/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
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

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.xmpbox.xml.DomXmpParser;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class MustangReaderWriterEdgeTest extends MustangReaderTestCase {

	@Override
	public Date getDeliveryDate() {
		return new GregorianCalendar(2017, Calendar.MAY, 7).getTime();
	}

	@Override
	public Date getDueDate() {
		return new GregorianCalendar(2017, Calendar.MAY, 30).getTime();
	}

	@Override
	public Date getIssueDate() {
		return new GregorianCalendar(2017, Calendar.MAY, 9).getTime();
	}

	@Override
	public String getNumber() {
		return "RE-20170509/505";
	}

	@Override
	public String getOwnCountry() {
		return "DE";
	}

	@Override
	public String getOwnLocation() {
		return "Stadthausen";
	}

	@Override
	public String getOwnOrganisationName() {
		return "Bei Spiel GmbH";
	}

	@Override
	public String getOwnStreet() {
		return "Ecke 12";
	}


	@Override
	public IZUGFeRDExportableTradeParty getSender() {
		return new SenderTradeParty();
		
	}

	@Override
	public String getOwnTaxID() {
		return "22/815/0815/4";
	}

	@Override
	public String getOwnVATID() {
		return "DE136695976";
	}

	@Override
	public String getOwnZIP() {
		return "12345";
	}

	@Override
	public IZUGFeRDExportableTradeParty getRecipient() {
		return new RecipientTradeParty();
	}

	@Override
	public String getOwnOrganisationFullPlaintextInfo() {
		return null;
	}

	@Override
	public String getCurrency() {
		return "EUR";
	}

	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		Item[] allItems = new Item[3];
		Product designProduct = new Product("", "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung", "HUR", new BigDecimal("7.000000"));
		Product balloonProduct = new Product("", "Luftballon: Bunt, ca. 500ml", "C62", new BigDecimal("19.000000"));
		Product airProduct = new Product("", "Heiße Luft pro Liter", "LTR", new BigDecimal("19.000000"));

		allItems[0] = new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), new BigDecimal("200"), airProduct);
		return allItems;
	}

	@Override
	public String getPaymentTermDescription() {
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");
		return "Zahlbar ohne Abzug bis zum " + germanDateFormat.format(getDueDate());
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		return null;
	}

	@Override
	public String getReferenceNumber() {
		return "AB321";
	}


	/**
	 * Create the test case
	 *
	 * @param testName name of the test case
	 */
	public MustangReaderWriterEdgeTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(MustangReaderWriterEdgeTest.class);
	}

	// //////// TESTS //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The importer test imports from ./src/test/MustangGnuaccountingBeispielRE-20170509_505.pdf to check the values.
	 * As only Name Ascending is supported for Test Unit sequence, I renamed the this test-A-Import to run before
	 * testZExport
	 */

	public void testAImport() {
		InputStream inputStream = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505.pdf");
		ZUGFeRDImporter zi = new ZUGFeRDImporter(inputStream);

		// Reading ZUGFeRD
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), "COBADEFFXXX");
		assertEquals(zi.getIBAN(), "DE88 2008 0000 0970 3757 00");
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getDueDate(), "20170530");
		assertEquals(zi.getForeignReference(), getNumber());
		assertEquals(zi.getDocumentCode(), "380");

	}

	/**
	 * The exporter test bases on @{code ./src/test/MustangGnuaccountingBeispielRE-20140703_502blanko.pdf}, adds metadata,
	 * writes to @{code ./target/testout-*} and then imports to check the values.
	 * It would not make sense to have it run before the less complex importer test (which is probably redundant).
	 * As only Name Ascending is supported for Test Unit sequence, I renamed the Exporter Test test-Z-Export
	 */
	public void testEdgeExport() {

		final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20170509_505newEdge.pdf";
		final String SOURCE_PDF = "/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf";

		// the writing part
		setupPdfUnderTest(SOURCE_PDF, TARGET_PDF);

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

		// Reading ZUGFeRD
		assertEquals("571.04", zi.getAmount());
		assertEquals("COBADEFFXXX", zi.getBIC());
		assertEquals("DE88 2008 0000 0970 3757 00", zi.getIBAN());
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), getNumber());
		try {
			assertEquals(zi.getVersion(), 1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	/**
	 * This test is based on #testEdgeExport but test only that the PDFIdentificationSchema is present and identifies
	 * the pdf as PDF/A-3 conformant.
	 */
	public void testEdgeExportIsPDFA3() throws Exception {

		final String SOURCE_PDF = "/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf";
		final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20170509_505newEdge.pdf";

		// the writing part
		setupPdfUnderTest(SOURCE_PDF, TARGET_PDF);

		// now check the contents
		PDDocument doc = PDDocument.load(new File(TARGET_PDF));
		PDMetadata meta = doc.getDocumentCatalog().getMetadata();
		assertNotNull("The pdf must contain XMPMetadata", meta);

		byte[] xmpBytes = meta.toByteArray();
		assertNotNull("The xmp metadata stream must not be null", xmpBytes);

		DomXmpParser xmpParser = new DomXmpParser();
		XMPMetadata xmp = xmpParser.parse(xmpBytes);

		PDFAIdentificationSchema pdfai = xmp.getPDFIdentificationSchema();
		assertNotNull("The pdf must contain a PDFIdentificationSchema", pdfai);

		assertTrue("The PDF/A conformance must be A, B or U",
				   Arrays.asList("A", "B", "U", "a", "b", "u").contains(pdfai.getConformance()));

		assertEquals("The PDF/A must be 3", (Integer) 3, pdfai.getPart());
	}

	private void setupPdfUnderTest(String sourcePath, String targetPath) {
		try (InputStream inputStream = this.getClass().getResourceAsStream(sourcePath)) {
			ZUGFeRDExporterFromA3 ze = new ZUGFeRDExporterFromA3()
					 .setProducer("My Application")
					 .setCreator(System.getProperty("user.name"))
				 	 .setZUGFeRDVersion(1)
					 .load(inputStream);
			ze.setTransaction(this);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryDocument"));
			ze.export(targetPath);
		} catch (IOException e) {
			e.printStackTrace();
			fail("IOException should not happen in testEdgeExport ");
		}
	}

}
