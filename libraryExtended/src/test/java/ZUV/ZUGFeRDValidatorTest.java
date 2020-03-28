package ZUV;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ZUGFeRDValidatorTest extends ResourceCase {

	public void testPDFValidation() {
		File tempFile = getResourceAsFile("invalidPDF.pdf");
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String report = zfv.validate(tempFile.getAbsolutePath());
		Pattern regex = Pattern.compile(".*status=\"invalid\".*/>\n  </pdf>", Pattern.DOTALL);
		Matcher regexMatcher = regex.matcher(report);
		assertTrue(regexMatcher.find());
		regex = Pattern.compile(".*status=\"invalid\".*/>\n</validation>", Pattern.DOTALL);
		regexMatcher = regex.matcher(report);
		assertTrue(regexMatcher.find());
		
		tempFile = getResourceAsFile("validAvoir_FR_type380_BASICWL.pdf");
		zfv = new ZUGFeRDValidator();

		report = zfv.validate(tempFile.getAbsolutePath());
		assertEquals(true, report.contains("status=\"valid\""));
		assertEquals(false, report.contains("status=\"invalid\""));

	}
}
