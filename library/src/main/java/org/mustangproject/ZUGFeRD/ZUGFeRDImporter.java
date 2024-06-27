/**
 * ********************************************************************** Copyright 2018 Jochen Staerk Use is subject to license terms. Licensed under the
 * Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0. Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions
 * and limitations under the License.
 */
package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation ZUGFeRD importer Licensed under the APLv2
 *
 * @date 2014-07-07
 * @version 1.1.0
 * @author jstaerk
 */

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.PDNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.mustangproject.EStandard;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.XMLTools;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ZUGFeRDImporter {

	/**
	 * if metadata has been found
	 */
	protected boolean containsMeta = false;
	/**
	 * map filenames of additional XML files to their contents
	 */
	private final HashMap<String, byte[]> additionalXMLs = new HashMap<>();
	/**
	 * Raw XML form of the extracted data - may be directly obtained.
	 */
	private byte[] rawXML = null;
	/**
	 * XMP metadata
	 */
	private String xmpString = null; // XMP metadata
	/**
	 * parsed Document
	 */
	private Document document;
	private Integer version;


	protected ZUGFeRDImporter() {
		//constructor for extending classes
	}

	public ZUGFeRDImporter(String pdfFilename) {
		try (InputStream bis = Files.newInputStream(Paths.get(pdfFilename), StandardOpenOption.READ)) {
			extractLowLevel(bis);
		} catch (final IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}


	public ZUGFeRDImporter(InputStream pdfStream) {
		try {
			extractLowLevel(pdfStream);
		} catch (final IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}


	/**
	 * Extracts a ZUGFeRD invoice from a PDF document represented by an input stream. Errors are reported via exception handling.
	 *
	 * @param inStream a inputstream of a pdf file
	 */
	private void extractLowLevel(InputStream inStream) throws IOException {
		BufferedInputStream pdfStream = new BufferedInputStream(inStream);
		byte[] pad = new byte[4];
		pdfStream.mark(0);
		pdfStream.read(pad);
		pdfStream.reset();
		byte[] pdfSignature = {'%', 'P', 'D', 'F'};
		if (Arrays.equals(pad, pdfSignature)) { // we have a pdf


			try (PDDocument doc = PDDocument.load(pdfStream)) {
				// PDDocumentInformation info = doc.getDocumentInformation();
				final PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
				//start

				if (doc.getDocumentCatalog() == null || doc.getDocumentCatalog().getMetadata() == null) {
					Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.INFO, "no-xmlpart");
					return;
				}

				final InputStream XMP = doc.getDocumentCatalog().getMetadata().exportXMPMetadata();
				xmpString = convertStreamToString(XMP);

				final PDEmbeddedFilesNameTreeNode etn = names.getEmbeddedFiles();
				if (etn == null) {
					return;
				}

				final Map<String, PDComplexFileSpecification> efMap = etn.getNames();
				// String filePath = "/tmp/";

				if (efMap != null) {
					extractFiles(efMap); // see
					// https://memorynotfound.com/apache-pdfbox-extract-embedded-file-pdf-document/
				} else {

					final List<PDNameTreeNode<PDComplexFileSpecification>> kids = etn.getKids();
					if (kids == null) {
						return;
					}
					for (final PDNameTreeNode<PDComplexFileSpecification> node : kids) {
						final Map<String, PDComplexFileSpecification> namesL = node.getNames();
						extractFiles(namesL);
					}
				}
			}
		} else {
			// no PDF probably XML
			containsMeta = true;
			setRawXML(XMLTools.getBytesFromStream(pdfStream));

		}
	}


	private void extractFiles(Map<String, PDComplexFileSpecification> names) throws IOException {
		for (final String alias : names.keySet()) {

			final PDComplexFileSpecification fileSpec = names.get(alias);
			final String filename = fileSpec.getFilename();
			/**
			 * filenames for invoice data (ZUGFeRD v1 and v2, Factur-X)
			 */
			if ((filename.equals("ZUGFeRD-invoice.xml") || (filename.equals("zugferd-invoice.xml")) || filename.equals("factur-x.xml")) || filename.equals("xrechnung.xml") || filename.equals("order-x.xml") || filename.equals("cida.xml")) {
				containsMeta = true;

				final PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				// String embeddedFilename = filePath + filename;
				// File file = new File(filePath + filename);
				// System.out.println("Writing " + embeddedFilename);
				// ByteArrayOutputStream fileBytes=new
				// ByteArrayOutputStream();
				// FileOutputStream fos = new FileOutputStream(file);

				setRawXML(embeddedFile.toByteArray());

				// fos.write(embeddedFile.getByteArray());
				// fos.close();
			}
			if (filename.startsWith("additional_data")) {
				final PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				additionalXMLs.put(filename, embeddedFile.toByteArray());
			}
		}
	}


	protected Document getDocument() {
		return document;
	}


	private void setDocument() throws ParserConfigurationException, IOException, SAXException {
		final DocumentBuilderFactory xmlFact = DocumentBuilderFactory.newInstance();
		xmlFact.setNamespaceAware(true);
		final DocumentBuilder builder = xmlFact.newDocumentBuilder();
		final ByteArrayInputStream is = new ByteArrayInputStream(rawXML);
		///	is.skip(guessBOMSize(is));
		document = builder.parse(is);
	}


	public void setRawXML(byte[] rawXML) throws IOException {
		this.rawXML = rawXML;
		this.version = null;
		try {
			setDocument();
		} catch (ParserConfigurationException | SAXException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}


	protected String extractString(String xpathStr) {
		if (!containsMeta) {
			throw new ZUGFeRDExportException("No suitable data/ZUGFeRD file could be found.");
		}
		final String result;
		try {
			final Document document = getDocument();
			final XPathFactory xpathFact = XPathFactory.newInstance();
			final XPath xpath = xpathFact.newXPath();
			result = xpath.evaluate(xpathStr, document);
		} catch (final XPathExpressionException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
		return result;
	}

	/***
	 * Wrapper for protected method extractString
	 * @param xpathStr the xpath expression to be evaluated
	 * @return the extracted String for the specific path in the document
	 */
	public String wExtractString(String xpathStr) {
		return extractString(xpathStr);
	}


	/**
	 * @return the reference (purpose) the sender specified for this invoice
	 */
	public String getForeignReference() {
		String result = extractString("//*[local-name() = 'ApplicableHeaderTradeSettlement']/*[local-name() = 'PaymentReference']");
		if (result == null || result.isEmpty()) {
			result = extractString("//*[local-name() = 'ApplicableSupplyChainTradeSettlement']/*[local-name() = 'PaymentReference']");
		}
		return result;
	}

	/**
	 * @return the ZUGFeRD Profile
	 */
	public String getZUGFeRDProfil() {
		String guideline = extractString("//*[local-name() = 'GuidelineSpecifiedDocumentContextParameter']//*[local-name() = 'ID']");
		if(guideline.contains("xrechnung")) {
			return "XRECHNUNG";
		}
		switch (guideline) {
			case "urn:cen.eu:en16931:2017":
			case "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort":
				return "COMFORT";
			case "urn:cen.eu:en16931:2017#compliant#urn:factur-x.eu:1p0:basic":
			case "urn:ferd:CrossIndustryDocument:invoice:1p0:basic":
				return "BASIC";
			case "urn:factur-x.eu:1p0:basicwl":
				return "BASIC WL";
			case "urn:factur-x.eu:1p0:minimum":
				return "MINIMUM";
			case "urn:ferd:CrossIndustryDocument:invoice:1p0:extended":
			case "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended":
				return "EXTENDED";
			default:
				return "";
		}
	}

	/**
	 * @return the Invoice Currency Code
	 */
	public String getInvoiceCurrencyCode() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'ApplicableSupplyChainTradeSettlement']//*[local-name() = 'InvoiceCurrencyCode']");
			} else {
				return extractString("//*[local-name() = 'ApplicableHeaderTradeSettlement']//*[local-name() = 'InvoiceCurrencyCode']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);

			return "";
		}
	}

	/**
	 * @return the IssuerAssigned ID
	 */
	public String getIssuerAssignedID() {
		return extractIssuerAssignedID("BuyerOrderReferencedDocument");
	}

	/**
	 * @return the SellerOrderReferencedDocument IssuerAssigned ID
	 */
	public String getSellerOrderReferencedDocumentIssuerAssignedID() {
		return extractIssuerAssignedID("SellerOrderReferencedDocument");
	}

	/**
	 * @return the IssuerAssigned ID
	 */
	public String getContractOrderReferencedDocumentIssuerAssignedID() {
		return extractIssuerAssignedID("ContractReferencedDocument");
	}

	private String extractIssuerAssignedID(String propertyName) {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = '" + propertyName + "']//*[local-name() = 'ID']");
			} else {
				return extractString("//*[local-name() = '" + propertyName + "']//*[local-name() = 'IssuerAssignedID']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the BuyerTradeParty ID
	 */
	public String getBuyerTradePartyID() {
		return extractString("//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'ID']");
	}

	/**
	 * @return the Issue Date()
	 */
	public String getIssueDate() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'HeaderExchangedDocument']//*[local-name() = 'IssueDateTime']//*[local-name() = 'DateTimeString']");
			} else {
				return extractString("//*[local-name() = 'ExchangedDocument']//*[local-name() = 'IssueDateTime']//*[local-name() = 'DateTimeString']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	public Date getDetailedDeliveryPeriodFrom() {
		final String toParse = extractString(
			"//*[local-name() = 'ApplicableHeaderTradeSettlement']" +
				"//*[local-name() = 'BillingSpecifiedPeriod']" +
				"//*[local-name() = 'StartDateTime']//*[local-name() = 'DateTimeString']");
		return tryDate(toParse);
	}

	public Date getDetailedDeliveryPeriodTo() {
		final String toParse = extractString(
			"//*[local-name() = 'ApplicableHeaderTradeSettlement']" +
				"//*[local-name() = 'BillingSpecifiedPeriod']" +
				"//*[local-name() = 'EndDateTime']//*[local-name() = 'DateTimeString']");
		return tryDate(toParse);
	}

	/**
	 * @return the TaxBasisTotalAmount
	 */
	public String getTaxBasisTotalAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']//*[local-name() = 'TaxBasisTotalAmount']");
			} else {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']//*[local-name() = 'TaxBasisTotalAmount']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the TaxTotalAmount
	 */
	public String getTaxTotalAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']//*[local-name() = 'TaxTotalAmount']");
			} else {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']//*[local-name() = 'TaxTotalAmount']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the RoundingAmount
	 */
	public String getRoundingAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']//*[local-name() = 'RoundingAmount']");
			} else {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']//*[local-name() = 'RoundingAmount']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the TotalPrepaidAmount
	 */
	public String getPaidAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']//*[local-name() = 'TotalPrepaidAmount']");
			} else {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']//*[local-name() = 'TotalPrepaidAmount']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return SellerTradeParty GlobalID
	 */
	public String getSellerTradePartyGlobalID() {
		return extractString("//*[local-name() = 'SellerTradeParty']//*[local-name() = 'GlobalID']");
	}

	/**
	 * @return the BuyerTradeParty GlobalID
	 */
	public String getBuyerTradePartyGlobalID() {
		return extractString("//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'GlobalID']");
	}

	/**
	 * @return the BuyerTradeParty SpecifiedTaxRegistration ID
	 */
	public String getBuyertradePartySpecifiedTaxRegistrationID() {
		return extractString("//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'SpecifiedTaxRegistration']//*[local-name() = 'ID']");
	}


	/**
	 * @return the IncludedNote
	 */
	public String getIncludedNote() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'HeaderExchangedDocument']//*[local-name() = 'IncludedNote']");
			} else {
				return extractString("//*[local-name() = 'ExchangedDocument']//*[local-name() = 'IncludedNote']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the BuyerTradeParty Name
	 */
	public String getBuyerTradePartyName() {
		return extractString("//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'Name']");
	}

	/**
	 * @return the BuyerTradeParty Name
	 */
	public String getDeliveryTradePartyName() {
		return extractString("//*[local-name() = 'ShipToTradeParty']//*[local-name() = 'Name']");
	}


	/**
	 * @return the line Total Amount
	 */
	public String getLineTotalAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']//*[local-name() = 'LineTotalAmount']");
			} else {
				return extractString("//*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']//*[local-name() = 'LineTotalAmount']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the Payment Terms
	 */
	public String getPaymentTerms() {
		return extractString("//*[local-name() = 'SpecifiedTradePaymentTerms']//*[local-name() = 'Description']");
	}

	/**
	 * @return the Taxpoint Date
	 */
	public String getTaxPointDate() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'ActualDeliverySupplyChainEvent']//*[local-name() = 'OccurrenceDateTime']//*[local-name() = 'DateTimeString']");
			} else {
				return extractString("//*[local-name() = 'ActualDeliverySupplyChainEvent']//*[local-name() = 'OccurrenceDateTime']//*[local-name() = 'DateTimeString']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}

	/**
	 * @return the Invoice ID
	 */
	public String getInvoiceID() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'HeaderExchangedDocument']//*[local-name() = 'ID']");
			} else {
				return extractString("//*[local-name() = 'ExchangedDocument']//*[local-name() = 'ID']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}


	/**
	 * @return the document code
	 */
	public String getDocumentCode() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'HeaderExchangedDocument']/*[local-name() = 'TypeCode']");
			} else {
				return extractString("//*[local-name() = 'ExchangedDocument']/*[local-name() = 'TypeCode']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}


	/**
	 * @return the referred document
	 */
	public String getReference() {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'ApplicableSupplyChainTradeAgreement']/*[local-name() = 'BuyerReference']");
			} else {
				return extractString("//*[local-name() = 'ApplicableHeaderTradeAgreement']/*[local-name() = 'BuyerReference']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return "";
		}
	}


	/**
	 * @return the sender's bank's BIC code
	 */
	public String getBIC() {
		return extractString("//*[local-name() = 'PayeeSpecifiedCreditorFinancialInstitution']/*[local-name() = 'BICID']");
	}


	/**
	 * @return the sender's bank name
	 */
	public String getBankName() {
		return extractString("//*[local-name() = 'PayeeSpecifiedCreditorFinancialInstitution']/*[local-name() = 'Name']");
	}


	/**
	 * @return the sender's account IBAN code
	 */
	public String getIBAN() {
		return extractString("//*[local-name() = 'PayeePartyCreditorFinancialAccount']/*[local-name() = 'IBANID']");
	}


	public String getHolder() {
		return extractString("//*[local-name() = 'SellerTradeParty']/*[local-name() = 'Name']");
	}


	/**
	 * @return the total payable amount
	 */
	public String getAmount() {
		String result = extractString("//*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']/*[local-name() = 'DuePayableAmount']");
		if (result == null || result.isEmpty()) {

			/* fx/zf would be SpecifiedTradeSettlementMonetarySummation
			 * but ox is SpecifiedTradeSettlementHeaderMonetarySummation...*/
			result = extractString("//*[local-name() = 'GrandTotalAmount']");
		}
		return result;
	}


	/**
	 * @return when the payment is due
	 */
	public String getDueDate() {
		return extractString("//*[local-name() = 'SpecifiedTradePaymentTerms']/*[local-name() = 'DueDateDateTime']/*[local-name() = 'DateTimeString']");
	}


	public HashMap<String, byte[]> getAdditionalData() {
		return additionalXMLs;
	}


	/**
	 * get xmp metadata of the PDF, null if not available
	 *
	 * @return string
	 */
	public String getXMP() {
		return xmpString;
	}


	/**
	 * @return if export found parseable ZUGFeRD data
	 */
	public boolean containsMeta() {
		return containsMeta;
	}


	/**
	 * @param meta raw XML to be set
	 * @throws IOException if raw can not be set
	 */
	public void setMeta(String meta) throws IOException {
		setRawXML(meta.getBytes());
	}


	/**
	 * @return raw XML of the invoice
	 */
	public String getMeta() {
		if (rawXML == null) {
			return null;
		}

		return new String(rawXML);
	}


	public EStandard getStandard() throws Exception {
		if (!containsMeta) {
			throw new Exception("Not yet parsed");
		}
		final String head = getUTF8();
		String rootNode = extractString("local-name(/*)");
		if (rootNode.equals("CrossIndustryDocument")) {
			return EStandard.zugferd;
		} else if (rootNode.equals("Invoice")) {
			return EStandard.ubl;
		} else if (rootNode.equals("CrossIndustryInvoice")) {
			return EStandard.facturx;
		} else if (rootNode.equals("SCRDMCCBDACIDAMessageStructure")) {
			return EStandard.despatchadvice;
		} else if (head.contains("<rsm:SCRDMCCBDACIOMessageStructure")) {
			return EStandard.orderx;
		}

		throw new Exception("ZUGFeRD version could not be determined");

	}

	public int getVersion() throws Exception {
		if (!containsMeta) {
			throw new Exception("Not yet parsed");
		}
		if (version != null) {
			return version;
		}

		final String head = getUTF8();
		if (head.contains("<rsm:CrossIndustryDocument") //
			|| head.contains("<CrossIndustryDocument") //
			|| head.contains("<SCRDMCCBDACIDAMessageStructure") //
			|| head.contains("<rsm:SCRDMCCBDACIOMessageStructure")) { //
			version = 1;
		} else if (head.contains("<rsm:CrossIndustryInvoice")) {
			version = 2;
		} else {
			throw new Exception("ZUGFeRD version could not be determined");
		}
		return version;
	}


	/**
	 * @return return UTF8 XML (without BOM) of the invoice
	 */
	public String getUTF8() {
		if (rawXML == null) {
			return null;
		}
		if (rawXML.length < 3) {
			return new String(rawXML);
		}


		final byte[] bomlessData;

		if ((rawXML[0] == (byte) 0xEF)
			&& (rawXML[1] == (byte) 0xBB)
			&& (rawXML[2] == (byte) 0xBF)) {
			// I don't like BOMs, lets remove it
			bomlessData = new byte[rawXML.length - 3];
			System.arraycopy(rawXML, 3, bomlessData, 0,
				rawXML.length - 3);
		} else {
			bomlessData = rawXML;
		}

		return new String(bomlessData);
	}


	/**
	 * Returns the raw XML data as extracted from the ZUGFeRD PDF file.
	 *
	 * @return the raw ZUGFeRD XML data
	 */
	public byte[] getRawXML() {
		return rawXML;
	}


	/**
	 * will return true if the metadata (just extract-ed or set with setMeta) contains ZUGFeRD XML
	 *
	 * @return true if the invoice contains ZUGFeRD XML
	 */
	public boolean canParse() {

		// SpecifiedExchangedDocumentContext is in the schema, so a relatively good
		// indication if zugferd is present - better than just invoice
		final String meta = getMeta();
		return (meta != null) && (meta.length() > 0) && ((meta.contains("SpecifiedExchangedDocumentContext")
			/* ZF1 */ || meta.contains("ExchangedDocumentContext") /* ZF2 */));
	}


	static String convertStreamToString(java.io.InputStream is) {
		// source https://stackoverflow.com/questions/309424/how-do-i-read-convert-an-inputstream-into-a-string-in-java referring to
		// https://community.oracle.com/blogs/pat/2004/10/23/stupid-scanner-tricks
		final Scanner s = new Scanner(is, "UTF-8").useDelimiter("\\A");
		return s.hasNext() ? s.next() : "";
	}

	/**
	 * returns an instance of PostalTradeAddress for SellerTradeParty section
	 *
	 * @return an instance of PostalTradeAddress
	 */
	public PostalTradeAddress getBuyerTradePartyAddress() {

		NodeList nl = null;

		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryDocument']//*[local-name() = 'SpecifiedSupplyChainTradeTransaction']/*[local-name() = 'ApplicableSupplyChainTradeAgreement']//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'PostalTradeAddress']");
			} else {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryInvoice']//*[local-name() = 'SupplyChainTradeTransaction']//*[local-name() = 'ApplicableHeaderTradeAgreement']//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'PostalTradeAddress']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return null;
		}

		return getAddressFromNodeList(nl);
	}

	/**
	 * returns an instance of PostalTradeAddress for SellerTradeParty section
	 *
	 * @return an instance of PostalTradeAddress
	 */
	public PostalTradeAddress getSellerTradePartyAddress() {

		NodeList nl = null;
		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryDocument']//*[local-name() = 'SpecifiedSupplyChainTradeTransaction']//*[local-name() = 'ApplicableSupplyChainTradeAgreement']//*[local-name() = 'SellerTradeParty']//*[local-name() = 'PostalTradeAddress']");
			} else {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryInvoice']//*[local-name() = 'SupplyChainTradeTransaction']//*[local-name() = 'ApplicableHeaderTradeAgreement']//*[local-name() = 'SellerTradeParty']//*[local-name() = 'PostalTradeAddress']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return null;
		}

		return getAddressFromNodeList(nl);
	}

	/**
	 * returns an instance of PostalTradeAddress for ShipToTradeParty section
	 *
	 * @return an instance of PostalTradeAddress
	 */
	public PostalTradeAddress getDeliveryTradePartyAddress() {

		final NodeList nl;
		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryDocument']//*[local-name() = 'SpecifiedSupplyChainTradeTransaction']//*[local-name() = 'ApplicableSupplyChainTradeDelivery']//*[local-name() = 'ShipToTradeParty']//*[local-name() = 'PostalTradeAddress']");
			} else {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryInvoice']//*[local-name() = 'SupplyChainTradeTransaction']//*[local-name() = 'ApplicableHeaderTradeDelivery']//*[local-name() = 'ShipToTradeParty']//*[local-name() = 'PostalTradeAddress']");
			}
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return null;
		}

		return getAddressFromNodeList(nl);
	}

	private PostalTradeAddress getAddressFromNodeList(NodeList nl) {
		final PostalTradeAddress address = new PostalTradeAddress();

		if (nl != null) {
			for (int i = 0; i < nl.getLength(); i++) {
				Node n = nl.item(i);
				final NodeList nodes = n.getChildNodes();
				for (int j = 0; j < nodes.getLength(); j++) {
					n = nodes.item(j);
					final short nodeType = n.getNodeType();
					if ((nodeType == Node.ELEMENT_NODE) && (n.getLocalName() != null)) {
						switch (n.getLocalName()) {
							case "PostcodeCode":
								address.setPostCodeCode("");
								if (n.getFirstChild() != null) {
									address.setPostCodeCode(n.getFirstChild().getNodeValue());
								}
								break;
							case "LineOne":
								address.setLineOne("");
								if (n.getFirstChild() != null) {
									address.setLineOne(n.getFirstChild().getNodeValue());
								}
								break;
							case "LineTwo":
								address.setLineTwo("");
								if (n.getFirstChild() != null) {
									address.setLineTwo(n.getFirstChild().getNodeValue());
								}
								break;
							case "LineThree":
								address.setLineThree("");
								if (n.getFirstChild() != null) {
									address.setLineThree(n.getFirstChild().getNodeValue());
								}
								break;
							case "CityName":
								address.setCityName("");
								if (n.getFirstChild() != null) {
									address.setCityName(n.getFirstChild().getNodeValue());
								}
								break;
							case "CountryID":
								address.setCountryID("");
								if (n.getFirstChild() != null) {
									address.setCountryID(n.getFirstChild().getNodeValue());
								}
								break;
							case "CountrySubDivisionName":
								address.setCountrySubDivisionName("");
								if (n.getFirstChild() != null) {
									address.setCountrySubDivisionName(n.getFirstChild().getNodeValue());
								}
								break;
						}
					}
				}
			}
		}
		return address;
	}

	/**
	 * returns a list of LineItems
	 *
	 * @return a List of LineItem instances
	 */
	public List<Item> getLineItemList() {
		final List<Node> nodeList = getLineItemNodes();
		final List<Item> lineItemList = new ArrayList<>();

		for (final Node n : nodeList) {
			final Item lineItem = new Item(null, null, null);
			lineItem.setProduct(new Product(null, null, null, null));

			final NodeList nl = n.getChildNodes();
			for (int i = 0; i < nl.getLength(); i++) {
				final Node nn = nl.item(i);
				Node node = null;
				if (nn.getLocalName() != null) {
					switch (nn.getLocalName()) {
						case "SpecifiedLineTradeAgreement":
						case "SpecifiedSupplyChainTradeAgreement":

							node = getNodeByName(nn.getChildNodes(), "NetPriceProductTradePrice");
							if (node != null) {
								final NodeList tradeAgreementChildren = node.getChildNodes();
								node = getNodeByName(tradeAgreementChildren, "ChargeAmount");
								lineItem.setPrice(tryBigDecimal(getNodeValue(node)));
								node = getNodeByName(tradeAgreementChildren, "BasisQuantity");
								if (node != null && node.getAttributes() != null) {
									final Node unitCodeAttribute = node.getAttributes().getNamedItem("unitCode");
									if (unitCodeAttribute != null) {
										lineItem.getProduct().setUnit(unitCodeAttribute.getNodeValue());
									}
								}
							}

							node = getNodeByName(nn.getChildNodes(), "GrossPriceProductTradePrice");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "ChargeAmount");
								lineItem.setGrossPrice(tryBigDecimal(getNodeValue(node)));
							}
							break;

						case "AssociatedDocumentLineDocument":

							node = getNodeByName(nn.getChildNodes(), "LineID");
							lineItem.setId(getNodeValue(node));
							break;

						case "SpecifiedTradeProduct":

							node = getNodeByName(nn.getChildNodes(), "SellerAssignedID");
							lineItem.getProduct().setSellerAssignedID(getNodeValue(node));

							node = getNodeByName(nn.getChildNodes(), "BuyerAssignedID");
							lineItem.getProduct().setBuyerAssignedID(getNodeValue(node));

							node = getNodeByName(nn.getChildNodes(), "Name");
							lineItem.getProduct().setName(getNodeValue(node));

							node = getNodeByName(nn.getChildNodes(), "Description");
							lineItem.getProduct().setDescription(getNodeValue(node));
							break;

						case "SpecifiedLineTradeDelivery":
						case "SpecifiedSupplyChainTradeDelivery":
							node = getNodeByName(nn.getChildNodes(), "BilledQuantity");
							lineItem.setQuantity(tryBigDecimal(getNodeValue(node)));
							break;

						case "SpecifiedLineTradeSettlement":
							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "RateApplicablePercent");
								lineItem.getProduct().setVATPercent(tryBigDecimal(getNodeValue(node)));
							}

							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "CalculatedAmount");
								lineItem.setTax(tryBigDecimal(getNodeValue(node)));
							}
							node = getNodeByName(nn.getChildNodes(), "BillingSpecifiedPeriod");
							if (node != null) {
								final Node start = getNodeByName(node.getChildNodes(), "StartDateTime");
								Node dateTimeStart = null;
								if (start != null) {
									dateTimeStart = getNodeByName(start.getChildNodes(), "DateTimeString");
								}
								final Node end = getNodeByName(node.getChildNodes(), "EndDateTime");
								Node dateTimeEnd = null;
								if (end != null) {
									dateTimeEnd = getNodeByName(end.getChildNodes(), "DateTimeString");
								}
								lineItem.setDetailedDeliveryPeriod(tryDate(dateTimeStart), tryDate(dateTimeEnd));
							}

							node = getNodeByName(nn.getChildNodes(), "SpecifiedTradeSettlementLineMonetarySummation");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "LineTotalAmount");
								lineItem.setLineTotalAmount(tryBigDecimal(getNodeValue(node)));
							}
							break;
						case "SpecifiedSupplyChainTradeSettlement":
							//ZF 1!

							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "ApplicablePercent");
								lineItem.getProduct().setVATPercent(tryBigDecimal(getNodeValue(node)));
							}

							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "CalculatedAmount");
								lineItem.setTax(tryBigDecimal(getNodeValue(node)));
							}

							node = getNodeByName(nn.getChildNodes(), "SpecifiedTradeSettlementMonetarySummation");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "LineTotalAmount");
								lineItem.setLineTotalAmount(tryBigDecimal(getNodeValue(node)));
							}
							break;
					}
				}
			}
			lineItemList.add(lineItem);
		}
		return lineItemList;
	}

	/**
	 * returns a List of LineItem Nodes from ZUGFeRD XML
	 *
	 * @return a List of Node instances
	 */
	public List<Node> getLineItemNodes() {
		final List<Node> lineItemNodes = new ArrayList<>();
		NodeList nl = null;
		try {
			nl = getNodeListByPath("//*[local-name() = 'IncludedSupplyChainTradeLineItem']");

		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
		}

		for (int i = 0; i < nl.getLength(); i++) {
			final Node n = nl.item(i);
			lineItemNodes.add(n);
		}
		return lineItemNodes;
	}

	/**
	 * Returns a node, found by name. If more nodes with the same name are present, the first occurence will be returned
	 *
	 * @param nl   - A NodeList which may contains the searched node
	 * @param name The nodes name
	 * @return a Node or null, if nothing is found
	 */
	private Node getNodeByName(NodeList nl, String name) {
		for (int i = 0; i < nl.getLength(); i++) {
			if ((nl.item(i).getLocalName() != null) && (nl.item(i).getLocalName().equals(name))) {
				return nl.item(i);
			} else if (nl.item(i).getChildNodes().getLength() > 0) {
				final Node node = getNodeByName(nl.item(i).getChildNodes(), name);
				if (node != null) {
					return node;
				}
			}
		}
		return null;
	}

	/**
	 * Get a NodeList by providing an path
	 *
	 * @param path a compliable Path
	 * @return a Nodelist or null, if an error occurs
	 */
	public NodeList getNodeListByPath(String path) {

		final XPathFactory xpathFact = XPathFactory.newInstance();
		final XPath xPath = xpathFact.newXPath();
		final String s = path;

		try {
			final XPathExpression xpr = xPath.compile(s);
			return (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		} catch (final Exception e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			return null;
		}
	}

	/**
	 * returns the value of an node
	 *
	 * @param node the Node to get the value from
	 * @return A String or empty String, if no value was found
	 */
	private String getNodeValue(Node node) {
		if (node != null && node.getFirstChild() != null) {
			return node.getFirstChild().getNodeValue();
		}
		return "";
	}

	/**
	 * tries to convert an String to BigDecimal.
	 *
	 * @param nodeValue The value as String
	 * @return a BigDecimal with the value provides as String or a BigDecimal with value 0.00 if an error occurs
	 */
	private BigDecimal tryBigDecimal(String nodeValue) {
		try {
			return new BigDecimal(nodeValue);
		} catch (final Exception e) {
			try {
				return BigDecimal.valueOf(Float.valueOf(nodeValue));
			} catch (final Exception ex) {
				return new BigDecimal("0.00");
			}
		}
	}

	private Date tryDate(Node node) {
		final String nodeValue = getNodeValue(node);
		if (nodeValue.isEmpty()) {
			return null;
		}
		return tryDate(nodeValue);
	}

	private static Date tryDate(String toParse) {
		final SimpleDateFormat formatter = ZUGFeRDDateFormat.DATE.getFormatter();
		try {
			return formatter.parse(toParse);
		} catch (final Exception e) {
			return null;
		}
	}
}
