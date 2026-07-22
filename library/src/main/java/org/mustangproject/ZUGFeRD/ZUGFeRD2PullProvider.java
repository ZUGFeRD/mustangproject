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
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.List;
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
import org.mustangproject.Invoice;
import org.mustangproject.LogisticsServiceCharge;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.XMLTools;
import org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants;
import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants;
import static org.mustangproject.util.StringUtils.isNotBlank;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ZUGFeRD2PullProvider implements IXMLProvider {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRD2PullProvider.class);

	protected byte[] zugferdData;
	protected IExportableTransaction trans;
	protected TransactionCalculator calc;
	protected String paymentTermsDescription;
	protected Profile profile = Profiles.getByName("EN16931");

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
			document = DocumentHelper.parseText(new String(zugferdData, StandardCharsets.UTF_8));
		} catch (final DocumentException e1) {
			LOGGER.error("Failed to parse ZUGFeRD data", e1);
		}
		try {
			final OutputFormat format = OutputFormat.createPrettyPrint();
			format.setTrimText(false);
			try (XMLWriter writer = new XMLWriter(sw, format)) {
				writer.write(document);
				res = sw.toString().getBytes(StandardCharsets.UTF_8);
			}
		} catch (final IOException e) {
			LOGGER.error("Failed to write ZUGFeRD data", e);
		}

		return res;

	}


	@Override
	public void setProfile(Profile p) {
		profile = p;
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
		StringBuilder xml = new StringBuilder();
		// According EN16931 either GlobalID or seller assigned ID might be present for BuyerTradeParty
		// and ShipToTradeParty, but not both. Prefer seller assigned ID for now.
		if (party.getID() != null) {
			xml.append("<ram:ID>" + XMLTools.encodeXML(party.getID()) + "</ram:ID>");
		}
		if ((party.getGlobalIDScheme() != null) && (party.getGlobalID() != null)) {
			xml.append("<ram:GlobalID schemeID=\"" + XMLTools.encodeXML(party.getGlobalIDScheme()) + "\">"
				+ XMLTools.encodeXML(party.getGlobalID()) + "</ram:GlobalID>");
		}
		if (party.getName() != null && !party.getName().isEmpty()) {
			xml.append("<ram:Name>" + XMLTools.encodeXML(party.getName()) + "</ram:Name>");
		}
		if (party.getDescription() != null) {
			xml.append("<ram:Description>" + XMLTools.encodeXML(party.getDescription()) + "</ram:Description>");
		}
		if (party.getLegalOrganisation() != null) {
			xml.append("<ram:SpecifiedLegalOrganization> ");
			if (party.getLegalOrganisation().getSchemedID() != null) {
				if (profile == Profiles.getByName("Minimum")) {
					xml.append("<ram:ID>" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>");
				} else {
					String schemeAttribute = "";
					if ((party.getLegalOrganisation().getSchemedID().getScheme() != null) && (party.getLegalOrganisation().getSchemedID().getScheme().length() > 0)) {
						schemeAttribute = "schemeID=\"" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getScheme()) + "\"";

					}
					xml.append("<ram:ID " + schemeAttribute + ">" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>");
				}
			}
			if (party.getLegalOrganisation().getTradingBusinessName() != null) {
				xml.append("<ram:TradingBusinessName>" + XMLTools.encodeXML(party.getLegalOrganisation().getTradingBusinessName()) + "</ram:TradingBusinessName>");
			}
			xml.append("</ram:SpecifiedLegalOrganization>");
		}

		if ((party.getContact() != null) && (isSender || profile == Profiles.getByName("EN16931") || profile == Profiles.getByName("Extended") || profile == Profiles.getByName("XRechnung"))) {
			String definedTradeContactXML = "";
			if (party.getContact().getName() != null) {
				definedTradeContactXML += "<ram:PersonName>"
					+ XMLTools.encodeXML(party.getContact().getName())
					+ "</ram:PersonName>";
			}
			if (party.getContact().getPhone() != null) {
				definedTradeContactXML += "<ram:TelephoneUniversalCommunication><ram:CompleteNumber>"
					+ XMLTools.encodeXML(party.getContact().getPhone()) + "</ram:CompleteNumber>"
					+ "</ram:TelephoneUniversalCommunication>";
			}

			if ((party.getContact().getFax() != null) && (profile == Profiles.getByName("Extended"))) {
				definedTradeContactXML += "<ram:FaxUniversalCommunication><ram:CompleteNumber>"
					+ XMLTools.encodeXML(party.getContact().getFax()) + "</ram:CompleteNumber>"
					+ "</ram:FaxUniversalCommunication>";
			}
			if (party.getContact().getEMail() != null) {
				definedTradeContactXML += "<ram:EmailURIUniversalCommunication><ram:URIID>"
					+ XMLTools.encodeXML(party.getContact().getEMail()) + "</ram:URIID>"
					+ "</ram:EmailURIUniversalCommunication>";
			}
			if (!definedTradeContactXML.isEmpty()) {
				xml.append("<ram:DefinedTradeContact>" + definedTradeContactXML + "</ram:DefinedTradeContact>");
			}
		}

		xml.append("<ram:PostalTradeAddress>");
		if (party.getZIP() != null) {
			xml.append("<ram:PostcodeCode>" + XMLTools.encodeXML(party.getZIP())
				+ "</ram:PostcodeCode>");
		}
		if (party.getStreet() != null) {
			xml.append("<ram:LineOne>" + XMLTools.encodeXML(party.getStreet())
				+ "</ram:LineOne>");
		}
		if (party.getAdditionalAddress() != null) {
			xml.append("<ram:LineTwo>" + XMLTools.encodeXML(party.getAdditionalAddress())
				+ "</ram:LineTwo>");
		}
		if (party.getAdditionalAddressExtension() != null) {
			xml.append("<ram:LineThree>" + XMLTools.encodeXML(party.getAdditionalAddressExtension())
				+ "</ram:LineThree>");
		}
		if (party.getLocation() != null) {
			xml.append("<ram:CityName>" + XMLTools.encodeXML(party.getLocation())
				+ "</ram:CityName>");
		}

		//country IS mandatory
		xml.append("<ram:CountryID>" + XMLTools.encodeXML(party.getCountry())
			+ "</ram:CountryID>"
			+ "</ram:PostalTradeAddress>");
		if (party.getUriUniversalCommunicationID() != null && party.getUriUniversalCommunicationIDScheme() != null && (!isShipToTradeParty)) {
			xml.append("<ram:URIUniversalCommunication>" +
				"<ram:URIID schemeID=\"" + party.getUriUniversalCommunicationIDScheme() + "\">" +
				XMLTools.encodeXML(party.getUriUniversalCommunicationID())
				+ "</ram:URIID></ram:URIUniversalCommunication>");
		}

		if ((party.getVATID() != null) && (!isShipToTradeParty)) {
			xml.append("<ram:SpecifiedTaxRegistration>"
				+ "<ram:ID schemeID=\"VA\">" + XMLTools.encodeXML(party.getVATID())
				+ "</ram:ID>"
				+ "</ram:SpecifiedTaxRegistration>");
		}
		if ((party.getTaxID() != null) && (!isShipToTradeParty)) {
			xml.append("<ram:SpecifiedTaxRegistration>"
				+ "<ram:ID schemeID=\"FC\">" + XMLTools.encodeXML(party.getTaxID())
				+ "</ram:ID>"
				+ "</ram:SpecifiedTaxRegistration>");

		}
		return xml.toString();

	}

	protected String getTradePartyPayeeAsXML(IZUGFeRDExportableTradeParty party) {
		StringBuilder xml = new StringBuilder();
		// According EN16931 either GlobalID or seller assigned ID might be present for a Payee
		if (party.getID() != null) {
			xml.append("<ram:ID>" + XMLTools.encodeXML(party.getID()) + "</ram:ID>");
		}
		if ((party.getGlobalIDScheme() != null) && (party.getGlobalID() != null)) {
			xml.append("<ram:GlobalID schemeID=\"" + XMLTools.encodeXML(party.getGlobalIDScheme()) + "\">"
				+ XMLTools.encodeXML(party.getGlobalID())
				+ "</ram:GlobalID>");
		}
		xml.append("<ram:Name>" + XMLTools.encodeXML(party.getName()) + "</ram:Name>");

		if (party.getLegalOrganisation() != null) {
			xml.append("<ram:SpecifiedLegalOrganization> ");
			if (party.getLegalOrganisation().getSchemedID() != null) {
				xml.append("<ram:ID schemeID=\"" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getScheme()) + "\">" + XMLTools.encodeXML(party.getLegalOrganisation().getSchemedID().getID()) + "</ram:ID>");
			}
			xml.append("</ram:SpecifiedLegalOrganization>");
		}

		return xml.toString();
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
			percentage += "<ram:BasisAmount>" + currencyFormat(item.getValue()) + "</ram:BasisAmount>";
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
		boolean isEN16931 = (profile == Profiles.getByName("XRechnung")) || (profile == Profiles.getByName("EN16931"));
		if (isEN16931 || (profile == Profiles.getByName("Extended"))) {
			if (allowance.getPercent() != null) {
				percentage += "<ram:CalculationPercent>" + vatFormat(allowance.getPercent()) + "</ram:CalculationPercent>";
			}
			if (allowance.getBasisAmount() != null) {
				percentage += "<ram:BasisAmount>" + currencyFormat(allowance.getBasisAmount()) + "</ram:BasisAmount>";
			} else if (allowance.getPercent() != null) {
				// BT-137/BT-142: fall back to the line subtotal (price/basisQty)*qty when the caller did not supply BasisAmount
				percentage += "<ram:BasisAmount>" + currencyFormat(item.getValue().multiply(item.getQuantity())) + "</ram:BasisAmount>";
			}
		}
		if (allowance.isCharge()) {
			chargeIndicator = "true";
		}

		String reason = "";
		if ((allowance.getReason() != null) && (profile == Profiles.getByName("Extended") || isEN16931)) {
			reason = "<ram:Reason>" + XMLTools.encodeXML(allowance.getReason()) + "</ram:Reason>";
		}
		String reasonCode = "";
		if ((allowance.getReasonCode() != null) && (profile == Profiles.getByName("Extended") || isEN16931)) {
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

	protected TransactionCalculator createCalculator(IExportableTransaction trans) {
   		 return new TransactionCalculator(trans);
	}

	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;
		this.calc = createCalculator(trans);

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
		} else if (paymentTermsDescription == null
			&& !DocumentCodeTypeConstants.CORRECTEDINVOICE.equals(trans.getDocumentCode())
			&& !DocumentCodeTypeConstants.CREDITNOTE.equals(trans.getDocumentCode())
		) {
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
			+ (ZUGFeRD1PullProvider.class.getPackage().getImplementationVersion() != null ?
			"<!-- generated by: mustangproject.org v" + ZUGFeRD1PullProvider.class.getPackage().getImplementationVersion() + "-->"
			: "<!-- generated by: mustangproject.org -->"
			)
			+ "<rsm:ExchangedDocumentContext>\n");

		if (trans.getTestIndicator() && profile == Profiles.getByName("Extended")) {
			xml.append("<ram:TestIndicator><udt:Indicator>" + trans.getTestIndicator() + "</udt:Indicator></ram:TestIndicator>");
		}

		String businessProcessId = trans.getBusinessProcessId();
		if (isNotBlank(businessProcessId)) {
 			xml.append("<ram:BusinessProcessSpecifiedDocumentContextParameter>\n"
				+ "<ram:ID>" + XMLTools.encodeXML(businessProcessId) + "</ram:ID>\n"
				+ "</ram:BusinessProcessSpecifiedDocumentContextParameter>\n");
		} else if (getProfile() == Profiles.getByName("XRechnung")) {
			xml.append("<ram:BusinessProcessSpecifiedDocumentContextParameter>\n"
				+ "<ram:ID>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</ram:ID>\n"
				+ "</ram:BusinessProcessSpecifiedDocumentContextParameter>\n");
		}
		xml.append(
			"<ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "<ram:ID>" + getProfile().getID() + "</ram:ID>"
				+ "</ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "</rsm:ExchangedDocumentContext>"
				+ "<rsm:ExchangedDocument>"
				+ "<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>");
		if (profile == Profiles.getByName("Extended") && trans.getDocumentName() != null) {
			xml.append("<ram:Name>" + XMLTools.encodeXML(trans.getDocumentName()) + "</ram:Name>");
		}
		xml.append("<ram:TypeCode>" + typecode + "</ram:TypeCode>"
			+ "<ram:IssueDateTime>" + DATE.udtFormat(trans.getIssueDate()) + "</ram:IssueDateTime>" // date
			+ buildNotes(trans)
			+ "</rsm:ExchangedDocument>"
			+ "<rsm:SupplyChainTradeTransaction>");
		int lineID = 0;
		for (final IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			String lineIDStr = Integer.toString(lineID);
			if (currentItem.getId() != null) {
				lineIDStr = currentItem.getId();
			}
			final LineCalculator lc = currentItem.getCalculation();
			if ((getProfile() != Profiles.getByName("Minimum")) && (getProfile() != Profiles.getByName("BasicWL"))) {
				xml.append("<ram:IncludedSupplyChainTradeLineItem>" +
					"<ram:AssociatedDocumentLineDocument>"
					+ "<ram:LineID>" + lineIDStr + "</ram:LineID>");
				if (getProfile() == Profiles.getByName("Extended")) {
					if (currentItem.getParentLineID() != null) {
						xml.append("<ram:ParentLineID>" + XMLTools.encodeXML(currentItem.getParentLineID()) + "</ram:ParentLineID>");
					}
					if (currentItem.getLineStatusReasonCode() != null) {
						xml.append("<ram:LineStatusReasonCode>" + XMLTools.encodeXML(currentItem.getLineStatusReasonCode()) + "</ram:LineStatusReasonCode>");
					}
				}
				xml.append(buildItemNotes(currentItem))
					.append("</ram:AssociatedDocumentLineDocument>")
					.append("<ram:SpecifiedTradeProduct>");
				if ((currentItem.getProduct().getGlobalIDScheme() != null) && (currentItem.getProduct().getGlobalID() != null)) {
					xml.append("<ram:GlobalID schemeID=\"" + XMLTools.encodeXML(currentItem.getProduct().getGlobalIDScheme()) + "\">" + XMLTools.encodeXML(currentItem.getProduct().getGlobalID()) + "</ram:GlobalID>");
				}

				if (currentItem.getProduct().getSellerAssignedID() != null) {
					xml.append("<ram:SellerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getSellerAssignedID()) + "</ram:SellerAssignedID>");
				}
				if (currentItem.getProduct().getBuyerAssignedID() != null) {
					xml.append("<ram:BuyerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getBuyerAssignedID()) + "</ram:BuyerAssignedID>");
				}

				xml.append("<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>");
				if (currentItem.getProduct().getDescription() != null && !currentItem.getProduct().getDescription().isEmpty()) {
					xml.append("<ram:Description>" + XMLTools.encodeXML(currentItem.getProduct().getDescription()) + "</ram:Description>");
				}

				if (currentItem.getProduct().getAttributes() != null) {
					for (Entry<String, String> entry : currentItem.getProduct().getAttributes().entrySet()) {
						xml.append("<ram:ApplicableProductCharacteristic>" +
							"<ram:Description>" + XMLTools.encodeXML(entry.getKey()) + "</ram:Description>" +
							"<ram:Value>" + XMLTools.encodeXML(entry.getValue()) + "</ram:Value>" +
							"</ram:ApplicableProductCharacteristic>");
					}
				}
				if (currentItem.getProduct().getClassifications() != null) {
					for (IDesignatedProductClassification classification : currentItem.getProduct().getClassifications()) {
						xml.append("<ram:DesignatedProductClassification>"
							+ "<ram:ClassCode listID=\"" + XMLTools.encodeXML(classification.getClassCode().getListID()) + "\"");
						if (classification.getClassCode().getListVersionID() != null) {
							xml.append(" listVersionID=\"" + XMLTools.encodeXML(classification.getClassCode().getListVersionID()) + "\"");
						}
						xml.append(">" + classification.getClassCode().getCode() + "</ram:ClassCode>");
						if (classification.getClassName() != null) {
							xml.append("<ram:ClassName>" + XMLTools.encodeXML(classification.getClassName()) + "</ram:ClassName>");
						}
						xml.append("</ram:DesignatedProductClassification>");
					}
				}
				if (currentItem.getProduct().getCountryOfOrigin() != null) {
					xml.append("<ram:OriginTradeCountry><ram:ID>" + XMLTools.encodeXML(currentItem.getProduct().getCountryOfOrigin()) + "</ram:ID></ram:OriginTradeCountry>");
				}
				xml.append("</ram:SpecifiedTradeProduct>" + "<ram:SpecifiedLineTradeAgreement>");
				if (currentItem.getReferencedDocuments() != null) {
					for (final IReferencedDocument currentReferencedDocument : currentItem.getReferencedDocuments()) {
						xml.append("<ram:AdditionalReferencedDocument>" +
							"<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentReferencedDocument.getIssuerAssignedID()) + "</ram:IssuerAssignedID>" +
							"<ram:TypeCode>" + XMLTools.encodeXML(currentReferencedDocument.getTypeCode()) + "</ram:TypeCode>");
						if (currentReferencedDocument.getName() != null) {
							xml.append("<ram:name>" + XMLTools.encodeXML(currentReferencedDocument.getName()) + "</ram:Name>");
						}
						if (currentReferencedDocument.getReferenceTypeCode() != null) {
							xml.append("<ram:ReferenceTypeCode>" + XMLTools.encodeXML(currentReferencedDocument.getReferenceTypeCode()) + "</ram:ReferenceTypeCode>");
						}
						if (currentReferencedDocument.getFormattedIssueDateTime() != null) {
							final SimpleDateFormat dateFormat102 = new SimpleDateFormat("yyyyMMdd");
							xml.append("<ram:FormattedIssueDateTime><qdt:DateTimeString format=\"102\">" + XMLTools.encodeXML(dateFormat102.format(currentReferencedDocument.getFormattedIssueDateTime())) + "</qdt:DateTimeString></ram:FormattedIssueDateTime>");
						}
						xml.append("</ram:AdditionalReferencedDocument>");
					}
				}
				if ((currentItem.getBuyerOrderReferencedDocumentLineID() != null) || (currentItem.getBuyerOrderReferencedDocumentID() != null)) {
					xml.append("<ram:BuyerOrderReferencedDocument> ");
					if (currentItem.getBuyerOrderReferencedDocumentID() != null) {
						xml.append("<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentItem.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>");
					}
					if (currentItem.getBuyerOrderReferencedDocumentLineID() != null) {
						xml.append("<ram:LineID>" + XMLTools.encodeXML(currentItem.getBuyerOrderReferencedDocumentLineID()) + "</ram:LineID>");
					}
					xml.append("</ram:BuyerOrderReferencedDocument>");
				}

				// Per-unit provider for product-level: ActualAmount must be per-unit (BT-147)
				final IZUGFeRDExportableItem itemForProduct = currentItem;
				IAbsoluteValueProvider perUnitProvider = new IAbsoluteValueProvider() {
					@Override
					public BigDecimal getValue() {
						return itemForProduct.getPrice();
					}
					@Override
					public BigDecimal getQuantity() {
						return BigDecimal.ONE;
					}
				};
				String allowanceChargeStr = "";
				if (currentItem.getProduct().getAllowances() != null && currentItem.getProduct().getAllowances().length > 0) {
					for (final IZUGFeRDAllowanceCharge allowance : currentItem.getProduct().getAllowances()) {
						allowanceChargeStr += getAllowanceChargeStr(allowance, perUnitProvider);
					}
				}
				if (currentItem.getProduct().getCharges() != null && currentItem.getProduct().getCharges().length > 0) {
					for (final IZUGFeRDAllowanceCharge charge : currentItem.getProduct().getCharges()) {
						allowanceChargeStr += getAllowanceChargeStr(charge, perUnitProvider);
					}
				}
				if (!allowanceChargeStr.isEmpty()) {
					xml.append("<ram:GrossPriceProductTradePrice>"
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
						+ "</ram:GrossPriceProductTradePrice>");
				}

				xml.append("<ram:NetPriceProductTradePrice>"
					+ "<ram:ChargeAmount>" + priceFormat(lc.getPrice())
					+ "</ram:ChargeAmount>" // currencyID=\"EUR\"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
					+ "</ram:NetPriceProductTradePrice>");

                if (currentItem.getLineSeller() != null) {
                    xml.append("<ram:ItemSellerTradeParty>" + getTradePartyAsXML(currentItem.getLineSeller(), true, false) + "</ram:ItemSellerTradeParty>");

                }
				xml.append("</ram:SpecifiedLineTradeAgreement>"
					+ "<ram:SpecifiedLineTradeDelivery>"
					+ "<ram:BilledQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">"
					+ quantityFormat(currentItem.getQuantity()) + "</ram:BilledQuantity>");

					if (currentItem.getDeliveryNoteReferencedDocumentID() != null && !currentItem.getDeliveryNoteReferencedDocumentID().trim().isEmpty()) {
						xml.append("<ram:DeliveryNoteReferencedDocument>");
						xml.append("<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentItem.getDeliveryNoteReferencedDocumentID()) + "</ram:IssuerAssignedID>");
						if (currentItem.getDeliveryNoteReferencedDocumentLineID() != null && !currentItem.getDeliveryNoteReferencedDocumentLineID().trim().isEmpty()) {
							xml.append("<ram:LineID>" + XMLTools.encodeXML(currentItem.getDeliveryNoteReferencedDocumentLineID()) + "</ram:LineID>");
						}
						if (currentItem.getDeliveryNoteReferencedDocumentDate() != null) {
							final SimpleDateFormat dateFormat102 = new SimpleDateFormat("yyyyMMdd");
							xml.append("<ram:FormattedIssueDateTime><qdt:DateTimeString format=\"102\">" + XMLTools.encodeXML(dateFormat102.format(currentItem.getDeliveryNoteReferencedDocumentDate())) + "</qdt:DateTimeString></ram:FormattedIssueDateTime>");
						}
						xml.append("</ram:DeliveryNoteReferencedDocument>");

					}

					xml.append("</ram:SpecifiedLineTradeDelivery>"
					+ "<ram:SpecifiedLineTradeSettlement>"
					+ "<ram:ApplicableTradeTax>");
				// <CalculatedAmount/>
				xml.append("<ram:TypeCode>VAT</ram:TypeCode>");
				if (profile != Profiles.getByName("EN16931") && currentItem.getProduct().getTaxExemptionReason() != null) {
					xml.append("<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>");
				}
				xml.append("<ram:CategoryCode>" + currentItem.getProduct().getTaxCategoryCode() + "</ram:CategoryCode>");
				if (profile != Profiles.getByName("EN16931") && currentItem.getProduct().getTaxExemptionReasonCode() != null) {
					xml.append("<ram:ExemptionReasonCode>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReasonCode()) + "</ram:ExemptionReasonCode>");
				}
				BigDecimal vatValue;
				if (currentItem.getProduct().getTaxCategoryCode().equals(TaxCategoryCodeTypeConstants.ZEROTAXPRODUCTS)) {
					vatValue = BigDecimal.ZERO;
				} else {
					vatValue = currentItem.getProduct().getVATPercent();
				}

				if ((!currentItem.getProduct().getTaxCategoryCode().equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) ) {
					xml.append("<ram:RateApplicablePercent>" + vatFormat(vatValue) + "</ram:RateApplicablePercent>");
				}
				xml.append("</ram:ApplicableTradeTax>");

				if ((currentItem.getDetailedDeliveryPeriodFrom() != null) || (currentItem.getDetailedDeliveryPeriodTo() != null)) {
					xml.append("<ram:BillingSpecifiedPeriod>");
					if (currentItem.getDetailedDeliveryPeriodFrom() != null) {
						xml.append("<ram:StartDateTime>" + DATE.udtFormat(currentItem.getDetailedDeliveryPeriodFrom()) + "</ram:StartDateTime>");
					}
					if (currentItem.getDetailedDeliveryPeriodTo() != null) {
						xml.append("<ram:EndDateTime>" + DATE.udtFormat(currentItem.getDetailedDeliveryPeriodTo()) + "</ram:EndDateTime>");
					}
					xml.append("</ram:BillingSpecifiedPeriod>");
				}

				// Item-level: use basisQuantity-aware provider so ActualAmount (BT-136) is correct when basisQuantity != 1
				BigDecimal itemBasisQty = currentItem.getBasisQuantity().compareTo(BigDecimal.ZERO) == 0
					? BigDecimal.ONE.setScale(4)
					: currentItem.getBasisQuantity();
				final IZUGFeRDExportableItem itemForSettlement = currentItem;
				final BigDecimal basisQty = itemBasisQty;
				IAbsoluteValueProvider itemBasisProvider = new IAbsoluteValueProvider() {
					@Override
					public BigDecimal getValue() {
						return itemForSettlement.getPrice().divide(basisQty, 18, RoundingMode.HALF_UP);
					}
					@Override
					public BigDecimal getQuantity() {
						return itemForSettlement.getQuantity();
					}
				};
				String itemTotalAllowanceChargeStr = "";
				if (currentItem.getItemAllowances() != null && currentItem.getItemAllowances().length > 0) {
					for (final IZUGFeRDAllowanceCharge itemTotalAllowance : currentItem.getItemAllowances()) {
						itemTotalAllowanceChargeStr += getItemTotalAllowanceChargeStr(itemTotalAllowance, itemBasisProvider);
					}
				}
				if (currentItem.getItemCharges() != null && currentItem.getItemCharges().length > 0) {
					for (final IZUGFeRDAllowanceCharge itemTotalCharges : currentItem.getItemCharges()) {
						itemTotalAllowanceChargeStr += getItemTotalAllowanceChargeStr(itemTotalCharges, itemBasisProvider);
					}
				}
				if (!itemTotalAllowanceChargeStr.isEmpty()) {
					xml.append(itemTotalAllowanceChargeStr );
				}
				xml.append("<ram:SpecifiedTradeSettlementLineMonetarySummation>"
					+ "<ram:LineTotalAmount>" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>" // currencyID=\"EUR\"
					+ "</ram:SpecifiedTradeSettlementLineMonetarySummation>");
				if (currentItem.getAdditionalReferences() != null) {
					for (final IReferencedDocument currentReference : currentItem.getAdditionalReferences()) {
						xml.append("<ram:AdditionalReferencedDocument>" +
							"<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentReference.getIssuerAssignedID()) + "</ram:IssuerAssignedID>" +
							"<ram:TypeCode>130</ram:TypeCode>");
						if (currentReference.getName() != null) {
							xml.append("<ram:name>" + XMLTools.encodeXML(currentReference.getName()) + "</ram:Name>");
						}
						if (currentReference.getReferenceTypeCode() != null) {
							xml.append("<ram:ReferenceTypeCode>" + XMLTools.encodeXML(currentReference.getReferenceTypeCode()) + "</ram:ReferenceTypeCode>");
						}
						if (currentReference.getFormattedIssueDateTime() != null) {
							final SimpleDateFormat dateFormat102 = new SimpleDateFormat("yyyyMMdd");
							xml.append("<ram:FormattedIssueDateTime><qdt:DateTimeString format=\"102\">" + XMLTools.encodeXML(dateFormat102.format(currentReference.getFormattedIssueDateTime())) + "</qdt:DateTimeString></ram:FormattedIssueDateTime>");
						}
						xml.append("</ram:AdditionalReferencedDocument>");
					}
				}
				if (currentItem.getAccountingReference() != null && !currentItem.getAccountingReference().trim().isEmpty()) {
					xml.append("<ram:ReceivableSpecifiedTradeAccountingAccount>"
						+ "<ram:ID>" + XMLTools.encodeXML(currentItem.getAccountingReference()) + "</ram:ID>"
						+ "</ram:ReceivableSpecifiedTradeAccountingAccount>");
				}
				xml.append("</ram:SpecifiedLineTradeSettlement>"
					+ "</ram:IncludedSupplyChainTradeLineItem>");
			}

		}

		xml.append("<ram:ApplicableHeaderTradeAgreement>");
		if (trans.getReferenceNumber() != null) {
			xml.append("<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>");

		}
		xml.append("<ram:SellerTradeParty>" + getTradePartyAsXML(trans.getSender(), true, false) + "</ram:SellerTradeParty>");
		xml.append("<ram:BuyerTradeParty>" + getTradePartyAsXML(trans.getRecipient(), false, false) + "</ram:BuyerTradeParty>");

		if (trans.getDeliveryTypeCode() != null && getProfile() == Profiles.getByName("Extended")) {
			xml.append("<ram:ApplicableTradeDeliveryTerms>"
				+ "<ram:DeliveryTypeCode>"
				+ trans.getDeliveryTypeCode()
				+ "</ram:DeliveryTypeCode>"
				+ "</ram:ApplicableTradeDeliveryTerms>");
		}
		if (trans.getSellerOrderReferencedDocumentID() != null && !trans.getSellerOrderReferencedDocumentID().trim().isEmpty()) {
			xml.append("<ram:SellerOrderReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getSellerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>"
				+ "</ram:SellerOrderReferencedDocument>");
		}
		if (trans.getBuyerOrderReferencedDocumentID() != null && !trans.getBuyerOrderReferencedDocumentID().trim().isEmpty()) {
			xml.append("<ram:BuyerOrderReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>"
				+ "</ram:BuyerOrderReferencedDocument>");
		}
		if (trans.getContractReferencedDocument() != null && !trans.getContractReferencedDocument().trim().isEmpty()) {
			xml.append("<ram:ContractReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getContractReferencedDocument()) + "</ram:IssuerAssignedID>"
				+ "</ram:ContractReferencedDocument>");
		}

		// Additional Documents of XRechnung (Rechnungsbegruendende Unterlagen - BG-24 XRechnung)
		if (trans.getAdditionalReferencedDocuments() != null) {
			for (final FileAttachment f : trans.getAdditionalReferencedDocuments()) {
				final String documentContent = Base64.getEncoder().encodeToString(f.getData());
				xml.append("<ram:AdditionalReferencedDocument>"
					+ "<ram:IssuerAssignedID>" + f.getFilename() + "</ram:IssuerAssignedID>"
					+ "<ram:TypeCode>916</ram:TypeCode>"
					+ "<ram:Name>" + f.getDescription() + "</ram:Name>"
					+ "<ram:AttachmentBinaryObject mimeCode=\"" + f.getMimetype() + "\"\n"
					+ "filename=\"" + f.getFilename() + "\">" + documentContent + "</ram:AttachmentBinaryObject>"
					+ "</ram:AdditionalReferencedDocument>");
			}
		}
		if (trans.getObjectIdentifierReferencedDocument() != null) {
			xml.append("<ram:AdditionalReferencedDocument>"
				+ "<ram:IssuerAssignedID>" + XMLTools.encodeXML(trans.getObjectIdentifierReferencedDocument().getIssuerAssignedID()) + "</ram:IssuerAssignedID>"
				+ "<ram:TypeCode>130</ram:TypeCode>");
		    String name = trans.getObjectIdentifierReferencedDocument().getName();
		    if (name != null && !name.isEmpty()) {
		        xml.append("<ram:Name>" + XMLTools.encodeXML(name) + "</ram:Name>");
		    }
		    // NEW: BT-18-1 scheme identifier
		    String rtc = trans.getObjectIdentifierReferencedDocument().getReferenceTypeCode();
		    if (rtc != null && !rtc.isEmpty()) {
		        xml.append("<ram:ReferenceTypeCode>" + XMLTools.encodeXML(rtc) + "</ram:ReferenceTypeCode>");
		    }
			if (trans.getObjectIdentifierReferencedDocument().getFormattedIssueDateTime() != null) {
				xml.append("<ram:FormattedIssueDateTime>" + DATE.qdtFormat(trans.getObjectIdentifierReferencedDocument().getFormattedIssueDateTime()) + "</ram:FormattedIssueDateTime>");
			}
			xml.append("</ram:AdditionalReferencedDocument>");
		}
		if (trans.getTenderReferencedDocument() != null) {
			xml.append("<ram:AdditionalReferencedDocument>"
				+ "<ram:IssuerAssignedID>" + XMLTools.encodeXML(trans.getTenderReferencedDocument().getIssuerAssignedID()) + "</ram:IssuerAssignedID>"
				+ "<ram:TypeCode>50</ram:TypeCode>");
		    String name = trans.getTenderReferencedDocument().getName();
		    if (name != null && !name.isEmpty()) {
		        xml.append("<ram:Name>" + XMLTools.encodeXML(name) + "</ram:Name>");
		    }
		    // NEW: BT-18-1 scheme identifier
		    String rtc = trans.getTenderReferencedDocument().getReferenceTypeCode();
		    if (rtc != null && !rtc.isEmpty()) {
		    	xml.append("<ram:ReferenceTypeCode>" + XMLTools.encodeXML(rtc) + "</ram:ReferenceTypeCode>");
		    }
			if (trans.getTenderReferencedDocument().getFormattedIssueDateTime() != null) {
				xml.append("<ram:FormattedIssueDateTime>" + DATE.qdtFormat(trans.getTenderReferencedDocument().getFormattedIssueDateTime()) + "</ram:FormattedIssueDateTime>");
			}
			xml.append("</ram:AdditionalReferencedDocument>");
		}
		if (trans.getRelatedReferencedDocument() != null) {
			xml.append("<ram:AdditionalReferencedDocument>"
				+ "<ram:IssuerAssignedID>" + XMLTools.encodeXML(trans.getRelatedReferencedDocument().getIssuerAssignedID()) + "</ram:IssuerAssignedID>"
				+ "<ram:TypeCode>916</ram:TypeCode>");
		    String name = trans.getRelatedReferencedDocument().getName();
		    if (name != null && !name.isEmpty()) {
		        xml.append("<ram:Name>" + XMLTools.encodeXML(name) + "</ram:Name>");
		    }
		    // NEW: BT-18-1 scheme identifier
		    String rtc = trans.getRelatedReferencedDocument().getReferenceTypeCode();
		    if (rtc != null && !rtc.isEmpty()) {
		    	xml.append("<ram:ReferenceTypeCode>" + XMLTools.encodeXML(rtc) + "</ram:ReferenceTypeCode>");
		    }
			if (trans.getRelatedReferencedDocument().getFormattedIssueDateTime() != null) {
				xml.append("<ram:FormattedIssueDateTime>" + DATE.qdtFormat(trans.getRelatedReferencedDocument().getFormattedIssueDateTime()) + "</ram:FormattedIssueDateTime>");
			}
			xml.append("</ram:AdditionalReferencedDocument>");
		}
		if (trans.getSpecifiedProcuringProjectID() != null) {
			xml.append("<ram:SpecifiedProcuringProject>"
				+ "<ram:ID>" + XMLTools.encodeXML(trans.getSpecifiedProcuringProjectID()) + "</ram:ID>");
			if (trans.getSpecifiedProcuringProjectName() != null) {
				xml.append("<ram:Name>" + XMLTools.encodeXML(trans.getSpecifiedProcuringProjectName()) + "</ram:Name>");
			}
			xml.append("</ram:SpecifiedProcuringProject>");
		}
		xml.append("</ram:ApplicableHeaderTradeAgreement>");
		xml.append("<ram:ApplicableHeaderTradeDelivery>");

		if (this.trans.getDeliveryAddress() != null) {
			xml.append("<ram:ShipToTradeParty>" +
				getTradePartyAsXML(this.trans.getDeliveryAddress(), false, true) +
				"</ram:ShipToTradeParty>");
		}
		if (this.trans.getEndCustomerDeliveryAddress() != null) {
			xml.append("<ram:UltimateShipToTradeParty>" +
				getTradePartyAsXML(this.trans.getEndCustomerDeliveryAddress(), false, true) +
				"</ram:UltimateShipToTradeParty>");
		}


		if (trans.getDeliveryDate() != null) {
			xml.append("<ram:ActualDeliverySupplyChainEvent>"
				+ "<ram:OccurrenceDateTime>" + DATE.udtFormat(trans.getDeliveryDate()) + "</ram:OccurrenceDateTime>"
				+ "</ram:ActualDeliverySupplyChainEvent>");
		}

		if (trans.getDespatchAdviceReferencedDocumentID() != null && !trans.getDespatchAdviceReferencedDocumentID().trim().isEmpty()) {
			xml.append("<ram:DespatchAdviceReferencedDocument>");
			xml.append("<ram:IssuerAssignedID>" + XMLTools.encodeXML(trans.getDespatchAdviceReferencedDocumentID()) + "</ram:IssuerAssignedID>");
			xml.append("</ram:DespatchAdviceReferencedDocument>");
		}

		if (trans.getDeliveryNoteReferencedDocumentID() != null && !trans.getDeliveryNoteReferencedDocumentID().trim().isEmpty()) {
			xml.append("<ram:DeliveryNoteReferencedDocument>");
			xml.append("<ram:IssuerAssignedID>" + XMLTools.encodeXML(trans.getDeliveryNoteReferencedDocumentID()) + "</ram:IssuerAssignedID>");
			if (trans.getDeliveryNoteReferencedDocumentDate() != null) {
				final SimpleDateFormat dateFormat102 = new SimpleDateFormat("yyyyMMdd");
				xml.append("<ram:FormattedIssueDateTime><qdt:DateTimeString format=\"102\">" + XMLTools.encodeXML(dateFormat102.format(trans.getDeliveryNoteReferencedDocumentDate())) + "</qdt:DateTimeString></ram:FormattedIssueDateTime>");
			}
			xml.append("</ram:DeliveryNoteReferencedDocument>");
		}

		xml.append("</ram:ApplicableHeaderTradeDelivery>");
		xml.append("<ram:ApplicableHeaderTradeSettlement>");

		if ((trans.getCreditorReferenceID() != null) && (getProfile() != Profiles.getByName("Minimum"))) {
			xml.append("<ram:CreditorReferenceID>" + XMLTools.encodeXML(trans.getCreditorReferenceID()) + "</ram:CreditorReferenceID>");
		}
		if ((trans.getPaymentReference() != null) && (getProfile() != Profiles.getByName("Minimum"))) {
			xml.append("<ram:PaymentReference>" + XMLTools.encodeXML(trans.getPaymentReference()) + "</ram:PaymentReference>");
		}
		xml.append("<ram:InvoiceCurrencyCode>" + trans.getCurrency() + "</ram:InvoiceCurrencyCode>");

		if (this.trans.getInvoicer() != null && getProfile() == Profiles.getByName("Extended")) {
			xml.append("<ram:InvoicerTradeParty>" +
				getTradePartyAsXML(this.trans.getInvoicer(), false, false) +
				"</ram:InvoicerTradeParty>");
		}
		if (this.trans.getInvoicee() != null && getProfile() == Profiles.getByName("Extended")) {
			xml.append("<ram:InvoiceeTradeParty>" +
				getTradePartyAsXML(this.trans.getInvoicee(), false, false) +
				"</ram:InvoiceeTradeParty>");
		}
		if (this.trans.getPayee() != null) {
			xml.append("<ram:PayeeTradeParty>" +
				getTradePartyPayeeAsXML(this.trans.getPayee()) +
				"</ram:PayeeTradeParty>");
		}

		if (trans.getTradeSettlementPayment() != null) {
			for (final IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if (payment != null) {
					hasDueDate = true;
					if (getProfile() != Profiles.getByName("Minimum")) {
						xml.append(payment.getSettlementXML(getProfile()));
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
						xml.append(payment.getSettlementXML(getProfile()));
					}
				}
			}
		}

		final List<VATAmount> vatAmounts = calc.getVATAmountList();
		for (final VATAmount amount : vatAmounts) {
			if (amount != null) {
				final String amountCategoryCode = amount.getCategoryCode();
				final String amountDueDateTypeCode = amount.getDueDateTypeCode();
				final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(amountCategoryCode);
				if (getProfile() != Profiles.getByName("Minimum")) {
					String exemptionReasonTextXML = "";
					if (displayExemptionReason && amount.getVatExemptionReasonText() != null) {
						exemptionReasonTextXML = "<ram:ExemptionReason>" + XMLTools.encodeXML(amount.getVatExemptionReasonText()) + "</ram:ExemptionReason>";
					}
					String exemptionReasonCodeXML = "";
					if (displayExemptionReason && amount.getVatExemptionReasonCode() != null) {
						exemptionReasonCodeXML = "<ram:ExemptionReasonCode>" + XMLTools.encodeXML(amount.getVatExemptionReasonCode()) + "</ram:ExemptionReasonCode>";
					}

					xml.append("<ram:ApplicableTradeTax>"
						+ "<ram:CalculatedAmount>" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>" //currencyID=\"EUR\"
						+ "<ram:TypeCode>VAT</ram:TypeCode>"
						+ exemptionReasonTextXML
						+ "<ram:BasisAmount>" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>" // currencyID=\"EUR\"
						+ "<ram:CategoryCode>" + amountCategoryCode + "</ram:CategoryCode>"
						+ exemptionReasonCodeXML
						+ (amountDueDateTypeCode != null ? "<ram:DueDateTypeCode>" + amountDueDateTypeCode + "</ram:DueDateTypeCode>" : ""));
					xml.append("<ram:RateApplicablePercent>"
						+ vatFormat(amount.getApplicablePercent()) + "</ram:RateApplicablePercent>");
					xml.append("</ram:ApplicableTradeTax>");
				}
			}
		}
		if ((trans.getDetailedDeliveryPeriodFrom() != null) || (trans.getDetailedDeliveryPeriodTo() != null)) {
			xml.append("<ram:BillingSpecifiedPeriod>");
			if (trans.getDetailedDeliveryPeriodFrom() != null) {
				xml.append("<ram:StartDateTime>" + DATE.udtFormat(trans.getDetailedDeliveryPeriodFrom()) + "</ram:StartDateTime>");
			}
			if (trans.getDetailedDeliveryPeriodTo() != null) {
				xml.append("<ram:EndDateTime>" + DATE.udtFormat(trans.getDetailedDeliveryPeriodTo()) + "</ram:EndDateTime>");
			}
			xml.append("</ram:BillingSpecifiedPeriod>");
		}

		if ((trans.getZFCharges() != null) && (trans.getZFCharges().length > 0)) {
			if ((profile == Profiles.getByName("XRechnung")) || (profile == Profiles.getByName("EN16931")) || (profile == Profiles.getByName("EXTENDED"))) {
				for (IZUGFeRDAllowanceCharge charge : trans.getZFCharges()) {
					final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(charge.getTaxCategoryCode());
					String exemptionReasonTextXML = "";
					if (displayExemptionReason && charge.getTaxExemptionReason() != null) {
						exemptionReasonTextXML = "<ram:ExemptionReason>" + XMLTools.encodeXML(charge.getTaxExemptionReason()) + "</ram:ExemptionReason>";
					}
					String exemptionReasonCodeXML = "";
					if (displayExemptionReason && charge.getTaxExemptionReasonCode() != null) {
						exemptionReasonCodeXML = "<ram:ExemptionReasonCode>" + XMLTools.encodeXML(charge.getTaxExemptionReasonCode()) + "</ram:ExemptionReasonCode>";
					}

					xml.append("<ram:SpecifiedTradeAllowanceCharge>" +
						"<ram:ChargeIndicator>" +
						"<udt:Indicator>true</udt:Indicator>" +
						"</ram:ChargeIndicator>");
					if (charge.getSequenceNumeric() != null) {
						xml.append("<ram:SequenceNumeric>" + charge.getSequenceNumeric() + "</ram:SequenceNumeric>");
					}
					if (charge.getPercent() != null && (profile == Profiles.getByName("EN16931") || (profile == Profiles.getByName("EXTENDED")))) {
						xml.append("<ram:CalculationPercent>" + vatFormat(charge.getPercent()) + "</ram:CalculationPercent>");
					}
					if (charge.getBasisAmount() != null && (profile == Profiles.getByName("EN16931") || (profile == Profiles.getByName("EXTENDED")))) {
						xml.append("<ram:BasisAmount>" + currencyFormat(charge.getBasisAmount()) + "</ram:BasisAmount>");
					}
					xml.append("<ram:ActualAmount>" + currencyFormat(charge.getTotalAmount(calc)) + "</ram:ActualAmount>");
					if (charge.getReasonCode() != null) {
						xml.append("<ram:ReasonCode>" + charge.getReasonCode() + "</ram:ReasonCode>");
					}
					if (charge.getReason() != null) {
						xml.append("<ram:Reason>" + XMLTools.encodeXML(charge.getReason()) + "</ram:Reason>");
					}
					xml.append("<ram:CategoryTradeTax>" +
						"<ram:TypeCode>VAT</ram:TypeCode>" +
						exemptionReasonTextXML +
						"<ram:CategoryCode>" + charge.getTaxCategoryCode() + "</ram:CategoryCode>" +
						exemptionReasonCodeXML);
					if (charge.getTaxRateApplicablePercent() != null && !charge.getTaxCategoryCode().equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) {
						xml.append("<ram:RateApplicablePercent>" + vatFormat(charge.getTaxRateApplicablePercent()) + "</ram:RateApplicablePercent>");
					}
					xml.append("</ram:CategoryTradeTax>" +
						"</ram:SpecifiedTradeAllowanceCharge>");
				}
			} else {
				for (final VATAmount amount : vatAmounts) {
					if (calc.getChargesForPercent(amount.getApplicablePercent()).compareTo(BigDecimal.ZERO) != 0) {
						xml.append("<ram:SpecifiedTradeAllowanceCharge>" +
							"<ram:ChargeIndicator>" +
							"<udt:Indicator>true</udt:Indicator>" +
							"</ram:ChargeIndicator>" +
							"<ram:ActualAmount>" + currencyFormat(calc.getChargesForPercent(amount.getApplicablePercent())) + "</ram:ActualAmount>" +
							"<ram:Reason>" + XMLTools.encodeXML(calc.getChargeReasonForPercent(amount.getApplicablePercent())) + "</ram:Reason>" +
							"<ram:CategoryTradeTax>" +
							"<ram:TypeCode>VAT</ram:TypeCode>" +
							"<ram:CategoryCode>" + amount.getCategoryCode() + "</ram:CategoryCode>" +
							"<ram:RateApplicablePercent>" + vatFormat(amount.getApplicablePercent()) + "</ram:RateApplicablePercent>" +
							"</ram:CategoryTradeTax>" +
							"</ram:SpecifiedTradeAllowanceCharge>");
					}
				}
			}
		}

		if ((trans.getZFAllowances() != null) && (trans.getZFAllowances().length > 0)) {
			if ((profile == Profiles.getByName("XRechnung")) || (profile == Profiles.getByName("EN16931")) || (profile == Profiles.getByName("EXTENDED"))) {
				for (IZUGFeRDAllowanceCharge allowance : trans.getZFAllowances()) {
					final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(allowance.getTaxCategoryCode());
					String exemptionReasonTextXML = "";
					if (displayExemptionReason && allowance.getTaxExemptionReason() != null) {
						exemptionReasonTextXML = "<ram:ExemptionReason>" + XMLTools.encodeXML(allowance.getTaxExemptionReason()) + "</ram:ExemptionReason>";
					}
					String exemptionReasonCodeXML = "";
					if (displayExemptionReason && allowance.getTaxExemptionReasonCode() != null) {
						exemptionReasonCodeXML = "<ram:ExemptionReasonCode>" + XMLTools.encodeXML(allowance.getTaxExemptionReasonCode()) + "</ram:ExemptionReasonCode>";
					}

					xml.append("<ram:SpecifiedTradeAllowanceCharge>" +
						"<ram:ChargeIndicator>" +
						"<udt:Indicator>false</udt:Indicator>" +
						"</ram:ChargeIndicator>");
					if (allowance.getSequenceNumeric() != null) {
						xml.append("<ram:SequenceNumeric>" + allowance.getSequenceNumeric() + "</ram:SequenceNumeric>");
					}
					if (allowance.getPercent() != null) {
						xml.append("<ram:CalculationPercent>" + vatFormat(allowance.getPercent()) + "</ram:CalculationPercent>");
					}
					if (allowance.getBasisAmount() != null) {
						xml.append("<ram:BasisAmount>" + currencyFormat(allowance.getBasisAmount()) + "</ram:BasisAmount>");
					}
					xml.append("<ram:ActualAmount>" + currencyFormat(allowance.getTotalAmount(calc)) + "</ram:ActualAmount>");
					if (allowance.getReasonCode() != null) {
						xml.append("<ram:ReasonCode>" + allowance.getReasonCode() + "</ram:ReasonCode>");
					}
					if (allowance.getReason() != null) {
						xml.append("<ram:Reason>" + XMLTools.encodeXML(allowance.getReason()) + "</ram:Reason>");
					}
					xml.append("<ram:CategoryTradeTax>" +
							"<ram:TypeCode>VAT</ram:TypeCode>" +
							exemptionReasonTextXML +
							"<ram:CategoryCode>" + allowance.getTaxCategoryCode() + "</ram:CategoryCode>" +
							exemptionReasonCodeXML);
					if (allowance.getTaxRateApplicablePercent() != null && !allowance.getTaxCategoryCode().equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) {
						xml.append("<ram:RateApplicablePercent>" + vatFormat(allowance.getTaxRateApplicablePercent()) + "</ram:RateApplicablePercent>");
					}
					xml.append("</ram:CategoryTradeTax>" +
						"</ram:SpecifiedTradeAllowanceCharge>");
				}
			} else {
				for (final VATAmount amount : vatAmounts) {
					if (calc.getAllowancesForPercent(amount.getApplicablePercent()).compareTo(BigDecimal.ZERO) != 0) {
						xml.append("<ram:SpecifiedTradeAllowanceCharge>" +
							"<ram:ChargeIndicator>" +
							"<udt:Indicator>false</udt:Indicator>" +
							"</ram:ChargeIndicator>" +
							"<ram:ActualAmount>" + currencyFormat(calc.getAllowancesForPercent(amount.getApplicablePercent())) + "</ram:ActualAmount>" +
							"<ram:Reason>" + XMLTools.encodeXML(calc.getAllowanceReasonForPercent(amount.getApplicablePercent())) + "</ram:Reason>" +
							"<ram:CategoryTradeTax>" +
							"<ram:TypeCode>VAT</ram:TypeCode>" +
							"<ram:CategoryCode>" + amount.getCategoryCode() + "</ram:CategoryCode>" +
							"<ram:RateApplicablePercent>" + vatFormat(amount.getApplicablePercent()) + "</ram:RateApplicablePercent>" +
							"</ram:CategoryTradeTax>" +
							"</ram:SpecifiedTradeAllowanceCharge>");
					}
				}
			}
		}

		if ((trans.getZFLogisticsServiceCharges() != null) && (trans.getZFLogisticsServiceCharges().length > 0)) {
			if (profile == Profiles.getByName("EXTENDED")) {
				for (IZUGFeRDLogisticsServiceCharge charge : trans.getZFLogisticsServiceCharges()) {
					final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(charge.getTaxCategoryCode());
					String exemptionReasonTextXML = "";
					if (displayExemptionReason && charge.getTaxExemptionReason() != null) {
						exemptionReasonTextXML = "<ram:ExemptionReason>" + XMLTools.encodeXML(charge.getTaxExemptionReason()) + "</ram:ExemptionReason>";
					}
					String exemptionReasonCodeXML = "";
					if (displayExemptionReason && charge.getTaxExemptionReasonCode() != null) {
						exemptionReasonCodeXML = "<ram:ExemptionReasonCode>" + XMLTools.encodeXML(charge.getTaxExemptionReasonCode()) + "</ram:ExemptionReasonCode>";
					}

					xml.append("<ram:SpecifiedLogisticsServiceCharge>");
					xml.append("<ram:Description>" + XMLTools.encodeXML(charge.getDescription()) + "</ram:Description>");
					xml.append("<ram:AppliedAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(charge.getAppliedAmount()) + "</ram:AppliedAmount>");
					xml.append("<ram:AppliedTradeTax>");
					if ( charge.getTaxCalculatedAmount() != null ) {
						xml.append("<ram:CalculatedAmount>" + currencyFormat(charge.getTaxCalculatedAmount()) + "</ram:CalculatedAmount>");
					}
					xml.append("<ram:TypeCode>VAT</ram:TypeCode>");
					xml.append(exemptionReasonTextXML);
					if ( charge.getTaxBasisAmount() != null ) {
						xml.append("<ram:BasisAmount>" + currencyFormat(charge.getTaxBasisAmount()) + "</ram:BasisAmount>");
					}
					if ( charge.getTaxLineTotalBasisAmount() != null ) {
						xml.append("<ram:LineTotalBasisAmount>" + currencyFormat(charge.getTaxLineTotalBasisAmount()) + "</ram:LineTotalBasisAmount>");
					}
					if ( charge.getTaxAllowanceChargeBasisAmount() != null ) {
						xml.append("<ram:AllowanceChargeBasisAmount>" + currencyFormat(charge.getTaxAllowanceChargeBasisAmount()) + "</ram:AllowanceChargeBasisAmount>");
					}
					if ( charge.getTaxCategoryCode() != null ) {
						xml.append("<ram:CategoryCode>" + charge.getTaxCategoryCode() + "</ram:CategoryCode>");
					}
					xml.append(exemptionReasonCodeXML);
					if ( charge.getTaxPointDate() != null ) {
						final SimpleDateFormat dateFormat102 = new SimpleDateFormat("yyyyMMdd");
						xml.append("<ram:TaxPointDate><qdt:DateTimeString format=\"102\">" + XMLTools.encodeXML(dateFormat102.format(charge.getTaxPointDate())) + "</qdt:DateTimeString></ram:TaxPointDate>");
					}
					if (charge.getTaxDueDateTypeCode() != null) {
						xml.append("<ram:DueDateTypeCode>" + XMLTools.encodeXML(charge.getTaxDueDateTypeCode()) + "</ram:DueDateTypeCode>");
					}
					if (charge.getTaxRateApplicablePercent() != null && !charge.getTaxCategoryCode().equals(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE)) {
						xml.append("<ram:RateApplicablePercent>" + vatFormat(charge.getTaxRateApplicablePercent()) + "</ram:RateApplicablePercent>");
					}
					xml.append("</ram:AppliedTradeTax>");
					xml.append("</ram:SpecifiedLogisticsServiceCharge>");
				}
			} else {
				((Invoice) trans).setZFLogisticsServiceCharges(new ArrayList<LogisticsServiceCharge>().toArray( new LogisticsServiceCharge[0]));
			}
		}

		if ((trans.getPaymentTerms() == null) && (getProfile() != Profiles.getByName("Minimum")) && ((paymentTermsDescription != null) || (trans.getTradeSettlement() != null) || (hasDueDate))) {
			xml.append("<ram:SpecifiedTradePaymentTerms>");

			if (paymentTermsDescription != null) {
				xml.append("<ram:Description>" + paymentTermsDescription + "</ram:Description>");
			}

			if (trans.getDueDate() != null) {
				xml.append("<ram:DueDateDateTime>" // $NON-NLS-2$
					+ DATE.udtFormat(trans.getDueDate())
					+ "</ram:DueDateDateTime>"); // 20130704
			}

			if (trans.getTradeSettlement() != null) {
				for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if (payment instanceof IZUGFeRDTradeSettlementDebit) {
						xml.append(payment.getPaymentXML());
					}
					if (payment instanceof IZUGFeRDTradeSettlementDebit) {
						xml.append(payment.getPaymentXML());
					}
				}
			}

			xml.append("</ram:SpecifiedTradePaymentTerms>");
		} else {
			xml.append(buildPaymentTermsXml());
		}
		if (profile == Profiles.getByName("Extended") && trans.getCashDiscounts() != null) {
			for (IZUGFeRDCashDiscount discount : trans.getCashDiscounts()
			) {
				xml.append(discount.getAsCII());
			}
		}


		final String allowanceTotalLine = "<ram:AllowanceTotalAmount>" + currencyFormat(calc.getAllowancesForPercent(null)) + "</ram:AllowanceTotalAmount>";

		final String chargesTotalLine = "<ram:ChargeTotalAmount>" + currencyFormat(calc.getChargesForPercent(null)) + "</ram:ChargeTotalAmount>";

		xml.append("<ram:SpecifiedTradeSettlementHeaderMonetarySummation>");
		if ((getProfile() != Profiles.getByName("Minimum"))) {
			xml.append("<ram:LineTotalAmount>" + currencyFormat(calc.getTotal()) + "</ram:LineTotalAmount>");
			xml.append(chargesTotalLine
				+ allowanceTotalLine);
		}
		xml.append("<ram:TaxBasisTotalAmount>" + currencyFormat(calc.getTaxBasis()) + "</ram:TaxBasisTotalAmount>"
			// //
			// currencyID=\"EUR\"
			+ "<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
			+ currencyFormat(calc.getGrandTotal().subtract(calc.getTaxBasis())) + "</ram:TaxTotalAmount>");
		if (trans.getRoundingAmount() != null) {
			xml.append("<ram:RoundingAmount>" + currencyFormat(trans.getRoundingAmount()) + "</ram:RoundingAmount>");
		}

		xml.append("<ram:GrandTotalAmount>" + currencyFormat(calc.getGrandTotal()) + "</ram:GrandTotalAmount>");
		// //
		// currencyID=\"EUR\"
		if (getProfile() != Profiles.getByName("Minimum")) {
			xml.append("<ram:TotalPrepaidAmount>" + currencyFormat(calc.getTotalPrepaid()) + "</ram:TotalPrepaidAmount>");
		}
		xml.append("<ram:DuePayableAmount>" + currencyFormat(calc.getDuePayable()) + "</ram:DuePayableAmount>"
			+ "</ram:SpecifiedTradeSettlementHeaderMonetarySummation>");
		if (trans.getInvoiceReferencedDocumentID() != null && !trans.getInvoiceReferencedDocumentID().trim().isEmpty()) {
			xml.append("<ram:InvoiceReferencedDocument>"
				+ "<ram:IssuerAssignedID>"
				+ XMLTools.encodeXML(trans.getInvoiceReferencedDocumentID()) + "</ram:IssuerAssignedID>");
			if (trans.getInvoiceReferencedIssueDate() != null) {
				xml.append("<ram:FormattedIssueDateTime>"
					+ DATE.qdtFormat(trans.getInvoiceReferencedIssueDate())
					+ "</ram:FormattedIssueDateTime>");
			}
			xml.append("</ram:InvoiceReferencedDocument>");
		}
		if (trans.getInvoiceReferencedDocuments() != null) {
			for (ReferencedDocument doc : trans.getInvoiceReferencedDocuments()) {
				xml.append("<ram:InvoiceReferencedDocument>"
					+ "<ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(doc.getIssuerAssignedID()) + "</ram:IssuerAssignedID>");
				if (doc.getFormattedIssueDateTime() != null) {
					xml.append("<ram:FormattedIssueDateTime>"
						+ DATE.qdtFormat(doc.getFormattedIssueDateTime())
						+ "</ram:FormattedIssueDateTime>");
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

		xml.append("</rsm:SupplyChainTradeTransaction>"
			+ "</rsm:CrossIndustryInvoice>");

		final byte[] zugferdRaw = xml.toString().getBytes(StandardCharsets.UTF_8);

		zugferdData = XMLTools.removeBOM(zugferdRaw);
	}

	protected String buildItemNotes(IZUGFeRDExportableItem currentItem) {
		final List<IncludedNote> includedNotes = new ArrayList<>();

		Optional.ofNullable(currentItem.getNotesWithSubjectCode()).ifPresent(includedNotes::addAll);

		if (currentItem.getNotes() != null) {
			for (final String currentNote : currentItem.getNotes()) {
				includedNotes.add(IncludedNote.unspecifiedNote(currentNote));
			}
		}

		return includedNotes.stream().map(IncludedNote::toCiiXml).collect(Collectors.joining(""));
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
		{
			// add payment terms
			{
				IZUGFeRDPaymentTerms izpt = trans.getPaymentTerms();
				if (izpt != null) {
					paymentTerms.add(izpt);
				}
			}

			// add extended payment terms (except the first one which is already added above)
			{
				IZUGFeRDPaymentTerms[] extendedPaymentTerms = trans.getExtendedPaymentTerms();
				for (int i = 1; i < extendedPaymentTerms.length; i++) {
					paymentTerms.add(extendedPaymentTerms[i]);
				}
			}
		}

		String paymentTermsXml = "";
		if (paymentTerms.size() == 0) {
			return "";
		}

		for (IZUGFeRDPaymentTerms pt : paymentTerms) {
			paymentTermsXml += "<ram:SpecifiedTradePaymentTerms>";

			final IZUGFeRDPaymentDiscountTerms discountTerms = pt.getDiscountTerms();
			final Date dueDate = pt.getDueDate();
			if (dueDate != null && discountTerms != null && discountTerms.getBaseDate() != null) {
				throw new IllegalStateException(
					"if paymentTerms.dueDate is specified, paymentTerms.discountTerms.baseDate has not to be specified");
			}

			if (pt.getDescription() != null) {
				paymentTermsXml += "<ram:Description>" + pt.getDescription() + "</ram:Description>";
			}

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
		}
		return paymentTermsXml;
	}

}
