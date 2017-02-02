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
import javax.xml.bind.annotation.XmlType;


/**
 * <p>
 * Java-Klasse f�r TradeContactType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradeContactType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="PersonName" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" minOccurs="0"/&gt;
 *         &lt;element name="DepartmentName" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" minOccurs="0"/&gt;
 *         &lt;element name="TelephoneUniversalCommunication" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}UniversalCommunicationType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="FaxUniversalCommunication" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}UniversalCommunicationType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="EmailURIUniversalCommunication" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}UniversalCommunicationType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradeContactType", propOrder = {
		"personName",
		"departmentName",
		"telephoneUniversalCommunication",
		"faxUniversalCommunication",
		"emailURIUniversalCommunication"
})
public class TradeContactType {

	@XmlElement(name = "PersonName")
	protected TextType personName;
	@XmlElement(name = "DepartmentName")
	protected TextType departmentName;
	@XmlElement(name = "TelephoneUniversalCommunication")
	protected List<UniversalCommunicationType> telephoneUniversalCommunication;
	@XmlElement(name = "FaxUniversalCommunication")
	protected List<UniversalCommunicationType> faxUniversalCommunication;
	@XmlElement(name = "EmailURIUniversalCommunication")
	protected UniversalCommunicationType emailURIUniversalCommunication;


	/**
	 * Ruft den Wert der personName-Eigenschaft ab.
	 *
	 * @return possible object is {@link TextType }
	 */
	public TextType getPersonName() {
		return personName;
	}


	/**
	 * Legt den Wert der personName-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TextType }
	 */
	public void setPersonName(TextType value) {
		personName = value;
	}


	/**
	 * Ruft den Wert der departmentName-Eigenschaft ab.
	 *
	 * @return possible object is {@link TextType }
	 */
	public TextType getDepartmentName() {
		return departmentName;
	}


	/**
	 * Legt den Wert der departmentName-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TextType }
	 */
	public void setDepartmentName(TextType value) {
		departmentName = value;
	}


	/**
	 * Gets the value of the telephoneUniversalCommunication property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the telephoneUniversalCommunication property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getTelephoneUniversalCommunication().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link UniversalCommunicationType }
	 */
	public List<UniversalCommunicationType> getTelephoneUniversalCommunication() {
		if (telephoneUniversalCommunication == null) {
			telephoneUniversalCommunication = new ArrayList<>();
		}
		return telephoneUniversalCommunication;
	}


	/**
	 * Gets the value of the faxUniversalCommunication property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the faxUniversalCommunication property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getFaxUniversalCommunication().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link UniversalCommunicationType }
	 */
	public List<UniversalCommunicationType> getFaxUniversalCommunication() {
		if (faxUniversalCommunication == null) {
			faxUniversalCommunication = new ArrayList<>();
		}
		return faxUniversalCommunication;
	}


	/**
	 * Ruft den Wert der emailURIUniversalCommunication-Eigenschaft ab.
	 *
	 * @return possible object is {@link UniversalCommunicationType }
	 */
	public UniversalCommunicationType getEmailURIUniversalCommunication() {
		return emailURIUniversalCommunication;
	}


	/**
	 * Legt den Wert der emailURIUniversalCommunication-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link UniversalCommunicationType }
	 */
	public void setEmailURIUniversalCommunication(UniversalCommunicationType value) {
		emailURIUniversalCommunication = value;
	}

}
