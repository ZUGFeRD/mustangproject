package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.0
 * @author jstaerk
 * */


import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.HashMap;

import javax.xml.transform.TransformerException;

import org.apache.jempbox.xmp.XMPMetadata;
import org.apache.jempbox.xmp.XMPSchemaBasic;
import org.apache.jempbox.xmp.XMPSchemaDublinCore;
import org.apache.jempbox.xmp.XMPSchemaPDF;
import org.apache.jempbox.xmp.pdfa.XMPSchemaPDFAId;
import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;


public class ZUGFeRDExporter {
	/***
	 * You will need Apache PDFBox. To use the ZUGFeRD exporter, 
	   implement IZUGFeRDExportableTransaction in yourTransaction 
	   (which will require you to implement Product, Item and Contact)
	 then call
	 			doc = PDDocument.load(PDFfilename);
			// automatically add Zugferd to all outgoing invoices
			ZUGFeRDExporter ze = new ZUGFeRDExporter();
			ze.PDFmakeA3compliant(doc, "Your application name",
					System.getProperty("user.name"), true);
			ze.PDFattachZugferdFile(doc, yourTransaction);

			doc.save(PDFfilename);

	 * @author jstaerk
	 *
	 */

	


	
	//// MAIN CLASS
	
	private String conformanceLevel="U";
	private String versionStr="1.0";
	
	private String currencyFormat(BigDecimal value, char decimalDelimiter) {
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
		value=value.setScale( 2, BigDecimal.ROUND_HALF_UP ); // first, round so that e.g. 1.189999999999999946709294817992486059665679931640625 becomes 1.19  
		long totalCent = value.multiply(new BigDecimal(100)).intValue(); //now get the cents
		long eurOnly = value.longValue();
		long centOnly = Math.abs(totalCent % 100);
		StringBuffer res = new StringBuffer();
		res.append(eurOnly);
		res.append(decimalDelimiter);
		if (centOnly < 10) {
			res.append('0');
		}
		res.append(centOnly);
		return res.toString();
	}

	/**
	 	 All files are PDF/A-3, setConformance refers to the level conformance.
	 	 
	 	 PDF/A-3 has three coformance levels, called "A", "U" and "B". 

		 PDF/A-3-B where B means only visually
		 preservable, U -standard for Mustang- means visually and unicode
		 preservable and A means full compliance, i.e. visually,
		 unicode and structurally preservable and tagged PDF, i.e. useful metainformation for blind people.
		 
		 Feel free to pass "A" as new level if you know what you are doing :-)
		  

	 */
	public void setConformanceLevel(String newLevel) {
		conformanceLevel=newLevel;
	}
	
	
	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
	 * the metadata level, this will not e.g. convert graphics to JPG-2000)
	 * */
	public PDDocumentCatalog PDFmakeA3compliant(PDDocument doc, String producer, String creator, 
			boolean attachZugferdHeaders) throws IOException,
			TransformerException {
		String fullProducer=producer+"(via mustangproject.org "+versionStr+")";
		PDDocumentCatalog cat = doc.getDocumentCatalog();
		PDMetadata metadata = new PDMetadata(doc);
		cat.setMetadata(metadata);
		// we're using the jempbox org.apache.jempbox.xmp.XMPMetadata version,
		// not the xmpbox one
		XMPMetadata xmp = new XMPMetadata();

		XMPSchemaPDFAId pdfaid = new XMPSchemaPDFAId(xmp);
		pdfaid.setAbout(""); //$NON-NLS-1$
		xmp.addSchema(pdfaid);

		XMPSchemaDublinCore dc = xmp.addDublinCoreSchema();
		dc.addCreator(creator);
		dc.setAbout(""); //$NON-NLS-1$

		XMPSchemaBasic xsb = xmp.addBasicSchema();
		xsb.setAbout(""); //$NON-NLS-1$

		xsb.setCreatorTool(creator);
		xsb.setCreateDate(GregorianCalendar.getInstance());
		// PDDocumentInformation pdi=doc.getDocumentInformation();
		PDDocumentInformation pdi = new PDDocumentInformation();
		pdi.setProducer(fullProducer);
		pdi.setAuthor(creator);
		doc.setDocumentInformation(pdi);

		XMPSchemaPDF pdf = xmp.addPDFSchema();
		pdf.setProducer(fullProducer);
		pdf.setAbout(""); //$NON-NLS-1$

		/*
		// Mandatory: PDF/A3-a is tagged PDF which has to be expressed using a
		// MarkInfo dictionary (PDF A/3 Standard sec. 6.7.2.2)
		PDMarkInfo markinfo = new PDMarkInfo();
		markinfo.setMarked(true);
		doc.getDocumentCatalog().setMarkInfo(markinfo);
*/
/*
 * 	 
		To be on the safe side, we use level B without Markinfo because we can not 
		guarantee that the user  correctly tagged the templates for the PDF. 

 * */
		pdfaid.setConformance(conformanceLevel);//$NON-NLS-1$ //$NON-NLS-1$
		 
		pdfaid.setPart(3);

		if (attachZugferdHeaders) {
			addZugferdXMP(xmp); /*
								 * this is the only line where we do something
								 * Zugferd-specific, i.e. add PDF metadata
								 * specifically for Zugferd, not generically for
								 * a embedded file
								 */
		}

		metadata.importXMPMetadata(xmp);
		return cat;
	}
	
	private String getZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans) {
		SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd"); //$NON-NLS-1$
		String xml= "﻿<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" //$NON-NLS-1$
				+ "<rsm:Invoice xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:rsm=\"urn:un:unece:uncefact:data:standard:CBFBUY:5\"  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CBFBUY:5 ../Schema/Invoice.xsd\">\n" //$NON-NLS-1$
				+ "	<rsm:SpecifiedExchangedDocumentContext>\n" //$NON-NLS-1$
				+ "		<TestIndicator>false</TestIndicator>\n" //$NON-NLS-1$
				+ "		<GuidelineSpecifiedDocumentContextParameter>\n" //$NON-NLS-1$
				+ "			<ID>urn:ferd:invoice:rc:comfort</ID>\n" //$NON-NLS-1$
				+ "		</GuidelineSpecifiedDocumentContextParameter>\n" //$NON-NLS-1$
				+ "	</rsm:SpecifiedExchangedDocumentContext>\n" //$NON-NLS-1$
				+ "	<rsm:HeaderExchangedDocument>\n" //$NON-NLS-1$
				+ "		<ID>"+trans.getNumber()+"</ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "		<Name>RECHNUNG</Name>\n" //$NON-NLS-1$
				+ "		<TypeCode>380</TypeCode>\n" //$NON-NLS-1$
				+ "		<IssueDateTime format=\"102\">"+zugferdDateFormat.format(trans.getIssueDate())+"</IssueDateTime>\n" //date format was 20130605 //$NON-NLS-1$ //$NON-NLS-2$
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
				+ "	</rsm:HeaderExchangedDocument>\n" //$NON-NLS-1$
				+ "	<rsm:SpecifiedSupplyChainTradeTransaction>\n" //$NON-NLS-1$
				+ "		<ApplicableSupplyChainTradeAgreement>\n" //$NON-NLS-1$
//				+ "			<BuyerReference>AB-312</BuyerReference>\n"
				+ "			<SellerTradeParty>\n" //$NON-NLS-1$
//				+ "				<GlobalID schemeID=\"0088\">4000001123452</GlobalID>\n"
				+ "				<Name>"+trans.getOwnOrganisationName()+"</Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
/*				+ "				<PostalTradeAddress>\n"
				+ "					<PostcodeCode>80333</PostcodeCode>\n"
				+ "					<LineOne>Lieferantenstraße 20</LineOne>\n"
				+ "					<CityName>München</CityName>\n"
				+ "					<CountryID>DE</CountryID>\n"
				+ "				</PostalTradeAddress>\n"*/
				+ "				<SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "					<ID schemeID=\"FC\">"+trans.getOwnTaxID()+"</ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "				<SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "					<ID schemeID=\"VA\">"+trans.getOwnVATID()+"</ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "			</SellerTradeParty>\n" //$NON-NLS-1$
				+ "			<BuyerTradeParty>\n" //$NON-NLS-1$
//				+ "				<ID>GE2020211</ID>\n"
//				+ "				<GlobalID schemeID=\"0088\">4000001987658</GlobalID>\n"
				+ "				<Name>"+trans.getRecipient().getName()+"</Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
//				+ "				<DefinedTradeContact>\n"
//				+ "					<PersonName>xxx</PersonName>\n"
//				+ "				</DefinedTradeContact>\n"
				+ "				<PostalTradeAddress>\n" //$NON-NLS-1$
				+ "					<PostcodeCode>"+trans.getRecipient().getZIP()+"</PostcodeCode>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<LineOne>"+trans.getRecipient().getStreet()+"</LineOne>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<CityName>"+trans.getRecipient().getLocation()+"</CityName>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<CountryID>"+trans.getRecipient().getCountry()+"</CountryID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</PostalTradeAddress>\n" //$NON-NLS-1$
				+ "				<SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "					<ID schemeID=\"VA\">"+trans.getRecipient().getVATID()+"</ID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</SpecifiedTaxRegistration>\n" //$NON-NLS-1$
				+ "			</BuyerTradeParty>\n" //$NON-NLS-1$
//				+ "			<BuyerOrderReferencedDocument>\n"
//				+ "				<IssueDateTime format=\"102\">20130301</IssueDateTime>\n"
//				+ "			<ID>2013-471331</ID>\n"
//				+ "			</BuyerOrderReferencedDocument>\n"
				+ "		</ApplicableSupplyChainTradeAgreement>\n" //$NON-NLS-1$
/*				+ "		<ApplicableSupplyChainTradeDelivery>\n"
				+ "			<ActualDeliverySupplyChainEvent>\n"
				+ "				<OccurrenceDateTime format=\"102\">20130603</OccurrenceDateTime>\n"
				+ "			</ActualDeliverySupplyChainEvent>\n"
				+ "			<DeliveryNoteReferencedDocument>\n"
				+ "				<IssueDateTime format=\"102\">20130603</IssueDateTime>\n"
				+ "				<ID>2013-51112</ID>\n"
				+ "			</DeliveryNoteReferencedDocument>\n"
				+ "		</ApplicableSupplyChainTradeDelivery>\n"*/
				+ "		<ApplicableSupplyChainTradeSettlement>\n" //$NON-NLS-1$
				// it's unclear if this is supposed to refer to the SEPA mandate or the transaction purpose
//				+ "			<PaymentReference>"+trans.getNumber()+"</PaymentReference>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "			<InvoiceCurrencyCode>EUR</InvoiceCurrencyCode>\n" //$NON-NLS-1$
				+ "			<SpecifiedTradeSettlementPaymentMeans>\n" //$NON-NLS-1$
				+ "				<TypeCode>42</TypeCode>\n" //$NON-NLS-1$
				+ "				<Information>Überweisung</Information>\n" //$NON-NLS-1$
				+ "				<PayeePartyCreditorFinancialAccount>\n" //$NON-NLS-1$
				+ "					<IBANID>"+trans.getOwnIBAN()+"</IBANID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</PayeePartyCreditorFinancialAccount>\n" //$NON-NLS-1$
				+ "				<PayeeSpecifiedCreditorFinancialInstitution>\n" //$NON-NLS-1$
				+ "					<BICID>"+trans.getOwnBIC()+"</BICID>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "					<Name>"+trans.getOwnBankName()+"</Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				</PayeeSpecifiedCreditorFinancialInstitution>\n" //$NON-NLS-1$
				+ "			</SpecifiedTradeSettlementPaymentMeans>\n"; //$NON-NLS-1$
				
		
		
		HashMap<BigDecimal, BigDecimal> VATPercentAmountMap=trans.getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
			BigDecimal amount = VATPercentAmountMap.get(currentTaxPercent);
			if (amount != null) {
				xml += "			<ApplicableTradeTax>\n" //$NON-NLS-1$
								+ "				<CalculatedAmount currencyID=\"EUR\">"+currencyFormat(amount, '.')+"</CalculatedAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
								+ "				<TypeCode>VAT</TypeCode>\n" //$NON-NLS-1$
//								+ "				<BasisAmount currencyID=\"EUR\">129.37</BasisAmount>\n"
								+ "				<CategoryCode>S</CategoryCode>\n" //$NON-NLS-1$
								+ "				<ApplicablePercent>"+currentTaxPercent+"</ApplicablePercent>\n" //$NON-NLS-1$
								+ "			</ApplicableTradeTax>\n"; //$NON-NLS-1$


	
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
		
				xml=xml+ "			<SpecifiedTradePaymentTerms>\n" //$NON-NLS-1$
//				+ "				<Description>Zahlbar innerhalb 30 Tagen netto bis 04.07.2013, 3% Skonto innerhalb 10 Tagen bis 15.06.2013</Description>\n"
				+ "				<DueDateDateTime format=\"102\">"+zugferdDateFormat.format(trans.getDueDate())+"</DueDateDateTime>\n"//20130704 //$NON-NLS-1$ //$NON-NLS-2$
				+ "			</SpecifiedTradePaymentTerms>\n" //$NON-NLS-1$
				+ "			<SpecifiedTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
				+ "				<LineTotalAmount currencyID=\"EUR\">"+currencyFormat(trans.getTotal(), '.')+"</LineTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
//				+ "				<ChargeTotalAmount currencyID=\"EUR\">5.80</ChargeTotalAmount>\n"
//				+ "				<AllowanceTotalAmount currencyID=\"EUR\">14.73</AllowanceTotalAmount>\n"
				+ "				<TaxBasisTotalAmount currencyID=\"EUR\">"+currencyFormat(trans.getTotal(), '.')+"</TaxBasisTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				<TaxTotalAmount currencyID=\"EUR\">"+currencyFormat(trans.getTotalGross().subtract(trans.getTotal()), '.')+"</TaxTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "				<GrandTotalAmount currencyID=\"EUR\">"+currencyFormat(trans.getTotalGross(), '.')+"</GrandTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
//				+ "				<TotalPrepaidAmount currencyID=\"EUR\">0.00</TotalPrepaidAmount>\n"
				+ "				<DuePayableAmount currencyID=\"EUR\">"+currencyFormat(trans.getTotalGross(), '.')+"</DuePayableAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
				+ "			</SpecifiedTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
				+ "		</ApplicableSupplyChainTradeSettlement>\n"; //$NON-NLS-1$
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
					xml=xml+ "		<IncludedSupplyChainTradeLineItem>\n"+ //$NON-NLS-1$
					"			<AssociatedDocumentLineDocument>\n" //$NON-NLS-1$
							+ "				<LineID>"+lineID+"</LineID>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "			</AssociatedDocumentLineDocument>\n" //$NON-NLS-1$
							
							+ "			<SpecifiedSupplyChainTradeAgreement>\n" //$NON-NLS-1$
							+ "				<GrossPriceProductTradePrice>\n" //$NON-NLS-1$
							+ "					<ChargeAmount currencyID=\"EUR\">"+currencyFormat(currentItem.getPriceGross(),'.')+"</ChargeAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "					<BasisQuantity unitCode=\""+currentItem.getProduct().getUnit()+"\">1</BasisQuantity>\n" //$NON-NLS-1$ //$NON-NLS-2$
//							+ "					<AppliedTradeAllowanceCharge>\n"
//							+ "						<ChargeIndicator>false</ChargeIndicator>\n"
//							+ "						<ActualAmount currencyID=\"EUR\">0.6667</ActualAmount>\n"
//							+ "						<Reason>Rabatt</Reason>\n"
//							+ "					</AppliedTradeAllowanceCharge>\n"
							+ "				</GrossPriceProductTradePrice>\n" //$NON-NLS-1$
							+ "				<NetPriceProductTradePrice>\n" //$NON-NLS-1$
							+ "					<ChargeAmount currencyID=\"EUR\">"+currencyFormat(currentItem.getPrice(),'.')+"</ChargeAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "					<BasisQuantity unitCode=\""+currentItem.getProduct().getUnit()+"\">1</BasisQuantity>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				</NetPriceProductTradePrice>\n" //$NON-NLS-1$
							+ "			</SpecifiedSupplyChainTradeAgreement>\n" //$NON-NLS-1$
							
							+ "			<SpecifiedSupplyChainTradeDelivery>\n" //$NON-NLS-1$
							+ "				<BilledQuantity unitCode=\""+currentItem.getProduct().getUnit()+"\">"+currentItem.getQuantity()+"</BilledQuantity>\n" //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
							+ "			</SpecifiedSupplyChainTradeDelivery>\n" //$NON-NLS-1$
							+ "			<SpecifiedSupplyChainTradeSettlement>\n" //$NON-NLS-1$
							+ "				<ApplicableTradeTax>\n" //$NON-NLS-1$
							+ "					<TypeCode>VAT</TypeCode>\n" //$NON-NLS-1$
							+ "					<CategoryCode>S</CategoryCode>\n" //$NON-NLS-1$
							+ "					<ApplicablePercent>"+currentItem.getProduct().getVATPercent()+"</ApplicablePercent>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				</ApplicableTradeTax>\n" //$NON-NLS-1$
							+ "				<SpecifiedTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
							+ "					<LineTotalAmount currencyID=\"EUR\">"+currencyFormat(currentItem.getTotalGross(),'.')+"</LineTotalAmount>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				</SpecifiedTradeSettlementMonetarySummation>\n" //$NON-NLS-1$
							+ "			</SpecifiedSupplyChainTradeSettlement>\n" //$NON-NLS-1$
							+ "			<SpecifiedTradeProduct>\n" //$NON-NLS-1$
//							+ "				<GlobalID schemeID=\"0160\">4012345001235</GlobalID>\n"
//							+ "				<SellerAssignedID>KR3M</SellerAssignedID>\n"
//							+ "				<BuyerAssignedID>55T01</BuyerAssignedID>\n"
							+ "				<Name>"+currentItem.getProduct().getName()+"</Name>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "				<Description>"+currentItem.getProduct().getDescription()+"</Description>\n" //$NON-NLS-1$ //$NON-NLS-2$
							+ "			</SpecifiedTradeProduct>\n" //$NON-NLS-1$
							+ "		</IncludedSupplyChainTradeLineItem>\n"; //$NON-NLS-1$
							
								
					
				}
				
				
				xml=xml	+ "	</rsm:SpecifiedSupplyChainTradeTransaction>\n" //$NON-NLS-1$
				+ "</rsm:Invoice>"; //$NON-NLS-1$
				return xml;
	}

	/**
	 * embed the Zugferd XML structure in a file named ZUGFeRD-invoice.xml
	 * */
	public void PDFattachZugferdFile(PDDocument doc, IZUGFeRDExportableTransaction trans) throws IOException {

		// embedded files are stored in a named tree
		PDEmbeddedFilesNameTreeNode efTree = new PDEmbeddedFilesNameTreeNode();

		String filename="ZUGFeRD-invoice.xml"; //$NON-NLS-1$
		// first create the file specification, which holds the embedded file
		PDComplexFileSpecification fs = new PDComplexFileSpecification();
		fs.setFile(filename);

		COSDictionary dict = fs.getCOSDictionary();
		// Relation "Source" for linking with eg. catalog
		dict.setName("AFRelationship", "Alternative"); // as defined in Zugferd standard //$NON-NLS-1$ //$NON-NLS-2$

		dict.setString("UF", filename); //$NON-NLS-1$

		// create a dummy file stream, this would probably normally be a
		// FileInputStream
		
		byte[] zugferdRaw = getZugferdXMLForTransaction(trans).getBytes("UTF-8"); //$NON-NLS-1$
		  
		byte[] zugferdData;
		
        
        		
		if ((zugferdRaw[0]==(byte)0xEF)&&(zugferdRaw[1]==(byte)0xBB)&&(zugferdRaw[2]==(byte)0xBF)) {
			// I don't like BOMs, lets remove it
			zugferdData=new byte[zugferdRaw.length-3];
			System.arraycopy(zugferdRaw,3,zugferdData,0,zugferdRaw.length-3);
		}	else {
			zugferdData=zugferdRaw;			
		}
		  
		ByteArrayInputStream fakeFile = new ByteArrayInputStream(zugferdData);
		PDEmbeddedFile ef = new PDEmbeddedFile(doc, fakeFile);
		// now lets some of the optional parameters
		ef.setSubtype("text/xml");// as defined in Zugferd standard //$NON-NLS-1$
		ef.setSize(zugferdData.length);
		ef.setCreationDate(new GregorianCalendar());

		ef.setModDate(GregorianCalendar.getInstance());

		fs.setEmbeddedFile(ef);

		// now add the entry to the embedded file tree and set in the document.
		efTree.setNames(Collections.singletonMap(filename, fs));
		PDDocumentNameDictionary names = new PDDocumentNameDictionary(
				doc.getDocumentCatalog());
		names.setEmbeddedFiles(efTree);
		doc.getDocumentCatalog().setNames(names);
		// AF entry (Array) in catalog with the FileSpec
		COSArray cosArray = new COSArray();
		cosArray.add(fs);
		doc.getDocumentCatalog().getCOSDictionary().setItem("AF", cosArray); //$NON-NLS-1$

	}

/***
 * This will add both the RDF-indication which embedded file is Zugferd and the 
 * neccessary PDF/A schema extension description to be able to add this information to RDF 
 * @param metadata
 */
	private void addZugferdXMP(XMPMetadata metadata) {

		XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata);
		zf.setAbout(""); //$NON-NLS-1$
		metadata.addSchema(zf);

		XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata);
		pdfaex.setAbout(""); //$NON-NLS-1$
		metadata.addSchema(pdfaex);

	}

}
