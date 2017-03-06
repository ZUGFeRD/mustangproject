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
 * Java-Klasse f�r TradeTaxType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradeTaxType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="CalculatedAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="TypeCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}TaxTypeCodeType" minOccurs="0"/&gt;
 *         &lt;element name="ExemptionReason" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" minOccurs="0"/&gt;
 *         &lt;element name="BasisAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="LineTotalBasisAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="AllowanceChargeBasisAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="CategoryCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}TaxCategoryCodeType" minOccurs="0"/&gt;
 *         &lt;element name="ApplicablePercent" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}PercentType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradeTaxType", propOrder = {
		"calculatedAmount",
		"typeCode",
		"exemptionReason",
		"basisAmount",
		"lineTotalBasisAmount",
		"allowanceChargeBasisAmount",
		"categoryCode",
		"applicablePercent"
})
public class TradeTaxType {

	@XmlElement(name = "CalculatedAmount")
	protected List<AmountType> calculatedAmount;
	@XmlElement(name = "TypeCode")
	protected TaxTypeCodeType typeCode;
	@XmlElement(name = "ExemptionReason")
	protected TextType exemptionReason;
	@XmlElement(name = "BasisAmount")
	protected List<AmountType> basisAmount;
	@XmlElement(name = "LineTotalBasisAmount")
	protected List<AmountType> lineTotalBasisAmount;
	@XmlElement(name = "AllowanceChargeBasisAmount")
	protected List<AmountType> allowanceChargeBasisAmount;
	@XmlElement(name = "CategoryCode")
	protected TaxCategoryCodeType categoryCode;
	@XmlElement(name = "ApplicablePercent")
	protected PercentType applicablePercent;


	/**
	 * Gets the value of the calculatedAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the calculatedAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getCalculatedAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getCalculatedAmount() {
		if (calculatedAmount == null) {
			calculatedAmount = new ArrayList<>();
		}
		return calculatedAmount;
	}


	/**
	 * Ruft den Wert der typeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link TaxTypeCodeType }
	 */
	public TaxTypeCodeType getTypeCode() {
		return typeCode;
	}


	/**
	 * Legt den Wert der typeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TaxTypeCodeType }
	 */
	public void setTypeCode(TaxTypeCodeType value) {
		typeCode = value;
	}


	/**
	 * Ruft den Wert der exemptionReason-Eigenschaft ab.
	 *
	 * @return possible object is {@link TextType }
	 */
	public TextType getExemptionReason() {
		return exemptionReason;
	}


	/**
	 * Legt den Wert der exemptionReason-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TextType }
	 */
	public void setExemptionReason(TextType value) {
		exemptionReason = value;
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
	 * Gets the value of the lineTotalBasisAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the lineTotalBasisAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getLineTotalBasisAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getLineTotalBasisAmount() {
		if (lineTotalBasisAmount == null) {
			lineTotalBasisAmount = new ArrayList<>();
		}
		return lineTotalBasisAmount;
	}


	/**
	 * Gets the value of the allowanceChargeBasisAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the allowanceChargeBasisAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getAllowanceChargeBasisAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getAllowanceChargeBasisAmount() {
		if (allowanceChargeBasisAmount == null) {
			allowanceChargeBasisAmount = new ArrayList<>();
		}
		return allowanceChargeBasisAmount;
	}


	/**
	 * Ruft den Wert der categoryCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link TaxCategoryCodeType }
	 */
	public TaxCategoryCodeType getCategoryCode() {
		return categoryCode;
	}


	/**
	 * Legt den Wert der categoryCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TaxCategoryCodeType }
	 */
	public void setCategoryCode(TaxCategoryCodeType value) {
		categoryCode = value;
	}


	/**
	 * Ruft den Wert der applicablePercent-Eigenschaft ab.
	 *
	 * @return possible object is {@link PercentType }
	 */
	public PercentType getApplicablePercent() {
		return applicablePercent;
	}


	/**
	 * Legt den Wert der applicablePercent-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link PercentType }
	 */
	public void setApplicablePercent(PercentType value) {
		applicablePercent = value;
	}

}
