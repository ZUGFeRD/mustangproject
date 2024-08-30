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
import java.util.Date;
import java.util.HashMap;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.XMLTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ZUGFeRD1PullProvider extends ZUGFeRD2PullProvider {
  private static final Logger LOGGER = LoggerFactory.getLogger (ZUGFeRD1PullProvider.class);

	//// MAIN CLASS

	protected byte[] zugferdData;
	private String paymentTermsDescription;
	protected Profile profile = Profiles.getByName("COMFORT", 1);


	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 */
	@Override
	public void setTest() {
	}

	@Override
  protected String vatFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 2);
	}

	@Override
  protected String currencyFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 2);
	}

	@Override
  protected String priceFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 4);
	}

	@Override
  protected String quantityFormat(BigDecimal value) {
		return XMLTools.nDigitFormat(value, 4);
	}


	@Override
	public Profile getProfile() {
		return profile;
	}

	@Override
	public byte[] getXML() {

		byte[] res = zugferdData;

		final StringWriter sw = new StringWriter();
		Document document = null;
		try {
			document = DocumentHelper.parseText(new String(zugferdData));
		} catch (final DocumentException e1) {
			LOGGER.error ("Failed to parse ZUGFeRD data", e1);
		}
		try {
			final OutputFormat format = OutputFormat.createPrettyPrint();
			format.setTrimText(false);
			final XMLWriter writer = new XMLWriter(sw, format);
			writer.write(document);
			res = sw.toString().getBytes(StandardCharsets.UTF_8);

		} catch (final IOException e) {
      LOGGER.error ("Failed to write ZUGFeRD data", e);
		}

		return res;

	}


	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;
		this.calc = new TransactionCalculator(trans);

		boolean hasDueDate = false;
		final SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");
		String exemptionReason = "";

		if (trans.getPaymentTermDescription() != null) {
			paymentTermsDescription = trans.getPaymentTermDescription();
		}

		if (paymentTermsDescription == null) {
			paymentTermsDescription = "Zahlbar ohne Abzug bis " + germanDateFormat.format(trans.getDueDate());

		}

		String senderReg = "";
		if (trans.getOwnOrganisationFullPlaintextInfo() != null) {
			senderReg = "<ram:IncludedNote><ram:Content>"
					+ XMLTools.encodeXML(trans.getOwnOrganisationFullPlaintextInfo()) + "</ram:Content>"
					+ "<ram:SubjectCode>REG</ram:SubjectCode></ram:IncludedNote>";

		}

		String rebateAgreement = "";
		if (trans.rebateAgreementExists()) {
			rebateAgreement = "<ram:IncludedNote><ram:Content>"
					+ "Es bestehen Rabatt- und Bonusvereinbarungen.</ram:Content>"
					+ "<ram:SubjectCode>AAK</ram:SubjectCode></ram:IncludedNote>";
		}

		String subjectNote = "";
		if (trans.getSubjectNote() != null) {
			subjectNote = "<ram:IncludedNote><ram:Content>"
					+ XMLTools.encodeXML(trans.getSubjectNote()) + "</ram:Content>"
					+ "</ram:IncludedNote>";
		}
		String typecode = "380";
		if (trans.getDocumentCode() != null) {
			typecode = trans.getDocumentCode();
		}
		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

				+ "<rsm:CrossIndustryDocument xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:ferd:CrossIndustryDocument:invoice:1p0\""
				// + "
				// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
				// ../Schema/ZUGFeRD1p0.xsd\""
				+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12\""
				+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15\">"
				+ "<!-- generated by: mustangproject.org v" + ZUGFeRD1PullProvider.class.getPackage().getImplementationVersion() + "-->"
				+ "<rsm:SpecifiedExchangedDocumentContext>"
				// + "
				// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>"
				//
				+ "<ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "<ram:ID>" + getProfile().getID() + "</ram:ID>"
				+ "</ram:GuidelineSpecifiedDocumentContextParameter>"
				+ "</rsm:SpecifiedExchangedDocumentContext>"
				+ "<rsm:HeaderExchangedDocument>"
				+ "<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>"
				+ "<ram:Name>RECHNUNG</ram:Name>"
				+ "<ram:TypeCode>" + typecode + "</ram:TypeCode>"
				+ "<ram:IssueDateTime>"
				+ DATE.udtFormat(trans.getIssueDate()) + "</ram:IssueDateTime>" // date
				// format
				// was
				// 20130605
				+ subjectNote
				+ rebateAgreement
				+ senderReg

				+ "</rsm:HeaderExchangedDocument>"
				+ "<rsm:SpecifiedSupplyChainTradeTransaction>";
		xml += "<ram:ApplicableSupplyChainTradeAgreement>";
		if (trans.getReferenceNumber() != null) {
			xml += "<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>";

		}
		xml += "<ram:SellerTradeParty>";
		xml += getTradePartyAsXML(trans.getSender(), true, false);
		xml += "</ram:SellerTradeParty>"
				+ "<ram:BuyerTradeParty>";
		// + " <ID>GE2020211</ID>"
		// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>"

		xml += getTradePartyAsXML(trans.getRecipient(), false, false);
		if ((trans.getOwnVATID() != null) && (trans.getOwnOrganisationName() != null)) {
			xml += "<ram:SpecifiedTaxRegistration><ram:ID schemeID=\"VA\">"
					+ XMLTools.encodeXML(trans.getOwnVATID()) + "</ram:ID>"
					+ "</ram:SpecifiedTaxRegistration>";
		}

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
		xml += "</ram:ApplicableSupplyChainTradeAgreement>"
				+ "<ram:ApplicableSupplyChainTradeDelivery>";
		if (this.trans.getDeliveryAddress() != null) {
			xml += "<ram:ShipToTradeParty>" +
					getTradePartyAsXML(this.trans.getDeliveryAddress(), false, true) +
					"</ram:ShipToTradeParty>";
		}

		xml += "<ram:ActualDeliverySupplyChainEvent>"
				+ "<ram:OccurrenceDateTime>";

		if (trans.getDeliveryDate() != null) {
			xml += DATE.udtFormat(trans.getDeliveryDate());
		} else {
			throw new IllegalStateException("No delivery date provided");
		}
		xml += "</ram:OccurrenceDateTime>";
		xml += "</ram:ActualDeliverySupplyChainEvent>"
				/*
				 * + "<DeliveryNoteReferencedDocument>" +
				 * "<IssueDateTime format=\"102\">20130603</IssueDateTime>" +
				 * "<ID>2013-51112</ID>" +
				 * "</DeliveryNoteReferencedDocument>"
				 */
				+ "</ram:ApplicableSupplyChainTradeDelivery><ram:ApplicableSupplyChainTradeSettlement>"
				+ "<ram:PaymentReference>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:PaymentReference>"
				+ "<ram:InvoiceCurrencyCode>" + trans.getCurrency() + "</ram:InvoiceCurrencyCode>";

		if (trans.getTradeSettlementPayment() != null) {
			for (final IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if (payment != null) {
					hasDueDate = true;
					xml += payment.getSettlementXML();
				}
			}
		}
		if (trans.getTradeSettlement() != null) {
			for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
				if (payment != null) {
					if (payment instanceof IZUGFeRDTradeSettlementPayment) {
						hasDueDate = true;
					}
					xml += payment.getSettlementXML();
				}
			}
		}

		final HashMap<BigDecimal, VATAmount> VATPercentAmountMap = calc.getVATPercentAmountMap();
		for (final BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			final VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				final String amountCategoryCode = amount.getCategoryCode();
				final String amountDueDateTypeCode = amount.getDueDateTypeCode();
				final boolean displayExemptionReason = CATEGORY_CODES_WITH_EXEMPTION_REASON.contains(amountCategoryCode);
				xml += "<ram:ApplicableTradeTax>"
						+ "<ram:CalculatedAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>" //currencyID=\"EUR\"
						+ "<ram:TypeCode>VAT</ram:TypeCode>"
						+ (displayExemptionReason ? exemptionReason : "")
						+ "<ram:BasisAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>" // currencyID=\"EUR\"
						+ "<ram:CategoryCode>" + amount.getCategoryCode() + "</ram:CategoryCode>"
						+ (amountDueDateTypeCode != null ? "<ram:DueDateTypeCode>" + amountDueDateTypeCode + "</ram:DueDateTypeCode>" : "")
						+ "<ram:ApplicablePercent>" + vatFormat(currentTaxPercent)
						+ "</ram:ApplicablePercent></ram:ApplicableTradeTax>";
			}
		}

		if (trans.getPaymentTerms() == null) {
			xml += "<ram:SpecifiedTradePaymentTerms>"
					+ "<ram:Description>" + paymentTermsDescription + "</ram:Description>";

			if (trans.getTradeSettlement() != null) {
				for (final IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
					if ((payment != null) && (payment instanceof IZUGFeRDTradeSettlementDebit)) {
						xml += payment.getPaymentXML();
					}
				}
			}

			if (hasDueDate && (trans.getDueDate() != null)) {
				xml += "<ram:DueDateDateTime>" // $NON-NLS-2$
						+ DATE.udtFormat(trans.getDueDate())
						+ "</ram:DueDateDateTime>";// 20130704

			}
			xml += "</ram:SpecifiedTradePaymentTerms>";
		} else {
			xml += buildPaymentTermsXml();
		}

		xml += "<ram:SpecifiedTradeSettlementMonetarySummation>"
				+ "<ram:LineTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotal()) + "</ram:LineTotalAmount>"
				// currencyID=\"EUR\"
				+ "<ram:ChargeTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(calc.getChargeTotal()) + "</ram:ChargeTotalAmount>" // currencyID=\"EUR\"
				+ "<ram:AllowanceTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(calc.getAllowanceTotal()) + "</ram:AllowanceTotalAmount>" //
				// currencyID=\"EUR\"
				// + " <ChargeTotalAmount currencyID=\"EUR\">5.80</ChargeTotalAmount>"
				// + " <AllowanceTotalAmount currencyID=\"EUR\">14.73</AllowanceTotalAmount>"
				+ "<ram:TaxBasisTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(calc.getTaxBasis()) + "</ram:TaxBasisTotalAmount>"
				// //
				// currencyID=\"EUR\"
				+ "<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(calc.getGrandTotal().subtract(calc.getTaxBasis())) + "</ram:TaxTotalAmount>"
				+ "<ram:GrandTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getGrandTotal()) + "</ram:GrandTotalAmount>"
				// //
				// currencyID=\"EUR\"
				+ "<ram:TotalPrepaidAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotalPrepaid()) + "</ram:TotalPrepaidAmount>"
				+ "<ram:DuePayableAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getGrandTotal().subtract(calc.getTotalPrepaid())) + "</ram:DuePayableAmount>"
				// //
				// currencyID=\"EUR\"
				+ "</ram:SpecifiedTradeSettlementMonetarySummation>"
				+ "</ram:ApplicableSupplyChainTradeSettlement>";


		int lineID = 0;
		for (final IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			if (currentItem.getProduct().getTaxExemptionReason() != null) {
				exemptionReason = "<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
			}


			final LineCalculator lc = new LineCalculator(currentItem);
			xml += "<ram:IncludedSupplyChainTradeLineItem>" +
					"<ram:AssociatedDocumentLineDocument>"
					+ "<ram:LineID>" + lineID + "</ram:LineID>"
					+ "</ram:AssociatedDocumentLineDocument>"
					+ "<ram:SpecifiedSupplyChainTradeAgreement>"
					+ "<ram:GrossPriceProductTradePrice>"
					+ "<ram:ChargeAmount currencyID=\"" + trans.getCurrency() + "\">" + priceFormat(lc.getPriceGross())
					+ "</ram:ChargeAmount>"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
					// + " <AppliedTradeAllowanceCharge>"
					// + " <ChargeIndicator>false</ChargeIndicator>"
					// + " <ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>"
					// + " <Reason>Rabatt</Reason>"
					// + " </AppliedTradeAllowanceCharge>"
					+ "</ram:GrossPriceProductTradePrice>"
					+ "<ram:NetPriceProductTradePrice>"
					+ "<ram:ChargeAmount currencyID=\"" + trans.getCurrency() + "\">" + priceFormat(currentItem.getPrice())
					+ "</ram:ChargeAmount>"
					+ "<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>"
					+ "</ram:NetPriceProductTradePrice>"
					+ "</ram:SpecifiedSupplyChainTradeAgreement>"


					+ "<ram:SpecifiedSupplyChainTradeDelivery>"
					+ "<ram:BilledQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">"
					+ quantityFormat(currentItem.getQuantity()) + "</ram:BilledQuantity>"
					+ "</ram:SpecifiedSupplyChainTradeDelivery>"
					+ "<ram:SpecifiedSupplyChainTradeSettlement>"
					+ "<ram:ApplicableTradeTax>"
					+ "<ram:TypeCode>VAT</ram:TypeCode>"
					+ exemptionReason
					+ "<ram:CategoryCode>" + currentItem.getProduct().getTaxCategoryCode() + "</ram:CategoryCode>"

					+ "<ram:ApplicablePercent>"
					+ vatFormat(currentItem.getProduct().getVATPercent()) + "</ram:ApplicablePercent>"
					+ "</ram:ApplicableTradeTax>"
					+ "<ram:SpecifiedTradeSettlementMonetarySummation>"
					+ "<ram:LineTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>"
					+ "</ram:SpecifiedTradeSettlementMonetarySummation>";
			if (currentItem.getAdditionalReferences() != null) {
				xml += "<ram:AdditionalReferencedDocument><ram:ID>" + currentItem.getAdditionalReferences()[0].getIssuerAssignedID() + "</ram:ID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>";
			} else if (currentItem.getAdditionalReferencedDocumentID() != null) {
				xml += "<ram:AdditionalReferencedDocument><ram:ID>" + currentItem.getAdditionalReferencedDocumentID() + "</ram:ID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>";
			}
			xml += "</ram:SpecifiedSupplyChainTradeSettlement>"
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
			xml += "<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>"
					+ "<ram:Description>" + XMLTools.encodeXML(currentItem.getProduct().getDescription())
					+ "</ram:Description>"
					+ "</ram:SpecifiedTradeProduct>"
					+ "</ram:IncludedSupplyChainTradeLineItem>";
		}

		// + " <IncludedSupplyChainTradeLineItem>\n"
		// + " <AssociatedDocumentLineDocument>\n"
		// + " <IncludedNote>\n"
		// + " <Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + " </IncludedNote>\n"
		// + " </AssociatedDocumentLineDocument>\n"
		// + " </IncludedSupplyChainTradeLineItem>\n";

		xml += "</rsm:SpecifiedSupplyChainTradeTransaction>"
				+ "</rsm:CrossIndustryDocument>";

		final byte[] zugferdRaw;
    zugferdRaw = xml.getBytes(StandardCharsets.UTF_8);
    zugferdData = XMLTools.removeBOM(zugferdRaw);
  }

	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

	private String buildPaymentTermsXml() {
		final IZUGFeRDPaymentTerms[] paymentTerms = trans.getPaymentTerms();

		String paymentTermsXml = "";
		if (paymentTerms == null || paymentTerms.length == 0) {
			return paymentTermsXml;
		}

		for (IZUGFeRDPaymentTerms pt : paymentTerms)
		{
			paymentTermsXml += "<ram:SpecifiedTradePaymentTerms>";

			final IZUGFeRDPaymentDiscountTerms discountTerms = pt.getDiscountTerms();
			final Date dueDate = pt.getDueDate();
			if (dueDate != null && discountTerms != null && discountTerms.getBaseDate() != null)
			{
				throw new IllegalStateException(
					"if paymentTerms.dueDate is specified, paymentTerms.discountTerms.baseDate has not to be specified");
			}
			paymentTermsXml += "<ram:Description>" + pt.getDescription() + "</ram:Description>";
			if (dueDate != null)
			{
				paymentTermsXml += "<ram:DueDateDateTime>";
				paymentTermsXml += DATE.udtFormat(dueDate);
				paymentTermsXml += "</ram:DueDateDateTime>";
			}

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
