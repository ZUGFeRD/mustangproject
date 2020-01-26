package org.mustangproject.ZUGFeRD;

public interface IZUGFeRDPaymentTerms {

	String getDescription();

	IZUGFeRDDate getDueDate();

	IZUGFeRDPaymentDiscountTerms getDiscountTerms();
}
