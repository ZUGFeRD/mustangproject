//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a>
// �nderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren.
// Generiert: 2015.10.16 um 06:16:03 PM CEST
//


package org.mustangproject.ZUGFeRD.model;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>
 * Java-Klasse f�r CreditorFinancialInstitutionType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="CreditorFinancialInstitutionType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="BICID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *         &lt;element name="GermanBankleitzahlID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *         &lt;element name="Name" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "CreditorFinancialInstitutionType", propOrder = {
		"bicid",
		"germanBankleitzahlID",
		"name"
})
public class CreditorFinancialInstitutionType {

	@XmlElement(name = "BICID")
	protected IDType bicid;
	@XmlElement(name = "GermanBankleitzahlID")
	protected IDType germanBankleitzahlID;
	@XmlElement(name = "Name")
	protected TextType name;


	/**
	 * Ruft den Wert der bicid-Eigenschaft ab.
	 *
	 * @return possible object is {@link IDType }
	 */
	public IDType getBICID() {
		return bicid;
	}


	/**
	 * Legt den Wert der bicid-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link IDType }
	 */
	public void setBICID(IDType value) {
		bicid = value;
	}


	/**
	 * Ruft den Wert der germanBankleitzahlID-Eigenschaft ab.
	 *
	 * @return possible object is {@link IDType }
	 */
	public IDType getGermanBankleitzahlID() {
		return germanBankleitzahlID;
	}


	/**
	 * Legt den Wert der germanBankleitzahlID-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link IDType }
	 */
	public void setGermanBankleitzahlID(IDType value) {
		germanBankleitzahlID = value;
	}


	/**
	 * Ruft den Wert der name-Eigenschaft ab.
	 *
	 * @return possible object is {@link TextType }
	 */
	public TextType getName() {
		return name;
	}


	/**
	 * Legt den Wert der name-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TextType }
	 */
	public void setName(TextType value) {
		name = value;
	}

}
