package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlementDebit;

/**
 * provides e.g. the IBAN to transfer money to :-)
 */
public class DirectDebit implements IZUGFeRDTradeSettlementDebit {
	/**
	 * Debited account identifier (BT-91)
	 */
	protected final String IBAN;

	/**
	 * Mandate reference identifier (BT-89)
	 */
	protected final String mandate;

	/**
	 * bean constructor
	 */
	public DirectDebit() {

	}

	/***
	 * constructor for normal use :-)
	 * @param IBAN the IBAN as string
	 * @param mandate the mandate as string
	 */
	public DirectDebit(String IBAN, String mandate) {
		this.IBAN = IBAN;
		this.mandate = mandate;
	}

	/***
	 * getter for the IBAN
	 * @return IBAN
	 */
	@Override
	public String getIBAN() {
		return this.IBAN;
	}

	@Override
	public String getMandate() {
		return this.mandate;
	}
}
