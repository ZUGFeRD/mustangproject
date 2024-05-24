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


import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;
import org.mustangproject.EStandard;

import javax.activation.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

public class ZUGFeRDExporterFromA1 extends ZUGFeRDExporterFromA3 implements IZUGFeRDExporter {
	protected boolean ignorePDFAErrors = false;

	public ZUGFeRDExporterFromA1 ignorePDFAErrors() {
		this.ignorePDFAErrors = true;
		return this;
	}

	private static boolean isValidA1(String dataSource) throws IOException {

		Path tempFile = Files.createTempFile(null, null);

		// Writes a string to the above temporary file
		Files.write(tempFile, dataSource.getBytes());

		return PreflightParser.validate(tempFile.toFile()).isValid();
	}



	public ZUGFeRDExporterFromA1 setProfile(Profile p) {
		return (ZUGFeRDExporterFromA1)super.setProfile(p);
	}
	public ZUGFeRDExporterFromA1 setProfile(String profileName) {
		return (ZUGFeRDExporterFromA1)super.setProfile(profileName);
	}

	public boolean ensurePDFIsValid(final String dataSource) throws IOException {
		if (!ignorePDFAErrors && !isValidA1(dataSource)) {
			throw new IOException("File is not a valid PDF/A-1 input file");
		}
		return true;
	}


	public ZUGFeRDExporterFromA1 load(String pdfFilename) throws IOException {
		return (ZUGFeRDExporterFromA1) super.load(pdfFilename);
	}
	public ZUGFeRDExporterFromA1 load(byte[] pdfBinary) throws IOException {
		return (ZUGFeRDExporterFromA1) super.load(pdfBinary);
	}
	public ZUGFeRDExporterFromA1 load(InputStream pdfSource) throws IOException{
		return (ZUGFeRDExporterFromA1) super.load(pdfSource);
	}
	public ZUGFeRDExporterFromA1 setCreator(String creator) {
		return (ZUGFeRDExporterFromA1) super.setCreator(creator);
	}
	public ZUGFeRDExporterFromA1 setConformanceLevel(PDFAConformanceLevel newLevel) {
		return (ZUGFeRDExporterFromA1) super.setConformanceLevel(newLevel);
	}
	public ZUGFeRDExporterFromA1 setProducer(String producer){
		return (ZUGFeRDExporterFromA1) super.setProducer(producer);
	}
	public ZUGFeRDExporterFromA1 setZUGFeRDVersion(EStandard est, int version){
		return (ZUGFeRDExporterFromA1) super.setZUGFeRDVersion(est, version);
	}
	public ZUGFeRDExporterFromA1 setZUGFeRDVersion(int version){
		return (ZUGFeRDExporterFromA1) super.setZUGFeRDVersion(version);
	}
	public ZUGFeRDExporterFromA1 setXML(byte[] zugferdData) throws IOException{
		return (ZUGFeRDExporterFromA1) super.setXML(zugferdData);
	}

	public ZUGFeRDExporterFromA1 disableAutoClose(boolean disableAutoClose){
		return (ZUGFeRDExporterFromA1) super.disableAutoClose(disableAutoClose);
	}
	public ZUGFeRDExporterFromA1 convertOnly() {
		setAttachZUGFeRDHeaders(false);
		return this;
	}

}
