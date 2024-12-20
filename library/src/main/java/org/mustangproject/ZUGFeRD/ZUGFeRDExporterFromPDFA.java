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

import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.xmpbox.xml.DomXmpParser;
import org.apache.xmpbox.xml.XmpParsingException;
import org.mustangproject.FileAttachment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.activation.DataSource;

/***
 * Auto-detects the source PDF-A-Version and acts accordingly
 * like a ZUGFeRDExporterFromA1 or ZUGFeRDExporterFromA3
 */
public class ZUGFeRDExporterFromPDFA implements IZUGFeRDExporter {

	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDExporterFromPDFA.class.getCanonicalName()); // log

	protected IZUGFeRDExporter theExporter;

	protected boolean ignorePDFAErrors = false;

	public ZUGFeRDExporterFromPDFA ignorePDFAErrors() {
		this.ignorePDFAErrors = true;
		return this;
	}
	protected void determineAndSetExporter(int PDFAVersion) {
		if (PDFAVersion == 3) {
			theExporter = new ZUGFeRDExporterFromA3();
			if (ignorePDFAErrors) {
				((ZUGFeRDExporterFromA3)theExporter).ignorePDFAErrors();
			}
		} else if (PDFAVersion == 1) {
			theExporter = new ZUGFeRDExporterFromA1();
			if (ignorePDFAErrors) {
				((ZUGFeRDExporterFromA1)theExporter).ignorePDFAErrors();
			}
		} else {
			throw new IllegalArgumentException("PDF-A version not supported");
		}


	}

	public IZUGFeRDExporter getExporter() {
		if (theExporter==null) {
			throw new RuntimeException("In ZUGFeRDExporterFromPDFA, source must always be loaded before other operations are performed.");
		}

		return theExporter;
	}

	protected byte[] filenameToByteArray(String pdfFilename) throws IOException {
		try (FileInputStream fileInputStream = new FileInputStream(pdfFilename)) {
			return inputstreamToByteArray(fileInputStream);
		}
	}

	protected byte[] inputstreamToByteArray(InputStream fileInputStream) throws IOException  {
		byte[] bytes = new byte[fileInputStream.available()];
		DataInputStream dataInputStream = new DataInputStream(fileInputStream);
		dataInputStream.readFully(bytes);
		return bytes;
	}

	/***
	 *
	 * @param byteArrayInputStream
	 * @return 0 if unknown, 1 for PDF/A-1 or 3 for PDF/A-3
	 * @throws IOException
	 */
	private int getPDFAVersion(byte[] byteArrayInputStream) throws IOException {
		PDDocument document = Loader.loadPDF(byteArrayInputStream);
		PDDocumentCatalog catalog = document.getDocumentCatalog();
		PDMetadata metadata = catalog.getMetadata();
		// the PDF version we could get through the document but we want the PDF-A version,
		// which is different (and can probably base on different PDF versions)
		if (metadata != null) {
			try {
				DomXmpParser xmpParser = new DomXmpParser();
				XMPMetadata xmp = xmpParser.parse(metadata.createInputStream());

				PDFAIdentificationSchema pdfaSchema = xmp.getPDFAIdentificationSchema();
				if (pdfaSchema != null) {
					return pdfaSchema.getPart();
				}
			} catch (XmpParsingException e) {
				LOGGER.error("XmpParsingException", e);
			} finally {
				document.close();
			}
		}
		return 0;
	}

	/***
	 * Load from filename
	 * @param pdfFilename binary of a PDF/A1 compliant document
	 * @return the A1 or A3 exporter
	 * @throws IOException e.g. on read error
	 */
	public IZUGFeRDExporter load(String pdfFilename) throws IOException {
		determineAndSetExporter(getPDFAVersion(filenameToByteArray(pdfFilename)));
		return theExporter.load(pdfFilename);
	}


	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary binary of a PDF/A1 compliant document
	 * @return the generated exporter
	 * @throws IOException (should not happen at all)
	 */
	public IZUGFeRDExporter load(byte[] pdfBinary) throws IOException {
		determineAndSetExporter(getPDFAVersion(pdfBinary));
		return theExporter.load(pdfBinary);
	}


	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfSource source to read a PDF/A1 compliant document from
	 * @return the generated ZUGFeRDExporter
	 * @throws IOException if anything is wrong with inputstream
	 */
	public IZUGFeRDExporter load(InputStream pdfSource) throws IOException {
		byte[] byteArray=inputstreamToByteArray(pdfSource);
		determineAndSetExporter(getPDFAVersion(byteArray));
		return theExporter.load(byteArray);
	}

	public IZUGFeRDExporter setCreator(String creator) {

		return getExporter().setCreator(creator);
	}

	public IZUGFeRDExporter setProfile(Profile p) {
		return getExporter().setProfile(p);
	}

	public IZUGFeRDExporter setProfile(String profileName) {
		Profile p = Profiles.getByName(profileName);
		if (p==null)  {
			throw new RuntimeException("Profile not found.");
		}
		return getExporter().setProfile(p);
	}

	public IZUGFeRDExporter setConformanceLevel(PDFAConformanceLevel newLevel) {
		return getExporter().setConformanceLevel(newLevel);
	}

	public IZUGFeRDExporter setProducer(String producer) {

		return getExporter().setProducer(producer);
	}

	public IZUGFeRDExporter setZUGFeRDVersion(int version) {

		return getExporter().setZUGFeRDVersion(version);

	}

	public boolean ensurePDFIsValid(final DataSource dataSource) throws IOException {

		return getExporter().ensurePDFIsValid(dataSource);
	}

	public IZUGFeRDExporter setXML(byte[] zugferdData) throws IOException {

		return getExporter().setXML(zugferdData);
	}

	public IZUGFeRDExporter disableFacturX() {

		return getExporter().disableFacturX();
	}

	//	public IZUGFeRDExporter setProfile(Profile zugferdConformanceLevel);
	public String getNamespaceForVersion(int ver) {

		return getExporter().getNamespaceForVersion(ver);
	}

	public String getPrefixForVersion(int ver) {

		return getExporter().getPrefixForVersion(ver);
	}

	public IZUGFeRDExporter disableAutoClose(boolean disableAutoClose) {
		return getExporter().disableAutoClose(disableAutoClose);
	}

	public IXMLProvider getProvider() {
		return getExporter().getProvider();
	}

	@Override
	public void close() throws IOException {
		getExporter().close();
	}

	@Override
	public IExporter setTransaction(IExportableTransaction trans) throws IOException {
		return getExporter().setTransaction(trans);
	}

	@Override
	public void export(String ZUGFeRDfilename) throws IOException {
		getExporter().export(ZUGFeRDfilename);
	}

	@Override
	public void export(OutputStream output) throws IOException {
		getExporter().export(output);
	}

	public void attachFile(FileAttachment file) {
		theExporter.attachFile(file);
	}

	public void attachFile(String filename, byte[] data, String mimetype, String relation) {
		theExporter.attachFile(filename, data, mimetype, relation);
	}

}

