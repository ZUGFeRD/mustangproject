//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a>
// �nderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren.
// Generiert: 2015.10.16 um 06:16:03 PM CEST
//


package org.mustangproject.ZUGFeRD.model;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>
 * Java-Klasse f�r SupplyChainTradeLineItemType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="SupplyChainTradeLineItemType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="AssociatedDocumentLineDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}DocumentLineDocumentType" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedSupplyChainTradeAgreement" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeAgreementType" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedSupplyChainTradeDelivery" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeDeliveryType" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedSupplyChainTradeSettlement" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeSettlementType" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedTradeProduct" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeProductType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SupplyChainTradeLineItemType", propOrder = {
		"associatedDocumentLineDocument",
		"specifiedSupplyChainTradeAgreement",
		"specifiedSupplyChainTradeDelivery",
		"specifiedSupplyChainTradeSettlement",
		"specifiedTradeProduct"
})
public class SupplyChainTradeLineItemType {

	@XmlElement(name = "AssociatedDocumentLineDocument")
	protected DocumentLineDocumentType associatedDocumentLineDocument;
	@XmlElement(name = "SpecifiedSupplyChainTradeAgreement")
	protected SupplyChainTradeAgreementType specifiedSupplyChainTradeAgreement;
	@XmlElement(name = "SpecifiedSupplyChainTradeDelivery")
	protected SupplyChainTradeDeliveryType specifiedSupplyChainTradeDelivery;
	@XmlElement(name = "SpecifiedSupplyChainTradeSettlement")
	protected SupplyChainTradeSettlementType specifiedSupplyChainTradeSettlement;
	@XmlElement(name = "SpecifiedTradeProduct")
	protected TradeProductType specifiedTradeProduct;


	/**
	 * Ruft den Wert der associatedDocumentLineDocument-Eigenschaft ab.
	 *
	 * @return possible object is {@link DocumentLineDocumentType }
	 */
	public DocumentLineDocumentType getAssociatedDocumentLineDocument() {
		return associatedDocumentLineDocument;
	}


	/**
	 * Legt den Wert der associatedDocumentLineDocument-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DocumentLineDocumentType }
	 */
	public void setAssociatedDocumentLineDocument(DocumentLineDocumentType value) {
		associatedDocumentLineDocument = value;
	}


	/**
	 * Ruft den Wert der specifiedSupplyChainTradeAgreement-Eigenschaft ab.
	 *
	 * @return possible object is {@link SupplyChainTradeAgreementType }
	 */
	public SupplyChainTradeAgreementType getSpecifiedSupplyChainTradeAgreement() {
		return specifiedSupplyChainTradeAgreement;
	}


	/**
	 * Legt den Wert der specifiedSupplyChainTradeAgreement-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link SupplyChainTradeAgreementType }
	 */
	public void setSpecifiedSupplyChainTradeAgreement(SupplyChainTradeAgreementType value) {
		specifiedSupplyChainTradeAgreement = value;
	}


	/**
	 * Ruft den Wert der specifiedSupplyChainTradeDelivery-Eigenschaft ab.
	 *
	 * @return possible object is {@link SupplyChainTradeDeliveryType }
	 */
	public SupplyChainTradeDeliveryType getSpecifiedSupplyChainTradeDelivery() {
		return specifiedSupplyChainTradeDelivery;
	}


	/**
	 * Legt den Wert der specifiedSupplyChainTradeDelivery-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link SupplyChainTradeDeliveryType }
	 */
	public void setSpecifiedSupplyChainTradeDelivery(SupplyChainTradeDeliveryType value) {
		specifiedSupplyChainTradeDelivery = value;
	}


	/**
	 * Ruft den Wert der specifiedSupplyChainTradeSettlement-Eigenschaft ab.
	 *
	 * @return possible object is {@link SupplyChainTradeSettlementType }
	 */
	public SupplyChainTradeSettlementType getSpecifiedSupplyChainTradeSettlement() {
		return specifiedSupplyChainTradeSettlement;
	}


	/**
	 * Legt den Wert der specifiedSupplyChainTradeSettlement-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link SupplyChainTradeSettlementType }
	 */
	public void setSpecifiedSupplyChainTradeSettlement(SupplyChainTradeSettlementType value) {
		specifiedSupplyChainTradeSettlement = value;
	}


	/**
	 * Ruft den Wert der specifiedTradeProduct-Eigenschaft ab.
	 *
	 * @return possible object is {@link TradeProductType }
	 */
	public TradeProductType getSpecifiedTradeProduct() {
		return specifiedTradeProduct;
	}


	/**
	 * Legt den Wert der specifiedTradeProduct-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TradeProductType }
	 */
	public void setSpecifiedTradeProduct(TradeProductType value) {
		specifiedTradeProduct = value;
	}

}
