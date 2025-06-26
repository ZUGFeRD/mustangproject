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
import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import static org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat.DATE;
import static org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants.CATEGORY_CODES_WITH_EXEMPTION_REASON;

public class ZUGFeRD2PullProvider implements IXMLProvider {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRD2PullProvider.class);

	protected byte[] zugferdData;
	protected IExportableTransaction trans;
	protected TransactionCalculator calc;
	protected Profile profile = Profiles.getByName("EN16931");
	private String paymentTermsDescription;

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

	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

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
		if (party.getName() != null && !party.getName().isEmpty()) {
			xml += "<ram:Name>" + XMLTools.encodeXML(party.getName()) + "</ram:Name>";
		}
		if (party.getDescription() != null) {
			xml += "<ram:Description>" + XMLTools.encodeXML(party.getDescription()) + "</ram:Description>";
		}
		if (party.getLegalOrganisation() != null) {
			xml += "<ram:SpecifiedLegalOrganization> ";
			if (party.getLegalOrganisation().getSchemedID() != null) {
				if (profile == Profiles.getByName("Minimum")) {
					xml += "<ram:ID>" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>";
				} else {
					String schemeAttribute = "";
					if ((party.getLegalOrganisation().getSchemedID().getScheme() != null) && (!party.getLegalOrganisation().getSchemedID().getScheme().isEmpty())) {
						schemeAttribute = "schemeID=\"" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getScheme()) + "\"";

					}
					xml += "<ram:ID " + schemeAttribute + ">" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>";
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
		return "<ram:AppliedTradeAllowanceCharge><ram:ChargeIndicator><udt:Indicator>" +
			chargeIndicator + "</udt:Indicator></ram:ChargeIndicator>" + percentage +
			"<ram:ActualAmount>" + priceFormat(allowance.getTotalAmount(item)) + "</ram:ActualAmount>" +
			reasonCode +
			reason +
			"</ram:AppliedTradeAllowanceCharge>";
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
		boolean isEN16931 = (profile == Profiles.getByName("XRechnung")) || (profile == Profiles.getByName("EN16931"));
		if ((allowance.getReason() != null) && (profile == Profiles.getByName("Extended") || isEN16931)) {
			reason = "<ram:Reason>" + XMLTools.encodeXML(allowance.getReason()) + "</ram:Reason>";
		}
		String reasonCode = "";
		if ((allowance.getReasonCode() != null) && (profile == Profiles.getByName("Extended") || isEN16931)) {
			// only in XRechnung profile
			reasonCode = "<ram:ReasonCode>" + allowance.getReasonCode() + "</ram:ReasonCode>";
		}
		return "<ram:SpecifiedTradeAllowanceCharge><ram:ChargeIndicator><udt:Indicator>" +
			chargeIndicator + "</udt:Indicator></ram:ChargeIndicator>" + percentage +
			"<ram:ActualAmount>" + currencyFormat(allowance.getTotalAmount(item)) + "</ram:ActualAmount>" +
			reasonCode +
			reason +
			"</ram:SpecifiedTradeAllowanceCharge>";
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
		} else if ((paymentTermsDescription == null) && (!Objects.equals(trans.getDocumentCode(), DocumentCodeTypeConstants.CORRECTEDINVOICE)) && (!Objects.equals(trans.getDocumentCode(), DocumentCodeTypeConstants.CREDITNOTE))) {
			if (trans.getDueDate() != null) {
				paymentTermsDescription = "Please remit until " + germanDateFormat.format(trans.getDueDate());
			}
		}

		String typecode = "380";
		if (trans.getDocumentCode() != null) {
			typecode = trans.getDocumentCode();
		}
		StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
			+ "<rsm:CrossIndustryInvoice xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100\""
			// + "
			// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
			// ../Schema/ZUGFeRD1p0.xsd\""
			+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100\""
			+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100\""
			+ " xmlns:qdt=\"urn:un:unece:uncefact:data:standard:QualifiedDataType:100\">"
			+ "<!-- generated by: mustangproject.org v" + ZUGFeRD2PullProvider.class.getPackage().getImplementationVersion() + "-->"
			+ "<rsm:ExchangedDocumentContext>\n");
		// + "
		// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>"
		//

		if (getProfile() == Profiles.getByName("XRechnung")) {
			xml.append("<ram:BusinessProcessSpecifiedDocumentContextParameter>\n" + "<ram:ID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</ram:ID>\n" + "</ram:BusinessProcessSpecifiedDocumentContextParameter>\n");
		}
		xml.append("<ram:GuidelineSpecifiedDocumentContextParameter>" + "<ram:ID>").append(getProfile().getID()).append("</ram:ID>").append("</ram:GuidelineSpecifiedDocumentContextParameter>").append("</rsm:ExchangedDocumentContext>").append("<rsm:ExchangedDocument>").append("<ram:ID>").append(XMLTools.encodeXML(trans.getNumber())).append("</ram:ID>");
		if (profile == Profiles.getByName("Extended") && trans.getDocumentName() != null) {
			xml.append("<ram:Name>").append(XMLTools.encodeXML(trans.getDocumentName())).append("</ram:Name>");
		}
		xml.append("<ram:TypeCode>").append(typecode).append("</ram:TypeCode>").append("<ram:IssueDateTime>").append(DATE.udtFormat(trans.getIssueDate())).append("</ram:IssueDateTime>" // date
		).append(buildNotes(trans)).append("</rsm:ExchangedDocument>").append("<rsm:SupplyChainTradeTransaction>");
		int lineID = 0;
		for (final IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			String lineIDStr = Integer.toString(lineID);
			if (currentItem.getId() != null) {
				lineIDStr = currentItem.getId();
			}
			final LineCalculator lc = new LineCalculator(currentItem);
			if ((getProfile() != Profiles.getByName("Minimum")) && (getProfile() != Profiles.getByName("BasicWL"))) {
				xml.append("<ram:IncludedSupplyChainTradeLineItem>" + "<ram:AssociatedDocumentLineDocument>" + "<ram:LineID>").append(lineIDStr).append("</ram:LineID>").append(buildItemNotes(currentItem)).append("</ram:AssociatedDocumentLineDocument>").append("<ram:SpecifiedTradeProduct>");
				if ((currentItem.getProduct().getGlobalIDScheme() != null) && (currentItem.getProduct().getGlobalID() != null)) {
					xml.append("<ram:GlobalID schemeID=\"").append(XMLTools.encodeXML(currentItem.getProduct().getGlobalIDScheme())).append("\">").append(XMLTools.encodeXML(currentItem.getProduct().getGlobalID())).append("</ram:GlobalID>");
				}

				if (currentItem.getProduct().getSellerAssignedID() != null) {
					xml.append("<ram:SellerAssignedID>").append(XMLTools.encodeXML(currentItem.getProduct().getSellerAssignedID())).append("</ram:SellerAssignedID>");
				}
				if (currentItem.getProduct().getBuyerAssignedID() != null) {
					xml.append("<ram:BuyerAssignedID>").append(XMLTools.encodeXML(currentItem.getProduct().getBuyerAssignedID())).append("</ram:BuyerAssignedID>");
				}
				StringBuilder allowanceChargeStr = new StringBuilder();
				if (currentItem.getProduct().getAllowances() != null) {
					currentItem.getProduct().getAllowances();
					for (final IZUGFeRDAllowanceCharge allowance : currentItem.getProduct().getAllowances()) {
						allowanceChargeStr.append(getAllowanceChargeStr(allowance, currentItem));
					}
				}
				if (currentItem.getProduct().getCharges() != null) {
					currentItem.getProduct().getCharges();
					for (final IZUGFeRDAllowanceCharge charge : currentItem.getProduct().getCharges()) {
						allowanceChargeStr.append(getAllowanceChargeStr(charge, currentItem));

					}
				}

				StringBuilder itemTotalAllowanceChargeStr = new StringBuilder();
				if (currentItem.getAllowances() != null) {
					currentItem.getAllowances();
					for (final IZUGFeRDAllowanceCharge itemTotalAllowance : currentItem.getAllowances()) {
						itemTotalAllowanceChargeStr.append(getItemTotalAllowanceChargeStr(itemTotalAllowance, currentItem));
					}
				}
				if (currentItem.getCharges() != null) {
					currentItem.getCharges();
					for (final IZUGFeRDAllowanceCharge itemTotalCharges : currentItem.getCharges()) {
						itemTotalAllowanceChargeStr.append(getItemTotalAllowanceChargeStr(itemTotalCharges, currentItem));
					}
				}

				xml.append("<ram:Name>").append(XMLTools.encodeXML(currentItem.getProduct().getName())).append("</ram:Name>");
				if (currentItem.getProduct().getDescription() != null && !currentItem.getProduct().getDescription().isEmpty()) {
					xml.append("<ram:Description>").append(XMLTools.encodeXML(currentItem.getProduct().getDescription())).append("</ram:Description>");
				}
				if (currentItem.getProduct().getClassifications() != null) {
					currentItem.getProduct().getClassifications();
					for (IDesignatedProductClassification classification : currentItem.getProduct().getClassifications()) {
						xml.append("<ram:DesignatedProductClassification>" + "<ram:ClassCode listID=\"").append(XMLTools.encodeXML(classification.getClassCode().getListID())).append("\"");
						if (classification.getClassCode().getListVersionID() != null) {
							xml.append(" listVersionID=\"").append(XMLTools.encodeXML(classification.getClassCode().getListVersionID())).append("\"");
						}
						xml.append(">").append(classification.getClassCode().getCode()).append("</ram:ClassCode>");
						if (classification.getClassName() != null) {
							xml.append("<ram:ClassName>").append(XMLTools.encodeXML(classification.getClassName())).append("</ram:ClassName>");
						}
						xml.append("</ram:DesignatedProductClassification>");
					}
				}
				if (currentItem.getProduct().getAttributes() != null) {
					for (Entry<String, String> entry : currentItem.getProduct().getAttributes().entrySet()) {
						xml.append("<ram:ApplicableProductCharacteristic>" + "<ram:Description>").append(XMLTools.encodeXML(entry.getKey())).append("</ram:Description>").append("<ram:Value>").append(XMLTools.encodeXML(entry.getValue())).append("</ram:Value>").append("</ram:ApplicableProductCharacteristic>");
					}
				}
				if (currentItem.getProduct().getCountryOfOrigin() != null) {
					xml.append("<ram:OriginTradeCountry><ram:ID>").append(XMLTools.encodeXML(currentItem.getProduct().getCountryOfOrigin())).append("</ram:ID></ram:OriginTradeCountry>");
				}
				xml.append("</ram:SpecifiedTradeProduct>" + "<ram:SpecifiedLineTradeAgreement>");
				if (currentItem.getReferencedDocuments() != null) {
					for (final IReferencedDocument currentReferencedDocument : currentItem.getReferencedDocuments()) {
						xml.append("<ram:AdditionalReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(currentReferencedDocument.getIssuerAssignedID())).append("</ram:IssuerAssignedID>").append("<ram:TypeCode>").append(XMLTools.encodeXML(currentReferencedDocument.getTypeCode())).append("</ram:TypeCode>").append("<ram:ReferenceTypeCode>").append(XMLTools.encodeXML(currentReferencedDocument.getReferenceTypeCode())).append("</ram:ReferenceTypeCode>").append("</ram:AdditionalReferencedDocument>");
					}
				}
				if (currentItem.getBuyerOrderReferencedDocumentLineID() != null) {
					xml.append("<ram:BuyerOrderReferencedDocument> " + "<ram:LineID>").append(XMLTools.encodeXML(currentItem.getBuyerOrderReferencedDocumentLineID())).append("</ram:LineID>").append("</ram:BuyerOrderReferencedDocument>");
				}

				if (allowanceChargeStr.length() > 0) {
					xml.append("<ram:GrossPriceProductTradePrice>" + "<ram:ChargeAmount>").append(priceFormat(lc.getPriceGross())).append("</ram:ChargeAmount>" //currencyID=\"EUR\"
					).append("<ram:BasisQuantity unitCode=\"").append(XMLTools.encodeXML(currentItem.getProduct().getUnit())).append("\">").append(quantityFormat(currentItem.getBasisQuantity())).append("</ram:BasisQuantity>").append(allowanceChargeStr
						// + "<AppliedTradeAllowanceCharge>"
						// + "<ChargeIndicator>false</ChargeIndicator>"
						// + "<ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>"
						// + "<Reason>Rabatt</Reason>"
						// + "</AppliedTradeAllowanceCharge>"
					).append("</ram:GrossPriceProductTradePrice>");
				}

				xml.append("<ram:NetPriceProductTradePrice>" + "<ram:ChargeAmount>").append(priceFormat(lc.getPrice())).append("</ram:ChargeAmount>" // currencyID=\"EUR\"
				).append("<ram:BasisQuantity unitCode=\"").append(XMLTools.encodeXML(currentItem.getProduct().getUnit())).append("\">").append(quantityFormat(currentItem.getBasisQuantity())).append("</ram:BasisQuantity>").append("</ram:NetPriceProductTradePrice>").append("</ram:SpecifiedLineTradeAgreement>").append("<ram:SpecifiedLineTradeDelivery>").append("<ram:BilledQuantity unitCode=\"").append(XMLTools.encodeXML(currentItem.getProduct().getUnit())).append("\">").append(quantityFormat(currentItem.getQuantity())).append("</ram:BilledQuantity>").append("</ram:SpecifiedLineTradeDelivery>").append("<ram:SpecifiedLineTradeSettlement>").append("<ram:ApplicableTradeTax>").append("<ram:TypeCode>VAT</ram:TypeCode>");
				if (currentItem.getProduct().getTaxExemptionReason() != null) {
					xml.append("<ram:ExemptionReason>").append(XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason())).append("</ram:ExemptionReason>");
				}
				xml.append("<ram:CategoryCode>").append(currentItem.getProduct().getTaxCategoryCode()).append("</ram:CategoryCode>");
				if (!currentItem.getProduct().getTaxCategoryCode().equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) {
					xml.append("<ram:RateApplicablePercent>").append(vatFormat(currentItem.getProduct().getVATPercent())).append("</ram:RateApplicablePercent>");
				}
				xml.append("</ram:ApplicableTradeTax>");

				if ((currentItem.getDetailedDeliveryPeriodFrom() != null) || (currentItem.getDetailedDeliveryPeriodTo() != null)) {
					xml.append("<ram:BillingSpecifiedPeriod>");
					if (currentItem.getDetailedDeliveryPeriodFrom() != null) {
						xml.append("<ram:StartDateTime>").append(DATE.udtFormat(currentItem.getDetailedDeliveryPeriodFrom())).append("</ram:StartDateTime>");
					}
					if (currentItem.getDetailedDeliveryPeriodTo() != null) {
						xml.append("<ram:EndDateTime>").append(DATE.udtFormat(currentItem.getDetailedDeliveryPeriodTo())).append("</ram:EndDateTime>");
					}
					xml.append("</ram:BillingSpecifiedPeriod>");
				}

				// item charges/allowances
				if (itemTotalAllowanceChargeStr.length() > 0) {
					xml.append(itemTotalAllowanceChargeStr);
				}

				xml.append("<ram:SpecifiedTradeSettlementLineMonetarySummation>" + "<ram:LineTotalAmount>").append(currencyFormat(lc.getItemTotalNetAmount())).append("</ram:LineTotalAmount>" // currencyID=\"EUR\"
				).append("</ram:SpecifiedTradeSettlementLineMonetarySummation>");
				if (currentItem.getAdditionalReferences() != null) {
					for (final IReferencedDocument currentReference : currentItem.getAdditionalReferences()) {
						xml.append("<ram:AdditionalReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(currentReference.getIssuerAssignedID())).append("</ram:IssuerAssignedID>").append("<ram:TypeCode>130</ram:TypeCode>").append("<ram:ReferenceTypeCode>").append(XMLTools.encodeXML(currentReference.getReferenceTypeCode())).append("</ram:ReferenceTypeCode>").append("</ram:AdditionalReferencedDocument>");
					}
				} else if (currentItem.getAdditionalReferencedDocumentID() != null) {
					xml.append("<ram:AdditionalReferencedDocument><ram:IssuerAssignedID>").append(currentItem.getAdditionalReferencedDocumentID()).append("</ram:IssuerAssignedID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>");
				}
				xml.append("</ram:SpecifiedLineTradeSettlement>" + "</ram:IncludedSupplyChainTradeLineItem>");
			}

		}

		xml.append("<ram:ApplicableHeaderTradeAgreement>");
		if (trans.getReferenceNumber() != null) {
			xml.append("<ram:BuyerReference>").append(XMLTools.encodeXML(trans.getReferenceNumber())).append("</ram:BuyerReference>");

		}
		xml.append("<ram:SellerTradeParty>").append(getTradePartyAsXML(trans.getSender(), true, false)).append("</ram:SellerTradeParty>").append("<ram:BuyerTradeParty>");
		// + "<ID>GE2020211</ID>"
		// + "<GlobalID schemeID=\"0088\">4000001987658</GlobalID>"

		xml.append(getTradePartyAsXML(trans.getRecipient(), false, false));
		xml.append("</ram:BuyerTradeParty>");

		if (trans.getSellerOrderReferencedDocumentID() != null) {
			xml.append("<ram:SellerOrderReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(trans.getSellerOrderReferencedDocumentID())).append("</ram:IssuerAssignedID>").append("</ram:SellerOrderReferencedDocument>");
		}
		if (trans.getBuyerOrderReferencedDocumentID() != null) {
			xml.append("<ram:BuyerOrderReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID())).append("</ram:IssuerAssignedID>").append("</ram:BuyerOrderReferencedDocument>");
		}
		if (trans.getContractReferencedDocument() != null) {
			xml.append("<ram:ContractReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(trans.getContractReferencedDocument())).append("</ram:IssuerAssignedID>").append("</ram:ContractReferencedDocument>");
		}

		// Additional Documents of XRechnung (Rechnungsbegründende Unterlagen - BG-24 XRechnung)
		if (trans.getAdditionalReferencedDocuments() != null) {
			for (final FileAttachment f : trans.getAdditionalReferencedDocuments()) {
				final String documentContent = Base64.getEncoder().encodeToString(f.getData());
				xml.append("<ram:AdditionalReferencedDocument>" + "<ram:IssuerAssignedID>").append(f.getFilename()).append("</ram:IssuerAssignedID>").append("<ram:TypeCode>916</ram:TypeCode>").append("<ram:Name>").append(f.getDescription()).append("</ram:Name>").append("<ram:AttachmentBinaryObject mimeCode=\"").append(f.getMimetype()).append("\"\n").append("filename=\"").append(f.getFilename()).append("\">").append(documentContent).append("</ram:AttachmentBinaryObject>").append("</ram:AdditionalReferencedDocument>");
			}
		}

		if (trans.getSpecifiedProcuringProjectID() != null) {
			xml.append("<ram:SpecifiedProcuringProject>" + "<ram:ID>").append(XMLTools.encodeXML(trans.getSpecifiedProcuringProjectID())).append("</ram:ID>");
			if (trans.getSpecifiedProcuringProjectName() != null) {
				xml.append("<ram:Name>").append(XMLTools.encodeXML(trans.getSpecifiedProcuringProjectName())).append("</ram:Name>");
			}
			xml.append("</ram:SpecifiedProcuringProject>");
		}
		xml.append("</ram:ApplicableHeaderTradeAgreement>");
		xml.append("<ram:ApplicableHeaderTradeDelivery>");

		if (this.trans.getDeliveryAddress() != null) {
			xml.append("<ram:ShipToTradeParty>").append(getTradePartyAsXML(this.trans.getDeliveryAddress(), false, true)).append("</ram:ShipToTradeParty>");
		}


		if (trans.getDeliveryDate() != null) {
			xml.append("<ram:ActualDeliverySupplyChainEvent>" + "<ram:OccurrenceDateTime>");
			xml.append(DATE.udtFormat(trans.getDeliveryDate()));
			xml.append("</ram:OccurrenceDateTime>");
			xml.append("</ram:ActualDeliverySupplyChainEvent>");

		}
		/*
		 * + "<DeliveryNoteReferencedDocument>" +
		 * "<IssueDateTime format=\"102\">20130603</IssueDateTime>" +
		 * "<ID>2013-51112</ID>" +
		 * "</DeliveryNoteReferencedDocument>"
		 */
		if (trans.getDespatchAdviceReferencedDocumentID() != null) {
			xml.append("<ram:DespatchAdviceReferencedDocument>");
			xml.append("<ram:IssuerAssignedID>").append(XMLTools.encodeXML(trans.getDespatchAdviceReferencedDocumentID())).append("</ram:IssuerAssignedID>");
			xml.append("</ram:DespatchAdviceReferencedDocument>");

		}

		xml.append("</ram:ApplicableHeaderTradeDelivery>");
		xml.append("<ram:ApplicableHeaderTradeSettlement>");

		if ((trans.getCreditorReferenceID() != null) && (getProfile() != Profiles.getByName("Minimum"))) {
			xml.append("<ram:CreditorReferenceID>").append(XMLTools.encodeXML(trans.getCreditorReferenceID())).append("</ram:CreditorReferenceID>");
		}
		if ((trans.getPaymentReference() != null) && (getProfile() != Profiles.getByName("Minimum"))) {
			xml.append("<ram:PaymentReference>").append(XMLTools.encodeXML(trans.getPaymentReference())).append("</ram:PaymentReference>");
		}
		xml.append("<ram:InvoiceCurrencyCode>").append(trans.getCurrency()).append("</ram:InvoiceCurrencyCode>");
		if (this.trans.getPayee() != null) {
			xml.append("<ram:PayeeTradeParty>").append(getTradePartyPayeeAsXML(this.trans.getPayee())).append("</ram:PayeeTradeParty>");
		}

		if (trans.getTradeSettlementPayment() != null) {
			for (final IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if (payment != null) {
					hasDueDate = true;
					if (getProfile() != Profiles.getByName("Minimum")) {
						xml.append(payment.getSettlementXML());
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
						xml.append(payment.getSettlementXML());
					}
				}
			}
		}
		if ((Objects.equals(trans.getDocumentCode(), DocumentCodeTypeConstants.CORRECTEDINVOICE)) || (Objects.equals(trans.getDocumentCode(), DocumentCodeTypeConstants.CREDITNOTE))) {
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

					xml.append("<ram:ApplicableTradeTax>" + "<ram:CalculatedAmount>").append(currencyFormat(amount.getCalculated())).append("</ram:CalculatedAmount>" //currencyID=\"EUR\"
					).append("<ram:TypeCode>VAT</ram:TypeCode>").append(exemptionReasonTextXML).append("<ram:BasisAmount>").append(currencyFormat(amount.getBasis())).append("</ram:BasisAmount>" // currencyID=\"EUR\"
					).append("<ram:CategoryCode>").append(amountCategoryCode).append("</ram:CategoryCode>").append(amountDueDateTypeCode != null ? "<ram:DueDateTypeCode>" + amountDueDateTypeCode + "</ram:DueDateTypeCode>" : "");
					if (!amountCategoryCode.equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) {
						xml.append("<ram:RateApplicablePercent>").append(vatFormat(currentTaxPercent)).append("</ram:RateApplicablePercent>");
					}
					xml.append("</ram:ApplicableTradeTax>");
				}
			}
		}
		if ((trans.getDetailedDeliveryPeriodFrom() != null) || (trans.getDetailedDeliveryPeriodTo() != null)) {
			xml.append("<ram:BillingSpecifiedPeriod>");
			if (trans.getDetailedDeliveryPeriodFrom() != null) {
				xml.append("<ram:StartDateTime>").append(DATE.udtFormat(trans.getDetailedDeliveryPeriodFrom())).append("</ram:StartDateTime>");
			}
			if (trans.getDetailedDeliveryPeriodTo() != null) {
				xml.append("<ram:EndDateTime>").append(DATE.udtFormat(trans.getDetailedDeliveryPeriodTo())).append("</ram:EndDateTime>");
			}
			xml.append("</ram:BillingSpecifiedPeriod>");
		}

		if ((trans.getZFCharges() != null) && (trans.getZFCharges().length > 0)) {
			if ((profile == Profiles.getByName("XRechnung")) || (profile == Profiles.getByName("EN16931")) || (profile == Profiles.getByName("EXTENDED"))) {
				for (IZUGFeRDAllowanceCharge charge : trans.getZFCharges()) {
					xml.append("<ram:SpecifiedTradeAllowanceCharge>" + "<ram:ChargeIndicator>" + "<udt:Indicator>true</udt:Indicator>" + "</ram:ChargeIndicator>" + "<ram:ActualAmount>").append(currencyFormat(charge.getTotalAmount(calc))).append("</ram:ActualAmount>");
					if (charge.getReasonCode() != null) {
						xml.append("<ram:ReasonCode>").append(charge.getReasonCode()).append("</ram:ReasonCode>");
					}
					if (charge.getReason() != null) {
						xml.append("<ram:Reason>").append(XMLTools.encodeXML(charge.getReason())).append("</ram:Reason>");
					}
					xml.append("<ram:CategoryTradeTax>" + "<ram:TypeCode>VAT</ram:TypeCode>" + "<ram:CategoryCode>").append(charge.getCategoryCode()).append("</ram:CategoryCode>");
					if (charge.getTaxPercent() != null && !charge.getCategoryCode().equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) {
						xml.append("<ram:RateApplicablePercent>").append(vatFormat(charge.getTaxPercent())).append("</ram:RateApplicablePercent>");
					}
					xml.append("</ram:CategoryTradeTax>" + "</ram:SpecifiedTradeAllowanceCharge>");
				}
			} else {
				for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
					if (calc.getChargesForPercent(currentTaxPercent).compareTo(BigDecimal.ZERO) != 0) {
						xml.append("<ram:SpecifiedTradeAllowanceCharge>" + "<ram:ChargeIndicator>" + "<udt:Indicator>true</udt:Indicator>" + "</ram:ChargeIndicator>" + "<ram:ActualAmount>").append(currencyFormat(calc.getChargesForPercent(currentTaxPercent))).append("</ram:ActualAmount>").append("<ram:Reason>").append(XMLTools.encodeXML(calc.getChargeReasonForPercent(currentTaxPercent))).append("</ram:Reason>").append("<ram:CategoryTradeTax>").append("<ram:TypeCode>VAT</ram:TypeCode>").append("<ram:CategoryCode>").append(VATPercentAmountMap.get(currentTaxPercent).getCategoryCode()).append("</ram:CategoryCode>").append("<ram:RateApplicablePercent>").append(vatFormat(currentTaxPercent)).append("</ram:RateApplicablePercent>").append("</ram:CategoryTradeTax>").append("</ram:SpecifiedTradeAllowanceCharge>");
					}
				}
			}
		}

		if ((trans.getZFAllowances() != null) && (trans.getZFAllowances().length > 0)) {
			if (profile == Profiles.getByName("XRechnung")) {
				for (IZUGFeRDAllowanceCharge allowance : trans.getZFAllowances()) {
					xml.append("<ram:SpecifiedTradeAllowanceCharge>" + "<ram:ChargeIndicator>" + "<udt:Indicator>false</udt:Indicator>" + "</ram:ChargeIndicator>" + "<ram:ActualAmount>").append(currencyFormat(allowance.getTotalAmount(calc))).append("</ram:ActualAmount>");
					if (allowance.getReason() != null) {
						xml.append("<ram:Reason>").append(XMLTools.encodeXML(allowance.getReason())).append("</ram:Reason>");
					}
					if (allowance.getReasonCode() != null) {
						xml.append("<ram:ReasonCode>").append(allowance.getReasonCode()).append("</ram:ReasonCode>");
					}
					xml.append("<ram:CategoryTradeTax>" + "<ram:TypeCode>VAT</ram:TypeCode>" + "<ram:CategoryCode>").append(allowance.getCategoryCode()).append("</ram:CategoryCode>");
					if (allowance.getTaxPercent() != null) {
						xml.append("<ram:RateApplicablePercent>").append(vatFormat(allowance.getTaxPercent())).append("</ram:RateApplicablePercent>");
					}
					xml.append("</ram:CategoryTradeTax>" + "</ram:SpecifiedTradeAllowanceCharge>");
				}
			} else {
				for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
					if (calc.getAllowancesForPercent(currentTaxPercent).compareTo(BigDecimal.ZERO) != 0) {
						xml.append("<ram:SpecifiedTradeAllowanceCharge>" + "<ram:ChargeIndicator>" + "<udt:Indicator>false</udt:Indicator>" + "</ram:ChargeIndicator>" + "<ram:ActualAmount>").append(currencyFormat(calc.getAllowancesForPercent(currentTaxPercent))).append("</ram:ActualAmount>").append("<ram:Reason>").append(XMLTools.encodeXML(calc.getAllowanceReasonForPercent(currentTaxPercent))).append("</ram:Reason>").append("<ram:CategoryTradeTax>").append("<ram:TypeCode>VAT</ram:TypeCode>").append("<ram:CategoryCode>").append(VATPercentAmountMap.get(currentTaxPercent).getCategoryCode()).append("</ram:CategoryCode>").append("<ram:RateApplicablePercent>").append(vatFormat(currentTaxPercent)).append("</ram:RateApplicablePercent>").append("</ram:CategoryTradeTax>").append("</ram:SpecifiedTradeAllowanceCharge>");
					}
				}
			}
		}

		if ((trans.getPaymentTerms() == null) && (getProfile() != Profiles.getByName("Minimum")) && ((paymentTermsDescription != null) || (trans.getTradeSettlement() != null) || (hasDueDate))) {
			xml.append("<ram:SpecifiedTradePaymentTerms>");

			if (paymentTermsDescription != null) {
				xml.append("<ram:Description>").append(paymentTermsDescription).append("</ram:Description>");
			}

			if (trans.getDueDate() != null) {
				xml.append("<ram:DueDateDateTime>" // $NON-NLS-2$
				).append(DATE.udtFormat(trans.getDueDate())).append("</ram:DueDateDateTime>");// 20130704
			}

			if (trans.getTradeSettlement() != null) {
				for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if ((payment instanceof IZUGFeRDTradeSettlementDebit)) {
						xml.append(payment.getPaymentXML());
					}
				}
			}

			xml.append("</ram:SpecifiedTradePaymentTerms>");
		} else {
			xml.append(buildPaymentTermsXml());
		}
		if ((profile == Profiles.getByName("Extended")) && (trans.getCashDiscounts() != null)) {
			trans.getCashDiscounts();
			for (IZUGFeRDCashDiscount discount : trans.getCashDiscounts()
			) {
				xml.append(discount.getAsCII());
			}
		}


		final String allowanceTotalLine = "<ram:AllowanceTotalAmount>" + currencyFormat(calc.getAllowancesForPercent(null)) + "</ram:AllowanceTotalAmount>";

		final String chargesTotalLine = "<ram:ChargeTotalAmount>" + currencyFormat(calc.getChargesForPercent(null)) + "</ram:ChargeTotalAmount>";

		xml.append("<ram:SpecifiedTradeSettlementHeaderMonetarySummation>");
		if ((getProfile() != Profiles.getByName("Minimum"))) {
			xml.append("<ram:LineTotalAmount>").append(currencyFormat(calc.getTotal())).append("</ram:LineTotalAmount>");
			xml.append(chargesTotalLine).append(allowanceTotalLine);
		}
		xml.append("<ram:TaxBasisTotalAmount>").append(currencyFormat(calc.getTaxBasis())).append("</ram:TaxBasisTotalAmount>"
			// //
			// currencyID=\"EUR\"
		).append("<ram:TaxTotalAmount currencyID=\"").append(trans.getCurrency()).append("\">").append(currencyFormat(calc.getGrandTotal().subtract(calc.getTaxBasis()))).append("</ram:TaxTotalAmount>");
		if (trans.getRoundingAmount() != null) {
			xml.append("<ram:RoundingAmount>").append(currencyFormat(trans.getRoundingAmount())).append("</ram:RoundingAmount>");
		}

		xml.append("<ram:GrandTotalAmount>").append(currencyFormat(calc.getGrandTotal())).append("</ram:GrandTotalAmount>");
		// //
		// currencyID=\"EUR\"
		if (getProfile() != Profiles.getByName("Minimum")) {
			xml.append("<ram:TotalPrepaidAmount>").append(currencyFormat(calc.getTotalPrepaid())).append("</ram:TotalPrepaidAmount>");
		}
		xml.append("<ram:DuePayableAmount>").append(currencyFormat(calc.getDuePayable())).append("</ram:DuePayableAmount>").append("</ram:SpecifiedTradeSettlementHeaderMonetarySummation>");
		if (trans.getInvoiceReferencedDocumentID() != null) {
			xml.append("<ram:InvoiceReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(trans.getInvoiceReferencedDocumentID())).append("</ram:IssuerAssignedID>");
			if (trans.getInvoiceReferencedIssueDate() != null) {
				xml.append("<ram:FormattedIssueDateTime>").append(DATE.qdtFormat(trans.getInvoiceReferencedIssueDate())).append("</ram:FormattedIssueDateTime>");
			}
			xml.append("</ram:InvoiceReferencedDocument>");
		}
		if (trans.getInvoiceReferencedDocuments() != null) {
			for (ReferencedDocument doc : trans.getInvoiceReferencedDocuments()) {
				xml.append("<ram:InvoiceReferencedDocument>" + "<ram:IssuerAssignedID>").append(XMLTools.encodeXML(doc.getIssuerAssignedID())).append("</ram:IssuerAssignedID>");
				if (doc.getFormattedIssueDateTime() != null) {
					xml.append("<ram:FormattedIssueDateTime>").append(DATE.qdtFormat(doc.getFormattedIssueDateTime())).append("</ram:FormattedIssueDateTime>");
				}
				xml.append("</ram:InvoiceReferencedDocument>");
			}
		}

		xml.append("</ram:ApplicableHeaderTradeSettlement>");
		// + "<IncludedSupplyChainTradeLineItem>\n"
		// + "<AssociatedDocumentLineDocument>\n"
		// + "<IncludedNote>\n"
		// + "<Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + "</IncludedNote>\n"
		// + "</AssociatedDocumentLineDocument>\n"
		// + "</IncludedSupplyChainTradeLineItem>\n";

		xml.append("</rsm:SupplyChainTradeTransaction>" + "</rsm:CrossIndustryInvoice>");

		final byte[] zugferdRaw;
		zugferdRaw = xml.toString().getBytes(StandardCharsets.UTF_8);

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

	private String buildPaymentTermsXml() {

		ArrayList<IZUGFeRDPaymentTerms> paymentTerms = new ArrayList<>();

		IZUGFeRDPaymentTerms izpt = trans.getPaymentTerms();
		if (izpt != null) {
			paymentTerms.add(izpt);
		}

		StringBuilder paymentTermsXml = new StringBuilder();
		if (paymentTerms.isEmpty()) {
			return "";
		}

		for (IZUGFeRDPaymentTerms pt : paymentTerms) {

			paymentTermsXml.append("<ram:SpecifiedTradePaymentTerms>");

			final IZUGFeRDPaymentDiscountTerms discountTerms = pt.getDiscountTerms();
			final Date dueDate = pt.getDueDate();
			if (dueDate != null && discountTerms != null && discountTerms.getBaseDate() != null) {
				throw new IllegalStateException(
					"if paymentTerms.dueDate is specified, paymentTerms.discountTerms.baseDate has not to be specified");
			}
			paymentTermsXml.append("<ram:Description>").append(pt.getDescription()).append("</ram:Description>");

			if (dueDate != null) {
				paymentTermsXml.append("<ram:DueDateDateTime>");
				paymentTermsXml.append(DATE.udtFormat(dueDate));
				paymentTermsXml.append("</ram:DueDateDateTime>");
			}

			if (trans.getTradeSettlement() != null) {
				for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if ((payment instanceof IZUGFeRDTradeSettlementDebit)) {
						paymentTermsXml.append(payment.getPaymentXML());
					}
				}
			}

			if (discountTerms != null) {
				paymentTermsXml.append("<ram:ApplicableTradePaymentDiscountTerms>");
				final String currency = trans.getCurrency();
				final String basisAmount = currencyFormat(calc.getGrandTotal());
				paymentTermsXml.append("<ram:BasisAmount currencyID=\"").append(currency).append("\">").append(basisAmount).append("</ram:BasisAmount>");
				paymentTermsXml.append("<ram:CalculationPercent>").append(discountTerms.getCalculationPercentage().toString()).append("</ram:CalculationPercent>");

				if (discountTerms.getBaseDate() != null) {
					final Date baseDate = discountTerms.getBaseDate();
					paymentTermsXml.append("<ram:BasisDateTime>");
					paymentTermsXml.append(DATE.udtFormat(baseDate));
					paymentTermsXml.append("</ram:BasisDateTime>");

					paymentTermsXml.append("<ram:BasisPeriodMeasure unitCode=\"").append(discountTerms.getBasePeriodUnitCode()).append("\">").append(discountTerms.getBasePeriodMeasure()).append("</ram:BasisPeriodMeasure>");
				}

				paymentTermsXml.append("</ram:ApplicableTradePaymentDiscountTerms>");
			}

			paymentTermsXml.append("</ram:SpecifiedTradePaymentTerms>");
		}
		return paymentTermsXml.toString();
	}
}
