/**
 * *********************************************************************
 * <p>
 * Copyright 2018 Jochen Staerk
 * <p>
 * Use is subject to license terms.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * <p>
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p>
 * **********************************************************************
 */
package org.mustangproject.ZUGFeRD;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

import javax.xml.transform.TransformerException;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.cos.COSArray;
import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.cos.COSObject;
import org.apache.pdfbox.io.IOUtils;
import org.apache.pdfbox.pdfwriter.compress.CompressParameters;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.apache.pdfbox.pdmodel.documentinterchange.logicalstructure.PDMarkInfo;
import org.apache.pdfbox.pdmodel.documentinterchange.logicalstructure.PDStructureTreeRoot;
import org.apache.pdfbox.pdmodel.font.PDCIDFontType2;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDFontDescriptor;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.color.PDOutputIntent;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.AdobePDFSchema;
import org.apache.xmpbox.schema.DublinCoreSchema;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.xmpbox.schema.XMPBasicSchema;
import org.apache.xmpbox.type.ArrayProperty;
import org.apache.xmpbox.type.BadFieldValueException;
import org.apache.xmpbox.xml.DomXmpParser;
import org.apache.xmpbox.xml.XmpParsingException;
import org.apache.xmpbox.xml.XmpSerializer;
import org.mustangproject.EStandard;
import org.mustangproject.FileAttachment;

import jakarta.activation.DataSource;
import jakarta.activation.FileDataSource;

public class ZUGFeRDExporterFromA3 extends XRExporter implements IZUGFeRDExporter {
	private boolean isFacturX = true;

	public static final int DefaultZUGFeRDVersion = 2;
	protected boolean ignorePDFAErrors = false;

	public ZUGFeRDExporterFromA3 ignorePDFAErrors() {
		this.ignorePDFAErrors = true;
		return this;
	}

	protected PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;
	protected ArrayList<FileAttachment> fileAttachments = new ArrayList<>();

	/**
	 * This flag controls whether or not the metadata is overwritten, or kind of merged.
	 * The merging probably needs to be overhauled, but for my purpose it was good enough.
	 */
	protected boolean overwrite = true;

	private boolean disableAutoClose;
	private boolean fileAttached = false;
	private Profile profile = null;
	protected boolean documentPrepared = false;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally set,
	 * in which case passing a IZUGFeRDExportableTransaction is not necessary. By
	 * default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	protected PDMetadata metadata = null;
	protected XMPMetadata xmp = null;
	/**
	 * Producer attribute for PDF
	 */
	protected String producer = "mustangproject";
	/**
	 * Author/Creator attribute for PDF
	 */
	protected String creator = "mustangproject";
	/**
	 * CreatorTool
	 */
	protected String creatorTool = "mustangproject";

	/**
	 * @deprecated author is never set yet
	 */
	@Deprecated
	protected String author;
	/**
	 * @deprecated title is never set yet
	 */
	@Deprecated
	protected String title;
	/**
	 * @deprecated subject is never set yet
	 */
	@Deprecated
	protected String subject;

	protected PDDocument doc;

	protected int ZFVersion = DefaultZUGFeRDVersion;
	private boolean attachZUGFeRDHeaders = true;


	// Specific metaData version in case of XRechnung. We need it to be settable
	// by the caller if necessary.
	protected String XRechnungVersion = null; // Default XRechnung as of late 2021 is 2p0

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfFilename filename of an PDF/A1 compliant document
	 */
	public ZUGFeRDExporterFromA3 load(String pdfFilename) throws IOException {

		ensurePDFIsValid(new FileDataSource(pdfFilename));
		try (FileInputStream pdf = new FileInputStream(pdfFilename)) {
			return load(readAllBytes(pdf));
		}
	}

	public IXMLProvider getProvider() {
		return xmlProvider;
	}

	public ZUGFeRDExporterFromA3 setProfile(Profile p) {
		this.profile = p;
		if (xmlProvider != null) {
			xmlProvider.setProfile(p);
		}
		return this;
	}

	public ZUGFeRDExporterFromA3 setProfile(String profilename) {
		this.profile = Profiles.getByName(profilename);

		if (xmlProvider != null) {
			xmlProvider.setProfile(this.profile);
		}
		return this;
	}

	public ZUGFeRDExporterFromA3 addAdditionalFile(String name, byte[] content) {
		fileAttachments.add(new FileAttachment(name, "text/xml", "Supplement", content).setDescription("ZUGFeRD extension/additional data"));
		return this;
	}

	/***
	 * internal helper function: get namespace for given zugferd or factur-x version
	 * @param ver the ZUGFeRD version
	 * @return the URN of the namespace
	 */
	public String getNamespaceForVersion(int ver) {
		if (isFacturX) {
			return "urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#";
		} else if (ver == 1) {
			return "urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#";
		} else if (ver == 2) {
			return "urn:zugferd:pdfa:CrossIndustryDocument:invoice:2p0#";
		} else {
			throw new IllegalArgumentException("Version not supported");
		}
	}

	/***
	 * internal helper: returns the namespace prefix for the given zf/fx version number
	 * @param ver the zf/fx version
	 * @return the namespace prefix as string, without colon
	 */
	public String getPrefixForVersion(int ver) {
		if (isFacturX) {
			return "fx";
		} else {
			return "zf";
		}
	}

	/***
	 * internal helper: return the name of the file attachment for the given zf/fx version
	 * @param ver the zf/fx version
	 * @param profile which profile to be used, e.g. Profiles.getByName("EN16931")
	 * @return the filename of the file to be embedded
	 */
	public String getFilenameForVersion(int ver, Profile profile) {
		if ("XRECHNUNG".equals(profile.getName())) {
			return "xrechnung.xml";
		}
		if (isFacturX) {
			return "factur-x.xml";
		} else {
			if (ver == 1) {
				return "ZUGFeRD-invoice.xml";
			} else {
				return "zugferd-invoice.xml";
			}
		}
	}


	/**
	 * Factur-X is now set by default since ZF 2.1, you have to disable it if you dont wont it
	 * Generate ZF2.1 files with filename factur-x.xml
	 *
	 * @return this (fluent setter)
	 * @deprecated It's now the default anyway
	 */
	@Deprecated
	public ZUGFeRDExporterFromA3 setFacturX() {
		isFacturX = true;
		return this;
	}


	/**
	 * Sets a specific XRechnung version from outside. This version needs to be present in the
	 * meta-data as well. The caller may wish to generate a specific version of XRechnung
	 * depending on the time period etc.
	 *
	 * @param XRechnungVersion the XRechnung version
	 */
	public void setXRechnungSpecificVersion(String XRechnungVersion) {
		this.XRechnungVersion = XRechnungVersion;
	}


	/***
	 * Generate ZF2.0/2.1 files with filename zugferd-invoice.xml instead of factur-x.xml
	 */
	public IZUGFeRDExporter disableFacturX() {
		isFacturX = false;
		return this;
	}


	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary binary of a PDF/A1 compliant document
	 */
	public ZUGFeRDExporterFromA3 load(byte[] pdfBinary) throws IOException {
		ensurePDFIsValid(new ByteArrayDataSource(new ByteArrayInputStream(pdfBinary)));
		doc = Loader.loadPDF(pdfBinary);
		return this;
	}

	public ZUGFeRDExporterFromA3() {
		super();
		setZUGFeRDVersion(ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion);

	}

	public void attachFile(FileAttachment file) {
		fileAttachments.add(file);
	}

	public void attachFile(String filename, byte[] data, String mimetype, String relation) {
		FileAttachment fa = new FileAttachment(filename, mimetype, relation, data);
		fileAttachments.add(fa);
	}

	/***
	 * Perform the final export to a now ZUGFeRD-enriched PDF file
	 * @param ZUGFeRDfilename the pdf file name
	 * @throws IOException if anything is wrong in the target location
	 */
	@Override
	public void export(String ZUGFeRDfilename) throws IOException {
		if (!documentPrepared) {
			prepareDocument();
		}
		if ((!fileAttached) && (attachZUGFeRDHeaders)) {
			throw new IOException(
				"File must be attached (usually with setTransaction) before perfoming this operation");
		}
		doc.save(ZUGFeRDfilename, CompressParameters.NO_COMPRESSION);
		if (!disableAutoClose) {
			close();
		}
	}

	@Override
	public void close() throws IOException {
		if (doc != null) {
			doc.close();
		}
	}


	/***
	 * Perform the final export to a now ZUGFeRD-enriched PDF file as OutputStream
	 * @param output the OutputStream
	 * @throws IOException if anything is wrong in the OutputStream
	 */
	@Override
	public void export(OutputStream output) throws IOException {
		if (!documentPrepared) {
			prepareDocument();
		}
		if ((!fileAttached) && (attachZUGFeRDHeaders)) {
			throw new IOException(
				"File must be attached (usually with setTransaction) before perfoming this operation");
		}
		doc.save(output, CompressParameters.NO_COMPRESSION);
		if (!disableAutoClose) {
			close();
		}
	}


	/**
	 * Embeds an external file (generic - any type allowed) in the PDF.
	 * The embedding is done in the default PDF document.
	 *
	 * @param filename     name of the file that will become attachment name in the PDF
	 * @param relationship how the file relates to the content, e.g. "Alternative"
	 * @param description  Human-readable description of the file content
	 * @param subType      type of the data e.g. could be "text/xml" - mime like
	 * @param data         the binary data of the file/attachment
	 * @throws java.io.IOException if anything is wrong with filename
	 */
	public void PDFAttachGenericFile(String filename, String relationship, String description,
									 String subType, byte[] data) throws IOException {
		PDFAttachGenericFile(this.doc, filename, relationship, description, subType, data);
	}


	/**
	 * Embeds an external file (generic - any type allowed) in the PDF.
	 *
	 * @param doc          PDDocument to attach the file to.
	 * @param filename     name of the file that will become attachment name in the PDF
	 * @param relationship how the file relates to the content, e.g. "Alternative"
	 * @param description  Human-readable description of the file content
	 * @param subType      type of the data e.g. could be "text/xml" - mime like
	 * @param data         the binary data of the file/attachment
	 * @throws java.io.IOException if anything is wrong with filename
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
//		ef.addCompression();
		ef.setSubtype(subType);
		ef.setSize(data.length);
		ef.setCreationDate(new GregorianCalendar());

		ef.setModDate(Calendar.getInstance());

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
		COSBase AFEntry = doc.getDocumentCatalog().getCOSObject().getItem("AF");
		if ((AFEntry == null)) {
			COSArray cosArray = new COSArray();
			cosArray.add(fs);
			doc.getDocumentCatalog().getCOSObject().setItem("AF", cosArray);
		} else if (AFEntry instanceof COSArray) {
			COSArray cosArray = (COSArray) AFEntry;
			cosArray.add(fs);
			doc.getDocumentCatalog().getCOSObject().setItem("AF", cosArray);
		} else if ((AFEntry instanceof COSObject) &&
			((COSObject) AFEntry).getObject() instanceof COSArray) {
			COSArray cosArray = (COSArray) ((COSObject) AFEntry).getObject();
			cosArray.add(fs);
		} else {
			throw new IOException("Unexpected object type for PDFDocument/Catalog/COSDictionary/Item(AF)");
		}
	}

	/**
	 * Sets the ZUGFeRD XML data to be attached as a single byte array. This is
	 * useful for use-cases where the XML has already been produced by some external
	 * API or component.
	 *
	 * @param zugferdData XML data to be set as a byte array (XML file in raw form).
	 * @throws IOException (should not happen)
	 */
	public ZUGFeRDExporterFromA3 setXML(byte[] zugferdData) throws IOException {
		CustomXMLProvider cus = new CustomXMLProvider();
		cus.setXML(zugferdData);
		this.setXMLProvider(cus);
		prepare();
		return this;
	}


	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfSource source to read a PDF/A1 compliant document from
	 */
	public ZUGFeRDExporterFromA3 load(InputStream pdfSource) throws IOException {
		return load(readAllBytes(pdfSource));
	}

	public boolean ensurePDFIsValid(final DataSource dataSource) throws IOException {
		return true;
	}

	private static byte[] readAllBytes(InputStream in) throws IOException {
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		IOUtils.copy(in, buffer);
		return buffer.toByteArray();
	}


	/**
	 * All files are PDF/A-3, setConformance refers to the level conformance.
	 * <p>
	 * PDF/A-3 has three coformance levels, called "A", "U" and "B".
	 * <p>
	 * PDF/A-3-B where B means only visually preservable, U -standard for Mustang-
	 * means visually and unicode preservable and A means full compliance, i.e.
	 * visually, unicode and structurally preservable and tagged PDF, i.e. useful
	 * metainformation for blind people.
	 * <p>
	 * Feel free to pass "A" as new level if you know what you are doing :-)
	 */
	public ZUGFeRDExporterFromA3 setConformanceLevel(PDFAConformanceLevel newLevel) {
		conformanceLevel = newLevel;
		return this;
	}


	public ZUGFeRDExporterFromA3 setCreator(String creator) {
		this.creator = creator;
		return this;
	}

	public ZUGFeRDExporterFromA3 setCreatorTool(String creatorTool) {
		this.creatorTool = creatorTool;
		return this;
	}

	public ZUGFeRDExporterFromA3 setProducer(String producer) {
		this.producer = producer;
		return this;
	}

	protected ZUGFeRDExporterFromA3 setAttachZUGFeRDHeaders(boolean attachHeaders) {
		this.attachZUGFeRDHeaders = attachHeaders;
		return this;
	}


	/**
	 * This will add both the RDF-indication which embedded file is Zugferd and the
	 * neccessary PDF/A schema extension description to be able to add this
	 * information to RDF
	 *
	 * @param metadata the PDFbox XMPMetadata object
	 */
	protected void addXMP(XMPMetadata metadata) {

		String metaDataVersion = null; // default will be used

		// The XRechnung version may be settable from outside.
		if ((this.XRechnungVersion != null) && (this.profile != null) &&
			this.profile.getName().equalsIgnoreCase(Profiles.getByName("XRECHNUNG").getName())) {
			metaDataVersion = this.XRechnungVersion;
		}

		if (attachZUGFeRDHeaders) {
			XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata, ZFVersion, isFacturX, xmlProvider.getProfile(),
				getNamespaceForVersion(ZFVersion), getPrefixForVersion(ZFVersion),
				getFilenameForVersion(ZFVersion, xmlProvider.getProfile()), metaDataVersion);

			metadata.addSchema(zf);
		}

		XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(this, metadata, ZFVersion, attachZUGFeRDHeaders);
		pdfaex.setZUGFeRDVersion(ZFVersion);
		metadata.addSchema(pdfaex);
	}

	private void removeCidSet(PDDocument doc)
		throws IOException {
		// https://github.com/ZUGFeRD/mustangproject/issues/249

		COSName cidSet = COSName.getPDFName("CIDSet");
		COSName resources = COSName.getPDFName("Resources");

		// iterate over all pdf pages

		for (PDPage page : doc.getPages()) {
			if (page != null) {

				PDResources res = page.getResources();

				// Check for fonts in PDXObjects:
				for (COSName xObjectName : res.getXObjectNames()) {
					PDXObject xObject = res.getXObject(xObjectName);
					COSDictionary d = xObject.getCOSObject().getCOSDictionary(resources);
					if (d != null) {
						PDResources xr = new PDResources(d);
						removeCIDSetFromPDResources(cidSet, xr);
					}
				}
				
				// Check for fonts in document-resources:
				removeCIDSetFromPDResources(cidSet, res);
			}
		}
	}

	private void removeCIDSetFromPDResources(COSName cidSet, PDResources res) throws IOException {
		for (COSName fontName : res.getFontNames()) {
			try {
				PDFont pdFont = res.getFont(fontName);
				if (pdFont instanceof PDType0Font) {
					PDType0Font typedFont = (PDType0Font) pdFont;

					if (typedFont.getDescendantFont() instanceof PDCIDFontType2) {
						@SuppressWarnings("unused")
						PDCIDFontType2 f = (PDCIDFontType2) typedFont.getDescendantFont();
						PDFontDescriptor fontDescriptor = pdFont.getFontDescriptor();

						fontDescriptor.getCOSObject().removeItem(cidSet);
					}
				}
			} catch (IOException e) {
				throw e;
			}
			// do stuff with the font
		}
	}
	
	protected void prepareDocument() throws IOException {

		PDDocumentCatalog cat = doc.getDocumentCatalog();
		metadata = new PDMetadata(doc);
		cat.setMetadata(metadata);

		removeCidSet(doc);
		xmp = getXmpMetadata();
		writeAdobePDFSchema(xmp);
		writePDFAIdentificationSchema(xmp);
		writeDublinCoreSchema(xmp);
		writeXMLBasicSchema(xmp);
		writeDocumentInformation();

		// the following three lines are intended to make the pdf more PDF/A conformant if it isn't already
		addSRGBOutputIntend();
		setMarked();
		addStructureTreeRoot();

		addXMP(xmp); /*
		 * this is the only line where we do something Zugferd-specific, i.e. add PDF
		 * metadata specifically for Zugferd, not generically for a embedded file
		 */


		try {
			metadata.importXMPMetadata(serializeXmpMetadata(xmp));

		} catch (TransformerException e) {
			throw new ZUGFeRDExportException("Could not export XmpMetadata", e);
		}
		documentPrepared = true;
	}

	/**
	 * Embeds the Zugferd XML structure in a file named ZUGFeRD-invoice.xml.
	 *
	 * @param trans a IZUGFeRDExportableTransaction that provides the data-model to
	 *              populate the XML. This parameter may be null, if so the XML data
	 *              should hav ebeen set via
	 *              <code>setZUGFeRDXMLData(byte[] zugferdData)</code>
	 * @throws IOException if anything is wrong with already loaded PDF
	 */
	@Override
	public IExporter setTransaction(IExportableTransaction trans) throws IOException {
		this.trans = trans;
		return prepare();
	}

	public IExporter prepare() throws IOException {
		prepareDocument();
		xmlProvider.generateXML(trans);
		String filename = getFilenameForVersion(ZFVersion, xmlProvider.getProfile());

		String relationship = "Alternative";
		// ZUGFeRD 2.1.1 Technical Supplement | Part A | 2.2.2. Data Relationship
		// See documentation ZUGFeRD211_EN/Documentation/ZUGFeRD-2.1.1 - Specification_TA_Part-A.pdf
		// https://www.ferd-net.de/standards/zugferd-2.1.1/index.html
		if ((this.profile != null) && (ZFVersion >= 2)) {
			if (this.profile.getName().equalsIgnoreCase(Profiles.getByName("MINIMUM").getName()) ||
				this.profile.getName().equalsIgnoreCase(Profiles.getByName("BASICWL").getName())) {
				relationship = "Data";
			}
		}

		PDFAttachGenericFile(doc, filename, relationship,
			"Invoice metadata conforming to ZUGFeRD standard (http://www.ferd-net.de/front_content.php?idcat=231&lang=4)",
			"text/xml", xmlProvider.getXML());

		for (FileAttachment attachment : fileAttachments) {
			PDFAttachGenericFile(doc, attachment.getFilename(), attachment.getRelation(), attachment.getDescription(), attachment.getMimetype(), attachment.getData());
		}

		return this;
	}

	/**
	 * Reads the XMPMetadata from the PDDocument, if it exists.
	 * Otherwise creates XMPMetadata.
	 *
	 * @return the finished XMPMetadata object
	 * @throws IOException when e.g. XmpParsingException
	 */
	protected XMPMetadata getXmpMetadata()
		throws IOException {
		PDMetadata meta = doc.getDocumentCatalog().getMetadata();
		if ((meta != null) && (meta.getLength() > 0)) {
			try {
				DomXmpParser xmpParser = new DomXmpParser();
				return xmpParser.parse(meta.toByteArray());
			} catch (XmpParsingException e) {
				throw new IOException(e);
			}
		}
		return XMPMetadata.createXMPMetadata();
	}

	protected byte[] serializeXmpMetadata(XMPMetadata xmpMetadata) throws TransformerException {
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		new XmpSerializer().serialize(xmpMetadata, buffer, true); // see https://github.com/ZUGFeRD/mustangproject/issues/44
		return buffer.toByteArray();
	}

	/**
	 * Sets the producer if the overwrite flag is set or the producer is not already set.
	 * Sets the PDFVersion to 1.4 if the field is empty.
	 *
	 * @param xmp the metadata as XML
	 */
	protected void writeAdobePDFSchema(XMPMetadata xmp) {
		AdobePDFSchema pdf = getAdobePDFSchema(xmp);
		if (overwrite || isEmpty(pdf.getProducer()))
			pdf.setProducer(producer);
	}

	/**
	 * Returns the AdobePDFSchema from the XMPMetadata if it exists.
	 * If the overwrite flag is set or no AdobePDFSchema exists in the XMPMetadata, it is created, added and returned.
	 *
	 * @param xmp the metadata to attach to
	 * @return the pdf schema
	 */
	protected AdobePDFSchema getAdobePDFSchema(XMPMetadata xmp) {
		AdobePDFSchema pdf = xmp.getAdobePDFSchema();
		if (pdf != null)
			if (overwrite)
				xmp.removeSchema(pdf);
			else
				return pdf;
		return xmp.createAndAddAdobePDFSchema();
	}

	protected void writePDFAIdentificationSchema(XMPMetadata xmp) {
		PDFAIdentificationSchema pdfaid = getPDFAIdentificationSchema(xmp);
		if (overwrite || isEmpty(pdfaid.getConformance())) {
			try {
				pdfaid.setConformance(conformanceLevel.getLetter());
			} catch (BadFieldValueException ex) {
				// This should be impossible, because it would occur only if an illegal
				// conformance level is supplied,
				// however the enum enforces that the conformance level is valid.
				throw new Error(ex);
			}
		}
		pdfaid.setPart(3);
	}

	protected PDFAIdentificationSchema getPDFAIdentificationSchema(XMPMetadata xmp) {
		PDFAIdentificationSchema pdfaid = xmp.getPDFAIdentificationSchema();
		if (pdfaid != null)
			if (overwrite)
				xmp.removeSchema(pdfaid);
			else
				return pdfaid;
		return xmp.createAndAddPDFAIdentificationSchema();
	}

	protected void writeDublinCoreSchema(XMPMetadata xmp) {
		DublinCoreSchema dc = getDublinCoreSchema(xmp);
		if (dc.getFormat() == null)
			dc.setFormat("application/pdf");
		if ((overwrite || dc.getCreators() == null || dc.getCreators().isEmpty()) && creator != null)
			dc.addCreator(creator);
		if ((overwrite || dc.getDates() == null || dc.getDates().isEmpty()) && creator != null)
			dc.addDate(Calendar.getInstance());

		ArrayProperty titleProperty = dc.getTitleProperty();
		if (titleProperty != null) {
			if (overwrite && !isEmpty(title)) {
				dc.removeProperty(titleProperty);
				dc.setTitle(title);
			} else if (titleProperty.getElementsAsString().stream().anyMatch("Untitled"::equalsIgnoreCase)) {
				// remove unfitting ghostscript default
				dc.removeProperty(titleProperty);
			}
		} else if (!isEmpty(title)) {
			dc.setTitle(title);
		}
	}

	protected DublinCoreSchema getDublinCoreSchema(XMPMetadata xmp) {
		DublinCoreSchema dc = xmp.getDublinCoreSchema();
		if (dc != null)
			if (overwrite)
				xmp.removeSchema(dc);
			else
				return dc;
		return xmp.createAndAddDublinCoreSchema();
	}

	protected void writeXMLBasicSchema(XMPMetadata xmp) {
		XMPBasicSchema xsb = getXmpBasicSchema(xmp);
		if (overwrite || isEmpty(xsb.getCreatorTool()) || "UnknownApplication".equals(xsb.getCreatorTool()))
			xsb.setCreatorTool(creatorTool);
		if (overwrite || xsb.getCreateDate() == null)
			xsb.setCreateDate(Calendar.getInstance());
	}

	protected XMPBasicSchema getXmpBasicSchema(XMPMetadata xmp) {
		XMPBasicSchema xsb = xmp.getXMPBasicSchema();
		if (xsb != null)
			if (overwrite)
				xmp.removeSchema(xsb);
			else
				return xsb;
		return xmp.createAndAddXMPBasicSchema();
	}

	protected void writeDocumentInformation() {
		String fullProducer = producer + " (via mustangproject.org " + Version.VERSION + ")";
		PDDocumentInformation info = doc.getDocumentInformation();
		if (overwrite || info.getCreationDate() == null)
			info.setCreationDate(Calendar.getInstance());
		if (overwrite || info.getModificationDate() == null)
			info.setModificationDate(Calendar.getInstance());
		if (overwrite || (isEmpty(info.getAuthor()) && !isEmpty(author)))
			info.setAuthor(author);
		if (overwrite || (isEmpty(info.getProducer()) && !isEmpty(fullProducer)))
			info.setProducer(fullProducer);
		if (overwrite || (isEmpty(info.getCreator()) && !isEmpty(creator)))
			info.setCreator(creator);
		if (overwrite || (isEmpty(info.getTitle()) && !isEmpty(title)))
			info.setTitle(title);
		if (overwrite || (isEmpty(info.getSubject()) && !isEmpty(subject)))
			info.setSubject(subject);
	}

	/**
	 * Adds an OutputIntent and the sRGB color profile if no OutputIntent exist
	 *
	 * @throws IOException if the ICC file cannot be read or attached to doc
	 */
	protected void addSRGBOutputIntend()
		throws IOException {
		if (!doc.getDocumentCatalog().getOutputIntents().isEmpty()) {
			return;
		}

		try {
			InputStream colorProfile = Thread.currentThread().getContextClassLoader().getResourceAsStream("sRGB.icc");
			if (colorProfile != null) {
				PDOutputIntent intent = new PDOutputIntent(doc, colorProfile);
				intent.setInfo("sRGB IEC61966-2.1");
				intent.setOutputCondition("sRGB IEC61966-2.1");
				intent.setOutputConditionIdentifier("sRGB IEC61966-2.1");
				intent.setRegistryName("http://www.color.org");
				doc.getDocumentCatalog().addOutputIntent(intent);
			}
		} catch (IOException e) {
			throw e;
		}
	}

	/**
	 * Adds a MarkInfo element to the PDF if it doesn't already exist and sets it as marked.
	 */
	protected void setMarked() {
		PDDocumentCatalog catalog = doc.getDocumentCatalog();
		if (catalog.getMarkInfo() == null) {
			catalog.setMarkInfo(new PDMarkInfo(doc.getPages().getCOSObject()));
		}
		catalog.getMarkInfo().setMarked(true);
	}

	/**
	 * Adds a StructureTreeRoot element to the PDF if it doesn't already exist.
	 */
	protected void addStructureTreeRoot() {
		if (doc.getDocumentCatalog().getStructureTreeRoot() == null) {
			doc.getDocumentCatalog().setStructureTreeRoot(new PDStructureTreeRoot());
		}
	}


	/**
	 * @return if pdf file will be automatically closed after adding ZF
	 */
	public boolean isAutoCloseDisabled() {
		return disableAutoClose;
	}

	/**
	 * @param disableAutoClose prevent PDF file from being closed after adding ZF
	 */
	public ZUGFeRDExporterFromA3 disableAutoClose(boolean disableAutoClose) {
		this.disableAutoClose = disableAutoClose;
		return this;
	}

	protected void setXMLProvider(IXMLProvider p) {
		this.xmlProvider = p;
		if (profile != null) {
			xmlProvider.setProfile(profile);
		}
	}

	public ZUGFeRDExporterFromA3 setZUGFeRDVersion(EStandard est, int version) {
		this.ZFVersion = version;
		if ((version < 1) || (version > 2)) {
			throw new IllegalArgumentException("Version not supported");
		}
		int generation = version;
		if ((est == EStandard.facturx) && (version == 1)) {
			generation = 2;
		}
		if (generation == 1) {
			ZUGFeRD1PullProvider z1p = new ZUGFeRD1PullProvider();
			disableFacturX();
			setXMLProvider(z1p);
		} else if (generation == 2) {
			ZUGFeRD2PullProvider z2p = new ZUGFeRD2PullProvider();
			setXMLProvider(z2p);
		}


		return this;
	}

	@Override
	public ZUGFeRDExporterFromA3 setZUGFeRDVersion(int version) {
		this.ZFVersion = version;
		if (version == 1) {
			ZUGFeRD1PullProvider z1p = new ZUGFeRD1PullProvider();
			disableFacturX();
			setXMLProvider(z1p);
		} else if (version == 2) {
			ZUGFeRD2PullProvider z2p = new ZUGFeRD2PullProvider();
			setXMLProvider(z2p);
		} else {
			throw new IllegalArgumentException("Version not supported");
		}

		return this;
	}

	/**
	 * Utility method inspired by apache commons-lang3 StringUtils.
	 *
	 * @param string the string to test
	 * @return true if the string is null or empty
	 */
	private boolean isEmpty(String string) {
		return string == null || string.isEmpty();
	}
}
