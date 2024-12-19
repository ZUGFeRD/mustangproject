package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IReferencedDocument;
import org.mustangproject.util.NodeMap;
import org.w3c.dom.Node;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ReferencedDocument implements IReferencedDocument {

	String issuerAssignedID;
	String typeCode;
	String referenceTypeCode;

	public ReferencedDocument(String issuerAssignedID, String typeCode, String referenceTypeCode) {
		this.issuerAssignedID = issuerAssignedID;
		this.typeCode = typeCode;
		this.referenceTypeCode = referenceTypeCode;
	}

	public ReferencedDocument(String issuerAssignedID, String referenceTypeCode) {
		this.issuerAssignedID = issuerAssignedID;
		this.typeCode = "916"; // additional invoice related document
		this.referenceTypeCode = referenceTypeCode;
	}

    /***
	 * sets an ID assigned by the sender
	 * @param issuerAssignedID the ID as a string :-)
	 */
	public void setIssuerAssignedID(String issuerAssignedID) {
		this.issuerAssignedID = issuerAssignedID;
	}

	/**
	 * which type is the document? e.g. "916" for additional invoice related
	 * @param typeCode as String, e.g. 916
	 */
	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}

	/**
	 * type of the reference of this line, a UNTDID 1153 code
	 * @param referenceTypeCode three uppercase character reference type code as string
	 */
	public void setReferenceTypeCode(String referenceTypeCode) {
		this.referenceTypeCode = referenceTypeCode;
	}

	@Override
	public String getIssuerAssignedID() {
		return issuerAssignedID;
	}

	@Override
	public String getTypeCode() {
		return typeCode;
	}

	@Override
	public String getReferenceTypeCode() {
		return referenceTypeCode;
	}

	public static ReferencedDocument fromNode(Node node) {
		if (!node.hasChildNodes()) {
			return null;
		}
		NodeMap nodes = new NodeMap(node);
		return new ReferencedDocument(nodes.getAsStringOrNull("IssuerAssignedID", "ID"),
			nodes.getAsStringOrNull("TypeCode", "DocumentTypeCode"),
			nodes.getAsStringOrNull("ReferenceTypeCode"));
	}
}
