package org.mustangproject;

import org.mustangproject.ZUGFeRD.IReferencedDocument;

public class ReferencedDocument implements IReferencedDocument {


	String issuerAssignedID;
	String typeCode;
	String referenceTypeCode;

	public void setIssuerAssignedID(String issuerAssignedID) {
		this.issuerAssignedID = issuerAssignedID;
	}

	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}

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
