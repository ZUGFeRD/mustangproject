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
 * Java-Klasse f�r ProductClassificationType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="ProductClassificationType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ClassCode" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}CodeType" minOccurs="0"/&gt;
 *         &lt;element name="ClassName" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ProductClassificationType", propOrder = {
		"classCode",
		"className"
})
public class ProductClassificationType {

	@XmlElement(name = "ClassCode")
	protected CodeType classCode;
	@XmlElement(name = "ClassName")
	protected List<TextType> className;


	/**
	 * Ruft den Wert der classCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link CodeType }
	 */
	public CodeType getClassCode() {
		return classCode;
	}


	/**
	 * Legt den Wert der classCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link CodeType }
	 */
	public void setClassCode(CodeType value) {
		classCode = value;
	}


	/**
	 * Gets the value of the className property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the className property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getClassName().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TextType }
	 */
	public List<TextType> getClassName() {
		if (className == null) {
			className = new ArrayList<>();
		}
		return className;
	}

}
