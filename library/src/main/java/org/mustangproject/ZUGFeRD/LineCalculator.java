package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.Objects;

/***
 * the linecalculator does the math within an item line, and e.g. calculates quantity*price.
 * @see TransactionCalculator
 */
public class LineCalculator {
	private final BigDecimal price;
	private final BigDecimal priceGross;
	private final BigDecimal itemTotalNetAmount;
	private BigDecimal allowance = BigDecimal.ZERO;
	private BigDecimal charge = BigDecimal.ZERO;
	private BigDecimal allowanceItemTotal = BigDecimal.ZERO;

	public LineCalculator(IZUGFeRDExportableItem currentItem) {

		if (Objects.nonNull(currentItem.getItemAllowances())) {
			Arrays.stream(currentItem.getItemAllowances())
						.map(allowance -> allowance.getTotalAmount(currentItem))
						.forEach(this::addAllowance);
		}
		if (Objects.nonNull(currentItem.getItemCharges())) {
			Arrays.stream(currentItem.getItemCharges())
						.map(charge -> charge.getTotalAmount(currentItem))
						.forEach(this::addCharge);
		}
		if (Objects.nonNull(currentItem.getItemTotalAllowances() )) {
			Arrays.stream(currentItem.getItemTotalAllowances())
						.map(itemTotalAllowance -> itemTotalAllowance.getTotalAmount(currentItem))
						.forEach(this::addAllowanceItemTotal);
		}
		
		BigDecimal vatPercent = null;
		if (Objects.nonNull(currentItem.getProduct())) {
			vatPercent = currentItem.getProduct().getVATPercent();
		}
		if (Objects.isNull(vatPercent)) {
			vatPercent = BigDecimal.ZERO;
		}
		BigDecimal multiplicator = vatPercent.divide(BigDecimal.valueOf(100));
		priceGross = currentItem.getPrice(); // see https://github.com/ZUGFeRD/mustangproject/issues/159
		price = priceGross.subtract(allowance).add(charge);

		BigDecimal quantity=BigDecimal.ZERO;
		if (Objects.nonNull(currentItem.getQuantity())) {
			quantity=currentItem.getQuantity();
		}

		// Division/Zero occurred here.
		// Used the setScale only because that's also done in getBasisQuantity
		BigDecimal basisQuantity = currentItem.getBasisQuantity().compareTo(BigDecimal.ZERO) == 0
			? BigDecimal.ONE.setScale(4)
			: currentItem.getBasisQuantity();
		itemTotalNetAmount = quantity.multiply(getPrice()).divide(basisQuantity, 18, RoundingMode.HALF_UP)
				.subtract(allowanceItemTotal).setScale(2, RoundingMode.HALF_UP);
	}

	public BigDecimal getPrice() {
		return price;
	}

	public BigDecimal getItemTotalNetAmount() {
		return itemTotalNetAmount;
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
