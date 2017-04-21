package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * Neccessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.2.0
 * @author jstaerk
 * */


public interface IZUGFeRDExportableContact {

	/**
	 * First and last name of the recipient
	 * @return
	 */
	String getName();

	/**
	 * Postal code of the recipient
	 * @return
	 */
	String getZIP();

	/** 
	 * VAT ID (Umsatzsteueridentifikationsnummer) of the contact
	 * @return
	 */
	String getVATID();

	/**
	 * two-letter country code of the contact
	 * @return
	 */
	String getCountry();

	/***
	 * Returns the city of the contact 
	 * @return
	 */
	String getLocation();

	/***
	 * Returns the street address (street+number) of the contact 
	 */
	String getStreet();

}
