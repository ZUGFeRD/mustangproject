package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;

import java.math.BigDecimal;
import java.util.ArrayList;

/***
 * describes any invoice line
 */
public class Item implements IZUGFeRDExportableItem {
	protected BigDecimal price, quantity, tax, grossPrice, lineTotalAmount;
	protected String id;
	protected Product product;
	protected ArrayList<String> notes = null;
	protected ArrayList<IZUGFeRDAllowanceCharge> Allowances = new ArrayList<IZUGFeRDAllowanceCharge>(),
			Charges = new ArrayList<IZUGFeRDAllowanceCharge>();

	/***
	 * default constructor
	 * @param product contains the products name, tax rate, and unit
	 * @param price the base price of one item the product
	 * @param quantity the number, dimensions or the weight of the delivered product or good in this context
	 */
	public Item(Product product, BigDecimal price, BigDecimal quantity) {
		this.price = price;
		this.quantity = quantity;
		this.product = product;
	}

	public BigDecimal getLineTotalAmount() {
		return lineTotalAmount;
	}

	/**
	 * should only be set by calculator classes or maybe when reading from XML
	 * @param lineTotalAmount
	 * @return
	 */
	public Item setLineTotalAmount(BigDecimal lineTotalAmount) {
		this.lineTotalAmount = lineTotalAmount;
		return this;
	}

	public BigDecimal getGrossPrice() {
		return grossPrice;
	}


	/***
	 * the list price without VAT (sic!), refer to EN16931-1 for definition
	 * @return
	 */
	public Item setGrossPrice(BigDecimal grossPrice) {
		this.grossPrice = grossPrice;
		return this;
	}

	public BigDecimal getTax() {
		return tax;
	}

	public Item setTax(BigDecimal tax) {
		this.tax = tax;
		return this;
	}

	public Item setId(String id) {
		this.id = id;
		return this;
	}

	public String getId() {
		return id;
	}

	@Override
	public BigDecimal getPrice() {
		return price;
	}

	public Item setPrice(BigDecimal price) {
		this.price = price;
		return this;
	}



	@Override
	public BigDecimal getQuantity() {
		return quantity;
	}

	public Item setQuantity(BigDecimal quantity) {
		this.quantity = quantity;
		return this;
	}

	@Override
	public Product getProduct() {
		return product;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemAllowances() {
		if (Allowances.isEmpty()) {
			return null;
		} else
			return Allowances.toArray(new IZUGFeRDAllowanceCharge[0]);
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemCharges() {
		if (Charges.isEmpty()) {
			return null;
		} else
			return Charges.toArray(new IZUGFeRDAllowanceCharge[0]);
	}



	@Override
	public String[] getNotes() {
		if (notes==null) {
			return null;
		}
		return notes.toArray(new String[0]);
	}

	public Item setProduct(Product product) {
		this.product = product;
		return this;
	}


	public Item addCharge(IZUGFeRDAllowanceCharge izac) {
		Charges.add(izac);
		return this;
	}

	public Item addAllowance(IZUGFeRDAllowanceCharge izac) {
		Allowances.add(izac);
		return this;
	}

	/***
	 * adds item level freetext fields (includednote)
	 * @param text
	 * @return
	 */
	public Item addNote(String text) {
		if (notes==null) {
			notes=new ArrayList<String>();
		}
		notes.add(text);
		return this;
	}


}
