package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlementPayment;

/**
 * provides e.g. the IBAN to transfer money to :-)
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class BankDetails implements IZUGFeRDTradeSettlementPayment {
	/**
	 * the bank account number
	 */
	protected String IBAN;
	/**
	 * BIC, I believe it's optional
	 */
	protected String BIC = null;
	/**
	 * the "name" of the bank account (holder)
	 */
	protected String accountName = null;

	/***
	 * bean constructor
	 */
	public BankDetails() {
	}

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
	 *
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


	/*
	I'd really like to get rid of all those getOwn... methods some time but in this case they are in the interface :-(
	 */
	@Override
	@Deprecated
	@JsonIgnore
	public String getOwnBIC() {
		return getBIC();
	}

	@Override
	@Deprecated
	@JsonIgnore
	public String getOwnIBAN() {
		return getIBAN();
	}


	/**
	 * set Holder
	 *
	 * @param name account name (usually account holder if != sender)
	 * @return fluent setter
	 */
	public BankDetails setAccountName(String name) {
		accountName = name;
		return this;
	}

	@Override
	public String getAccountName() {
		return accountName;
	}


}
