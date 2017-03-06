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
 * Java-Klasse f�r ProductCharacteristicType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="ProductCharacteristicType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="TypeCode" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}CodeType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="Description" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ValueMeasure" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}MeasureType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="Value" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ProductCharacteristicType", propOrder = {
		"typeCode",
		"description",
		"valueMeasure",
		"value"
})
public class ProductCharacteristicType {

	@XmlElement(name = "TypeCode")
	protected List<CodeType> typeCode;
	@XmlElement(name = "Description")
	protected List<TextType> description;
	@XmlElement(name = "ValueMeasure")
	protected List<MeasureType> valueMeasure;
	@XmlElement(name = "Value")
	protected List<TextType> value;


	/**
	 * Gets the value of the typeCode property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the typeCode property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getTypeCode().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link CodeType }
	 */
	public List<CodeType> getTypeCode() {
		if (typeCode == null) {
			typeCode = new ArrayList<>();
		}
		return typeCode;
	}


	/**
	 * Gets the value of the description property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the description property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getDescription().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TextType }
	 */
	public List<TextType> getDescription() {
		if (description == null) {
			description = new ArrayList<>();
		}
		return description;
	}


	/**
	 * Gets the value of the valueMeasure property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the valueMeasure property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getValueMeasure().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link MeasureType }
	 */
	public List<MeasureType> getValueMeasure() {
		if (valueMeasure == null) {
			valueMeasure = new ArrayList<>();
		}
		return valueMeasure;
	}


	/**
	 * Gets the value of the value property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the value property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getValue().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TextType }
	 */
	public List<TextType> getValue() {
		if (value == null) {
			value = new ArrayList<>();
		}
		return value;
	}

}
