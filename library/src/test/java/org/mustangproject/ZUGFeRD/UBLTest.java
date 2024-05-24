
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

import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.util.Date;

import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.mustangproject.BankDetails;
import org.mustangproject.CII.CIIToUBL;
import org.mustangproject.Contact;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

import javax.xml.xpath.XPathExpressionException;

public class UBLTest extends ResourceCase {
	final String TARGET_XML = "./target/testout-1Lieferschein.xml";

  public UBLTest() {
  }

  @Test
  @Order(2)
	public void testUBLBasic() {

		// the writing part
		final CIIToUBL c2u = new CIIToUBL();
		final String sourceFilename = "factur-x.xml";
		final File input = getResourceAsFile(sourceFilename);
		final File expectedFile = getResourceAsFile("ubl-conv-ubl-output-factur-x.xml");
		String expected = null;
		String result = null;
		try {
			final File tempFile = File.createTempFile("ZUGFeRD-UBL-", "-test");
			c2u.convert(input, tempFile);
			expected = ResourceUtilities.readFile(StandardCharsets.UTF_8, expectedFile.getAbsolutePath());
			result = ResourceUtilities.readFile(StandardCharsets.UTF_8, tempFile.getAbsolutePath());
		} catch (final IOException e) {
			fail("Exception should not happen: " + e.getMessage());
		}


		assertNotNull(result);
		Assertions.assertThat(result).isXmlEqualTo(expected);
	}

  @Test
  @Order(1)
	public void test1Lieferschein() {

		final EinLieferscheinExporter oe = new EinLieferscheinExporter();
		final Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE").addTaxID("DE4711").addVATID("DE0815").setContact(new Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX")))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
				.setReferenceNumber("991-01484-64")//leitweg-id
				.setNumber("123").addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO), /*price*/ new BigDecimal("1.0"),  /*qty*/ new BigDecimal("1.0")).addReferencedLineID("A12"));


		try {
			oe.setTransaction(i);
			final ByteArrayOutputStream baos=new ByteArrayOutputStream();
			oe.export(baos);

			final String theXML = baos.toString("UTF-8");
			assertTrue(theXML.contains("<DespatchAdvice"));
			Files.write(Paths.get(TARGET_XML), theXML.getBytes(StandardCharsets.UTF_8));
		} catch (final IOException e) {
			e.printStackTrace();
		}


	}

	public void testEdgeInvoiceImportUBL() {

		File UBLinputFile = getResourceAsFile("ubl/01.01a-INVOICE.ubl.xml");
		boolean hasExceptions = false;

		ZUGFeRDInvoiceImporter zii = null;
		Invoice invoice = null;
		try {
			zii = new ZUGFeRDInvoiceImporter(new FileInputStream(UBLinputFile));
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException | FileNotFoundException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals(new BigDecimal("288.79"), invoice.getZFItems()[0].getPrice());
		assertEquals("04011000-12345-03", invoice.getReferenceNumber());
		assertEquals("seller@email.de", invoice.getSender().getContact().getEMail());
		assertEquals("12345", invoice.getRecipient().getZIP());
		assertEquals("DE75512108001245126199", invoice.getSender().getBankDetails().get(0).getIBAN());

	}


/*	public void testInvoiceImportOtherUBL() {


		File UBLinputFile = getResourceAsFile("ubl/EN16931_1_Teilrechnung.ubl.xml");
//		File UBLinputFile = getResourceAsFile("ubl/EN16931_2_Teilrechnung.ubl.xml");
/*			File UBLinputFile = getResourceAsFile("ubl/EN16931_AbweichenderZahlungsempf.ubl.xml");
				File UBLinputFile = getResourceAsFile("ubl/EN16931_Betriebskostenabrechnung.ubl.xml");
					File UBLinputFile = getResourceAsFile("ubl/EN16931_Einfach.ubl.xml");
						File UBLinputFile = getResourceAsFile("ubl/EN16931_Einfach_DueDate.ubl.xml");
							File UBLinputFile = getResourceAsFile("ubl/EN16931_Einfach_negativePaymentDue.ubl.xml");
								File UBLinputFile = getResourceAsFile("ubl/EN16931_Elektron.ubl.xml");
									File UBLinputFile = getResourceAsFile("ubl/EN16931_ElektronischeAdresse.ubl.xml");
										File UBLinputFile = getResourceAsFile("ubl/EN16931_Gutschrift.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Haftpflichtversicherung_Versicherungssteuer.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Innergemeinschaftliche_Lieferungen.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Kraftfahrversicherung_Bruttopreise.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Miete.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_OEPNV.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Physiotherapeut.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Rabatte.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Rechnungskorrektur.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_RechnungsUebertragung.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Reisekostenabrechnung.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_Sachversicherung_berechneter_Steuersatz.ubl.xml");
		File UBLinputFile = getResourceAsFile("ubl/EN16931_SEPA_Prenotification.ubl.xml");



		boolean hasExceptions = false;

		ZUGFeRDInvoiceImporter zii = null;
		Invoice invoice = null;
		try {
			zii = new ZUGFeRDInvoiceImporter(new FileInputStream(UBLinputFile));
			invoice = zii.extractInvoice();
		} catch (XPathExpressionException | ParseException | FileNotFoundException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals(new BigDecimal("288.79"), invoice.getZFItems()[0].getPrice());
		assertEquals("04011000-12345-03", invoice.getReferenceNumber());
		assertEquals("seller@email.de", invoice.getSender().getContact().getEMail());
		assertEquals("12345", invoice.getRecipient().getZIP());
		assertEquals("DE75512108001245126199", invoice.getSender().getBankDetails().get(0).getIBAN());

	}*/
}
