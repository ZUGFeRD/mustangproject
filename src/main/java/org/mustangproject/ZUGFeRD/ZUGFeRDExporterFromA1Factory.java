package org.mustangproject.ZUGFeRD;

import org.apache.pdfbox.io.IOUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;
import org.apache.pdfbox.preflight.utils.ByteArrayDataSource;
import org.apache.pdfbox.util.Version;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.AdobePDFSchema;
import org.apache.xmpbox.schema.DublinCoreSchema;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.xmpbox.schema.XMPBasicSchema;
import org.apache.xmpbox.type.BadFieldValueException;
import org.apache.xmpbox.xml.XmpSerializer;

import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.xml.transform.TransformerException;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.GregorianCalendar;

public class ZUGFeRDExporterFromA1Factory {
    private boolean ignoreA1Errors = false;
    private ZUGFeRDConformanceLevel zugferdConformanceLevel = ZUGFeRDConformanceLevel.EXTENDED;
    private PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;
    private String producer = "mustangproject";
    private String creator = "mustangproject";
    private boolean attachZugferdHeaders = true;

    /**
     * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
     * the metadata level, this will not e.g. convert graphics to JPG-2000)
     *
     * @param pdfFilename filename of an PDF/A1 compliant document
     */
    public ZUGFeRDExporter loadFromPDFA1(String pdfFilename) throws IOException {
        ensurePDFIsValidA1(new FileDataSource(pdfFilename));
        PDDocument doc = PDDocument.load(new File(pdfFilename));
        makePDFA3compliant(doc);
        return new ZUGFeRDExporter(doc);
    }

    /**
     * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
     * the metadata level, this will not e.g. convert graphics to JPG-2000)
     *
     * @param pdfBinary binary of a PDF/A1 compliant document
     */
    public ZUGFeRDExporter loadFromPDFA1(byte[] pdfBinary) throws IOException {
        ensurePDFIsValidA1(new ByteArrayDataSource(new ByteArrayInputStream(pdfBinary)));
        ZUGFeRDExporter zugFeRDExporter;
        PDDocument doc = PDDocument.load(pdfBinary);
        makePDFA3compliant(doc);
        zugFeRDExporter = new ZUGFeRDExporter(doc);

		return zugFeRDExporter;
    }

    /**
     * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
     * the metadata level, this will not e.g. convert graphics to JPG-2000)
     *
     * @param pdfSource source to read a PDF/A1 compliant document from
     */
    public ZUGFeRDExporter loadFromPDFA1(InputStream pdfSource) throws IOException {
        return loadFromPDFA1(readAllBytes(pdfSource));
    }

    private void ensurePDFIsValidA1(final DataSource dataSource) throws IOException {
        if (!ignoreA1Errors && !isValidA1(dataSource)) {
            throw new IOException("File is not a valid PDF/A-1 input file");
        }
    }

    private static byte[] readAllBytes(InputStream in) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        IOUtils.copy(in, buffer);
        return buffer.toByteArray();
    }

    private void makePDFA3compliant(PDDocument doc) throws IOException {
        String fullProducer = producer + " (via mustangproject.org "+org.mustangproject.ZUGFeRD.Version.VERSION+")";

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
            pdfaid.setConformance(conformanceLevel.getLetter());//$NON-NLS-1$ //$NON-NLS-1$
        } catch (BadFieldValueException ex) {
            // This should be impossible, because it would occur only if an illegal conformance level is supplied,
            // however the enum enforces that the conformance level is valid.
            throw new Error(ex);
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


        try {
            metadata.importXMPMetadata(serializeXmpMetadata(xmp));
        } catch (TransformerException e) {
            throw new ZUGFeRDExportException("Could not export XmpMetadata", e);
        }
    }

    private static byte[] serializeXmpMetadata(XMPMetadata xmpMetadata) throws TransformerException {
        XmpSerializer serializer = new XmpSerializer();
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        serializer.serialize(xmpMetadata, buffer, false);
        return buffer.toByteArray();
    }

    private static boolean isValidA1(DataSource dataSource) throws IOException {
        return getA1ParserValidationResult(new PreflightParser(dataSource));
    }

    /**
     * This will add both the RDF-indication which embedded file is Zugferd
     * and the neccessary PDF/A schema extension description to be able to add
     * this information to RDF
     *
     * @param metadata
     */
    private void addZugferdXMP(XMPMetadata metadata) {

        XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata, zugferdConformanceLevel);

        metadata.addSchema(zf);

        XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata);

        metadata.addSchema(pdfaex);

    }

    /**
     * Sets the ZUGFeRD conformance level (override).
     *
     * @param zugferdConformanceLevel
     *            the new conformance level
     */
    public ZUGFeRDExporterFromA1Factory setZugferdConformanceLevel(ZUGFeRDConformanceLevel zugferdConformanceLevel) {
        this.zugferdConformanceLevel = zugferdConformanceLevel;
        return this;
    }

    private static boolean getA1ParserValidationResult(PreflightParser parser) throws IOException {
		/*
		 * Parse the PDF file with PreflightParser that inherits from the
		 * NonSequentialParser. Some additional controls are present to
		 * check a set of PDF/A requirements. (Stream length consistency,
		 * EOL after some Keyword...)
		 */
        parser.parse();


        try ( PreflightDocument document = parser.getPreflightDocument()) {
			/*
			 * Once the syntax validation is done, the parser can provide a
			 * PreflightDocument (that inherits from PDDocument) This document
			 * process the end of PDF/A validation.
			 */

            document.validate();

            // Get validation result
            return document.getResult().isValid();
        } catch (ValidationException e) {
			/*
			 * the parse method can throw a SyntaxValidationException if the PDF
			 * file can't be parsed. In this case, the exception contains an
			 * instance of ValidationResult
			 */
            return false;
        }
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
    public ZUGFeRDExporterFromA1Factory setConformanceLevel(PDFAConformanceLevel newLevel) {
        conformanceLevel = newLevel;
        return this;
    }

    public ZUGFeRDExporterFromA1Factory ignoreA1Errors() {
        this.ignoreA1Errors = true;
        return this;
    }

    public ZUGFeRDExporterFromA1Factory setAttachZugferdHeaders(final boolean attachZugferdHeaders) {
        this.attachZugferdHeaders = attachZugferdHeaders;
        return this;
    }

    public ZUGFeRDExporterFromA1Factory setCreator(String creator) {
        this.creator = creator;
        return this;
    }

    public ZUGFeRDExporterFromA1Factory setProducer(String producer) {
        this.producer = producer;
        return this;
    }
}
