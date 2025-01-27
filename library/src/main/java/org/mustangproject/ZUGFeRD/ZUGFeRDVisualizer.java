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

import com.helger.commons.io.stream.StreamHelper;
import org.apache.commons.io.IOUtils;
import org.apache.fop.apps.*;
import org.apache.fop.apps.io.ResourceResolverFactory;
import org.apache.fop.configuration.Configuration;
import org.apache.fop.configuration.ConfigurationException;
import org.apache.fop.configuration.DefaultConfigurationBuilder;
import org.apache.xmlgraphics.util.MimeConstants;
import org.mustangproject.ClasspathResolverURIAdapter;
import org.mustangproject.EStandard;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Consumer;
import java.util.function.Supplier;

public class ZUGFeRDVisualizer {

	public enum Language {
		EN,
		FR,
		DE
	}

	static final ClassLoader CLASS_LOADER = ZUGFeRDVisualizer.class.getClassLoader();
	private static final String RESOURCE_PATH = "";
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDVisualizer.class);
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
	private Templates mXsltCIOTemplate = null;
	private Templates mXsltHTMLTemplate = null;
	private Templates mXsltPDFTemplate = null;
	private Templates mXsltZF1HTMLTemplate = null;

	public ZUGFeRDVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		// fact = TransformerFactory.newInstance();
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
	}

	/***
	 * returns which standard is used, CII or UBL
	 * @param fis inputstream (will be consumed)
	 * @return (facturx = cii)
	 */
	private EStandard findOutStandardFromRootNode(InputStream fis) {

		String zf1Signature = "CrossIndustryDocument";
		String zf2Signature = "CrossIndustryInvoice";
		String ublSignature = "Invoice";
		String ublCreditNoteSignature = "CreditNote";
		String cioSignature = "SCRDMCCBDACIOMessageStructure";

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(new InputSource(fis));
			Element root = doc.getDocumentElement();
			if (root.getLocalName().equals(zf1Signature)) {
				return EStandard.zugferd;
			} else if (root.getLocalName().equals(zf2Signature)) {
				return EStandard.facturx;
			} else if (root.getLocalName().equals(ublSignature)) {
				return EStandard.ubl;
			} else if (root.getLocalName().equals(ublCreditNoteSignature)) {
				return EStandard.ubl_creditnote;
			} else if (root.getLocalName().equals(cioSignature)) {
				return EStandard.orderx;
			}
		} catch (Exception e) {
			LOGGER.error("Failed to recognize standard", e);
		}
		return null;
	}

	public String visualize(String xmlFilename, Language lang) throws IOException, TransformerException {
		FileInputStream fis = new FileInputStream(xmlFilename);
		return visualize(fis, lang);
	}

	public String visualize(InputStream inputXml, Language lang) throws IOException, TransformerException {
		initTemplates(lang);

		String fileContent = new String(IOUtils.toByteArray(inputXml), StandardCharsets.UTF_8);
		EStandard thestandard = findOutStandardFromRootNode(new ByteArrayInputStream(fileContent.getBytes(StandardCharsets.UTF_8)));
		ByteArrayOutputStream htmlOutput = new ByteArrayOutputStream();


		ByteArrayInputStream xmlContentStream = new ByteArrayInputStream(fileContent.getBytes(StandardCharsets.UTF_8));

		if (thestandard == EStandard.zugferd) {
			applyZF1XSLT(xmlContentStream, htmlOutput);
			return htmlOutput.toString(StandardCharsets.UTF_8);
		} else if (thestandard == EStandard.facturx) {
			//zf2 or fx
			applyZF2XSLT(xmlContentStream, htmlOutput);
		} else if (thestandard == EStandard.ubl) {
			//zf2 or fx
			applyUBL2XSLT(xmlContentStream, htmlOutput);
		} else if (thestandard == EStandard.ubl_creditnote) {
			//zf2 or fx
			applyUBLCreditNote2XSLT(xmlContentStream, htmlOutput);
		} else if (thestandard == EStandard.orderx) {
			//zf2 or fx
			applyCIO2XSLT(xmlContentStream, htmlOutput);
		} else {
			throw new IllegalArgumentException("File does not look like CII or UBL");
		}
		Optional<InputStream> in = copyStream(htmlOutput);
		ByteArrayOutputStream htmlOutStream = new ByteArrayOutputStream();
		if (in.isPresent()) {
			applyXSLTToHTML(in.get(), htmlOutStream);
		}

		return htmlOutStream.toString(StandardCharsets.UTF_8);
	}

	/**
	 * TODO: jstaerk: why not copy with that simple call: new ByteArrayInputStream(byteArrayOutputStream.toByteArray()) ?
	 */
	private Optional<InputStream> copyStream(ByteArrayOutputStream byteArrayOutputStream) {
		// take the copy of the stream and re-write it to an InputStream
		PipedInputStream in = new PipedInputStream();
		try {
			PipedOutputStream out = new PipedOutputStream(in);
			new Thread(() -> {
				try {
					// write the original OutputStream to the PipedOutputStream
					// note that in order for the below method to work, you need
					// to ensure that the data has finished writing to the
					// ByteArrayOutputStream
					byteArrayOutputStream.writeTo(out);
				} catch (IOException e) {
					LOGGER.error("Failed to write to stream", e);
				} finally {
					// close the PipedOutputStream here because we're done writing data
					// once this thread has completed its run
					StreamHelper.close(out);
				}
			}).start();
		} catch (IOException e1) {
			LOGGER.error("Failed to create HTML", e1);
			return Optional.empty();
		}
		return Optional.of(in);
	}


	private void initTemplates(Language lang) throws TransformerConfigurationException {
		if (mXsltXRTemplate == null) {
			mXsltXRTemplate = mFactory.newTemplates(
				new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cii-xr.xsl")));
		}

		if (mXsltHTMLTemplate == null) {
			mXsltHTMLTemplate = mFactory.newTemplates(new StreamSource(
				CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xrechnung-html." + lang.name().toLowerCase() + ".xsl")));
		}
		if (mXsltZF1HTMLTemplate == null) {
			mXsltZF1HTMLTemplate = mFactory.newTemplates(new StreamSource(
				CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ZUGFeRD_1p0_c1p0_s1p0.xslt")));
		}
	}

	protected String toFOP(String xmlFilename)
		throws IOException, TransformerException {

		FileInputStream fis = new FileInputStream(xmlFilename);
		EStandard theStandard = findOutStandardFromRootNode(fis);
		fis = new FileInputStream(xmlFilename);//rewind :-(

		return toFOP(fis, theStandard);
	}

	protected String toFOP(InputStream is, EStandard theStandard)
		throws TransformerException, IOException {

		try {
			if (mXsltPDFTemplate == null) {
				mXsltPDFTemplate = mFactory.newTemplates(
					new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xr-pdf.xsl")));
			}
		} catch (TransformerConfigurationException ex) {
			LOGGER.error("Failed to init XSLT templates", ex);
		}

		ByteArrayOutputStream iaos = new ByteArrayOutputStream();

		//zf2 or fx
		if (theStandard == EStandard.facturx) {
			applyZF2XSLT(is, iaos);
		} else if (theStandard == EStandard.ubl) {
			applyUBL2XSLT(is, iaos);
		} else if (theStandard == EStandard.ubl_creditnote) {
			applyUBLCreditNote2XSLT(is, iaos);
		}


		Optional<InputStream> in = copyStream(iaos);
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		if (in.isPresent()) {
			applyXSLTToPDF(in.get(), baos);
		}
		return baos.toString(StandardCharsets.UTF_8);
	}

	public void toPDF(String xmlFilename, String pdfFilename) {

		// the writing part
		File XMLinputFile = new File(xmlFilename);

		String fopInput = null;

			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
		try {
			fopInput = this.toFOP(XMLinputFile.getAbsolutePath());
		} catch (TransformerException | IOException e) {
			LOGGER.error("Failed to apply FOP", e);
		}
		
		toPDFfromFOP(fopInput, () -> {
				try {
					return new FileOutputStream(pdfFilename);
				} catch (FileNotFoundException e) {
					LOGGER.error("Failed to create PDF", e);
				}
			return null;
		}, (OutputStream out) -> {});
	}
	
	public byte[] toPDF(String xmlContent) {

		String fopInput = null;

			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
		try {
			ByteArrayInputStream fis = new ByteArrayInputStream(xmlContent.getBytes(StandardCharsets.UTF_8));
			EStandard theStandard = findOutStandardFromRootNode(fis);
			fis = new ByteArrayInputStream(xmlContent.getBytes(StandardCharsets.UTF_8));//rewind :-(
			
			fopInput = toFOP(fis, theStandard);
		} catch (TransformerException | IOException e) {
			LOGGER.error("Failed to apply FOP", e);
		}

		AtomicReference<byte[]> byteHolder = new AtomicReference<>();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		toPDFfromFOP(fopInput, () -> new BufferedOutputStream(os), (OutputStream out) -> {
			
			try {
				out.flush();
			} catch (IOException e) {
				LOGGER.error("Failed to create PDF", e);
			}
			byteHolder.set(os.toByteArray());
		});
		
		return byteHolder.get();
	}
	
	private void toPDFfromFOP(String fopInput, Supplier<OutputStream> outputStreamDelegate, Consumer<OutputStream> consumerDelegate) {

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

		userAgent.getRendererOptions().put("pdf-a-mode", "PDF/A-3b");

// Step 2: Set up output stream.
// Note: Using BufferedOutputStream for performance reasons (helpful with FileOutputStreams).

		try (OutputStream out = new BufferedOutputStream(outputStreamDelegate.get())) {

			// Step 3: Construct fop with desired output format
			Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, userAgent, out);

			// Step 4: Setup JAXP using identity transformer
			TransformerFactory factory = TransformerFactory.newInstance();
			Transformer transformer = factory.newTransformer(); // identity transformer

			// Step 5: Setup input and output for XSLT transformation
			// Setup input stream
			Source src = new StreamSource(new ByteArrayInputStream(fopInput.getBytes(StandardCharsets.UTF_8)));

			// Resulting SAX events (the generated FO) must be piped through to FOP
			Result res = new SAXResult(fop.getDefaultHandler());

			// Step 6: Start XSLT transformation and FOP processing
			transformer.transform(src, res);
			
			consumerDelegate.accept(out);

		} catch (FOPException | IOException | TransformerException e) {
			LOGGER.error("Failed to create PDF", e);
		}
	}

	protected void applyZF2XSLT(final InputStream xmlFile, final OutputStream htmlOutStream)
		throws TransformerException {
		if (mXsltXRTemplate == null) {
			mXsltXRTemplate = mFactory.newTemplates(
				new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cii-xr.xsl")));

		}
		Transformer transformer = mXsltXRTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(htmlOutStream));
	}

	protected void applyCIO2XSLT(final InputStream xmlFile, final OutputStream htmlOutstream)
		throws TransformerException {
		if (mXsltCIOTemplate == null) {
			mXsltCIOTemplate = mFactory.newTemplates(
				new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cio-xr.xsl")));
		}
		Transformer transformer = mXsltCIOTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(htmlOutstream));
	}

	protected void applyUBL2XSLT(final InputStream xmlFile, final OutputStream htmlOutStream)
		throws TransformerException {
		if (mXsltUBLTemplate == null) {
			mXsltUBLTemplate = mFactory.newTemplates(
				new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ubl-invoice-xr.xsl")));
		}
		Transformer transformer = mXsltUBLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(htmlOutStream));
	}

	protected void applyUBLCreditNote2XSLT(final InputStream xmlFile, final OutputStream htmlOutStream)
		throws TransformerException {
		if (mXsltUBLTemplate == null) {
			mXsltUBLTemplate = mFactory.newTemplates(
				new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ubl-creditnote-xr.xsl")));
		}
		Transformer transformer = mXsltUBLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(htmlOutStream));
	}

	protected void applyZF1XSLT(final InputStream xmlFile, final OutputStream htmlOutStream)
		throws TransformerException {
		Transformer transformer = mXsltZF1HTMLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(htmlOutStream));
	}

	protected void applyXSLTToHTML(final InputStream xmlFile, final OutputStream htmlOutStream)
		throws TransformerException, IOException {
		Transformer transformer = mXsltHTMLTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(htmlOutStream));
		xmlFile.close();
	}

	protected void applyXSLTToPDF(final InputStream xmlFile, final OutputStream PDFOutstream)
		throws TransformerException, IOException {
		Transformer transformer = mXsltPDFTemplate.newTransformer();

		transformer.transform(new StreamSource(xmlFile), new StreamResult(PDFOutstream));
		xmlFile.close();
	}

	private static class ClasspathResourceURIResolver implements URIResolver {
		ClasspathResourceURIResolver() {
			// Do nothing, just prevents synthetic access warning.
		}

		@Override
		public Source resolve(String href, String base) {
			return new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/" + href));
		}
	}
}
