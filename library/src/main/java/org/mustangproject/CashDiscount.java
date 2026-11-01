package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IZUGFeRDCashDiscount;

import static org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat.DATE;

import java.math.BigDecimal;
import java.util.Date;

/***
 * A class to represent discounts for early payments ("Skonto")
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class CashDiscount implements IZUGFeRDCashDiscount {

	/***
	 * the reduction percent allowed in the period
	 */
	protected BigDecimal percent;
	/***
	 * the period (usually days) count how long the percent apply
	 */
	protected Integer days;

	protected Date dueDate;

	/**
	 * The actual discount amount
	 */
	protected BigDecimal actualAmount;

	/**
	 * The original payment amount
	 */
	protected BigDecimal basisAmount;

	/**
	 * The original payment date
	 */
	protected Date basisDateTime;

	/***
	 * Create a cash discount (skonto) with the specified height in the specified period.
	 * Should someone add more period types than just "days" there
	 * is be space for a (optional) third parameter
	 *
	 * @param percent max 3 decimals "behind the dot", more precision is currently ignored
	 * @param days the count of the periods (usually days) the percentage applies
	 */
	public CashDiscount(BigDecimal percent, int days) {
		this.percent = percent;
		this.days = days;
	}

	/***
	 * bean constructor
	 */
	public CashDiscount() {

	}

	/***
	 * how much this discount removed from the original dept
	 * @return the percent
	 */
	public BigDecimal getPercent() {
		return percent;
	}

	public CashDiscount setPercent(BigDecimal percent) {
		this.percent = percent;
		return this;
	}

	/***
	 * get the number of calendar days this cash discount is valid
	 * @return the number (integer) of days
	 */
	public Integer getDays() {
		return days;
	}

	/***
	 * the number this cash discount holds valid
	 * @param days the number of days
	 * @return fluent setter
	 */
	public CashDiscount setDays(Integer days) {
		this.days = days;
		return this;
	}

	public CashDiscount setDueDate(Date dueDate) {
		this.dueDate = dueDate;
		return this;
	}

	public Date getDueDate() {
		return dueDate;
	}

	/***
	 * get the amount of this cash discount
	 * @return amount
	 */
	public BigDecimal getActualAmount() {
		return actualAmount;
	}

	/***
	 * set the amount of this cash discount
	 * @param actualAmount the amount
	 * @return fluent setter
	 */
	public CashDiscount setActualAmount(BigDecimal actualAmount) {
		this.actualAmount = actualAmount;
		return this;
	}

	/***
	 * get the amount upon which the cash discount is applied
	 * @return money amount
	 */
	public BigDecimal getBasisAmount() {
		return basisAmount;
	}

	/***
	 * set the amount on which the cash discount is applied
	 * @param basisAmount the money amount
	 * @return fluent setter
	 */
	public CashDiscount setBasisAmount(BigDecimal basisAmount) {
		this.basisAmount = basisAmount;
		return this;
	}

	/***
	 * get the date upon which the cash discount date is calculated
	 * @return the base date
	 */
	public Date getBasisDateTime() {
		return basisDateTime;
	}

	/***
	 * set the date on which the cash discount date is calculated
	 * @param basisDateTime the date value
	 * @return fluent setter
	 */
	public CashDiscount setBasisDateTime(Date basisDateTime) {
		this.basisDateTime = basisDateTime;
		return this;
	}

	/***
	 * @return this particular cash discount as cross industry invoice XML
	 */
	@JsonIgnore
	public String getAsCII() {
		StringBuilder sb = new StringBuilder();
		sb.append("<ram:SpecifiedTradePaymentTerms>");
		sb.append("<ram:Description>Cash Discount</ram:Description>");
		if (dueDate != null) {
			sb.append("<ram:DueDateDateTime>" + DATE.udtFormat(dueDate) + "</ram:DueDateDateTime>");
		}
		sb.append("<ram:ApplicableTradePaymentDiscountTerms>");
		if (basisDateTime != null) {
			sb.append("<ram:BasisDateTime>" + DATE.udtFormat(basisDateTime) + "</ram:BasisDateTime>");
		}
		sb.append("<ram:BasisPeriodMeasure unitCode=\"DAY\">" + days + "</ram:BasisPeriodMeasure>");
		if (basisAmount != null) {
			sb.append("<ram:BasisAmount>" + XMLTools.nDigitFormat(basisAmount, 2) + "</ram:BasisAmount>");
		}
		sb.append("<ram:CalculationPercent>" + XMLTools.nDigitFormat(percent, 3) + "</ram:CalculationPercent>");
		if (actualAmount != null) {
			sb.append("<ram:ActualDiscountAmount>" + XMLTools.nDigitFormat(actualAmount, 2) + "</ram:ActualDiscountAmount>");
		}
		sb.append("</ram:ApplicableTradePaymentDiscountTerms>");
		sb.append("</ram:SpecifiedTradePaymentTerms>");
		return sb.toString();
	}

	/***
	 * since EN16931 voted not to have (or even allow) cash discounts in their core invoice the german
	 * XRechnung CIUS defined it's own proprietary format for a freetext field
	 * @return this particular cash discount in proprietary xrechnung format
	 */
	@JsonIgnore
	public String getAsXRechnung() {
		return "#SKONTO#TAGE=" + days + "#PROZENT=" + XMLTools.nDigitFormat(percent, 2) + "#\n";
	}
}
