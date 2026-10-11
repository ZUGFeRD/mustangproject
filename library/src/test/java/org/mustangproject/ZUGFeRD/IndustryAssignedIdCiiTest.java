package org.mustangproject.ZUGFeRD;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import org.junit.jupiter.api.Test;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

/**
 * Unit tests for BT-X-532 (IndustryAssignedID / Producer Part Number) emission in CII output.
 * Run: mvn test -pl library -Dtest=IndustryAssignedIdCiiTest
 */
public class IndustryAssignedIdCiiTest {

	@Test
	void industryAssignedId_isEmitted_whenSet() {

		TradeParty buyer = new TradeParty("Client X", "3 rue C", "33000", "Bordeaux", "FR");
		TradeParty seller = new TradeParty("Mairie A", "1 rue A", "75001", "Paris", "FR");

		Invoice invoice = new Invoice()
			.setNumber("INV-TEST-001")
			.setIssueDate(new Date())
			.setDeliveryDate(new Date())
			.setDueDate(new Date())
			.setCurrency("EUR")
			.setSender(seller)
			.setRecipient(buyer);

		// Product with manufacturer / producer part number (BT-X-532)
		Product service = new Product("Prestation", "Service intercommunal", "C62", new BigDecimal("20.00"))
			.setIndustryAssignedID("PRODUCER-PART-999");

		invoice.addItem(new Item(service, BigDecimal.ONE, BigDecimal.TEN).setTax(BigDecimal.valueOf(20)));

		ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
		provider.setProfile(Profiles.getByName("EXTENDED"));
		provider.generateXML(invoice);

		String xml = new String(provider.getXML(), StandardCharsets.UTF_8);

		assertTrue(
			xml.contains("<ram:IndustryAssignedID>PRODUCER-PART-999</ram:IndustryAssignedID>"),
			"XML output must contain the native IndustryAssignedID element with the correct producer part number."
		);
	}

	@Test
	void industryAssignedId_isNotEmitted_whenNull() {

		TradeParty buyer = new TradeParty("Client X", "3 rue C", "33000", "Bordeaux", "FR");
		TradeParty seller = new TradeParty("Mairie A", "1 rue A", "75001", "Paris", "FR");

		Invoice invoice = new Invoice()
			.setNumber("INV-TEST-002")
			.setIssueDate(new Date())
			.setDeliveryDate(new Date())
			.setDueDate(new Date())
			.setCurrency("EUR")
			.setSender(seller)
			.setRecipient(buyer);

		Product service = new Product("Prestation", "Service intercommunal", "C62", new BigDecimal("20.00"));

		invoice.addItem(new Item(service, BigDecimal.ONE, BigDecimal.TEN).setTax(BigDecimal.valueOf(20)));

		ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
		provider.setProfile(Profiles.getByName("EXTENDED"));
		provider.generateXML(invoice);

		String xml = new String(provider.getXML(), StandardCharsets.UTF_8);

		assertFalse(
			xml.contains("IndustryAssignedID"),
			"XML output must not contain IndustryAssignedID when it has not been set."
		);
	}
}
