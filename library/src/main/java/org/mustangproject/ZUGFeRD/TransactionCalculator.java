package org.mustangproject.ZUGFeRD;

import static java.math.BigDecimal.ZERO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Objects;
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

	private HashMap<BigDecimal, VATAmount>   netAmountPerVAT;

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
		if (Objects.isNull(this.netAmountPerVAT)) {
			this.getVATPercentAmountMap();
		}
		return this.netAmountPerVAT.keySet()
															 .stream()
															 .map(taxPercent -> this.netAmountPerVAT.get(taxPercent))
															 .map(VATAmount::getCalculated)
															 .map(value -> value.setScale(2, RoundingMode.HALF_UP))
															 .reduce(BigDecimal.ZERO, BigDecimal::add);
	}

	/***
	 * returns total of charges for this tax rate
	 *
	 * @param taxPercent a specific rate, or null for any rate
	 * @return the total amount
	 */
	protected BigDecimal getChargesForPercent(BigDecimal taxPercent) {
		if (Objects.isNull(this.trans.getZFCharges())) {
			return BigDecimal.ZERO;
		}
		if (Objects.isNull(this.netAmountPerVAT)) {
			this.getVATPercentAmountMap();
		}
		if (Objects.isNull(taxPercent)) {
			return Stream.of(this.trans.getZFCharges())
									 .map(charge -> charge.getTotalAmount(this))
									 .reduce(BigDecimal.ZERO, BigDecimal::add);
		}
		return Arrays.stream(this.trans.getZFCharges())
								 .filter(charge -> taxPercent.equals(charge.getPercent()))
								 .findFirst()
								 .map(charge -> charge.getTotalAmount(this))
								 .orElse(ZERO);
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
	 * @param taxPercent a specific rate, or null for any rate
	 * @return the total amount
	 */
	protected BigDecimal getAllowancesForPercent(BigDecimal taxPercent) {
		if (Objects.isNull(this.trans.getZFAllowances())) {
			return BigDecimal.ZERO;
		}
		if (Objects.isNull(this.netAmountPerVAT)) {
			this.getVATPercentAmountMap();
		}
		if (Objects.isNull(taxPercent)) {
			return Stream.of(this.trans.getZFAllowances())
									 .map(allowance -> allowance.getTotalAmount(this))
									 .reduce(BigDecimal.ZERO, BigDecimal::add);
		}
		return Arrays.stream(this.trans.getZFAllowances())
								 .filter(allowance -> taxPercent.equals(allowance.getPercent()))
								 .findFirst()
								 .map(allowance -> allowance.getTotalAmount(this))
								 .orElse(ZERO);
	}

	/***
	 * returns the total net value of all items, without document level
	 * charges/allowances
	 *
	 * @return item sum
	 */
	protected BigDecimal getTotal() {
		if (Objects.isNull(this.netAmountPerVAT)) {
			this.getVATPercentAmountMap();
		}
		return this.netAmountPerVAT.keySet()
															 .stream()
															 .map(taxPercent -> this.netAmountPerVAT.get(taxPercent))
															 .map(VATAmount::getBasis)
															 .map(value -> value.setScale(2, RoundingMode.HALF_UP))
															 .reduce(BigDecimal.ZERO, BigDecimal::add);
	}

	/***
	 * returns the total net value of the invoice, including charges/allowances on
	 * document level
	 *
	 * @return item sum +- charges/allowances
	 */
	public BigDecimal getTaxBasis() {
		if (Objects.isNull(this.netAmountPerVAT)) {
			this.getVATPercentAmountMap();
		}
		BigDecimal netTotalValue = this.netAmountPerVAT.keySet()
																									 .stream()
																									 .map(taxPercent -> this.netAmountPerVAT.get(taxPercent))
																									 .map(VATAmount::getBasis)
																									 .map(value -> value.setScale(2, RoundingMode.HALF_UP))
																									 .reduce(BigDecimal.ZERO, BigDecimal::add);
		if (Objects.nonNull(this.trans.getZFCharges())) {
			BigDecimal chargesValue = Stream.of(this.trans.getZFCharges())
																			.map(charge -> charge.getTotalAmount(this))
																			.map(value -> value.setScale(2,
																																	 RoundingMode.HALF_UP))
																			.reduce(BigDecimal.ZERO,
																							BigDecimal::add);
			netTotalValue = netTotalValue.add(chargesValue);
		}
		if (Objects.nonNull(this.trans.getZFAllowances())) {
			BigDecimal allowancesValue = Stream.of(this.trans.getZFAllowances())
																				 .map(allowance -> allowance.getTotalAmount(this))
																				 .map(value -> value.setScale(2,
																																			RoundingMode.HALF_UP))
																				 .reduce(BigDecimal.ZERO,
																								 BigDecimal::add);
			netTotalValue = netTotalValue.add(allowancesValue);
		}
		return netTotalValue;
	}

	/**
	 * which taxes have been used with which amounts in this transaction, empty for
	 * no taxes, or e.g. 19:190 and 7:14 if 1000 Eur were applicable to 19% VAT
	 * (=190 EUR VAT) and 200 EUR were applicable to 7% (=14 EUR VAT) 190 Eur
	 *
	 * order of precessing:
	 *
	 * 1. calculate the total net amount of all items with the same VAT
	 * 2. use allowances and charges on every calculated value
	 * 3. calculate the VAT for each value
	 *
	 * @return which taxes have been used with which amounts in this invoice
	 */
	protected HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
		// once we have calculated the values, we do not need to do it again!
		if (Objects.nonNull(this.netAmountPerVAT)) {
			return this.netAmountPerVAT;
		}
		this.netAmountPerVAT = new HashMap<>();
		// 1. calculate the total net amount of all items with the same VAT
		IZUGFeRDExportableItem[] items = trans.getZFItems();
		final String vatDueDateTypeCode = trans.getVATDueDateTypeCode();
		Stream.of(items).forEach(item -> {
			BigDecimal percent = null;
			if (Objects.nonNull(item.getProduct())) {
				percent = item.getProduct().getVATPercent();
			}
			if (Objects.nonNull(percent)) {
				LineCalculator lc = new LineCalculator(item);
				VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(), item.getProduct().getTaxCategoryCode(), vatDueDateTypeCode);
				String reasonText = item.getProduct().getTaxExemptionReason();
				if (Objects.nonNull(reasonText)) {
					itemVATAmount.setVatExemptionReasonText(reasonText);
				}
				VATAmount current = netAmountPerVAT.get(percent.stripTrailingZeros());
				if (Objects.isNull(current)) {
					netAmountPerVAT.put(percent.stripTrailingZeros(), itemVATAmount);
				} else {
					netAmountPerVAT.put(percent.stripTrailingZeros(), current.add(itemVATAmount));
				}
			}
		});

		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		if (Objects.nonNull(charges)) {
			Stream.of(charges)
						.forEach(charge -> {
							BigDecimal taxPercent = charge.getTaxPercent();
							// in case taxPercent is null, the charge will be used on every VAT,
							// otherwise it will only be used for the VAT value
							// this will keep old implementations working
							if (Objects.isNull(taxPercent)) {
								netAmountPerVAT.keySet()
															 .forEach(vat -> {
																 VATAmount  theAmount    = netAmountPerVAT.get(vat);
																 BigDecimal chargeAmount = theAmount.getBasis()
																																		.multiply(charge.getPercent())
																																		.divide(new BigDecimal(100),
																																						4,
																																						RoundingMode.HALF_UP);
																 charge.setTotalAmount(chargeAmount);
																 BigDecimal newTotal = theAmount.getBasis()
																																.add(chargeAmount);
																 theAmount.setBasis(newTotal);
																 netAmountPerVAT.put(vat,
																										 theAmount);
															 });
							} else {
								VATAmount theAmount = netAmountPerVAT.get(taxPercent.stripTrailingZeros());
								if (Objects.nonNull(theAmount)) {
									BigDecimal chargeAmount = theAmount.getBasis()
																										 .multiply(charge.getPercent())
																										 .divide(new BigDecimal(100),
																														 4,
																														 RoundingMode.HALF_UP);
									charge.setTotalAmount(chargeAmount);
									BigDecimal newTotal = theAmount.getBasis()
																								 .add(chargeAmount);
									theAmount.setBasis(newTotal);
									netAmountPerVAT.put(taxPercent.stripTrailingZeros(),
																			theAmount);
								}
							}
						});
		}

		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
			if (Objects.nonNull(allowances)) {
				Stream.of(allowances)
							.forEach(allowance -> {
								BigDecimal taxPercent = allowance.getTaxPercent();
								// in case taxPercent is null, the charge will be used on every VAT,
								// otherwise it will only be used for the VAT value
								// this will keep old implementations working
								if (Objects.isNull(taxPercent)) {
									netAmountPerVAT.keySet()
																 .forEach(vat -> {
																	 VATAmount  theAmount    = netAmountPerVAT.get(vat);
																	 BigDecimal allowanceAmount = theAmount.getBasis()
																																			.multiply(allowance.getPercent())
																																			.divide(new BigDecimal(100),
																																							4,
																																							RoundingMode.HALF_UP);
																	 allowance.setTotalAmount(allowanceAmount);
																	 BigDecimal newTotal = theAmount.getBasis()
																																	.subtract(allowanceAmount);
																	 theAmount.setBasis(newTotal);
																	 netAmountPerVAT.put(vat,
																											 theAmount);
																 });
								} else {
									VATAmount theAmount = netAmountPerVAT.get(taxPercent.stripTrailingZeros());
									if (Objects.nonNull(theAmount)) {
										BigDecimal allowanceAmount = theAmount.getBasis()
																											 .multiply(allowance.getPercent())
																											 .divide(new BigDecimal(100),
																															 4,
																															 RoundingMode.HALF_UP);
										allowance.setTotalAmount(allowanceAmount);
										BigDecimal newTotal = theAmount.getBasis()
																									 .subtract(allowanceAmount);
										theAmount.setBasis(newTotal);
										netAmountPerVAT.put(taxPercent.stripTrailingZeros(),
																				theAmount);
									}
								}
							});
			}

		netAmountPerVAT.keySet()
									 .forEach(vat -> {
										 VATAmount theAmount = netAmountPerVAT.get(vat);
										 BigDecimal vatValue = theAmount.getBasis().multiply(vat).divide(new BigDecimal(100), 4, RoundingMode.HALF_UP);
										 theAmount.setCalculated(theAmount.getBasis().add(vatValue).setScale(4, RoundingMode.HALF_UP));
									 });

		return netAmountPerVAT;
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
