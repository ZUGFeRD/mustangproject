package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;
import java.util.Date;

public interface IZUGFeRDPaymentDiscountTerms {

	BigDecimal getCalculationPercentage();

	Date getBaseDate();

	int getBasePeriodMeasure();

	String getBasePeriodUnitCode();

}
