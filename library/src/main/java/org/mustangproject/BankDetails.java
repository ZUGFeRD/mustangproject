package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlementPayment;

/**
 * provides e.g. the IBAN to transfer money to :-)
 */
public class BankDetails implements IZUGFeRDTradeSettlementPayment {
	protected String IBAN, BIC, accountName=null;

	public BankDetails(String IBAN, String BIC) {
		this.IBAN = IBAN;
		this.BIC = BIC;
	}

	public String getIBAN() {
		return IBAN;
	}

	/**
	 * Sets the IBAN "ID", which means that it only needs to be a way to uniquely
	 * identify the IBAN. Of course you will specify your own IBAN in full length but
	 * if you deduct from a customer's account you may e.g. leave out the first or last
	 * digits so that nobody spying on the invoice gets to know the complete number
	 * @param IBAN the "IBAN ID", i.e. the IBAN or parts of it
	 * @return fluent setter
	 */
	public BankDetails setIBAN(String IBAN) {
		this.IBAN = IBAN;
		return this;
	}

	public String getBIC() {
		return BIC;
	}

	/***
	 * The bank identifier. Bank name is no longer neccessary in SEPA.
	 * @param BIC the bic code
	 * @return fluent setter
	 */
	public BankDetails setBIC(String BIC) {
		this.BIC = BIC;
		return this;
	}

	/***
	 *  getOwn... methods will be removed in the future in favor of Tradeparty (e.g. Sender) class
	 * */
	@Override
	@Deprecated
	public String getOwnBIC() {
		return getBIC();
	}

	@Override
	@Deprecated
	public String getOwnIBAN() {
		return getIBAN();
	}


	/**
	 * set Holder
	 * @param name account name (usually account holder if != sender)
	 * @return fluent setter
	 */
	public BankDetails setAccountName(String name) {
		accountName=name;
		return this;
	}

	@Override
	public String getAccountName() {
		return accountName;
	}



}
