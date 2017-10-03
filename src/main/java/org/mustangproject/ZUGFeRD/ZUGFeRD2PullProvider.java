package org.mustangproject.ZUGFeRD;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;

public class ZUGFeRD2PullProvider implements IXMLProvider {

	private class LineCalc {
		private IZUGFeRDExportableItem currentItem=null;
		private BigDecimal totalGross;
		private BigDecimal itemTotalNetAmount;
		private BigDecimal itemTotalVATAmount;
		
		public LineCalc(IZUGFeRDExportableItem currentItem) {
			this.currentItem=currentItem;
			BigDecimal multiplicator=currentItem.getProduct().getVATPercent().divide(new BigDecimal(100)).add(new BigDecimal(1));
//			priceGross=currentItem.getPrice().multiply(multiplicator);
			totalGross=currentItem.getPrice().multiply(multiplicator).multiply(currentItem.getQuantity());
			itemTotalNetAmount=currentItem.getQuantity().multiply(currentItem.getPrice()).setScale(2,BigDecimal.ROUND_HALF_UP);
			itemTotalVATAmount=totalGross.subtract(itemTotalNetAmount);
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
	private boolean isTest;

	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 *
	 */
	public void setTest() {
		isTest = true;
	}
	
	private String nDigitFormat(BigDecimal value, int scale) {
		/*
		 * I needed 123,45, locale independent.I tried
		 * NumberFormat.getCurrencyInstance().format( 12345.6789 ); but that is
		 * locale specific.I also tried DecimalFormat df = new DecimalFormat(
		 * "0,00" ); df.setDecimalSeparatorAlwaysShown(true);
		 * df.setGroupingUsed(false); DecimalFormatSymbols symbols = new
		 * DecimalFormatSymbols(); symbols.setDecimalSeparator(',');
		 * symbols.setGroupingSeparator(' ');
		 * df.setDecimalFormatSymbols(symbols);
		 *
		 * but that would not switch off grouping. Although I liked very much
		 * the (incomplete) "BNF diagram" in
		 * http://docs.oracle.com/javase/tutorial/i18n/format/decimalFormat.html
		 * in the end I decided to calculate myself and take eur+sparator+cents
		 *
		 * This function will cut off, i.e. floor() subcent values Tests:
		 * System.err.println(utils.currencyFormat(new BigDecimal(0),
		 * ".")+"\n"+utils.currencyFormat(new BigDecimal("-1.10"),
		 * ",")+"\n"+utils.currencyFormat(new BigDecimal("-1.1"),
		 * ",")+"\n"+utils.currencyFormat(new BigDecimal("-1.01"),
		 * ",")+"\n"+utils.currencyFormat(new BigDecimal("20000123.3489"),
		 * ",")+"\n"+utils.currencyFormat(new BigDecimal("20000123.3419"),
		 * ",")+"\n"+utils.currencyFormat(new BigDecimal("12"), ","));
		 *
		 * results 0.00 -1,10 -1,10 -1,01 20000123,34 20000123,34 12,00
		 */
		value=value.setScale( scale, BigDecimal.ROUND_HALF_UP ); // first, round so that e.g. 1.189999999999999946709294817992486059665679931640625 becomes 1.19
		char[] repeat = new char[scale];
		Arrays.fill(repeat, '0');
		
		DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols();
		otherSymbols.setDecimalSeparator('.');
		DecimalFormat dec = new DecimalFormat("0."+new String(repeat), otherSymbols);
		return dec.format(value);
		
	}

	private String vatFormat(BigDecimal value) {
		return nDigitFormat(value, 2);
	}

	private String currencyFormat(BigDecimal value) {
		return nDigitFormat(value, 2);
	}

	private String priceFormat(BigDecimal value) {
		return nDigitFormat(value, 4);
	}
	private String quantityFormat(BigDecimal value) {
		return nDigitFormat(value, 4);
	}

	@Override
	public byte[] getXML() {
		// TODO Auto-generated method stub
		return null;
	}

	
	


	private BigDecimal getTotalGross() {
		
		BigDecimal res=getTotal();
		HashMap<BigDecimal, VATAmount> VATPercentAmountMap=getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			res=res.add(amount.getCalculated()); 
		}

			
		return res;
	}

	private BigDecimal getTotal() {
		BigDecimal res=new BigDecimal(0);
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			LineCalc lc=new LineCalc(currentItem);
			res=res.add(lc.getItemTotalNetAmount());
		}
		return res;
	}

	/**
	 * which taxes have been used with which amounts in this transaction,
	 * empty for no taxes, or e.g. 19=>190 and 7=>14 if 1000 Eur were applicable
	 * to 19% VAT (=>190 EUR VAT) and 200 EUR were applicable to 7% (=>14 EUR VAT)
	 * 190 Eur  
	 * @return
	 *
	*/
	private HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
		HashMap<BigDecimal, VATAmount> hm=new HashMap<BigDecimal, VATAmount> ();
		
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			BigDecimal percent=currentItem.getProduct().getVATPercent();
			LineCalc lc=new LineCalc(currentItem);
			VATAmount itemVATAmount=new VATAmount(lc.getItemTotalNetAmount(), lc.getItemTotalVATAmount() ) ;
			VATAmount current=hm.get(percent);
			if (current==null) {
				hm.put(percent, itemVATAmount);
			} else {
				hm.put(percent, current.add(itemVATAmount));
				
			}
		}

		return hm;
	}

	
	@Override
	public void generateXML(IZUGFeRDExportableTransaction trans) {

		this.trans=trans;
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy"); //$NON-NLS-1$
		SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd"); //$NON-NLS-1$
		String testBooleanStr="false";
		if (isTest) {
			testBooleanStr="true";
			
		}
		String senderReg="";
		if (trans.getOwnOrganisationFullPlaintextInfo()!=null) {
		 senderReg=""
					+ "<ram:IncludedCINote>\n"
					+ "		<ram:Content>\n"
					+ trans.getOwnOrganisationFullPlaintextInfo()
					+ "		</ram:Content>\n"
					+ "<ram:SubjectCode>REG</ram:SubjectCode>\n"
					+ "</ram:IncludedCINote>\n";
			
		}
		String xml= "﻿<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" //$NON-NLS-1$

				+ "<rsm:CrossIndustryInvoice xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:13\""
//				+ " xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:13 ../Schema/ZUGFeRD1p0.xsd\""
				+ " xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:20\""
				+ " xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:20\">\n" //$NON-NLS-1$
				+ "	<rsm:CIExchangedDocumentContext>\n" //$NON-NLS-1$
				+ "		\n" //$NON-NLS-1$
				+ "		<ram:GuidelineSpecifiedCIDocumentContextParameter>\n" //$NON-NLS-1$
				+ "			<ram:ID>urn:ferd:CrossIndustryDocument:invoice:1p0:comfort</ram:ID>\n" //$NON-NLS-1$
				+ "		</ram:GuidelineSpecifiedCIDocumentContextParameter>\n" //$NON-NLS-1$
				+ "	</rsm:CIExchangedDocumentContext>\n" //$NON-NLS-1$
				+ "	<rsm:CIIHExchangedDocument>\n" //$NON-NLS-1$
				+ "		<ram:ID>"+trans.getNumber()+"</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "		<ram:Name>RECHNUNG</ram:Name>\n" //$NON-NLS-1$
				+ "		<ram:TypeCode>380</ram:TypeCode>\n" //$NON-NLS-1$
				+ "		<ram:IssueDateTime><udt:DateTimeString format=\"102\">"+zugferdDateFormat.format(trans.getIssueDate())+"</udt:DateTimeString></ram:IssueDateTime>\n" //date format was 20130605 //$NON-NLS-1$ //$NON-NLS-2$
				+ senderReg
//				+ "		<IncludedNote>\n"
//				+ "			<Content>\n"
//				+ "Rechnung gemäß Bestellung Nr. 2013-471331 vom 01.03.2013.\n"
//				+ "\n"
//				+ "      </Content>\n"
//				+ "      </IncludedNote>\n"
//				+ "      <IncludedNote>\n"
//				+ "			<Content>\n"
//				+ "Es bestehen Rabatt- und Bonusvereinbarungen.\n"
//				+ "			</Content>\n"
//				+ "			<SubjectCode>AAK</SubjectCode>\n"
//				+ "		</IncludedNote>\n"
				+ "	</rsm:CIIHExchangedDocument>\n" //$NON-NLS-1$
				+ "	<rsm:CIIHSupplyChainTradeTransaction>\n" //$NON-NLS-1$
				+ "		<ram:ApplicableCIIHSupplyChainTradeAgreement>\n" //$NON-NLS-1$
//				+ "			<BuyerReference>AB-312</BuyerReference>\n"
				+ "			<ram:SellerCITradeParty>\n" //$NON-NLS-1$
//				+ "				<GlobalID schemeID=\"0088\">4000001123452</GlobalID>\n"
				+ "				<ram:Name>"+trans.getOwnOrganisationName()+"</ram:Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				<ram:PostalCITradeAddress>\n"
				+ "					<ram:PostcodeCode>"+trans.getOwnZIP()+"</ram:PostcodeCode>\n"
				+ "					<ram:LineOne>"+trans.getOwnStreet()+"</ram:LineOne>\n"
				+ "					<ram:CityName>"+trans.getOwnLocation()+"</ram:CityName>\n"
				+ "					<ram:CountryID>"+trans.getOwnCountry()+"</ram:CountryID>\n"
				+ "				</ram:PostalCITradeAddress>\n"
				+ "				<ram:SpecifiedCITaxRegistration>\n" //$NON-NLS-1$
				+ "					<ram:ID schemeID=\"FC\">"+trans.getOwnTaxID()+"</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:SpecifiedCITaxRegistration>\n" //$NON-NLS-1$
				+ "				<ram:SpecifiedCITaxRegistration>\n" //$NON-NLS-1$
				+ "					<ram:ID schemeID=\"VA\">"+trans.getOwnVATID()+"</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:SpecifiedCITaxRegistration>\n" //$NON-NLS-1$
				+ "			</ram:SellerCITradeParty>\n" //$NON-NLS-1$
				+ "			<ram:BuyerCITradeParty>\n" //$NON-NLS-1$
//				+ "				<ID>GE2020211</ID>\n"
//				+ "				<GlobalID schemeID=\"0088\">4000001987658</GlobalID>\n"
				+ "				<ram:Name>"+trans.getRecipient().getName()+"</ram:Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
//				+ "				<DefinedTradeContact>\n"
//				+ "					<PersonName>xxx</PersonName>\n"
//				+ "				</DefinedTradeContact>\n"
				+ "				<ram:PostalCITradeAddress>\n" //$NON-NLS-1$
				+ "					<ram:PostcodeCode>"+trans.getRecipient().getZIP()+"</ram:PostcodeCode>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:LineOne>"+trans.getRecipient().getStreet()+"</ram:LineOne>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:CityName>"+trans.getRecipient().getLocation()+"</ram:CityName>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:CountryID>"+trans.getRecipient().getCountry()+"</ram:CountryID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:PostalCITradeAddress>\n" //$NON-NLS-1$
				+ "				<ram:SpecifiedCITaxRegistration>\n" //$NON-NLS-1$
				+ "					<ram:ID schemeID=\"VA\">"+trans.getRecipient().getVATID()+"</ram:ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:SpecifiedCITaxRegistration>\n" //$NON-NLS-1$
				+ "			</ram:BuyerCITradeParty>\n" //$NON-NLS-1$
//				+ "			<BuyerOrderReferencedDocument>\n"
//				+ "				<IssueDateTime format=\"102\">20130301</IssueDateTime>\n"
//				+ "			<ID>2013-471331</ID>\n"
//				+ "			</BuyerOrderReferencedDocument>\n"
				+ "		</ram:ApplicableCIIHSupplyChainTradeAgreement>\n" //$NON-NLS-1$
				+ "		<ram:ApplicableCIIHSupplyChainTradeDelivery>\n"
				+ "			<ram:ActualDeliveryCISupplyChainEvent>\n"
				+ "				<ram:OccurrenceDateTime><udt:DateTimeString format=\"102\">"+zugferdDateFormat.format(trans.getDeliveryDate())+"</udt:DateTimeString></ram:OccurrenceDateTime>\n"
				+ "			</ram:ActualDeliveryCISupplyChainEvent>\n"
				/*
				+ "			<DeliveryNoteReferencedDocument>\n"
				+ "				<IssueDateTime format=\"102\">20130603</IssueDateTime>\n"
				+ "				<ID>2013-51112</ID>\n"
				+ "			</DeliveryNoteReferencedDocument>\n" */
				+ "		</ram:ApplicableCIIHSupplyChainTradeDelivery>\n"
				+ "		<ram:ApplicableCIIHSupplyChainTradeSettlement>\n" //$NON-NLS-1$
				+ "			<ram:PaymentReference>"+trans.getNumber()+"</ram:PaymentReference>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "			<ram:InvoiceCurrencyCode>EUR</ram:InvoiceCurrencyCode>\n" //$NON-NLS-1$
				+ "			<ram:SpecifiedCITradeSettlementPaymentMeans>\n" //$NON-NLS-1$
				+ "				<ram:TypeCode>42</ram:TypeCode>\n" //$NON-NLS-1$
				+ "				<ram:Information>Überweisung</ram:Information>\n" //$NON-NLS-1$
				+ "				<ram:PayeePartyCICreditorFinancialAccount>\n" //$NON-NLS-1$
				+ "					<ram:IBANID>"+trans.getOwnIBAN()+"</ram:IBANID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:PayeePartyCICreditorFinancialAccount>\n" //$NON-NLS-1$
				+ "				<ram:PayeeSpecifiedCICreditorFinancialInstitution>\n" //$NON-NLS-1$
				+ "					<ram:BICID>"+trans.getOwnBIC()+"</ram:BICID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<ram:Name>"+trans.getOwnBankName()+"</ram:Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</ram:PayeeSpecifiedCICreditorFinancialInstitution>\n" //$NON-NLS-1$
				+ "			</ram:SpecifiedCITradeSettlementPaymentMeans>\n"; //$NON-NLS-1$


		
		HashMap<BigDecimal, VATAmount> VATPercentAmountMap=getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				xml += "			<ram:ApplicableCITradeTax>\n" //$NON-NLS-1$
								+ "				<ram:CalculatedAmount currencyID=\"EUR\">"+currencyFormat(amount.getCalculated())+"</ram:CalculatedAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
								+ "				<ram:TypeCode>VAT</ram:TypeCode>\n" //$NON-NLS-1$
								+ "				<ram:BasisAmount currencyID=\"EUR\">"+currencyFormat(amount.getBasis())+"</ram:BasisAmount>\n"
								+ "				<ram:CategoryCode>S</ram:CategoryCode>\n" //$NON-NLS-1$
								+ "				<ram:RateApplicablePercent>"+vatFormat(currentTaxPercent)+"</ram:RateApplicablePercent>\n" //$NON-NLS-1$
								+ "			</ram:ApplicableCITradeTax>\n"; //$NON-NLS-1$



			}
		}
/*				xml+= "
				+ "			<SpecifiedTradeAllowanceCharge>\n"
				+ "				<ChargeIndicator>false</ChargeIndicator>\n"
				+ "				<BasisAmount currencyID=\"EUR\">10</BasisAmount>\n"
				+ "				<ActualAmount>1.00</ActualAmount>\n"
				+ "				<Reason>Sondernachlass</Reason>\n"
				+ "				<CategoryTradeTax>\n"
				+ "					<TypeCode>VAT</TypeCode>\n"
				+ "					<CategoryCode>S</CategoryCode>\n"
				+ "					<ApplicablePercent>19</ApplicablePercent>\n"
				+ "				</CategoryTradeTax>\n"
				+ "			</SpecifiedTradeAllowanceCharge>\n"
				+ "			<SpecifiedTradeAllowanceCharge>\n"
				+ "				<ChargeIndicator>false</ChargeIndicator>\n"
				+ "				<BasisAmount currencyID=\"EUR\">137.30</BasisAmount>\n"
				+ "				<ActualAmount>13.73</ActualAmount>\n"
				+ "				<Reason>Sondernachlass</Reason>\n"
				+ "				<CategoryTradeTax>\n"
				+ "					<TypeCode>VAT</TypeCode>\n"
				+ "					<CategoryCode>S</CategoryCode>\n"
				+ "					<ApplicablePercent>7</ApplicablePercent>\n"
				+ "				</CategoryTradeTax>\n"
				+ "							</SpecifiedTradeAllowanceCharge>\n"
				+ "			<SpecifiedLogisticsServiceCharge>\n"
				+ "				<Description>Versandkosten</Description>\n"
				+ "				<AppliedAmount>5.80</AppliedAmount>\n"
				+ "				<AppliedTradeTax>\n"
				+ "					<TypeCode>VAT</TypeCode>\n"
				+ "					<CategoryCode>S</CategoryCode>\n"
				+ "					<ApplicablePercent>7</ApplicablePercent>\n"
				+ "				</AppliedTradeTax>\n"
				+ "			</SpecifiedLogisticsServiceCharge>\n"*/

				xml=xml+ "			<ram:SpecifiedCITradePaymentTerms>\n" //$NON-NLS-1$
				+ "				<ram:Description>Zahlbar ohne Abzug bis "+germanDateFormat.format(trans.getDueDate())+"</ram:Description>\n"
				+ "				<ram:DueDateDateTime><udt:DateTimeString format=\"102\">"+zugferdDateFormat.format(trans.getDueDate())+"</udt:DateTimeString></ram:DueDateDateTime>\n"//20130704 //$NON-NLS-1$ //$NON-NLS-2$
				+ "			</ram:SpecifiedCITradePaymentTerms>\n" //$NON-NLS-1$
				+ "			<ram:SpecifiedCIIHTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
				+ "				<ram:LineTotalAmount currencyID=\"EUR\">"+currencyFormat(getTotal())+"</ram:LineTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				<ram:ChargeTotalAmount currencyID=\"EUR\">0.00</ram:ChargeTotalAmount>\n" //$NON-NLS-1$
				+ "				<ram:AllowanceTotalAmount currencyID=\"EUR\">0.00</ram:AllowanceTotalAmount>\n" //$NON-NLS-1$
//				+ "				<ChargeTotalAmount currencyID=\"EUR\">5.80</ChargeTotalAmount>\n"
//				+ "				<AllowanceTotalAmount currencyID=\"EUR\">14.73</AllowanceTotalAmount>\n"
				+ "				<ram:TaxBasisTotalAmount currencyID=\"EUR\">"+currencyFormat(getTotal())+"</ram:TaxBasisTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				<ram:TaxTotalAmount currencyID=\"EUR\">"+currencyFormat(getTotalGross().subtract(getTotal()))+"</ram:TaxTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				<ram:GrandTotalAmount currencyID=\"EUR\">"+currencyFormat(getTotalGross())+"</ram:GrandTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
//				+ "				<TotalPrepaidAmount currencyID=\"EUR\">0.00</TotalPrepaidAmount>\n"
				+ "				<ram:DuePayableAmount currencyID=\"EUR\">"+currencyFormat(getTotalGross())+"</ram:DuePayableAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "			</ram:SpecifiedCIIHTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
				+ "		</ram:ApplicableCIIHSupplyChainTradeSettlement>\n"; //$NON-NLS-1$
//				+ "		<IncludedSupplyChainTradeLineItem>\n"
//				+ "			<AssociatedDocumentLineDocument>\n"
//				+ "				<IncludedNote>\n"
//				+ "					<Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr. 2013-51112 in Rechnung zu stellen:</Content>\n"
//				+ "				</IncludedNote>\n"
//				+ "			</AssociatedDocumentLineDocument>\n"
//				+ "		</IncludedSupplyChainTradeLineItem>\n";


				int lineID=0;
				for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
					lineID++;

					LineCalc lc=new LineCalc(currentItem);
					xml=xml+ "		<ram:IncludedCIILSupplyChainTradeLineItem>\n"+ //$NON-NLS-1$
					"			<ram:AssociatedCIILDocumentLineDocument>\n" //$NON-NLS-1$
							+ "				<ram:LineID>"+lineID+"</ram:LineID>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "			</ram:AssociatedCIILDocumentLineDocument>\n" //$NON-NLS-1$

							+ "			<ram:SpecifiedCIILSupplyChainTradeAgreement>\n" //$NON-NLS-1$
							+ "				<ram:GrossPriceProductCITradePrice>\n" //$NON-NLS-1$
							+ "					<ram:ChargeAmount currencyID=\"EUR\">"+priceFormat(currentItem.getPrice())+"</ram:ChargeAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "					<ram:BasisQuantity unitCode=\""+currentItem.getProduct().getUnit()+"\">1.0000</ram:BasisQuantity>\n" //$NON-NLS-1$ //$NON-NLS-2$
//							+ "					<AppliedTradeAllowanceCharge>\n"
//							+ "						<ChargeIndicator>false</ChargeIndicator>\n"
//							+ "						<ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
//							+ "						<Reason>Rabatt</Reason>\n"
//							+ "					</AppliedTradeAllowanceCharge>\n"
							+ "				</ram:GrossPriceProductCITradePrice>\n" //$NON-NLS-1$
							+ "				<ram:NetPriceProductCITradePrice>\n" //$NON-NLS-1$
							+ "					<ram:ChargeAmount currencyID=\"EUR\">"+priceFormat(currentItem.getPrice())+"</ram:ChargeAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "					<ram:BasisQuantity unitCode=\""+currentItem.getProduct().getUnit()+"\">1.0000</ram:BasisQuantity>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				</ram:NetPriceProductCITradePrice>\n" //$NON-NLS-1$
							+ "			</ram:SpecifiedCIILSupplyChainTradeAgreement>\n" //$NON-NLS-1$

							+ "			<ram:SpecifiedCIILSupplyChainTradeDelivery>\n" //$NON-NLS-1$
							+ "				<ram:BilledQuantity unitCode=\""+currentItem.getProduct().getUnit()+"\">"+quantityFormat(currentItem.getQuantity())+"</ram:BilledQuantity>\n" //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
							+ "			</ram:SpecifiedCIILSupplyChainTradeDelivery>\n" //$NON-NLS-1$
							+ "			<ram:SpecifiedCIILSupplyChainTradeSettlement>\n" //$NON-NLS-1$
							+ "				<ram:ApplicableCITradeTax>\n" //$NON-NLS-1$
							+ "					<ram:TypeCode>VAT</ram:TypeCode>\n" //$NON-NLS-1$
							+ "					<ram:CategoryCode>S</ram:CategoryCode>\n" //$NON-NLS-1$
							+ "					<ram:RateApplicablePercent>"+vatFormat(currentItem.getProduct().getVATPercent())+"</ram:RateApplicablePercent>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				</ram:ApplicableCITradeTax>\n" //$NON-NLS-1$
							+ "				<ram:SpecifiedCIILTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
							+ "					<ram:LineTotalAmount currencyID=\"EUR\">"+currencyFormat(lc.getItemTotalNetAmount())+"</ram:LineTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				</ram:SpecifiedCIILTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
							+ "			</ram:SpecifiedCIILSupplyChainTradeSettlement>\n" //$NON-NLS-1$
							+ "			<ram:SpecifiedCITradeProduct>\n" //$NON-NLS-1$
//							+ "				<GlobalID schemeID=\"0160\">4012345001235</GlobalID>\n"
//							+ "				<SellerAssignedID>KR3M</SellerAssignedID>\n"
//							+ "				<BuyerAssignedID>55T01</BuyerAssignedID>\n"
							+ "				<ram:Name>"+currentItem.getProduct().getName()+"</ram:Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				<ram:Description>"+currentItem.getProduct().getDescription()+"</ram:Description>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "			</ram:SpecifiedCITradeProduct>\n" //$NON-NLS-1$
							+ "		</ram:IncludedCIILSupplyChainTradeLineItem>\n"; //$NON-NLS-1$



				}


				xml=xml	+ "	</rsm:CIIHSupplyChainTradeTransaction>\n" //$NON-NLS-1$
				+ "</rsm:CrossIndustryInvoice>"; //$NON-NLS-1$
				byte[] zugferdRaw;
				try {
					zugferdRaw = xml.getBytes("UTF-8");

				if ((zugferdRaw[0]==(byte)0xEF)&&(zugferdRaw[1]==(byte)0xBB)&&(zugferdRaw[2]==(byte)0xBF)) {
					// I don't like BOMs, lets remove it
					zugferdData=new byte[zugferdRaw.length-3];
					System.arraycopy(zugferdRaw,3,zugferdData,0,zugferdRaw.length-3);
				}	else {
					zugferdData=zugferdRaw;
				}
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} //$NON-NLS-1$
	}

}
