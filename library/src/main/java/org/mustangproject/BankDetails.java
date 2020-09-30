package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlementPayment;

public class BankDetails implements IZUGFeRDTradeSettlementPayment {
	protected String IBAN, BIC;

	public BankDetails(String IBAN, String BIC) {
		this.IBAN = IBAN;
		this.BIC = BIC;
	}

	public String getIBAN() {
		return IBAN;
	}

	public BankDetails setIBAN(String IBAN) {
		this.IBAN = IBAN;
		return this;
	}

	public String getBIC() {
		return BIC;
	}

	public BankDetails setBIC(String BIC) {
		this.BIC = BIC;
		return this;
	}

	@Override
	public String getOwnBIC() {
		return getBIC();
	}

	@Override
	public String getOwnIBAN() {
		return getIBAN();
	}




}
