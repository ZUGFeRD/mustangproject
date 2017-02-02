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
 * Java-Klasse f�r TradePaymentTermsType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradePaymentTermsType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="Description" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="DueDateDateTime" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}DateTimeType" minOccurs="0"/&gt;
 *         &lt;element name="PartialPaymentAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ApplicableTradePaymentPenaltyTerms" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePaymentPenaltyTermsType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ApplicableTradePaymentDiscountTerms" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePaymentDiscountTermsType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradePaymentTermsType", propOrder = {
		"description",
		"dueDateDateTime",
		"partialPaymentAmount",
		"applicableTradePaymentPenaltyTerms",
		"applicableTradePaymentDiscountTerms"
})
public class TradePaymentTermsType {

	@XmlElement(name = "Description")
	protected List<TextType> description;
	@XmlElement(name = "DueDateDateTime")
	protected DateTimeType dueDateDateTime;
	@XmlElement(name = "PartialPaymentAmount")
	protected List<AmountType> partialPaymentAmount;
	@XmlElement(name = "ApplicableTradePaymentPenaltyTerms")
	protected List<TradePaymentPenaltyTermsType> applicableTradePaymentPenaltyTerms;
	@XmlElement(name = "ApplicableTradePaymentDiscountTerms")
	protected List<TradePaymentDiscountTermsType> applicableTradePaymentDiscountTerms;


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
	 * Ruft den Wert der dueDateDateTime-Eigenschaft ab.
	 *
	 * @return possible object is {@link DateTimeType }
	 */
	public DateTimeType getDueDateDateTime() {
		return dueDateDateTime;
	}


	/**
	 * Legt den Wert der dueDateDateTime-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DateTimeType }
	 */
	public void setDueDateDateTime(DateTimeType value) {
		dueDateDateTime = value;
	}


	/**
	 * Gets the value of the partialPaymentAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the partialPaymentAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getPartialPaymentAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getPartialPaymentAmount() {
		if (partialPaymentAmount == null) {
			partialPaymentAmount = new ArrayList<>();
		}
		return partialPaymentAmount;
	}


	/**
	 * Gets the value of the applicableTradePaymentPenaltyTerms property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the applicableTradePaymentPenaltyTerms property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getApplicableTradePaymentPenaltyTerms().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradePaymentPenaltyTermsType }
	 */
	public List<TradePaymentPenaltyTermsType> getApplicableTradePaymentPenaltyTerms() {
		if (applicableTradePaymentPenaltyTerms == null) {
			applicableTradePaymentPenaltyTerms = new ArrayList<>();
		}
		return applicableTradePaymentPenaltyTerms;
	}


	/**
	 * Gets the value of the applicableTradePaymentDiscountTerms property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the applicableTradePaymentDiscountTerms property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getApplicableTradePaymentDiscountTerms().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradePaymentDiscountTermsType }
	 */
	public List<TradePaymentDiscountTermsType> getApplicableTradePaymentDiscountTerms() {
		if (applicableTradePaymentDiscountTerms == null) {
			applicableTradePaymentDiscountTerms = new ArrayList<>();
		}
		return applicableTradePaymentDiscountTerms;
	}

}
