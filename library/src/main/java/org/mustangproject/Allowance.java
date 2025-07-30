package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IAbsoluteValueProvider;

import java.math.BigDecimal;
import java.math.RoundingMode;

/***
 * (absolute) allowances on item and document level
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
		if(totalAmount != null) {
			return totalAmount;
		} else if (percent!=null) {
			BigDecimal singlePrice=currentItem.getValue().multiply(BigDecimal.ONE.subtract(getPercent().divide(new BigDecimal(100))));
//			BigDecimal singlePrice=currentItem.getValue().multiply(BigDecimal.ONE.subtract(getPercent().divide(new BigDecimal(100))));
			BigDecimal singlePriceDiff=currentItem.getValue().subtract(singlePrice);
			return singlePriceDiff;
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
}
