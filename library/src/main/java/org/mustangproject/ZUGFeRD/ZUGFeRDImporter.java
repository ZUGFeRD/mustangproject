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
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.IOUtils;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.PDNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.mustangproject.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ZUGFeRDImporter {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDImporter.class);

	/**
	 * if metadata has been found
	 */
	protected boolean containsMeta = false;
	/**
	 * map filenames of additional XML files to their contents
	 */
	private final HashMap<String, byte[]> additionalXMLs = new HashMap<>();
	/**
	 * map filenames of all embedded files in the respective PDF
	 */
	private final ArrayList<FileAttachment> PDFAttachments = new ArrayList<>();
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
	Invoice importedInvoice=null;
	private boolean recalcPrice = false;
	private boolean ignoreCalculationErrors = false;
	private ArrayList<FileAttachment> fileAttachments=new ArrayList<>();


	protected ZUGFeRDImporter() {
		//constructor for extending classes
	}

	public ZUGFeRDImporter(String pdfFilename) {
		try (InputStream bis = Files.newInputStream(Paths.get(pdfFilename), StandardOpenOption.READ)) {
			extractLowLevel(bis);
		} catch (final IOException e) {
			LOGGER.error("Failed to extract ZUGFeRD data", e);
			throw new ZUGFeRDExportException(e);
		}
	}


	public ZUGFeRDImporter(InputStream pdfStream) {
		try {
			extractLowLevel(pdfStream);
		} catch (final IOException e) {
			LOGGER.error("Failed to extract ZUGFeRD data", e);
			throw new ZUGFeRDExportException(e);
		}
	}


	/***
	 * return the file names of all files embedded into the PDF
	 * @see for XML embedded files please use ZUGFeRDInvoiceImporter.getFileAttachmentsXML
	 * @return a ArrayList of FileAttachments, empty if none
	 */
	public List<FileAttachment> getFileAttachmentsPDF() {
		return PDFAttachments;
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


			try (PDDocument doc = Loader.loadPDF(IOUtils.toByteArray(pdfStream))) {
				// PDDocumentInformation info = doc.getDocumentInformation();
				final PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
				//start

				if (doc.getDocumentCatalog() == null || doc.getDocumentCatalog().getMetadata() == null) {
					LOGGER.info("no-xmlpart");
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

			final PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
			if ((filename.equals("ZUGFeRD-invoice.xml") || (filename.equals("zugferd-invoice.xml")) || filename.equals("factur-x.xml")) || filename.equals("xrechnung.xml") || filename.equals("order-x.xml") || filename.equals("cida.xml")) {
				containsMeta = true;

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
				additionalXMLs.put(filename, embeddedFile.toByteArray());
			}
			PDFAttachments.add(new FileAttachment(filename, embeddedFile.getSubtype(), "Data", embeddedFile.toByteArray()));
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
		try {
			extractInto(importedInvoice);
		} catch (XPathExpressionException e) {
			throw new RuntimeException(e);
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}


	public void setRawXML(byte[] rawXML) throws IOException {
		this.containsMeta = true;
		this.rawXML = rawXML;
		this.version = null;
		try {
			setDocument();
		} catch (ParserConfigurationException | SAXException e) {
			LOGGER.error("Failed to parse XML", e);
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
			LOGGER.error("Failed to evaluate XPath", e);
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




	public void fromXML(String XML) {
		try {
			containsMeta = true;
			setRawXML(XML.getBytes(StandardCharsets.UTF_8));
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
	}


	/***
	 * This will parse a XML into the given invoice object
	 * @param zpp the invoice to be altered
	 * @return the parsed invoice object
	 * @throws XPathExpressionException if xpath could not be evaluated
	 * @throws ParseException if the grand total of the parsed invoice could not be replicated with the new invoice
	 */
	public Invoice extractInto(Invoice zpp) throws XPathExpressionException, ParseException {

		String number = "";
		String typeCode = null;
		/*
		 * dummywerte sind derzeit noch setDueDate setIssueDate setDeliveryDate
		 * setSender setRecipient setnumber bspw. due date
		 * //ExchangedDocument//IssueDateTime//DateTimeString : due date optional
		 */
		XPathFactory xpathFact = XPathFactory.newInstance();
		XPath xpath = xpathFact.newXPath();
		XPathExpression xpr = xpath.compile("//*[local-name()=\"SellerTradeParty\"]|//*[local-name()=\"AccountingSupplierParty\"]/*");
		NodeList SellerNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		xpr = xpath.compile("//*[local-name()=\"BuyerTradeParty\"]|//*[local-name()=\"AccountingCustomerParty\"]/*");
		NodeList BuyerNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		xpr = xpath.compile("//*[local-name()=\"ExchangedDocument\"]|//*[local-name()=\"HeaderExchangedDocument\"]");
		NodeList ExchangedDocumentNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		xpr = xpath.compile("//*[local-name()=\"GrandTotalAmount\"]|//*[local-name()=\"PayableAmount\"]");
		BigDecimal expectedGrandTotal = null;
		NodeList totalNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		if (totalNodes.getLength() > 0) {
			expectedGrandTotal = new BigDecimal(totalNodes.item(0).getTextContent());
		}

		Date issueDate = null;
		Date dueDate = null;
		Date deliveryDate = null;
		String despatchAdviceReferencedDocument = null;
		for (int i = 0; i < ExchangedDocumentNodes.getLength(); i++) {

			// nodes.item(i).getTextContent())) {
			Node exchangedDocumentNode = ExchangedDocumentNodes.item(i);
			NodeList exchangedDocumentChilds = exchangedDocumentNode.getChildNodes();
			for (int documentChildIndex = 0; documentChildIndex < exchangedDocumentChilds.getLength(); documentChildIndex++) {
				Node item = exchangedDocumentChilds.item(documentChildIndex);
				if ((item.getLocalName() != null) && (item.getLocalName().equals("ID"))) {
					number = item.getTextContent();
				}
				if ((item.getLocalName() != null) && (item.getLocalName().equals("TypeCode"))) {
					typeCode = item.getTextContent();
				}
				if ((item.getLocalName() != null) && (item.getLocalName().equals("IssueDateTime"))) {
					NodeList issueDateTimeChilds = item.getChildNodes();
					for (int issueDateChildIndex = 0; issueDateChildIndex < issueDateTimeChilds.getLength(); issueDateChildIndex++) {
						if ((issueDateTimeChilds.item(issueDateChildIndex).getLocalName() != null)
							&& (issueDateTimeChilds.item(issueDateChildIndex).getLocalName().equals("DateTimeString"))) {
							issueDate = new SimpleDateFormat("yyyyMMdd").parse(issueDateTimeChilds.item(issueDateChildIndex).getTextContent());
						}
					}
				}
			}
		}
		String rootNode = extractString("local-name(/*)");
		if (rootNode.equals("Invoice")) {
			// UBL...
			number = extractString("//*[local-name()=\"Invoice\"]/*[local-name()=\"ID\"]").trim();
			issueDate = new SimpleDateFormat("yyyy-MM-dd").parse(extractString("//*[local-name()=\"Invoice\"]/*[local-name()=\"IssueDate\"]").trim());
			String dueDt = extractString("//*[local-name()=\"Invoice\"]/*[local-name()=\"DueDate\"]").trim();
			if (dueDt.length() > 0) {
				dueDate = new SimpleDateFormat("yyyy-MM-dd").parse(dueDt);
			}
			String deliveryDt = extractString("//*[local-name()=\"Delivery\"]/*[local-name()=\"ActualDeliveryDate\"]").trim();
			if (deliveryDt.length() > 0) {
				deliveryDate = new SimpleDateFormat("yyyy-MM-dd").parse(deliveryDt);
			}
		}
		xpr = xpath.compile("//*[local-name()=\"ApplicableHeaderTradeDelivery\"]");
		NodeList headerTradeDeliveryNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		for (int i = 0; i < headerTradeDeliveryNodes.getLength(); i++) {
			// nodes.item(i).getTextContent())) {
			Node headerTradeDeliveryNode = headerTradeDeliveryNodes.item(i);
			NodeList headerTradeDeliveryChilds = headerTradeDeliveryNode.getChildNodes();
			for (int deliveryChildIndex = 0; deliveryChildIndex < headerTradeDeliveryChilds.getLength(); deliveryChildIndex++) {
				if (headerTradeDeliveryChilds.item(deliveryChildIndex).getLocalName() != null) {
					if (headerTradeDeliveryChilds.item(deliveryChildIndex).getLocalName().equals("ActualDeliverySupplyChainEvent")) {
						NodeList actualDeliveryChilds = headerTradeDeliveryChilds.item(deliveryChildIndex).getChildNodes();
						for (int actualDeliveryChildIndex = 0; actualDeliveryChildIndex < actualDeliveryChilds.getLength(); actualDeliveryChildIndex++) {
							if ((actualDeliveryChilds.item(actualDeliveryChildIndex).getLocalName() != null)
								&& (actualDeliveryChilds.item(actualDeliveryChildIndex).getLocalName().equals("OccurrenceDateTime"))) {
								NodeList occurenceChilds = actualDeliveryChilds.item(actualDeliveryChildIndex).getChildNodes();
								for (int occurenceChildIndex = 0; occurenceChildIndex < occurenceChilds.getLength(); occurenceChildIndex++) {
									if ((occurenceChilds.item(occurenceChildIndex).getLocalName() != null)
										&& (occurenceChilds.item(occurenceChildIndex).getLocalName().equals("DateTimeString"))) {
										deliveryDate = new SimpleDateFormat("yyyyMMdd").parse(occurenceChilds.item(occurenceChildIndex).getTextContent());
									}
								}
							}
						}
					}

					if (headerTradeDeliveryChilds.item(deliveryChildIndex).getLocalName().equals("DespatchAdviceReferencedDocument")) {
						NodeList despatchAdviceChilds = headerTradeDeliveryChilds.item(deliveryChildIndex).getChildNodes();
						for (int despatchAdviceChildIndex = 0; despatchAdviceChildIndex < despatchAdviceChilds.getLength(); despatchAdviceChildIndex++) {
							if (despatchAdviceChilds.item(despatchAdviceChildIndex).getLocalName() != null
								&& despatchAdviceChilds.item(despatchAdviceChildIndex).getLocalName().equals("IssuerAssignedID")) {
								despatchAdviceReferencedDocument = despatchAdviceChilds.item(despatchAdviceChildIndex).getTextContent();
							}
						}
					}
				}
			}
		}

		xpr = xpath.compile("//*[local-name()=\"ApplicableHeaderTradeAgreement\"]");
		NodeList headerTradeAgreementNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		String buyerOrderIssuerAssignedID = null;
		String sellerOrderIssuerAssignedID = null;
		for (int i = 0; i < headerTradeAgreementNodes.getLength(); i++) {
			// nodes.item(i).getTextContent())) {
			Node headerTradeAgreementNode = headerTradeAgreementNodes.item(i);
			NodeList headerTradeAgreementChilds = headerTradeAgreementNode.getChildNodes();
			for (int agreementChildIndex = 0; agreementChildIndex < headerTradeAgreementChilds.getLength(); agreementChildIndex++) {
				if (headerTradeAgreementChilds.item(agreementChildIndex).getLocalName() != null) {
					if (headerTradeAgreementChilds.item(agreementChildIndex).getLocalName().equals("BuyerOrderReferencedDocument")) {
						NodeList buyerOrderChilds = headerTradeAgreementChilds.item(agreementChildIndex).getChildNodes();
						for (int buyerOrderChildIndex = 0; buyerOrderChildIndex < buyerOrderChilds.getLength(); buyerOrderChildIndex++) {
							if ((buyerOrderChilds.item(buyerOrderChildIndex).getLocalName() != null)
								&& (buyerOrderChilds.item(buyerOrderChildIndex).getLocalName().equals("IssuerAssignedID"))) {
								buyerOrderIssuerAssignedID = buyerOrderChilds.item(buyerOrderChildIndex).getTextContent();
							}
						}
					}

					if (headerTradeAgreementChilds.item(agreementChildIndex).getLocalName().equals("SellerOrderReferencedDocument")) {
						NodeList sellerOrderChilds = headerTradeAgreementChilds.item(agreementChildIndex).getChildNodes();
						for (int sellerOrderChildIndex = 0; sellerOrderChildIndex < sellerOrderChilds.getLength(); sellerOrderChildIndex++) {
							if ((sellerOrderChilds.item(sellerOrderChildIndex).getLocalName() != null)
								&& (sellerOrderChilds.item(sellerOrderChildIndex).getLocalName().equals("IssuerAssignedID"))) {
								sellerOrderIssuerAssignedID = sellerOrderChilds.item(sellerOrderChildIndex).getTextContent();
							}
						}
					}
				}
			}

		}


		xpr = xpath.compile("//*[local-name()=\"ApplicableHeaderTradeSettlement\"]|//*[local-name()=\"ApplicableSupplyChainTradeSettlement\"]");
		NodeList headerTradeSettlementNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		List<BankDetails> bankDetails = new ArrayList<>();

		for (int i = 0; i < headerTradeSettlementNodes.getLength(); i++) {
			// nodes.item(i).getTextContent())) {
			Node headerTradeSettlementNode = headerTradeSettlementNodes.item(i);
			NodeList headerTradeSettlementChilds = headerTradeSettlementNode.getChildNodes();
			for (int settlementChildIndex = 0; settlementChildIndex < headerTradeSettlementChilds.getLength(); settlementChildIndex++) {
				if ((headerTradeSettlementChilds.item(settlementChildIndex).getLocalName() != null)
					&& (headerTradeSettlementChilds.item(settlementChildIndex).getLocalName().equals("SpecifiedTradePaymentTerms"))) {
					NodeList paymentTermChilds = headerTradeSettlementChilds.item(settlementChildIndex).getChildNodes();
					for (int paymentTermChildIndex = 0; paymentTermChildIndex < paymentTermChilds.getLength(); paymentTermChildIndex++) {
						if ((paymentTermChilds.item(paymentTermChildIndex).getLocalName() != null) && (paymentTermChilds.item(paymentTermChildIndex).getLocalName().equals("DueDateDateTime"))) {
							NodeList dueDateChilds = paymentTermChilds.item(paymentTermChildIndex).getChildNodes();
							for (int dueDateChildIndex = 0; dueDateChildIndex < dueDateChilds.getLength(); dueDateChildIndex++) {
								if ((dueDateChilds.item(dueDateChildIndex).getLocalName() != null) && (dueDateChilds.item(dueDateChildIndex).getLocalName().equals("DateTimeString"))) {
									dueDate = new SimpleDateFormat("yyyyMMdd").parse(dueDateChilds.item(dueDateChildIndex).getTextContent());
								}
							}
						}
					}
				}

				if ((headerTradeSettlementChilds.item(settlementChildIndex).getLocalName() != null)
					&& (headerTradeSettlementChilds.item(settlementChildIndex).getLocalName().equals("SpecifiedTradeSettlementPaymentMeans"))) {
					NodeList paymentMeansChilds = headerTradeSettlementChilds.item(settlementChildIndex).getChildNodes();
					for (int paymentMeansChildIndex = 0; paymentMeansChildIndex < paymentMeansChilds.getLength(); paymentMeansChildIndex++) {
						String IBAN = null, BIC = null;
						if ((paymentMeansChilds.item(paymentMeansChildIndex).getLocalName() != null) && (paymentMeansChilds.item(paymentMeansChildIndex).getLocalName().equals("PayeePartyCreditorFinancialAccount"))) {
							NodeList accountChilds = paymentMeansChilds.item(paymentMeansChildIndex).getChildNodes();
							for (int accountChildIndex = 0; accountChildIndex < accountChilds.getLength(); accountChildIndex++) {
								if ((accountChilds.item(accountChildIndex).getLocalName() != null) && (accountChilds.item(accountChildIndex).getLocalName().equals("IBANID"))) {//CII
									IBAN = accountChilds.item(accountChildIndex).getTextContent();
								}
							}
						}
						if ((paymentMeansChilds.item(paymentMeansChildIndex).getLocalName() != null) && (paymentMeansChilds.item(paymentMeansChildIndex).getLocalName().equals("PayeePartyCreditorFinancialInstitution"))) {
							NodeList accountChilds = paymentMeansChilds.item(paymentMeansChildIndex).getChildNodes();
							for (int accountChildIndex = 0; accountChildIndex < accountChilds.getLength(); accountChildIndex++) {
								if ((accountChilds.item(accountChildIndex).getLocalName() != null) && (accountChilds.item(accountChildIndex).getLocalName().equals("BICID"))) {//CII
									BIC = accountChilds.item(accountChildIndex).getTextContent();
								}
							}
						}
						if (IBAN != null) {
							BankDetails bd = new BankDetails(IBAN);
							if (BIC != null) {
								bd.setBIC(BIC);
							}
							bankDetails.add(bd);
						}
					}
				}
			}
		}


		xpr = xpath.compile("//*[local-name()=\"PaymentMeans\"]"); //UBL only
		NodeList paymentMeansNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		for (int i = 0; i < paymentMeansNodes.getLength(); i++) {
			// nodes.item(i).getTextContent())) {
			Node paymentMeansNode = paymentMeansNodes.item(i);
			NodeList paymentMeansChilds = paymentMeansNode.getChildNodes();
			for (int meansChildIndex = 0; meansChildIndex < paymentMeansChilds.getLength(); meansChildIndex++) {
				if ((paymentMeansChilds.item(meansChildIndex).getLocalName() != null)
					&& (paymentMeansChilds.item(meansChildIndex).getLocalName().equals("PayeeFinancialAccount"))) {
					NodeList paymentTermChilds = paymentMeansChilds.item(meansChildIndex).getChildNodes();
					for (int paymentTermChildIndex = 0; paymentTermChildIndex < paymentTermChilds.getLength(); paymentTermChildIndex++) {
						if ((paymentTermChilds.item(paymentTermChildIndex).getLocalName() != null) && (paymentTermChilds.item(paymentTermChildIndex).getLocalName().equals("ID"))) {
							String IBAN = paymentTermChilds.item(paymentTermChildIndex).getTextContent();
							if (IBAN != null) {
								BankDetails bd = new BankDetails(IBAN);
								bankDetails.add(bd);
							}
						}
					}
				}
			}
		}

		zpp.setDueDate(dueDate).setDeliveryDate(deliveryDate).setIssueDate(issueDate).setSender(new TradeParty(SellerNodes)).setRecipient(new TradeParty(BuyerNodes)).setNumber(number).setDocumentCode(typeCode);
		bankDetails.forEach(bankDetail -> zpp.getSender().addBankDetails(bankDetail));

		if (buyerOrderIssuerAssignedID != null) {
			zpp.setBuyerOrderReferencedDocumentID(buyerOrderIssuerAssignedID);
		}
		if (sellerOrderIssuerAssignedID != null) {
			zpp.setSellerOrderReferencedDocumentID(sellerOrderIssuerAssignedID);
		}
		if (despatchAdviceReferencedDocument != null) {
			zpp.setDespatchAdviceReferencedDocumentID(despatchAdviceReferencedDocument);
		}

		zpp.setOwnOrganisationName(extractString("//*[local-name()=\"SellerTradeParty\"]/*[local-name()=\"Name\"]|//*[local-name()=\"AccountingSupplierParty\"]/*[local-name()=\"Party\"]/*[local-name()=\"PartyName\"]").trim());

		xpr = xpath.compile("//*[local-name()=\"BuyerReference\"]");
		String buyerReference = null;
		totalNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		if (totalNodes.getLength() > 0) {
			buyerReference = totalNodes.item(0).getTextContent();
		}
		if (buyerReference != null) {
			zpp.setReferenceNumber(buyerReference);
		}

		xpr = xpath.compile("//*[local-name()=\"IncludedSupplyChainTradeLineItem\"]|//*[local-name()=\"InvoiceLine\"]");
		NodeList nodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		if (nodes.getLength() != 0) {
			for (int i = 0; i < nodes.getLength(); i++) {

				Node currentItemNode = nodes.item(i);
				Item it = new Item(currentItemNode.getChildNodes(), recalcPrice);
				zpp.addItem(it);

			}

			// now handling base64 encoded attachments AttachmentBinaryObject=CII, EmbeddedDocumentBinaryObject=UBL
			xpr = xpath.compile("//*[local-name()=\"AttachmentBinaryObject\"]|//*[local-name()=\"EmbeddedDocumentBinaryObject\"]");
			NodeList attachmentNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
			for (int i = 0; i < attachmentNodes.getLength(); i++) {
				FileAttachment fa=new FileAttachment(attachmentNodes.item(i).getAttributes().getNamedItem("filename").getNodeValue(),attachmentNodes.item(i).getAttributes().getNamedItem("mimeCode").getNodeValue(),"Data", Base64.getDecoder().decode(attachmentNodes.item(i).getTextContent()));
				fileAttachments.add(fa);
				// filename = "Aufmass.png" mimeCode = "image/png"
				//EmbeddedDocumentBinaryObject cbc:EmbeddedDocumentBinaryObject mimeCode="image/png" filename="Aufmass.png"
			}

			// item level charges+allowances are not yet handled but a lower item price will
			// be read,
			// so the invoice remains arithmetically correct
			// -> parse document level charges+allowances
			xpr = xpath.compile("//*[local-name()=\"SpecifiedTradeAllowanceCharge\"]");
			NodeList chargeNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
			for (int i = 0; i < chargeNodes.getLength(); i++) {
				NodeList chargeNodeChilds = chargeNodes.item(i).getChildNodes();
				boolean isCharge = true;
				String chargeAmount = null;
				String reason = null;
				String reasonCode = null;
				String taxPercent = null;
				for (int chargeChildIndex = 0; chargeChildIndex < chargeNodeChilds.getLength(); chargeChildIndex++) {
					String chargeChildName = chargeNodeChilds.item(chargeChildIndex).getLocalName();
					if (chargeChildName != null) {

						if (chargeChildName.equals("ChargeIndicator")) {
							NodeList indicatorChilds = chargeNodeChilds.item(chargeChildIndex).getChildNodes();
							for (int indicatorChildIndex = 0; indicatorChildIndex < indicatorChilds.getLength(); indicatorChildIndex++) {
								if ((indicatorChilds.item(indicatorChildIndex).getLocalName() != null)
									&& (indicatorChilds.item(indicatorChildIndex).getLocalName().equals("Indicator"))) {
									isCharge = indicatorChilds.item(indicatorChildIndex).getTextContent().equalsIgnoreCase("true");
								}
							}
						} else if (chargeChildName.equals("ActualAmount")) {
							chargeAmount = chargeNodeChilds.item(chargeChildIndex).getTextContent();
						} else if (chargeChildName.equals("Reason")) {
							reason = chargeNodeChilds.item(chargeChildIndex).getTextContent();
						} else if (chargeChildName.equals("ReasonCode")) {
							reasonCode = chargeNodeChilds.item(chargeChildIndex).getTextContent();
						} else if (chargeChildName.equals("CategoryTradeTax")) {
							NodeList taxChilds = chargeNodeChilds.item(chargeChildIndex).getChildNodes();
							for (int taxChildIndex = 0; taxChildIndex < taxChilds.getLength(); taxChildIndex++) {
								String taxItemName = taxChilds.item(taxChildIndex).getLocalName();
								if ((taxItemName != null) && (taxItemName.equals("RateApplicablePercent") || taxItemName.equals("ApplicablePercent"))) {
									taxPercent = taxChilds.item(taxChildIndex).getTextContent();
								}
							}
						}
					}
				}

				if (isCharge) {
					Charge c = new Charge(new BigDecimal(chargeAmount));
					if (reason != null) {
						c.setReason(reason);
					}
					if (reasonCode != null) {
						c.setReasonCode(reasonCode);
					}
					if (taxPercent != null) {
						c.setTaxPercent(new BigDecimal(taxPercent));
					}
					zpp.addCharge(c);
				} else {
					Allowance a = new Allowance(new BigDecimal(chargeAmount));
					if (reason != null) {
						a.setReason(reason);
					}
					if (reasonCode != null) {
						a.setReasonCode(reasonCode);
					}
					if (taxPercent != null) {
						a.setTaxPercent(new BigDecimal(taxPercent));
					}
					zpp.addAllowance(a);
				}

			}

			TransactionCalculator tc = new TransactionCalculator(zpp);
			String expectedStringTotalGross = tc.getGrandTotal().toPlainString();
			EStandard whichType;
			try {
				whichType = getStandard();
			} catch (Exception e) {
				throw new ParseException("Could not find out if it's an invoice, order, or delivery advice", 0);

			}

			if ((whichType != EStandard.despatchadvice)
				&& ((!expectedStringTotalGross.equals(XMLTools.nDigitFormat(expectedGrandTotal, 2)))
				&& (!ignoreCalculationErrors))) {
				throw new ParseException(
					"Could not reproduce the invoice, this could mean that it could not be read properly", 0);
			}
		}
		return zpp;

	}

	/***
	 *
	 * @return the file attachments embedded in XML (using base64) decoded as byte array,
	 * @see for PDF embedded files in FX use getFileAttachmentsPDF()
	 */
	public List<FileAttachment> getFileAttachmentsXML() {
		return fileAttachments;
	}

	/***
	 * This will parse a XML into a invoice object
	 *
	 * @return the parsed invoice object
	 * @throws XPathExpressionException if internal xpath expressions were wrong
	 * @throws ParseException if the grand total of the parsed invoice could not be replicated with the new invoice
	 */
	public Invoice extractInvoice() throws XPathExpressionException, ParseException {
		Invoice i = new Invoice();
		return extractInto(i);


	}

	/***
	 * have the item prices be determined from the line total.
	 * That's a workaround for some invoices which just put 0 as item price
	 */
	public void doRecalculateItemPricesFromLineTotals() {
		recalcPrice = true;
	}

	/***
	 * do not raise ParseExceptions even if the reproduced invoice total does not match the given value
	 */
	public void doIgnoreCalculationErrors() {
		ignoreCalculationErrors = true;
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
		importedInvoice.getProfile
			@todo
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
			// Exception was already logged
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
		try {
			if (getVersion() == 1) {
				return extractString("//*[local-name() = 'HeaderExchangedDocument']//*[local-name() = 'ID']");
			} else {
				return extractString("//*[local-name() = 'ExchangedDocument']//*[local-name() = 'ID']");
			}
		} catch (final Exception e) {
			// Exception was already logged
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
		return importedInvoice.getRecipient().getID();
	}

	/**
	 * @return the Issue Date()
	 */
	public String getIssueDate() {
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
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
		try {
			return IOUtils.toString(is, StandardCharsets.UTF_8);
		} catch (IOException e) {
			throw new UncheckedIOException(e);
		}
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
