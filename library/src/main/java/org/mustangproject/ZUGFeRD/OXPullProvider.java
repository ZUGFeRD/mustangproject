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
import static org.mustangproject.ZUGFeRD.model.DocumentCodeTypeConstants.CORRECTEDINVOICE;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.Map;

import org.mustangproject.EStandard;
import org.mustangproject.FileAttachment;
import org.mustangproject.XMLTools;

public class OXPullProvider extends ZUGFeRD2PullProvider {

	protected IExportableTransaction trans;
	protected TransactionCalculator calc;
	private String paymentTermsDescription;
	protected Profile profile = Profiles.getByName(EStandard.orderx,"basic", 1);


	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;
		this.calc = new TransactionCalculator(trans);

		boolean hasDueDate = false;
		final SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");

		final String exemptionReason = "";

		if (trans.getPaymentTermDescription() != null) {
      paymentTermsDescription = XMLTools.encodeXML(trans.getPaymentTermDescription());
		}

		if ((paymentTermsDescription == null) && (trans.getDocumentCode() != CORRECTEDINVOICE)/* && (trans.getDocumentCode() != DocumentCodeTypeConstants.CREDITNOTE)*/) {
			paymentTermsDescription = "Zahlbar ohne Abzug bis " + germanDateFormat.format(trans.getDueDate());

		}

		final String typecode = "220";
		/*if (trans.getDocumentCode() != null) {
			typecode = trans.getDocumentCode();
		}*/
	
		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

				+ "<rsm:SCRDMCCBDACIOMessageStructure\n" +
				"xmlns:rsm=\"urn:un:unece:uncefact:data:SCRDMCCBDACIOMessageStructure:100\"\n" +
				"xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:128\"\n" +
				"xmlns:qdt=\"urn:un:unece:uncefact:data:standard:QualifiedDataType:128\"\n" +
				"xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:128\"\n" +
				"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
				// + "
				// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
				// ../Schema/ZUGFeRD1p0.xsd\""
				+ "<rsm:ExchangedDocumentContext>"
				// + "
				// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>\n"
				//
				+ "<ram:BusinessProcessSpecifiedDocumentContextParameter>"
				+ "<ram:ID>A1</ram:ID>"
				+ "</ram:BusinessProcessSpecifiedDocumentContextParameter>"
				+ "<ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "<ram:ID>" + getProfile().getID() + "</ram:ID>"
				+ "</ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "</rsm:ExchangedDocumentContext>"
				+ "<rsm:ExchangedDocument>"
				+ "<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>"
				// + " <ram:Name>RECHNUNG</ram:Name>"
				// + "<ram:TypeCode>380</ram:TypeCode>"
				+ "<ram:TypeCode>" + typecode + "</ram:TypeCode>"
				+ "<ram:IssueDateTime>"
				+ DATE.udtFormat(trans.getIssueDate()) + "</ram:IssueDateTime>" // date
				+ buildNotes(trans)

				+ "</rsm:ExchangedDocument>"
				+ "<rsm:SupplyChainTradeTransaction>";
		int lineID = 0;
		for (final IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			if (currentItem.getProduct().getTaxExemptionReason() != null) {
			//	exemptionReason = "<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
			}
    
			final LineCalculator lc = new LineCalculator(currentItem);
			xml += "<ram:IncludedSupplyChainTradeLineItem>" +
					"<ram:AssociatedDocumentLineDocument>"
					+ "<ram:LineID>" + lineID + "</ram:LineID>"
					+ buildItemNotes(currentItem)
					+ "</ram:AssociatedDocumentLineDocument>"

					+ "<ram:SpecifiedTradeProduct>";
			// + " <GlobalID schemeID=\"0160\">4012345001235</GlobalID>"
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


			xml += "<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>"
					+ "<ram:Description>" + XMLTools.encodeXML(currentItem.getProduct().getDescription())
					+ "</ram:Description>"
					+ "</ram:SpecifiedTradeProduct>"

					+ "<ram:SpecifiedLineTradeAgreement>";
		/*	if (currentItem.getReferencedDocuments() != null) {
				for (IReferencedDocument currentReferencedDocument : currentItem.getReferencedDocuments()) {
					xml += "<ram:AdditionalReferencedDocument>\n" +
							"<ram:IssuerAssignedID>" + XMLTools.encodeXML(currentReferencedDocument.getIssuerAssignedID()) + "</ram:IssuerAssignedID>\n" +
							"<ram:TypeCode>" + XMLTools.encodeXML(currentReferencedDocument.getTypeCode()) + "</ram:TypeCode>\n" +
							"<ram:ReferenceTypeCode>" + XMLTools.encodeXML(currentReferencedDocument.getReferenceTypeCode()) + "</ram:ReferenceTypeCode>\n" +
							"</ram:AdditionalReferencedDocument>\n";


				}

			}*/
			if (currentItem.getBuyerOrderReferencedDocumentLineID() != null) {
				xml += "<ram:BuyerOrderReferencedDocument> \n"
						+ "<ram:LineID>" + XMLTools.encodeXML(currentItem.getBuyerOrderReferencedDocumentLineID()) + "</ram:LineID>"
						+ "</ram:BuyerOrderReferencedDocument>";

			}
			xml += "<ram:GrossPriceProductTradePrice>"
					+ "<ram:ChargeAmount>" + priceFormat(lc.getPriceGross())
					+ "</ram:ChargeAmount>" //currencyID=\"EUR\"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
					+ allowanceChargeStr
					// + " <AppliedTradeAllowanceCharge>\n"
					// + " <ChargeIndicator>false</ChargeIndicator>\n"
					// + " <ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
					// + " <Reason>Rabatt</Reason>\n"
					// + " </AppliedTradeAllowanceCharge>\n"
					+ "</ram:GrossPriceProductTradePrice>"
					+ "<ram:NetPriceProductTradePrice>"
					+ "<ram:ChargeAmount>" + priceFormat(lc.getPrice())
					+ "</ram:ChargeAmount>" // currencyID=\"EUR\"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
					+ "</ram:NetPriceProductTradePrice>"
					+ "</ram:SpecifiedLineTradeAgreement>"

					+ "<ram:SpecifiedLineTradeDelivery>"
					+ "<ram:RequestedQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">"
					+ quantityFormat(currentItem.getQuantity()) + "</ram:RequestedQuantity>"
					+ "</ram:SpecifiedLineTradeDelivery>"
					+ "<ram:SpecifiedLineTradeSettlement>"
					+ "<ram:ApplicableTradeTax>"
					+ "<ram:TypeCode>VAT</ram:TypeCode>"
					+ exemptionReason
					+ "<ram:CategoryCode>" + currentItem.getProduct().getTaxCategoryCode() + "</ram:CategoryCode>"

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

			xml += "<ram:SpecifiedTradeSettlementLineMonetarySummation>"
					+ "<ram:LineTotalAmount>" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>" // currencyID=\"EUR\"
					+ "</ram:SpecifiedTradeSettlementLineMonetarySummation>";
		/*	if (currentItem.getAdditionalReferencedDocumentID() != null) {
				xml += "<ram:AdditionalReferencedDocument><ram:IssuerAssignedID>" + currentItem.getAdditionalReferencedDocumentID() + "</ram:IssuerAssignedID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>";

			}*/
			xml += "</ram:SpecifiedLineTradeSettlement>"
					+ "</ram:IncludedSupplyChainTradeLineItem>";

		}

		xml += "<ram:ApplicableHeaderTradeAgreement>";
		if (trans.getReferenceNumber() != null) {
			xml += "<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>";

		}
		xml += "<ram:SellerTradeParty>"
				+ getTradePartyAsXML(trans.getSender(), true, false)
				+ "</ram:SellerTradeParty>"
				+ "<ram:BuyerTradeParty>";
		// + " <ID>GE2020211</ID>"
		// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>"

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
				xml += "<ram:Name >" + XMLTools.encodeXML(trans.getSpecifiedProcuringProjectName()) + "</ram:Name>";
			}
			xml += "</ram:SpecifiedProcuringProject>";
		}
		xml += "</ram:ApplicableHeaderTradeAgreement>"
				+ "<ram:ApplicableHeaderTradeDelivery>";
		IZUGFeRDExportableTradeParty deliveryAddress=this.trans.getDeliveryAddress();
		if (deliveryAddress == null) {
			deliveryAddress = this.trans.getRecipient();
		}
		xml += "<ram:ShipToTradeParty>" +
				getTradePartyAsXML(deliveryAddress, false, true) +
				"</ram:ShipToTradeParty>";
/*
		xml += "<ram:ActualDeliverySupplyChainEvent>"
				+ "<ram:OccurrenceDateTime>";

		if (trans.getDeliveryDate() != null) {
			xml += DATE.udtFormat(trans.getDeliveryDate());
		} else {
			throw new IllegalStateException("No delivery date provided");
		}
		xml += "</ram:OccurrenceDateTime>\n";
		xml += "</ram:ActualDeliverySupplyChainEvent>\n"

 */
				/*
				 * + "<DeliveryNoteReferencedDocument>\n" +
				 * "<IssueDateTime format=\"102\">20130603</IssueDateTime>\n" +
				 * "<ID>2013-51112</ID>\n" +
				 * "</DeliveryNoteReferencedDocument>\n"
				 */
				xml+= "</ram:ApplicableHeaderTradeDelivery>\n<ram:ApplicableHeaderTradeSettlement>"
	//			+ "<ram:PaymentReference>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:PaymentReference>"
				+ "<ram:OrderCurrencyCode>" + trans.getCurrency() + "</ram:OrderCurrencyCode>";

		if (trans.getTradeSettlementPayment() != null) {
			for (final IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if (payment != null) {
					hasDueDate = true;
				//	xml += payment.getSettlementXML();
				}
			}
		}
		if (trans.getTradeSettlement() != null) {
			for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
				if (payment != null) {
					if (payment instanceof IZUGFeRDTradeSettlementPayment) {
						hasDueDate = true;
					}
				//	xml += payment.getSettlementXML();
				}
			}
		}
		if (trans.getDocumentCode() != null) {
  		if ((trans.getDocumentCode().equals(CORRECTEDINVOICE))/*||(trans.getDocumentCode().equals (DocumentCodeTypeConstants.CREDITNOTE))*/) {
  			hasDueDate = false;
  		}
		}

		final Map<BigDecimal, VATAmount> VATPercentAmountMap = calc.getVATPercentAmountMap();
		for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			final VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
			  /*final String amountCategoryCode = amount.getCategoryCode();
				final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(amountCategoryCode);
				xml += "<ram:ApplicableTradeTax>\n"
						+ "<ram:CalculatedAmount>" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>\n" //currencyID=\"EUR\"
						+ "<ram:TypeCode>VAT</ram:TypeCode>\n"
						+ (displayExemptionReason ? exemptionReason : "")
						+ "<ram:BasisAmount>" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>\n" // currencyID=\"EUR\"
						+ "<ram:CategoryCode>" + amountCategoryCode + "</ram:CategoryCode>\n"
						+ "<ram:RateApplicablePercent>"
						+ vatFormat(currentTaxPercent) + "</ram:RateApplicablePercent>\n" + "</ram:ApplicableTradeTax>\n";

	 */
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

			for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
				if (calc.getChargesForPercent(currentTaxPercent).compareTo(BigDecimal.ZERO) != 0) {


					xml += " <ram:SpecifiedTradeAllowanceCharge>" +
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

		if ((trans.getZFAllowances() != null) && (trans.getZFAllowances().length > 0)) {
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
							"</ram:SpecifiedTradeAllowanceCharge>	\n";
				}
			}
		}


		if ((trans.getPaymentTerms() == null) && ((paymentTermsDescription != null) || (trans.getTradeSettlement() != null) || (hasDueDate))) {
			xml += "<ram:SpecifiedTradePaymentTerms>";

			if (paymentTermsDescription != null) {
				xml += "<ram:Description>" + paymentTermsDescription + "</ram:Description>";
			}

			if (trans.getTradeSettlement() != null) {
				for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if ((payment != null) && (payment instanceof IZUGFeRDTradeSettlementDebit)) {
		//not in order-x				xml += payment.getPaymentXML();
					}
				}
			}

			xml += "</ram:SpecifiedTradePaymentTerms>";
		} else {
			xml += buildPaymentTermsXml();
		}


		final String allowanceTotalLine = "<ram:AllowanceTotalAmount>" + currencyFormat(calc.getAllowancesForPercent(null)) + "</ram:AllowanceTotalAmount>";

		final String chargesTotalLine = "<ram:ChargeTotalAmount>" + currencyFormat(calc.getChargesForPercent(null)) + "</ram:ChargeTotalAmount>";

		xml += "<ram:SpecifiedTradeSettlementHeaderMonetarySummation>"
				+ "<ram:LineTotalAmount>" + currencyFormat(calc.getTotal()) + "</ram:LineTotalAmount>"
				+ chargesTotalLine
				+ allowanceTotalLine
				+ "<ram:TaxBasisTotalAmount>" + currencyFormat(calc.getTaxBasis()) + "</ram:TaxBasisTotalAmount>"
				// //
				// currencyID=\"EUR\"
				+ "<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(calc.getGrandTotal().subtract(calc.getTaxBasis())) + "</ram:TaxTotalAmount>"
				+ "<ram:GrandTotalAmount>" + currencyFormat(calc.getGrandTotal()) + "</ram:GrandTotalAmount>"
				// //
				// currencyID=\"EUR\"
				//+ "<ram:TotalPrepaidAmount>" + currencyFormat(calc.getTotalPrepaid()) + "</ram:TotalPrepaidAmount>"
				//+ "<ram:DuePayableAmount>" + currencyFormat(calc.getGrandTotal().subtract(calc.getTotalPrepaid())) + "</ram:DuePayableAmount>"
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

		xml += "</ram:ApplicableHeaderTradeSettlement>";
		// + " <IncludedSupplyChainTradeLineItem>"
		// + " <AssociatedDocumentLineDocument>"
		// + " <IncludedNote>"
		// + " <Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + " </IncludedNote>\n"
		// + " </AssociatedDocumentLineDocument>\n"
		// + " </IncludedSupplyChainTradeLineItem>\n";

		xml += "</rsm:SupplyChainTradeTransaction>"
				+ "</rsm:SCRDMCCBDACIOMessageStructure>";

		final byte[] zugferdRaw;
		zugferdRaw = xml.getBytes(StandardCharsets.UTF_8);

		zugferdData = XMLTools.removeBOM(zugferdRaw);
	}


	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

	@Override
	public Profile getProfile() {
		return profile;
	}

	private String buildPaymentTermsXml() {

		final IZUGFeRDPaymentTerms[] paymentTerms = trans.getPaymentTerms();

		String paymentTermsXml = "";
		if (paymentTerms == null || paymentTerms.length == 0) {
			return "";
		}

		for (IZUGFeRDPaymentTerms pt : paymentTerms)
		{
			paymentTermsXml += "<ram:SpecifiedTradePaymentTerms>";

			final IZUGFeRDPaymentDiscountTerms discountTerms = pt.getDiscountTerms();
			paymentTermsXml += "<ram:Description>" + pt.getDescription() + "</ram:Description>";
			if (discountTerms != null)
			{
				paymentTermsXml += "<ram:ApplicableTradePaymentDiscountTerms>";
				final String currency = trans.getCurrency();
				final String basisAmount = currencyFormat(calc.getGrandTotal());
				paymentTermsXml += "<ram:BasisAmount currencyID=\"" + currency + "\">" + basisAmount + "</ram:BasisAmount>";
				paymentTermsXml += "<ram:CalculationPercent>" + discountTerms.getCalculationPercentage().toString()
					+ "</ram:CalculationPercent>";

				if (discountTerms.getBaseDate() != null)
				{
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
