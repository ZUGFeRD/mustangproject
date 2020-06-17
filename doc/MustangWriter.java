package mustangtest;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableTransaction;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA1Factory;

class Contact implements IZUGFeRDExportableContact {

	public String getCountry() {
		return "DE";
	}

	public String getLocation() {
		return "Spielkreis";
	}

	public String getName() {
		return "Theodor Est";
	}

	public String getStreet() {
		return "Bahnstr. 42";
	}

	public String getVATID() {
		return "DE999999999";
	}

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

	public IZUGFeRDAllowanceCharge[] getItemAllowances() {
		// TODO Auto-generated method stub
		return null;
	}

	public IZUGFeRDAllowanceCharge[] getItemCharges() {
		// TODO Auto-generated method stub
		return null;
	}
}

class Product implements IZUGFeRDExportableProduct {
	public Product(String description, String name, String unit, BigDecimal vATPercent) {
		super();
		this.description = description;
		this.name = name;
		this.unit = unit;
		VATPercent = vATPercent;
	}

	private String description, name, unit;
	private BigDecimal VATPercent;

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

public class MustangWriter implements IZUGFeRDExportableTransaction {

	private void apply() {
		try {
			System.out.println("Reading Blanko-PDF");
			ZUGFeRDExporter ze = new ZUGFeRDExporterFromA1Factory().setProducer("My Application")
					.setCreator(System.getProperty("user.name"))
					.load("./MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");
			System.out.println("Generating and attaching ZUGFeRD-Data");
			ze.PDFattachZugferdFile(this);
			System.out.println("Writing ZUGFeRD-PDF");
			ze.export("./MustangGnuaccountingBeispielRE-20170509_505new.pdf");
			System.out.println("Done.");
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public static void main(String[] args) {
		MustangWriter mw=new MustangWriter();
		mw.apply();
	}

	public String getCurrency() {
		return "EUR";
	}

	public Date getDeliveryDate() {
		return new GregorianCalendar(2017, Calendar.NOVEMBER, 17).getTime();
	}

	public Date getDueDate() {
		return new GregorianCalendar(2017, Calendar.DECEMBER, 9).getTime();
	}

	public Date getIssueDate() {
		return new GregorianCalendar(2017, Calendar.NOVEMBER, 18).getTime();
	}

	public String getNumber() {
		// TODO Auto-generated method stub
		return "RE-20171118/506";
	}

	public String getOwnBIC() {
		// TODO Auto-generated method stub
		return "COBADEFFXXX";
	}

	public String getOwnBankName() {
		// TODO Auto-generated method stub
		return "Commerzbank";
	}

	public String getOwnCountry() {
		// TODO Auto-generated method stub
		return "DE";
	}

	public String getOwnIBAN() {
		// TODO Auto-generated method stub
		return "DE88 2008 0000 0970 3757 00";
	}

	public String getOwnLocation() {
		// TODO Auto-generated method stub
		return "Stadthausen";
	}

	public String getOwnOrganisationFullPlaintextInfo() {
		// TODO Auto-generated method stub
		return "Bei Spiel GmbH\n" + "Ecke 12\n" + "12345 Stadthausen\n" + "GeschÃ¤ftsfÃ¼hrer: Max Mustermann";
	}

	public String getOwnOrganisationName() {
		// TODO Auto-generated method stub
		return "Bei Spiel GmbH";
	}

	public String getOwnPaymentInfoText() {
		// TODO Auto-generated method stub
		return null;
	}

	public String getOwnStreet() {
		return "Ecke 12";
	}

	public String getOwnTaxID() {
		return "22/815/0815/4";
	}

	public String getOwnVATID() {
		return "DE136695976";
	}

	public String getOwnZIP() {
		return "12345";
	}

	public String getPaymentTermDescription() {
		// TODO Auto-generated method stub
		return null;
	}

	public IZUGFeRDExportableContact getRecipient() {
		return new Contact();
	}

	public String getReferenceNumber() {
		// TODO Auto-generated method stub
		return null;
	}

	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		// TODO Auto-generated method stub
		return null;
	}

	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		// TODO Auto-generated method stub
		return null;
	}

	public IZUGFeRDExportableItem[] getZFItems() {
		Item[] allItems = new Item[3];
		Product designProduct = new Product("", "KÃ¼nstlerische Gestaltung (Stunde): Einer Beispielrechnung", "HUR",
				new BigDecimal("7.000000"));
		Product balloonProduct = new Product("", "Luftballon: Bunt, ca. 500ml", "C62", new BigDecimal("19.000000"));
		Product airProduct = new Product("", "HeiÃŸe Luft pro Liter", "LTR", new BigDecimal("19.000000"));
		allItems[0] = new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), new BigDecimal("200"), airProduct);
		return allItems;
	}

	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		// TODO Auto-generated method stub
		return null;
	}

}
