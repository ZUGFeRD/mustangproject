package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public interface IZUGFeRDPaymentDiscountTerms {

	BigDecimal getCalculationPercentage();

	IZUGFeRDDate getBaseDate();

	int getBasePeriodMeasure();

	String getBasePeriodUnitCode();

}
