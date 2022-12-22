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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/***
 * This is a test to confirm the minimum steps to implement a interface are still sufficient
 *
 * @author jstaerk
 *
 */
public class ProfilesMinimumBasicWLTest extends TestCase {

	final String TARGET_PDF_FX_MINIMUM = "./target/testout-Minimum.pdf";

	public void testMinimumExport() {
		String ownNumber = "NUMFACTURE";
		String ownBIC = "COBADEFFXXX";
		String ownIBAN = "DE88200800000970375700";
		String ownOrgName = "ME";

		// the writing part
		try (InputStream SOURCE_PDF = this.getClass()
				.getResourceAsStream("/MustangGnuaccountingBeispielRE-20190610_507blanko.pdf");
			 IZUGFeRDExporter ze = new ZUGFeRDExporterFromA1().setZUGFeRDVersion(2).setProfile("Minimum").load(SOURCE_PDF)) {
			//https://stackoverflow.com/questions/72450066/creating-a-min-basic-and-basic-wl-factur-x-using-mustang
			Invoice i = new Invoice()
					.setIssueDate(new Date())
/*					.setDueDate(new Date())
					.setDetailedDeliveryPeriod(new Date(), new Date())
					.setDeliveryDate(new Date())*/
					.setSender(
							new TradeParty().setName(ownOrgName).setCountry("FR")
									.addBankDetails(new BankDetails(ownIBAN, ownBIC)))
					.setRecipient(
							new TradeParty().setName("Client").setCountry("FR"))
					.setNumber(ownNumber)
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal(123), new BigDecimal(1)))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal(123), new BigDecimal(1)))
					.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(19)), new BigDecimal(123), new BigDecimal(1)))
					.setCreditNote();
			ze.setTransaction(i);
			ze.export(TARGET_PDF_FX_MINIMUM);

			// check for pdf-a schema extension
//			assertFalse(pdfContent.indexOf("<zf:ConformanceLevel>EN 16931</zf:ConformanceLevel>") == -1);
//			assertFalse(pdfContent.indexOf("<pdfaSchema:prefix>zf</pdfaSchema:prefix>") == -1);
//			assertFalse(pdfContent.indexOf("urn:zugferd:pdfa:CrossIndustryDocument:invoice:2p0#") == -1);

		} catch (IOException e) {
			fail("IOException should not happen in testZExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_FX_MINIMUM);

		// Reading ZUGFeRD
		assertEquals(zi.getAmount(), "439.11");
//		assertEquals(zi.getBIC(), ownBIC);
//		assertEquals(zi.getIBAN(), ownIBAN);
		assertEquals(zi.getHolder(), ownOrgName);
//		assertEquals(zi.getForeignReference(), ownNumber);


	}


}
