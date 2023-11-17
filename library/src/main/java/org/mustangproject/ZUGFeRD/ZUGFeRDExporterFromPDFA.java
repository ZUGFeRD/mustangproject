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
import java.io.OutputStream;

public class ZUGFeRDExporterFromPDFA implements IZUGFeRDExporter {
	protected IZUGFeRDExporter theExporter=null;


	public IZUGFeRDExporter load(String pdfFilename) throws IOException {
		return (IZUGFeRDExporter)theExporter.load(pdfFilename);
	}

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary binary of a PDF/A1 compliant document
	 * @return the generated exporter
	 * @throws IOException (should not happen at all)
	 */
	public IZUGFeRDExporter load(byte[] pdfBinary) throws IOException{
		return theExporter.load(pdfBinary);
	}


	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfSource source to read a PDF/A1 compliant document from
	 * @throws IOException if anything is wrong with inputstream
	 * @return the generated ZUGFeRDExporter
	 */
	public IZUGFeRDExporter load(InputStream pdfSource) throws IOException {
		return theExporter.load(pdfSource);
	}
	public IZUGFeRDExporter setCreator(String creator)
	{
		return theExporter.setCreator(creator);
	}
	public IZUGFeRDExporter setConformanceLevel(PDFAConformanceLevel newLevel){
		return theExporter.setConformanceLevel(newLevel);
	}
	public IZUGFeRDExporter setProducer(String producer) {
		return theExporter.setProducer(producer);
	}
	public IZUGFeRDExporter setZUGFeRDVersion(int version) {

			return theExporter.setZUGFeRDVersion(version);

	}
	public boolean ensurePDFIsValid(final DataSource dataSource) throws IOException {
		return theExporter.ensurePDFIsValid(dataSource);
	}
	public IZUGFeRDExporter setXML(byte[] zugferdData) throws IOException {
		return theExporter.setXML(zugferdData);
	}
	public IZUGFeRDExporter disableFacturX() {
		return theExporter.disableFacturX();
	}
	//	public IZUGFeRDExporter setProfile(Profile zugferdConformanceLevel);
	public String getNamespaceForVersion(int ver) {
		return theExporter.getNamespaceForVersion(ver);
	}
	public String getPrefixForVersion(int ver) {
		return theExporter.getPrefixForVersion(ver);
	}
	public IZUGFeRDExporter disableAutoClose(boolean disableAutoClose) {
		return theExporter.disableAutoClose(disableAutoClose);
	}
	public IXMLProvider getProvider() {
		return theExporter.getProvider();
	}

	@Override
	public void close() throws IOException {
		theExporter.close();
	}

	@Override
	public IExporter setTransaction(IExportableTransaction trans) throws IOException {
		return theExporter.setTransaction(trans);
	}

	@Override
	public void export(String ZUGFeRDfilename) throws IOException {
		theExporter.export(ZUGFeRDfilename);
	}

	@Override
	public void export(OutputStream output) throws IOException {
		theExporter.export(output);
	}
}

