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
 * <p>Java-Klasse f�r DebtorFinancialAccountType complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * &lt;complexType name="DebtorFinancialAccountType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="IBANID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *         &lt;element name="ProprietaryID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DebtorFinancialAccountType", propOrder = {
    "ibanid",
    "proprietaryID"
})
public class DebtorFinancialAccountType {

    @XmlElement(name = "IBANID")
    protected IDType ibanid;
    @XmlElement(name = "ProprietaryID")
    protected IDType proprietaryID;

    /**
     * Ruft den Wert der ibanid-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link IDType }
     *     
     */
    public IDType getIBANID() {
        return ibanid;
    }

    /**
     * Legt den Wert der ibanid-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link IDType }
     *     
     */
    public void setIBANID(IDType value) {
        this.ibanid = value;
    }

    /**
     * Ruft den Wert der proprietaryID-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link IDType }
     *     
     */
    public IDType getProprietaryID() {
        return proprietaryID;
    }

    /**
     * Legt den Wert der proprietaryID-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link IDType }
     *     
     */
    public void setProprietaryID(IDType value) {
        this.proprietaryID = value;
    }

}
