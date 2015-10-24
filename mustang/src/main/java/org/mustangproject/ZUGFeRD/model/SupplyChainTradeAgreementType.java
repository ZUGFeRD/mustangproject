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
 * <p>Java-Klasse f�r SupplyChainTradeAgreementType complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * &lt;complexType name="SupplyChainTradeAgreementType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="BuyerReference" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SellerTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="BuyerTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="ProductEndUserTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="ApplicableTradeDeliveryTerms" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeDeliveryTermsType" minOccurs="0"/&gt;
 *         &lt;element name="BuyerOrderReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ContractReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="AdditionalReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="GrossPriceProductTradePrice" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePriceType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="NetPriceProductTradePrice" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePriceType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="CustomerOrderReferencedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ReferencedDocumentType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SupplyChainTradeAgreementType", propOrder = {
    "buyerReference",
    "sellerTradeParty",
    "buyerTradeParty",
    "productEndUserTradeParty",
    "applicableTradeDeliveryTerms",
    "buyerOrderReferencedDocument",
    "contractReferencedDocument",
    "additionalReferencedDocument",
    "grossPriceProductTradePrice",
    "netPriceProductTradePrice",
    "customerOrderReferencedDocument"
})
public class SupplyChainTradeAgreementType {

    @XmlElement(name = "BuyerReference")
    protected List<TextType> buyerReference;
    @XmlElement(name = "SellerTradeParty")
    protected TradePartyType sellerTradeParty;
    @XmlElement(name = "BuyerTradeParty")
    protected TradePartyType buyerTradeParty;
    @XmlElement(name = "ProductEndUserTradeParty")
    protected TradePartyType productEndUserTradeParty;
    @XmlElement(name = "ApplicableTradeDeliveryTerms")
    protected TradeDeliveryTermsType applicableTradeDeliveryTerms;
    @XmlElement(name = "BuyerOrderReferencedDocument")
    protected List<ReferencedDocumentType> buyerOrderReferencedDocument;
    @XmlElement(name = "ContractReferencedDocument")
    protected List<ReferencedDocumentType> contractReferencedDocument;
    @XmlElement(name = "AdditionalReferencedDocument")
    protected List<ReferencedDocumentType> additionalReferencedDocument;
    @XmlElement(name = "GrossPriceProductTradePrice")
    protected List<TradePriceType> grossPriceProductTradePrice;
    @XmlElement(name = "NetPriceProductTradePrice")
    protected List<TradePriceType> netPriceProductTradePrice;
    @XmlElement(name = "CustomerOrderReferencedDocument")
    protected List<ReferencedDocumentType> customerOrderReferencedDocument;

    /**
     * Gets the value of the buyerReference property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the buyerReference property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getBuyerReference().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TextType }
     * 
     * 
     */
    public List<TextType> getBuyerReference() {
        if (buyerReference == null) {
            buyerReference = new ArrayList<TextType>();
        }
        return this.buyerReference;
    }

    /**
     * Ruft den Wert der sellerTradeParty-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link TradePartyType }
     *     
     */
    public TradePartyType getSellerTradeParty() {
        return sellerTradeParty;
    }

    /**
     * Legt den Wert der sellerTradeParty-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link TradePartyType }
     *     
     */
    public void setSellerTradeParty(TradePartyType value) {
        this.sellerTradeParty = value;
    }

    /**
     * Ruft den Wert der buyerTradeParty-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link TradePartyType }
     *     
     */
    public TradePartyType getBuyerTradeParty() {
        return buyerTradeParty;
    }

    /**
     * Legt den Wert der buyerTradeParty-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link TradePartyType }
     *     
     */
    public void setBuyerTradeParty(TradePartyType value) {
        this.buyerTradeParty = value;
    }

    /**
     * Ruft den Wert der productEndUserTradeParty-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link TradePartyType }
     *     
     */
    public TradePartyType getProductEndUserTradeParty() {
        return productEndUserTradeParty;
    }

    /**
     * Legt den Wert der productEndUserTradeParty-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link TradePartyType }
     *     
     */
    public void setProductEndUserTradeParty(TradePartyType value) {
        this.productEndUserTradeParty = value;
    }

    /**
     * Ruft den Wert der applicableTradeDeliveryTerms-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link TradeDeliveryTermsType }
     *     
     */
    public TradeDeliveryTermsType getApplicableTradeDeliveryTerms() {
        return applicableTradeDeliveryTerms;
    }

    /**
     * Legt den Wert der applicableTradeDeliveryTerms-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link TradeDeliveryTermsType }
     *     
     */
    public void setApplicableTradeDeliveryTerms(TradeDeliveryTermsType value) {
        this.applicableTradeDeliveryTerms = value;
    }

    /**
     * Gets the value of the buyerOrderReferencedDocument property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the buyerOrderReferencedDocument property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getBuyerOrderReferencedDocument().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ReferencedDocumentType }
     * 
     * 
     */
    public List<ReferencedDocumentType> getBuyerOrderReferencedDocument() {
        if (buyerOrderReferencedDocument == null) {
            buyerOrderReferencedDocument = new ArrayList<ReferencedDocumentType>();
        }
        return this.buyerOrderReferencedDocument;
    }

    /**
     * Gets the value of the contractReferencedDocument property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the contractReferencedDocument property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getContractReferencedDocument().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ReferencedDocumentType }
     * 
     * 
     */
    public List<ReferencedDocumentType> getContractReferencedDocument() {
        if (contractReferencedDocument == null) {
            contractReferencedDocument = new ArrayList<ReferencedDocumentType>();
        }
        return this.contractReferencedDocument;
    }

    /**
     * Gets the value of the additionalReferencedDocument property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the additionalReferencedDocument property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAdditionalReferencedDocument().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ReferencedDocumentType }
     * 
     * 
     */
    public List<ReferencedDocumentType> getAdditionalReferencedDocument() {
        if (additionalReferencedDocument == null) {
            additionalReferencedDocument = new ArrayList<ReferencedDocumentType>();
        }
        return this.additionalReferencedDocument;
    }

    /**
     * Gets the value of the grossPriceProductTradePrice property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the grossPriceProductTradePrice property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getGrossPriceProductTradePrice().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TradePriceType }
     * 
     * 
     */
    public List<TradePriceType> getGrossPriceProductTradePrice() {
        if (grossPriceProductTradePrice == null) {
            grossPriceProductTradePrice = new ArrayList<TradePriceType>();
        }
        return this.grossPriceProductTradePrice;
    }

    /**
     * Gets the value of the netPriceProductTradePrice property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the netPriceProductTradePrice property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getNetPriceProductTradePrice().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TradePriceType }
     * 
     * 
     */
    public List<TradePriceType> getNetPriceProductTradePrice() {
        if (netPriceProductTradePrice == null) {
            netPriceProductTradePrice = new ArrayList<TradePriceType>();
        }
        return this.netPriceProductTradePrice;
    }

    /**
     * Gets the value of the customerOrderReferencedDocument property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the customerOrderReferencedDocument property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getCustomerOrderReferencedDocument().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ReferencedDocumentType }
     * 
     * 
     */
    public List<ReferencedDocumentType> getCustomerOrderReferencedDocument() {
        if (customerOrderReferencedDocument == null) {
            customerOrderReferencedDocument = new ArrayList<ReferencedDocumentType>();
        }
        return this.customerOrderReferencedDocument;
    }

}
