package mustang15test;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableTransaction;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA1Factory;

public class MustangWriter implements IZUGFeRDExportableTransaction {

	public static void main(String[] args) {
		MustangWriter m1 = new MustangWriter();
		m1.apply();
	}

	private void apply() {
		try {
			System.out.println("Reading Blanko-PDF");
			ZUGFeRDExporter ze =
					new ZUGFeRDExporterFromA1Factory().setProducer("My Application").setCreator(System.getProperty("user.name")).load("./MustangGnuaccountingBeispielRE-20171118_506blanko.pdf");
			System.out.println("Generating and attaching ZUGFeRD-Data");
			ze.PDFattachZugferdFile(this);
			System.out.println("Writing ZUGFeRD-PDF");
			ze.export("./MustangGnuaccountingBeispielRE-20171118_506new.pdf");
			System.out.println("Done.");
		} catch (IOException e) {
			Logger.getLogger(MustangWriter.class.getName()).log(Level.SEVERE, null, e1);
		}
	}

	@Override
	public String getCurrency() {
		// TODO Auto-generated method stub
		return null;
	}

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
	public String getOwnOrganisationFullPlaintextInfo() {
		return "Bei Spiel GmbH\n" +
				"Ecke 12\n" +
				"12345 Stadthausen\n" +
				"Geschäftsführer: Max Mustermann";
	}

	@Override
	public String getOwnOrganisationName() {
		return "Bei Spiel GmbH";
	}

	@Override
	public String getOwnPaymentInfoText() {
		// TODO Auto-generated method stub
		return null;
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
	public String getPaymentTermDescription() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public IZUGFeRDExportableContact getRecipient() {

		return new Contact();
	}

	@Override
	public String getReferenceNumber() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		// TODO Auto-generated method stub
		return null;
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
	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		// TODO Auto-generated method stub
		return null;
	}

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

	@Override
	public IZUGFeRDAllowanceCharge[] getItemAllowances() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
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
