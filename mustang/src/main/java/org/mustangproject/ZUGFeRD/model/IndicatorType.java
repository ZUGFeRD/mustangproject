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
 * Java-Klasse f�r IndicatorType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="IndicatorType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;choice&gt;
 *         &lt;element name="Indicator" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *       &lt;/choice&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "IndicatorType", namespace = "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15", propOrder = {
		"indicator"
})
public class IndicatorType {

	@XmlElement(name = "Indicator")
	protected Boolean indicator;


	/**
	 * Ruft den Wert der indicator-Eigenschaft ab.
	 *
	 * @return possible object is {@link Boolean }
	 */
	public Boolean isIndicator() {
		return indicator;
	}


	/**
	 * Legt den Wert der indicator-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link Boolean }
	 */
	public void setIndicator(Boolean value) {
		indicator = value;
	}

}
