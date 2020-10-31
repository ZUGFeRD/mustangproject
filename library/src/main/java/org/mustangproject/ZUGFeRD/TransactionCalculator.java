package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;
import java.util.HashMap;

/***
 * The Transactioncalculator e.g. adds the line totals and applies VAT on whole invoices
 * @see LineCalculator
 */
public class TransactionCalculator implements IAbsoluteValueProvider {
	protected IExportableTransaction trans;

	public TransactionCalculator(IExportableTransaction trans) {
		this.trans=trans;
	}

	protected BigDecimal getTotalPrepaid() {
		if (trans.getTotalPrepaidAmount() == null) {
			return new BigDecimal(0);
		} else {
			return trans.getTotalPrepaidAmount();
		}
	}

	protected BigDecimal getTotalGross() {

		BigDecimal res = getTaxBasis();
		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			res = res.add(amount.getCalculated());
		}
		return res;
	}

	protected BigDecimal getCharges() {
		BigDecimal res = new BigDecimal(0);
		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				res = res.add(currentCharge.getTotalAmount(this));
			}
		}
		return res;
	}

	protected BigDecimal getAllowances() {
		BigDecimal res = new BigDecimal(0);
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		if ((allowances != null) && (allowances.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentAllowance : allowances) {
				res = res.add(currentAllowance.getTotalAmount(this));
			}
		}
		return res;
	}

	protected BigDecimal getTotal() {
		BigDecimal res = new BigDecimal(0);
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			LineCalculator lc = new LineCalculator(currentItem);
			res = res.add(lc.getItemTotalGrossAmount());
		}
		return res;
	}

	protected BigDecimal getTaxBasis() {
		BigDecimal res = getTotal().add(getCharges()).subtract(getAllowances());
		return res;
	}

	/**
	 * which taxes have been used with which amounts in this transaction, empty for
	 * no taxes, or e.g. 19:190 and 7:14 if 1000 Eur were applicable to 19% VAT
	 * (=190 EUR VAT) and 200 EUR were applicable to 7% (=14 EUR VAT) 190 Eur
	 *
	 * @return which taxes have been used with which amounts in this invoice
	 */
	protected HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
		HashMap<BigDecimal, VATAmount> hm = new HashMap<>();

		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			BigDecimal percent = currentItem.getProduct().getVATPercent();
			LineCalculator lc = new LineCalculator(currentItem);
			VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(), lc.getItemTotalVATAmount(),
					trans.getDocumentCode());
			VATAmount current = hm.get(percent);
			if (current == null) {
				hm.put(percent, itemVATAmount);
			} else {
				hm.put(percent, current.add(itemVATAmount));
			}
		}


		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				VATAmount theAmount = hm.get(currentCharge.getTaxPercent());
				if (theAmount == null) {
					theAmount = new VATAmount(new BigDecimal(0), new BigDecimal(0), "S");
				}
				theAmount.setBasis(theAmount.getBasis().add(currentCharge.getTotalAmount(this)));
				BigDecimal factor = currentCharge.getTaxPercent().divide(new BigDecimal(100));
				theAmount.setCalculated(theAmount.getBasis().multiply(factor));
				hm.put(currentCharge.getTaxPercent(), theAmount);
			}
		}
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		if ((allowances != null) && (allowances.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentAllowance : allowances) {
				VATAmount theAmount = hm.get(currentAllowance.getTaxPercent());
				if (theAmount == null) {
					theAmount = new VATAmount(new BigDecimal(0), new BigDecimal(0), "S");
				}
				theAmount.setBasis(theAmount.getBasis().subtract(currentAllowance.getTotalAmount(this)));
				BigDecimal factor = currentAllowance.getTaxPercent().divide(new BigDecimal(100));
				theAmount.setCalculated(theAmount.getBasis().multiply(factor));

				hm.put(currentAllowance.getTaxPercent(), theAmount);
			}
		}


		return hm;
	}


	@Override
	public BigDecimal getValue() {
		return getTotal();
	}

}
