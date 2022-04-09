/** **********************************************************************
 *
 * Copyright 2020 Jochen Staerk
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


import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;

import javax.activation.DataSource;
import java.io.IOException;
import java.io.InputStream;

public class DXExporterFromA1 extends DXExporterFromA3 implements IZUGFeRDExporter {
	protected boolean ignorePDFAErrors = false;

	public DXExporterFromA1 ignorePDFAErrors() {
		this.ignorePDFAErrors = true;
		return this;
	}

	private static boolean isValidA1(DataSource dataSource) throws IOException {
		return getPDFAParserValidationResult(new PreflightParser(dataSource));
	}
	/***
	 * internal helper function: get namespace for order-x
	 * @param ver the order-x version
	 * @return the URN of the namespace
	 */
	public String getNamespaceForVersion(int ver) {
		return "urn:factur-x:pdfa:CrossIndustryDocument:1p0#";
	}
	/***
	 * internal helper: returns the namespace prefix for the given order-x version number
	 * @param ver the ox version
	 * @return the namespace prefix as string, without colon
	 */
	public String getPrefixForVersion(int ver) {
		return "fx";
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


	public DXExporterFromA1 setProfile(Profile p) {
		return (DXExporterFromA1)super.setProfile(p);
	}
	public DXExporterFromA1 setProfile(String profileName) {
		return (DXExporterFromA1)super.setProfile(profileName);
	}

	public boolean ensurePDFIsValid(final DataSource dataSource) throws IOException {
		if (!ignorePDFAErrors && !isValidA1(dataSource)) {
			throw new IOException("File is not a valid PDF/A input file");
		}
		return true;
	}

	public DXExporterFromA1() {
		setZUGFeRDVersion(ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion);

	}

	public DXExporterFromA1 load(String pdfFilename) throws IOException {
		return (DXExporterFromA1) super.load(pdfFilename);
	}
	public DXExporterFromA1 load(byte[] pdfBinary) throws IOException {
		return (DXExporterFromA1) super.load(pdfBinary);
	}
	public DXExporterFromA1 load(InputStream pdfSource) throws IOException{
		return (DXExporterFromA1) super.load(pdfSource);
	}
	public DXExporterFromA1 setCreator(String creator) {
		return (DXExporterFromA1) super.setCreator(creator);
	}
	public DXExporterFromA1 setConformanceLevel(PDFAConformanceLevel newLevel) {
		return (DXExporterFromA1) super.setConformanceLevel(newLevel);
	}
	public DXExporterFromA1 setProducer(String producer){
		return (DXExporterFromA1) super.setProducer(producer);
	}
	public DXExporterFromA1 setZUGFeRDVersion(int version){
		return (DXExporterFromA1) super.setZUGFeRDVersion(version);
	}
	public DXExporterFromA1 setXML(byte[] zugferdData) throws IOException{
		return (DXExporterFromA1) super.setXML(zugferdData);
	}

	public DXExporterFromA1 disableAutoClose(boolean disableAutoClose){
		return (DXExporterFromA1) super.disableAutoClose(disableAutoClose);
	}
	public DXExporterFromA1 convertOnly() {
		setAttachZUGFeRDHeaders(false);
		return this;
	}

}
