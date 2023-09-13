package org.mustangproject;

import org.mustangproject.ZUGFeRD.IReferencedDocument;

public class ReferencedDocument implements IReferencedDocument {

	protected String issuerAssignedID;
	protected String typeCode;
	protected String referenceTypeCode;

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
	 * @param issuerAssignedID null or a string with the ID of the document as defined by issuer
	 */
	public void setIssuerAssignedID(String issuerAssignedID) {
		this.issuerAssignedID = issuerAssignedID;
	}

	/**
	 * which type is the document?
	 * @param typeCode string with e.g. "916" for additional invoice related
	 */
	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}

	/**
	 * type of the reference of this line,
	 * @param referenceTypeCode the typecode of the reference as a UNTDID 1153 string value https://service.unece.org/trade/untdid/d19b/tred/tred1153.htm
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
}
