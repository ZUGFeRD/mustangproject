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

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import org.apache.pdfbox.io.IOUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;
import org.apache.pdfbox.preflight.utils.ByteArrayDataSource;

public class ZUGFeRDExporterFromA3Factory implements IExporterFactory {
	protected boolean ignorePDFAErrors = false;
	protected ZUGFeRDConformanceLevel zugferdConformanceLevel = ZUGFeRDConformanceLevel.EXTENDED;
	protected PDFAConformanceLevel conformanceLevel = PDFAConformanceLevel.UNICODE;
	/** Producer (attribute for PDF */
	protected String producer = "mustangproject";
	/** Human creator (attribute for PDF) */
	protected String creator = "mustangproject";
	/** Creator tool (attribute for PDF) */
	protected String creatorTool = null;

	protected int ZFVersion=ZUGFeRDExporter.DefaultZUGFeRDVersion;
	protected boolean ensurePDFisUpgraded=false;
	private boolean attachZUGFeRDHeaders=true;
	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfFilename
	 *            filename of an PDF/A1 compliant document
	 */
	public ZUGFeRDExporter load(String pdfFilename) throws IOException {

		ensurePDFIsValidPDFA(new FileDataSource(pdfFilename));
		ZUGFeRDExporter zugFeRDExporter;
		PDDocument doc = PDDocument.load(new File(pdfFilename));
		zugFeRDExporter = new ZUGFeRDExporter(doc);
		zugFeRDExporter.setZUGFeRDVersion(ZFVersion);
		zugFeRDExporter.setZUGFeRDConformanceLevel(zugferdConformanceLevel);
		zugFeRDExporter.setCreator(creator);
		// Use creator as default for compatibility
		zugFeRDExporter.setCreatorTool(creatorTool != null ? creatorTool : creator);
		zugFeRDExporter.setProducer(producer);
		zugFeRDExporter.setAttachZUGFeRDHeaders(attachZUGFeRDHeaders);
		zugFeRDExporter.setPDFA3(ensurePDFisUpgraded);

		return zugFeRDExporter;

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
		zugFeRDExporter = new ZUGFeRDExporter(doc);
		zugFeRDExporter.setZUGFeRDVersion(ZFVersion);
		zugFeRDExporter.setZUGFeRDConformanceLevel(zugferdConformanceLevel);
		zugFeRDExporter.setCreator(creator);
		zugFeRDExporter.setProducer(producer);
		zugFeRDExporter.setAttachZUGFeRDHeaders(attachZUGFeRDHeaders);
		zugFeRDExporter.setPDFA3(ensurePDFisUpgraded);

		return zugFeRDExporter;
	}

	public ZUGFeRDExporterFromA3Factory () {

		ensurePDFisUpgraded=false;
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
		private static boolean isValidA1(DataSource dataSource) throws IOException {
		return getPDFAParserValidationResult(new PreflightParser(dataSource));
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
		parser.parse();// might add a Format.PDF_A1A as parameter and iterate through A1 and A3

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


	public IExporterFactory setCreator(String creator) {
		this.creator = creator;
		return this;
	}
	
	public IExporterFactory setCreatorTool(String creatorTool) {
		this.creatorTool = creatorTool;
		return this;
	}

	public IExporterFactory setProducer(String producer) {
		this.producer = producer;
		return this;
	}
	public IExporterFactory setAttachZUGFeRDHeaders(boolean attachHeaders) {
		this.attachZUGFeRDHeaders = attachHeaders;
		return this;
	}


	@Override
	public IExporterFactory setZUGFeRDVersion(int version) {
		this.ZFVersion=version;
		return this;
	}
}
