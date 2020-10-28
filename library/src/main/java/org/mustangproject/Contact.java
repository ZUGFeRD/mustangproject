package org.mustangproject;

import org.mustangproject.ZUGFeRD.IZUGFeRDExportableContact;

public class Contact implements IZUGFeRDExportableContact {

	protected String name,phone,email,zip,street,location,country;
	protected String fax=null;

	public Contact(String name, String phone, String email) {
		this.name = name;
		this.phone = phone;
		this.email = email;

	}
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

	public Contact setName(String name) {
		this.name = name;
		return this;
	}

	@Override
	public String getPhone() {
		return phone;
	}

	public Contact setPhone(String phone) {
		this.phone = phone;
		return this;
	}

	@Override
	public String getFax() {
		return fax;
	}

	public Contact setFax(String fax) {
		this.fax = fax;
		return this;
	}

	public String getEMail() {
		return email;
	}

	public Contact setEMail(String email) {
		this.email = email;
		return this;
	}

	public String getZIP() {
		return zip;
	}

	public Contact setZIP(String zip) {
		this.zip = zip;
		return this;
	}

	@Override
	public String getStreet() {
		return street;
	}

	public Contact setStreet(String street) {
		this.street = street;
		return this;
	}

	@Override
	public String getLocation() {
		return location;
	}

	public Contact setLocation(String location) {
		this.location = location;
		return this;
	}

	@Override
	public String getCountry() {
		return country;
	}

	public Contact setCountry(String country) {
		this.country = country;
		return this;
	}

}
