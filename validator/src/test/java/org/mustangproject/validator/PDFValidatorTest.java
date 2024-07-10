package org.mustangproject.validator;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PDFValidatorTest extends ResourceCase {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDValidator.class.getCanonicalName()); // log

	public void testPDFPotentialA3SourceValidation() {
		final ValidationContext vc = new ValidationContext(null);
		final PDFValidator pv = new PDFValidator(vc);

		try {

			File tempFile = new File("../library/target/testout-PDFA3FromA3.pdf");
			assertTrue(tempFile.exists());

			pv.setFilename(tempFile.getAbsolutePath());
			pv.validate();
			String actual = pv.getXMLResult();
			assertEquals(true, actual.contains("summary status=\"valid"));
			assertEquals(false, actual.contains("summary status=\"invalid"));


			tempFile = new File("../library/target/testout-PDFA3FromUnkownA3.pdf");
			assertTrue(tempFile.exists());

			pv.setFilename(tempFile.getAbsolutePath());
			vc.clear();
			pv.validate();
			actual = pv.getXMLResult();
			assertEquals(true, actual.contains("summary status=\"valid"));
			assertEquals(false, actual.contains("summary status=\"invalid"));

			tempFile = new File("../library/target/testout-PDFA3FromUnkownA1.pdf");
			assertTrue(tempFile.exists());

			pv.setFilename(tempFile.getAbsolutePath());
			vc.clear();
			pv.validate();
			actual = pv.getXMLResult();
			assertEquals(true, actual.contains("summary status=\"valid"));
			assertEquals(false, actual.contains("summary status=\"invalid"));

		} catch (final IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}
	public void testPDFValidation() {
		final ValidationContext vc = new ValidationContext(null);
		final PDFValidator pv = new PDFValidator(vc);

		try {

			byte [] contents = getResourceAsByteArray("XMLinvalidV2PDF.pdf");// need a more invalid file here

			pv.setFilenameAndContents("XMLinvalidV2PDF.pdf", contents);
			pv.validate();
			// assertEquals("", pv.getXMLResult());

			//
			contents = getResourceAsByteArray("Facture_F20180027.pdf");
			pv.setFilenameAndContents("Facture_F20180027.pdf", contents);
			pv.validate();
			String actual = pv.getXMLResult();
			assertEquals(true, actual.contains("summary status=\"valid"));
			assertEquals(false, actual.contains("summary status=\"invalid"));

			final XMLValidator xv = new XMLValidator(vc);
			xv.setStringContent(pv.getRawXML());
			xv.validate();
			actual = vc.getXMLResult();

			assertEquals(true, actual.contains("flavour=3u"));
			assertEquals(true, actual.contains("flavour=3b"));
			assertEquals(true,
					actual.contains("isCompliant=true"));
			// test some xml
			// assertEquals(true, actual.contains("<error
			// location=\"/*:CrossIndustryInvoice[namespace-uri()='urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100'][1]/*:SupplyChainTradeTransaction[namespace-uri()='urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100'][1]/*:ApplicableHeaderTradeSettlement[namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100'][1]/*:SpecifiedTradeSettlementHeaderMonetarySummation[namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100'][1]/*:DuePayableAmount[namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100'][1]\"
			// criterion=\"not(@currencyID)\">[CII-DT-031] - currencyID should not be
			// present</error>"));
			// test some binary signature recognition
			assertEquals(true, actual.contains("<version>2</version>"));

			// valid one
			contents = getResourceAsByteArray("validV2PDF.pdf");

			pv.setFilenameAndContents("validV2PDF.pdf", contents);
			vc.clear();
			pv.validate();
			actual = pv.getXMLResult();
			assertEquals(true, actual.contains("flavour=3u"));
			assertEquals(true, actual.contains("summary status=\"valid"));
			assertEquals(false, actual.contains("summary status=\"invalid"));

			assertEquals(false, actual.contains("<error"));
		} catch (final IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

	public void testPDFXMLValidation() {
		final ValidationContext vc = new ValidationContext(null);
		try {
			final PDFValidator pv = new PDFValidator(vc);
			// need a more
			// invalid file here
			byte [] contents = getResourceAsByteArray("attributeBasedXMP_zugferd_2p0_EN16931_Einfach.pdf");

			pv.setFilenameAndContents("attributeBasedXMP_zugferd_2p0_EN16931_Einfach.pdf", contents);
			pv.validate();
			String pdfvres = pv.getXMLResult();

			XMLValidator xv = new XMLValidator(vc);

			xv.setStringContent(pv.getRawXML());
			xv.validate();
			String xmlvres = xv.getXMLResult();

			assertEquals(true, pdfvres.contains("valid") && !pdfvres.contains("invalid"));
			assertEquals(true, xmlvres.contains("invalid"));

			vc.clear();
			contents = getResourceAsByteArray("validV1WithAdditionalData.pdf");// need a more invalid file here

			pv.setFilenameAndContents("validV1WithAdditionalData.pdf", contents);
			pv.validate();
			pdfvres = pv.getXMLResult();

			xv = new XMLValidator(vc);

			xv.setStringContent(pv.getRawXML());
			xv.validate();
			xmlvres = xv.getXMLResult();
			assertEquals(true, pdfvres.contains("valid") && !pdfvres.contains("invalid"));
			assertEquals(true, xmlvres.contains("valid") && !xmlvres.contains("invalid"));
		} catch (final IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

	public void testXMPValidation() {

		final ValidationContext vc = new ValidationContext(null);
		final PDFValidator pv = new PDFValidator(vc);
		try {
			byte [] contents = getResourceAsByteArray("invalidXMP.pdf");

			pv.setFilenameAndContents("invalidXMP.pdf", contents);
			vc.clear();
			pv.validate();
			String actual = pv.getXMLResult();

			assertEquals(true, actual
					.contains("<error type=\"12\">XMP Metadata: ConformanceLevel contains invalid value</error>"));

			contents = getResourceAsByteArray("attributeBasedXMP_zugferd_2p0_EN16931_Einfach.pdf");

			pv.setFilenameAndContents("attributeBasedXMP_zugferd_2p0_EN16931_Einfach.pdf", contents);
			vc.clear();
			pv.validate();
			actual = pv.getXMLResult();

			assertEquals(false, actual.contains("<error"));// issue 18: "ConformanceLevel not found" should not be
															// reported since it's actually there
		} catch (final IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

}
