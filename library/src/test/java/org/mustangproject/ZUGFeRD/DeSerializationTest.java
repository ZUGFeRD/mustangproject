
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
		Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty("some org", "teststr", "55232", "teststadt", "DE").addTaxID("taxID")).setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE4711").setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE"))).setNumber("0185").addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal("1"), new BigDecimal(1.0)));
		String jsonArray = mapper.writeValueAsString(i);

		// [{"stringValue":"a","intValue":1,"booleanValue":true},
		// {"stringValue":"bc","intValue":3,"booleanValue":false}]

		Invoice fromJSON = mapper.readValue(jsonArray, Invoice.class);
		assertEquals(fromJSON.getNumber(), i.getNumber());
		assertEquals(fromJSON.getZFItems().length, i.getZFItems().length);

	}
}
