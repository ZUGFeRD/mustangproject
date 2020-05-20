package org.mustangproject.ZUGFeRD;

public class PostalTradeAddress implements IZUGFeRDExportablePostalTradeAddress {

	private String postCodeCode;
	private String lineOne;
	private String lineTwo;
	private String lineThree;
	private String cityName;
	private String countryID;
	private String CountrySubDivisionName;

	public void setPostCodeCode(String postCodeCode) {
		this.postCodeCode = postCodeCode;
	}

	public void setLineOne(String lineOne) {
		this.lineOne = lineOne;
	}

	public void setLineTwo(String lineTwo) {
		this.lineTwo = lineTwo;
	}

	public void setLineThree(String lineThree) {
		this.lineThree = lineThree;
	}

	public void setCityName(String cityName) {
		this.cityName = cityName;
	}

	public void setCountryID(String countryID) {
		this.countryID = countryID;
	}

	public void setCountrySubDivisionName(String countrySubDivisionName) {
		CountrySubDivisionName = countrySubDivisionName;
	}

	@Override
	public String getPostcodeCode() {
		return this.postCodeCode;
	}

	@Override
	public String getLineOne() {
		return this.lineOne;
	}

	@Override
	public String getLineTwo() {
		return this.lineTwo;
	}

	@Override
	public String getLineThree() {
		return this.lineThree;
	}

	@Override
	public String getCityName() {
		return this.cityName;
	}

	@Override
	public String getCountryID() {
		return this.countryID;
	}

	@Override
	public String getCountrySubDivisionName() {
		return this.CountrySubDivisionName;
	}
}
