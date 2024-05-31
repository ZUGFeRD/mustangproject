/**
 * *********************************************************************
 * <p>
 * Copyright 2018 Jochen Staerk
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

import org.apache.fop.apps.*;
import org.apache.fop.apps.io.ResourceResolverFactory;
import org.apache.fop.configuration.Configuration;
import org.apache.fop.configuration.ConfigurationException;
import org.apache.fop.configuration.DefaultConfigurationBuilder;
import org.apache.xmlgraphics.util.MimeConstants;
import org.mustangproject.CII.CIIToUBL;
import org.mustangproject.ClasspathResolverURIAdapter;
import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
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
	private Templates mXsltPDFTemplate = null;
	private Templates mXsltZF1HTMLTemplate = null;

	public ZUGFeRDVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		// fact = TransformerFactory.newInstance();
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
	}

	public String visualize(String xmlFilename, Language lang)
			throws FileNotFoundException, TransformerException, UnsupportedEncodingException {

		try {
			if (mXsltXRTemplate == null) {
				mXsltXRTemplate = mFactory.newTemplates(
						new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cii-xr.xsl")));
			}
			if (mXsltPDFTemplate == null) {
				mXsltPDFTemplate = mFactory.newTemplates(
						new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xr-pdf.xsl")));
			}
			if (mXsltHTMLTemplate == null) {
				mXsltHTMLTemplate = mFactory.newTemplates(new StreamSource(
						CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xrechnung-html." + lang.name().toLowerCase() + ".xsl")));
			}
			if (mXsltZF1HTMLTemplate == null) {
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
		FileInputStream fis = new FileInputStream(xmlFilename);
		String fileContent = "";
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
		String ublCreditNoteSignature = "ubl:CreditNote";
		boolean doPostProcessing = false;
		if (fileContent.contains(zf1Signature)) {
			applyZF1XSLT(fis, baos);

		} else if (fileContent.contains(zf2Signature)) {

			//zf2 or fx
			applyZF2XSLT(fis, iaos);
			doPostProcessing = true;
		} else if (fileContent.contains(ublSignature)) {
			//zf2 or fx
			applyUBL2XSLT(fis, iaos);
			doPostProcessing = true;

		} else if (fileContent.contains(ublCreditNoteSignature)) {
			//zf2 or fx
			applyUBLCreditNote2XSLT(fis, iaos);
			doPostProcessing = true;

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

	protected String toFOP(String xmlFilename)
			throws FileNotFoundException, TransformerException, UnsupportedEncodingException {

		try {
			if (mXsltXRTemplate == null) {
				mXsltXRTemplate = mFactory.newTemplates(
						new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cii-xr.xsl")));
			}
			if (mXsltPDFTemplate == null) {
				mXsltPDFTemplate = mFactory.newTemplates(
						new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xr-pdf.xsl")));
			}
		} catch (TransformerConfigurationException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}

		FileInputStream fis = new FileInputStream(xmlFilename);
		String fileContent = "";
		try {
			fileContent = new String(Files.readAllBytes(Paths.get(xmlFilename)), StandardCharsets.UTF_8);
		} catch (IOException e2) {
			LOG.log(Level.SEVERE, null, e2);
		}

		ByteArrayOutputStream iaos = new ByteArrayOutputStream();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();

		//zf2 or fx
		applyZF2XSLT(fis, iaos);

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
			applyXSLTToPDF(in, baos);
		} catch (IOException e1) {
			LOG.log(Level.SEVERE, null, e1);
		}


		return baos.toString("UTF-8");
	}

	public void toPDF(String xmlFilename, String pdfFilename) {

		// the writing part
		CIIToUBL c2u = new CIIToUBL();
		String sourceFilename = "factur-x.xml";
		File CIIinputFile = new File(xmlFilename);

		String expected = null;
		String result = null;

		ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
		try {
			result = zvi.toFOP(CIIinputFile.getAbsolutePath());
		} catch (FileNotFoundException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		} catch (TransformerException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		} catch (UnsupportedEncodingException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		}
		/*
		FopConfParser parser = null;
		try {
			//parsing configuration
			parser = new FopConfParser(CLASS_LOADER.getResourceAsStream("fop-config.xconf"), new URI("file:///"));

		} catch (SAXException e) {
			throw new UncheckedIOException(new IOException(e));
		} catch (IOException e) {
			throw new UncheckedIOException(e);
		} catch (URISyntaxException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		}*/
//		FopFactoryBuilder builder = parser.getFopFactoryBuilder();
		DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder();

		Configuration cfg = null;
		try {
			cfg = cfgBuilder.build(CLASS_LOADER.getResourceAsStream("fop-config.xconf"));
		} catch (ConfigurationException e) {
			throw new RuntimeException(e);
		}

		FopFactoryBuilder builder = new FopFactoryBuilder(new File(".").toURI(), new ClasspathResolverURIAdapter()).setConfiguration(cfg);
// Step 1: Construct a FopFactory by specifying a reference to the configuration file
// (reuse if you plan to render multiple documents!)

		FopFactory fopFactory = builder.build();//FopFactory.newInstance(new File("c:\\Users\\jstaerk\\temp\\fop-config.xconf"));

		fopFactory.getFontManager().setResourceResolver(
			ResourceResolverFactory.createInternalResourceResolver(
				new File(".").toURI(),
				 new ClasspathResolverURIAdapter()));

		FOUserAgent userAgent = fopFactory.newFOUserAgent();

		userAgent.getRendererOptions().put("pdf-a-mode", "PDF/A-1b");

// Step 2: Set up output stream.
// Note: Using BufferedOutputStream for performance reasons (helpful with FileOutputStreams).

		try (OutputStream out = new BufferedOutputStream(new FileOutputStream(pdfFilename))) {

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

		} catch (FOPException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		} catch (TransformerConfigurationException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		} catch (IOException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		} catch (TransformerException e) {
			Logger.getLogger(ZUGFeRDVisualizer.class.getName()).log(Level.SEVERE, null, e);
		}


	}

	protected void applyZF2XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		Transformer transformer = mXsltXRTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	protected void applyUBL2XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		if (mXsltUBLTemplate == null) {
			mXsltUBLTemplate = mFactory.newTemplates(
					new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ubl-invoice-xr.xsl")));
		}
		Transformer transformer = mXsltUBLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	protected void applyUBLCreditNote2XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		if (mXsltUBLTemplate == null) {
			mXsltUBLTemplate = mFactory.newTemplates(
					new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ubl-creditnote-xr.xsl")));
		}
		Transformer transformer = mXsltUBLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	protected void applyZF1XSLT(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		Transformer transformer = mXsltZF1HTMLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	protected void applyXSLTToHTML(final InputStream xmlFile, final OutputStream HTMLOutstream)
			throws TransformerException {
		Transformer transformer = mXsltHTMLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	protected void applyXSLTToPDF(final InputStream xmlFile, final OutputStream PDFOutstream)
			throws TransformerException {
		Transformer transformer = mXsltPDFTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(PDFOutstream));
	}

	private static class ClasspathResourceURIResolver implements URIResolver {
		ClasspathResourceURIResolver() {
			// Do nothing, just prevents synthetic access warning.
		}

		@Override
		public Source resolve(String href, String base) throws TransformerException {
			return new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/" + href));
		}
	}
}
