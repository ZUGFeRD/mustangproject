package org.mustangproject.validator;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;


public class SchematronPipeline {
	static final ClassLoader cl = SchematronPipeline.class.getClassLoader();
	private static final TransformerFactory factory = getTransformerFactory();
	private static final String xslExt = ".xsl";
	private static final String resourcePath = "iso-schematron-xslt2/";
	private static final String isoDsdlXsl = resourcePath + "iso_dsdl_include" + xslExt;
	private static final String isoExpXsl = resourcePath + "iso_abstract_expand" + xslExt;
	private static final String isoSvrlXsl = resourcePath + "iso_svrl_for_xslt2" + xslExt;
	private static final Templates cachedIsoDsdXsl = createCachedTransform(isoDsdlXsl);
	private static final Templates cachedExpXsl = createCachedTransform(isoExpXsl);
	private static final Templates cachedIsoSvrlXsl = createCachedTransform(isoSvrlXsl);

	private static TransformerFactory getTransformerFactory() {
		TransformerFactory fact = TransformerFactory.newInstance();
		fact.setURIResolver(new ClasspathResourceURIResolver());
		return fact;
	}

	static Templates createCachedTransform(final String transName) {
		try {
			return factory.newTemplates(new StreamSource(cl.getResourceAsStream(transName)));
		} catch (TransformerConfigurationException excep) {
			throw new IllegalStateException("Policy Schematron transformer XSL " + transName + " not found.", excep); //$NON-NLS-2$
		}
	}

	public static void processSchematron(InputStream schematronSource, OutputStream xslDest)
			throws TransformerException, IOException {
		File isoDsdResult = createTempFileResult(cachedIsoDsdXsl.newTransformer(), new StreamSource(schematronSource),
				"IsoDsd");
		File isoExpResult = createTempFileResult(cachedExpXsl.newTransformer(), new StreamSource(isoDsdResult),
				"ExpXsl");
		cachedIsoSvrlXsl.newTransformer().transform(new StreamSource(isoExpResult), new StreamResult(xslDest));
		isoDsdResult.delete();
		isoExpResult.delete();
	}

	private static File createTempFileResult(final Transformer transformer, final StreamSource toTransform,
			final String suffix) throws TransformerException, IOException {
		File result = File.createTempFile("ZUV_", suffix);
		result.deleteOnExit();

		try (FileOutputStream fos = new FileOutputStream(result)) {
			transformer.transform(toTransform, new StreamResult(fos));
		}
		return result;
	}
	
	private static class ClasspathResourceURIResolver implements URIResolver {
		ClasspathResourceURIResolver() {
			// Do nothing, just prevents synthetic access warning.
		}

		@Override
		public Source resolve(String href, String base) throws TransformerException {
			return new StreamSource(cl.getResourceAsStream(resourcePath + href));
		}
	}
	
	public static void applySchematronXsl(final InputStream xmlFile,
			final OutputStream policyReport) throws TransformerException {
		Transformer transformer = factory.newTransformer(new StreamSource(cl.getResourceAsStream(resourcePath+"ZUGFeRDSchematronStylesheetXSLT1.xsl")));
		transformer.transform(new StreamSource(xmlFile), new StreamResult(policyReport));
	}
}
