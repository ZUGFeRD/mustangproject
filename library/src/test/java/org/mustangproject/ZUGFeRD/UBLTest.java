
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

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.CII.CIIToUBL;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class UBLTest extends ResourceCase {

	public void testUBLBasic() {

		// the writing part
		final CIIToUBL c2u = new CIIToUBL();
		final String sourceFilename = "factur-x.xml";
		final File input = getResourceAsFile(sourceFilename);
		final File expectedFile = getResourceAsFile("ubl-conv-ubl-output-factur-x.xml");
		String expected = null;
		String result = null;
		try {
			final File tempFile = File.createTempFile("ZUGFeRD-UBL-", "-test");
			c2u.convert(input, tempFile);
			expected = ResourceUtilities.readFile(StandardCharsets.UTF_8, expectedFile.getAbsolutePath());
			result = ResourceUtilities.readFile(StandardCharsets.UTF_8, tempFile.getAbsolutePath()).replaceAll("\r\n", "\n");
		} catch (final IOException e) {
			fail("Exception should not happen: "+e.getMessage());
		}


		assertNotNull(result);
		assertEquals(expected, result);
	}
}
