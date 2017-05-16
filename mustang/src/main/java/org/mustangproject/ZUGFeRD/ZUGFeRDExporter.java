package org.mustangproject.ZUGFeRD;

/**
 * Mustangproject's ZUGFeRD implementation ZUGFeRD exporter Licensed under the
 * APLv2
 *
 * @date 2014-07-12
 * @version 1.2.0
 * @author jstaerk
 *
 */
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.activation.FileDataSource;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.transform.TransformerException;


import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.XMPBasicSchema;
import org.apache.xmpbox.schema.DublinCoreSchema;
import org.apache.xmpbox.schema.AdobePDFSchema;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.ValidationResult;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;
import org.apache.pdfbox.preflight.utils.ByteArrayDataSource;
import org.apache.xmpbox.type.BadFieldValueException;
import org.apache.xmpbox.xml.XmpSerializer;
import org.mustangproject.ZUGFeRD.model.*;

public class ZUGFeRDExporter implements Closeable {

	/**
	 * * You will need Apache PDFBox. To use the ZUGFeRD exporter, implement
	 * IZUGFeRDExportableTransaction in yourTransaction (which will require you
	 * to implement Product, Item and Contact) then call doc =
	 * PDDocument.load(PDFfilename); // automatically add Zugferd to all
	 * outgoing invoices ZUGFeRDExporter ze = new ZUGFeRDExporter();
	 * ze.PDFmakeA3compliant(doc, "Your application name",
	 * System.getProperty("user.name"), true); ze.PDFattachZugferdFile(doc,
	 * yourTransaction);
	 *
	 * doc.save(PDFfilename);
	 *
	 * @author jstaerk
	 * @throws ZUGFeRDExportException if the exporter could not be initialized
	 *
	 */
	public ZUGFeRDExporter() {
		try {
			jaxbContext = JAXBContext
					.newInstance("org.mustangproject.ZUGFeRD.model");
			marshaller = jaxbContext.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
        } catch (JAXBException e) {
            throw new ZUGFeRDExportException("Could not initialize JAXB", e);
        }
	}

	private class LineCalc {

		private BigDecimal totalGross;
		private BigDecimal itemTotalNetAmount;
		private BigDecimal itemTotalVATAmount;
		private BigDecimal itemNetAmount;

		public LineCalc(IZUGFeRDExportableItem currentItem) {
			BigDecimal totalAllowance = BigDecimal.ZERO;
			BigDecimal totalCharge = BigDecimal.ZERO;

			if (currentItem.getItemAllowances() != null) {
				for (IZUGFeRDAllowanceCharge itemAllowance : currentItem
						.getItemAllowances()) {
					totalAllowance = itemAllowance.getTotalAmount().add(
							totalAllowance);
				}
			}

			if (currentItem.getItemCharges() != null) {
				for (IZUGFeRDAllowanceCharge itemCharge : currentItem
						.getItemCharges()) {
					totalCharge = itemCharge.getTotalAmount().add(totalCharge);
				}
			}

			BigDecimal multiplicator = currentItem.getProduct().getVATPercent()
					.divide(new BigDecimal(100), 4, BigDecimal.ROUND_HALF_UP)
					.add(BigDecimal.ONE);
			// priceGross=currentItem.getPrice().multiply(multiplicator);

			totalGross = currentItem.getPrice()
					.multiply(currentItem.getQuantity())
					.subtract(totalAllowance).add(totalCharge)
					.multiply(multiplicator);
			itemTotalNetAmount = currentItem.getPrice()
					.multiply(currentItem.getQuantity())
					.subtract(totalAllowance).add(totalCharge)
					.setScale(2, BigDecimal.ROUND_HALF_UP);
			itemTotalVATAmount = totalGross.subtract(itemTotalNetAmount);
			itemNetAmount = currentItem
					.getPrice()
					.multiply(currentItem.getQuantity())
					.subtract(totalAllowance)
					.add(totalCharge)
					.divide(currentItem.getQuantity(), 4,
							BigDecimal.ROUND_HALF_UP);
		}

		public BigDecimal getItemTotalNetAmount() {
			return itemTotalNetAmount;
		}

		public BigDecimal getItemTotalVATAmount() {
			return itemTotalVATAmount;
		}

		public BigDecimal getItemNetAmount() {
			return itemNetAmount;
		}

	}

	private class Totals {
		private BigDecimal totalNetAmount;
		private BigDecimal totalGrossAmount;
		private BigDecimal lineTotalAmount;
		private BigDecimal totalTaxAmount;

		public Totals() {
			BigDecimal res = BigDecimal.ZERO;
			for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
				LineCalc lc = new LineCalc(currentItem);
				res = res.add(lc.getItemTotalNetAmount());
			}
			// Set line total
			this.lineTotalAmount = res;

			if (trans.getZFAllowances() != null) {
				for (IZUGFeRDAllowanceCharge headerAllowance : trans
						.getZFAllowances()) {
					res = res.subtract(headerAllowance.getTotalAmount());
				}
			}

			if (trans.getZFLogisticsServiceCharges() != null) {
				for (IZUGFeRDAllowanceCharge logisticsServiceCharge : trans
						.getZFLogisticsServiceCharges()) {
					res = res.add(logisticsServiceCharge.getTotalAmount());
				}
			}

			if (trans.getZFCharges() != null) {
				for (IZUGFeRDAllowanceCharge charge : trans.getZFCharges()) {
					res = res.add(charge.getTotalAmount());
				}
			}

			// Set total net amount
			this.totalNetAmount = res;

			HashMap<BigDecimal, VATAmount> VATPercentAmountMap = getVATPercentAmountMap();
			for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {
				VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);
				res = res.add(amount.getCalculated());
			}

			// Set total gross amount
			this.totalGrossAmount = res;

			this.totalTaxAmount = this.totalGrossAmount
					.subtract(this.totalNetAmount);
		}

		public BigDecimal getTotalNet() {
			return totalNetAmount;
		}

		public BigDecimal getTotalGross() {
			return totalGrossAmount;
		}

		public BigDecimal getLineTotal() {
			return lineTotalAmount;
		}

		public BigDecimal getTaxTotal() {
			return totalTaxAmount;
		}

	}

	// // MAIN CLASS
	private String conformanceLevel = "U";
	private String versionStr = "1.4.0";

	// BASIC, COMFORT etc - may be set from outside.
	private String ZUGFeRDConformanceLevel = null;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally
	 * set, in which case passing a IZUGFeRDExportableTransaction is not
	 * necessary. By default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	byte[] zugferdData = null;
	private boolean isTest;
	IZUGFeRDExportableTransaction trans = null;
	private boolean ignoreA1Errors;
	private PDDocument doc;
	private String currency = "EUR";

	private BigDecimal nDigitFormat(BigDecimal value, int scale) {
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
		value = value.setScale(scale, BigDecimal.ROUND_HALF_UP); // first, round
																	// so that
																	// e.g.
																	// 1.189999999999999946709294817992486059665679931640625
																	// becomes
																	// 1.19
		char[] repeat = new char[scale];
		Arrays.fill(repeat, '0');

		DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols();
		otherSymbols.setDecimalSeparator('.');
		DecimalFormat dec = new DecimalFormat("0." + new String(repeat),
				otherSymbols);
		return new BigDecimal(dec.format(value));

	}

	private BigDecimal vatFormat(BigDecimal value) {
		return nDigitFormat(value, 2);
	}

	private BigDecimal currencyFormat(BigDecimal value) {
		return nDigitFormat(value, 2);
	}

	private BigDecimal priceFormat(BigDecimal value) {
		return nDigitFormat(value, 4);
	}

	private BigDecimal quantityFormat(BigDecimal value) {
		return nDigitFormat(value, 4);
	}

	/**
	 * All files are PDF/A-3, setConformance refers to the level conformance.
	 *
	 * PDF/A-3 has three coformance levels, called "A", "U" and "B".
	 *
	 * PDF/A-3-B where B means only visually preservable, U -standard for
	 * Mustang- means visually and unicode preservable and A means full
	 * compliance, i.e. visually, unicode and structurally preservable and
	 * tagged PDF, i.e. useful metainformation for blind people.
	 *
	 * Feel free to pass "A" as new level if you know what you are doing :-)
	 *
	 *
	 */
	public void setConformanceLevel(String newLevel) {
		conformanceLevel = newLevel;
	}

	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 *
	 */
	public void setTest() {
		isTest = true;
	}

	public void ignoreA1Errors() {
		ignoreA1Errors = true;
	}

	private boolean getA1ParserValidationResult(PreflightParser parser) {
		ValidationResult result = null;

		try {

			/*
			 * Parse the PDF file with PreflightParser that inherits from the
			 * NonSequentialParser. Some additional controls are present to
			 * check a set of PDF/A requirements. (Stream length consistency,
			 * EOL after some Keyword...)
			 */
			parser.parse();

			/*
			 * Once the syntax validation is done, the parser can provide a
			 * PreflightDocument (that inherits from PDDocument) This document
			 * process the end of PDF/A validation.
			 */
			PreflightDocument document = parser.getPreflightDocument();
			document.validate();

			// Get validation result
			result = document.getResult();
			document.close();

		} catch (ValidationException e) {
			/*
			 * the parse method can throw a SyntaxValidationException if the PDF
			 * file can't be parsed. In this case, the exception contains an
			 * instance of ValidationResult
			 */
			return false;
		} catch (IOException e) {
			return false;
		}

		// display validation result
		return result.isValid();

	}

	public boolean isValidA1(String filename) {
		FileDataSource fd = new FileDataSource(filename);
		PreflightParser parser;
		try {
			parser = new PreflightParser(fd);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}

		return getA1ParserValidationResult(parser);
	}

	/***
	 * Will return a boolean if the inputstream is valid PDF/A-1 and close the input stream
	 * @param file
	 * @return
	 */
	public boolean isValidA1(InputStream file) {
		
            ByteArrayDataSource fd;
            try {
                    fd = new ByteArrayDataSource(file);
                    PreflightParser parser = new PreflightParser(fd);
                    return getA1ParserValidationResult(parser);
            } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                    return false;
            }
        }

	public void loadPDFA3(String filename) {

		try {
                    
                    doc = PDDocument.load(new File(filename));

		} catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
		}

	}

	public void loadPDFA3(InputStream file) {

		try {
			doc = PDDocument.load(file);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
	 * the metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 */
	public PDDocumentCatalog PDFmakeA3compliant(String filename,
			String producer, String creator, boolean attachZugferdHeaders)
			throws IOException, TransformerException {

		if (!ignoreA1Errors && !isValidA1(filename)) {
			throw new IOException("File is not a valid PDF/A-1 input file");
		}
		loadPDFA3(filename);

		return makeDocPDFA3compliant(producer, creator, attachZugferdHeaders);
	}

	public PDDocumentCatalog PDFmakeA3compliant(InputStream file,
			String producer, String creator, boolean attachZugferdHeaders)
			throws IOException, TransformerException {
		/* cache the file content in memory, unfortunately the next step, isValidA1,
		 * will close the input stream but the step thereafter (loadPDFA3) needs
		 * and open one*/
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] buf = new byte[1024];
		int n = 0;
		while ((n = file.read(buf)) >= 0)
		    baos.write(buf, 0, n);
		byte[] content = baos.toByteArray();

		InputStream is1 = new ByteArrayInputStream(content);
		if (!ignoreA1Errors && !isValidA1(is1)) {
			throw new IOException("File is not a valid PDF/A-1 input file");
		}
		InputStream is2 = new ByteArrayInputStream(content);
		loadPDFA3(is2);

		return makeDocPDFA3compliant(producer, creator, attachZugferdHeaders);
	}	
	private PDDocumentCatalog makeDocPDFA3compliant(String producer,
			String creator, boolean attachZugferdHeaders) throws IOException,
			TransformerException {
		String fullProducer = producer + " (via mustangproject.org "
				+ versionStr + ")";

		PDDocumentCatalog cat = doc.getDocumentCatalog();
		PDMetadata metadata = new PDMetadata(doc);
		cat.setMetadata(metadata);
		XMPMetadata xmp = XMPMetadata.createXMPMetadata();

                
		PDFAIdentificationSchema pdfaid = new PDFAIdentificationSchema(xmp);
                
		xmp.addSchema(pdfaid);

		DublinCoreSchema dc = xmp.createAndAddDublinCoreSchema();
                
		dc.addCreator(creator);
                
		XMPBasicSchema xsb = xmp.createAndAddXMPBasicSchema();
                
		xsb.setCreatorTool(creator);
		xsb.setCreateDate(GregorianCalendar.getInstance());
		// PDDocumentInformation pdi=doc.getDocumentInformation();
		PDDocumentInformation pdi = new PDDocumentInformation();
		pdi.setProducer(fullProducer);
		pdi.setAuthor(creator);
		doc.setDocumentInformation(pdi);

		AdobePDFSchema pdf = xmp.createAndAddAdobePDFSchema();
		pdf.setProducer(fullProducer);

                /*
                * // Mandatory: PDF/A3-a is tagged PDF which has to be expressed using
                * a // MarkInfo dictionary (PDF A/3 Standard sec. 6.7.2.2) PDMarkInfo
                * markinfo = new PDMarkInfo(); markinfo.setMarked(true);
                * doc.getDocumentCatalog().setMarkInfo(markinfo);
                */
                /*
                *
                * To be on the safe side, we use level B without Markinfo because we
                * can not guarantee that the user correctly tagged the templates for
                * the PDF.
                */
                try {
                    pdfaid.setConformance(conformanceLevel);//$NON-NLS-1$ //$NON-NLS-1$
                } catch (BadFieldValueException ex) {
                    Logger.getLogger(ZUGFeRDExporter.class.getName()).log(Level.SEVERE, null, ex);
                }

		pdfaid.setPart(3);

		if (attachZugferdHeaders) {
			addZugferdXMP(xmp); /*
								 * this is the only line where we do something
								 * Zugferd-specific, i.e. add PDF metadata
								 * specifically for Zugferd, not generically for
								 * a embedded file
								 */

		}

                XmpSerializer serializer = new XmpSerializer();
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                serializer.serialize(xmp, baos, false);
                metadata.importXMPMetadata( baos.toByteArray() );
                
		return cat;
	}

	public void close() throws IOException {
		if (doc != null) {
			doc.close();
		}
	}

	private static final ObjectFactory xmlFactory = new ObjectFactory();
	private final JAXBContext jaxbContext;
	private final Marshaller marshaller;
	private static final SimpleDateFormat zugferdDateFormat = new SimpleDateFormat(
			"yyyyMMdd"); //$NON-NLS-1$

	private Totals totals;

	private String createZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans) {
		this.trans = trans;
		this.totals = new Totals();
		currency = trans.getCurrency();

		CrossIndustryDocumentType invoice = xmlFactory
				.createCrossIndustryDocumentType();

		invoice.setSpecifiedExchangedDocumentContext(this.getDocumentContext());
		invoice.setHeaderExchangedDocument(this.getDocument());
		invoice.setSpecifiedSupplyChainTradeTransaction(this
				.getTradeTransaction());

		JAXBElement<CrossIndustryDocumentType> jaxElement = xmlFactory
				.createCrossIndustryDocument(invoice);

		try {
			return marshalJaxToXMLString(jaxElement);
		} catch (JAXBException e) {
			throw new ZUGFeRDExportException("Could not marshal ZUGFeRD transaction to XML", e);
		}
	}

	private String marshalJaxToXMLString(Object jaxElement) throws JAXBException {
		ByteArrayOutputStream outputXml = new ByteArrayOutputStream();
		marshaller.marshal(jaxElement, outputXml);
		return outputXml.toString();
	}

	private ExchangedDocumentContextType getDocumentContext() {

		ExchangedDocumentContextType context = xmlFactory
				.createExchangedDocumentContextType();
		DocumentContextParameterType contextParameter = xmlFactory
				.createDocumentContextParameterType();
		IDType idType = xmlFactory.createIDType();
		idType.setValue(DocumentContextParameterType.EXTENDED);
		contextParameter.setID(idType);
		context.getGuidelineSpecifiedDocumentContextParameter().add(
				contextParameter);

		IndicatorType testIndicator = xmlFactory.createIndicatorType();
		testIndicator.setIndicator(isTest);
		context.setTestIndicator(testIndicator);

		return context;
	}

	private ExchangedDocumentType getDocument() {

		ExchangedDocumentType document = xmlFactory
				.createExchangedDocumentType();

		IDType id = xmlFactory.createIDType();
		id.setValue(trans.getNumber());
		document.setID(id);

		DateTimeType issueDateTime = xmlFactory.createDateTimeType();
		DateTimeType.DateTimeString issueDateTimeString = xmlFactory
				.createDateTimeTypeDateTimeString();
		issueDateTimeString.setFormat(DateTimeType.DateTimeString.DATE);
		issueDateTimeString.setValue(zugferdDateFormat.format(trans
				.getIssueDate()));
		issueDateTime.setDateTimeString(issueDateTimeString);
		document.setIssueDateTime(issueDateTime);

		DocumentCodeType documentCodeType = xmlFactory.createDocumentCodeType();
		documentCodeType.setValue(DocumentCodeType.INVOICE);
		document.setTypeCode(documentCodeType);

		TextType name = xmlFactory.createTextType();
		name.setValue("RECHNUNG");
		document.getName().add(name);
                
		if (trans.getOwnOrganisationFullPlaintextInfo() != null) {
			NoteType regularInfo = xmlFactory.createNoteType();
			CodeType regularInfoSubjectCode = xmlFactory.createCodeType();
			regularInfoSubjectCode.setValue(NoteType.REGULARINFO);
			regularInfo.setSubjectCode(regularInfoSubjectCode);
			TextType regularInfoContent = xmlFactory.createTextType();
			regularInfoContent.setValue(trans
					.getOwnOrganisationFullPlaintextInfo());
			regularInfo.getContent().add(regularInfoContent);
			document.getIncludedNote().add(regularInfo);
		}
                
                if (trans.getReferenceNumber() != null && !new String().equals(trans.getReferenceNumber())){
                    NoteType referenceInfo = xmlFactory.createNoteType();
                    TextType referenceInfoContent = xmlFactory.createTextType();
                    referenceInfoContent.setValue("Ursprungsbeleg: " + trans.getReferenceNumber());
                    referenceInfo.getContent().add(referenceInfoContent);
                    document.getIncludedNote().add(referenceInfo);            
                }

		return document;
	}

	private SupplyChainTradeTransactionType getTradeTransaction() {

		SupplyChainTradeTransactionType transaction = xmlFactory
				.createSupplyChainTradeTransactionType();
		transaction.getApplicableSupplyChainTradeAgreement().add(
				this.getTradeAgreement());
		transaction.setApplicableSupplyChainTradeDelivery(this
				.getTradeDelivery());
		transaction.setApplicableSupplyChainTradeSettlement(this
				.getTradeSettlement());
		transaction.getIncludedSupplyChainTradeLineItem().addAll(
				this.getLineItems());

		return transaction;
	}

	private SupplyChainTradeAgreementType getTradeAgreement() {

		SupplyChainTradeAgreementType tradeAgreement = xmlFactory
				.createSupplyChainTradeAgreementType();

		tradeAgreement.setBuyerTradeParty(this.getBuyer());
		tradeAgreement.setSellerTradeParty(this.getSeller());

		return tradeAgreement;
	}

	private TradePartyType getBuyer() {

		TradePartyType buyerTradeParty = xmlFactory.createTradePartyType();
		TextType buyerName = xmlFactory.createTextType();
		buyerName.setValue(trans.getRecipient().getName());
		buyerTradeParty.setName(buyerName);

		TradeAddressType buyerAddressType = xmlFactory.createTradeAddressType();
		TextType buyerCityName = xmlFactory.createTextType();
		buyerCityName.setValue(trans.getRecipient().getLocation());
		buyerAddressType.setCityName(buyerCityName);

		CountryIDType buyerCountryId = xmlFactory.createCountryIDType();
		buyerCountryId.setValue(trans.getRecipient().getCountry());
		buyerAddressType.setCountryID(buyerCountryId);

		TextType buyerAddress = xmlFactory.createTextType();
		buyerAddress.setValue(trans.getRecipient().getStreet());
		buyerAddressType.setLineOne(buyerAddress);

		CodeType buyerPostcode = xmlFactory.createCodeType();
		buyerPostcode.setValue(trans.getRecipient().getZIP());
		buyerAddressType.getPostcodeCode().add(buyerPostcode);

		buyerTradeParty.setPostalTradeAddress(buyerAddressType);

		// Ust-ID
		TaxRegistrationType buyerTaxRegistration = xmlFactory
				.createTaxRegistrationType();
		IDType buyerUstId = xmlFactory.createIDType();
		buyerUstId.setValue(trans.getRecipient().getVATID());
		buyerUstId.setSchemeID(TaxRegistrationType.USTID);
		buyerTaxRegistration.setID(buyerUstId);
		buyerTradeParty.getSpecifiedTaxRegistration().add(buyerTaxRegistration);

		return buyerTradeParty;
	}

	private TradePartyType getSeller() {

		TradePartyType sellerTradeParty = xmlFactory.createTradePartyType();
		TextType sellerName = xmlFactory.createTextType();
		sellerName.setValue(trans.getOwnOrganisationName());
		sellerTradeParty.setName(sellerName);

		TradeAddressType sellerAddressType = xmlFactory
				.createTradeAddressType();
		TextType sellerCityName = xmlFactory.createTextType();
		sellerCityName.setValue(trans.getOwnLocation());
		sellerAddressType.setCityName(sellerCityName);

		CountryIDType sellerCountryId = xmlFactory.createCountryIDType();
		sellerCountryId.setValue(trans.getOwnCountry());
		sellerAddressType.setCountryID(sellerCountryId);

		TextType sellerAddress = xmlFactory.createTextType();
		sellerAddress.setValue(trans.getOwnStreet());
		sellerAddressType.setLineOne(sellerAddress);

		CodeType sellerPostcode = xmlFactory.createCodeType();
		sellerPostcode.setValue(trans.getOwnZIP());
		sellerAddressType.getPostcodeCode().add(sellerPostcode);

		sellerTradeParty.setPostalTradeAddress(sellerAddressType);

		// Steuernummer
		TaxRegistrationType sellerTaxRegistration = xmlFactory
				.createTaxRegistrationType();
		IDType sellerTaxId = xmlFactory.createIDType();
		sellerTaxId.setValue(trans.getOwnTaxID());
		sellerTaxId.setSchemeID(TaxRegistrationType.TAXID);
		sellerTaxRegistration.setID(sellerTaxId);
		sellerTradeParty.getSpecifiedTaxRegistration().add(
				sellerTaxRegistration);

		// Ust-ID
		sellerTaxRegistration = xmlFactory.createTaxRegistrationType();
		IDType sellerUstId = xmlFactory.createIDType();
		sellerUstId.setValue(trans.getOwnVATID());
		sellerUstId.setSchemeID(TaxRegistrationType.USTID);
		sellerTaxRegistration.setID(sellerUstId);
		sellerTradeParty.getSpecifiedTaxRegistration().add(
				sellerTaxRegistration);

		return sellerTradeParty;
	}

	private SupplyChainTradeDeliveryType getTradeDelivery() {

		SupplyChainTradeDeliveryType tradeDelivery = xmlFactory
				.createSupplyChainTradeDeliveryType();
		SupplyChainEventType deliveryEvent = xmlFactory
				.createSupplyChainEventType();
		DateTimeType deliveryDate = xmlFactory.createDateTimeType();
		DateTimeType.DateTimeString deliveryDateString = xmlFactory
				.createDateTimeTypeDateTimeString();
		deliveryDateString.setFormat(DateTimeType.DateTimeString.DATE);
		deliveryDateString.setValue(zugferdDateFormat.format(trans
				.getDeliveryDate()));
		deliveryDate.setDateTimeString(deliveryDateString);
		deliveryEvent.getOccurrenceDateTime().add(deliveryDate);
		tradeDelivery.getActualDeliverySupplyChainEvent().add(deliveryEvent);

		return tradeDelivery;
	}

	private SupplyChainTradeSettlementType getTradeSettlement() {
		SupplyChainTradeSettlementType tradeSettlement = xmlFactory
				.createSupplyChainTradeSettlementType();

		TextType paymentReference = xmlFactory.createTextType();
		paymentReference.setValue(trans.getNumber());
		tradeSettlement.getPaymentReference().add(paymentReference);

		CodeType currencyCode = xmlFactory.createCodeType();
		currencyCode.setValue(currency);
		tradeSettlement.setInvoiceCurrencyCode(currencyCode);

		tradeSettlement.getSpecifiedTradeSettlementPaymentMeans().add(
				this.getPaymentData());
		tradeSettlement.getApplicableTradeTax().addAll(this.getTradeTax());
		tradeSettlement.getSpecifiedTradePaymentTerms().addAll(
				this.getPaymentTerms());
		if (trans.getZFAllowances() != null) {
			tradeSettlement.getSpecifiedTradeAllowanceCharge().addAll(
					this.getHeaderAllowances());
		}
		if (trans.getZFLogisticsServiceCharges() != null) {
			tradeSettlement.getSpecifiedLogisticsServiceCharge().addAll(
					this.getHeaderLogisticsServiceCharges());
		}
		if (trans.getZFCharges() != null) {
			tradeSettlement.getSpecifiedTradeAllowanceCharge().addAll(
					this.getHeaderCharges());
		}

		tradeSettlement.setSpecifiedTradeSettlementMonetarySummation(this
				.getMonetarySummation());

		return tradeSettlement;
	}

	private TradeSettlementPaymentMeansType getPaymentData() {
		TradeSettlementPaymentMeansType paymentData = xmlFactory
				.createTradeSettlementPaymentMeansType();
		PaymentMeansCodeType paymentDataType = xmlFactory
				.createPaymentMeansCodeType();
		paymentDataType.setValue(PaymentMeansCodeType.BANKACCOUNT);
		paymentData.setTypeCode(paymentDataType);

		TextType paymentInfo = xmlFactory.createTextType();
		String paymentInfoText = trans.getOwnPaymentInfoText();
		if (paymentInfoText == null) {
			paymentInfoText = "";
		}
		paymentInfo.setValue(paymentInfoText);
		paymentData.getInformation().add(paymentInfo);

		CreditorFinancialAccountType bankAccount = xmlFactory
				.createCreditorFinancialAccountType();
		IDType iban = xmlFactory.createIDType();
		iban.setValue(trans.getOwnIBAN());
		bankAccount.setIBANID(iban);
		paymentData.setPayeePartyCreditorFinancialAccount(bankAccount);

		CreditorFinancialInstitutionType bankData = xmlFactory
				.createCreditorFinancialInstitutionType();
		IDType bicId = xmlFactory.createIDType();
		bicId.setValue(trans.getOwnBIC());
		bankData.setBICID(bicId);
		TextType bankName = xmlFactory.createTextType();
		bankName.setValue(trans.getOwnBankName());
		bankData.setName(bankName);
		paymentData.setPayeeSpecifiedCreditorFinancialInstitution(bankData);
		return paymentData;
	}

	private Collection<TradeTaxType> getTradeTax() {
		List<TradeTaxType> tradeTaxTypes = new ArrayList<TradeTaxType>();

		HashMap<BigDecimal, VATAmount> VATPercentAmountMap = this
				.getVATPercentAmountMap();
		for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {

			TradeTaxType tradeTax = xmlFactory.createTradeTaxType();
			TaxTypeCodeType taxTypeCode = xmlFactory.createTaxTypeCodeType();
			taxTypeCode.setValue(TaxTypeCodeType.SALESTAX);
			tradeTax.setTypeCode(taxTypeCode);

			TaxCategoryCodeType taxCategoryCode = xmlFactory
					.createTaxCategoryCodeType();
			taxCategoryCode.setValue(TaxCategoryCodeType.STANDARDRATE);
			tradeTax.setCategoryCode(taxCategoryCode);

			VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);

			PercentType taxPercent = xmlFactory.createPercentType();
			taxPercent.setValue(vatFormat(currentTaxPercent));
			tradeTax.setApplicablePercent(taxPercent);

			AmountType calculatedTaxAmount = xmlFactory.createAmountType();
			calculatedTaxAmount.setCurrencyID(currency);
			calculatedTaxAmount
					.setValue(currencyFormat(amount.getCalculated()));
			tradeTax.getCalculatedAmount().add(calculatedTaxAmount);

			AmountType basisTaxAmount = xmlFactory.createAmountType();
			basisTaxAmount.setCurrencyID(currency);
			basisTaxAmount.setValue(currencyFormat(amount.getBasis()));
			tradeTax.getBasisAmount().add(basisTaxAmount);

			tradeTaxTypes.add(tradeTax);
		}

		return tradeTaxTypes;
	}

	private Collection<TradeAllowanceChargeType> getHeaderAllowances() {
		List<TradeAllowanceChargeType> headerAllowances = new ArrayList<TradeAllowanceChargeType>();

		for (IZUGFeRDAllowanceCharge iAllowance : trans.getZFAllowances()) {

			TradeAllowanceChargeType allowance = xmlFactory
					.createTradeAllowanceChargeType();

			IndicatorType chargeIndicator = xmlFactory.createIndicatorType();
			chargeIndicator.setIndicator(false);
			allowance.setChargeIndicator(chargeIndicator);

			AmountType actualAmount = xmlFactory.createAmountType();
			actualAmount.setCurrencyID(currency);
			actualAmount.setValue(currencyFormat(iAllowance.getTotalAmount()));
			allowance.getActualAmount().add(actualAmount);

			TextType reason = xmlFactory.createTextType();
			reason.setValue(iAllowance.getReason());
			allowance.setReason(reason);

			TradeTaxType tradeTax = xmlFactory.createTradeTaxType();

			PercentType vatPercent = xmlFactory.createPercentType();
			vatPercent.setValue(currencyFormat(iAllowance.getTaxPercent()));
			tradeTax.setApplicablePercent(vatPercent);

			/*
			 * Only in extended AmountType basisAmount =
			 * xmlFactory.createAmountType();
			 * basisAmount.setCurrencyID(trans.getInvoiceCurrency());
			 * basisAmount.setValue(amount.getBasis());
			 * allowance.setBasisAmount(basisAmount);
			 */
			TaxCategoryCodeType taxType = xmlFactory
					.createTaxCategoryCodeType();
			taxType.setValue(TaxCategoryCodeType.STANDARDRATE);
			tradeTax.setCategoryCode(taxType);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeType.SALESTAX);
			tradeTax.setTypeCode(taxCode);

			allowance.getCategoryTradeTax().add(tradeTax);
			headerAllowances.add(allowance);

		}

		return headerAllowances;
	}

	private Collection<TradeAllowanceChargeType> getHeaderCharges() {
		List<TradeAllowanceChargeType> headerCharges = new ArrayList<TradeAllowanceChargeType>();

		for (IZUGFeRDAllowanceCharge iCharge : trans.getZFCharges()) {

			TradeAllowanceChargeType charge = xmlFactory
					.createTradeAllowanceChargeType();

			IndicatorType chargeIndicator = xmlFactory.createIndicatorType();
			chargeIndicator.setIndicator(true);
			charge.setChargeIndicator(chargeIndicator);

			AmountType actualAmount = xmlFactory.createAmountType();
			actualAmount.setCurrencyID(currency);
			actualAmount.setValue(currencyFormat(iCharge.getTotalAmount()));
			charge.getActualAmount().add(actualAmount);

			TextType reason = xmlFactory.createTextType();
			reason.setValue(iCharge.getReason());
			charge.setReason(reason);

			TradeTaxType tradeTax = xmlFactory.createTradeTaxType();

			PercentType vatPercent = xmlFactory.createPercentType();
			vatPercent.setValue(currencyFormat(iCharge.getTaxPercent()));
			tradeTax.setApplicablePercent(vatPercent);

			/*
			 * Only in extended AmountType basisAmount =
			 * xmlFactory.createAmountType();
			 * basisAmount.setCurrencyID(trans.getInvoiceCurrency());
			 * basisAmount.setValue(amount.getBasis());
			 * allowance.setBasisAmount(basisAmount);
			 */
			TaxCategoryCodeType taxType = xmlFactory
					.createTaxCategoryCodeType();
			taxType.setValue(TaxCategoryCodeType.STANDARDRATE);
			tradeTax.setCategoryCode(taxType);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeType.SALESTAX);
			tradeTax.setTypeCode(taxCode);

			charge.getCategoryTradeTax().add(tradeTax);
			headerCharges.add(charge);

		}

		return headerCharges;
	}

	private Collection<LogisticsServiceChargeType> getHeaderLogisticsServiceCharges() {
		List<LogisticsServiceChargeType> headerServiceCharge = new ArrayList<LogisticsServiceChargeType>();

		for (IZUGFeRDAllowanceCharge iServiceCharge : trans
				.getZFLogisticsServiceCharges()) {

			LogisticsServiceChargeType serviceCharge = xmlFactory
					.createLogisticsServiceChargeType();

			AmountType actualAmount = xmlFactory.createAmountType();
			actualAmount.setCurrencyID(currency);
			actualAmount.setValue(currencyFormat(iServiceCharge
					.getTotalAmount()));
			serviceCharge.getAppliedAmount().add(actualAmount);

			TextType reason = xmlFactory.createTextType();
			reason.setValue(iServiceCharge.getReason());
			serviceCharge.getDescription().add(reason);

			TradeTaxType tradeTax = xmlFactory.createTradeTaxType();

			PercentType vatPercent = xmlFactory.createPercentType();
			vatPercent.setValue(currencyFormat(iServiceCharge.getTaxPercent()));
			tradeTax.setApplicablePercent(vatPercent);

			/*
			 * Only in extended AmountType basisAmount =
			 * xmlFactory.createAmountType();
			 * basisAmount.setCurrencyID(trans.getInvoiceCurrency());
			 * basisAmount.setValue(amount.getBasis());
			 * allowance.setBasisAmount(basisAmount);
			 */
			TaxCategoryCodeType taxType = xmlFactory
					.createTaxCategoryCodeType();
			taxType.setValue(TaxCategoryCodeType.STANDARDRATE);
			tradeTax.setCategoryCode(taxType);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeType.SALESTAX);
			tradeTax.setTypeCode(taxCode);

			serviceCharge.getAppliedTradeTax().add(tradeTax);
			headerServiceCharge.add(serviceCharge);

		}

		return headerServiceCharge;
	}

	private Collection<TradePaymentTermsType> getPaymentTerms() {
		List<TradePaymentTermsType> paymentTerms = new ArrayList<TradePaymentTermsType>();

		TradePaymentTermsType paymentTerm = xmlFactory
				.createTradePaymentTermsType();
		DateTimeType dueDate = xmlFactory.createDateTimeType();
		DateTimeType.DateTimeString dueDateString = xmlFactory
				.createDateTimeTypeDateTimeString();
		dueDateString.setFormat(DateTimeType.DateTimeString.DATE);
		dueDateString.setValue(zugferdDateFormat.format(trans.getDueDate()));
		dueDate.setDateTimeString(dueDateString);
		paymentTerm.setDueDateDateTime(dueDate);

		TextType paymentTermDescr = xmlFactory.createTextType();

		String paymentTermDescription = trans.getPaymentTermDescription();
		if (paymentTermDescription == null) {
			paymentTermDescription = "";
		}
		paymentTermDescr.setValue(paymentTermDescription);
		paymentTerm.getDescription().add(paymentTermDescr);

		paymentTerms.add(paymentTerm);

		return paymentTerms;
	}

	private TradeSettlementMonetarySummationType getMonetarySummation() {
		TradeSettlementMonetarySummationType monetarySummation = xmlFactory
				.createTradeSettlementMonetarySummationType();

		// AllowanceTotalAmount = sum of all allowances
		AmountType allowanceTotalAmount = xmlFactory.createAmountType();
		allowanceTotalAmount.setCurrencyID(currency);
		if (trans.getZFAllowances() != null) {
			BigDecimal totalHeaderAllowance = BigDecimal.ZERO;
			for (IZUGFeRDAllowanceCharge headerAllowance : trans
					.getZFAllowances()) {
				totalHeaderAllowance = headerAllowance.getTotalAmount().add(
						totalHeaderAllowance);
			}
			allowanceTotalAmount.setValue(currencyFormat(totalHeaderAllowance));
		} else {
			allowanceTotalAmount.setValue(currencyFormat(BigDecimal.ZERO));
		}
		monetarySummation.getAllowanceTotalAmount().add(allowanceTotalAmount);

		// ChargeTotalAmount = sum of all Logistic service charges + normal
		// charges
		BigDecimal totalCharge = BigDecimal.ZERO;
		AmountType totalChargeAmount = xmlFactory.createAmountType();
		totalChargeAmount.setCurrencyID(currency);
		if (trans.getZFLogisticsServiceCharges() != null) {
			for (IZUGFeRDAllowanceCharge logisticsServiceCharge : trans
					.getZFLogisticsServiceCharges()) {
				totalCharge = logisticsServiceCharge.getTotalAmount().add(
						totalCharge);
			}
		}
		if (trans.getZFCharges() != null) {
			for (IZUGFeRDAllowanceCharge charge : trans.getZFCharges()) {
				totalCharge = charge.getTotalAmount().add(totalCharge);
			}
		}

		totalChargeAmount.setValue(currencyFormat(totalCharge));

		monetarySummation.getChargeTotalAmount().add(totalChargeAmount);

		/*
		 * AmountType chargeTotalAmount = xmlFactory.createAmountType();
		 * chargeTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
		 * chargeTotalAmount.setValue(currencyFormat(BigDecimal.ZERO));
		 * monetarySummation.getChargeTotalAmount().add(chargeTotalAmount);
		 */

		AmountType lineTotalAmount = xmlFactory.createAmountType();
		lineTotalAmount.setCurrencyID(currency);
		lineTotalAmount.setValue(currencyFormat(totals.getLineTotal()));
		monetarySummation.getLineTotalAmount().add(lineTotalAmount);

		AmountType taxBasisTotalAmount = xmlFactory.createAmountType();
		taxBasisTotalAmount.setCurrencyID(currency);
		taxBasisTotalAmount.setValue(currencyFormat(totals.getTotalNet()));
		monetarySummation.getTaxBasisTotalAmount().add(taxBasisTotalAmount);

		AmountType taxTotalAmount = xmlFactory.createAmountType();
		taxTotalAmount.setCurrencyID(currency);
		taxTotalAmount.setValue(currencyFormat(totals.getTaxTotal()));
		monetarySummation.getTaxTotalAmount().add(taxTotalAmount);

		AmountType grandTotalAmount = xmlFactory.createAmountType();
		grandTotalAmount.setCurrencyID(currency);
		grandTotalAmount.setValue(currencyFormat(totals.getTotalGross()));
		monetarySummation.getGrandTotalAmount().add(grandTotalAmount);

		AmountType duePayableAmount = xmlFactory.createAmountType();
		duePayableAmount.setCurrencyID(currency);
		duePayableAmount.setValue(currencyFormat(totals.getTotalGross()));
		monetarySummation.getDuePayableAmount().add(duePayableAmount);

		return monetarySummation;
	}

	private Collection<SupplyChainTradeLineItemType> getLineItems() {

		ArrayList<SupplyChainTradeLineItemType> lineItems = new ArrayList<SupplyChainTradeLineItemType>();
		int lineID = 0;
		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			LineCalc lc = new LineCalc(currentItem);
			SupplyChainTradeLineItemType lineItem = xmlFactory
					.createSupplyChainTradeLineItemType();

			DocumentLineDocumentType lineDocument = xmlFactory
					.createDocumentLineDocumentType();
			IDType lineNumber = xmlFactory.createIDType();
			lineNumber.setValue(Integer.toString(lineID));
			lineDocument.setLineID(lineNumber);
			lineItem.setAssociatedDocumentLineDocument(lineDocument);

			SupplyChainTradeAgreementType tradeAgreement = xmlFactory
					.createSupplyChainTradeAgreementType();
			TradePriceType grossTradePrice = xmlFactory.createTradePriceType();
			QuantityType grossQuantity = xmlFactory.createQuantityType();
			grossQuantity.setUnitCode(currentItem.getProduct().getUnit());
			grossQuantity.setValue(quantityFormat(BigDecimal.ONE));
			grossTradePrice.setBasisQuantity(grossQuantity);

			AmountType grossChargeAmount = xmlFactory.createAmountType();
			grossChargeAmount.setCurrencyID(currency);
			grossChargeAmount.setValue(priceFormat(currentItem.getPrice()));
			grossTradePrice.getChargeAmount().add(grossChargeAmount);
			tradeAgreement.getGrossPriceProductTradePrice()
					.add(grossTradePrice);

			if (currentItem.getItemAllowances() != null) {
				for (IZUGFeRDAllowanceCharge itemAllowance : currentItem
						.getItemAllowances()) {
					TradeAllowanceChargeType eItemAllowance = xmlFactory
							.createTradeAllowanceChargeType();
					IndicatorType chargeIndicator = xmlFactory
							.createIndicatorType();
					chargeIndicator.setIndicator(false);
					eItemAllowance.setChargeIndicator(chargeIndicator);
					AmountType actualAmount = xmlFactory.createAmountType();
					actualAmount.setCurrencyID(currency);
					actualAmount.setValue(priceFormat(itemAllowance
							.getTotalAmount().divide(currentItem.getQuantity(),
									4, BigDecimal.ROUND_HALF_UP)));
					eItemAllowance.getActualAmount().add(actualAmount);
					TextType reason = xmlFactory.createTextType();
					reason.setValue(itemAllowance.getReason());
					eItemAllowance.setReason(reason);
					grossTradePrice.getAppliedTradeAllowanceCharge().add(
							eItemAllowance);
				}
			}

			if (currentItem.getItemCharges() != null) {
				for (IZUGFeRDAllowanceCharge itemCharge : currentItem
						.getItemCharges()) {
					TradeAllowanceChargeType eItemCharge = xmlFactory
							.createTradeAllowanceChargeType();
					AmountType actualAmount = xmlFactory.createAmountType();
					actualAmount.setCurrencyID(currency);
					actualAmount.setValue(priceFormat(itemCharge
							.getTotalAmount().divide(currentItem.getQuantity(),
									4, BigDecimal.ROUND_HALF_UP)));
					eItemCharge.getActualAmount().add(actualAmount);
					TextType reason = xmlFactory.createTextType();
					reason.setValue(itemCharge.getReason());
					eItemCharge.setReason(reason);
					IndicatorType chargeIndicator = xmlFactory
							.createIndicatorType();
					chargeIndicator.setIndicator(true);
					eItemCharge.setChargeIndicator(chargeIndicator);
					grossTradePrice.getAppliedTradeAllowanceCharge().add(
							eItemCharge);
				}
			}

			TradePriceType netTradePrice = xmlFactory.createTradePriceType();
			QuantityType netQuantity = xmlFactory.createQuantityType();
			netQuantity.setUnitCode(currentItem.getProduct().getUnit());
			netQuantity.setValue(quantityFormat(BigDecimal.ONE));
			netTradePrice.setBasisQuantity(netQuantity);

			AmountType netChargeAmount = xmlFactory.createAmountType();
			netChargeAmount.setCurrencyID(currency);
			netChargeAmount.setValue(priceFormat(lc.getItemNetAmount()));
			netTradePrice.getChargeAmount().add(netChargeAmount);
			tradeAgreement.getNetPriceProductTradePrice().add(netTradePrice);

			lineItem.setSpecifiedSupplyChainTradeAgreement(tradeAgreement);

			SupplyChainTradeDeliveryType tradeDelivery = xmlFactory
					.createSupplyChainTradeDeliveryType();
			QuantityType billedQuantity = xmlFactory.createQuantityType();
			billedQuantity.setUnitCode(currentItem.getProduct().getUnit());
			billedQuantity.setValue(quantityFormat(currentItem.getQuantity()));
			tradeDelivery.setBilledQuantity(billedQuantity);
			lineItem.setSpecifiedSupplyChainTradeDelivery(tradeDelivery);

			SupplyChainTradeSettlementType tradeSettlement = xmlFactory
					.createSupplyChainTradeSettlementType();
			TradeTaxType tradeTax = xmlFactory.createTradeTaxType();

			TaxCategoryCodeType taxCategoryCode = xmlFactory
					.createTaxCategoryCodeType();
			taxCategoryCode.setValue(TaxCategoryCodeType.STANDARDRATE);
			tradeTax.setCategoryCode(taxCategoryCode);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeType.SALESTAX);
			tradeTax.setTypeCode(taxCode);

			PercentType taxPercent = xmlFactory.createPercentType();
			taxPercent.setValue(vatFormat(currentItem.getProduct()
					.getVATPercent()));
			tradeTax.setApplicablePercent(taxPercent);
			tradeSettlement.getApplicableTradeTax().add(tradeTax);

			TradeSettlementMonetarySummationType monetarySummation = xmlFactory
					.createTradeSettlementMonetarySummationType();
			AmountType itemAmount = xmlFactory.createAmountType();
			itemAmount.setCurrencyID(currency);
			itemAmount.setValue(currencyFormat(lc.getItemTotalNetAmount()));
			monetarySummation.getLineTotalAmount().add(itemAmount);
			tradeSettlement
					.setSpecifiedTradeSettlementMonetarySummation(monetarySummation);

			lineItem.setSpecifiedSupplyChainTradeSettlement(tradeSettlement);

			TradeProductType tradeProduct = xmlFactory.createTradeProductType();
			TextType productName = xmlFactory.createTextType();
			productName.setValue(currentItem.getProduct().getName());
			tradeProduct.getName().add(productName);

			TextType productDescription = xmlFactory.createTextType();
			productDescription.setValue(currentItem.getProduct()
					.getDescription());
			tradeProduct.getDescription().add(productDescription);
			lineItem.setSpecifiedTradeProduct(tradeProduct);

			lineItems.add(lineItem);
		}

		return lineItems;

	}

	/**
	 * which taxes have been used with which amounts in this transaction, empty
	 * for no taxes, or e.g. 19=>190 and 7=>14 if 1000 Eur were applicable to
	 * 19% VAT (=>190 EUR VAT) and 200 EUR were applicable to 7% (=>14 EUR VAT)
	 * 190 Eur
	 *
	 * @return
	 *
	 */
	private HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
		return getVATPercentAmountMap(false);
	}

	private HashMap<BigDecimal, VATAmount> getVATPercentAmountMap(
			Boolean itemOnly) {
		HashMap<BigDecimal, VATAmount> hm = new HashMap<BigDecimal, VATAmount>();

		for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			BigDecimal percent = currentItem.getProduct().getVATPercent();
			LineCalc lc = new LineCalc(currentItem);
			VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(),
					lc.getItemTotalVATAmount());
			VATAmount current = hm.get(percent);
			if (current == null) {
				hm.put(percent, itemVATAmount);
			} else {
				hm.put(percent, current.add(itemVATAmount));
			}
		}
		if (itemOnly) {
			return hm;
		}
		if (trans.getZFAllowances() != null) {
			for (IZUGFeRDAllowanceCharge headerAllowance : trans
					.getZFAllowances()) {
				BigDecimal percent = headerAllowance.getTaxPercent();
				VATAmount itemVATAmount = new VATAmount(
						headerAllowance.getTotalAmount(), headerAllowance
								.getTotalAmount().multiply(percent)
								.divide(new BigDecimal(100)));
				VATAmount current = hm.get(percent);
				if (current == null) {
					hm.put(percent, itemVATAmount);
				} else {
					hm.put(percent, current.subtract(itemVATAmount));
				}
			}
		}

		if (trans.getZFLogisticsServiceCharges() != null) {
			for (IZUGFeRDAllowanceCharge logisticsServiceCharge : trans
					.getZFLogisticsServiceCharges()) {
				BigDecimal percent = logisticsServiceCharge.getTaxPercent();
				VATAmount itemVATAmount = new VATAmount(
						logisticsServiceCharge.getTotalAmount(),
						logisticsServiceCharge.getTotalAmount()
								.multiply(percent).divide(new BigDecimal(100)));
				VATAmount current = hm.get(percent);
				if (current == null) {
					hm.put(percent, itemVATAmount);
				} else {
					hm.put(percent, current.add(itemVATAmount));
				}
			}
		}

		if (trans.getZFCharges() != null) {
			for (IZUGFeRDAllowanceCharge charge : trans.getZFCharges()) {
				BigDecimal percent = charge.getTaxPercent();
				VATAmount itemVATAmount = new VATAmount(
						charge.getTotalAmount(), charge.getTotalAmount()
								.multiply(percent).divide(new BigDecimal(100)));
				VATAmount current = hm.get(percent);
				if (current == null) {
					hm.put(percent, itemVATAmount);
				} else {
					hm.put(percent, current.add(itemVATAmount));
				}
			}
		}

		return hm;
	}

	/**
	 * Embeds the Zugferd XML structure in a file named ZUGFeRD-invoice.xml.
	 *
	 * @param doc
	 *            PDDocument to attach an XML invoice to
	 * @param trans
	 *            a IZUGFeRDExportableTransaction that provides the data-model
	 *            to populate the XML. This parameter may be null, if so the XML
	 *            data should hav ebeen set via
	 *            <code>setZUGFeRDXMLData(byte[] zugferdData)</code>
	 */
	public void PDFattachZugferdFile(IZUGFeRDExportableTransaction trans)
			throws IOException {

            if (zugferdData == null) // XML ZUGFeRD data not set externally, needs
                                                                    // to be built
            {
                    // create a dummy file stream, this would probably normally be a
                    // FileInputStream

                    byte[] zugferdRaw = createZugferdXMLForTransaction(trans).getBytes(); //$NON-NLS-1$

                    if ((zugferdRaw[0] == (byte) 0xEF)
                                    && (zugferdRaw[1] == (byte) 0xBB)
                                    && (zugferdRaw[2] == (byte) 0xBF)) {
                            // I don't like BOMs, lets remove it
                            zugferdData = new byte[zugferdRaw.length - 3];
                            System.arraycopy(zugferdRaw, 3, zugferdData, 0,
                                            zugferdRaw.length - 3);
                    } else {
                            zugferdData = zugferdRaw;
                    }
            }

            PDFAttachGenericFile(
                            doc,
                            "ZUGFeRD-invoice.xml",
                            "Alternative",
                            "Invoice metadata conforming to ZUGFeRD standard (http://www.ferd-net.de/front_content.php?idcat=231&lang=4)",
                            "text/xml", zugferdData);
	}

	public void export(String ZUGFeRDfilename) {
            try {
                doc.save(ZUGFeRDfilename);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
	}

	/**
	 * Embeds an external file (generic - any type allowed) in the PDF.
	 *
	 * @param doc
	 *            PDDocument to attach the file to.
	 * @param filename
	 *            name of the file that will become attachment name in the PDF
	 * @param relationship
	 *            how the file relates to the content, e.g. "Alternative"
	 * @param description
	 *            Human-readable description of the file content
	 * @param subType
	 *            type of the data e.g. could be "text/xml" - mime like
	 * @param data
	 *            the binary data of the file/attachment
         * @throws java.io.IOException
	 */
	public void PDFAttachGenericFile(PDDocument doc, String filename,
			String relationship, String description, String subType, byte[] data)
			throws IOException {
		PDComplexFileSpecification fs = new PDComplexFileSpecification();
		fs.setFile(filename);
                

		COSDictionary dict = fs.getCOSObject();
		dict.setName("AFRelationship", relationship);
		dict.setString("UF", filename);
		dict.setString("Desc", description);

		ByteArrayInputStream fakeFile = new ByteArrayInputStream(data);
		PDEmbeddedFile ef = new PDEmbeddedFile(doc, fakeFile);
		ef.setSubtype(subType);
		ef.setSize(data.length);
		ef.setCreationDate(new GregorianCalendar());

		ef.setModDate(GregorianCalendar.getInstance());

		fs.setEmbeddedFile(ef);

		// In addition make sure the embedded file is set under /UF
		dict = fs.getCOSObject();
		COSDictionary efDict = (COSDictionary) dict
				.getDictionaryObject(COSName.EF);
		COSBase lowerLevelFile = efDict.getItem(COSName.F);
		efDict.setItem(COSName.UF, lowerLevelFile);

		// now add the entry to the embedded file tree and set in the document.
		PDDocumentNameDictionary names = new PDDocumentNameDictionary(
				doc.getDocumentCatalog());
		PDEmbeddedFilesNameTreeNode efTree = names.getEmbeddedFiles();
		if (efTree == null) {
			efTree = new PDEmbeddedFilesNameTreeNode();
		}

		Map<String, PDComplexFileSpecification> namesMap = new HashMap<String, PDComplexFileSpecification>();

		Map<String, PDComplexFileSpecification> oldNamesMap = efTree.getNames();
		if (oldNamesMap != null) {
			for (String key : oldNamesMap.keySet()) {
				namesMap.put(key, oldNamesMap.get(key));
			}
		}
		namesMap.put(filename, fs);
		efTree.setNames(namesMap);

		names.setEmbeddedFiles(efTree);
		doc.getDocumentCatalog().setNames(names);

		// AF entry (Array) in catalog with the FileSpec
		COSArray cosArray = (COSArray) doc.getDocumentCatalog()
				.getCOSObject().getItem("AF");
		if (cosArray == null) {
			cosArray = new COSArray();
		}
		cosArray.add(fs);
		COSDictionary dict2 = doc.getDocumentCatalog().getCOSObject();
		COSArray array = new COSArray();
		array.add(fs.getCOSObject()); // see below
	        dict2.setItem("AF",array);
		doc.getDocumentCatalog().getCOSObject().setItem("AF", cosArray);
	}

	/**
	 * Sets the ZUGFeRD XML data to be attached as a single byte array. This is
	 * useful for use-cases where the XML has already been produced by some
	 * external API or component.
	 *
	 * @param zugferdData
	 *            XML data to be set as a byte array (XML file in raw form).
	 */
	public void setZUGFeRDXMLData(byte[] zugferdData) {
		this.zugferdData = zugferdData;
	}

	/**
	 * Sets the ZUGFeRD conformance level (override).
	 *
	 * @param ZUGFeRDConformanceLevel
	 *            the new conformance level
	 */
	public void setZUGFeRDConformanceLevel(String ZUGFeRDConformanceLevel) {
		this.ZUGFeRDConformanceLevel = ZUGFeRDConformanceLevel;
	}

	/**
	 * * This will add both the RDF-indication which embedded file is Zugferd
	 * and the neccessary PDF/A schema extension description to be able to add
	 * this information to RDF
	 *
	 * @param metadata
	 */
	private void addZugferdXMP(XMPMetadata metadata) {

		XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata,
				this.ZUGFeRDConformanceLevel);

		metadata.addSchema(zf);

		XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata);
                
		metadata.addSchema(pdfaex);

	}

	/****
	 * Returns the PDFBox PDF Document
	 * 
	 * @return
	 */
	public PDDocument getDoc() {
		return doc;
	}

}
