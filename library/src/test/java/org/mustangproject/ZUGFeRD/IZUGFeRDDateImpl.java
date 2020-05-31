package org.mustangproject.ZUGFeRD;

import java.util.Date;

public class IZUGFeRDDateImpl implements IZUGFeRDDate {

	private Date date;
	private ZUGFeRDDateFormat format = ZUGFeRDDateFormat.DATE;

	public IZUGFeRDDateImpl setDate(Date date) {
		this.date = date;
		return this;
	}

	public IZUGFeRDDateImpl setFormat(ZUGFeRDDateFormat format) {
		this.format = format;
		return this;
	}

	@Override
	public Date getDate() {
		return date;
	}

	@Override
	public ZUGFeRDDateFormat getFormat() {
		return format;
	}

}
