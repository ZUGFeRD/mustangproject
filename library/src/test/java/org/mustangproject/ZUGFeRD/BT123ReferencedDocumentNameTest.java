package org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.TradeParty;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class BT123ReferencedDocumentNameTest extends TestCase {

	/**
	 * BT-123 (supporting document description) used to be written as
	 * &lt;ram:name&gt;...&lt;/ram:Name&gt; — a lowercase opening tag with an uppercase closing tag.
	 * That makes the whole document non-wellformed, so ZUGFeRD2PullProvider#getXML cannot re-parse
	 * its own output: dom4j fails, the Document stays null and XMLWriter#write(null) throws a
	 * NullPointerException without a message. Any invoice with a named referenced document (e.g. an
	 * attached PDF) was therefore unwritable.
	 */
	public void testReferencedDocumentNameIsWellformed() {
		Invoice i = new Invoice()
			.setIssueDate(new Date())
			.setDueDate(new Date())
			.setDeliveryDate(new Date())
			.setSender(new TradeParty("Test company", "teststr", "55232", "teststadt", "DE"))
			.setRecipient(new TradeParty("Franz Müller", "teststr.12", "55232", "Entenhausen", "DE"))
			.setNumber("INV-123")
			.addItem(new Item(
				new Product("Testprodukt", "", "C62", BigDecimal.ZERO),
				new BigDecimal("1.00"),
				BigDecimal.ONE
			));

		ReferencedDocument rd = new ReferencedDocument("ID unique");
		rd.setName("Delivery note description");
		i.setObjectIdentifierReferencedDocument(rd);

		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("XRechnung"));
		zf2p.generateXML(i);

		String xml = new String(zf2p.getXML(), StandardCharsets.UTF_8);

		// getXML() pretty-prints through dom4j, so a non-wellformed name element would have left
		// the output empty (and NPEd) instead of returning a parseable CII invoice.
		assertTrue(xml.contains("<rsm:CrossIndustryInvoice"));

		assertThat(xml)
			.valueByXPath("string(//*[local-name()='AdditionalReferencedDocument']/*[local-name()='Name'])")
			.isEqualTo("Delivery note description");
	}
}
