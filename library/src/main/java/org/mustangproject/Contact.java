package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;

/***
 * a named contact person in an organisation
 * for the organisation/company itsel please
 * @see TradeParty
 */
public class Contact implements IZUGFeRDExportableContact {

	protected String name,phone,email,zip,street,location,country;
	protected String fax=null;

	/***
	 * default constructor.
	 * Name, phone and email of sender contact person are e.g. required by XRechnung
	 * @param name
	 * @param phone
	 * @param email
	 */
	public Contact(String name, String phone, String email) {
		this.name = name;
		this.phone = phone;
		this.email = email;
	}

	/***
	 * complete specification of a named contact with a different address
	 * @param name
	 * @param phone
	 * @param email
	 * @param street
	 * @param zip
	 * @param location
	 * @param country
	 */
	public Contact(String name, String phone, String email, String street, String zip, String location, String country) {
		this.name = name;
		this.phone = phone;
		this.email = email;
		this.street = street;
		this.zip = zip;
		this.location = location;
		this.country = country;

	}

	@Override
	public String getName() {
		return name;
	}

	/**
	 * the first and last name of the contact
	 * @param name
	 * @return
	 */
	public Contact setName(String name) {
		this.name = name;
		return this;
	}

	@Override
	public String getPhone() {
		return phone;
	}

	/***
	 * complete phone number of the contact
	 * @param phone
	 * @return
	 */
	public Contact setPhone(String phone) {
		this.phone = phone;
		return this;
	}

	@Override
	public String getFax() {
		return fax;
	}

	/***
	 * (optional) complete fax number
	 * @param fax
	 * @return
	 */
	public Contact setFax(String fax) {
		this.fax = fax;
		return this;
	}

	public String getEMail() {
		return email;
	}

	/***
	 * personal email address of the contact person
	 * @param email
	 * @return
	 */
	public Contact setEMail(String email) {
		this.email = email;
		return this;
	}

	public String getZIP() {
		return zip;
	}

	/***
	 * the postcode, if the address is different to the organisation
	 * @param zip
	 * @return
	 */
	public Contact setZIP(String zip) {
		this.zip = zip;
		return this;
	}

	@Override
	public String getStreet() {
		return street;
	}

	/**
	 * street and number, if the address is different to the organisation
	 * @param street
	 * @return
	 */
	public Contact setStreet(String street) {
		this.street = street;
		return this;
	}

	@Override
	public String getLocation() {
		return location;
	}

	/***
	 * city of the contact person, if different from organisation
	 * @param location
	 * @return
	 */
	public Contact setLocation(String location) {
		this.location = location;
		return this;
	}

	@Override
	public String getCountry() {
		return country;
	}

	/***
	 * two-letter ISO country code of the contact, if different from organisation
	 * @param country
	 * @return
	 */
	public Contact setCountry(String country) {
		this.country = country;
		return this;
	}

}
