
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

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Date;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.xml.DomXmpParser;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mustangproject.BankDetails;
import org.mustangproject.Contact;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

@TestMethodOrder(MethodOrderer.MethodName.class)
public class PDFAWriteTest extends ResourceCase {
	private static final String TARGET_PDF_FROM_A1 = "./target/testout-PDFA3FromA3.pdf";
	private static final String TARGET_PDF_FROM_A3 = "./target/testout-PDFA3FromA3.pdf";
	private static final String TARGET_PDF_FROM_A3_UNKNOWN = "./target/testout-PDFA3FromUnkownA3.pdf";
	private static final String TARGET_PDF_FROM_A1_UNKNOWN = "./target/testout-PDFA3FromUnkownA1.pdf";

	@Test
	public void testA1KnownExport() {
		// test creating factur-x invoices to french authorities, i.e. with SIRET number
		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");

		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blanko.pdf"); //a3
		int exceptions = 0;
		try (ZUGFeRDExporterFromA1 zea3 = new ZUGFeRDExporterFromA1()) {
			zea3.load(tempFile.getAbsolutePath());
			zea3.setTransaction(i);
			zea3.export(TARGET_PDF_FROM_A1);

		} catch (IOException e) {
			exceptions++;
		}
		assertEquals(0, exceptions);
	}

	@Test
	public void testA3KnownExport() {
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");

		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blankoA3.pdf"); //a3
		int exceptions = 0;
		try (ZUGFeRDExporterFromA3 zea3 = new ZUGFeRDExporterFromA3()) {
			zea3.load(tempFile.getAbsolutePath());
			zea3.setTransaction(i);
			zea3.export(TARGET_PDF_FROM_A3);

		} catch (IOException e) {
			exceptions++;
		}
		assertEquals(0, exceptions);
	}

	@Test
	public void testA3UnknownExport() {
		// test creating factur-x invoices to french authorities, i.e. with SIRET number
		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);

		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blankoA3.pdf");
		int exceptions = 0;
		try (IZUGFeRDExporter zea = new ZUGFeRDExporterFromPDFA()) {
			zea.load(tempFile.getAbsolutePath());
			zea.setTransaction(i);
			zea.export(TARGET_PDF_FROM_A3_UNKNOWN);

		} catch (IOException e) {
			exceptions++;
		}
		assertEquals(0, exceptions);
	}

	@Test
	public void testA3UnknownExportFromA1() {
		// test creating factur-x invoices to french authorities, i.e. with SIRET number
		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);
		Path tempFile = getResourceAsPath("MustangGnuaccountingBeispielRE-20201121_508blanko.pdf");
		int exceptions = 0;
		try (IZUGFeRDExporter zea = new ZUGFeRDExporterFromPDFA();
			InputStream is = Files.newInputStream(tempFile)) {
			zea.load(is);
			zea.setTransaction(i);
			zea.setProfile(Profiles.getByName("EN16931"));
			zea.export(TARGET_PDF_FROM_A1_UNKNOWN);

		} catch (IOException e) {
			exceptions++;
		}
		assertEquals(0, exceptions);
	}

	@Test
	public void testDescriptiveMetadataIsPassedToExporter() throws Exception {
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blankoA3.pdf");

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try (IZUGFeRDExporter zea = new ZUGFeRDExporterFromPDFA()) {
			zea.load(tempFile.getAbsolutePath());
			zea.setTitle("My Invoice").setSubject("My Subject").setKeywords("Invoice, ZUGFeRD");
			zea.setTransaction(i);
			zea.export(bos);
		}

		assertDescriptiveMetadata(bos.toByteArray(), "My Invoice", "My Subject", "Invoice, ZUGFeRD");
	}

	@Test
	public void testDescriptiveMetadataOfSourcePDFIsRetained() throws Exception {
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("EN16931_Einfach.pdf");

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try (IZUGFeRDExporter zea = new ZUGFeRDExporterFromPDFA()) {
			zea.load(tempFile.getAbsolutePath());
			zea.setTransaction(i);
			zea.export(bos);
		}

		assertDescriptiveMetadata(bos.toByteArray(), "Lieferant GmbH: Invoice 471102",
			"Invoice 471102 dated 2024-11-15 issued by Lieferant GmbH", "Invoice, Factur-X");
	}

	private void assertDescriptiveMetadata(byte[] pdf, String title, String subject, String keywords) throws Exception {
		try (PDDocument doc = Loader.loadPDF(pdf)) {
			PDDocumentInformation info = doc.getDocumentInformation();
			assertEquals(title, info.getTitle());
			assertEquals(subject, info.getSubject());
			assertEquals(keywords, info.getKeywords());

			XMPMetadata xmp = new DomXmpParser().parse(doc.getDocumentCatalog().getMetadata().toByteArray());
			assertEquals(title, xmp.getDublinCoreSchema().getTitle());
			assertEquals(subject, xmp.getDublinCoreSchema().getDescription());
			assertEquals(keywords, xmp.getAdobePDFSchema().getKeywords());
		}
	}

	private Invoice createInvoice(TradeParty recipient) {
		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		return new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("DE4711").addVATID("DE0815").setContact(new Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX")))
				.setRecipient(recipient)
				.setReferenceNumber("991-01484-64") //leitweg-id
				// not using any VAT, this is also a test of zero-rated goods:
				.setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO), amount, new BigDecimal("1.0")));
	}

}
