package org.mustangproject.ZUGFeRD;

import static java.math.BigDecimal.ZERO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.stream.Stream;

/***
 * The Transactioncalculator e.g. adds the line totals and applies VAT on whole
 * invoices
 *
 * @see LineCalculator
 */
public class TransactionCalculator implements IAbsoluteValueProvider {
	protected IExportableTransaction trans;

	/***
	 *
	 * @param trans the invoice (or IExportableTransaction) to be calculated
	 */
	public TransactionCalculator(IExportableTransaction trans) {
		this.trans = trans;
	}

	/***
	 * if something had already been paid in advance, this will get it from the
	 * transaction
	 *
	 * @return prepaid amount
	 */
	protected BigDecimal getTotalPrepaid() {
		if (trans.getTotalPrepaidAmount() == null) {
			return BigDecimal.ZERO;
		} else {
			return trans.getTotalPrepaidAmount().setScale(2, RoundingMode.HALF_UP);
		}
	}

	/***
	 * the invoice total with VAT, allowances and
	 * charges, WITHOUT considering prepaid amount
	 *
	 * @return the invoice total including taxes
	 */
	public BigDecimal getGrandTotal() {

		BigDecimal basis = getTaxBasis();
		return getVATPercentAmountMap().values().stream().map(VATAmount::getCalculated)
			.map(p -> p.setScale(2, RoundingMode.HALF_UP)).reduce(BigDecimal.ZERO, BigDecimal::add).add(basis);
	}

	/***
	 * returns total of charges for this tax rate
	 *
	 * @param percent a specific rate, or null for any rate
	 * @return the total amount
	 */
	protected BigDecimal getChargesForPercent(BigDecimal percent) {
		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		return sumAllowanceCharge(percent, charges);
	}

	private BigDecimal sumAllowanceCharge(BigDecimal percent, IZUGFeRDAllowanceCharge[] charges) {
		BigDecimal res = BigDecimal.ZERO;
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				if ((percent == null) || (currentCharge.getTaxPercent().compareTo(percent) == 0)) {
					res = res.add(currentCharge.getTotalAmount(this));
				}
			}
		}
		return res;
	}

	/***
	 * returns a (potentially concatenated) string of charge reasons, or "Charges"
	 * if none are defined
	 *
	 * @param percent a specific rate, or null for any rate
	 * @return the space separated String
	 */
	protected String getChargeReasonForPercent(BigDecimal percent) {
		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		String res = getAllowanceChargeReasonForPercent(percent, charges);
		if ("".equals(res)) {
			res = "Charges";
		}
		return res;
	}

	private String getAllowanceChargeReasonForPercent(BigDecimal percent, IZUGFeRDAllowanceCharge[] charges) {
		String res = " ";
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				if ((percent == null) || (currentCharge.getTaxPercent().compareTo(percent) == 0)
					&& currentCharge.getReason() != null) {
					res += currentCharge.getReason() + " ";
				}
			}
		}
		res = res.substring(0, res.length() - 1);
		return res;
	}

	/***
	 * returns a (potentially concatenated) string of allowance reasons, or
	 * "Allowances", if none are defined
	 *
	 * @param percent a specific rate, or null for any rate
	 * @return the space separated String
	 */
	protected String getAllowanceReasonForPercent(BigDecimal percent) {
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		String res = getAllowanceChargeReasonForPercent(percent, allowances);
		if ("".equals(res)) {
			res = "Allowances";
		}
		return res;
	}

	/***
	 * returns total of allowances for this tax rate
	 *
	 * @param percent a specific rate, or null for any rate
	 * @return the total amount
	 */
	protected BigDecimal getAllowancesForPercent(BigDecimal percent) {
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		return sumAllowanceCharge(percent, allowances);
	}

	/***
	 * returns the total net value of all items, without document level
	 * charges/allowances
	 *
	 * @return item sum
	 */
	protected BigDecimal getTotal() {
		BigDecimal dec = Stream.of(trans.getZFItems()).map(LineCalculator::new)
			.map(LineCalculator::getItemTotalNetAmount).reduce(ZERO, BigDecimal::add);
		return dec;
	}

	/***
	 * returns the total net value of the invoice, including charges/allowances on
	 * document level
	 *
	 * @return item sum +- charges/allowances
	 */
	protected BigDecimal getTaxBasis() {
		return getTotal().add(getChargesForPercent(null).setScale(2, RoundingMode.HALF_UP))
			.subtract(getAllowancesForPercent(null).setScale(2, RoundingMode.HALF_UP))
			.setScale(2, RoundingMode.HALF_UP);
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
		final String vatDueDateTypeCode = trans.getVATDueDateTypeCode();

		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			BigDecimal percent = currentItem.getProduct().getVATPercent();
			if (percent != null) {
				LineCalculator lc = new LineCalculator(currentItem);
				VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(), lc.getItemTotalVATAmount(),
					currentItem.getProduct().getTaxCategoryCode(), vatDueDateTypeCode);
				String reasonText = currentItem.getProduct().getTaxExemptionReason();
				if (reasonText != null) {
					itemVATAmount.setVatExemptionReasonText(reasonText);
				}
				VATAmount current = hm.get(percent.stripTrailingZeros());
				if (current == null) {
					hm.put(percent.stripTrailingZeros(), itemVATAmount);
				} else {
					hm.put(percent.stripTrailingZeros(), current.add(itemVATAmount));
				}
			}
		}

		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				BigDecimal taxPercent = currentCharge.getTaxPercent();
				if (taxPercent != null) {
					VATAmount theAmount = hm.get(taxPercent.stripTrailingZeros());
					if (theAmount == null) {
						theAmount = new VATAmount(BigDecimal.ZERO, BigDecimal.ZERO,
							currentCharge.getCategoryCode() != null ? currentCharge.getCategoryCode() : "S",
							vatDueDateTypeCode);
					}
					theAmount.setBasis(theAmount.getBasis().add(currentCharge.getTotalAmount(this)));
					BigDecimal factor = taxPercent.divide(new BigDecimal(100));
					theAmount.setCalculated(theAmount.getBasis().multiply(factor));
					hm.put(taxPercent.stripTrailingZeros(), theAmount);
				}
			}
		}
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		if ((allowances != null) && (allowances.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentAllowance : allowances) {
				BigDecimal taxPercent = currentAllowance.getTaxPercent();
				if (taxPercent != null) {
					VATAmount theAmount = hm.get(taxPercent.stripTrailingZeros());
					if (theAmount == null) {
						theAmount = new VATAmount(BigDecimal.ZERO, BigDecimal.ZERO,
							currentAllowance.getCategoryCode() != null ? currentAllowance.getCategoryCode() : "S",
							vatDueDateTypeCode);
					}
					theAmount.setBasis(theAmount.getBasis().subtract(currentAllowance.getTotalAmount(this)));
					BigDecimal factor = taxPercent.divide(new BigDecimal(100));
					theAmount.setCalculated(theAmount.getBasis().multiply(factor));

					hm.put(taxPercent.stripTrailingZeros(), theAmount);
				}
			}
		}

		return hm;
	}

	@Override
	public BigDecimal getValue() {
		return getTotal();
	}

	public BigDecimal getChargeTotal() {
		return getChargesForPercent(null).setScale(2, RoundingMode.HALF_UP);
	}

	public BigDecimal getAllowanceTotal() {
		return getAllowancesForPercent(null).setScale(2, RoundingMode.HALF_UP);
	}

	public BigDecimal getDuePayable() {
		BigDecimal res = getGrandTotal().subtract(getTotalPrepaid());
		if (trans.getRoundingAmount() != null) {
			res = res.add(trans.getRoundingAmount());
		}
		return res;
	}
}
