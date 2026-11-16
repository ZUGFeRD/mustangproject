package org.mustangproject.dates;

import org.mustangproject.Allowance;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.LogisticsServiceCharge;
import org.mustangproject.PaymentTerms;
import org.mustangproject.Product;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.TradeParty;
import org.mustangproject.ZUGFeRD.IZUGFeRDPaymentDiscountTerms;
import org.mustangproject.ZUGFeRD.IZUGFeRDPaymentTerms;

import java.math.BigDecimal;
import java.util.Date;

import static org.mustangproject.dates.Days.date;

/**
 * Invoices for the date tests. Call them inside the zone under test, because the dates are
 * created at midnight of the current default zone.
 */
final class TestInvoices {

	private TestInvoices() {
	}

	static TradeParty sender() {
		return new TradeParty("Test company", "teststr", "55232", "teststadt", "DE").addVATID("DE123456788");
	}

	static TradeParty recipient() {
		return new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE");
	}

	static Item item() {
		return new Item(new Product("Testprodukt", "", "C62", new BigDecimal("19")), new BigDecimal("100.00"), BigDecimal.ONE);
	}

	/**
	 * An invoice with a different day of January 2024 on every date field the CII export
	 * knows, so each value in the XML can be traced back to exactly one field:
	 * 1 issue, 2 due, 3 delivery, 4 tax point, 5 tax conversion rate, 6/7 delivery period,
	 * 8/9 line delivery period, 10 line delivery note, 11 delivery note, 12 buyer order,
	 * 13 preceding invoice, 14 object identifier, 15 related document, 16 contract,
	 * 17 payment terms due date, 18 discount base date, 19 allowance tax point, 20 line buyer order,
	 * 21 seller order, 22 tender, 23 despatch advice, 24 line seller order, 25 line contract,
	 * 26 line referenced document, 27 line additional reference, 28 line despatch advice,
	 * 29 logistics service charge tax point.
	 */
	static Invoice allDatesInvoice() {
		Item item = item()
			.setDetailedDeliveryPeriod(date(2024, 1, 8), date(2024, 1, 9))
			.setDeliveryNoteReferencedDocument(new ReferencedDocument("DN-L", date(2024, 1, 10)))
			.setBuyerOrderReferencedDocument(new ReferencedDocument("BO-L", date(2024, 1, 20)))
			.setSellerOrderReferencedDocument(new ReferencedDocument("SO-L", date(2024, 1, 24)))
			.setContractReferencedDocument(new ReferencedDocument("C-L", date(2024, 1, 25)))
			.addReferencedDocument(new ReferencedDocument("REF-L", date(2024, 1, 26)))
			.addAdditionalReference(new ReferencedDocument("ADD-L", "130", "AAA", date(2024, 1, 27)))
			.setDespatchAdviceReferencedDocument(new ReferencedDocument("DA-L", date(2024, 1, 28)));
		return new Invoice()
			.setIssueDate(date(2024, 1, 1))
			.setDueDate(date(2024, 1, 2))
			.setDeliveryDate(date(2024, 1, 3))
			.setTaxPointDate(date(2024, 1, 4))
			.setCurrency("CHF")
			.setTaxCurrency("EUR")
			.setTaxConversionRate(new BigDecimal("1.1"))
			.setTaxConversionRateDateTime(date(2024, 1, 5))
			.setDetailedDeliveryPeriod(date(2024, 1, 6), date(2024, 1, 7))
			.setDeliveryNoteReferencedDocument(new ReferencedDocument("DN-H", date(2024, 1, 11)))
			.setBuyerOrderReferencedDocument(new ReferencedDocument("BO-H", date(2024, 1, 12)))
			.setSellerOrderReferencedDocument(new ReferencedDocument("SO-H", date(2024, 1, 21)))
			.setTenderReferencedDocument(new ReferencedDocument("T-1", date(2024, 1, 22)))
			.setDespatchAdviceReferencedDocument(new ReferencedDocument("DA-H", date(2024, 1, 23)))
			.addInvoiceReferencedDocument(new ReferencedDocument("R-1", date(2024, 1, 13)))
			.setObjectIdentifierReferencedDocument("OI-1", "AAA", date(2024, 1, 14))
			.setRelatedReferencedDocument("REL-1", "AAA", date(2024, 1, 15))
			.setContractReferencedDocument(new ReferencedDocument("C-1", date(2024, 1, 16)))
			.setExtendedPaymentTerms(new IZUGFeRDPaymentTerms[] {
				new PaymentTerms("pay 1", date(2024, 1, 17)),
				new PaymentTerms("pay 2", null, new DiscountTerms(date(2024, 1, 18)))
			})
			.addAllowance(new Allowance(new BigDecimal("1.00")).setTaxRateApplicablePercent(new BigDecimal("19")).setTaxPointDate(date(2024, 1, 19)))
			.addLogisticServiceCharge(new LogisticsServiceCharge(new BigDecimal("5.00")).setDescription("Freight").setTaxRateApplicablePercent(new BigDecimal("19")).setTaxPointDate(date(2024, 1, 29)))
			.setSender(sender())
			.setRecipient(recipient())
			.setNumber("INV-1")
			.addItem(item);
	}

	/** the date fields every exporter supports, same day numbers as allDatesInvoice() */
	static Invoice basicDatesInvoice() {
		return new Invoice()
			.setIssueDate(date(2024, 1, 1))
			.setDueDate(date(2024, 1, 2))
			.setDeliveryDate(date(2024, 1, 3))
			.setDetailedDeliveryPeriod(date(2024, 1, 6), date(2024, 1, 7))
			.setBuyerOrderReferencedDocument(new ReferencedDocument("BO-H", date(2024, 1, 12)))
			.setSender(sender())
			.setRecipient(recipient())
			.setNumber("INV-2")
			.addItem(item()
				.setDetailedDeliveryPeriod(date(2024, 1, 8), date(2024, 1, 9))
				// UBL despatch advice needs a buyer order line reference
				.setBuyerOrderReferencedDocument(new ReferencedDocument("BO-H").setLineID("1")));
	}

	/**
	 * A 2 % cash discount without BasisPeriodMeasure, so the importer computes its days from
	 * the payment terms due date (2024-04-03) minus the issue date (2024-03-20).
	 */
	static Invoice cashDiscountInvoice() {
		return new Invoice()
			.setIssueDate(date(2024, 3, 20))
			.setDeliveryDate(date(2024, 3, 21))
			.setPaymentTerms(new PaymentTerms("2% Skonto", date(2024, 4, 3), new DiscountTerms(null)))
			.setSender(sender())
			.setRecipient(recipient())
			.setNumber("INV-4")
			.addItem(item());
	}

	/** 2 % discount; with a base date the export writes BasisDateTime and a 14-day period */
	private static class DiscountTerms implements IZUGFeRDPaymentDiscountTerms {
		private final Date baseDate;

		DiscountTerms(Date baseDate) {
			this.baseDate = baseDate;
		}

		@Override
		public BigDecimal getCalculationPercentage() {
			return new BigDecimal("2");
		}

		@Override
		public Date getBaseDate() {
			return baseDate;
		}

		@Override
		public int getBasePeriodMeasure() {
			return 14;
		}

		@Override
		public String getBasePeriodUnitCode() {
			return "DAY";
		}
	}
}
