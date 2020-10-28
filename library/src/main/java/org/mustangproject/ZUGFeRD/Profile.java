package org.mustangproject.ZUGFeRD;

public class Profile {
	protected String name, id;

	public Profile(String name, String ID) {
		this.name = name;
		this.id = ID;
	}

	public String getName() {
		return name;
	}

	public String getID() {
		return id;
	}

	public String getXMPName() {
		if (name.equals("BASICWL")) {
			return "BASIC WL";
		} else if (name.equals("EN16931")) {
			return "EN 16931";
		} else {
			return name;
		}
	}
}
