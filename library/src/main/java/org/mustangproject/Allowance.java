package org.mustangproject;

import org.mustangproject.ZUGFeRD.IExportableTransaction;
import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;

import java.math.BigDecimal;

public class Allowance extends Charge implements IZUGFeRDAllowanceCharge {

	public Allowance() {

	}
	public Allowance(BigDecimal totalAmount) {
		super(totalAmount);

	}

	@Override
	public boolean isCharge() {
		return false;
	}
}
