package org.mustangproject.ZUGFeRD;

import java.util.Date;

public interface IZUGFeRDDate {

	Date getDate();

	default ZUGFeRDDateFormat getFormat() {
		return ZUGFeRDDateFormat.DATE;
	}

}
