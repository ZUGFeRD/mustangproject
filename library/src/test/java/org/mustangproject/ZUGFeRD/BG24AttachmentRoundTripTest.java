package org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;
import org.mustangproject.FileAttachment;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.TradeParty;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class BG24AttachmentRoundTripTest extends TestCase {

	private Invoice createInvoice() {
		return new Invoice()
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
	}

	private String writeCII(Invoice i) {
		ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
		zf2p.setProfile(Profiles.getByName("EN16931"));
		zf2p.generateXML(i);
		return new String(zf2p.getXML(), StandardCharsets.UTF_8);
	}

	private Invoice readCII(String xml) throws Exception {
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.setRawXML(xml.getBytes(StandardCharsets.UTF_8));
		return zii.extractInvoice();
	}

	/**
	 * A BG-24 supporting document with an embedded binary (BT-122 + BT-125) is one
	 * ram:AdditionalReferencedDocument with TypeCode 916. The importer used to store it TWICE: the
	 * AttachmentBinaryObject scan puts it into additionalReferencedDocuments (Invoice#embedFileInXML)
	 * and the header trade agreement pass mapped the same element to relatedReferencedDocument.
	 * ZUGFeRD2PullProvider writes both, so every import/export round trip duplicated the attachment —
	 * and each further round trip added another copy.
	 */
	public void testEmbeddedAttachmentIsNotDuplicatedOnRoundTrip() throws Exception {
		Invoice i = createInvoice();
		i.embedFileInXML(new FileAttachment("attachment.pdf", "application/pdf", "Data",
			new byte[]{1, 2, 3}));

		String source = writeCII(i);
		assertThat(source).valueByXPath(
				"count(//*[local-name()='ApplicableHeaderTradeAgreement']/*[local-name()='AdditionalReferencedDocument'])")
			.asInt()
			.isEqualTo(1);

		String reExported = writeCII(readCII(source));

		assertThat(reExported).valueByXPath(
				"count(//*[local-name()='ApplicableHeaderTradeAgreement']/*[local-name()='AdditionalReferencedDocument'])")
			.asInt()
			.isEqualTo(1);
		assertThat(reExported).valueByXPath(
				"count(//*[local-name()='AttachmentBinaryObject'])")
			.asInt()
			.isEqualTo(1);
	}

	/**
	 * The duplicate is only suppressed when the FileAttachment can carry everything the source element
	 * declared. A 916 element with a binary AND e.g. an issue date must still reach
	 * relatedReferencedDocument, because the FileAttachment branch of the writer cannot express that date -
	 * writing the document twice is recoverable, losing a declared field is not.
	 */
	public void testEmbeddedAttachmentWithExtraMetadataIsKept() throws Exception {
		Invoice i = createInvoice();
		Date issueDate = new SimpleDateFormat("yyyyMMdd").parse("20260722");
		ReferencedDocument rd = new ReferencedDocument("attachment.pdf");
		rd.setAttachmentBinaryObject(new FileAttachment("attachment.pdf", "application/pdf", "Data",
			new byte[]{1, 2, 3}));
		rd.setFormattedIssueDateTime(issueDate);
		i.setRelatedReferencedDocument(rd);

		Invoice imported = readCII(writeCII(i));

		assertNotNull(imported.getRelatedReferencedDocument());
		assertEquals(issueDate, imported.getRelatedReferencedDocument().getFormattedIssueDateTime());
	}

	/**
	 * CII allows ram:IssuerAssignedID and AttachmentBinaryObject/@filename to differ. The FileAttachment
	 * branch of the writer rebuilds BT-122 from the filename, so such an element must keep going into
	 * relatedReferencedDocument - otherwise the reference would silently come back re-labelled.
	 */
	public void testEmbeddedAttachmentWithOwnIssuerAssignedIdIsKept() throws Exception {
		Invoice i = createInvoice();
		ReferencedDocument rd = new ReferencedDocument("SUPPORT-DOC-4711");
		rd.setAttachmentBinaryObject(new FileAttachment("attachment.pdf", "application/pdf", "Data",
			new byte[]{1, 2, 3}));
		i.setRelatedReferencedDocument(rd);

		Invoice imported = readCII(writeCII(i));

		assertNotNull(imported.getRelatedReferencedDocument());
		assertEquals("SUPPORT-DOC-4711", imported.getRelatedReferencedDocument().getIssuerAssignedID());
	}

	/**
	 * A 916 reference WITHOUT a binary is not a BG-24 attachment and nothing else carries it, so it
	 * must still reach relatedReferencedDocument and survive the round trip.
	 */
	public void testReferenceWithoutBinaryStillRoundTrips() throws Exception {
		Invoice i = createInvoice();
		i.setRelatedReferencedDocument(new ReferencedDocument("related-document-id"));

		Invoice imported = readCII(writeCII(i));

		assertNotNull(imported.getRelatedReferencedDocument());
		assertEquals("related-document-id", imported.getRelatedReferencedDocument().getIssuerAssignedID());
	}
}
