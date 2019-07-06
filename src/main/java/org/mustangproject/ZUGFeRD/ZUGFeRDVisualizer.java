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
import java.util.logging.Level;
import java.util.logging.Logger;

public class ZUGFeRDVisualizer {

	static final ClassLoader CLASS_LOADER = ZUGFeRDVisualizer.class.getClassLoader();
	private static final String RESOURCE_PATH = ""; //$NON-NLS-1$
	private static final Logger LOG = Logger.getLogger(ZUGFeRDVisualizer.class.getName());
	//    private static File createTempFileResult(final Transformer transformer, final StreamSource toTransform,
//            final String suffix) throws TransformerException, IOException {
//        File result = File.createTempFile("ZUV_", suffix); //$NON-NLS-1$
//        result.deleteOnExit();
//
//        try (FileOutputStream fos = new FileOutputStream(result)) {
//            transformer.transform(toTransform, new StreamResult(fos));
//        }
//        return result;
//    }
	private TransformerFactory mFactory = null;
	private Templates mXsltXRTemplate = null;
	private Templates mXsltHTMLTemplate = null;

	public ZUGFeRDVisualizer() {
		mFactory = new net.sf.saxon.TransformerFactoryImpl();
		//fact = TransformerFactory.newInstance();
		mFactory.setURIResolver(new ClasspathResourceURIResolver());
		try {
			mXsltXRTemplate = mFactory.newTemplates(new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/cii-xr.xsl")));
			mXsltHTMLTemplate = mFactory.newTemplates(new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "stylesheets/xrechnung-html.xsl")));
		} catch (TransformerConfigurationException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}
	}

	public String visualize(String xmlFilename) throws FileNotFoundException, TransformerException, UnsupportedEncodingException {
		/**
		 * *
		 * http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
		 * http://www.ferd-net.de/upload/Dokumente/FACTUR-X_ZUGFeRD_2p0_Teil1_Profil_EN16931_1p03.pdf
		 * http://countwordsfree.com/xmlviewer
		 */
		ByteArrayOutputStream iaos = new ByteArrayOutputStream();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		applySchematronXsl(new FileInputStream(xmlFilename), iaos);
		// take the copy of the stream and re-write it to an InputStream
		PipedInputStream in = new PipedInputStream();
		PipedOutputStream out;
		try {
			out = new PipedOutputStream(in);
		new Thread(new Runnable() {
		    public void run () {
		        try {
		            // write the original OutputStream to the PipedOutputStream
		            // note that in order for the below method to work, you need
		            // to ensure that the data has finished writing to the
		            // ByteArrayOutputStream
		        	iaos.writeTo(out);
		        }
		        catch (IOException e) {
		            // logging and exception handling should go here
		        }
		        finally {
		            // close the PipedOutputStream here because we're done writing data
		            // once this thread has completed its run
		            if (out != null) {
		                // close the PipedOutputStream cleanly
		                try {
							out.close();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
		            }
		        }   
		    }
		}).start();
		applySchematronXsl2(in, baos);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		return baos.toString("UTF-8");
	}

	public void applySchematronXsl(final InputStream xmlFile,
								   final OutputStream HTMLOutstream) throws TransformerException {
		Transformer transformer = mXsltXRTemplate.newTransformer();
		
		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
	}

	public void applySchematronXsl2(final InputStream xmlFile,
								   final OutputStream HTMLOutstream) throws TransformerException {
		Transformer transformer = mXsltHTMLTemplate.newTransformer();
		
		transformer.transform(new StreamSource(xmlFile), new StreamResult(HTMLOutstream));
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
