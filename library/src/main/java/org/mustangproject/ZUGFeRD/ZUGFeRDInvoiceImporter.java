package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.mustangproject.Allowance;
import org.mustangproject.Charge;
import org.mustangproject.EStandard;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.ReferencedDocument;
import org.mustangproject.SchemedID;
import org.mustangproject.TradeParty;
import org.mustangproject.XMLTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ZUGFeRDInvoiceImporter extends ZUGFeRDImporter {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDInvoiceImporter.class.getCanonicalName()); // log
	private boolean recalcPrice = false;
	private boolean ignoreCalculationErrors = false;

	public ZUGFeRDInvoiceImporter() {
		super();
	}

	public ZUGFeRDInvoiceImporter(String filename) {
		super(filename);
	}

	public ZUGFeRDInvoiceImporter(InputStream stream) {
		super(stream);
	}

	public void fromXML(String XML) {
		try {
			containsMeta = true;
			setRawXML(XML.getBytes(StandardCharsets.UTF_8));
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
	}

	public Invoice extractInto(Invoice zpp) throws XPathExpressionException, ParseException {

		String number = "";
		/*
		 * dummywerte sind derzeit noch setDueDate setIssueDate setDeliveryDate
		 * setSender setRecipient setnumber bspw. due date
		 * //ExchangedDocument//IssueDateTime//DateTimeString : due date optional
		 */
		XPathFactory xpathFact = XPathFactory.newInstance();
		XPath xpath = xpathFact.newXPath();
		XPathExpression xpr = xpath.compile("//*[local-name()=\"SellerTradeParty\"]");
		NodeList SellerNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		xpr = xpath.compile("//*[local-name()=\"BuyerTradeParty\"]");
		NodeList BuyerNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		xpr = xpath.compile("//*[local-name()=\"ExchangedDocument\"]|//*[local-name()=\"HeaderExchangedDocument\"]");
		NodeList ExchangedDocumentNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		xpr = xpath.compile("//*[local-name()=\"GrandTotalAmount\"]");
		BigDecimal expectedGrandTotal = null;
		NodeList totalNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		if (totalNodes.getLength() > 0) {
			expectedGrandTotal = new BigDecimal(totalNodes.item(0).getTextContent());
		}

		Date issueDate = null;
		Date dueDate = null;
		Date deliveryDate = null;
		for (int i = 0; i < ExchangedDocumentNodes.getLength(); i++) {

			// nodes.item(i).getTextContent())) {
			Node exchangedDocumentNode = ExchangedDocumentNodes.item(i);
			NodeList exchangedDocumentChilds = exchangedDocumentNode.getChildNodes();
			for (int documentChildIndex = 0; documentChildIndex < exchangedDocumentChilds
					.getLength(); documentChildIndex++) {
				Node item = exchangedDocumentChilds.item(documentChildIndex);
				if ((item.getLocalName() != null) && (item.getLocalName().equals("ID"))) {
					number = item.getTextContent();
				}
				if ((item.getLocalName() != null) && (item.getLocalName().equals("IssueDateTime"))) {
					NodeList issueDateTimeChilds = item.getChildNodes();
					for (int issueDateChildIndex = 0; issueDateChildIndex < issueDateTimeChilds
							.getLength(); issueDateChildIndex++) {
						if ((issueDateTimeChilds.item(issueDateChildIndex).getLocalName() != null)
								&& (issueDateTimeChilds.item(issueDateChildIndex).getLocalName()
								.equals("DateTimeString"))) {
							issueDate = new SimpleDateFormat("yyyyMMdd")
									.parse(issueDateTimeChilds.item(issueDateChildIndex).getTextContent());
						}
					}
				}
			}
		}

		xpr = xpath.compile("//*[local-name()=\"ApplicableHeaderTradeDelivery\"]");
		NodeList headerTradeDeliveryNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		for (int i = 0; i < headerTradeDeliveryNodes.getLength(); i++) {
			// nodes.item(i).getTextContent())) {
			Node headerTradeDeliveryNode = headerTradeDeliveryNodes.item(i);
			NodeList headerTradeDeliveryChilds = headerTradeDeliveryNode.getChildNodes();
			for (int deliveryChildIndex = 0; deliveryChildIndex < headerTradeDeliveryChilds
					.getLength(); deliveryChildIndex++) {
				if ((headerTradeDeliveryChilds.item(deliveryChildIndex).getLocalName() != null)
						&& (headerTradeDeliveryChilds.item(deliveryChildIndex).getLocalName()
						.equals("ActualDeliverySupplyChainEvent"))) {
					NodeList actualDeliveryChilds = headerTradeDeliveryChilds.item(deliveryChildIndex).getChildNodes();
					for (int actualDeliveryChildIndex = 0; actualDeliveryChildIndex < actualDeliveryChilds
							.getLength(); actualDeliveryChildIndex++) {
						if ((actualDeliveryChilds.item(actualDeliveryChildIndex).getLocalName() != null)
								&& (actualDeliveryChilds.item(actualDeliveryChildIndex).getLocalName()
								.equals("OccurrenceDateTime"))) {
							NodeList occurenceChilds = actualDeliveryChilds.item(actualDeliveryChildIndex)
									.getChildNodes();
							for (int occurenceChildIndex = 0; occurenceChildIndex < occurenceChilds
									.getLength(); occurenceChildIndex++) {
								if ((occurenceChilds.item(occurenceChildIndex).getLocalName() != null)
										&& (occurenceChilds.item(occurenceChildIndex).getLocalName()
										.equals("DateTimeString"))) {
									deliveryDate = new SimpleDateFormat("yyyyMMdd")
											.parse(occurenceChilds.item(occurenceChildIndex).getTextContent());
								}
							}
						}
					}
				}
			}
		}

		xpr = xpath.compile("//*[local-name()=\"ApplicableHeaderTradeSettlement\"]|//*[local-name()=\"ApplicableSupplyChainTradeSettlement\"]");
		NodeList headerTradeSettlementNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		for (int i = 0; i < headerTradeSettlementNodes.getLength(); i++) {
			// nodes.item(i).getTextContent())) {
			Node headerTradeSettlementNode = headerTradeSettlementNodes.item(i);
			NodeList headerTradeSettlementChilds = headerTradeSettlementNode.getChildNodes();
			for (int settlementChildIndex = 0; settlementChildIndex < headerTradeSettlementChilds
					.getLength(); settlementChildIndex++) {
				if ((headerTradeSettlementChilds.item(settlementChildIndex).getLocalName() != null)
						&& (headerTradeSettlementChilds.item(settlementChildIndex).getLocalName()
						.equals("SpecifiedTradePaymentTerms"))) {
					NodeList paymentTermChilds = headerTradeSettlementChilds.item(settlementChildIndex).getChildNodes();
					for (int paymentTermChildIndex = 0; paymentTermChildIndex < paymentTermChilds
							.getLength(); paymentTermChildIndex++) {
						if ((paymentTermChilds.item(paymentTermChildIndex).getLocalName() != null) && (paymentTermChilds
								.item(paymentTermChildIndex).getLocalName().equals("DueDateDateTime"))) {
							NodeList dueDateChilds = paymentTermChilds.item(paymentTermChildIndex).getChildNodes();
							for (int dueDateChildIndex = 0; dueDateChildIndex < dueDateChilds
									.getLength(); dueDateChildIndex++) {
								if ((dueDateChilds.item(dueDateChildIndex).getLocalName() != null) && (dueDateChilds
										.item(dueDateChildIndex).getLocalName().equals("DateTimeString"))) {
									dueDate = new SimpleDateFormat("yyyyMMdd")
											.parse(dueDateChilds.item(dueDateChildIndex).getTextContent());
								}
							}
						}
					}
				}
			}
		}

		zpp.setDueDate(dueDate).setDeliveryDate(deliveryDate).setIssueDate(issueDate)
				.setSender(new TradeParty(SellerNodes)).setRecipient(new TradeParty(BuyerNodes)).setNumber(number);
//.addItem(new Item(new Product("Testprodukt","","C62",BigDecimal.ZERO),amount,new BigDecimal(1.0)))
		zpp.setOwnOrganisationName(extractString("//*[local-name()=\"SellerTradeParty\"]/*[local-name()=\"Name\"]"));

		xpr = xpath.compile("//*[local-name()=\"BuyerReference\"]");
		String buyerReference = null;
		totalNodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);
		if (totalNodes.getLength() > 0) {
			buyerReference = totalNodes.item(0).getTextContent();
		}
		if (buyerReference != null) {
			zpp.setReferenceNumber(buyerReference);
		}

		xpr = xpath.compile("//*[local-name()=\"IncludedSupplyChainTradeLineItem\"]");
		NodeList nodes = (NodeList) xpr.evaluate(getDocument(), XPathConstants.NODESET);

		if (nodes.getLength() == 0) {
		} else {
			for (int i = 0; i < nodes.getLength(); i++) {

				String price = "0";
				String name = "";
				String description = "";
				SchemedID gid = null;
				String quantity = "0";
				String vatPercent = null;
				String lineTotal = "0";
				String unitCode = "0";

				ArrayList<ReferencedDocument> rdocs = null;

				// nodes.item(i).getTextContent())) {
				Node currentItemNode = nodes.item(i);
				NodeList itemChilds = currentItemNode.getChildNodes();
				for (int itemChildIndex = 0; itemChildIndex < itemChilds.getLength(); itemChildIndex++) {
					String lineTrade = itemChilds.item(itemChildIndex).getLocalName();
					if ((lineTrade != null) && (lineTrade.equals("SpecifiedLineTradeAgreement")
							|| lineTrade.equals("SpecifiedSupplyChainTradeAgreement"))) {
						NodeList tradeLineChilds = itemChilds.item(itemChildIndex).getChildNodes();
						for (int tradeLineChildIndex = 0; tradeLineChildIndex < tradeLineChilds
								.getLength(); tradeLineChildIndex++) {

							if ((tradeLineChilds.item(tradeLineChildIndex).getLocalName() != null) && tradeLineChilds
									.item(tradeLineChildIndex).getLocalName().equals("AdditionalReferencedDocument")) {
								String IssuerAssignedID = "";
								String TypeCode = "";
								String ReferenceTypeCode = "";

								NodeList refDocChilds = tradeLineChilds.item(tradeLineChildIndex).getChildNodes();
								for (int refDocIndex = 0; refDocIndex < refDocChilds.getLength(); refDocIndex++) {
									String localName = refDocChilds.item(refDocIndex).getLocalName();
									if ((localName != null) && (localName.equals("IssuerAssignedID"))) {
										IssuerAssignedID = refDocChilds.item(refDocIndex).getTextContent();
									}
									if ((localName != null) && (localName.equals("TypeCode"))) {
										TypeCode = refDocChilds.item(refDocIndex).getTextContent();
									}
									if ((localName != null) && (localName.equals("ReferenceTypeCode"))) {
										ReferenceTypeCode = refDocChilds.item(refDocIndex).getTextContent();
									}
								}

								ReferencedDocument rd = new ReferencedDocument(IssuerAssignedID, TypeCode,
										ReferenceTypeCode);
								if (rdocs == null) {
									rdocs = new ArrayList<ReferencedDocument>();
								}
								rdocs.add(rd);

							}

							if ((tradeLineChilds.item(tradeLineChildIndex).getLocalName() != null) && tradeLineChilds
									.item(tradeLineChildIndex).getLocalName().equals("NetPriceProductTradePrice")) {
								NodeList netChilds = tradeLineChilds.item(tradeLineChildIndex).getChildNodes();
								for (int netIndex = 0; netIndex < netChilds.getLength(); netIndex++) {
									if ((netChilds.item(netIndex).getLocalName() != null)
											&& (netChilds.item(netIndex).getLocalName().equals("ChargeAmount"))) {
										price = netChilds.item(netIndex).getTextContent();// ChargeAmount

									}
								}
							}
						}
					}
					if ((lineTrade != null) && (lineTrade.equals("SpecifiedLineTradeDelivery")
							|| lineTrade.equals("SpecifiedSupplyChainTradeDelivery"))) {
						NodeList tradeLineChilds = itemChilds.item(itemChildIndex).getChildNodes();
						for (int tradeLineChildIndex = 0; tradeLineChildIndex < tradeLineChilds
								.getLength(); tradeLineChildIndex++) {
							String tradeName = tradeLineChilds.item(tradeLineChildIndex).getLocalName();
							if ((tradeName != null)
									&& (tradeName.equals("BilledQuantity") || tradeName.equals("RequestedQuantity")
									|| tradeName.equals("DespatchedQuantity"))) {
								// RequestedQuantity is for Order-X, BilledQuantity for FX and ZF
								quantity = tradeLineChilds.item(tradeLineChildIndex).getTextContent();
								unitCode = tradeLineChilds.item(tradeLineChildIndex).getAttributes()
										.getNamedItem("unitCode").getNodeValue();
							}
						}
					}
					if ((lineTrade != null) && (lineTrade.equals("SpecifiedTradeProduct"))) {
						NodeList tradeProductChilds = itemChilds.item(itemChildIndex).getChildNodes();
						for (int tradeProductChildIndex = 0; tradeProductChildIndex < tradeProductChilds
								.getLength(); tradeProductChildIndex++) {
							if ((tradeProductChilds.item(tradeProductChildIndex).getLocalName() != null)
									&& (tradeProductChilds.item(tradeProductChildIndex).getLocalName()
									.equals("Name"))) {
								name = tradeProductChilds.item(tradeProductChildIndex).getTextContent();
							}
							if ((tradeProductChilds.item(tradeProductChildIndex).getLocalName() != null)
									&& (tradeProductChilds.item(tradeProductChildIndex).getLocalName()
									.equals("GlobalID"))) {
								if (tradeProductChilds.item(tradeProductChildIndex).getAttributes()
										.getNamedItem("schemeID") != null) {
									gid = new SchemedID()
											.setScheme(tradeProductChilds.item(tradeProductChildIndex).getAttributes()
													.getNamedItem("schemeID").getNodeValue())
											.setId(tradeProductChilds.item(tradeProductChildIndex).getTextContent());
								}

							}
						}
					}
					if ((lineTrade != null) && (lineTrade.equals("SpecifiedLineTradeSettlement")
							|| lineTrade.equals("SpecifiedSupplyChainTradeSettlement"))) {
						NodeList tradeSettlementChilds = itemChilds.item(itemChildIndex).getChildNodes();
						for (int tradeSettlementChildIndex = 0; tradeSettlementChildIndex < tradeSettlementChilds
								.getLength(); tradeSettlementChildIndex++) {

							String tradeSettlementName = tradeSettlementChilds.item(tradeSettlementChildIndex)
									.getLocalName();
							if (tradeSettlementName != null) {
								if (tradeSettlementName.equals("ApplicableTradeTax")) {
									NodeList taxChilds = tradeSettlementChilds.item(tradeSettlementChildIndex)
											.getChildNodes();
									for (int taxChildIndex = 0; taxChildIndex < taxChilds
											.getLength(); taxChildIndex++) {
										String taxChildName = taxChilds.item(taxChildIndex).getLocalName();
										if ((taxChildName != null) && (taxChildName.equals("RateApplicablePercent")
												|| taxChildName.equals("ApplicablePercent"))) {
											vatPercent = taxChilds.item(taxChildIndex).getTextContent();
										}
									}
								}

								if (tradeSettlementName.equals("SpecifiedTradeSettlementLineMonetarySummation")) {
									NodeList totalChilds = tradeSettlementChilds.item(tradeSettlementChildIndex)
											.getChildNodes();
									for (int totalChildIndex = 0; totalChildIndex < totalChilds
											.getLength(); totalChildIndex++) {
										if ((totalChilds.item(totalChildIndex).getLocalName() != null) && (totalChilds
												.item(totalChildIndex).getLocalName().equals("LineTotalAmount"))) {
											lineTotal = totalChilds.item(totalChildIndex).getTextContent();
										}
									}
								}
							}
						}
					}
				}
				BigDecimal prc = new BigDecimal(price.trim());
				BigDecimal qty = new BigDecimal(quantity.trim());
				if ((recalcPrice) && (!qty.equals(BigDecimal.ZERO))) {
					prc = new BigDecimal(lineTotal.trim()).divide(qty, 4, RoundingMode.HALF_UP);
				}
				Product p = new Product(name, description, unitCode,
						vatPercent == null ? null : new BigDecimal(vatPercent.trim()));
				if (gid != null) {
					p.addGlobalID(gid);
				}
				Item it = new Item(p, prc, qty);
				if (rdocs != null) {
					for (ReferencedDocument rdoc : rdocs) {
						it.addReferencedDocument(rdoc);
					}
				}
				zpp.addItem(it);

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
				String taxPercent = null;
				for (int chargeChildIndex = 0; chargeChildIndex < chargeNodeChilds.getLength(); chargeChildIndex++) {
					String chargeChildName = chargeNodeChilds.item(chargeChildIndex).getLocalName();
					if (chargeChildName != null) {

						if (chargeChildName.equals("ChargeIndicator")) {
							NodeList indicatorChilds = chargeNodeChilds.item(chargeChildIndex).getChildNodes();
							for (int indicatorChildIndex = 0; indicatorChildIndex < indicatorChilds
									.getLength(); indicatorChildIndex++) {
								if ((indicatorChilds.item(indicatorChildIndex).getLocalName() != null)
										&& (indicatorChilds.item(indicatorChildIndex).getLocalName()
										.equals("Indicator"))) {
									isCharge = indicatorChilds.item(indicatorChildIndex).getTextContent()
											.equalsIgnoreCase("true");
								}
							}
						} else if (chargeChildName.equals("ActualAmount")) {
							chargeAmount = chargeNodeChilds.item(chargeChildIndex).getTextContent();
						} else if (chargeChildName.equals("Reason")) {
							reason = chargeNodeChilds.item(chargeChildIndex).getTextContent();
						} else if (chargeChildName.equals("CategoryTradeTax")) {
							NodeList taxChilds = chargeNodeChilds.item(chargeChildIndex).getChildNodes();
							for (int taxChildIndex = 0; taxChildIndex < taxChilds.getLength(); taxChildIndex++) {
								String taxItemName = taxChilds.item(taxChildIndex).getLocalName();
								if ((taxItemName != null) && (taxItemName.equals("RateApplicablePercent")
										|| taxItemName.equals("ApplicablePercent"))) {
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
					if (taxPercent != null) {
						c.setTaxPercent(new BigDecimal(taxPercent));
					}

					zpp.addCharge(c);
				} else {
					Allowance a = new Allowance(new BigDecimal(chargeAmount));
					if (reason != null) {
						a.setReason(reason);
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
	 * This will parse a XML into a invoice object
	 * 
	 * @return the parsed invoice object
	 */
	public Invoice extractInvoice() throws XPathExpressionException, ParseException {
		Invoice i=new Invoice();
		return extractInto(i);


	}

	public void doRecalculateItemPricesFromLineTotals() {
		recalcPrice = true;
	}

	public void doIgnoreCalculationErrors() {
		ignoreCalculationErrors = true;
	}
}
