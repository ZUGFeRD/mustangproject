package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;

import java.math.BigDecimal;

public class Charge implements IZUGFeRDAllowanceCharge {
	protected String reason;
	protected BigDecimal totalAmount;
	protected BigDecimal taxPercent;
	protected String categoryCode;

	public Charge(BigDecimal totalAmount, BigDecimal taxPercent, String categoryCode, String reason) {
		this.totalAmount=totalAmount;
		this.taxPercent=taxPercent;
		this.categoryCode=categoryCode;
		this.reason=reason;
	}

	@Override
	public String getReason() {
		return reason;
	}

	public Charge setReason(String reason) {
		this.reason = reason;
		return this;
	}

	@Override
	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public Charge setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
		return this;
	}

	@Override
	public BigDecimal getTaxPercent() {
		return taxPercent;
	}

	public Charge setTaxPercent(BigDecimal taxPercent) {
		this.taxPercent = taxPercent;
		return this;
	}

	@Override
	public String getCategoryCode() {
		return categoryCode;
	}

	public Charge setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
		return this;
	}
}
