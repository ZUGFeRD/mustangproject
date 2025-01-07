// Copyright (c) 2023 Jochen Stärk, see LICENSE file
package org.mustangproject;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.TransactionCalculator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.Serializable;
import java.math.BigDecimal;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class CalculatedInvoice extends Invoice implements Serializable {

	protected BigDecimal lineTotalAmount=null;
	protected BigDecimal duePayable=null;
	protected BigDecimal grandTotal=null;
	protected BigDecimal taxBasis=null;

    public void calculate() {
        TransactionCalculator tc=new TransactionCalculator(this);
        grandTotal=tc.getGrandTotal();
		lineTotalAmount=tc.getValue();
		duePayable=tc.getDuePayable();
		taxBasis= tc.getTaxBasis();
    }
	public BigDecimal getGrandTotal() {
		if (grandTotal==null) {
			calculate();
		}
		return grandTotal;
	}
	public CalculatedInvoice setGrandTotal(BigDecimal grand) {
		grandTotal=grand;
		return this;
	}
	public BigDecimal getTaxBasis() {
		if (taxBasis==null) {
			calculate();
		}
		return taxBasis;
	}
	public CalculatedInvoice setTaxBasis(BigDecimal basis) {
		taxBasis=basis;
		return this;
	}

	public BigDecimal getDuePayable() {
		if (duePayable==null) {
			calculate();
		}
		return duePayable;
	}
	public CalculatedInvoice setDuePayable(BigDecimal due) {
		duePayable=due;
		return this;
	}

	public BigDecimal getLineTotalAmount() {
		if (lineTotalAmount==null) {
			calculate();
		}
		return lineTotalAmount;
	}
	public CalculatedInvoice setLineTotalAmount(BigDecimal total) {
		lineTotalAmount=total;
		return this;
	}

}
