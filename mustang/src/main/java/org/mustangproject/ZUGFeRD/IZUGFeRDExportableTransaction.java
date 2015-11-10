package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * Neccessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10 to 2014-06-25
 * @version 1.0.2
 * @author jstaerk
 * */



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
	 * this should be the full sender institution name, details, manager and tax registration like.
	 * It is one of the few functions which may return null.
	 * 
	 Lieferant GmbH
	 Lieferantenstraße 20
	 80333 München
	 Deutschland
     Geschäftsführer: Hans Muster
	 Handelsregisternummer: H A 123
	 * @return
	 */
	String getOwnOrganisationFullPlaintextInfo();

	/**
	 * when the invoice is to be paid
	 * @return
	 */
	Date getDueDate();
        
        IZUGFeRDAllowanceCharge[] getZFAllowances();
        IZUGFeRDAllowanceCharge[] getZFCharges();
        IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges();        

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
	
        /**
	 * get main invoice currency used on the invoice
	 * @return
	 */        
        String getInvoiceCurrency();
        
        /**
	 * get payment information text. e.g. Bank transfer
	 * @return
	 */  	
        String getOwnPaymentInfoText();

        /**
	 * get payment term descriptional text
         * e.g. Bis zum 22.10.2015 ohne Abzug
	 * @return
	 */         
        String getPaymentTermDescription();
        
	
}
