package org.mustangproject.ZUGFeRD;

/***
 * specifies a kind of a XML completeness levels,
 * e.g. Factur-X has 6 (Minimum, Basic-WL, Basic, EN16931, Extended, and XRechnung),
 * ZUGFeRD 1 had and Order-X will have three (Basic, Comfort, Extended)
 * and the XRechnung has two (Standard, Extension)
 * For the XRechnung at the time being please use Factur-X's Xrechnung
 */
public class Profile {
	protected String name, id;

	/***
	 * Contruct
	 * @param name human readable name of the profile, also used as basis to detemine the XMP Name
	 * @param ID XML Guideline ID
	 */
	public Profile(String name, String ID) {
		this.name = name;
		this.id = ID;
	}

	/***
	 * gets the name
	 * @return the name of the profile
	 */
	public String getName() {
		return name;
	}

	/***
	 * get guideline id
	 * @return the XML Guideline ID of the profile
	 */
	public String getID() {
		return id;
	}

	/***
	 * if the profile is embedded in PDF we need RDF metadata
	 * @return the XMP name string of the profile
	 */
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
