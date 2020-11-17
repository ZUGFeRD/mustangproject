package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;

import java.math.BigDecimal;

/***
 * describes a product, good or service used in an invoice item line
 */
public class Product implements IZUGFeRDExportableProduct {
	protected String unit, name, description, sellerAssignedID, buyerAssignedID;
	protected BigDecimal VATPercent;

	/***
	 * default constructor
	 * @param name product short name
	 * @param description product long name
	 * @param unit a two/three letter UN/ECE rec 20 unit code, e.g. "C62" for piece
	 * @param VATPercent product vat rate
	 */
	public Product(String name, String description, String unit, BigDecimal VATPercent) {
		this.unit = unit;
		this.name = name;
		this.description = description;
		this.VATPercent = VATPercent;
	}


	public String getSellerAssignedID() {
		return sellerAssignedID;
	}

	/***
	 * how the seller identifies this type of product
	 * @param sellerAssignedID a unique String
	 * @return fluent setter
	 */
	public Product setSellerAssignedID(String sellerAssignedID) {
		this.sellerAssignedID = sellerAssignedID;
		return this;
	}

	public String getBuyerAssignedID() {
		return buyerAssignedID;
	}

	/***
	 * if the buyer provided an ID how he refers to this product
	 * @param buyerAssignedID a string the buyer provided
	 * @return fluent setter
	 */
	public Product setBuyerAssignedID(String buyerAssignedID) {
		this.buyerAssignedID = buyerAssignedID;
		return this;
	}

	@Override
	public String getUnit() {
		return unit;
	}

	/***
	 * sets a UN/ECE rec 20 or 21 code which unit the product ships in, e.g. C62=piece
	 * @param unit 2-3 letter UN/ECE rec 20 or 21
	 * @return fluent setter
	 */
	public Product setUnit(String unit) {
		this.unit = unit;
		return this;
	}

	@Override
	public String getName() {
		return name;
	}

	/**
	 * name of the product
	 * @param name short name
	 * @return fluent setter
	 */
	public Product setName(String name) {
		this.name = name;
		return this;
	}

	@Override
	public String getDescription() {
		return description;
	}

	/**
	 * description of the product (required)
	 * @param description long name
	 * @return fluent setter
	 */
	public Product setDescription(String description) {
		this.description = description;
		return this;
	}

	@Override
	public BigDecimal getVATPercent() {
		return VATPercent;
	}

	/****
	 * VAT rate of the product
	 * @param VATPercent vat rate of the product
	 * @return fluent setter
	 */
	public Product setVATPercent(BigDecimal VATPercent) {
		this.VATPercent = VATPercent;
		return this;
	}
}
