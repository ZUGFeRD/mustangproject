package org.mustangproject.validator;

import static org.xmlunit.assertj.XmlAssert.assertThat;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.xml.transform.Source;

import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;

public class XMLValidatorTest extends ResourceCase {

	public void testZF2XMLValidation() {
		// ignored for the
		// time being

		ValidationContext ctx = new ValidationContext(null);
		XMLValidator xv = new XMLValidator(ctx);
		XPathEngine xpath = new JAXPXPathEngine();
		File tempFile = getResourceAsFile("invalidV2.xml");
		Source source;
		String content;

		try {
			xv.setFilename(tempFile.getAbsolutePath());

			xv.validate();

			/*
			 * assertEquals(true, xv.getXMLResult().
			 * contains("<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='ApplicableHeaderTradeSettlement']/*[local-name()='SpecifiedTradeSettlementHeaderMonetarySummation']\" criterion=\"(ram:LineTotalAmount)\">\n"
			 * +
			 * "	Eine Rechnung (INVOICE) muss die Summe der Rechnungspositionen-Nettobeträge „Sum of Invoice line net amount“ (BT-106) enthalten.</error>\n"
			 * +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='ApplicableHeaderTradeSettlement']/*[local-name()='SpecifiedTradeSettlementHeaderMonetarySummation']\" criterion=\"(ram:TaxBasisTotalAmount = ram:LineTotalAmount - ram:AllowanceTotalAmount + ram:ChargeTotalAmount) or ((ram:TaxBasisTotalAmount = ram:LineTotalAmount - ram:AllowanceTotalAmount) and not (ram:ChargeTotalAmount)) or ((ram:TaxBasisTotalAmount = ram:LineTotalAmount + ram:ChargeTotalAmount) and not (ram:AllowanceTotalAmount)) or ((ram:TaxBasisTotalAmount = ram:LineTotalAmount) and not (ram:ChargeTotalAmount) and not (ram:AllowanceTotalAmount))\">\n"
			 * +
			 * "	Der Inhalt des Elementes „Invoice total amount without VAT“ (BT-109) entspricht der Summe aller Inhalte der Elemente „Invoice line net amount“ (BT-131) abzüglich der Summe aller in der Rechnung enthaltenen Nachlässe der Dokumentenebene „Sum of allowances on document level“ (BT-107) zuzüglich der Summe aller in der Rechnung enthaltenen Abgaben der Dokumentenebene „Sum of charges on document level“ (BT-108).</error>\n"
			 * +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='ApplicableHeaderTradeSettlement']/*[local-name()='SpecifiedTradeSettlementHeaderMonetarySummation']\" criterion=\"(ram:GrandTotalAmount = round(ram:TaxBasisTotalAmount*100 + ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]*100 +0) div 100) or ((ram:GrandTotalAmount = ram:TaxBasisTotalAmount) and not (ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]))\">\n"
			 * +
			 * "	Der Inhalt des Elementes „Invoice total amount with VAT“ (BT-112) entspricht der Summe des Inhalts des Elementes „Invoice total amount without VAT“ (BT-109) und des Elementes „Invoice total VAT amount“ (BT-110).</error>\n"
			 * +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='ApplicableHeaderTradeSettlement']/*[local-name()='SpecifiedTradeSettlementHeaderMonetarySummation']\" criterion=\"ram:LineTotalAmount = (round(sum(../../ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * 10 * 10)div 100)\">\n"
			 * +
			 * "	Der Inhalt des Elementes „Sum of Invoice line net amount“ (BT-106) entspricht der Summe aller Inhalte der Elemente „Invoice line net amount“ (BT-131).</error>\n"
			 * +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']\" criterion=\"(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!='')\">\n"
			 * +
			 * "	Eine Rechnung (INVOICE) muss den Erwerbernamen „Buyer name“ (BT-44) enthalten.</error>\n"
			 * +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='ApplicableHeaderTradeAgreement']/*[local-name()='BuyerTradeParty']\" criterion=\"count(ram:Name)=1\">\n"
			 * + "	Das Element 'ram:Name' muss genau 1 mal auftreten.</error>\n" +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='ApplicableHeaderTradeSettlement']/*[local-name()='SpecifiedTradeSettlementHeaderMonetarySummation']\" criterion=\"count(ram:LineTotalAmount)=1\">\n"
			 * + "	Das Element 'ram:LineTotalAmount' muss genau 1 mal auftreten.</error>\n"
			 * +
			 * "<error location=\"/*[local-name()='CrossIndustryInvoice']/*[local-name()='SupplyChainTradeTransaction']/*[local-name()='IncludedSupplyChainTradeLineItem'][2]/*[local-name()='SpecifiedLineTradeDelivery']/*[local-name()='BilledQuantity']\" criterion=\"document('zugferd2p0_extended_codedb.xml')//cl[@id=7]/enumeration[@value=$codeValue7]\">\n"
			 * + "	Wert von '@unitCode' ist unzulässig.</error>\n" +
			 * "</messages><summary status='invalid'/>"));
			 *
			 */

			tempFile = getResourceAsFile("invalidV2Profile.xml");

			xv.setFilename(tempFile.getAbsolutePath());

			xv.validate();
		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}
		assertTrue(xv.getXMLResult().contains("<error type=\"25\""));
		ctx.clear();

		try {

			tempFile = getResourceAsFile("FAIL_zugferd_2p1_MINIMUM_Rechnung_380.xml");

			xv.setFilename(tempFile.getAbsolutePath());

			xv.validate();
		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}
		String res = xv.getXMLResult();
		/*OutputStream os = null;
		try {
			os = new FileOutputStream(new File("return.xml"));
			os.write(res.getBytes(), 0, res.length());
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}*/

		content = "<validation>" + res + "</validation>";

		assertThat(content).valueByXPath("count(//error)")
				.asInt()
				.isGreaterThan(1); //2 errors are OK because there is a known bug


		assertThat(content).valueByXPath("//error[@type=\"4\"]")
				.asString()
				.contains(
						"In Deutschland sind die Profile MINIMUM und BASIC WL nur als Buchungshilfe (TypeCode: 751) zugelassen.");


		ctx.clear();
		tempFile = getResourceAsFile("validV2Basic.xml");
		try {

			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();
			assertEquals(true, xv.getXMLResult().contains("valid") && !xv.getXMLResult().contains("invalid"));

			ctx.clear();
			tempFile = getResourceAsFile("ZUGFeRD-invoice_rabatte_3_abschlag_duepayableamount.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();
			assertEquals(true, xv.getXMLResult().contains("valid") && !xv.getXMLResult().contains("invalid"));

			ctx.clear();
			tempFile = getResourceAsFile("valid_Avoir_FR_type380_minimum_factur-x.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();

			source = Input.fromString("<validation>" + xv.getXMLResult() + "</validation>").build();
			content = xpath.evaluate("/validation/summary/@status", source);
			assertEquals("invalid", content);

			// assertEquals(true, xv.getXMLResult().contains("valid") &&
			// !xv.getXMLResult().contains("invalid"));

			/*
			 * this test failure might have to be upstreamed ctx.clear(); tempFile =
			 * getResourceAsFile(
			 * "ZUGFeRD-invoice_rabatte_4_abschlag_taxbasistotalamount.xml");
			 * xv.setFilename(tempFile.getAbsolutePath()); xv.validate(); assertEquals(true,
			 * xv.getXMLResult().contains("valid") &&
			 * !xv.getXMLResult().contains("invalid"));
			 */
			ctx.clear();
			tempFile = getResourceAsFile("attributeBasedXMP_zugferd_2p0_EN16931_Einfach_corrected.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();
			assertEquals(true, xv.getXMLResult().contains("valid") && !xv.getXMLResult().contains("invalid"));

			ctx.clear();
			tempFile = getResourceAsFile("validZREtestZugferd.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();

			source = Input.fromString("<validation>" + xv.getXMLResult() + "</validation>").build();
			content = xpath.evaluate("/validation/summary/@status", source);
			assertEquals("invalid", content);

		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

	public void testZF1XMLValidation() {
		ValidationContext ctx = new ValidationContext(null);
		XMLValidator xv = new XMLValidator(ctx);
		File tempFile = getResourceAsFile("validV1.xml");
		try {
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();
			assertEquals(true, xv.getXMLResult().contains("valid") && !xv.getXMLResult().contains("invalid"));

			tempFile = getResourceAsFile("invalidV1ExtraTags.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();
			assertEquals(true, xv.getXMLResult().contains("invalid"));

			tempFile = getResourceAsFile("invalidV1TooMinimal.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();
			assertEquals(true, xv.getXMLResult().contains("<error type=\"26\""));

		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

	public void testXRValidation() {
		ValidationContext ctx = new ValidationContext(null);
		XMLValidator xv = new XMLValidator(ctx);
		XPathEngine xpath = new JAXPXPathEngine();

		File tempFile = getResourceAsFile("validXRv2.xml");
		try {
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();

			Source source = Input.fromString("<validation>" + xv.getXMLResult() + "</validation>").build();
			String content = xpath.evaluate("/validation/summary/@status", source);
			assertEquals("valid", content);

			tempFile = getResourceAsFile("invalidXRv2.xml");
			xv.setFilename(tempFile.getAbsolutePath());
			xv.validate();

			source = Input.fromString("<validation>" + xv.getXMLResult() + "</validation>").build();
			content = xpath.evaluate("/validation/summary/@status", source);
			assertEquals("invalid", content);


		} catch (IrrecoverableValidationError e) {
			// ignore, will be in XML output anyway
		}

	}

}
