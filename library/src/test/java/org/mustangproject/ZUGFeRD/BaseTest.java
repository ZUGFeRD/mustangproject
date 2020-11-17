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
import junit.framework.TestSuite;
import junit.framework.TestCase;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import org.mustangproject.XMLTools;

public class BaseTest extends TestCase {
	/**
	 * Create the test case
	 *
	 * @param testName name of the test case
	 */
	public BaseTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(BaseTest.class);
	}

	public void testCorrectDigits() {
		assertEquals("0.00", XMLTools.nDigitFormat(BigDecimal.ZERO,2));
		assertEquals("-1.10", XMLTools.nDigitFormat(new BigDecimal("-1.10"),2));
		assertEquals("-1.10", XMLTools.nDigitFormat(new BigDecimal("-1.1"),2));
		assertEquals("-1.01", XMLTools.nDigitFormat(new BigDecimal("-1.01"),2));
		assertEquals("20000123.35", XMLTools.nDigitFormat(new BigDecimal("20000123.3489"),2));
		assertEquals("20000123.34", XMLTools.nDigitFormat(new BigDecimal("20000123.3419"),2));
		assertEquals("12.00", XMLTools.nDigitFormat(new BigDecimal("12"),2));
		assertEquals("12", XMLTools.nDigitFormat(new BigDecimal("12"),0));
		assertEquals("20000123.342", XMLTools.nDigitFormat(new BigDecimal("20000123.3419"),3));
	}

}
