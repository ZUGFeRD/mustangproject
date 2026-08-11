	package org.mustangproject;

import java.math.BigDecimal;
import java.util.Date;

import org.mustangproject.ZUGFeRD.IZUGFeRDTradeTax;


/***
 * Absolute and relative charges for document and item level
 * &lt;xs:complexType name="TradeTaxType"&gt;
 *   &lt;xs:sequence&gt;
 *     &lt;xs:element name="CalculatedAmount" type="udt:AmountType" minOccurs="0"/&gt;
 *     &lt;xs:element name="TypeCode" type="qdt:TaxTypeCodeType"/&gt;
 *     &lt;xs:element name="ExemptionReason" type="udt:TextType" minOccurs="0"/&gt;
 *     &lt;xs:element name="BasisAmount" type="udt:AmountType" minOccurs="0"/&gt;
 *     &lt;xs:element name="LineTotalBasisAmount" type="udt:AmountType" minOccurs="0"/&gt;
 *     &lt;xs:element name="AllowanceChargeBasisAmount" type="udt:AmountType" minOccurs="0"/&gt;
 *     &lt;xs:element name="CategoryCode" type="qdt:TaxCategoryCodeType"/&gt;
 *     &lt;xs:element name="ExemptionReasonCode" type="udt:CodeType" minOccurs="0"/&gt;
 *     &lt;xs:element name="TaxPointDate" type="udt:DateType" minOccurs="0"/&gt;
 *     &lt;xs:element name="DueDateTypeCode" type="qdt:TimeReferenceCodeType" minOccurs="0"/&gt;
 *     &lt;xs:element name="RateApplicablePercent" type="udt:PercentType" minOccurs="0"/&gt;
 *   &lt;/xs:sequence&gt;
 * &lt;/xs:complexType&gt;
 * <p>The class is parameterized with its own concrete subtype (&quot;recursive generics&quot; or
 * curiously recurring template pattern) so that the fluid setters declared here already
 * return the subtype and no covariant overrides are needed in the subclasses, e.g.
 * <code>class Charge extends TradeTax&lt;Charge&gt</code> makes
 * <code>setTaxBasisAmount(..)</code> return a <code>Charge</code></p>
 *
 * @param <T> the concrete subtype returned by the fluid setters
 */
public abstract class TradeTax<T extends TradeTax<T>> implements IZUGFeRDTradeTax {
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
	 * this instance, typed as the concrete subclass, for the fluid setters
	 */
	@SuppressWarnings("unchecked")
	protected T self() {
		return (T) this;
	}

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
	public T setTaxCalculatedAmount(BigDecimal taxCalculatedAmount) {
		this.taxCalculatedAmount = taxCalculatedAmount;
		return self();
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
	public T setTaxExemptionReason(String taxExemptionReason) {
		this.taxExemptionReason = taxExemptionReason;
		return self();
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
	public T setTaxBasisAmount(BigDecimal taxBasisAmount) {
		this.taxBasisAmount = taxBasisAmount;
		return self();
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
	public T setTaxLineTotalBasisAmount(BigDecimal taxLineTotalBasisAmount) {
		this.taxLineTotalBasisAmount = taxLineTotalBasisAmount;
		return self();
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
	public T setTaxAllowanceChargeBasisAmount(BigDecimal taxAllowanceChargeBasisAmount) {
		this.taxAllowanceChargeBasisAmount = taxAllowanceChargeBasisAmount;
		return self();
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
	public T setTaxCategoryCode(String taxCategoryCode) {
		this.taxCategoryCode = taxCategoryCode;
		return self();
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
	public T setTaxExemptionReasonCode(String taxExemptionReasonCode) {
		this.taxExemptionReasonCode = taxExemptionReasonCode;
		return self();
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
	public T setTaxPointDate(Date taxPointDate) {
		this.taxPointDate = taxPointDate;
		return self();
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
	public T setTaxDueDateTypeCode(String taxDueDateTypeCode) {
		this.taxDueDateTypeCode = taxDueDateTypeCode;
		return self();
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
	public T setTaxRateApplicablePercent(BigDecimal taxRateApplicablePercent) {
		this.taxRateApplicablePercent = taxRateApplicablePercent;
		return self();
	}
}
