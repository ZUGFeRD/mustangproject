package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlementPayment;

/**
 * provides e.g. the IBAN to transfer money to :-)
 */
public class BankDetails implements IZUGFeRDTradeSettlementPayment {
	/**
	 * the bank account number
	 */
	protected String IBAN;
	/**
	 * BIC, I believe it's optional
	 */
	protected String BIC=null;
	/**
	 * the "name" of the bank account (holder)
	 */
	protected String accountName=null;

	/***
	 * constructor for IBAN only :-)
	 * @param IBAN the IBAN as string
	 */
	public BankDetails(String IBAN) {
		this.IBAN = IBAN;
	}
	/***
	 * constructor for normal use :-)
	 * @param IBAN the IBAN as string
	 * @param BIC the BIC code as string
	 */
	public BankDetails(String IBAN, String BIC) {
		this.IBAN = IBAN;
		this.BIC = BIC;
	}

	/***
	 * getter for the IBAN
	 * @return IBAN
	 */
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

	/***
	 * getter for the BIC
	 * @return the BIC
	 */
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
