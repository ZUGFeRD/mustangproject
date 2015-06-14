package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

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
