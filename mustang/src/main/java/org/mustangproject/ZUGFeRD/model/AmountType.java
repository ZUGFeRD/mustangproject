//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a>
// �nderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren.
// Generiert: 2015.10.16 um 06:16:03 PM CEST
//


package org.mustangproject.ZUGFeRD.model;

import java.math.BigDecimal;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;


/**
 * <p>
 * Java-Klasse f�r AmountType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="AmountType"&gt;
 *   &lt;simpleContent&gt;
 *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;decimal"&gt;
 *       &lt;attribute name="currencyID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountTypeCurrencyIDContentType" /&gt;
 *     &lt;/extension&gt;
 *   &lt;/simpleContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AmountType", namespace = "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15", propOrder = {
		"value"
})
public class AmountType {

	@XmlValue
	protected BigDecimal value;
	@XmlAttribute(name = "currencyID")
	@XmlJavaTypeAdapter(CollapsedStringAdapter.class)
	protected String currencyID;


	/**
	 * Ruft den Wert der value-Eigenschaft ab.
	 *
	 * @return possible object is {@link BigDecimal }
	 */
	public BigDecimal getValue() {
		return value;
	}


	/**
	 * Legt den Wert der value-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link BigDecimal }
	 */
	public void setValue(BigDecimal value) {
		this.value = value;
	}


	/**
	 * Ruft den Wert der currencyID-Eigenschaft ab.
	 *
	 * @return possible object is {@link String }
	 */
	public String getCurrencyID() {
		return currencyID;
	}


	/**
	 * Legt den Wert der currencyID-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link String }
	 */
	public void setCurrencyID(String value) {
		currencyID = value;
	}

}
