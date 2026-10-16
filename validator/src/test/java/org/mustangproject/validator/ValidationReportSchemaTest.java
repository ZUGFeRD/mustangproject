package org.mustangproject.validator;

import java.io.File;
import java.io.StringReader;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

/**
 * Checks that validation reports conform to the documented schema doc/mustang-validation.xsd
 */
public class ValidationReportSchemaTest extends ResourceCase {

	private static final String SCHEMA_PATH = "../doc/mustang-validation.xsd";

	private static Schema schema;

	@BeforeAll
	public static void loadSchema() throws Exception {
		schema = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI)
			.newSchema(new File(SCHEMA_PATH));
	}

	// valid PDF and XML, PDF with failed PDF/A rules, XML without PDF
	@ParameterizedTest
	@ValueSource(strings = {"validXRechnung.pdf", "invalidPDF.pdf", "validV2.xml"})
	public void testReportMatchesSchema(String filename) throws Exception {
		String report = new ZUGFeRDValidator().validate(getResourceAsFile(filename).getAbsolutePath());
		schema.newValidator().validate(new StreamSource(new StringReader(report)));
	}
}
