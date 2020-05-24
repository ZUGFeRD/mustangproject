package org.mustangproject.library.extended;

import static org.xmlunit.assertj.XmlAssert.assertThat;
import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class ZUGFeRDValidatorTest extends ResourceCase {

	public void testPDFValidation() {
		File tempFile = getResourceAsFile("invalidPDF.pdf");
		/**used to be Rule	Status
		 Specification: ISO 19005-3:2012, Clause: 6.2.11.4, Test number: 4
		 If the FontDescriptor dictionary of an embedded CID font contains a CIDSet stream, then it shall identify all CIDs which are present in the font program, regardless of whether a CID in the font is referenced or used by the PDF or not.	Failed
		 2 occurrences	Hide
		 PDCIDFont
		 fontFile_size == 0 || fontName.search(/[A-Z]{6}\+/) != 0 || CIDSet_size == 0 || cidSetListsAllGlyphs == true
		 root/document[0]/pages[1](9 0 obj PDPage)/contentStream[0](18 0 obj PDContentStream)/operators[166]/font[0](WIUIIO+CIDFont+F2)/DescendantFonts[0](WIUIIO+CIDFont+F2)
		 root/document[0]/pages[1](9 0 obj PDPage)/contentStream[0](18 0 obj PDContentStream)/operators[192]/font[0](VEXQUA+CIDFont+F1)/DescendantFonts[0](VEXQUA+CIDFont+F1)
		 but new sample since that has been downgraded to warning
		 */
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("invalid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("invalid");


		tempFile = getResourceAsFile("validAvoir_FR_type380_BASICWL.pdf");
		zfv = new ZUGFeRDValidator();

		res = zfv.validate(tempFile.getAbsolutePath());
		assertEquals(true, res.contains("status=\"valid\""));
		assertEquals(false, res.contains("status=\"invalid\""));

	}
}
