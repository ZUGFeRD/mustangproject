
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
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.junit.FixMethodOrder;
import org.junit.jupiter.api.Assertions;
import org.junit.runners.MethodSorters;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import static org.xmlunit.assertj.XmlAssert.assertThat;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class XRTest extends TestCase {
	final String TARGET_XML = "./target/testout-XR.xml";
	final String TARGET_EDGE_XML = "./target/testout-XR-Edge.xml";

	public void testXRExport() {

		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		recipient.setEmail("quack@ducktown.org");
		Invoice i = createInvoice(recipient);
		String legalOrgID = "aCustomSellerLegalOrgId";
		String sellerID = "aSellerTradePartyID";
		i.getSender().setLegalOrganisation(new LegalOrganisation(legalOrgID));
		i.getSender().setID(sellerID);
		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);
		String theXML = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
		assertTrue(theXML.contains("<ram:ID>" + sellerID + "</ram:ID>"));// must be possible without scheme #
		assertTrue(theXML.contains("<ram:ID>" + legalOrgID + "</ram:ID>"));// must be possible without scheme #
		assertThat(theXML).valueByXPath("count(//*[local-name()='IncludedSupplyChainTradeLineItem'])")
			.asInt()
			.isEqualTo(1); //2 errors are OK because there is a known bug


		assertThat(theXML).valueByXPath("//*[local-name()='DuePayableAmount']")
			.asDouble()
			.isEqualTo(1);
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(TARGET_XML));
			writer.write(theXML);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}


	public void testXREdgeExport() {

		// the writing part

		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		byte[] b = {12, 13};

		FileAttachment fe1 = new FileAttachment("one.pdf", "application/pdf", "Alternative", b,"Beschreibung");
		Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
			.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").setEmail("sender@example.com").addTaxID("DE4711").addVATID("DE0815").setContact(new Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX").setAccountName("kontoInhaber")))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setEmail("recipient@sample.org"))
			.setDeliveryAddress(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setEmail("recipient@sample.org"))
			.addCashDiscount(new CashDiscount(new BigDecimal(2), 7))
			.addCashDiscount(new CashDiscount(new BigDecimal(3), 14))
			.setReferenceNumber("991-01484-64")//leitweg-id
			// not using any VAT, this is also a test of zero-rated goods:
			.setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO).setTaxExemptionReason("Kleinunternehmer"), amount, new BigDecimal(1.0)))
			.setPayee(new TradeParty().setName("VR Factoring GmbH").setID("DE813838785").setLegalOrganisation(new LegalOrganisation("391200LDDFJDMIPPMZ54", "0199")))
			.embedFileInXML(fe1);


		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();

		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);
		String theXML = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
		assertTrue(theXML.contains("#SKONTO#"));
		assertThat(theXML).valueByXPath("count(//*[local-name()='IncludedSupplyChainTradeLineItem'])")
			.asInt()
			.isEqualTo(1); //2 errors are OK because there is a known bug

		assertThat(theXML).valueByXPath("count(//*[local-name()='PayeeTradeParty'])")
			.asInt()
			.isEqualTo(1);

		assertThat(theXML).valueByXPath("//*[local-name()='DuePayableAmount']")
			.asDouble()
			.isEqualTo(1);
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(TARGET_EDGE_XML));
			writer.write(theXML);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}


		Invoice readInvoice = new Invoice();
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		try {
			zii.setRawXML(zf2p.getXML(), false);
			zii.extractInto(readInvoice);
		} catch (ParseException | XPathExpressionException xp) {
			fail("ParseException not expected");
		} catch (IOException e) {
			fail("IOException not expected");
		}
		FileAttachment[] attachedFiles = readInvoice.getAdditionalReferencedDocuments();
		assertNotNull(attachedFiles);
		assertEquals(attachedFiles.length, 1);

		assertTrue(Arrays.equals(attachedFiles[0].getData(), b));
		assertEquals("Beschreibung",attachedFiles[0].getDescription());

	}

	public void testIssue830ApplicableHeaderTradeSettlementTax() throws XPathExpressionException, SAXException, IOException, ParserConfigurationException
	{
		final Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
			.setSender(new TradeParty("Test", "teststr", "55232", "teststadt", "DE").setEmail("sender@example.com").addTaxID("DE4711").addVATID("DE0815")
				.setContact(new Contact("Hans Test", "+49123456789", "test@example.org"))
				.addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX").setAccountName("kontoInhaber")))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setEmail("recipient@sample.org"))
			.setReferenceNumber("991-01484-64")
			.setNumber("123")
			.addItem(
				new Item(new Product("Testprodukt1", "", "C62", BigDecimal.ZERO).setTaxCategoryCode("E").setTaxExemptionReason("Product is exempt"), BigDecimal.TEN,
					BigDecimal.ONE))
			.addItem(new Item(new Product("Testprodukt2", "", "C62", BigDecimal.ZERO).setTaxCategoryCode("AE").setTaxExemptionReason("Reversecharge process"),
				BigDecimal.ONE, BigDecimal.ONE))
			.addItem(new Item(new Product("Testprodukt3", "", "C62", BigDecimal.valueOf(19)).setTaxCategoryCode("S"), BigDecimal.valueOf(9), BigDecimal.ONE)
				.addCharge(new Charge(BigDecimal.ONE).setReasonCode("64").setTaxPercent(BigDecimal.valueOf(19))))
			.addItem(new Item(
				new Product("Testprodukt4", "", "C62", BigDecimal.ZERO).setTaxCategoryCode("AE").setTaxExemptionReason("Reversecharge process"),
				BigDecimal.TEN, BigDecimal.ONE)
					.addAllowance(new Allowance().setReasonCode("64").setTotalAmount(BigDecimal.valueOf(4)).setTaxPercent(BigDecimal.ZERO)))
			.setPayee(
				new TradeParty().setName("VR Factoring GmbH").setID("DE813838785").setLegalOrganisation(new LegalOrganisation("391200LDDFJDMIPPMZ54", "0199")))
			.addAllowance(new Allowance().setReasonCode("64").setTotalAmount(BigDecimal.valueOf(5)).setTaxPercent(BigDecimal.valueOf(19)));

		final ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();

		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);

		final Document doc = DocumentBuilderFactory.newInstance()
			.newDocumentBuilder()
			.parse(new ByteArrayInputStream(zf2p.getXML()));

		final XPath xpath = XPathFactory.newInstance().newXPath();
		final NodeList tradeTaxes = (NodeList) xpath
			.compile("//*[local-name()='ApplicableHeaderTradeSettlement']/*[local-name()='ApplicableTradeTax']")
			.evaluate(doc, XPathConstants.NODESET);

		Assertions.assertEquals(3, tradeTaxes.getLength());
		final Node taxNode0 = tradeTaxes.item(0);
		final String categoryCode0 = xpath
			.compile("*[local-name()='CategoryCode']/text()")
			.evaluate(taxNode0);
		Assertions.assertEquals("E", categoryCode0);
		final String basisAmount0 = xpath
			.compile("*[local-name()='BasisAmount']/text()")
			.evaluate(taxNode0);
		Assertions.assertTrue(BigDecimal.TEN.compareTo(new BigDecimal(basisAmount0)) == 0);

		final Node taxNode1 = tradeTaxes.item(1);
		final String categoryCode1 = xpath
			.compile("*[local-name()='CategoryCode']/text()")
			.evaluate(taxNode1);
		Assertions.assertEquals("AE", categoryCode1);
		final String basisAmount1 = xpath
			.compile("*[local-name()='BasisAmount']/text()")
			.evaluate(taxNode1);
		Assertions.assertTrue(BigDecimal.valueOf(7).compareTo(new BigDecimal(basisAmount1)) == 0);

		final Node taxNode2 = tradeTaxes.item(2);
		final String categoryCode2 = xpath
			.compile("*[local-name()='CategoryCode']/text()")
			.evaluate(taxNode2);
		Assertions.assertEquals("S", categoryCode2);
		final String basisAmount2 = xpath
			.compile("*[local-name()='BasisAmount']/text()")
			.evaluate(taxNode2);
		Assertions.assertTrue(BigDecimal.valueOf(5).compareTo(new BigDecimal(basisAmount2)) == 0);
	}
	
	public void testXRExportWithoutStreet() {

		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", null, "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);

		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);
		String theXML = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
		assertThat(theXML).valueByXPath("count(//*[local-name()='IncludedSupplyChainTradeLineItem'])")
			.asInt()
			.isEqualTo(1); //2 errors are OK because there is a known bug


		assertThat(theXML).valueByXPath("//*[local-name()='DuePayableAmount']")
			.asDouble()
			.isEqualTo(1);
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(TARGET_XML));
			writer.write(theXML);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
	
	public void testTaxExemptionReasonIssue() {
		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		byte[] b = {12, 13};

		Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
			.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").setEmail("sender@example.com").addTaxID("DE4711").addVATID("DE0815").setContact(new Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX").setAccountName("kontoInhaber")))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE").setEmail("recipient@sample.org"))
			.setReferenceNumber("991-01484-64")//leitweg-id
			// not using any VAT, this is also a test of zero-rated goods:
			.setNumber(number)
				.addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO).setTaxCategoryCode("E").setTaxExemptionReason("Kleinunternehmer"), amount, new BigDecimal(1.0)))
				.addItem(new Item(new Product("Testprodukt2", "", "C62", BigDecimal.ZERO).setTaxCategoryCode("S"), amount, new BigDecimal(1.0)))
			.setPayee( new TradeParty().setName("VR Factoring GmbH").setID("DE813838785").setLegalOrganisation(new LegalOrganisation("391200LDDFJDMIPPMZ54", "0199")));



		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();

		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);
		String theXML = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		assertThat(theXML).valueByXPath("count(//*[local-name()='ExemptionReason'])")
			.asInt()
			.isEqualTo(2);
	}
	

	public void testApplicablePercentInUntaxedService() {

		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", null, "55232", "Entenhausen", "DE");
		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		var i = new Invoice().setDueDate(new java.util.Date()).setIssueDate(new java.util.Date()).setDeliveryDate(new java.util.Date())
			.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("DE4711").addVATID("DE0815").setEmail("info@example.org").setContact(new org.mustangproject.Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new org.mustangproject.BankDetails("DE12500105170648489890", "COBADEFXXX")))
			.setRecipient(recipient)
			.setReferenceNumber("991-01484-64")//leitweg-id
			// not using any VAT, this is also a test of zero-rated goods:
			.setNumber(number).addItem(new org.mustangproject.Item(new org.mustangproject.Product("Testprodukt", "", "C62", java.math.BigDecimal.ZERO).setTaxCategoryCode(TaxCategoryCodeTypeConstants.UNTAXEDSERVICE).setTaxExemptionReason("Expemtion reason"), amount, new java.math.BigDecimal(1.0)));

		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);
		String theXML = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		// Untaxed services don't have the field RateApplicablePercent, since it would be always 0. An error is thrown on validation, if 0 is set.
		assertThat(theXML).valueByXPath("count(//*[local-name()='RateApplicablePercent'])")
			.asInt()
			.isEqualTo(0);

		//Exemption reason needs to be set if TaxCategoryCode == "O", reason should be at the product and in the ApplicableTradeTax
		assertThat(theXML).valueByXPath("count(//*[local-name()='ExemptionReason'])")
			.asInt()
			.isEqualTo(2);
	}

	private org.mustangproject.Invoice createInvoice(TradeParty recipient) {
		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		return new Invoice().setDueDate(new java.util.Date()).setIssueDate(new java.util.Date()).setDeliveryDate(new java.util.Date())
			.setSender(new TradeParty(orgname, "teststr", "55232", "teststadt", "DE").addTaxID("DE4711").addVATID("DE0815").setEmail("info@example.org").setContact(new org.mustangproject.Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new org.mustangproject.BankDetails("DE12500105170648489890", "COBADEFXXX")))
			.setRecipient(recipient)
			.setReferenceNumber("991-01484-64")//leitweg-id
			// not using any VAT, this is also a test of zero-rated goods:
			.setNumber(number).addItem(new org.mustangproject.Item(new org.mustangproject.Product("Testprodukt", "", "C62", java.math.BigDecimal.ZERO), amount, new java.math.BigDecimal(1.0)));
	}

}
