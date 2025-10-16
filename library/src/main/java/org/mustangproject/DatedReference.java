package org.mustangproject;

import org.mustangproject.ZUGFeRD.IDatedReference;

import java.beans.BeanProperty;
import java.util.Date;

public class DatedReference implements IDatedReference {

	protected String ID;
	protected Date opDate;

	public DatedReference setDate(Date opDate) {
		this.opDate = opDate;
		return this;
	}

	public DatedReference setID(String ID) {
		this.ID = ID;
		return this;
	}

	public DatedReference() {

	}

	public DatedReference(String ID) {
		setID(ID);
	}

	public DatedReference(String ID, Date theDate) {
		setID(ID);
		setDate(theDate);
	}


	@Override
	public String getID() {
		return ID;
	}

	@Override
	public Date getDate() {
		return opDate;
	}
}
