package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;
import java.math.RoundingMode;

/***
 * the linecalculator does the math within an item line, and e.g. calculates quantity*price.
 * @see TransactionCalculator
 */
public class LineCalculator {
	private final BigDecimal price;
	private final BigDecimal priceGross;
	private final BigDecimal itemTotalNetAmount;
	private final BigDecimal itemTotalVATAmount;
	private BigDecimal allowance = BigDecimal.ZERO;
	private BigDecimal charge = BigDecimal.ZERO;
	private BigDecimal allowanceItemTotal = BigDecimal.ZERO;

	public LineCalculator(IZUGFeRDExportableItem currentItem) {

		if (currentItem.getItemAllowances() != null && currentItem.getItemAllowances().length > 0) {
			for (IZUGFeRDAllowanceCharge allowance : currentItem.getItemAllowances()) {
				BigDecimal factor=BigDecimal.ONE;
				BigDecimal singleAllowance=allowance.getTotalAmount(currentItem);
				if ((allowance.getPercent()!=null)&&(allowance.getPercent().compareTo(BigDecimal.ZERO)!=0)) {
					factor=allowance.getPercent().divide(new BigDecimal(100), 18, RoundingMode.HALF_UP);
				}
				addAllowance(singleAllowance.multiply(factor));

			}
		}
		if (currentItem.getItemCharges() != null && currentItem.getItemCharges().length > 0) {
			for (IZUGFeRDAllowanceCharge charge : currentItem.getItemCharges()) {
				BigDecimal factor=BigDecimal.ONE;
				BigDecimal singleCharge=charge.getTotalAmount(currentItem);
				if ((charge.getPercent()!=null)&&(charge.getPercent().compareTo(BigDecimal.ZERO)!=0)) {
					factor=charge.getPercent().divide(new BigDecimal(100), 18, RoundingMode.HALF_UP).multiply(currentItem.getQuantity());
				}
				addCharge(singleCharge.multiply(factor));

			}
		}
		if (currentItem.getItemTotalAllowances() != null && currentItem.getItemTotalAllowances().length > 0) {
			for (final IZUGFeRDAllowanceCharge itemTotalAllowance : currentItem.getItemTotalAllowances()) {
				addAllowanceItemTotal(itemTotalAllowance.getTotalAmount(currentItem));
			}
		}
		
		BigDecimal vatPercent = null;
		if (currentItem.getProduct()!=null) {
			vatPercent = currentItem.getProduct().getVATPercent();
		}
		if (vatPercent == null) {
			vatPercent = BigDecimal.ZERO;
		}
		BigDecimal multiplicator = vatPercent.divide(BigDecimal.valueOf(100));


		BigDecimal quantity=BigDecimal.ZERO;
		if ((currentItem!=null)&&(currentItem.getQuantity()!=null)) {
			quantity=currentItem.getQuantity();
		}

		price=currentItem.getPrice();
		priceGross=price;
//		BigDecimal delta=charge.subtract(allowanceItemTotal).subtract(allowance);
//		delta=delta.divide(currentItem.getQuantity(), 18, RoundingMode.HALF_UP);
//		priceGross=currentItem.getPrice().add(delta);
		// Division/Zero occurred here.
		// Used the setScale only because that's also done in getBasisQuantity
		BigDecimal basisQuantity = currentItem.getBasisQuantity().compareTo(BigDecimal.ZERO) == 0
			? BigDecimal.ONE.setScale(4)
			: currentItem.getBasisQuantity();
		itemTotalNetAmount = quantity.multiply(currentItem.getPrice()).divide(basisQuantity, 18, RoundingMode.HALF_UP)
			.subtract(allowanceItemTotal).subtract(allowance).add(charge).setScale(2, RoundingMode.HALF_UP);
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

	public void addAllowanceItemTotal(BigDecimal b) {
		allowanceItemTotal = allowanceItemTotal.add(b);
	}

}
