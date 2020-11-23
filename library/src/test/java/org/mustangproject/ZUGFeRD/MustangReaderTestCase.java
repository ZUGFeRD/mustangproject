/** **********************************************************************
 *
 * Copyright 2019 by ak on 12.04.19.
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

import junit.framework.TestCase;

import java.math.BigDecimal;

public abstract class MustangReaderTestCase extends TestCase implements IExportableTransaction {

	public MustangReaderTestCase(String testName) {
		super(testName);
	}
	

	@Override
	public IZUGFeRDTradeSettlement[] getTradeSettlement() {
		Payment[] payments = new Payment[1];
		payments[0] = new Payment();
		return payments;
	}

	protected class Payment implements IZUGFeRDTradeSettlementPayment {

		@Override
		public String getOwnBIC() {
			return "COBADEFFXXX";
		}

		@Override
		public String getOwnPaymentInfoText() {
			return "Überweisung";
		}

		@Override
		public String getOwnIBAN() {
			return "DE88 2008 0000 0970 3757 00";
		}
	}

	protected class RecipientTradeParty implements IZUGFeRDExportableTradeParty {

		@Override
		public String getCountry() {
			return "DE";
		}

		@Override
		public String getLocation() {
			return "Spielkreis";
		}

		@Override
		public String getName() {
			return "Theodor Est";
		}

		@Override
		public String getStreet() {
			return "Bahnstr. 42";
		}

		@Override
		public String getVATID() {
			return "DE999999999";
		}

		@Override
		public String getZIP() {
			return "88802";
		}
	}

	protected class SenderContact implements IZUGFeRDExportableContact {



		@Override
		public String getName() {
			return "Ingmar N. Fo";
		}

		@Override
		public String getPhone() {
			return "++49(0)237823";
		}

		@Override
		public String getEMail() {
			return "info@localhost.local";
		}

	}

	protected class SenderTradeParty implements IZUGFeRDExportableTradeParty {


		@Override
		public String getName() {
			return "Bei Spiel GmbH";
		}

		@Override
		public String getZIP() {
			return "12345";
		}

		@Override
		public String getCountry() {
			return "DE";
		}

		@Override
		public String getLocation() {
			return "Stadthausen";
		}

		@Override
		public String getStreet() {
			return "Ecke 12";
		}

		@Override
		public String getTaxID() {
			return "0815";
		}

		@Override
		public String getVATID() {
			return "DE0815";
		}

	}

	protected class Item implements IZUGFeRDExportableItem {

		public Item(BigDecimal price, BigDecimal quantity, IZUGFeRDExportableProduct product) {
			super();
			this.price = price;
			this.quantity = quantity;
			this.product = product;
		}

		private BigDecimal price, quantity;
		private IZUGFeRDExportableProduct product;
		private String addReference=null;
		
		public String getAdditionalReferencedDocumentID() {
			return addReference;
		}

		@Override
		public BigDecimal getPrice() {
			return price;
		}

		public void setPrice(BigDecimal price) {
			this.price = price;
		}

		@Override
		public BigDecimal getQuantity() {
			return quantity;
		}

		public void setQuantity(BigDecimal quantity) {
			this.quantity = quantity;
		}

		@Override
		public IZUGFeRDExportableProduct getProduct() {
			return product;
		}

		public void setProduct(IZUGFeRDExportableProduct product) {
			this.product = product;
		}

		@Override
		public IZUGFeRDAllowanceCharge[] getItemAllowances() {
			return null;
		}

		@Override
		public IZUGFeRDAllowanceCharge[] getItemCharges() {
			return null;
		}

		public String getAddReference() {
			return addReference;
		}

		public void setAddReference(String addReference) {
			this.addReference = addReference;
		}
		

	}

	protected class Product implements IZUGFeRDExportableProduct {
		private String description, name, unit;
		private BigDecimal VATPercent;

		public Product(String description, String name, String unit, BigDecimal VATPercent) {
			super();
			this.description = description;
			this.name = name;
			this.unit = unit;
			this.VATPercent = VATPercent;
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
			return VATPercent;
		}

		public void setVATPercent(BigDecimal VATPercent) {
			this.VATPercent = VATPercent;
		}
	}

}
