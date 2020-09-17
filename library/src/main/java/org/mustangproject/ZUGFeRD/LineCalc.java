package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public class LineCalc {
	private BigDecimal totalGross;
	private BigDecimal price;
	private BigDecimal priceGross;
	private BigDecimal itemTotalNetAmount;
	private BigDecimal itemTotalVATAmount;
	private BigDecimal allowance=new BigDecimal(0);

	public LineCalc(IZUGFeRDExportableItem currentItem) {

		if (currentItem.getItemAllowances()!=null && currentItem.getItemAllowances().length>0) {
			for (IZUGFeRDAllowanceCharge allowance:currentItem.getItemAllowances()) {
				addAllowance(allowance.getTotalAmount());
			}
		}
		BigDecimal multiplicator = currentItem.getProduct().getVATPercent().divide(new BigDecimal(100))
				.add(new BigDecimal(1));
		priceGross = currentItem.getPrice(); // see https://github.com/ZUGFeRD/mustangproject/issues/159
		price = priceGross.subtract(allowance);
		totalGross = currentItem.getQuantity().multiply(getPrice()).divide(currentItem.getBasisQuantity())
				.multiply(multiplicator);
		itemTotalNetAmount = currentItem.getQuantity().multiply(getPrice()).divide(currentItem.getBasisQuantity())
				.setScale(2, BigDecimal.ROUND_HALF_UP);
		itemTotalVATAmount = totalGross.subtract(itemTotalNetAmount);


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
		allowance=b;

	}


}
