package org.mustangproject.ZUGFeRD;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.bind.JAXBException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.xmpbox.type.BadFieldValueException;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.xml.sax.SAXException;

public class MustangReaderWriterTest {

	@Rule
	public final TemporaryFolder tempFolderRule = new TemporaryFolder();


	/**
	 * The importer test imports from ./src/test/MustangGnuaccountingBeispielRE-20151008_504.pdf to check the values. --> as only Name Ascending is supported
	 * for Test Unit sequence, I renamed the this test-A-Export to run before testZExport
	 *
	 * @throws IOException
	 * @throws ParseException
	 * @throws SAXException
	 * @throws ParserConfigurationException
	 */
	@Test
	public void testAImport() throws IOException, ParseException, ParserConfigurationException, SAXException {
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		InputStream inputStream = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20151008_504.pdf");
		zi.extractLowLevel(inputStream);
		// Reading ZUGFeRD

		if (!zi.canParse()) {
			throw new ParseException("Can't parse XML-File.", 0);
		}

		// parse XML
		zi.parse();

		Transaction trans = new Transaction();
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), trans.getOwnBIC());
		assertEquals(zi.getIBAN(), trans.getOwnIBAN());
		assertEquals(zi.getHolder(), trans.getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), trans.getNumber());
	}


	/**
	 * The exporter test bases on @{code ./src/test/MustangGnuaccountingBeispielRE-20140703_502blanko.pdf}, adds metadata, writes to @{code ./target/testout-*}
	 * and then imports to check the values. It would not make sense to have it run before the less complex importer test (which is probably redundant) --> as
	 * only Name Ascending is supported for Test Unit sequence, I renamed the Exporter Test test-Z-Export
	 *
	 * @throws IOException
	 * @throws BadFieldValueException
	 * @throws TransformerException
	 * @throws JAXBException
	 * @throws ParseException
	 * @throws SAXException
	 * @throws ParserConfigurationException
	 */
	@Test
	public void testZExport()
			throws IOException, TransformerException, BadFieldValueException, JAXBException, ParseException, ParserConfigurationException, SAXException {

		Transaction trans = new Transaction();
		File TARGET_PDF = tempFolderRule.newFile("testout-MustangGnuaccountingBeispielRE-20151008_504new.pdf");
		String TARGET_PDF_PATH = TARGET_PDF.getAbsolutePath();

		// the writing part
		try (InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20151008_504blanko.pdf")) {
			// automatically add Zugferd to all outgoing invoices
			ZUGFeRDExporter ze = new ZUGFeRDExporter();
			ze.createPDFmakeA3compliant(SOURCE_PDF, "My Application", System.getProperty("user.name"), true);
			ze.createPDFattachZUGFeRDFile(trans);
			ze.export(TARGET_PDF_PATH);
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.extract(TARGET_PDF_PATH);

		// Reading ZUGFeRD
		if (!zi.canParse()) {
			throw new ParseException("Can't parse XML-File.", 0);
		}

		// parse XML
		zi.parse();

		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), trans.getOwnBIC());
		assertEquals(zi.getIBAN(), trans.getOwnIBAN());
		assertEquals(zi.getHolder(), trans.getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), trans.getNumber());
	}

	private class Transaction implements IZUGFeRDExportableTransaction {
		@Override
		public Date getDeliveryDate() {
			return new GregorianCalendar(2014, Calendar.JULY, 3).getTime();
		}


		@Override
		public Date getDueDate() {
			return new GregorianCalendar(2014, Calendar.JULY, 24).getTime();
		}


		@Override
		public Date getIssueDate() {
			return new GregorianCalendar(2014, Calendar.JULY, 3).getTime();
		}


		@Override
		public String getNumber() {
			return "RE-20151008/504";
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
			Product designProduct = new Product("", "Künstlerische Gestaltung (Stunde)", "HUR", new BigDecimal("7.000000"));
			Product balloonProduct = new Product("", "Luftballon", "C62", new BigDecimal("19.000000"));
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
			// throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
		}


		@Override
		public IZUGFeRDAllowanceCharge[] getZFCharges() {
			return null;
			// throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
		}


		@Override
		public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
			return null;
			// throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
		}
	}

	private class Contact implements IZUGFeRDExportableContact {

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

	private class Item implements IZUGFeRDExportableItem {

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

	private class Product implements IZUGFeRDExportableProduct {

		private String description, name, unit;
		private BigDecimal vatPercent;


		public Product(String description, String name, String unit, BigDecimal vatPercent) {
			super();
			this.description = description;
			this.name = name;
			this.unit = unit;
			this.vatPercent = vatPercent;
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
			return vatPercent;
		}


		public void setVATPercent(BigDecimal vATPercent) {
			vatPercent = vATPercent;
		}

	}
}
