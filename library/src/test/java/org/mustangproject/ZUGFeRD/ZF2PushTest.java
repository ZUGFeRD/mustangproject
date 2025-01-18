
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

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.mustangproject.*;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import junit.framework.TestCase;

import org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants;
import org.mustangproject.ZUGFeRD.model.EventTimeCodeTypeConstants;

import javax.xml.xpath.XPathExpressionException;

import static org.xmlunit.assertj.XmlAssert.assertThat;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ZF2PushTest extends TestCase {
	final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20201121_508.pdf";
	final String TARGET_ALLOWANCESPDF = "./target/testout-ZF2PushAllowances.pdf";
	final String TARGET_CREDITNOTEPDF = "./target/testout-ZF2PushCreditNote.pdf";
	final String TARGET_CORRECTIONPDF = "./target/testout-ZF2PushCorrection.pdf";
	final String TARGET_ITEMCHARGESALLOWANCESPDF = "./target/testout-ZF2PushItemChargesAllowances.pdf";
	final String TARGET_CHARGESALLOWANCESPDF = "./target/testout-ZF2PushChargesAllowances.pdf";
	final String TARGET_RELATIVECHARGESALLOWANCESPDF = "./target/testout-ZF2PushRelativeChargesAllowances.pdf";
	final String TARGET_ATTACHMENTSPDF = "./target/testout-ZF2PushAttachments.pdf";
	final String TARGET_BANKPDF = "./target/testout-ZF2PushBank.pdf";
	final String TARGET_PUSHEDGE = "./target/testout-ZF2PushEdge.pdf";
	final String TARGET_INTRACOMMUNITYSUPPLYMANUALPDF = "./target/testout-ZF2PushIntraCommunitySupplyManual.pdf";
	final String TARGET_INTRACOMMUNITYSUPPLYPDF = "./target/testout-ZF2PushIntraCommunitySupply.pdf";
	final String TARGET_REVERSECHARGEPDF = "./target/testout-ZF2PushReverseCharge.pdf";

	public void testPushExport() {
		/***
		 * This writes to a filename like an official sample, please consider when changing (probably better not?)
		 */
		// the writing part
		String orgname = "Bei Spiel GmbH";
		String number = "RE-20201121/508";
		String priceStr = "160.00";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20201121_508blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors();
			ze.load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2);
			ze.setTransaction(new Invoice().setDueDate(sdf.parse("2020-12-12")).setIssueDate(sdf.parse("2020-11-21")).setDeliveryDate(sdf.parse("2020-11-10"))
				.setSender(new TradeParty(orgname, "Ecke 12", "12345", "Stadthausen", "DE").addBankDetails(new BankDetails("DE88200800000970375700", "COBADEFFXXX").setAccountName("Max Mustermann")).addVATID("DE136695976"))
				.setRecipient(new TradeParty("Theodor Est", "Bahnstr. 42", "88802", "Spielkreis", "DE")
					.setContact(new Contact("Ingmar N. Fo", "(555) 23 78-23", "info@localhost.local")).setID("2"))
				.setNumber(number)
				.setReferenceNumber("AB321")
				.addItem(new Item(new Product("Design (hours)", "Of a sample invoice", "HUR", new BigDecimal(7)), price, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Ballons", "various colors, ~2000ml", "H87", new BigDecimal(19)), new BigDecimal("0.79"), new BigDecimal(400.0)))
				.addItem(new Item(new Product("Hot air „heiße Luft“ (litres)", "", "LTR", new BigDecimal(19)), new BigDecimal("0.025"), new BigDecimal(800.0)))
				.setRoundingAmount(new BigDecimal("1"))
			);

			ze.export(TARGET_PDF);
		} catch (IOException | ParseException e) {
			fail("Exception should not be raised");
		}

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_PDF);
		Invoice i = new Invoice();
		try {
			zii.extractInto(i);
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}


		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);
		assertTrue(zi.getUTF8().contains("DE88200800000970375700")); //the iban
		assertTrue(zi.getUTF8().contains("Max Mustermann")); //account holder
		assertTrue(zi.getUTF8().contains("DueDateDateTime")); //account holder
		assertTrue(zi.getUTF8().contains("20201212")); //account holder

		assertTrue(zi.getUTF8().contains("<rsm:CrossIndustryInvoice"));

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertTrue(zi.getUTF8().contains("AB321"));

		// Reading ZUGFeRD
		assertEquals("571.04", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
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

		String senderDescription = "Kleinunternehmer";
		String taxID = "9990815";
		String theNote="oh lala";
		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors();
			ze.load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2);

			byte[] b = {12, 13};
			ze.attachFile("one.pdf", b, "application/pdf", "Alternative");
			ze.attachFile("two.pdf", b, "application/pdf", "Alternative");
			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID(taxID).addVATID("DE0815").setDescription(senderDescription))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE4711")
					.setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE")))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(0)).setTaxExemptionReason("Kleinunternehmer gemäß §19 UStG").setTaxCategoryCode("E"), price, new BigDecimal(1.0)).addNote(theNote))
			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_ATTACHMENTSPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_ATTACHMENTSPDF);
		Invoice i = null;
		try {
			i = zii.extractInvoice();
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}

		assertEquals(i.getZFItems()[0].getNotesWithSubjectCode().get(0).getContent(),theNote);
		assertEquals(senderDescription, i.getSender().getDescription());

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_ATTACHMENTSPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertTrue(zi.getUTF8().contains(taxID));

		// Reading ZUGFeRD
		assertEquals("1.00", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void testBankTransferExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		String taxID = "9990815";
		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2);

			String IBAN = "DE999888777";
			String BIC = "COBADEFXXX";
			BankDetails bd = new BankDetails(IBAN, BIC);
			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addBankDetails(bd).addTaxID(taxID).addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE4711")
					.setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE")))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)))
			);
			String theXML = new String(ze.getProvider().getXML());
			Invoice read = new Invoice();
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new ByteArrayInputStream(theXML.getBytes(StandardCharsets.UTF_8)));
			zii.extractInto(read);
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));

			assertEquals(IBAN, read.getSender().getBankDetails().get(0).getIBAN());
			ze.export(TARGET_BANKPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		} catch (XPathExpressionException e) {
			fail("XPathException should not be raised");
		} catch (ParseException e) {
			fail("ParseException should not be raised");
		}
	}

	public void testItemChargesAllowancesExport() {

		String orgname = "Test company";
		String number = "123";
		String amountStr = "3.00";
		BigDecimal amount = new BigDecimal(amountStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProfile(Profiles.getByName("Extended"));

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("extended");
			//	ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
			//					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50)))));

			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")
					.setContact(new Contact("contact testname", "123456", "contact.testemail@example.org").setFax("0911623562")))
				.setNumber(number)
				.addCharge(new Charge(new BigDecimal(1)).setReasonCode("ABK").setReason("AReason").setTaxPercent(new BigDecimal(19)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance(new BigDecimal("0.1"))))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50))))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(2.0)).addCharge(new Charge(new BigDecimal(1)).setReasonCode("ABK").setReason("AnotherReason")))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addCharge(new Charge(new BigDecimal(1))).addAllowance(new Allowance(new BigDecimal("1"))))
			);

			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_ITEMCHARGESALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_ITEMCHARGESALLOWANCESPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertTrue(zi.getUTF8().contains("0911623562")); // fax number
		assertTrue(zi.getUTF8().contains("ABK"));

		// Reading ZUGFeRD
		assertEquals("19.52", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	/***
	 * you can activate intra community suppliy on item level
	 */
	public void testIntraCommunitySupplyItemExport() {

		String orgname = "Test company";
		String number = "123";
		String amountStr = "3.00";
		BigDecimal amount = new BigDecimal(amountStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("extended");
			//	ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
			//					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50)))));

			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addVATID("DE0815").addTaxID("4711"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0816")
					.setContact(new Contact("contact testname", "123456", "contact.testemail@example.org").setFax("0911623562")))
				.setDeliveryAddress(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0816"))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setIntraCommunitySupply(), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setIntraCommunitySupply(), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setIntraCommunitySupply(), amount, new BigDecimal(2.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setIntraCommunitySupply(), amount, new BigDecimal(1.0)))
			);

			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_INTRACOMMUNITYSUPPLYPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_INTRACOMMUNITYSUPPLYPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertTrue(zi.getUTF8().contains("0911623562")); // fax number

		// Reading ZUGFeRD
		assertEquals("15.00", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * or manually, in which case the transaction needs a delivery address outside DE, and the items a 0 tax with reason K and reason code
	 */

	public void testIntraCommunitySupplyManualExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";

		String taxID = "9990815";
		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors();
			ze.load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2);

			ze.setTransaction(new Invoice().setDeliveryAddress(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "FR")).setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID(taxID).addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "FR").addVATID("DE4711")

					.setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE")))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(0)).setTaxExemptionReason("Kein Ausweis der Umsatzsteuer bei innergemeinschaftlichen Lieferungen").setTaxCategoryCode("K"), price, new BigDecimal(1.0)))
			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_INTRACOMMUNITYSUPPLYMANUALPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_INTRACOMMUNITYSUPPLYMANUALPDF);
		Invoice i = null;
		try {
			i = zii.extractInvoice();
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_INTRACOMMUNITYSUPPLYMANUALPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertTrue(zi.getUTF8().contains(taxID));

		// Reading ZUGFeRD
		assertEquals("1.00", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	public void testReverseChargeExport() {

		String orgname = "Test company";
		String number = "123";
		String amountStr = "3.00";
		BigDecimal amount = new BigDecimal(amountStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("extended");

			//	ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
			//					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50)))));

			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addVATID("DE0815").addTaxID("4711"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0816")
					.setContact(new Contact("contact testname", "123456", "contact.testemail@example.org").setFax("0911623562")))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setReverseCharge(), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setReverseCharge(), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setReverseCharge(), amount, new BigDecimal(2.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)).setReverseCharge(), amount, new BigDecimal(1.0)))
			);

			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_REVERSECHARGEPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_REVERSECHARGEPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertTrue(zi.getUTF8().contains("0911623562")); // fax number

		// Reading ZUGFeRD
		assertEquals("15.00", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
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
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("en16931"));

			ze.setTransaction(new Invoice().setCurrency("CHF").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))
				.addCharge(new Charge(new BigDecimal(0.5)).setTaxPercent(new BigDecimal(19)).setReasonCode("ABK"))
				.addAllowance(new Allowance(new BigDecimal(0.2)).setTaxPercent(new BigDecimal(19)).setReasonCode("ABK"))
			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_CHARGESALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_CHARGESALLOWANCESPDF);

		assertEquals("CHF", zi.getInvoiceCurrencyCode());

		// Reading ZUGFeRD
		assertEquals("11.07", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
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

		String orgID = "0009845";
		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		String taxID = "9990815";
		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("extended"));

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			try {
				SchemedID gtin = new SchemedID("0160", "2001015001325");
				SchemedID gln = new SchemedID("0088", "4304171000002");
				ze.setTransaction(new Invoice().setCurrency("CHF").addNote("document level 1/2").addNote("document level 2/2").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
					.setSellerOrderReferencedDocumentID("9384").setBuyerOrderReferencedDocumentID("28934")
					.setDetailedDeliveryPeriod(new SimpleDateFormat("yyyyMMdd").parse(occurrenceFrom), new SimpleDateFormat("yyyyMMdd").parse(occurrenceTo))
					.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID(taxID).setEmail("sender@test.org").setID(orgID).addVATID("DE0815"))
					.setDeliveryAddress(new TradeParty("just the other side of the street", "teststr.12a", "55232", "Entenhausen", "DE").addVATID("DE47110"))
					.setContractReferencedDocument(contractID)
					.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addGlobalID(gln).setEmail("recipient@test.org").addVATID("DE4711")
						.setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE").setFax("++49555123456")).setAdditionalAddress("Hinterhaus 3"))
					.addItem(new Item(new Product("Testprodukt", "", "H87", new BigDecimal(16)).addGlobalID(gtin).setSellerAssignedID("4711"), price, new BigDecimal(1.0)).setId("a123").addReferencedLineID("xxx").addNote("item level 1/1").addAllowance(new Allowance(new BigDecimal(0.02)).setReason("item discount").setTaxPercent(new BigDecimal(16))).setDetailedDeliveryPeriod(sdf.parse("2020-01-13"), sdf.parse("2020-01-15")))
					.addCharge(new Charge(new BigDecimal(0.5)).setReason("quick delivery charge").setTaxPercent(new BigDecimal(16)))
					.addAllowance(new Allowance(new BigDecimal(0.2)).setReason("discount").setTaxPercent(new BigDecimal(16)))
					.addCashDiscount(new CashDiscount(new BigDecimal(2), 14))
					.setDeliveryDate(sdf.parse("2020-11-02")).setNumber(number).setVATDueDateTypeCode(EventTimeCodeTypeConstants.PAYMENT_DATE)
					.setInvoiceReferencedDocumentID("abc123").addInvoiceReferencedDocument(new ReferencedDocument("abcd1234"))
				);
			} catch (ParseException e) {
				e.printStackTrace();
			}

			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_PUSHEDGE);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PUSHEDGE);

		assertFalse(zi.getUTF8().contains("<ram:IBANID>")); // maybe add a direct debit mandate to the class in the future then this would fail
		assertTrue(zi.getUTF8().contains("Hinterhaus"));
		assertThat(zi.getUTF8()).valueByXPath("//*[local-name()='BuyerTradeParty']/*[local-name()='GlobalID'][@schemeID=0088]").asString().isEqualTo("4304171000002");
		assertThat(zi.getUTF8()).valueByXPath("//*[local-name()='SpecifiedTradeProduct']/*[local-name()='GlobalID'][@schemeID=0160]").asString().isEqualTo("2001015001325");
		assertTrue(zi.getUTF8().contains("2001015001325"));
		assertTrue(zi.getUTF8().contains("4304171000002"));
		assertTrue(zi.getUTF8().contains("0088"));
		assertTrue(zi.getUTF8().contains(orgID));
		assertTrue(zi.getUTF8().contains("ram:BuyerOrderReferencedDocument"));
		assertTrue(zi.getUTF8().contains(occurrenceFrom));
		assertTrue(zi.getUTF8().contains(occurrenceTo));
		assertTrue(zi.getUTF8().contains(contractID));
		assertEquals(zi.importedInvoice.getZFItems()[0].getId(), "a123");
		assertTrue(zi.getUTF8().contains("20200113")); // to contain item delivery periods
		assertTrue(zi.getUTF8().contains("20200115")); // to contain item delivery periods

		assertTrue(zi.getUTF8().contains("item level 1/1"));
		assertTrue(zi.getUTF8().contains("DE4711")); // the VAT ID should be there...
		assertFalse(zi.getUTF8().contains("DE47110")); // but not the VAT ID of the shiptotradeparty
		assertTrue(zi.getUTF8().contains("document level 2/2"));
		assertTrue(zi.getUTF8().contains("++49555123456"));
		assertTrue(zi.getUTF8().contains("Cash Discount")); // default description for cash discounts
		assertThat(zi.getUTF8()).valueByXPath("//*[local-name()='ApplicableTradeTax']/*[local-name()='DueDateTypeCode']").asString().isEqualTo(EventTimeCodeTypeConstants.PAYMENT_DATE);

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_PUSHEDGE);
		try {
			Invoice i = zii.extractInvoice();

			assertEquals("abc123", i.getInvoiceReferencedDocumentID());
			assertEquals(1, i.getInvoiceReferencedDocuments().size());
			assertEquals("abcd1234", i.getInvoiceReferencedDocuments().get(0).getIssuerAssignedID());
			assertEquals("4304171000002", i.getRecipient().getGlobalID());
			assertEquals("2001015001325", i.getZFItems()[0].getProduct().getGlobalID());
			assertEquals(orgID, i.getSender().getID());

		} catch (XPathExpressionException e) {
			fail("XPathExpressionException should not be raised");
		} catch (ParseException e) {
			fail("ParseException should not be raised");
			/* a parseException would also be fired if the calculated grand total does not
			match the read grand total */
		}
	}

	public void testAllowancesExport() {

		String orgname = "Test company";
		String number = "123";
		BigDecimal qty = new BigDecimal("20");
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("en16931"));

			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal(500.0), qty).addAllowance(new Allowance(new BigDecimal(300)).setTaxPercent(new BigDecimal(19))))
				.addAllowance(new Allowance(new BigDecimal(600)).setTaxPercent(new BigDecimal(19)))
			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_ALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_ALLOWANCESPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());

		// Reading ZUGFeRD
		assertEquals("4046.00", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
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
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile(Profiles.getByName("extended"));

			ze.setTransaction(new Invoice().setCurrency("CHF").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, new BigDecimal(1.0)).addCharge(new Charge().setPercent(new BigDecimal(50)).setTaxPercent(new BigDecimal(19))))
				.addAllowance(new Allowance().setPercent(new BigDecimal(50)).setTaxPercent(new BigDecimal(19)))
			);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_RELATIVECHARGESALLOWANCESPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_RELATIVECHARGESALLOWANCESPDF);

		assertEquals("CHF", zi.getInvoiceCurrencyCode());
		assertEquals("6.25", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	/***
	 * German Stornorechnung/Rechnungskorrektur:
	 * quantities have to be negative!
	 * official example: zugferd_2p1_EXTENDED_Rechnungskorrektur.pdf
	 */
	public void testCorrectionExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		BigDecimal price = new BigDecimal(priceStr);
		BigDecimal qty = new BigDecimal(-1.0);
		try {
			InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2);
			// no due date, since we are not expecting money
			Invoice i = new Invoice().setIssueDate(new Date()).setDetailedDeliveryPeriod(new Date(), new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0815"))
				.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty)).setCorrection("0815");
			ze.setTransaction(i);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_CORRECTIONPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_CORRECTIONPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertEquals(zi.getDocumentCode(), DocumentCodeTypeConstants.CORRECTEDINVOICE);
		//totest: BuyerOrderReferencedDocument
		assertEquals("-3.57", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/***
	 * UNTDID 1001 says 381 as typecode for credit notes and
	 * the Factur-X 1.0.50 has examples like Avoir_FR_type381_EN16931.pdf
	 * along with a documentation in chapter 7.1.6 (where they also tackle
	 * negative TypeCode 380 invoices)
	 */
	public void testCreditNoteExport() {

		String orgname = "Test company";
		String number = "123";
		String despatchAdviceReferencedDocumentID = "DESADV-4711";
		String priceStr = "1.00";
		BigDecimal price = new BigDecimal(priceStr);
		BigDecimal qty = new BigDecimal(1.0);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2);
			Invoice i = new Invoice().setIssueDate(new Date()).setDueDate(new Date()).setDetailedDeliveryPeriod(new Date(), new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815").addBankDetails(new BankDetails("DE88200800000970375700", "COBADEFFXXX")))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0815"))
				.setNumber(number).setDespatchAdviceReferencedDocumentID(despatchAdviceReferencedDocumentID)
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty))
				.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, qty)).setCreditNote();
			ze.setTransaction(i);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_CREDITNOTEPDF);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_CREDITNOTEPDF);

		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertEquals(DocumentCodeTypeConstants.CREDITNOTE, zi.getDocumentCode());
		//totest: BuyerOrderReferencedDocument
		assertEquals("3.57", zi.getAmount());
		assertEquals(orgname, zi.getHolder());
		assertEquals(number, zi.getForeignReference());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_CREDITNOTEPDF);
		try {
			Invoice i = zii.extractInvoice();

			assertEquals(despatchAdviceReferencedDocumentID, i.getDespatchAdviceReferencedDocumentID());

		} catch (XPathExpressionException e) {
			fail("XPathExpressionException should not be raised");
		} catch (ParseException e) {
			fail("ParseException should not be raised");
			/* a parseException would also be fired if the calculated grand total does not
			match the read grand total */
		}
	}

}
