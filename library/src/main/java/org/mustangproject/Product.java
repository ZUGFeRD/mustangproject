package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;

import java.math.BigDecimal;

public class Product implements IZUGFeRDExportableProduct {
	protected String unit, name, description, sellerAssignedID, buyerAssignedID;
	protected BigDecimal VATPercent;

	public Product(String name, String description, String unit, BigDecimal VATPercent) {
		this.unit = unit;
		this.name = name;
		this.description = description;
		this.VATPercent = VATPercent;
	}


	public String getSellerAssignedID() {
		return sellerAssignedID;
	}

	public Product setSellerAssignedID(String sellerAssignedID) {
		this.sellerAssignedID = sellerAssignedID;
		return this;
	}

	public String getBuyerAssignedID() {
		return buyerAssignedID;
	}

	public Product setBuyerAssignedID(String buyerAssignedID) {
		this.buyerAssignedID = buyerAssignedID;
		return this;
	}

	@Override
	public String getUnit() {
		return unit;
	}

	public Product setUnit(String unit) {
		this.unit = unit;
		return this;
	}

	@Override
	public String getName() {
		return name;
	}

	public Product setName(String name) {
		this.name = name;
		return this;
	}

	@Override
	public String getDescription() {
		return description;
	}

	public Product setDescription(String description) {
		this.description = description;
		return this;
	}

	@Override
	public BigDecimal getVATPercent() {
		return VATPercent;
	}

	public Product setVATPercent(BigDecimal VATPercent) {
		this.VATPercent = VATPercent;
		return this;
	}
}
