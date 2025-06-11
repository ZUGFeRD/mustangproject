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
	protected TransactionCalculator tc=null;

    public void calculate() {
		tc=new TransactionCalculator(this);
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


	/***
	 * usually one would use calculate, use only if the invoice is parsed
	 * @param grand the gross total
	 * @return fluent setter
	 */
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


	/***
	 * usually one would use calculate, use only if the invoice is parsed
	 * @param basis taxable net total
	 * @return fluent setter
	 */
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


	/***
	 * usually one would use calculate, use only if the invoice is parsed
	 * @param due the gross total minus prepaid
	 * @return fluent setter
	 */
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

	/***
	 * usually one would use calculate, use only if the invoice is parsed
	 * @param total the net total
	 * @return fluent setter
	 */
	public CalculatedInvoice setLineTotalAmount(BigDecimal total) {
		lineTotalAmount=total;
		return this;
	}

	/**
	 * this can be used to additionally e.g. access the VAT amounts
	 * @return a updated transactioncalulator
	 */
	public TransactionCalculator getCalculation() {
		return tc;
	}

}
