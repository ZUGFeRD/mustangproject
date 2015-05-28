package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * Neccessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10 to 2014-06-25
 * @version 1.0.2
 * @author jstaerk
 * */



import java.math.BigDecimal;
import java.util.Date;

public interface IZUGFeRDExportableTransaction {

	/** 
	 * Number, typically invoice number of the invoice
	 * @return
	 */
	String getNumber();

	/**
	 * the date when the invoice was created
	 * @return
	 */
	Date getIssueDate();


	/**
	 * total amount incl. taxes 
	 * @return
	 */
	BigDecimal getTotalGross();

	/**
	 * total amount excl. taxes 
	 * @return
	 */
	BigDecimal getTotal();

	/**
	 * when the invoice is to be paid
	 * @return
	 */
	Date getDueDate();

	IZUGFeRDExportableItem[] getZFItems();

	/***
	 * the recipient
	 * @return
	 */
	IZUGFeRDExportableContact getRecipient();

	/***
	 * BIC of the sender
	 * @return
	 */
	String getOwnBIC();

	/***
	 * Bank name of the sender
	 * @return
	 */
	String getOwnBankName();

	/**
	 * IBAN of the sender
	 * @return
	 */
	String getOwnIBAN();

	/**
	 * Tax ID (not VAT ID) of the sender
	 */
	String getOwnTaxID();

	/**
	 * VAT ID (Umsatzsteueridentifikationsnummer) of the sender
	 * @return
	 */
	String getOwnVATID();

	/**
	 * own name
	 * @return
	 */
	String getOwnOrganisationName();

	/**
	 * own street address
	 * @return
	 */
	String getOwnStreet();

	/**
	 * own street postal code
	 * @return
	 */
	String getOwnZIP();
	
	/**
	 * own city
	 * @return
	 */
	String getOwnLocation();

	/**
	 * own two digit country code
	 * @return
	 */
	String getOwnCountry();
	
	/**
	 * get delivery date
	 * @return
	 */
	Date getDeliveryDate();
	
	
	
}
