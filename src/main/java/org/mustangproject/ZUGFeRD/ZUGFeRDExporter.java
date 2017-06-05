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

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.transform.TransformerException;


import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.mustangproject.ZUGFeRD.model.AmountType;
import org.mustangproject.ZUGFeRD.model.CodeType;
import org.mustangproject.ZUGFeRD.model.CountryIDType;
import org.mustangproject.ZUGFeRD.model.CreditorFinancialAccountType;
import org.mustangproject.ZUGFeRD.model.CreditorFinancialInstitutionType;
import org.mustangproject.ZUGFeRD.model.CrossIndustryDocumentType;
import org.mustangproject.ZUGFeRD.model.DateTimeType;
import org.mustangproject.ZUGFeRD.model.DocumentCodeType;
import org.mustangproject.ZUGFeRD.model.DocumentContextParameterType;
import org.mustangproject.ZUGFeRD.model.DocumentLineDocumentType;
import org.mustangproject.ZUGFeRD.model.ExchangedDocumentContextType;
import org.mustangproject.ZUGFeRD.model.ExchangedDocumentType;
import org.mustangproject.ZUGFeRD.model.IDType;
import org.mustangproject.ZUGFeRD.model.IndicatorType;
import org.mustangproject.ZUGFeRD.model.LogisticsServiceChargeType;
import org.mustangproject.ZUGFeRD.model.NoteType;
import org.mustangproject.ZUGFeRD.model.ObjectFactory;
import org.mustangproject.ZUGFeRD.model.PaymentMeansCodeType;
import org.mustangproject.ZUGFeRD.model.PercentType;
import org.mustangproject.ZUGFeRD.model.QuantityType;
import org.mustangproject.ZUGFeRD.model.SupplyChainEventType;
import org.mustangproject.ZUGFeRD.model.SupplyChainTradeAgreementType;
import org.mustangproject.ZUGFeRD.model.SupplyChainTradeDeliveryType;
import org.mustangproject.ZUGFeRD.model.SupplyChainTradeLineItemType;
import org.mustangproject.ZUGFeRD.model.SupplyChainTradeSettlementType;
import org.mustangproject.ZUGFeRD.model.SupplyChainTradeTransactionType;
import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeType;
import org.mustangproject.ZUGFeRD.model.TaxRegistrationType;
import org.mustangproject.ZUGFeRD.model.TaxTypeCodeType;
import org.mustangproject.ZUGFeRD.model.TextType;
import org.mustangproject.ZUGFeRD.model.TradeAddressType;
import org.mustangproject.ZUGFeRD.model.TradeAllowanceChargeType;
import org.mustangproject.ZUGFeRD.model.TradePartyType;
import org.mustangproject.ZUGFeRD.model.TradePaymentTermsType;
import org.mustangproject.ZUGFeRD.model.TradePriceType;
import org.mustangproject.ZUGFeRD.model.TradeProductType;
import org.mustangproject.ZUGFeRD.model.TradeSettlementMonetarySummationType;
import org.mustangproject.ZUGFeRD.model.TradeSettlementPaymentMeansType;
import org.mustangproject.ZUGFeRD.model.TradeTaxType;

public class ZUGFeRDExporter implements Closeable {


	private void init() {
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
	 * @deprecated Use the factory methods {@link #createFromPDFA3(String)}, {@link #createFromPDFA3(InputStream)} or
     *             the {@link ZUGFeRDExporterFromA1Factory} instead
	 *
	 */
    @Deprecated
	public ZUGFeRDExporter() {
		init();
	}

	public ZUGFeRDExporter(PDDocument doc2) {
		init();
		doc=doc2;

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
    @Deprecated
	private PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;

	// BASIC, COMFORT etc - may be set from outside.
    @Deprecated
	private ZUGFeRDConformanceLevel zUGFeRDConformanceLevel = ZUGFeRDConformanceLevel.EXTENDED;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally
	 * set, in which case passing a IZUGFeRDExportableTransaction is not
	 * necessary. By default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	byte[] zugferdData = null;
	private boolean isTest;
	IZUGFeRDExportableTransaction trans = null;
	@Deprecated
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
	 * PDF/A-3 has three conformance levels, called "A", "U" and "B".
	 *
	 * PDF/A-3-B where B means only visually preservable, U -standard for
	 * Mustang- means visually and unicode preservable and A means full
	 * compliance, i.e. visually, unicode and structurally preservable and
	 * tagged PDF, i.e. useful metainformation for blind people.
	 *
	 * Feel free to pass "A" as new level if you know what you are doing :-)
	 *
	 * @deprecated Use {@link ZUGFeRDExporterFromA1Factory} instead
	 */
    @Deprecated
	public void setConformanceLevel(PDFAConformanceLevel newLevel) {
		if (newLevel == null) {
			throw new NullPointerException("pdf conformance level");
		}
		conformanceLevel = newLevel;
	}

	/**
	 * All files are PDF/A-3, setConformance refers to the level conformance.
	 *
	 * PDF/A-3 has three conformance levels, called "A", "U" and "B".
	 *
	 * PDF/A-3-B where B means only visually preservable, U -standard for
	 * Mustang- means visually and unicode preservable and A means full
	 * compliance, i.e. visually, unicode and structurally preservable and
	 * tagged PDF, i.e. useful metainformation for blind people.
	 *
	 * Feel free to pass "A" as new level if you know what you are doing :-)
	 *
	 * @deprecated Use {@link #setConformanceLevel(org.mustangproject.ZUGFeRD.PDFAConformanceLevel)} instead
	 */
	@Deprecated
	public void setConformanceLevel(String newLevel) {
		conformanceLevel = PDFAConformanceLevel.findByLetter(newLevel);
	}

	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 *
	 */
	public void setTest() {
		isTest = true;
	}

    /**
     * @deprecated Use {@link ZUGFeRDExporterFromA1Factory} instead
     */
	@Deprecated
	public void ignoreA1Errors() {
		ignoreA1Errors = true;
	}

    /**
     * @deprecated Use the factory method {@link #createFromPDFA3(String)} instead
     */
	@Deprecated
    public void loadPDFA3(String filename) throws IOException {
        doc = PDDocument.load(new File(filename));
    }

	public static ZUGFeRDExporter createFromPDFA3(String filename) throws IOException {
		return new ZUGFeRDExporter(PDDocument.load(new File(filename)));
	}

    /**
     * @deprecated Use the factory method {@link #createFromPDFA3(InputStream)} instead
     */
	@Deprecated
	public void loadPDFA3(InputStream file) throws IOException {
		doc = PDDocument.load(file);
	}

	public static ZUGFeRDExporter createFromPDFA3(InputStream pdfSource) throws IOException {
		return new ZUGFeRDExporter(PDDocument.load(pdfSource));
	}

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
	 * the metadata level, this will not e.g. convert graphics to JPG-2000)
     *
     * @deprecated use the {@link ZUGFeRDExporterFromA1Factory} instead
	 *
	 */
	@Deprecated
	public PDDocumentCatalog PDFmakeA3compliant(String filename,
												String producer, String creator, boolean attachZugferdHeaders)
			throws IOException, TransformerException {

		doc = createPDFA1Factory()
            .setProducer(producer)
            .setCreator(creator)
            .setAttachZugferdHeaders(attachZugferdHeaders)
			.loadFromPDFA1(filename)
			.doc;

		return doc.getDocumentCatalog();
	}

	/**
     * @deprecated use the {@link ZUGFeRDExporterFromA1Factory} instead
     */
	@Deprecated
	public PDDocumentCatalog PDFmakeA3compliant(InputStream file,
			String producer, String creator, boolean attachZugferdHeaders) throws IOException, TransformerException {

		doc = createPDFA1Factory()
            .setProducer(producer)
            .setCreator(creator)
            .setAttachZugferdHeaders(attachZugferdHeaders)
			.loadFromPDFA1(file)
			.doc;

		return doc.getDocumentCatalog();
	}

	private ZUGFeRDExporterFromA1Factory createPDFA1Factory() {
		ZUGFeRDExporterFromA1Factory factory = new ZUGFeRDExporterFromA1Factory();
		if (ignoreA1Errors) {
			factory.ignoreA1Errors();
		}
		return factory
			.setZugferdConformanceLevel(zUGFeRDConformanceLevel)
			.setConformanceLevel(conformanceLevel);
	}

	@Override
	public void close() throws IOException {
		if (doc != null) {
			doc.close();
		}
	}

	private static final ObjectFactory xmlFactory = new ObjectFactory();
	private JAXBContext jaxbContext;
	private Marshaller marshaller;
	private static final SimpleDateFormat zugferdDateFormat = new SimpleDateFormat(
			"yyyyMMdd"); //$NON-NLS-1$

	private Totals totals;

	private String createZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans1) {
		this.trans = trans1;
		this.totals = new Totals();
		currency = trans1.getCurrency();

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
		idType.setValue(DocumentContextParameterTypeConstants.EXTENDED);
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
		issueDateTimeString.setFormat(DateTimeTypeConstants.DATE);
		issueDateTimeString.setValue(zugferdDateFormat.format(trans
				.getIssueDate()));
		issueDateTime.setDateTimeString(issueDateTimeString);
		document.setIssueDateTime(issueDateTime);

		DocumentCodeType documentCodeType = xmlFactory.createDocumentCodeType();
		documentCodeType.setValue(DocumentCodeTypeConstants.INVOICE);
		document.setTypeCode(documentCodeType);

		TextType name = xmlFactory.createTextType();
		name.setValue("RECHNUNG");
		document.getName().add(name);

		if (trans.getOwnOrganisationFullPlaintextInfo() != null) {
			NoteType regularInfo = xmlFactory.createNoteType();
			CodeType regularInfoSubjectCode = xmlFactory.createCodeType();
			regularInfoSubjectCode.setValue(NoteTypeConstants.REGULARINFO);
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
		buyerUstId.setSchemeID(TaxRegistrationTypeConstants.USTID);
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
		sellerTaxId.setSchemeID(TaxRegistrationTypeConstants.TAXID);
		sellerTaxRegistration.setID(sellerTaxId);
		sellerTradeParty.getSpecifiedTaxRegistration().add(
				sellerTaxRegistration);

		// Ust-ID
		sellerTaxRegistration = xmlFactory.createTaxRegistrationType();
		IDType sellerUstId = xmlFactory.createIDType();
		sellerUstId.setValue(trans.getOwnVATID());
		sellerUstId.setSchemeID(TaxRegistrationTypeConstants.USTID);
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
		deliveryDateString.setFormat(DateTimeTypeConstants.DATE);
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
		paymentDataType.setValue(PaymentMeansCodeTypeConstants.BANKACCOUNT);
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
			taxTypeCode.setValue(TaxTypeCodeTypeConstants.SALESTAX);
			tradeTax.setTypeCode(taxTypeCode);

			TaxCategoryCodeType taxCategoryCode = xmlFactory
					.createTaxCategoryCodeType();
			taxCategoryCode.setValue(TaxCategoryCodeTypeConstants.STANDARDRATE);
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
			taxType.setValue(TaxCategoryCodeTypeConstants.STANDARDRATE);
			tradeTax.setCategoryCode(taxType);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeTypeConstants.SALESTAX);
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
			taxType.setValue(TaxCategoryCodeTypeConstants.STANDARDRATE);
			tradeTax.setCategoryCode(taxType);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeTypeConstants.SALESTAX);
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
			taxType.setValue(TaxCategoryCodeTypeConstants.STANDARDRATE);
			tradeTax.setCategoryCode(taxType);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeTypeConstants.SALESTAX);
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
		dueDateString.setFormat(DateTimeTypeConstants.DATE);
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
			taxCategoryCode.setValue(TaxCategoryCodeTypeConstants.STANDARDRATE);
			tradeTax.setCategoryCode(taxCategoryCode);

			TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
			taxCode.setValue(TaxTypeCodeTypeConstants.SALESTAX);
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
	 * @return HashMap<BigDecimal, VATAmount>
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
	 * @param trans
	 *            a IZUGFeRDExportableTransaction that provides the data-model
	 *            to populate the XML. This parameter may be null, if so the XML
	 *            data should hav ebeen set via
	 *            <code>setZUGFeRDXMLData(byte[] zugferdData)</code>
	 */
	public void PDFattachZugferdFile(IZUGFeRDExportableTransaction trans1)
			throws IOException {

            if (zugferdData == null) // XML ZUGFeRD data not set externally, needs
                                                                    // to be built
            {
                    // create a dummy file stream, this would probably normally be a
                    // FileInputStream

                    byte[] zugferdRaw = createZugferdXMLForTransaction(trans1).getBytes(); //$NON-NLS-1$

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

	public void export(String ZUGFeRDfilename) throws IOException {
		doc.save(ZUGFeRDfilename);
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
	public void PDFAttachGenericFile(PDDocument doc1, String filename,
			String relationship, String description, String subType, byte[] data)
			throws IOException {
		PDComplexFileSpecification fs = new PDComplexFileSpecification();
		fs.setFile(filename);


		COSDictionary dict = fs.getCOSObject();
		dict.setName("AFRelationship", relationship);
		dict.setString("UF", filename);
		dict.setString("Desc", description);

		ByteArrayInputStream fakeFile = new ByteArrayInputStream(data);
		PDEmbeddedFile ef = new PDEmbeddedFile(doc1, fakeFile);
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
				doc1.getDocumentCatalog());
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
		doc1.getDocumentCatalog().setNames(names);

		// AF entry (Array) in catalog with the FileSpec
		COSArray cosArray = (COSArray) doc1.getDocumentCatalog()
				.getCOSObject().getItem("AF");
		if (cosArray == null) {
			cosArray = new COSArray();
		}
		cosArray.add(fs);
		COSDictionary dict2 = doc1.getDocumentCatalog().getCOSObject();
		COSArray array = new COSArray();
		array.add(fs.getCOSObject()); // see below
	        dict2.setItem("AF",array);
		doc1.getDocumentCatalog().getCOSObject().setItem("AF", cosArray);
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
	 * @param zUGFeRDConformanceLevel
	 *            the new conformance level
     *            
     * @deprecated Use {@link ZUGFeRDExporterFromA1Factory} instead            
	 */
	@Deprecated
	public void setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel zUGFeRDConformanceLevel) {
		if (zUGFeRDConformanceLevel == null) {
			throw new NullPointerException("ZUGFeRD conformance level");
		}
		this.zUGFeRDConformanceLevel = zUGFeRDConformanceLevel;
	}

	/**
	 * Sets the ZUGFeRD conformance level (override).
	 *
	 * @param zUGFeRDConformanceLevel
	 *            the new conformance level
	 *
	 * @deprecated Use {@link #setConformanceLevel(PDFAConformanceLevel)} instead
	 */
	@Deprecated
	public void setZUGFeRDConformanceLevel(String zUGFeRDConformanceLevel) {
		this.zUGFeRDConformanceLevel = ZUGFeRDConformanceLevel.valueOf(zUGFeRDConformanceLevel);
	}

	/****
	 * Returns the PDFBox PDF Document
	 *
	 * @return PDDocument
	 */
	public PDDocument getDoc() {
		return doc;
	}

}
