
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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import junit.framework.Test;
import junit.framework.TestSuite;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ZF2EdgeTest extends MustangReaderTestCase implements IExportableTransaction {
	final String TARGET_PDF = "./target/testout-ZF2newEdge.pdf";

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

		Item design=new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
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
	public ZF2EdgeTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(ZF2EdgeTest.class);
	}

	// //////// TESTS
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	public void testEdgeExport() {

		// the writing part

		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			 ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().setProducer("My Application")
						.setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).ignorePDFAErrors()
						.load(SOURCE_PDF)) {
			ze.setTransaction(this);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_PDF);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

		assertTrue(zi.getUTF8().contains("<ram:TypeCode>59</ram:TypeCode>"));
		assertTrue(zi.getUTF8().contains("<ram:ShipToTradeParty>"));
		assertTrue(zi.getUTF8().contains("<ram:IBANID>DE540815</ram:IBANID>"));
		assertTrue(zi.getUTF8().contains("<ram:DirectDebitMandateID>DE99XX12345</ram:DirectDebitMandateID>"));
		assertFalse(zi.getUTF8().contains("<ram:DueDateDateTime>"));
		assertFalse(zi.getUTF8().contains("EUR"));
		assertTrue(zi.getUTF8().contains("USD"));//currency should be USD, test for #150

		// Reading ZUGFeRD
		assertEquals("496.00", zi.getAmount());
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), getNumber());
		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	public void testOutputStreamExport() {

		// the writing part

		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf");

				IZUGFeRDExporter ze = new ZUGFeRDExporterFromA3().setProducer("My Application")
						.setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).disableFacturX()
						.load(SOURCE_PDF)) {
			ze.setTransaction(this);
			String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(bos);
		} catch (IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

	}

}
