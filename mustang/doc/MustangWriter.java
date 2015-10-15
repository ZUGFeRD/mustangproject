package zugferd;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Calendar;

import javax.xml.transform.TransformerException;

import org.apache.pdfbox.exceptions.COSVisitorException;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableTransaction;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;

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
	private BigDecimal price,  quantity;

	public Item(BigDecimal price, BigDecimal quantity, Product product) {
		super();
		this.price = price;
		this.quantity = quantity;
		this.product = product;
	}

	private Product product;

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	
	public BigDecimal getQuantity() {
		return quantity;
	}

	public void setQuantity(BigDecimal quantity) {
		this.quantity = quantity;
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

	public Product(String description, String name, String unit,
			BigDecimal VATPercent) {
		super();
		this.description = description;
		this.name = name;
		this.unit = unit;
		this.VATPercent = VATPercent;
	}

	private BigDecimal VATPercent;

	@Override
	public String getDescription() {
		return description;
	}

	@Override
	public String getName() {
		return name;
	}

	@Override
	public String getUnit() {
		return unit;
	}

	@Override
	public BigDecimal getVATPercent() {
		return VATPercent;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public void setVATPercent(BigDecimal vATPercent) {
		VATPercent = vATPercent;
	}
}

public class MustangWriter implements IZUGFeRDExportableTransaction {

	public static void main(String[] args) {
		MustangWriter w=new MustangWriter();
		w.apply();
	}

	@Override
	public Date getDeliveryDate() {
		return new GregorianCalendar(2015, Calendar.OCTOBER, 7).getTime();
	}

	@Override
	public Date getDueDate() {
		return new GregorianCalendar(2015, Calendar.OCTOBER, 29).getTime();
	}

	@Override
	public Date getIssueDate() {
		return new GregorianCalendar(2015, Calendar.OCTOBER, 8).getTime();
	}

	@Override
	public String getNumber() {
		return "RE-20151008/504";
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
	public IZUGFeRDExportableItem[] getZFItems() {
		Item[] allItems = new Item[3];
		Product designProduct = new Product("",
				"Künstlerische Gestaltung (Stunde)", "HUR", new BigDecimal(
						"7.000000"));
		Product balloonProduct = new Product("", "Luftballon", "C62",
				new BigDecimal("19.000000"));
		Product airProduct = new Product("", "Heiße Luft pro Liter", "LTR",
				new BigDecimal("19.000000"));
		allItems[0] = new Item(new BigDecimal("160"), 
				new BigDecimal("1"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"),
				new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), 
				new BigDecimal("200"), airProduct);
		return allItems;
	}

	private void apply() {
		PDDocument doc;
		try {
			System.out.println("Reading blank PDF");
			doc = PDDocument
					.load("/Users/jstaerk/workspace/zugferd/MustangGnuaccountingBeispielRE-20151008_504blanko.pdf");
			ZUGFeRDExporter ze = new ZUGFeRDExporter();
			System.out.println("Converting to PDF/A-3u");
			ze.PDFmakeA3compliant(doc, "Mustangproject",
					System.getProperty("user.name"), true);
			System.out.println("Generating and attaching ZUGFeRD-Data");
			ze.setTest();
			ze.PDFattachZugferdFile(doc, this);
			System.out.println("Writing ZUGFeRD-PDF");

			doc.save("/Users/jstaerk/workspace/zugferd/MustangGnuaccountingBeispielRE-20151008_504.pdf");
			System.out.println("Done.");
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		} catch (COSVisitorException e) {
			e.printStackTrace();
		}
	}

	@Override
	public String getOwnOrganisationFullPlaintextInfo() {
		return "Bei Spiel GmbH\n"
				+ "Ecke 12\n"
				+ "12345 Stadthausen\n"
				+ "Geschäftsführer: Max Mustermann";
	}

}
