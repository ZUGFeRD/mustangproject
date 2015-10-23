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
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java-Klasse f�r CrossIndustryDocumentType complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * &lt;complexType name="CrossIndustryDocumentType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="SpecifiedExchangedDocumentContext" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ExchangedDocumentContextType"/&gt;
 *         &lt;element name="HeaderExchangedDocument" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}ExchangedDocumentType"/&gt;
 *         &lt;element name="SpecifiedSupplyChainTradeTransaction" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SupplyChainTradeTransactionType"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name="CrossIndustryDocumentType", namespace="urn:ferd:CrossIndustryDocument:invoice:1p0")
@XmlType(name = "CrossIndustryDocumentType", namespace = "urn:ferd:CrossIndustryDocument:invoice:1p0", propOrder = {
    "specifiedExchangedDocumentContext",
    "headerExchangedDocument",
    "specifiedSupplyChainTradeTransaction"
})
public class CrossIndustryDocumentType {

    @XmlElement(name = "SpecifiedExchangedDocumentContext", required = true)
    protected ExchangedDocumentContextType specifiedExchangedDocumentContext;
    @XmlElement(name = "HeaderExchangedDocument", required = true)
    protected ExchangedDocumentType headerExchangedDocument;
    @XmlElement(name = "SpecifiedSupplyChainTradeTransaction", required = true)
    protected SupplyChainTradeTransactionType specifiedSupplyChainTradeTransaction;

    /**
     * Ruft den Wert der specifiedExchangedDocumentContext-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link ExchangedDocumentContextType }
     *     
     */
    public ExchangedDocumentContextType getSpecifiedExchangedDocumentContext() {
        return specifiedExchangedDocumentContext;
    }

    /**
     * Legt den Wert der specifiedExchangedDocumentContext-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link ExchangedDocumentContextType }
     *     
     */
    public void setSpecifiedExchangedDocumentContext(ExchangedDocumentContextType value) {
        this.specifiedExchangedDocumentContext = value;
    }

    /**
     * Ruft den Wert der headerExchangedDocument-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link ExchangedDocumentType }
     *     
     */
    public ExchangedDocumentType getHeaderExchangedDocument() {
        return headerExchangedDocument;
    }

    /**
     * Legt den Wert der headerExchangedDocument-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link ExchangedDocumentType }
     *     
     */
    public void setHeaderExchangedDocument(ExchangedDocumentType value) {
        this.headerExchangedDocument = value;
    }

    /**
     * Ruft den Wert der specifiedSupplyChainTradeTransaction-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link SupplyChainTradeTransactionType }
     *     
     */
    public SupplyChainTradeTransactionType getSpecifiedSupplyChainTradeTransaction() {
        return specifiedSupplyChainTradeTransaction;
    }

    /**
     * Legt den Wert der specifiedSupplyChainTradeTransaction-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link SupplyChainTradeTransactionType }
     *     
     */
    public void setSpecifiedSupplyChainTradeTransaction(SupplyChainTradeTransactionType value) {
        this.specifiedSupplyChainTradeTransaction = value;
    }

}
