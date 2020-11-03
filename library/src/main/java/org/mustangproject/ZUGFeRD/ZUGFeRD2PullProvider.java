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

import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Base64.Encoder;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.Invoice;
import org.mustangproject.FileAttachment;
import org.mustangproject.XMLTools;

public class ZUGFeRD2PullProvider implements IXMLProvider, IAbsoluteValueProvider {

	//// MAIN CLASS
	protected SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd");
	protected byte[] zugferdData;
	protected IExportableTransaction trans;
	private String paymentTermsDescription;
	protected Profile profile = Profiles.getByName("EN16931");


	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 */
	@Override
	public void setTest() {
	}

	private String vatFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 2);
	}

	private String currencyFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 2);
	}

	private String priceFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 4);
	}

	private String quantityFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 4);
	}

	@Override
	public byte[] getXML() {

		byte[] res = zugferdData;

		StringWriter sw = new StringWriter();
		Document document = null;
		try {
			document = DocumentHelper.parseText(new String(zugferdData));
		} catch (DocumentException e1) {
			Logger.getLogger(ZUGFeRD2PullProvider.class.getName()).log(Level.SEVERE, null, e1);
		}
		try {
			OutputFormat format = OutputFormat.createPrettyPrint();
			XMLWriter writer = new XMLWriter(sw, format);
			writer.write(document);
			res = sw.toString().getBytes("UTF-8");

		} catch (IOException e) {
			Logger.getLogger(ZUGFeRD2PullProvider.class.getName()).log(Level.SEVERE, null, e);
		}

		return res;

	}

	//move
	protected BigDecimal getTotalPrepaid() {
		if (trans.getTotalPrepaidAmount() == null) {
			return new BigDecimal(0);
		} else {
			return trans.getTotalPrepaidAmount();
		}
	}

	protected BigDecimal getTotalGross() {

		BigDecimal res = getTaxBasis();
		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			res = res.add(amount.getCalculated());
		}
		return res;
	}

	protected BigDecimal getCharges() {
		BigDecimal res = new BigDecimal(0);
		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				res = res.add(currentCharge.getTotalAmount(this));
			}
		}
		return res;
	}

	protected BigDecimal getAllowances() {
		BigDecimal res = new BigDecimal(0);
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		if ((allowances != null) && (allowances.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentAllowance : allowances) {
				res = res.add(currentAllowance.getTotalAmount(this));
			}
		}
		return res;
	}

	protected BigDecimal getTotal() {
		BigDecimal res = new BigDecimal(0);
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			LineCalc lc = new LineCalc(currentItem);
			res = res.add(lc.getItemTotalGrossAmount());
		}
		return res;
	}

	protected BigDecimal getTaxBasis() {
		BigDecimal res = getTotal().add(getCharges()).subtract(getAllowances());
		return res;
	}

	/**
	 * which taxes have been used with which amounts in this transaction, empty for
	 * no taxes, or e.g. 19:190 and 7:14 if 1000 Eur were applicable to 19% VAT
	 * (=190 EUR VAT) and 200 EUR were applicable to 7% (=14 EUR VAT) 190 Eur
	 *
	 * @return which taxes have been used with which amounts in this invoice
	 */
	protected HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
		HashMap<BigDecimal, VATAmount> hm = new HashMap<>();

		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			BigDecimal percent = currentItem.getProduct().getVATPercent();
			LineCalc lc = new LineCalc(currentItem);
			VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(), lc.getItemTotalVATAmount(),
					trans.getDocumentCode());
			VATAmount current = hm.get(percent);
			if (current == null) {
				hm.put(percent, itemVATAmount);
			} else {
				hm.put(percent, current.add(itemVATAmount));
			}
		}


		IZUGFeRDAllowanceCharge[] charges = trans.getZFCharges();
		if ((charges != null) && (charges.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentCharge : charges) {
				VATAmount theAmount = hm.get(currentCharge.getTaxPercent());
				if (theAmount == null) {
					theAmount = new VATAmount(new BigDecimal(0), new BigDecimal(0), "S");
				}
				theAmount.setBasis(theAmount.getBasis().add(currentCharge.getTotalAmount(this)));
				BigDecimal factor = currentCharge.getTaxPercent().divide(new BigDecimal(100));
				theAmount.setCalculated(theAmount.getBasis().multiply(factor));
				hm.put(currentCharge.getTaxPercent(), theAmount);
			}
		}
		IZUGFeRDAllowanceCharge[] allowances = trans.getZFAllowances();
		if ((allowances != null) && (allowances.length > 0)) {
			for (IZUGFeRDAllowanceCharge currentAllowance : allowances) {
				VATAmount theAmount = hm.get(currentAllowance.getTaxPercent());
				if (theAmount == null) {
					theAmount = new VATAmount(new BigDecimal(0), new BigDecimal(0), "S");
				}
				theAmount.setBasis(theAmount.getBasis().subtract(currentAllowance.getTotalAmount(this)));
				BigDecimal factor = currentAllowance.getTaxPercent().divide(new BigDecimal(100));
				theAmount.setCalculated(theAmount.getBasis().multiply(factor));

				hm.put(currentAllowance.getTaxPercent(), theAmount);
			}
		}


		return hm;
	}

	@Override
	public Profile getProfile() {
		return profile;
	}

	protected String getTradePartyAsXML(IZUGFeRDExportableTradeParty party) {
		String xml = "";
		// According EN16931 either GlobalID or seller assigned ID might be present for BuyerTradeParty
		// and ShipToTradeParty, but not both. Prefer seller assigned ID for now.
		if (party.getID() != null) {
			xml += "	<ram:ID>" + XMLTools.encodeXML(party.getID()) + "</ram:ID>\n";
		} else if ((party.getGlobalIDScheme() != null) && (party.getGlobalID() != null)) {
			xml = xml + "           <ram:GlobalID schemeID=\"" + XMLTools.encodeXML(party.getGlobalIDScheme()) + "\">"
					+ XMLTools.encodeXML(party.getGlobalID()) + "</ram:GlobalID>\n";
		}
		xml += "	<ram:Name>" + XMLTools.encodeXML(party.getName()) + "</ram:Name>\n"; //$NON-NLS-2$

		if (party.getContact() != null) {
			xml = xml + "<ram:DefinedTradeContact>\n" + "     <ram:PersonName>" + XMLTools.encodeXML(party.getContact().getName())
					+ "</ram:PersonName>\n";
			if (party.getContact().getPhone() != null) {

				xml = xml + "     <ram:TelephoneUniversalCommunication>\n" + "        <ram:CompleteNumber>"
						+ XMLTools.encodeXML(party.getContact().getPhone()) + "</ram:CompleteNumber>\n"
						+ "     </ram:TelephoneUniversalCommunication>\n";
			}

			if (party.getContact().getFax() != null) {

				xml = xml + "     <ram:FaxUniversalCommunication>\n" + "        <ram:CompleteNumber>"
						+ XMLTools.encodeXML(party.getContact().getFax()) + "</ram:CompleteNumber>\n"
						+ "     </ram:FaxUniversalCommunication>\n";
			}
			if (party.getContact().getEMail() != null) {

				xml = xml + "     <ram:EmailURIUniversalCommunication>\n" + "        <ram:URIID>"
						+ XMLTools.encodeXML(party.getContact().getEMail()) + "</ram:URIID>\n"
						+ "     </ram:EmailURIUniversalCommunication>\n";
			}

			xml = xml + "  </ram:DefinedTradeContact>";

		}
		xml += "				<ram:PostalTradeAddress>\n"
				+ "					<ram:PostcodeCode>" + XMLTools.encodeXML(party.getZIP())
				+ "</ram:PostcodeCode>\n"
				+ "					<ram:LineOne>" + XMLTools.encodeXML(party.getStreet())
				+ "</ram:LineOne>\n";
		if (party.getAdditionalAddress() != null) {
			xml += "				<ram:LineTwo>" + XMLTools.encodeXML(party.getAdditionalAddress())
					+ "</ram:LineTwo>\n";
		}
		xml += "					<ram:CityName>" + XMLTools.encodeXML(party.getLocation())
				+ "</ram:CityName>\n"
				+ "					<ram:CountryID>" + XMLTools.encodeXML(party.getCountry())
				+ "</ram:CountryID>\n"
				+ "				</ram:PostalTradeAddress>\n";
		if (party.getVATID() != null) {
			xml += "				<ram:SpecifiedTaxRegistration>\n"
					+ "					<ram:ID schemeID=\"VA\">" + XMLTools.encodeXML(party.getVATID())
					+ "</ram:ID>\n"
					+ "				</ram:SpecifiedTaxRegistration>\n";
		}
		if (party.getTaxID() != null) {
			xml += "				<ram:SpecifiedTaxRegistration>\n"
					+ "					<ram:ID schemeID=\"FC\">" + XMLTools.encodeXML(party.getTaxID())
					+ "</ram:ID>\n"
					+ "				</ram:SpecifiedTaxRegistration>\n";

		}
		return xml;

	}


	protected String getAllowanceChargeStr(IZUGFeRDAllowanceCharge allowance, IAbsoluteValueProvider item) {
		String percentage = "";
		String chargeIndicator = "false";
		if (allowance.getPercent() != null) {
			percentage = "<ram:CalculationPercent>" + allowance.getPercent() + "</ram:CalculationPercent>";
			percentage += "<ram:BasisAmount>" + item.getValue() + "</ram:BasisAmount>";
		}
		if (allowance.isCharge()) {
			chargeIndicator = "true";
		}

		String allowanceChargeStr = "<ram:AppliedTradeAllowanceCharge><ram:ChargeIndicator><udt:Indicator>" + chargeIndicator + "</udt:Indicator></ram:ChargeIndicator>" + percentage + "<ram:ActualAmount>" + priceFormat(allowance.getTotalAmount(item)) + "</ram:ActualAmount></ram:AppliedTradeAllowanceCharge>";
		return allowanceChargeStr;
	}

	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;

		boolean hasDueDate = false;
		String taxCategoryCode = "";
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");

		String exemptionReason = "";

		if (trans.getPaymentTermDescription() != null) {
			paymentTermsDescription = trans.getPaymentTermDescription();
		}

		if (paymentTermsDescription == null) {
			paymentTermsDescription = "Zahlbar ohne Abzug bis " + germanDateFormat.format(trans.getDueDate());

		}

		String senderReg = "";
		if (trans.getOwnOrganisationFullPlaintextInfo() != null) {
			senderReg = "" + "<ram:IncludedNote>\n" + "		<ram:Content>\n"
					+ XMLTools.encodeXML(trans.getOwnOrganisationFullPlaintextInfo()) + "		</ram:Content>\n"
					+ "<ram:SubjectCode>REG</ram:SubjectCode>\n" + "</ram:IncludedNote>\n";

		}

		String rebateAgreement = "";
		if (trans.rebateAgreementExists()) {
			rebateAgreement = "<ram:IncludedNote>\n" + "		<ram:Content>"
					+ "Es bestehen Rabatt- und Bonusvereinbarungen.</ram:Content>\n"
					+ "<ram:SubjectCode>AAK</ram:SubjectCode>\n" + "</ram:IncludedNote>\n";
		}

		String subjectNote = "";
		if (trans.getSubjectNote() != null) {
			subjectNote = "<ram:IncludedNote>\n" + "		<ram:Content>"
					+ XMLTools.encodeXML(trans.getSubjectNote()) + "</ram:Content>\n"
					+ "</ram:IncludedNote>\n";
		}

		String typecode = "380";
		if (trans.getDocumentCode() != null) {
			typecode = trans.getDocumentCode();
		}
		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"

				+ "<rsm:CrossIndustryInvoice xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100\""
				// + "
				// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
				// ../Schema/ZUGFeRD1p0.xsd\""
				+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100\""
				+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100\">\n"
				+ "	<rsm:ExchangedDocumentContext>\n"
				// + "
				// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>\n"
				//
				+ "		<ram:GuidelineSpecifiedDocumentContextParameter>\n"
				+ "			<ram:ID>" + getProfile().getID() + "</ram:ID>\n"
				+ "		</ram:GuidelineSpecifiedDocumentContextParameter>\n"
				+ "	</rsm:ExchangedDocumentContext>\n"
				+ "	<rsm:ExchangedDocument>\n"
				+ "		<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>\n" //$NON-NLS-2$
				// + " <ram:Name>RECHNUNG</ram:Name>\n"
				// + "		<ram:TypeCode>380</ram:TypeCode>\n"
				+ "		<ram:TypeCode>" + typecode + "</ram:TypeCode>\n"
				+ "		<ram:IssueDateTime><udt:DateTimeString format=\"102\">"
				+ zugferdDateFormat.format(trans.getIssueDate()) + "</udt:DateTimeString></ram:IssueDateTime>\n" // date
				// format
				// was
				// 20130605
				+ subjectNote
				+ rebateAgreement
				+ senderReg

				+ "	</rsm:ExchangedDocument>\n"
				+ "	<rsm:SupplyChainTradeTransaction>\n";
		int lineID = 0;
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			taxCategoryCode = currentItem.getProduct().getTaxCategoryCode();
			if (currentItem.getProduct().getTaxExemptionReason() != null) {
				exemptionReason = "<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
			}

			LineCalc lc = new LineCalc(currentItem);
			xml = xml + "		<ram:IncludedSupplyChainTradeLineItem>\n" +
					"			<ram:AssociatedDocumentLineDocument>\n"
					+ "				<ram:LineID>" + lineID + "</ram:LineID>\n" //$NON-NLS-2$
					+ "			</ram:AssociatedDocumentLineDocument>\n"
					+ "			<ram:SpecifiedTradeProduct>\n";
			// + " <GlobalID schemeID=\"0160\">4012345001235</GlobalID>\n"
			if (currentItem.getProduct().getSellerAssignedID() != null) {
				xml = xml + "				<ram:SellerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getSellerAssignedID()) + "</ram:SellerAssignedID>\n";
			}
			if (currentItem.getProduct().getBuyerAssignedID() != null) {
				xml = xml + "				<ram:BuyerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getBuyerAssignedID()) + "</ram:BuyerAssignedID>\n";
			}
			String allowanceChargeStr = "";
			if (currentItem.getItemAllowances() != null && currentItem.getItemAllowances().length > 0) {
				for (IZUGFeRDAllowanceCharge allowance : currentItem.getItemAllowances()) {
					allowanceChargeStr += getAllowanceChargeStr(allowance, currentItem);
				}
			}
			if (currentItem.getItemCharges() != null && currentItem.getItemCharges().length > 0) {
				for (IZUGFeRDAllowanceCharge charge : currentItem.getItemCharges()) {
					allowanceChargeStr += getAllowanceChargeStr(charge, currentItem);

				}
			}


			xml = xml + "					<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>\n" //$NON-NLS-2$
					+ "				<ram:Description>" + XMLTools.encodeXML(currentItem.getProduct().getDescription())
					+ "</ram:Description>\n"
					+ "			</ram:SpecifiedTradeProduct>\n"

					+ "			<ram:SpecifiedLineTradeAgreement>\n"
					+ "				<ram:GrossPriceProductTradePrice>\n"
					+ "					<ram:ChargeAmount>" + priceFormat(lc.getPriceGross())
					+ "</ram:ChargeAmount>\n" //currencyID=\"EUR\"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>\n"
					+ allowanceChargeStr
					// + " <AppliedTradeAllowanceCharge>\n"
					// + " <ChargeIndicator>false</ChargeIndicator>\n"
					// + " <ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
					// + " <Reason>Rabatt</Reason>\n"
					// + " </AppliedTradeAllowanceCharge>\n"
					+ "				</ram:GrossPriceProductTradePrice>\n"
					+ "				<ram:NetPriceProductTradePrice>\n"
					+ "					<ram:ChargeAmount>" + priceFormat(lc.getPrice())
					+ "</ram:ChargeAmount>\n" // currencyID=\"EUR\"
					+ "					<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>\n"
					+ "				</ram:NetPriceProductTradePrice>\n"
					+ "			</ram:SpecifiedLineTradeAgreement>\n"

					+ "			<ram:SpecifiedLineTradeDelivery>\n"
					+ "				<ram:BilledQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">" //$NON-NLS-2$
					+ quantityFormat(currentItem.getQuantity()) + "</ram:BilledQuantity>\n"
					+ "			</ram:SpecifiedLineTradeDelivery>\n"
					+ "			<ram:SpecifiedLineTradeSettlement>\n"
					+ "				<ram:ApplicableTradeTax>\n"
					+ "					<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ exemptionReason
					+ "					<ram:CategoryCode>" + currentItem.getProduct().getTaxCategoryCode() + "</ram:CategoryCode>\n"

					+ "					<ram:RateApplicablePercent>"
					+ vatFormat(currentItem.getProduct().getVATPercent()) + "</ram:RateApplicablePercent>\n"
					+ "				</ram:ApplicableTradeTax>\n"
					+ "				<ram:SpecifiedTradeSettlementLineMonetarySummation>\n"
					+ "					<ram:LineTotalAmount>" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>\n" // currencyID=\"EUR\"
					+ "				</ram:SpecifiedTradeSettlementLineMonetarySummation>\n";
			if (currentItem.getAdditionalReferencedDocumentID() != null) {
				xml = xml + "			<ram:AdditionalReferencedDocument><ram:IssuerAssignedID>" + currentItem.getAdditionalReferencedDocumentID() + "</ram:IssuerAssignedID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>\n";

			}
			xml = xml + "			</ram:SpecifiedLineTradeSettlement>\n"
					+ "		</ram:IncludedSupplyChainTradeLineItem>\n";

		}

		xml = xml + "		<ram:ApplicableHeaderTradeAgreement>\n";
		if (trans.getReferenceNumber() != null) {
			xml = xml + "			<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>\n";

		}
		xml = xml + "			<ram:SellerTradeParty>\n"
				+ getTradePartyAsXML(trans.getSender())
				+ "			</ram:SellerTradeParty>\n"
				+ "			<ram:BuyerTradeParty>\n";
		// + " <ID>GE2020211</ID>\n"
		// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>\n"

		xml += getTradePartyAsXML(trans.getRecipient());
		xml += "			</ram:BuyerTradeParty>\n";

		if (trans.getBuyerOrderReferencedDocumentID() != null) {
			xml = xml + "   <ram:BuyerOrderReferencedDocument>\n"
					+ "       <ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>\n"
					+ "   </ram:BuyerOrderReferencedDocument>\n";
		}
		if (trans.getContractReferencedDocument() != null) {
			xml = xml + "   <ram:ContractReferencedDocument>\n"
					+ "       <ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(trans.getContractReferencedDocument()) + "</ram:IssuerAssignedID>\n"
					+ "    </ram:ContractReferencedDocument>\n";
		}

		// Additional Documents of XRechnung (Rechnungsbegruendende Unterlagen - BG-24 XRechnung)
		if (trans.getAdditionalReferencedDocuments() != null) {
			for (FileAttachment f : trans.getAdditionalReferencedDocuments()) {
				Encoder encoder = Base64.getEncoder();
//				final String documentContent = Base64.encodeBase64String(f.getData());f.
				final String documentContent = encoder.encodeToString(f.getData());
				xml = xml + "  <ram:AdditionalReferencedDocument>\n"
						+ "    <ram:IssuerAssignedID>" + f.getFilename() + "</ram:IssuerAssignedID>\n"
						+ "    <ram:TypeCode>916</ram:TypeCode>\n"
						+ "    <ram:Name>" + f.getDescription() + "</ram:Name>\n"
						+ "    <ram:AttachmentBinaryObject mimeCode=\"" + f.getMimetype() + "\"\n"
						+ "      filename=\"" + f.getFilename() + ">" + documentContent + "\n"
						+ "  </ram:AdditionalReferencedDocument>\n";
			}
		}

		xml = xml + "		</ram:ApplicableHeaderTradeAgreement>\n"
				+ "		<ram:ApplicableHeaderTradeDelivery>\n";
		if (this.trans.getDeliveryAddress() != null) {
			xml += "<ram:ShipToTradeParty>" +
					getTradePartyAsXML(this.trans.getDeliveryAddress()) +
					"</ram:ShipToTradeParty>";
		}

		xml += "			<ram:ActualDeliverySupplyChainEvent>\n"
				+ "				<ram:OccurrenceDateTime>";

		if (trans.getDeliveryDate() != null) {
			xml += "<udt:DateTimeString format=\"102\">" + zugferdDateFormat.format(trans.getDeliveryDate())
					+ "</udt:DateTimeString>";
		} else {
			throw new IllegalStateException("No delivery date provided");
		}
		xml += "</ram:OccurrenceDateTime>\n";
		xml += "			</ram:ActualDeliverySupplyChainEvent>\n"
				/*
				 * + "			<DeliveryNoteReferencedDocument>\n" +
				 * "				<IssueDateTime format=\"102\">20130603</IssueDateTime>\n" +
				 * "				<ID>2013-51112</ID>\n" +
				 * "			</DeliveryNoteReferencedDocument>\n"
				 */
				+ "		</ram:ApplicableHeaderTradeDelivery>\n" + "		<ram:ApplicableHeaderTradeSettlement>\n" //$NON-NLS-2$
				+ "			<ram:PaymentReference>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:PaymentReference>\n" //$NON-NLS-2$
				+ "			<ram:InvoiceCurrencyCode>" + trans.getCurrency() + "</ram:InvoiceCurrencyCode>\n";

		if (trans.getTradeSettlementPayment() != null) {
			for (IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if (payment != null) {
					hasDueDate = true;
					xml += payment.getSettlementXML();
				}
			}
		}
		if (trans.getTradeSettlement() != null) {
			for (IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
				if (payment != null) {
					if (payment instanceof IZUGFeRDTradeSettlementPayment) {
						hasDueDate = true;
					}
					xml += payment.getSettlementXML();
				}
			}
		}

		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				xml += "			<ram:ApplicableTradeTax>\n"
						+ "				<ram:CalculatedAmount>" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>\n" //currencyID=\"EUR\"
						+ "				<ram:TypeCode>VAT</ram:TypeCode>\n"
						+ exemptionReason
						+ "				<ram:BasisAmount>" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>\n" // currencyID=\"EUR\"
						+ "				<ram:CategoryCode>" + taxCategoryCode + "</ram:CategoryCode>\n"
						+ "				<ram:RateApplicablePercent>" + vatFormat(currentTaxPercent)
						+ "</ram:RateApplicablePercent>\n" + "			</ram:ApplicableTradeTax>\n"; //$NON-NLS-2$

			}
		}
		if ((trans.getOccurrencePeriodFrom() != null) || (trans.getOccurrencePeriodTo() != null)) {
			xml = xml + "<ram:BillingSpecifiedPeriod>";
			if (trans.getOccurrencePeriodFrom() != null) {
				xml = xml + "<ram:StartDateTime><udt:DateTimeString format='102'>" + zugferdDateFormat.format(trans.getOccurrencePeriodFrom()) + "</udt:DateTimeString></ram:StartDateTime>";
			}
			if (trans.getOccurrencePeriodTo() != null) {
				xml = xml + "<ram:EndDateTime><udt:DateTimeString format='102'>" + zugferdDateFormat.format(trans.getOccurrencePeriodTo()) + "</udt:DateTimeString></ram:EndDateTime>";
			}
			xml = xml + "</ram:BillingSpecifiedPeriod>";


		}

		if ((trans.getZFCharges() != null) && (trans.getZFCharges().length > 0)) {
			xml = xml + "	 <ram:SpecifiedTradeAllowanceCharge>\n" +
					"        <ram:ChargeIndicator>\n" +
					"          <udt:Indicator>true</udt:Indicator>\n" +
					"        </ram:ChargeIndicator>\n" +
					"        <ram:ActualAmount>" + currencyFormat(getCharges()) + "</ram:ActualAmount>\n" +
					"        <ram:Reason>Charge</ram:Reason>\n" +
					"        <ram:CategoryTradeTax>\n" +
					"          <ram:TypeCode>VAT</ram:TypeCode>\n" +
					"          <ram:CategoryCode>S</ram:CategoryCode>\n" +
					"          <ram:RateApplicablePercent>19.00</ram:RateApplicablePercent>\n" +
					"        </ram:CategoryTradeTax>\n" +
					"      </ram:SpecifiedTradeAllowanceCharge>	\n";


		}

		if ((trans.getZFAllowances() != null) && (trans.getZFAllowances().length > 0)) {
			xml = xml + "	 <ram:SpecifiedTradeAllowanceCharge>\n" +
					"        <ram:ChargeIndicator>\n" +
					"          <udt:Indicator>false</udt:Indicator>\n" +
					"        </ram:ChargeIndicator>\n" +
					"        <ram:ActualAmount>" + currencyFormat(getAllowances()) + "</ram:ActualAmount>\n" +
					"        <ram:Reason>Allowance</ram:Reason>\n" +
					"        <ram:CategoryTradeTax>\n" +
					"          <ram:TypeCode>VAT</ram:TypeCode>\n" +
					"          <ram:CategoryCode>S</ram:CategoryCode>\n" +
					"          <ram:RateApplicablePercent>19.00</ram:RateApplicablePercent>\n" +
					"        </ram:CategoryTradeTax>\n" +
					"      </ram:SpecifiedTradeAllowanceCharge>	\n";

		}


		if (trans.getPaymentTerms() == null) {
			xml = xml + "			<ram:SpecifiedTradePaymentTerms>\n"
					+ "				<ram:Description>" + paymentTermsDescription + "</ram:Description>\n";

			if (trans.getTradeSettlement() != null) {
				for (IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if ((payment != null) && (payment instanceof IZUGFeRDTradeSettlementDebit)) {
						xml += payment.getPaymentXML();
					}
				}
			}

			if (hasDueDate && (trans.getDueDate() != null)) {
				xml = xml + "				<ram:DueDateDateTime><udt:DateTimeString format=\"102\">" // $NON-NLS-2$
						+ zugferdDateFormat.format(trans.getDueDate())
						+ "</udt:DateTimeString></ram:DueDateDateTime>\n";// 20130704

			}
			xml = xml + "			</ram:SpecifiedTradePaymentTerms>\n";
		} else {
			xml = xml + buildPaymentTermsXml();
		}


		String allowanceTotalLine = "<ram:AllowanceTotalAmount>" + currencyFormat(getAllowances()) + "</ram:AllowanceTotalAmount>";

		String chargesTotalLine = "<ram:ChargeTotalAmount>" + currencyFormat(getCharges()) + "</ram:ChargeTotalAmount>";

		xml = xml + "			<ram:SpecifiedTradeSettlementHeaderMonetarySummation>\n"
				+ "				<ram:LineTotalAmount>" + currencyFormat(getTotal()) + "</ram:LineTotalAmount>\n" //$NON-NLS-2$
				+ chargesTotalLine
				+ allowanceTotalLine
				+ "				<ram:TaxBasisTotalAmount>" + currencyFormat(getTaxBasis()) + "</ram:TaxBasisTotalAmount>\n" //$NON-NLS-2$
				// //
				// currencyID=\"EUR\"
				+ "				<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(getTotalGross().subtract(getTaxBasis())) + "</ram:TaxTotalAmount>\n"
				+ "				<ram:GrandTotalAmount>" + currencyFormat(getTotalGross()) + "</ram:GrandTotalAmount>\n" //$NON-NLS-2$
				// //
				// currencyID=\"EUR\"
				+ "             <ram:TotalPrepaidAmount>" + currencyFormat(getTotalPrepaid()) + "</ram:TotalPrepaidAmount>\n"
				+ "				<ram:DuePayableAmount>" + currencyFormat(getTotalGross().subtract(getTotalPrepaid())) + "</ram:DuePayableAmount>\n" //$NON-NLS-2$
				// //
				// currencyID=\"EUR\"
				+ "			</ram:SpecifiedTradeSettlementHeaderMonetarySummation>\n"
				+ "		</ram:ApplicableHeaderTradeSettlement>\n";
		// + " <IncludedSupplyChainTradeLineItem>\n"
		// + " <AssociatedDocumentLineDocument>\n"
		// + " <IncludedNote>\n"
		// + " <Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + " </IncludedNote>\n"
		// + " </AssociatedDocumentLineDocument>\n"
		// + " </IncludedSupplyChainTradeLineItem>\n";

		xml = xml + "	</rsm:SupplyChainTradeTransaction>\n"
				+ "</rsm:CrossIndustryInvoice>";

		byte[] zugferdRaw;
		try {
			zugferdRaw = xml.getBytes("UTF-8");

			if ((zugferdRaw[0] == (byte) 0xEF) && (zugferdRaw[1] == (byte) 0xBB) && (zugferdRaw[2] == (byte) 0xBF)) {
				// I don't like BOMs, lets remove it
				zugferdData = new byte[zugferdRaw.length - 3];
				System.arraycopy(zugferdRaw, 3, zugferdData, 0, zugferdRaw.length - 3);
			} else {
				zugferdData = zugferdRaw;
			}
		} catch (UnsupportedEncodingException e) {
			Logger.getLogger(ZUGFeRD2PullProvider.class.getName()).log(Level.SEVERE, null, e);
		} // $NON-NLS-1$
	}

	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

	private String buildPaymentTermsXml() {
		String paymentTermsXml = "<ram:SpecifiedTradePaymentTerms>";

		IZUGFeRDPaymentTerms paymentTerms = trans.getPaymentTerms();
		IZUGFeRDPaymentDiscountTerms discountTerms = paymentTerms.getDiscountTerms();
		Date dueDate = paymentTerms.getDueDate();
		if (dueDate != null && discountTerms != null && discountTerms.getBaseDate() != null) {
			throw new IllegalStateException(
					"if paymentTerms.dueDate is specified, paymentTerms.discountTerms.baseDate has not to be specified");
		}
		paymentTermsXml += "<ram:Description>" + paymentTerms.getDescription() + "</ram:Description>";
		if (dueDate != null) {
			paymentTermsXml += "<ram:DueDateDateTime>";
			paymentTermsXml += "<udt:DateTimeString format=\"102\">"
					+ zugferdDateFormat.format(dueDate) + "</udt:DateTimeString>";
			paymentTermsXml += "</ram:DueDateDateTime>";
		}

		if (discountTerms != null) {
			paymentTermsXml += "<ram:ApplicableTradePaymentDiscountTerms>";
			String currency = trans.getCurrency();
			String basisAmount = currencyFormat(getTotalGross());
			paymentTermsXml += "<ram:BasisAmount currencyID=\"" + currency + "\">" + basisAmount + "</ram:BasisAmount>";
			paymentTermsXml += "<ram:CalculationPercent>" + discountTerms.getCalculationPercentage().toString()
					+ "</ram:CalculationPercent>";

			if (discountTerms.getBaseDate() != null) {
				Date baseDate = discountTerms.getBaseDate();
				paymentTermsXml += "<ram:BasisDateTime>";
				paymentTermsXml += "<udt:DateTimeString format=\"102\">" + zugferdDateFormat.format(baseDate) + "</udt:DateTimeString>";
				paymentTermsXml += "</ram:BasisDateTime>";

				paymentTermsXml += "<ram:BasisPeriodMeasure unitCode=\"" + discountTerms.getBasePeriodUnitCode() + "\">"
						+ discountTerms.getBasePeriodMeasure() + "</ram:BasisPeriodMeasure>";
			}

			paymentTermsXml += "</ram:ApplicableTradePaymentDiscountTerms>";
		}

		paymentTermsXml += "</ram:SpecifiedTradePaymentTerms>";
		return paymentTermsXml;
	}

	@Override
	public BigDecimal getValue() {
		return getTotal();
	}
}
