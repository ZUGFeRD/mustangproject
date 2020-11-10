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
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import junit.framework.TestCase;
import org.mustangproject.TradeParty;

/***
 * This is a test to confirm the minimum steps to implement a interface are still sufficient
 * 
 * @author jstaerk
 *
 */
public class BackwardCompatibilityTest extends TestCase implements IExportableTransaction {

	final String TARGET_PDF_ZF1 = "./target/testout-MustangGnuaccountingBeispielRE-20171118_506zf1.pdf";
	final String TARGET_PDF_ZF2 = "./target/testout-MustangGnuaccountingBeispielRE-20171118_506zf2.pdf";
	final String TARGET_PDF_FX = "./target/testout-MustangGnuaccountingBeispielRE-20171118_506fx.pdf";

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20140703_502blanko.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values. It would not make sense to have it run before the less complex
	 * importer test (which is probably redundant). As only Name Ascending is
	 * supported for Test Unit sequence, I renamed the Exporter Test test-Z-Export
	 */
	public void testZF1Export() {


		// the writing part
		try (InputStream SOURCE_PDF = this.getClass()
			.getResourceAsStream("/MustangGnuaccountingBeispielRE-20190610_507blanko.pdf");

			 IZUGFeRDExporter ze = new ZUGFeRDExporterFromA1().setZUGFeRDVersion(1).setProfile(Profiles.getByName("Extended",1)).load(SOURCE_PDF)) {

			ze.setTransaction(this);
			ze.disableAutoClose(true);
			ze.export(TARGET_PDF_ZF1);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ze.export(baos);
			ze.close();
			String pdfContent = baos.toString("UTF-8");
			assertFalse(pdfContent.indexOf("(via mustangproject.org") == -1);
			// check for pdf-a schema extension
//			assertFalse(pdfContent.indexOf("<zf:ConformanceLevel>EN 16931</zf:ConformanceLevel>") == -1);
//			assertFalse(pdfContent.indexOf("<pdfaSchema:prefix>zf</pdfaSchema:prefix>") == -1);
//			assertFalse(pdfContent.indexOf("urn:zugferd:pdfa:CrossIndustryDocument:invoice:2p0#") == -1);

		} catch (IOException e) {
			fail("IOException should not happen in testZExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_ZF1);

		// Reading ZUGFeRD
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), getTradeSettlementPayment()[0].getOwnBIC());
		assertEquals(zi.getIBAN(), getTradeSettlementPayment()[0].getOwnIBAN());
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), getNumber());
		
		
	}

	public void testZF2Export() {

	
		// the writing part
		try (InputStream SOURCE_PDF = this.getClass()
			.getResourceAsStream("/MustangGnuaccountingBeispielRE-20190610_507blanko.pdf");

			 IZUGFeRDExporter ze = new ZUGFeRDExporterFromA1().setZUGFeRDVersion(2).setProfile("EN16931").load(SOURCE_PDF)) {

			ze.setTransaction(this);
			ze.disableAutoClose(true);
			ze.export(TARGET_PDF_ZF2);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ze.export(baos);
			ze.close();
			String pdfContent = baos.toString("UTF-8");
			assertFalse(pdfContent.indexOf("(via mustangproject.org") == -1);
			// check for pdf-a schema extension
//			assertFalse(pdfContent.indexOf("<zf:ConformanceLevel>EN 16931</zf:ConformanceLevel>") == -1);
//			assertFalse(pdfContent.indexOf("<pdfaSchema:prefix>zf</pdfaSchema:prefix>") == -1);
//			assertFalse(pdfContent.indexOf("urn:zugferd:pdfa:CrossIndustryDocument:invoice:2p0#") == -1);

		} catch (IOException e) {
			fail("IOException should not happen in testZExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_ZF2);

		// Reading ZUGFeRD
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), getTradeSettlementPayment()[0].getOwnBIC());
		assertEquals(zi.getIBAN(), getTradeSettlementPayment()[0].getOwnIBAN());
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), getNumber());
		
		
	}
	public void testFXExport() {

		// the writing part
		try (InputStream SOURCE_PDF = this.getClass()
			.getResourceAsStream("/MustangGnuaccountingBeispielRE-20190610_507blanko.pdf");

			 IZUGFeRDExporter ze = new ZUGFeRDExporterFromA1().setZUGFeRDVersion(2).setProfile("EN16931").load(SOURCE_PDF)) {

			ze.setTransaction(this);
			ze.disableAutoClose(true);
			ze.export(TARGET_PDF_FX);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ze.export(baos);
			ze.close();
			String pdfContent = baos.toString("UTF-8");
			assertFalse(pdfContent.indexOf("(via mustangproject.org") == -1);
			// check for pdf-a schema extension
//			assertFalse(pdfContent.indexOf("<zf:ConformanceLevel>EN 16931</zf:ConformanceLevel>") == -1);
//			assertFalse(pdfContent.indexOf("<pdfaSchema:prefix>zf</pdfaSchema:prefix>") == -1);
//			assertFalse(pdfContent.indexOf("urn:zugferd:pdfa:CrossIndustryDocument:invoice:2p0#") == -1);

		} catch (IOException e) {
			fail("IOException should not happen in testZExport");
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter(TARGET_PDF_FX);

		// Reading ZUGFeRD
		assertEquals(zi.getAmount(), "571.04");
		assertEquals(zi.getBIC(), getTradeSettlementPayment()[0].getOwnBIC());
		assertEquals(zi.getIBAN(), getTradeSettlementPayment()[0].getOwnIBAN());
		assertEquals(zi.getHolder(), getOwnOrganisationName());
		assertEquals(zi.getForeignReference(), getNumber());
		
		
	}
	class Contact implements IZUGFeRDExportableContact {
		public String getCountry() {
			return "DE";
		}

		public String getLocation() {
			return "Spielkreis";
		}

		public String getName() {
			return "Theodor Est";
		}

		public String getStreet() {
			return "Bahnstr. 42";
		}

		public String getVATID() {
			return "DE999999999";
		}

		public String getZIP() {
			return "88802";
		}

	}
   class Payment implements IZUGFeRDTradeSettlementPayment {

		@Override
		public String getOwnBIC() {
			return "bla";
		}

		@Override
		public String getOwnIBAN() {
			return "bla";
		}

	}

	class Item implements IZUGFeRDExportableItem {
		public Item(BigDecimal price, BigDecimal quantity, Product product) {
			super();
			this.price = price;
			this.quantity = quantity;
			this.product = product;
		}

		private BigDecimal price, quantity;
		private Product product;

		public BigDecimal getPrice() {
			return price;
		}

		public void setPrice(BigDecimal price) {
			this.price = price;
		}

		public BigDecimal getQuantity() {
			return quantity;
		}

		public void setQuantity(BigDecimal quantity) {
			this.quantity = quantity;
		}

		public Product getProduct() {
			return product;
		}

		public void setProduct(Product product) {
			this.product = product;
		}

		public IZUGFeRDAllowanceCharge[] getItemAllowances() {
			// TODO Auto-generated method stub
			return null;
		}

		public IZUGFeRDAllowanceCharge[] getItemCharges() {
			// TODO Auto-generated method stub
			return null;
		}
	}

	class Product implements IZUGFeRDExportableProduct {
		public Product(String description, String name, String unit, BigDecimal vATPercent) {
			super();
			this.description = description;
			this.name = name;
			this.unit = unit;
			VATPercent = vATPercent;
		}

		private String description, name, unit;
		private BigDecimal VATPercent;

		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getUnit() {
			return unit;
		}

		public void setUnit(String unit) {
			this.unit = unit;
		}

		public BigDecimal getVATPercent() {
			return VATPercent;
		}

		public void setVATPercent(BigDecimal vATPercent) {
			VATPercent = vATPercent;
		}
	}

	@Override
	public Date getDeliveryDate() {
		return new GregorianCalendar(2019, Calendar.JUNE, 10).getTime();
	}



	@Override
	public IZUGFeRDExportableTradeParty getRecipient() {
		return new TradeParty("name","street","zip","city","DE");
	}

	@Override
	public IZUGFeRDExportableTradeParty getSender() {
		return new TradeParty("Bei Spiel GmbH","street","zip","city","DE");
	}
	
		
	//
	public IZUGFeRDTradeSettlementPayment[] getTradeSettlementPayment() {
		Payment P = new Payment();
		IZUGFeRDTradeSettlementPayment[] allP = new Payment[1];
		allP[0] = P;
		return allP;

	}

	public IZUGFeRDAllowanceCharge[] getZFAllowances() {
		// TODO Auto-generated method stub
		return null;
	}

	public IZUGFeRDAllowanceCharge[] getZFCharges() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public IZUGFeRDExportableItem[] getZFItems() {
		Item[] allItems = new Item[3];
		Product designProduct = new Product("", "Design (hours): Of a sample invoice", "HUR",
				new BigDecimal("7.000000"));
		Product balloonProduct = new Product("", "Ballons: various colors, ~2000ml", "C62", new BigDecimal("19.000000"));
		Product airProduct = new Product("", "Hot air „heiße Luft“ (litres)", "LTR", new BigDecimal("19.000000"));

		allItems[0] = new Item(new BigDecimal("160"), new BigDecimal("1"), designProduct);
		allItems[1] = new Item(new BigDecimal("0.79"), new BigDecimal("400"), balloonProduct);
		allItems[2] = new Item(new BigDecimal("0.025"), new BigDecimal("800"), airProduct);
		return allItems;
	}

	public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Date getDueDate() {
		return new GregorianCalendar(2019, Calendar.JULY, 1).getTime();
	}

	@Override
	public Date getIssueDate() {
		return new GregorianCalendar(2019, Calendar.JUNE, 10).getTime();
	}


	@Override
	public String getNumber() {
		return "RE-20190610/507";
	}



	public String getOwnBIC() {
		return "COBADEFFXXX";
	}

	public String getOwnBankName() {
		return "Commerzbank";
	}


	@Override
	public String getOwnCountry() {
		return "DE";
	}

	public String getOwnIBAN() {
		return "DE88 2008 0000 0970 3757 00";
	}
	

	@Override
	public String getOwnLocation() {
		return "Stadthausen";
	}

	@Override
	public String getOwnOrganisationFullPlaintextInfo() {
		return "Bei Spiel GmbH\n" + "Ecke 12\n" + "12345 Stadthausen\n" + "Geschäftsführer: Max Mustermann";
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




}
