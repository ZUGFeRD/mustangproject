
/** **********************************************************************
 *
 * Copyright 2019 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
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
	final String TARGET_PDF = "./target/testout-ZF2Push.pdf";
	final String TARGET_CORRECTIONPDF = "./target/testout-ZF2PushCorrection.pdf";
	final String TARGET_ITEMCHARGESALLOWANCESPDF = "./target/testout-ZF2PushItemChargesAllowances.pdf";
	final String TARGET_CHARGESALLOWANCESPDF = "./target/testout-ZF2PushChargesAllowances.pdf";
	final String TARGET_ATTACHMENTSPDF = "./target/testout-ZF2PushAttachments.pdf";

	public void testPushExport() {

		// the writing part

		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			try {
				ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setOccurrencePeriod(new SimpleDateFormat("yyyy-MM-dd").parse("2020-10-01"), new SimpleDateFormat("yyyy-MM-dd").parse("2020-10-05")).setContractReferencedDocument("0815").setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addBankDetails(new BankDetails("777666555", "DE4321"))).setOwnTaxID("4711").setOwnVATID("DE19990815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setContact(new Contact("nameRep", "phoneRep", "emailRep@test.com"))).setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0))));
			} catch (ParseException ex) {
				throw new RuntimeException("Parse exception");
			}
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("777666555")); //the iban
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));

			ze.export(TARGET_PDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

		assertTrue(zi.getUTF8().contains("EUR"));
		assertTrue(zi.getUTF8().contains("0815"));

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

	public void testAttachmentsExport() {

		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		String taxID="9990815";
		BigDecimal amount = new BigDecimal(amountStr);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			byte[] b={12,13};
			ze.attachFile("one.pdf", b, "Application/PDF", "Alternative");
			ze.attachFile("two.pdf", b, "Application/PDF", "Alternative");
			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE").addTaxID(taxID)).setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE4711").setContact(new Contact("Franz Müller","01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE"))).setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), amount, new BigDecimal(1.0)))

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


			ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
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

			ze.setTransaction(new Invoice().setCurrency("CHF").setDueDate(new Date()).setOccurrenceDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
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


	public void testCorrectionExport() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		BigDecimal price = new BigDecimal(priceStr);
		BigDecimal amount=new BigDecimal(-1.0);
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {

			Invoice i=new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setOccurrencePeriod(new Date(),new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE").addTaxID("4711").addVATID("DE0815")).setRecipient(new TradeParty("Franz Müller",  "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0815")).setNumber(number)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, amount))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, amount))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), price, amount)).setCorrection("0815");
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
