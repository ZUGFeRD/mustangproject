
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

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.Contact;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class UXTest extends TestCase {
	final String TARGET_PDF = "./target/testout-UX.pdf";
	public void testShortExport() {

		// the writing part
/*
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf"))
		{
			Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setOwnOrganisationName("My company").setOwnStreet("teststr").setOwnZIP("12345").setOwnLocation("teststadt").setOwnCountry("DE").setOwnTaxID("4711").setOwnVATID("0815").setRecipient(new Contact("Franz Müller", "0177123456", "fmueller@test.com", "teststr.12", "55232", "Entenhausen", "DE")).setNumber("INV/123").addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO), new BigDecimal(1.0), new BigDecimal(1.0)));
			new ZUGFeRDExporterFromA1().load("source.pdf").setTransaction(i).export(TARGET_PDF);
		} catch (Exception e) {
			fail("Exception should not be raised in testEdgeExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF);

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
		assertEquals(zi.getDocumentCode(),"380");
		assertEquals(zi.getReference(),"AB321");
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBuyerTradePartyAddress().getPostcodeCode(), "88802");
		assertEquals(zi.getBuyerTradePartyAddress().getLineOne(), "Bahnstr. 42");
		assertEquals(zi.getBuyerTradePartyAddress().getLineTwo(), null);
		assertEquals(zi.getBuyerTradePartyAddress().getLineThree(), null);
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

		List<org.mustangproject.Item> li = zi.getLineItemList();
		assertEquals(zi.getLineItemList().get(0).getId().toString(), "1");
		assertEquals(zi.getLineItemList().get(0).getProduct().getBuyerAssignedID(), "");
		assertEquals(zi.getLineItemList().get(0).getProduct().getSellerAssignedID(), "");
		assertEquals(zi.getLineItemList().get(0).getLineTotalAmount().toString(), "160.00");
		assertEquals(zi.getLineItemList().get(0).getQuantity().toString(), "1.0000");
		assertEquals(zi.getLineItemList().get(0).getGrossPrice().toString(), "160.0000");
		assertEquals(zi.getLineItemList().get(0).getProduct().getVATPercent().toString(), "7.00");
		assertEquals(zi.getLineItemList().get(0).getProduct().getName(), "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung");
		assertEquals(zi.getLineItemList().get(0).getProduct().getDescription(), "");

		try {
			assertEquals(zi.getVersion(), 2);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
	}
}
