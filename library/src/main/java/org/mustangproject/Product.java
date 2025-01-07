package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.mustangproject.ZUGFeRD.IDesignatedProductClassification;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;
import org.mustangproject.util.NodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

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
	protected String taxCategoryCode = null;
	protected BigDecimal VATPercent;
	protected boolean isReverseCharge = false;
	protected boolean isIntraCommunitySupply = false;
	protected SchemedID globalId = null;
	protected String countryOfOrigin = null;
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


		nodeMap.getAsNodeMap("ApplicableProductCharacteristic").ifPresent(apcNodes -> {
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

		nodeMap.getAsString("OriginTradeCounty").ifPresent(this::setCountryOfOrigin);
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
		taxExemptionReason = taxExemptionReasonText;
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

	@Override
	public boolean isReverseCharge() {
		return isReverseCharge;
	}

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
}
