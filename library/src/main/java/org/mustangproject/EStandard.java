package org.mustangproject;

public enum EStandard {
	/**factur-x/zugferd 2*/
	facturx,
	/***
	 * order-x
	 */
	orderx,
	/***
	 * deliver-x
	 */
	despatchadvice,
	/***
	 * 1lieferschein
	 */
	ubldespatchadvice,
	/***
	 * ZUGFeRD 1
	 */
	zugferd,
	/***
	 * imported from cross industry invoice
	 */
	cii,
	/***
	 * imported from an UBL invoice
	 */
	ubl,
	/***
	 * imported from an UBL credit note
	 */
	ubl_creditnote

}
