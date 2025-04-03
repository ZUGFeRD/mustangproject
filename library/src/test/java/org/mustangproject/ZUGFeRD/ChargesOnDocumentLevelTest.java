package org.mustangproject.ZUGFeRD;

import org.mustangproject.Charge;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.Date;

public class ChargesOnDocumentLevelTest {

	public static void main(String[] args) {
		BigDecimal thePercent = new BigDecimal("10");
		BigDecimal vat1       = new BigDecimal("19");
		BigDecimal vat2       = new BigDecimal("7");

		TradeParty recipient = new TradeParty("Franz Müller",
																					"teststr.12",
																					"55232",
																					"Entenhausen",
																					"DE").setEmail("info@mueller.com");
		Invoice i = new Invoice().setDueDate(new Date())
														 .setIssueDate(new Date())
														 .setDeliveryDate(new Date())
														 .setSender(new TradeParty("Test company",
																											 "teststr",
																											 "55232",
																											 "teststadt",
																											 "DE").addTaxID("DE4711")
																														.addVATID("DE0815")
																														.setContact(new org.mustangproject.Contact("Hans Test",
																																																			 "+49123456789",
																																																			 "test@example.org"))
																														.addBankDetails(new org.mustangproject.BankDetails("DE12500105170648489890",
																																																							 "COBADEFXXX"))
																														.setEmail("info@example.org"))
														 .setRecipient(recipient)
														 .setReferenceNumber("991-01484-64")//leitweg-id
														 .setNumber("123")
														 .addItem(new Item(new Product("item 01",
																													 "",
																													 "C62",
																													 vat1),
																							 new BigDecimal("10.00"),
																							 new BigDecimal("10.0")))
														 .addItem(new Item(new Product("item 02",
																													 "",
																													 "C62",
																													 vat2),
																							 new BigDecimal("1.00"),
																							 new BigDecimal("10.0")))
														 .addCharge(new Charge().setPercent(thePercent)
																										.setTaxPercent(vat1)
																										.setReason("Teuerungszuschlag"))
														 .addCharge(new Charge().setPercent(thePercent)
																										.setTaxPercent(vat2)
																										.setReason("Teuerungszuschlag"));

		// Expected values


		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);

		try {
			Files.write(new File("ChargesOnDocumentLevel.xml").toPath(),
									zf2p.getXML());
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}

