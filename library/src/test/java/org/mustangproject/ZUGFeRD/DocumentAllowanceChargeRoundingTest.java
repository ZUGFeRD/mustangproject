package org.mustangproject.ZUGFeRD;

import org.junit.jupiter.api.Test;
import org.mustangproject.Allowance;
import org.mustangproject.Charge;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.xmlunit.assertj.XmlAssert.assertThat;

/**
 * Document level allowances and charges are written with two decimals (BT-92, BT-99), so the totals (BT-107, BT-108,
 * BT-109) and the VAT breakdown (BT-116) have to add up these rounded amounts.
 */
public class DocumentAllowanceChargeRoundingTest {

	private static final String SETTLEMENT = "//*[local-name()='ApplicableHeaderTradeSettlement']";
	private static final String SUMMATION = SETTLEMENT + "/*[local-name()='SpecifiedTradeSettlementHeaderMonetarySummation']";
	private static final String VAT_BREAKDOWN = SETTLEMENT + "/*[local-name()='ApplicableTradeTax']";

	private Invoice createInvoice(Item item) {
		return new Invoice()
			.setIssueDate(new Date())
			.setDueDate(new Date())
			.setDeliveryDate(new Date())
			.setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE").addVATID("DE0815"))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
			.setNumber("INV-123")
			.addItem(item);
	}

	private Item createItem(String price) {
		return new Item(new Product("Testprodukt", "", "C62", new BigDecimal("19")), new BigDecimal(price), BigDecimal.ONE);
	}

	private Allowance percentAllowance(String percent) {
		Allowance allowance = new Allowance().setPercent(new BigDecimal(percent));
		allowance.setTaxRateApplicablePercent(new BigDecimal("19"));
		return allowance;
	}

	private String generate(Invoice invoice) {
		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("EN16931"));
		zf2p.generateXML(invoice);
		return new String(zf2p.getXML(), StandardCharsets.UTF_8);
	}

	/**
	 * #808: 89.90 with a 50% line allowance and a 50% document allowance. The document allowance of 22.475 was written
	 * as 22.48 and the tax basis as 22.47, but the VAT breakdown used 44.95 - 22.475, i.e. 22.48 (BR-S-08).
	 */
	@Test
	public void testLineAndDocumentAllowanceOfIssue808() {
		Invoice invoice = createInvoice(createItem("89.90").addAllowance(new Allowance().setPercent(new BigDecimal("50"))))
			.addAllowance(percentAllowance("50"));

		String xml = generate(invoice);

		assertThat(xml).valueByXPath("string(" + SETTLEMENT + "/*[local-name()='SpecifiedTradeAllowanceCharge']/*[local-name()='ActualAmount'])").isEqualTo("22.48");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='LineTotalAmount'])").isEqualTo("44.95");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='AllowanceTotalAmount'])").isEqualTo("22.48");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='TaxBasisTotalAmount'])").isEqualTo("22.47");
		assertThat(xml).valueByXPath("string(" + VAT_BREAKDOWN + "/*[local-name()='BasisAmount'])").isEqualTo("22.47");
		assertThat(xml).valueByXPath("string(" + VAT_BREAKDOWN + "/*[local-name()='CalculatedAmount'])").isEqualTo("4.27");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='TaxTotalAmount'])").isEqualTo("4.27");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='GrandTotalAmount'])").isEqualTo("26.74");
	}

	/**
	 * Two allowances of 10% of 123.45 are written as 12.35 each, so the allowance total has to be 24.70 (BR-CO-11),
	 * not the rounded sum 24.69 of the unrounded amounts.
	 */
	@Test
	public void testSeveralPercentAllowances() {
		Invoice invoice = createInvoice(createItem("123.45"))
			.addAllowance(percentAllowance("10"))
			.addAllowance(percentAllowance("10"));

		String xml = generate(invoice);

		assertThat(xml).valueByXPath("count(" + SETTLEMENT + "/*[local-name()='SpecifiedTradeAllowanceCharge'][*[local-name()='ActualAmount']='12.35'])").asInt().isEqualTo(2);
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='AllowanceTotalAmount'])").isEqualTo("24.70");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='TaxBasisTotalAmount'])").isEqualTo("98.75");
		assertThat(xml).valueByXPath("string(" + VAT_BREAKDOWN + "/*[local-name()='BasisAmount'])").isEqualTo("98.75");
		assertThat(xml).valueByXPath("string(" + VAT_BREAKDOWN + "/*[local-name()='CalculatedAmount'])").isEqualTo("18.76");
	}

	/**
	 * The same for charges: two charges of 10% of 123.45 are written as 12.35 each, so the charge total has to be
	 * 24.70 (BR-CO-12) and the tax basis 148.15.
	 */
	@Test
	public void testSeveralPercentCharges() {
		Invoice invoice = createInvoice(createItem("123.45"));
		for (int i = 0; i < 2; i++) {
			Charge charge = new Charge().setPercent(new BigDecimal("10"));
			charge.setTaxRateApplicablePercent(new BigDecimal("19"));
			invoice.addCharge(charge);
		}

		String xml = generate(invoice);

		assertThat(xml).valueByXPath("count(" + SETTLEMENT + "/*[local-name()='SpecifiedTradeAllowanceCharge'][*[local-name()='ActualAmount']='12.35'])").asInt().isEqualTo(2);
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='ChargeTotalAmount'])").isEqualTo("24.70");
		assertThat(xml).valueByXPath("string(" + SUMMATION + "/*[local-name()='TaxBasisTotalAmount'])").isEqualTo("148.15");
		assertThat(xml).valueByXPath("string(" + VAT_BREAKDOWN + "/*[local-name()='BasisAmount'])").isEqualTo("148.15");
		assertThat(xml).valueByXPath("string(" + VAT_BREAKDOWN + "/*[local-name()='CalculatedAmount'])").isEqualTo("28.15");
	}
}
