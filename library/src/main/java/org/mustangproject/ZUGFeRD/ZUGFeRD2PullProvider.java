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
package org.mustangproject.ZUGFeRD;

import static org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat.DATE;
import static org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants.CATEGORY_CODES_WITH_EXEMPTION_REASON;

import java.io.IOException;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.stream.Collectors;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.FileAttachment;
import org.mustangproject.IncludedNote;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.XMLTools;
import org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ZUGFeRD2PullProvider implements IXMLProvider {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRD2PullProvider.class);

	protected byte[] zugferdData;
	protected IExportableTransaction trans;
	protected TransactionCalculator calc;
	private String paymentTermsDescription;
	protected Profile profile = Profiles.getByName("EN16931");


	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 */
	@Override
	public void setTest() {
	}

	protected String vatFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 2);
	}

	protected String currencyFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 2);
	}

	protected String priceFormat(BigDecimal value) {
		// 18 decimals are max for price and qty due  to xml restrictions,
		// see Chapter 3.2.3 of https://www.w3.org/TR/xmlschema-2/
		return XMLTools.nDigitFormatDecimalRange(value, 18, 4);
	}

	protected String quantityFormat(BigDecimal value) {
		return XMLTools.nDigitFormatDecimalRange(value, 18, 4);
	}

	@Override
	public byte[] getXML() {

		byte[] res = zugferdData;

		final StringWriter sw = new StringWriter();
		Document document = null;
		try {
			document = DocumentHelper.parseText(new String(zugferdData));
		} catch (final DocumentException e1) {
			LOGGER.error("Failed to parse ZUGFeRD data", e1);
		}
		try {
			final OutputFormat format = OutputFormat.createPrettyPrint();
			format.setTrimText(false);
			final XMLWriter writer = new XMLWriter(sw, format);
			writer.write(document);
			res = sw.toString().getBytes(StandardCharsets.UTF_8);

		} catch (final IOException e) {
			LOGGER.error("Failed to write ZUGFeRD data", e);
		}

		return res;

	}


	@Override
	public Profile getProfile() {
		return profile;
	}

	// @todo check if the two boolean args can be refactored

	/***
	 * returns the UN/CEFACT CII XML for companies(tradeparties), which is actually
	 * the same for ZF1 (v 2013b) and ZF2 (v 2016b)
	 * @param party any sender, recipient, seller or legal party involved
	 * @param isSender some attributes are allowed only for senders in certain profiles
	 * @param isShipToTradeParty some attributes are allowed only for senders or recipients
	 * @return CII XML
	 */
	protected String getTradePartyAsXML(IZUGFeRDExportableTradeParty party, boolean isSender, boolean isShipToTradeParty) {
		String xml = "";
		// According EN16931 either GlobalID or seller assigned ID might be present for BuyerTradeParty
		// and ShipToTradeParty, but not both. Prefer seller assigned ID for now.
		if (party.getID() != null) {
			xml += "<ram:ID>" + XMLTools.encodeXML(party.getID()) + "</ram:ID>";
		}
		if ((party.getGlobalIDScheme() != null) && (party.getGlobalID() != null)) {
			xml += "<ram:GlobalID schemeID=\"" + XMLTools.encodeXML(party.getGlobalIDScheme()) + "\">"
				+ XMLTools.encodeXML(party.getGlobalID()) + "</ram:GlobalID>";
		}
		xml += "<ram:Name>" + XMLTools.encodeXML(party.getName()) + "</ram:Name>";
		if (party.getDescription() != null) {
			xml += "<ram:Description>" + XMLTools.encodeXML(party.getDescription()) + "</ram:Description>";
		}
		if (party.getLegalOrganisation() != null) {
			xml += "<ram:SpecifiedLegalOrganization> ";
			if (party.getLegalOrganisation().getSchemedID() != null) {
				if (profile == Profiles.getByName("Minimum")) {
					xml += "<ram:ID>" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>";
				} else {
					String schemeAttribute="";
					if ((party.getLegalOrganisation().getSchemedID().getScheme()!=null)&&(party.getLegalOrganisation().getSchemedID().getScheme().length()>0)) {
						schemeAttribute="schemeID=\"" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getScheme())+"\"";

					}
					xml += "<ram:ID "+schemeAttribute+">" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>";
				}
			}
			if (party.getLegalOrganisation().getTradingBusinessName() != null) {
				xml += "<ram:TradingBusinessName>" + XMLTools.encodeXML(party.getLegalOrganisation().getTradingBusinessName()) + "</ram:TradingBusinessName>";
			}
			xml += "</ram:SpecifiedLegalOrganization>";
		}

		if ((party.getContact() != null) && (isSender || profile == Profiles.getByName("EN16931") || profile == Profiles.getByName("Extended") || profile == Profiles.getByName("XRechnung"))) {
			xml += "<ram:DefinedTradeContact>";
			if (party.getContact().getName() != null) {
				xml += "<ram:PersonName>"
					+ XMLTools.encodeXML(party.getContact().getName())
					+ "</ram:PersonName>";
			}
			if (party.getContact().getPhone() != null) {
				xml += "<ram:TelephoneUniversalCommunication><ram:CompleteNumber>"
					+ XMLTools.encodeXML(party.getContact().getPhone()) + "</ram:CompleteNumber>"
					+ "</ram:TelephoneUniversalCommunication>";
			}

			if ((party.getContact().getFax() != null) && (profile == Profiles.getByName("Extended"))) {
				xml += "<ram:FaxUniversalCommunication><ram:CompleteNumber>"
					+ XMLTools.encodeXML(party.getContact().getFax()) + "</ram:CompleteNumber>"
					+ "</ram:FaxUniversalCommunication>";
			}
			if (party.getContact().getEMail() != null) {
				xml += "<ram:EmailURIUniversalCommunication><ram:URIID>"
					+ XMLTools.encodeXML(party.getContact().getEMail()) + "</ram:URIID>"
					+ "</ram:EmailURIUniversalCommunication>";
			}
			xml += "</ram:DefinedTradeContact>";
		}

		xml += "<ram:PostalTradeAddress>";
		if (party.getZIP() != null) {
			xml += "<ram:PostcodeCode>" + XMLTools.encodeXML(party.getZIP())
				+ "</ram:PostcodeCode>";
		}
		if (party.getStreet() != null) {
			xml += "<ram:LineOne>" + XMLTools.encodeXML(party.getStreet())
				+ "</ram:LineOne>";
		}
		if (party.getAdditionalAddress() != null) {
			xml += "<ram:LineTwo>" + XMLTools.encodeXML(party.getAdditionalAddress())
				+ "</ram:LineTwo>";
		}
		if (party.getAdditionalAddressExtension() != null) {
			xml += "<ram:LineThree>" + XMLTools.encodeXML(party.getAdditionalAddressExtension())
				+ "</ram:LineThree>";
		}
		if (party.getLocation() != null) {
			xml += "<ram:CityName>" + XMLTools.encodeXML(party.getLocation())
				+ "</ram:CityName>";
		}

		//country IS mandatory
		xml += "<ram:CountryID>" + XMLTools.encodeXML(party.getCountry())
			+ "</ram:CountryID>"
			+ "</ram:PostalTradeAddress>";
		if (party.getUriUniversalCommunicationID() != null && party.getUriUniversalCommunicationIDScheme() != null) {
			xml += "<ram:URIUniversalCommunication>" +
				"<ram:URIID schemeID=\"" + party.getUriUniversalCommunicationIDScheme() + "\">" +
				XMLTools.encodeXML(party.getUriUniversalCommunicationID())
				+ "</ram:URIID></ram:URIUniversalCommunication>";
		}

		if ((party.getVATID() != null) && (!isShipToTradeParty)) {
			xml += "<ram:SpecifiedTaxRegistration>"
				+ "<ram:ID schemeID=\"VA\">" + XMLTools.encodeXML(party.getVATID())
				+ "</ram:ID>"
				+ "</ram:SpecifiedTaxRegistration>";
		}
		if ((party.getTaxID() != null) && (!isShipToTradeParty)) {
			xml += "<ram:SpecifiedTaxRegistration>"
				+ "<ram:ID schemeID=\"FC\">" + XMLTools.encodeXML(party.getTaxID())
				+ "</ram:ID>"
				+ "</ram:SpecifiedTaxRegistration>";

		}
		return xml;

	}

	protected String getTradePartyPayeeAsXML(IZUGFeRDExportableTradeParty party) {
		String xml = "";
		// According EN16931 either GlobalID or seller assigned ID might be present for a Payee
		if (party.getID() != null) {
			xml += "<ram:ID>" + XMLTools.encodeXML(party.getID()) + "</ram:ID>";
		}
		if ((party.getGlobalIDScheme() != null) && (party.getGlobalID() != null)) {
			xml += "<ram:GlobalID schemeID=\"" + XMLTools.encodeXML(party.getGlobalIDScheme()) + "\">"
				+ XMLTools.encodeXML(party.getGlobalID())
				+ "</ram:GlobalID>";
		}
		xml += "<ram:Name>" + XMLTools.encodeXML(party.getName()) + "</ram:Name>";

		if (party.getLegalOrganisation() != null) {
			xml += "<ram:SpecifiedLegalOrganization> ";
			if (party.getLegalOrganisation().getSchemedID() != null) {
				xml += "<ram:ID schemeID=\"" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getScheme()) + "\">" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>";
			}
			xml += "</ram:SpecifiedLegalOrganization>";
		}

		return xml;
	}


	/***
	 * returns the XML for a charge or allowance on item level
	 * @param allowance the allowance or charge on this item
	 * @param item the item
	 * @return CII XML
	 */
	protected String getAllowanceChargeStr(IZUGFeRDAllowanceCharge allowance, IAbsoluteValueProvider item) {
		String percentage = "";
		String chargeIndicator = "false";
		if ((allowance.getPercent() != null) && (profile == Profiles.getByName("Extended"))) {
			percentage = "<ram:CalculationPercent>" + vatFormat(allowance.getPercent()) + "</ram:CalculationPercent>";
			percentage += "<ram:BasisAmount>" + item.getValue() + "</ram:BasisAmount>";
		}
		if (allowance.isCharge()) {
			chargeIndicator = "true";
		}

		String reason = "";
		if ((allowance.getReason() != null) && (profile == Profiles.getByName("Extended") || profile == Profiles.getByName("XRechnung") || profile == Profiles.getByName("EN16931"))) {
			reason = "<ram:Reason>" + XMLTools.encodeXML(allowance.getReason()) + "</ram:Reason>";
		}
		String reasonCode = "";
		if (allowance.getReasonCode() != null) {
			// only in XRechnung profile
			reasonCode = "<ram:ReasonCode>" + allowance.getReasonCode() + "</ram:ReasonCode>";
		}
		final String allowanceChargeStr = "<ram:AppliedTradeAllowanceCharge><ram:ChargeIndicator><udt:Indicator>" +
			chargeIndicator + "</udt:Indicator></ram:ChargeIndicator>" + percentage +
			"<ram:ActualAmount>" + priceFormat(allowance.getTotalAmount(item)) + "</ram:ActualAmount>" +
			reasonCode +
			reason +
			"</ram:AppliedTradeAllowanceCharge>";
		return allowanceChargeStr;
	}

	/***
	 * returns the XML for a charge or allowance on item total level
	 * @param allowance the allowance or charge
	 * @param item the line
	 * @return CII XML
	 */
	protected String getItemTotalAllowanceChargeStr(IZUGFeRDAllowanceCharge allowance, IAbsoluteValueProvider item) {
		String percentage = "";
		String chargeIndicator = "false";
		if ((allowance.getPercent() != null) && (profile == Profiles.getByName("Extended"))) {
			percentage = "<ram:CalculationPercent>" + vatFormat(allowance.getPercent()) + "</ram:CalculationPercent>";
			percentage += "<ram:BasisAmount>" + item.getValue() + "</ram:BasisAmount>";
		}
		if (allowance.isCharge()) {
			chargeIndicator = "true";
		}

		String reason = "";
		if ((allowance.getReason() != null) && (profile == Profiles.getByName("Extended") || profile == Profiles.getByName("XRechnung"))) {
			reason = "<ram:Reason>" + XMLTools.encodeXML(allowance.getReason()) + "</ram:Reason>";
		}
		String reasonCode = "";
		if ((allowance.getReasonCode() != null) && (profile == Profiles.getByName("XRechnung"))) {
			// only in XRechnung profile
			reasonCode = "<ram:ReasonCode>" + allowance.getReasonCode() + "</ram:ReasonCode>";
		}
		final String itemTotalAllowanceChargeStr = "<ram:SpecifiedTradeAllowanceCharge><ram:ChargeIndicator><udt:Indicator>" +
			chargeIndicator + "</udt:Indicator></ram:ChargeIndicator>" + percentage +
			"<ram:ActualAmount>" + currencyFormat(allowance.getTotalAmount(item)) + "</ram:ActualAmount>" +
			reasonCode +
			reason +
			"</ram:SpecifiedTradeAllowanceCharge>";
		return itemTotalAllowanceChargeStr;
	}

	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;
		this.calc = new TransactionCalculator(trans);

		boolean hasDueDate = trans.getDueDate() != null;
		final SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");

		if (trans.getPaymentTermDescription() != null) {
			paymentTermsDescription = XMLTools.encodeXML(trans.getPaymentTermDescription());
		}


		if ((profile == Profiles.getByName("XRechnung")) && (trans.getCashDiscounts() != null) && (trans.getCashDiscounts().length > 0)) {
			for (IZUGFeRDCashDiscount discount : trans.getCashDiscounts()
			) {
				if (paymentTermsDescription == null) {
					paymentTermsDescription = "";
				}
				paymentTermsDescription += discount.getAsXRechnung();
			}
		} else if ((paymentTermsDescription == null) && (trans.getDocumentCode() != DocumentCodeTypeConstants.CORRECTEDINVOICE) && (trans.getDocumentCode() != DocumentCodeTypeConstants.CREDITNOTE)) {
			if (trans.getDueDate() != null) {
				paymentTermsDescription = "Please remit until " + germanDateFormat.format(trans.getDueDate());
			}
		}


		String typecode = "380";
		if (trans.getDocumentCode() != null) {
			typecode = trans.getDocumentCode();
		}
		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
			+ "<rsm:CrossIndustryInvoice xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100\""
			// + "
			// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
			// ../Schema/ZUGFeRD1p0.xsd\""
			+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100\""
			+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100\""
			+ " xmlns:qdt=\"urn:un:unece:uncefact:data:standard:QualifiedDataType:100\">"
			+ "<!-- generated by: mustangproject.org v" + ZUGFeRD2PullProvider.class.getPackage().getImplementationVersion() + "-->"
			+ "<rsm:ExchangedDocumentContext>\n";
		// + "
		// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>"
		//

		if (getProfile() == Profiles.getByName("XRechnung")) {
			xml += "<ram:BusinessProcessSpecifiedDocumentContextParameter>\n"
				+ "<ram:ID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</ram:ID>\n"
				+ "</ram:BusinessProcessSpecifiedDocumentContextParameter>\n";
		}
		xml +=
			"<ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "<ram:ID>" + getProfile().getID() + "</ram:ID>"
				+ "</ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "</rsm:ExchangedDocumentContext>"
				+ "<rsm:ExchangedDocument>"
				+ "<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>";
				if (profile == Profiles.getByName("Extended") && trans.getDocumentName() != null) {
					xml += "<ram:Name>" + XMLTools.encodeXML(trans.getDocumentName()) + "</ram:Name>";
				}
			xml += "<ram:TypeCode>" + typecode + "</ram:TypeCode>"
				+ "<ram:IssueDateTime>" + DATE.udtFormat(trans.getIssueDate()) + "</ram:IssueDateTime>" // date
				+ buildNotes(trans)
				+ "</rsm:ExchangedDocument>"
				+ "<rsm:SupplyChainTradeTransaction>";
		int lineID = 0;
		for (final IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			String lineIDStr = Integer.toString(lineID);
			if (currentItem.getId()!=null) {
				lineIDStr=currentItem.getId();
			}
			final LineCalculator lc = new LineCalculator(currentItem);
			if ((getProfile() != Profiles.getByName("Minimum")) && (getProfile() != Profiles.getByName("BasicWL"))) {
				xml += "<ram:IncludedSupplyChainTradeLineItem>" +
					"<ram:AssociatedDocumentLineDocument>"
					+ "<ram:LineID>" + lineIDStr + "</ram:LineID>"
					+ buildItemNotes(currentItem)
					+ "</ram:AssociatedDocumentLineDocument>"

					+ "<ram:SpecifiedTradeProduct>";
				if ((currentItem.getProduct().getGlobalIDScheme() != null) && (currentItem.getProduct().getGlobalID() != null)) {
					xml += "<ram:GlobalID schemeID=\"" + XMLTools.encodeXML(currentItem.getProduct().getGlobalIDScheme()) + "\">" + XMLTools.encodeXML(currentItem.getProduct().getGlobalID()) + "</ram:GlobalID>";
				}

				if (currentItem.getProduct().getSellerAssignedID() != null) {
					xml += "<ram:SellerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getSellerAssignedID()) + "</ram:SellerAssignedID>";
				}
				if (currentItem.getProduct().getBuyerAssignedID() != null) {
					xml += "<ram:BuyerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getBuyerAssignedID()) + "</ram:BuyerAssignedID>";
				}
				String allowanceChargeStr = "";
				if (currentItem.getItemAllowances() != null && currentItem.getItemAllowances().length > 0) {
					for (final IZUGFeRDAllowanceCharge allowance : currentItem.getItemAllowances()) {
						allowanceChargeStr += getAllowanceChargeStr(allowance, currentItem);
					}
				}
				if (currentItem.getItemCharges() != null && currentItem.getItemCharges().length > 0) {
					for (final IZUGFeRDAllowanceCharge charge : currentItem.getItemCharges()) {
						allowanceChargeStr += getAllowanceChargeStr(charge, currentItem);

					}
				}

				String itemTotalAllowanceChargeStr = "";
				if (currentItem.getItemTotalAllowances() != null && currentItem.getItemTotalAllowances().length > 0) {
					for (final IZUGFeRDAllowanceCharge itemTotalAllowance : currentItem.getItemTotalAllowances()) {
						itemTotalAllowanceChargeStr += getItemTotalAllowanceChargeStr(itemTotalAllowance, currentItem);
					}
				}

				xml += "<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>";
				if (currentItem.getProduct().getDescription().length() > 0) {
					xml += "<ram:Description>" +
						XMLTools.encodeXML(currentItem.getProduct().getDescription()) +
						"</ram:Description>";
				}
				if (currentItem.getProduct().getClassifications() != null && currentItem.getProduct().getClassifications().length > 0) {
					for (IDesignatedProductClassification classification : currentItem.getProduct().getClassifications()) {
						xml += "<ram:DesignatedProductClassification>"
							+ "<ram:ClassCode listID=\"" + XMLTools.encodeXML(classification.getClassCode().getListID()) + "\"";
						if (classification.getClassCode().getListVersionID() != null) {
							xml += " listVersionID=\"" + XMLTools.encodeXML(classification.getClassCode().getListVersionID()) + "\"";
						}
						xml += ">" + classification.getClassCode().getCode() + "</ram:ClassCode>";
						if (classification.getClassName() != null) {
							xml += "<ram:ClassName>" + XMLTools.encodeXML(classification.getClassName()) + "</ram:ClassName>";
						}
						xml += "</ram:DesignatedProductClassification>";
					}
				}
				if (currentItem.getProduct().getAttributes() != null) {
					for (Entry<String, String> entry : currentItem.getProduct().getAttributes().entrySet()) {
						xml += "<ram:ApplicableProductCharacteristic>" +
							"<ram:Description>" + XMLTools.encodeXML(entry.getKey()) + "</ram:Description>" +
							"<ram:Value>" + XMLTools.encodeXML(entry.getValue()) + "</ram:Value>" +
							"</ram:ApplicableProductCharacteristic>";
					}
				}
				if (currentItem.getProduct().getCountryOfOrigin() != null) {
					xml += "<ram:OriginTradeCountry><ram:ID>" +
						XMLTools.encodeXML(currentItem.getProduct().getCountryOfOrigin()) +
						"</ram:ID></ram:OriginTradeCountry>";
				}
				xml += "</ram:SpecifiedTradeProduct>"

					+ "<ram:SpecifiedLineTradeAgreement>";
				if (currentItem.getReferencedDocuments() != null) {
					for (final IReferencedDocument currentReferencedDocument : currentItem.getReferencedDocuments()) {
						xml += "<ram:AdditionalReferencedDocument>" +
							"<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentReferencedDocument.getIssuerAssignedID()) + "</ram:IssuerAssignedID>" +
							"<ram:TypeCode>" + XMLTools.encodeXML(currentReferencedDocument.getTypeCode()) + "</ram:TypeCode>" +
							"<ram:ReferenceTypeCode>" + XMLTools.encodeXML(currentReferencedDocument.getReferenceTypeCode()) + "</ram:ReferenceTypeCode>" +
							"</ram:AdditionalReferencedDocument>";
					}
				}
				if (currentItem.getBuyerOrderReferencedDocumentLineID() != null) {
					xml += "<ram:BuyerOrderReferencedDocument> "
						+ "<ram:LineID>" + XMLTools.encodeXML(currentItem.getBuyerOrderReferencedDocumentLineID()) + "</ram:LineID>"
						+ "</ram:BuyerOrderReferencedDocument>";
				}

				if (!allowanceChargeStr.isEmpty()) {
					xml += "<ram:GrossPriceProductTradePrice>"
						+ "<ram:ChargeAmount>" + priceFormat(lc.getPriceGross())
						+ "</ram:ChargeAmount>" //currencyID=\"EUR\"
						+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
						+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
						+ allowanceChargeStr
						// + "<AppliedTradeAllowanceCharge>"
						// + "<ChargeIndicator>false</ChargeIndicator>"
						// + "<ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>"
						// + "<Reason>Rabatt</Reason>"
						// + "</AppliedTradeAllowanceCharge>"
						+ "</ram:GrossPriceProductTradePrice>";
				}

				xml += "<ram:NetPriceProductTradePrice>"
					+ "<ram:ChargeAmount>" + priceFormat(lc.getPrice())
					+ "</ram:ChargeAmount>" // currencyID=\"EUR\"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
					+ "</ram:NetPriceProductTradePrice>"
					+ "</ram:SpecifiedLineTradeAgreement>"
					+ "<ram:SpecifiedLineTradeDelivery>"
					+ "<ram:BilledQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">"
					+ quantityFormat(currentItem.getQuantity()) + "</ram:BilledQuantity>"
					+ "</ram:SpecifiedLineTradeDelivery>"
					+ "<ram:SpecifiedLineTradeSettlement>"
					+ "<ram:ApplicableTradeTax>"
					+ "<ram:TypeCode>VAT</ram:TypeCode>";
				
				if (currentItem.getProduct().getTaxExemptionReason() != null) {
					xml += "<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
				}
					
				xml += "<ram:CategoryCode>" + currentItem.getProduct().getTaxCategoryCode() + "</ram:CategoryCode>"
					+ "<ram:RateApplicablePercent>"
					+ vatFormat(currentItem.getProduct().getVATPercent()) + "</ram:RateApplicablePercent>"
					+ "</ram:ApplicableTradeTax>";
				if ((currentItem.getDetailedDeliveryPeriodFrom() != null) || (currentItem.getDetailedDeliveryPeriodTo() != null)) {
					xml += "<ram:BillingSpecifiedPeriod>";
					if (currentItem.getDetailedDeliveryPeriodFrom() != null) {
						xml += "<ram:StartDateTime>" + DATE.udtFormat(currentItem.getDetailedDeliveryPeriodFrom()) + "</ram:StartDateTime>";
					}
					if (currentItem.getDetailedDeliveryPeriodTo() != null) {
						xml += "<ram:EndDateTime>" + DATE.udtFormat(currentItem.getDetailedDeliveryPeriodTo()) + "</ram:EndDateTime>";
					}
					xml += "</ram:BillingSpecifiedPeriod>";
				}

				xml += itemTotalAllowanceChargeStr;

				xml += "<ram:SpecifiedTradeSettlementLineMonetarySummation>"
					+ "<ram:LineTotalAmount>" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>" // currencyID=\"EUR\"
					+ "</ram:SpecifiedTradeSettlementLineMonetarySummation>";
				if (currentItem.getAdditionalReferences() != null) {
					for (final IReferencedDocument currentReference : currentItem.getAdditionalReferences()) {
						xml += "<ram:AdditionalReferencedDocument>" +
							"<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentReference.getIssuerAssignedID()) + "</ram:IssuerAssignedID>" +
							"<ram:TypeCode>130</ram:TypeCode>" +
							"<ram:ReferenceTypeCode>" + XMLTools.encodeXML(currentReference.getReferenceTypeCode()) + "</ram:ReferenceTypeCode>" +
							"</ram:AdditionalReferencedDocument>";
					}
				} else if (currentItem.getAdditionalReferencedDocumentID() != null) {
					xml += "<ram:AdditionalReferencedDocument><ram:IssuerAssignedID>" + currentItem.getAdditionalReferencedDocumentID() + "</ram:IssuerAssignedID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>";
				}
				xml += "</ram:SpecifiedLineTradeSettlement>"
					+ "</ram:IncludedSupplyChainTradeLineItem>";
			}

		}

		xml += "<ram:ApplicableHeaderTradeAgreement>";
		if (trans.getReferenceNumber() != null) {
			xml += "<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>";

		}
		xml += "<ram:SellerTradeParty>"
			+ getTradePartyAsXML(trans.getSender(), true, false)
			+ "</ram:SellerTradeParty>"
			+ "<ram:BuyerTradeParty>";
		// + "<ID>GE2020211</ID>"
		// + "<GlobalID schemeID=\"0088\">4000001987658</GlobalID>"

		xml += getTradePartyAsXML(trans.getRecipient(), false, false);
		xml += "</ram:BuyerTradeParty>";

		if (trans.getSellerOrderReferencedDocumentID() != null) {
			xml += "<ram:SellerOrderReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getSellerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>"
				+ "</ram:SellerOrderReferencedDocument>";
		}
		if (trans.getBuyerOrderReferencedDocumentID() != null) {
			xml += "<ram:BuyerOrderReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>"
				+ "</ram:BuyerOrderReferencedDocument>";
		}
		if (trans.getContractReferencedDocument() != null) {
			xml += "<ram:ContractReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getContractReferencedDocument()) + "</ram:IssuerAssignedID>"
				+ "</ram:ContractReferencedDocument>";
		}

		// Additional Documents of XRechnung (Rechnungsbegruendende Unterlagen - BG-24 XRechnung)
		if (trans.getAdditionalReferencedDocuments() != null) {
			for (final FileAttachment f : trans.getAdditionalReferencedDocuments()) {
				final String documentContent = new String(Base64.getEncoder().encodeToString(f.getData()));
				xml += "<ram:AdditionalReferencedDocument>"
					+ "<ram:IssuerAssignedID>" + f.getFilename() + "</ram:IssuerAssignedID>"
					+ "<ram:TypeCode>916</ram:TypeCode>"
					+ "<ram:Name>" + f.getDescription() + "</ram:Name>"
					+ "<ram:AttachmentBinaryObject mimeCode=\"" + f.getMimetype() + "\"\n"
					+ "filename=\"" + f.getFilename() + "\">" + documentContent + "</ram:AttachmentBinaryObject>"
					+ "</ram:AdditionalReferencedDocument>";
			}
		}

		if (trans.getSpecifiedProcuringProjectID() != null) {
			xml += "<ram:SpecifiedProcuringProject>"
				+ "<ram:ID>"
				+ XMLTools.encodeXML(trans.getSpecifiedProcuringProjectID()) + "</ram:ID>";
			if (trans.getSpecifiedProcuringProjectName() != null) {
				xml += "<ram:Name>" + XMLTools.encodeXML(trans.getSpecifiedProcuringProjectName()) + "</ram:Name>";
			}
			xml += "</ram:SpecifiedProcuringProject>";
		}
		xml += "</ram:ApplicableHeaderTradeAgreement>";
		xml += "<ram:ApplicableHeaderTradeDelivery>";

		if (this.trans.getDeliveryAddress() != null) {
			xml += "<ram:ShipToTradeParty>" +
				getTradePartyAsXML(this.trans.getDeliveryAddress(), false, true) +
				"</ram:ShipToTradeParty>";
		}


		if (trans.getDeliveryDate() != null) {
			xml += "<ram:ActualDeliverySupplyChainEvent>"
				+ "<ram:OccurrenceDateTime>";
			xml += DATE.udtFormat(trans.getDeliveryDate());
			xml += "</ram:OccurrenceDateTime>";
			xml += "</ram:ActualDeliverySupplyChainEvent>";

		}
		/*
		 * + "<DeliveryNoteReferencedDocument>" +
		 * "<IssueDateTime format=\"102\">20130603</IssueDateTime>" +
		 * "<ID>2013-51112</ID>" +
		 * "</DeliveryNoteReferencedDocument>"
		 */
		if (trans.getDespatchAdviceReferencedDocumentID() != null) {
			xml += "<ram:DespatchAdviceReferencedDocument>";
			xml += "<ram:IssuerAssignedID>" + XMLTools.encodeXML(trans.getDespatchAdviceReferencedDocumentID()) + "</ram:IssuerAssignedID>";
			xml += "</ram:DespatchAdviceReferencedDocument>";

		}

		xml += "</ram:ApplicableHeaderTradeDelivery>";
		xml += "<ram:ApplicableHeaderTradeSettlement>";

		if ((trans.getCreditorReferenceID() != null) && (getProfile() != Profiles.getByName("Minimum"))) {
			xml += "<ram:CreditorReferenceID>" + XMLTools.encodeXML(trans.getCreditorReferenceID()) + "</ram:CreditorReferenceID>";
		}
		if ((trans.getPaymentReference() != null) && (getProfile() != Profiles.getByName("Minimum"))) {
			xml += "<ram:PaymentReference>" + XMLTools.encodeXML(trans.getPaymentReference()) + "</ram:PaymentReference>";
		}
		xml += "<ram:InvoiceCurrencyCode>" + trans.getCurrency() + "</ram:InvoiceCurrencyCode>";
		if (this.trans.getPayee() != null) {
			xml += "<ram:PayeeTradeParty>" +
				getTradePartyPayeeAsXML(this.trans.getPayee()) +
				"</ram:PayeeTradeParty>";
		}

		if (trans.getTradeSettlementPayment() != null) {
			for (final IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if (payment != null) {
					hasDueDate = true;
					if (getProfile() != Profiles.getByName("Minimum")) {
						xml += payment.getSettlementXML();
					}
				}
			}
		}
		if (trans.getTradeSettlement() != null) {
			for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
				if (payment != null) {
					if (payment instanceof IZUGFeRDTradeSettlementPayment) {
						hasDueDate = true;
					}
					if (getProfile() != Profiles.getByName("Minimum")) {
						xml += payment.getSettlementXML();
					}
				}
			}
		}
		if ((trans.getDocumentCode() == DocumentCodeTypeConstants.CORRECTEDINVOICE) || (trans.getDocumentCode() == DocumentCodeTypeConstants.CREDITNOTE)) {
			hasDueDate = false;
		}

		final Map<BigDecimal, VATAmount> VATPercentAmountMap = calc.getVATPercentAmountMap();
		for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			final VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				final String amountCategoryCode = amount.getCategoryCode();
				final String amountDueDateTypeCode = amount.getDueDateTypeCode();
				final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(amountCategoryCode);
				if (getProfile() != Profiles.getByName("Minimum")) {
					String exemptionReasonTextXML = "";
					if ((displayExemptionReason) && (amount.getVatExemptionReasonText() != null)) {
						exemptionReasonTextXML = "<ram:ExemptionReason>" + XMLTools.encodeXML(amount.getVatExemptionReasonText()) + "</ram:ExemptionReason>";

					}

					xml += "<ram:ApplicableTradeTax>"
						+ "<ram:CalculatedAmount>" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>" //currencyID=\"EUR\"
						+ "<ram:TypeCode>VAT</ram:TypeCode>"
						+ exemptionReasonTextXML
						+ "<ram:BasisAmount>" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>" // currencyID=\"EUR\"
						+ "<ram:CategoryCode>" + amountCategoryCode + "</ram:CategoryCode>"
						+ (amountDueDateTypeCode != null ? "<ram:DueDateTypeCode>" + amountDueDateTypeCode + "</ram:DueDateTypeCode>" : "")
						+ "<ram:RateApplicablePercent>"
						+ vatFormat(currentTaxPercent) + "</ram:RateApplicablePercent></ram:ApplicableTradeTax>";
				}
			}
		}
		if ((trans.getDetailedDeliveryPeriodFrom() != null) || (trans.getDetailedDeliveryPeriodTo() != null)) {
			xml += "<ram:BillingSpecifiedPeriod>";
			if (trans.getDetailedDeliveryPeriodFrom() != null) {
				xml += "<ram:StartDateTime>" + DATE.udtFormat(trans.getDetailedDeliveryPeriodFrom()) + "</ram:StartDateTime>";
			}
			if (trans.getDetailedDeliveryPeriodTo() != null) {
				xml += "<ram:EndDateTime>" + DATE.udtFormat(trans.getDetailedDeliveryPeriodTo()) + "</ram:EndDateTime>";
			}
			xml += "</ram:BillingSpecifiedPeriod>";
		}

		if ((trans.getZFCharges() != null) && (trans.getZFCharges().length > 0)) {
			if ((profile == Profiles.getByName("XRechnung")) || (profile == Profiles.getByName("EN16931")) || (profile == Profiles.getByName("EXTENDED")))  {
				for (IZUGFeRDAllowanceCharge charge : trans.getZFCharges()) {
					xml += "<ram:SpecifiedTradeAllowanceCharge>" +
						"<ram:ChargeIndicator>" +
						"<udt:Indicator>true</udt:Indicator>" +
						"</ram:ChargeIndicator>" +
						"<ram:ActualAmount>" + currencyFormat(charge.getTotalAmount(calc)) + "</ram:ActualAmount>";
					if (charge.getReasonCode() != null) {
						xml += "<ram:ReasonCode>" + charge.getReasonCode() + "</ram:ReasonCode>";
					}
					if (charge.getReason() != null) {
						xml += "<ram:Reason>" + XMLTools.encodeXML(charge.getReason()) + "</ram:Reason>";
					}
					xml += "<ram:CategoryTradeTax>" +
						"<ram:TypeCode>VAT</ram:TypeCode>" +
						"<ram:CategoryCode>" + charge.getCategoryCode() + "</ram:CategoryCode>";
					if (charge.getTaxPercent() != null) {
						xml += "<ram:RateApplicablePercent>" + vatFormat(charge.getTaxPercent()) + "</ram:RateApplicablePercent>";
					}
					xml += "</ram:CategoryTradeTax>" +
						"</ram:SpecifiedTradeAllowanceCharge>";
				}
			} else {
				for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
					if (calc.getChargesForPercent(currentTaxPercent).compareTo(BigDecimal.ZERO) != 0) {
						xml += "<ram:SpecifiedTradeAllowanceCharge>" +
							"<ram:ChargeIndicator>" +
							"<udt:Indicator>true</udt:Indicator>" +
							"</ram:ChargeIndicator>" +
							"<ram:ActualAmount>" + currencyFormat(calc.getChargesForPercent(currentTaxPercent)) + "</ram:ActualAmount>" +
							"<ram:Reason>" + XMLTools.encodeXML(calc.getChargeReasonForPercent(currentTaxPercent)) + "</ram:Reason>" +
							"<ram:CategoryTradeTax>" +
							"<ram:TypeCode>VAT</ram:TypeCode>" +
							"<ram:CategoryCode>" + VATPercentAmountMap.get(currentTaxPercent).getCategoryCode() + "</ram:CategoryCode>" +
							"<ram:RateApplicablePercent>" + vatFormat(currentTaxPercent) + "</ram:RateApplicablePercent>" +
							"</ram:CategoryTradeTax>" +
							"</ram:SpecifiedTradeAllowanceCharge>";
					}
				}
			}
		}

		if ((trans.getZFAllowances() != null) && (trans.getZFAllowances().length > 0)) {
			if (profile == Profiles.getByName("XRechnung")) {
				for (IZUGFeRDAllowanceCharge allowance : trans.getZFAllowances()) {
					xml += "<ram:SpecifiedTradeAllowanceCharge>" +
						"<ram:ChargeIndicator>" +
						"<udt:Indicator>false</udt:Indicator>" +
						"</ram:ChargeIndicator>" +
						"<ram:ActualAmount>" + currencyFormat(allowance.getTotalAmount(calc)) + "</ram:ActualAmount>";
					if (allowance.getReason() != null) {
						xml += "<ram:Reason>" + XMLTools.encodeXML(allowance.getReason()) + "</ram:Reason>";
					}
					if (allowance.getReasonCode() != null) {
						xml += "<ram:ReasonCode>" + allowance.getReasonCode() + "</ram:ReasonCode>";
					}
					xml += "<ram:CategoryTradeTax>" +
						"<ram:TypeCode>VAT</ram:TypeCode>" +
						"<ram:CategoryCode>" + allowance.getCategoryCode() + "</ram:CategoryCode>";
					if (allowance.getTaxPercent() != null) {
						xml += "<ram:RateApplicablePercent>" + vatFormat(allowance.getTaxPercent()) + "</ram:RateApplicablePercent>";
					}
					xml += "</ram:CategoryTradeTax>" +
						"</ram:SpecifiedTradeAllowanceCharge>";
				}
			} else {
				for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
					if (calc.getAllowancesForPercent(currentTaxPercent).compareTo(BigDecimal.ZERO) != 0) {
						xml += "<ram:SpecifiedTradeAllowanceCharge>" +
							"<ram:ChargeIndicator>" +
							"<udt:Indicator>false</udt:Indicator>" +
							"</ram:ChargeIndicator>" +
							"<ram:ActualAmount>" + currencyFormat(calc.getAllowancesForPercent(currentTaxPercent)) + "</ram:ActualAmount>" +
							"<ram:Reason>" + XMLTools.encodeXML(calc.getAllowanceReasonForPercent(currentTaxPercent)) + "</ram:Reason>" +
							"<ram:CategoryTradeTax>" +
							"<ram:TypeCode>VAT</ram:TypeCode>" +
							"<ram:CategoryCode>" + VATPercentAmountMap.get(currentTaxPercent).getCategoryCode() + "</ram:CategoryCode>" +
							"<ram:RateApplicablePercent>" + vatFormat(currentTaxPercent) + "</ram:RateApplicablePercent>" +
							"</ram:CategoryTradeTax>" +
							"</ram:SpecifiedTradeAllowanceCharge>";
					}
				}
			}
		}

		if ((trans.getPaymentTerms() == null) && (getProfile() != Profiles.getByName("Minimum")) && ((paymentTermsDescription != null) || (trans.getTradeSettlement() != null) || (hasDueDate))) {
			xml += "<ram:SpecifiedTradePaymentTerms>";

			if (paymentTermsDescription != null) {
				xml += "<ram:Description>" + paymentTermsDescription + "</ram:Description>";
			}
			
			if (trans.getDueDate() != null) {
				xml += "<ram:DueDateDateTime>" // $NON-NLS-2$
					+ DATE.udtFormat(trans.getDueDate())
					+ "</ram:DueDateDateTime>";// 20130704
			}

			if (trans.getTradeSettlement() != null) {
				for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if ((payment != null) && (payment instanceof IZUGFeRDTradeSettlementDebit)) {
						xml += payment.getPaymentXML();
					}
				}
			}

			xml += "</ram:SpecifiedTradePaymentTerms>";
		} else {
			xml += buildPaymentTermsXml();
		}
		if ((profile == Profiles.getByName("Extended")) && (trans.getCashDiscounts() != null) && (trans.getCashDiscounts().length > 0)) {
			for (IZUGFeRDCashDiscount discount : trans.getCashDiscounts()
			) {
				xml += discount.getAsCII();
			}
		}


		final String allowanceTotalLine = "<ram:AllowanceTotalAmount>" + currencyFormat(calc.getAllowancesForPercent(null)) + "</ram:AllowanceTotalAmount>";

		final String chargesTotalLine = "<ram:ChargeTotalAmount>" + currencyFormat(calc.getChargesForPercent(null)) + "</ram:ChargeTotalAmount>";

		xml += "<ram:SpecifiedTradeSettlementHeaderMonetarySummation>";
		if ((getProfile() != Profiles.getByName("Minimum")) && (getProfile() != Profiles.getByName("BASICWL"))) {
			xml += "<ram:LineTotalAmount>" + currencyFormat(calc.getTotal()) + "</ram:LineTotalAmount>";
			xml += chargesTotalLine
				+ allowanceTotalLine;
		}
		xml += "<ram:TaxBasisTotalAmount>" + currencyFormat(calc.getTaxBasis()) + "</ram:TaxBasisTotalAmount>"
			// //
			// currencyID=\"EUR\"
			+ "<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
			+ currencyFormat(calc.getGrandTotal().subtract(calc.getTaxBasis())) + "</ram:TaxTotalAmount>";
		if (trans.getRoundingAmount() != null) {
			xml += "<ram:RoundingAmount>" + currencyFormat(trans.getRoundingAmount()) + "</ram:RoundingAmount>";
		}

		xml += "<ram:GrandTotalAmount>" + currencyFormat(calc.getGrandTotal()) + "</ram:GrandTotalAmount>";
		// //
		// currencyID=\"EUR\"
		if (getProfile() != Profiles.getByName("Minimum")) {
			xml += "<ram:TotalPrepaidAmount>" + currencyFormat(calc.getTotalPrepaid()) + "</ram:TotalPrepaidAmount>";
		}
		xml += "<ram:DuePayableAmount>" + currencyFormat(calc.getDuePayable()) + "</ram:DuePayableAmount>"
			+ "</ram:SpecifiedTradeSettlementHeaderMonetarySummation>";
		if (trans.getInvoiceReferencedDocumentID() != null) {
			xml += "<ram:InvoiceReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getInvoiceReferencedDocumentID()) + "</ram:IssuerAssignedID>";
			if (trans.getInvoiceReferencedIssueDate() != null) {
				xml += "<ram:FormattedIssueDateTime>"
					+ DATE.qdtFormat(trans.getInvoiceReferencedIssueDate())
					+ "</ram:FormattedIssueDateTime>";
			}
			xml += "</ram:InvoiceReferencedDocument>";
		}
		if (trans.getInvoiceReferencedDocuments() != null) {
			for (ReferencedDocument doc : trans.getInvoiceReferencedDocuments()) {
				xml += "<ram:InvoiceReferencedDocument>"
						+ "<ram:IssuerAssignedID>"
						+ XMLTools.encodeXML(doc.getIssuerAssignedID()) + "</ram:IssuerAssignedID>";
				if (doc.getFormattedIssueDateTime() != null) {
					xml += "<ram:FormattedIssueDateTime>"
							+ DATE.qdtFormat(doc.getFormattedIssueDateTime())
							+ "</ram:FormattedIssueDateTime>";
				}
				xml += "</ram:InvoiceReferencedDocument>";
			}
		}

		xml += "</ram:ApplicableHeaderTradeSettlement>";
		// + "<IncludedSupplyChainTradeLineItem>\n"
		// + "<AssociatedDocumentLineDocument>\n"
		// + "<IncludedNote>\n"
		// + "<Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + "</IncludedNote>\n"
		// + "</AssociatedDocumentLineDocument>\n"
		// + "</IncludedSupplyChainTradeLineItem>\n";

		xml += "</rsm:SupplyChainTradeTransaction>"
			+ "</rsm:CrossIndustryInvoice>";

		final byte[] zugferdRaw;
		zugferdRaw = xml.getBytes(StandardCharsets.UTF_8);

		zugferdData = XMLTools.removeBOM(zugferdRaw);
	}

	protected String buildItemNotes(IZUGFeRDExportableItem currentItem) {
		if (currentItem.getNotes() == null) {
			return "";
		}
		return Arrays.stream(currentItem.getNotes())
			.map(IncludedNote::unspecifiedNote)
			.map(IncludedNote::toCiiXml)
			.collect(Collectors.joining());
	}

	protected String buildNotes(IExportableTransaction exportableTransaction) {
		final List<IncludedNote> includedNotes = new ArrayList<>();
		Optional.ofNullable(exportableTransaction.getNotesWithSubjectCode()).ifPresent(includedNotes::addAll);

		if (exportableTransaction.getNotes() != null) {
			for (final String currentNote : exportableTransaction.getNotes()) {
				includedNotes.add(IncludedNote.unspecifiedNote(currentNote));
			}
		}
		if (exportableTransaction.rebateAgreementExists()) {
			includedNotes.add(IncludedNote.discountBonusNote("Es bestehen Rabatt- und Bonusvereinbarungen."));
		}
		Optional.ofNullable(exportableTransaction.getOwnOrganisationFullPlaintextInfo())
			.ifPresent(info -> includedNotes.add(IncludedNote.regulatoryNote(info)));

		Optional.ofNullable(exportableTransaction.getSubjectNote())
			.ifPresent(note -> includedNotes.add(IncludedNote.unspecifiedNote(note)));

		return includedNotes.stream().map(IncludedNote::toCiiXml).collect(Collectors.joining(""));
	}

	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

	private String buildPaymentTermsXml() {
		final IZUGFeRDPaymentTerms paymentTerms = trans.getPaymentTerms();
		if (paymentTerms == null) {
			return "";
		}
		String paymentTermsXml = "<ram:SpecifiedTradePaymentTerms>";

		final IZUGFeRDPaymentDiscountTerms discountTerms = paymentTerms.getDiscountTerms();
		final Date dueDate = paymentTerms.getDueDate();
		if (dueDate != null && discountTerms != null && discountTerms.getBaseDate() != null) {
			throw new IllegalStateException(
				"if paymentTerms.dueDate is specified, paymentTerms.discountTerms.baseDate has not to be specified");
		}
		paymentTermsXml += "<ram:Description>" + paymentTerms.getDescription() + "</ram:Description>";

		if (dueDate != null) {
			paymentTermsXml += "<ram:DueDateDateTime>";
			paymentTermsXml += DATE.udtFormat(dueDate);
			paymentTermsXml += "</ram:DueDateDateTime>";
		}

		if (trans.getTradeSettlement() != null) {
			for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
				if ((payment != null) && (payment instanceof IZUGFeRDTradeSettlementDebit)) {
					paymentTermsXml += payment.getPaymentXML();
				}
			}
		}

		if (discountTerms != null) {
			paymentTermsXml += "<ram:ApplicableTradePaymentDiscountTerms>";
			final String currency = trans.getCurrency();
			final String basisAmount = currencyFormat(calc.getGrandTotal());
			paymentTermsXml += "<ram:BasisAmount currencyID=\"" + currency + "\">" + basisAmount + "</ram:BasisAmount>";
			paymentTermsXml += "<ram:CalculationPercent>" + discountTerms.getCalculationPercentage().toString()
				+ "</ram:CalculationPercent>";

			if (discountTerms.getBaseDate() != null) {
				final Date baseDate = discountTerms.getBaseDate();
				paymentTermsXml += "<ram:BasisDateTime>";
				paymentTermsXml += DATE.udtFormat(baseDate);
				paymentTermsXml += "</ram:BasisDateTime>";

				paymentTermsXml += "<ram:BasisPeriodMeasure unitCode=\"" + discountTerms.getBasePeriodUnitCode() + "\">"
					+ discountTerms.getBasePeriodMeasure() + "</ram:BasisPeriodMeasure>";
			}

			paymentTermsXml += "</ram:ApplicableTradePaymentDiscountTerms>";
		}

		paymentTermsXml += "</ram:SpecifiedTradePaymentTerms>";
		return paymentTermsXml;
	}

}
