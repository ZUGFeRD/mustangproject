package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.mustangproject.ZUGFeRD.IReferencedDocument;
import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Date;

/***
 * describes any invoice line
 */

@JsonIgnoreProperties(ignoreUnknown = true)
public class Item implements IZUGFeRDExportableItem {
	protected BigDecimal price, quantity, tax, grossPrice, lineTotalAmount;
	protected BigDecimal basisQuantity = BigDecimal.ONE;
	protected Date detailedDeliveryPeriodFrom = null, detailedDeliveryPeriodTo = null;
	protected String id;
	protected String referencedLineID = null;
	protected Product product;
	protected ArrayList<String> notes = null;
	protected ArrayList<ReferencedDocument> referencedDocuments = null;
	protected ArrayList<IZUGFeRDAllowanceCharge> Allowances = new ArrayList<>(),
		Charges = new ArrayList<>();

	/***
	 * default constructor
	 * @param product contains the products name, tax rate, and unit
	 * @param price the base price of one item the product
	 * @param quantity the number, dimensions or the weight of the delivered product or good in this context
	 */
	public Item(Product product, BigDecimal price, BigDecimal quantity) {
		this.price = price;
		this.quantity = quantity;
		this.product = product;
	}


	/***
	 * empty constructor
	 * do not use, but might be used e.g. by jackson
	 * */
	public Item() {
	}

	public Item(NodeList itemChilds, boolean recalcPrice) {
		String price = "0";
		String basisQuantity = "1";
		String name = "";
		String sellerAssignedID = null;
		String description = "";
		SchemedID gid = null;
		String quantity = "0";
		String vatPercent = null;
		String lineTotal = "0";
		String unitCode = "0";
		String referencedLineID = null;

		ArrayList<ReferencedDocument> rdocs = null;

		// nodes.item(i).getTextContent())) {

		for (int itemChildIndex = 0; itemChildIndex < itemChilds.getLength(); itemChildIndex++) {
			String lineTrade = itemChilds.item(itemChildIndex).getLocalName();
			if ((lineTrade != null) && (lineTrade.equals("Item"))) {
				// ubl
				//we need: name description unitcode
				//and we additionally have vat%
				NodeList UBLitemChilds = itemChilds.item(itemChildIndex).getChildNodes();
				for (Node currentUBLItemChildNode : XMLTools.asList(UBLitemChilds)) {

					if ((currentUBLItemChildNode.getLocalName() != null) && (currentUBLItemChildNode.getLocalName().equals("Name"))) {
						name = currentUBLItemChildNode.getTextContent();
					}
					if ((currentUBLItemChildNode.getLocalName() != null) && (currentUBLItemChildNode.getLocalName().equals("ClassifiedTaxCategory"))) {
						for (Node currentUBLTaxChildNode : XMLTools.asList(currentUBLItemChildNode.getChildNodes())) {
							if ((currentUBLTaxChildNode.getLocalName() != null) && (currentUBLTaxChildNode.getLocalName().equals("Percent"))) {
								vatPercent = currentUBLTaxChildNode.getTextContent();
							}
						}
					}
				}
			}
			if ((lineTrade != null) && (lineTrade.equals("Price"))) {
				// ubl
				// PriceAmount with currencyID and  BaseQuantity with unitCode
				NodeList UBLpriceChilds = itemChilds.item(itemChildIndex).getChildNodes();
				for (Node currentUBLPriceChildNode : XMLTools.asList(UBLpriceChilds)) {

					if ((currentUBLPriceChildNode.getLocalName() != null) && (currentUBLPriceChildNode.getLocalName().equals("PriceAmount"))) {
						price = currentUBLPriceChildNode.getTextContent();
					}
					if ((currentUBLPriceChildNode.getLocalName() != null) && (currentUBLPriceChildNode.getLocalName().equals("BaseQuantity"))) {
						basisQuantity = currentUBLPriceChildNode.getTextContent();
					}
				}

			}
			if ((lineTrade != null) && (lineTrade.equals("InvoicedQuantity"))) {
				// ubl
				quantity = itemChilds.item(itemChildIndex).getTextContent();
				unitCode = itemChilds.item(itemChildIndex).getAttributes()
					.getNamedItem("unitCode").getNodeValue();
			}
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
							rdocs = new ArrayList<>();
						}
						rdocs.add(rd);

					}

					if ((tradeLineChilds.item(tradeLineChildIndex).getLocalName() != null) && tradeLineChilds.item(tradeLineChildIndex).getLocalName().equals("BuyerOrderReferencedDocument")) {
						NodeList docChilds = tradeLineChilds.item(tradeLineChildIndex).getChildNodes();
						for (int docIndex = 0; docIndex < docChilds.getLength(); docIndex++) {
							String localName = docChilds.item(docIndex).getLocalName();
							if ((localName != null) && (localName.equals("LineID"))) {
								referencedLineID = docChilds.item(docIndex).getTextContent();
							}
						}
					}

					if ((tradeLineChilds.item(tradeLineChildIndex).getLocalName() != null) && tradeLineChilds
						.item(tradeLineChildIndex).getLocalName().equals("NetPriceProductTradePrice")) {
						NodeList netChilds = tradeLineChilds.item(tradeLineChildIndex).getChildNodes();
						for (int netIndex = 0; netIndex < netChilds.getLength(); netIndex++) {
							if ((netChilds.item(netIndex).getLocalName() != null)
								&& (netChilds.item(netIndex).getLocalName().equals("ChargeAmount"))) {
								price = netChilds.item(netIndex).getTextContent();// ChargeAmount

							}
							if ((netChilds.item(netIndex).getLocalName() != null)
								&& ((netChilds.item(netIndex).getLocalName().equals("BasisQuantity")) || (netChilds.item(netIndex).getLocalName().equals("InvoicedQuantity")))) {
								basisQuantity = netChilds.item(netIndex).getTextContent();// ChargeAmount

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
						.equals("SellerAssignedID"))) {
						sellerAssignedID = tradeProductChilds.item(tradeProductChildIndex).getTextContent();
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
		if (sellerAssignedID != null) {
			p.setSellerAssignedID(sellerAssignedID);
		}
		setProduct(p);
		setPrice(prc);
		setQuantity(qty);
		setBasisQuantity(new BigDecimal(basisQuantity));
		if (rdocs != null) {
			for (ReferencedDocument rdoc : rdocs) {
				addReferencedDocument(rdoc);
			}
		}
		addReferencedLineID( referencedLineID );
	}


	public Item addReferencedLineID(String s) {
		referencedLineID = s;
		return this;
	}

	/***
	 * BT 132 (issue https://github.com/ZUGFeRD/mustangproject/issues/247)
	 * @return the line ID of the order (BT132)
	 */
	@Override
	public String getBuyerOrderReferencedDocumentLineID() {
		return referencedLineID;
	}

	public BigDecimal getLineTotalAmount() {
		return lineTotalAmount;
	}

	/**
	 * should only be set by calculator classes or maybe when reading from XML
	 *
	 * @param lineTotalAmount price*quantity of this line
	 * @return fluent setter
	 */
	public Item setLineTotalAmount(BigDecimal lineTotalAmount) {
		this.lineTotalAmount = lineTotalAmount;
		return this;
	}

	public BigDecimal getGrossPrice() {
		return grossPrice;
	}


	/***
	 * the list price without VAT (sic!), refer to EN16931-1 for definition
	 * @param grossPrice the list price without VAT
	 * @return fluent setter
	 */
	public Item setGrossPrice(BigDecimal grossPrice) {
		this.grossPrice = grossPrice;
		return this;
	}


	public BigDecimal getTax() {
		return tax;
	}

	public Item setTax(BigDecimal tax) {
		this.tax = tax;
		return this;
	}

	public Item setId(String id) {
		this.id = id;
		return this;
	}

	public String getId() {
		return id;
	}

	@Override
	public BigDecimal getPrice() {
		return price;
	}

	public Item setPrice(BigDecimal price) {
		this.price = price;
		return this;
	}


	@Override
	public BigDecimal getBasisQuantity() {
		return basisQuantity;
	}

	public Item setBasisQuantity(BigDecimal basis) {
		this.basisQuantity = basis;
		return this;
	}


	@Override
	public BigDecimal getQuantity() {
		return quantity;
	}

	public Item setQuantity(BigDecimal quantity) {
		this.quantity = quantity;
		return this;
	}

	@Override
	public Product getProduct() {
		return product;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemAllowances() {
		if (Allowances.isEmpty()) {
			return null;
		} else
			return Allowances.toArray(new IZUGFeRDAllowanceCharge[0]);
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemCharges() {
		if (Charges.isEmpty()) {
			return null;
		} else
			return Charges.toArray(new IZUGFeRDAllowanceCharge[0]);
	}


	@Override
	public String[] getNotes() {
		if (notes == null) {
			return null;
		}
		return notes.toArray(new String[0]);
	}

	public Item setProduct(Product product) {
		this.product = product;
		return this;
	}


	/***
	 * Adds a item level addition to the price (will be multiplied by quantity)
	 * @see org.mustangproject.Charge
	 * @param izac a relative or absolute charge
	 * @return fluent setter
	 */
	public Item addCharge(IZUGFeRDAllowanceCharge izac) {
		Charges.add(izac);
		return this;
	}

	/***
	 * Adds a item level reduction the price (will be multiplied by quantity)
	 * @see org.mustangproject.Allowance
	 * @param izac a relative or absolute allowance
	 * @return fluent setter
	 */
	public Item addAllowance(IZUGFeRDAllowanceCharge izac) {
		Allowances.add(izac);
		return this;
	}

	/***
	 * adds item level freetext fields (includednote)
	 * @param text UTF8 plain text
	 * @return fluent setter
	 */
	public Item addNote(String text) {
		if (notes == null) {
			notes = new ArrayList<>();
		}
		notes.add(text);
		return this;
	}

	/***
	 * adds item level Referenced documents along with their typecodes and issuerassignedIDs
	 * @param doc the ReferencedDocument to add
	 * @return fluent setter
	 */
	public Item addReferencedDocument(ReferencedDocument doc) {
		if (referencedDocuments == null) {
			referencedDocuments = new ArrayList<>();
		}
		referencedDocuments.add(doc);
		return this;
	}

	@Override
	public IReferencedDocument[] getReferencedDocuments() {
		if (referencedDocuments == null) {
			return null;
		}
		return referencedDocuments.toArray(new IReferencedDocument[0]);
	}

	/***
	 * specify a item level delivery period
	 * (apart from the document level delivery period, and the document level
	 * delivery day, which is probably anyway required)
	 *
	 * @param from start date
	 * @param to end date
	 * @return fluent setter
	 */
	public Item setDetailedDeliveryPeriod(Date from, Date to) {
		detailedDeliveryPeriodFrom = from;
		detailedDeliveryPeriodTo = to;
		return this;
	}

	/***
	 * specifies the item level delivery period (there is also one on document level),
	 * this will be included in a BillingSpecifiedPeriod element
	 * @return the beginning of the delivery period
	 */
	public Date getDetailedDeliveryPeriodFrom() {
		return detailedDeliveryPeriodFrom;
	}

	/***
	 * specifies the item level delivery period (there is also one on document level),
	 * this will be included in a BillingSpecifiedPeriod element
	 * @return the end of the delivery period
	 */
	public Date getDetailedDeliveryPeriodTo() {
		return detailedDeliveryPeriodTo;
	}

}
