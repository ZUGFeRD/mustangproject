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
 * Java-Klasse f�r SupplyChainTradeDeliveryType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="SupplyChainTradeDeliveryType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="BilledQuantity" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}QuantityType" minOccurs="0"/&gt;
 *         &lt;element name="ChargeFreeQuantity" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}QuantityType" minOccurs="0"/&gt;
 *         &lt;element name="PackageQuantity" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}QuantityType" minOccurs="0"/&gt;
 *         &lt;element name="RelatedSupplyChainConsignment" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainConsignmentType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ShipToTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="UltimateShipToTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="ShipFromTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="ActualDeliverySupplyChainEvent" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainEventType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="DespatchAdviceReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" minOccurs="0"/&gt;
 *         &lt;element name="ReceivingAdviceReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="DeliveryNoteReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SupplyChainTradeDeliveryType", propOrder = {
		"billedQuantity",
		"chargeFreeQuantity",
		"packageQuantity",
		"relatedSupplyChainConsignment",
		"shipToTradeParty",
		"ultimateShipToTradeParty",
		"shipFromTradeParty",
		"actualDeliverySupplyChainEvent",
		"despatchAdviceReferencedDocument",
		"receivingAdviceReferencedDocument",
		"deliveryNoteReferencedDocument"
})
public class SupplyChainTradeDeliveryType {

	@XmlElement(name = "BilledQuantity")
	protected QuantityType billedQuantity;
	@XmlElement(name = "ChargeFreeQuantity")
	protected QuantityType chargeFreeQuantity;
	@XmlElement(name = "PackageQuantity")
	protected QuantityType packageQuantity;
	@XmlElement(name = "RelatedSupplyChainConsignment")
	protected List<SupplyChainConsignmentType> relatedSupplyChainConsignment;
	@XmlElement(name = "ShipToTradeParty")
	protected TradePartyType shipToTradeParty;
	@XmlElement(name = "UltimateShipToTradeParty")
	protected TradePartyType ultimateShipToTradeParty;
	@XmlElement(name = "ShipFromTradeParty")
	protected TradePartyType shipFromTradeParty;
	@XmlElement(name = "ActualDeliverySupplyChainEvent")
	protected List<SupplyChainEventType> actualDeliverySupplyChainEvent;
	@XmlElement(name = "DespatchAdviceReferencedDocument")
	protected ReferencedDocumentType despatchAdviceReferencedDocument;
	@XmlElement(name = "ReceivingAdviceReferencedDocument")
	protected List<ReferencedDocumentType> receivingAdviceReferencedDocument;
	@XmlElement(name = "DeliveryNoteReferencedDocument")
	protected ReferencedDocumentType deliveryNoteReferencedDocument;


	/**
	 * Ruft den Wert der billedQuantity-Eigenschaft ab.
	 *
	 * @return possible object is {@link QuantityType }
	 */
	public QuantityType getBilledQuantity() {
		return billedQuantity;
	}


	/**
	 * Legt den Wert der billedQuantity-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link QuantityType }
	 */
	public void setBilledQuantity(QuantityType value) {
		billedQuantity = value;
	}


	/**
	 * Ruft den Wert der chargeFreeQuantity-Eigenschaft ab.
	 *
	 * @return possible object is {@link QuantityType }
	 */
	public QuantityType getChargeFreeQuantity() {
		return chargeFreeQuantity;
	}


	/**
	 * Legt den Wert der chargeFreeQuantity-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link QuantityType }
	 */
	public void setChargeFreeQuantity(QuantityType value) {
		chargeFreeQuantity = value;
	}


	/**
	 * Ruft den Wert der packageQuantity-Eigenschaft ab.
	 *
	 * @return possible object is {@link QuantityType }
	 */
	public QuantityType getPackageQuantity() {
		return packageQuantity;
	}


	/**
	 * Legt den Wert der packageQuantity-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link QuantityType }
	 */
	public void setPackageQuantity(QuantityType value) {
		packageQuantity = value;
	}


	/**
	 * Gets the value of the relatedSupplyChainConsignment property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the relatedSupplyChainConsignment property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getRelatedSupplyChainConsignment().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link SupplyChainConsignmentType }
	 */
	public List<SupplyChainConsignmentType> getRelatedSupplyChainConsignment() {
		if (relatedSupplyChainConsignment == null) {
			relatedSupplyChainConsignment = new ArrayList<>();
		}
		return relatedSupplyChainConsignment;
	}


	/**
	 * Ruft den Wert der shipToTradeParty-Eigenschaft ab.
	 *
	 * @return possible object is {@link TradePartyType }
	 */
	public TradePartyType getShipToTradeParty() {
		return shipToTradeParty;
	}


	/**
	 * Legt den Wert der shipToTradeParty-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TradePartyType }
	 */
	public void setShipToTradeParty(TradePartyType value) {
		shipToTradeParty = value;
	}


	/**
	 * Ruft den Wert der ultimateShipToTradeParty-Eigenschaft ab.
	 *
	 * @return possible object is {@link TradePartyType }
	 */
	public TradePartyType getUltimateShipToTradeParty() {
		return ultimateShipToTradeParty;
	}


	/**
	 * Legt den Wert der ultimateShipToTradeParty-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TradePartyType }
	 */
	public void setUltimateShipToTradeParty(TradePartyType value) {
		ultimateShipToTradeParty = value;
	}


	/**
	 * Ruft den Wert der shipFromTradeParty-Eigenschaft ab.
	 *
	 * @return possible object is {@link TradePartyType }
	 */
	public TradePartyType getShipFromTradeParty() {
		return shipFromTradeParty;
	}


	/**
	 * Legt den Wert der shipFromTradeParty-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TradePartyType }
	 */
	public void setShipFromTradeParty(TradePartyType value) {
		shipFromTradeParty = value;
	}


	/**
	 * Gets the value of the actualDeliverySupplyChainEvent property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the actualDeliverySupplyChainEvent property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getActualDeliverySupplyChainEvent().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link SupplyChainEventType }
	 */
	public List<SupplyChainEventType> getActualDeliverySupplyChainEvent() {
		if (actualDeliverySupplyChainEvent == null) {
			actualDeliverySupplyChainEvent = new ArrayList<>();
		}
		return actualDeliverySupplyChainEvent;
	}


	/**
	 * Ruft den Wert der despatchAdviceReferencedDocument-Eigenschaft ab.
	 *
	 * @return possible object is {@link ReferencedDocumentType }
	 */
	public ReferencedDocumentType getDespatchAdviceReferencedDocument() {
		return despatchAdviceReferencedDocument;
	}


	/**
	 * Legt den Wert der despatchAdviceReferencedDocument-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link ReferencedDocumentType }
	 */
	public void setDespatchAdviceReferencedDocument(ReferencedDocumentType value) {
		despatchAdviceReferencedDocument = value;
	}


	/**
	 * Gets the value of the receivingAdviceReferencedDocument property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the receivingAdviceReferencedDocument property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getReceivingAdviceReferencedDocument().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link ReferencedDocumentType }
	 */
	public List<ReferencedDocumentType> getReceivingAdviceReferencedDocument() {
		if (receivingAdviceReferencedDocument == null) {
			receivingAdviceReferencedDocument = new ArrayList<>();
		}
		return receivingAdviceReferencedDocument;
	}


	/**
	 * Ruft den Wert der deliveryNoteReferencedDocument-Eigenschaft ab.
	 *
	 * @return possible object is {@link ReferencedDocumentType }
	 */
	public ReferencedDocumentType getDeliveryNoteReferencedDocument() {
		return deliveryNoteReferencedDocument;
	}


	/**
	 * Legt den Wert der deliveryNoteReferencedDocument-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link ReferencedDocumentType }
	 */
	public void setDeliveryNoteReferencedDocument(ReferencedDocumentType value) {
		deliveryNoteReferencedDocument = value;
	}

}
