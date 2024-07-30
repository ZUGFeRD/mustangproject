
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
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.*;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Date;



@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class PreValidationTest extends TestCase {
	final String TARGET_PDF = "./target/testout-Preval.pdf";
	final String SOURCE_PDF = "/veraPDFtestsuite6-7-11-t01-fail-a.pdf";

	public void testFailIgnore() {

		// the writing part


		boolean hasEx = false;
		try (InputStream source = this.getClass()
			.getResourceAsStream(SOURCE_PDF)) {
			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
				.setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2)
				.load(source);
			ze.setTransaction(createInvoice());

			ze.export(TARGET_PDF);
		} catch (IOException e) {
			hasEx = true;
		}
		assertTrue(hasEx);
		hasEx = false;
		try (InputStream source = this.getClass()
			.getResourceAsStream(SOURCE_PDF)) {
			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(source);

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).
				setTransaction(createInvoice());
			ze.export(TARGET_PDF);
		} catch (IOException e) {
			hasEx = true;
		}
		assertFalse(hasEx);
	}

	private Invoice createInvoice() {
		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		return new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
			.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("DE4711").addVATID("DE0815").setEmail("info@example.org").setContact(new Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX")))
			.setRecipient(new TradeParty("Theodor Est", "Bahnstr. 42", "88802", "Spielkreis", "DE"))
			.setReferenceNumber("991-01484-64")//leitweg-id
			// not using any VAT, this is also a test of zero-rated goods:
			.setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO), amount, new BigDecimal(1.0)));
	}

}
