
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

import org.mustangproject.Invoice;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import junit.framework.TestCase;
import junit.framework.Test;
import junit.framework.TestSuite;


/***
 * Classname ZF2ZInvoiceImporterTest is alphabetical behind the tests which will create the file
 * used for this import, testout-ZF2New.pdf
 */
public class ZF2ZInvoiceImporterTest extends TestCase  {
	final String TARGET_PDF = "./target/testout-ZF2new.pdf";

	public void testInvoiceImport() {

		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter(TARGET_PDF);

		Invoice invoice=zii.extractInvoice();
		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", invoice.getOwnOrganisationName());
		assertEquals(3, invoice.getZFItems().length);
	/*	assertEquals("160.0000", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("400.0000", invoice.getZFItems()[1].getQuantity().toString());
		assertEquals("Heiße Luft pro Liter", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("7", invoice.getZFItems()[0].getProduct().getVATPercent().toString());

*/

	}

}
