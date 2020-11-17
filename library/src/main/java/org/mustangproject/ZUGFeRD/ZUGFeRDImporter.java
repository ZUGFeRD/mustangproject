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

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.*;

import org.mustangproject.Item;
import org.mustangproject.Product;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.PDNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ZUGFeRDImporter {

	/**
	 * if metadata has been found
	 */
	private boolean containsMeta = false;
	/**
	 * map filenames of additional XML files to their contents
	 */
	private HashMap<String, byte[]> additionalXMLs = new HashMap<>();
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


	public ZUGFeRDImporter(String pdfFilename) {
		try (InputStream bis = Files.newInputStream(Paths.get(pdfFilename), StandardOpenOption.READ)) {
			extractLowLevel(bis);
		} catch (IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}


	public ZUGFeRDImporter(InputStream pdfStream) {
		try {
			extractLowLevel(pdfStream);
		} catch (IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}


	/**
	 * Extracts a ZUGFeRD invoice from a PDF document represented by an input stream. Errors are reported via exception handling.
	 *
	 * @param pdfStream a inputstream of a pdf file
	 */
	private void extractLowLevel(InputStream pdfStream) throws IOException {
		try (PDDocument doc = PDDocument.load(pdfStream)) {
			// PDDocumentInformation info = doc.getDocumentInformation();
			PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
			//start

			if (doc.getDocumentCatalog() == null || doc.getDocumentCatalog().getMetadata() == null) {
				Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.INFO, "no-xmlpart");
				return;
			}

			InputStream XMP = doc.getDocumentCatalog().getMetadata().exportXMPMetadata();
			xmpString = convertStreamToString(XMP);

			PDEmbeddedFilesNameTreeNode etn = names.getEmbeddedFiles();
			if (etn == null) {
				return;
			}

			Map<String, PDComplexFileSpecification> efMap = etn.getNames();
			// String filePath = "/tmp/";

			if (efMap != null) {
				extractFiles(efMap); // see
				// https://memorynotfound.com/apache-pdfbox-extract-embedded-file-pdf-document/
			} else {

				List<PDNameTreeNode<PDComplexFileSpecification>> kids = etn.getKids();
				for (PDNameTreeNode<PDComplexFileSpecification> node : kids) {
					Map<String, PDComplexFileSpecification> namesL = node.getNames();
					extractFiles(namesL);
				}
			}
		}
	}


	private void extractFiles(Map<String, PDComplexFileSpecification> names) throws IOException {
		for (String alias : names.keySet()) {

			PDComplexFileSpecification fileSpec = names.get(alias);
			String filename = fileSpec.getFilename();
			/**
			 * filenames for invoice data (ZUGFeRD v1 and v2, Factur-X)
			 */
			if ((filename.equals("ZUGFeRD-invoice.xml") || (filename.equals("zugferd-invoice.xml")) || filename.equals("factur-x.xml")) || filename.equals("xrechnung.xml") || filename.equals("order-x.xml")) {
				containsMeta = true;

				PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
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
				PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				additionalXMLs.put(filename, embeddedFile.toByteArray());
			}
		}
	}


	protected Document getDocument() {
		return document;
	}


	private void setDocument() throws ParserConfigurationException, IOException, SAXException {
		DocumentBuilderFactory xmlFact = DocumentBuilderFactory.newInstance();
		xmlFact.setNamespaceAware(false);
		DocumentBuilder builder = xmlFact.newDocumentBuilder();
		ByteArrayInputStream is = new ByteArrayInputStream(rawXML);
	///	is.skip(guessBOMSize(is));
		document = builder.parse(is);
	}


	public void setRawXML(byte[] rawXML) throws IOException {
		this.rawXML = rawXML;
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
		String result;
		try {
			Document document = getDocument();
			XPathFactory xpathFact = XPathFactory.newInstance();
			XPath xpath = xpathFact.newXPath();
			result = xpath.evaluate(xpathStr, document);
		} catch (XPathExpressionException e) {
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
		String result = extractString("//ApplicableHeaderTradeSettlement/PaymentReference");
		if (result == null || result.isEmpty()) {
			result = extractString("//ApplicableSupplyChainTradeSettlement/PaymentReference");
		}
		return result;
	}

	/**
	 * @return the ZUGFeRD Profile
	 */
	public String getZUGFeRDProfil() {
		switch (extractString("//GuidelineSpecifiedDocumentContextParameter//ID")) {
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
		}
		return "";
	}

	/**
	 * @return the Invoice Currency Code
	 */
	public String getInvoiceCurrencyCode() {
		try {
			if (getVersion() == 1) {
				return extractString("//ApplicableSupplyChainTradeSettlement//InvoiceCurrencyCode");
			} else {
				return extractString("//ApplicableHeaderTradeSettlement//InvoiceCurrencyCode");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the IssuerAssigned ID
	 */
	public String getIssuerAssignedID() {
		try {
			if (getVersion() == 1) {
				return extractString("//BuyerOrderReferencedDocument//ID");
			} else {
				return extractString("//BuyerOrderReferencedDocument//IssuerAssignedID");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the BuyerTradeParty ID
	 */
	public String getBuyerTradePartyID() {
		return extractString("//BuyerTradeParty//ID");
	}

	/**
	 * @return the Issue Date()
	 */
	public String getIssueDate() {
		try {
			if (getVersion() == 1) {
				return extractString("//HeaderExchangedDocument//IssueDateTime//DateTimeString");
			} else {
				return extractString("//ExchangedDocument//IssueDateTime//DateTimeString");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the TaxBasisTotalAmount
	 */
	public String getTaxBasisTotalAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//SpecifiedTradeSettlementMonetarySummation//TaxBasisTotalAmount");
			} else {
				return extractString("//SpecifiedTradeSettlementHeaderMonetarySummation//TaxBasisTotalAmount");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the TaxTotalAmount
	 */
	public String getTaxTotalAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//SpecifiedTradeSettlementMonetarySummation//TaxTotalAmount");
			} else {
				return extractString("//SpecifiedTradeSettlementHeaderMonetarySummation//TaxTotalAmount");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the RoundingAmount
	 */
	public String getRoundingAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//SpecifiedTradeSettlementMonetarySummation//RoundingAmount");
			} else {
				return extractString("//SpecifiedTradeSettlementHeaderMonetarySummation//RoundingAmount");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the TotalPrepaidAmount
	 */
	public String getPaidAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//SpecifiedTradeSettlementMonetarySummation//TotalPrepaidAmount");
			} else {
				return extractString("//SpecifiedTradeSettlementHeaderMonetarySummation//TotalPrepaidAmount");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return SellerTradeParty GlobalID
	 */
	public String getSellerTradePartyGlobalID() {
		return extractString("//SellerTradeParty//GlobalID");
	}

	/**
	 * @return the BuyerTradeParty GlobalID
	 */
	public String getBuyerTradePartyGlobalID() {
		return extractString("//BuyerTradeParty//GlobalID");
	}

	/**
	 * @return the BuyerTradeParty SpecifiedTaxRegistration ID
	 */
	public String getBuyertradePartySpecifiedTaxRegistrationID() {
		return extractString("//BuyerTradeParty//SpecifiedTaxRegistration//ID");
	}


	/**
	 * @return the IncludedNote
	 */
	public String getIncludedNote() {
		try {
			if (getVersion() == 1) {
				return extractString("//HeaderExchangedDocument//IncludedNote");
			} else {
				return extractString("//ExchangedDocument//IncludedNote");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the BuyerTradeParty Name
	 */
	public String getBuyerTradePartyName() {
		return extractString("//BuyerTradeParty//Name");
	}



	/**
	 * @return the line Total Amount
	 */
	public String getLineTotalAmount() {
		try {
			if (getVersion() == 1) {
				return extractString("//SpecifiedTradeSettlementMonetarySummation//LineTotalAmount");
			} else {
				return extractString("//SpecifiedTradeSettlementHeaderMonetarySummation//LineTotalAmount");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the Payment Terms
	 */
	public String getPaymentTerms() {
		return extractString("//SpecifiedTradePaymentTerms//Description");
	}

	/**
	 * @return the Taxpoint Date
	 */
	public String getTaxPointDate() {
		try {
			if (getVersion() == 1) {
				return extractString("//ActualDeliverySupplyChainEvent//OccurrenceDateTime//DateTimeString");
			} else {
				return extractString("//ActualDeliverySupplyChainEvent//OccurrenceDateTime//DateTimeString");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * @return the Invoice ID
	 */
	public String getInvoiceID() {
		try {
			if (getVersion() == 1) {
				return extractString("//HeaderExchangedDocument//ID");
			} else {
				return extractString("//ExchangedDocument//ID");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}



	/**
	 * @return the document code
	 */
	public String getDocumentCode() {
		try {
			if (getVersion() == 1) {
				return extractString("//HeaderExchangedDocument/TypeCode");
			} else {
				return extractString("//ExchangedDocument/TypeCode");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}


	/**
	 * @return the referred document
	 */
	public String getReference() {
		try {
			if (getVersion() == 1) {
				return extractString("//ApplicableSupplyChainTradeAgreement/BuyerReference");
			} else {
				return extractString("//ApplicableHeaderTradeAgreement/BuyerReference");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}


	/**
	 * @return the sender's bank's BIC code
	 */
	public String getBIC() {
		return extractString("//PayeeSpecifiedCreditorFinancialInstitution/BICID");
	}


	/**
	 * @return the sender's bank name
	 */
	public String getBankName() {
		return extractString("//PayeeSpecifiedCreditorFinancialInstitution/Name");
	}


	/**
	 * @return the sender's account IBAN code
	 */
	public String getIBAN() {
		return extractString("//PayeePartyCreditorFinancialAccount/IBANID");
	}


	public String getHolder() {
		return extractString("//SellerTradeParty/Name");
	}


	/**
	 * @return the total payable amount
	 */
	public String getAmount() {
		String result = extractString("//SpecifiedTradeSettlementHeaderMonetarySummation/DuePayableAmount");
		if (result == null || result.isEmpty()) {
			result = extractString("//SpecifiedTradeSettlementMonetarySummation/GrandTotalAmount");
		}
		return result;
	}


	/**
	 * @return when the payment is due
	 */
	public String getDueDate() {
		return extractString("//SpecifiedTradePaymentTerms/DueDateDateTime/DateTimeString");
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


	public int getVersion() throws Exception {
		if (!containsMeta) {
			throw new Exception("Not yet parsed");
		}
		if (getUTF8().contains("<rsm:CrossIndustryDocument")) {
			return 1;
		} else if (getUTF8().contains("<rsm:CrossIndustryInvoice")) {
			return 2;
		}
		throw new Exception("ZUGFeRD version could not be determined");
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


		byte[] bomlessData;

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
		String meta = getMeta();
		return (meta != null) && (meta.length() > 0) && ((meta.contains("SpecifiedExchangedDocumentContext")
				/* ZF1 */ || meta.contains("ExchangedDocumentContext") /* ZF2 */));
	}


	static String convertStreamToString(java.io.InputStream is) {
		// source https://stackoverflow.com/questions/309424/how-do-i-read-convert-an-inputstream-into-a-string-in-java referring to
		// https://community.oracle.com/blogs/pat/2004/10/23/stupid-scanner-tricks
		Scanner s = new Scanner(is, "UTF-8").useDelimiter("\\A");
		return s.hasNext() ? s.next() : "";
	}

	/**
	 * returns an instance of PostalTradeAddress for SellerTradeParty section
	 * @return an instance of PostalTradeAddress
	 */
	public PostalTradeAddress getBuyerTradePartyAddress() {

		NodeList nl = null;

		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//CrossIndustryDocument//SpecifiedSupplyChainTradeTransaction//ApplicableSupplyChainTradeAgreement//BuyerTradeParty//PostalTradeAddress");
			} else {
				nl = getNodeListByPath("//CrossIndustryInvoice//SupplyChainTradeTransaction//ApplicableHeaderTradeAgreement//BuyerTradeParty//PostalTradeAddress");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return getAddressFromNodeList(nl);
	}

	/**
	 * returns an instance of PostalTradeAddress for SellerTradeParty section
	 * @return an instance of PostalTradeAddress
	 */
	public PostalTradeAddress getSellerTradePartyAddress() {

		NodeList nl = null;
		PostalTradeAddress address = new PostalTradeAddress();

		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//CrossIndustryDocument//SpecifiedSupplyChainTradeTransaction//ApplicableSupplyChainTradeAgreement//SellerTradeParty//PostalTradeAddress");
			} else {
				nl = getNodeListByPath("//CrossIndustryInvoice//SupplyChainTradeTransaction//ApplicableHeaderTradeAgreement//SellerTradeParty//PostalTradeAddress");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return getAddressFromNodeList(nl);
	}

	private PostalTradeAddress getAddressFromNodeList(NodeList nl) {
		PostalTradeAddress address = new PostalTradeAddress();

		if (nl != null) {
			for (int i = 0; i < nl.getLength(); i++) {
				Node n = nl.item(i);
				NodeList nodes = n.getChildNodes();
				for (int j = 0; j < nodes.getLength(); j++) {
					n = nodes.item(j);
					short nodeType = n.getNodeType();
					if (nodeType==Node.ELEMENT_NODE){
						switch (n.getNodeName()) {
							case "ram:PostcodeCode":
								address.setPostCodeCode("");
								if (n.getFirstChild() != null) {
									address.setPostCodeCode(n.getFirstChild().getNodeValue());
								}
								break;
							case "ram:LineOne":
								address.setLineOne("");
								if (n.getFirstChild() != null) {
									address.setLineOne(n.getFirstChild().getNodeValue());
								}
								break;
							case "ram:LineTwo":
								address.setLineTwo("");
								if (n.getFirstChild() != null) {
									address.setLineTwo(n.getFirstChild().getNodeValue());
								}
								break;
							case "ram:LineThree":
								address.setLineThree("");
								if (n.getFirstChild() != null) {
									address.setLineThree(n.getFirstChild().getNodeValue());
								}
								break;
							case "ram:CityName":
								address.setCityName("");
								if (n.getFirstChild() != null) {
									address.setCityName(n.getFirstChild().getNodeValue());
								}
								break;
							case "ram:CountryID":
								address.setCountryID("");
								if (n.getFirstChild() != null) {
									address.setCountryID(n.getFirstChild().getNodeValue());
								}
								break;
							case "ram:CountrySubDivisionName":
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
	 * @return a List of LineItem instances
	 */
	public List<Item> getLineItemList() {
		List<Node> nodeList = getLineItemNodes();
		List<Item> lineItemList = new ArrayList<>();

		for (Node n: nodeList
		) {
			Item lineItem = new Item(null, null, null);
			lineItem.setProduct(new Product(null,null,null,null));

			NodeList nl = n.getChildNodes();
			for (int i = 0; i < nl.getLength(); i++) {
				Node nn = nl.item(i);
				Node node = null;
				switch (nn.getNodeName()) {
					case "ram:SpecifiedLineTradeAgreement":
					case "ram:SpecifiedSupplyChainTradeAgreement":

						node = getNodeByName(nn.getChildNodes(), "ram:NetPriceProductTradePrice");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:ChargeAmount");
							lineItem.setPrice(tryBigDecimal(getNodeValue(node)));
						}

						node = getNodeByName(nn.getChildNodes(), "ram:GrossPriceProductTradePrice");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:ChargeAmount");
							lineItem.setGrossPrice(tryBigDecimal(getNodeValue(node)));
						}
						break;

					case "ram:AssociatedDocumentLineDocument":

						node = getNodeByName(nn.getChildNodes(), "ram:LineID");
						lineItem.setId(getNodeValue(node));
						break;

					case "ram:SpecifiedTradeProduct":

						node = getNodeByName(nn.getChildNodes(), "ram:SellerAssignedID");
						lineItem.getProduct().setSellerAssignedID(getNodeValue(node));

						node = getNodeByName(nn.getChildNodes(), "ram:BuyerAssignedID");
						lineItem.getProduct().setBuyerAssignedID(getNodeValue(node));

						node = getNodeByName(nn.getChildNodes(), "ram:Name");
						lineItem.getProduct().setName(getNodeValue(node));

						node = getNodeByName(nn.getChildNodes(), "ram:Description");
						lineItem.getProduct().setDescription(getNodeValue(node));
						break;

					case "ram:SpecifiedLineTradeDelivery":
					case "ram:SpecifiedSupplyChainTradeDelivery":
						node = getNodeByName(nn.getChildNodes(), "ram:BilledQuantity");
						lineItem.setQuantity(tryBigDecimal(getNodeValue(node)));
						break;

					case "ram:SpecifiedLineTradeSettlement":

						node = getNodeByName(nn.getChildNodes(), "ram:ApplicableTradeTax");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:RateApplicablePercent");
							lineItem.getProduct().setVATPercent(tryBigDecimal(getNodeValue(node)));
						}

						node = getNodeByName(nn.getChildNodes(), "ram:ApplicableTradeTax");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:CalculatedAmount");
							lineItem.setTax(tryBigDecimal(getNodeValue(node)));
						}

						node = getNodeByName(nn.getChildNodes(), "ram:SpecifiedTradeSettlementLineMonetarySummation");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:LineTotalAmount");
							lineItem.setLineTotalAmount(tryBigDecimal(getNodeValue(node)));
						}
						break;
					case "ram:SpecifiedSupplyChainTradeSettlement":
						//ZF 1!

						node = getNodeByName(nn.getChildNodes(), "ram:ApplicableTradeTax");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:ApplicablePercent");
							lineItem.getProduct().setVATPercent(tryBigDecimal(getNodeValue(node)));
						}

						node = getNodeByName(nn.getChildNodes(), "ram:ApplicableTradeTax");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:CalculatedAmount");
							lineItem.setTax(tryBigDecimal(getNodeValue(node)));
						}

						node = getNodeByName(nn.getChildNodes(), "ram:SpecifiedTradeSettlementMonetarySummation");
						if (node != null) {
							node = getNodeByName(node.getChildNodes(), "ram:LineTotalAmount");
							lineItem.setLineTotalAmount(tryBigDecimal(getNodeValue(node)));
						}
						break;
				}
			}
			lineItemList.add(lineItem);
		}
		return lineItemList;
	}

	/**
	 * returns a List of LineItem Nodes from ZUGFeRD XML
	 * @return a List of Node instances
	 */
	public List<Node> getLineItemNodes() {
		List<Node> lineItemNodes = new ArrayList<>();
		NodeList nl = null;
		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//CrossIndustryDocument//SpecifiedSupplyChainTradeTransaction//IncludedSupplyChainTradeLineItem");
			} else {
				nl = getNodeListByPath("//CrossIndustryInvoice//SupplyChainTradeTransaction//IncludedSupplyChainTradeLineItem");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		for (int i = 0; i < nl.getLength(); i++) {
			Node n = nl.item(i);
			lineItemNodes.add(n);
		}
		return lineItemNodes;
	}

	/**
	 * Returns a node, found by name. If more nodes with the same name are present, the first occurence will be returned
	 * @param nl - A NodeList which may contains the searched node
	 * @param name The nodes name
	 * @return a Node or null, if nothing is found
	 */
	private Node getNodeByName(NodeList nl, String name) {
		for (int i = 0; i < nl.getLength(); i++) {
			if (nl.item(i).getNodeName() == name) {
				return nl.item(i);
			} else if (nl.item(i).getChildNodes().getLength() > 0) {
				Node node = getNodeByName(nl.item(i).getChildNodes(), name);
				if (node != null) {
					return node;
				}
			}
		}
		return null;
	}

	/**
	 * Get a NodeList by providing an path
	 * @param path a compliable Path
	 * @return a Nodelist or null, if an error occurs
	 */
	public NodeList getNodeListByPath(String path) {

		XPathFactory xpathFact = XPathFactory.newInstance();
		XPath xPath = xpathFact.newXPath();
		String s = path;

		try {
			XPathExpression xpr = xPath.compile(s);
			return (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * returns the value of an node
	 * @param node the Node to get the value from
	 * @return A String or empty String, if no value was found
	 */
	private String getNodeValue(Node node) {
		if (node != null) {
			if (node.getFirstChild() != null) {
				return node.getFirstChild().getNodeValue();
			}
		}
		return "";
	}

	/**
	 * tries to convert an String to BigDecimal.
	 * @param nodeValue The value as String
	 * @return a BigDecimal with the value provides as String or a BigDecimal with value 0.00 if an error occurs
	 */
	private BigDecimal tryBigDecimal(String nodeValue) {
		try {
			return new BigDecimal(nodeValue);
		} catch (Exception e) {
			try {
				return new BigDecimal(Float.valueOf(nodeValue));
			} catch (Exception ex) {
				return new BigDecimal("0.00");
			}
		}
	}
}
