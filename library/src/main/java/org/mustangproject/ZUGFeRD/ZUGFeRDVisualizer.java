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
import org.mustangproject.ClasspathResolverURIAdapter;
import org.mustangproject.EStandard;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

public class ZUGFeRDVisualizer {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDVisualizer.class);

	private static final String CANNOT_OPEN_XML_FILE = "Cannot open XML file '{}'.";
	private static final String CII_XR_XSL = "cii-xr.xsl";
	private static final String CIO_XR_XSL = "cio-xr.xsl";
	private static final String UBL_CREDIT_NOTE_XR_XSL = "ubl-creditnote-xr.xsl";
	private static final String UBL_INVOICE_XR_XSL = "ubl-invoice-xr.xsl";
	private static final String XR_HTML_XSL = "xrechnung-html.xsl";
	private static final String XR_PDF_XSL = "xr-pdf.xsl";
	private static final String ZF1_HTML_XSL = "ZUGFeRD_1p0_c1p0_s1p0.xslt";

	private final TransformerFactory mFactory;
	private final Map<String, Templates> mapOfTemplates = new LinkedHashMap<>();

	private EStandard eStandard;

	public ZUGFeRDVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		// fact = TransformerFactory.newInstance()
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
	}

	public String visualize(String xmlFilename, ELanguage lang)
			throws IOException, TransformerException {
		String rv = null;
		eStandard = getEStandard(xmlFilename);
		try (FileInputStream fis = new FileInputStream(xmlFilename)) {
			rv = visualize(fis, lang);
		} catch (IOException | SecurityException e) {
			LOGGER.error(CANNOT_OPEN_XML_FILE, xmlFilename);
		}
		return rv;
	}

	public String visualize(InputStream inputStream, ELanguage lang) {
		initTemplates();
		ByteArrayOutputStream outputStream;
		switch (eStandard) {
			case zugferd:
				outputStream = applyXSLT(ZF1_HTML_XSL, inputStream);
				break;
			case orderx:
				outputStream = applyXSLT(CIO_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_HTML_XSL, outputStream, lang);
				break;
			case facturx:
				outputStream = applyXSLT(CII_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_HTML_XSL, outputStream, lang);
				break;
			case ubl:
				outputStream = applyXSLT(UBL_INVOICE_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_HTML_XSL, outputStream, lang);
				break;
			case ubl_creditnote:
				outputStream = applyXSLT(UBL_CREDIT_NOTE_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_HTML_XSL, outputStream, lang);
				break;
			default:
				throw new IllegalArgumentException(String.format("Cannot process doc type '%s'.", eStandard));
		}
		return outputStream != null ? outputStream.toString(StandardCharsets.UTF_8) : null;
	}

	/***
	 * @param path to XML file
	 * @return EStandard
	 */
	private EStandard getEStandard(final String path) {
		EStandard rv;
		String localName = getRootName(path);
		switch (localName) {
			case "CrossIndustryDocument":
				rv = EStandard.zugferd;
				break;
			case "CrossIndustryInvoice":
				rv = EStandard.facturx;
				break;
			case "Invoice":
				rv = EStandard.ubl;
				break;
			case "CreditNote":
				rv = EStandard.ubl_creditnote;
				break;
			case "SCRDMCCBDACIOMessageStructure":
				rv = EStandard.orderx;
				break;
			default:
				LOGGER.error("Unknown document type '{}'.", localName);
				rv = null;
				break;
		}
		return rv;
	}

	private String getRootName(final String path) {
		String rv = "";
		try (FileInputStream fis = new FileInputStream(path)) {
			rv = getRootName(fis);
		} catch (IOException | SecurityException e) {
			LOGGER.error(CANNOT_OPEN_XML_FILE, path);
		}
		return rv;
	}

	private String getRootName(final InputStream inputStream) {
		String rv = "";
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			dbf.setNamespaceAware(true);
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(new InputSource(inputStream));
			Element root = doc.getDocumentElement();
			rv = root.getLocalName();
		} catch (ParserConfigurationException | SAXException | IOException e) {
			LOGGER.error("Cannot parse XML file.", e);
		}
		return rv;
	}

	private void initTemplates() {
		initTemplates(ClasspathResourceURIResolver.CUSTOM_BASE_PATH, CIO_XR_XSL);
		initTemplates(ClasspathResourceURIResolver.MAIN_BASE_PATH, CII_XR_XSL);
		initTemplates(ClasspathResourceURIResolver.MAIN_BASE_PATH, UBL_CREDIT_NOTE_XR_XSL);
		initTemplates(ClasspathResourceURIResolver.MAIN_BASE_PATH, UBL_INVOICE_XR_XSL);
		initTemplates(ClasspathResourceURIResolver.MAIN_BASE_PATH, XR_PDF_XSL);
		initTemplates(ClasspathResourceURIResolver.MAIN_BASE_PATH, XR_HTML_XSL);
		initTemplates(ClasspathResourceURIResolver.ZF10_BASE_PATH, ZF1_HTML_XSL);
	}

	private void initTemplates(final String basePath, final String fileName) {
		if (!mapOfTemplates.containsKey(fileName)) {
			try {
				mapOfTemplates.put(
						fileName,
						mFactory.newTemplates(
								ClasspathResourceURIResolver.getSource(basePath + fileName)
						)
				);
			} catch (TransformerConfigurationException e) {
				LOGGER.error("Cannot retrieve transformation script '{}'.", fileName);
			}
		}
	}

	protected ByteArrayOutputStream applyXSLT(final String fileName, final InputStream inputStream) {
		ByteArrayOutputStream rv = new ByteArrayOutputStream();
		if (mapOfTemplates.containsKey(fileName)) {
			try {
				Templates templates = mapOfTemplates.get(fileName);
				Transformer transformer = templates.newTransformer();
				transformer.transform(new StreamSource(inputStream), new StreamResult(rv));
			} catch (TransformerException e) {
				LOGGER.error("Cannot apply 1st pass transformation script '{}'.", fileName);
			}
		}
		return rv;
	}

	protected ByteArrayOutputStream applyXSLT(final String fileName, final ByteArrayOutputStream outputStream, final ELanguage lang) {
		return applyXSLT(fileName, new ByteArrayInputStream(outputStream.toByteArray()), lang);
	}

	protected ByteArrayOutputStream applyXSLT(final String fileName, final InputStream inputStream, final ELanguage lang) {
		ByteArrayOutputStream rv = new ByteArrayOutputStream();
		if (mapOfTemplates.containsKey(fileName)) {
			try {
				Templates templates = mapOfTemplates.get(fileName);
				Transformer transformer = templates.newTransformer();
				transformer.setParameter("lang", lang.name().toLowerCase());
				transformer.transform(new StreamSource(inputStream), new StreamResult(rv));
			} catch (TransformerException e) {
				LOGGER.error("Cannot apply 2nd pass transformation script '{}'.", fileName);
			}
		}
		return rv;
	}

	public void toPDF(String xmlFilename, String pdfFilename) {
		toPDF(xmlFilename, pdfFilename, ELanguage.EN);
	}

	public void toPDF(String xmlFilename, String pdfFilename, final ELanguage lang) {
		// the writing part
		File xmlFile = new File(xmlFilename);
		String result = this.toFOP(xmlFile.getAbsolutePath(), lang);
		if (result == null) {
			throw new IllegalArgumentException(String.format("FOP cannot process XML file '%s'.", xmlFilename));
		}
		DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder();
		Configuration cfg;
		try {
			cfg = cfgBuilder.build(ClasspathResourceURIResolver.CLASS_LOADER.getResourceAsStream("fop-config.xconf"));
		} catch (ConfigurationException e) {
			throw new IllegalArgumentException("Cannot parse FOP configuration.", e);
		}
		FopFactoryBuilder builder = new FopFactoryBuilder(new File(".").toURI(), new ClasspathResolverURIAdapter()).setConfiguration(cfg);
		// Step 1: Construct a FopFactory by specifying a reference to the configuration file
		// (reuse if you plan to render multiple documents!)
		FopFactory fopFactory = builder.build();
		// FopFactory.newInstance(new File("c:\\Users\\jstaerk\\temp\\fop-config.xconf"))
		fopFactory.getFontManager().setResourceResolver(
				ResourceResolverFactory.createInternalResourceResolver(
						new File(".").toURI(),
						new ClasspathResolverURIAdapter()));
		FOUserAgent userAgent = fopFactory.newFOUserAgent();
		userAgent.getRendererOptions().put("pdf-a-mode", "PDF/A-3b");
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
		} catch (FOPException | IOException | TransformerException e) {
			LOGGER.error("Failed to create PDF", e);
		}
	}

	protected String toFOP(final String path, final ELanguage lang) {
		String rv = null;
		eStandard = getEStandard(path);
		try (FileInputStream fis = new FileInputStream(path)) {
			rv = toFOP(fis, lang);
		} catch (IOException | SecurityException e) {
			LOGGER.error(CANNOT_OPEN_XML_FILE, path);
		}
		return rv;
	}

	protected String toFOP(InputStream inputStream, final ELanguage lang) {
		initTemplates();
		ByteArrayOutputStream outputStream;
		switch (eStandard) {
			case facturx:
				outputStream = applyXSLT(CII_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_PDF_XSL, outputStream, lang);
				break;
			case ubl:
				outputStream = applyXSLT(UBL_INVOICE_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_PDF_XSL, outputStream, lang);
				break;
			case ubl_creditnote:
				outputStream = applyXSLT(UBL_CREDIT_NOTE_XR_XSL, inputStream);
				outputStream = applyXSLT(XR_PDF_XSL, outputStream, lang);
				break;
			default:
				throw new IllegalArgumentException(String.format("Cannot process doc type '%s'.", eStandard));
		}
		return outputStream != null ? outputStream.toString(StandardCharsets.UTF_8) : null;
	}
}
