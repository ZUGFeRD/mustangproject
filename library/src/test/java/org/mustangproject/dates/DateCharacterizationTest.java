package org.mustangproject.dates;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.mustangproject.CashDiscount;
import org.mustangproject.EStandard;
import org.mustangproject.Invoice;
import org.mustangproject.XMLTools;
import org.mustangproject.ZUGFeRD.DAPullProvider;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.IZUGFeRDPaymentTerms;
import org.mustangproject.ZUGFeRD.OXPullProvider;
import org.mustangproject.ZUGFeRD.Profiles;
import org.mustangproject.ZUGFeRD.UBLDAPullProvider;
import org.mustangproject.ZUGFeRD.XRechnungImporter;
import org.mustangproject.ZUGFeRD.ZUGFeRD1PullProvider;
import org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat;
import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.Callable;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mustangproject.dates.Days.date;
import static org.mustangproject.dates.Days.issueDate;
import static org.mustangproject.dates.TestInvoices.allDatesInvoice;
import static org.mustangproject.dates.TestInvoices.basicDatesInvoice;
import static org.mustangproject.dates.TestInvoices.cashDiscountInvoice;
import static org.mustangproject.dates.TestInvoices.item;
import static org.mustangproject.dates.TestInvoices.recipient;
import static org.mustangproject.dates.TestInvoices.sender;
import static org.mustangproject.dates.TimeZones.BERLIN;
import static org.mustangproject.dates.TimeZones.UTC;
import static org.mustangproject.dates.TimeZones.inZone;
import static org.mustangproject.dates.TimeZones.inZoneAndLocale;
import static org.mustangproject.dates.TimeZones.runInZone;
import static org.mustangproject.dates.XmlDates.dateString;
import static org.mustangproject.dates.XmlDates.dateTime;
import static org.mustangproject.dates.XmlDates.dates;
import static org.mustangproject.dates.XmlDates.export;
import static org.mustangproject.dates.XmlDates.exportAsString;
import static org.mustangproject.dates.XmlDates.importInvoice;
import static org.mustangproject.dates.XmlDates.readResource;
import static org.mustangproject.dates.XmlDates.replaceOnce;
import static org.mustangproject.dates.XmlDates.text;
import static org.mustangproject.dates.XmlDates.zf2;

/**
 * Characterization tests for the current java.util.Date handling.
 * <p>
 * They pin down what the library does today, including behaviour that is probably wrong
 * (marked CURRENT BEHAVIOUR). They are the safety net for fixes and a possible java.time migration:
 * a fix changes the affected assertion on purpose, the migration itself should not change any.
 * <p>
 * Most tests work on XML and JSON, which should survive a migration unchanged. Users run in
 * either UTC or Europe/Berlin, so every test that depends on the zone runs in both zones
 * (parameterized with zones()); tests that show a difference between the zones compare them
 * explicitly.
 * <p>
 * Surefire runs with -Duser.timezone=UTC, which hides every time zone effect, so the
 * tests switch the default zone explicitly using a helper class ({@link TimeZones}).
 */
class DateCharacterizationTest {

	private static final String LINE = "SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/";
	private static final String AGREEMENT = "SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/";
	private static final String DELIVERY = "SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/";
	private static final String SETTLEMENT = "SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/";

	/** the zones users run in */
	static Stream<ZoneId> zones() {
		return Stream.of(UTC, BERLIN);
	}

	// ---------------------------------------------------------------- export: the complete list of dates per exporter

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportZugferd2ExtendedWithEveryDateField(ZoneId zone) throws Exception {
		// allDatesInvoice() sets every date field the library knows (numbered 1-29, see there).
		// The allowance tax point date (19) is correctly not written: the Factur-X EXTENDED
		// Schematron marks it as not used.
		// CURRENT BEHAVIOUR: the invoice due date (2) is silently dropped when explicit payment
		// terms exist: CII has only one place for a due date, the payment terms, and those then
		// write their own due date (17). The logistics service charge tax point date (29) is
		// written, although the Schematron marks it as not used as well.
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240101"),
			dateTime(LINE + "SpecifiedLineTradeAgreement/SellerOrderReferencedDocument/FormattedIssueDateTime", "20240124"),
			dateTime(LINE + "SpecifiedLineTradeAgreement/BuyerOrderReferencedDocument/FormattedIssueDateTime", "20240120"),
			dateTime(LINE + "SpecifiedLineTradeAgreement/ContractReferencedDocument/FormattedIssueDateTime", "20240125"),
			dateTime(LINE + "SpecifiedLineTradeAgreement/AdditionalReferencedDocument/FormattedIssueDateTime", "20240126"),
			dateTime(LINE + "SpecifiedLineTradeDelivery/DespatchAdviceReferencedDocument/FormattedIssueDateTime", "20240128"),
			dateTime(LINE + "SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument/FormattedIssueDateTime", "20240110"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime", "20240108"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime", "20240109"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/AdditionalReferencedDocument/FormattedIssueDateTime", "20240127"),
			dateTime(AGREEMENT + "SellerOrderReferencedDocument/FormattedIssueDateTime", "20240121"),
			dateTime(AGREEMENT + "BuyerOrderReferencedDocument/FormattedIssueDateTime", "20240112"),
			dateTime(AGREEMENT + "ContractReferencedDocument/FormattedIssueDateTime", "20240116"),
			dateTime(AGREEMENT + "AdditionalReferencedDocument/FormattedIssueDateTime", "20240114"),
			dateTime(AGREEMENT + "AdditionalReferencedDocument/FormattedIssueDateTime", "20240122"),
			dateTime(AGREEMENT + "AdditionalReferencedDocument/FormattedIssueDateTime", "20240115"),
			dateTime(DELIVERY + "ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240103"),
			dateTime(DELIVERY + "DespatchAdviceReferencedDocument/FormattedIssueDateTime", "20240123"),
			dateTime(DELIVERY + "DeliveryNoteReferencedDocument/FormattedIssueDateTime", "20240111"),
			dateTime(SETTLEMENT + "TaxApplicableTradeCurrencyExchange/ConversionRateDateTime", "20240105"),
			dateString(SETTLEMENT + "ApplicableTradeTax/TaxPointDate", "20240104"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/StartDateTime", "20240106"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/EndDateTime", "20240107"),
			dateString(SETTLEMENT + "SpecifiedLogisticsServiceCharge/AppliedTradeTax/TaxPointDate", "20240129"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/DueDateDateTime", "20240117"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisDateTime", "20240118"),
			dateTime(SETTLEMENT + "InvoiceReferencedDocument/FormattedIssueDateTime", "20240113"));
		runInZone(zone, () -> assertEquals(expected, dates(export(zf2("EXTENDED"), allDatesInvoice()))));
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportZugferd2EN16931AndXRechnung(ZoneId zone) throws Exception {
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240101"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime", "20240108"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime", "20240109"),
			dateTime(AGREEMENT + "BuyerOrderReferencedDocument/FormattedIssueDateTime", "20240112"),
			dateTime(DELIVERY + "ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240103"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/StartDateTime", "20240106"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/EndDateTime", "20240107"),
			text(SETTLEMENT + "SpecifiedTradePaymentTerms/Description", "Please remit until 02.01.2024"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/DueDateDateTime", "20240102"));
		runInZone(zone, () -> {
			assertEquals(expected, dates(export(zf2("EN16931"), basicDatesInvoice())));
			assertEquals(expected, dates(export(zf2("XRechnung"), basicDatesInvoice())));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportOrderX(ZoneId zone) throws Exception {
		// Order-X 1.0 has no actual delivery date and no payment due date, so neither is
		// written; the due date only appears in the payment terms text.
		// CURRENT BEHAVIOUR: the billing period dates (6-9) are written although Order-X has
		// no billing period, which makes the output schema-invalid. The delivery date is not
		// written as requested delivery date, and the buyer order date (12) is missing,
		// although Order-X has both. No test validates the generated Order-X against the
		// schema, which is a big part of why this went unnoticed.
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240101"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime", "20240108"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime", "20240109"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/StartDateTime", "20240106"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/EndDateTime", "20240107"),
			text(SETTLEMENT + "SpecifiedTradePaymentTerms/Description", "Zahlbar ohne Abzug bis 02.01.2024"));
		runInZone(zone, () -> {
			OXPullProvider provider = new OXPullProvider();
			provider.setProfile(Profiles.getByName(EStandard.ORDER_X, "EXTENDED", 1));
			assertEquals(expected, dates(export(provider, basicDatesInvoice())));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportOrderXWithEveryDateField(ZoneId zone) throws Exception {
		// The payment terms due date (17) is correctly absent, Order-X has no payment due date.
		// CURRENT BEHAVIOUR: the billing period dates (6-9), the preceding invoice date (13) and
		// the discount base date (18) are written although Order-X has none of these fields,
		// which makes the output schema-invalid (not caught because no test validates against
		// the schema, see exportOrderX). The buyer order (12), seller order (21) and contract
		// (16) dates are missing, although Order-X has them.
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240101"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime", "20240108"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime", "20240109"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/StartDateTime", "20240106"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/EndDateTime", "20240107"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisDateTime", "20240118"),
			dateTime(SETTLEMENT + "InvoiceReferencedDocument/FormattedIssueDateTime", "20240113"));
		runInZone(zone, () -> {
			OXPullProvider provider = new OXPullProvider();
			provider.setProfile(Profiles.getByName(EStandard.ORDER_X, "EXTENDED", 1));
			assertEquals(expected, dates(export(provider, allDatesInvoice())));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportDeliverX(ZoneId zone) throws Exception {
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240101"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime", "20240108"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime", "20240109"),
			dateTime(DELIVERY + "ActualDespatchSupplyChainEvent/OccurrenceDateTime", "20240103"));
		runInZone(zone, () -> assertEquals(expected, dates(export(new DAPullProvider(), basicDatesInvoice()))));
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportZugferd1(ZoneId zone) throws Exception {
		// basicDatesInvoice() sets the dates every exporter supports, numbered as in allDatesInvoice().
		// CURRENT BEHAVIOUR: the billing periods (6-9) and the buyer order date (12) are not
		// written, although ZUGFeRD 1 has fields for them. Without explicit payment terms the
		// due date (2) only appears in the payment terms text, not as a date, see
		// exportZugferd1WithEveryDateField.
		List<String> expected = List.of(
			dateTime("HeaderExchangedDocument/IssueDateTime", "20240101"),
			dateTime("SpecifiedSupplyChainTradeTransaction/ApplicableSupplyChainTradeDelivery/ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240103"),
			text("SpecifiedSupplyChainTradeTransaction/ApplicableSupplyChainTradeSettlement/SpecifiedTradePaymentTerms/Description", "Zahlbar ohne Abzug bis 02.01.2024"));
		runInZone(zone, () -> {
			ZUGFeRD1PullProvider provider = new ZUGFeRD1PullProvider();
			provider.setProfile(Profiles.getByName(EStandard.ZUGFERD, "EXTENDED", 1));
			assertEquals(expected, dates(export(provider, basicDatesInvoice())));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportZugferd1WithEveryDateField(ZoneId zone) throws Exception {
		// allDatesInvoice() sets every date field the library knows (numbered 1-29, see there).
		// ZUGFeRD 1 has no field for some of them, e.g. the tax point date or the preceding
		// invoice. With explicit payment terms, their due date (17) and discount base date (18)
		// are written as dates, unlike exportZugferd1, where the due date only appears in the
		// payment terms text.
		// CURRENT BEHAVIOUR: apart from these two, the issue date and the delivery date, no other
		// date is written, although ZUGFeRD 1 has fields for the billing periods (6-9) and for
		// the issue dates of referenced documents such as buyer order, contract, delivery note
		// and despatch advice.
		List<String> expected = List.of(
			dateTime("HeaderExchangedDocument/IssueDateTime", "20240101"),
			dateTime("SpecifiedSupplyChainTradeTransaction/ApplicableSupplyChainTradeDelivery/ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240103"),
			dateTime("SpecifiedSupplyChainTradeTransaction/ApplicableSupplyChainTradeSettlement/SpecifiedTradePaymentTerms/DueDateDateTime", "20240117"),
			dateTime("SpecifiedSupplyChainTradeTransaction/ApplicableSupplyChainTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisDateTime", "20240118"));
		runInZone(zone, () -> {
			ZUGFeRD1PullProvider provider = new ZUGFeRD1PullProvider();
			provider.setProfile(Profiles.getByName(EStandard.ZUGFERD, "EXTENDED", 1));
			assertEquals(expected, dates(export(provider, allDatesInvoice())));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void exportUblDespatchAdvice(ZoneId zone) throws Exception {
		List<String> expected = List.of(
			text("IssueDate", "2024-01-01"),
			text("Shipment/Delivery/ActualDeliveryDate", "2024-01-03"));
		runInZone(zone, () -> assertEquals(expected, dates(export(new UBLDAPullProvider(), basicDatesInvoice()))));
	}

	@Test
	void exportWritesTheDayInTheJvmZone() throws Exception {
		// A Date is an instant; which calendar day gets written depends on the JVM zone.
		// A migration must keep "Date means JVM default zone" for the Date-based API.
		Callable<List<String>> export = () -> dates(export(zf2("EN16931"), new Invoice()
			.setIssueDate(Date.from(Instant.parse("2024-03-03T23:30:00Z")))
			.setDueDate(Date.from(Instant.parse("2024-03-10T23:30:00Z")))
			.setDeliveryDate(Date.from(Instant.parse("2024-03-17T23:30:00Z")))
			.setSender(sender())
			.setRecipient(recipient())
			.setNumber("INV-3")
			.addItem(item())));
		assertEquals(List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240303"),
			dateTime(DELIVERY + "ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240317"),
			text(SETTLEMENT + "SpecifiedTradePaymentTerms/Description", "Please remit until 10.03.2024"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/DueDateDateTime", "20240310")),
			inZone(UTC, export));
		assertEquals(List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240304"),
			dateTime(DELIVERY + "ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240318"),
			text(SETTLEMENT + "SpecifiedTradePaymentTerms/Description", "Please remit until 11.03.2024"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/DueDateDateTime", "20240311")),
			inZone(BERLIN, export));
	}

	// ---------------------------------------------------------------- import: one assertion per field

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importCiiReadsEveryDateField(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			Invoice invoice = importInvoice(exportAsString(zf2("EXTENDED"), allDatesInvoice()));

			assertEquals(date(2024, 1, 1), invoice.getIssueDate(), "issue date");
			// CURRENT BEHAVIOUR: payment terms blocks overwrite the invoice due date, the last one
			// wins; a block with discount terms uses its discount base date (18) instead of a due
			// date, and leaves the due date unchanged if it has no base date. The discount base
			// date itself is not kept.
			assertEquals(date(2024, 1, 18), invoice.getDueDate(), "due date");
			assertEquals(date(2024, 1, 3), invoice.getDeliveryDate(), "delivery date");
			assertEquals(date(2024, 1, 4), invoice.getTaxPointDate(), "tax point date");
			assertEquals(date(2024, 1, 5), invoice.getTaxConversionRateDateTime(), "tax conversion rate date");
			assertEquals(date(2024, 1, 6), invoice.getDetailedDeliveryPeriodFrom(), "delivery period from");
			assertEquals(date(2024, 1, 7), invoice.getDetailedDeliveryPeriodTo(), "delivery period to");
			assertEquals(date(2024, 1, 11), issueDate(invoice.getDeliveryNoteReferencedDocument()), "delivery note");
			assertEquals(date(2024, 1, 12), issueDate(invoice.getBuyerOrderReferencedDocument()), "buyer order");
			assertEquals(1, invoice.getInvoiceReferencedDocuments().size(), "preceding invoices");
			assertEquals(date(2024, 1, 13), issueDate(invoice.getInvoiceReferencedDocuments().get(0)), "preceding invoice");
			assertEquals(date(2024, 1, 14), issueDate(invoice.getObjectIdentifierReferencedDocument()), "object identifier");
			assertEquals(date(2024, 1, 15), issueDate(invoice.getRelatedReferencedDocument()), "related document");
			assertEquals(date(2024, 1, 16), issueDate(invoice.getContractReferencedDocument()), "contract");
			assertEquals(date(2024, 1, 21), issueDate(invoice.getSellerOrderReferencedDocument()), "seller order");
			assertEquals(date(2024, 1, 22), issueDate(invoice.getTenderReferencedDocument()), "tender");
			assertEquals(date(2024, 1, 23), issueDate(invoice.getDespatchAdviceReferencedDocument()), "despatch advice");
			assertEquals(1, invoice.getZFLogisticsServiceCharges().length, "logistics service charges");
			// The tax point date of a logistics service charge (29) is not imported, which is
			// consistent with the Factur-X EXTENDED Schematron (marked as not used); the export
			// writing it is the questionable part, see exportZugferd2ExtendedWithEveryDateField
			assertNull(invoice.getZFLogisticsServiceCharges()[0].getTaxPointDate(), "logistics service charge tax point date");

			IZUGFeRDPaymentTerms[] paymentTerms = invoice.getExtendedPaymentTerms();
			assertEquals(2, paymentTerms.length, "payment terms");
			assertEquals(date(2024, 1, 17), paymentTerms[0].getDueDate(), "payment terms 1 due date");
			assertNull(paymentTerms[1].getDueDate(), "payment terms 2 due date");
			assertNull(paymentTerms[1].getDiscountTerms(), "discount terms");
			CashDiscount[] cashDiscounts = invoice.getCashDiscounts();
			assertEquals(1, cashDiscounts.length, "cash discounts");
			assertEquals(14, cashDiscounts[0].getDays(), "cash discount days");

			IZUGFeRDExportableItem item = invoice.getZFItems()[0];
			assertEquals(date(2024, 1, 8), item.getDetailedDeliveryPeriodFrom(), "line period from");
			assertEquals(date(2024, 1, 9), item.getDetailedDeliveryPeriodTo(), "line period to");
			assertEquals(date(2024, 1, 10), issueDate(item.getDeliveryNoteReferencedDocument()), "line delivery note");
			assertEquals(date(2024, 1, 20), issueDate(item.getBuyerOrderReferencedDocument()), "line buyer order");
			assertEquals(date(2024, 1, 24), issueDate(item.getSellerOrderReferencedDocument()), "line seller order");
			assertEquals(date(2024, 1, 25), issueDate(item.getContractReferencedDocument()), "line contract");
			assertEquals(1, item.getReferencedDocuments().length, "line referenced documents");
			assertEquals(date(2024, 1, 26), issueDate(item.getReferencedDocuments()[0]), "line referenced document");
			assertEquals(1, item.getAdditionalReferences().length, "line additional references");
			assertEquals(date(2024, 1, 27), issueDate(item.getAdditionalReferences()[0]), "line additional reference");
			assertEquals(date(2024, 1, 28), issueDate(item.getDespatchAdviceReferencedDocument()), "line despatch advice");
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importAndExportRealFacturXKeepsEveryDate(ZoneId zone) throws Exception {
		// third-party input instead of XML generated by this library
		String source = readResource("factur-x.xml");
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20201121"),
			dateTime(DELIVERY + "ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20201110"),
			text(SETTLEMENT + "SpecifiedTradePaymentTerms/Description", "Zahlbar ohne Abzug bis 12.12.2020"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/DueDateDateTime", "20201212"));
		assertEquals(expected, dates(source.getBytes(StandardCharsets.UTF_8)), "source");
		runInZone(zone, () -> {
			Invoice invoice = importInvoice(source);
			assertEquals(date(2020, 11, 21), invoice.getIssueDate(), "issue date");
			assertEquals(date(2020, 11, 10), invoice.getDeliveryDate(), "delivery date");
			assertEquals(date(2020, 12, 12), invoice.getDueDate(), "due date");
			assertEquals(date(2020, 12, 12), invoice.getPaymentTerms().getDueDate(), "payment terms due date");
			assertEquals(expected, dates(export(zf2("EN16931"), invoice)), "export");
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importUbl(ZoneId zone) throws Exception {
		String source = readResource("ubl/BT-128.ubl.xml");
		runInZone(zone, () -> {
			Invoice invoice = importInvoice(source);
			assertEquals(date(2018, 11, 12), invoice.getIssueDate(), "issue date");
			assertEquals(date(2018, 11, 30), invoice.getDueDate(), "due date");
			assertEquals(date(2018, 12, 4), invoice.getDeliveryDate(), "delivery date");
			assertEquals(date(2018, 11, 12), invoice.getDetailedDeliveryPeriodFrom(), "invoice period from");
			assertEquals(date(2018, 11, 30), invoice.getDetailedDeliveryPeriodTo(), "invoice period to");
			assertEquals(1, invoice.getInvoiceReferencedDocuments().size(), "preceding invoices");
			assertEquals(date(2018, 10, 4), issueDate(invoice.getInvoiceReferencedDocuments().get(0)), "preceding invoice");
			// CURRENT BEHAVIOUR: line periods (cac:InvoiceLine/cac:InvoicePeriod) are not imported,
			// although the sample has one (2018-11-12 to 2018-11-30)
			for (IZUGFeRDExportableItem item : invoice.getZFItems()) {
				assertNull(item.getDetailedDeliveryPeriodFrom(), "line period from");
				assertNull(item.getDetailedDeliveryPeriodTo(), "line period to");
			}
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importUblIgnoresTimezoneSuffix(ZoneId zone) throws Exception {
		// xs:date allows a zone; the calendar day as written is kept
		String source = replaceOnce(readResource("ubl/BT-128.ubl.xml"),
			"<cbc:IssueDate>2018-11-12</cbc:IssueDate>", "<cbc:IssueDate>2018-11-12+01:00</cbc:IssueDate>");
		runInZone(zone, () -> assertEquals(date(2018, 11, 12), importInvoice(source).getIssueDate()));
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importZugferd1(ZoneId zone) throws Exception {
		String source = readResource("migration/input/ZUGFeRD1-invoice.xml");
		runInZone(zone, () -> {
			Invoice invoice = importInvoice(source);
			assertEquals(date(2017, 5, 9), invoice.getIssueDate(), "issue date");
			assertEquals(date(2017, 5, 30), invoice.getDueDate(), "due date");
			assertEquals(date(2017, 5, 30), invoice.getPaymentTerms().getDueDate(), "payment terms due date");
			// CURRENT BEHAVIOUR: the ZUGFeRD 1 delivery date (20170507) is not imported: the
			// importer only looks for ApplicableHeaderTradeDelivery (ZUGFeRD 2) and Delivery (UBL),
			// ZUGFeRD 1 uses ApplicableSupplyChainTradeDelivery
			assertNull(invoice.getDeliveryDate(), "delivery date");
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importOrderXFormat203(ZoneId zone) throws Exception {
		// The sample uses format 203 (CCYYMMDDHHMM). Order-X allows 102 and 203 for every
		// date, so this affects any Order-X input with times.
		String source = readResource("ORDER-X_EX01_ORDER_FULL_DATA-COMFORTorder-x.xml");
		runInZone(zone, () -> {
			Invoice invoice = importInvoice(source);
			// CURRENT BEHAVIOUR: 202003311232 is parsed as yyyyMMdd with day 311232, so
			// 2020-03-31 12:32 becomes 2872-04-14
			assertEquals(date(2872, 4, 14), invoice.getIssueDate(), "issue date");
			// CURRENT BEHAVIOUR: the requested delivery date (20200415) and window (202004150900 to
			// 202004301800) of the header are not imported, and neither are those of the lines
			assertNull(invoice.getDetailedDeliveryPeriodFrom(), "delivery period from");
			assertNull(invoice.getDetailedDeliveryPeriodTo(), "delivery period to");
			assertNull(invoice.getDeliveryDate(), "delivery date");
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importFacturXExtendedFormat205(ZoneId zone) throws Exception {
		// Factur-X EXTENDED allows format 205 for referenced document dates; the official
		// Schematron accepts 12 digits (YYYYMMDDHHMM)
		runInZone(zone, () -> {
			String source = replaceOnce(exportAsString(zf2("EXTENDED"), allDatesInvoice()),
				"format=\"102\">20240112<", "format=\"205\">202401121230<");
			// CURRENT BEHAVIOUR: parsed as yyyyMMdd with day 121230, so 2024-01-12 12:30 becomes 2355-12-01
			assertEquals(date(2355, 12, 1), issueDate(importInvoice(source).getBuyerOrderReferencedDocument()));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importIsLenient(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			String source = replaceOnce(exportAsString(zf2("EXTENDED"), allDatesInvoice()),
				"format=\"102\">20240101<", "format=\"102\">20240231<");
			// CURRENT BEHAVIOUR: the invalid 31 February rolls over to 2 March instead of failing
			assertEquals(date(2024, 3, 2), importInvoice(source).getIssueDate());
		});
	}

	@Test
	void importCashDiscountDaysAreTruncatedAcrossDstChange() throws Exception {
		// A cash discount without BasisPeriodMeasure gets its days from the payment terms due
		// date minus the issue date, computed in milliseconds and truncated. 2024-03-20 to
		// 2024-04-03 is 14 days, but in Berlin the DST switch on 2024-03-31 makes it 14 days
		// minus one hour.
		Callable<Integer> roundTripDays = () -> {
			CashDiscount[] discounts = importInvoice(exportAsString(zf2("EXTENDED"), cashDiscountInvoice())).getCashDiscounts();
			assertEquals(1, discounts.length, "cash discounts");
			return discounts[0].getDays();
		};
		assertEquals(14, inZone(UTC, roundTripDays));
		// CURRENT BEHAVIOUR: off by one in zones with DST
		assertEquals(13, inZone(BERLIN, roundTripDays));
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importCashDiscountWithUnparseableDueDateThrows(ZoneId zone) throws Exception {
		// CURRENT BEHAVIOUR: an unparseable date becomes null, and the cash discount days
		// computation calls getTime() on it without a null check
		runInZone(zone, () -> {
			String valid = exportAsString(zf2("EXTENDED"), cashDiscountInvoice());
			// the unchanged invoice imports fine, so the NPE below comes from the invalid date
			importInvoice(valid);
			String source = replaceOnce(valid, "format=\"102\">20240403<", "format=\"102\">invalid<");
			assertThrows(NullPointerException.class, () -> importInvoice(source));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void importCashDiscountWithUnparseableIssueDateThrows(ZoneId zone) throws Exception {
		// CURRENT BEHAVIOUR: same as importCashDiscountWithUnparseableDueDateThrows for the issue date
		runInZone(zone, () -> {
			String valid = exportAsString(zf2("EXTENDED"), cashDiscountInvoice());
			// the unchanged invoice imports fine, so the NPE below comes from the invalid date
			importInvoice(valid);
			String source = replaceOnce(valid, "format=\"102\">20240320<", "format=\"102\">invalid<");
			assertThrows(NullPointerException.class, () -> importInvoice(source));
		});
	}

	// ---------------------------------------------------------------- deprecated Date methods

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	@SuppressWarnings("removal")
	void deprecatedDateMethodsOfReferencedDocuments(ZoneId zone) throws Exception {
		// Every deprecated method of Invoice and Item with a Date in its signature; they set and
		// read the date of a referenced document directly. The deprecated ID setters only make the
		// documents complete for the export.
		// CURRENT BEHAVIOUR: setBuyerOrderReferencedDocumentIssueDateTime is not deprecated, although
		// its getter and all other date setters of this kind were deprecated in the same refactoring
		// (probably an oversight).
		List<String> expected = List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20240101"),
			dateTime(LINE + "SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument/FormattedIssueDateTime", "20240110"),
			dateTime(AGREEMENT + "BuyerOrderReferencedDocument/FormattedIssueDateTime", "20240112"),
			dateTime(DELIVERY + "DeliveryNoteReferencedDocument/FormattedIssueDateTime", "20240111"),
			dateTime(SETTLEMENT + "InvoiceReferencedDocument/FormattedIssueDateTime", "20240113"));
		runInZone(zone, () -> {
			Invoice invoice = new Invoice()
				.setIssueDate(date(2024, 1, 1))
				.setDeliveryNoteReferencedDocumentID("DN-H")
				.setDeliveryNoteReferencedDocumentDate(date(2024, 1, 11))
				.setBuyerOrderReferencedDocumentID("BO-H")
				.setBuyerOrderReferencedDocumentIssueDateTime(date(2024, 1, 12))
				.setInvoiceReferencedDocumentID("R-1")
				.setInvoiceReferencedIssueDate(date(2024, 1, 13))
				.setSender(sender())
				.setRecipient(recipient())
				.setNumber("INV-5")
				.addItem(item()
					.setDeliveryNoteReferencedDocumentID("DN-L")
					.setDeliveryNoteReferencedDocumentDate(date(2024, 1, 10)));

			assertEquals(date(2024, 1, 11), invoice.getDeliveryNoteReferencedDocumentDate(), "delivery note");
			assertEquals(date(2024, 1, 12), invoice.getBuyerOrderReferencedDocumentIssueDateTime(), "buyer order");
			assertEquals(date(2024, 1, 13), invoice.getInvoiceReferencedIssueDate(), "preceding invoice");
			assertEquals(date(2024, 1, 10), invoice.getZFItems()[0].getDeliveryNoteReferencedDocumentDate(), "line delivery note");
			assertEquals(expected, dates(export(zf2("EXTENDED"), invoice)), "export");

			Invoice imported = importInvoice(exportAsString(zf2("EXTENDED"), invoice));
			assertEquals(date(2024, 1, 11), imported.getDeliveryNoteReferencedDocumentDate(), "imported delivery note");
			assertEquals(date(2024, 1, 12), imported.getBuyerOrderReferencedDocumentIssueDateTime(), "imported buyer order");
			assertEquals(date(2024, 1, 13), imported.getInvoiceReferencedIssueDate(), "imported preceding invoice");
			assertEquals(date(2024, 1, 10), imported.getZFItems()[0].getDeliveryNoteReferencedDocumentDate(), "imported line delivery note");
		});
	}

	// ---------------------------------------------------------------- older importer API: dates as strings

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void zugferdImporterStringGetters(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			ZUGFeRDImporter importer = new ZUGFeRDImporter();
			importer.setRawXML(export(zf2("EXTENDED"), allDatesInvoice()));
			assertEquals("20240101", importer.getIssueDate(), "issue date");
			// CURRENT BEHAVIOUR: the due date of the imported invoice, see importCiiReadsEveryDateField
			assertEquals("20240118", importer.getDueDate(), "due date");
			// the text of the XML element, not a parsed and formatted date
			assertEquals("20240103", importer.getDeliveryDate(), "delivery date");
			// CURRENT BEHAVIOUR: the deprecated getTaxPointDate returns the delivery date, as
			// documented in its Javadoc
			assertEquals("20240103", importer.getTaxPointDate(), "tax point date");
			assertEquals(date(2024, 1, 6), importer.getDetailedDeliveryPeriodFrom(), "delivery period from");
			assertEquals(date(2024, 1, 7), importer.getDetailedDeliveryPeriodTo(), "delivery period to");
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void zugferdImporterDueDateWithoutDueDateThrows(ZoneId zone) throws Exception {
		// The due date is optional (BR-CO-25: payment terms text is enough, and credit notes or
		// MINIMUM invoices have none), so a valid invoice without one is common.
		// CURRENT BEHAVIOUR: getDueDate throws a NullPointerException, because it formats the
		// imported due date without a null check
		runInZone(zone, () -> {
			ZUGFeRDImporter withDueDate = new ZUGFeRDImporter();
			withDueDate.setRawXML(export(zf2("EN16931"), basicDatesInvoice()));
			// with a due date getDueDate works, so the NPE below comes from the missing due date
			assertEquals("20240102", withDueDate.getDueDate());
			ZUGFeRDImporter importer = new ZUGFeRDImporter();
			importer.setRawXML(export(zf2("EN16931"), basicDatesInvoice().setDueDate(null)));
			assertThrows(NullPointerException.class, importer::getDueDate);
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void xrechnungImporterStringGetters(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			XRechnungImporter importer = new XRechnungImporter(export(zf2("XRechnung"), basicDatesInvoice()));
			assertEquals("20240101", importer.getIssueDate(), "issue date");
			assertEquals("20240102", importer.getDueDate(), "due date");
			assertEquals("20240103", importer.getDeliveryDate(), "delivery date");
		});
	}

	// ---------------------------------------------------------------- JSON (Jackson)

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void jsonWritesDatesAsEpochMillis(ZoneId zone) throws Exception {
		// switching to LocalDate changes this format, which breaks stored JSON
		runInZone(zone, () -> {
			Date d = date(2024, 3, 4);
			String json = new ObjectMapper().writeValueAsString(basicDatesInvoice().setIssueDate(d));
			assertTrue(json.contains("\"issueDate\":" + d.getTime()), json);
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void jsonRoundTripWithEveryDateField(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			ObjectMapper mapper = new ObjectMapper();
			Invoice copy = mapper.readValue(mapper.writeValueAsString(allDatesInvoice()), Invoice.class);

			assertEquals(date(2024, 1, 1), copy.getIssueDate(), "issue date");
			assertEquals(date(2024, 1, 2), copy.getDueDate(), "due date");
			assertEquals(date(2024, 1, 3), copy.getDeliveryDate(), "delivery date");
			assertEquals(date(2024, 1, 4), copy.getTaxPointDate(), "tax point date");
			assertEquals(date(2024, 1, 5), copy.getTaxConversionRateDateTime(), "tax conversion rate date");
			assertEquals(date(2024, 1, 6), copy.getDetailedDeliveryPeriodFrom(), "delivery period from");
			assertEquals(date(2024, 1, 7), copy.getDetailedDeliveryPeriodTo(), "delivery period to");
			assertEquals(date(2024, 1, 11), issueDate(copy.getDeliveryNoteReferencedDocument()), "delivery note");
			assertEquals(date(2024, 1, 12), issueDate(copy.getBuyerOrderReferencedDocument()), "buyer order");
			assertEquals(1, copy.getInvoiceReferencedDocuments().size(), "preceding invoices");
			assertEquals(date(2024, 1, 13), issueDate(copy.getInvoiceReferencedDocuments().get(0)), "preceding invoice");
			// CURRENT BEHAVIOUR: the object identifier (14) and the related document (15) are lost.
			// Invoice has @JsonIgnore on the String overloads of setObjectIdentifierReferencedDocument and
			// setRelatedReferencedDocument, which makes Jackson ignore the whole property: it is
			// neither written nor read. The annotations were added in 9efeac14 because without them
			// Jackson picks the String setter and fails on the written object. The round trip in
			// DeSerializationTest.testFull300Roundtrip checks the original invoice instead of the
			// deserialized one, so the loss went unnoticed.
			assertNull(copy.getObjectIdentifierReferencedDocument(), "object identifier");
			assertNull(copy.getRelatedReferencedDocument(), "related document");
			assertEquals(date(2024, 1, 16), issueDate(copy.getContractReferencedDocument()), "contract");
			assertEquals(date(2024, 1, 21), issueDate(copy.getSellerOrderReferencedDocument()), "seller order");
			// CURRENT BEHAVIOUR: the tender document (22) is lost for the same reason, @JsonIgnore on
			// the String overload of setTenderReferencedDocument (also added in 9efeac14)
			assertNull(copy.getTenderReferencedDocument(), "tender");
			assertEquals(date(2024, 1, 23), issueDate(copy.getDespatchAdviceReferencedDocument()), "despatch advice");
			// payment terms are @JsonIgnore, so their due date (17) and discount base date (18) do not survive
			assertNull(copy.getPaymentTerms(), "payment terms");
			assertEquals(1, copy.getZFAllowances().length, "allowances");
			assertEquals(date(2024, 1, 19), copy.getZFAllowances()[0].getTaxPointDate(), "allowance tax point date");
			assertEquals(1, copy.getZFLogisticsServiceCharges().length, "logistics service charges");
			assertEquals(date(2024, 1, 29), copy.getZFLogisticsServiceCharges()[0].getTaxPointDate(), "logistics service charge tax point date");

			IZUGFeRDExportableItem item = copy.getZFItems()[0];
			assertEquals(date(2024, 1, 8), item.getDetailedDeliveryPeriodFrom(), "line period from");
			assertEquals(date(2024, 1, 9), item.getDetailedDeliveryPeriodTo(), "line period to");
			assertEquals(date(2024, 1, 10), issueDate(item.getDeliveryNoteReferencedDocument()), "line delivery note");
			assertEquals(date(2024, 1, 20), issueDate(item.getBuyerOrderReferencedDocument()), "line buyer order");
			assertEquals(date(2024, 1, 24), issueDate(item.getSellerOrderReferencedDocument()), "line seller order");
			assertEquals(date(2024, 1, 25), issueDate(item.getContractReferencedDocument()), "line contract");
			assertEquals(1, item.getReferencedDocuments().length, "line referenced documents");
			assertEquals(date(2024, 1, 26), issueDate(item.getReferencedDocuments()[0]), "line referenced document");
			// CURRENT BEHAVIOUR: the line additional references (27) are written but not read back:
			// Item has no setter for them and ignores unknown properties
			assertNull(item.getAdditionalReferences(), "line additional references");
			assertEquals(date(2024, 1, 28), issueDate(item.getDespatchAdviceReferencedDocument()), "line despatch advice");
		});
	}

	@Test
	void jsonWrittenInBerlinAndReadInUtcIsOneDayEarlier() throws Exception {
		// Stored JSON holds epoch millis: midnight in Berlin is 23:00 UTC of the previous day,
		// so reading it in UTC and exporting it writes the previous day for every date
		String json = inZone(BERLIN, () -> new ObjectMapper().writeValueAsString(basicDatesInvoice()));
		assertEquals(List.of(
			dateTime("ExchangedDocument/IssueDateTime", "20231231"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime", "20240107"),
			dateTime(LINE + "SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime", "20240108"),
			dateTime(AGREEMENT + "BuyerOrderReferencedDocument/FormattedIssueDateTime", "20240111"),
			dateTime(DELIVERY + "ActualDeliverySupplyChainEvent/OccurrenceDateTime", "20240102"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/StartDateTime", "20240105"),
			dateTime(SETTLEMENT + "BillingSpecifiedPeriod/EndDateTime", "20240106"),
			text(SETTLEMENT + "SpecifiedTradePaymentTerms/Description", "Please remit until 01.01.2024"),
			dateTime(SETTLEMENT + "SpecifiedTradePaymentTerms/DueDateDateTime", "20240101")),
			inZone(UTC, () -> dates(export(zf2("EN16931"), new ObjectMapper().readValue(json, Invoice.class)))));
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void jsonDateOnlyStringIsReadAsUtcMidnight(ZoneId zone) throws Exception {
		// Jackson reads date strings as UTC regardless of the JVM zone. In UTC and Berlin
		// that is still the same calendar day.
		runInZone(zone, () -> {
			Invoice invoice = new ObjectMapper().readValue("{\"issueDate\":\"2024-03-04\"}", Invoice.class);
			assertEquals(Date.from(Instant.parse("2024-03-04T00:00:00Z")), invoice.getIssueDate());
			assertEquals("20240304", ZUGFeRDDateFormat.DATE.simpleFormat(invoice.getIssueDate()));
		});
	}

	@Test
	void jsonTimestampWithOffsetIsAnInstant() throws Exception {
		// The format used in DeSerializationTest: midnight in Berlin, written as 23:00 UTC
		String json = "{\"issueDate\":\"2018-03-03T23:00:00.000+00:00\"}";
		Callable<String> day = () -> ZUGFeRDDateFormat.DATE.simpleFormat(new ObjectMapper().readValue(json, Invoice.class).getIssueDate());
		assertEquals("20180303", inZone(UTC, day));
		assertEquals("20180304", inZone(BERLIN, day));
	}

	// ---------------------------------------------------------------- parsing: XMLTools.tryDate (public API)

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void tryDateParsesFormat102AndIso(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			assertEquals(date(2024, 3, 4), XMLTools.tryDate("20240304"));
			assertEquals(date(2024, 3, 4), XMLTools.tryDate("2024-03-04"));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void tryDateReturnsNullForUnparseableInput(ZoneId zone) throws Exception {
		runInZone(zone, () -> {
			assertNull(XMLTools.tryDate((String) null));
			assertNull(XMLTools.tryDate(""));
			assertNull(XMLTools.tryDate("abc"));
			// format 610 (month) is not recognised
			assertNull(XMLTools.tryDate("202403"));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void tryDateRollsOverInvalidDates(ZoneId zone) throws Exception {
		// CURRENT BEHAVIOUR: invalid dates roll over (20240231 becomes 2024-03-02) instead of returning null
		runInZone(zone, () -> {
			assertEquals(date(2024, 3, 2), XMLTools.tryDate("20240231"));
			assertEquals(date(2025, 1, 1), XMLTools.tryDate("20241301"));
			assertEquals(date(2024, 3, 1), XMLTools.tryDate("2024-02-30"));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void tryDateIgnoresTrailingText(ZoneId zone) throws Exception {
		// SimpleDateFormat.parse(String) stops after the pattern, so xs:date zones
		// ("2024-03-04+01:00", "2024-03-04Z") are accepted and the zone is ignored.
		// CURRENT BEHAVIOUR: any other trailing text (=garbage) is ignored as well instead of returning null
		runInZone(zone, () -> {
			assertEquals(date(2024, 3, 4), XMLTools.tryDate("2024-03-04+01:00"));
			assertEquals(date(2024, 3, 4), XMLTools.tryDate("2024-03-04Z"));
			assertEquals(date(2024, 3, 4), XMLTools.tryDate("2024-03-04xyz"));
		});
	}

	// ---------------------------------------------------------------- formatting: ZUGFeRDDateFormat (public API; MONTH_OF_YEAR and WEEK_OF_YEAR are not used inside the library)

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void dateFormatWritesFormat102(ZoneId zone) throws Exception {
		// DATE is what the exporters use; udt is written for most dates, qdt by Order-X for referenced documents
		runInZone(zone, () -> {
			assertEquals("20240304", ZUGFeRDDateFormat.DATE.simpleFormat(date(2024, 3, 4)));
			assertEquals("<udt:DateTimeString format=\"102\">20240304</udt:DateTimeString>", ZUGFeRDDateFormat.DATE.udtFormat(date(2024, 3, 4)));
			assertEquals("<qdt:DateTimeString format=\"102\">20240304</qdt:DateTimeString>", ZUGFeRDDateFormat.DATE.qdtFormat(date(2024, 3, 4)));
		});
	}

	@ParameterizedTest(name = "{0}")
	@MethodSource("zones")
	void monthFormat(ZoneId zone) throws Exception {
		runInZone(zone, () -> assertEquals("202403", ZUGFeRDDateFormat.MONTH_OF_YEAR.simpleFormat(date(2024, 3, 4))));
	}

	@Test
	void weekFormatMixesCalendarYearAndWeekNumber() throws Exception {
		// CURRENT BEHAVIOUR: "yyyyww" combines the calendar year with the week number, so dates
		// around New Year get the wrong year: 2024-12-30 is ISO week 1 of 2025, 2021-01-03 is
		// ISO week 53 of 2020.
		// Neither WEEK_OF_YEAR nor MONTH_OF_YEAR is used inside the library,
		// so instead of fixing the pattern, both could be deprecated.
		assertEquals("202401", inZoneAndLocale(UTC, Locale.GERMANY,
			() -> ZUGFeRDDateFormat.WEEK_OF_YEAR.simpleFormat(date(2024, 12, 30))));
		assertEquals("202153", inZoneAndLocale(UTC, Locale.GERMANY,
			() -> ZUGFeRDDateFormat.WEEK_OF_YEAR.simpleFormat(date(2021, 1, 3))));
	}
}
