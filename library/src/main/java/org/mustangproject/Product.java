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
	 * @param name
	 * @param description
	 * @param unit a two/three letter UN/ECE rec 20 unit code, e.g. "C62" for piece
	 * @param VATPercent
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
	 * @param sellerAssignedID
	 * @return
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
	 * @param buyerAssignedID
	 * @return
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
	 * @param unit
	 * @return
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
	 * @param name
	 * @return
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
	 * @param description
	 * @return
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
	 * @param VATPercent
	 * @return
	 */
	public Product setVATPercent(BigDecimal VATPercent) {
		this.VATPercent = VATPercent;
		return this;
	}
}
