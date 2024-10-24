package org.mustangproject.ZUGFeRD;

public interface IZUGFeRDCashDiscount {


	/***
	 * @return this particular cash discount as cross industry invoice XML
	 */
	public String getAsCII();

	/***
	 * since EN16931 voted not to have (or even allow) cash discounts in their core invoice the german
	 * XRechnung CIUS defined it's own proprietary format for a freetext field
	 * @return this particular cash discount in proprietary xrechnung format
	 */
	public String getAsXRechnung();

}
