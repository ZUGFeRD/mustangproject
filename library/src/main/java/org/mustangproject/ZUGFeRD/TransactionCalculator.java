package org.mustangproject.ZUGFeRD;

import static java.math.BigDecimal.ZERO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
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


	/**
	 * Returns information about every tax that is involved in the current transaction.
	 *
	 * @return transaction taxes.
	 */
	public Set<VATAmount> getTaxDetails() {
		return getVATPercentAmountMap().entrySet().stream()
			.map(entry ->
				new VATAmount(
					entry.getValue().getBasis(),
					entry.getValue().getCalculated(),
					entry.getValue().getCategoryCode()
				).setApplicablePercent(entry.getKey())
			)
			.collect(Collectors.toSet());
	}

	private BigDecimal sumAllowanceCharge(BigDecimal percent, IZUGFeRDAllowanceCharge[] charges) {
		BigDecimal res = BigDecimal.ZERO;
		if (charges != null) {
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
		if (charges == null) {
			return "";
		}
		return Arrays.stream(charges)
			.filter(currentCharge -> (percent == null || currentCharge.getTaxPercent().compareTo(percent) == 0))
			.map(IZUGFeRDAllowanceCharge::getReason)
			.filter(Objects::nonNull)
			.collect(Collectors.joining(" "));
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
	 * charges/allowances. For sub invoice lines only DETAIL lines are summed,
	 * GROUP and INFORMATION lines are ignored.
	 *
	 * @return item sum
	 */
	protected BigDecimal getTotal() {
		BigDecimal dec = Stream.of(trans.getZFItems())
			.filter(IZUGFeRDExportableItem::isCalculationRelevant)
			.map(LineCalculator::new)
			.map(LineCalculator::getItemTotalNetAmount).reduce(ZERO, BigDecimal::add);
		return dec;
	}

	/***
	 * returns the total net value of the invoice, including charges/allowances on
	 * document level
	 *
	 * @return item sum +- charges/allowances
	 */
	public BigDecimal getTaxBasis() {
		BigDecimal debug_1=getTotal();
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
			// skip GROUP and INFORMATION lines for sub invoice lines
			if (!currentItem.isCalculationRelevant()) {
				continue;
			}
			BigDecimal percent = null;
			if (currentItem.getProduct() != null) {
				percent = currentItem.getProduct().getVATPercent();
			}
			if (percent != null) {
				LineCalculator lc = currentItem.getCalculation();
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
		if (charges != null) {
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
		if (allowances != null) {
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

	protected List<VATAmount> getVATAmountList()
	{
		final List<VATAmount> vatAmounts = new ArrayList<>();
		final String vatDueDateTypeCode = this.trans.getVATDueDateTypeCode();
		for (final IZUGFeRDExportableItem currentItem : this.trans.getZFItems())
		{
			// skip GROUP and INFORMATION lines for sub invoice lines
			if (!currentItem.isCalculationRelevant()) {
				continue;
			}
			BigDecimal percent = null;
			if (currentItem.getProduct() != null)
			{
				percent = currentItem.getProduct().getVATPercent();
			}
			if (percent != null)
			{
				final LineCalculator lc = currentItem.getCalculation();
				final VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(), lc.getItemTotalVATAmount(),
					currentItem.getProduct().getTaxCategoryCode(), vatDueDateTypeCode, percent);
				final String reasonText = currentItem.getProduct().getTaxExemptionReason();
				if (reasonText != null)
				{
					itemVATAmount.setVatExemptionReasonText(reasonText);
				}
				final Optional<VATAmount> currentVatAmount = this.getCurrentVatAmount(vatAmounts, currentItem.getProduct().getTaxCategoryCode(), percent);
				if (currentVatAmount.isEmpty())
				{
					vatAmounts.add(itemVATAmount);
				}
				else
				{
					this.mergeAdding(currentVatAmount.get(), itemVATAmount);
				}
			}
		}

		final IZUGFeRDAllowanceCharge[] charges = this.trans.getZFCharges();
		if (charges != null) {
			for (final IZUGFeRDAllowanceCharge currentCharge : charges)
			{
				final BigDecimal taxPercent = currentCharge.getTaxPercent();
				if (taxPercent != null)
				{
					final String vatCategoryCode = currentCharge.getCategoryCode() != null ? currentCharge.getCategoryCode() : "S";
					final Optional<VATAmount> currentChargeVatAmount = this.getCurrentVatAmount(vatAmounts, vatCategoryCode, taxPercent);
					final BigDecimal chargeBasis = currentCharge.getTotalAmount(this);
					final VATAmount chargeVatAmount = new VATAmount(chargeBasis, chargeBasis.multiply(taxPercent.divide(new BigDecimal(100))), vatCategoryCode,
						vatDueDateTypeCode, taxPercent);
					if (currentChargeVatAmount.isEmpty())
					{
						vatAmounts.add(chargeVatAmount);
					}
					else
					{
						this.mergeAdding(currentChargeVatAmount.get(), chargeVatAmount);
					}
				}
			}
		}
		final IZUGFeRDAllowanceCharge[] allowances = this.trans.getZFAllowances();
		if (allowances != null) {
			for (final IZUGFeRDAllowanceCharge currentAllowance : allowances)
			{
				final BigDecimal taxPercent = currentAllowance.getTaxPercent();
				if (taxPercent != null)
				{
					final String vatCategoryCode = currentAllowance.getCategoryCode() != null ? currentAllowance.getCategoryCode() : "S";
					final Optional<VATAmount> currentAllowanceVatAmount = this.getCurrentVatAmount(vatAmounts, vatCategoryCode, taxPercent);
					final BigDecimal allowanceNegativeBasis = currentAllowance.getTotalAmount(this).multiply(BigDecimal.valueOf(-1));
					final VATAmount allowanceVATAmount = new VATAmount(allowanceNegativeBasis,
						allowanceNegativeBasis.multiply(taxPercent.divide(new BigDecimal(100))),
						currentAllowance.getCategoryCode() != null ? currentAllowance.getCategoryCode() : "S",
						vatDueDateTypeCode, taxPercent);
					if (currentAllowanceVatAmount.isEmpty())
					{
						vatAmounts.add(allowanceVATAmount);
					}
					else
					{
						this.mergeAdding(currentAllowanceVatAmount.get(), allowanceVATAmount);
					}
				}
			}
		}
		return vatAmounts;
	}
	
	public void mergeAdding(VATAmount vatAmount, VATAmount toAdd)
	{
		vatAmount.setBasis(vatAmount.getBasis().add(toAdd.getBasis()));
		vatAmount.setCalculated(vatAmount.getCalculated().add(toAdd.getCalculated()));
		if (toAdd.getVatExemptionReasonText() != null && !toAdd.getVatExemptionReasonText().isBlank())
		{
			Optional.ofNullable(vatAmount.getVatExemptionReasonText()).filter(reasonText -> !reasonText.equals(toAdd.getVatExemptionReasonText())).ifPresentOrElse(
				text -> vatAmount.setVatExemptionReasonText(String.join(", ", text, toAdd.getVatExemptionReasonText())),
				() -> vatAmount.setVatExemptionReasonText(toAdd.getVatExemptionReasonText()));
		}
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
	
	private Optional<VATAmount> getCurrentVatAmount(List<VATAmount> vatAmounts, String vatCategoryCode, BigDecimal percentage)
	{
		return vatAmounts.stream()
			.filter(va -> Objects.equals(vatCategoryCode, va.getCategoryCode())
				&& Optional.ofNullable(percentage).map(p -> va.getApplicablePercent() == null && p == null || p.compareTo(va.getApplicablePercent()) == 0)
					.orElse(true))
			.findFirst();
	}

	public BigDecimal getDuePayable() {
		BigDecimal res = getGrandTotal().subtract(getTotalPrepaid());
		if (trans.getRoundingAmount() != null) {
			res = res.add(trans.getRoundingAmount());
		}
		return res;
	}
}
