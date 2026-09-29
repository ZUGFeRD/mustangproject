
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
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mustangproject.*;
import org.mustangproject.ZUGFeRD.model.EventTimeCodeTypeConstants;

import javax.xml.xpath.XPathExpressionException;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.MethodName.class)
public class DebitTest extends ResourceCase {

	@Test
	public void testImport() {
		File inputCII = getResourceAsFile("factur-x.xml");
		boolean hasExceptions = false;

		Invoice i = new Invoice();
		ZUGFeRD2PullProvider ze=new ZUGFeRD2PullProvider();
		try {
		 i.setIssueDate(new Date()).setDueDate(new Date()).setDetailedDeliveryPeriod(new Date(), new Date()).setDeliveryDate(new Date())
			.setSender(new TradeParty("Test", "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815")
				.addDebitDetails(new DirectDebit("DE887115257006200XXXXX", "XY90012")))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addVATID("DE0815"))
			.setNumber("123")
			.setDeliveryNoteReferencedDocument(new ReferencedDocument("0815").setFormattedIssueDateTime(new SimpleDateFormat("dd.MM.yyyy").parse("01.04.2016")))
			.addItem(new Item(new Product("Testprodukt", "", "H87", new BigDecimal(19)), BigDecimal.ONE, BigDecimal.ONE));
		} catch ( ParseException e ) {
			hasExceptions = true;
		}
		ze.generateXML(i);
		String theXML = new String(ze.getXML(), StandardCharsets.UTF_8);

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		try {
			zii.fromXML(theXML);

		} catch (ParseException e) {
			hasExceptions = true;
		}

		CalculatedInvoice ci = new CalculatedInvoice();
		try {
			zii.extractInto(ci);
			/*			for (BankDetails cbd: ci.getRecipient().getBankDetails()) {

				System.out.println(theXML);
				System.out.println("Means : "+cbd.getPaymentMeansCode());
				System.out.println("recipient IBAN: "+cbd.getIBAN());
			}*/
			assertEquals(1, ci.getRecipient().getBankDetails().size());
			assertEquals(0, ci.getSender().getBankDetails().size());
			assertEquals("59", ci.getRecipient().getBankDetails().get(0).getPaymentMeansCode());
		} catch (ParseException | XPathExpressionException e) {
			hasExceptions = true;
		}
		assertFalse(hasExceptions);

	}


}
