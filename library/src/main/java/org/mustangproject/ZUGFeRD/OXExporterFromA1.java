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
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

public class OXExporterFromA1 extends OXExporterFromA3 implements IZUGFeRDExporter {
	protected boolean ignorePDFAErrors = false;

	public OXExporterFromA1 ignorePDFAErrors() {
		this.ignorePDFAErrors = true;
		return this;
	}

	private static boolean isValidA1(String dataSource) throws IOException {

		Path tempFile = Files.createTempFile(null, null);

		// Writes a string to the above temporary file
		Files.write(tempFile, dataSource.getBytes());

		return PreflightParser.validate(tempFile.toFile()).isValid();
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


	public OXExporterFromA1 setProfile(Profile p) {
		return (OXExporterFromA1)super.setProfile(p);
	}
	public OXExporterFromA1 setProfile(String profileName) {
		return (OXExporterFromA1)super.setProfile(profileName);
	}

	public boolean ensurePDFIsValid(final String dataSource) throws IOException {
		if (!ignorePDFAErrors && !isValidA1(dataSource)) {
			throw new IOException("File is not a valid PDF/A input file");
		}
		return true;
	}

	public OXExporterFromA1() {
		setZUGFeRDVersion(ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion);

	}

	public OXExporterFromA1 load(String pdfFilename) throws IOException {
		return (OXExporterFromA1) super.load(pdfFilename);
	}
	public OXExporterFromA1 load(byte[] pdfBinary) throws IOException {
		return (OXExporterFromA1) super.load(pdfBinary);
	}
	public OXExporterFromA1 load(InputStream pdfSource) throws IOException{
		return (OXExporterFromA1) super.load(pdfSource);
	}
	public OXExporterFromA1 setCreator(String creator) {
		return (OXExporterFromA1) super.setCreator(creator);
	}
	public OXExporterFromA1 setConformanceLevel(PDFAConformanceLevel newLevel) {
		return (OXExporterFromA1) super.setConformanceLevel(newLevel);
	}
	public OXExporterFromA1 setProducer(String producer){
		return (OXExporterFromA1) super.setProducer(producer);
	}
	public OXExporterFromA1 setZUGFeRDVersion(int version){
		return (OXExporterFromA1) super.setZUGFeRDVersion(version);
	}
	public OXExporterFromA1 setXML(byte[] zugferdData) throws IOException{
		return (OXExporterFromA1) super.setXML(zugferdData);
	}

	public OXExporterFromA1 disableAutoClose(boolean disableAutoClose){
		return (OXExporterFromA1) super.disableAutoClose(disableAutoClose);
	}
	public OXExporterFromA1 convertOnly() {
		setAttachZUGFeRDHeaders(false);
		return this;
	}

}
