/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * Neccessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10 to 2014-06-25
 * @version 1.2.0
 * @author jstaerk
 * */



import java.util.Date;

public interface IZUGFeRDExportableTransaction {

	/**
	 * Number, typically invoice number of the invoice
	 * @return invoice number
	 */
	String getNumber();

	/**
	 * the date when the invoice was created
	 * @return when the invoice was created
	 */
	Date getIssueDate();

	/**
	 * this should be the full sender institution name, details, manager and tax registration.
	 * It is one of the few functions which may return null.
	 * e.g.
	 *
	 Lieferant GmbH
	 Lieferantenstraße 20
	 80333 München
	 Deutschland
     Geschäftsführer: Hans Muster
	 Handelsregisternummer: H A 123
	 * @return null or full sender institution name, details, manager and tax registration
	 */
	String getOwnOrganisationFullPlaintextInfo();

	/**
	 * when the invoice is to be paid
	 * @return when the invoice is to be paid
	 */
	Date getDueDate();

        IZUGFeRDAllowanceCharge[] getZFAllowances();
        IZUGFeRDAllowanceCharge[] getZFCharges();
        IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges();

	IZUGFeRDExportableItem[] getZFItems();

	/***
	 * the recipient
	 * @return the recipient of the invoice
	 */
	IZUGFeRDExportableContact getRecipient();

	/***
	 * BIC of the sender
	 * @return the BIC code of the recipient sender's bank
	 */
	String getOwnBIC();

	/***
	 * Bank name of the sender
	 * @return the name of the sender's bank
	 */
	String getOwnBankName();

	/**
	 * IBAN of the sender
	 * @return  the IBAN of the invoice sender's bank account
	 */
	String getOwnIBAN();

	/**
	 * Tax ID (not VAT ID) of the sender
	 * @return  Tax ID (not VAT ID) of the sender
	 */
	String getOwnTaxID();

	/**
	 * VAT ID (Umsatzsteueridentifikationsnummer) of the sender
	 * @return VAT ID (Umsatzsteueridentifikationsnummer) of the sender
	 */
	String getOwnVATID();

	/**
	 * own name
	 * @return the sender's organisation name
	 */
	String getOwnOrganisationName();

	/**
	 * own street address
	 * @return sender street address
	 */
	String getOwnStreet();

	/**
	 * own street postal code
	 * @return sender postal code
	 */
	String getOwnZIP();

	/**
	 * own city
	 * @return the invoice sender's city
	 */
	String getOwnLocation();

	/**
	 * own two digit country code
	 * @return the invoice senders two character country iso code
	 */
	String getOwnCountry();

	/**
	 * get delivery date
	 * @return the day the goods have been delivered
	 */
	Date getDeliveryDate();

        /**
	 * get main invoice currency used on the invoice
	 * @return three character currency of this invoice
	 */
     String getCurrency();

        /**
	 * get payment information text. e.g. Bank transfer
	 * @return payment information text
	 */
        String getOwnPaymentInfoText();

        /**
	 * get payment term descriptional text
         * e.g. Bis zum 22.10.2015 ohne Abzug
	 * @return get payment terms
	 */
        String getPaymentTermDescription();

        /**
         * get reference document number
         * typically used for Invoice Corrections
         * Will be added as IncludedNote in comfort profile
         * @return the ID of the document this document refers to
         */
        String getReferenceNumber();

}
