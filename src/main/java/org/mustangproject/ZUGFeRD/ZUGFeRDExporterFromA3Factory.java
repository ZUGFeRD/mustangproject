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
import java.io.UnsupportedEncodingException;
import java.util.GregorianCalendar;

public class ZUGFeRDExporterFromA3Factory implements IExporterFactory {
	protected boolean ignorePDFAErrors = false;
	protected ZUGFeRDConformanceLevel zugferdConformanceLevel = ZUGFeRDConformanceLevel.EXTENDED;
	protected PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;
	protected String producer = "mustangproject";
	protected String creator = "mustangproject";
	protected boolean attachZugferdHeaders = true;
	

	protected PDMetadata metadata = null;
	protected PDFAIdentificationSchema pdfaid = null;
	protected XMPMetadata xmp = null;
	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfFilename
	 *            filename of an PDF/A1 compliant document
	 */
	public ZUGFeRDExporter load(String pdfFilename) throws IOException {
		ensurePDFIsValidPDFA(new FileDataSource(pdfFilename));
		PDDocument doc = PDDocument.load(new File(pdfFilename));
		prepareDocument(doc);
		return new ZUGFeRDExporter(doc);
	}
	
	
	public void prepareDocument(PDDocument doc) throws IOException {
		String fullProducer = producer + " (via mustangproject.org " + org.mustangproject.ZUGFeRD.Version.VERSION + ")";

		PDDocumentCatalog cat = doc.getDocumentCatalog();
		metadata = new PDMetadata(doc);
		cat.setMetadata(metadata);
		
		xmp = XMPMetadata.createXMPMetadata();

		pdfaid = new PDFAIdentificationSchema(xmp);

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

	}
		

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary
	 *            binary of a PDF/A1 compliant document
	 */
	public ZUGFeRDExporter load(byte[] pdfBinary) throws IOException {
		ensurePDFIsValidPDFA(new ByteArrayDataSource(new ByteArrayInputStream(pdfBinary)));
		ZUGFeRDExporter zugFeRDExporter;
		PDDocument doc = PDDocument.load(pdfBinary);
		prepareDocument(doc);
		zugFeRDExporter = new ZUGFeRDExporter(doc);

		return zugFeRDExporter;
	}

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfSource
	 *            source to read a PDF/A1 compliant document from
	 */
	public ZUGFeRDExporter load(InputStream pdfSource) throws IOException {
		return load(readAllBytes(pdfSource));
	}

	private void ensurePDFIsValidPDFA(final DataSource dataSource) throws IOException {
		if (!ignorePDFAErrors && !isValidA1(dataSource)) {
			throw new IOException("File is not a valid PDF/A input file");
		}
	}

	private static byte[] readAllBytes(InputStream in) throws IOException {
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		IOUtils.copy(in, buffer);
		return buffer.toByteArray();
	}

	public byte[] serializeXmpMetadata(XMPMetadata xmpMetadata) throws TransformerException {
		XmpSerializer serializer = new XmpSerializer();
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();

		String prefix="<?xpacket begin=\"\uFEFF\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?>";
		String suffix="<?xpacket end=\"w\"?>";
		
		try {
			buffer.write(prefix.getBytes("UTF-8")); // see https://github.com/ZUGFeRD/mustangproject/issues/44 
			serializer.serialize(xmpMetadata, buffer, false);
			buffer.write(suffix.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return buffer.toByteArray();
	}

	private static boolean isValidA1(DataSource dataSource) throws IOException {
		return getPDFAParserValidationResult(new PreflightParser(dataSource));
	}

	/**
	 * This will add both the RDF-indication which embedded file is Zugferd and the
	 * neccessary PDF/A schema extension description to be able to add this
	 * information to RDF
	 *
	 * @param metadata
	 */
	public void addXMP(XMPMetadata metadata) {

		if (attachZugferdHeaders) {
			XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata, zugferdConformanceLevel);

			metadata.addSchema(zf);
		}

		XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata, attachZugferdHeaders);

		metadata.addSchema(pdfaex);

	}

	/**
	 * Sets the ZUGFeRD conformance level (override).
	 *
	 * @param zugferdConformanceLevel
	 *            the new conformance level
	 */
	public IExporterFactory setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel zugferdConformanceLevel) {
		this.zugferdConformanceLevel = zugferdConformanceLevel;
		return this;
	}

	private static boolean getPDFAParserValidationResult(PreflightParser parser) throws IOException {
		/*
		 * Parse the PDF file with PreflightParser that inherits from the
		 * NonSequentialParser. Some additional controls are present to check a set of
		 * PDF/A requirements. (Stream length consistency, EOL after some Keyword...)
		 */
		parser.parse();

		try (PreflightDocument document = parser.getPreflightDocument()) {
			/*
			 * Once the syntax validation is done, the parser can provide a
			 * PreflightDocument (that inherits from PDDocument) This document process the
			 * end of PDF/A validation.
			 */

			document.validate();

			// Get validation result
			return document.getResult().isValid();
		} catch (ValidationException e) {
			/*
			 * the parse method can throw a SyntaxValidationException if the PDF file can't
			 * be parsed. In this case, the exception contains an instance of
			 * ValidationResult
			 */
			return false;
		}
	}

	/**
	 * All files are PDF/A-3, setConformance refers to the level conformance.
	 *
	 * PDF/A-3 has three coformance levels, called "A", "U" and "B".
	 *
	 * PDF/A-3-B where B means only visually preservable, U -standard for Mustang-
	 * means visually and unicode preservable and A means full compliance, i.e.
	 * visually, unicode and structurally preservable and tagged PDF, i.e. useful
	 * metainformation for blind people.
	 *
	 * Feel free to pass "A" as new level if you know what you are doing :-)
	 *
	 *
	 */
	public IExporterFactory setConformanceLevel(PDFAConformanceLevel newLevel) {
		conformanceLevel = newLevel;
		return this;
	}

	public IExporterFactory ignorePDFAErrors() {
		this.ignorePDFAErrors = true;
		return this;
	}

	public IExporterFactory setAttachZUGFeRDHeaders(final boolean attachZugferdHeaders) {
		this.attachZugferdHeaders = attachZugferdHeaders;
		return this;
	}

	public IExporterFactory setCreator(String creator) {
		this.creator = creator;
		return this;
	}

	public IExporterFactory setProducer(String producer) {
		this.producer = producer;
		return this;
	}
}
