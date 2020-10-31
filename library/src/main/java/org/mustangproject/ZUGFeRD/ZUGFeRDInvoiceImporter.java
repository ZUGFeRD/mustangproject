package org.mustangproject.ZUGFeRD;

import org.mustangproject.*;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.xpath.*;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ZUGFeRDInvoiceImporter extends ZUGFeRDImporter {
	public ZUGFeRDInvoiceImporter(String filename) {
		super(filename);
	}

	public Invoice extractInvoice() {

		String number = "";
		/**
		 * dummywerte sind derzeit noch setDueDate setIssueDate setDeliveryDate setSender setRecipient setnumber
		 * bspw. due date //ExchangedDocument//IssueDateTime//DateTimeString : due date optional
		 */
		XPathFactory xpathFact = XPathFactory.newInstance();
		XPath xpath = xpathFact.newXPath();
		Invoice zpp = null;
		try {
			XPathExpression xpr = xpath.compile(
					"//SellerTradeParty");
			NodeList SellerNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
			xpr = xpath.compile(
					"//BuyerTradeParty");
			NodeList BuyerNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
			xpr = xpath.compile(
					"//*[local-name()=\"ExchangedDocument\"]");
			NodeList ExchangedDocumentNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

			Date issueDate = null;
			Date dueDate = null;
			Date deliveryDate = null;
			for (int i = 0; i < ExchangedDocumentNodes.getLength(); i++) {

				//nodes.item(i).getTextContent())) {
				Node exchangedDocumentNode = ExchangedDocumentNodes.item(i);
				NodeList exchangedDocumentChilds = exchangedDocumentNode.getChildNodes();
				for (int documentChildIndex = 0; documentChildIndex < exchangedDocumentChilds.getLength(); documentChildIndex++) {
					if (exchangedDocumentChilds.item(documentChildIndex).getNodeName().equals("ram:ID")) {
	/*					NodeList tradeLineChilds = itemChilds.item(documentChildIndex).getChildNodes();
						for (int tradeLineChildIndex = 0; tradeLineChildIndex < tradeLineChilds.getLength(); tradeLineChildIndex++) {
							if (tradeLineChilds.item(tradeLineChildIndex).getNodeName().equals("ram:NetPriceProductTradePrice")) {
								NodeList netChilds = tradeLineChilds.item(tradeLineChildIndex).getChildNodes();
								for (int netIndex = 0; netIndex < netChilds.getLength(); netIndex++) {
									if (netChilds.item(netIndex).getNodeName().equals("ram:ChargeAmount")) {
										price = netChilds.item(netIndex).getTextContent();//ram:ChargeAmount

									}
								}
							}
						}*/
						number = exchangedDocumentChilds.item(documentChildIndex).getTextContent();
					}
					if (exchangedDocumentChilds.item(documentChildIndex).getNodeName().equals("ram:IssueDateTime")) {
						NodeList issueDateTimeChilds = exchangedDocumentChilds.item(documentChildIndex).getChildNodes();
						for (int issueDateChildIndex = 0; issueDateChildIndex < issueDateTimeChilds.getLength(); issueDateChildIndex++) {
							if (issueDateTimeChilds.item(issueDateChildIndex).getNodeName().equals("udt:DateTimeString")) {
								issueDate = new SimpleDateFormat("yyyyMMdd").parse(issueDateTimeChilds.item(issueDateChildIndex).getTextContent());
							}
						}
					}
				}
			}


			xpr = xpath.compile(
					"//*[local-name()=\"ApplicableHeaderTradeDelivery\"]");
			NodeList headerTradeDeliveryNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

			for (int i = 0; i < headerTradeDeliveryNodes.getLength(); i++) {
				//nodes.item(i).getTextContent())) {
				Node headerTradeDeliveryNode = headerTradeDeliveryNodes.item(i);
				NodeList headerTradeDeliveryChilds = headerTradeDeliveryNode.getChildNodes();
				for (int deliveryChildIndex = 0; deliveryChildIndex < headerTradeDeliveryChilds.getLength(); deliveryChildIndex++) {
					if (headerTradeDeliveryChilds.item(deliveryChildIndex).getNodeName().equals("ram:ActualDeliverySupplyChainEvent")) {
						NodeList actualDeliveryChilds = headerTradeDeliveryChilds.item(deliveryChildIndex).getChildNodes();
						for (int actualDeliveryChildIndex = 0; actualDeliveryChildIndex < actualDeliveryChilds.getLength(); actualDeliveryChildIndex++) {
							if (actualDeliveryChilds.item(actualDeliveryChildIndex).getNodeName().equals("ram:OccurrenceDateTime")) {
								NodeList occurenceChilds = actualDeliveryChilds.item(actualDeliveryChildIndex).getChildNodes();
								for (int occurenceChildIndex = 0; occurenceChildIndex < occurenceChilds.getLength(); occurenceChildIndex++) {
									if (occurenceChilds.item(occurenceChildIndex).getNodeName().equals("udt:DateTimeString")) {
										deliveryDate = new SimpleDateFormat("yyyyMMdd").parse(occurenceChilds.item(occurenceChildIndex).getTextContent());

									}
								}
							}
						}
					}
				}
			}


			xpr = xpath.compile(
					"//*[local-name()=\"ApplicableHeaderTradeSettlement\"]");
			NodeList headerTradeSettlementNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

			for (int i = 0; i < headerTradeSettlementNodes.getLength(); i++) {
				//nodes.item(i).getTextContent())) {
				Node headerTradeSettlementNode = headerTradeSettlementNodes.item(i);
				NodeList headerTradeSettlementChilds = headerTradeSettlementNode.getChildNodes();
				for (int settlementChildIndex = 0; settlementChildIndex < headerTradeSettlementChilds.getLength(); settlementChildIndex++) {
					if (headerTradeSettlementChilds.item(settlementChildIndex).getNodeName().equals("ram:SpecifiedTradePaymentTerms")) {
						NodeList paymentTermChilds = headerTradeSettlementChilds.item(settlementChildIndex).getChildNodes();
						for (int paymentTermChildIndex = 0; paymentTermChildIndex < paymentTermChilds.getLength(); paymentTermChildIndex++) {
							if (paymentTermChilds.item(paymentTermChildIndex).getNodeName().equals("ram:DueDateDateTime")) {
								NodeList dueDateChilds = paymentTermChilds.item(paymentTermChildIndex).getChildNodes();
								for (int dueDateChildIndex = 0; dueDateChildIndex < dueDateChilds.getLength(); dueDateChildIndex++) {
									if (dueDateChilds.item(dueDateChildIndex).getNodeName().equals("udt:DateTimeString")) {
										dueDate = new SimpleDateFormat("yyyyMMdd").parse(dueDateChilds.item(dueDateChildIndex).getTextContent());

									}
								}
							}
						}
					}
				}
			}

			zpp = new Invoice().setDueDate(dueDate).setDeliveryDate(deliveryDate).setIssueDate(issueDate).setSender(new TradeParty(SellerNodes)).setRecipient(new TradeParty(BuyerNodes)).setNumber(number);
//.addItem(new Item(new Product("Testprodukt","","C62",new BigDecimal(0)),amount,new BigDecimal(1.0)))
			zpp.setOwnOrganisationName(extractString("//SellerTradeParty/Name"));

			xpr = xpath.compile(
					"//*[local-name()=\"IncludedSupplyChainTradeLineItem\"]");
			NodeList nodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

			if (nodes.getLength() == 0) {
			} else {
				for (int i = 0; i < nodes.getLength(); i++) {

					String price = "0";
					String name = "";
					String description = "";
					String quantity = "0";
					String vatPercent = "0";
					String unitCode = "0";

					//nodes.item(i).getTextContent())) {
					Node currentItemNode = nodes.item(i);
					NodeList itemChilds = currentItemNode.getChildNodes();
					for (int itemChildIndex = 0; itemChildIndex < itemChilds.getLength(); itemChildIndex++) {
						if (itemChilds.item(itemChildIndex).getNodeName().equals("ram:SpecifiedLineTradeAgreement")) {
							NodeList tradeLineChilds = itemChilds.item(itemChildIndex).getChildNodes();
							for (int tradeLineChildIndex = 0; tradeLineChildIndex < tradeLineChilds.getLength(); tradeLineChildIndex++) {
								if (tradeLineChilds.item(tradeLineChildIndex).getNodeName().equals("ram:NetPriceProductTradePrice")) {
									NodeList netChilds = tradeLineChilds.item(tradeLineChildIndex).getChildNodes();
									for (int netIndex = 0; netIndex < netChilds.getLength(); netIndex++) {
										if (netChilds.item(netIndex).getNodeName().equals("ram:ChargeAmount")) {
											price = netChilds.item(netIndex).getTextContent();//ram:ChargeAmount

										}
									}
								}
							}
						}
						if (itemChilds.item(itemChildIndex).getNodeName().equals("ram:SpecifiedLineTradeDelivery")) {
							NodeList tradeLineChilds = itemChilds.item(itemChildIndex).getChildNodes();
							for (int tradeLineChildIndex = 0; tradeLineChildIndex < tradeLineChilds.getLength(); tradeLineChildIndex++) {
								if (tradeLineChilds.item(tradeLineChildIndex).getNodeName().equals("ram:BilledQuantity")) {
									quantity = tradeLineChilds.item(tradeLineChildIndex).getTextContent();
									unitCode = tradeLineChilds.item(tradeLineChildIndex).getAttributes().getNamedItem("unitCode").getNodeValue();
								}
							}
						}
						if (itemChilds.item(itemChildIndex).getNodeName().equals("ram:SpecifiedTradeProduct")) {
							NodeList tradeProductChilds = itemChilds.item(itemChildIndex).getChildNodes();
							for (int tradeProductChildIndex = 0; tradeProductChildIndex < tradeProductChilds.getLength(); tradeProductChildIndex++) {
								if (tradeProductChilds.item(tradeProductChildIndex).getNodeName().equals("ram:Name")) {
									name = tradeProductChilds.item(tradeProductChildIndex).getTextContent();
								}
							}
						}
						if (itemChilds.item(itemChildIndex).getNodeName().equals("ram:SpecifiedLineTradeSettlement")) {
							NodeList tradeSettlementChilds = itemChilds.item(itemChildIndex).getChildNodes();
							for (int tradeSettlementChildIndex = 0; tradeSettlementChildIndex < tradeSettlementChilds.getLength(); tradeSettlementChildIndex++) {
								if (tradeSettlementChilds.item(tradeSettlementChildIndex).getNodeName().equals("ram:ApplicableTradeTax")) {
									NodeList taxChilds = tradeSettlementChilds.item(tradeSettlementChildIndex).getChildNodes();
									for (int taxChildIndex = 0; taxChildIndex < taxChilds.getLength(); taxChildIndex++) {
										if (taxChilds.item(taxChildIndex).getNodeName().equals("ram:RateApplicablePercent")) {
											vatPercent = taxChilds.item(taxChildIndex).getTextContent();
										}
									}
								}
							}
						}


					}
					zpp.addItem(new Item(new Product(name, description, unitCode, new BigDecimal(vatPercent)), new BigDecimal(price), new BigDecimal(quantity)));
				}

			}


		} catch (XPathExpressionException e) {
			e.printStackTrace();
		} catch (ParseException ex) {
			ex.printStackTrace();
		}

		return zpp;
	}
}
