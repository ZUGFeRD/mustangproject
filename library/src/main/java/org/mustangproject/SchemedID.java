package org.mustangproject;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class SchemedID {
	protected String scheme;
	protected String id;

	public String getScheme() {
		return scheme;
	}

	public SchemedID setScheme(String scheme) {
		this.scheme = scheme;
		return this;
	}

	public String getID() {
		return id;
	}

	public SchemedID setId(String id) {
		this.id = id;
		return this;
	}

	public SchemedID() {

	}

	public SchemedID(String scheme, String id) {
		setScheme(scheme);
		setId(id);
	}

	@Override
	public String toString() {
		return "SchemedID{scheme='" + scheme + "', id='" + id + "'}";
	}

}
