package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;

import java.math.BigDecimal;

public class Item implements IZUGFeRDExportableItem {
	protected BigDecimal price, quantity, tax, grossPrice, lineTotalAmount;
	protected String id;
	protected Product product;

	public Item(Product product, BigDecimal price, BigDecimal quantity) {
		this.price = price;
		this.quantity = quantity;
		this.product = product;
	}

	public BigDecimal getLineTotalAmount() {
		return lineTotalAmount;
	}

	public Item setLineTotalAmount(BigDecimal lineTotalAmount) {
		this.lineTotalAmount = lineTotalAmount;
		return this;
	}

	public Item addCharge(IZUGFeRDAllowanceCharge charge) {
		//@todo
		return this;
	}

	public Item addAllowance(IZUGFeRDAllowanceCharge allowance) {
		//@todo
		return this;
	}

	public BigDecimal getGrossPrice() {
		return grossPrice;
	}

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
