package org.mustangproject.validator;

import org.junit.jupiter.api.Test;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;
import org.mustangproject.ZUGFeRD.Profiles;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;

import java.math.BigDecimal;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class IndustryAssignedIdValidationTest {

	@Test
	void testIndustryAssignedIdValidatesAgainstSchema() {
		TradeParty buyer = new TradeParty("Buyer Corp", "Street 1", "12345", "City", "DE");
		TradeParty seller = new TradeParty("Seller GmbH", "Street 2", "54321", "Town", "DE")
			.setVATID("DE123456789");

		Invoice invoice = new Invoice()
			.setNumber("INV-2026-VAL")
			.setIssueDate(new Date())
			.setDeliveryDate(new Date())
			.setDueDate(new Date())
			.setCurrency("EUR")
			.setSender(seller)
			.setRecipient(buyer);

		Product product = new Product("Widget", "High-tech widget", "H87", new BigDecimal("19.00"))
			.setIndustryAssignedID("PRODUCER-PART-123");

		invoice.addItem(new Item(product, BigDecimal.ONE, BigDecimal.TEN).setTax(BigDecimal.valueOf(19)));

		ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
		provider.setProfile(Profiles.getByName("EXTENDED"));
		provider.generateXML(invoice);

		byte[] xmlData = provider.getXML();
		assertNotNull(xmlData);

		ZUGFeRDValidator validator = new ZUGFeRDValidator();
		String report = validator.validate(xmlData, "invoice.xml");

		assertTrue(
			validator.wasCompletelyValid(),
			"The generated EXTENDED profile invoice with IndustryAssignedID must pass full schema validation:\n" + report
		);
	}
}
