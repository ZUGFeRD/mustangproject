
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

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import junit.framework.TestCase;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.*;

import java.math.BigDecimal;
import java.util.Date;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class DeSerializationTest extends TestCase {
	public void testJackson() throws JsonProcessingException {

		ObjectMapper mapper = new ObjectMapper();
		Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty("some org", "teststr", "55232", "teststadt", "DE").addTaxID("taxID").addBankDetails(new BankDetails("DE3600000123456", "ABCDEFG1001").setAccountName("Donald Duck")).setEmail("info@company.com")).setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE4711").setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE"))).setNumber("0185").addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal("1"), new BigDecimal(1.0)));
		String jsonArray = mapper.writeValueAsString(i);

		// [{"stringValue":"a","intValue":1,"booleanValue":true},
		// {"stringValue":"bc","intValue":3,"booleanValue":false}]

		Invoice fromJSON = mapper.readValue(jsonArray, Invoice.class);
		assertEquals(fromJSON.getNumber(), i.getNumber());
		assertEquals(fromJSON.getZFItems().length, i.getZFItems().length);
		assertEquals("info@company.com", fromJSON.getSender().getEmail());
		assertEquals("info@company.com", fromJSON.getSender().getUriUniversalCommunicationID());

	}

	public void testAllowanceRead() throws JsonProcessingException {

		ObjectMapper mapper = new ObjectMapper();

		// [{"stringValue":"a","intValue":1,"booleanValue":true},
		// {"stringValue":"bc","intValue":3,"booleanValue":false}]

		Invoice fromJSON = mapper.readValue("{\n" +
			"  \"documentCode\": \"380\",\n" +
			"  \"number\": \"471102\",\n" +
			"  \"ownOrganisationName\": \"Lieferant GmbH\",\n" +
			"  \"currency\": \"EUR\",\n" +
			"  \"issueDate\": \"2018-03-03T23:00:00.000+00:00\",\n" +
			"  \"deliveryDate\": \"2018-03-03T23:00:00.000+00:00\",\n" +
			"  \"sender\": {\n" +
			"    \"name\": \"Lieferant GmbH\",\n" +
			"    \"zip\": \"80333\",\n" +
			"    \"street\": \"Lieferantenstraße 20\",\n" +
			"    \"location\": \"München\",\n" +
			"    \"country\": \"DE\",\n" +
			"    \"taxID\": \"201/113/40209\",\n" +
			"    \"vatID\": \"DE123456789\",\n" +
			"    \"vatid\": \"DE123456789\"\n" +
			"  },\n" +
			"  \"recipient\": {\n" +
			"    \"name\": \"Kunden AG Mitte\",\n" +
			"    \"zip\": \"69876\",\n" +
			"    \"street\": \"Kundenstraße 15\",\n" +
			"    \"location\": \"Frankfurt\",\n" +
			"    \"country\": \"DE\"\n" +
			"  },\n" +
			"  \"grandTotal\": 234.43,\n" +
			"  \"zfitems\": [\n" +
			"    {\n" +
			"      \"price\": 9.9,\n" +
			"      \"quantity\": 20,\n" +
			"      \"tax\": null,\n" +
			"      \"grossPrice\": null,\n" +
			"      \"lineTotalAmount\": null,\n" +
			"      \"basisQuantity\": 1,\n" +
			"      \"detailedDeliveryPeriodFrom\": null,\n" +
			"      \"detailedDeliveryPeriodTo\": null,\n" +
			"      \"id\": null,\n" +
			"      \"product\": {\n" +
			"        \"unit\": \"H87\",\n" +
			"        \"name\": \"Trennblätter A4\",\n" +
			"        \"taxCategoryCode\": \"S\",\n" +
			"        \"attributes\": null,\n" +
			"        \"vatpercent\": 19\n" +
			"      },\n" +
			"      \"value\": 9.9\n" +
			"    }\n" +
			"  ],\n" +
			"  \"tradeSettlement\": null,\n" +
			"  \"ownTaxID\": \"201/113/40209\",\n" +
			"  \"ownVATID\": \"DE123456789\",\n" +
			"  \"ownStreet\": \"Lieferantenstraße 20\",\n" +
			"  \"ownZIP\": \"80333\",\n" +
			"  \"ownLocation\": \"München\",\n" +
			"  \"ownCountry\": \"DE\",\n" +
			"  \"zfallowances\": [\n" +
			"    {\n" +
			"      \"totalAmount\": 1,\n" +
			"      \"taxPercent\": 19,\n" +
			"      \"reason\": \"Sondernachlass\",\n" +
			"      \"reasonCode\": null,\n" +
			"      \"categoryCode\": \"S\",\n" +
			"      \"charge\": false\n" +
			"    }\n" +
			"  ]\n" +
			"}", Invoice.class);
		TransactionCalculator tc=new TransactionCalculator(fromJSON);
		assertEquals(tc.getGrandTotal(),new BigDecimal("234.43"));
		assertEquals(fromJSON.getNumber(), fromJSON.getNumber());
		assertEquals(fromJSON.getZFItems().length, fromJSON.getZFItems().length);

	}




}
