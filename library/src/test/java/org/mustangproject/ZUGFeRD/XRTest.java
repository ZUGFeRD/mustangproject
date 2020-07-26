
/**
 * *********************************************************************
 * <p>
 * Copyright 2019 Jochen Staerk
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
package library.src.test.java.org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;
import library.src.main.java.org.mustangproject.Contact;
import library.src.main.java.org.mustangproject.Invoice;
import library.src.main.java.org.mustangproject.Item;
import library.src.main.java.org.mustangproject.Product;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA3Factory;
import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;



import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;


import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Date;

import static org.xmlunit.assertj.XmlAssert.assertThat;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class XRTest extends TestCase {

	public void testPushExport() {

		// the writing part

		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);

		Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setOwnOrganisationName(orgname).setOwnStreet("teststr").setOwnZIP("55232").setOwnLocation("teststadt").setOwnCountry("DE").setOwnTaxID("4711").setOwnVATID("0815").setRecipient(new Contact("Franz Müller", "0177123456", "fmueller@test.com", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(0)), amount, new BigDecimal(1.0)));

		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.generateXML(i);
		String theXML = new String(zf2p.getXML());
		assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
		assertThat(theXML).valueByXPath("count(//*[local-name()='IncludedSupplyChainTradeLineItem'])")
				.asInt()
				.isEqualTo(1); //2 errors are OK because there is a known bug


		assertThat(theXML).valueByXPath("//*[local-name()='DuePayableAmount']")
				.asDouble()
				.isEqualTo(1);


	}

}
