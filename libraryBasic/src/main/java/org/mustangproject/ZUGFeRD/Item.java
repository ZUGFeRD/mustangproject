package org.mustangproject.ZUGFeRD;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;

import java.math.BigDecimal;

public class Item implements IZUGFeRDExportableItem {
	protected BigDecimal price, quantity;
	protected Product product;

	public Item(Product product, BigDecimal price, BigDecimal quantity) {
		this.price = price;
		this.quantity = quantity;
		this.product = product;
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
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemCharges() {
		return null;
	}

	public Item setProduct(Product product) {
		this.product = product;
		return this;
	}
}
