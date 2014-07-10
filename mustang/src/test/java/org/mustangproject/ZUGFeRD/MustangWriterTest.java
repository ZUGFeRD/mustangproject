package org.mustangproject.ZUGFeRD;


import java.io.IOException;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.transform.TransformerException;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.jempbox.xmp.*;


public class MustangWriterTest extends TestCase implements IZUGFeRDExportableTransaction {

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
		return "RE-20140703/502";
	}

	@Override
	public String getOwnBIC() {
		return "COBADEFXXX";
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
	public BigDecimal getTotal() {
		return new BigDecimal("496.00");
	}

	@Override
	public BigDecimal getTotalGross() {
		return new BigDecimal("571.04");
	}

	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		Item[] allItems = new Item[3];
		Product designProduct = new Product("",
				"Künstlerische Gestaltung (Stunde)", "HUR", new BigDecimal(
						"7.000000"));
		Product balloonProduct = new Product("", "Luftballon", "C62",
				new BigDecimal("19.000000"));
		Product airProduct = new Product("", "Heiße Luft pro Liter", "LTR",
				new BigDecimal("19.000000"));

		allItems[0] = new Item(new BigDecimal("160"), new BigDecimal("171.20"),
				new BigDecimal("1"), new BigDecimal("171.20"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("0.94"),
				new BigDecimal("400"), new BigDecimal("376.04"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), new BigDecimal("0.12"),
				new BigDecimal("200"), new BigDecimal("23.80"), airProduct);
		return allItems;
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

		public Item(BigDecimal price, BigDecimal priceGross,
				BigDecimal quantity, BigDecimal totalGross, Product product) {
			super();
			this.price = price;
			this.priceGross = priceGross;
			this.quantity = quantity;
			this.totalGross = totalGross;
			this.product = product;
		}

		private BigDecimal price, priceGross, quantity, totalGross;
		private Product product;

		public BigDecimal getPrice() {
			return price;
		}

		public void setPrice(BigDecimal price) {
			this.price = price;
		}

		public BigDecimal getPriceGross() {
			return priceGross;
		}

		public void setPriceGross(BigDecimal priceGross) {
			this.priceGross = priceGross;
		}

		public BigDecimal getQuantity() {
			return quantity;
		}

		public void setQuantity(BigDecimal quantity) {
			this.quantity = quantity;
		}

		public BigDecimal getTotalGross() {
			return totalGross;
		}

		public void setTotalGross(BigDecimal totalGross) {
			this.totalGross = totalGross;
		}

		public Product getProduct() {
			return product;
		}

		public void setProduct(Product product) {
			this.product = product;
		}

	}

	class Product implements IZUGFeRDExportableProduct {
		private String description, name, unit;
		private BigDecimal VATPercent;

		public Product(String description, String name, String unit,
				BigDecimal VATPercent) {
			super();
			this.description = description;
			this.name = name;
			this.unit = unit;
			this.VATPercent = VATPercent;
		}

		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getUnit() {
			return unit;
		}

		public void setUnit(String unit) {
			this.unit = unit;
		}

		public BigDecimal getVATPercent() {
			return VATPercent;
		}

		public void setVATPercent(BigDecimal vATPercent) {
			VATPercent = vATPercent;
		}

	}

	private void apply() {
		PDDocument doc;
		try {
			System.out.println("Lese Blanko-PDF");
			doc = PDDocument
					.load("./src/test/MustangGnuaccountingBeispielRE-20140703_502blanko.pdf");
			// automatically add Zugferd to all outgoing invoices
			ZUGFeRDExporter ze = new ZUGFeRDExporter();
			System.out.println("Wandle in PDF/A-3u um");
			ze.PDFmakeA3compliant(doc, "My Application",
					System.getProperty("user.name"), true);
			System.out.println("ZUGFeRD-Daten generieren und anhängen");
			ze.PDFattachZugferdFile(doc, this);
			System.out.println("Schreibe ZUGFeRD-PDF");
			doc.save("./src/test/MustangGnuaccountingBeispielRE-20140703_502new.pdf");
			System.out.println("Fertig.");
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} 

	}
	
	/**
	 * Create the test case
	 * 
	 * @param testName
	 *            name of the test case
	 */
	public MustangWriterTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(MustangWriterTest.class);
	}



	public void testExport() {
		// generate ./src/test/MustangGnuaccountingBeispielRE-20140703_502new.pdf from ./src/test/MustangGnuaccountingBeispielRE-20140703_502blank.pdf:
		// the writing part
		apply();
		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.extract("./src/test/MustangGnuaccountingBeispielRE-20140703_502new.pdf");
		// Reading ZUGFeRD
		
		String amount=null;
		String bic=null;
		String iban=null;
		String holder=null;
		String ref=null;
		
		if (zi.canParse()) {
			zi.parse();
			amount=zi.getAmount();
			bic=zi.getBIC();
			iban=zi.getIBAN();
			holder=zi.getHolder();
			ref=zi.getForeignReference();
		}
		

		assertEquals(amount, "571.04");
		assertEquals(bic, "COBADEFXXX");
		assertEquals(iban, "DE88 2008 0000 0970 3757 00");
		assertEquals(holder, "Bei Spiel GmbH");
		assertEquals(ref, "RE-20140703/502");
		
		
	}

}
