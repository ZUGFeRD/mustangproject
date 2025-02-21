package org.mustangproject.ZUGFeRD;

import org.junit.Test;
import org.mustangproject.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;

import static java.math.BigDecimal.TEN;
import static java.math.BigDecimal.valueOf;
import static org.junit.Assert.assertEquals;

/***
 * tests the linecalculator and transactioncalculator classes
 *
 */
public class CalculationTest {
	private static final Logger LOGGER = LoggerFactory.getLogger(CalculationTest.class);

	@Test
	public void testLineCalculator_simpleAmounts_resultInValidVATAmount() {
		final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(valueOf(16));
		final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(valueOf(100))
			.setQuantity(TEN)
			.setProduct(product);

		final LineCalculator calculator = new LineCalculator(currentItem);

		assertEquals(valueOf(100).stripTrailingZeros(), calculator.getPrice().stripTrailingZeros());
		assertEquals(valueOf(1000).stripTrailingZeros(), calculator.getItemTotalNetAmount().stripTrailingZeros());
		assertEquals(valueOf(160).stripTrailingZeros(), calculator.getItemTotalVATAmount().stripTrailingZeros());
	}

	@Test
	public void testLineCalculatorInclusiveAllowance() {
		//This test failed with previous implementation. By rounding the totalVATAmount to 2 decimal places the result became wrong
		final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(valueOf(16));
		// 10 % discount on each item
		final IZUGFeRDAllowanceCharge allowance = new IZUGFeRDAllowanceChargeImpl().setTotalAmount(valueOf(14.8730)).setAllowance();

		final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(valueOf(148.73))
			.setQuantity(valueOf(12))
			.addAllowanceCharge(allowance)
			.setProduct(product);

		final LineCalculator calculator = new LineCalculator(currentItem);

		assertEquals(valueOf(133.857).stripTrailingZeros(), calculator.getPrice().stripTrailingZeros());
		assertEquals(valueOf(1606.28).stripTrailingZeros(), calculator.getItemTotalNetAmount().stripTrailingZeros());
		assertEquals(valueOf(257.0048).stripTrailingZeros(), calculator.getItemTotalVATAmount().stripTrailingZeros());
	}

	@Test
	public void testLineCalculatorInclusiveAllowanceAndCharge() {
		final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(valueOf(16));
		// 10 % discount on each item
		final IZUGFeRDAllowanceCharge allowance = new IZUGFeRDAllowanceChargeImpl().setTotalAmount(valueOf(14.873)).setAllowance();
		// 29.746 EUR charge
		final IZUGFeRDAllowanceCharge charge = new IZUGFeRDAllowanceChargeImpl().setTotalAmount(valueOf(29.746));
		final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(valueOf(148.73))
			.setQuantity(valueOf(12))
			.addAllowanceCharge(allowance)
			.setItemCharges(new IZUGFeRDAllowanceCharge[]{charge})
			.setProduct(product);

		final LineCalculator calculator = new LineCalculator(currentItem);

		assertEquals(valueOf(133.857).stripTrailingZeros(), calculator.getPrice().stripTrailingZeros());
		//(133.857*12) + 29.746
		assertEquals(valueOf(1636.03).stripTrailingZeros(), calculator.getItemTotalNetAmount().stripTrailingZeros());
		assertEquals(valueOf(261.7648).stripTrailingZeros(), calculator.getItemTotalVATAmount().stripTrailingZeros());
	}


	@Test
	public void testTotalCalculatorGrandTotalRounding() {
		SimpleDateFormat sqlDate = new SimpleDateFormat("yyyy-MM-dd");

		BigDecimal sales_tax_percent1 = new BigDecimal(16);

		/* invoice (1st part) */

		Invoice invoice = new Invoice();
		invoice.setDocumentName("Rechnung");
		invoice.setNumber("777777");
		try {
			invoice.setIssueDate(sqlDate.parse("2020-12-31"));
			invoice.setDetailedDeliveryPeriod(sqlDate.parse("2020-12-01 - 2020-12-31".split(" - ")[0]), sqlDate.parse("2020-12-01 - 2020-12-31".split(" - ")[1]));
			invoice.setDeliveryDate(sqlDate.parse("2020-12-31"));
			invoice.setDueDate(sqlDate.parse("2021-01-15"));
		} catch (Exception e) {
			LOGGER.error("Failed to set dates", e);

		}

		/* trade party (sender) */
		TradeParty sender = new TradeParty("Maier GmbH", "Musterweg 5", "11111", "Testung", "DE");
		sender.addVATID("DE2222222222");
		invoice.setSender(sender);

		/* trade party (recipient) */
		TradeParty recipient = new TradeParty("Teston GmbH" + " " + "Zentrale" + " " + "", "Testweg 5", "11111", "Testung", "DE");
		recipient.setID("111111");
		recipient.addVATID("DE111111111");
		invoice.setRecipient(recipient);

		/* item */
		Product product;
		IZUGFeRDExportableItemImpl item;

		product = new Product("AAA", "", "H84", sales_tax_percent1).setSellerAssignedID("1AAA");
		item = new IZUGFeRDExportableItemImpl().setProduct(product).setPrice(new BigDecimal("4.750"))
			.setQuantity(new BigDecimal(5.00));

		// set values for additional charge and discount used for next lines
		BigDecimal item_discount = BigDecimal.valueOf(10.00);

		/* lines */
		//percentage only for total line allowance allowed
		if (item_discount.compareTo(BigDecimal.ZERO) > 0) {
			item.addAllowanceCharge(new Allowance().setPercent(item_discount).setTaxPercent(sales_tax_percent1).setReasonCode("95").setReason("Rabatt"));
		}
		invoice.addItem(item);
		//item price: 4.75 -> total line amount: (5 * 4.75) - 0.475 => 23.275

		product = new Product("BBB", "", "H84", sales_tax_percent1).setSellerAssignedID("2BBB");
		item = new IZUGFeRDExportableItemImpl().setProduct(product).setPrice(new BigDecimal("5.750"))
			.setQuantity(new BigDecimal(4.00));

		invoice.addItem(item);
		//item price: 5.75 -> total line amount: (4 * 5.75)  => 23

		product = new Product("CCC", "", "H84", sales_tax_percent1).setSellerAssignedID("3CCC");
		item = new IZUGFeRDExportableItemImpl().setProduct(product).setPrice(new BigDecimal("6.750"))
			.setQuantity(new BigDecimal(3.00));

		invoice.addItem(item);
		//item price: 6.75 -> total line amount: (3 * 6.75)  => 20.25

		product = new Product("DDD", "", "H84", sales_tax_percent1).setSellerAssignedID("4DDD");
		item = new IZUGFeRDExportableItemImpl().setProduct(product)
			.setPrice(new BigDecimal("7.750"))
			.setQuantity(new BigDecimal(2.00));

		invoice.addItem(item);
		//item price: 7.75 -> total line amount: (2 * 7.75)  => 15.5

		product = new Product("EEE", "", "H84", sales_tax_percent1).setSellerAssignedID("5EEE");
		item = new IZUGFeRDExportableItemImpl().setProduct(product)
			.setPrice(new BigDecimal("8.750"))
			.setQuantity(new BigDecimal(1.00));

		invoice.addItem(item);
		//item price: 8.75 -> total line amount: (1 * 8.75)  => 8.75


		BigDecimal total_increase_percent = new BigDecimal(0.80);
		if (total_increase_percent.compareTo(BigDecimal.ZERO) > 0) {
			invoice.addCharge(new Charge().setPercent(total_increase_percent).setTaxPercent(sales_tax_percent1).setReasonCode("ZZZ").setReason("Zuschläge"));
		}
		BigDecimal total_discount_percent = new BigDecimal(2.00);
		if (total_discount_percent.compareTo(BigDecimal.ZERO) > 0) {
			invoice.addAllowance(new Allowance().setPercent(total_discount_percent).setTaxPercent(sales_tax_percent1).setReasonCode("95").setReason("Rabatte"));
		}
		TransactionCalculator calculator = new TransactionCalculator(invoice);
		assertEquals(valueOf(101.86).stripTrailingZeros(), calculator.getGrandTotal().stripTrailingZeros());
	}

	/**
	 * LineCalculator should not throw an exception when calculating a non-terminating decimal expansion
	 */
	@Test
	public void testNonTerminatingDecimalExpansion() {
		final Product product = new Product();
		final IZUGFeRDExportableItem currentItem = new Item().setPrice(valueOf(386.52))
			.setQuantity(BigDecimal.valueOf(31))
			.setBasisQuantity(BigDecimal.valueOf(366))
			.setProduct(product);
		final LineCalculator calculator = new LineCalculator(currentItem);
		assertEquals(BigDecimal.valueOf(32.74), calculator.getItemTotalNetAmount());
	}

}
