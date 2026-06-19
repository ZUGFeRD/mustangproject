package org.mustangproject.ZUGFeRD;

import org.junit.Test;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class ItemSellerTradePartyTest {

    /**
     * Item de test qui force un ItemSellerTradeParty au niveau ligne
     * via la nouvelle méthode IZUGFeRDExportableItem#getItemSellerTradeParty().
     */
    private static class ItemWithItemSellerTradeParty extends Item {
        private final TradeParty itemSeller;

        ItemWithItemSellerTradeParty(Product product, BigDecimal price, BigDecimal quantity, TradeParty itemSeller) {
            super(product, price, quantity);
            this.itemSeller = itemSeller;
        }

        @Override
        public TradeParty getLineSeller() {
            return itemSeller;
        }
    }

    @Test
    public void testLineLevelItemSellerTradePartyIsExportedOnlyWhenProvided() {
        // Header seller = vendeur contractuel (collectivité émettrice)
        TradeParty contractualSeller = new TradeParty("Mairie A", "1 rue A", "75001", "Paris", "FR");
        // Line-level "actual service provider" (autre collectivité)
        TradeParty actualServiceProvider = new TradeParty("Mairie B", "2 rue B", "69001", "Lyon", "FR");
        // Buyer
        TradeParty buyer = new TradeParty("Client X", "3 rue C", "33000", "Bordeaux", "FR");

        Product service = new Product("Prestation", "Service intercommunal", "C62", new BigDecimal("20.00"));

        // Ligne 1 : avec ItemSellerTradeParty
        Item line1 = new ItemWithItemSellerTradeParty(
                service,
                new BigDecimal("100.00"),
                new BigDecimal("1"),
                actualServiceProvider
        );

        // Ligne 2 : sans ItemSellerTradeParty (null via default getter)
        Item line2 = new Item(
                service,
                new BigDecimal("50.00"),
                new BigDecimal("1")
        );

        Invoice inv = new Invoice()
                .setNumber("INV-ITEM-SELLER-001")
                .setIssueDate(new Date())
                .setDeliveryDate(new Date())
                .setDueDate(new Date())
                .setSender(contractualSeller)
                .setRecipient(buyer)
                .setCurrency("EUR")
                .addItem(line1)
                .addItem(line2);

        ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
        provider.setProfile(Profiles.getByName("EXTENDED"));
        provider.generateXML(inv);

        String xml = new String(provider.getXML(), StandardCharsets.UTF_8);

        // 1) Le Seller header doit rester "Mairie A"
        assertThat(xml)
                .valueByXPath("//*[local-name()='ApplicableHeaderTradeAgreement']" +
                        "/*[local-name()='SellerTradeParty']" +
                        "/*[local-name()='Name']")
                .isEqualTo("Mairie A");

        // 2) Ligne 1 : ItemSellerTradeParty présent, et correspond à "Mairie B"
        assertThat(xml)
                .nodesByXPath("(//*[local-name()='IncludedSupplyChainTradeLineItem'])[1]" +
                        "//*[local-name()='SpecifiedLineTradeAgreement']" +
                        "/*[local-name()='ItemSellerTradeParty']")
                .exist();

        assertThat(xml)
                .valueByXPath("(//*[local-name()='IncludedSupplyChainTradeLineItem'])[1]" +
                        "//*[local-name()='ItemSellerTradeParty']" +
                        "/*[local-name()='Name']")
                .isEqualTo("Mairie B");

         // 3) Ligne 2 : ItemSellerTradeParty absent
        assertThat(xml)
                .nodesByXPath("(//*[local-name()='IncludedSupplyChainTradeLineItem'])[2]" +
                        "//*[local-name()='SpecifiedLineTradeAgreement']" +
                        "/*[local-name()='ItemSellerTradeParty']").isEmpty();
     
    }
}
