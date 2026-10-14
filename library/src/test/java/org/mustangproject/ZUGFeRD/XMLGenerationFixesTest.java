package org.mustangproject.ZUGFeRD;

import org.junit.jupiter.api.Test;
import org.mustangproject.CashDiscount;
import org.mustangproject.ClassCode;
import org.mustangproject.DesignatedProductClassification;
import org.mustangproject.EStandard;
import org.mustangproject.FileAttachment;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.LegalOrganisation;
import org.mustangproject.LogisticsServiceCharge;
import org.mustangproject.PaymentTerms;
import org.mustangproject.Product;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.TradeParty;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.xmlunit.assertj.XmlAssert.assertThat;

/**
 * Regression tests for defects in the XML generation of the pull providers.
 */
public class XMLGenerationFixesTest {

	private static final Date ISSUE_DATE = new Date(1700000000000L);
	private static final Date DUE_DATE = new Date(1700600000000L);

	private Invoice createInvoice() {
		return new Invoice()
			.setIssueDate(ISSUE_DATE)
			.setDueDate(DUE_DATE)
			.setDeliveryDate(ISSUE_DATE)
			.setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE").addVATID("DE0815"))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
			.setNumber("INV-123")
			.addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal("19")), new BigDecimal("100.00"), BigDecimal.ONE));
	}

	private String generate(Invoice invoice, String profile) {
		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName(profile));
		zf2p.generateXML(invoice);
		return new String(zf2p.getXML(), StandardCharsets.UTF_8);
	}

	private IZUGFeRDPaymentDiscountTerms discountTerms(String percent, Date baseDate) {
		return new IZUGFeRDPaymentDiscountTerms() {
			@Override
			public BigDecimal getCalculationPercentage() {
				return new BigDecimal(percent);
			}

			@Override
			public Date getBaseDate() {
				return baseDate;
			}

			@Override
			public int getBasePeriodMeasure() {
				return 10;
			}

			@Override
			public String getBasePeriodUnitCode() {
				return "DAY";
			}
		};
	}

	/**
	 * URIID used to be filled with the line ID.
	 */
	@Test
	public void testReferencedDocumentURIID() {
		ReferencedDocument rd = new ReferencedDocument("R1").setUriID("https://example.org/doc").setLineID("7");
		String cii = rd.getAsCII(Profiles.getByName("EXTENDED"));

		assertTrue(cii.contains("<ram:URIID>https://example.org/doc</ram:URIID>"), cii);
		assertTrue(cii.contains("<ram:LineID>7</ram:LineID>"), cii);
	}

	/**
	 * Unescaped payment terms descriptions, attachment names, line IDs and class codes made the XML malformed,
	 * which then caused getXML() to fail with a NullPointerException (#793).
	 */
	@Test
	public void testPaymentTermsAndAttachmentsAreEscaped() {
		Invoice invoice = createInvoice();
		Item item = (Item) invoice.getZFItems()[0];
		item.setId("1 & <2>");
		((Product) item.getProduct()).addClassification(new DesignatedProductClassification(new ClassCode("TST", "A&B")));
		invoice
			.setPaymentTerms(new PaymentTerms("2% Skonto & 30 Tage <netto>", DUE_DATE))
			.setAdditionalReferencedDocuments(new FileAttachment[]{
				new FileAttachment("Lieferschein & \"Aufmass\".pdf", "application/pdf", "Data", new byte[]{1, 2, 3}, "Lieferschein & Aufmass")
			});

		String xml = generate(invoice, "EXTENDED");

		assertThat(xml).valueByXPath("string(//*[local-name()='SpecifiedTradePaymentTerms']/*[local-name()='Description'])")
			.isEqualTo("2% Skonto & 30 Tage <netto>");
		assertThat(xml).valueByXPath("string(//*[local-name()='AdditionalReferencedDocument']/*[local-name()='AttachmentBinaryObject']/@filename)")
			.isEqualTo("Lieferschein & \"Aufmass\".pdf");
		assertThat(xml).valueByXPath("string(//*[local-name()='AdditionalReferencedDocument']/*[local-name()='Name'])")
			.isEqualTo("Lieferschein & Aufmass");
		assertThat(xml).valueByXPath("string(//*[local-name()='AssociatedDocumentLineDocument']/*[local-name()='LineID'])")
			.isEqualTo("1 & <2>");
		assertThat(xml).valueByXPath("string(//*[local-name()='DesignatedProductClassification']/*[local-name()='ClassCode'])")
			.isEqualTo("A&B");
	}

	/**
	 * EXTENDED allows several payment terms; f2e8cd00 rejected them for every profile.
	 */
	@Test
	public void testSeveralPaymentTermsInExtended() {
		Invoice invoice = createInvoice()
			.addPaymentTerms(new PaymentTerms("3% Skonto innerhalb 10 Tagen", null, discountTerms("3", null)))
			.addPaymentTerms(new PaymentTerms("30 Tage netto", DUE_DATE));

		String xml = generate(invoice, "EXTENDED");

		assertThat(xml).valueByXPath("count(//*[local-name()='SpecifiedTradePaymentTerms'])").asInt().isEqualTo(2);
	}

	/**
	 * The XSD sequence of TradePaymentDiscountTermsType is BasisDateTime, BasisPeriodMeasure, BasisAmount,
	 * CalculationPercent; the percentage must not be written in scientific notation.
	 */
	@Test
	public void testPaymentDiscountTermsOrder() {
		Invoice invoice = createInvoice()
			.setPaymentTerms(new PaymentTerms("2% Skonto", null, discountTerms("2E+1", ISSUE_DATE)));

		String xml = generate(invoice, "EXTENDED");

		String discountTerms = "//*[local-name()='ApplicableTradePaymentDiscountTerms']";
		assertThat(xml).valueByXPath("local-name(" + discountTerms + "/*[1])").isEqualTo("BasisDateTime");
		assertThat(xml).valueByXPath("local-name(" + discountTerms + "/*[2])").isEqualTo("BasisPeriodMeasure");
		assertThat(xml).valueByXPath("local-name(" + discountTerms + "/*[3])").isEqualTo("BasisAmount");
		assertThat(xml).valueByXPath("local-name(" + discountTerms + "/*[4])").isEqualTo("CalculationPercent");
		assertThat(xml).valueByXPath("string(" + discountTerms + "/*[local-name()='CalculationPercent'])").isEqualTo("20");
	}

	/**
	 * TaxPointDate of a TradeTax is a udt:DateType.
	 */
	@Test
	public void testLogisticsServiceChargeTaxPointDate() {
		Invoice invoice = createInvoice()
			.setZFLogisticsServiceCharges(new LogisticsServiceCharge[]{
				new LogisticsServiceCharge(new BigDecimal("25")).setDescription("Fracht")
					.setTaxRateApplicablePercent(new BigDecimal("19")).setTaxCategoryCode("S").setTaxPointDate(ISSUE_DATE)
			});

		String xml = generate(invoice, "EXTENDED");

		assertThat(xml).valueByXPath("string(//*[local-name()='SpecifiedLogisticsServiceCharge']//*[local-name()='TaxPointDate']/*[local-name()='DateString'])")
			.isEqualTo("20231114");
		assertThat(xml).valueByXPath("count(//*[local-name()='SpecifiedLogisticsServiceCharge']//*[local-name()='TaxPointDate']/*[local-name()='DateTimeString'])")
			.asInt().isEqualTo(0);
	}

	/**
	 * The payment terms description is kept in the provider and used to leak into the next generateXML call.
	 */
	@Test
	public void testPaymentTermsDescriptionDoesNotLeakIntoNextInvoice() {
		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));

		Invoice withCashDiscount = createInvoice().addCashDiscount(new CashDiscount(new BigDecimal("2"), 14));
		zf2p.generateXML(withCashDiscount);
		zf2p.generateXML(withCashDiscount);
		String second = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		assertEquals(1, second.split("#SKONTO#", -1).length - 1, second);

		Invoice withoutTerms = createInvoice().setDueDate(null);
		zf2p.generateXML(withoutTerms);
		String third = new String(zf2p.getXML(), StandardCharsets.UTF_8);
		assertFalse(third.contains("SKONTO"), third);
	}

	/**
	 * A legal organisation of the payee without scheme must not get an empty schemeID.
	 */
	@Test
	public void testPayeeLegalOrganisationWithoutScheme() {
		TradeParty payee = new TradeParty("Payee GmbH", "Weg 1", "12345", "Stadt", "DE")
			.setLegalOrganisation(new LegalOrganisation("HRB 123"));
		Invoice invoice = createInvoice().setPayee(payee);

		String xml = generate(invoice, "EN16931");

		String payeeID = "//*[local-name()='PayeeTradeParty']/*[local-name()='SpecifiedLegalOrganization']/*[local-name()='ID']";
		assertThat(xml).valueByXPath("string(" + payeeID + ")").isEqualTo("HRB 123");
		assertThat(xml).valueByXPath("count(" + payeeID + "/@schemeID)").asInt().isEqualTo(0);
	}

	/**
	 * ZUGFeRD 1 and Order-X threw a NullPointerException when there was neither a due date nor a payment terms text.
	 */
	@Test
	public void testNoDueDateInZF1AndOrderX() {
		Invoice invoice = createInvoice().setDueDate(null);

		ZUGFeRD1PullProvider zf1p = new ZUGFeRD1PullProvider();
		zf1p.setProfile(Profiles.getByName(EStandard.ZUGFERD, "EXTENDED", 1));
		zf1p.generateXML(invoice);
		String zf1 = new String(zf1p.getXML(), StandardCharsets.UTF_8);
		assertFalse(zf1.contains(">null<"), zf1);

		OXPullProvider oxp = new OXPullProvider();
		oxp.generateXML(createInvoice().setDueDate(null));
		assertTrue(new String(oxp.getXML(), StandardCharsets.UTF_8).contains("SCRDMCCBDACIOMessageStructure"));
	}

	/**
	 * udtFormat already returns the udt:DateTimeString element, it used to be nested into another one.
	 */
	@Test
	public void testDeliverXDespatchDateIsNotNested() {
		DAPullProvider dap = new DAPullProvider();
		dap.setProfile(Profiles.getByName(EStandard.DELIVER_X, "Pilot", 1));
		dap.generateXML(createInvoice());
		String xml = new String(dap.getXML(), StandardCharsets.UTF_8);

		String occurrence = "//*[local-name()='ActualDespatchSupplyChainEvent']/*[local-name()='OccurrenceDateTime']";
		assertThat(xml).valueByXPath("count(" + occurrence + "/*[local-name()='DateTimeString'])").asInt().isEqualTo(1);
		assertThat(xml).valueByXPath("count(" + occurrence + "/*[local-name()='DateTimeString']/*)").asInt().isEqualTo(0);
	}

	/**
	 * The UBL despatch advice wrote the document number into the order reference.
	 */
	@Test
	public void testUBLDespatchAdviceOrderReference() {
		Invoice invoice = createInvoice().setNumber("DESADV-1").setReferenceNumber("ORDER-4711");
		for (IZUGFeRDExportableItem item : invoice.getZFItems()) {
			((Item) item).setBuyerOrderReferencedDocument(new ReferencedDocument("ORDER-4711").setLineID("1"));
		}

		UBLDAPullProvider ublp = new UBLDAPullProvider();
		ublp.generateXML(invoice);
		String xml = new String(ublp.getXML(), StandardCharsets.UTF_8);

		assertThat(xml).valueByXPath("string(//*[local-name()='OrderReference']/*[local-name()='ID'])").isEqualTo("ORDER-4711");
	}
}
