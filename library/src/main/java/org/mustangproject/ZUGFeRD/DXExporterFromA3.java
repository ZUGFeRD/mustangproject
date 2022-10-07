/**
 * *********************************************************************
 * <p>
 * Copyright 2020 Jochen Staerk
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

import org.apache.pdfbox.cos.*;
import org.apache.pdfbox.io.IOUtils;
import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.apache.pdfbox.pdmodel.documentinterchange.logicalstructure.PDMarkInfo;
import org.apache.pdfbox.pdmodel.documentinterchange.logicalstructure.PDStructureTreeRoot;
import org.apache.pdfbox.pdmodel.graphics.color.PDOutputIntent;
import org.apache.pdfbox.preflight.utils.ByteArrayDataSource;
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

import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.xml.transform.TransformerException;
import java.io.*;
import java.util.*;

public class DXExporterFromA3 extends ZUGFeRDExporterFromA3 {

	protected PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;
	protected ArrayList<FileAttachment> fileAttachments = new ArrayList<FileAttachment>();

	/**
	 * This flag controls whether or not the metadata is overwritten, or kind of merged.
	 * The merging probably needs to be overhauled, but for my purpose it was good enough.
	 */
	protected boolean overwrite = true;

	private boolean disableAutoClose;
	private boolean fileAttached = false;
	private Profile profile = null;
	private boolean documentPrepared = false;

	/**
	 * Data (XML invoice) to be added to the ZUGFeRD PDF. It may be externally set,
	 * in which case passing a IZUGFeRDExportableTransaction is not necessary. By
	 * default it is null meaning the caller needs to pass a
	 * IZUGFeRDExportableTransaction for the XML to be populated.
	 */
	protected PDMetadata metadata = null;
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

	/**
	 * OrderX document type. As of version 1.0 it may be
	 * ORDER, ORDER_RESPONSE, or ORDER_CHANGE
	 */
	protected String despatchAdviceDocumentType = "DESPATCHADVICE";


	private HashMap<String, byte[]> additionalXMLs = new HashMap<String, byte[]>();


	private boolean attachZUGFeRDHeaders = true;

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfFilename filename of an PDF/A1 compliant document
	 */
	public DXExporterFromA3 load(String pdfFilename) throws IOException {

		ensurePDFIsValid(new FileDataSource(pdfFilename));
		try (FileInputStream pdf = new FileInputStream(pdfFilename)) {
			return load(readAllBytes(pdf));
		}
	}

	public IXMLProvider getProvider() {
		return xmlProvider;
	}

	public DXExporterFromA3 setProfile(Profile p) {
		this.profile = p;
		if (xmlProvider != null) {
			xmlProvider.setProfile(p);
		}
		return this;
	}

	public DXExporterFromA3 setProfile(String profilename) {
		this.profile = Profiles.getByName(profilename);

		if (xmlProvider != null) {
			xmlProvider.setProfile(this.profile);
		}
		return this;
	}

	public DXExporterFromA3 addAdditionalFile(String name, byte[] content) {
		fileAttachments.add(new FileAttachment(name, "text/xml", "Supplement", content).setDescription("ZUGFeRD extension/additional data"));
		return this;
	}



	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary binary of a PDF/A1 compliant document
	 */
	public DXExporterFromA3 load(byte[] pdfBinary) throws IOException {
		ensurePDFIsValid(new ByteArrayDataSource(new ByteArrayInputStream(pdfBinary)));
		doc = PDDocument.load(pdfBinary);
		return this;
	}

	public DXExporterFromA3() {
		super();
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
	public void export(String ZUGFeRDfilename) throws IOException {
		if (!documentPrepared) {
			prepareDocument();
		}
		if ((!fileAttached) && (attachZUGFeRDHeaders)) {
			throw new IOException(
					"File must be attached (usually with setTransaction) before perfoming this operation");
		}
		doc.save(ZUGFeRDfilename);
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
	public void export(OutputStream output) throws IOException {
		if (!documentPrepared) {
			prepareDocument();
		}
		if ((!fileAttached) && (attachZUGFeRDHeaders)) {
			throw new IOException(
					"File must be attached (usually with setTransaction) before perfoming this operation");
		}
		doc.save(output);
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
	 * @throws IOException if anything is wrong with filename
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
	 * @throws IOException if anything is wrong with filename
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
		COSBase AFEntry = (COSBase) doc.getDocumentCatalog().getCOSObject().getItem("AF");
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
	public DXExporterFromA3 setXML(byte[] zugferdData) throws IOException {
		CustomXMLProvider cus = new CustomXMLProvider();
		// As of late 2022 the Delivery-X standard is not yet published. See specification:
		// Die digitale Ablösung des Papier-Lieferscheins, Version 1.1, April 2022
		// Chapter 7.1 XMP-Erweiterungsschema für PDF/A-3
		// http://docplayer.org/230301085-Der-digitale-lieferschein-dls.html
		cus.setProfile(Profiles.getByName(EStandard.despatchadvice, "PILOT", 1));

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
	public DXExporterFromA3 load(InputStream pdfSource) throws IOException {
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
	public DXExporterFromA3 setConformanceLevel(PDFAConformanceLevel newLevel) {
		conformanceLevel = newLevel;
		return this;
	}


	public DXExporterFromA3 setCreator(String creator) {
		this.creator = creator;
		return this;
	}

	public DXExporterFromA3 setCreatorTool(String creatorTool) {
		this.creatorTool = creatorTool;
		return this;
	}

	public DXExporterFromA3 setProducer(String producer) {
		this.producer = producer;
		return this;
	}

	/**
	 * Sets the property for DocumentType.
	 *
	 * @param DocumentType String, usually DESPATCHADVICE
	 *
	 * @return this exporter
	 */
	public DXExporterFromA3 setDocumentType(String DocumentType)
	{
		this.despatchAdviceDocumentType = DocumentType;

		return this;
	}

	protected DXExporterFromA3 setAttachZUGFeRDHeaders(boolean attachHeaders) {
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

		if (attachZUGFeRDHeaders) {
			// As of late 2022 the Delivery-X standard is not yet published. See specification:
			// Die digitale Ablösung des Papier-Lieferscheins, Version 1.1, April 2022
			// Chapter 7.1 XMP-Erweiterungsschema für PDF/A-3
			// http://docplayer.org/230301085-Der-digitale-lieferschein-dls.html
			XMPSchemaZugferd zf = new XMPSchemaZugferd(metadata, 1, true, xmlProvider.getProfile(),
					"urn:factur-x:pdfa:CrossIndustryDocument:despatchadvice:1p0#", "fx",
					"cida.xml", "1.0");
			zf.setType(this.despatchAdviceDocumentType);

			metadata.addSchema(zf);
			// also add the schema extensions...
			XMPSchemaPDFAExtensions pdfaex = new XMPSchemaPDFAExtensions(this, metadata, 1, attachZUGFeRDHeaders, EStandard.despatchadvice);
			pdfaex.setZUGFeRDVersion(1);
			metadata.addSchema(pdfaex);
		}

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
	public IExporter setTransaction(IExportableTransaction trans) throws IOException {
		this.trans = trans;
		return prepare();
	}

	public IExporter prepare() throws IOException {
		prepareDocument();
		xmlProvider.generateXML(trans);
		String filename = "cida.xml";
		PDFAttachGenericFile(doc, filename, "Alternative",
				"Delivery metadata",
				"text/xml", xmlProvider.getXML());

		for (FileAttachment attachment : fileAttachments) {
			PDFAttachGenericFile(doc, attachment.getFilename(), attachment.getRelation(), attachment.getDescription(), attachment.getMimetype(), attachment.getData());
		}

		return this;
	}

	/**
	 * Reads the XMPMetadata from the PDDocument, if it exists.
	 * Otherwise creates XMPMetadata.
	 */
	protected XMPMetadata getXmpMetadata() throws IOException {
		PDMetadata meta = doc.getDocumentCatalog().getMetadata();
		if ((meta != null) && (meta.getLength() > 0)) {
			try {
				DomXmpParser xmpParser = new DomXmpParser();
				return xmpParser.parse(meta.toByteArray());
			} catch (XmpParsingException | IOException e) {
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
	 */
	protected void writeAdobePDFSchema(XMPMetadata xmp) {
		AdobePDFSchema pdf = getAdobePDFSchema(xmp);
		if (overwrite || isEmpty(pdf.getProducer()))
			pdf.setProducer(producer);
	}

	/**
	 * Returns the AdobePDFSchema from the XMPMetadata if it exists.
	 * If the overwrite flag is set or no AdobePDFSchema exists in the XMPMetadata, it is created, added and returned.
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
				throw new RuntimeException(ex);
			}
		}
		pdfaid.setPart(3);
	}

	protected PDFAIdentificationSchema getPDFAIdentificationSchema(XMPMetadata xmp) {
		PDFAIdentificationSchema pdfaid = xmp.getPDFIdentificationSchema();
		if (pdfaid != null)
			if (overwrite)
				xmp.removeSchema(pdfaid);
			else
				return pdfaid;
		return xmp.createAndAddPFAIdentificationSchema();
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
			xsb.setCreateDate(GregorianCalendar.getInstance());
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
	 */
	protected void addSRGBOutputIntend() throws IOException {
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
	public DXExporterFromA3 disableAutoClose(boolean disableAutoClose) {
		this.disableAutoClose = disableAutoClose;
		return this;
	}

	protected void setXMLProvider(IXMLProvider p) {
		this.xmlProvider = p;
		if (profile != null) {
			xmlProvider.setProfile(profile);
		}
	}

	@Override
	public DXExporterFromA3 setZUGFeRDVersion(int version) {
		DAPullProvider z2p = new DAPullProvider();
		setXMLProvider(z2p);
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
