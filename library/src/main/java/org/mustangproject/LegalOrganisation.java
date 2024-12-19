package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.*;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/***
 * A organisation, i.e. usually a company
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class LegalOrganisation implements IZUGFeRDLegalOrganisation {

	protected SchemedID schemedID = null;
	protected String tradingBusinessName = null;

	public LegalOrganisation() {
	}

	public LegalOrganisation(String ID, String scheme) {
		this.schemedID = new SchemedID(scheme, ID);
	}

	public LegalOrganisation(SchemedID schemedID, String tradingBusinessName) {
		this.schemedID = schemedID;
		this.tradingBusinessName=tradingBusinessName;
	}

	/***
	 * XML parsing constructor
	 * @param nodes the nodelist returned e.g. from xpath
	 */
	public LegalOrganisation(NodeList nodes) {
		if (nodes.getLength() > 0) {
		/*
			will parse sth like
			<ram:SpecifiedLegalOrganization>  
				<ram:ID schemeID="0002">4711</ram:ID>
				<ram:TradingBusinessName>Test GmbH &amp; Co.KG</ram:TradingBusinessName>
			</ram:SpecifiedLegalOrganization>
		 */
			for (int nodeIndex = 0; nodeIndex < nodes.getLength(); nodeIndex++) {
				Node currentItemNode = nodes.item(nodeIndex);
				if (currentItemNode.getLocalName() != null) {
					if (currentItemNode.getLocalName().equals("GlobalID")) {
						if (currentItemNode.getAttributes().getNamedItem("schemeID") != null) {
							SchemedID gid = new SchemedID().setScheme(currentItemNode.getAttributes().getNamedItem("schemeID").getNodeValue()).setId(currentItemNode.getTextContent());
							this.setSchemedID(gid);
						}
					}
					if (currentItemNode.getLocalName().equals("TradingBusinessName")) {
					    setTradingBusinessName(currentItemNode.getFirstChild().getNodeValue());
					}
				}
			}
		}
	}

	@Override
	public SchemedID getSchemedID() {
		return this.schemedID;
	}

	@Override
	public String getTradingBusinessName() {
		return this.tradingBusinessName;
	}

	public LegalOrganisation setSchemedID(SchemedID schemedID) {
		this.schemedID = schemedID;
		return this;
	}

	public LegalOrganisation setTradingBusinessName(String tradingBusinessName) {
		this.tradingBusinessName = tradingBusinessName;
		return this;
	}
}
