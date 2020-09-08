package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;

import java.math.BigDecimal;

public class Allowance extends Charge implements IZUGFeRDAllowanceCharge {

	public Allowance() {

	}
	public Allowance(BigDecimal totalAmount, BigDecimal taxPercent, String reason, String categoryCode) {
		super(totalAmount, taxPercent, reason, categoryCode);

	}
}
