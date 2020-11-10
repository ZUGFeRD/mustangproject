package org.mustangproject.validator;

import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;

import javax.xml.transform.Source;
import java.io.File;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class LibraryTest extends ResourceCase {

	public void testLibraryPush() {
		File tempFile = new File("../library/target/testout-ZF2Push.pdf");
		assertTrue(tempFile.exists());
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");
		tempFile = new File("../library/target/testout-ZF2PushCorrection.pdf");
		assertTrue(tempFile.exists());

		res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");

	}
	public void testLibraryPushCorrection() {
		File tempFile = new File("../library/target/testout-ZF2PushCorrection.pdf");
		assertTrue(tempFile.exists());
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");

	}
	public void testLibraryPushItemAllowances() {
		File tempFile = new File("../library/target/testout-ZF2PushItemChargesAllowances.pdf");
		assertTrue(tempFile.exists());
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");

	}

	public void testLibraryPushRelativeAllowances() {
		File tempFile = new File("../library/target/testout-ZF2PushRelativeChargesAllowances.pdf");
		assertTrue(tempFile.exists());
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");

	}

	public void testLibraryPushAllowances() {
		File tempFile = new File("../library/target/testout-ZF2PushChargesAllowances.pdf");
		assertTrue(tempFile.exists());
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");

	}

	public void testZF1validity() {
		File tempFile = new File("../library/target/testout-MustangGnuaccountingBeispielRE-20171118_506zf1.pdf");
		assertTrue(tempFile.exists());
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());


		assertThat(res).valueByXPath("/validation/pdf/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.isEqualTo("valid");

		assertThat(res).valueByXPath("/validation/summary/@status")
				.isEqualTo("valid");
	}
}
