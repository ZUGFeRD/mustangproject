/**
 * *********************************************************************
 * <p>
 * Copyright 2018 Jochen Staerk
 * <p>
 * Use is subject to license terms.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * <p>
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p>
 * **********************************************************************
 */
package org.mustangproject;

import org.mustangproject.ZUGFeRD.*;
import org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;

public class Invoice implements IExportableTransaction {

	protected String documentName = null, documentCode = null, number = null, ownOrganisationFullPlaintextInfo = null, referenceNumber = null, shipToOrganisationID = null, shipToOrganisationName = null, shipToStreet = null, shipToZIP = null, shipToLocation = null, shipToCountry = null, buyerOrderReferencedDocumentID = null, buyerOrderReferencedDocumentIssueDateTime = null, ownForeignOrganisationID = null, ownOrganisationName = null, currency = null, paymentTermDescription = null;
	protected Date issueDate = null, dueDate = null, deliveryDate = null;
	protected BigDecimal totalPrepaidAmount = null;
	protected TradeParty sender=null, recipient = null, deliveryAddress = null;
	protected ArrayList<IZUGFeRDExportableItem> ZFItems = null;
	protected String contractReferencedDocument = null;

	protected Date occurrenceDateFrom = null;
	protected Date occurrenceDateTo = null;

	protected ArrayList<IZUGFeRDAllowanceCharge> Allowances = new ArrayList<IZUGFeRDAllowanceCharge>(),
			Charges = new ArrayList<IZUGFeRDAllowanceCharge>(), LogisticsServiceCharges = new ArrayList<IZUGFeRDAllowanceCharge>();
	protected IZUGFeRDPaymentTerms paymentTerms = null;


	public Invoice() {
		ZFItems = new ArrayList<IZUGFeRDExportableItem>();
		setCurrency("EUR");
	}

	@Override
	public String getDocumentName() {
		return documentName;
	}

	public String getContractReferencedDocument() { return contractReferencedDocument; }

	public Invoice setDocumentName(String documentName) {
		this.documentName = documentName;
		return this;
	}

	@Override
	public String getDocumentCode() {
		return documentCode;
	}

	public Invoice setDocumentCode(String documentCode) {
		this.documentCode = documentCode;
		return this;
	}


	@Override
	public String getNumber() {
		return number;
	}

	public Invoice setNumber(String number) {
		this.number = number;
		return this;
	}

	/***
	 * switch type to invoice correction and refer to document number
	 * @param number the invoice number to be corrected
	 * @return this object (fluent setter)
	 */
	public Invoice setCorrection(String number) {
		setBuyerOrderReferencedDocumentID(number);
		documentCode= DocumentCodeTypeConstants.CORRECTEDINVOICE;
		return this;
	}

	@Override
	public String getOwnOrganisationFullPlaintextInfo() {
		return ownOrganisationFullPlaintextInfo;
	}

	public Invoice setOwnOrganisationFullPlaintextInfo(String ownOrganisationFullPlaintextInfo) {
		this.ownOrganisationFullPlaintextInfo = ownOrganisationFullPlaintextInfo;
		return this;
	}

	@Override
	public String getReferenceNumber() {
		return referenceNumber;
	}

	public Invoice setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
		return this;
	}

	@Override
	public String getShipToOrganisationID() {
		return shipToOrganisationID;
	}

	public Invoice setShipToOrganisationID(String shipToOrganisationID) {
		this.shipToOrganisationID = shipToOrganisationID;
		return this;
	}

	@Override
	public String getShipToOrganisationName() {
		return shipToOrganisationName;
	}

	public Invoice setShipToOrganisationName(String shipToOrganisationName) {
		this.shipToOrganisationName = shipToOrganisationName;
		return this;
	}

	@Override
	public String getShipToStreet() {
		return shipToStreet;
	}



	public Invoice setShipToStreet(String shipToStreet) {
		this.shipToStreet = shipToStreet;
		return this;
	}

	@Override
	public String getShipToZIP() {
		return shipToZIP;
	}

	public Invoice setShipToZIP(String shipToZIP) {
		this.shipToZIP = shipToZIP;
		return this;
	}

	@Override
	public String getShipToLocation() {
		return shipToLocation;
	}

	public Invoice setShipToLocation(String shipToLocation) {
		this.shipToLocation = shipToLocation;
		return this;
	}

	@Override
	public String getShipToCountry() {
		return shipToCountry;
	}

	public Invoice setShipToCountry(String shipToCountry) {
		this.shipToCountry = shipToCountry;
		return this;
	}

	@Override
	public String getBuyerOrderReferencedDocumentID() {
		return buyerOrderReferencedDocumentID;
	}

	public Invoice setBuyerOrderReferencedDocumentID(String buyerOrderReferencedDocumentID) {
		this.buyerOrderReferencedDocumentID = buyerOrderReferencedDocumentID;
		return this;
	}

	@Override
	public String getBuyerOrderReferencedDocumentIssueDateTime() {
		return buyerOrderReferencedDocumentIssueDateTime;
	}

	public Invoice setBuyerOrderReferencedDocumentIssueDateTime(String buyerOrderReferencedDocumentIssueDateTime) {
		this.buyerOrderReferencedDocumentIssueDateTime = buyerOrderReferencedDocumentIssueDateTime;
		return this;
	}

	@Override
	public String getOwnTaxID() {
		return getSender().getTaxID();
	}


	@Deprecated
	/***
	 * @deprecated use TradeParty::addTaxID instead
	 */
	public Invoice setOwnTaxID(String ownTaxID) {
		sender.addTaxID(ownTaxID);
		return this;
	}

	@Override
	public String getOwnVATID() {
		return getSender().getVATID();
	}

	@Deprecated
	/***
	 * @deprecated use TradeParty::addVATID instead
	 */
	public Invoice setOwnVATID(String ownVATID) {
		sender.addVATID(ownVATID);
		return this;
	}

	@Override
	public String getOwnForeignOrganisationID() {
		return ownForeignOrganisationID;
	}

	public Invoice setOwnForeignOrganisationID(String ownForeignOrganisationID) {
		this.ownForeignOrganisationID = ownForeignOrganisationID;
		return this;
	}

	@Override
	public String getOwnOrganisationName() {
		return ownOrganisationName;
	}

	public Invoice setOwnOrganisationName(String ownOrganisationName) {
		this.ownOrganisationName = ownOrganisationName;
		return this;
	}

	@Override
	public String getOwnStreet() {
		return sender.getStreet();
	}


	@Override
	public String getOwnZIP() {
		return sender.getZIP();
	}


	public String getOwnLocation() {
		return sender.getLocation();
	}


	public String getOwnCountry() {
		return sender.getCountry();
	}


	@Override
	public String getCurrency() {
		return currency;
	}

	public Invoice setCurrency(String currency) {
		this.currency = currency;
		return this;
	}

	@Override
	public String getPaymentTermDescription() {
		return paymentTermDescription;
	}

	public Invoice setPaymentTermDescription(String paymentTermDescription) {
		this.paymentTermDescription = paymentTermDescription;
		return this;
	}

	@Override
	public Date getIssueDate() {
		return issueDate;
	}

	public Invoice setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
		return this;
	}

	@Override
	public Date getDueDate() {
		return dueDate;
	}

	public Invoice setDueDate(Date dueDate) {
		this.dueDate = dueDate;
		return this;
	}

	@Override
	public Date getDeliveryDate() {
		return deliveryDate;
	}

	public Invoice setDeliveryDate(Date deliveryDate) {
		this.deliveryDate = deliveryDate;
		return this;
	}

	@Override
	public BigDecimal getTotalPrepaidAmount() {
		return totalPrepaidAmount;
	}

	public Invoice setTotalPrepaidAmount(BigDecimal totalPrepaidAmount) {
		this.totalPrepaidAmount = totalPrepaidAmount;
		return this;
	}

	@Override
	public IZUGFeRDExportableTradeParty getSender() {
		return sender;
	}

	public Invoice setOwnContact(Contact ownContact) {
		this.sender.setContact(ownContact);
		return this;
	}

	public IZUGFeRDExportableTradeParty getRecipient() {
		return recipient;
	}

	public Invoice setRecipient(TradeParty recipient) {
		this.recipient = recipient;
		return this;
	}

	public Invoice setSender(TradeParty sender) {
		this.sender = sender;
		if ((sender.getBankDetails()!=null)&&(sender.getBankDetails().size()>0)) {
			// convert bankdetails

		}
		return this;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		if (Allowances.isEmpty()) {
			return null;
		} else
		return Allowances.toArray(new IZUGFeRDAllowanceCharge[0]);
	}


	@Override
	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		if (Charges.isEmpty()) {
			return null;
		} else
			return Charges.toArray(new IZUGFeRDAllowanceCharge[0]);
	}


	@Override
	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		if (LogisticsServiceCharges.isEmpty()) {
			return null;
		} else
			return LogisticsServiceCharges.toArray(new IZUGFeRDAllowanceCharge[0]);
	}


	@Override
	public IZUGFeRDTradeSettlement[] getTradeSettlement() {

		if (getSender()==null) {
			return null;
		}

		return ((TradeParty)getSender()).getAsTradeSettlement();

	}


	@Override
	public IZUGFeRDPaymentTerms getPaymentTerms() {
		return paymentTerms;
	}

	public Invoice setPaymentTerms(IZUGFeRDPaymentTerms paymentTerms) {
		this.paymentTerms = paymentTerms;
		return this;
	}

	@Override
	public TradeParty getDeliveryAddress() {
		return deliveryAddress;
	}

	public Invoice setDeliveryAddress(TradeParty deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
		return this;
	}

	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		return ZFItems.toArray(new IZUGFeRDExportableItem[0]);
	}

	public Invoice addItem(IZUGFeRDExportableItem item) {
		ZFItems.add(item);
		return this;
	}




	/***
	 * checks if all required items are set in order to be able to export it
	 * @return true if all required items are set
	 */
	public boolean isValid() {
		return (dueDate != null) && (sender != null) && (sender.getTaxID() != null) && (sender.getVATID() != null) && (recipient != null);
		//contact
		//		this.phone = phone;
		//		this.email = email;
		//		this.street = street;
		//		this.zip = zip;
		//		this.location = location;
		//		this.country = country;
	}

	public Invoice addCharge(IZUGFeRDAllowanceCharge izac) {
		Charges.add(izac);
		return this;
	}
	public Invoice addAllowance(IZUGFeRDAllowanceCharge izac) {
		Allowances.add(izac);
		return this;
	}

	public Invoice setContractReferencedDocument(String s) {
		contractReferencedDocument=s;
		return this;
	}

	public Invoice setOccurrenceDate(Date occur) {
		occurrenceDateFrom=occur;
		occurrenceDateTo=null;

		return this;
	}

	public Invoice setOccurrencePeriod(Date start, Date end) {
		occurrenceDateFrom=start;
		occurrenceDateTo=end;

		return this;
	}

	@Override
	public Date getOccurrenceDate() {

		return occurrenceDateFrom;
	}

	@Override
	public Date getOccurrencePeriodFrom() {
		if (occurrenceDateTo!=null)  {
			return occurrenceDateFrom;
		} else {
			return null;
		}
	}
	@Override
	public Date getOccurrencePeriodTo() {
		if (occurrenceDateTo!=null)  {
			return occurrenceDateTo;
		} else {
			return null;
		}
	}

}
