
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

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ZF2Test extends MustangReaderTestCase {
	final String TARGET_PDF = "./target/testout-ZF2new.pdf";


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
	public String getOwnOrganisationFullPlaintextInfo() {
		return null;
	}

	@Override
	public String getCurrency() {
		return "EUR";
	}

	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		final Item[] allItems = new Item[3];
		final Product designProduct = new Product("", "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung", "HUR",
				new BigDecimal("7.000000"));
		final Product balloonProduct = new Product("", "Bestellerweiterung für E&F Umbau", "C62",
				new BigDecimal("19.000000"));// test for issue 103
		final Product airProduct = new Product("", "Heiße Luft pro Liter", "LTR", new BigDecimal("19.000000"));

		allItems[0] = new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.10"), new BigDecimal("200"), airProduct);
		return allItems;
	}

	@Override
	public String getPaymentTermDescription() {
		final SimpleDateFormat germanDateFormat = new SimpleDateFormat("dd.MM.yyyy");
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
	public ZF2Test(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(ZF2Test.class);
	}

	// //////// TESTS
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	public void testExport() {

		// the writing part

		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf");

			 ZUGFeRDExporterFromA3 ze = new ZUGFeRDExporterFromA3().setProducer("My Application")
						.setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("EN16931")
						.load(SOURCE_PDF)) {
			
			ze.setTransaction(this);
			final String theXML = new String(ze.getProvider().getXML());
			assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
			ze.export(TARGET_PDF);
		} catch (final IOException e) {
			fail("IOException should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		final ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

		assertTrue(zi.getUTF8().contains("<ram:DueDateDateTime>"));

		// Reading ZUGFeRD
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getInvoiceID(), "RE-20170509/505");
		assertEquals(zi.getZUGFeRDProfil(), "COMFORT");
		assertEquals(zi.getInvoiceCurrencyCode(), "EUR");
		assertEquals(zi.getIssuerAssignedID(),"");
		assertEquals(zi.getIssueDate(), "20170509");
		assertEquals(zi.getTaxPointDate(), "20170507");
		assertEquals(zi.getPaymentTerms(), "Zahlbar ohne Abzug bis zum 30.05.2017");
		assertEquals(zi.getLineTotalAmount(), "496.00");
		assertEquals(zi.getTaxBasisTotalAmount(), "496.00");
		assertEquals(zi.getTaxTotalAmount(),"75.04");
		assertEquals(zi.getRoundingAmount(), "");
		assertEquals(zi.getPaidAmount(), "0.00");
		assertEquals(zi.getBuyerTradePartyName(), "Theodor Est");
		assertEquals(zi.getBuyerTradePartyGlobalID(), "");
		assertEquals(zi.getSellerTradePartyGlobalID(), "");
		assertEquals(zi.getBuyerTradePartyID(), "DE999999999");
		assertEquals(zi.getBuyertradePartySpecifiedTaxRegistrationID(), "DE999999999");
		assertEquals(zi.getIncludedNote(), "");
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getDocumentCode(),"380");
		assertEquals(zi.getReference(),"AB321");
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), "COBADEFFXXX");
		assertEquals(zi.getIBAN(), "DE88 2008 0000 0970 3757 00");
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), getNumber());
		assertEquals(zi.getBuyerTradePartyAddress().getPostcodeCode(), "88802");
		assertEquals(zi.getBuyerTradePartyAddress().getLineOne(), "Bahnstr. 42");
		assertEquals(zi.getBuyerTradePartyAddress().getLineTwo(), "Hinterhaus");
		assertEquals(zi.getBuyerTradePartyAddress().getLineThree(), "Zweiter Stock");
		assertEquals(zi.getBuyerTradePartyAddress().getCountrySubDivisionName(), null);
		assertEquals(zi.getBuyerTradePartyAddress().getCountryID(), "DE");
		assertEquals(zi.getBuyerTradePartyAddress().getCityName(), "Spielkreis");
		assertEquals(zi.getSellerTradePartyAddress().getPostcodeCode(), "12345");
		assertEquals(zi.getSellerTradePartyAddress().getLineOne(), "Ecke 12");
		assertEquals(zi.getSellerTradePartyAddress().getLineTwo(), null);
		assertEquals(zi.getSellerTradePartyAddress().getLineThree(), null);
		assertEquals(zi.getSellerTradePartyAddress().getCountrySubDivisionName(), null);
		assertEquals(zi.getSellerTradePartyAddress().getCountryID(), "DE");
		assertEquals(zi.getSellerTradePartyAddress().getCityName(), "Stadthausen");

		final List<org.mustangproject.Item> li = zi.getLineItemList();
		assertEquals(li.get(0).getId().toString(), "1");
		assertEquals(li.get(0).getProduct().getBuyerAssignedID(), "");
		assertEquals(li.get(0).getProduct().getSellerAssignedID(), "");
		assertEquals(li.get(0).getLineTotalAmount().toString(), "160.00");
		assertEquals(li.get(0).getQuantity().toString(), "1.0000");
		assertEquals(li.get(0).getProduct().getVATPercent().toString(), "7.00");
		assertEquals(li.get(0).getProduct().getName(), "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung");
		assertEquals(li.get(0).getProduct().getDescription(), "");

		try {
			assertEquals(zi.getVersion(), 2);
		} catch (final Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangBeispiel20221026.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	public void testImport() {
		// now check the contents (like MustangReaderTest)
		final ZUGFeRDImporter zi = new ZUGFeRDImporter("src/test/resources/MustangBeispiel20221026.pdf");

		// Reading ZUGFeRD
		assertEquals("963.11", zi.getAmount());
		assertEquals("RE1001", zi.getInvoiceID());
		assertEquals("COMFORT", zi.getZUGFeRDProfil());
		assertEquals("EUR", zi.getInvoiceCurrencyCode());
		assertEquals("20221026", zi.getIssueDate());
		assertEquals("20221026", zi.getTaxPointDate());
		assertEquals("Innerhalb von 30 Tagen 2% Skonto, 60 Tage ohne Abzug", zi.getPaymentTerms());
		assertEquals("804.35", zi.getLineTotalAmount());
		assertEquals("809.34", zi.getTaxBasisTotalAmount());
		assertEquals("153.77",zi.getTaxTotalAmount());
		assertEquals("", zi.getRoundingAmount());
		assertEquals("0.00", zi.getPaidAmount());
		assertEquals("Beispiel AG", zi.getBuyerTradePartyName());
		assertEquals("", zi.getBuyerTradePartyGlobalID());
		assertEquals("", zi.getSellerTradePartyGlobalID());
		assertEquals("10000", zi.getBuyerTradePartyID());
		assertEquals("\n      weclapp.com\nSomestreet 42\n08155 Some city\nDE\n    ", zi.getIncludedNote());
		assertEquals("weclapp.com", zi.getHolder());
		assertEquals("380",zi.getDocumentCode());
		assertEquals("01-95",zi.getReference());
		assertEquals("RE1001", zi.getForeignReference());
		assertEquals("54321", zi.getBuyerTradePartyAddress().getPostcodeCode());
		assertEquals("Feldstraße 34", zi.getBuyerTradePartyAddress().getLineOne());
		assertEquals(null, zi.getBuyerTradePartyAddress().getLineTwo());
		assertEquals(null, zi.getBuyerTradePartyAddress().getLineThree());
		assertEquals(null, zi.getBuyerTradePartyAddress().getCountrySubDivisionName());
		assertEquals("DE", zi.getBuyerTradePartyAddress().getCountryID());
		assertEquals("Hithausen", zi.getBuyerTradePartyAddress().getCityName());
		assertEquals("Beispiel Lager AG", zi.getDeliveryTradePartyName());
    assertEquals("54321", zi.getDeliveryTradePartyAddress().getPostcodeCode());
    assertEquals("Feldstraße 39", zi.getDeliveryTradePartyAddress().getLineOne());
    assertEquals(null, zi.getDeliveryTradePartyAddress().getLineTwo());
    assertEquals(null, zi.getDeliveryTradePartyAddress().getLineThree());
    assertEquals(null, zi.getDeliveryTradePartyAddress().getCountrySubDivisionName());
    assertEquals("DE", zi.getDeliveryTradePartyAddress().getCountryID());
    assertEquals("Hithausen", zi.getDeliveryTradePartyAddress().getCityName());
		assertEquals("08155", zi.getSellerTradePartyAddress().getPostcodeCode());
		assertEquals("Somestreet 42", zi.getSellerTradePartyAddress().getLineOne());
		assertEquals(null, zi.getSellerTradePartyAddress().getLineTwo());
		assertEquals(null, zi.getSellerTradePartyAddress().getLineThree());
		assertEquals(null, zi.getSellerTradePartyAddress().getCountrySubDivisionName());
		assertEquals("DE", zi.getSellerTradePartyAddress().getCountryID());
		assertEquals("Some city", zi.getSellerTradePartyAddress().getCityName());

		try {
			assertEquals(zi.getVersion(), 2);
		} catch (final Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
