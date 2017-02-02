//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a>
// �nderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren.
// Generiert: 2015.10.16 um 06:16:03 PM CEST
//


package org.mustangproject.ZUGFeRD.model;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;


/**
 * <p>
 * Java-Klasse f�r TaxCategoryCodeType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TaxCategoryCodeType"&gt;
 *   &lt;simpleContent&gt;
 *     &lt;extension base="&lt;urn:un:unece:uncefact:data:standard:QualifiedDataType:12&gt;TaxCategoryCodeContentType"&gt;
 *     &lt;/extension&gt;
 *   &lt;/simpleContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TaxCategoryCodeType", namespace = "urn:un:unece:uncefact:data:standard:QualifiedDataType:12", propOrder = {
		"value"
})
public class TaxCategoryCodeType {

	public static final String STANDARDRATE = "S";
	public static final String REVERSECHARGE = "AE";
	public static final String TAXEXEMPT = "E";
	public static final String ZEROTAXPRODUCTS = "Z";
	public static final String UNTAXEDSERVICE = "O";
	public static final String INTRACOMMUNITY = "IC";

	@XmlValue
	@XmlJavaTypeAdapter(CollapsedStringAdapter.class)
	protected String value;


	/**
	 * Ruft den Wert der value-Eigenschaft ab.
	 *
	 * @return possible object is {@link String }
	 */
	public String getValue() {
		return value;
	}


	/**
	 * Legt den Wert der value-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link String }
	 */
	public void setValue(String value) {
		this.value = value;
	}

}
