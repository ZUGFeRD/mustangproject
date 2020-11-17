package org.mustangproject;

import org.mustangproject.ZUGFeRD.IAbsoluteValueProvider;
import org.mustangproject.ZUGFeRD.IExportableTransaction;
import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;

import java.math.BigDecimal;

public class Charge implements IZUGFeRDAllowanceCharge {

	protected BigDecimal percent = null;
	protected BigDecimal totalAmount;
	protected BigDecimal taxPercent;
	protected String reason;
	protected String categoryCode;

	public Charge() {
		taxPercent=BigDecimal.ZERO;
	}

	/***
	 * creates a item level or invoice level charge
	 * @param totalAmount (the absolute amount)
	 */
	public Charge(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
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
	public BigDecimal getTotalAmount(IAbsoluteValueProvider currentItem) {
		if (totalAmount!=null) {
			return totalAmount;
		} else if (percent!=null) {
			return currentItem.getValue().multiply(getPercent().divide(new BigDecimal(100)));
		} else {
			throw new RuntimeException("Either totalAmount or percent must be set");
		}
	}


	@Override
	public BigDecimal getPercent() {
		return percent;
	}

	@Override
	public BigDecimal getTaxPercent() {
		return taxPercent;
	}

	@Override
	public boolean isCharge() {
		return true;
	}



	public Charge setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
		return this;
	}
}
