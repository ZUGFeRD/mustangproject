package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.mustangproject.ZUGFeRD.*;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
