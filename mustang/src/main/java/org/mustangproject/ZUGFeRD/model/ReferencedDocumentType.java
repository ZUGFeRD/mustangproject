//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a>
// �nderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren.
// Generiert: 2015.10.16 um 06:16:03 PM CEST
//


package org.mustangproject.ZUGFeRD.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>
 * Java-Klasse f�r ReferencedDocumentType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="ReferencedDocumentType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="IssueDateTime" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}DateMandatoryDateTimeType" minOccurs="0"/&gt;
 *         &lt;element name="LineID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *         &lt;element name="TypeCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}DocumentCodeType" minOccurs="0"/&gt;
 *         &lt;element name="ID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ReferenceTypeCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}ReferenceCodeType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ReferencedDocumentType", propOrder = {
		"issueDateTime",
		"lineID",
		"typeCode",
		"id",
		"referenceTypeCode"
})
public class ReferencedDocumentType {

	@XmlElement(name = "IssueDateTime")
	@XmlSchemaType(name = "anySimpleType")
	protected String issueDateTime;
	@XmlElement(name = "LineID")
	protected IDType lineID;
	@XmlElement(name = "TypeCode")
	protected DocumentCodeType typeCode;
	@XmlElement(name = "ID")
	protected List<IDType> id;
	@XmlElement(name = "ReferenceTypeCode")
	protected ReferenceCodeType referenceTypeCode;


	/**
	 * Ruft den Wert der issueDateTime-Eigenschaft ab.
	 *
	 * @return possible object is {@link String }
	 */
	public String getIssueDateTime() {
		return issueDateTime;
	}


	/**
	 * Legt den Wert der issueDateTime-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link String }
	 */
	public void setIssueDateTime(String value) {
		issueDateTime = value;
	}


	/**
	 * Ruft den Wert der lineID-Eigenschaft ab.
	 *
	 * @return possible object is {@link IDType }
	 */
	public IDType getLineID() {
		return lineID;
	}


	/**
	 * Legt den Wert der lineID-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link IDType }
	 */
	public void setLineID(IDType value) {
		lineID = value;
	}


	/**
	 * Ruft den Wert der typeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link DocumentCodeType }
	 */
	public DocumentCodeType getTypeCode() {
		return typeCode;
	}


	/**
	 * Legt den Wert der typeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DocumentCodeType }
	 */
	public void setTypeCode(DocumentCodeType value) {
		typeCode = value;
	}


	/**
	 * Gets the value of the id property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the id property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getID().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link IDType }
	 */
	public List<IDType> getID() {
		if (id == null) {
			id = new ArrayList<>();
		}
		return id;
	}


	/**
	 * Ruft den Wert der referenceTypeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link ReferenceCodeType }
	 */
	public ReferenceCodeType getReferenceTypeCode() {
		return referenceTypeCode;
	}


	/**
	 * Legt den Wert der referenceTypeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link ReferenceCodeType }
	 */
	public void setReferenceTypeCode(ReferenceCodeType value) {
		referenceTypeCode = value;
	}

}
