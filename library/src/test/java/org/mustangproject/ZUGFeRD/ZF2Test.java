
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

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mustangproject.Invoice;

@TestMethodOrder(MethodOrderer.MethodName.class)
public class ZF2Test extends MustangReaderTestCase {
	private static final String TARGET_PDF = "./target/testout-ZF2new.pdf";


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
			new BigDecimal("19.000000")); // test for issue 103
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
	public IZUGFeRDLogisticsServiceCharge[] getZFLogisticsServiceCharges() {
		return null;
	}

	@Override
	public String getReferenceNumber() {
		return "AB321";
	}


	// //////// TESTS
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	@Test
	public void testExport() {
		try {
			// the writing part
			try (InputStream SOURCE_PDF = this.getClass().getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf");
					ZUGFeRDExporterFromA3 ze = new ZUGFeRDExporterFromA3()) {

				 ze.setProducer("My Application")
					 .setCreator(System.getProperty("user.name")).setZUGFeRDVersion(2).setProfile("EN16931")
					 .load(SOURCE_PDF);

				ze.setTransaction(this);
				final String theXML = new String(ze.getProvider().getXML(), StandardCharsets.UTF_8);
				assertTrue(theXML.contains("<rsm:CrossIndustryInvoice"));
				ze.export(TARGET_PDF);
			} catch (final IOException e) {
				fail("IOException should not be raised in testEdgeExport");
			}

			// now check the contents (like MustangReaderTest)
			final ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

			assertTrue(zi.getUTF8().contains("<ram:DueDateDateTime>"));

			// Reading ZUGFeRD
			assertEquals("571.04", zi.getAmount());
			assertEquals("RE-20170509/505", zi.getInvoiceID());
			assertEquals("COMFORT", zi.getZUGFeRDProfil());
			assertEquals("EUR", zi.getInvoiceCurrencyCode());
			assertEquals("", zi.getIssuerAssignedID());
			assertEquals("20170509", zi.getIssueDate());
			assertEquals("20170507", zi.getTaxPointDate());
			assertEquals("Zahlbar ohne Abzug bis zum 30.05.2017", zi.getPaymentTerms());
			assertEquals("496.00", zi.getLineTotalAmount());
			assertEquals("496.00", zi.getTaxBasisTotalAmount());
			assertEquals("75.04", zi.getTaxTotalAmount());
			assertEquals("", zi.getRoundingAmount());
			assertEquals("0.00", zi.getPaidAmount());
			assertEquals("Theodor Est", zi.getBuyerTradePartyName());
			assertEquals("", zi.getBuyerTradePartyGlobalID());
			assertEquals("", zi.getSellerTradePartyGlobalID());
			assertEquals("DE999999999", zi.getBuyerTradePartyID());
			assertEquals("DE999999999", zi.getBuyertradePartySpecifiedTaxRegistrationID());
			assertEquals("", zi.getIncludedNote());
			assertEquals(getOwnOrganisationName(), zi.getHolder());
			assertEquals("380", zi.getDocumentCode());
			assertEquals("AB321", zi.getReference());
			assertEquals("571.04", zi.getAmount());
			assertEquals("COBADEFFXXX", zi.getBIC());
			assertEquals("DE88 2008 0000 0970 3757 00", zi.getIBAN());
			assertEquals(getOwnOrganisationName(), zi.getHolder());
			assertEquals(getNumber(), zi.getForeignReference());
			assertEquals("88802", zi.getBuyerTradePartyAddress().getPostcodeCode());
			assertEquals("Bahnstr. 42", zi.getBuyerTradePartyAddress().getLineOne());
			assertEquals("Hinterhaus", zi.getBuyerTradePartyAddress().getLineTwo());
			assertEquals("Zweiter Stock", zi.getBuyerTradePartyAddress().getLineThree());
			assertNull(zi.getBuyerTradePartyAddress().getCountrySubDivisionName());
			assertEquals("DE", zi.getBuyerTradePartyAddress().getCountryID());
			assertEquals("Spielkreis", zi.getBuyerTradePartyAddress().getCityName());
			assertEquals("12345", zi.getSellerTradePartyAddress().getPostcodeCode());
			assertEquals("Ecke 12", zi.getSellerTradePartyAddress().getLineOne());
			assertNull(zi.getSellerTradePartyAddress().getLineTwo());
			assertNull(zi.getSellerTradePartyAddress().getLineThree());
			assertNull(zi.getSellerTradePartyAddress().getCountrySubDivisionName());
			assertEquals("DE", zi.getSellerTradePartyAddress().getCountryID());
			assertEquals("Stadthausen", zi.getSellerTradePartyAddress().getCityName());

			Invoice invoice = zi.extractInvoice();
			assertEquals("1", invoice.getZFItems()[0].getId());
			assertNull(invoice.getZFItems()[0].getProduct().getBuyerAssignedID());
			assertNull(invoice.getZFItems()[0].getProduct().getSellerAssignedID());
			assertEquals("160.00", invoice.getZFItems()[0].getLineTotalAmount().toString());
			assertEquals("1.0000", invoice.getZFItems()[0].getQuantity().toString());
			assertEquals("7.00", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
			assertEquals("Künstlerische Gestaltung (Stunde): Einer Beispielrechnung", invoice.getZFItems()[0].getProduct().getName());
			assertNull(invoice.getZFItems()[0].getProduct().getDescription());

			assertEquals(2, zi.getVersion());
		} catch ( Exception e ) {
			fail(e.getMessage());
		}
	}

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangBeispiel20221026.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values.
	 */
	@Test
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
		assertEquals("153.77", zi.getTaxTotalAmount());
		assertEquals("", zi.getRoundingAmount());
		assertEquals("0.00", zi.getPaidAmount());
		assertEquals("Beispiel AG", zi.getBuyerTradePartyName());
		assertEquals("", zi.getBuyerTradePartyGlobalID());
		assertEquals("", zi.getSellerTradePartyGlobalID());
		assertEquals("10000", zi.getBuyerTradePartyID());
		assertEquals("\n      weclapp.com\nSomestreet 42\n08155 Some city\nDE\n    ", zi.getIncludedNote());
		assertEquals("weclapp.com", zi.getHolder());
		assertEquals("380", zi.getDocumentCode());
		assertEquals("01-95", zi.getReference());
		assertEquals("RE1001", zi.getForeignReference());
		assertEquals("54321", zi.getBuyerTradePartyAddress().getPostcodeCode());
		assertEquals("Feldstraße 34", zi.getBuyerTradePartyAddress().getLineOne());
		assertNull(zi.getBuyerTradePartyAddress().getLineTwo());
		assertNull(zi.getBuyerTradePartyAddress().getLineThree());
		assertNull(zi.getBuyerTradePartyAddress().getCountrySubDivisionName());
		assertEquals("DE", zi.getBuyerTradePartyAddress().getCountryID());
		assertEquals("Hithausen", zi.getBuyerTradePartyAddress().getCityName());
		assertEquals("Beispiel Lager AG", zi.getDeliveryTradePartyName());
		assertEquals("54321", zi.getDeliveryTradePartyAddress().getPostcodeCode());
		assertEquals("Feldstraße 39", zi.getDeliveryTradePartyAddress().getLineOne());
		assertNull(zi.getDeliveryTradePartyAddress().getLineTwo());
		assertNull(zi.getDeliveryTradePartyAddress().getLineThree());
		assertNull(zi.getDeliveryTradePartyAddress().getCountrySubDivisionName());
		assertEquals("DE", zi.getDeliveryTradePartyAddress().getCountryID());
		assertEquals("Hithausen", zi.getDeliveryTradePartyAddress().getCityName());
		assertEquals("08155", zi.getSellerTradePartyAddress().getPostcodeCode());
		assertEquals("Somestreet 42", zi.getSellerTradePartyAddress().getLineOne());
		assertNull(zi.getSellerTradePartyAddress().getLineTwo());
		assertNull(zi.getSellerTradePartyAddress().getLineThree());
		assertNull(zi.getSellerTradePartyAddress().getCountrySubDivisionName());
		assertEquals("DE", zi.getSellerTradePartyAddress().getCountryID());
		assertEquals("Some city", zi.getSellerTradePartyAddress().getCityName());

		try {
			assertEquals(2, zi.getVersion());
		} catch (final Exception e) {
			e.printStackTrace();
		}
	}
}
