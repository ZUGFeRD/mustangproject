package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;
/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD exporter helper class
 * Licensed under the APLv2
 * @date 2015-10-29
 * @version 1.2.0
 * @author jstaerk
 * */
public class VATAmount {

	public VATAmount(BigDecimal basis, BigDecimal calculated) {
		super();
		this.basis = basis;
		this.calculated = calculated;
	}

	BigDecimal basis, calculated;

	public BigDecimal getBasis() {
		return basis;
	}

	public void setBasis(BigDecimal basis) {
		this.basis = basis;
	}

	public BigDecimal getCalculated() {
		return calculated;
	}

	public void setCalculated(BigDecimal calculated) {
		this.calculated = calculated;
	}
	
	public VATAmount add(VATAmount v) {
		return new VATAmount(basis.add(v.getBasis()), calculated.add(v.getCalculated()));
	}

}
