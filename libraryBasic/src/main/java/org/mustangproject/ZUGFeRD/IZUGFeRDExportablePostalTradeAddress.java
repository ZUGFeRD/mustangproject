package org.mustangproject.ZUGFeRD;

public interface IZUGFeRDExportablePostalTradeAddress {
	default String getPostcodeCode(){return null;}
	default String getLineOne() {return null;}
	default String getLineTwo() {return null;}
	default String getLineThree() {return null;}
	default String getCityName() {return null;}
	default String getCountryID() {return null;}
	default String getCountrySubDivisionName() {return null;}
}
