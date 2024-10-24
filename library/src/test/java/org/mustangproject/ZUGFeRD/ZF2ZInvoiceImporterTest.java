
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

import com.fasterxml.jackson.databind.ObjectMapper;
import org.mustangproject.*;

import javax.xml.xpath.XPathExpressionException;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;


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
		assertEquals("Bei Spiel GmbH", invoice.getOwnOrganisationName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("400.0000", invoice.getZFItems()[1].getQuantity().toString());

		assertEquals("AB321", invoice.getReferenceNumber());
		assertEquals("160.0000", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("Heiße Luft pro Liter", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("LTR", invoice.getZFItems()[2].getProduct().getUnit());
		assertEquals("7.00", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
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
		assertEquals("Bei Spiel GmbH", invoice.getOwnOrganisationName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("400", invoice.getZFItems()[1].getQuantity().toString());

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
		// Reading ZUGFeRD
		assertEquals("4711", invoice.getZFItems()[0].getProduct().getSellerAssignedID());
		assertEquals("9384", invoice.getSellerOrderReferencedDocumentID());
		assertEquals("sender@test.org", invoice.getSender().getEmail());
		assertEquals("recipient@test.org", invoice.getRecipient().getEmail());
		assertEquals("28934", invoice.getBuyerOrderReferencedDocumentID());

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
		assertEquals("Bei Spiel GmbH", invoice.getOwnOrganisationName());
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

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		try {
			zii.fromXML(new String(Files.readAllBytes(Paths.get("./target/testout-XR-Edge.xml")), StandardCharsets.UTF_8));

		} catch (IOException e) {
			hasExceptions = true;
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
		assertTrue(invoice.getTradeSettlement().length==1);
		assertTrue(invoice.getTradeSettlement()[0] instanceof IZUGFeRDTradeSettlementPayment);
		IZUGFeRDTradeSettlementPayment paym=(IZUGFeRDTradeSettlementPayment)invoice.getTradeSettlement()[0];
		assertEquals("DE12500105170648489890", paym.getOwnIBAN());
		assertEquals("COBADEFXXX", paym.getOwnBIC());


		assertTrue(invoice.getPayee() != null);
		assertEquals("VR Factoring GmbH", invoice.getPayee().getName());
	}

	/**
	 * testing if other files embedded in pdf additionally to the invoice can be read correctly
	 * */
	public void testDetach() {
		boolean hasExceptions = false;

		byte[] fileA=null;
		byte[] fileB=null;

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushAttachments.pdf");
		for (FileAttachment fa:zii.getFileAttachmentsPDF()) {
			if (fa.getFilename().equals("one.pdf")) {
				fileA=fa.getData();
			} else if (fa.getFilename().equals("two.pdf")) {
				fileB=fa.getData();
			}
		}
		byte[] b = {12, 13}; // the sample data that was used to write the files

		assertTrue(Arrays.equals(fileA, b));
		assertEquals(fileA.length, 2);
		assertTrue(Arrays.equals(fileB, b));
		assertEquals(fileB.length, 2);
	}



	public void testImportDebit() {
		File CIIinputFile = getResourceAsFile("cii/minimalDebit.xml");
		try {
			ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(new FileInputStream(CIIinputFile));
			Invoice i=zii.extractInvoice();

			assertEquals("DE21860000000086001055", i.getSender().getBankDetails().get(0).getIBAN());
			ObjectMapper mapper = new ObjectMapper();

			String jsonArray = mapper.writeValueAsString(i);

	//		assertEquals("",jsonArray);

		} catch (IOException e) {
			fail("IOException not expected");
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}


	}


	public void testEEISI_300_cii_Import() {
		boolean hasExceptions = false;
	/*	File input = getResourceAsFile("not_validating_full_invoice_based_onTest_EeISI_300_CENfullmodel.cii.xml");


		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		try {
			zii.fromXML(new String(Files.readAllBytes(input.toPath()), StandardCharsets.UTF_8));

		} catch (IOException e) {
			hasExceptions = true;
		}

		Invoice invoice = null;
		try {
			invoice = zii.extractInvoice();
			assertEquals("Seller contact point",invoice.getSender().getName());
				/*
				<cbc:Name>Seller contact point</cbc:Name>
        <cbc:Telephone>+41 345 654455</cbc:Telephone>
        <cbc:ElectronicMail>seller@contact.de);*
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		TransactionCalculator tc = new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("205.00"), tc.getGrandTotal());
*/
	}


}
