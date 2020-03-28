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

import org.mustangproject.ZUGFeRD.model.CrossIndustryDocumentType;
import org.mustangproject.ZUGFeRD.model.DocumentContextParameterTypeConstants;
import org.mustangproject.ZUGFeRD.model.ZFNamespacePrefixMapper;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import java.io.ByteArrayOutputStream;

public class ZUGFeRD1PullProvider implements IXMLProvider, IProfileProvider {


	protected byte[] zugferdData;
	private Marshaller marshaller;

	private boolean isTest;
	private ZUGFeRDConformanceLevel level;


	public void setProfile(ZUGFeRDConformanceLevel level) {
		this.level = level;
	}

	public String getProfile() {
		switch (level) {
			case BASIC: return DocumentContextParameterTypeConstants.BASIC;
			case COMFORT: return DocumentContextParameterTypeConstants.COMFORT;
			default: return DocumentContextParameterTypeConstants.EXTENDED;
		}
	}


	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 */
	public void setTest() {
		isTest = true;
	}

	public ZUGFeRD1PullProvider() {
		// TODO Auto-generated constructor stub
		try {
			marshaller = JAXBContext.newInstance("org.mustangproject.ZUGFeRD.model").createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			marshaller.setProperty("com.sun.xml.bind.namespacePrefixMapper", new ZFNamespacePrefixMapper());
		} catch (JAXBException e) {
			throw new ZUGFeRDExportException("Could not initialize JAXB", e);
		}

	}

	private String createZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans) {

		JAXBElement<CrossIndustryDocumentType> jaxElement =
				new ZUGFeRDTransactionModelConverter(trans).withTest(isTest).withProfile(getProfile()).convertToModel();

		try {
			return marshalJaxToXMLString(jaxElement);
		} catch (JAXBException e) {
			throw new ZUGFeRDExportException("Could not marshal ZUGFeRD transaction to XML", e);
		}
	}

	private String marshalJaxToXMLString(Object jaxElement) throws JAXBException {
		ByteArrayOutputStream outputXml = new ByteArrayOutputStream();
		marshaller.marshal(jaxElement, outputXml);
		return outputXml.toString();
	}


	@Override
	public byte[] getXML() {
		return zugferdData;
	}


	@Override
	public void generateXML(IZUGFeRDExportableTransaction trans) {
		// create a dummy file stream, this would probably normally be a
		// FileInputStream

		byte[] zugferdRaw = createZugferdXMLForTransaction(trans).getBytes(); //$NON-NLS-1$

		if ((zugferdRaw[0] == (byte) 0xEF)
				&& (zugferdRaw[1] == (byte) 0xBB)
				&& (zugferdRaw[2] == (byte) 0xBF)) {
			// I don't like BOMs, lets remove it
			zugferdData = new byte[zugferdRaw.length - 3];
			System.arraycopy(zugferdRaw, 3, zugferdData, 0,
					zugferdRaw.length - 3);
		} else {
			zugferdData = zugferdRaw;
		}
	}


}
