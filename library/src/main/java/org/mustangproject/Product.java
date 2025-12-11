package org.mustangproject;

import com.fasterxml.jackson.annotation.*;
import org.mustangproject.ZUGFeRD.IDesignatedProductClassification;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;
import org.mustangproject.util.NodeMap;
import org.w3c.dom.Node;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/***
 * describes a product, good or service used in an invoice item line
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)

public class Product implements IZUGFeRDExportableProduct {
	protected String unit, name, sellerAssignedID, buyerAssignedID;
	protected String description = "";
	protected String taxExemptionReason = null;
	protected String taxExemptionReasonCode = null;
	protected String taxCategoryCode = null;
	protected BigDecimal VATPercent;
	protected boolean isReverseCharge = false;
	protected boolean isIntraCommunitySupply = false;
	protected SchemedID globalId = null;
	protected String countryOfOrigin = null;
	protected ArrayList<Charge> charges=new ArrayList<>();
	protected ArrayList<Allowance> allowances=new ArrayList<>();
	protected HashMap<String, String> attributes = new HashMap<>();

	protected List<IDesignatedProductClassification> classifications = new ArrayList<>();

	/***
	 * default constructor
	 * @param name product short name
	 * @param description product long name
	 * @param unit a two/three letter UN/ECE rec 20 unit code, e.g. "C62" for piece
	 * @param VATPercent product vat rate
	 */
	public Product(String name, String description, String unit, BigDecimal VATPercent) {
		this.unit = unit;
		this.name = name;
		this.description = description;
		this.VATPercent = VATPercent;
	}

	public Product(Node node) {
		NodeMap nodeMap = new NodeMap(node);

		nodeMap.getNode("GlobalID").ifPresent(idNode -> {
			if (idNode.hasAttributes()
				&& idNode.getAttributes().getNamedItem("schemeID") != null) {
				globalId = new SchemedID()
					.setScheme(idNode.getAttributes().getNamedItem("schemeID").getNodeValue())
					.setId(idNode.getTextContent());
			}
		});


		nodeMap.getAsString("SellerAssignedID").ifPresent(this::setSellerAssignedID);
		nodeMap.getAsString("BuyerAssignedID").ifPresent(this::setBuyerAssignedID);
		nodeMap.getAsString("Name").ifPresent(this::setName);
		nodeMap.getAsString("Description").ifPresent(this::setDescription);


		nodeMap.getAllNodes("ApplicableProductCharacteristic").map(NodeMap::new).forEach(apcNodes -> { // ApplicableProductCharacteristic is 0 .. unbounded
			String key = apcNodes.getAsStringOrNull("Description");
			String value = apcNodes.getAsStringOrNull("Value");
			if (key != null && value != null) {
				if (attributes == null) {
					attributes = new HashMap<>();
				}
				attributes.put(key, value);
			}
		});

		//UBL
		nodeMap.getAsNodeMap("AdditionalItemProperty").ifPresent(aipNodes -> {
			String name = aipNodes.getAsStringOrNull("Name");
			String val = aipNodes.getAsStringOrNull("Value");
			if (name != null && val != null) {
				if (attributes == null) {
					attributes = new HashMap<>();
				}
				attributes.put(name, val);
			}
		});

		nodeMap.getAsNodeMap("CommodityClassification").ifPresent(dpcNodes -> {
			String className = dpcNodes.getAsStringOrNull("ClassName");
			dpcNodes.getNode("ItemClassificationCode").map(ClassCode::fromNode).ifPresent(classCode ->
				classifications.add(new DesignatedProductClassification(classCode, className)));
		});

		//UBL
		nodeMap.getAsNodeMap("DesignatedProductClassification").ifPresent(dpcNodes -> {
			String className = dpcNodes.getAsStringOrNull("ClassName");
			dpcNodes.getNode("ClassCode").map(ClassCode::fromNode).ifPresent(classCode ->
				classifications.add(new DesignatedProductClassification(classCode, className)));
		});

		nodeMap.getAsNodeMap("OriginTradeCountry")
			   .flatMap(nodes -> nodes.getNode("ID"))
			   .map(Node::getTextContent)
			   .ifPresent(this::setCountryOfOrigin);
	}

	/***
	 * empty constructor
	 * just for jackson etc
	 */
	public Product() {

	}

	@Override
	public String getGlobalID() {
		if (globalId == null) {
			return null;
		} else {
			return globalId.getID();
		}
	}

	@Override
	public String getGlobalIDScheme() {
		if (globalId == null) {
			return null;
		} else {
			return globalId.getScheme();
		}
	}

	public Product addGlobalID(SchemedID schemedID) {
		globalId = schemedID;
		return this;
	}


	/***
	 *
	 * @return e.g. intra-commnunity supply or small business
	 */
	@Override
	public String getTaxExemptionReason() {
		return taxExemptionReason;
	}

	/***
	 *
	 * @param taxExemptionReasonText String e.g. Kleinunternehmer gemäß §19 UStG https://github.com/ZUGFeRD/mustangproject/issues/463
	 * @return fluent setter
	 */
	public Product setTaxExemptionReason(String taxExemptionReasonText) {
		this.taxExemptionReason = taxExemptionReasonText;
		return this;
	}

	@Override
	public String getTaxExemptionReasonCode() {
		return taxExemptionReasonCode;
	}

	/***
	 *
	 * @param taxExemptionReasonCode, https://docs.peppol.eu/poacc/billing/3.0/codelist/vatex/
	 * @return fluent setter
	 */
	public Product setTaxExemptionReasonCode(String taxExemptionReasonCode) {
		this.taxExemptionReasonCode = taxExemptionReasonCode;
		return this;
	}

	/***
	 *
	 * @return e.g. S (normal tax), Z=zero rated,  E (e.g. small business) or K (intrra community supply)
	 */
	@Override
	public String getTaxCategoryCode() {
		if (taxCategoryCode == null) {
			return IZUGFeRDExportableProduct.super.getTaxCategoryCode();
		}
		return taxCategoryCode;
	}

	/***
	 *
	 * @param code e.g. S (normal tax), Z=zero rated,  E (e.g. small business) or K (intrra community supply) see also https://github.com/ZUGFeRD/mustangproject/issues/463
	 * @return fluent setter
	 */
	public Product setTaxCategoryCode(String code) {
		taxCategoryCode = code;
		return this;
	}


	@Override
	public String getSellerAssignedID() {
		return sellerAssignedID;
	}

	/***
	 * how the seller identifies this type of product
	 * @param sellerAssignedID a unique String
	 * @return fluent setter
	 */
	public Product setSellerAssignedID(String sellerAssignedID) {
		this.sellerAssignedID = sellerAssignedID;
		return this;
	}

	@Override
	public String getBuyerAssignedID() {
		return buyerAssignedID;
	}

	/***
	 * if the buyer provided an ID how he refers to this product
	 * @param buyerAssignedID a string the buyer provided
	 * @return fluent setter
	 */
	public Product setBuyerAssignedID(String buyerAssignedID) {
		this.buyerAssignedID = buyerAssignedID;
		return this;
	}

	@JsonIgnore
	@Override
	public boolean isReverseCharge() {
		return isReverseCharge;
	}


	@JsonIgnore
	@Override
	public boolean isIntraCommunitySupply() {
		return isIntraCommunitySupply;
	}

	/***
	 * sets reverse charge(=delivery to outside EU)
	 * @return fluent setter
	 */
	public Product setReverseCharge() {
		isReverseCharge = true;
		if ((getTaxExemptionReason()==null)||(getTaxExemptionReason().isEmpty())) {
			setTaxExemptionReason("Reverse charge");
		}
		setVATPercent(BigDecimal.ZERO);
		return this;
	}


	/***
	 * sets intra community supply(=delivery outside the country inside the EU)
	 * @return fluent setter
	 */
	public Product setIntraCommunitySupply() {
		isIntraCommunitySupply = true;
		setVATPercent(BigDecimal.ZERO);
		setTaxExemptionReason("Intra-community supply");
		setTaxCategoryCode("K");
		return this;
	}

	@Override
	public String getUnit() {
		return unit;
	}

	/***
	 * sets a UN/ECE rec 20 or 21 code which unit the product ships in, e.g. C62=piece
	 * @param unit 2-3 letter UN/ECE rec 20 or 21
	 * @return fluent setter
	 */
	public Product setUnit(String unit) {
		this.unit = unit;
		return this;
	}

	@Override
	public String getName() {
		return name;
	}

	/**
	 * name of the product
	 *
	 * @param name short name
	 * @return fluent setter
	 */
	public Product setName(String name) {
		this.name = name;
		return this;
	}

	@Override
	public String getDescription() {
		return description;
	}

	/**
	 * description of the product (required)
	 *
	 * @param description long name
	 * @return fluent setter
	 */
	public Product setDescription(String description) {
		this.description = description;
		return this;
	}

	@Override
	public BigDecimal getVATPercent() {
		return VATPercent;
	}

	/****
	 * VAT rate of the product
	 * @param VATPercent vat rate of the product
	 * @return fluent setter
	 */
	public Product setVATPercent(BigDecimal VATPercent) {
		if (VATPercent == null) {
			this.VATPercent = BigDecimal.ZERO;
		} else {
			this.VATPercent = VATPercent;
		}
		return this;
	}

	@Override
	public String getCountryOfOrigin() {
		return this.countryOfOrigin;
	}

	public Product setCountryOfOrigin(String countryOfOrigin) {
		this.countryOfOrigin = countryOfOrigin;
		return this;
	}

	@Override
	public HashMap<String, String> getAttributes() {
		if (attributes.isEmpty()) {
			return null;
		} else {
			return this.attributes;
		}
	}

	public Product setAttributes(Map<String, String> attributes) {
		this.attributes.clear();
		if (attributes != null) {
			this.attributes.putAll(attributes);
		}
		return this;
	}

	public Product addAttribute(String name, String value) {
		this.attributes.put(name, value);
		return this;
	}

	@Override
	public IDesignatedProductClassification[] getClassifications() {
		if (classifications.isEmpty()) {
			return null;
		} else {
			return classifications.toArray(new IDesignatedProductClassification[0]);
		}
	}

	/**
	 * Replace the current set of {@link IDesignatedProductClassification}s with a new set
	 *
	 * @param classifications the new set of classifications
	 * @return the modified object
	 */
	public Product setClassifications(IDesignatedProductClassification[] classifications) {
		this.classifications.clear();
		if (classifications != null) {
			this.classifications.addAll(Arrays.asList(classifications));
		}
		return this;
	}


	/**
	 * Provide Jackson a hint as to use DesignatedProductClassification for the
	 * IDesignatedProductClassification product classifications
	 *
	 * @param classifications the new set of classifications
	 * @return fluent setter
	 */
	@JsonSetter("classifications")
	public Product setClassificationsClass(DesignatedProductClassification[] classifications) {
		this.classifications.clear();
		if (classifications != null) {
			this.classifications.addAll(Arrays.asList(classifications));
		}
		return this;
	}

	/**
	 * Add a {@link IDesignatedProductClassification} classification
	 *
	 * @param classification the classification
	 * @return the modified object
	 */
	public Product addClassification(IDesignatedProductClassification classification) {
		this.classifications.add(classification);
		return this;
	}

	public Product addCharge(Charge e) {
		charges.add(e);
		return this;
	}

	public Product addAllowance(Allowance a) {
		allowances.add(a);
		return this;
	}


	/***
	 * Jackson courtesy function, please use addCharge if you have the choice
	 * @return array of or null, if none
	 */
	public Product setCharges(ArrayList<Charge> charges) {
		this.charges=charges;
		return this;
	}

	/***
	 * returns the AppliedTradeAllowanceCharges of this product which are actually Charges
	 * @return array of or null, if none
	 */
	@Override
	public Charge[] getCharges() {
		if (charges.size()==0) {
			return null;
		}
		Charge[] chargeArr = new Charge[charges.size()];
		return charges.toArray(chargeArr);
	}

	@Override
	/***
	 * returns the AppliedTradeAllowanceCharges of this product which are actually Allowances
	 * @return array of or null, if none
	 */
	public Allowance[] getAllowances() {
		if (allowances.size()==0) {
			return null;
		}
		Allowance[] allowanceArr = new Allowance[allowances.size()];
		return allowances.toArray(allowanceArr);
	}

	/***
	 * Jackson courtesy function, please use addAllowance if you have the choice
	 * @return array of or null, if none
	 */
	public Product setAllowances(ArrayList<Allowance> allowances) {
		this.allowances=allowances;
		return this;
	}


	private static final HashMap<String, HashMap<String, String>> unitAbbrevs = new HashMap<>();

	static {
		HashMap<String, String> inner1 = new HashMap<>();
		inner1.put("H87", "Piece");
		inner1.put("C62", "One");
		inner1.put("ANN", "Years");
		inner1.put("DAY", "Days");
		inner1.put("H18", "Hectar");
		inner1.put("HUR", "Hours");
		inner1.put("KGM", "Kilogram");
		inner1.put("KTM", "Kilometre");
		inner1.put("KWH", "Kilowatt hour");
		inner1.put("LS", "Lump sum");
		inner1.put("MIN", "Minutes");
		inner1.put("MMK", "Square millimetre");
		inner1.put("MMT", "Millimetre");
		inner1.put("MON", "Months");
		inner1.put("MTK", "Square metre");
		inner1.put("MTQ", "Cubic metre");
		inner1.put("MTR", "Metre");
		inner1.put("NAR", "Number of articles");
		inner1.put("P1", "Percent");
		inner1.put("SET", "Sets");
		inner1.put("TNE", "Metric ton");
		inner1.put("WEE", "Weeks");

		HashMap<String, String> inner2 = new HashMap<>();
		inner2.put("H87", "Stück");
		inner2.put("C62", "Einzeln");
		inner2.put("ANN", "Jahre");
		inner2.put("DAY", "Tage");
		inner2.put("H18", "Hektar");
		inner2.put("HUR", "Stunden");
		inner2.put("KGM", "Kilogramm");
		inner2.put("KTM", "Kilometer");
		inner2.put("KWH", "Kilowattstunde");
		inner2.put("LS", "Pauschale");
		inner2.put("MIN", "Minuten");
		inner2.put("MMK", "Quadratmillimeter");
		inner2.put("MMT", "Millimeter");
		inner2.put("MON", "Monate");
		inner2.put("MTK", "Quadratmeter");
		inner2.put("MTQ", "Kubikmeter");
		inner2.put("MTR", "Meter");
		inner2.put("NAR", "Anzahl Artikel");
		inner2.put("P1", "Prozent");
		inner2.put("SET", "Sets");
		inner2.put("TNE", "Tonne (metrisch)");
		inner2.put("WEE", "Wochen");

		unitAbbrevs.put("EN", inner1);
		unitAbbrevs.put("DE", inner2);
	}



	public static String getHumanReadableUnit(String language, String unitcode) {
		if (!unitAbbrevs.containsKey(language)) {
			throw new RuntimeException("Language unknown");
		}
		if (unitAbbrevs.get(language).containsKey(unitcode)) {
			return unitAbbrevs.get(language).get(unitcode);
		} else{
			return unitcode;
		}
	}

}
