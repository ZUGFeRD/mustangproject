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


import java.io.IOException;
import java.io.InputStream;

import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.ValidationResult;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;
import org.mustangproject.EStandard;

import jakarta.activation.DataSource;

public class ZUGFeRDExporterFromA1 extends ZUGFeRDExporterFromA3 {

	private static boolean isValidA1(DataSource dataSource) throws IOException {
		return getPDFAParserValidationResult(PreflightParserHelper.createPreflightParser(dataSource));
	}

	private static boolean getPDFAParserValidationResult(PreflightParser parser) throws IOException {
		/*
		 * Parse the PDF file with PreflightParser that inherits from the
		 * NonSequentialParser. Some additional controls are present to check a set of
		 * PDF/A requirements. (Stream length consistency, EOL after some Keyword...)
		 */
		// might add a Format.PDF_A1A as parameter and iterate through A1 and A3

		try (PreflightDocument document = (PreflightDocument) parser.parse()) {
			/*
			 * Once the syntax validation is done, the parser can provide a
			 * PreflightDocument (that inherits from PDDocument) This document process the
			 * end of PDF/A validation.
			 */

			ValidationResult res = document.validate();

			// Get validation result
			return res.isValid();
		} catch (ValidationException e) {
			/*
			 * the parse method can throw a SyntaxValidationException if the PDF file can't
			 * be parsed. In this case, the exception contains an instance of
			 * ValidationResult
			 */
			return false;
		}
	}


	@Override
  public ZUGFeRDExporterFromA1 setProfile(Profile p) {
		return (ZUGFeRDExporterFromA1)super.setProfile(p);
	}
	@Override
  public ZUGFeRDExporterFromA1 setProfile(String profileName) {
		return (ZUGFeRDExporterFromA1)super.setProfile(profileName);
	}

	@Override
  public boolean ensurePDFIsValid(final DataSource dataSource) throws IOException {
		if (!ignorePDFAErrors && !isValidA1(dataSource)) {
			throw new IOException("File is not a valid PDF/A-1 input file");
		}
		return true;
	}


	@Override
  public ZUGFeRDExporterFromA1 load(String pdfFilename) throws IOException {
		return (ZUGFeRDExporterFromA1) super.load(pdfFilename);
	}
	@Override
  public ZUGFeRDExporterFromA1 load(byte[] pdfBinary) throws IOException {
		return (ZUGFeRDExporterFromA1) super.load(pdfBinary);
	}
	@Override
  public ZUGFeRDExporterFromA1 load(InputStream pdfSource) throws IOException{
		return (ZUGFeRDExporterFromA1) super.load(pdfSource);
	}
	@Override
  public ZUGFeRDExporterFromA1 setCreator(String creator) {
		return (ZUGFeRDExporterFromA1) super.setCreator(creator);
	}
	@Override
  public ZUGFeRDExporterFromA1 setConformanceLevel(PDFAConformanceLevel newLevel) {
		return (ZUGFeRDExporterFromA1) super.setConformanceLevel(newLevel);
	}
	@Override
  public ZUGFeRDExporterFromA1 setProducer(String producer){
		return (ZUGFeRDExporterFromA1) super.setProducer(producer);
	}
	@Override
  public ZUGFeRDExporterFromA1 setZUGFeRDVersion(EStandard est, int version){
		return (ZUGFeRDExporterFromA1) super.setZUGFeRDVersion(est, version);
	}
	@Override
  public ZUGFeRDExporterFromA1 setZUGFeRDVersion(int version){
		return (ZUGFeRDExporterFromA1) super.setZUGFeRDVersion(version);
	}
	@Override
  public ZUGFeRDExporterFromA1 setXML(byte[] zugferdData) throws IOException{
		return (ZUGFeRDExporterFromA1) super.setXML(zugferdData);
	}

	@Override
  public ZUGFeRDExporterFromA1 disableAutoClose(boolean disableAutoClose){
		return (ZUGFeRDExporterFromA1) super.disableAutoClose(disableAutoClose);
	}
	public ZUGFeRDExporterFromA1 convertOnly() {
		setAttachZUGFeRDHeaders(false);
		return this;
	}

}
