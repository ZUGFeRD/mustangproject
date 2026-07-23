package org.mustangproject;

public enum EStandard {
	/**factur-x/zugferd 2*/
	FACTUR_X,
	/***
	 * order-x
	 */
	ORDER_X,
	/***
	 * deliver-x
	 */
	DELIVER_X,
	/***
	 * 1lieferschein
	 */
	UBL_DESPATCHADVICE,
	/***
	 * ZUGFeRD 1
	 */
	ZUGFERD,
	/***
	 * imported from cross industry invoice
	 */
	CII,
	/***
	 * imported from an UBL invoice
	 */
	UBL,
	/***
	 * imported from an UBL credit note
	 */
	UBL_CREDITNOTE

}
