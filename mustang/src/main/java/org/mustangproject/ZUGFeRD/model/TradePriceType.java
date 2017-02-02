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
 * Java-Klasse f�r TradePriceType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradePriceType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ChargeAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="BasisQuantity" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}QuantityType" minOccurs="0"/&gt;
 *         &lt;element name="AppliedTradeAllowanceCharge" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeAllowanceChargeType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradePriceType", propOrder = {
		"chargeAmount",
		"basisQuantity",
		"appliedTradeAllowanceCharge"
})
public class TradePriceType {

	@XmlElement(name = "ChargeAmount")
	protected List<AmountType> chargeAmount;
	@XmlElement(name = "BasisQuantity")
	protected QuantityType basisQuantity;
	@XmlElement(name = "AppliedTradeAllowanceCharge")
	protected List<TradeAllowanceChargeType> appliedTradeAllowanceCharge;


	/**
	 * Gets the value of the chargeAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the chargeAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getChargeAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getChargeAmount() {
		if (chargeAmount == null) {
			chargeAmount = new ArrayList<>();
		}
		return chargeAmount;
	}


	/**
	 * Ruft den Wert der basisQuantity-Eigenschaft ab.
	 *
	 * @return possible object is {@link QuantityType }
	 */
	public QuantityType getBasisQuantity() {
		return basisQuantity;
	}


	/**
	 * Legt den Wert der basisQuantity-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link QuantityType }
	 */
	public void setBasisQuantity(QuantityType value) {
		basisQuantity = value;
	}


	/**
	 * Gets the value of the appliedTradeAllowanceCharge property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the appliedTradeAllowanceCharge property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getAppliedTradeAllowanceCharge().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradeAllowanceChargeType }
	 */
	public List<TradeAllowanceChargeType> getAppliedTradeAllowanceCharge() {
		if (appliedTradeAllowanceCharge == null) {
			appliedTradeAllowanceCharge = new ArrayList<>();
		}
		return appliedTradeAllowanceCharge;
	}

}
