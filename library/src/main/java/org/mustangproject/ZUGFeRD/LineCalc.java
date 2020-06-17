package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public class LineCalc {
	private BigDecimal totalGross;
	private BigDecimal priceGross;
	private BigDecimal itemTotalNetAmount;
	private BigDecimal itemTotalVATAmount;

	public LineCalc(IZUGFeRDExportableItem currentItem) {
		BigDecimal multiplicator = currentItem.getProduct().getVATPercent().divide(new BigDecimal(100))
				.add(new BigDecimal(1));
		priceGross = currentItem.getPrice(); // see https://github.com/ZUGFeRD/mustangproject/issues/159
		totalGross = currentItem.getQuantity().multiply(currentItem.getPrice()).divide(currentItem.getBasisQuantity())
				.multiply(multiplicator);
		itemTotalNetAmount = currentItem.getQuantity().multiply(currentItem.getPrice()).divide(currentItem.getBasisQuantity())
				.setScale(2, BigDecimal.ROUND_HALF_UP);
		itemTotalVATAmount = totalGross.subtract(itemTotalNetAmount);
	}

	public BigDecimal getItemTotalNetAmount() {
		return itemTotalNetAmount;
	}

	public BigDecimal getItemTotalVATAmount() {
		return itemTotalVATAmount;
	}

	public BigDecimal getItemTotalGrossAmount() {
		return itemTotalVATAmount;
	}

	public BigDecimal getPriceGross() {
		return priceGross;
	}


}
