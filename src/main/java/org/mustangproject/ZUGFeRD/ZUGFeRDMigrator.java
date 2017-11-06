package org.mustangproject.ZUGFeRD;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;



public class ZUGFeRDMigrator {
	static final ClassLoader cl = ZUGFeRDMigrator.class.getClassLoader();
	private static TransformerFactory factory = null;
	private static final String resourcePath = ""; //$NON-NLS-1$

	private static TransformerFactory getTransformerFactory() {
		//TransformerFactory fact = new net.sf.saxon.TransformerFactoryImpl();
		TransformerFactory fact = TransformerFactory.newInstance();
		fact.setURIResolver(new ClasspathResourceURIResolver());
		return fact;
	}
	public String migrateFromV1ToV2(String xmlFilename) {
/***
 * http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
 * http://www.ferd-net.de/upload/Dokumente/FACTUR-X_ZUGFeRD_2p0_Teil1_Profil_EN16931_1p03.pdf
http://countwordsfree.com/xmlviewer
 */
		ByteArrayOutputStream baos=new ByteArrayOutputStream();
		try {
			applySchematronXsl(new FileInputStream(xmlFilename), baos);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String res=null;
		try {
			res=baos.toString("UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}

	private static File createTempFileResult(final Transformer transformer, final StreamSource toTransform,
			final String suffix) throws TransformerException, IOException {
		File result = File.createTempFile("ZUV_", suffix); //$NON-NLS-1$
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
			final OutputStream EN16931Outstream) throws TransformerException {
		factory=getTransformerFactory();
		Transformer transformer = factory.newTransformer(new StreamSource(cl.getResourceAsStream(resourcePath+"COMFORTtoEN16931.xsl")));
		transformer.transform(new StreamSource(xmlFile), new StreamResult(EN16931Outstream));
	}

}
