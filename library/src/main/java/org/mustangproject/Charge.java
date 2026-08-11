package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IAbsoluteValueProvider;
import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;

import java.math.BigDecimal;
import java.math.RoundingMode;

/***
 * Absolute and relative charges for document and item level
 *
 * &lt;xs:complexType name="TradeAllowanceChargeType"&gt;
 *   &lt;xs:sequence&gt;
 *     &lt;xs:element name="ChargeIndicator" type="udt:IndicatorType"/&gt;
 *     &lt;xs:element name="SequenceNumeric" type="udt:NumericType" minOccurs="0"/&gt;
 *     &lt;xs:element name="CalculationPercent" type="udt:PercentType" minOccurs="0"/&gt;
 *     &lt;xs:element name="BasisAmount" type="udt:AmountType" minOccurs="0"/&gt;
 *     &lt;xs:element name="BasisQuantity" type="udt:QuantityType" minOccurs="0"/&gt;
 *     &lt;xs:element name="ActualAmount" type="udt:AmountType"/&gt;
 *     &lt;xs:element name="ReasonCode" type="qdt:AllowanceChargeReasonCodeType" minOccurs="0"/&gt;
 *     &lt;xs:element name="Reason" type="udt:TextType" minOccurs="0"/&gt;
 *     &lt;xs:element name="CategoryTradeTax" type="ram:TradeTaxType" minOccurs="0"/&gt;
 *   &lt;/xs:sequence&gt;
 * &lt;/xs:complexType&gt;
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Charge extends TradeTax<Charge> implements IZUGFeRDAllowanceCharge {

	protected Integer sequenceNumeric;

	/**
	 * the percentage, null if not relative at all
	 */
	protected BigDecimal percent;
	/**
	 * the absolute value if not percentage
	 */
	protected BigDecimal totalAmount;
	/**
	 * the value the percentage is applied upon
	 */
	protected BigDecimal basisAmount;
	/**
	 * the quantity the percentage is applied upon
	 */
	protected BigDecimal basisQuantity;
	/**
	 * a simple human readable description
	 */
	protected String reason;
	/**
	 * Code from list UNTDID 5189
	 */
	protected String reasonCode;

	/***
	 * Bean constructor
	 */
	public Charge() {
		setTaxRateApplicablePercent(BigDecimal.ZERO);
	}

	/***
	 * creates a item level or invoice level charge
	 * @param totalAmount (the absolute amount)
	 */
	public Charge(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
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

	/**
	 * @return the sequenceNumeric
	 */
	@Override
	public Integer getSequenceNumeric() {
		return sequenceNumeric;
	}

	/**
	 * @param sequenceNumeric the sequenceNumeric to set
	 */
	public void setSequenceNumeric(Integer sequenceNumeric) {
		this.sequenceNumeric = sequenceNumeric;
	}

	/**
	 * if relative charge: percent to increase the item
	 */
	@Override
	public BigDecimal getPercent() {
		return percent;
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

	@Override
	public BigDecimal getBasisAmount() {
		return basisAmount;
	}

	/***
	 * sets a potential basis for the potential percentage
	 * @param basis the basis amount
	 * @return fluid setter
	 */
	public Charge setBasisAmount(BigDecimal basis) {
		this.basisAmount = basis;
		return this;
	}

	@Override
	public BigDecimal getBasisQuantity() {
		return basisQuantity;
	}

	/***
	 * sets a potential basis for the potential percentage
	 * @param basis the basis quantity
	 * @return fluid setter
	 */
	public Charge setBasisQuantity(BigDecimal basis) {
		this.basisQuantity = basis;
		return this;
	}

	@Override
	public BigDecimal getTotalAmount(IAbsoluteValueProvider currentItem) {
		if (totalAmount != null) {
			return totalAmount;
		} else if (percent != null) {
			BigDecimal singlePrice = currentItem.getValue().multiply(BigDecimal.ONE.subtract(getPercent().divide(new BigDecimal(100), 18, RoundingMode.HALF_UP)));
			BigDecimal singlePriceDiff = currentItem.getValue().subtract(singlePrice);
			return singlePriceDiff.multiply(currentItem.getQuantity());

		} else {
			throw new RuntimeException("percent must be set");
		}
	}

	public BigDecimal getTotalAmount() {
		if (totalAmount != null) {
			return totalAmount;
		} else {
			if (percent == null) {
				throw new RuntimeException("totalAmount must be set");
			}
			return null;
		}
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
	 * Reason code for the charge
	 * @param reasonCode from list UNTDID 5189
	 * @return fluid setter
	 */
	public Charge setReasonCode(String reasonCode) {
		this.reasonCode = reasonCode;
		return this;
	}

	@Override
	public String getReasonCode() {
		return reasonCode;
	}

	@Override
	public String getReason() {
		return reason;
	}

	/***
	 * Freetext (?) reason for the charge
	 * @param reason free text
	 * @return fluid setter
	 */
	public Charge setReason(String reason) {
		this.reason = reason;
		return this;
	}

	/*
	 * for backward compatibility only
	 */
	/**
	 * @deprecated use getTaxRateApplicablePercent() instead.
	 */
	@SuppressWarnings("deprecation")
	@Deprecated(forRemoval = true, since = "2.24.1")
	@JsonIgnore
	@Override
	public BigDecimal getTaxPercent() {
		return getTaxRateApplicablePercent();
	}

	/**
	 * set the taxRateApplicablePercent.
	 * @deprecated use setTaxRateApplicablePercent(BigDecimal) instead.
	 * @param percent
	 * @return
	 */
	@Deprecated(forRemoval = true, since = "2.24.1")
	public Charge setTaxPercent(BigDecimal percent) {
		this.setTaxRateApplicablePercent(percent);
		return this;
	}

	/**
	 * @deprecated use getTaxCategoryCode() instead.
	 */
	@SuppressWarnings("deprecation")
	@Deprecated(forRemoval = true, since = "2.24.1")
	@JsonIgnore
	@Override
	public String getCategoryCode() {
		return getTaxCategoryCode();
	}

	/**
	 * @deprecated use setTaxCategoryCode(String) instead.
	 * @param taxCategoryCode
	 * @return
	 */
	@Deprecated(forRemoval = true, since = "2.24.1")
	public Charge setCategoryCode(String taxCategoryCode) {
		this.setTaxCategoryCode(taxCategoryCode);
		return this;
	}
}
