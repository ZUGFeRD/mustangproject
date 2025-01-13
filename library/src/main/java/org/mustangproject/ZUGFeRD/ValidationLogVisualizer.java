package org.mustangproject.ZUGFeRD;

import org.apache.fop.apps.*;
import org.apache.fop.apps.io.ResourceResolverFactory;
import org.apache.fop.configuration.Configuration;
import org.apache.fop.configuration.ConfigurationException;
import org.apache.fop.configuration.DefaultConfigurationBuilder;
import org.apache.xmlgraphics.util.MimeConstants;
import org.mustangproject.ClasspathResolverURIAdapter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

public class ValidationLogVisualizer {
	private static final Logger LOGGER = LoggerFactory.getLogger(ValidationLogVisualizer.class);
	public static final String LOG_FO_XSL = "result-pdf.xsl";

	private final TransformerFactory mFactory;
	private final Map<String, Templates> mapOfTemplates = new LinkedHashMap<>();

	public ValidationLogVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		// fact = TransformerFactory.newInstance()
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
	}

	@SuppressWarnings("unused")
	public void toPDF(String xmlLogfileContent, String pdfFilename) {
		toPDF(xmlLogfileContent, pdfFilename, ELanguage.EN);
	}

	public void toPDF(String xmlLogfileContent, String pdfFilename, final ELanguage lang) {
		// the writing part
		String result = this.toFOP(xmlLogfileContent, lang);
		if (result == null) {
			throw new IllegalArgumentException("FOP cannot process XML content.");
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

	protected String toFOP(final String xmlContent, final ELanguage lang) {
		initTemplates();
		ByteArrayOutputStream outputStream;
		outputStream = applyXSLT(LOG_FO_XSL, new StringReader(xmlContent), lang);
		return outputStream != null ? outputStream.toString(StandardCharsets.UTF_8) : null;
	}

	private void initTemplates() {
		initTemplates(ClasspathResourceURIResolver.CUSTOM_BASE_PATH, LOG_FO_XSL);
	}

	@SuppressWarnings("SameParameterValue")
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

	@SuppressWarnings("SameParameterValue")
	protected ByteArrayOutputStream applyXSLT(final String fileName, final StringReader reader, final ELanguage lang) {
		ByteArrayOutputStream rv = new ByteArrayOutputStream();
		if (mapOfTemplates.containsKey(fileName)) {
			try {
				Templates templates = mapOfTemplates.get(fileName);
				Transformer transformer = templates.newTransformer();
				transformer.setParameter("lang", lang.name().toLowerCase());
				transformer.transform(new StreamSource(reader), new StreamResult(rv));
			} catch (TransformerException e) {
				LOGGER.error("Cannot apply transformation script '{}'.", fileName);
			}
		}
		return rv;
	}
}
