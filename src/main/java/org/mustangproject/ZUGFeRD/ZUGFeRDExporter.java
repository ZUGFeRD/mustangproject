
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

/*
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
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;
import javax.xml.transform.TransformerException;
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
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.AdobePDFSchema;
import org.apache.xmpbox.schema.DublinCoreSchema;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.xmpbox.schema.XMPBasicSchema;
import org.apache.xmpbox.type.BadFieldValueException;
import org.apache.xmpbox.xml.XmpSerializer;

public class ZUGFeRDExporter implements Closeable {

	public static final int DefaultZUGFeRDVersion = 1;

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
	private ZUGFeRDConformanceLevel profile = ZUGFeRDConformanceLevel.EXTENDED;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally set,
	 * in which case passing a IZUGFeRDExportableTransaction is not necessary. By
	 * default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	IXMLProvider xmlProvider;
	protected PDMetadata metadata = null;
	protected PDFAIdentificationSchema pdfaid = null;
	protected XMPMetadata xmp = null;
	/** Producer attribute for PDF */
	protected String producer = "mustangproject";
	/** Author/Creator attribute for PDF for PDF */
	protected String creator = "mustangproject";
	/** CreatorTool */
	protected String creatorTool = "mustangproject";

	@Deprecated
	private boolean ignoreA1Errors;
	protected boolean ensurePDFisUpgraded = true;
	private PDDocument doc;
	int ZFVersion;

	private boolean disableAutoClose;

	private boolean fileAttached = false;
	protected boolean attachZUGFeRDHeaders = true;

	private boolean documentPrepared=false;

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

	@Deprecated
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
		setZUGFeRDVersion(DefaultZUGFeRDVersion);
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

		doc = createPDFA1Factory().setProducer(producer).setCreator(creator).load(filename).doc;

		return doc.getDocumentCatalog();
	}

	/**
	 * @deprecated use the {@link ZUGFeRDExporterFromA1Factory} instead
	 */
	@Deprecated
	public PDDocumentCatalog PDFmakeA3compliant(InputStream file, String producer, String creator,
			boolean attachZugferdHeaders) throws IOException, TransformerException {

		doc = createPDFA1Factory().setProducer(producer).setCreator(creator).load(file).doc;

		return doc.getDocumentCatalog();
	}

	private IExporterFactory createPDFA1Factory() {
		ZUGFeRDExporterFromA1Factory factory = new ZUGFeRDExporterFromA1Factory();
		if (ignoreA1Errors) {
			factory.ignorePDFAErrors();
		}
		return factory.setZUGFeRDConformanceLevel(profile).setConformanceLevel(conformanceLevel);
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
		prepareDocument();

		xmlProvider.generateXML(trans);
		String filename = getFilenameForVersion(ZFVersion);
		PDFAttachGenericFile(doc, filename, "Alternative",
				"Invoice metadata conforming to ZUGFeRD standard (http://www.ferd-net.de/front_content.php?idcat=231&lang=4)",
				"text/xml", xmlProvider.getXML());

		if ((ZFVersion>1)&&(trans!=null)) {
			/*
			 *  Also attach a ZF1 file for backward compatibility, but only in case
			 *  if we do not e.g. embed custom XML (in which case, if its v2, the v1 provider won't be able to deliver data)
			 */
			setZUGFeRDVersion(1);
			xmlProvider.generateXML(trans);
			filename = getFilenameForVersion(ZFVersion);
			PDFAttachGenericFile(doc, filename, "Alternative",
					"Invoice metadata conforming to ZUGFeRD standard (http://www.ferd-net.de/front_content.php?idcat=231&lang=4)",
					"text/xml", xmlProvider.getXML());
			
			
		}
	}

	public void export(String ZUGFeRDfilename) throws IOException {
		if (!documentPrepared) {
			prepareDocument();
		}
		if ((!fileAttached)&&(attachZUGFeRDHeaders)) {
			throw new IOException(
					"File must be attached (usually with PDFattachZugferdFile) before perfoming this operation");
		}
		doc.save(ZUGFeRDfilename);
		if (!disableAutoClose) {
			close();
		}
	}

	public void export(OutputStream output) throws IOException {
		if (!fileAttached) {
			throw new IOException(
					"File must be attached (usually with PDFattachZugferdFile) before perfoming this operation");
		}
		doc.save(output);
		if (!disableAutoClose) {
			close();
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
	public void PDFAttachGenericFile(PDDocument doc, String filename, String relationship, String description,
			String subType, byte[] data) throws IOException {
		fileAttached = true;

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
		this.profile = zUGFeRDConformanceLevel;
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
		this.profile = ZUGFeRDConformanceLevel.valueOf(zUGFeRDConformanceLevel);
	}

	/****
	 * Returns the PDFBox PDF Document
	 *
	 * @return PDDocument the PDFBox PDF
	 */
	public PDDocument getDoc() {
		return doc;
	}

	/**
	 * This will add both the RDF-indication which embedded file is Zugferd and the
	 * neccessary PDF/A schema extension description to be able to add this
	 * information to RDF
	 *
	 * @param metadata
	 */
	protected void addXMP(XMPMetadata metadata) {

		if (attachZUGFeRDHeaders) {
			XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata, profile,
					ZUGFeRDExporter.getNamespaceForVersion(ZFVersion), ZUGFeRDExporter.getPrefixForVersion(ZFVersion),
					ZUGFeRDExporter.getFilenameForVersion(ZFVersion));

			metadata.addSchema(zf);
		}

		XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(metadata, ZFVersion, attachZUGFeRDHeaders);
		pdfaex.setZUGFeRDVersion(ZFVersion);
		metadata.addSchema(pdfaex);

	}

	protected byte[] serializeXmpMetadata(XMPMetadata xmpMetadata) throws TransformerException {
		XmpSerializer serializer = new XmpSerializer();
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();

		String prefix = "<?xpacket begin=\"\uFEFF\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?>";
		String suffix = "<?xpacket end=\"w\"?>";

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

	protected void prepareDocument() throws IOException {
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

		xsb.setCreatorTool(creatorTool);
		xsb.setCreateDate(GregorianCalendar.getInstance());
		// PDDocumentInformation pdi=doc.getDocumentInformation();
		PDDocumentInformation pdi = new PDDocumentInformation();
		pdi.setProducer(fullProducer);
		pdi.setAuthor(creator);
		doc.setDocumentInformation(pdi);

		AdobePDFSchema pdf = xmp.createAndAddAdobePDFSchema();
		pdf.setProducer(fullProducer);
		if (ensurePDFisUpgraded) {
			try {
				pdfaid.setConformance(conformanceLevel.getLetter());// $NON-NLS-1$ //$NON-NLS-1$
			} catch (BadFieldValueException ex) {
				// This should be impossible, because it would occur only if an illegal
				// conformance level is supplied,
				// however the enum enforces that the conformance level is valid.
				throw new Error(ex);
			}

			pdfaid.setPart(3);
		}
		addXMP(xmp); /*
							 * this is the only line where we do something Zugferd-specific, i.e. add PDF
							 * metadata specifically for Zugferd, not generically for a embedded file
							 */

	
		try {
			metadata.importXMPMetadata(serializeXmpMetadata(xmp));

		} catch (TransformerException e) {
			throw new ZUGFeRDExportException("Could not export XmpMetadata", e);
		}
		documentPrepared=true;
	}

	/**
	 * 
	 * @return if pdf file will be automatically closed after adding ZF
	 */
	public boolean isAutoCloseDisabled() {
		return disableAutoClose;
	}
	
	/**
	 * 
	 * @param disableAutoClose prevent PDF file from being closed after adding ZF
	 */
	public void disableAutoClose(boolean disableAutoClose) {
		this.disableAutoClose = disableAutoClose;
	}

	/**
	 * the human author (use factory method instead) 
	 * @param creator
	 */
	@Deprecated
	public void setCreator(String creator) {
		this.creator = creator;
	}
	/**
	 * the CreatorTool attribute for the PDF
	 * @param creator
	 */
	protected void setCreatorTool(String creatorTool) {
		this.creatorTool = creatorTool;
	}
	
	/**
	 * the authoring software (use factory method instead) 
	 * @param producer
	 */
	@Deprecated
	public void setProducer(String producer) {
		this.producer = producer;
	}

	/**
	 * 
	 * @param ensurePDFisUpgraded if not set the PDF/A won't be relabelled A/3, e.g. if it already is one
	 */
	public void setPDFA3(boolean ensurePDFisUpgraded) {
		this.ensurePDFisUpgraded = ensurePDFisUpgraded;
	}
	
	/**
	 * 
	 * @param attachZUGFeRDHeaders if false the ZUGFeRD XMP metadata won't be added, e.g. if it's not the first file
	 */
	public void setAttachZUGFeRDHeaders(boolean attachZUGFeRDHeaders) {
		this.attachZUGFeRDHeaders=attachZUGFeRDHeaders;
	}

}
