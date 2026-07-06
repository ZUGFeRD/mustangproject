package org.mustangproject.ZUGFeRD;

import org.junit.jupiter.api.Test;
import org.mustangproject.*;

import java.io.File;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

public class SubInvoiceLineExportTest {

	private static final String TARGET_PDF = "./target/testout-SubInvoiceLines.pdf";

	@Test
	public void testSubInvoiceLineExportRoundTrip() throws Exception {

		// -- Build invoice with hierarchical positions --
		TradeParty sender = new TradeParty("Test Seller", "Test Street 1", "12345", "Test City", "DE")
			.addTaxID("DE123456789")
			.addVATID("DE123456789");
		Contact senderContact = new Contact("Max Mustermann", "012345", "max@test.de");
		sender.setContact(senderContact);

		TradeParty recipient = new TradeParty("Test Buyer", "Buyer Street 1", "54321", "Buyer City", "DE")
			.addVATID("DE987654321");

		// DETAIL line 0101: child of group 01
		Item detail0101 = new Item(
			new Product("Laser printer", "", "H87", new BigDecimal("19")),
			new BigDecimal("300.00"),
			new BigDecimal("2.0000")
		);
		detail0101.setId("0101");
		detail0101.setParentLineID("01");
		detail0101.setLineStatusReasonCode("DETAIL");

		// DETAIL line 0102: child of group 01
		Item detail0102 = new Item(
			new Product("Ink printer", "", "H87", new BigDecimal("19")),
			new BigDecimal("150.00"),
			new BigDecimal("3.0000")
		);
		detail0102.setId("0102");
		detail0102.setParentLineID("01");
		detail0102.setLineStatusReasonCode("DETAIL");

		// INFORMATION line 0103: child of group 01, non-calculation-relevant
		Item info0103 = new Item(
			new Product("Setup instructions", "", "H87", new BigDecimal("19")),
			new BigDecimal("0.00"),
			new BigDecimal("1.0000")
		);
		info0103.setId("0103");
		info0103.setParentLineID("01");
		info0103.setLineStatusReasonCode("INFORMATION");

		// GROUP line 01: parent, LineTotalAmount = sum of DETAIL children = 1050
		Item group01 = new Item(
			new Product("Hardware bundle", "", "H87", new BigDecimal("19")),
			new BigDecimal("1050.00"),
			new BigDecimal("1.0000")
		);
		group01.setId("01");
		group01.setLineStatusReasonCode("GROUP");

		Invoice invoice = new Invoice()
			.setNumber("SUB-INV-001")
			.setIssueDate(new Date())
			.setDeliveryDate(new Date())
			.setDueDate(new Date())
			.setSender(sender)
			.setRecipient(recipient)
			.setCurrency("EUR")
			.setPaymentTermDescription("Net 30")
			.addItem(detail0101)
			.addItem(detail0102)
			.addItem(info0103)
			.addItem(group01);

		// -- Export to PDF with EXTENDED profile --
		try (InputStream sourcePDF = this.getClass()
			.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf");
			 ZUGFeRDExporterFromA3 exporter = new ZUGFeRDExporterFromA3()
				 .setProducer("Mustang SubInvoiceLine Test")
				 .setCreator("Test")
				 .setZUGFeRDVersion(2)
				 .setProfile("EXTENDED")
				 .load(sourcePDF)) {

			exporter.setTransaction(invoice);

			// Verify XML contains the hierarchical elements
			String xml = new String(exporter.getProvider().getXML(), StandardCharsets.UTF_8);
			assertTrue(xml.contains("<ram:ParentLineID>01</ram:ParentLineID>"),
				"XML must contain ParentLineID element");
			assertTrue(xml.contains("<ram:LineStatusReasonCode>DETAIL</ram:LineStatusReasonCode>"),
				"XML must contain DETAIL LineStatusReasonCode");
			assertTrue(xml.contains("<ram:LineStatusReasonCode>GROUP</ram:LineStatusReasonCode>"),
				"XML must contain GROUP LineStatusReasonCode");
			assertTrue(xml.contains("<ram:LineStatusReasonCode>INFORMATION</ram:LineStatusReasonCode>"),
				"XML must contain INFORMATION LineStatusReasonCode");

			exporter.export(TARGET_PDF);
		}

		// -- Re-import and verify round-trip --
		ZUGFeRDImporter importer = new ZUGFeRDImporter(TARGET_PDF);
		Invoice reimported = new Invoice();
		importer.extractInto(reimported);

		// Find items by ID
		Item rDetail0101 = findItemById(reimported, "0101");
		assertNotNull(rDetail0101, "DETAIL item 0101 must be reimported");
		assertEquals("01", rDetail0101.getParentLineID());
		assertEquals("DETAIL", rDetail0101.getLineStatusReasonCode());
		assertTrue(rDetail0101.isCalculationRelevant());

		Item rDetail0102 = findItemById(reimported, "0102");
		assertNotNull(rDetail0102, "DETAIL item 0102 must be reimported");
		assertEquals("01", rDetail0102.getParentLineID());
		assertEquals("DETAIL", rDetail0102.getLineStatusReasonCode());
		assertTrue(rDetail0102.isCalculationRelevant());

		Item rInfo0103 = findItemById(reimported, "0103");
		assertNotNull(rInfo0103, "INFORMATION item 0103 must be reimported");
		assertEquals("01", rInfo0103.getParentLineID());
		assertEquals("INFORMATION", rInfo0103.getLineStatusReasonCode());
		assertFalse(rInfo0103.isCalculationRelevant());

		Item rGroup01 = findItemById(reimported, "01");
		assertNotNull(rGroup01, "GROUP item 01 must be reimported");
		assertNull(rGroup01.getParentLineID());
		assertEquals("GROUP", rGroup01.getLineStatusReasonCode());
		assertFalse(rGroup01.isCalculationRelevant());

		// Verify only DETAIL lines contribute to totals
		// DETAIL: 0101=600, 0102=450 = 1050
		TransactionCalculator tc = new TransactionCalculator(reimported);
		assertEquals(new BigDecimal("1050.00"), tc.getTotal().setScale(2));
	}

	private Item findItemById(Invoice invoice, String id) {
		for (IZUGFeRDExportableItem item : invoice.getZFItems()) {
			if (item instanceof Item && id.equals(((Item) item).getId())) {
				return (Item) item;
			}
		}
		return null;
	}
}
