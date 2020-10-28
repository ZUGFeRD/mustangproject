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

import org.apache.pdfbox.cos.*;
import org.apache.pdfbox.io.IOUtils;
import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;
import org.apache.pdfbox.preflight.utils.ByteArrayDataSource;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.AdobePDFSchema;
import org.apache.xmpbox.schema.DublinCoreSchema;
import org.apache.xmpbox.schema.PDFAIdentificationSchema;
import org.apache.xmpbox.schema.XMPBasicSchema;
import org.apache.xmpbox.type.BadFieldValueException;
import org.apache.xmpbox.xml.XmpSerializer;

import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.xml.transform.TransformerException;
import java.io.*;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

public class XRExporter implements IExporter  {
	IXMLProvider xmlProvider;
	IExportableTransaction trans;

	public XRExporter() {
	}


	@Override
	public IExporter setTransaction(IExportableTransaction trans) throws IOException {
		this.trans=trans;
		return this;
	}

	@Override
	public void export(String ZUGFeRDfilename) throws IOException {
		export(new FileOutputStream(new File(ZUGFeRDfilename)));

	}

	@Override
	public void export(OutputStream output) throws IOException {
		xmlProvider.generateXML(trans);
		byte[] bytes=xmlProvider.getXML();
		output.write(bytes, 0, bytes.length);
	}
}
