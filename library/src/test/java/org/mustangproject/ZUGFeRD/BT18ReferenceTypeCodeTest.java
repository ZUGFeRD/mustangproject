package org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.TradeParty;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class BT18ReferenceTypeCodeTest extends TestCase {

    /**
     * Ensures BT-18-1 (scheme identifier) is serialized as ram:ReferenceTypeCode
     * inside ram:AdditionalReferencedDocument (TypeCode=130).
     */
    public void testBT18ReferenceTypeCodeIsWrittenWhenSet() {
        // Minimal invoice (XRechnung profile => CII output)
        Invoice i = new Invoice()
                .setIssueDate(new Date())
                .setDueDate(new Date())
                .setDeliveryDate(new Date())
                .setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE"))
                .setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
                .setNumber("INV-123")
                .addItem(new Item(
                        new Product("Testprodukt", "", "C62", BigDecimal.ZERO),
                        new BigDecimal("1.00"),
                        BigDecimal.ONE
                ));

        // BT-18: Invoiced Object Identifier (AdditionalReferencedDocument / TypeCode 130)
        ReferencedDocument rd = new ReferencedDocument("ID unique");
        rd.setReferenceTypeCode("AJW"); // BT-18-1
        i.setObjectIdentifierReferencedDocument(rd);

        ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
        zf2p.setProfile(Profiles.getByName("XRechnung"));
        zf2p.generateXML(i);

        String xml = new String(zf2p.getXML(), StandardCharsets.UTF_8);

        // Assert: we still have a CII invoice
        assertTrue(xml.contains("<rsm:CrossIndustryInvoice"));

        // Assert: BT-18 block contains ID, TypeCode=130 and ReferenceTypeCode=AJW
        assertThat(xml)
                .valueByXPath("string(//*[local-name()='AdditionalReferencedDocument']/*[local-name()='TypeCode'])")
                .isEqualTo("130");

        assertThat(xml)
                .valueByXPath("string(//*[local-name()='AdditionalReferencedDocument']/*[local-name()='IssuerAssignedID'])")
                .isEqualTo("ID unique");

        assertThat(xml)
                .valueByXPath("string(//*[local-name()='AdditionalReferencedDocument']/*[local-name()='ReferenceTypeCode'])")
                .isEqualTo("AJW");
    }
}