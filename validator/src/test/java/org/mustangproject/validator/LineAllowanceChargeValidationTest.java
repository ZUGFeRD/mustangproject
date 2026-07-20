package org.mustangproject.validator;

import java.io.File;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Date;

import javax.xml.transform.Source;

import org.mustangproject.Allowance;
import org.mustangproject.BankDetails;
import org.mustangproject.Charge;
import org.mustangproject.Contact;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.TradeParty;
import org.mustangproject.ZUGFeRD.Profiles;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;
import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;

import junit.framework.TestCase;

/**
 * End-to-end integration test for #925: a generated EN16931/XRechnung invoice carrying a
 * line-level allowance and charge with CalculationPercent (BT-138) / BasisAmount (BT-137) must
 * (a) contain those elements at line level and (b) still pass Schematron/EN16931 validation.
 */
public class LineAllowanceChargeValidationTest extends TestCase {

	private String generate(String profileName) {
		Invoice invoice = new Invoice()
			.setNumber("471102")
			.setReferenceNumber("AB321")
			.setIssueDate(new Date()).setDueDate(new Date()).setDeliveryDate(new Date())
			.setSender(new TradeParty("Bei Spiel GmbH", "Ecke 12", "12345", "Stadthausen", "DE")
				.addVATID("DE136695976").setEmail("seller@example.org")
				.setContact(new Contact("Max Mustermann", "(555) 12 34-56", "seller@example.org"))
				.addBankDetails(new BankDetails("DE88200800000970375700", "COBADEFFXXX").setAccountName("Max Mustermann")))
			.setRecipient(new TradeParty("Theodor Est", "Bahnstr. 42", "88802", "Spielkreis", "DE")
				.addVATID("DE999999999").setEmail("buyer@example.org"))
			.addItem(new Item(new Product("Design", "Sample product", "HUR", new BigDecimal("19")),
				new BigDecimal("100.00"), new BigDecimal("10"))
				.addAllowance(new Allowance(new BigDecimal("100.00"))
					.setPercent(new BigDecimal("10.00"))
					.setBasisAmount(new BigDecimal("1000.00"))
					.setReasonCode("95").setReason("Volume discount"))
				.addCharge(new Charge(new BigDecimal("50.00"))
					.setPercent(new BigDecimal("5.00"))
					.setBasisAmount(new BigDecimal("1000.00"))
					.setReasonCode("ABK").setReason("Handling")));

		ZUGFeRD2PullProvider pp = new ZUGFeRD2PullProvider();
		pp.setProfile(Profiles.getByName(profileName));
		pp.generateXML(invoice);
		return new String(pp.getXML(), StandardCharsets.UTF_8);
	}

	private String validate(String xml) throws Exception {
		File tempFile = File.createTempFile("line-allowance-charge", ".xml");
		tempFile.deleteOnExit();
		Files.write(tempFile.toPath(), xml.getBytes(StandardCharsets.UTF_8));

		final ValidationContext ctx = new ValidationContext(null);
		final XMLValidator xv = new XMLValidator(ctx);
		xv.setFilename(tempFile.getAbsolutePath());
		xv.validate();
		return xv.getXMLResult();
	}

	public void testLineAllowanceChargePercentBasisValidates() throws Exception {
		final XPathEngine xpath = new JAXPXPathEngine();
		for (String profileName : new String[]{"EN16931", "XRechnung"}) {
			String xml = generate(profileName);

			assertTrue(profileName + ": expected line-level CalculationPercent 10.00",
				xml.contains("<ram:CalculationPercent>10.00</ram:CalculationPercent>"));
			assertTrue(profileName + ": expected line-level CalculationPercent 5.00",
				xml.contains("<ram:CalculationPercent>5.00</ram:CalculationPercent>"));
			assertTrue(profileName + ": expected caller-supplied line-level BasisAmount 1000.00",
				xml.contains("<ram:BasisAmount>1000.00</ram:BasisAmount>"));

			String result = validate(xml);
			Source source = Input.fromString("<validation>" + result + "</validation>").build();
			String status = xpath.evaluate("/validation/summary/@status", source);
			assertEquals(profileName + ": Schematron validation must remain valid.\n" + result,
				"valid", status);
		}
	}
}
