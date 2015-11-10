package org.mustangproject.ZUGFeRD;

/**
 * Mustangproject's ZUGFeRD implementation ZUGFeRD exporter Licensed under the
 * APLv2
 *
 * @date 2014-07-12
 * @version 1.1
 * @author jstaerk
 *
 */
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
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

import org.apache.jempbox.xmp.XMPMetadata;
import org.apache.jempbox.xmp.XMPSchemaBasic;
import org.apache.jempbox.xmp.XMPSchemaDublinCore;
import org.apache.jempbox.xmp.XMPSchemaPDF;
import org.apache.jempbox.xmp.pdfa.XMPSchemaPDFAId;
import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.COSObjectable;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.mustangproject.ZUGFeRD.model.*;

public class ZUGFeRDExporter {

    /**
     * *
     * You will need Apache PDFBox. To use the ZUGFeRD exporter, implement
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
     *
     */
    public ZUGFeRDExporter() throws JAXBException {
        jaxbContext = JAXBContext.newInstance("org.mustangproject.ZUGFeRD.model");
        marshaller = jaxbContext.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
    }

    private class LineCalc {

        private IZUGFeRDExportableItem currentItem = null;
        private BigDecimal totalGross;
        private BigDecimal itemTotalNetAmount;
        private BigDecimal itemTotalVATAmount;

        public LineCalc(IZUGFeRDExportableItem currentItem) {
            this.currentItem = currentItem;
            BigDecimal multiplicator = currentItem.getProduct().getVATPercent().divide(new BigDecimal(100)).add(new BigDecimal(1));
//			priceGross=currentItem.getPrice().multiply(multiplicator);
            totalGross = currentItem.getPrice().multiply(multiplicator).multiply(currentItem.getQuantity());
            itemTotalNetAmount = currentItem.getQuantity().multiply(currentItem.getPrice()).setScale(2, BigDecimal.ROUND_HALF_UP);
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
    private String conformanceLevel = "U";
    private String versionStr = "1.3.0";

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
        value = value.setScale(scale, BigDecimal.ROUND_HALF_UP); // first, round so that e.g. 1.189999999999999946709294817992486059665679931640625 becomes 1.19
        char[] repeat = new char[scale];
        Arrays.fill(repeat, '0');

        DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols();
        otherSymbols.setDecimalSeparator('.');
        DecimalFormat dec = new DecimalFormat("0." + new String(repeat), otherSymbols);
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

    /**
     * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
     * the metadata level, this will not e.g. convert graphics to JPG-2000)
     *
     */
    public PDDocumentCatalog PDFmakeA3compliant(PDDocument doc, String producer, String creator,
            boolean attachZugferdHeaders) throws IOException,
            TransformerException {
        String fullProducer = producer + " (via mustangproject.org " + versionStr + ")";
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

    private static final ObjectFactory xmlFactory = new ObjectFactory();
    private final JAXBContext jaxbContext;
    private final Marshaller marshaller;
    private static final SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy"); //$NON-NLS-1$
    private static final SimpleDateFormat zugferdDateFormat = new SimpleDateFormat("yyyyMMdd"); //$NON-NLS-1$

    private String getZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans) throws JAXBException {
        this.trans = trans;

        CrossIndustryDocumentType invoice = xmlFactory.createCrossIndustryDocumentType();

        invoice.setSpecifiedExchangedDocumentContext(this.getDocumentContext());
        invoice.setHeaderExchangedDocument(this.getDocument());
        invoice.setSpecifiedSupplyChainTradeTransaction(this.getTradeTransaction());

        JAXBElement<CrossIndustryDocumentType> jaxElement = xmlFactory.createCrossIndustryDocument(invoice);

        ByteArrayOutputStream outputXml = new ByteArrayOutputStream();
        marshaller.marshal(jaxElement, outputXml);

        return outputXml.toString();
    }

    private ExchangedDocumentContextType getDocumentContext() {

        ExchangedDocumentContextType context = xmlFactory.createExchangedDocumentContextType();
        DocumentContextParameterType contextParameter = xmlFactory.createDocumentContextParameterType();
        IDType idType = xmlFactory.createIDType();
        idType.setValue(DocumentContextParameterType.COMFORT);
        contextParameter.setID(idType);
        context.getGuidelineSpecifiedDocumentContextParameter().add(contextParameter);
        
        IndicatorType testIndicator = xmlFactory.createIndicatorType();
        testIndicator.setIndicator(isTest);
        context.setTestIndicator(testIndicator);

        return context;
    }

    private ExchangedDocumentType getDocument() {

        ExchangedDocumentType document = xmlFactory.createExchangedDocumentType();

        IDType id = xmlFactory.createIDType();
        id.setValue(trans.getNumber());
        document.setID(id);

        DateTimeType issueDateTime = xmlFactory.createDateTimeType();
        DateTimeType.DateTimeString issueDateTimeString = xmlFactory.createDateTimeTypeDateTimeString();
        issueDateTimeString.setFormat(DateTimeType.DateTimeString.DATE);
        issueDateTimeString.setValue(zugferdDateFormat.format(trans.getIssueDate()));
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
            regularInfoContent.setValue(trans.getOwnOrganisationFullPlaintextInfo());
            regularInfo.getContent().add(regularInfoContent);
            document.getIncludedNote().add(regularInfo);
        }

        return document;
    }

    private SupplyChainTradeTransactionType getTradeTransaction() {

        SupplyChainTradeTransactionType transaction = xmlFactory.createSupplyChainTradeTransactionType();
        transaction.getApplicableSupplyChainTradeAgreement().add(this.getTradeAgreement());
        transaction.setApplicableSupplyChainTradeDelivery(this.getTradeDelivery());
        transaction.setApplicableSupplyChainTradeSettlement(this.getTradeSettlement());
        transaction.getIncludedSupplyChainTradeLineItem().addAll(this.getLineItems());

        return transaction;
    }

    private SupplyChainTradeAgreementType getTradeAgreement() {

        SupplyChainTradeAgreementType tradeAgreement = xmlFactory.createSupplyChainTradeAgreementType();

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
        TaxRegistrationType buyerTaxRegistration = xmlFactory.createTaxRegistrationType();
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

        TradeAddressType sellerAddressType = xmlFactory.createTradeAddressType();
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
        TaxRegistrationType sellerTaxRegistration = xmlFactory.createTaxRegistrationType();
        IDType sellerTaxId = xmlFactory.createIDType();
        sellerTaxId.setValue(trans.getOwnTaxID());
        sellerTaxId.setSchemeID(TaxRegistrationType.TAXID);
        sellerTaxRegistration.setID(sellerTaxId);
        sellerTradeParty.getSpecifiedTaxRegistration().add(sellerTaxRegistration);

        // Ust-ID
        sellerTaxRegistration = xmlFactory.createTaxRegistrationType();
        IDType sellerUstId = xmlFactory.createIDType();
        sellerUstId.setValue(trans.getOwnVATID());
        sellerUstId.setSchemeID(TaxRegistrationType.USTID);
        sellerTaxRegistration.setID(sellerUstId);
        sellerTradeParty.getSpecifiedTaxRegistration().add(sellerTaxRegistration);

        return sellerTradeParty;
    }

    private SupplyChainTradeDeliveryType getTradeDelivery() {

        SupplyChainTradeDeliveryType tradeDelivery = xmlFactory.createSupplyChainTradeDeliveryType();
        SupplyChainEventType deliveryEvent = xmlFactory.createSupplyChainEventType();
        DateTimeType deliveryDate = xmlFactory.createDateTimeType();
        DateTimeType.DateTimeString deliveryDateString = xmlFactory.createDateTimeTypeDateTimeString();
        deliveryDateString.setFormat(DateTimeType.DateTimeString.DATE);
        deliveryDateString.setValue(zugferdDateFormat.format(trans.getDeliveryDate()));
        deliveryDate.setDateTimeString(deliveryDateString);
        deliveryEvent.getOccurrenceDateTime().add(deliveryDate);
        tradeDelivery.getActualDeliverySupplyChainEvent().add(deliveryEvent);

        return tradeDelivery;
    }

    private SupplyChainTradeSettlementType getTradeSettlement() {
        SupplyChainTradeSettlementType tradeSettlement = xmlFactory.createSupplyChainTradeSettlementType();

        TextType paymentReference = xmlFactory.createTextType();
        paymentReference.setValue(trans.getNumber());
        tradeSettlement.getPaymentReference().add(paymentReference);

        CodeType currencyCode = xmlFactory.createCodeType();
        currencyCode.setValue(trans.getInvoiceCurrency());
        tradeSettlement.setInvoiceCurrencyCode(currencyCode);

        tradeSettlement.getSpecifiedTradeSettlementPaymentMeans().add(this.getPaymentData());
        tradeSettlement.getApplicableTradeTax().addAll(this.getTradeTax());
        tradeSettlement.getSpecifiedTradePaymentTerms().addAll(this.getPaymentTerms());
        tradeSettlement.getSpecifiedTradeAllowanceCharge().addAll(this.getHeaderAllowances());
        tradeSettlement.setSpecifiedTradeSettlementMonetarySummation(this.getMonetarySummation());

        return tradeSettlement;
    }

    private TradeSettlementPaymentMeansType getPaymentData() {
        TradeSettlementPaymentMeansType paymentData = xmlFactory.createTradeSettlementPaymentMeansType();
        PaymentMeansCodeType paymentDataType = xmlFactory.createPaymentMeansCodeType();
        paymentDataType.setValue(PaymentMeansCodeType.BANKACCOUNT);
        paymentData.setTypeCode(paymentDataType);

        TextType paymentInfo = xmlFactory.createTextType();
        paymentInfo.setValue(trans.getOwnPaymentInfoText());
        paymentData.getInformation().add(paymentInfo);

        CreditorFinancialAccountType bankAccount = xmlFactory.createCreditorFinancialAccountType();
        IDType iban = xmlFactory.createIDType();
        iban.setValue(trans.getOwnIBAN());
        bankAccount.setIBANID(iban);
        paymentData.setPayeePartyCreditorFinancialAccount(bankAccount);

        CreditorFinancialInstitutionType bankData = xmlFactory.createCreditorFinancialInstitutionType();
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

        HashMap<BigDecimal, VATAmount> VATPercentAmountMap = this.getVATPercentAmountMap();
        for (BigDecimal currentTaxPercent : VATPercentAmountMap.keySet()) {

            TradeTaxType tradeTax = xmlFactory.createTradeTaxType();
            TaxTypeCodeType taxTypeCode = xmlFactory.createTaxTypeCodeType();
            taxTypeCode.setValue(TaxTypeCodeType.SALESTAX);
            tradeTax.setTypeCode(taxTypeCode);

            TaxCategoryCodeType taxCategoryCode = xmlFactory.createTaxCategoryCodeType();
            taxCategoryCode.setValue(TaxCategoryCodeType.STANDARDRATE);
            tradeTax.setCategoryCode(taxCategoryCode);

            VATAmount amount = VATPercentAmountMap.get(currentTaxPercent);

            PercentType taxPercent = xmlFactory.createPercentType();
            taxPercent.setValue(vatFormat(currentTaxPercent));
            tradeTax.setApplicablePercent(taxPercent);

            AmountType calculatedTaxAmount = xmlFactory.createAmountType();
            calculatedTaxAmount.setCurrencyID(trans.getInvoiceCurrency());
            calculatedTaxAmount.setValue(currencyFormat(amount.getCalculated()));
            tradeTax.getCalculatedAmount().add(calculatedTaxAmount);

            AmountType basisTaxAmount = xmlFactory.createAmountType();
            basisTaxAmount.setCurrencyID(trans.getInvoiceCurrency());
            basisTaxAmount.setValue(currencyFormat(amount.getBasis()));
            tradeTax.getBasisAmount().add(basisTaxAmount);

            tradeTaxTypes.add(tradeTax);
        }

        return tradeTaxTypes;
    }

    private Collection<TradeAllowanceChargeType> getHeaderAllowances() {
        List<TradeAllowanceChargeType> headerAllowances = new ArrayList<TradeAllowanceChargeType>();

        for (IZUGFeRDAllowanceCharge iAllowance : trans.getZFAllowances()) {
            
            TradeAllowanceChargeType allowance = xmlFactory.createTradeAllowanceChargeType();
            
            IndicatorType chargeIndicator = xmlFactory.createIndicatorType();
            chargeIndicator.setIndicator(false);
            allowance.setChargeIndicator(chargeIndicator);
            
            TextType reason = xmlFactory.createTextType();
            reason.setValue(iAllowance.getReason());
            allowance.setReason(reason);
            
            TradeTaxType tradeTax = xmlFactory.createTradeTaxType();
            
            PercentType vatPercent = xmlFactory.createPercentType();
            vatPercent.setValue(iAllowance.getTaxPercent());
            tradeTax.setApplicablePercent(vatPercent);
            
            TaxCategoryCodeType taxType = xmlFactory.createTaxCategoryCodeType();
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

    private Collection<TradePaymentTermsType> getPaymentTerms() {
        List<TradePaymentTermsType> paymentTerms = new ArrayList<TradePaymentTermsType>();

        TradePaymentTermsType paymentTerm = xmlFactory.createTradePaymentTermsType();
        DateTimeType dueDate = xmlFactory.createDateTimeType();
        DateTimeType.DateTimeString dueDateString = xmlFactory.createDateTimeTypeDateTimeString();
        dueDateString.setFormat(DateTimeType.DateTimeString.DATE);
        dueDateString.setValue(zugferdDateFormat.format(trans.getDueDate()));
        dueDate.setDateTimeString(dueDateString);
        paymentTerm.setDueDateDateTime(dueDate);

        TextType paymentTermDescr = xmlFactory.createTextType();

        paymentTermDescr.setValue(trans.getPaymentTermDescription());
        paymentTerm.getDescription().add(paymentTermDescr);

        paymentTerms.add(paymentTerm);

        return paymentTerms;
    }    

    private TradeSettlementMonetarySummationType getMonetarySummation() {
        TradeSettlementMonetarySummationType monetarySummation = xmlFactory.createTradeSettlementMonetarySummationType();
        AmountType allowanceTotalAmount = xmlFactory.createAmountType();
        allowanceTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
        allowanceTotalAmount.setValue(currencyFormat(BigDecimal.ZERO));
        monetarySummation.getAllowanceTotalAmount().add(allowanceTotalAmount);

        AmountType chargeTotalAmount = xmlFactory.createAmountType();
        chargeTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
        chargeTotalAmount.setValue(currencyFormat(BigDecimal.ZERO));
        monetarySummation.getChargeTotalAmount().add(chargeTotalAmount);

        AmountType lineTotalAmount = xmlFactory.createAmountType();
        lineTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
        lineTotalAmount.setValue(currencyFormat(this.getTotal()));
        monetarySummation.getLineTotalAmount().add(lineTotalAmount);

        AmountType taxBasisTotalAmount = xmlFactory.createAmountType();
        taxBasisTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
        taxBasisTotalAmount.setValue(currencyFormat(this.getTotal()));
        monetarySummation.getTaxBasisTotalAmount().add(taxBasisTotalAmount);

        AmountType taxTotalAmount = xmlFactory.createAmountType();
        taxTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
        taxTotalAmount.setValue(currencyFormat(this.getTotalGross().subtract(this.getTotal())));
        monetarySummation.getTaxTotalAmount().add(taxTotalAmount);

        AmountType grandTotalAmount = xmlFactory.createAmountType();
        grandTotalAmount.setCurrencyID(trans.getInvoiceCurrency());
        grandTotalAmount.setValue(currencyFormat(this.getTotalGross()));
        monetarySummation.getGrandTotalAmount().add(grandTotalAmount);

        AmountType duePayableAmount = xmlFactory.createAmountType();
        duePayableAmount.setCurrencyID(trans.getInvoiceCurrency());
        duePayableAmount.setValue(currencyFormat(this.getTotalGross()));
        monetarySummation.getDuePayableAmount().add(duePayableAmount);

        return monetarySummation;
    }

    private Collection<SupplyChainTradeLineItemType> getLineItems() {

        ArrayList<SupplyChainTradeLineItemType> lineItems = new ArrayList<SupplyChainTradeLineItemType>();
        int lineID = 0;
        for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
            lineID++;
            LineCalc lc = new LineCalc(currentItem);
            SupplyChainTradeLineItemType lineItem = xmlFactory.createSupplyChainTradeLineItemType();

            DocumentLineDocumentType lineDocument = xmlFactory.createDocumentLineDocumentType();
            IDType lineNumber = xmlFactory.createIDType();
            lineNumber.setValue(Integer.toString(lineID));
            lineDocument.setLineID(lineNumber);
            lineItem.setAssociatedDocumentLineDocument(lineDocument);

            SupplyChainTradeAgreementType tradeAgreement = xmlFactory.createSupplyChainTradeAgreementType();
            TradePriceType grossTradePrice = xmlFactory.createTradePriceType();
            QuantityType grossQuantity = xmlFactory.createQuantityType();
            grossQuantity.setUnitCode(currentItem.getProduct().getUnit());
            grossQuantity.setValue(quantityFormat(BigDecimal.ONE));
            grossTradePrice.setBasisQuantity(grossQuantity);

            AmountType grossChargeAmount = xmlFactory.createAmountType();
            grossChargeAmount.setCurrencyID(trans.getInvoiceCurrency());
            grossChargeAmount.setValue(priceFormat(currentItem.getPrice()));
            grossTradePrice.getChargeAmount().add(grossChargeAmount);
            tradeAgreement.getGrossPriceProductTradePrice().add(grossTradePrice);

            TradePriceType netTradePrice = xmlFactory.createTradePriceType();
            QuantityType netQuantity = xmlFactory.createQuantityType();
            netQuantity.setUnitCode(currentItem.getProduct().getUnit());
            netQuantity.setValue(quantityFormat(BigDecimal.ONE));
            netTradePrice.setBasisQuantity(netQuantity);

            AmountType netChargeAmount = xmlFactory.createAmountType();
            netChargeAmount.setCurrencyID(trans.getInvoiceCurrency());
            netChargeAmount.setValue(priceFormat(currentItem.getPrice()));
            netTradePrice.getChargeAmount().add(netChargeAmount);
            tradeAgreement.getNetPriceProductTradePrice().add(netTradePrice);

            lineItem.setSpecifiedSupplyChainTradeAgreement(tradeAgreement);

            SupplyChainTradeDeliveryType tradeDelivery = xmlFactory.createSupplyChainTradeDeliveryType();
            QuantityType billedQuantity = xmlFactory.createQuantityType();
            billedQuantity.setUnitCode(currentItem.getProduct().getUnit());
            billedQuantity.setValue(quantityFormat(currentItem.getQuantity()));
            tradeDelivery.setBilledQuantity(billedQuantity);
            lineItem.setSpecifiedSupplyChainTradeDelivery(tradeDelivery);

            SupplyChainTradeSettlementType tradeSettlement = xmlFactory.createSupplyChainTradeSettlementType();
            TradeTaxType tradeTax = xmlFactory.createTradeTaxType();
            
            TaxCategoryCodeType taxCategoryCode = xmlFactory.createTaxCategoryCodeType();
            taxCategoryCode.setValue(TaxCategoryCodeType.STANDARDRATE);
            tradeTax.setCategoryCode(taxCategoryCode);
            
            TaxTypeCodeType taxCode = xmlFactory.createTaxTypeCodeType();
            taxCode.setValue(TaxTypeCodeType.SALESTAX);
            tradeTax.setTypeCode(taxCode);
            
            PercentType taxPercent = xmlFactory.createPercentType();
            taxPercent.setValue(vatFormat(currentItem.getProduct().getVATPercent()));
            tradeTax.setApplicablePercent(taxPercent);
            tradeSettlement.getApplicableTradeTax().add(tradeTax);

            TradeSettlementMonetarySummationType monetarySummation = xmlFactory.createTradeSettlementMonetarySummationType();
            AmountType itemAmount = xmlFactory.createAmountType();
            itemAmount.setCurrencyID(trans.getInvoiceCurrency());
            itemAmount.setValue(currencyFormat(lc.getItemTotalNetAmount()));
            monetarySummation.getLineTotalAmount().add(itemAmount);
            tradeSettlement.setSpecifiedTradeSettlementMonetarySummation(monetarySummation);

            lineItem.setSpecifiedSupplyChainTradeSettlement(tradeSettlement);

            TradeProductType tradeProduct = xmlFactory.createTradeProductType();
            TextType productName = xmlFactory.createTextType();
            productName.setValue(currentItem.getProduct().getName());
            tradeProduct.getName().add(productName);

            TextType productDescription = xmlFactory.createTextType();
            productDescription.setValue(currentItem.getProduct().getDescription());
            tradeProduct.getDescription().add(productDescription);
            lineItem.setSpecifiedTradeProduct(tradeProduct);

            lineItems.add(lineItem);
        }

        return lineItems;

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
     * which taxes have been used with which amounts in this transaction, empty
     * for no taxes, or e.g. 19=>190 and 7=>14 if 1000 Eur were applicable to
     * 19% VAT (=>190 EUR VAT) and 200 EUR were applicable to 7% (=>14 EUR VAT)
     * 190 Eur
     *
     * @return
     *
     */
    private HashMap<BigDecimal, VATAmount> getVATPercentAmountMap() {
        HashMap<BigDecimal, VATAmount> hm = new HashMap<BigDecimal, VATAmount>();

        for (IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
            BigDecimal percent = currentItem.getProduct().getVATPercent();
            LineCalc lc = new LineCalc(currentItem);
            VATAmount itemVATAmount = new VATAmount(lc.getItemTotalNetAmount(), lc.getItemTotalVATAmount());
            VATAmount current = hm.get(percent);
            if (current == null) {
                hm.put(percent, itemVATAmount);
            } else {
                hm.put(percent, current.add(itemVATAmount));

            }
        }

        return hm;
    }

    /**
     * Embeds the Zugferd XML structure in a file named ZUGFeRD-invoice.xml.
     *
     * @param doc PDDocument to attach an XML invoice to
     * @param trans a IZUGFeRDExportableTransaction that provides the data-model
     * to populate the XML. This parameter may be null, if so the XML data
     * should hav ebeen set via
     * <code>setZUGFeRDXMLData(byte[] zugferdData)</code>
     */
    public void PDFattachZugferdFile(PDDocument doc, IZUGFeRDExportableTransaction trans) throws IOException, JAXBException {

        if (zugferdData == null) // XML ZUGFeRD data not set externally, needs to be built
        {
            // create a dummy file stream, this would probably normally be a
            // FileInputStream

            byte[] zugferdRaw = getZugferdXMLForTransaction(trans).getBytes(); //$NON-NLS-1$

            if ((zugferdRaw[0] == (byte) 0xEF) && (zugferdRaw[1] == (byte) 0xBB) && (zugferdRaw[2] == (byte) 0xBF)) {
                // I don't like BOMs, lets remove it
                zugferdData = new byte[zugferdRaw.length - 3];
                System.arraycopy(zugferdRaw, 3, zugferdData, 0, zugferdRaw.length - 3);
            } else {
                zugferdData = zugferdRaw;
            }
        }

        PDFAttachGenericFile(doc, "ZUGFeRD-invoice.xml", "Alternative", "Invoice metadata conforming to ZUGFeRD standard (http://www.ferd-net.de/front_content.php?idcat=231&lang=4)", "text/xml", zugferdData);
    }

    /**
     * Embeds an external file (generic - any type allowed) in the PDF.
     *
     * @param doc PDDocument to attach the file to.
     * @param filename name of the file that will become attachment name in the
     * PDF
     * @param relationship how the file relates to the content, e.g.
     * "Alternative"
     * @param description Human-readable description of the file content
     * @param subType type of the data e.g. could be "text/xml" - mime like
     * @param data the binary data of the file/attachment
     */
    public void PDFAttachGenericFile(PDDocument doc, String filename, String relationship, String description, String subType, byte[] data)
            throws IOException {
        PDComplexFileSpecification fs = new PDComplexFileSpecification();
        fs.setFile(filename);

        COSDictionary dict = fs.getCOSDictionary();
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
        dict = fs.getCOSDictionary();
        COSDictionary efDict = (COSDictionary) dict.getDictionaryObject(COSName.EF);
        COSBase lowerLevelFile = efDict.getItem(COSName.F);
        efDict.setItem(COSName.UF, lowerLevelFile);

        // now add the entry to the embedded file tree and set in the document.
        PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
        PDEmbeddedFilesNameTreeNode efTree = names.getEmbeddedFiles();
        if (efTree == null) {
            efTree = new PDEmbeddedFilesNameTreeNode();
        }

        Map<String, COSObjectable> namesMap = new HashMap<String, COSObjectable>();
        Map<String, COSObjectable> oldNamesMap = efTree.getNames();
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
        COSArray cosArray = (COSArray) doc.getDocumentCatalog().getCOSDictionary().getItem("AF");
        if (cosArray == null) {
            cosArray = new COSArray();
        }
        cosArray.add(fs);
        doc.getDocumentCatalog().getCOSDictionary().setItem("AF", cosArray);
    }

    /**
     * Sets the ZUGFeRD XML data to be attached as a single byte array. This is
     * useful for use-cases where the XML has already been produced by some
     * external API or component.
     *
     * @param zugferdData XML data to be set as a byte array (XML file in raw
     * form).
     */
    public void setZUGFeRDXMLData(byte[] zugferdData) {
        this.zugferdData = zugferdData;
    }

    /**
     * Sets the ZUGFeRD conformance level (override).
     *
     * @param ZUGFeRDConformanceLevel the new conformance level
     */
    public void setZUGFeRDConformanceLevel(String ZUGFeRDConformanceLevel) {
        this.ZUGFeRDConformanceLevel = ZUGFeRDConformanceLevel;
    }

    /**
     * *
     * This will add both the RDF-indication which embedded file is Zugferd and
     * the neccessary PDF/A schema extension description to be able to add this
     * information to RDF
     *
     * @param metadata
     */
    private void addZugferdXMP(XMPMetadata metadata) {

        XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata, this.ZUGFeRDConformanceLevel);
        zf.setAbout(""); //$NON-NLS-1$
        metadata.addSchema(zf);

        XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata);
        pdfaex.setAbout(""); //$NON-NLS-1$
        metadata.addSchema(pdfaex);

    }

}
