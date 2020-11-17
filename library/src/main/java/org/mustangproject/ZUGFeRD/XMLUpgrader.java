package org.mustangproject.ZUGFeRD;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;


/***
 * Uses a XSLT transformation to upgrade
 * from ZUGFeRD 1 to ZUGFeRD 2 (=Factur-X1 ˜= XRechnung)
 * This is an external functionality of the software and not very complete, for
 * internal operations (generation of ZF2) of course the ZF2PullProvider is used
 */
public class XMLUpgrader {

	static final ClassLoader CLASS_LOADER = XMLUpgrader.class.getClassLoader();
	private static final String RESOURCE_PATH = "";
	private TransformerFactory mFactory = null;
	private Templates mXsltTemplate = null;

	public XMLUpgrader() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		//fact = TransformerFactory.newInstance();
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
	}

	/***
	 * Takes a filename of a ZF1 XML file and returns the string of ZF2 XML
	 * @param xmlFilename the filename of the source
	 * @return String the updated XML
	 * @throws FileNotFoundException if the source could not be found
	 * @throws TransformerException if the source could not be transformed
	 * @throws UnsupportedEncodingException if the source was not utf8
	 */
	public String migrateFromV1ToV2(String xmlFilename) throws FileNotFoundException, TransformerException, UnsupportedEncodingException {
		/**
		 * *
		 * http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
		 * http://www.ferd-net.de/upload/Dokumente/FACTUR-X_ZUGFeRD_2p0_Teil1_Profil_EN16931_1p03.pdf
		 * http://countwordsfree.com/xmlviewer
		 */
		mXsltTemplate = mFactory.newTemplates(new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/ZF1ToZF2.xsl")));

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		applySchematronXsl(new FileInputStream(xmlFilename), baos);
		String res = null;
		res = baos.toString("UTF-8");
		return res;
	}

	protected void applySchematronXsl(final InputStream xmlFile,
								   final OutputStream EN16931Outstream) throws TransformerException {
		Transformer transformer = mXsltTemplate.newTransformer();
		transformer.transform(new StreamSource(xmlFile), new StreamResult(EN16931Outstream));
	}

	private static class ClasspathResourceURIResolver implements URIResolver {
		ClasspathResourceURIResolver() {
			// Do nothing, just prevents synthetic access warning.
		}

		@Override
		public Source resolve(String href, String base) throws TransformerException {
			return new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + href));
		}
	}
}
