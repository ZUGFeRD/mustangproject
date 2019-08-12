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

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.toecount.Toecount;

public class ZUGFeRD2PullProvider implements IXMLProvider, IProfileProvider {

	private class LineCalc {
		private BigDecimal totalGross;
		private BigDecimal itemTotalNetAmount;
		private BigDecimal itemTotalVATAmount;

		public LineCalc(IZUGFeRDExportableItem currentItem) {
			BigDecimal multiplicator = currentItem.getProduct().getVATPercent().divide(new BigDecimal(100))
					.add(new BigDecimal(1));
			// priceGross=currentItem.getPrice().multiply(multiplicator);
			totalGross = currentItem.getPrice().multiply(multiplicator).multiply(currentItem.getQuantity());
			itemTotalNetAmount = currentItem.getQuantity().multiply(currentItem.getPrice()).setScale(2,
					BigDecimal.ROUND_HALF_UP);
			itemTotalVATAmount = totalGross.subtract(itemTotalNetAmount);
		}

		public BigDecimal getItemTotalNetAmount() {
			return itemTotalNetAmount;
		}

		public BigDecimal getItemTotalVATAmount() {
			return itemTotalVATAmount;
		}

	}

	//// MAIN CLASS

	protected byte[] zugferdData;
	private IZUGFeRDExportableTransaction trans;
	private ZUGFeRDConformanceLevel level;

	public void setProfile(ZUGFeRDConformanceLevel level) {
		this.level = level;
	}

	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 */
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
		return ZUGFeRD2PullProvider.nDigitFormat(value, 2);
	}

	private String currencyFormat(BigDecimal value) {
		return ZUGFeRD2PullProvider.nDigitFormat(value, 2);
	}

	private String priceFormat(BigDecimal value) {
		return ZUGFeRD2PullProvider.nDigitFormat(value, 4);
	}

	private String quantityFormat(BigDecimal value) {
		return ZUGFeRD2PullProvider.nDigitFormat(value, 4);
	}

	@Override
	public byte[] getXML() {

		byte[] res = zugferdData;
		
		StringWriter sw = new StringWriter();
		Document document=null;
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

	private BigDecimal getTotalPrepaid() {
		if (trans.getTotalPrepaidAmount()==null) {
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

	public String getProfile() {
		return "urn:cen.eu:en16931:2017";
	}
	
	public static String encodeXML(CharSequence s) {
	    StringBuilder sb = new StringBuilder();
	    int len = s.length();
	    for (int i=0;i<len;i++) {
	        int c = s.charAt(i);
	        if (c >= 0xd800 && c <= 0xdbff && i + 1 < len) {
	            c = ((c-0xd7c0)<<10) | (s.charAt(++i)&0x3ff);    // UTF16 decode
	        }
	        if (c < 0x80) {      // ASCII range: test most common case first
	            if (c < 0x20 && (c != '\t' && c != '\r' && c != '\n')) {
	                // Illegal XML character, even encoded. Skip or substitute
	                sb.append("&#xfffd;");   // Unicode replacement character
	            } else {
	                switch(c) {
	                  case '&':  sb.append("&amp;"); break;
	                  case '>':  sb.append("&gt;"); break;
	                  case '<':  sb.append("&lt;"); break;
	                  // Uncomment next two if encoding for an XML attribute
//	                  case '\''  sb.append("&apos;"); break;
//	                  case '\"'  sb.append("&quot;"); break;
	                  // Uncomment next three if you prefer, but not required
//	                  case '\n'  sb.append("&#10;"); break;
//	                  case '\r'  sb.append("&#13;"); break;
//	                  case '\t'  sb.append("&#9;"); break;

	                  default:   sb.append((char)c);
	                }
	            }
	        } else if ((c >= 0xd800 && c <= 0xdfff) || c == 0xfffe || c == 0xffff) {
	            // Illegal XML character, even encoded. Skip or substitute
	            sb.append("&#xfffd;");   // Unicode replacement character
	        } else {
	            sb.append("&#x");
	            sb.append(Integer.toHexString(c));
	            sb.append(';');
	        }
	    }
	    return sb.toString();
	}

	@Override
	public void generateXML(IZUGFeRDExportableTransaction trans) {
		this.trans = trans;
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy"); //$NON-NLS-1$
		SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd"); //$NON-NLS-1$
		String senderReg = "";
		if (trans.getOwnOrganisationFullPlaintextInfo() != null) {
			senderReg = "" + "<ram:IncludedNote>\n" + "		<ram:Content>\n"
					+ encodeXML(trans.getOwnOrganisationFullPlaintextInfo()) + "		</ram:Content>\n"
					+ "<ram:SubjectCode>REG</ram:SubjectCode>\n" + "</ram:IncludedNote>\n";

		}

		String xml = "﻿<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" //$NON-NLS-1$

				+ "<rsm:CrossIndustryInvoice xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100\""
				// + "
				// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
				// ../Schema/ZUGFeRD1p0.xsd\""
				+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100\""
				+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100\">\n" //$NON-NLS-1$
				+ "	<rsm:ExchangedDocumentContext>\n" //$NON-NLS-1$
				// + "
				// <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>\n"
				// //$NON-NLS-1$
				+ "		<ram:GuidelineSpecifiedDocumentContextParameter>\n" //$NON-NLS-1$
				+ "			<ram:ID>" + getProfile() + "</ram:ID>\n" //$NON-NLS-1$
				+ "		</ram:GuidelineSpecifiedDocumentContextParameter>\n" //$NON-NLS-1$
				+ "	</rsm:ExchangedDocumentContext>\n" //$NON-NLS-1$
				+ "	<rsm:ExchangedDocument>\n" //$NON-NLS-1$
				+ "		<ram:ID>" + encodeXML(trans.getNumber()) + "</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				// + " <ram:Name>RECHNUNG</ram:Name>\n" //$NON-NLS-1$
				+ "		<ram:TypeCode>380</ram:TypeCode>\n" //$NON-NLS-1$
				+ "		<ram:IssueDateTime><udt:DateTimeString format=\"102\">" //$NON-NLS-1$
				+ zugferdDateFormat.format(trans.getIssueDate()) + "</udt:DateTimeString></ram:IssueDateTime>\n" // date //$NON-NLS-1$
																													// format
																													// was
																													// 20130605
				+ senderReg
				// + " <IncludedNote>\n"
				// + " <Content>\n"
				// + "Rechnung gemäß Bestellung Nr. 2013-471331 vom 01.03.2013.\n"
				// + "\n"
				// + " </Content>\n"
				// + " </IncludedNote>\n"
				// + " <IncludedNote>\n"
				// + " <Content>\n"
				// + "Es bestehen Rabatt- und Bonusvereinbarungen.\n"
				// + " </Content>\n"
				// + " <SubjectCode>AAK</SubjectCode>\n"
				// + " </IncludedNote>\n"
				+ "	</rsm:ExchangedDocument>\n" //$NON-NLS-1$
				+ "	<rsm:SupplyChainTradeTransaction>\n"; //$NON-NLS-1$
		int lineID = 0;
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;

			LineCalc lc = new LineCalc(currentItem);
			xml = xml + "		<ram:IncludedSupplyChainTradeLineItem>\n" + //$NON-NLS-1$
					"			<ram:AssociatedDocumentLineDocument>\n" //$NON-NLS-1$
					+ "				<ram:LineID>" + lineID + "</ram:LineID>\n" //$NON-NLS-1$ //$NON-NLS-2$
					+ "			</ram:AssociatedDocumentLineDocument>\n" //$NON-NLS-1$
					+ "			<ram:SpecifiedTradeProduct>\n" //$NON-NLS-1$
					// + " <GlobalID schemeID=\"0160\">4012345001235</GlobalID>\n"
					// + " <SellerAssignedID>KR3M</SellerAssignedID>\n"
					// + " <BuyerAssignedID>55T01</BuyerAssignedID>\n"
					+ "				<ram:Name>" + encodeXML(currentItem.getProduct().getName()) + "</ram:Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
					+ "				<ram:Description>" + encodeXML(currentItem.getProduct().getDescription()) //$NON-NLS-1$
					+ "</ram:Description>\n" //$NON-NLS-1$
					+ "			</ram:SpecifiedTradeProduct>\n" //$NON-NLS-1$

					+ "			<ram:SpecifiedLineTradeAgreement>\n" //$NON-NLS-1$
					+ "				<ram:GrossPriceProductTradePrice>\n" //$NON-NLS-1$
					+ "					<ram:ChargeAmount>" + priceFormat(currentItem.getPrice()) //$NON-NLS-1$
					+ "</ram:ChargeAmount>\n" //$NON-NLS-1$ //currencyID=\"EUR\"
					+ "					<ram:BasisQuantity unitCode=\"" + encodeXML(currentItem.getProduct().getUnit()) //$NON-NLS-1$
					+ "\">1.0000</ram:BasisQuantity>\n" //$NON-NLS-1$
					// + " <AppliedTradeAllowanceCharge>\n"
					// + " <ChargeIndicator>false</ChargeIndicator>\n"
					// + " <ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
					// + " <Reason>Rabatt</Reason>\n"
					// + " </AppliedTradeAllowanceCharge>\n"
					+ "				</ram:GrossPriceProductTradePrice>\n" //$NON-NLS-1$
					+ "				<ram:NetPriceProductTradePrice>\n" //$NON-NLS-1$
					+ "					<ram:ChargeAmount>" + priceFormat(currentItem.getPrice()) //$NON-NLS-1$
					+ "</ram:ChargeAmount>\n" //$NON-NLS-1$ // currencyID=\"EUR\"
					+ "					<ram:BasisQuantity unitCode=\"" + encodeXML(currentItem.getProduct().getUnit()) //$NON-NLS-1$
					+ "\">1.0000</ram:BasisQuantity>\n" //$NON-NLS-1$
					+ "				</ram:NetPriceProductTradePrice>\n" //$NON-NLS-1$
					+ "			</ram:SpecifiedLineTradeAgreement>\n" //$NON-NLS-1$

					+ "			<ram:SpecifiedLineTradeDelivery>\n" //$NON-NLS-1$
					+ "				<ram:BilledQuantity unitCode=\"" + encodeXML(currentItem.getProduct().getUnit()) + "\">" //$NON-NLS-1$ //$NON-NLS-2$
					+ quantityFormat(currentItem.getQuantity()) + "</ram:BilledQuantity>\n" //$NON-NLS-1$
					+ "			</ram:SpecifiedLineTradeDelivery>\n" //$NON-NLS-1$
					+ "			<ram:SpecifiedLineTradeSettlement>\n" //$NON-NLS-1$
					+ "				<ram:ApplicableTradeTax>\n" //$NON-NLS-1$
					+ "					<ram:TypeCode>VAT</ram:TypeCode>\n" //$NON-NLS-1$
					+ "					<ram:CategoryCode>S</ram:CategoryCode>\n" //$NON-NLS-1$
					+ "					<ram:RateApplicablePercent>" //$NON-NLS-1$
					+ vatFormat(currentItem.getProduct().getVATPercent()) + "</ram:RateApplicablePercent>\n" //$NON-NLS-1$
					+ "				</ram:ApplicableTradeTax>\n" //$NON-NLS-1$
					+ "				<ram:SpecifiedTradeSettlementLineMonetarySummation>\n" //$NON-NLS-1$
					+ "					<ram:LineTotalAmount>" + currencyFormat(lc.getItemTotalNetAmount()) //$NON-NLS-1$
					+ "</ram:LineTotalAmount>\n" //$NON-NLS-1$ // currencyID=\"EUR\"
					+ "				</ram:SpecifiedTradeSettlementLineMonetarySummation>\n" //$NON-NLS-1$
					+ "			</ram:SpecifiedLineTradeSettlement>\n" //$NON-NLS-1$
					+ "		</ram:IncludedSupplyChainTradeLineItem>\n"; //$NON-NLS-1$

		}

		xml = xml + "		<ram:ApplicableHeaderTradeAgreement>\n"; //$NON-NLS-1$
		if (trans.getReferenceNumber() != null) {
			xml = xml + "			<ram:BuyerReference>" + encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>\n";

		}
		xml = xml + "			<ram:SellerTradeParty>\n" //$NON-NLS-1$
		// + " <GlobalID schemeID=\"0088\">4000001123452</GlobalID>\n"
				+ "				<ram:Name>" + encodeXML(trans.getOwnOrganisationName()) + "</ram:Name>\n"; //$NON-NLS-1$ //$NON-NLS-2$

		if ((trans.getOwnVATID()!=null)&&(trans.getOwnOrganisationName()!=null)) {
			
			xml = xml + "            <ram:SpecifiedLegalOrganization>\n" + "               <ram:ID schemeID='9930'>"
					+ encodeXML(trans.getOwnVATID()) + "</ram:ID>\n" + "               <ram:TradingBusinessName>"
					+ encodeXML(trans.getOwnOrganisationName()) + "</ram:TradingBusinessName>\n"
					+ "            </ram:SpecifiedLegalOrganization>";
		}

		if (trans.getOwnContact() != null) {
			xml = xml + "<ram:DefinedTradeContact>\n" + "     <ram:PersonName>" + encodeXML(trans.getOwnContact().getName())
					+ "</ram:PersonName>\n";
			if (trans.getOwnContact().getPhone() != null) {

				xml = xml + "     <ram:TelephoneUniversalCommunication>\n" + "        <ram:CompleteNumber>"
						+ encodeXML(trans.getOwnContact().getPhone()) + "</ram:CompleteNumber>\n"
						+ "     </ram:TelephoneUniversalCommunication>\n";
			}
			if (trans.getOwnContact().getEMail() != null) {

				xml = xml + "     <ram:EmailURIUniversalCommunication>\n" + "        <ram:URIID>"
						+ encodeXML(trans.getOwnContact().getEMail()) + "</ram:URIID>\n"
						+ "     </ram:EmailURIUniversalCommunication>\n";
			}
			xml = xml + "  </ram:DefinedTradeContact>";

		}

		xml = xml + "				<ram:PostalTradeAddress>\n" + "					<ram:PostcodeCode>"
				+ encodeXML(trans.getOwnZIP()) + "</ram:PostcodeCode>\n" + "					<ram:LineOne>"
				+ encodeXML(trans.getOwnStreet()) + "</ram:LineOne>\n" + "					<ram:CityName>" + encodeXML(trans.getOwnLocation())
				+ "</ram:CityName>\n" + "					<ram:CountryID>" + encodeXML(trans.getOwnCountry())
				+ "</ram:CountryID>\n" + "				</ram:PostalTradeAddress>\n"
				+ "				<ram:SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "					<ram:ID schemeID=\"FC\">" + encodeXML(trans.getOwnTaxID()) + "</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "				<ram:SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "					<ram:ID schemeID=\"VA\">" + encodeXML(trans.getOwnVATID()) + "</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "			</ram:SellerTradeParty>\n" //$NON-NLS-1$
				+ "			<ram:BuyerTradeParty>\n" //$NON-NLS-1$
				// + " <ID>GE2020211</ID>\n"
				// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>\n"
				+ "				<ram:Name>" + encodeXML(trans.getRecipient().getName()) + "</ram:Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
				// + " <DefinedTradeContact>\n"
				// + " <PersonName>xxx</PersonName>\n"
				// + " </DefinedTradeContact>\n"
				+ "				<ram:PostalTradeAddress>\n" //$NON-NLS-1$
				+ "					<ram:PostcodeCode>" + encodeXML(trans.getRecipient().getZIP()) + "</ram:PostcodeCode>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:LineOne>" + encodeXML(trans.getRecipient().getStreet()) + "</ram:LineOne>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:CityName>" + encodeXML(trans.getRecipient().getLocation()) + "</ram:CityName>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:CountryID>" + encodeXML(trans.getRecipient().getCountry()) + "</ram:CountryID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:PostalTradeAddress>\n"; //$NON-NLS-1$
		if (trans.getRecipient().getVATID() != null) {
			xml += "				<ram:SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "					<ram:ID schemeID=\"VA\">" + encodeXML(trans.getRecipient().getVATID()) + "</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:SpecifiedTaxRegistration>\n"; //$NON-NLS-1$
		}
		xml += "			</ram:BuyerTradeParty>\n" //$NON-NLS-1$
				// + " <BuyerOrderReferencedDocument>\n"
				// + " <IssueDateTime format=\"102\">20130301</IssueDateTime>\n"
				// + " <ID>2013-471331</ID>\n"
				// + " </BuyerOrderReferencedDocument>\n"
				+ "		</ram:ApplicableHeaderTradeAgreement>\n" //$NON-NLS-1$
				+ "		<ram:ApplicableHeaderTradeDelivery>\n" + "			<ram:ActualDeliverySupplyChainEvent>\n"
				+ "				<ram:OccurrenceDateTime><udt:DateTimeString format=\"102\">"
				+ zugferdDateFormat.format(trans.getDeliveryDate()) + "</udt:DateTimeString></ram:OccurrenceDateTime>\n"
				+ "			</ram:ActualDeliverySupplyChainEvent>\n"
				/*
				 * + "			<DeliveryNoteReferencedDocument>\n" +
				 * "				<IssueDateTime format=\"102\">20130603</IssueDateTime>\n" +
				 * "				<ID>2013-51112</ID>\n" +
				 * "			</DeliveryNoteReferencedDocument>\n"
				 */
				+ "		</ram:ApplicableHeaderTradeDelivery>\n" + "		<ram:ApplicableHeaderTradeSettlement>\n" //$NON-NLS-2$
				+ "			<ram:PaymentReference>" + encodeXML(trans.getNumber()) + "</ram:PaymentReference>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "			<ram:InvoiceCurrencyCode>EUR</ram:InvoiceCurrencyCode>\n"; //$NON-NLS-1$

		for (IZUGFeRDTradeSettlementPayment payment : trans.getTradeSettlementPayment()) {
			xml += "			<ram:SpecifiedTradeSettlementPaymentMeans>\n" //$NON-NLS-1$
					+ "				<ram:TypeCode>42</ram:TypeCode>\n" //$NON-NLS-1$
					+ "				<ram:Information>Überweisung</ram:Information>\n" //$NON-NLS-1$
					+ "				<ram:PayeePartyCreditorFinancialAccount>\n" //$NON-NLS-1$
					+ "					<ram:IBANID>" + encodeXML(payment.getOwnIBAN()) + "</ram:IBANID>\n"; //$NON-NLS-1$ //$NON-NLS-2$
				if (payment.getOwnKto()!=null) {
					xml+= "					<ram:ProprietaryID>" + encodeXML(payment.getOwnKto()) + "</ram:ProprietaryID>\n"; //$NON-NLS-1$ //$NON-NLS-2$
					
				}
					xml+= "				</ram:PayeePartyCreditorFinancialAccount>\n" //$NON-NLS-1$
					+ "				<ram:PayeeSpecifiedCreditorFinancialInstitution>\n" //$NON-NLS-1$
					+ "					<ram:BICID>" + encodeXML(payment.getOwnBIC()) + "</ram:BICID>\n" //$NON-NLS-1$ //$NON-NLS-2$
					// + " <ram:Name>"+trans.getOwnBankName()+"</ram:Name>\n" //$NON-NLS-1$
					// //$NON-NLS-2$
					+ "				</ram:PayeeSpecifiedCreditorFinancialInstitution>\n" //$NON-NLS-1$
					+ "			</ram:SpecifiedTradeSettlementPaymentMeans>\n"; //$NON-NLS-1$
		}

		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				xml += "			<ram:ApplicableTradeTax>\n" //$NON-NLS-1$
						+ "				<ram:CalculatedAmount>" + currencyFormat(amount.getCalculated()) //$NON-NLS-1$
						+ "</ram:CalculatedAmount>\n" //$NON-NLS-1$ //currencyID=\"EUR\"
						+ "				<ram:TypeCode>VAT</ram:TypeCode>\n" //$NON-NLS-1$
						+ "				<ram:BasisAmount>" + currencyFormat(amount.getBasis()) + "</ram:BasisAmount>\n" // currencyID=\"EUR\"
						+ "				<ram:CategoryCode>S</ram:CategoryCode>\n" //$NON-NLS-1$
						+ "				<ram:RateApplicablePercent>" + vatFormat(currentTaxPercent) //$NON-NLS-1$
						+ "</ram:RateApplicablePercent>\n" + "			</ram:ApplicableTradeTax>\n"; //$NON-NLS-2$

			}
		}
		/*
		 * xml+= " + " <SpecifiedTradeAllowanceCharge>\n" +
		 * "				<ChargeIndicator>false</ChargeIndicator>\n" +
		 * "				<BasisAmount currencyID=\"EUR\">10</BasisAmount>\n" +
		 * "				<ActualAmount>1.00</ActualAmount>\n" +
		 * "				<Reason>Sondernachlass</Reason>\n" +
		 * "				<CategoryTradeTax>\n" +
		 * "					<TypeCode>VAT</TypeCode>\n" +
		 * "					<CategoryCode>S</CategoryCode>\n" +
		 * "					<ApplicablePercent>19</ApplicablePercent>\n" +
		 * "				</CategoryTradeTax>\n" +
		 * "			</SpecifiedTradeAllowanceCharge>\n" +
		 * "			<SpecifiedTradeAllowanceCharge>\n" +
		 * "				<ChargeIndicator>false</ChargeIndicator>\n" +
		 * "				<BasisAmount currencyID=\"EUR\">137.30</BasisAmount>\n" +
		 * "				<ActualAmount>13.73</ActualAmount>\n" +
		 * "				<Reason>Sondernachlass</Reason>\n" +
		 * "				<CategoryTradeTax>\n" +
		 * "					<TypeCode>VAT</TypeCode>\n" +
		 * "					<CategoryCode>S</CategoryCode>\n" +
		 * "					<ApplicablePercent>7</ApplicablePercent>\n" +
		 * "				</CategoryTradeTax>\n" +
		 * "							</SpecifiedTradeAllowanceCharge>\n" +
		 * "			<SpecifiedLogisticsServiceCharge>\n" +
		 * "				<Description>Versandkosten</Description>\n" +
		 * "				<AppliedAmount>5.80</AppliedAmount>\n" +
		 * "				<AppliedTradeTax>\n" +
		 * "					<TypeCode>VAT</TypeCode>\n" +
		 * "					<CategoryCode>S</CategoryCode>\n" +
		 * "					<ApplicablePercent>7</ApplicablePercent>\n" +
		 * "				</AppliedTradeTax>\n" +
		 * "			</SpecifiedLogisticsServiceCharge>\n"
		 */

		xml = xml + "			<ram:SpecifiedTradePaymentTerms>\n" //$NON-NLS-1$
				+ "				<ram:Description>Zahlbar ohne Abzug bis " + germanDateFormat.format(trans.getDueDate())
				+ "</ram:Description>\n" + "				<ram:DueDateDateTime><udt:DateTimeString format=\"102\">" //$NON-NLS-2$
				+ zugferdDateFormat.format(trans.getDueDate()) + "</udt:DateTimeString></ram:DueDateDateTime>\n"// 20130704 //$NON-NLS-1$
				+ "			</ram:SpecifiedTradePaymentTerms>\n" //$NON-NLS-1$
				+ "			<ram:SpecifiedTradeSettlementHeaderMonetarySummation>\n" //$NON-NLS-1$
				+ "				<ram:LineTotalAmount>" + currencyFormat(getTotal()) + "</ram:LineTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
																													// currencyID=\"EUR\"
				+ "				<ram:ChargeTotalAmount>0.00</ram:ChargeTotalAmount>\n" //$NON-NLS-1$ currencyID=\"EUR\"
				+ "				<ram:AllowanceTotalAmount>0.00</ram:AllowanceTotalAmount>\n" //$NON-NLS-1$ //
																								// currencyID=\"EUR\"
				// + " <ChargeTotalAmount currencyID=\"EUR\">5.80</ChargeTotalAmount>\n"
				// + " <AllowanceTotalAmount currencyID=\"EUR\">14.73</AllowanceTotalAmount>\n"
				+ "				<ram:TaxBasisTotalAmount>" + currencyFormat(getTotal()) + "</ram:TaxBasisTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
																															// //
																															// currencyID=\"EUR\"
				+ "				<ram:TaxTotalAmount currencyID=\"EUR\">" //$NON-NLS-1$
				+ currencyFormat(getTotalGross().subtract(getTotal())) + "</ram:TaxTotalAmount>\n" //$NON-NLS-1$
				+ "				<ram:GrandTotalAmount>" + currencyFormat(getTotalGross()) + "</ram:GrandTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
																														// //
																														// currencyID=\"EUR\"
				+ "             <ram:TotalPrepaidAmount currencyID=\"EUR\">" + currencyFormat(getTotalPrepaid()) + "</ram:TotalPrepaidAmount>\n"
				+ "				<ram:DuePayableAmount>" + currencyFormat(getTotalGross().subtract(getTotalPrepaid())) + "</ram:DuePayableAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
																														// //
																														// currencyID=\"EUR\"
				+ "			</ram:SpecifiedTradeSettlementHeaderMonetarySummation>\n" //$NON-NLS-1$
				+ "		</ram:ApplicableHeaderTradeSettlement>\n"; //$NON-NLS-1$
		// + " <IncludedSupplyChainTradeLineItem>\n"
		// + " <AssociatedDocumentLineDocument>\n"
		// + " <IncludedNote>\n"
		// + " <Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + " </IncludedNote>\n"
		// + " </AssociatedDocumentLineDocument>\n"
		// + " </IncludedSupplyChainTradeLineItem>\n";

		xml = xml + "	</rsm:SupplyChainTradeTransaction>\n" //$NON-NLS-1$
				+ "</rsm:CrossIndustryInvoice>"; //$NON-NLS-1$

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
			Logger.getLogger(Toecount.class.getName()).log(Level.SEVERE, null, e);
		} // $NON-NLS-1$
	}

}
