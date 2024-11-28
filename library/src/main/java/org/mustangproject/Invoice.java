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

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.*;
import org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

/***
 * An invoice, with fluent setters
 * @see IExportableTransaction if you want to implement an interface instead
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Invoice implements IExportableTransaction {

	protected String documentName = null, documentCode = null, number = null, ownOrganisationFullPlaintextInfo = null, referenceNumber = null, shipToOrganisationID = null, shipToOrganisationName = null, shipToStreet = null, shipToZIP = null, shipToLocation = null, shipToCountry = null, buyerOrderReferencedDocumentID = null, invoiceReferencedDocumentID = null, buyerOrderReferencedDocumentIssueDateTime = null, ownForeignOrganisationID = null, ownOrganisationName = null, currency = null, paymentTermDescription = null;
	protected Date issueDate = null, dueDate = null, deliveryDate = null;
	protected TradeParty sender = null, recipient = null, deliveryAddress = null, payee = null;
	protected ArrayList<CashDiscount> cashDiscounts = null;
	@JsonDeserialize(contentAs = Item.class)
	protected ArrayList<IZUGFeRDExportableItem> ZFItems = null;
	protected ArrayList<String> notes = null;
	private List<IncludedNote> includedNotes = null;
	protected String sellerOrderReferencedDocumentID;
	protected String contractReferencedDocument = null;
	protected ArrayList<FileAttachment> xmlEmbeddedFiles = null;

	protected BigDecimal totalPrepaidAmount = null;
	protected Date detailedDeliveryDateStart = null;
	protected Date detailedDeliveryPeriodEnd = null;

	protected ArrayList<IZUGFeRDAllowanceCharge> Allowances = new ArrayList<>(),
		Charges = new ArrayList<>(), LogisticsServiceCharges = new ArrayList<>();
	protected IZUGFeRDPaymentTerms paymentTerms = null;
	protected Date invoiceReferencedIssueDate;
	protected String specifiedProcuringProjectID = null;
	protected String specifiedProcuringProjectName = null;
	protected String despatchAdviceReferencedDocumentID = null;
	protected String vatDueDateTypeCode = null;
	protected String creditorReferenceID; // required when direct debit is used.
	private BigDecimal roundingAmount=null;

	public Invoice() {
		ZFItems = new ArrayList<>();
		cashDiscounts = new ArrayList<>();
		setCurrency("EUR");
	}

	@Override
	public String getDocumentName() {
		return documentName;
	}

	@Override
	public String getContractReferencedDocument() {
		return contractReferencedDocument;
	}

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

	public Invoice embedFileInXML(FileAttachment fa) {
		if (xmlEmbeddedFiles == null) {
			xmlEmbeddedFiles = new ArrayList<>();
		}
		xmlEmbeddedFiles.add(fa);
		return this;
	}

	@Override
	public FileAttachment[] getAdditionalReferencedDocuments() {
		if (xmlEmbeddedFiles == null) {
			return null;
		}
		return xmlEmbeddedFiles.toArray(new FileAttachment[0]);

	}

	@Override
	public IZUGFeRDCashDiscount[] getCashDiscounts() {
		return cashDiscounts.toArray(new IZUGFeRDCashDiscount[0]);
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
	 * switch type to invoice correction and refer to document number.
	 * Please note that the quantities need to be negative, if you
	 * e.g. delivered 100 and take 50 back the quantity should be -50 in the
	 * corrected invoice, which will result in negative VAT and a negative payment amount
	 * @param number the invoice number to be corrected
	 * @return this object (fluent setter)
	 */
	public Invoice setCorrection(String number) {
		setInvoiceReferencedDocumentID(number);
		documentCode = DocumentCodeTypeConstants.CORRECTEDINVOICE;
		return this;
	}

	public Invoice setCreditNote() {
		documentCode = DocumentCodeTypeConstants.CREDITNOTE;
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

	@Override
	public String getSellerOrderReferencedDocumentID() {
		return sellerOrderReferencedDocumentID;
	}


	public Invoice setSellerOrderReferencedDocumentID(String sellerOrderReferencedDocumentID) {
		this.sellerOrderReferencedDocumentID = sellerOrderReferencedDocumentID;
		return this;
	}

	/***
	 * usually the order number
	 * @param buyerOrderReferencedDocumentID string with number
	 * @return fluent setter
	 */
	public Invoice setBuyerOrderReferencedDocumentID(String buyerOrderReferencedDocumentID) {
		this.buyerOrderReferencedDocumentID = buyerOrderReferencedDocumentID;
		return this;
	}

	/***
	 * usually in case of a correction the original invoice number
	 * @param invoiceReferencedDocumentID string with number
	 * @return fluent setter
	 */
	public Invoice setInvoiceReferencedDocumentID(String invoiceReferencedDocumentID) {
		this.invoiceReferencedDocumentID = invoiceReferencedDocumentID;
		return this;
	}

	@Override
	public String getInvoiceReferencedDocumentID() {
		return invoiceReferencedDocumentID;
	}

	@Override
	public Date getInvoiceReferencedIssueDate() {
		return invoiceReferencedIssueDate;
	}

	public Invoice setInvoiceReferencedIssueDate(Date issueDate) {
		this.invoiceReferencedIssueDate = issueDate;
		return this;
	}

	@Override
	public String getBuyerOrderReferencedDocumentIssueDateTime() {
		return buyerOrderReferencedDocumentIssueDateTime;
	}


	/***
	 * allow to set a amount which has already been paid
	 * @param prepaid null is possible to omit
	 * @return fluent setter
	 */
	public Invoice setTotalPrepaidAmount(BigDecimal prepaid) {
		totalPrepaidAmount = prepaid;
		return this;
	}

	@Override
	public BigDecimal getTotalPrepaidAmount() {
		return totalPrepaidAmount;
	}

	/***
	 * when the order (or whatever reference in BuyerOrderReferencedDocumentID) was issued (@todo switch to date?)
	 * @param buyerOrderReferencedDocumentIssueDateTime  IssueDateTime in format CCYY-MM-DDTHH:MM:SS
	 * @return fluent setter
	 */
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
	 * @see TradeParty
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
	 * @see TradeParty
	 */
	public Invoice setOwnVATID(String ownVATID) {
		sender.addVATID(ownVATID);
		return this;
	}

	@Override
	public String getOwnForeignOrganisationID() {
		return ownForeignOrganisationID;
	}


	@Deprecated
	/***
	 * @deprecated use TradeParty instead
	 * @see TradeParty
	 */
	public Invoice setOwnForeignOrganisationID(String ownForeignOrganisationID) {
		this.ownForeignOrganisationID = ownForeignOrganisationID;
		return this;
	}

	@Override
	public String getOwnOrganisationName() {
		return ownOrganisationName;
	}


	@Deprecated
	/***
	 * @deprecated use senders' TradeParty's name instead
	 * @see TradeParty
	 */
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


	@Override
	public String getOwnLocation() {
		return sender.getLocation();
	}


	@Override
	public String getOwnCountry() {
		return sender.getCountry();
	}


	@Override
	public String[] getNotes() {
		if (notes == null) {
			return null;
		}
		return notes.toArray(new String[0]);
	}

	@Override
	public List<IncludedNote> getNotesWithSubjectCode() {
		return includedNotes;
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
	public TradeParty getSender() {
		return sender;
	}

	/***
	 * for currency rounding differences to 5ct e.g. in Netherlands ("Rappenrundung")
	 * @return null if not set, otherwise BigDecimal of Euros
	 */
	@Override
	public BigDecimal getRoundingAmount() {
		return roundingAmount;
	}

	/***
	 * set the cent e.g. to reach the next 5ct mark for currencies in certain countries
	 * e.g. in the Netherlands ("Rappenrundung")
	 * @param amount
	 * @return fluent setter
	 */
	public Invoice setRoundingAmount(BigDecimal amount) {
		 roundingAmount=amount;
		 return this;
	}

	/***
	 * sets a named sender contact
	 * @deprecated use setSender
	 * @see Contact
	 * @param ownContact the sender contact
	 * @return fluent setter
	 */
	@Deprecated
	public Invoice setOwnContact(Contact ownContact) {
		this.sender.setContact(ownContact);
		return this;
	}

	@Override
	public TradeParty getRecipient() {
		return recipient;
	}

	/**
	 * required.
	 * sets the invoice receiving institution = invoicee
	 *
	 * @param recipient the invoicee organisation
	 * @return fluent setter
	 */
	public Invoice setRecipient(TradeParty recipient) {
		this.recipient = recipient;
		return this;
	}

	/**
	 * required.
	 * sets the invoicing institution = invoicer
	 *
	 * @param sender the invoicer
	 * @return fluent setter
	 */
	public Invoice setSender(TradeParty sender) {
		this.sender = sender;
		if ((sender.getBankDetails() != null) && (sender.getBankDetails().size() > 0)) {
			// convert bankdetails

		}
		return this;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		if (Allowances.isEmpty()) {
			return null;
		} else {
			return Allowances.toArray(new IZUGFeRDAllowanceCharge[0]);
		}
	}

	/***
	 * this is wrong and only used from jackson
	 * @param iza the Array of allowances/charges
	 * @return fluent setter
	 */
	public Invoice setZFAllowances(Allowance[] iza) {
		Allowances=new ArrayList<>();

		for (IZUGFeRDAllowanceCharge cz:iza) {
			Allowances.add(cz);
		}
		return this;
	}


	@Override
	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		if (Charges.isEmpty()) {
			return null;
		} else {
			return Charges.toArray(new IZUGFeRDAllowanceCharge[0]);
		}
	}

	/***
	 * this is wrong and only used from jackson
	 * @param iza the array of charges
	 * @return fluent setter
	 */
	public Invoice setZFCharges(Charge[] iza) {
		Charges=new ArrayList<>();
		for (IZUGFeRDAllowanceCharge cz:iza) {
			Charges.add(cz);
		}
		return this;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		if (LogisticsServiceCharges.isEmpty()) {
			return null;
		} else {
			return LogisticsServiceCharges.toArray(new IZUGFeRDAllowanceCharge[0]);
		}
	}


	@Override
	public IZUGFeRDTradeSettlement[] getTradeSettlement() {

		if (getSender() == null) {
			return null;
		}

		return getSender().getAsTradeSettlement();

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

	/***
	 * if the delivery address is not the recipient address, it can be specified here
	 * @param deliveryAddress the goods receiving organisation
	 * @return fluent setter
	 */
	public Invoice setDeliveryAddress(TradeParty deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
		return this;
	}

	@Override
	public TradeParty getPayee() {
		return this.payee;
	}

	/***
	 * if the payee is not the seller, it can be specified here
	 * @param payee the payment receiving organisation
	 * @return fluent setter
	 */
	public Invoice setPayee(TradeParty payee) {
		this.payee = payee;
		return this;
	}

	/***
	 * Adds a cash discount (skonto)
	 * @param c the CashDiscount percent/period combination
	 * @return fluent setter
	 */
	public Invoice addCashDiscount(CashDiscount c) {
		this.cashDiscounts.add(c);
		return this;
	}


	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		return ZFItems.toArray(new IZUGFeRDExportableItem[0]);
	}

	public void setZFItems(ArrayList<IZUGFeRDExportableItem> ims) {
		ZFItems = ims;
	}

	/**
	 * required
	 * adds invoice "lines" :-)
	 *
	 * @param item the invoice line
	 * @return fluent setter
	 * @see Item
	 */
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

	/***
	 * adds a document level addition to the price
	 * @see Charge
	 * @param izac the charge to be applied
	 * @return fluent setter
	 */
	public Invoice addCharge(IZUGFeRDAllowanceCharge izac) {
		Charges.add(izac);
		return this;
	}

	/***
	 * adds a document level rebate
	 * @see Allowance
	 * @param izac the allowance to be applied
	 * @return fluent setter
	 */
	public Invoice addAllowance(IZUGFeRDAllowanceCharge izac) {
		Allowances.add(izac);
		return this;
	}

	/***
	 * adds the ID of a contract referenced in the invoice
	 * @param s the contract number
	 * @return fluent setter
	 */
	public Invoice setContractReferencedDocument(String s) {
		contractReferencedDocument = s;
		return this;
	}


	/***
	 * sets a document level delivery period,
	 * which is optional additional to the mandatory deliverydate
	 * and which will become a BillingSpecifiedPeriod-Element
	 * @param start the date of first delivery
	 * @param end the date of last delivery
	 * @return fluent setter
	 */
	public Invoice setDetailedDeliveryPeriod(Date start, Date end) {
		detailedDeliveryDateStart = start;
		detailedDeliveryPeriodEnd = end;

		return this;
	}


	@Override
	public Date getDetailedDeliveryPeriodFrom() {
		return detailedDeliveryDateStart;
	}

	@Override
	public Date getDetailedDeliveryPeriodTo() {
		return detailedDeliveryPeriodEnd;
	}


	/**
	 * adds a free text paragraph, which will become an includedNote element
	 *
	 * @param text freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addNote(String text) {
		if (notes == null) {
			notes = new ArrayList<>();
		}
		notes.add(text);
		return this;
	}

	public Invoice addNotes(Collection<IncludedNote> notes) {
		if (notes == null) {
			return this;
		}
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.addAll(notes);
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#AAI}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addGeneralNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.generalNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#REG}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addRegulatoryNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.regulatoryNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#ABL}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addLegalNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.legalNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#CUS}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addCustomsNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.customsNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#SUR}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addSellerNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.sellerNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#TXD}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addTaxNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.taxNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#ACY}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addIntroductionNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.introductionNote(content));
		return this;
	}

	/**
	 * adds a free text paragraph, which will become an includedNote element with explicit
	 * subjectCode {@link SubjectCode#AAK}
	 *
	 * @param content freeform UTF8 plain text
	 * @return fluent setter
	 */
	public Invoice addDiscountBonusNote(String content) {
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(IncludedNote.discountBonusNote(content));
		return this;
	}

	@Override
	public String getSpecifiedProcuringProjectID() {
		return specifiedProcuringProjectID;
	}

	public Invoice setSpecifiedProcuringProjectID(String specifiedProcuringProjectID) {
		this.specifiedProcuringProjectID = specifiedProcuringProjectID;
		return this;
	}

	@Override
	public String getDespatchAdviceReferencedDocumentID() {
		return despatchAdviceReferencedDocumentID;
	}


	public Invoice setDespatchAdviceReferencedDocumentID(String despatchAdviceReferencedDocumentID) {
		this.despatchAdviceReferencedDocumentID = despatchAdviceReferencedDocumentID;
		return this;
	}


	@Override
	public String getSpecifiedProcuringProjectName() {
		return specifiedProcuringProjectName;
	}

	public Invoice setSpecifiedProcuringProjectName(String specifiedProcuringProjectName) {
		this.specifiedProcuringProjectName = specifiedProcuringProjectName;
		return this;
	}

	@Override
	public String getVATDueDateTypeCode() {
		return vatDueDateTypeCode;
	}

	/**
	 * Decide when the VAT should be collected.
	 *
	 * @param vatDueDateTypeCode use EventTimeCodeTypeConstants
	 * @return fluent setter
	 */
	public Invoice setVATDueDateTypeCode(String vatDueDateTypeCode) {
		this.vatDueDateTypeCode = vatDueDateTypeCode;
		return this;
	}

	public String getCreditorReferenceID() {
		return creditorReferenceID;
	}

	public Invoice setCreditorReferenceID(String creditorReferenceID) {
		this.creditorReferenceID = creditorReferenceID;
		return this;
	}

}
