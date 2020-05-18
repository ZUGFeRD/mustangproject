
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

import junit.framework.TestCase;
import junit.framework.Test;
import junit.framework.TestSuite;


/***
 * Classname ZF2ZInvoiceImporterTest is alphabetical behind the tests which will create the file
 * used for this import, testout-ZF2New.pdf
 */
public class ZF2ZInvoiceImporterTest extends TestCase  {
	final String TARGET_PDF = "./target/testout-ZF2New.pdf";

	public void testInvoiceImport() {

		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter(TARGET_PDF);


		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", zii.extractInvoice().getOwnOrganisationName());
		assertEquals(3, zii.extractInvoice().getZFItems().length);
		assertEquals("160.0000", zii.extractInvoice().getZFItems()[0].getPrice().toString());


	}

}
