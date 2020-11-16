
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
package org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;
import org.mustangproject.*;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;


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

		Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr","55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO), amount, new BigDecimal(1.0)));

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
