package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IReferencedDocument;
import org.mustangproject.ZUGFeRD.IZUGFeRDAllowanceCharge;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.LineCalculator;
import org.mustangproject.util.NodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/***
 * describes any invoice line
 */

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Item implements IZUGFeRDExportableItem {
	protected BigDecimal price = BigDecimal.ZERO;
	protected BigDecimal quantity;
	protected BigDecimal tax;
	protected BigDecimal grossPrice;
	protected BigDecimal lineTotalAmount;
	protected BigDecimal basisQuantity = BigDecimal.ONE;
	protected Date detailedDeliveryPeriodFrom = null;
	protected Date detailedDeliveryPeriodTo = null;
	protected String id;
	protected String buyerOrderReferencedDocumentLineID = null;
	protected String buyerOrderReferencedDocumentID = null;
	protected Product product;
	protected ArrayList<String> notes = null;
	protected ArrayList<ReferencedDocument> referencedDocuments = null;
	protected ArrayList<ReferencedDocument> additionalReference = null;
	protected ArrayList<IZUGFeRDAllowanceCharge> Allowances = new ArrayList<>();
	protected ArrayList<IZUGFeRDAllowanceCharge> Charges = new ArrayList<>();
	protected List<IncludedNote> includedNotes = null;
	protected String accountingReference;
	//protected HashMap<String, String> attributes = new HashMap<>();

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
		NodeMap itemMap = new NodeMap(itemChilds);

		itemMap.getAsNodeMap("Item").ifPresent(icnm -> {
			// ubl
			//we need: name description unitcode
			//and we additionally have vat%

			setProduct(new Product(itemMap.getNode("Item").get()));
			icnm.getAsString("Name").ifPresent(product::setName);
			icnm.getAsString("Description").ifPresent(product::setDescription);

			icnm.getAsNodeMap("SellersItemIdentification")
				.flatMap(SellersItemIdentification -> SellersItemIdentification.getAsString("ID"))
				.ifPresent(product::setSellerAssignedID);

			icnm.getAsNodeMap("BuyersItemIdentification")
				.flatMap(BuyersItemIdentification -> BuyersItemIdentification.getAsString("ID"))
				.ifPresent(product::setBuyerAssignedID);

			icnm.getAsNodeMap("ClassifiedTaxCategory")
				.flatMap(m -> m.getAsBigDecimal("Percent"))
				.ifPresent(product::setVATPercent);
		});
		itemMap.getAsNodeMap("AssociatedDocumentLineDocument")
			.flatMap(icnm -> icnm.getAsString("LineID"))
			.ifPresent(this::setId);

		itemMap.getAsNodeMap("Price").ifPresent(icnm -> {
			// ubl
			// PriceAmount with currencyID and  BaseQuantity with unitCode
			icnm.getAsBigDecimal("PriceAmount").ifPresent(this::setPrice);
			icnm.getAsBigDecimal("BaseQuantity").ifPresent(this::setBasisQuantity);
		});

		itemMap.getNode("InvoicedQuantity").ifPresent(icn -> {
			// ubl
			setQuantity(new BigDecimal(icn.getTextContent().trim()));
			product.setUnit(icn.getAttributes().getNamedItem("unitCode").getNodeValue());
		});

		itemMap.getAllNodes("DocumentReference").map(ReferencedDocument::fromNode)
			.forEach(this::addAdditionalReference);

		// ubl

		itemMap.getAsNodeMap("OrderLineReference")
			// ubl
			.flatMap(bordNodes -> bordNodes.getAsString("LineID"))
			.ifPresent(this::addReferencedLineID);

		itemMap.getAsString("ID")
			.ifPresent(this::setId);

		itemMap.getAsString("Note")
			.ifPresent(this::addNote);

		if (product==null) { // CII
			if (itemMap.getNode("SpecifiedTradeProduct").isPresent()) {
				product = new Product(itemMap.getNode("SpecifiedTradeProduct").get());
			} else {
				product = new Product();
			}
		}

		itemMap.getAsNodeMap("SpecifiedLineTradeAgreement", "SpecifiedSupplyChainTradeAgreement").ifPresent(icnm -> {
			icnm.getAsNodeMap("BuyerOrderReferencedDocument")
				.flatMap(bordNodes -> bordNodes.getAsString("LineID"))
				.ifPresent(this::addReferencedLineID);

			icnm.getAsNodeMap("BuyerOrderReferencedDocument")
				.flatMap(bordNodes -> bordNodes.getAsString("IssuerAssignedID"))
				.ifPresent(this::addBuyerOrderReferencedDocumentID);

			icnm.getAsNodeMap("NetPriceProductTradePrice").ifPresent(npptpNodes -> {
				npptpNodes.getAsBigDecimal("ChargeAmount").ifPresent(this::setPrice);
				npptpNodes.getAsBigDecimal("BasisQuantity").ifPresent(this::setBasisQuantity);
			});
			icnm.getAsNodeMap("GrossPriceProductTradePrice").ifPresent(gpptpNodes -> {
				gpptpNodes.getAsNodeMap("AppliedTradeAllowanceCharge").ifPresent(gpptpAtacNodes -> {

						/** mustang attributes differences between net and gross price to the product */
						String chargeIndicator = gpptpAtacNodes.getAsStringOrNull("ChargeIndicator");
						if ((chargeIndicator != null)&&(gpptpAtacNodes.getAsBigDecimal("ActualAmount").isPresent())) {
							BigDecimal actual = gpptpAtacNodes.getAsBigDecimal("ActualAmount").get();
							if (chargeIndicator.equals("true")) {
								product.addCharge(new Charge(actual));
								setPrice(getPrice().subtract(actual)); // the gross price affects the net price, which is read,
								// so if we do not ignore charges|allowances we have to re-compensate the net price
							} else {
								product.addAllowance(new Allowance(actual));
								setPrice(getPrice().add(actual));
							}

						}
					});
				});
			icnm.getAllNodes("AdditionalReferencedDocument").map(ReferencedDocument::fromNode).
				forEach(this::addReferencedDocument);
		});

		// RequestedQuantity is for Order-X, BilledQuantity for FX and ZF
		itemMap.getAsNodeMap("SpecifiedLineTradeDelivery", "SpecifiedSupplyChainTradeDelivery")
			.flatMap(icnm -> icnm.getNode("BilledQuantity", "RequestedQuantity", "DespatchedQuantity"))
			.ifPresent(bq -> {
				setQuantity(new BigDecimal(bq.getTextContent().trim()));
				if (bq.hasAttributes()) {
					Node unitAttr = bq.getAttributes().getNamedItem("unitCode");
					if (unitAttr != null) {
						product.setUnit(unitAttr.getNodeValue());
					}
				}
			});

		itemMap.getAsNodeMap("SpecifiedLineTradeSettlement", "SpecifiedSupplyChainTradeSettlement").ifPresent(icnm -> {
			icnm.getAsNodeMap("ApplicableTradeTax")
				.flatMap(cnm -> cnm.getAsBigDecimal("RateApplicablePercent", "ApplicablePercent"))
				.ifPresent(product::setVATPercent);
			icnm.getAsNodeMap("ApplicableTradeTax")
				.flatMap(cnm -> cnm.getAsString("ExemptionReason"))
				.ifPresent(product::setTaxExemptionReason);

			icnm.getAllNodes("SpecifiedTradeAllowanceCharge").map(NodeMap::new).forEach(stac -> {
				stac.getAsNodeMap("ChargeIndicator").ifPresent(ci -> {
					String isChargeString = ci.getAsString("Indicator").get();
					String percentString = stac.getAsStringOrNull("CalculationPercent");
					String amountString = stac.getAsStringOrNull("ActualAmount");
					String basisAmountString = stac.getAsStringOrNull("BasisAmount");
					String reason = stac.getAsStringOrNull("Reason");
					Charge izac = new Charge();
					if (isChargeString.equalsIgnoreCase("false")) {
						izac = new Allowance();
					} else {
						izac = new Charge();
					}
					if (amountString != null) {
						izac.setTotalAmount(new BigDecimal(amountString));
					}
					if (basisAmountString != null) {
						izac.setBasisAmount(new BigDecimal(basisAmountString));
					}
					if (percentString != null) {
						izac.setPercent(new BigDecimal(percentString));
					}
					if (reason != null) {
						izac.setReason(reason);
					}

					if (isChargeString.equalsIgnoreCase("false")) {
						addAllowance(izac);
					} else {
						addCharge(izac);
					}
				});

			});
			if (recalcPrice && !BigDecimal.ZERO.equals(quantity)) {
				icnm.getAsNodeMap("SpecifiedTradeSettlementLineMonetarySummation")
					.flatMap(cnm -> cnm.getAsBigDecimal("LineTotalAmount"))
					.ifPresent(lineTotal -> setPrice(lineTotal.divide(quantity, 4, RoundingMode.HALF_UP)));
			}

			icnm.getAllNodes("AdditionalReferencedDocument").map(ReferencedDocument::fromNode).forEach(this::addAdditionalReference);

			icnm.getAsString("ReceivableSpecifiedTradeAccountingAccount").ifPresent(s -> this.accountingReference = s.trim());

			icnm.getAsNodeMap("BillingSpecifiedPeriod").ifPresent(periodNode -> {
				Date start = periodNode.getAsNodeMap("StartDateTime").flatMap(dateTimeNode -> dateTimeNode.getNode("DateTimeString")).map(XMLTools::tryDate).orElse(null);
				Date end = periodNode.getAsNodeMap("EndDateTime").flatMap(dateTimeNode -> dateTimeNode.getNode("DateTimeString")).map(XMLTools::tryDate).orElse(null);
				setDetailedDeliveryPeriod(start, end);
			});
		});

		itemMap.getAllNodes("AllowanceCharge").map(NodeMap::new).forEach(stac -> { //CII

			String isChargeString = stac.getAsString("ChargeIndicator").get();
			String percentString = stac.getAsStringOrNull("MultiplierFactorNumeric");
			String amountString = stac.getAsStringOrNull("Amount");
			String reason = stac.getAsStringOrNull("AllowanceChargeReason");
			Charge izac = new Charge();
			if (isChargeString.equalsIgnoreCase("false")) {
				izac = new Allowance();
			} else {
				izac = new Charge();
			}
			if (amountString != null) {
				izac.setTotalAmount(new BigDecimal(amountString));
			}
			if (percentString != null) {
				izac.setPercent(new BigDecimal(percentString));
			}
			if (reason != null) {
				izac.setReason(reason);
			}

			if (isChargeString.equalsIgnoreCase("false")) {
				addAllowance(izac);
			} else {
				addCharge(izac);
			}

		});

		itemMap.getAsNodeMap("AssociatedDocumentLineDocument").ifPresent(adld -> {
			List<IncludedNote> includedNotes = new ArrayList<>();
			adld.getAllNodes("IncludedNote").forEach(item -> {
				String subjectCode = "";
				String content = null;
				NodeList includedNodeChilds = item.getChildNodes();
				for (int issueDateChildIndex = 0; issueDateChildIndex < includedNodeChilds.getLength(); issueDateChildIndex++) {
					if ((includedNodeChilds.item(issueDateChildIndex).getLocalName() != null)
						&& (includedNodeChilds.item(issueDateChildIndex).getLocalName().equals("Content"))) {
						content = XMLTools.trimOrNull(includedNodeChilds.item(issueDateChildIndex));
					}
					if ((includedNodeChilds.item(issueDateChildIndex).getLocalName() != null)
						&& (includedNodeChilds.item(issueDateChildIndex).getLocalName().equals("SubjectCode"))) {
						subjectCode = XMLTools.trimOrNull(includedNodeChilds.item(issueDateChildIndex));
					}
				}
				boolean foundCode = false;
				for (SubjectCode code : SubjectCode.values()) {
					if (code.toString().equals(subjectCode)) {
						includedNotes.add(new IncludedNote(content, code));
						foundCode = true;
						break;
					}
				}
				if (!foundCode) {
					includedNotes.add(new IncludedNote(content, null));
				}
			});
			addNotes(includedNotes);
		});
	}

	public Item addBuyerOrderReferencedDocumentLineID(String s) {
		buyerOrderReferencedDocumentLineID = s;
		return this;
	}

	@Deprecated(since = "2.14.0")
	public Item addReferencedLineID(String s) {
		return addBuyerOrderReferencedDocumentLineID(s);
	}

	@Override
	public String getBuyerOrderReferencedDocumentID() {
		return buyerOrderReferencedDocumentID;
	}

	public Item addBuyerOrderReferencedDocumentID(String s) {
		buyerOrderReferencedDocumentID = s;
		return this;
	}

	@JsonIgnore
	@Override
	public IZUGFeRDAllowanceCharge[] getAllowances() { // in JSON is already returned as itemAllowances (and only read from there)
		IZUGFeRDAllowanceCharge[] izac = new IZUGFeRDAllowanceCharge[Allowances.size()];
		return Allowances.toArray(izac);
	}

	@JsonIgnore
	@Override
	public IZUGFeRDAllowanceCharge[] getCharges() { // in JSON is already returned as itemAllowances (and only read from there)
		IZUGFeRDAllowanceCharge[] izac = new IZUGFeRDAllowanceCharge[Charges.size()];
		return Charges.toArray(izac);
	}

	/***
	 * BT 132 (issue https://github.com/ZUGFeRD/mustangproject/issues/247)
	 * @return the line ID of the order (BT132)
	 */
	@Override
	public String getBuyerOrderReferencedDocumentLineID() {
		return buyerOrderReferencedDocumentLineID;
	}

	public BigDecimal getLineTotalAmount() {
		return lineTotalAmount;
	}

	public Item setNotesWithSubjectCode(List<IncludedNote> theList) {
		includedNotes = theList;
		return this;
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

	/***
	 * jackson convenience method
	 */
	public void setItemAllowances(ArrayList<Allowance> theAllowances) {
		if (theAllowances != null) {
			Allowances.clear();
			Allowances.addAll(theAllowances);
		}
	}

	/***
	 * jackson convenience method
	 */
	public void setItemCharges(ArrayList<Charge> theCharges) {
		if (theCharges != null) {
			Charges.clear();
			Charges.addAll(theCharges);
		}
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
	 * @see Charge
	 * @param izac a relative or absolute charge
	 * @return fluent setter
	 */
	public Item addCharge(IZUGFeRDAllowanceCharge izac) {
		Charges.add(izac);
		return this;
	}

	/***
	 * Adds a item level reduction the price (will be multiplied by quantity)
	 * @see Allowance
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

		addNote(IncludedNote.unspecifiedNote(text));


		return this;
	}

	/***
	 * adds categorized item level freetext fields (includednote)
	 * @param theNote IncludedNote to add
	 * @return fluent setter
	 */
	public Item addNote(IncludedNote theNote) {

		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.add(theNote);


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
	 * adds item level references along with their typecodes and issuerassignedIDs (contract ID, cost centre, ...)
	 * @param doc the ReferencedDocument to add
	 * @return fluent setter
	 */
	public Item addAdditionalReference(ReferencedDocument doc) {
		if (additionalReference == null) {
			additionalReference = new ArrayList<>();
		}
		additionalReference.add(doc);
		return this;
	}

	@Override
	public IReferencedDocument[] getAdditionalReferences() {
		if (additionalReference == null) {
			return null;
		}
		return additionalReference.toArray(new IReferencedDocument[0]);
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
	@Override
	public Date getDetailedDeliveryPeriodFrom() {
		return detailedDeliveryPeriodFrom;
	}

	/***
	 * specifies the item level delivery period (there is also one on document level),
	 * this will be included in a BillingSpecifiedPeriod element
	 * @return the end of the delivery period
	 */
	@Override
	public Date getDetailedDeliveryPeriodTo() {
		return detailedDeliveryPeriodTo;
	}

	public IZUGFeRDExportableItem addNotes(Collection<IncludedNote> notes) {
		if (notes == null) {
			return this;
		}
		if (includedNotes == null) {
			includedNotes = new ArrayList<>();
		}
		includedNotes.addAll(notes);
		return this;
	}

	@Override
	public List<IncludedNote> getNotesWithSubjectCode() {
		return includedNotes;
	}

	@Override
	public String getAccountingReference() {
		return accountingReference;
	}
}
