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
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.mustangproject.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ZUGFeRDImporter extends ZUGFeRDInvoiceImporter {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDImporter.class);

	public ZUGFeRDImporter() {
		super();
	}

	public ZUGFeRDImporter(String filename) {
		super(filename);
	}

	public ZUGFeRDImporter(InputStream stream) {
		super(stream);
	}


	/***
	 * return the file names of all files embedded into the PDF
	 * for XML embedded files please use ZUGFeRDInvoiceImporter.getFileAttachmentsXML
	 * @return a ArrayList of FileAttachments, empty if none
	 */
	public List<FileAttachment> getFileAttachmentsPDF() {
		return PDFAttachments;
	}



	////////////////////////////////////

	/**
	 * @return the reference (purpose) the sender specified for this invoice
	 */
	public String getForeignReference() {

		return importedInvoice.getNumber();
	}

	/**
	 * @return the ZUGFeRD Profile
	 */
	public String getZUGFeRDProfil() {

		String guideline = extractString("//*[local-name() = 'GuidelineSpecifiedDocumentContextParameter']//*[local-name() = 'ID']");
		if (guideline.contains("xrechnung")) {
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
			// Exception was already logged
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
			// Exception was already logged
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
			// Exception was already logged
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
			// Exception was already logged
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
		String id = null;
		if  ((importedInvoice.getRecipient()!=null) && (importedInvoice.getRecipient().getLegalOrganisation()!=null)) {
			// this *should* be the official result
			id = importedInvoice.getRecipient().getLegalOrganisation().getSchemedID().getID();
		}
		// but also provide some fallback
		if (id == null) {
			id = getBuyerTradePartyID();
		}
		return id;
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
			// Exception was already logged
			return "";
		}
	}

	/**
	 * @return the BuyerTradeParty Name
	 */
	public String getBuyerTradePartyName() {
		return importedInvoice.getRecipient().getName();
	}

	/**
	 * @return the BuyerTradeParty Name
	 */
	public String getDeliveryTradePartyName() {
		return importedInvoice.getDeliveryAddress().getName();
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
			// Exception was already logged
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
			// Exception was already logged
			return "";
		}
	}

	/**
	 * @return the Invoice ID
	 */
	public String getInvoiceID() {
		return importedInvoice.getNumber();
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
			// Exception was already logged
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
			// Exception was already logged
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
		for (IZUGFeRDTradeSettlement settlement : importedInvoice.getTradeSettlement()) {
			if (settlement instanceof IZUGFeRDTradeSettlementDebit) {
				return ((IZUGFeRDTradeSettlementDebit) settlement).getIBAN();
			}
			if (settlement instanceof IZUGFeRDTradeSettlementPayment) {
				return ((IZUGFeRDTradeSettlementPayment) settlement).getOwnIBAN();
			}
		}
		return null;
	}


	public String getHolder() {


		return extractString("//*[local-name() = 'SellerTradeParty']/*[local-name() = 'Name']");
	}


	/**
	 * @return the total payable amount
	 */
	public String getAmount() {

		return importedInvoice.getGrandTotal().toPlainString();
	}


	/**
	 * @return when the payment is due
	 */
	public String getDueDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return sdf.format(importedInvoice.getDueDate());
	}


	////////////////////

	/**
	 * @return the Invoice Currency Code
	 */
	public String getInvoiceCurrencyCode() {
		return importedInvoice.getCurrency();
	}


	private String extractIssuerAssignedID(String propertyName) {
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = '" + propertyName + "']//*[local-name() = 'ID']");
			} else {
				return extractString("//*[local-name() = '" + propertyName + "']//*[local-name() = 'IssuerAssignedID']");
			}
		} catch (final Exception e) {
			// Exception was already logged
			return "";
		}
	}

	/**
	 * @return the BuyerTradeParty ID
	 */
	public String getBuyerTradePartyID() {
		String id = importedInvoice.getRecipient().getID();
		if (id == null) {
			// provide some fallback
			id = importedInvoice.getRecipient().getVATID();
		}
		return id;
	}

	/**
	 * @return the Issue Date()
	 */
	public String getIssueDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return sdf.format(importedInvoice.getIssueDate());
	}

	public Date getDetailedDeliveryPeriodFrom() {
		return importedInvoice.getDetailedDeliveryPeriodFrom();
	}

	public Date getDetailedDeliveryPeriodTo() {
		return importedInvoice.getDetailedDeliveryPeriodTo();
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


	/**
	 * returns an instance of PostalTradeAddress for SellerTradeParty section
	 *
	 * @return an instance of PostalTradeAddress
	 */
	public PostalTradeAddress getBuyerTradePartyAddress() {

		NodeList nl = null;

		try {
			if (getVersion() == 1) {
				nl = getNodeListByPath("//*[localname() = 'CrossIndustryDocument']//*[local-name() = 'SpecifiedSupplyChainTradeTransaction']/*[local-name() = 'ApplicableSupplyChainTradeAgreement']//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'PostalTradeAddress']");
			} else {
				nl = getNodeListByPath("//*[local-name() = 'CrossIndustryInvoice']//*[local-name() = 'SupplyChainTradeTransaction']//*[local-name() = 'ApplicableHeaderTradeAgreement']//*[local-name() = 'BuyerTradeParty']//*[local-name() = 'PostalTradeAddress']");
			}
		} catch (final Exception e) {
			// Exception was already logged
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
			// Exception was already logged
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
			// Exception was already logged
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
	 * @deprecated use invoiceimporter getZFItems
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
								lineItem.setPrice(XMLTools.tryBigDecimal(node));
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
								lineItem.setGrossPrice(XMLTools.tryBigDecimal(node));
							}
							break;

						case "AssociatedDocumentLineDocument":

							node = getNodeByName(nn.getChildNodes(), "LineID");
							lineItem.setId(XMLTools.getNodeValue(node));
							break;

						case "SpecifiedTradeProduct":
							node = getNodeByName(nn.getChildNodes(), "GlobalID");
							if (node != null) {
								SchemedID globalId = new SchemedID()
									.setScheme(node.getAttributes()
										.getNamedItem("schemeID").getNodeValue())
									.setId(XMLTools.getNodeValue(node));
								lineItem.getProduct().addGlobalID(globalId);
							}
							node = getNodeByName(nn.getChildNodes(), "SellerAssignedID");
							lineItem.getProduct().setSellerAssignedID(XMLTools.getNodeValue(node));

							node = getNodeByName(nn.getChildNodes(), "BuyerAssignedID");
							lineItem.getProduct().setBuyerAssignedID(XMLTools.getNodeValue(node));

							node = getNodeByName(nn.getChildNodes(), "Name");
							lineItem.getProduct().setName(XMLTools.getNodeValue(node));

							node = getNodeByName(nn.getChildNodes(), "Description");
							lineItem.getProduct().setDescription(XMLTools.getNodeValue(node));
							break;

						case "SpecifiedLineTradeDelivery":
						case "SpecifiedSupplyChainTradeDelivery":
							node = getNodeByName(nn.getChildNodes(), "BilledQuantity");
							lineItem.setQuantity(XMLTools.tryBigDecimal(node));
							break;

						case "SpecifiedLineTradeSettlement":
							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "RateApplicablePercent");
								lineItem.getProduct().setVATPercent(XMLTools.tryBigDecimal(node));
							}

							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "CalculatedAmount");
								lineItem.setTax(XMLTools.tryBigDecimal(node));
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
								lineItem.setDetailedDeliveryPeriod(XMLTools.tryDate(dateTimeStart), XMLTools.tryDate(dateTimeEnd));
							}

							node = getNodeByName(nn.getChildNodes(), "SpecifiedTradeSettlementLineMonetarySummation");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "LineTotalAmount");
								lineItem.setLineTotalAmount(XMLTools.tryBigDecimal(node));
							}
							break;
						case "SpecifiedSupplyChainTradeSettlement":
							//ZF 1!

							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "ApplicablePercent");
								lineItem.getProduct().setVATPercent(XMLTools.tryBigDecimal(node));
							}

							node = getNodeByName(nn.getChildNodes(), "ApplicableTradeTax");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "CalculatedAmount");
								lineItem.setTax(XMLTools.tryBigDecimal(node));
							}

							node = getNodeByName(nn.getChildNodes(), "SpecifiedTradeSettlementMonetarySummation");
							if (node != null) {
								node = getNodeByName(node.getChildNodes(), "LineTotalAmount");
								lineItem.setLineTotalAmount(XMLTools.tryBigDecimal(node));
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
			// Exception was already logged
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
			LOGGER.error("Failed to evaluate XPath", e);
			return null;
		}
	}

}
