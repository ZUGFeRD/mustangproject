package org.mustangproject.ZUGFeRD;

import java.text.SimpleDateFormat;

import org.mustangproject.ZUGFeRD.model.DateTimeTypeConstants;

public enum ZUGFeRDDateFormat {

	MONTH_OF_YEAR(DateTimeTypeConstants.MONTH, new SimpleDateFormat("yyyyMM")),
	WEEK_OF_YEAR(DateTimeTypeConstants.WEEK, new SimpleDateFormat("yyyyww")),
	DATE(DateTimeTypeConstants.DATE, new SimpleDateFormat("yyyyMMdd"));

	private String dateTimeType;
	private SimpleDateFormat formatter;

	private ZUGFeRDDateFormat(String dateTimeType, SimpleDateFormat formatter) {
		this.dateTimeType = dateTimeType;
		this.formatter = formatter;
	}

	public String getDateTimeType() {
		return dateTimeType;
	}

	public SimpleDateFormat getFormatter() {
		return formatter;
	}
}
