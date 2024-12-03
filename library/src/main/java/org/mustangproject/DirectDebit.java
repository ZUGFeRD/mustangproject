package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlementDebit;

/**
 * provides e.g. the IBAN to transfer money to :-)
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class DirectDebit implements IZUGFeRDTradeSettlementDebit {
	/**
	 * Debited account identifier (BT-91)
	 */
	protected String IBAN;

	/**
	 * Mandate reference identifier (BT-89)
	 */
	protected String mandate;

	/**
	 * bean constructor
	 */
	public DirectDebit() {
		this.IBAN = "";
		this.mandate = "";
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

	public DirectDebit setIBAN(String iBAN) {
		this.IBAN = iBAN;
		return this;
	}

	@Override
	public String getMandate() {
		return this.mandate;
	}

	public DirectDebit setMandate(String mandate) {
		this.mandate = mandate;
		return this;
	}
}
