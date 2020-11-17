package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

/***
 * the linecalculator does the math within an item line, and e.g. calculates quantity*price.
 * @see TransactionCalculator
 */
public class LineCalculator {
	private BigDecimal price;
	private BigDecimal priceGross;
	private BigDecimal itemTotalNetAmount;
	private BigDecimal itemTotalVATAmount;
	private BigDecimal allowance = BigDecimal.ZERO;
	private BigDecimal charge = BigDecimal.ZERO;

	public LineCalculator(IZUGFeRDExportableItem currentItem) {

		if (currentItem.getItemAllowances() != null && currentItem.getItemAllowances().length > 0) {
			for (IZUGFeRDAllowanceCharge allowance : currentItem.getItemAllowances()) {
				addAllowance(allowance.getTotalAmount(currentItem));
			}
		}
		if (currentItem.getItemCharges() != null && currentItem.getItemCharges().length > 0) {
			for (IZUGFeRDAllowanceCharge charge : currentItem.getItemCharges()) {
				addCharge(charge.getTotalAmount(currentItem));
			}
		}
		BigDecimal multiplicator = currentItem.getProduct().getVATPercent().divide(BigDecimal.valueOf(100));
		priceGross = currentItem.getPrice(); // see https://github.com/ZUGFeRD/mustangproject/issues/159
		price = priceGross.subtract(allowance).add(charge);
		itemTotalNetAmount = currentItem.getQuantity().multiply(getPrice()).divide(currentItem.getBasisQuantity())
				.setScale(2, BigDecimal.ROUND_HALF_UP);
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

	public void addAllowance(BigDecimal b) {
		allowance = allowance.add(b);
	}

	public void addCharge(BigDecimal b) {
		charge = charge.add(b);
	}


}
