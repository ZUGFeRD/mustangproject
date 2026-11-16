package org.mustangproject.dates;

import org.mustangproject.Invoice;
import org.mustangproject.ZUGFeRD.IXMLProvider;
import org.mustangproject.ZUGFeRD.Profiles;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;
import org.mustangproject.ZUGFeRD.ZUGFeRDInvoiceImporter;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Export, import and inspection of the dates in an XML document.
 */
final class XmlDates {

	/** date-like text inside a description, e.g. "Please remit until 02.01.2024" */
	private static final Pattern GERMAN_DATE = Pattern.compile("\\d{2}\\.\\d{2}\\.\\d{4}");

	private XmlDates() {
	}

	static ZUGFeRD2PullProvider zf2(String profile) {
		ZUGFeRD2PullProvider provider = new ZUGFeRD2PullProvider();
		provider.setProfile(Profiles.getByName(profile));
		return provider;
	}

	static byte[] export(IXMLProvider provider, Invoice invoice) {
		provider.generateXML(invoice);
		return provider.getXML();
	}

	static String exportAsString(IXMLProvider provider, Invoice invoice) {
		return new String(export(provider, invoice), StandardCharsets.UTF_8);
	}

	/** imports any format ZUGFeRDInvoiceImporter detects (CII, UBL, ZUGFeRD 1, Order-X) */
	static Invoice importInvoice(String xml) throws Exception {
		ZUGFeRDInvoiceImporter zii = new ZUGFeRDInvoiceImporter();
		zii.doIgnoreCalculationErrors();
		zii.fromXML(xml);
		return zii.extractInvoice();
	}

	/**
	 * Reads a test resource straight from the classpath. Unlike ResourceCase.getResourceAsFile
	 * this creates no temp file; the shared resources are only ever read.
	 */
	static String readResource(String path) throws IOException {
		try (InputStream in = XmlDates.class.getClassLoader().getResourceAsStream(path)) {
			assertNotNull(in, "missing test resource " + path);
			return new String(in.readAllBytes(), StandardCharsets.UTF_8);
		}
	}

	static String replaceOnce(String text, String search, String replacement) {
		int first = text.indexOf(search);
		assertTrue(first >= 0 && first == text.lastIndexOf(search), "expected exactly one occurrence of " + search);
		return text.substring(0, first) + replacement + text.substring(first + search.length());
	}

	/**
	 * Lists every date in the document as "path=value" in document order, the path starting
	 * below the root element. Descriptions are included when they contain a date.
	 */
	static List<String> dates(byte[] xml) throws Exception {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		Element root = factory.newDocumentBuilder().parse(new ByteArrayInputStream(xml)).getDocumentElement();
		List<String> result = new ArrayList<>();
		collectDates(root, "", result);
		return result;
	}

	/** the entry dates() lists for a udt/qdt:DateTimeString with format 102 below path */
	static String dateTime(String path, String value) {
		return path + "/DateTimeString[@format=102]=" + value;
	}

	/** the entry dates() lists for a udt:DateString with format 102 below path */
	static String dateString(String path, String value) {
		return path + "/DateString[@format=102]=" + value;
	}

	/** the entry dates() lists for an element with the date as text (UBL, descriptions) */
	static String text(String path, String value) {
		return path + "=" + value;
	}

	private static void collectDates(Element element, String path, List<String> result) {
		for (Node child = element.getFirstChild(); child != null; child = child.getNextSibling()) {
			if (!(child instanceof Element)) {
				continue;
			}
			Element e = (Element) child;
			String name = e.getLocalName();
			String childPath = path.isEmpty() ? name : path + "/" + name;
			String value = e.getTextContent().trim();
			if (name.equals("DateTimeString") || name.equals("DateString")) {
				result.add(childPath + "[@format=" + e.getAttribute("format") + "]=" + value);
			} else if (name.equals("IssueDate") || name.equals("DueDate") || name.equals("ActualDeliveryDate")) {
				result.add(text(childPath, value));
			} else if (name.equals("Description") && GERMAN_DATE.matcher(value).find()) {
				result.add(text(childPath, value));
			}
			collectDates(e, childPath, result);
		}
	}
}
