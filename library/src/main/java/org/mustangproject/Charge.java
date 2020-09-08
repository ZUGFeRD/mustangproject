package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;

import java.math.BigDecimal;

public class Charge implements IZUGFeRDAllowanceCharge {

	protected BigDecimal percent;
	protected BigDecimal totalAmount;
	protected BigDecimal taxPercent;
	protected String reason;
	protected String categoryCode;

	public Charge() {

	}

	public Charge(BigDecimal totalAmount, BigDecimal taxPercent, String reason, String categoryCode) {
		this.totalAmount = totalAmount;
		this.taxPercent = taxPercent;
		this.reason = reason;
		this.categoryCode = categoryCode;
	}


	public Charge setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
		return this;
	}

	public Charge setPercent(BigDecimal percent) {
		this.percent = percent;
		return this;
	}

	public Charge setTaxPercent(BigDecimal taxPercent) {
		this.taxPercent = taxPercent;
		return this;
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


	@Override
	public BigDecimal getTaxPercent() {
		return taxPercent;
	}


	public Charge setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
		return this;
	}
}
