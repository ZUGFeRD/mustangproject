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
import org.mustangproject.XMLTools;

import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ZUGFeRD1PullProvider extends ZUGFeRD2PullProvider implements IXMLProvider {


	//// MAIN CLASS

	protected byte[] zugferdData;
	private String paymentTermsDescription;
	SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd");
	protected Profile profile = Profiles.getByName("COMFORT", 1);


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
	public Profile getProfile() {
		return profile;
	}

	@Override
	public byte[] getXML() {

		byte[] res = zugferdData;

		StringWriter sw = new StringWriter();
		Document document = null;
		try {
			document = DocumentHelper.parseText(new String(zugferdData));
		} catch (DocumentException e1) {
			Logger.getLogger(ZUGFeRD1PullProvider.class.getName()).log(Level.SEVERE, null, e1);
		}
		try {
			OutputFormat format = OutputFormat.createPrettyPrint();
			XMLWriter writer = new XMLWriter(sw, format);
			writer.write(document);
			res = sw.toString().getBytes("UTF-8");

		} catch (IOException e) {
			Logger.getLogger(ZUGFeRD1PullProvider.class.getName()).log(Level.SEVERE, null, e);
		}

		return res;

	}


	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;
		this.calc = new TransactionCalculator(trans);

		boolean hasDueDate = false;
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

				+ "<rsm:CrossIndustryDocument xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:ferd:CrossIndustryDocument:invoice:1p0\""
				// + "
				// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
				// ../Schema/ZUGFeRD1p0.xsd\""
				+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12\""
				+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15\">\n"
				+ "	<rsm:SpecifiedExchangedDocumentContext>\n"
				// + "
				// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>\n"
				//
				+ "		<ram:GuidelineSpecifiedDocumentContextParameter>\n"
				+ "			<ram:ID>" + getProfile().getID() + "</ram:ID>\n"
				+ "		</ram:GuidelineSpecifiedDocumentContextParameter>\n"
				+ "	</rsm:SpecifiedExchangedDocumentContext>\n"
				+ "	<rsm:HeaderExchangedDocument>\n"
				+ "		<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>\n" //$NON-NLS-2$
				+ "     <ram:Name>RECHNUNG</ram:Name>\n"
				+ "		<ram:TypeCode>" + typecode + "</ram:TypeCode>\n"
				+ "		<ram:IssueDateTime><udt:DateTimeString format=\"102\">"
				+ zugferdDateFormat.format(trans.getIssueDate()) + "</udt:DateTimeString></ram:IssueDateTime>\n" // date
				// format
				// was
				// 20130605
				+ subjectNote
				+ rebateAgreement
				+ senderReg

				+ "	</rsm:HeaderExchangedDocument>\n"
				+ "	<rsm:SpecifiedSupplyChainTradeTransaction>\n";
		xml = xml + "		<ram:ApplicableSupplyChainTradeAgreement>\n";
		if (trans.getReferenceNumber() != null) {
			xml = xml + "			<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>\n";

		}
		xml = xml + "			<ram:SellerTradeParty>\n";
		xml += getTradePartyAsXML(trans.getSender(), true, false);
		xml += "			</ram:SellerTradeParty>\n"
				+ "			<ram:BuyerTradeParty>\n";
		// + " <ID>GE2020211</ID>\n"
		// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>\n"

		xml += getTradePartyAsXML(trans.getRecipient(), false, false);
		if ((trans.getOwnVATID() != null) && (trans.getOwnOrganisationName() != null)) {
			xml = xml + "            <ram:SpecifiedTaxRegistration>\n" + "               <ram:ID schemeID=\"VA\">"
					+ XMLTools.encodeXML(trans.getOwnVATID()) + "</ram:ID>\n"
					+ "            </ram:SpecifiedTaxRegistration>";
		}

		xml += "			</ram:BuyerTradeParty>\n";

		if (trans.getBuyerOrderReferencedDocumentID() != null) {
			xml = xml + "   <ram:BuyerOrderReferencedDocument>\n"
					+ "       <ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>\n"
					+ "   </ram:BuyerOrderReferencedDocument>\n";
		}
		xml = xml + "		</ram:ApplicableSupplyChainTradeAgreement>\n"
				+ "		<ram:ApplicableSupplyChainTradeDelivery>\n";
		if (this.trans.getDeliveryAddress() != null) {
			xml += "<ram:ShipToTradeParty>" +
					getTradePartyAsXML(this.trans.getDeliveryAddress(), false, true) +
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
				+ "		</ram:ApplicableSupplyChainTradeDelivery>\n" + "		<ram:ApplicableSupplyChainTradeSettlement>\n" //$NON-NLS-2$
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

		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = calc.getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				xml += "			<ram:ApplicableTradeTax>\n"
						+ "				<ram:CalculatedAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>\n" //currencyID=\"EUR\"
						+ "				<ram:TypeCode>VAT</ram:TypeCode>\n"
						+ exemptionReason
						+ "				<ram:BasisAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>\n" // currencyID=\"EUR\"
						+ "				<ram:CategoryCode>" + amount.getCategoryCode() + "</ram:CategoryCode>\n"
						+ "				<ram:ApplicablePercent>" + vatFormat(currentTaxPercent)
						+ "</ram:ApplicablePercent>\n" + "			</ram:ApplicableTradeTax>\n"; //$NON-NLS-2$

			}
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

		xml = xml + "			<ram:SpecifiedTradeSettlementMonetarySummation>\n"
				+ "				<ram:LineTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotal()) + "</ram:LineTotalAmount>\n" //$NON-NLS-2$
				// currencyID=\"EUR\"
				+ "				<ram:ChargeTotalAmount currencyID=\"" + trans.getCurrency() + "\">0.00</ram:ChargeTotalAmount>\n" // currencyID=\"EUR\"
				+ "				<ram:AllowanceTotalAmount currencyID=\"" + trans.getCurrency() + "\">0.00</ram:AllowanceTotalAmount>\n" //
				// currencyID=\"EUR\"
				// + " <ChargeTotalAmount currencyID=\"EUR\">5.80</ChargeTotalAmount>\n"
				// + " <AllowanceTotalAmount currencyID=\"EUR\">14.73</AllowanceTotalAmount>\n"
				+ "				<ram:TaxBasisTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotal()) + "</ram:TaxBasisTotalAmount>\n" //$NON-NLS-2$
				// //
				// currencyID=\"EUR\"
				+ "				<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(calc.getTotalGross().subtract(calc.getTotal())) + "</ram:TaxTotalAmount>\n"
				+ "				<ram:GrandTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotalGross()) + "</ram:GrandTotalAmount>\n" //$NON-NLS-2$
				// //
				// currencyID=\"EUR\"
				+ "             <ram:TotalPrepaidAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotalPrepaid()) + "</ram:TotalPrepaidAmount>\n"
				+ "				<ram:DuePayableAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(calc.getTotalGross().subtract(calc.getTotalPrepaid())) + "</ram:DuePayableAmount>\n" //$NON-NLS-2$
				// //
				// currencyID=\"EUR\"
				+ "			</ram:SpecifiedTradeSettlementMonetarySummation>\n"
				+ "		</ram:ApplicableSupplyChainTradeSettlement>\n";


		int lineID = 0;
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			if (currentItem.getProduct().getTaxExemptionReason() != null) {
				exemptionReason = "<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
			}


			LineCalculator lc = new LineCalculator(currentItem);
			xml = xml + "		<ram:IncludedSupplyChainTradeLineItem>\n" +
					"			<ram:AssociatedDocumentLineDocument>\n"
					+ "				<ram:LineID>" + lineID + "</ram:LineID>\n" //$NON-NLS-2$
					+ "			</ram:AssociatedDocumentLineDocument>\n"
					+ "			<ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "				<ram:GrossPriceProductTradePrice>\n"
					+ "					<ram:ChargeAmount currencyID=\"" + trans.getCurrency() + "\">" + priceFormat(lc.getPriceGross())
					+ "</ram:ChargeAmount>\n"
					+ "					<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>\n"
					// + " <AppliedTradeAllowanceCharge>\n"
					// + " <ChargeIndicator>false</ChargeIndicator>\n"
					// + " <ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
					// + " <Reason>Rabatt</Reason>\n"
					// + " </AppliedTradeAllowanceCharge>\n"
					+ "				</ram:GrossPriceProductTradePrice>\n"
					+ "				<ram:NetPriceProductTradePrice>\n"
					+ "					<ram:ChargeAmount currencyID=\"" + trans.getCurrency() + "\">" + priceFormat(currentItem.getPrice())
					+ "</ram:ChargeAmount>\n"
					+ "					<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) + "</ram:BasisQuantity>\n"
					+ "				</ram:NetPriceProductTradePrice>\n"
					+ "			</ram:SpecifiedSupplyChainTradeAgreement>\n"


					+ "			<ram:SpecifiedSupplyChainTradeDelivery>\n"
					+ "				<ram:BilledQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">" //$NON-NLS-2$
					+ quantityFormat(currentItem.getQuantity()) + "</ram:BilledQuantity>\n"
					+ "			</ram:SpecifiedSupplyChainTradeDelivery>\n"
					+ "			<ram:SpecifiedSupplyChainTradeSettlement>\n"
					+ "				<ram:ApplicableTradeTax>\n"
					+ "					<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ exemptionReason
					+ "					<ram:CategoryCode>" + currentItem.getProduct().getTaxCategoryCode() + "</ram:CategoryCode>\n"

					+ "					<ram:ApplicablePercent>"
					+ vatFormat(currentItem.getProduct().getVATPercent()) + "</ram:ApplicablePercent>\n"
					+ "				</ram:ApplicableTradeTax>\n"
					+ "				<ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "					<ram:LineTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>\n"
					+ "				</ram:SpecifiedTradeSettlementMonetarySummation>\n";
			if (currentItem.getAdditionalReferencedDocumentID() != null) {
				xml = xml + "			<ram:AdditionalReferencedDocument><ram:ID>" + currentItem.getAdditionalReferencedDocumentID() + "</ram:ID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>\n";

			}
			xml = xml + "			</ram:SpecifiedSupplyChainTradeSettlement>\n"
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
			xml = xml + "					<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>\n" //$NON-NLS-2$
					+ "				<ram:Description>" + XMLTools.encodeXML(currentItem.getProduct().getDescription())
					+ "</ram:Description>\n"
					+ "			</ram:SpecifiedTradeProduct>\n"

					+ "		</ram:IncludedSupplyChainTradeLineItem>\n";

		}

		// + " <IncludedSupplyChainTradeLineItem>\n"
		// + " <AssociatedDocumentLineDocument>\n"
		// + " <IncludedNote>\n"
		// + " <Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + " </IncludedNote>\n"
		// + " </AssociatedDocumentLineDocument>\n"
		// + " </IncludedSupplyChainTradeLineItem>\n";

		xml = xml + "	</rsm:SpecifiedSupplyChainTradeTransaction>\n"
				+ "</rsm:CrossIndustryDocument>";

		byte[] zugferdRaw;
		try {
			zugferdRaw = xml.getBytes("UTF-8");
			zugferdData = XMLTools.removeBOM(zugferdRaw);
		} catch (UnsupportedEncodingException e) {
			Logger.getLogger(ZUGFeRD1PullProvider.class.getName()).log(Level.SEVERE, null, e);
		}
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
					+ zugferdDateFormat.format(dueDate.getDate()) + "</udt:DateTimeString>";
			paymentTermsXml += "</ram:DueDateDateTime>";
		}

		if (discountTerms != null) {
			paymentTermsXml += "<ram:ApplicableTradePaymentDiscountTerms>";
			String currency = trans.getCurrency();
			String basisAmount = currencyFormat(calc.getTotalGross());
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

}
