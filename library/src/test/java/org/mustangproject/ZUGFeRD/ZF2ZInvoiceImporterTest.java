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

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.Test;
import org.mustangproject.*;
import org.skyscreamer.jsonassert.JSONAssert;

import javax.xml.xpath.XPathExpressionException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.assertThat;


/***
 * Classname ZF2ZInvoiceImporterTest is alphabetical behind the tests which will create the file
 * used for this import, testout-ZF2New.pdf
 */
public class ZF2ZInvoiceImporterTest extends ResourceCase {


	public void testInvoiceImport() {

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2new.pdf");

		boolean hasExceptions = false;
		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", invoice.getSender().getName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("400.0000", invoice.getZFItems()[1].getQuantity().toString());

		assertEquals("AB321", invoice.getReferenceNumber());
		assertEquals("160.0000", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("Heiße Luft pro Liter", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("LTR", invoice.getZFItems()[2].getProduct().getUnit());
		assertEquals("7.00", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
		assertEquals("RE-20170509/505", invoice.getNumber());
		assertEquals("Zahlbar ohne Abzug bis zum 30.05.2017", invoice.getPaymentTermDescription());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		assertEquals("2017-05-09", sdf.format(invoice.getIssueDate()));
		assertEquals("2017-05-07", sdf.format(invoice.getDeliveryDate()));
		assertEquals("2017-05-30", sdf.format(invoice.getDueDate()));

		assertEquals("Bahnstr. 42", invoice.getRecipient().getStreet());
		assertEquals("Hinterhaus", invoice.getRecipient().getAdditionalAddress());
		assertEquals("Zweiter Stock", invoice.getRecipient().getAdditionalAddressExtension());
		assertEquals("88802", invoice.getRecipient().getZIP());
		assertEquals("DE", invoice.getRecipient().getCountry());
		assertEquals("Spielkreis", invoice.getRecipient().getLocation());

		assertEquals("Ecke 12", invoice.getSender().getStreet());
		assertEquals("12345", invoice.getSender().getZIP());
		assertEquals("DE", invoice.getSender().getCountry());
		assertEquals("Stadthausen", invoice.getSender().getLocation());

		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("571.04"), tc.getGrandTotal());


		// name street location zip country, contact name phone email, total amount

	}


	public void testInvoiceImportUBL() {


		boolean hasExceptions = false;

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		File expectedResult = getResourceAsFile("testout-ZF2new.ubl.xml");

		Invoice invoice = null;
		try {
			String xml = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r", "").replace("\n", "");

			zii.fromXML(xml);

			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException | IOException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", invoice.getSender().getName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals(invoice.getZFItems()[0].getNotesWithSubjectCode().get(0).getContent(),"Something");
		assertEquals(invoice.getZFItems()[0].getNotesWithSubjectCode().size(),1);
		assertEquals("400", invoice.getZFItems()[1].getQuantity().toString());
		assertEquals("Zahlbar ohne Abzug bis zum 30.05.2017", invoice.getPaymentTermDescription());
		assertEquals("AB321", invoice.getReferenceNumber());
		assertEquals("160", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("Heiße Luft pro Liter", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("LTR", invoice.getZFItems()[2].getProduct().getUnit());
		assertEquals("7", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
		assertEquals("RE-20170509/505", invoice.getNumber());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		assertEquals("2017-05-09", sdf.format(invoice.getIssueDate()));
		assertEquals("2017-05-07", sdf.format(invoice.getDeliveryDate()));
		assertEquals("2017-05-30", sdf.format(invoice.getDueDate()));

		assertEquals("Bahnstr. 42", invoice.getRecipient().getStreet());
		assertEquals("Hinterhaus", invoice.getRecipient().getAdditionalAddress());
		assertEquals("Zweiter Stock", invoice.getRecipient().getAdditionalAddressExtension());
		assertEquals("88802", invoice.getRecipient().getZIP());
		assertEquals("DE", invoice.getRecipient().getCountry());
		assertEquals("Spielkreis", invoice.getRecipient().getLocation());

		assertEquals("Ecke 12", invoice.getSender().getStreet());
		assertEquals("12345", invoice.getSender().getZIP());
		assertEquals("DE", invoice.getSender().getCountry());
		assertEquals("Stadthausen", invoice.getSender().getLocation());

		assertTrue(invoice.getPayee() != null);
		assertEquals("VR Factoring GmbH", invoice.getPayee().getName());

		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("571.04"), tc.getGrandTotal());


		// name street location zip country, contact name phone email, total amount

	}

	public void testEdgeInvoiceImport() {

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushEdge.pdf");

		boolean hasExceptions = false;
		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		SimpleDateFormat sdf=new SimpleDateFormat("YYYY-MM-dd");
		// Reading ZUGFeRD
		assertEquals("4711", invoice.getZFItems()[0].getProduct().getSellerAssignedID());
		assertEquals("9384", invoice.getSellerOrderReferencedDocumentID());
		assertEquals("90-kl-98798-C", invoice.getTenderReferencedDocument().getIssuerAssignedID());

		IReferencedDocument[] rd=invoice.getZFItems()[0].getAdditionalReferences();
		assertEquals("90-kl-98798-C1", rd[0].getIssuerAssignedID());
		assertEquals("AAG", rd[0].getReferenceTypeCode());



		assertEquals("90-kl-98798-C", invoice.getTenderReferencedDocument().getIssuerAssignedID());
		assertEquals("2025-10-12", sdf.format(invoice.getTenderReferencedDocument().getFormattedIssueDateTime()));
		assertEquals("sender@test.org", invoice.getSender().getEmail());
		assertEquals("recipient@test.org", invoice.getRecipient().getEmail());
		assertEquals("28934", invoice.getBuyerOrderReferencedDocumentID());




	}


	public void testBT17InvoiceImport() {
		boolean hasExceptions = false;
		Invoice invoice = null;

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushEdge.pdf");

		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		SimpleDateFormat sdf=new SimpleDateFormat("YYYY-MM-dd");
		// Reading ZUGFeRD
		assertEquals("90-kl-98798-C", invoice.getTenderReferencedDocument().getIssuerAssignedID());
		assertNotNull(invoice.getTenderReferencedDocument().getFormattedIssueDateTime());
		assertEquals("2025-10-12", sdf.format(invoice.getTenderReferencedDocument().getFormattedIssueDateTime()));
		try {
			zii.setInputStream(new FileInputStream(getResourceAsFile("cii/bt17-response_1760553749128.cii.xml")));
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException | FileNotFoundException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals("Testing1", invoice.getTenderReferencedDocument().getIssuerAssignedID());

	}

	public void testBT128InvoiceImport() {
		boolean hasExceptions = false;
		Invoice invoice = null;

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		try {
		zii.setInputStream(new FileInputStream(getResourceAsFile("ubl/BT-128.ubl.xml")));

			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException | FileNotFoundException  e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		SimpleDateFormat sdf=new SimpleDateFormat("YYYY-mm-dd");
		// Reading ZUGFeRD
		assertEquals("90-kl-98798-C1", invoice.getZFItems()[0].getAdditionalReferences()[0].getIssuerAssignedID());
		assertEquals("AAG", invoice.getZFItems()[0].getAdditionalReferences()[0].getReferenceTypeCode());

	}

	public void testZF1Import() {

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-MustangGnuaccountingBeispielRE-20171118_506zf1.pdf");

		boolean hasExceptions = false;
		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", invoice.getSender().getName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("400.0000", invoice.getZFItems()[1].getQuantity().toString());

		assertEquals("160.0000", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("Hot air „heiße Luft“ (litres)", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("LTR", invoice.getZFItems()[2].getProduct().getUnit());
		assertEquals("7.00", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
		assertEquals("RE-20190610/507", invoice.getNumber());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		assertEquals("2019-06-10", sdf.format(invoice.getIssueDate()));
		assertEquals("2019-07-01", sdf.format(invoice.getDueDate()));

		assertEquals("street", invoice.getRecipient().getStreet());
		assertEquals("zip", invoice.getRecipient().getZIP());
		assertEquals("DE", invoice.getRecipient().getCountry());
		assertEquals("city", invoice.getRecipient().getLocation());

		assertEquals("street", invoice.getSender().getStreet());
		assertEquals("zip", invoice.getSender().getZIP());
		assertEquals("DE", invoice.getSender().getCountry());
		assertEquals("city", invoice.getSender().getLocation());

		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("571.04"), tc.getGrandTotal());


		// name street location zip country, contact name phone email, total amount


	}

	public void testSpecifiedLogisticsChargeCashDiscountImport() {
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		File expectedResult = getResourceAsFile("cii/extended_warenrechnung_based_doublecashdiscount.xml");


		boolean hasExceptions = false;
		CalculatedInvoice invoice = new CalculatedInvoice();
		try {
			zii.setInputStream(new FileInputStream(expectedResult));
			zii.extractInto(invoice);
		} catch (XPathExpressionException | ParseException | FileNotFoundException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		assertEquals(invoice.getCashDiscounts().length,2);
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("518.99"), tc.getGrandTotal());


	}
	public void testItemAllowancesChargesImport() {

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushItemChargesAllowances.pdf");

		boolean hasExceptions = false;
		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("18.33"), tc.getGrandTotal());
	}

	public void testIBANImport() {
		File CIIinputFile = getResourceAsFile("cii/lastschrift_iban_bug.xml");
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(CIIinputFile));


			CalculatedInvoice invoice = new CalculatedInvoice();
			zii.extractInto(invoice);
			assertEquals("DE11111111111111111111", invoice.getCreditorReferenceID());
			assertEquals("DE22222222222222222222", invoice.getSender().getBankDetails().stream().map(BankDetails::getIBAN).collect(Collectors.joining(",")));
		} catch (FileNotFoundException e) {
			throw new RuntimeException(e);
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}
	public void testBasisQuantityImport() {

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2newEdge.pdf");

		boolean hasExceptions = false;
		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("337.60"), tc.getGrandTotal());
	}


	public void testAllowancesChargesImport() {

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushChargesAllowances.pdf");

		boolean hasExceptions = false;
		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("11.07"), tc.getGrandTotal());

	}

	public void testXRImport() {
		boolean hasExceptions = false;

		ZUGFeRDImporter zii = new ZUGFeRDImporter();

		int version=-1;
		try {
			zii.fromXML(new String(Files.readAllBytes(Paths.get("./target/testout-XR-Edge.xml")), StandardCharsets.UTF_8));
			version=zii.getVersion();
		} catch (IOException e) {
			hasExceptions = true;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);


		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("1.00"), tc.getGrandTotal());
		assertEquals(invoice.getCashDiscounts().length,2);
		assertEquals(version,2);
		assertTrue(new BigDecimal("1").compareTo(invoice.getZFItems()[0].getQuantity()) == 0);
		LineCalculator lc=invoice.getZFItems()[0].getCalculation();
		assertTrue(new BigDecimal("1").compareTo(lc.getItemTotalNetAmount()) == 0);

		assertEquals("Z", invoice.getZFItems()[0].getProduct().getTaxCategoryCode());
		assertEquals("Kleinunternehmer", invoice.getZFItems()[0].getProduct().getTaxExemptionReason());

		assertTrue(invoice.getTradeSettlement().length == 1);
		assertTrue(invoice.getTradeSettlement()[0] instanceof IZUGFeRDTradeSettlementPayment);
		IZUGFeRDTradeSettlementPayment paym = (IZUGFeRDTradeSettlementPayment) invoice.getTradeSettlement()[0];
		assertEquals("DE12500105170648489890", paym.getOwnIBAN());
		assertEquals("COBADEFXXX", paym.getOwnBIC());
		assertEquals("kontoInhaber",paym.getAccountName());


		assertTrue(invoice.getPayee() != null);
		assertEquals("VR Factoring GmbH", invoice.getPayee().getName());
	}

	/**
	 * testing if other files embedded in pdf additionally to the invoice can be read correctly
	 */
	public void testDetach() {
		boolean hasExceptions = false;

		byte[] fileA = null;
		byte[] fileB = null;
		boolean facturXFound=false;

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushAttachments.pdf");
		for (FileAttachment fa : zii.getFileAttachmentsPDF()) {
			if (fa.getFilename().equals("one.pdf")) {
				fileA = fa.getData();
			} else if (fa.getFilename().equals("two.pdf")) {
				fileB = fa.getData();
			} else if (fa.getFilename().equals("factur-x.xml")) {
				facturXFound=true;
			}
		}
		byte[] b = {12, 13}; // the sample data that was used to write the files

		assertTrue(facturXFound);
		assertTrue(Arrays.equals(fileA, b));
		assertEquals(fileA.length, 2);
		assertTrue(Arrays.equals(fileB, b));
		assertEquals(fileB.length, 2);
	}

	public void testImportDebit() {
		File CIIinputFile = getResourceAsFile("cii/minimalDebit.xml");
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(CIIinputFile));
			Invoice i = zii.extractInvoice();

			assertEquals("DE21860000000086001055", i.getRecipient().getBankDetails().get(0).getIBAN());
			ObjectMapper mapper = new ObjectMapper();

			String jsonArray = mapper.writeValueAsString(i);
			JSONAssert.assertEquals("{\"documentCode\":\"380\",\"number\":\"471102\",\"currency\":\"EUR\",\"paymentTermDescription\":\"Der Betrag in Höhe von EUR 529,87 wird am 20.03.2018 von Ihrem Konto per SEPA-Lastschrift eingezogen.\\n          \",\"issueDate\":1520121600000,\"deliveryDate\":1520121600000,\"sender\":{\"name\":\"Lieferant GmbH\",\"zip\":\"80333\",\"street\":\"Lieferantenstraße 20\",\"location\":\"München\",\"country\":\"DE\",\"taxID\":\"201/113/40209\",\"vatID\":\"DE123456789\",\"debitDetails\":[{\"mandate\":\"REF A-123\",\"paymentMeansCode\":\"59\",\"paymentMeansInformation\":\"SEPA direct debit\",\"iban\":\"DE21860000000086001055\"}],\"vatid\":\"DE123456789\"},\"recipient\":{\"name\":\"Kunden AG Mitte\",\"zip\":\"69876\",\"street\":\"Kundenstraße 15\",\"location\":\"Frankfurt\",\"country\":\"DE\",\"bankDetails\":[{\"paymentMeansCode\":\"58\",\"paymentMeansInformation\":\"SEPA credit transfer\",\"iban\":\"DE21860000000086001055\"}]},\"totalPrepaidAmount\":0.00,\"creditorReferenceID\":\"DE98ZZZ09999999999\",\"zfitems\":[{\"price\":9.9000,\"quantity\":20.0000,\"basisQuantity\":1.0000,\"id\":\"1\",\"product\":{\"unit\":\"H87\",\"name\":\"Trennblätter A4\",\"taxCategoryCode\":\"S\",\"vatpercent\":19.00},\"value\":9.9000},{\"price\":5.5000,\"quantity\":50.0000,\"basisQuantity\":1.0000,\"id\":\"2\",\"product\":{\"unit\":\"H87\",\"name\":\"Joghurt Banane\",\"taxCategoryCode\":\"S\",\"vatpercent\":7.00},\"value\":5.5000}],\"tradeSettlement\":[{\"mandate\":\"REF A-123\",\"paymentMeansCode\":\"59\",\"paymentMeansInformation\":\"SEPA direct debit\",\"iban\":\"DE21860000000086001055\"}]}",jsonArray,false);

		} catch (IOException e) {
			fail("IOException not expected");
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}
	public static Date atStartOfDay(Date date) {
		ZoneId tz=ZoneId.ofOffset("UTC", ZoneOffset.ofHours(0));
		LocalDateTime localDateTime = LocalDateTime.ofInstant(date.toInstant(), tz);
		LocalDateTime startOfDay = localDateTime.with(LocalTime.MIN);
		return Date.from(startOfDay.atZone(tz).toInstant());
	}
	public void testImportAllowances() {
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushItemChargesAllowances.pdf");
			Invoice i = zii.extractInvoice();
			ObjectMapper mapper = new ObjectMapper();

			String jsonArray = mapper.writeValueAsString(i);
			SimpleDateFormat iso=new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat german=new SimpleDateFormat("dd.MM.yyyy");
			Date now=new Date();
			Date morning=atStartOfDay(now);

			String expectedDueDate= String.valueOf(morning.toInstant().getEpochSecond() *1000);
			String expectedIssueDate= String.valueOf(morning.toInstant().getEpochSecond() *1000);
			String expectedPaymentTermDesciption="Please remit until "+german.format(now);

			JSONAssert.assertEquals("{\n" +
				"  \"documentCode\" : \"380\",\n" +
				"  \"number\" : \"123\",\n" +
				"  \"currency\" : \"EUR\",\n" +
				"  \"paymentTermDescription\" : "+expectedPaymentTermDesciption+",\n" +
				"  \"issueDate\" : "+expectedIssueDate+",\n" +
				"  \"dueDate\" : "+expectedDueDate+",\n" +
				"  \"deliveryDate\" : "+expectedIssueDate+",\n" +
				"  \"sender\" : {\n" +
				"    \"name\" : \"Test company\",\n" +
				"    \"zip\" : \"55232\",\n" +
				"    \"street\" : \"teststr\",\n" +
				"    \"location\" : \"teststadt\",\n" +
				"    \"country\" : \"DE\",\n" +
				"    \"taxID\" : \"4711\",\n" +
				"    \"vatID\" : \"DE0815\",\n" +
				"    \"vatid\" : \"DE0815\"\n" +
				"  },\n" +
				"  \"recipient\" : {\n" +
				"    \"name\" : \"Franz Müller\",\n" +
				"    \"zip\" : \"55232\",\n" +
				"    \"street\" : \"teststr.12\",\n" +
				"    \"location\" : \"Entenhausen\",\n" +
				"    \"country\" : \"DE\",\n" +
				"    \"contact\" : {\n" +
				"      \"name\" : \"contact testname\",\n" +
				"      \"phone\" : \"123456\",\n" +
				"      \"email\" : \"contact.testemail@example.org\",\n" +
				"      \"fax\" : \"0911623562\"\n" +
				"    }\n" +
				"  },\n" +
				"  \"totalPrepaidAmount\" : 0.0,\n" +
				"  \"zfitems\" : [ {\n" +
				"    \"price\" : 3.0,\n" +
				"    \"quantity\" : 1.0,\n" +
				"    \"basisQuantity\" : 1.0,\n" +
				"    \"id\" : \"1\",\n" +
				"    \"product\" : {\n" +
				"      \"unit\" : \"H87\",\n" +
				"      \"name\" : \"Testprodukt\",\n" +
				"      \"taxCategoryCode\" : \"S\",\n" +
				"      \"vatpercent\" : 19.0\n" +
				"    },\n" +
				"    \"itemAllowances\" : [ {\n" +
				"      \"totalAmount\" : 0.1,\n" +
				"      \"taxPercent\" : 0,\n" +
				"      \"categoryCode\" : \"S\"\n" +
				"    } ],\n" +
				"    \"value\" : 3.0,\n" +
				"    \"calculation\" : {\n" +
				"      \"price\" : 3.0,\n" +
				"      \"priceGross\" : 3.0,\n" +
				"      \"itemTotalNetAmount\" : 2.9,\n" +
				"      \"itemTotalVATAmount\" : 0.551,\n" +
				"      \"itemTotalGrossAmount\" : 2.9\n" +
				"    }\n" +
				"  }, {\n" +
				"    \"price\" : 3.0,\n" +
				"    \"quantity\" : 1.0,\n" +
				"    \"basisQuantity\" : 1.0,\n" +
				"    \"id\" : \"2\",\n" +
				"    \"product\" : {\n" +
				"      \"unit\" : \"H87\",\n" +
				"      \"name\" : \"Testprodukt\",\n" +
				"      \"taxCategoryCode\" : \"S\",\n" +
				"      \"vatpercent\" : 19.0\n" +
				"    },\n" +
				"    \"itemAllowances\" : [ {\n" +
				"      \"percent\" : 50.0,\n" +
				"      \"totalAmount\" : 1.5,\n" +
				"      \"basisAmount\" : 3.0,\n" +
				"      \"taxPercent\" : 0,\n" +
				"      \"reason\" : \"In love with salesperson\",\n" +
				"      \"categoryCode\" : \"S\"\n" +
				"    } ],\n" +
				"    \"value\" : 3.0,\n" +
				"    \"calculation\" : {\n" +
				"      \"price\" : 3.0,\n" +
				"      \"priceGross\" : 3.0,\n" +
				"      \"itemTotalNetAmount\" : 1.5,\n" +
				"      \"itemTotalVATAmount\" : 0.285,\n" +
				"      \"itemTotalGrossAmount\" : 1.5\n" +
				"    }\n" +
				"  }, {\n" +
				"    \"price\" : 3.0,\n" +
				"    \"quantity\" : 2.0,\n" +
				"    \"basisQuantity\" : 1.0,\n" +
				"    \"id\" : \"3\",\n" +
				"    \"product\" : {\n" +
				"      \"unit\" : \"H87\",\n" +
				"      \"name\" : \"Testprodukt\",\n" +
				"      \"taxCategoryCode\" : \"S\",\n" +
				"      \"vatpercent\" : 19.0\n" +
				"    },\n" +
				"    \"itemCharges\" : [ {\n" +
				"      \"totalAmount\" : 1.0,\n" +
				"      \"taxPercent\" : 0,\n" +
				"      \"reason\" : \"AnotherReason\",\n" +
				"      \"categoryCode\" : \"S\"\n" +
				"    } ],\n" +
				"    \"value\" : 3.0,\n" +
				"    \"calculation\" : {\n" +
				"      \"price\" : 3.0,\n" +
				"      \"priceGross\" : 3.0,\n" +
				"      \"itemTotalNetAmount\" : 7.0,\n" +
				"      \"itemTotalVATAmount\" : 1.33,\n" +
				"      \"itemTotalGrossAmount\" : 7.0\n" +
				"    }\n" +
				"  }, {\n" +
				"    \"price\" : 3.0,\n" +
				"    \"quantity\" : 1.0,\n" +
				"    \"basisQuantity\" : 1.0,\n" +
				"    \"id\" : \"4\",\n" +
				"    \"product\" : {\n" +
				"      \"unit\" : \"H87\",\n" +
				"      \"name\" : \"Testprodukt\",\n" +
				"      \"taxCategoryCode\" : \"S\",\n" +
				"      \"vatpercent\" : 19.0\n" +
				"    },\n" +
				"    \"itemAllowances\" : [ {\n" +
				"      \"totalAmount\" : 1.0,\n" +
				"      \"taxPercent\" : 0,\n" +
				"      \"reason\" : \"Something completely strange\",\n" +
				"      \"categoryCode\" : \"S\"\n" +
				"    } ],\n" +
				"    \"itemCharges\" : [ {\n" +
				"      \"totalAmount\" : 1.0,\n" +
				"      \"taxPercent\" : 0,\n" +
				"      \"reason\" : \"Yet another reason\",\n" +
				"      \"categoryCode\" : \"S\"\n" +
				"    } ],\n" +
				"    \"value\" : 3.0,\n" +
				"    \"calculation\" : {\n" +
				"      \"price\" : 3.0,\n" +
				"      \"priceGross\" : 3.0,\n" +
				"      \"itemTotalNetAmount\" : 3.0,\n" +
				"      \"itemTotalVATAmount\" : 0.57,\n" +
				"      \"itemTotalGrossAmount\" : 3.0\n" +
				"    }\n" +
				"  } ],\n" +
				"  \"zfcharges\" : [ {\n" +
				"    \"totalAmount\" : 1.0,\n" +
				"    \"taxPercent\" : 19.0,\n" +
				"    \"reason\" : \"AReason\",\n" +
				"    \"reasonCode\" : \"ABK\",\n" +
				"    \"categoryCode\" : \"S\"\n" +
				"  } ]\n" +
				"}",jsonArray,true);
		} catch (IOException e) {
			fail("IOException not expected");
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}

	public void testImportMinimum() {
		File CIIinputFile = getResourceAsFile("cii/facturFrMinimum.xml");
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(CIIinputFile));


			CalculatedInvoice i = new CalculatedInvoice();
			zii.extractInto(i);
			assertEquals("671.15", i.getGrandTotal().toString());

		} catch (IOException e) {
			fail("IOException not expected");
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}


	}

	public void testImportUBLCreditnote() { // Confirm some basics also work with UBL credit notes
		File CIIinputFile = getResourceAsFile("ubl/UBL-CreditNote-2.1-Example.ubl.xml");
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(CIIinputFile));


			CalculatedInvoice i = new CalculatedInvoice();
			zii.extractInto(i);
			assertEquals("TOSL108", i.getNumber());
			assertEquals("1729", i.getGrandTotal().toString());
			assertEquals("729", i.getDuePayable().toString());


		} catch (IOException e) {
			fail("IOException not expected");
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}


	}

	public void testImportUBLPeriods() { // Confirm some basics also work with UBL credit notes
		File ublinputFile = getResourceAsFile("ubl/periods.ubl.xml");
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
			zii.doIgnoreCalculationErrors();
			zii.setInputStream(new FileInputStream(ublinputFile));


			CalculatedInvoice i = new CalculatedInvoice();
			zii.extractInto(i);
			assertEquals("123", i.getNumber());
			assertEquals("1.48", i.getGrandTotal().toString());
			assertEquals("0.20", i.getVATtotal().toString());
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

			assertEquals("2020-10-01", sdf.format(i.getDetailedDeliveryPeriodFrom()));
			assertEquals("2020-10-05", sdf.format(i.getDetailedDeliveryPeriodTo()));

		} catch (IOException e) {
			fail("IOException not expected");
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}


	}


	@Test
	public void testImportPrepaid() throws XPathExpressionException, ParseException {
		InputStream inputStream = this.getClass()
			.getResourceAsStream("/EN16931_1_Teilrechnung.pdf");
		ZUGFeRDInvoiceImporter importer = new ZUGFeRDInvoiceImporter();
		importer.doIgnoreCalculationErrors();
		importer.setInputStream(inputStream);

		CalculatedInvoice invoice = new CalculatedInvoice();
		importer.extractInto(invoice);

		boolean isBD=invoice.getTotalPrepaidAmount() instanceof BigDecimal;
		assertTrue(isBD);
		BigDecimal expectedPrepaid=new BigDecimal(50);
		BigDecimal expectedLineTotal=new BigDecimal("180.76");
		BigDecimal expectedDue=new BigDecimal("147.65");
		BigDecimal expectedTax=new BigDecimal("20.16");
		if (isBD) {
			BigDecimal amread=invoice.getTotalPrepaidAmount();
			BigDecimal importedLineTotal=invoice.getLineTotalAmount();
			BigDecimal importedDuePayable=invoice.getDuePayable();
			BigDecimal importedTaxAmount=invoice.getVATtotal();
			assertTrue(amread.compareTo(expectedPrepaid) == 0);
			assertTrue(importedLineTotal.compareTo(expectedLineTotal) == 0);
			assertTrue(importedDuePayable.compareTo(expectedDue) == 0);
			assertTrue(importedTaxAmount.compareTo(expectedTax) == 0);
		}

	}


	@Test
	public void testImportPrepaidUBL() throws XPathExpressionException, ParseException {
		InputStream inputStream = this.getClass()
			.getResourceAsStream("/ubl/XRECHNUNG_teilrechnung.ubl.xml");
		ZUGFeRDInvoiceImporter importer = new ZUGFeRDInvoiceImporter();
		importer.doIgnoreCalculationErrors();
		importer.setInputStream(inputStream);

		CalculatedInvoice invoice = new CalculatedInvoice();
		importer.extractInto(invoice);

		assertEquals(0, invoice.getGrandTotal().compareTo(new BigDecimal("529.87")));
		assertEquals(0, invoice.getLineTotalAmount().compareTo(new BigDecimal("473")));
		assertEquals(0, invoice.getTotalPrepaidAmount().compareTo(new BigDecimal("500")));
		assertEquals(0, invoice.getDuePayable().compareTo(new BigDecimal("29.87")));
	}


	@Test
	public void testImportIncludedNotes() throws XPathExpressionException, ParseException {
		InputStream inputStream = this.getClass()
			.getResourceAsStream("/EN16931_Einfach.pdf");
		ZUGFeRDInvoiceImporter importer = new ZUGFeRDInvoiceImporter(inputStream);
		Invoice invoice = importer.extractInvoice();
		List<IncludedNote> notesWithSubjectCode = invoice.getNotesWithSubjectCode();
		assertThat(notesWithSubjectCode).hasSize(2);
		assertThat(notesWithSubjectCode.get(0).getSubjectCode()).isNull();
		assertThat(notesWithSubjectCode.get(0).getContent()).isEqualTo("Rechnung gemäß Bestellung vom 01.11.2024.");
		assertThat(notesWithSubjectCode.get(1).getSubjectCode()).isEqualTo(SubjectCode.REG);
		assertThat(notesWithSubjectCode.get(1).getContent()).isEqualTo("Lieferant GmbH\t\t\t\t\n"
			+ "Lieferantenstraße 20\t\t\t\t\n"
			+ "80333 München\t\t\t\t\n"
			+ "Deutschland\t\t\t\t\n"
			+ "Geschäftsführer: Hans Muster\n"
			+ "Handelsregisternummer: H A 123");

	}


	@Test
	public void testIBANparsing() throws XPathExpressionException, ParseException, FileNotFoundException {

		File inputFile = getResourceAsFile("cii/minimalDebit.xml");

		ZUGFeRDInvoiceImporter importer = new ZUGFeRDInvoiceImporter(new FileInputStream(inputFile));
		Invoice invoice = importer.extractInvoice();
		assertEquals(1,invoice.getRecipient().getBankDetails().size());
		// IBAN belongs to recipient in invoice with sepa debit
		assertEquals("DE21860000000086001055",invoice.getRecipient().getBankDetails().get(0).getIBAN());
		assertEquals(0,invoice.getSender().getBankDetails().size());

		inputFile = getResourceAsFile("factur-x.xml");

		importer = new ZUGFeRDInvoiceImporter(new FileInputStream(inputFile));
		invoice = importer.extractInvoice();
		assertEquals(1,invoice.getSender().getBankDetails().size());
		// IBAN belongs to sender in normal invoice
		assertEquals("DE88200800000970375700",invoice.getSender().getBankDetails().get(0).getIBAN());
		assertEquals(0,invoice.getRecipient().getBankDetails().size());

	}

	@Test
	public void testItemsBillingSpecifiedPeriod() throws FileNotFoundException, XPathExpressionException, ParseException {
		File inputFile = getResourceAsFile("factur-x_invoicingPeriod.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(inputFile));

		CalculatedInvoice invoice = new CalculatedInvoice();
		zii.extractInto(invoice);
		assertEquals(3, invoice.getZFItems().length);
		assertEquals(new Date(2022-1900, 8-1, 29), invoice.getZFItems()[0].getDetailedDeliveryPeriodFrom());
		assertEquals(new Date(2022-1900, 8-1, 31), invoice.getZFItems()[0].getDetailedDeliveryPeriodTo());
	}

	public void testImportPositionIncludedNotes() throws FileNotFoundException, XPathExpressionException, ParseException {
		File inputFile = getResourceAsFile("ZTESTZUGFERD_1_INVDSS_012015738820PDF-1.pdf");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();
		assertEquals(1, invoice.getZFItems().length);
		assertEquals(8, invoice.getZFItems()[0].getNotesWithSubjectCode().size());
		assertEquals("FB-LE 9999", invoice.getZFItems()[0].getNotesWithSubjectCode().stream().filter(note -> note.getSubjectCode().equals(SubjectCode.ABZ)).findFirst().get().getContent());
	}

	@Test
	public void testImportXRechnungPositionNote() throws FileNotFoundException, XPathExpressionException, ParseException {
		File inputFile = getResourceAsFile("TESTXRECHNUNG_INVDSS_012015776085.XML");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();
		assertEquals(1, invoice.getZFItems().length);
		assertFalse(invoice.getZFItems()[0].getNotes() == null);
		assertEquals(1, invoice.getZFItems()[0].getNotes().length);
	}

	@Test
	public void testImportXRechnungWithoutCalculationErrors() throws FileNotFoundException, XPathExpressionException, ParseException {
		File inputFile = getResourceAsFile("cii/02.03a-INVOICE_uncefact.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(inputFile));

		assertEquals("0", zii.importedInvoice.getDuePayable().toPlainString());
	}

	@Test
	public void test() throws FileNotFoundException, XPathExpressionException, ParseException {
		File inputFile = getResourceAsFile("ORDER-X_EX01_ORDER_FULL_DATA-COMFORTorder-x.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.setInputStream(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("BUYER_ACCOUNTING_REF", invoice.getZFItems()[0].getAccountingReference());
	}

	@Test
	public void testImportExport() throws FileNotFoundException, XPathExpressionException, ParseException {
		File inputFile = getResourceAsFile("cii/Factur-X_basic.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.setInputStream(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();
		assertTrue(invoice.isValid());

		assertNull(invoice.getDeliveryAddress());
		assertNull(invoice.getPayee());

		assertNull(invoice.getBuyerOrderReferencedDocumentID());
		assertNull(invoice.getSellerOrderReferencedDocumentID());
		assertNull(invoice.getDespatchAdviceReferencedDocumentID());
		assertNull(invoice.getInvoiceReferencedDocumentID());
		assertNull(invoice.getDeliveryNoteReferencedDocumentID());
		assertNull(invoice.getDeliveryNoteReferencedDocumentDate());
	}

	@Test
	public void testSubInvoiceLinesImport() throws FileNotFoundException, XPathExpressionException, ParseException {
		// test import of sub invoice lines with GROUP and DETAIL lines
		File inputFile = getResourceAsFile("subinvoicelines/Extended_SubInvoiceLines_Hardware_Bsp2.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.setInputStream(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();
		assertEquals(6, invoice.getZFItems().length);

		// find GROUP and DETAIL lines and verify LineStatusReasonCode and ParentLineID
		Item group01 = findItemById(invoice, "01");
		assertNotNull(group01);
		assertEquals("GROUP", group01.getLineStatusReasonCode());
		assertNull(group01.getParentLineID());
		assertFalse(group01.isCalculationRelevant());

		Item detail0101 = findItemById(invoice, "0101");
		assertNotNull(detail0101);
		assertEquals("DETAIL", detail0101.getLineStatusReasonCode());
		assertEquals("01", detail0101.getParentLineID());
		assertTrue(detail0101.isCalculationRelevant());

		Item detail0102 = findItemById(invoice, "0102");
		assertNotNull(detail0102);
		assertEquals("DETAIL", detail0102.getLineStatusReasonCode());
		assertEquals("01", detail0102.getParentLineID());
		assertTrue(detail0102.isCalculationRelevant());

		// verify that only DETAIL lines are summed (not GROUP lines)
		// DETAIL lines: 0101=600, 0102=450, 0201=360, 0202=90 = 1500
		// GROUP lines should NOT be added: 01=1050, 02=450
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("1500.00"), tc.getTotal().setScale(2));
		assertEquals(new BigDecimal("1785.00"), tc.getGrandTotal().setScale(2));
	}

	@Test
	public void testSubInvoiceLinesNestedImport() throws FileNotFoundException, XPathExpressionException, ParseException {
		// test import of nested sub invoice lines (GROUP containing GROUP containing DETAIL)
		File inputFile = getResourceAsFile("subinvoicelines/Extended___SubInvoiceLines_Kaffee_Bundle_Set_Bsp4__.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.setInputStream(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();

		// find nested structure: 1 (GROUP) -> 1.3 (GROUP) -> 1.3.1 (DETAIL)
		Item group1 = findItemById(invoice, "1");
		assertNotNull(group1);
		assertEquals("GROUP", group1.getLineStatusReasonCode());

		Item group13 = findItemById(invoice, "1.3");
		assertNotNull(group13);
		assertEquals("GROUP", group13.getLineStatusReasonCode());
		assertEquals("1", group13.getParentLineID());

		Item detail131 = findItemById(invoice, "1.3.1");
		assertNotNull(detail131);
		assertEquals("DETAIL", detail131.getLineStatusReasonCode());
		assertEquals("1.3", detail131.getParentLineID());

		// verify calculation only includes DETAIL lines
		// DETAIL: 1.1=30, 1.2=60, 1.3.1=90, 1.3.2=36 = 216
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("216.00"), tc.getTotal().setScale(2));
	}

	@Test
	public void testSubInvoiceLinesWithDiscounts() throws FileNotFoundException, XPathExpressionException, ParseException {
		// test sub invoice lines with negative amounts (discounts)
		File inputFile = getResourceAsFile("subinvoicelines/Extended___SubInvoiceLines_Buero_Material_Bsp3__.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.setInputStream(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();

		// verify calculation handles negative DETAIL lines correctly
		// GROUP 01: 600 + 450 - 50 = 1000
		// GROUP 02: 360 + 90 - 45 = 405
		// Total DETAIL: 1405
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("1405.00"), tc.getTotal().setScale(2));
	}

	@Test
	public void testSubInvoiceLinesInformation() throws FileNotFoundException, XPathExpressionException, ParseException {
		// test INFORMATION lines (should have price 0 and not affect calculation)
		File inputFile = getResourceAsFile("subinvoicelines/Extended_Fallschutz-Set_SubInvoiceLine_Bsp5.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.setInputStream(new FileInputStream(inputFile));

		Invoice invoice = zii.extractInvoice();

		// find INFORMATION lines
		Item info0101 = findItemById(invoice, "01.01");
		assertNotNull(info0101);
		assertEquals("INFORMATION", info0101.getLineStatusReasonCode());
		assertFalse(info0101.isCalculationRelevant());

		// DETAIL line 01 = 45000
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("45000.00"), tc.getTotal().setScale(2));
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
