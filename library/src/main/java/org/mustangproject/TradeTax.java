	package org.mustangproject;

import java.math.BigDecimal;
import java.util.Date;

import org.mustangproject.ZUGFeRD.IZUGFeRDTradeTax;


/***
 * Absolute and relative charges for document and item level
 * <xs:complexType name="TradeTaxType">
 *   <xs:sequence>
 *     <xs:element name="CalculatedAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="TypeCode" type="qdt:TaxTypeCodeType"/>
 *     <xs:element name="ExemptionReason" type="udt:TextType" minOccurs="0"/>
 *     <xs:element name="BasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="LineTotalBasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="AllowanceChargeBasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="CategoryCode" type="qdt:TaxCategoryCodeType"/>
 *     <xs:element name="ExemptionReasonCode" type="udt:CodeType" minOccurs="0"/>
 *     <xs:element name="TaxPointDate" type="udt:DateType" minOccurs="0"/>
 *     <xs:element name="DueDateTypeCode" type="qdt:TimeReferenceCodeType" minOccurs="0"/>
 *     <xs:element name="RateApplicablePercent" type="udt:PercentType" minOccurs="0"/>
 *   </xs:sequence>
 * </xs:complexType>
 */
public class TradeTax implements IZUGFeRDTradeTax {
	/**
	 * the value
	 */
	private BigDecimal taxCalculatedAmount;

	/**
	 * a simple human readable description
	 */
	private String taxExemptionReason;

	/**
	 * the value the percentage is applied upon
	 */
	private BigDecimal taxBasisAmount;

	/**
	 * the value the lines the percentage is applied upon
	 */
	private BigDecimal taxLineTotalBasisAmount;

	/**
	 * the value the lines the percentage is applied upon
	 */
	private BigDecimal taxAllowanceChargeBasisAmount;

	/**
	 * the category ID why this charge has been applied
	 */
	private String taxCategoryCode;

	/***
	 * the taxExemptionReasonCode, https://docs.peppol.eu/poacc/billing/3.0/codelist/vatex/
	 */
	private String taxExemptionReasonCode;

	/***
	 * the tax date
	 */
	private Date taxPointDate;

	/***
	 * the type code for the due date
	 */
	private String taxDueDateTypeCode;

	/**
	 * the tax rate percent value
	 */
	private BigDecimal taxRateApplicablePercent;


	/**
	 * @return the taxCalculatedAmount
	 */
	@Override
	public BigDecimal getTaxCalculatedAmount() {
		return taxCalculatedAmount;
	}

	/**
	 * @param taxCalculatedAmount the taxCalculatedAmount to set
	 */
	public TradeTax setTaxCalculatedAmount(BigDecimal taxCalculatedAmount) {
		this.taxCalculatedAmount = taxCalculatedAmount;
		return this;
	}

	/**
	 * @return the taxExemptionReason
	 */
	@Override
	public String getTaxExemptionReason() {
		return taxExemptionReason;
	}

	/**
	 * @param taxExemptionReason the taxExemptionReason to set
	 */
	public TradeTax setTaxExemptionReason(String taxExemptionReason) {
		this.taxExemptionReason = taxExemptionReason;
		return this;
	}

	/**
	 * @return the taxBasisAmount
	 */
	@Override
	public BigDecimal getTaxBasisAmount() {
		return taxBasisAmount;
	}

	/**
	 * @param taxBasisAmount the taxBasisAmount to set
	 */
	public TradeTax setTaxBasisAmount(BigDecimal taxBasisAmount) {
		this.taxBasisAmount = taxBasisAmount;
		return this;
	}

	/**
	 * @return the taxLineTotalBasisAmount
	 */
	@Override
	public BigDecimal getTaxLineTotalBasisAmount() {
		return taxLineTotalBasisAmount;
	}

	/**
	 * @param taxLineTotalBasisAmount the taxLineTotalBasisAmount to set
	 */
	public TradeTax setTaxLineTotalBasisAmount(BigDecimal taxLineTotalBasisAmount) {
		this.taxLineTotalBasisAmount = taxLineTotalBasisAmount;
		return this;
	}

	/**
	 * @return the taxAllowanceChargeBasisAmount
	 */
	@Override
	public BigDecimal getTaxAllowanceChargeBasisAmount() {
		return taxAllowanceChargeBasisAmount;
	}

	/**
	 * @param taxAllowanceChargeBasisAmount the taxAllowanceChargeBasisAmount to set
	 */
	public TradeTax setTaxAllowanceChargeBasisAmount(BigDecimal taxAllowanceChargeBasisAmount) {
		this.taxAllowanceChargeBasisAmount = taxAllowanceChargeBasisAmount;
		return this;
	}

	/**
	 * @return the taxCategoryCode
	 */
	@Override
	public String getTaxCategoryCode() {
		if (taxCategoryCode != null) {
			return taxCategoryCode;
		}
		return IZUGFeRDTradeTax.super.getTaxCategoryCode();
	}

	/**
	 * @param taxCategoryCode the taxCategoryCode to set
	 */
	public TradeTax setTaxCategoryCode(String taxCategoryCode) {
		this.taxCategoryCode = taxCategoryCode;
		return this;
	}

	/**
	 * @return the exemptionReasonCode
	 */
	@Override
	public String getTaxExemptionReasonCode() {
		return taxExemptionReasonCode;
	}

	/**
	 * @param taxExemptionReasonCode the taxExemptionReasonCode to set
	 */
	public TradeTax setTaxExemptionReasonCode(String taxExemptionReasonCode) {
		this.taxExemptionReasonCode = taxExemptionReasonCode;
		return this;
	}

	/**
	 * @return the taxPointDate
	 */
	@Override
	public Date getTaxPointDate() {
		return taxPointDate;
	}

	/**
	 * @param taxPointDate the taxPointDate to set
	 */
	public TradeTax setTaxPointDate(Date taxPointDate) {
		this.taxPointDate = taxPointDate;
		return this;
	}

	/**
	 * @return the taxDueDateTypeCode
	 */
	@Override
	public String getTaxDueDateTypeCode() {
		return taxDueDateTypeCode;
	}

	/**
	 * @param taxDueDateTypeCode the taxDueDateTypeCode to set
	 */
	public TradeTax setTaxDueDateTypeCode(String taxDueDateTypeCode) {
		this.taxDueDateTypeCode = taxDueDateTypeCode;
		return this;
	}

	/**
	 * @return the taxRateApplicablePercent
	 */
	@Override
	public BigDecimal getTaxRateApplicablePercent() {
		return taxRateApplicablePercent;
	}

	/**
	 * @param taxRateApplicablePercent the taxRateApplicablePercent to set
	 */
	public TradeTax setTaxRateApplicablePercent(BigDecimal taxRateApplicablePercent) {
		this.taxRateApplicablePercent = taxRateApplicablePercent;
		return this;
	}
}
