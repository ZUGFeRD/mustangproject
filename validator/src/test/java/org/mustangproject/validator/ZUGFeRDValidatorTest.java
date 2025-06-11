package org.mustangproject.validator;

import java.io.ByteArrayInputStream;
import java.io.File;

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
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("valid");

		tempFile = getResourceAsFile("validAvoir_FR_type380_BASICWL.pdf");
		zfv = new ZUGFeRDValidator();

		res = zfv.validate(tempFile.getAbsolutePath());
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("valid");

		tempFile = getResourceAsFile("validXRechnung.pdf");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(tempFile.getAbsolutePath());
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("valid");
/*
		tempFile = getResourceAsFile("testout-OX.pdf");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(tempFile.getAbsolutePath());
		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");

		tempFile = getResourceAsFile("testout-OX.xml");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(tempFile.getAbsolutePath());
		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");
*/
		tempFile = getResourceAsFile("invalidXRechnung.pdf");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(tempFile.getAbsolutePath());
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("invalid");

		zfv = new ZUGFeRDValidator();
		res = zfv.validate("/does/not/exist");
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("invalid");

	}

	public void testPDFValidationInputStream() {
		byte[] fileBytes = getResourceAsByteArray("invalidPDF.pdf");
		/**used to be Rule  Status
		 Specification: ISO 19005-3:2012, Clause: 6.2.11.4, Test number: 4
		 If the FontDescriptor dictionary of an embedded CID font contains a CIDSet stream, then it shall identify all CIDs which are present in the font program, regardless of whether a CID in the font is referenced or used by the PDF or not. Failed
		 2 occurrences  Hide
		 PDCIDFont
		 fontFile_size == 0 || fontName.search(/[A-Z]{6}\+/) != 0 || CIDSet_size == 0 || cidSetListsAllGlyphs == true
		 root/document[0]/pages[1](9 0 obj PDPage)/contentStream[0](18 0 obj PDContentStream)/operators[166]/font[0](WIUIIO+CIDFont+F2)/DescendantFonts[0](WIUIIO+CIDFont+F2)
		 root/document[0]/pages[1](9 0 obj PDPage)/contentStream[0](18 0 obj PDContentStream)/operators[192]/font[0](VEXQUA+CIDFont+F1)/DescendantFonts[0](VEXQUA+CIDFont+F1)
		 but new sample since that has been downgraded to warning
		 */
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(new ByteArrayInputStream(fileBytes), "invalidPDF.pdf");


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
			.isEqualTo("invalid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
			.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("invalid");


		fileBytes = getResourceAsByteArray("validAvoir_FR_type380_BASICWL.pdf");
		zfv = new ZUGFeRDValidator();

		res = zfv.validate(new ByteArrayInputStream(fileBytes), "validAvoir_FR_type380_BASICWL.pdf");
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("valid");

		fileBytes = getResourceAsByteArray("validXRechnung.pdf");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(new ByteArrayInputStream(fileBytes), "validXRechnung.pdf");
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("valid");

		fileBytes = getResourceAsByteArray("invalidXRechnung.pdf");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(new ByteArrayInputStream(fileBytes), "invalidXRechnung.pdf");
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("invalid");

		zfv = new ZUGFeRDValidator();
		res = zfv.validate(new ByteArrayInputStream(new byte[0]), "/does/not/exist");
		assertThat(res).valueByXPath("/validation/summary/@status")
			.isEqualTo("invalid");

	}

	public void testPDFA3AValidation() {
		File tempFile = getResourceAsFile("zugferd_2p1_EXTENDED_PDFA-3A.pdf");

		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());

		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
			.isEqualTo("valid");
	}

	/***
	 * the XMLValidatorTests only cover the <xml></xml> part, this one includes the root element and
	 * the global <summary></summary> part as well
	 */
	public void testV1XMLValidation() {
		File tempFile = getResourceAsFile("invalidV1addition.xml");
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());

		assertThat(res).valueByXPath("count(//error)")
			.asInt()
			.isNotEqualTo(0);

		assertThat(res).valueByXPath("/validation/summary/@status")
			.asString()
			.isEqualTo("invalid");// expect to be valid because XR notices are, well, only notices
		assertThat(res).valueByXPath("/validation/xml/summary/@status")
			.asString()
			.isEqualTo("invalid");

	}

	public void testXR23Validation() {
		File tempFile = getResourceAsFile("validXRV23.xml");
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("count(//error)")
			.asInt()
			.isEqualTo(0);

		assertThat(res).valueByXPath("count(//notice)")
			.asInt()
			.isEqualTo(0);
		assertThat(res).valueByXPath("/validation/summary/@status")
			.asString()
			.isEqualTo("valid");// expect to be valid because XR notices are, well, only notices
		assertThat(res).valueByXPath("/validation/xml/summary/@status")
			.asString()
			.isEqualTo("valid");


	}

	public void testXR30Validation() {

		File tempFile = getResourceAsFile("validXRV30.xml");
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());
		assertThat(res).valueByXPath("count(//error)")
			.asInt()
			.isEqualTo(0);

		assertThat(res).valueByXPath("count(//notice)")
			.asInt()
			.isEqualTo(0);
		assertThat(res).valueByXPath("/validation/summary/@status")
			.asString()
			.isEqualTo("valid");// expect to be valid because XR notices are, well, only notices
		assertThat(res).valueByXPath("/validation/xml/summary/@status")
			.asString()
			.isEqualTo("valid");

		tempFile = getResourceAsFile("invalidXRV30.xml");
		zfv = new ZUGFeRDValidator();
		res = zfv.validate(tempFile.getAbsolutePath());

		assertThat(res).valueByXPath("count(//error)")
			.asInt()
			.isEqualTo(2);
		assertThat(res).valueByXPath("count(//warning)")
			.asInt()
			.isEqualTo(2);

		assertThat(res).valueByXPath("count(//notice)")
			.asInt()
			.isEqualTo(0); // 12 notices RE XRechnung 3.0
		assertThat(res).valueByXPath("/validation/summary/@status")
			.asString()
			.isEqualTo("invalid");// expect to be valid
		assertThat(res).valueByXPath("/validation/xml/summary/@status")
			.asString()
			.isEqualTo("invalid");// expect to be valid


	}

	/***
	 * the XMLValidatorTests only cover the <xml></xml> part, this one includes the root element and
	 * the global <summary></summary> part as well
	 */
	public void testXMLValidation() {
		File tempFile = getResourceAsFile("validV2.xml");
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());

		assertThat(res).valueByXPath("count(//error)")
			.asInt()
			.isEqualTo(0);

		assertThat(res).valueByXPath("count(//notice)")
			.asInt()
			.isEqualTo(12); // 12 notices RE XRechnung 3.0
		assertThat(res).valueByXPath("/validation/summary/@status")
			.asString()
			.isEqualTo("valid");// expect to be valid because XR notices are, well, only notices
		assertThat(res).valueByXPath("/validation/xml/summary/@status")
			.asString()
			.isEqualTo("valid");

	}
}
