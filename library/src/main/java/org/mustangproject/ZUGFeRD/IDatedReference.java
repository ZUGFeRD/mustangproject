package org.mustangproject.ZUGFeRD;

import java.util.Date;

public interface IDatedReference {
	public String getID();
	default Date getDate() {
		return null;
	}
}
