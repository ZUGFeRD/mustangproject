package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;

import java.math.BigDecimal;

public class Allowance extends Charge {

	public Allowance(BigDecimal totalAmount, BigDecimal taxPercent, String categoryCode, String reason) {
		super(totalAmount, taxPercent, categoryCode, reason);
	}
}
