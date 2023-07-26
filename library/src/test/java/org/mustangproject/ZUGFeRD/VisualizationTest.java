
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

import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.xmlgraphics.util.MimeConstants;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.CII.CIIToUBL;
import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class VisualizationTest extends ResourceCase {

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
			result = zvi.visualize(CIIinputFile.getAbsolutePath(),ZUGFeRDVisualizer.Language.FR).replace("\r","").replace("\n","");

			File expectedResult=getResourceAsFile("factur-x-vis.fr.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r","").replace("\n","");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: "+e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: "+e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: "+e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: "+e.getMessage());
		}



		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}
	public void testUBLCreditNoteVisualizationBasic() {

		// the writing part
		CIIToUBL c2u = new CIIToUBL();
		String sourceFilename = "factur-x.xml";
		File UBLinputFile = getResourceAsFile("ubl-creditnote.xml");

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.visualize(UBLinputFile.getAbsolutePath(),ZUGFeRDVisualizer.Language.EN).replace("\r","").replace("\n","");

			File expectedResult=getResourceAsFile("factur-x-vis-ubl-creditnote.en.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r","").replace("\n","");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: "+e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: "+e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: "+e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: "+e.getMessage());
		}



		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}
	public void testUBLVisualizationBasic() {

		// the writing part
		CIIToUBL c2u = new CIIToUBL();
		String sourceFilename = "factur-x.xml";
		File UBLinputFile = getResourceAsFile("01.01a-INVOICE_ubl.xml");

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.visualize(UBLinputFile.getAbsolutePath(),ZUGFeRDVisualizer.Language.EN).replace("\r","").replace("\n","");

			File expectedResult=getResourceAsFile("factur-x-vis-ubl.en.html");
			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r","").replace("\n","");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: "+e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: "+e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: "+e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: "+e.getMessage());
		}



		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}

	public void testPDFVisualization() {

		// the writing part
		CIIToUBL c2u = new CIIToUBL();
		String sourceFilename = "factur-x.xml";
		File CIIinputFile = getResourceAsFile(sourceFilename);

		String expected = null;
		String result = null;
		try {
			ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
			result = zvi.toFOP(CIIinputFile.getAbsolutePath());
			File expectedResult=getResourceAsFile("fop.xml");
			ByteArrayOutputStream fopout = new ByteArrayOutputStream();
			//FileOutputStream outfile = new FileOutputStream("c:\\Users\\jstaerk\\temp\\fop2.pdf");
		//	File out=new File("c:\\Users\\jstaerk\\temp\\fop.xml");

// Step 1: Construct a FopFactory by specifying a reference to the configuration file
// (reuse if you plan to render multiple documents!)
			FopFactory fopFactory = FopFactory.newInstance(new File("c:\\Users\\jstaerk\\temp\\fop.xconf"));
			FOUserAgent userAgent = fopFactory.newFOUserAgent();
			userAgent.getRendererOptions().put("pdf-a-mode", "PDF/A-1b");

// Step 2: Set up output stream.
// Note: Using BufferedOutputStream for performance reasons (helpful with FileOutputStreams).
			OutputStream out = new BufferedOutputStream(new FileOutputStream(new File("c:\\Users\\jstaerk\\temp\\fop3.pdf")));

			try {
				// Step 3: Construct fop with desired output format
				Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, userAgent, out);

				// Step 4: Setup JAXP using identity transformer
				TransformerFactory factory = TransformerFactory.newInstance();
				Transformer transformer = factory.newTransformer(); // identity transformer

				// Step 5: Setup input and output for XSLT transformation
				// Setup input stream
				Source src = new StreamSource(new ByteArrayInputStream(result.getBytes(StandardCharsets.UTF_8)));

				// Resulting SAX events (the generated FO) must be piped through to FOP
				Result res = new SAXResult(fop.getDefaultHandler());

				// Step 6: Start XSLT transformation and FOP processing
				transformer.transform(src, res);

				//Files.write(Paths.get("C:\\Users\\jstaerk\\temp\\fop.pdf"), res.toString().getBytes(StandardCharsets.UTF_8));

			} finally {
				//Clean-up
				out.close();
			}

//			Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, fopout);
/*
			Transformer transformer = TransformerFactory.newInstance().newTransformer(
					new StreamSource(new File(args[1])));
			transformer.transform(new StreamSource(new File(args[0])),
					new SAXResult(((Fop) fop).getDefaultHandler()));
*/
		//	fopout.toByteArray();

			expected = new String(Files.readAllBytes(expectedResult.toPath()), StandardCharsets.UTF_8).replace("\r","").replace("\n","");
			// remove linebreaks as well...

		} catch (UnsupportedOperationException e) {
			fail("UnsupportedOperationException should not happen: "+e.getMessage());
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException should not happen: "+e.getMessage());
		} catch (TransformerException e) {
			fail("TransformerException should not happen: "+e.getMessage());
		} catch (IOException e) {
			fail("IOException should not happen: "+e.getMessage());
		} catch (FOPException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}

		assertNotNull(result);
		// Reading ZUGFeRD
		assertEquals(expected, result);
	}

}
