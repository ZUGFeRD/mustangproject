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

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.XMLTools;
import org.mustangproject.ZUGFeRD.*;

import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ZUGFeRD1PullProvider implements IXMLProvider, IProfileProvider {

	private class LineCalc {
		private BigDecimal totalGross;
		private BigDecimal priceGross;
		private BigDecimal itemTotalNetAmount;
		private BigDecimal itemTotalVATAmount;

		public LineCalc(IZUGFeRDExportableItem currentItem) {
			BigDecimal multiplicator = currentItem.getProduct().getVATPercent().divide(new BigDecimal(100))
					.add(new BigDecimal(1));
			priceGross = currentItem.getPrice().multiply(multiplicator);
			totalGross = currentItem.getQuantity().multiply(currentItem.getPrice()).divide(currentItem.getBasisQuantity())
					.multiply(multiplicator);
			itemTotalNetAmount = currentItem.getQuantity().multiply(currentItem.getPrice()).divide(currentItem.getBasisQuantity())
					.setScale(2, BigDecimal.ROUND_HALF_UP);
			itemTotalVATAmount = totalGross.subtract(itemTotalNetAmount);
		}

		public BigDecimal getItemTotalNetAmount() {
			return itemTotalNetAmount;
		}

		public BigDecimal getItemTotalVATAmount() {
			return itemTotalVATAmount;
		}

		public BigDecimal getItemTotalGrossAmount() {
			return itemTotalVATAmount;
		}

		public BigDecimal getPriceGross() {
			return priceGross;
		}

	}

	//// MAIN CLASS

	protected byte[] zugferdData;
	private IZUGFeRDExportableTransaction trans;
	private ZUGFeRDConformanceLevel level;
	private String paymentTermsDescription;

	@Override
	public void setProfile(ZUGFeRDConformanceLevel level) {
		this.level = level;
	}

	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 */
	@Override
	public void setTest() {
	}

	public static String nDigitFormat(BigDecimal value, int scale) {
		/*
		 * I needed 123,45, locale independent.I tried
		 * NumberFormat.getCurrencyInstance().format( 12345.6789 ); but that is locale
		 * specific.I also tried DecimalFormat df = new DecimalFormat( "0,00" );
		 * df.setDecimalSeparatorAlwaysShown(true); df.setGroupingUsed(false);
		 * DecimalFormatSymbols symbols = new DecimalFormatSymbols();
		 * symbols.setDecimalSeparator(','); symbols.setGroupingSeparator(' ');
		 * df.setDecimalFormatSymbols(symbols);
		 *
		 * but that would not switch off grouping. Although I liked very much the
		 * (incomplete) "BNF diagram" in
		 * http://docs.oracle.com/javase/tutorial/i18n/format/decimalFormat.html in the
		 * end I decided to calculate myself and take eur+sparator+cents
		 *
		 */
		return value.setScale(scale, RoundingMode.HALF_UP).toPlainString();

	}

	private String vatFormat(BigDecimal value) {
		return ZUGFeRD1PullProvider.nDigitFormat(value, 2);
	}

	private String currencyFormat(BigDecimal value) {
		return ZUGFeRD1PullProvider.nDigitFormat(value, 2);
	}

	private String priceFormat(BigDecimal value) {
		return ZUGFeRD1PullProvider.nDigitFormat(value, 4);
	}

	private String quantityFormat(BigDecimal value) {
		return ZUGFeRD1PullProvider.nDigitFormat(value, 4);
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

	private BigDecimal getTotalPrepaid() {
		if (trans.getTotalPrepaidAmount() == null) {
			return new BigDecimal(0);
		} else {
			return trans.getTotalPrepaidAmount();
		}
	}

	private BigDecimal getTotalGross() {

		BigDecimal res = getTotal();
		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			res = res.add(amount.getCalculated());
		}
		return res;
	}

	private BigDecimal getTotal() {
		BigDecimal res = new BigDecimal(0);
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			LineCalc lc = new LineCalc(currentItem);
			res = res.add(lc.getItemTotalNetAmount());
		}
		return res;
	}

	/**
	 * which taxes have been used with which amounts in this transaction, empty for
	 * no taxes, or e.g. 19=>190 and 7=>14 if 1000 Eur were applicable to 19% VAT
	 * (=>190 EUR VAT) and 200 EUR were applicable to 7% (=>14 EUR VAT) 190 Eur
	 *
	 * @return which taxes have been used with which amounts in this invoice
	 */
	private HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
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
		return hm;
	}

	@Override
	public String getProfile() {
		return "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort";
	}

	protected String getContactAsXML(IZUGFeRDExportableContact contact) {
		String xml = "	<ram:Name>" + XMLTools.encodeXML(contact.getName()) + "</ram:Name>\n" //$NON-NLS-2$
		// + " <DefinedTradeContact>\n"
		// + " <PersonName>xxx</PersonName>\n"
		// + " </DefinedTradeContact>\n"
				+ "				<ram:PostalTradeAddress>\n"
				+ "					<ram:PostcodeCode>" + XMLTools.encodeXML(contact.getZIP())
				+ "</ram:PostcodeCode>\n"
				+ "					<ram:LineOne>" + XMLTools.encodeXML(contact.getStreet())
				+ "</ram:LineOne>\n";
		if (trans.getRecipient().getAdditionalAddress() != null) {
			xml += "				<ram:LineTwo>" + XMLTools.encodeXML(contact.getAdditionalAddress())
					+ "</ram:LineTwo>\n";
		}
		xml += "					<ram:CityName>" + XMLTools.encodeXML(contact.getLocation())
				+ "</ram:CityName>\n"
				+ "					<ram:CountryID>" + XMLTools.encodeXML(contact.getCountry())
				+ "</ram:CountryID>\n"
				+ "				</ram:PostalTradeAddress>\n";
		if (contact.getVATID() != null) {
			xml += "				<ram:SpecifiedTaxRegistration>\n"
					+ "					<ram:ID schemeID=\"VA\">" + XMLTools.encodeXML(contact.getVATID())
					+ "</ram:ID>\n"
					+ "				</ram:SpecifiedTaxRegistration>\n";
		}
		return xml;

	}

	@Override
	public void generateXML(IZUGFeRDExportableTransaction trans) {
		this.trans = trans;

		boolean hasDueDate=false;
		String taxCategoryCode="";
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");
		SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd");
		String exemptionReason="";

		if (trans.getPaymentTermDescription()!=null) {
			paymentTermsDescription=trans.getPaymentTermDescription();
		}

		if (paymentTermsDescription==null) {
			paymentTermsDescription= "Zahlbar ohne Abzug bis " + germanDateFormat.format(trans.getDueDate());
			
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
		if (trans.getSubjectNote()!=null) {
			subjectNote = "<ram:IncludedNote>\n" + "		<ram:Content>"
					+ XMLTools.encodeXML(trans.getSubjectNote())+ "</ram:Content>\n"
					+ "</ram:IncludedNote>\n";
		}

		String xml = "﻿<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"

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
				+ "			<ram:ID>" + getProfile() + "</ram:ID>\n"
				+ "		</ram:GuidelineSpecifiedDocumentContextParameter>\n"
				+ "	</rsm:SpecifiedExchangedDocumentContext>\n"
				+ "	<rsm:HeaderExchangedDocument>\n"
				+ "		<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>\n" //$NON-NLS-2$
				+ "     <ram:Name>RECHNUNG</ram:Name>\n"
				+ "		<ram:TypeCode>380</ram:TypeCode>\n"
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
		int lineID = 0;
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			taxCategoryCode=currentItem.getProduct().getTaxCategoryCode();
			if  (currentItem.getProduct().getTaxExemptionReason() != null) {
				exemptionReason="<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
			}
			
			LineCalc lc = new LineCalc(currentItem);
			xml = xml + "		<ram:IncludedSupplyChainTradeLineItem>\n" +
					"			<ram:AssociatedDocumentLineDocument>\n"
					+ "				<ram:LineID>" + lineID + "</ram:LineID>\n" //$NON-NLS-2$
					+ "			</ram:AssociatedDocumentLineDocument>\n"
					+ "			<ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "				<ram:GrossPriceProductTradePrice>\n"
					+ "					<ram:ChargeAmount currencyID=\""+trans.getCurrency()+"\">" + priceFormat(lc.getPriceGross())
					+ "</ram:ChargeAmount>\n"
					+ "					<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) +"</ram:BasisQuantity>\n"
					// + " <AppliedTradeAllowanceCharge>\n"
					// + " <ChargeIndicator>false</ChargeIndicator>\n"
					// + " <ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
					// + " <Reason>Rabatt</Reason>\n"
					// + " </AppliedTradeAllowanceCharge>\n"
					+ "				</ram:GrossPriceProductTradePrice>\n"
					+ "				<ram:NetPriceProductTradePrice>\n"
					+ "					<ram:ChargeAmount currencyID=\""+trans.getCurrency()+"\">" + priceFormat(currentItem.getPrice())
					+ "</ram:ChargeAmount>\n"
					+ "					<ram:BasisQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit())
					+ "\">" + quantityFormat(currentItem.getBasisQuantity()) +"</ram:BasisQuantity>\n"
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
					+ "					<ram:CategoryCode>"+currentItem.getProduct().getTaxCategoryCode()+"</ram:CategoryCode>\n"
					
					+ "					<ram:ApplicablePercent>"
					+ vatFormat(currentItem.getProduct().getVATPercent()) + "</ram:ApplicablePercent>\n"
					+ "				</ram:ApplicableTradeTax>\n"
					+ "				<ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "					<ram:LineTotalAmount currencyID=\""+trans.getCurrency()+"\">" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>\n"
					+ "				</ram:SpecifiedTradeSettlementMonetarySummation>\n";
					if (currentItem.getAdditionalReferencedDocumentID()!=null) {
						xml=xml	+ "			<ram:AdditionalReferencedDocument><ram:ID>"+currentItem.getAdditionalReferencedDocumentID()+"</ram:ID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>\n";
											
					}
				xml=xml	+ "			</ram:SpecifiedSupplyChainTradeSettlement>\n"
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

		xml = xml + "		<ram:ApplicableSupplyChainTradeAgreement>\n";
		if (trans.getReferenceNumber() != null) {
			xml = xml + "			<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>\n";

		}
		xml = xml + "			<ram:SellerTradeParty>\n";
		if (trans.getOwnForeignOrganisationID()!=null) {
			xml = xml + "			<ram:ID>" + XMLTools.encodeXML(trans.getOwnForeignOrganisationID()) + "</ram:ID>\n";
		}
		
		if ((trans.getOwnContact()!=null)&&(trans.getOwnContact().getGlobalID()!=null)&&(trans.getOwnContact().getGlobalIDScheme()!=null)) {
			xml = xml + "           <ram:GlobalID schemeID=\"" + XMLTools.encodeXML(trans.getOwnContact().getGlobalIDScheme()) + "\">"
					  + XMLTools.encodeXML(trans.getOwnContact().getGlobalID()) + "</ram:GlobalID>\n";
		}
		xml = xml + "				<ram:Name>" + XMLTools.encodeXML(trans.getOwnOrganisationName()) + "</ram:Name>\n"; //$NON-NLS-2$

		if ((trans.getOwnVATID()!=null)&&(trans.getOwnOrganisationName()!=null)) {
			
			xml = xml + "            <ram:SpecifiedTaxRegistration>\n" + "               <ram:ID schemeID=\"VA\">"
					+ XMLTools.encodeXML(trans.getOwnVATID()) + "</ram:ID>\n"
					+ "            </ram:SpecifiedTaxRegistration>";
		}

		if (trans.getOwnContact() != null) {
			xml = xml + "<ram:DefinedTradeContact>\n" + "     <ram:PersonName>" + XMLTools.encodeXML(trans.getOwnContact().getName())
					+ "</ram:PersonName>\n";
			if (trans.getOwnContact().getPhone() != null) {

				xml = xml + "     <ram:TelephoneUniversalCommunication>\n" + "        <ram:CompleteNumber>"
						+ XMLTools.encodeXML(trans.getOwnContact().getPhone()) + "</ram:CompleteNumber>\n"
						+ "     </ram:TelephoneUniversalCommunication>\n";
			}
			if (trans.getOwnContact().getEMail() != null) {

				xml = xml + "     <ram:EmailURIUniversalCommunication>\n" + "        <ram:URIID>"
						+ XMLTools.encodeXML(trans.getOwnContact().getEMail()) + "</ram:URIID>\n"
						+ "     </ram:EmailURIUniversalCommunication>\n";
			}
			xml = xml + "  </ram:DefinedTradeContact>";

		}

		xml = xml + "				<ram:PostalTradeAddress>\n" + "					<ram:PostcodeCode>"
				+ XMLTools.encodeXML(trans.getOwnZIP()) + "</ram:PostcodeCode>\n" + "					<ram:LineOne>"
				+ XMLTools.encodeXML(trans.getOwnStreet()) + "</ram:LineOne>\n" + "					<ram:CityName>" + XMLTools.encodeXML(trans.getOwnLocation())
				+ "</ram:CityName>\n" + "					<ram:CountryID>" + XMLTools.encodeXML(trans.getOwnCountry())
				+ "</ram:CountryID>\n" + "				</ram:PostalTradeAddress>\n"
				+ "				<ram:SpecifiedTaxRegistration>\n"
				+ "					<ram:ID schemeID=\"FC\">" + XMLTools.encodeXML(trans.getOwnTaxID()) + "</ram:ID>\n" //$NON-NLS-2$
				+ "				</ram:SpecifiedTaxRegistration>\n"
				+ "				<ram:SpecifiedTaxRegistration>\n"
				+ "					<ram:ID schemeID=\"VA\">" + XMLTools.encodeXML(trans.getOwnVATID()) + "</ram:ID>\n" //$NON-NLS-2$
				+ "				</ram:SpecifiedTaxRegistration>\n"
				+ "			</ram:SellerTradeParty>\n"
				+ "			<ram:BuyerTradeParty>\n";
				// + " <ID>GE2020211</ID>\n"
				// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>\n"
				
				xml+=getContactAsXML(trans.getRecipient());
				xml += "			</ram:BuyerTradeParty>\n";

		if (trans.getBuyerOrderReferencedDocumentID()!=null) {
			xml = xml + "   <ram:BuyerOrderReferencedDocument>\n" 
					  + "       <ram:IssuerAssignedID>" 
					  + XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>\n" 
					  + "   </ram:BuyerOrderReferencedDocument>\n";
		}
		xml = xml  + "		</ram:ApplicableSupplyChainTradeAgreement>\n"
				+ "		<ram:ApplicableSupplyChainTradeDelivery>\n" ;
		if (this.trans.getDeliveryAddress()!=null) {
			xml += "<ram:ShipToTradeParty>"+
		getContactAsXML(this.trans.getDeliveryAddress())+
	       "</ram:ShipToTradeParty>";
		}
				
				xml+= "			<ram:ActualDeliverySupplyChainEvent>\n"
				+ "				<ram:OccurrenceDateTime>";

		if (trans.getZFDeliveryDate() != null) {
			ZUGFeRDDateFormat dateFormat = trans.getZFDeliveryDate().getFormat();
			Date date = trans.getZFDeliveryDate().getDate();
			xml += "<udt:DateTimeString format=\"" + dateFormat.getDateTimeType() + "\">"
					+ dateFormat.getFormatter().format(date) + "</udt:DateTimeString>";
		} else if (trans.getDeliveryDate() != null) {
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

		if (trans.getTradeSettlementPayment()!=null) {
			for (IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
				if(payment!=null) {
					hasDueDate=true;
					xml+=payment.getSettlementXML();
				}
			}
		}
		if (trans.getTradeSettlement()!=null) {
			for (IZUGFeRDTradeSettlement payment : trans.getTradeSettlement()) {
				if(payment!=null) {
					if (payment instanceof IZUGFeRDTradeSettlementPayment) {
						hasDueDate=true;
					}
					xml+=payment.getSettlementXML();
				}
			}
		}

		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				xml += "			<ram:ApplicableTradeTax>\n"
						+ "				<ram:CalculatedAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(amount.getCalculated())
						+ "</ram:CalculatedAmount>\n" //currencyID=\"EUR\"
						+ "				<ram:TypeCode>VAT</ram:TypeCode>\n"
						+ exemptionReason
						+ "				<ram:BasisAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>\n" // currencyID=\"EUR\"
						+ "				<ram:CategoryCode>"+taxCategoryCode+"</ram:CategoryCode>\n"
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

			if (hasDueDate && (trans.getDueDate()!=null)) {
				xml = xml + "				<ram:DueDateDateTime><udt:DateTimeString format=\"102\">" // $NON-NLS-2$
						+ zugferdDateFormat.format(trans.getDueDate())
						+ "</udt:DateTimeString></ram:DueDateDateTime>\n";// 20130704

			}
			xml = xml + "			</ram:SpecifiedTradePaymentTerms>\n";
		} else {
			xml = xml + buildPaymentTermsXml();
		}

		xml = xml + "			<ram:SpecifiedTradeSettlementMonetarySummation>\n"
				+ "				<ram:LineTotalAmount currencyID=\""+trans.getCurrency()+"\">" + currencyFormat(getTotal()) + "</ram:LineTotalAmount>\n" //$NON-NLS-2$
																													// currencyID=\"EUR\"
				+ "				<ram:ChargeTotalAmount currencyID=\"" + trans.getCurrency() + "\">0.00</ram:ChargeTotalAmount>\n" // currencyID=\"EUR\"
				+ "				<ram:AllowanceTotalAmount currencyID=\"" + trans.getCurrency() + "\">0.00</ram:AllowanceTotalAmount>\n" //
																								// currencyID=\"EUR\"
				// + " <ChargeTotalAmount currencyID=\"EUR\">5.80</ChargeTotalAmount>\n"
				// + " <AllowanceTotalAmount currencyID=\"EUR\">14.73</AllowanceTotalAmount>\n"
				+ "				<ram:TaxBasisTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(getTotal()) + "</ram:TaxBasisTotalAmount>\n" //$NON-NLS-2$
																															// //
																															// currencyID=\"EUR\"
				+ "				<ram:TaxTotalAmount currencyID=\"" + trans.getCurrency() + "\">"
				+ currencyFormat(getTotalGross().subtract(getTotal())) + "</ram:TaxTotalAmount>\n"
				+ "				<ram:GrandTotalAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(getTotalGross()) + "</ram:GrandTotalAmount>\n" //$NON-NLS-2$
																														// //
																														// currencyID=\"EUR\"
				+ "             <ram:TotalPrepaidAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(getTotalPrepaid()) + "</ram:TotalPrepaidAmount>\n"
				+ "				<ram:DuePayableAmount currencyID=\"" + trans.getCurrency() + "\">" + currencyFormat(getTotalGross().subtract(getTotalPrepaid())) + "</ram:DuePayableAmount>\n" //$NON-NLS-2$
																														// //
																														// currencyID=\"EUR\"
				+ "			</ram:SpecifiedTradeSettlementMonetarySummation>\n"
				+ "		</ram:ApplicableSupplyChainTradeSettlement>\n";
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

			if ((zugferdRaw[0] == (byte) 0xEF) && (zugferdRaw[1] == (byte) 0xBB) && (zugferdRaw[2] == (byte) 0xBF)) {
				// I don't like BOMs, lets remove it
				zugferdData = new byte[zugferdRaw.length - 3];
				System.arraycopy(zugferdRaw, 3, zugferdData, 0, zugferdRaw.length - 3);
			} else {
				zugferdData = zugferdRaw;
			}
		} catch (UnsupportedEncodingException e) {
			Logger.getLogger(ZUGFeRD1PullProvider.class.getName()).log(Level.SEVERE, null, e);
		} // $NON-NLS-1$
	}

	private String buildPaymentTermsXml() {
		String paymentTermsXml = "<ram:SpecifiedTradePaymentTerms>";

		IZUGFeRDPaymentTerms paymentTerms = trans.getPaymentTerms();
		IZUGFeRDPaymentDiscountTerms discountTerms = paymentTerms.getDiscountTerms();
		IZUGFeRDDate dueDate = paymentTerms.getDueDate();
		if (dueDate != null && discountTerms != null && discountTerms.getBaseDate() != null) {
			throw new IllegalStateException(
					"if paymentTerms.dueDate is specified, paymentTerms.discountTerms.baseDate has not to be specified");
		}
		paymentTermsXml += "<ram:Description>" + paymentTerms.getDescription() + "</ram:Description>";
		if (dueDate != null) {
			paymentTermsXml += "<ram:DueDateDateTime>";
			paymentTermsXml += "<udt:DateTimeString format=\"" + dueDate.getFormat().getDateTimeType() + "\">"
					+ dueDate.getFormat().getFormatter().format(dueDate.getDate()) + "</udt:DateTimeString>";
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
				Date baseDate = discountTerms.getBaseDate().getDate();
				ZUGFeRDDateFormat baseDateFormat = discountTerms.getBaseDate().getFormat();
				paymentTermsXml += "<ram:BasisDateTime>";
				paymentTermsXml += "<udt:DateTimeString format=\"" + baseDateFormat.getDateTimeType() + "\">" + baseDateFormat.getFormatter().format(baseDate) + "</udt:DateTimeString>";
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
