package org.mustangproject.ZUGFeRD;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.mustangproject.ZUGFeRD.model.DateTimeTypeConstants;

public enum ZUGFeRDDateFormat {

	MONTH_OF_YEAR(DateTimeTypeConstants.MONTH, new SimpleDateFormat("yyyyMM")),
	WEEK_OF_YEAR(DateTimeTypeConstants.WEEK, new SimpleDateFormat("yyyyww")),
	DATE(DateTimeTypeConstants.DATE, new SimpleDateFormat("yyyyMMdd"));

	private String dateTimeType;
	private SimpleDateFormat formatter;
	private static final String QDT_FORMAT = "<qdt:DateTimeString format=\"%s\">%s</qdt:DateTimeString>";
	private static final String UDT_FORMAT = "<udt:DateTimeString format=\"%s\">%s</udt:DateTimeString>";

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
	
	public String simpleFormat(Date date){
    return getFormatter().format(date);
  }
	public String qdtFormat(Date date){
    return String.format(QDT_FORMAT, getDateTimeType(), getFormatter().format(date));
  }
	public String udtFormat(Date date){
    return String.format(UDT_FORMAT, getDateTimeType(), getFormatter().format(date));
  }
}
