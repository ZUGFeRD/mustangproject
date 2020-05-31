package org.mustangproject.validator;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PDFValidatorTest extends ResourceCase {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDValidator.class.getCanonicalName()); // log

	public void testPDFValidation() {
		ValidationContext vc = new ValidationContext(null);
		PDFValidator pv = new PDFValidator(vc);

		try {

			File tempFile = getResourceAsFile("XMLinvalidV2PDF.pdf");// need a more invalid file here

			pv.setFilename(tempFile.getAbsolutePath());
			pv.validate();
			// assertEquals("", pv.getXMLResult());

			//
			tempFile = getResourceAsFile("Facture_F20180027.pdf");
			pv.setFilename(tempFile.getAbsolutePath());
			pv.validate();
			String actual = pv.getXMLResult();
			assertEquals(true, actual.contains("summary status='valid"));
			assertEquals(false, actual.contains("summary status='invalid"));

			XMLValidator xv = new XMLValidator(vc);
			xv.setStringContent(pv.getRawXML());
			xv.validate();
			actual = vc.getXMLResult();

			assertEquals(true, actual.contains("validationReport profileName=\"PDF/A-3"));
			assertEquals(true, actual.contains("batchSummary totalJobs=\"1\" failedToParse=\"0\" encrypted=\"0\""));
			assertEquals(true,
					actual.contains("validationReports compliant=\"1\" nonCompliant=\"0\" failedJobs=\"0\">"));
			// test some xml
			// assertEquals(true, actual.contains("<error
			// location=\"/*:CrossIndustryInvoice[namespace-uri()='urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100'][1]/*:SupplyChainTradeTransaction[namespace-uri()='urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100'][1]/*:ApplicableHeaderTradeSettlement[namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100'][1]/*:SpecifiedTradeSettlementHeaderMonetarySummation[namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100'][1]/*:DuePayableAmount[namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100'][1]\"
			// criterion=\"not(@currencyID)\">[CII-DT-031] - currencyID should not be
			// present</error>"));
			// test some binary signature recognition
			assertEquals(true, actual.contains("<version>2</version>"));

			// valid one
			tempFile = getResourceAsFile("validV2PDF.pdf");

			pv.setFilename(tempFile.getAbsolutePath());
			vc.clear();
			pv.validate();
			actual = pv.getXMLResult();
			assertEquals(true, actual.contains("validationReport profileName=\"PDF/A-3"));
			assertEquals(true, actual.contains("batchSummary totalJobs=\"1\" failedToParse=\"0\" encrypted=\"0\""));
			assertEquals(true,
					actual.contains("validationReports compliant=\"1\" nonCompliant=\"0\" failedJobs=\"0\">"));

			assertEquals(false, actual.contains("<error"));
		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

	public void testPDFXMLValidation() {
		ValidationContext vc = new ValidationContext(null);
		try {
			PDFValidator pv = new PDFValidator(vc);

			File tempFile = getResourceAsFile("attributeBasedXMP_zugferd_2p0_EN16931_Einfach.pdf");// need a more
																									// invalid file here

			pv.setFilename(tempFile.getAbsolutePath());
			pv.validate();
			String pdfvres = pv.getXMLResult();

			XMLValidator xv = new XMLValidator(vc);

			xv.setStringContent(pv.getRawXML());
			xv.validate();
			String xmlvres = xv.getXMLResult();

			assertEquals(true, pdfvres.contains("valid") && !pdfvres.contains("invalid"));
			assertEquals(true, xmlvres.contains("invalid"));

			vc.clear();
			tempFile = getResourceAsFile("validV1WithAdditionalData.pdf");// need a more invalid file here

			pv.setFilename(tempFile.getAbsolutePath());
			pv.validate();
			pdfvres = pv.getXMLResult();

			xv = new XMLValidator(vc);

			xv.setStringContent(pv.getRawXML());
			xv.validate();
			xmlvres = xv.getXMLResult();
			assertEquals(true, pdfvres.contains("valid") && !pdfvres.contains("invalid"));
			assertEquals(true, xmlvres.contains("valid") && !xmlvres.contains("invalid"));
		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

	public void testXMPValidation() {

		ValidationContext vc = new ValidationContext(null);
		PDFValidator pv = new PDFValidator(vc);
		try {

			File tempFile = getResourceAsFile("invalidXMP.pdf");

			pv.setFilename(tempFile.getAbsolutePath());
			vc.clear();
			pv.validate();
			String actual = pv.getXMLResult();

			assertEquals(true, actual
					.contains("<error type=\"12\">XMP Metadata: ConformanceLevel contains invalid value</error>"));

			tempFile = getResourceAsFile("attributeBasedXMP_zugferd_2p0_EN16931_Einfach.pdf");

			pv.setFilename(tempFile.getAbsolutePath());
			vc.clear();
			pv.validate();
			actual = pv.getXMLResult();

			assertEquals(false, actual.contains("<error"));// issue 18: "ConformanceLevel not found" should not be
															// reported since it's actually there
		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

}
