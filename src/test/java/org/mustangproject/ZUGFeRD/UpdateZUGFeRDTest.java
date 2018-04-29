/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0. You can also
 * obtain a copy of the License at http://odftoolkit.org/docs/license.txt
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

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.TransformerException;
import org.junit.Assert;
import org.junit.Test;

public class UpdateZUGFeRDTest {

    private static final Logger LOG = Logger.getLogger(UpdateZUGFeRDTest.class.getName());

    private static final String TEST_INPUT_NAME = "ZUGFeRD1-invoice_test-input.xml";
    private static final String TEST_OUTPUT_NAME = "ZUGFeRD2-invoice_test-output.xml";
    private static final String TEST_REF_NAME = "ZUGFeRD2-invoice_output-reference.xml";

    private static final String TEST_INPUT_DIR = "src" + File.separator + "test" + File.separator + "resources" + File.separator;
    private static final String TEST_OUTPUT_DIR = "target" + File.separator + "test-classes" + File.separator;

    private static String readFile(Charset encoding, String path) throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, encoding);
    }

    private static void saveFile(String content, String path) throws FileNotFoundException {
        try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(new File(path)), StandardCharsets.UTF_8), true)) {
            out.println(content);
        }
    }

    @Test
    public void testMigration() {
        try {
            String tmp = new ZUGFeRDMigrator().migrateFromV1ToV2(TEST_INPUT_DIR + TEST_INPUT_NAME);
            saveFile(tmp, TEST_OUTPUT_DIR + TEST_OUTPUT_NAME);
            LOG.log(Level.INFO, "***\nZUGFeRD 2.0:\n***\n{0}", tmp);

            // we need to save the string and reload it otherwise two bytes are missing (likely EOF related)
            String refXML = readFile(StandardCharsets.UTF_8, TEST_INPUT_DIR + TEST_REF_NAME);
            String outXML = readFile(StandardCharsets.UTF_8, TEST_OUTPUT_DIR + TEST_OUTPUT_NAME);
            int t = outXML.length();
            int r = refXML.length();
            if (t != r || !(outXML.equals(refXML))) {
                LOG.info("Please compare:"
                        + "\nZUGFeRD 2.0 Test Output: " + TEST_OUTPUT_DIR + TEST_OUTPUT_NAME
                        + "\nZUGFeRD 2.0 Test Reference: " + TEST_INPUT_DIR  + TEST_REF_NAME);
                LOG.info("\n\nFile sizes:\n "
                        + "\nZUGFeRD 2.0 Test Output: " + t
                        + "\nZUGFeRD 2.0 Test Reference: " + r);
                Assert.fail("Version update failed, as test result and reference are different!");
            }else{
                LOG.log(Level.INFO, "***\nZUGFeRD 2.0 invoice:\n***\n{0}", outXML);
            }
        } catch (IOException | TransformerException t) {
            LOG.log(Level.SEVERE, t.getMessage(), t);
            Assert.fail("Failed with " + t.getClass().getName() + ": '" + t.getMessage() + "'");
        }
    }
}
