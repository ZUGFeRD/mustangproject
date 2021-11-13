
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

import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.mustangproject.Invoice;

import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;


/***
 * Classname ZF2ZInvoiceImporterTest is alphabetical behind the tests which will create the file
 * used for this import, testout-ZF2New.pdf
 */
public class ZF2ZInvoiceImporterTest extends ResourceCase  {

	public void testInvoiceImport() {

		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter("./target/testout-ZF2new.pdf");

		boolean hasExceptions=false;
		Invoice invoice=null;
		try {
			invoice=zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions=true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", invoice.getOwnOrganisationName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("400.0000", invoice.getZFItems()[1].getQuantity().toString());

		assertEquals("160.0000", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("Heiße Luft pro Liter", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("LTR", invoice.getZFItems()[2].getProduct().getUnit());
		assertEquals("7.00", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
		assertEquals("RE-20170509/505", invoice.getNumber());

		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		assertEquals("2017-05-09",sdf.format(invoice.getIssueDate()));
		assertEquals("2017-05-07",sdf.format(invoice.getDeliveryDate()));
		assertEquals("2017-05-30",sdf.format(invoice.getDueDate()));

		assertEquals("Bahnstr. 42", invoice.getRecipient().getStreet());
		assertEquals("88802", invoice.getRecipient().getZIP());
		assertEquals("DE", invoice.getRecipient().getCountry());
		assertEquals("Spielkreis", invoice.getRecipient().getLocation());

		assertEquals("Ecke 12", invoice.getSender().getStreet());
		assertEquals("12345", invoice.getSender().getZIP());
		assertEquals("DE", invoice.getSender().getCountry());
		assertEquals("Stadthausen", invoice.getSender().getLocation());

		TransactionCalculator tc=new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("571.04"),tc.getGrandTotal());


		// name street location zip country, contact name phone email, total amount



	}
	public void testItemAllowancesChargesImport() {

		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushItemChargesAllowances.pdf");

		boolean hasExceptions=false;
		Invoice invoice=null;
		try {
			invoice=zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions=true;
		}
		assertFalse(hasExceptions);
		TransactionCalculator tc=new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("18.33"),tc.getGrandTotal());
	}

	public void testAllowancesChargesImport() {

		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter("./target/testout-ZF2PushChargesAllowances.pdf");

		boolean hasExceptions=false;
		Invoice invoice=null;
		try {
			invoice=zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
			hasExceptions=true;
		}
		assertFalse(hasExceptions);
		TransactionCalculator tc=new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("11.07"),tc.getGrandTotal());

	}

	public void testItemReferencedDocumentsImport() {
		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter();

		DocumentBuilderFactory db = DocumentBuilderFactory.newInstance();

		boolean hasExceptions=false;
		Invoice invoice=null;
		try {
			zii.doRecalculateItemPricesFromLineTotals();
			zii.doIgnoreCalculationErrors();
			zii.fromXML(new String(Files.readAllBytes(Paths.get(getResourceAsFile("factur-x-testImport-corrected.xml").getAbsolutePath())), StandardCharsets.UTF_8));
			invoice=zii.extractInvoice();
		} catch (XPathExpressionException | ParseException | IOException e) {
			hasExceptions=true;
		}
		assertFalse(hasExceptions);
		assertNotNull(invoice.getZFItems()[0].getReferencedDocuments());
		assertEquals(2, invoice.getZFItems()[0].getReferencedDocuments().length);
		assertEquals("33807818630-5",  invoice.getZFItems()[0].getReferencedDocuments()[0].getIssuerAssignedID());
		assertEquals("PL", invoice.getZFItems()[0].getReferencedDocuments()[1].getReferenceTypeCode());

		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("Extended"));
		zf2p.generateXML(invoice);
		String theXML = new String(zf2p.getXML());
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter("c:\\Users\\jstaerk\\Desktop\\xrechnung-written.xml"));
			writer.write(theXML);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		TransactionCalculator tc=new TransactionCalculator(invoice);
//    assertEquals(new BigDecimal("1284.66"),tc.getGrandTotal());
		assertEquals(new BigDecimal("1284.40"),tc.getGrandTotal());
	}

}
