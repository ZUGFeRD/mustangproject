package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableTradeParty;
import org.mustangproject.ZUGFeRD.IZUGFeRDTradeSettlement;

import java.util.ArrayList;

public class TradeParty implements IZUGFeRDExportableTradeParty {

	protected String name, zip, street, location, country;
	protected String taxID = null, vatID = null;
	protected ArrayList<BankDetails> bankDetails = new ArrayList<BankDetails>();
	protected Contact contact = null;

	public TradeParty(String name, String street, String zip, String location, String country) {
		this.name = name;
		this.street = street;
		this.zip = zip;
		this.location = location;
		this.country = country;

	}

	public TradeParty setContact(Contact c) {
		this.contact = c;
		return this;
	}
	public TradeParty addBankDetails(BankDetails s) {
		bankDetails.add(s);
		return this;
	}
	public ArrayList<BankDetails> getBankDetails() {
		return bankDetails;
	}
	public TradeParty addTaxID(String taxID) {
		this.taxID = taxID;
		return this;
	}

	public TradeParty addVATID(String vatID) {
		this.vatID = vatID;
		return this;
	}

	@Override
	public String getVATID() {
		return vatID;
	}

	@Override
	public String getTaxID() {
		return taxID;
	}

	public String getName() {
		return name;
	}

	public TradeParty setName(String name) {
		this.name = name;
		return this;
	}


	public String getZIP() {
		return zip;
	}

	public TradeParty setZIP(String zip) {
		this.zip = zip;
		return this;
	}

	@Override
	public String getStreet() {
		return street;
	}

	public TradeParty setStreet(String street) {
		this.street = street;
		return this;
	}

	@Override
	public String getLocation() {
		return location;
	}

	public TradeParty setLocation(String location) {
		this.location = location;
		return this;
	}

	@Override
	public String getCountry() {
		return country;
	}

	public TradeParty setCountry(String country) {
		this.country = country;
		return this;
	}


	public String getVatID() {
		return vatID;
	}

	public String getZip() {
		return zip;
	}

	@Override
	public IZUGFeRDExportableContact getContact() {
		return contact;
	}

	public IZUGFeRDTradeSettlement[] getAsTradeSettlement() {
		if (bankDetails.size()==0) {
			return null;
		}
		return bankDetails.toArray(new IZUGFeRDTradeSettlement[0]);
	}
}
