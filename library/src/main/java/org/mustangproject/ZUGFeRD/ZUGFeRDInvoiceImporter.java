package org.mustangproject.ZUGFeRD;

import org.mustangproject.*;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.xpath.*;
import java.math.BigDecimal;
import java.util.Date;

public class ZUGFeRDInvoiceImporter extends ZUGFeRDImporter {
	public ZUGFeRDInvoiceImporter(String filename) {
		super(filename);
	}

	public Invoice extractInvoice() {

		String number = "AB123";
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

			zpp = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setSender(new TradeParty(SellerNodes)).setRecipient(new TradeParty(BuyerNodes)).setNumber(number);
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
		}

		return zpp;
	}


}
