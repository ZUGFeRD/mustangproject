package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IAbsoluteValueProvider;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;

/**
 * (absolute) allowances on item and document level
 *
 * <p>{@link Charge} binds the self type of the recursive generic of {@link TradeTax} to
 * {@code Charge}, so all inherited fluid setters are declared to return a {@code Charge}.
 * They already return this very instance at runtime, only the static type is too wide, so
 * this class narrows it by covariant overrides - that keeps the API of {@code Charge}
 * untouched and lets allowances be chained without an intermediate variable or cast</p>
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Allowance extends Charge {

	/***
	 * bean constructor
	 */
	public Allowance() {

	}

	/***
	 * create a allowance with the following amount
	 * @param totalAmount the money amount as bigdecimal (prob max 2 decimals)
	 */
	public Allowance(BigDecimal totalAmount) {
		super(totalAmount);

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

	/***
	 * Always to return false for IZUGFeRDAllowanceCharge
	 * @return false since its not supposed to be calculated negatively
	 */
	@Override
	@JsonIgnore
	public boolean isCharge() {
		return false;
	}

	/*
	 * covariant overrides of the inherited fluid setters, see class javadoc
	 */

	@Override
	public Allowance setPercent(BigDecimal percent) {
		super.setPercent(percent);
		return this;
	}

	@Override
	public Allowance setBasisAmount(BigDecimal basis) {
		super.setBasisAmount(basis);
		return this;
	}

	@Override
	public Allowance setBasisQuantity(BigDecimal basis) {
		super.setBasisQuantity(basis);
		return this;
	}

	@Override
	public Allowance setTotalAmount(BigDecimal totalAmount) {
		super.setTotalAmount(totalAmount);
		return this;
	}

	@Override
	public Allowance setReason(String reason) {
		super.setReason(reason);
		return this;
	}

	@Override
	public Allowance setReasonCode(String reasonCode) {
		super.setReasonCode(reasonCode);
		return this;
	}

	@Override
	public Allowance setTaxCalculatedAmount(BigDecimal taxCalculatedAmount) {
		super.setTaxCalculatedAmount(taxCalculatedAmount);
		return this;
	}

	@Override
	public Allowance setTaxExemptionReason(String taxExemptionReason) {
		super.setTaxExemptionReason(taxExemptionReason);
		return this;
	}

	@Override
	public Allowance setTaxExemptionReasonCode(String taxExemptionReasonCode) {
		super.setTaxExemptionReasonCode(taxExemptionReasonCode);
		return this;
	}

	@Override
	public Allowance setTaxBasisAmount(BigDecimal taxBasisAmount) {
		super.setTaxBasisAmount(taxBasisAmount);
		return this;
	}

	@Override
	public Allowance setTaxLineTotalBasisAmount(BigDecimal taxLineTotalBasisAmount) {
		super.setTaxLineTotalBasisAmount(taxLineTotalBasisAmount);
		return this;
	}

	@Override
	public Allowance setTaxAllowanceChargeBasisAmount(BigDecimal taxAllowanceChargeBasisAmount) {
		super.setTaxAllowanceChargeBasisAmount(taxAllowanceChargeBasisAmount);
		return this;
	}

	@Override
	public Allowance setTaxCategoryCode(String taxCategoryCode) {
		super.setTaxCategoryCode(taxCategoryCode);
		return this;
	}

	@Override
	public Allowance setTaxPointDate(Date taxPointDate) {
		super.setTaxPointDate(taxPointDate);
		return this;
	}

	@Override
	public Allowance setTaxDueDateTypeCode(String taxDueDateTypeCode) {
		super.setTaxDueDateTypeCode(taxDueDateTypeCode);
		return this;
	}

	@Override
	public Allowance setTaxRateApplicablePercent(BigDecimal taxRateApplicablePercent) {
		super.setTaxRateApplicablePercent(taxRateApplicablePercent);
		return this;
	}

	/**
	 * @deprecated use setTaxRateApplicablePercent(BigDecimal) instead.
	 */
	@SuppressWarnings("deprecation")
	@Deprecated(forRemoval = true, since = "2.24.1")
	@Override
	public Allowance setTaxPercent(BigDecimal percent) {
		super.setTaxPercent(percent);
		return this;
	}

	/**
	 * @deprecated use setTaxCategoryCode(String) instead.
	 */
	@SuppressWarnings("deprecation")
	@Deprecated(forRemoval = true, since = "2.24.1")
	@Override
	public Allowance setCategoryCode(String taxCategoryCode) {
		super.setCategoryCode(taxCategoryCode);
		return this;
	}
}
