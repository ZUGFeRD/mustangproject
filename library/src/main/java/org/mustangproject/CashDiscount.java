package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IZUGFeRDCashDiscount;

import java.math.BigDecimal;

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
	protected Integer days=null;

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
	 * bean contructor
	 */
	public CashDiscount() {

	}

	public BigDecimal getPercent() {
		return percent;
	}

	public CashDiscount setPercent(BigDecimal percent) {
		this.percent = percent;
		return this;
	}

	public Integer getDays() {
		return days;
	}

	public CashDiscount setDays(Integer days) {
		this.days = days;
		return this;
	}

	/***
	 * @return this particular cash discount as cross industry invoice XML
	 */
	public String getAsCII() {
		return  "<ram:SpecifiedTradePaymentTerms>"+
				"<ram:Description>Cash Discount</ram:Description>"+
				" <ram:ApplicableTradePaymentDiscountTerms>"+
          		"  <ram:BasisPeriodMeasure unitCode=\"DAY\">"+days+"</ram:BasisPeriodMeasure>"+
          		"  <ram:CalculationPercent>"+XMLTools.nDigitFormat(percent,3)+"</ram:CalculationPercent>"+
        		" </ram:ApplicableTradePaymentDiscountTerms>"+
      			"</ram:SpecifiedTradePaymentTerms>";
	}

	/***
	 * since EN16931 voted not to have (or even allow) cash discounts in their core invoice the german
	 * XRechnung CIUS defined it's own proprietary format for a freetext field
	 * @return this particular cash discount in proprietary xrechnung format
	 */
	public String getAsXRechnung() {
		return "#SKONTO#TAGE="+days+"#PROZENT="+XMLTools.nDigitFormat(percent,2)+"#\n";
	}




}
