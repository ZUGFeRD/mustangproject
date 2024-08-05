package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableProduct;

import java.math.BigDecimal;
import java.util.HashMap;

/***
 * describes a product, good or service used in an invoice item line
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Product implements IZUGFeRDExportableProduct {
	protected String unit, name, description, sellerAssignedID, buyerAssignedID;
	protected BigDecimal VATPercent;
	protected boolean isReverseCharge = false;
	protected boolean isIntraCommunitySupply = false;
	protected SchemedID globalId = null;
	protected String countryOfOrigin = null;
	protected HashMap<String, String> attributes = null;

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
		this.VATPercent = VATPercent;
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
	    return this.attributes;
	}

	public Product setAttributes(HashMap<String, String> attributes) {
	    this.attributes = attributes;
	    return this;
	}

	public Product addAttribute(String name, String value ) {
	    if ( this.attributes == null ) {
		this.attributes = new HashMap<>();
	    }
	    this.attributes.put(name, value);
	    return this;
	}
}
