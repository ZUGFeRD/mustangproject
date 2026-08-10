package org.mustangproject;

import java.math.BigDecimal;

import org.mustangproject.ZUGFeRD.IZUGFeRDLogisticsServiceCharge;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

/***
 * Absolute and relative logistic charges for document level
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class LogisticsServiceCharge extends TradeTax implements IZUGFeRDLogisticsServiceCharge {

	/**
	 * the description
	 */
	protected String description;

	protected BigDecimal appliedAmount;

	/***
	 * Bean constructor
	 */
	public LogisticsServiceCharge() {
	}

	/***
	 * creates a invoice level logistic charge
	 * @param appliedAmount (the absolute amount)
	 */
	public LogisticsServiceCharge(BigDecimal appliedAmount) {
		this.appliedAmount = appliedAmount;
	}

	@Override
	public String getDescription() {
		return description;
	}

	public LogisticsServiceCharge setDescription(String description) {
		this.description = description;
		return this;
	}

	public BigDecimal getAppliedAmount() {
		return appliedAmount;
	}

	public LogisticsServiceCharge setAppliedAmount(BigDecimal appliedAmount) {
		this.appliedAmount = appliedAmount;
		return this;
	}
}
