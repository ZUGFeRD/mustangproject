package org.mustangproject.ZUGFeRD;

import java.util.Date;

public interface IZUGFeRDPaymentTerms {

	String getDescription();

	Date getDueDate();

	IZUGFeRDPaymentDiscountTerms getDiscountTerms();
}
