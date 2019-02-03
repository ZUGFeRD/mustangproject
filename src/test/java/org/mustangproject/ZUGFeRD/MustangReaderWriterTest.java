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

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class MustangReaderWriterTest extends TestCase implements IZUGFeRDExportableTransaction {

	@Override
	public Date getDeliveryDate() {
		return new GregorianCalendar(2017, Calendar.NOVEMBER, 17).getTime();
	}

	@Override
	public Date getDueDate() {
		return new GregorianCalendar(2017, Calendar.DECEMBER, 9).getTime();
	}

	@Override
	public Date getIssueDate() {
		return new GregorianCalendar(2017, Calendar.NOVEMBER, 18).getTime();
	}

	@Override
	public String getNumber() {
		return "RE-20171118/506";
	}

	@Override
	public String getOwnBIC() {
		return "COBADEFFXXX";
	}

	@Override
	public String getOwnBankName() {
		return "Commerzbank";
	}

	@Override
	public String getOwnCountry() {
		return "DE";
	}

	@Override
	public String getOwnIBAN() {
		return "DE88 2008 0000 0970 3757 00";
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
	public IZUGFeRDExportableContact getRecipient() {
		return new Contact();
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
		Product designProduct = new Product("", "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung", "HUR",
				new BigDecimal("7.000000"));
		Product balloonProduct = new Product("", "Luftballon: Bunt, ca. 500ml", "C62", new BigDecimal("19.000000"));
		Product airProduct = new Product("", "Heiße Luft pro Liter", "LTR", new BigDecimal("19.000000"));

		allItems[0] = new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), new BigDecimal("200"), airProduct);
		return allItems;
	}

	@Override
	public String getOwnPaymentInfoText() {
		return "Überweisung";
	}

	@Override
	public String getPaymentTermDescription() {
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");
		return "Zahlbar ohne Abzug bis zum " + germanDateFormat.format(getDueDate());
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		return null;
		// throw new UnsupportedOperationException("Not supported yet."); //To change
		// body of generated methods, choose Tools | Templates.
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		return null;
		// throw new UnsupportedOperationException("Not supported yet."); //To change
		// body of generated methods, choose Tools | Templates.
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		return null;
		// throw new UnsupportedOperationException("Not supported yet."); //To change
		// body of generated methods, choose Tools | Templates.
	}

	@Override
	public String getReferenceNumber() {
		return null;
	}

	class Contact implements IZUGFeRDExportableContact {

		@Override
		public String getCountry() {
			return "DE";
		}

		@Override
		public String getLocation() {
			return "Spielkreis";
		}

		@Override
		public String getName() {
			return "Theodor Est";
		}

		@Override
		public String getStreet() {
			return "Bahnstr. 42";
		}

		@Override
		public String getVATID() {
			return "DE999999999";
		}

		@Override
		public String getZIP() {
			return "88802";
		}
	}

	class Item implements IZUGFeRDExportableItem {

		public Item(BigDecimal price, BigDecimal quantity, Product product) {
			super();
			this.price = price;
			this.quantity = quantity;
			this.product = product;
		}

		private BigDecimal price, quantity;
		private Product product;

		@Override
		public BigDecimal getPrice() {
			return price;
		}

		public void setPrice(BigDecimal price) {
			this.price = price;
		}

		@Override
		public BigDecimal getQuantity() {
			return quantity;
		}

		public void setQuantity(BigDecimal quantity) {
			this.quantity = quantity;
		}

		@Override
		public Product getProduct() {
			return product;
		}

		public void setProduct(Product product) {
			this.product = product;
		}

		@Override
		public IZUGFeRDAllowanceCharge[] getItemAllowances() {
			return null;
		}

		@Override
		public IZUGFeRDAllowanceCharge[] getItemCharges() {
			return null;
		}

	}

	class Product implements IZUGFeRDExportableProduct {
		private String description, name, unit;
		private BigDecimal VATPercent;

		public Product(String description, String name, String unit, BigDecimal VATPercent) {
			super();
			this.description = description;
			this.name = name;
			this.unit = unit;
			this.VATPercent = VATPercent;
		}

		@Override
		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		@Override
		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		@Override
		public String getUnit() {
			return unit;
		}

		public void setUnit(String unit) {
			this.unit = unit;
		}

		@Override
		public BigDecimal getVATPercent() {
			return VATPercent;
		}

		public void setVATPercent(BigDecimal VATPercent) {
			this.VATPercent = VATPercent;
		}

	}

	/**
	 * Create the test case
	 *
	 * @param testName
	 *            name of the test case
	 */
	public MustangReaderWriterTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(MustangReaderWriterTest.class);
	}

	// //////// TESTS
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The importer test imports from
	 * ./src/test/MustangGnuaccountingBeispielRE-20170509_505.pdf to check the
	 * values. --> as only Name Ascending is supported for Test Unit sequence, I
	 * renamed the this test-A-Export to run before testZExport
	 *
	 * @throws IOException
	 */

	public void testAImport() throws IOException {
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		try (InputStream inputStream = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505.pdf")) {
			zi.extractLowLevel(inputStream);
		}

		// Reading ZUGFeRD

		String amount = null;
		String bic = null;
		String iban = null;
		String holder = null;
		String ref = null;

		if (zi.canParse()) {
			zi.parse();
			amount = zi.getAmount();
			bic = zi.getBIC();
			iban = zi.getIBAN();
			holder = zi.getHolder();
			ref = zi.getForeignReference();
		}
		// this resembles the data written in MustangReaderWriterCustomXMLTest
		assertEquals(amount, "571.04");
		assertEquals(bic, "COBADEFFXXX");
		assertEquals(iban, "DE88 2008 0000 0970 3757 00");
		assertEquals(holder, "Bei Spiel GmbH");
		assertEquals(ref, "RE-20170509/505");

	}

	public void testForeignImport() throws IOException {
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		
		try (InputStream inputStream = this.getClass()
				.getResourceAsStream("/zugferd_invoice.pdf")) {
			zi.extractLowLevel(inputStream);
		}
		// Reading ZUGFeRD

		String	amount = zi.getAmount();
		
		// this resembles the data written in MustangReaderWriterCustomXMLTest
		assertEquals(amount, "1005.55");

	}
	


	public void testMigratePDFA1ToA3() throws IOException {
// just make sure there is no Exception
		InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20171118_506blanko.pdf");


		ZUGFeRDExporter ze = new ZUGFeRDExporterFromA1Factory().setAttachZUGFeRDHeaders(false).load(SOURCE_PDF);

		File tempFile = File.createTempFile("ZUGFeRD-", "-test");
		ze.export(tempFile.getName());
		tempFile.deleteOnExit();
	}

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20140703_502blanko.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values. It would not make sense to have it run before the less complex
	 * importer test (which is probably redundant) --> as only Name Ascending is
	 * supported for Test Unit sequence, I renamed the Exporter Test test-Z-Export
	 */
	public void testZExport() throws Exception {

		final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20171118_506new.pdf";

		// the writing part
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20171118_506blanko.pdf");

				ZUGFeRDExporter ze = new ZUGFeRDExporterFromA1Factory().setZUGFeRDVersion(2).setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel.EN16931).load(SOURCE_PDF)) {

			ze.PDFattachZugferdFile(this);
			ze.disableAutoClose(true);
			ze.export(TARGET_PDF);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ze.export(baos);
			ze.close();
			String pdfContent = baos.toString("UTF-8");
			assertFalse(pdfContent.indexOf("(via mustangproject.org") == -1);
			// check for pdf-a schema extension
			assertFalse(pdfContent.indexOf("<fx:ConformanceLevel>EN 16931</fx:ConformanceLevel>") == -1);
			assertFalse(pdfContent.indexOf("<pdfaSchema:prefix>fx</pdfaSchema:prefix>") == -1);
			assertFalse(pdfContent.indexOf("urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:en16931") == -1);
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.extract(TARGET_PDF);
		// Reading ZUGFeRD

		String amount = null;
		String bic = null;
		String iban = null;
		String holder = null;
		String ref = null;
		if (zi.canParse()) {
			zi.parse();
			amount = zi.getAmount();
			bic = zi.getBIC();
			iban = zi.getIBAN();
			holder = zi.getHolder();
			ref = zi.getForeignReference();
		}

		assertEquals(amount, "571.04");
		assertEquals(bic, getOwnBIC());
		assertEquals(iban, getOwnIBAN());
		assertEquals(holder, getOwnOrganisationName());
		assertEquals(ref, getNumber());

	}

	/**
	 * @Test(expected = IndexOutOfBoundsException.class)
	 * @throws Exception
	 */
	public void testExceptionOnPDF14() throws Exception {

		final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20170509_505new.pdf";

		boolean exceptionThrown = false;
		// the writing part
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505PDF14.pdf");

				ZUGFeRDExporter ze = new ZUGFeRDExporterFromA1Factory().load(SOURCE_PDF)) {

			ze.PDFattachZugferdFile(this);
			ze.export(TARGET_PDF);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ze.export(baos);
		} catch (IOException ex) {
			// should throw a java.io.IOException: File is not a valid PDF/A-1 input file
			exceptionThrown = true;
		}
		assertTrue(exceptionThrown);

	}

}
