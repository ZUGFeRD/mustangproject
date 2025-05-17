/**
 * *********************************************************************
 * <p>
 * Copyright 2019 Jochen Staerk
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
package org.mustangproject.validator;

import org.apache.commons.io.FilenameUtils;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.mustangproject.ZUGFeRD.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.LinkedList;
import java.util.List;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ValidationLogVisualizationTest extends ResourceCase {

	private static final Logger log = LoggerFactory.getLogger(ValidationLogVisualizationTest.class);

	public void testValidationLogVisualization() {
		List<String> tests = new LinkedList<>();
		tests.add("01.01a-INVOICE_ubl.xml");
		tests.add("attributeBasedXMP_zugferd_2p0_EN16931_Einfach_corrected.xml");
		tests.add("CII_XRechnung_with_Peppol_violation.xml");
		tests.add("EN16931_Einfach.ubl.xml");
		tests.add("FAIL_zugferd_2p1_MINIMUM_Rechnung_380.xml");
		tests.add("invalidV1.xml");
		tests.add("invalidV1addition.xml");
		tests.add("invalidV1ExtraTags.xml");
		tests.add("invalidV1TooMinimal.xml");
		tests.add("invalidV2.xml");
		tests.add("invalidV2Profile.xml");
		tests.add("invalidV2Root.xml");
		tests.add("invalidXRSchemav2.xml");
		tests.add("invalidXRv2.xml");
		tests.add("invalidXRV30.xml");
		tests.add("ubl-tc434-creditnote1.xml");
		tests.add("valid_Avoir_FR_type380_minimum_factur-x.xml");
		tests.add("validV1.xml");
		tests.add("validV2.xml");
		tests.add("validV2Basic.xml");
		tests.add("validXRv2.xml");
		tests.add("validXRV23.xml");
		tests.add("validXRV30.xml");
		tests.add("validZREtestZugferd.xml");
		tests.add("xrechnung-ubl.xml");
		tests.add("ZUGFeRD-invoice_rabatte_3_abschlag_duepayableamount.xml");
		tests.add("ZUGFeRD-invoice_rabatte_4_abschlag_taxbasistotalamount.xml");
		for (String test : tests) {
			assertTrue(runValidationLogVisualizer(test));
		}
	}

	private boolean runValidationLogVisualizer(String inputName) {
		boolean rv;
		byte[] input = ResourceCase.getResourceAsByteArray(inputName);
		if (input != null) {
			try {
				ZUGFeRDValidator zfv = new ZUGFeRDValidator();
				String validationResult = zfv.validate(input, inputName);
				ValidationLogVisualizer vlv = new ValidationLogVisualizer();
				String outputName = String.join(
					File.separator,
					"target",
					FilenameUtils.getBaseName(inputName) + "_result.pdf"
				);
				File pdfFile = new File(outputName);
				vlv.toPDF(validationResult, pdfFile.getAbsolutePath());
				rv = pdfFile.exists() && pdfFile.length() > 15;
			} catch (Exception e) {
				rv = false;
				log.error("Error while testing validation log visualization.", e);
			}
		} else {
			rv = false;
			log.error(String.format("Cannot read resource '%s'.", inputName));
		}
		return rv;
	}
}
