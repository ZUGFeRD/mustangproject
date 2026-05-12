package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.List;

/***
 * the linecalculator does the math within an item line, and e.g. calculates quantity*price.
 * @see TransactionCalculator
 */
public class LineCalculator {
	protected BigDecimal price;
	protected BigDecimal priceGross;
	protected BigDecimal itemTotalNetAmount;
	protected BigDecimal itemTotalVATAmount;
	protected BigDecimal lineAllowance = BigDecimal.ZERO;
	protected BigDecimal lineCharge = BigDecimal.ZERO;
	protected BigDecimal itemAllowance = BigDecimal.ZERO;
	protected BigDecimal itemCharge = BigDecimal.ZERO;
	protected BigDecimal allowanceItemTotal = BigDecimal.ZERO;

	public LineCalculator(IZUGFeRDExportableItem currentItem) {
		// Compute basisQuantity first so it can be used for item-level allowance/charge context
		BigDecimal basisQuantity = currentItem.getBasisQuantity().compareTo(BigDecimal.ZERO) == 0
			? BigDecimal.ONE.setScale(4)
			: currentItem.getBasisQuantity();

		// Provider for item-level: getValue() returns price/basisQty so percentage
		// allowances compute against the actual line amount (qty * price / basisQty),
		// not the raw (qty * price). No effect on absolute amounts.
		IAbsoluteValueProvider itemBasisProvider = new IAbsoluteValueProvider() {
			@Override
			public BigDecimal getValue() {
				return currentItem.getPrice().divide(basisQuantity, 18, RoundingMode.HALF_UP);
			}
			@Override
			public BigDecimal getQuantity() {
				return currentItem.getQuantity();
			}
		};

		if (currentItem.getItemAllowances() != null) {
			for (IZUGFeRDAllowanceCharge allowance : currentItem.getItemAllowances()) {
				BigDecimal singleAllowance = allowance.getTotalAmount(itemBasisProvider);
				addItemAllowance(singleAllowance);
				addAllowanceItemTotal(singleAllowance);
			}
		}
		if (currentItem.getItemCharges() != null) {
			for (IZUGFeRDAllowanceCharge charge : currentItem.getItemCharges()) {
				BigDecimal singleCharge = charge.getTotalAmount(itemBasisProvider);
				addItemCharge(singleCharge);
				subtractAllowanceItemTotal(singleCharge);
			}
		}
		if (currentItem.getItemTotalAllowances() != null) {
			for (final IZUGFeRDAllowanceCharge itemTotalAllowance : currentItem.getItemTotalAllowances()) {
				addAllowanceItemTotal(itemTotalAllowance.getTotalAmount(itemBasisProvider));
			}
		}

		BigDecimal vatPercent = null;
		if (currentItem.getProduct() != null) {
			vatPercent = currentItem.getProduct().getVATPercent();
		}
		if (vatPercent == null) {
			vatPercent = BigDecimal.ZERO;
		}
		BigDecimal multiplicator = vatPercent.divide(BigDecimal.valueOf(100));

		BigDecimal quantity = BigDecimal.ZERO;
		if ((currentItem != null) && (currentItem.getQuantity() != null)) {
			quantity = currentItem.getQuantity();
		}

		price = currentItem.getPrice();
		priceGross = price;

		// Provider for product-level: getQuantity() returns ONE because product
		// allowances adjust the per-unit price, not the line total.
		// No effect on absolute amounts.
		IAbsoluteValueProvider perUnitProvider = new IAbsoluteValueProvider() {
			@Override
			public BigDecimal getValue() {
				return currentItem.getPrice();
			}
			@Override
			public BigDecimal getQuantity() {
				return BigDecimal.ONE;
			}
		};

		BigDecimal delta = BigDecimal.ZERO;
		if (currentItem.getProduct() != null) {
			if (currentItem.getProduct().getAllowances() != null) {
				for (IZUGFeRDAllowanceCharge ccaf : currentItem.getProduct().getAllowances()) {
					delta = delta.subtract(ccaf.getTotalAmount(perUnitProvider));
				}
			}
			if (currentItem.getProduct().getCharges() != null) {
				for (IZUGFeRDAllowanceCharge ccaf : currentItem.getProduct().getCharges()) {
					delta = delta.add(ccaf.getTotalAmount(perUnitProvider));
				}
			}
		}

		price = price.add(delta);
		itemTotalNetAmount = quantity.multiply(price).divide(basisQuantity, 18, RoundingMode.HALF_UP)
			.add(lineCharge).subtract(lineAllowance)
			.subtract(allowanceItemTotal.setScale(2, RoundingMode.HALF_UP))
			.setScale(2, RoundingMode.HALF_UP);
		itemTotalVATAmount = itemTotalNetAmount.multiply(multiplicator);
	}

	public BigDecimal getPrice() {
		return price;
	}

	public BigDecimal getItemTotalNetAmount() {
		return itemTotalNetAmount;
	}

	public BigDecimal getItemTotalVATAmount() {
		return itemTotalVATAmount;
	}

	public BigDecimal getItemTotalGrossAmount() {
		return itemTotalNetAmount;
	}

	public BigDecimal getPriceGross() {
		return priceGross;
	}

	public void addLineAllowance(BigDecimal b) {
		lineAllowance = lineAllowance.add(b);
	}

	public void addLineCharge(BigDecimal b) {
		lineCharge = lineCharge.add(b);
	}

	public void addItemAllowance(BigDecimal b) {
		itemAllowance = itemAllowance.add(b);
	}

	public void addItemCharge(BigDecimal b) {
		itemCharge = itemCharge.add(b);
	}

	public void addAllowanceItemTotal(BigDecimal b) {
		allowanceItemTotal = allowanceItemTotal.add(b);
	}
	public void subtractAllowanceItemTotal(BigDecimal b) {
		allowanceItemTotal = allowanceItemTotal.subtract(b);
	}

}
