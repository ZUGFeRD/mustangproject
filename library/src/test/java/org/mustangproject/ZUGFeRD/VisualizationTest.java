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
import org.mustangproject.ZUGFeRD.ZUGFeRDVisualizer.Language;
import org.mustangproject.util.ByteArraySearcher;

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
		this.runZUGFeRDVisualization("factur-x.xml", "factur-x-vis.fr.html", Language.FR);
	}

	public void testCIIVisualizationExtended() {
		this.runZUGFeRDVisualization("factur-x-extended.xml", "factur-x-vis-extended.de.html", Language.DE);
	}

	public void testUBLCreditNoteVisualizationBasic() {
		this.runZUGFeRDVisualization("ubl-creditnote.xml", "factur-x-vis-ubl-creditnote.en.html", Language.EN);
	}

	public void testUBLVisualizationBasic() {
		this.runZUGFeRDVisualization("ubl/01.01a-INVOICE.ubl.xml", "factur-x-vis-ubl.en.html", Language.EN);
	}

	private void runZUGFeRDVisualization(String inputFilename, String resultFileName, Language lang) {
		File CIIinputFile = getResourceAsFile(inputFilename);

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			result = zvi.visualize(CIIinputFile.getAbsolutePath(), lang);
			Files.write(Paths.get("./target/testout-" + resultFileName), result.getBytes(StandardCharsets.UTF_8));

			File expectedResult = getResourceAsFile(resultFileName);
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8)
				;

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: " + e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: " + e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: " + e.getMessage());
		}


		assertNotNull(result);
        /* remove file endings so that tests can also pass after checking
		   out from git with arbitrary options (which may include CSRF changes)
		 */
		assertEquals(expected.replace("\r", "")
			.replace("\n", "")
			.replace("\t", "")
			.replace(" ", ""), result.replace("\r", "")
			.replace("\n", "")
			.replace("\t", "")
			.replace(" ", ""));
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
