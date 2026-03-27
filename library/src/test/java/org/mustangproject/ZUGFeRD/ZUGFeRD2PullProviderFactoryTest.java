package org.mustangproject.ZUGFeRD;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.util.Date;

import org.junit.jupiter.api.Test;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

public class ZUGFeRD2PullProviderFactoryTest {

	static class TestTransactionCalculator extends TransactionCalculator {

		private boolean called = false;

		public TestTransactionCalculator(IExportableTransaction trans) {
			super(trans);
		}

		@Override
		public BigDecimal getGrandTotal() {
			called = true;
			return BigDecimal.valueOf(999.99);
		}

		public boolean wasCalled() {
			return called;
		}
	}

	static class TestPullProvider extends ZUGFeRD2PullProvider {

		private TestTransactionCalculator calculator;

		@Override
		protected TransactionCalculator createCalculator(IExportableTransaction trans) {
			calculator = new TestTransactionCalculator(trans);
			return calculator;
		}

		public TestTransactionCalculator getCalculator() {
			return calculator;
		}
	}

	@Test
	void customCalculatorIsUsed() throws Exception {

		TradeParty buyer = new TradeParty("Client X", "3 rue C", "33000", "Bordeaux", "FR");
		TradeParty seller = new TradeParty("Mairie A", "1 rue A", "75001", "Paris", "FR");

		Invoice invoice = new Invoice().setNumber("INV-CALC-001").setIssueDate(new Date()).setDeliveryDate(new Date())
				.setDueDate(new Date()).setCurrency("EUR").setSender(buyer).setRecipient(seller);

		Product service = new Product("Prestation", "Service intercommunal", "C62", new BigDecimal("20.00"));

		invoice.addItem(new Item(service, BigDecimal.ONE, BigDecimal.TEN).setTax(BigDecimal.valueOf(20)));

		TestPullProvider provider = new TestPullProvider();

		provider.generateXML(invoice);

		assertNotNull(provider.getCalculator());
		assertTrue(provider.getCalculator().wasCalled());
	}
}
