
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

import junit.framework.Test;
import junit.framework.TestSuite;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.*;

import javax.xml.xpath.XPathExpressionException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class OXTest extends MustangReaderTestCase {
	final String TARGET_PDF = "./target/testout-OX.pdf";
	final String TARGET_PDF_EDGE = "./target/testout-OX-edge.pdf";
	final String TARGET_XML = "./target/testout-OX.xml";

	protected class EdgeProduct implements IZUGFeRDExportableProduct {
		private String description, name, unit;

		public EdgeProduct(String description, String name, String unit) {
			super();
			this.description = description;
			this.name = name;
			this.unit = unit;
		}

		@Override
		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		@Override
		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		@Override
		public String getUnit() {
			return unit;
		}

		public void setUnit(String unit) {
			this.unit = unit;
		}

		@Override
		public BigDecimal getVATPercent() {
			return BigDecimal.ZERO;
		}

		@Override
		public boolean isIntraCommunitySupply() {
			return true; // simulate intra community supply
		}
	}

	protected class DebitPayment implements IZUGFeRDTradeSettlementDebit {

		@Override
		public String getIBAN() {
			return "DE540815";
		}

		@Override
		public String getMandate() {
			return "DE99XX12345";
		}

	}

	@Override
	public IZUGFeRDTradeSettlement[] getTradeSettlement() {
		IZUGFeRDTradeSettlement[] payments = new DebitPayment[1];
		payments[0] = new DebitPayment();
		return payments;
	}

	@Override
	public Date getDeliveryDate() {
		return new GregorianCalendar(2017, Calendar.MAY, 7).getTime();
	}

	@Override
	public Date getDueDate() {
		return new GregorianCalendar(2017, Calendar.MAY, 30).getTime();
	}

	@Override
	public Date getIssueDate() {
		return new GregorianCalendar(2017, Calendar.MAY, 9).getTime();
	}

	@Override
	public String getNumber() {
		return "RE-20170509/505";
	}

	@Override
	public String getOwnCountry() {
		return "DE";
	}

	@Override
	public String getOwnLocation() {
		return "Stadthausen";
	}

	@Override
	public String getOwnOrganisationName() {
		return "Bei Spiel GmbH";
	}

	@Override
	public String getOwnStreet() {
		return "Ecke 12";
	}

	@Override
	public IZUGFeRDExportableTradeParty getSender() {
		return new SenderTradeParty();
	}

	@Override
	public String getOwnTaxID() {
		return "22/815/0815/4";
	}

	@Override
	public String getOwnVATID() {
		return "DE136695976";
	}

	@Override
	public String getOwnZIP() {
		return "12345";
	}

	@Override
	public IZUGFeRDExportableTradeParty getRecipient() {
		return new RecipientTradeParty();
	}

	@Override
	public IZUGFeRDExportableTradeParty getDeliveryAddress() {
		return new RecipientTradeParty();
	}

	@Override
	public String getOwnOrganisationFullPlaintextInfo() {
		return null;
	}

	@Override
	public String getCurrency() {
		return "USD";
	}

	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		Item[] allItems = new Item[3];
		EdgeProduct designProduct = new EdgeProduct("", "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung",
				"HUR");
		EdgeProduct balloonProduct = new EdgeProduct("", "Bestellerweiterung für E&F Umbau", "C62");// test for issue
		// 103
		EdgeProduct airProduct = new EdgeProduct("", "Heiße Luft pro Liter", "LTR");

		Item design = new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
		design.setAddReference("1825");
		allItems[0] = design;
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), new BigDecimal("200"), airProduct);
		return allItems;
	}

	@Override
	public String getPaymentTermDescription() {
		SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");
		return "Zahlbar ohne Abzug bis zum " + germanDateFormat.format(getDueDate());
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		return null;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		return null;
	}

	@Override
	public String getReferenceNumber() {
		return "AB321";
	}

	/**
	 * Create the test case
	 *
	 * @param testName name of the test case
	 */
	public OXTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(OXTest.class);
	}

	// //////// TESTS
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	public void testOXExport() {

		// the writing part

		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 OXExporterFromA1 oe = new OXExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(1).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {
			oe.setTransaction(this);
			String theXML = new String(oe.getProvider().getXML(), StandardCharsets.UTF_8);
			assertTrue(theXML.contains("<rsm:SCRDMCCBDACIOMessageStructure"));
			Files.write(Paths.get(TARGET_XML), theXML.getBytes(StandardCharsets.UTF_8));
			oe.export(TARGET_PDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

		assertTrue(zi.getUTF8().contains("<ram:TypeCode>220</ram:TypeCode>"));
		assertTrue(zi.getUTF8().contains("<ram:ShipToTradeParty>"));
		assertFalse(zi.getUTF8().contains("EUR"));
		assertTrue(zi.getUTF8().contains("USD"));//currency should be USD, test for #150

		// Now also check the "invoice"Importer
		assertEquals("496.00", zi.getAmount());
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_PDF);
		try {
			Invoice i = zii.extractInvoice();

			assertEquals(new BigDecimal("400.0000"), i.getZFItems()[1].getQuantity());
			/* getting the Quantity is more difficult than usual because in OrderX it's
			called requestedQuantity, not BilledQuantity
			 */


		} catch (XPathExpressionException e) {
			fail("XPathExpressionException should not be raised in testEdgeExport");
		} catch (ParseException e) {
			fail("ParseException should not be raised in testEdgeExport");
			/* a parseException would also be fired if the calculated grand total does not
			match the read grand total */
		}


	}

	public void testOXEdgeExport() {

		// the writing part

		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 OXExporterFromA1 oe = new OXExporterFromA1().setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(1).ignorePDFAErrors()
					 .load(SOURCE_PDF)) {
			TradeParty rec=new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
			Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
					.setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE").addTaxID("DE4711").addVATID("DE0815").setContact(new Contact("Hans Test", "+49123456789", "test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890", "COBADEFXXX")))
					.setRecipient(rec)
					.setReferenceNumber("991-01484-64")//leitweg-id
					.setNumber("123").addItem(new org.mustangproject.Item(new org.mustangproject.Product("Testprodukt", "", "C62", BigDecimal.ZERO), /*price*/ new BigDecimal("1.0"),  /*qty*/ new BigDecimal("1.0"))).addItem(new org.mustangproject.Item(new org.mustangproject.Product("Testprodukt", "", "C62", BigDecimal.ZERO), /*price*/ new BigDecimal("1.0"),  /*qty*/ new BigDecimal("1.0")));

			oe.setTransaction(i);
			oe.export(TARGET_PDF_EDGE);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_EDGE);

		assertTrue(zi.getUTF8().contains("<ram:TypeCode>220</ram:TypeCode>"));
		assertTrue(zi.getUTF8().contains("<ram:ShipToTradeParty>"));
		assertTrue(zi.getUTF8().contains("EUR"));

		// Now also check the "invoice"Importer
		assertEquals("2.00", zi.getAmount());
		assertEquals(zi.getHolder(), "Test company");
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter(TARGET_PDF_EDGE);
		try {
			Invoice i = zii.extractInvoice();

			assertEquals(new BigDecimal("1.0000"), i.getZFItems()[1].getQuantity());
			/* getting the Quantity is more difficult than usual because in OrderX it's
			called requestedQuantity, not BilledQuantity
			 */


		} catch (XPathExpressionException e) {
			fail("XPathExpressionException should not be raised in testEdgeExport");
		} catch (ParseException e) {
			fail("ParseException should not be raised in testEdgeExport");
			/* a parseException would also be fired if the calculated grand total does not
			match the read grand total */
		}


	}

}
