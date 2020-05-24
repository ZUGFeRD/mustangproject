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

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import org.junit.Assert;
import org.mustangproject.ZUGFeRD.model.CrossIndustryDocumentType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.parsers.DocumentBuilderFactory;

public class ZUGFeRDXMLAssert {
	private static final ISchematronResource SCHEMATRON = loadSchematron();

	public static void assertValidZugferd(JAXBElement<CrossIndustryDocumentType> xml) throws Exception {
		assertValidZugferd(toDocument(xml));
	}

	public static void assertValidZugferd(Node xml) throws Exception {
		Assert.assertTrue("schema valid", SCHEMATRON.getSchematronValidity(xml, null).isValid());
	}

	private static Document toDocument(Object jaxbElement) throws Exception {
		final Document result = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		JAXBContext.newInstance("org.mustangproject.ZUGFeRD.model").createMarshaller().marshal(jaxbElement, result);
		return result;
	}

	private static SchematronResourcePure loadSchematron() {
		final SchematronResourcePure result = SchematronResourcePure.fromClassPath("/ZUGFeRD_1p0.scmt");
		if (!result.isValidSchematron()) {
			throw new IllegalArgumentException("Invalid Schematron!");
		}
		return result;
	}
}
