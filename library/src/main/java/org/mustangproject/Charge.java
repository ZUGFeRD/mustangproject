package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IAbsoluteValueProvider;
import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;

import java.math.BigDecimal;

/***
 * Absolute and relative charges for document and item level
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Charge implements IZUGFeRDAllowanceCharge {

	/**
	 * the percentage, null if not relative at all
	 */
	protected BigDecimal percent = null;
	/**
	 * the absolute value if not percentage
	 */
	protected BigDecimal totalAmount;
	/**
	 * the tax rate the charge belongs to
	 */
	protected BigDecimal taxPercent;
	/**
	 * a simple human readable description
	 */
	protected String reason;
	/**
	 * Code from list UNTDID 5189
	 */
	protected String reasonCode;
	/**
	 * the category ID why this charge has been applied
	 */
	protected String categoryCode;

	/***
	 * Bean connstructor
	 */
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


	/***
	 * sets the total amount to be changed to, e.g. if not specified via constructor
	 * @param totalAmount 2 decimal money amount
	 * @return fluid setter
	 */
	public Charge setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
		return this;
	}

	/***
	 * if relative charge: percent to increase the item
	 * @param percent as bigdecimal
	 * @return fluid setter
	 */
	public Charge setPercent(BigDecimal percent) {
		this.percent = percent;
		return this;
	}

	/***
	 * charges can be applied to VAT items, in which case they take the same VAT rate
	 * @param taxPercent the tax percentage on the charge
	 * @return fluid setter
	 */
	public Charge setTaxPercent(BigDecimal taxPercent) {
		this.taxPercent = taxPercent;
		return this;
	}


	@Override
	public String getReason() {
		return reason;
	}

	/***
	 * Freetext (?) reason for the charge
	 * @param reason freetext
	 * @return fluid setter
	 */
	public Charge setReason(String reason) {
		this.reason = reason;
		return this;
	}


	@Override
	public String getReasonCode() {
		return reasonCode;
	}

	/***
	 * Reason code for the charge
	 * @param reasonCode from list UNTDID 5189
	 * @return fluid setter
	 */
	public Charge setReasonCode(String reasonCode) {
		this.reasonCode = reasonCode;
		return this;
	}

	
	@Override
	public BigDecimal getTotalAmount(IAbsoluteValueProvider currentItem) {
		if (percent!=null) {
			return currentItem.getValue().multiply(getPercent().divide(new BigDecimal(100)));
		} else if(totalAmount != null) {
			return totalAmount;
		} else {
			throw new RuntimeException("percent must be set");
		}
	}

	public BigDecimal getTotalAmount() {
		if (totalAmount!=null) {
			return totalAmount;
		} else {
			throw new RuntimeException("totalAmount must be set");
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



	/***
	 * Always to return true  for IZUGFeRDAllowanceCharge
	 * @return true since it is supposed to be calculated negatively
	 */
	@Override
	@JsonIgnore
	public boolean isCharge() {
		return true;
	}

	@Override
	public String getCategoryCode() {
		if(categoryCode != null){
		    return categoryCode;
		}
		return IZUGFeRDAllowanceCharge.super.getCategoryCode();
	}


	/***
	 * the category ID why this has been applied
	 * @param categoryCode usually S
	 * @return fluid setter
	 */
	public Charge setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
		return this;
	}
}
