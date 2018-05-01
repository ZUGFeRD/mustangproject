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

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class ZUGFeRDMigrator {

    static final ClassLoader CLASS_LOADER = ZUGFeRDMigrator.class.getClassLoader();
    private static final String RESOURCE_PATH = ""; //$NON-NLS-1$
    private static final Logger LOG = Logger.getLogger(ZUGFeRDMigrator.class.getName());
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
    private Templates mXsltTemplate = null;

    public ZUGFeRDMigrator() {
            mFactory = new net.sf.saxon.TransformerFactoryImpl();
            //fact = TransformerFactory.newInstance();
            mFactory.setURIResolver(new ClasspathResourceURIResolver());
        try {
            mXsltTemplate = mFactory.newTemplates(new StreamSource(CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + "COMFORTtoEN16931.xsl")));
        } catch (TransformerConfigurationException ex) {
            LOG.log(Level.SEVERE, null, ex);
        }
    }

    public String migrateFromV1ToV2(String xmlFilename) throws FileNotFoundException, TransformerException, UnsupportedEncodingException {
        /**
         * *
         * http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
         * http://www.ferd-net.de/upload/Dokumente/FACTUR-X_ZUGFeRD_2p0_Teil1_Profil_EN16931_1p03.pdf
         * http://countwordsfree.com/xmlviewer
         */
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        applySchematronXsl(new FileInputStream(xmlFilename), baos);
        String res = null;
        res = baos.toString("UTF-8");
        return res;
    }

    public void applySchematronXsl(final InputStream xmlFile,
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
