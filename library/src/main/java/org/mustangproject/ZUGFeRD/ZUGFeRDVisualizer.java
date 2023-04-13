/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
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

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ZUGFeRDVisualizer {

	public enum Language {
		EN,
		FR,
		DE
	}
	static final ClassLoader CLASS_LOADER = ZUGFeRDVisualizer.class.getClassLoader();
	private static final String RESOURCE_PATH = "";
	private static final Logger LOG = Logger.getLogger(ZUGFeRDVisualizer.class.getName());
	// private static File createTempFileResult(final Transformer transformer, final
	// StreamSource toTransform,
	// final String suffix) throws TransformerException, IOException {
	// File result = File.createTempFile("ZUV_", suffix);
	// result.deleteOnExit();
	//
	// try (FileOutputStream fos = new FileOutputStream(result)) {
	// transformer.transform(toTransform, new StreamResult(fos));
	// }
	// return result;
	// }
	private TransformerFactory mFactory = null;
	private Templates mXsltXRTemplate = null;
	private Templates mXsltUBLTemplate = null;
	private Templates mXsltHTMLTemplate = null;
	private Templates mXsltZF1HTMLTemplate = null;

	public ZUGFeRDVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		// fact = TransformerFactory.newInstance();
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
	}

	public String visualize(String xmlFilename, Language lang)
			throws FileNotFoundException, TransformerException, UnsupportedEncodingException {

		try {
			if (mXsltXRTemplate==null) {
				mXsltXRTemplate = mFactory.newTemplates(
						new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cii-xr.xsl")));
			}
			mXsltHTMLTemplate = mFactory.newTemplates(new StreamSource(
					CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xrechnung-html."+lang.name().toLowerCase()+".xsl")));
			if (mXsltZF1HTMLTemplate==null) {
				mXsltZF1HTMLTemplate = mFactory.newTemplates(new StreamSource(
						CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ZUGFeRD_1p0_c1p0_s1p0.xslt")));
			}
		} catch (TransformerConfigurationException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}

		/**
		 * *
		 * http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
		 * http://www.ferd-net.de/upload/Dokumente/FACTUR-X_ZUGFeRD_2p0_Teil1_Profil_EN16931_1p03.pdf
		 * http://countwordsfree.com/xmlviewer
		 */
		FileInputStream fis=new FileInputStream(xmlFilename);
		String fileContent="";
		try {
			fileContent = new String(Files.readAllBytes(Paths.get(xmlFilename)), StandardCharsets.UTF_8);
		} catch (IOException e2) {
			LOG.log(Level.SEVERE, null, e2);
		}
		
		ByteArrayOutputStream iaos = new ByteArrayOutputStream();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();

		String zf1Signature = "rsm:CrossIndustryDocument";
		String zf2Signature = "rsm:CrossIndustryInvoice";
		String ublSignature = "ubl:Invoice";
		boolean doPostProcessing=false;
		if (fileContent.contains(zf1Signature)) {
			applyZF1XSLT(fis, baos);

		} else if (fileContent.contains(zf2Signature)) {

			//zf2 or fx
			applyZF2XSLT(fis, iaos);
			doPostProcessing=true;
		} else if (fileContent.contains(ublSignature)) {
			//zf2 or fx
			applyUBL2XSLT(fis, iaos);
			doPostProcessing=true;

		}
		if (doPostProcessing) {
			// take the copy of the stream and re-write it to an InputStream
			PipedInputStream in = new PipedInputStream();
			PipedOutputStream out;
			try {
				out = new PipedOutputStream(in);
				new Thread(new Runnable() {
					public void run() {
						try {
							// write the original OutputStream to the PipedOutputStream
							// note that in order for the below method to work, you need
							// to ensure that the data has finished writing to the
							// ByteArrayOutputStream
							iaos.writeTo(out);
						} catch (IOException e) {
							LOG.log(Level.SEVERE, null, e);
						} finally {
							// close the PipedOutputStream here because we're done writing data
							// once this thread has completed its run
							if (out != null) {
								// close the PipedOutputStream cleanly
								try {
									out.close();
								} catch (IOException e) {
									// TODO Auto-generated catch block
									LOG.log(Level.SEVERE, null, e);
								}
							}
						}
					}
				}).start();
				applyXSLTToHTML(in, baos);
			} catch (IOException e1) {
				LOG.log(Level.SEVERE, null, e1);
			}

		}
		
		return baos.toString("UTF-8");
	}

	public void applyZF2XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		Transformer transformer = mXsltXRTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	public void applyUBL2XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		if (mXsltUBLTemplate==null) {
			mXsltUBLTemplate = mFactory.newTemplates(
					new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ubl-invoice-xr.xsl")));
		}
		Transformer transformer = mXsltUBLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	public void applyZF1XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		Transformer transformer = mXsltZF1HTMLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	public void applyXSLTToHTML(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		Transformer transformer = mXsltHTMLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	private static class ClasspathResourceURIResolver implements URIResolver {
		ClasspathResourceURIResolver() {
			// Do nothing, just prevents synthetic access warning.
		}

		@Override
		public Source resolve(String href, String base) throws TransformerException {
			return new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH +"stylesheets/"+ href));
		}
	}
}
