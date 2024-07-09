package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.mustangproject.ZUGFeRD.*;

/***
 * A organisation, i.e. usually a company
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class LegalOrganisation implements IZUGFeRDLegalOrganisation {

	protected String ID = null;
	protected String SchemeID = null;

	public LegalOrganisation() {
	}

	public LegalOrganisation(String ID, String scheme) {
		this.ID=ID;
		this.SchemeID=scheme;
	}

	@Override
	public String getID() {
		return ID;
	}

	@Override
	public String getSchemeID() {
		return SchemeID;
	}

	public LegalOrganisation setID(String id) {
		this.ID=id;
		return this;
	}

	public LegalOrganisation setSchemeID(String scheme) {
		SchemeID=scheme;
		return this;
	}

}
