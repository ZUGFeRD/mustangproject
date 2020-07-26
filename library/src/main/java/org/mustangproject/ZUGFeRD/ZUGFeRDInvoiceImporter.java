package org.mustangproject.ZUGFeRD;

import library.src.main.java.org.mustangproject.Contact;
import library.src.main.java.org.mustangproject.Invoice;
import library.src.main.java.org.mustangproject.Item;
import library.src.main.java.org.mustangproject.Product;
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

		String number="AB123";
			Invoice zpp=new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setOwnStreet("teststr").setOwnZIP("55232").setOwnLocation("teststadt").setOwnCountry("DE").setOwnTaxID("4711").setOwnVATID("0815").setRecipient(new Contact("Franz Müller", "0177123456", "fmueller@test.com", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number);
//.addItem(new Item(new Product("Testprodukt","","C62",new BigDecimal(0)),amount,new BigDecimal(1.0)))
		zpp.setOwnOrganisationName(extractString("//SellerTradeParty/Name"));

		XPathFactory xpathFact = XPathFactory.newInstance();
		XPath xpath = xpathFact.newXPath();
		try {

			XPathExpression xpr = xpath.compile(
					"//*[local-name()=\"IncludedSupplyChainTradeLineItem\"]");
			NodeList nodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		if (nodes.getLength() == 0) {
		} else {
			for (int i = 0; i < nodes.getLength(); i++) {
				//nodes.item(i).getTextContent())) {
				Node currentItemNode=nodes.item(i);
				NodeList itemChilds=currentItemNode.getChildNodes();
				String price="0";
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
				}
//				Logger.getLogger(ZUGFeRDInvoiceImporter.class.getName()).log(Level.INFO, "deb "+price);

				zpp.addItem(new Item(new Product("Testprodukt","","C62",new BigDecimal(0)),new BigDecimal(price),new BigDecimal(1.0)));
			}

		}


		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}

		return zpp;
	}


}
