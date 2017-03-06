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
 * Java-Klasse f�r TradePaymentDiscountTermsType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradePaymentDiscountTermsType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="BasisDateTime" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}DateTimeType" minOccurs="0"/&gt;
 *         &lt;element name="BasisPeriodMeasure" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}MeasureType" minOccurs="0"/&gt;
 *         &lt;element name="BasisAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="CalculationPercent" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}PercentType" minOccurs="0"/&gt;
 *         &lt;element name="ActualDiscountAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradePaymentDiscountTermsType", propOrder = {
		"basisDateTime",
		"basisPeriodMeasure",
		"basisAmount",
		"calculationPercent",
		"actualDiscountAmount"
})
public class TradePaymentDiscountTermsType {

	@XmlElement(name = "BasisDateTime")
	protected DateTimeType basisDateTime;
	@XmlElement(name = "BasisPeriodMeasure")
	protected MeasureType basisPeriodMeasure;
	@XmlElement(name = "BasisAmount")
	protected List<AmountType> basisAmount;
	@XmlElement(name = "CalculationPercent")
	protected PercentType calculationPercent;
	@XmlElement(name = "ActualDiscountAmount")
	protected List<AmountType> actualDiscountAmount;


	/**
	 * Ruft den Wert der basisDateTime-Eigenschaft ab.
	 *
	 * @return possible object is {@link DateTimeType }
	 */
	public DateTimeType getBasisDateTime() {
		return basisDateTime;
	}


	/**
	 * Legt den Wert der basisDateTime-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DateTimeType }
	 */
	public void setBasisDateTime(DateTimeType value) {
		basisDateTime = value;
	}


	/**
	 * Ruft den Wert der basisPeriodMeasure-Eigenschaft ab.
	 *
	 * @return possible object is {@link MeasureType }
	 */
	public MeasureType getBasisPeriodMeasure() {
		return basisPeriodMeasure;
	}


	/**
	 * Legt den Wert der basisPeriodMeasure-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link MeasureType }
	 */
	public void setBasisPeriodMeasure(MeasureType value) {
		basisPeriodMeasure = value;
	}


	/**
	 * Gets the value of the basisAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the basisAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getBasisAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getBasisAmount() {
		if (basisAmount == null) {
			basisAmount = new ArrayList<>();
		}
		return basisAmount;
	}


	/**
	 * Ruft den Wert der calculationPercent-Eigenschaft ab.
	 *
	 * @return possible object is {@link PercentType }
	 */
	public PercentType getCalculationPercent() {
		return calculationPercent;
	}


	/**
	 * Legt den Wert der calculationPercent-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link PercentType }
	 */
	public void setCalculationPercent(PercentType value) {
		calculationPercent = value;
	}


	/**
	 * Gets the value of the actualDiscountAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the actualDiscountAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getActualDiscountAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getActualDiscountAmount() {
		if (actualDiscountAmount == null) {
			actualDiscountAmount = new ArrayList<>();
		}
		return actualDiscountAmount;
	}

}
