package org.mustangproject;

import org.junit.jupiter.api.Test;
import org.mustangproject.ZUGFeRD.Profiles;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for BT-23 (BusinessProcessSpecifiedDocumentContextParameter/ID) emission in CII output.
 *
 * Assumptions / prerequisites for the proposed fix:
 *  - IExportableTransaction#getBusinessProcessId() exists (as a default method returning null)
 *  - Invoice#setBusinessProcessId(String) exists and Invoice overrides getBusinessProcessId()
 *  - ZUGFeRD2PullProvider writes BT-23 if a custom businessProcessId is provided,
 *    otherwise keeps the current XRechnung default behavior.
 */
public class BusinessProcessIdCiiTest {

    @Test
    void xrechnung_nonRegression_defaultBusinessProcessId_isStillEmitted() throws Exception {
        // ===== GIVEN: A minimal invoice (as provided) WITHOUT setting businessProcessId =====

        TradeParty buyer = new TradeParty("Client X", "3 rue C", "33000", "Bordeaux", "FR");
        TradeParty seller = new TradeParty("Mairie A", "1 rue A", "75001", "Paris", "FR");

        Invoice invoice = new Invoice()
                .setNumber("INV-CALC-001")   // BT-1: Invoice number -> /.../ExchangedDocument/ram:ID
                .setIssueDate(new Date())    // BT-2: Issue date
                .setDeliveryDate(new Date()) // Delivery date (depending on profile/exporter mapping)
                .setDueDate(new Date())      // BT-9: Payment due date
                .setCurrency("EUR")          // BT-5: Invoice currency code
                .setSender(buyer)
                .setRecipient(seller);

        Product service = new Product("Prestation", "Service intercommunal", "C62", new BigDecimal("20.00"));
        invoice.addItem(new Item(service, BigDecimal.ONE, BigDecimal.TEN).setTax(BigDecimal.valueOf(20)));

        // ===== WHEN: Generating CII XML using the XRechnung profile =====

        ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
        provider.setProfile(Profiles.getByName("XRechnung"));
        provider.generateXML(invoice);

        String xml = new String(provider.getXML(), StandardCharsets.UTF_8);

        // ===== THEN: Non-regression check =====
        // XRechnung currently emits BT-23 with a default fixed URN.
        // This behavior must remain unchanged when businessProcessId is NOT explicitly provided by the user.

        assertTrue(
                xml.contains("<ram:BusinessProcessSpecifiedDocumentContextParameter>"),
                "XRechnung should still emit BusinessProcessSpecifiedDocumentContextParameter (BT-23)."
        );

        assertTrue(
                xml.contains("<ram:ID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</ram:ID>"),
                "XRechnung default BT-23 URN must remain unchanged when businessProcessId is not set."
        );
    }

    @Test
    void whenBusinessProcessIdIsSet_itIsEmitted_inExtendedProfile() throws Exception {
        // ===== GIVEN: The same minimal invoice, but WITH an explicit businessProcessId =====

        TradeParty buyer = new TradeParty("Client X", "3 rue C", "33000", "Bordeaux", "FR");
        TradeParty seller = new TradeParty("Mairie A", "1 rue A", "75001", "Paris", "FR");

        Invoice invoice = new Invoice()
                .setNumber("INV-CALC-001")
                .setIssueDate(new Date())
                .setDeliveryDate(new Date())
                .setDueDate(new Date())
                .setCurrency("EUR")
                .setSender(buyer)
                .setRecipient(seller);

        Product service = new Product("Prestation", "Service intercommunal", "C62", new BigDecimal("20.00"));
        invoice.addItem(new Item(service, BigDecimal.ONE, BigDecimal.TEN).setTax(BigDecimal.valueOf(20)));

        // Proposed new API: user-provided BT-23 value
        invoice.setBusinessProcessId("B1");
        // BT-23 path:
        // /rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/
        //   ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID

        // ===== WHEN: Generating CII XML using the EXTENDED profile =====

        ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
        provider.setProfile(Profiles.getByName("EXTENDED"));
        provider.generateXML(invoice);

        String xml = new String(provider.getXML(), StandardCharsets.UTF_8);

        // ===== THEN: BT-23 must be emitted with the user-provided value =====

        assertTrue(
                xml.contains("<ram:BusinessProcessSpecifiedDocumentContextParameter>"),
                "When businessProcessId is set, BT-23 must be emitted even for EXTENDED."
        );

        assertTrue(
                xml.contains("<ram:ID>B1</ram:ID>"),
                "BT-23 must contain the user-provided businessProcessId."
        );

        // Extra sanity check: the guideline/specification identifier (BT-24) should still be present
        assertTrue(
                xml.contains("<ram:GuidelineSpecifiedDocumentContextParameter>"),
                "BT-24 (GuidelineSpecifiedDocumentContextParameter) must be present."
        );
    }
}
