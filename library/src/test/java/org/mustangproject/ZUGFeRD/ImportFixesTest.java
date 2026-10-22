package org.mustangproject.ZUGFeRD;

import org.junit.jupiter.api.Test;
import org.mustangproject.BankDetails;
import org.mustangproject.CashDiscount;
import org.mustangproject.EStandard;
import org.mustangproject.Invoice;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.xml.xpath.XPathExpressionException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

/**
 * Regression tests for defects in ZUGFeRDInvoiceImporter and the item parsing.
 */
public class ImportFixesTest {

	private static String readResource(String path) throws IOException {
		return Files.readString(ResourceCase.getResourceAsFile(path).toPath(), StandardCharsets.UTF_8);
	}

	private static String replaceOnce(String text, String search, String replacement) {
		int index = text.indexOf(search);
		assertNotEquals(-1, index, "test resource does not contain " + search);
		return text.substring(0, index) + replacement + text.substring(index + search.length());
	}

	private static ZUGFeRDInvoiceImporter importer(String xml) throws ParseException {
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.fromXML(xml);
		return zii;
	}

	/**
	 * The billing period (BG-14) of UBL credit notes was ignored, only the Invoice root was considered.
	 */
	@Test
	public void testUBLCreditNoteInvoicePeriod() throws Exception {
		Invoice invoice = importer(readResource("ubl/UBL-CreditNote-2.1-Example.ubl.xml")).extractInvoice();

		SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd");
		assertNotNull(invoice.getDetailedDeliveryPeriodFrom());
		assertNotNull(invoice.getDetailedDeliveryPeriodTo());
		assertEquals("2009-11-01", iso.format(invoice.getDetailedDeliveryPeriodFrom()));
		assertEquals("2009-11-30", iso.format(invoice.getDetailedDeliveryPeriodTo()));
	}

	/**
	 * In UBL, BT-90 is only the party identification with schemeID SEPA. Any other seller identifier,
	 * e.g. the GLN of XRECHNUNG_Einfach, was taken as creditor reference.
	 */
	@Test
	public void testUBLCreditorReferenceRequiresSEPAScheme() throws Exception {
		String xml = readResource("ubl/XRECHNUNG_Einfach.ubl.xml");
		assertNull(importer(xml).extractInvoice().getCreditorReferenceID());

		String withSEPA = replaceOnce(xml, "</cac:PartyIdentification>",
			"</cac:PartyIdentification><cac:PartyIdentification><cbc:ID schemeID=\"SEPA\">DE98ZZZ09999999999</cbc:ID></cac:PartyIdentification>");
		assertEquals("DE98ZZZ09999999999", importer(withSEPA).extractInvoice().getCreditorReferenceID());
	}

	/**
	 * Order-X was only recognized with the namespace prefix "rsm".
	 */
	@Test
	public void testOrderXDetectionDoesNotDependOnPrefix() throws Exception {
		String xml = readResource("ORDER-X_EX01_ORDER_FULL_DATA-COMFORTorder-x.xml")
			.replace("rsm:", "ord:").replace("xmlns:rsm=", "xmlns:ord=");

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.setRawXML(xml.getBytes(StandardCharsets.UTF_8), false);
		assertEquals(EStandard.ORDER_X, zii.getStandard());
	}

	/**
	 * CII: the account name was not reset between payment means, and the payment means information was dropped.
	 */
	@Test
	public void testCIIPaymentMeansDoNotLeak() throws Exception {
		String xml = replaceOnce(readResource("multiple-payment-means.cii.xml"),
			"<ram:IBANID>DE8576040061XXXXXXXXXX</ram:IBANID>",
			"<ram:IBANID>DE8576040061XXXXXXXXXX</ram:IBANID><ram:AccountName>Acct One</ram:AccountName>");

		List<BankDetails> bankDetails = importer(xml).extractInvoice().getSender().getBankDetails();

		assertEquals(4, bankDetails.size());
		assertEquals("Acct One", bankDetails.get(0).getAccountName());
		assertNull(bankDetails.get(1).getAccountName());
		assertEquals("Zahlung durch Überweisung", bankDetails.get(1).getPaymentMeansInformation());
	}

	/**
	 * UBL: IBAN, BIC and account name of one PaymentMeans leaked into the following ones.
	 */
	@Test
	public void testUBLPaymentMeansDoNotLeak() throws Exception {
		String xml = replaceOnce(readResource("ubl/XRECHNUNG_Einfach.ubl.xml"), "</cac:PaymentMeans>",
			"</cac:PaymentMeans>"
				+ "<cac:PaymentMeans><cbc:PaymentMeansCode>58</cbc:PaymentMeansCode>"
				+ "<cac:PayeeFinancialAccount><cbc:ID>DE75512108001245126199</cbc:ID></cac:PayeeFinancialAccount></cac:PaymentMeans>"
				+ "<cac:PaymentMeans><cbc:PaymentMeansCode>10</cbc:PaymentMeansCode></cac:PaymentMeans>");

		List<BankDetails> bankDetails = importer(xml).extractInvoice().getSender().getBankDetails();

		assertEquals(2, bankDetails.size());
		assertEquals("DE02120300000000202051", bankDetails.get(0).getIBAN());
		assertEquals("BYLADEM1001", bankDetails.get(0).getBIC());
		assertEquals("DE75512108001245126199", bankDetails.get(1).getIBAN());
		assertNull(bankDetails.get(1).getBIC());
		assertNull(bankDetails.get(1).getAccountName());
	}

	/**
	 * unitCode is optional for BasisPeriodMeasure, the import used to fail with a NullPointerException.
	 * A discount whose period has no unit cannot be converted to days and is skipped.
	 */
	@Test
	public void testBasisPeriodMeasureWithoutUnitCode() throws Exception {
		String xml = replaceOnce(readResource("cii/extended_warenrechnung_based_doublecashdiscount.xml"),
			"<ram:BasisPeriodMeasure unitCode=\"DAY\">14</ram:BasisPeriodMeasure>",
			"<ram:BasisPeriodMeasure>14</ram:BasisPeriodMeasure>");

		CashDiscount[] cashDiscounts = importer(xml).extractInvoice().getCashDiscounts();

		assertEquals(1, cashDiscounts.length);
		assertEquals(7, cashDiscounts[0].getDays());
	}

	/**
	 * A zero quantity with scale (as written by Mustang, e.g. 0.0000) is not equal to BigDecimal.ZERO, so recalculating
	 * the price from the line total divided by zero.
	 */
	@Test
	public void testRecalculatePricesWithZeroQuantity() throws ParseException, XPathExpressionException, IOException {
		String xml = replaceOnce(readResource("cii/extended_warenrechnung_based_doublecashdiscount.xml"),
			"<ram:BilledQuantity unitCode=\"H87\">100.0000</ram:BilledQuantity>",
			"<ram:BilledQuantity unitCode=\"H87\">0.0000</ram:BilledQuantity>");

		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.doRecalculateItemPricesFromLineTotals();
		zii.fromXML(xml);

		assertEquals(0, zii.extractInvoice().getZFItems()[0].getQuantity().signum());
	}
}
