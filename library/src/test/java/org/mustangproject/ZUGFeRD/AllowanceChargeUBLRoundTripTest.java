/**
 * *********************************************************************
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
package org.mustangproject.ZUGFeRD;

import org.mustangproject.Allowance;
import org.mustangproject.CII.CIIToUBL;
import org.mustangproject.Charge;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;
import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Date;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/***
 * End-to-end round-trip test for AllowanceCharge handling across the real production pipeline:
 * mustangproject CII export -&gt; com.helger.en16931.cii2ubl.CIIToUBL23Converter (UBL) -&gt;
 * ZUGFeRDInvoiceImporter (back into the internal model) -&gt; ZUGFeRD2PullProvider (CII again).
 * <p>
 * This exercises header-level amount-based and percent-only allowances/charges, line-level
 * (BT-136/BT-141 style) allowances, and per-unit-price allowances nested under
 * GrossPriceProductTradePrice/cac:Price - i.e. all of the cases fixed for UBL AllowanceCharge import.
 */
public class AllowanceChargeUBLRoundTripTest extends ResourceCase {

	public void testHeaderAndLineAllowanceChargeSurviveCIIToUBLToCIIRoundTrip() throws Exception {

		BigDecimal price = new BigDecimal("100.00");
		BigDecimal qty = BigDecimal.ONE;

		BigDecimal headerChargeAmount = new BigDecimal("12.50");
		BigDecimal headerAllowancePercent = new BigDecimal("5.00");
		BigDecimal headerAllowanceBasis = new BigDecimal("100.00");

		BigDecimal lineAllowanceAmount = new BigDecimal("2.00");
		BigDecimal perUnitAllowanceAmount = new BigDecimal("1.00");

		Product product = new Product("Testprodukt", "", "H87", new BigDecimal("19"));
		// Bug 4 case: per-unit-price allowance, exported under GrossPriceProductTradePrice/AppliedTradeAllowanceCharge (CII)
		// and cac:Price/cac:AllowanceCharge (UBL)
		product.addAllowance(new Allowance(perUnitAllowanceAmount));

		Item item = new Item(product, price, qty)
			// Bug 3 case: genuine line-level allowance, SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge (CII)
			// and a direct-child cac:AllowanceCharge under cac:InvoiceLine (UBL)
			.addAllowance(new Allowance(lineAllowanceAmount).setReason("line discount").setReasonCode("95"));

		Invoice invoice = new Invoice()
			.setCurrency("EUR")
			.setIssueDate(new Date())
			.setDueDate(new Date())
			.setDeliveryDate(new Date())
			.setNumber("RT-1")
			.setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE").addTaxID("4711").addVATID("DE0815"))
			.setRecipient(new TradeParty("Franz Mueller", "teststr.12", "55232", "Entenhausen", "DE"))
			.addItem(item)
			// Bug 2 amount-based case, with reason/reasonCode/taxPercent/categoryCode
			.addCharge(new Charge(headerChargeAmount).setReason("Handling").setReasonCode("FC")
				.setTaxPercent(new BigDecimal("19")).setCategoryCode(TaxCategoryCodeTypeConstants.STANDARDRATE))
			// Bug 2 percent-only case (no ActualAmount at all) - this used to throw NumberFormatException on import
			.addAllowance(new Allowance().setPercent(headerAllowancePercent).setBasisAmount(headerAllowanceBasis)
				.setReason("Loyalty discount").setReasonCode("95")
				.setTaxPercent(new BigDecimal("19")).setCategoryCode(TaxCategoryCodeTypeConstants.STANDARDRATE));

		// 1. mustangproject: Invoice -> CII XML
		ZUGFeRD2PullProvider originalProvider = new ZUGFeRD2PullProvider();
		originalProvider.setProfile(Profiles.getByName("EXTENDED"));
		originalProvider.generateXML(invoice);
		byte[] originalCiiXml = originalProvider.getXML();

		File ciiFile = File.createTempFile("AllowanceChargeRoundTrip-", "-cii.xml");
		ciiFile.deleteOnExit();
		Files.write(ciiFile.toPath(), originalCiiXml);

		// 2. com.helger.en16931.cii2ubl.CIIToUBL23Converter: CII -> UBL (the real downstream pipeline, not mustang's own UBL exporter)
		File ublFile = File.createTempFile("AllowanceChargeRoundTrip-", "-ubl.xml");
		ublFile.deleteOnExit();
		new CIIToUBL().convert(ciiFile, ublFile);
		assertTrue("CIIToUBL23Converter should have produced a non-empty UBL file", ublFile.length() > 0);

		// 3. ZUGFeRDInvoiceImporter: UBL -> internal model (this is what Bugs 1-4 were fixed in)
		ZUGFeRDInvoiceImporter importer = new ZUGFeRDInvoiceImporter(new FileInputStream(ublFile));
		Invoice reimported = importer.extractInvoice();

		// 4. ZUGFeRD2PullProvider: internal model -> CII XML again
		ZUGFeRD2PullProvider finalProvider = new ZUGFeRD2PullProvider();
		finalProvider.setProfile(Profiles.getByName("EXTENDED"));
		finalProvider.generateXML(reimported);
		byte[] finalCiiXml = finalProvider.getXML();

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		Document finalDoc = dbf.newDocumentBuilder().parse(new java.io.ByteArrayInputStream(finalCiiXml));

		XPath xpath = XPathFactory.newInstance().newXPath();

		// --- header level: amount-based charge ---
		NodeList headerCharges = (NodeList) xpath.evaluate(
			"//*[local-name()=\"ApplicableHeaderTradeSettlement\"]/*[local-name()=\"SpecifiedTradeAllowanceCharge\"]",
			finalDoc, XPathConstants.NODESET);
		Node headerCharge = findByIndicator(headerCharges, true);
		assertNotNull("header charge (amount-based) should survive the round trip", headerCharge);
		assertDecimalEquals(headerChargeAmount, childDecimal(headerCharge, "ActualAmount"));
		assertEquals("Handling", childText(headerCharge, "Reason"));
		assertEquals("FC", childText(headerCharge, "ReasonCode"));
		Node headerChargeTax = child(headerCharge, "CategoryTradeTax");
		assertNotNull(headerChargeTax);
		assertEquals(TaxCategoryCodeTypeConstants.STANDARDRATE, childText(headerChargeTax, "CategoryCode"));
		assertDecimalEquals(new BigDecimal("19"), childDecimal(headerChargeTax, "RateApplicablePercent"));

		// --- header level: percent-only allowance (the case that used to crash on import) ---
		Node headerAllowance = findByIndicator(headerCharges, false);
		assertNotNull("header allowance (percent-only) should survive the round trip", headerAllowance);
		assertDecimalEquals(headerAllowancePercent, childDecimal(headerAllowance, "CalculationPercent"));
		assertDecimalEquals(headerAllowanceBasis, childDecimal(headerAllowance, "BasisAmount"));
		assertNotNull("ActualAmount must have been computed from percent+basis, not crashed", childDecimal(headerAllowance, "ActualAmount"));
		assertEquals("Loyalty discount", childText(headerAllowance, "Reason"));
		assertEquals("95", childText(headerAllowance, "ReasonCode"));
		Node headerAllowanceTax = child(headerAllowance, "CategoryTradeTax");
		assertNotNull(headerAllowanceTax);
		assertEquals(TaxCategoryCodeTypeConstants.STANDARDRATE, childText(headerAllowanceTax, "CategoryCode"));
		assertDecimalEquals(new BigDecimal("19"), childDecimal(headerAllowanceTax, "RateApplicablePercent"));

		// --- line level: genuine line-level allowance (BT-141 style, direct child of InvoiceLine in UBL) ---
		NodeList lineAllowances = (NodeList) xpath.evaluate(
			"//*[local-name()=\"SpecifiedLineTradeSettlement\"]/*[local-name()=\"SpecifiedTradeAllowanceCharge\"]",
			finalDoc, XPathConstants.NODESET);
		assertEquals(1, lineAllowances.getLength());
		Node lineAllowance = lineAllowances.item(0);
		assertEquals("false", childText(child(lineAllowance, "ChargeIndicator"), "Indicator"));
		assertDecimalEquals(lineAllowanceAmount, childDecimal(lineAllowance, "ActualAmount"));
		assertEquals("line discount", childText(lineAllowance, "Reason"));
		assertEquals("95", childText(lineAllowance, "ReasonCode"));

		// --- line level: per-unit-price allowance (Bug 4 case, nested under GrossPriceProductTradePrice / cac:Price) ---
		NodeList perUnitAllowances = (NodeList) xpath.evaluate(
			"//*[local-name()=\"GrossPriceProductTradePrice\"]/*[local-name()=\"AppliedTradeAllowanceCharge\"]",
			finalDoc, XPathConstants.NODESET);
		assertEquals(1, perUnitAllowances.getLength());
		Node perUnitAllowance = perUnitAllowances.item(0);
		assertEquals("false", childText(child(perUnitAllowance, "ChargeIndicator"), "Indicator"));
		assertDecimalEquals(perUnitAllowanceAmount, childDecimal(perUnitAllowance, "ActualAmount"));
	}

	private static void assertDecimalEquals(BigDecimal expected, BigDecimal actual) {
		assertNotNull("expected a numeric value but found none", actual);
		assertTrue("expected " + expected + " but was " + actual, expected.compareTo(actual) == 0);
	}

	private static Node findByIndicator(NodeList nodes, boolean isCharge) {
		String expected = isCharge ? "true" : "false";
		for (int i = 0; i < nodes.getLength(); i++) {
			Node candidate = nodes.item(i);
			Node indicatorParent = child(candidate, "ChargeIndicator");
			if (indicatorParent != null && expected.equalsIgnoreCase(childText(indicatorParent, "Indicator"))) {
				return candidate;
			}
		}
		return null;
	}

	private static Node child(Node parent, String localName) {
		if (parent == null) {
			return null;
		}
		NodeList children = parent.getChildNodes();
		for (int i = 0; i < children.getLength(); i++) {
			Node c = children.item(i);
			if (localName.equals(c.getLocalName())) {
				return c;
			}
		}
		return null;
	}

	private static String childText(Node parent, String localName) {
		Node c = child(parent, localName);
		return c == null ? null : c.getTextContent().trim();
	}

	private static BigDecimal childDecimal(Node parent, String localName) {
		String text = childText(parent, localName);
		return text == null ? null : new BigDecimal(text);
	}
}
