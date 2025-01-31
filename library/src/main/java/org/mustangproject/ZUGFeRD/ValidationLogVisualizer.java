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

public class ValidationLogVisualizer {
	public enum Language {
		EN,
		FR,
		DE
	}

	static final ClassLoader CLASS_LOADER = ValidationLogVisualizer.class.getClassLoader();
	private static final String RESOURCE_PATH = "";
	private static final Logger LOGGER = LoggerFactory.getLogger(ValidationLogVisualizer.class);

	private TransformerFactory mFactory = null;
	private Templates mXsltPDFTemplate = null;


	public ValidationLogVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		// fact = TransformerFactory.newInstance();
		mFactory.setURIResolver(new ValidationLogVisualizer.ClasspathResourceURIResolver());
	}

	protected void applyXSLTToPDF(final String xmlContent, final OutputStream PDFOutstream)
		throws TransformerException {
		Transformer transformer = mXsltPDFTemplate.newTransformer();

		transformer.transform(new StreamSource(new StringReader(xmlContent)), new StreamResult(PDFOutstream));
	}

	protected String toFOP(final String xmlContent)
		throws TransformerException {

		try {
			if (mXsltPDFTemplate == null) {
				mXsltPDFTemplate = mFactory.newTemplates(
					new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/result-pdf.xsl")));
			}
		} catch (TransformerConfigurationException ex) {
			LOGGER.error("Failed to init XSLT templates", ex);
		}

		ByteArrayOutputStream baos = new ByteArrayOutputStream();

		try {

			applyXSLTToPDF(xmlContent, baos);

		} catch (Exception e1) {
			LOGGER.error("Failed to create PDF", e1);
		}

		return baos.toString(StandardCharsets.UTF_8);
	}

	public void toPDF(String xmlLogfileContent, String pdfFilename) {

		// the writing part

		String result = null;

			/* remove file endings so that tests can also pass after checking
			   out from git with arbitrary options (which may include CSRF changes)
			 */
		try {
			result = this.toFOP(xmlLogfileContent);
		} catch ( TransformerException e) {
			LOGGER.error("Failed to apply FOP", e);
		}
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
