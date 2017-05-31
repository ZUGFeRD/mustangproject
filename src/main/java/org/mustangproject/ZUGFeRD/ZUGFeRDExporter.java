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
import java.io.FileInputStream;
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
	 * @throws ZUGFeRDExportException if the exporter could not be initialized
	 *
	 */
	public ZUGFeRDExporter() {
		init();
	}

	public ZUGFeRDExporter(PDDocument doc2) {
		init();
		doc=doc2;
		
	}

	private PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;

	// BASIC, COMFORT etc - may be set from outside.
	private ZUGFeRDConformanceLevel zUGFeRDConformanceLevel = ZUGFeRDConformanceLevel.EXTENDED;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally
	 * set, in which case passing a IZUGFeRDExportableTransaction is not
	 * necessary. By default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	byte[] zugferdData = null;
	private boolean isTest;
	private boolean ignoreA1Errors;
	private PDDocument doc;

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
	 *
	 */
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

	public void ignoreA1Errors() {
		ignoreA1Errors = true;
	}

	private boolean getA1ParserValidationResult(PreflightParser parser) throws IOException {
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
		}
		// display validation result
		return result.isValid();

	}


	/***
	 * Will return a boolean if the inputstream is valid PDF/A-1 and close the input stream
	 * @param file
	 * @return boolean
	 */
	public boolean isValidA1(InputStream file) throws IOException {
		return getA1ParserValidationResult(new PreflightParser(new ByteArrayDataSource(file)));
	}

	public void loadPDFA3(String filename) throws IOException {
		doc = PDDocument.load(new File(filename));
	}

	public void loadPDFA3(InputStream file) throws IOException {
			doc = PDDocument.load(file);
	}

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on
	 * the metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 */
	public PDDocumentCatalog PDFmakeA3compliant(String filename,
			String producer, String creator, boolean attachZugferdHeaders)
			throws IOException, TransformerException {
		
		if (!ignoreA1Errors && !isValidA1(new FileInputStream(filename))) {
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
				+ Version.VERSION + ")";

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
			// This should be impossible, because it would occur only if an illegal conformance level is
			// supplied, however the enum enforces that the conformance level is valid.
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

	private JAXBContext jaxbContext;
	private Marshaller marshaller;

	private String createZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans) {

		JAXBElement<CrossIndustryDocumentType> jaxElement =
			new ZUGFeRDTransactionModelConverter(trans).withTest(isTest).convertToModel();

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

	/**
	 * Embeds the Zugferd XML structure in a file named ZUGFeRD-invoice.xml.
	 *
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
	 * @param zUGFeRDConformanceLevel
	 *            the new conformance level
	 */
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

	/**
	 * * This will add both the RDF-indication which embedded file is Zugferd
	 * and the neccessary PDF/A schema extension description to be able to add
	 * this information to RDF
	 *
	 * @param metadata
	 */
	private void addZugferdXMP(XMPMetadata metadata) {

		XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata,
				this.zUGFeRDConformanceLevel);

		metadata.addSchema(zf);

		XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata);
                
		metadata.addSchema(pdfaex);

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
