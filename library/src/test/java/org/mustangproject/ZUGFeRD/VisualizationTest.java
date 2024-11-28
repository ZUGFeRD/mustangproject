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
import org.mustangproject.util.ByteArraySearcher;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class VisualizationTest extends ResourceCase {

	final String TARGET_PDF_CII = "./target/testout-Visualization-cii.pdf";
	final String TARGET_PDF_UBL = "./target/testout-Visualization-cii.pdf";

	public void testCIIVisualizationBasic() {

		// the writing part
		String sourceFilename = "factur-x.xml";
		File CIIinputFile = getResourceAsFile(sourceFilename);

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.visualize(CIIinputFile.getAbsolutePath(), ZUGFeRDVisualizer.Language.FR)
				.replace("\r", "")
				.replace("\n", "")
				.replace("\t", "")
				.replace(" ", "");

			File expectedResult = getResourceAsFile("factur-x-vis.fr.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8)
				.replace("\r", "")
				.replace("\n", "")
				.replace("\t", "")
				.replace(" ", "");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: " + e.getMessage());
		} catch (ParserConfigurationException e) {
			fail("ParserConfigurationException should not happen: " + e.getMessage());
		} catch (SAXException e) {
			fail("SAXException should not happen: " + e.getMessage());
		}


		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}

	public void testCIIVisualizationExtended() {

		// the writing part
		String sourceFilename = "factur-x-extended.xml";
		File CIIinputFile = getResourceAsFile(sourceFilename);

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.visualize(CIIinputFile.getAbsolutePath(), ZUGFeRDVisualizer.Language.DE).replace("\r", "").replace("\n", "")
				.replace("\t", "")
				.replace(" ", "");

			File expectedResult = getResourceAsFile("factur-x-vis-extended.de.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r", "").replace("\n", "")
				.replace("\t", "")
				.replace(" ", "");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: " + e.getMessage());
		} catch (ParserConfigurationException e) {
			fail("ParserConfigurationException should not happen: " + e.getMessage());
		} catch (SAXException e) {
			fail("SAXException should not happen: " + e.getMessage());
		}


		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}

	public void testUBLCreditNoteVisualizationBasic() {

		// the writing part
		File UBLinputFile = getResourceAsFile("ubl-creditnote.xml");

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.visualize(UBLinputFile.getAbsolutePath(), ZUGFeRDVisualizer.Language.EN).replace("\r", "").replace("\n", "").replace("\t", "").replace(" ", "");

			File expectedResult = getResourceAsFile("factur-x-vis-ubl-creditnote.en.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r", "").replace("\n", "").replace("\t", "").replace(" ", "");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: " + e.getMessage());
		} catch (ParserConfigurationException e) {
			fail("ParserConfigurationException should not happen: " + e.getMessage());
		} catch (SAXException e) {
			fail("SAXException should not happen: " + e.getMessage());
		}


		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}


	public void testUBLVisualizationBasic() {

		// the writing part
		File UBLinputFile = getResourceAsFile("ubl/01.01a-INVOICE.ubl.xml");

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.visualize(UBLinputFile.getAbsolutePath(), ZUGFeRDVisualizer.Language.EN).replace("\r", "").replace("\n", "")
				.replace("\t", "")
				.replace(" ", "");

			File expectedResult = getResourceAsFile("factur-x-vis-ubl.en.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r", "").replace("\n", "")
				.replace("\t", "")
				.replace(" ", "");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: " + e.getMessage());
		} catch (ParserConfigurationException e) {
			fail("ParserConfigurationException should not happen: " + e.getMessage());
		} catch (SAXException e) {
			fail("SAXException should not happen: " + e.getMessage());
		}


		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}

	public void testPDFVisualizationCII() {

		File CIIinputFile = getResourceAsFile("cii/01.01a-INVOICE.cii.xml");

		// the writing part

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			zvi.toPDF(CIIinputFile.getAbsolutePath(), TARGET_PDF_CII);
		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		}

		try {
			assertTrue(ByteArraySearcher.startsWith(Files.readAllBytes(Paths.get(TARGET_PDF_CII)), new byte[]{'%', 'P', 'D', 'F'}));
		} catch (IOException e) {
			fail("IOException should not occur");
		}
	}

	public void testPDFVisualizationUBL() {

		File UBLinputFile = getResourceAsFile("ubl/01.01a-INVOICE.ubl.xml");

		// the writing part
		String sourceFilename = "factur-x.xml";

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			zvi.toPDF(UBLinputFile.getAbsolutePath(), TARGET_PDF_UBL);
		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		}


		try {
			assertTrue(ByteArraySearcher.startsWith(Files.readAllBytes(Paths.get(TARGET_PDF_CII)), new byte[]{'%', 'P', 'D', 'F'}));
		} catch (IOException e) {
			fail("IOException should not occur");
		}
	}

	public void testPDFVisualizationUBLCreditNote() {

		File UBLinputFile = getResourceAsFile("ubl/UBL-CreditNote-2.1-Example.ubl.xml");

		// the writing part
		String sourceFilename = "factur-x.xml";

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			zvi.toPDF(UBLinputFile.getAbsolutePath(), TARGET_PDF_UBL);
		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		}


		try {
			assertTrue(ByteArraySearcher.startsWith(Files.readAllBytes(Paths.get(TARGET_PDF_CII)), new byte[]{'%', 'P', 'D', 'F'}));
		} catch (IOException e) {
			fail("IOException should not occur");
		}
	}

}
