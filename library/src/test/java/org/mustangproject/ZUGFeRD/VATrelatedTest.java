
/** **********************************************************************
 *
 * Copyright 2019 Jochen Staerk
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

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.*;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class VATrelatedTest extends ResourceCase  {
	final String TARGET_PDF_REVERSE = "./target/testout-ReverseCharge.pdf";
	final String TARGET_PDF_Z = "./target/testout-TaxcodeZ.pdf";

	public void testReverseCharge() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "3.00";
		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProfile(Profiles.getByName("Extended"));

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("extended");
			//	ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
			//					.addItem(new Item(new Product("Testprodukt", "", "H84", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50)))));

			Product p=new Product("Testprodukt", "", "H87", new BigDecimal(19));
			p.setReverseCharge();
			Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")
					.setContact(new Contact("contact testname", "123456", "contact.testemail@example.org").setFax("0911623562")).addVATID("DE0915"))
				.setNumber(number)
				.addCharge(new Charge(new BigDecimal(1)).setReasonCode("ABK").setReason("AReason").setTaxPercent(new BigDecimal(19)))

				.addItem(new Item(p, price, new BigDecimal(1.0)));
			ze.setTransaction(i);


			String theXML = new String(ze.getProvider().getXML(), StandardCharsets.UTF_8);
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_PDF_REVERSE);
		} catch (IOException e) {
			fail("IOException should not be raised");
		}

		try {
			// now check the contents (like MustangReaderTest)
			ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_REVERSE);
			assertEquals("EUR", zi.getInvoiceCurrencyCode());
			assertTrue(zi.getUTF8().contains("0911623562")); // fax number

			// Reading ZUGFeRD
			assertEquals("4.19", zi.getAmount());
			assertEquals(orgname, zi.getHolder());
			assertEquals(number, zi.getForeignReference());
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			fail("Exception "+e.getMessage()+" should not be raised");
		}
	}

	public void testTaxcodeZ() {

		String orgname = "Test company";
		String number = "123";
		String priceStr = "3.00";
		BigDecimal price = new BigDecimal(priceStr);
		try {
			InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1();
			ze.ignorePDFAErrors().load(SOURCE_PDF);
			ze.setProfile(Profiles.getByName("Extended"));

			ze.setProducer("My Application").setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("extended");
			//	ze.setTransaction(new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(orgname,"teststr", "55232","teststadt","DE")).setOwnTaxID("4711").setOwnVATID("DE0815").setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number)
			//					.addItem(new Item(new Product("Testprodukt", "", "H84", new BigDecimal(19)), amount, new BigDecimal(1.0)).addAllowance(new Allowance().setPercent(new BigDecimal(50)))));

			Product p;

			ObjectMapper mapper = new ObjectMapper();
			String json="{\n" +
				"        \"unit\": \"H87\",\n" +
				"        \"name\": \"Joghurt Banane\",\n" +
				"        \"description\": \"\",\n" +

				"        \"taxCategoryCode\": \"Z\"\n" +
				"      }";// 				"        \"vatpercent\": 0,\n" + missing, #979
			p=mapper.readValue(json, Product.class);

			Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE")
					.setContact(new Contact("contact testname", "123456", "contact.testemail@example.org").setFax("0911623562")))
				.setNumber(number)
				.addCharge(new Charge(new BigDecimal(1)).setReasonCode("ABK").setReason("AReason").setTaxPercent(new BigDecimal(19)))

				.addItem(new Item(p, price, new BigDecimal(1.0)));
			ze.setTransaction(i);


			String theXML = new String(ze.getProvider().getXML(), StandardCharsets.UTF_8);
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_PDF_Z);
		} catch (IOException e) {
			fail("IOException "+e.getMessage()+" should not be raised");
		}

		try {
			// now check the contents (like MustangReaderTest)
			ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_Z);
			assertEquals("EUR", zi.getInvoiceCurrencyCode());
			assertTrue(zi.getUTF8().contains("0911623562")); // fax number

			// Reading ZUGFeRD
			assertEquals("4.19", zi.getAmount());
			assertEquals(orgname, zi.getHolder());
			assertEquals(number, zi.getForeignReference());
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			fail("Exception should not be raised");
		}
	}
}
