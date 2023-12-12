
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

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class PDFAWriteTest extends ResourceCase {
	final String TARGET_PDF_FROM_A1 = "./target/testout-PDFA3FromA3.pdf";
	final String TARGET_PDF_FROM_A3 = "./target/testout-PDFA3FromA3.pdf";
	final String TARGET_PDF_FROM_A3_UNKNOWN = "./target/testout-PDFA3FromUnkownA3.pdf";
	final String TARGET_PDF_FROM_A1_UNKNOWN = "./target/testout-PDFA3FromUnkownA1.pdf";
	public void testA1KnownExport() {
		// test creating factur-x invoices to french authorities, i.e. with SIRET number
		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");

		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blanko.pdf");//a3
		int exceptions=0;
		try {
			ZUGFeRDExporterFromA1 zea3 = new ZUGFeRDExporterFromA1().load(tempFile.getAbsolutePath());
			zea3.setTransaction(i);
			zea3.export(TARGET_PDF_FROM_A1);

		} catch (IOException e) {
			exceptions++;
		}
		assertTrue(exceptions==0);

	}
	public void testA3KnownExport() {
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");

		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blankoA3.pdf");//a3
		int exceptions=0;
		try {
			ZUGFeRDExporterFromA3 zea3 = new ZUGFeRDExporterFromA3().load(tempFile.getAbsolutePath());
			zea3.setTransaction(i);
			zea3.export(TARGET_PDF_FROM_A3);

		} catch (IOException e) {
			exceptions++;
		}
		assertTrue(exceptions==0);

	}
	public void testA3UnknownExport() {
		// test creating factur-x invoices to french authorities, i.e. with SIRET number
		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);

		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blankoA3.pdf");
		int exceptions=0;
		try {
			IZUGFeRDExporter zea = new ZUGFeRDExporterFromPDFA().load(tempFile.getAbsolutePath());
			zea.setTransaction(i);
			zea.export(TARGET_PDF_FROM_A3_UNKNOWN);

		} catch (IOException e) {
			exceptions++;
		}
		assertTrue(exceptions==0);

	}

	public void testA3UnknownExportFromA1() {
		// test creating factur-x invoices to french authorities, i.e. with SIRET number
		// the writing part
		TradeParty recipient = new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
		Invoice i = createInvoice(recipient);
		File tempFile = getResourceAsFile("MustangGnuaccountingBeispielRE-20201121_508blanko.pdf");
		int exceptions=0;
		try {
			FileInputStream fis=new FileInputStream(tempFile);
			IZUGFeRDExporter zea3 = new  ZUGFeRDExporterFromPDFA().load(fis);
			zea3.setTransaction(i);
			zea3.setProfile(Profiles.getByName("EN16931"));
			zea3.export(TARGET_PDF_FROM_A1_UNKNOWN);

		} catch (IOException e) {
			exceptions++;
		}
		assertTrue(exceptions==0);

	}

	private Invoice createInvoice(TradeParty recipient) {
		String orgname = "Test company";
		String number = "123";
		String amountStr = "1.00";
		BigDecimal amount = new BigDecimal(amountStr);
		return new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date())
				.setSender(new TradeParty(orgname,"teststr","55232","teststadt","DE").addTaxID("DE4711").addVATID("DE0815").setContact(new Contact("Hans Test","+49123456789","test@example.org")).addBankDetails(new BankDetails("DE12500105170648489890","COBADEFXXX")))
				.setRecipient(recipient)
				.setReferenceNumber("991-01484-64")//leitweg-id
				// not using any VAT, this is also a test of zero-rated goods:
				.setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", BigDecimal.ZERO), amount, new BigDecimal(1.0)));
	}

}
