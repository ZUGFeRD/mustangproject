package org.mustangproject.validator;

import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;

import javax.xml.transform.Source;
import java.io.File;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class LibraryTest extends ResourceCase {

	public void testLibraryPush() {
		File tempFile = new File("../library/target/testout-MustangGnuaccountingBeispielRE-20201121_508.pdf");
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

	public void testLibraryPushEdge() {
		File tempFile = new File("../library/target/testout-ZF2PushEdge.pdf");
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
	public void testPDFA3Exporter() {
		// testout-MustangGnuaccountingBeispielRE-20170509_505newEdge.pdf was a A3 file
		// already in import (MustangGnuaccountingBeispielRE-20170509_505PDFA3.pdf),
		// so it's important to check that we did not screw anythig up in that scenario

		File tempFile = new File("../library/target/testout-MustangGnuaccountingBeispielRE-20170509_505newEdge.pdf");
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

	/**
	 * automatically test the xrechnung
	 */
	public void testXRValidation() {
		File tempFile = new File("../library/target/testout-XR-Edge.xml");
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();

		String res = zfv.validate(tempFile.getAbsolutePath());

		/** We're releasing XR in the (published) version 2.2, unfortunately as of 2022-05-10 the validating schematrons only support 1.1, thus throw this error:*/
		assertThat(res).valueByXPath("count(//error)")
				.asInt()
				.isEqualTo(1);
		assertThat(res).valueByXPath("//error").asString().isEqualTo("[BR-DE-21] Das Element \"Specification identifier\" (BT-24) soll syntaktisch der Kennung des Standards XRechnung entsprechen. (From /xslt/XR_21/XRechnung-CII-validation.xslt)");
		assertThat(res).valueByXPath("/validation/summary/@status")
				.asString()
				.isEqualTo("invalid");// expect to be valid because XR notices are, well, only notices
		assertThat(res).valueByXPath("/validation/xml/summary/@status")
				.asString()
				.isEqualTo("invalid");
		/** end of errors due to version mismatch*/


		assertThat(res).valueByXPath("count(//notice)")
				.asInt()
				.isEqualTo(0);

	}
}
