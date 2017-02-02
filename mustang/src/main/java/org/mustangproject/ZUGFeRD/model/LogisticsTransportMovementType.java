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
 * Java-Klasse f�r LogisticsTransportMovementType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="LogisticsTransportMovementType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ModeCode" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}CodeType" minOccurs="0"/&gt;
 *         &lt;element name="ID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "LogisticsTransportMovementType", propOrder = {
		"modeCode",
		"id"
})
public class LogisticsTransportMovementType {

	@XmlElement(name = "ModeCode")
	protected CodeType modeCode;
	@XmlElement(name = "ID")
	protected IDType id;


	/**
	 * Ruft den Wert der modeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link CodeType }
	 */
	public CodeType getModeCode() {
		return modeCode;
	}


	/**
	 * Legt den Wert der modeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link CodeType }
	 */
	public void setModeCode(CodeType value) {
		modeCode = value;
	}


	/**
	 * Ruft den Wert der id-Eigenschaft ab.
	 *
	 * @return possible object is {@link IDType }
	 */
	public IDType getID() {
		return id;
	}


	/**
	 * Legt den Wert der id-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link IDType }
	 */
	public void setID(IDType value) {
		id = value;
	}

}
