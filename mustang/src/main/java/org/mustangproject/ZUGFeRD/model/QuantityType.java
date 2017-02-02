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
 * Java-Klasse f�r QuantityType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="QuantityType"&gt;
 *   &lt;simpleContent&gt;
 *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;decimal"&gt;
 *       &lt;attribute name="unitCode" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}QuantityTypeUnitCodeContentType" /&gt;
 *     &lt;/extension&gt;
 *   &lt;/simpleContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "QuantityType", namespace = "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15", propOrder = {
		"value"
})
public class QuantityType {

	public static final String PIECE = "C62";
	public static final String DAY = "DAY";
	public static final String HECTARE = "HAR";
	public static final String HOUR = "HUR";
	public static final String KILOGRAM = "KGM";
	public static final String KILOMETER = "KTM";
	public static final String KILOWATTHOUR = "KWH";
	public static final String FIXEDRATE = "LS";
	public static final String LITRE = "LTR";
	public static final String MINUTE = "MIN";
	public static final String SQUAREMILLIMETER = "MMK";
	public static final String MILLIMETER = "MMT";
	public static final String SQUAREMETER = "MTK";
	public static final String CUBICMETER = "MTQ";
	public static final String METER = "MTR";
	public static final String PRODUCTCOUNT = "NAR";
	public static final String PRODUCTPAIR = "NPR";
	public static final String PERCENT = "P1";
	public static final String SET = "SET";
	public static final String TON = "TNE";
	public static final String WEEK = "WEE";

	@XmlValue
	protected BigDecimal value;
	@XmlAttribute(name = "unitCode")
	@XmlJavaTypeAdapter(CollapsedStringAdapter.class)
	protected String unitCode;


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
	 * Ruft den Wert der unitCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link String }
	 */
	public String getUnitCode() {
		return unitCode;
	}


	/**
	 * Legt den Wert der unitCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link String }
	 */
	public void setUnitCode(String value) {
		unitCode = value;
	}

}
