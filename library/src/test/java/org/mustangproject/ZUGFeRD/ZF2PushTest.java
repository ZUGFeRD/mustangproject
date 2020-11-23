
/**
 * *********************************************************************
 * <p>
 * Copyright 2019 Jochen Staerk
 * <p>
 * Use is subject to license terms.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * <p>
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p>
 * **********************************************************************
 */
package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.mustangproject.*;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import junit.framework.TestCase;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ZF2PushTest extends TestCase {
	final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20201121_508.pdf";
	final String TARGET_ALLOWANCESPDF = "./target/testout-ZF2PushAllowances.pdf";
	final String TARGET_CORRECTIONPDF = "./target/testout-ZF2PushCorrection.pdf";
	final String TARGET_ITEMCHARGESALLOWANCESPDF = "./target/testout-ZF2PushItemChargesAllowances.pdf";
	final String TARGET_CHARGESALLOWANCESPDF = "./target/testout-ZF2PushChargesAllowances.pdf";
	final String TARGET_RELATIVECHARGESALLOWANCESPDF = "./target/testout-ZF2PushRelativeChargesAllowances.pdf";
	final String TARGET_ATTACHMENTSPDF = "./target/testout-ZF2PushAttachments.pdf";
	final String TARGET_PUSHEDGE = "./target/testout-ZF2PushEdge.pdf";

	public void testPushExport() {

		// the writing part

		String orgname = "Bei Spiel GmbH";
		String number = "RE-20201121/508";
		String priceStr = "160.00";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		BigDecimal price = new BigDecimal(priceStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20201121_508blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {


			ze.setTransaction(new Invoice().setDueDate(sdf.parse("2020-12-12")).setIssueDate(sdf.parse("2020-11-21")).setDeliveryDate(sdf.parse("2020-11-10"))
					.setSender(new TradeParty(orgname, "Ecke 12", "12345", "Stadthausen", "DE").addBankDetails(new BankDetails("DE88200800000970375700", "COBADEFFXXX").setAccountName("Max Mustermann")).addVATID("DE136695976"))
					.setRecipient(new TradeParty("Theodor Est", "Bahnstr. 42", "88802", "Spielkreis", "DE")
							.setContact(new Contact("Ingmar N. Fo", "(555) 23 78-23", "info@localhost.local")).setID("2"))
					.setNumber(number)
					.setReferenceNumber("AB321")
					.addItem(new Item(new Product("Design (hours)", "Of a sample invoice", "HUR", new BigDecimal(7)), price, new BigDecimal(1.0)))
					.addItem(new Item(new Product("Ballons", "various colors, ~2000ml", "H87", new BigDecimal(19)), new BigDecimal("0.79"), new BigDecimal(400.0)))
					.addItem(new Item(new Product("Hot air „heiße Luft“ (litres)", "", "LTR", new BigDecimal(19)), new BigDecimal("0.025"), new BigDecimal(800.0)))
			);

			ze.export(TARGET_PDF);
		} catch (IOException | ParseException e) {
			fail("Exception should not be raised in testPushExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);
		assertTrue(zi.getUTF8().contains("DE88200800000970375700")); //the iban
		assertTrue(zi.getUTF8().contains("Max Mustermann")); //account holder

		assertTrue(zi.getUTF8().contains("<rsm:CrossIndustryInvoice"));

		assertTrue(zi.getUTF8().contains("EUR")); //default invoice currency
		assertTrue(zi.getUTF8().contains("AB321"));

		// Reading ZUGFeRD
		assertEquals("571.04", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void testAttachmentsExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		String taxID = "9990815";
		BigDecimal price = new BigDecimal(priceStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			byte[] b = {12, 13};
			ze.attachFile("one.pdf", b, "Application/PDF", "Alternative");
			ze.attachFile("two.pdf", b, "Application/PDF", "Alternative");
			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID(taxID)).setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE4711").setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE"))).setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)))

			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_ATTACHMENTSPDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_ATTACHMENTSPDF);

		assertTrue(zi.getUTF8().contains("EUR"));
		assertTrue(zi.getUTF8().contains(taxID));

		// Reading ZUGFeRD
		assertEquals("1.19", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}


	}

	public void testItemChargesAllowancesExport() {

		String orgname = "Test company";
		String number = "123";
		String amountStr = "3.00";
		BigDecimal amount = new BigDecimal(amountStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("extended").ignorePDFAErrors()
					 .load(SOURCE_PDF)) {
			//	ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
			//					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50)))));


			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setContact(new Contact("contact testname", "123456", "contact.testemail@example.org").setFax("0911623562"))).setNumber(number)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance(new BigDecimal("0.1"))))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50))))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(2.0)).addCharge(new Charge(new BigDecimal(1))))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addCharge(new Charge(new BigDecimal(1))).addAllowance(new Allowance(new BigDecimal("1"))))

			);

			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_ITEMCHARGESALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_ITEMCHARGESALLOWANCESPDF);

		assertTrue(zi.getUTF8().contains("EUR"));
		assertTrue(zi.getUTF8().contains("0911623562")); // fax number

		// Reading ZUGFeRD
		assertEquals("18.33", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}


	}

	public void testChargesAllowancesExport() {

		String orgname = "Test company";
		String number = "123";
		String amountStr = "3.00";
		BigDecimal amount = new BigDecimal(amountStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("en16931")).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			ze.setTransaction(new Invoice().setCurrency("CHF").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))
					.addCharge(new Charge(new BigDecimal(0.5)).setTaxPercent(new BigDecimal(19)))
					.addAllowance(new Allowance(new BigDecimal(0.2)).setTaxPercent(new BigDecimal(19)))

			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_CHARGESALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_CHARGESALLOWANCESPDF);

		assertFalse(zi.getUTF8().contains("EUR"));

		// Reading ZUGFeRD
		assertEquals("11.07", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}


	}

	/***
	 * test the edge cases of the invoice class
	 */
	public void testPushEdge() {
		String occurrenceFrom = "20201001";
		String occurrenceTo = "20201005";
		String contractID = "376zreurzu0983";

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		String taxID = "9990815";
		BigDecimal price = new BigDecimal(priceStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try {
				ze.setTransaction(new Invoice().setCurrency("CHF").addNote("document level 1/2").addNote("document level 2/2").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
						.setDetailedDeliveryPeriod(new SimpleDateFormat("yyyyMMdd").parse(occurrenceFrom), new SimpleDateFormat("yyyyMMdd").parse(occurrenceTo))
						.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID(taxID).setID("0009845"))
						.setDeliveryAddress(new TradeParty("just the other side of the street", "teststr.12a", "55232", "Entenhausen", "DE").addVATID("DE47110"))
						.setContractReferencedDocument(contractID)
						.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setID("0008734").addVATID("DE4711").setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE").setFax("++49555123456")).setAdditionalAddress("Hinterhaus 3"))
						.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(16)), price, new BigDecimal(1.0)).addNote("item level 1/1").addAllowance(new Allowance(new BigDecimal(0.02)).setReason("item discount").setTaxPercent(new BigDecimal(16))).setDetailedDeliveryPeriod(sdf.parse("2020-01-13"), sdf.parse("2020-01-15")))
						.addCharge(new Charge(new BigDecimal(0.5)).setReason("quick delivery charge").setTaxPercent(new BigDecimal(16)))
						.addAllowance(new Allowance(new BigDecimal(0.2)).setReason("discount").setTaxPercent(new BigDecimal(16)))
						.setDeliveryDate(sdf.parse("2020-11-02")).setOwnVATID("DE0815").setNumber(number)
				);
			} catch (ParseException e) {
				e.printStackTrace();
			}

			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_PUSHEDGE);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PUSHEDGE);

		assertTrue(zi.getUTF8().contains("Hinterhaus"));
		assertTrue(zi.getUTF8().contains("0009845"));
		assertTrue(zi.getUTF8().contains("0008734"));
		assertTrue(zi.getUTF8().contains(occurrenceFrom));
		assertTrue(zi.getUTF8().contains(occurrenceTo));
		assertTrue(zi.getUTF8().contains(contractID));

		assertTrue(zi.getUTF8().contains("20200113")); // to contain item delivery periods
		assertTrue(zi.getUTF8().contains("20200115")); // to contain item delivery periods

		assertTrue(zi.getUTF8().contains("item level 1/1"));
		assertTrue(zi.getUTF8().contains("DE4711")); // the VAT ID should be there...
		assertFalse(zi.getUTF8().contains("DE47110")); // but not the VAT ID of the shiptotradeparty
		assertTrue(zi.getUTF8().contains("document level 2/2"));
		assertFalse(zi.getUTF8().contains("++49555123456")); // in profile EN16931 contact fax number is not allowed

	}

	public void testAllowancesExport() {

		String orgname = "Test company";
		String number = "123";
		BigDecimal qty = new BigDecimal("20");
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("en16931")).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal(500.0), qty).addAllowance(new Allowance(new BigDecimal(300)).setTaxPercent(new BigDecimal(19))))
					.addAllowance(new Allowance(new BigDecimal(600)).setTaxPercent(new BigDecimal(19)))

			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_ALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_ALLOWANCESPDF);

		assertTrue(zi.getUTF8().contains("EUR"));

		// Reading ZUGFeRD
		assertEquals("4046.00", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}


	}

	public void testRelativeChargesAllowancesExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "3.00";
		BigDecimal price = new BigDecimal(priceStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("extended")).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			ze.setTransaction(new Invoice().setCurrency("CHF").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)).addCharge(new Charge().setPercent(new BigDecimal(50)).setTaxPercent(new BigDecimal(19))))
					.addAllowance(new Allowance().setPercent(new BigDecimal(50)).setTaxPercent(new BigDecimal(19)))

			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_RELATIVECHARGESALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_RELATIVECHARGESALLOWANCESPDF);

		assertFalse(zi.getUTF8().contains("EUR"));

		// Reading ZUGFeRD
		assertEquals("6.25", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}


	}


	public void testCorrectionExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		BigDecimal price = new BigDecimal(priceStr);
		BigDecimal qty = new BigDecimal(-1.0);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {
			// no due date, since we are not expecting money
			Invoice i = new Invoice().setIssueDate(new Date()).setDetailedDeliveryPeriod(new Date(), new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815")).setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0815")).setNumber(number)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty)).setCorrection("0815");
			ze.setTransaction(i);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_CORRECTIONPDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_CORRECTIONPDF);

		assertTrue(zi.getUTF8().contains("EUR"));
//totest: typecode 384, BuyerOrderReferencedDocument
		// Reading ZUGFeRD
		assertEquals("-3.57", zi.getAmount());
		assertEquals(zi.getHolder(), orgname);
		assertEquals(zi.getForeignReference(), number);
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}


	}


}
