package org.mustangproject;

import org.mustangproject.ZUGFeRD.*;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;

public class TradeParty implements IZUGFeRDExportableTradeParty {

	protected String name, zip, street, location, country;
	protected String taxID = null, vatID = null;
	protected String ID = null;
	protected String additionalAddress = null;
	protected ArrayList<BankDetails> bankDetails = new ArrayList<BankDetails>();
	protected Contact contact = null;

	public TradeParty(String name, String street, String zip, String location, String country) {
		this.name = name;
		this.street = street;
		this.zip = zip;
		this.location = location;
		this.country = country;

	}

	public TradeParty(NodeList nodes) {
/**
 * <ram:SellerTradeParty>
 *  <ram:ID>LIEF-987654321</ram:ID>
 *  <ram:Name>Max Mustermann IT GmbH</ram:Name>
 *  <ram:DefinedTradeContact>
 *  <ram:PersonName>Herr Treudiener</ram:PersonName>
 *  <ram:TelephoneUniversalCommunication>
 *  <ram:CompleteNumber>+49 1234-98765-12</ram:CompleteNumber>
 *  </ram:TelephoneUniversalCommunication>
 *  <ram:EmailURIUniversalCommunication>
 *  <ram:URIID>treudiener@max-mustermann-it.de</ram:URIID>
 *  </ram:EmailURIUniversalCommunication>
 *  </ram:DefinedTradeContact>
 *  <ram:PostalTradeAddress>
 *  <ram:PostcodeCode>12345</ram:PostcodeCode>
 *  <ram:LineOne>Musterstraße 1</ram:LineOne>
 *  <ram:CityName>Musterstadt</ram:CityName>
 *  <ram:CountryID>DE</ram:CountryID>
 *  </ram:PostalTradeAddress>
 *  <ram:SpecifiedTaxRegistration>
 *  <ram:ID schemeID="VA">DE123456789</ram:ID>
 *  </ram:SpecifiedTaxRegistration>
 *  </ram:SellerTradeParty>
 */
		if (nodes.getLength() > 0) {

			for (int nodeIndex = 0; nodeIndex < nodes.getLength(); nodeIndex++) {
				//nodes.item(i).getTextContent())) {
				Node currentItemNode = nodes.item(nodeIndex);
				NodeList itemChilds = currentItemNode.getChildNodes();
				for (int itemChildIndex = 0; itemChildIndex < itemChilds.getLength(); itemChildIndex++) {
					if (itemChilds.item(itemChildIndex).getNodeName().equals("ram:Name")) {
						setName(itemChilds.item(itemChildIndex).getTextContent());
					}
					if (itemChilds.item(itemChildIndex).getNodeName().equals("ram:PostalTradeAddress")) {
						NodeList postal = itemChilds.item(itemChildIndex).getChildNodes();
						for (int postalChildIndex = 0; postalChildIndex < postal.getLength(); postalChildIndex++) {
							if (postal.item(postalChildIndex).getNodeName().equals("ram:LineOne")) {
								setStreet(postal.item(postalChildIndex).getTextContent());
							}
							if (postal.item(postalChildIndex).getNodeName().equals("ram:LineTwo")) {
								setAdditionalAddress(postal.item(postalChildIndex).getTextContent());
							}
							if (postal.item(postalChildIndex).getNodeName().equals("ram:CityName")) {
								setLocation(postal.item(postalChildIndex).getTextContent());
							}
							if (postal.item(postalChildIndex).getNodeName().equals("ram:PostcodeCode")) {
								setZIP(postal.item(postalChildIndex).getTextContent());
							}
							if (postal.item(postalChildIndex).getNodeName().equals("ram:CountryID")) {
								setCountry(postal.item(postalChildIndex).getTextContent());
							}
						}

					}

				}
			}
		}

	}

	@Override
	public String getID() {
		return ID;
	}

	public TradeParty setID(String ID) {
		this.ID = ID;
		return this;
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
		if (bankDetails.size() == 0) {
			return null;
		}
		return bankDetails.toArray(new IZUGFeRDTradeSettlement[0]);
	}

	@Override
	public String getAdditionalAddress() {
		return additionalAddress;
	}

	public TradeParty setAdditionalAddress(String additionalAddress) {
		this.additionalAddress = additionalAddress;
		return this;
	}


}
