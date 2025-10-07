
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
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.*;
import org.mustangproject.ZUGFeRD.model.EventTimeCodeTypeConstants;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.xpath.XPathExpressionException;

import static org.assertj.core.api.Assertions.assertThat;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class DeSerializationTest extends ResourceCase {
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

	public void testProduct() throws IOException, XPathExpressionException, ParseException {
		File inputCII = getResourceAsFile("Extended_fremdwaehrung.xml");
		var zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.fromXML(Files.readString(inputCII.toPath()));
		var product = zii.extractInvoice()
			.getZFItems()[0]
			.getProduct();

		assertThat(product.getCountryOfOrigin()).as("Product Country of origin")
			.isEqualTo("DE");
		assertThat(product.getSellerAssignedID()).as("Product Seller assigned ID")
			.isEqualTo("CO-123/V2A");
		assertThat(product.getBuyerAssignedID()).as("Product Buyer assigned ID")
			.isEqualTo("Toolbox 0815");
		assertThat(product.getName()).as("Name")
			.isEqualTo("Stahlcoil");

		assertThat(product.getAttributes()).as("Product attributes")
			.containsKey("LeoID")
			.containsValue("704310.0105636504");
	}

	public void testInvoiceLine() throws JsonProcessingException {
		File inputCII = getResourceAsFile("factur-x.xml");
		boolean hasExceptions = false;

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		try {
			zii.fromXML(new String(Files.readAllBytes(inputCII.toPath()), StandardCharsets.UTF_8));

		} catch (IOException | ParseException e) {
			hasExceptions = true;
		}

		CalculatedInvoice ci = new CalculatedInvoice();
		try {
			zii.extractInto(ci);
		} catch (XPathExpressionException e) {
			hasExceptions = true;
		} catch (ParseException e) {
			hasExceptions = true;
		}
		ObjectMapper mapper = new ObjectMapper();
		String jsonArray = mapper.writeValueAsString(ci);
		assertFalse(hasExceptions);
		assertTrue(jsonArray.contains("lineTotalAmount"));

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
			"  \"detailedDeliveryPeriodFrom\": \"2017-03-03T13:00:00.000+00:00\",\n" +
			"  \"detailedDeliveryPeriodTo\": \"2017-03-04T13:00:00.000+00:00\",\n" +
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
		TransactionCalculator tc = new TransactionCalculator(fromJSON);
		assertEquals(tc.getGrandTotal(), new BigDecimal("234.43"));
		assertEquals(fromJSON.getNumber(), fromJSON.getNumber());

		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(fromJSON);
		String theXML = new String(zf2p.getXML(), StandardCharsets.UTF_8);

		assertEquals(fromJSON.getZFItems().length, fromJSON.getZFItems().length);
		assertTrue(theXML.contains("20170303"));
		assertTrue(theXML.contains("20170304"));

	}

	public void testDeserializedFiles() {
		File inputUBL = getResourceAsFile("XRECHNUNG_Elektron.ubl.xml");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		Invoice i = new Invoice();
		String exText = null;

		try {
			zii.fromXML(new String(Files.readAllBytes(inputUBL.toPath()), StandardCharsets.UTF_8));
			ObjectMapper mapper = new ObjectMapper();
			zii.extractInto(i);
			String json = mapper.writeValueAsString(i);
			Invoice newInvoiceFromJSON = mapper.readValue(json, Invoice.class);

			assertEquals("181301674", i.getNumber());
			assertEquals(newInvoiceFromJSON.getNumber(), i.getNumber());
			assertEquals(newInvoiceFromJSON.getAdditionalReferencedDocuments()[0].getFilename(), i.getAdditionalReferencedDocuments()[0].getFilename());
			assertEquals(newInvoiceFromJSON.getAdditionalReferencedDocuments().length, 2);


		} catch (IOException e) {
			exText = e.getMessage();
		} catch (XPathExpressionException e) {
			exText = e.getMessage();
		} catch (ParseException e) {
			exText = e.getMessage();
		}
		assertNull(exText);

	}

	public void testFileSerialization() {

		String base64 = "b25ldHdvdGhyZWU=";
		String json = "{\n" +
			"    \"additionalReferencedDocuments\": [\n" +
			"        {\n" +
			"            \"data\": \"" + base64 + "\",\n" +
			"            \"description\": \"Additional file attachment\",\n" +
			"            \"filename\": \"text.txt\",\n" +
			"            \"mimetype\": \"text/plain\",\n" +
			"            \"relation\": \"Data\"\n" +
			"        }\n" +
			"],\n" +
			"\n" +
			"  \"number\": \"471102\",\n" +
			"  \"currency\": \"EUR\",\n" +
			"  \"issueDate\": \"2018-03-04T00:00:00.000\",\n" +
			"  \"dueDate\": \"2018-03-04T00:00:00.000+01:00\",\n" +
			"  \"deliveryDate\": \"2018-03-04T00:00:00.000+01:00\",\n" +
			"  \"sender\": {\n" +
			"    \"name\": \"Lieferant GmbH\",\n" +
			"    \"zip\": \"80333\",\n" +
			"    \"street\": \"Lieferantenstraße 20\",\n" +
			"    \"location\": \"München\",\n" +
			"    \"country\": \"DE\",\n" +
			"    \"taxID\": \"201/113/40209\",\n" +
			"    \"vatID\": \"DE123456789\",\n" +
			"    \"globalID\": \"4000001123452\",\n" +
			"    \"globalIDScheme\": \"0088\"\n" +
			"  },\n" +
			"  \"recipient\": {\n" +
			"    \"name\": \"Kunden AG Mitte\",\n" +
			"    \"zip\": \"69876\",\n" +
			"    \"street\": \"Kundenstraße 15\",\n" +
			"    \"location\": \"Frankfurt\",\n" +
			"    \"country\": \"DE\"\n" +
			"  },\n" +
			"  \"zfitems\": [\n" +
			"    {\n" +
			"      \"price\": 9.9,\n" +
			"      \"quantity\": 20,\n" +
			"      \"product\": {\n" +
			"        \"unit\": \"H87\",\n" +
			"        \"name\": \"Trennblätter A4\",\n" +
			"        \"description\": \"\",\n" +
			"        \"vatpercent\": 19,\n" +
			"        \"taxCategoryCode\": \"S\"\n" +
			"      }\n" +
			"    },\n" +
			"    {\n" +
			"      \"price\": 5.5,\n" +
			"      \"quantity\": 50,\n" +
			"      \"product\": {\n" +
			"        \"unit\": \"H87\",\n" +
			"        \"name\": \"Joghurt Banane\",\n" +
			"        \"description\": \"\",\n" +
			"        \"vatpercent\": 7,\n" +
			"        \"taxCategoryCode\": \"S\"\n" +
			"      }\n" +
			"    }\n" +
			"  ]\n" +
			"}\n";

		ObjectMapper mapper = new ObjectMapper();

		try {
			Invoice newInvoiceFromJSON = mapper.readValue(json, Invoice.class);
			ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
			zf2p.setProfile(Profiles.getByName("XRechnung"));
			zf2p.generateXML(newInvoiceFromJSON);
			String theXML = new String(zf2p.getXML());
			assertTrue(theXML.contains("<udt:DateTimeString format=\"102\">20180304</udt:DateTimeString>"));
			assertTrue(theXML.contains(base64));

		} catch (Exception e) {
			fail("No exception expected");
		}

	}


	public void testFull300Roundtrip() {
		File inputCII = getResourceAsFile("not_validating_full_invoice_based_onTest_EeISI_300_CENfullmodel.cii.xml");

		Invoice i = new Invoice();
		String exText = null;
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		try {
			zii.fromXML(new String(Files.readAllBytes(inputCII.toPath()), StandardCharsets.UTF_8));
			ObjectMapper mapper = new ObjectMapper();
			zii.extractInto(i);
			String json = mapper.writeValueAsString(i);
			Invoice newInvoiceFromJSON = mapper.readValue(json, Invoice.class);

			assertEquals("Test_EeISI_100", i.getNumber());
			assertEquals(newInvoiceFromJSON.getNumber(), i.getNumber());

		} catch (IOException e) {
			exText = e.getMessage();
		} catch (XPathExpressionException e) {
			exText = e.getMessage();
		} catch (ParseException e) {
			exText = e.getMessage();
		}
		assertNull(exText);


	}
	public void testNulledAttachments() {

		String json="{\n" +
			"  \"number\": \"471102\",\n" +
			"  \"currency\": \"EUR\",\n" +
			"  \"issueDate\": \"2018-03-04T00:00:00.000+01:00\",\n" +
			"  \"dueDate\": \"2018-03-04T00:00:00.000+01:00\",\n" +
			"  \"deliveryDate\": \"2018-03-04T00:00:00.000+01:00\",\n" +
			"  \"sender\": {\n" +
			"    \"name\": \"Lieferant GmbH\",\n" +
			"    \"zip\": \"80333\",\n" +
			"    \"street\": \"Lieferantenstraße 20\",\n" +
			"    \"location\": \"München\",\n" +
			"    \"country\": \"DE\",\n" +
			"    \"taxID\": \"201/113/40209\",\n" +
			"    \"vatID\": \"DE123456789\",\n" +
			"    \"globalID\": \"4000001123452\",\n" +
			"    \"globalIDScheme\": \"0088\"\n" +
			"  },\n" +
			"  \"recipient\": {\n" +
			"    \"name\": \"Kunden AG Mitte\",\n" +
			"    \"zip\": \"69876\",\n" +
			"    \"street\": \"Kundenstraße 15\",\n" +
			"    \"location\": \"Frankfurt\",\n" +
			"    \"country\": \"DE\"\n" +
			"  },\n" +
			"\"additionalReferencedDocuments\":null,"+
			"  \"zfitems\": [\n" +
			"    {\n" +
			"      \"price\": 9.9,\n" +
			"      \"quantity\": 20,\n" +
			"      \"product\": {\n" +
			"        \"unit\": \"H87\",\n" +
			"        \"name\": \"Trennblätter A4\",\n" +
			"        \"description\": \"\",\n" +
			"        \"vatpercent\": 19,\n" +
			"        \"taxCategoryCode\": \"S\"\n" +
			"      }\n" +
			"    },\n" +
			"    {\n" +
			"      \"price\": 5.5,\n" +
			"      \"quantity\": 50,\n" +
			"      \"product\": {\n" +
			"        \"unit\": \"H87\",\n" +
			"        \"name\": \"Joghurt Banane\",\n" +
			"        \"description\": \"\",\n" +
			"        \"vatpercent\": 7,\n" +
			"        \"taxCategoryCode\": \"S\"\n" +
			"      }\n" +
			"    }\n" +
			"  ]\n" +
			"}\n";
		ObjectMapper mapper = new ObjectMapper();
		boolean exceptions=false;
		try {
			Invoice newInvoiceFromJSON = mapper.readValue(json, Invoice.class);
		} catch (JsonProcessingException e) {
			exceptions=true;
		}
		assertFalse(exceptions);
	}

	public void testItemAllowances() {

		String json="{\"number\":\"123\",\"currency\":\"EUR\",\"issueDate\":1738935176399,\"dueDate\":1738935176399,\"sender\":{\"name\":\"Test company\",\"zip\":\"55232\",\"street\":\"teststr\",\"location\":\"teststadt\",\"country\":\"DE\",\"taxID\":\"4711\",\"vatID\":\"DE0815\",\"vatid\":\"DE0815\"},\"recipient\":{\"name\":\"Franz Müller\",\"zip\":\"55232\",\"street\":\"teststr.12\",\"location\":\"Entenhausen\",\"country\":\"DE\",\"contact\":{\"name\":\"contact testname\",\"phone\":\"123456\",\"email\":\"contact.testemail@example.org\",\"fax\":\"0911623562\"}},\"zfitems\":[{\"price\":3.00,\"quantity\":1,\"basisQuantity\":1,\"product\":{\"unit\":\"C62\",\"name\":\"Testprodukt\",\"taxCategoryCode\":\"S\",\"vatpercent\":19,\"reverseCharge\":false,\"intraCommunitySupply\":false},\"itemAllowances\":[{\"totalAmount\":0.1,\"categoryCode\":\"S\"}],\"value\":3.00},{\"price\":3.00,\"quantity\":1,\"basisQuantity\":1,\"product\":{\"unit\":\"C62\",\"name\":\"Testprodukt\",\"taxCategoryCode\":\"S\",\"vatpercent\":19,\"reverseCharge\":false,\"intraCommunitySupply\":false},\"itemAllowances\":[{\"percent\":50,\"taxPercent\":0,\"categoryCode\":\"S\"}],\"value\":3.00},{\"price\":3.00,\"quantity\":2,\"basisQuantity\":1,\"product\":{\"unit\":\"C62\",\"name\":\"Testprodukt\",\"taxCategoryCode\":\"S\",\"vatpercent\":19,\"reverseCharge\":false,\"intraCommunitySupply\":false},\"itemCharges\":[{\"totalAmount\":1,\"reason\":\"AnotherReason\",\"reasonCode\":\"ABK\",\"categoryCode\":\"S\"}],\"value\":3.00},{\"price\":3.00,\"quantity\":1,\"basisQuantity\":1,\"product\":{\"unit\":\"C62\",\"name\":\"Testprodukt\",\"taxCategoryCode\":\"S\",\"vatpercent\":19,\"reverseCharge\":false,\"intraCommunitySupply\":false},\"itemAllowances\":[{\"totalAmount\":1,\"categoryCode\":\"S\"}],\"itemCharges\":[{\"totalAmount\":1,\"categoryCode\":\"S\"}],\"value\":3.00}],\"ownStreet\":\"teststr\",\"ownCountry\":\"DE\",\"zfcharges\":[{\"totalAmount\":1,\"taxPercent\":19,\"reason\":\"AReason\",\"reasonCode\":\"ABK\",\"categoryCode\":\"S\"}],\"ownLocation\":\"teststadt\",\"ownTaxID\":\"4711\",\"ownZIP\":\"55232\",\"ownVATID\":\"DE0815\",\"valid\":true}";
		ObjectMapper mapper = new ObjectMapper();
		try {
			Invoice newInvoiceFromJSON = mapper.readValue(json, Invoice.class);
			TransactionCalculator tc=new TransactionCalculator(newInvoiceFromJSON);
			assertEquals(new BigDecimal("18.33"),tc.getGrandTotal());

		} catch (JsonProcessingException e) {
			throw new RuntimeException(e);
		}


	}

	public void testIssuerAssignedIDRoundtrip() {
		String occurrenceFrom = "20201001";
		String occurrenceTo = "20201005";
		String contractID = "376zreurzu0983";

		String orgID = "0009845";
		String orgname = "Test company";
		String number = "123";
		String priceStr = "1.00";
		String taxID = "9990815";

		BigDecimal price = new BigDecimal(priceStr);
		Invoice newInvoiceFromJSON = null;
		boolean hasExceptions = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String json = "";
		try {
			SchemedID gtin = new SchemedID("0160", "2001015001325");
			SchemedID gln = new SchemedID("0088", "4304171000002");
			Invoice i = new Invoice().setCurrency("CHF").addNote("document level 1/2").addNote("document level 2/2").setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSellerOrderReferencedDocumentID("9384").setBuyerOrderReferencedDocumentID("28934")
				.setDetailedDeliveryPeriod(new SimpleDateFormat("yyyyMMdd").parse(occurrenceFrom), new SimpleDateFormat("yyyyMMdd").parse(occurrenceTo))
				.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID(taxID).setEmail("sender@test.org").setID(orgID).addVATID("DE0815"))
				.setDeliveryAddress(new TradeParty("just the other side of the street", "teststr.12a", "55232", "Entenhausen", "DE").addVATID("DE47110"))
				.setContractReferencedDocument(contractID)
				.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").addGlobalID(gln).setEmail("recipient@test.org").addVATID("DE4711")
					.setContact(new Contact("Franz Müller", "01779999999", "franz@mueller.de", "teststr. 12", "55232", "Entenhausen", "DE").setFax("++49555123456")).setAdditionalAddress("Hinterhaus 3"))
				.addItem(new Item(new Product("Testprodukt", "", "H87", new BigDecimal(16)).addGlobalID(gtin).setSellerAssignedID("4711"), price, new BigDecimal(1.0)).setId("a123").addReferencedLineID("xxx").addNote("item level 1/1").addAllowance(new Allowance(new BigDecimal(0.02)).setReason("item discount").setTaxPercent(new BigDecimal(16))).setDetailedDeliveryPeriod(sdf.parse("2020-01-13"), sdf.parse("2020-01-15")))
				.addCharge(new Charge(new BigDecimal(0.5)).setReason("quick delivery charge").setTaxPercent(new BigDecimal(16)))
				.addAllowance(new Allowance(new BigDecimal(0.2)).setReason("discount").setTaxPercent(new BigDecimal(16)))
				.addCashDiscount(new CashDiscount(new BigDecimal(2), 14))
				.setDeliveryDate(sdf.parse("2020-11-02")).setNumber(number).setVATDueDateTypeCode(EventTimeCodeTypeConstants.PAYMENT_DATE);
			ObjectMapper mapper = new ObjectMapper();
			json = mapper.writeValueAsString(i);
			newInvoiceFromJSON = mapper.readValue(json, Invoice.class);
		} catch (ParseException e) {
			hasExceptions = true;
		} catch (JsonProcessingException e) {
			hasExceptions = true;
		}
		assertEquals(newInvoiceFromJSON.getBuyerOrderReferencedDocumentID(), "28934");
		assertFalse(hasExceptions);
	}

	public void testFromJSON() throws JsonProcessingException {
		String globalID = "4000001123452";
		String globalIDScheme = "0088";
		String itemDeliveryFrom="2022-01-28T23:00:00.000+00:00";
		String itemDeliveryTo="2022-01-30T23:00:00.000+00:00";

		String json="{\"number\":\"123\",\"buyerOrderReferencedDocumentID\":\"28934\",\"currency\":\"CHF\",\"issueDate\":1752744199178,\"dueDate\":1752744199178,\"deliveryDate\":1604271600000,\"sender\":{\"name\":\"Test company\",\"zip\":\"55232\",\"street\":\"teststr\",\"location\":\"teststadt\",\"country\":\"DE\",\"taxID\":\"9990815\",\"vatID\":\"DE0815\",\"id\":\"0009845\",\"globalID\":\""+globalID+"\",\"globalIDScheme\":\""+globalIDScheme+"\",\"email\":\"sender@test.org\",\"vatid\":\"DE0815\"},\"recipient\":{\"name\":\"Franz Müller\",\"zip\":\"55232\",\"street\":\"teststr.12\",\"location\":\"Entenhausen\",\"country\":\"DE\",\"vatID\":\"DE4711\",\"additionalAddress\":\"Hinterhaus 3\",\"contact\":{\"name\":\"Franz Müller\",\"phone\":\"01779999999\",\"email\":\"franz@mueller.de\",\"zip\":\"55232\",\"street\":\"teststr. 12\",\"location\":\"Entenhausen\",\"country\":\"DE\",\"fax\":\"++49555123456\"},\"globalID\":\"4304171000002\",\"globalIDScheme\":\"0088\",\"email\":\"recipient@test.org\",\"vatid\":\"DE4711\"},\"deliveryAddress\":{\"name\":\"just the other side of the street\",\"zip\":\"55232\",\"street\":\"teststr.12a\",\"location\":\"Entenhausen\",\"country\":\"DE\",\"vatID\":\"DE47110\",\"vatid\":\"DE47110\"},\"cashDiscounts\":[{\"percent\":2,\"days\":14}],\"notes\":[\"document level 1/2\",\"document level 2/2\"],\"sellerOrderReferencedDocumentID\":\"9384\",\"contractReferencedDocument\":\"376zreurzu0983\",\"valid\":true,\"vatdueDateTypeCode\":\"72\",\"zfitems\":[{\"price\":1.00,\"quantity\":1,\"basisQuantity\":1,\"detailedDeliveryPeriodFrom\":\""+itemDeliveryFrom+"\",\"detailedDeliveryPeriodTo\":\""+itemDeliveryTo+"\",\"id\":\"a123\",\"buyerOrderReferencedDocumentLineID\":\"xxx\",\"product\":{\"unit\":\"H87\",\"name\":\"Testprodukt\",\"sellerAssignedID\":\"4711\",\"taxCategoryCode\":\"S\",\"globalID\":\"2001015001325\",\"globalIDScheme\":\"0160\",\"intraCommunitySupply\":false,\"reverseCharge\":false,\"vatpercent\":16},\"notes\":[\"item level 1/1\"],\"notesWithSubjectCode\":[{\"content\":\"item level 1/1\"}],\"itemAllowances\":[{\"totalAmount\":0.0200000000000000004163336342344337026588618755340576171875,\"taxPercent\":16,\"reason\":\"item discount\",\"categoryCode\":\"S\"}],\"value\":1.00}],\"ownVATID\":\"DE0815\",\"detailedDeliveryPeriodFrom\":1601503200000,\"detailedDeliveryPeriodTo\":1601848800000,\"ownTaxID\":\"9990815\",\"ownZIP\":\"55232\",\"ownLocation\":\"teststadt\",\"zfallowances\":[{\"totalAmount\":0.200000000000000011102230246251565404236316680908203125,\"taxPercent\":16,\"reason\":\"discount\",\"categoryCode\":\"S\"}],\"ownStreet\":\"teststr\",\"zfcharges\":[{\"totalAmount\":0.5,\"taxPercent\":16,\"reason\":\"quick delivery charge\",\"categoryCode\":\"S\"}],\"ownCountry\":\"DE\"}";

		ObjectMapper mapper = new ObjectMapper();
		Invoice fromJSON = mapper.readValue(json, Invoice.class);
		assertEquals(globalID, fromJSON.getSender().getGlobalID());
		assertEquals(globalIDScheme, fromJSON.getSender().getGlobalIDScheme());
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		assertEquals("2022-01-28", sdf.format(fromJSON.getZFItems()[0].getDetailedDeliveryPeriodFrom()));
		assertEquals("2022-01-30", sdf.format(fromJSON.getZFItems()[0].getDetailedDeliveryPeriodTo()));
		assertEquals("sender@test.org", fromJSON.getSender().getEmail());
	}

	public void testItemAbsoluteChargeFromJSON() throws JsonProcessingException {
		String globalID = "4000001123452";
		String globalIDScheme = "0088";

		String json="{\"number\":\"471102\",\"currency\":\"EUR\",\"issueDate\":\"2018-03-04T00:00:00.000+01:00\",\"dueDate\":\"2018-03-04T00:00:00.000+01:00\",\"deliveryDate\":\"2018-03-04T00:00:00.000+01:00\",\"sender\":{\"name\":\"Lieferant GmbH\",\"zip\":\"80333\",\"street\":\"Lieferantenstraße 20\",\"location\":\"München\",\"country\":\"DE\",\"taxID\":\"201/113/40209\",\"vatID\":\"DE123456789\",\"globalID\":\"4000001123452\",\"globalIDScheme\":\"0088\"},\"recipient\":{\"name\":\"Kunden AG Mitte\",\"zip\":\"69876\",\"street\":\"Kundenstraße 15\",\"location\":\"Frankfurt\",\"country\":\"DE\"},\"zfitems\":[{\"price\":9.9,\"quantity\":20,\"product\":{\"unit\":\"H87\",\"name\":\"Trennblätter A4\",\"description\":\"\",\"vatpercent\":19,\"taxCategoryCode\":\"S\"},\"itemCharges\":[{\"totalAmount\":1,\"taxPercent\":19,\"reason\":\"Invoice line charge reason\",\"categoryCode\":\"S\"}]},{\"price\":5.5,\"quantity\":50,\"product\":{\"unit\":\"H87\",\"name\":\"Joghurt Banane\",\"description\":\"\",\"vatpercent\":7,\"taxCategoryCode\":\"S\"}}]}";

		ObjectMapper mapper = new ObjectMapper();
		Invoice fromJSON = mapper.readValue(json, Invoice.class);
		assertEquals(globalID, fromJSON.getSender().getGlobalID());
		assertEquals(globalIDScheme, fromJSON.getSender().getGlobalIDScheme());
		TransactionCalculator tc=new TransactionCalculator(fromJSON);
		assertEquals(new BigDecimal("531.06"), tc.getDuePayable());
	}

	public void testGrossFromJSON() throws JsonProcessingException {

		String json="{  \"documentCode\": \"380\",  \"number\": \"123\",  \"currency\": \"EUR\",  \"paymentTermDescription\": \"Please remit until 28.07.2025\",  \"issueDate\": 1753653600000,  \"dueDate\": 1753653600000,  \"sender\": {    \"name\": \"Test company\",    \"zip\": \"55232\",    \"street\": \"teststr\",    \"location\": \"teststadt\",    \"country\": \"DE\",    \"taxID\": \"4711\",    \"vatID\": \"DE0815\",    \"vatid\": \"DE0815\"  },  \"recipient\": {    \"name\": \"Franz Müller\",    \"zip\": \"55232\",    \"street\": \"teststr.12\",    \"location\": \"Entenhausen\",    \"country\": \"DE\",    \"contact\": {      \"name\": \"contact testname\",      \"phone\": \"123456\",      \"email\": \"contact.testemail@example.org\",      \"fax\": \"0911623562\"    }  },  \"totalPrepaidAmount\": 0.00,  \"lineTotalAmount\": 29.00,  \"duePayable\": 34.51,  \"grandTotal\": 34.51,  \"taxBasis\": 29.00,  \"valid\": true,  \"zfitems\": [    {      \"price\": 3.0000,      \"quantity\": 10.0000,      \"basisQuantity\": 1.0000,      \"id\": \"1\",      \"product\": {        \"unit\": \"H87\",        \"name\": \"Testprodukt\",        \"taxCategoryCode\": \"S\",        \"allowances\": [          {            \"totalAmount\": 0.1000,            \"categoryCode\": \"S\"          }        ],        \"vatpercent\": 19.00,        \"intraCommunitySupply\": false,        \"reverseCharge\": false      },      \"value\": 3.0000    }  ],  \"ownVATID\": \"DE0815\",  \"ownTaxID\": \"4711\",  \"ownLocation\": \"teststadt\",  \"ownZIP\": \"55232\",  \"ownCountry\": \"DE\",  \"ownStreet\": \"teststr\"}";

		ObjectMapper mapper = new ObjectMapper();
		CalculatedInvoice fromJSON = mapper.readValue(json, CalculatedInvoice.class);
		fromJSON.calculate();
		assertEquals(new BigDecimal("34.51"),fromJSON.getDuePayable());
	}

	public void testDueDateRoundtrip() throws JsonProcessingException {

		ObjectMapper mapper = new ObjectMapper();

		// [{"stringValue":"a","intValue":1,"booleanValue":true},
		// {"stringValue":"bc","intValue":3,"booleanValue":false}]

		Invoice fromJSON = mapper.readValue("{\n" +
			"    \"number\": \"RE - 228\",\n" +
			"    \"currency\": \"EUR\",\n" +
			"    \"issueDate\": \"2024-10-24\",\n" +
			"    \"dueDate\": \"2024-10-26\",\n" +
			"    \"deliveryDate\": \"2024-10-25\",\n" +
			"    \"sender\": {\n" +
			"        \"name\": \"Amazing Company\",\n" +
			"        \"zip\": \"10000\",\n" +
			"        \"street\": \"Straße der Kosmonauten 20\",\n" +
			"        \"location\": \"Berlin\",\n" +
			"        \"country\": \"DE\",\n" +
			"        \"taxID\": \"201/113/40209\",\n" +
			"        \"vatID\": \"DE123456789\",\n" +
			"        \"globalID\": \"4000001123452\",\n" +
			"        \"globalIDScheme\": \"0088\"\n" +
			"    },\n" +
			"    \"recipient\": {\n" +
			"        \"name\": \"Amazing Company\",\n" +
			"        \"zip\": \"1000\",\n" +
			"        \"street\": \"Straße der Kosmonauten 10\",\n" +
			"        \"location\": \"Berlin\",\n" +
			"        \"taxID\": \"201/113/40209\",\n" +
			"        \"vatID\": \"DE123456789\",\n" +
			"        \"country\": \"DE\"\n" +
			"    },\n" +
			"    \"zfitems\": [\n" +
			"        {\n" +
			"            \"price\": 99.9,\n" +
			"            \"quantity\": 10,\n" +
			"            \"product\": {\n" +
			"                \"unit\": \"H87\",\n" +
			"                \"name\": \"Amazing Archives\",\n" +
			"                \"description\": \"123\",\n" +
			"                \"vatpercent\": \"19\",\n" +
			"                \"taxCategoryCode\": \"3\"\n" +
			"            }\n" +
			"        }\n" +
			"    ]\n" +
			"}\n", Invoice.class);
		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(fromJSON);
		String theXML = new String(zf2p.getXML());
		assertTrue(theXML.contains("<udt:DateTimeString format=\"102\">20241026</udt:DateTimeString>"));

	}


	public void testDirectDebit() throws JsonProcessingException {

		ObjectMapper mapper = new ObjectMapper();

		// [{"stringValue":"a","intValue":1,"booleanValue":true},
		// {"stringValue":"bc","intValue":3,"booleanValue":false}]

		boolean exceptions = false;
		String theXML = "";
		try {
			Invoice fromJSON = mapper.readValue("\n" +
				"\t{\n" +
				"\t\t\"documentCode\": \"380\",\n" +
				"\t\t\"number\": \"F20220031\",\n" +
				"\t\t\"referenceNumber\": \"SERVEXEC\",\n" +
				"\t\t\"buyerOrderReferencedDocumentID\": \"PO201925478\",\n" +
				"\t\t\"ownOrganisationName\": \"LE FOURNISSEUR\",\n" +
				"\t\t\"currency\": \"EUR\",\n" +
				"\t\t\"issueDate\": \"2022-01-30T23:00:00.000+00:00\",\n" +
				"\t\t\"dueDate\": \"2022-03-01T23:00:00.000+00:00\",\n" +
				"\t\t\"deliveryDate\": \"2022-01-27T23:00:00.000+00:00\",\n" +
				"\t\t\"sender\": {\n" +
				"\t\t\"name\": \"LE FOURNISSEUR\",\n" +
				"\t\t\t\"zip\": \"75018\",\n" +
				"\t\t\t\"street\": \"35 rue d'ici\",\n" +
				"\t\t\t\"location\": \"PARIS\",\n" +
				"\t\t\t\"country\": \"FR\",\n" +
				"\t\t\t\"vatID\": \"FR11123456782\",\n" +
				"\t\t\t\"additionalAddress\": \"Seller line 2\",\n" +
				"\t\t\t\"additionalAddressExtension\": \"Seller line 3\",\n" +
				"\t\t\t\"bankDetails\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"accountName\": null,\n" +
				"\t\t\t\"iban\": \"FR20 1254 2547 2569 8542 5874 698\",\n" +
				"\t\t\t\"bic\": \"BIC_MONCOMPTE\"\n" +
				"\t\t}\n" +
				"    ],\n" +
				"\t\t\"debitDetails\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"mandate\": \"MANDATE PT\",\n" +
				"\t\t\t\"iban\": \"FR20 1254 2547 2569 8542 5874 698\"\n" +
				"\t\t}\n" +
				"    ],\n" +
				"\t\t\"contact\": {\n" +
				"\t\t\t\"name\": \"M. CONTACT\",\n" +
				"\t\t\t\t\"phone\": \"01 02 03 54 87\",\n" +
				"\t\t\t\t\"email\": \"seller@seller.com\",\n" +
				"\t\t\t\t\"zip\": null,\n" +
				"\t\t\t\t\"street\": null,\n" +
				"\t\t\t\t\"location\": null,\n" +
				"\t\t\t\t\"country\": null,\n" +
				"\t\t\t\t\"fax\": null,\n" +
				"\t\t\t\t\"vatid\": null,\n" +
				"\t\t\t\t\"id\": null,\n" +
				"\t\t\t\t\"additionalAddress\": null\n" +
				"\t\t},\n" +
				"\t\t\"email\": \"moi@seller.com\",\n" +
				"\t\t\t\"vatid\": \"FR11123456782\",\n" +
				"\t\t\t\"id\": \"123\",\n" +
				"\t\t\t\"legalOrganisation\": {\n" +
				"\t\t\t\"schemedID\": null,\n" +
				"\t\t\t\t\"tradingBusinessName\": \"SELLER TRADE NAME\"\n" +
				"\t\t},\n" +
				"\t\t\"globalID\": \"587451236587\",\n" +
				"\t\t\t\"globalIDScheme\": \"0088\"\n" +
				"\t},\n" +
				"\t\t\"recipient\": {\n" +
				"\t\t\"name\": \"LE CLIENT\",\n" +
				"\t\t\t\"zip\": \"06000\",\n" +
				"\t\t\t\"street\": \"MON ADRESSE LIGNE 1\",\n" +
				"\t\t\t\"location\": \"MA VILLE\",\n" +
				"\t\t\t\"country\": \"FR\",\n" +
				"\t\t\t\"vatID\": \"FR 05 987 654 321\",\n" +
				"\t\t\t\"additionalAddress\": \"Buyer line 2\",\n" +
				"\t\t\t\"additionalAddressExtension\": \"Buyer line 3\",\n" +
				"\t\t\t\"contact\": {\n" +
				"\t\t\t\"name\": \"Buyer contact name\",\n" +
				"\t\t\t\t\"phone\": \"01 01 25 45 87\",\n" +
				"\t\t\t\t\"email\": \"buyer@buyer.com\",\n" +
				"\t\t\t\t\"zip\": null,\n" +
				"\t\t\t\t\"street\": null,\n" +
				"\t\t\t\t\"location\": null,\n" +
				"\t\t\t\t\"country\": null,\n" +
				"\t\t\t\t\"fax\": null,\n" +
				"\t\t\t\t\"vatid\": null,\n" +
				"\t\t\t\t\"id\": null,\n" +
				"\t\t\t\t\"additionalAddress\": null\n" +
				"\t\t},\n" +
				"\t\t\"email\": \"me@buyer.com\",\n" +
				"\t\t\t\"vatid\": \"FR 05 987 654 321\",\n" +
				"\t\t\t\"legalOrganisation\": {\n" +
				"\t\t\t\"schemedID\": null,\n" +
				"\t\t\t\t\"tradingBusinessName\": null\n" +
				"\t\t},\n" +
				"\t\t\"globalID\": \"3654789851\",\n" +
				"\t\t\t\"globalIDScheme\": \"0088\"\n" +
				"\t},\n" +
				"\t\t\"deliveryAddress\": {\n" +
				"\t\t\"name\": \"DEL Name\",\n" +
				"\t\t\t\"zip\": \"06000\",\n" +
				"\t\t\t\"street\": \"DEL ADRESSE LIGNE 1\",\n" +
				"\t\t\t\"location\": \"NICE\",\n" +
				"\t\t\t\"country\": \"FR\",\n" +
				"\t\t\t\"additionalAddress\": \"DEL line 2\",\n" +
				"\t\t\t\"id\": \"PRIVATE_ID_DEL\"\n" +
				"\t},\n" +
				"\t\t\"payee\": {\n" +
				"\t\t\"name\": \"PAYEE NAME\",\n" +
				"\t\t\t\"legalOrganisation\": {\n" +
				"\t\t\t\"schemedID\": null,\n" +
				"\t\t\t\t\"tradingBusinessName\": null\n" +
				"\t\t},\n" +
				"\t\t\"globalID\": \"587451236586\",\n" +
				"\t\t\t\"globalIDScheme\": \"0088\"\n" +
				"\t},\n" +
				"\t\t\"sellerOrderReferencedDocumentID\": \"SALES REF 2547\",\n" +
				"\t\t\"despatchAdviceReferencedDocumentID\": \"DESPADV002\",\n" +
				"\t\t\"grandTotal\": 107.82,\n" +
				"\t\t\"detailedDeliveryPeriodFrom\": \"2021-12-31T23:00:00.000+00:00\",\n" +
				"\t\t\"detailedDeliveryPeriodTo\": \"2022-12-30T23:00:00.000+00:00\",\n" +
				"\t\t\"notesWithSubjectCode\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"content\": \"FOURNISSEUR F SARL au capital de 50 000 EUR\",\n" +
				"\t\t\t\"subjectCode\": \"REG\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"content\": \"RCS MAVILLE 123 456 782\",\n" +
				"\t\t\t\"subjectCode\": \"ABL\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"content\": \"35 ma rue a moi, code postal Ville Pays – contact@masociete.fr - www.masociete.fr  – N° TVA : FR32 123 456 789\",\n" +
				"\t\t\t\"subjectCode\": \"AAI\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"content\": \"Tout retard de paiement engendre une pénalité exigible à compter de la date d'échéance, calculée sur la base de trois fois le taux d'intérêt légal.\",\n" +
				"\t\t\t\"subjectCode\": null\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"content\": \"Indemnité forfaitaire pour frais de recouvrement en cas de retard de paiement : 40 €.\",\n" +
				"\t\t\t\"subjectCode\": null\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"content\": \"Les réglements reçus avant la date d'échéance ne donneront pas lieu à escompte.\",\n" +
				"\t\t\t\"subjectCode\": null\n" +
				"\t\t}\n" +
				"  ],\n" +
				"\t\t\"zfallowances\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"REMISE VOLUME\",\n" +
				"\t\t\t\"reasonCode\": \"71\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"REMISE VOLUME\",\n" +
				"\t\t\t\"reasonCode\": \"71\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"REMISE VOLUME\",\n" +
				"\t\t\t\"reasonCode\": \"71\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": null,\n" +
				"\t\t\t\"reasonCode\": \"100\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 2,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"REMISE VOLUME\",\n" +
				"\t\t\t\"reasonCode\": \"71\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"REMISE VOLUME\",\n" +
				"\t\t\t\"reasonCode\": \"71\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"REMISE VOLUME\",\n" +
				"\t\t\t\"reasonCode\": \"71\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": null,\n" +
				"\t\t\t\"reasonCode\": \"100\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1.4,\n" +
				"\t\t\t\"taxPercent\": 20,\n" +
				"\t\t\t\"reason\": \"REMISE COMMERCIALE\",\n" +
				"\t\t\t\"reasonCode\": \"100\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1.2,\n" +
				"\t\t\t\"taxPercent\": 10,\n" +
				"\t\t\t\"reason\": \"REMISE COMMERCIALE\",\n" +
				"\t\t\t\"reasonCode\": \"100\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t}\n" +
				"  ],\n" +
				"\t\t\"zfcharges\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"FRAIS PALETTE\",\n" +
				"\t\t\t\"reasonCode\": null,\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"FRAIS PALETTE\",\n" +
				"\t\t\t\"reasonCode\": null,\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"FRAIS PALETTE\",\n" +
				"\t\t\t\"reasonCode\": null,\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"FRAIS PALETTE\",\n" +
				"\t\t\t\"reasonCode\": null,\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": null,\n" +
				"\t\t\t\"reasonCode\": \"ADL\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"FRAIS PALETTE\",\n" +
				"\t\t\t\"reasonCode\": null,\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 1,\n" +
				"\t\t\t\"taxPercent\": null,\n" +
				"\t\t\t\"reason\": \"FRAIS PALETTE\",\n" +
				"\t\t\t\"reasonCode\": null,\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 2.8,\n" +
				"\t\t\t\"taxPercent\": 20,\n" +
				"\t\t\t\"reason\": \"FRAIS DEPLACEMENT\",\n" +
				"\t\t\t\"reasonCode\": \"FC\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"percent\": null,\n" +
				"\t\t\t\"totalAmount\": 0.6,\n" +
				"\t\t\t\"taxPercent\": 10,\n" +
				"\t\t\t\"reason\": \"FRAIS DEPLACEMENT\",\n" +
				"\t\t\t\"reasonCode\": \"ADR\",\n" +
				"\t\t\t\"categoryCode\": \"S\"\n" +
				"\t\t}\n" +
				"  ],\n" +
				"\t\t\"tradeSettlement\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"accountName\": null,\n" +
				"\t\t\t\"iban\": \"FR20 1254 2547 2569 8542 5874 698\",\n" +
				"\t\t\t\"bic\": \"BIC_MONCOMPTE\"\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"mandate\": \"MANDATE PT\",\n" +
				"\t\t\t\"iban\": \"FR20 1254 2547 2569 8542 5874 698\"\n" +
				"\t\t}\n" +
				"  ],\n" +
				"\t\t\"zfitems\": [\n" +
				"\t\t{\n" +
				"\t\t\t\"price\": 60,\n" +
				"\t\t\t\"quantity\": 1,\n" +
				"\t\t\t\"basisQuantity\": 1,\n" +
				"\t\t\t\"product\": {\n" +
				"\t\t\t\"unit\": \"C62\",\n" +
				"\t\t\t\t\"name\": \"REMBOURSEMENT AFFRANCHISSEMENT\",\n" +
				"\t\t\t\t\"description\": \"Description\",\n" +
				"\t\t\t\t\"taxCategoryCode\": \"Z\",\n" +
				"\t\t\t\t\"vatpercent\": 0,\n" +
				"\t\t\t\t\"reverseCharge\": false,\n" +
				"\t\t\t\t\"intraCommunitySupply\": false,\n" +
				"\t\t\t\t\"globalID\": \"598785412598745\",\n" +
				"\t\t\t\t\"globalIDScheme\": \"0160\"\n" +
				"\t\t},\n" +
				"\t\t\t\"buyerOrderReferencedDocumentLineID\": \"1\",\n" +
				"\t\t\t\"value\": 60\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"price\": 30,\n" +
				"\t\t\t\"quantity\": 3,\n" +
				"\t\t\t\"basisQuantity\": 3,\n" +
				"\t\t\t\"product\": {\n" +
				"\t\t\t\"unit\": \"C62\",\n" +
				"\t\t\t\t\"name\": \"FOURNITURES DIVERSES\",\n" +
				"\t\t\t\t\"description\": \"Description\",\n" +
				"\t\t\t\t\"taxCategoryCode\": \"S\",\n" +
				"\t\t\t\t\"vatpercent\": 20,\n" +
				"\t\t\t\t\"reverseCharge\": false,\n" +
				"\t\t\t\t\"intraCommunitySupply\": false\n" +
				"\t\t},\n" +
				"\t\t\t\"buyerOrderReferencedDocumentLineID\": \"3\",\n" +
				"\t\t\t\"value\": 30\n" +
				"\t\t},\n" +
				"\t\t{\n" +
				"\t\t\t\"price\": 12,\n" +
				"\t\t\t\"quantity\": 1,\n" +
				"\t\t\t\"basisQuantity\": 1,\n" +
				"\t\t\t\"product\": {\n" +
				"\t\t\t\"unit\": \"C62\",\n" +
				"\t\t\t\t\"name\": \"APPEL\",\n" +
				"\t\t\t\t\"description\": \"Description\",\n" +
				"\t\t\t\t\"taxCategoryCode\": \"S\",\n" +
				"\t\t\t\t\"vatpercent\": 10,\n" +
				"\t\t\t\t\"reverseCharge\": false,\n" +
				"\t\t\t\t\"intraCommunitySupply\": false\n" +
				"\t\t},\n" +
				"\t\t\t\"buyerOrderReferencedDocumentLineID\": \"2\",\n" +
				"\t\t\t\"value\": 12\n" +
				"\t\t}\n" +
				"  ],\n" +
				"\t\t\"ownStreet\": \"35 rue d'ici\",\n" +
				"\t\t\"ownCountry\": \"FR\",\n" +
				"\t\t\"ownZIP\": \"75018\",\n" +
				"\t\t\"ownLocation\": \"PARIS\",\n" +
				"\t\t\"ownVATID\": \"FR11123456782\",\n" +
				"\t\t\"valid\": false\n" +
				"\t}\n", Invoice.class);
			ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
			zf2p.setProfile(Profiles.getByName("XRechnung"));
			zf2p.generateXML(fromJSON);
			theXML = new String(zf2p.getXML());
		} catch (Exception e) {
			exceptions = true;
		}
		assertTrue(theXML.contains("pour frais de recouvrement en cas de retard de paiement"));
		assertFalse(exceptions);

	}


}
