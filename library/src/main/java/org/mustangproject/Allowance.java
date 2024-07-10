package org.mustangproject;

import java.math.BigDecimal;

/***
 * (absolute) allowances on item and document level
 */
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

	/***
	 * Always to return false for IZUGFeRDAllowanceCharge
	 * @return false since its not supposed to be calculated negatively
	 */
	@Override
	public boolean isCharge() {
		return false;
	}
}
