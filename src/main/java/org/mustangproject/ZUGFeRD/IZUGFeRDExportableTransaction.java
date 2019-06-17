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


import org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants;

import java.util.Date;

public interface IZUGFeRDExportableTransaction {

	/**
	 *
	 *
	 * @return Code of Document
	 */
	default String getDocumentCode() {
		return DocumentCodeTypeConstants.INVOICE;
	}

	/**
	 * Number, typically invoice number of the invoice
	 *
	 * @return invoice number
	 */
	default String getNumber() {
		return null;
	}


	/**
	 * the date when the invoice was created
	 *
	 * @return when the invoice was created
	 */
	default Date getIssueDate() {
		return null;
	}


	/**
	 * this should be the full sender institution name, details, manager and tax registration. It is one of the few functions which may return null. e.g.
	 * <p/>
	 * Lieferant GmbH Lieferantenstraße 20 80333 München Deutschland Geschäftsführer: Hans Muster Handelsregisternummer: H A 123
	 *
	 * @return null or full sender institution name, details, manager and tax registration
	 */
	default String getOwnOrganisationFullPlaintextInfo() {
		return null;
	}


	/**
	 * when the invoice is to be paid
	 *
	 * @return when the invoice is to be paid
	 */
	default Date getDueDate() {
		return null;
	}

	/**
	 * who processed the order
	 *
	 * @return the contact person at the supplier side
	 */
	default IZUGFeRDExportableContact getOwnContact() {
		return null;
	}


	IZUGFeRDAllowanceCharge[] getZFAllowances();


	IZUGFeRDAllowanceCharge[] getZFCharges();


	IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges();


	IZUGFeRDExportableItem[] getZFItems();


	/**
	 * the recipient
	 *
	 * @return the recipient of the invoice
	 */
	IZUGFeRDExportableContact getRecipient();


	/**
	 * the creditors payment informations
	 */
	IZUGFeRDTradeSettlementPayment[] getTradeSettlementPayment();


	/**
	 * Tax ID (not VAT ID) of the sender
	 *
	 * @return Tax ID (not VAT ID) of the sender
	 */
	default String getOwnTaxID() {
		return null;
	}


	/**
	 * VAT ID (Umsatzsteueridentifikationsnummer) of the sender
	 *
	 * @return VAT ID (Umsatzsteueridentifikationsnummer) of the sender
	 */
	default String getOwnVATID() {
		return null;
	}


	/**
	 * supplier identification assigned by the costumer
	 *
	 * @return the sender's identification
	 */
	default String getOwnForeignOrganisationID() {
		return null;
	}


	/**
	 * own name
	 *
	 * @return the sender's organisation name
	 */
	default String getOwnOrganisationName() {
		return null;
	}


	/**
	 * own street address
	 *
	 * @return sender street address
	 */
	default String getOwnStreet() {
		return null;
	}


	/**
	 * own street postal code
	 *
	 * @return sender postal code
	 */
	default String getOwnZIP() {
		return null;
	}


	/**
	 * own city
	 *
	 * @return the invoice sender's city
	 */
	default String getOwnLocation() {
		return null;
	}


	/**
	 * own two digit country code
	 *
	 * @return the invoice senders two character country iso code
	 */
	default String getOwnCountry() {
		return null;
	}


	/**
	 * get delivery date
	 *
	 * @return the day the goods have been delivered
	 */
	Date getDeliveryDate();


	/**
	 * get main invoice currency used on the invoice
	 *
	 * @return three character currency of this invoice
	 */
	default String getCurrency() {
		return null;
	}


	/**
	 * get payment term descriptional text e.g. Bis zum 22.10.2015 ohne Abzug
	 *
	 * @return get payment terms
	 */
	default String getPaymentTermDescription() {
		return null;
	}


	/**
	 * get reference document number typically used for Invoice Corrections Will be added as IncludedNote in comfort profile
	 *
	 * @return the ID of the document this document refers to
	 */
	default String getReferenceNumber() {
		return null;
	}

}
