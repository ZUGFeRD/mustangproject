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
 * Java-Klasse f�r TradeDeliveryTermsType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradeDeliveryTermsType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="DeliveryTypeCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}DeliveryTermsCodeType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradeDeliveryTermsType", propOrder = {
		"deliveryTypeCode"
})
public class TradeDeliveryTermsType {

	@XmlElement(name = "DeliveryTypeCode")
	protected DeliveryTermsCodeType deliveryTypeCode;


	/**
	 * Ruft den Wert der deliveryTypeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link DeliveryTermsCodeType }
	 */
	public DeliveryTermsCodeType getDeliveryTypeCode() {
		return deliveryTypeCode;
	}


	/**
	 * Legt den Wert der deliveryTypeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DeliveryTermsCodeType }
	 */
	public void setDeliveryTypeCode(DeliveryTermsCodeType value) {
		deliveryTypeCode = value;
	}

}
