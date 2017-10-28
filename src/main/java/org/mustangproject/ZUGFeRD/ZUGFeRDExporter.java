package org.mustangproject.ZUGFeRD;

/*
 * Mustangproject's ZUGFeRD implementation ZUGFeRD exporter Licensed under the
 * APLv2
 *
 * @date 2014-07-12
 * @version 1.2.0
 * @author jstaerk
 *
 */

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

import javax.xml.transform.TransformerException;
import java.io.ByteArrayInputStream;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

public class ZUGFeRDExporter implements Closeable {

	/**
	 * To use the ZUGFeRD exporter, implement IZUGFeRDExportableTransaction in
	 * yourTransaction (which will require you to implement Product, Item and
	 * Contact) then call doc = PDDocument.load(PDFfilename); // automatically add
	 * Zugferd to all outgoing invoices ZUGFeRDExporter ze = new ZUGFeRDExporter();
	 * ze.PDFmakeA3compliant(doc, "Your application name",
	 * System.getProperty("user.name"), true); ze.PDFattachZugferdFile(doc,
	 * yourTransaction);
	 *
	 * doc.save(PDFfilename);
	 *
	 * @author jstaerk
	 * @deprecated Use the factory methods {@link #createFromPDFA3(String)},
	 *             {@link #createFromPDFA3(InputStream)} or the
	 *             {@link ZUGFeRDExporterFromA1Factory} instead
	 *
	 */
	// // MAIN CLASS
	@Deprecated
	private PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;

	// BASIC, COMFORT etc - may be set from outside.
	@Deprecated
	private ZUGFeRDConformanceLevel zUGFeRDConformanceLevel = ZUGFeRDConformanceLevel.EXTENDED;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally set,
	 * in which case passing a IZUGFeRDExportableTransaction is not necessary. By
	 * default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	IXMLProvider xmlProvider;
	@Deprecated
	private boolean ignoreA1Errors;
	private PDDocument doc;
	int ZFVersion;

	public ZUGFeRDExporter() {
		init();
	}

	public ZUGFeRDExporter(PDDocument doc2) {
		doc = doc2;
		init();
	}

	public static String getNamespaceForVersion(int ver) {
		if (ver == 1) {
			return "urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#";
		} else if (ver == 2) {
			return "urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#";
		} else {
			throw new IllegalArgumentException("Version not supported");
		}
	}

	public static String getPrefixForVersion(int ver) {
		if (ver == 1) {
			return "zf";
		} else if (ver == 2) {
			return "fx";
		} else {
			throw new IllegalArgumentException("Version not supported");
		}
	}

	public static String getFilenameForVersion(int ver) {
		if (ver == 1) {
			return "ZUGFeRD-invoice.xml";
		} else if (ver == 2) {
			return "factur-x.xml";
		} else {
			throw new IllegalArgumentException("Version not supported");
		}
	}

	public void setZUGFeRDVersion(int ver) {
		if (ver == 1) {
			ZUGFeRD1PullProvider z1p = new ZUGFeRD1PullProvider();
			this.xmlProvider = z1p;
		} else if (ver == 2) {
			ZUGFeRD2PullProvider z2p = new ZUGFeRD2PullProvider();
			this.xmlProvider = z2p;
		} else {
			throw new IllegalArgumentException("Version not supported");
		}
		ZFVersion = ver;
	}
	
	public IXMLProvider getProvider() {
		return xmlProvider;
	}

	private void init() {
		setZUGFeRDVersion(2);
	}

	/**
	 * All files are PDF/A-3, setConformance refers to the level conformance.
	 *
	 * PDF/A-3 has three conformance levels, called "A", "U" and "B".
	 *
	 * PDF/A-3-B where B means only visually preservable, U -standard for Mustang-
	 * means visually and unicode preservable and A means full compliance, i.e.
	 * visually, unicode and structurally preservable and tagged PDF, i.e. useful
	 * metainformation for blind people.
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
	 * PDF/A-3-B where B means only visually preservable, U -standard for Mustang-
	 * means visually and unicode preservable and A means full compliance, i.e.
	 * visually, unicode and structurally preservable and tagged PDF, i.e. useful
	 * metainformation for blind people.
	 *
	 * Feel free to pass "A" as new level if you know what you are doing :-)
	 *
	 * @deprecated Use
	 *             {@link #setConformanceLevel(org.mustangproject.ZUGFeRD.PDFAConformanceLevel)}
	 *             instead
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
		xmlProvider.setTest();
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
	 * @deprecated Use the factory method {@link #createFromPDFA3(InputStream)}
	 *             instead
	 */
	@Deprecated
	public void loadPDFA3(InputStream file) throws IOException {
		doc = PDDocument.load(file);
	}

	public static ZUGFeRDExporter createFromPDFA3(InputStream pdfSource) throws IOException {
		return new ZUGFeRDExporter(PDDocument.load(pdfSource));
	}

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @deprecated use the {@link ZUGFeRDExporterFromA1Factory} instead
	 *
	 */
	@Deprecated
	public PDDocumentCatalog PDFmakeA3compliant(String filename, String producer, String creator,
			boolean attachZugferdHeaders) throws IOException, TransformerException {

		doc = createPDFA1Factory().setProducer(producer).setCreator(creator)
				.setAttachZUGFeRDHeaders(attachZugferdHeaders).load(filename).doc;

		return doc.getDocumentCatalog();
	}

	/**
	 * @deprecated use the {@link ZUGFeRDExporterFromA1Factory} instead
	 */
	@Deprecated
	public PDDocumentCatalog PDFmakeA3compliant(InputStream file, String producer, String creator,
			boolean attachZugferdHeaders) throws IOException, TransformerException {

		doc = createPDFA1Factory().setProducer(producer).setCreator(creator)
				.setAttachZUGFeRDHeaders(attachZugferdHeaders).load(file).doc;

		return doc.getDocumentCatalog();
	}

	private IExporterFactory createPDFA1Factory() {
		ZUGFeRDExporterFromA1Factory factory = new ZUGFeRDExporterFromA1Factory();
		if (ignoreA1Errors) {
			factory.ignorePDFAErrors();
		}
		return factory.setZUGFeRDConformanceLevel(zUGFeRDConformanceLevel).setConformanceLevel(conformanceLevel);
	}

	@Override
	public void close() throws IOException {
		if (doc != null) {
			doc.close();
		}
	}

	/**
	 * Embeds the Zugferd XML structure in a file named ZUGFeRD-invoice.xml.
	 *
	 * @param trans
	 *            a IZUGFeRDExportableTransaction that provides the data-model to
	 *            populate the XML. This parameter may be null, if so the XML data
	 *            should hav ebeen set via
	 *            <code>setZUGFeRDXMLData(byte[] zugferdData)</code>
	 */
	public void PDFattachZugferdFile(IZUGFeRDExportableTransaction trans) throws IOException {

		xmlProvider.generateXML(trans);
		String filename = getFilenameForVersion(ZFVersion);
		PDFAttachGenericFile(doc, filename, "Alternative",
				"Invoice metadata conforming to ZUGFeRD standard (http://www.ferd-net.de/front_content.php?idcat=231&lang=4)",
				"text/xml", xmlProvider.getXML());
	}

	public void export(String ZUGFeRDfilename) throws IOException {
		doc.save(ZUGFeRDfilename);
	}

	public void export(OutputStream output) throws IOException {
		doc.save(output);
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
	public void PDFAttachGenericFile(PDDocument doc, String filename, String relationship, String description,
			String subType, byte[] data) throws IOException {
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
		COSDictionary efDict = (COSDictionary) dict.getDictionaryObject(COSName.EF);
		COSBase lowerLevelFile = efDict.getItem(COSName.F);
		efDict.setItem(COSName.UF, lowerLevelFile);

		// now add the entry to the embedded file tree and set in the document.
		PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
		PDEmbeddedFilesNameTreeNode efTree = names.getEmbeddedFiles();
		if (efTree == null) {
			efTree = new PDEmbeddedFilesNameTreeNode();
		}

		Map<String, PDComplexFileSpecification> namesMap = new HashMap<>();

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
		COSArray cosArray = (COSArray) doc.getDocumentCatalog().getCOSObject().getItem("AF");
		if (cosArray == null) {
			cosArray = new COSArray();
		}
		cosArray.add(fs);
		COSDictionary dict2 = doc.getDocumentCatalog().getCOSObject();
		COSArray array = new COSArray();
		array.add(fs.getCOSObject()); // see below
		dict2.setItem("AF", array);
		doc.getDocumentCatalog().getCOSObject().setItem("AF", cosArray);
	}

	/**
	 * Sets the ZUGFeRD XML data to be attached as a single byte array. This is
	 * useful for use-cases where the XML has already been produced by some external
	 * API or component.
	 *
	 * @param zugferdData
	 *            XML data to be set as a byte array (XML file in raw form).
	 */
	public void setZUGFeRDXMLData(byte[] zugferdData) throws IOException {
		CustomXMLProvider cus = new CustomXMLProvider();
		cus.setXML(zugferdData);
		this.xmlProvider = cus;
		PDFattachZugferdFile(null);
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
