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

public interface IExporterFactory {
	/**
	 * factory: loads a PDF file and returns an appropriate exporter 
	 *
	 * @param pdfFilename binary of a PDF/A1 compliant document
	 * @return the generated exporter
	 * @throws IOException if anything is wrong with filename
	 */
	public ZUGFeRDExporter load(String pdfFilename) throws IOException;

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary binary of a PDF/A1 compliant document
	 * @return the generated exporter
	 * @throws IOException (should not happen at all)
	 */
	public ZUGFeRDExporter load(byte[] pdfBinary) throws IOException;

	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfSource source to read a PDF/A1 compliant document from
	 * @throws IOException if anything is wrong with inputstream
	 * @return the generated ZUGFeRDExporter
	 */
	public ZUGFeRDExporter load(InputStream pdfSource) throws IOException;

	public IExporterFactory setCreator(String creator);

	public IExporterFactory setConformanceLevel(PDFAConformanceLevel newLevel);

	public IExporterFactory setProducer(String producer);

	public IExporterFactory setZUGFeRDVersion(int version);

	public IExporterFactory ignorePDFAErrors();

	public IExporterFactory setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel zugferdConformanceLevel);

}
