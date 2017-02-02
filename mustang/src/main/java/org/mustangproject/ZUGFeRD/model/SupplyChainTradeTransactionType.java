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
 * Java-Klasse f�r SupplyChainTradeTransactionType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="SupplyChainTradeTransactionType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ApplicableSupplyChainTradeAgreement" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeAgreementType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ApplicableSupplyChainTradeDelivery" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeDeliveryType" minOccurs="0"/&gt;
 *         &lt;element name="ApplicableSupplyChainTradeSettlement" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeSettlementType" minOccurs="0"/&gt;
 *         &lt;element name="IncludedSupplyChainTradeLineItem" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeLineItemType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SupplyChainTradeTransactionType", propOrder = {
		"applicableSupplyChainTradeAgreement",
		"applicableSupplyChainTradeDelivery",
		"applicableSupplyChainTradeSettlement",
		"includedSupplyChainTradeLineItem"
})
public class SupplyChainTradeTransactionType {

	@XmlElement(name = "ApplicableSupplyChainTradeAgreement")
	protected List<SupplyChainTradeAgreementType> applicableSupplyChainTradeAgreement;
	@XmlElement(name = "ApplicableSupplyChainTradeDelivery")
	protected SupplyChainTradeDeliveryType applicableSupplyChainTradeDelivery;
	@XmlElement(name = "ApplicableSupplyChainTradeSettlement")
	protected SupplyChainTradeSettlementType applicableSupplyChainTradeSettlement;
	@XmlElement(name = "IncludedSupplyChainTradeLineItem")
	protected List<SupplyChainTradeLineItemType> includedSupplyChainTradeLineItem;


	/**
	 * Gets the value of the applicableSupplyChainTradeAgreement property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the applicableSupplyChainTradeAgreement property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getApplicableSupplyChainTradeAgreement().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link SupplyChainTradeAgreementType }
	 */
	public List<SupplyChainTradeAgreementType> getApplicableSupplyChainTradeAgreement() {
		if (applicableSupplyChainTradeAgreement == null) {
			applicableSupplyChainTradeAgreement = new ArrayList<>();
		}
		return applicableSupplyChainTradeAgreement;
	}


	/**
	 * Ruft den Wert der applicableSupplyChainTradeDelivery-Eigenschaft ab.
	 *
	 * @return possible object is {@link SupplyChainTradeDeliveryType }
	 */
	public SupplyChainTradeDeliveryType getApplicableSupplyChainTradeDelivery() {
		return applicableSupplyChainTradeDelivery;
	}


	/**
	 * Legt den Wert der applicableSupplyChainTradeDelivery-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link SupplyChainTradeDeliveryType }
	 */
	public void setApplicableSupplyChainTradeDelivery(SupplyChainTradeDeliveryType value) {
		applicableSupplyChainTradeDelivery = value;
	}


	/**
	 * Ruft den Wert der applicableSupplyChainTradeSettlement-Eigenschaft ab.
	 *
	 * @return possible object is {@link SupplyChainTradeSettlementType }
	 */
	public SupplyChainTradeSettlementType getApplicableSupplyChainTradeSettlement() {
		return applicableSupplyChainTradeSettlement;
	}


	/**
	 * Legt den Wert der applicableSupplyChainTradeSettlement-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link SupplyChainTradeSettlementType }
	 */
	public void setApplicableSupplyChainTradeSettlement(SupplyChainTradeSettlementType value) {
		applicableSupplyChainTradeSettlement = value;
	}


	/**
	 * Gets the value of the includedSupplyChainTradeLineItem property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the includedSupplyChainTradeLineItem property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getIncludedSupplyChainTradeLineItem().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link SupplyChainTradeLineItemType }
	 */
	public List<SupplyChainTradeLineItemType> getIncludedSupplyChainTradeLineItem() {
		if (includedSupplyChainTradeLineItem == null) {
			includedSupplyChainTradeLineItem = new ArrayList<>();
		}
		return includedSupplyChainTradeLineItem;
	}

}
