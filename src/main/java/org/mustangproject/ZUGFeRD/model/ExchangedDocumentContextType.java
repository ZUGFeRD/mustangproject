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
 * <p>Java-Klasse f�r ExchangedDocumentContextType complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * &lt;complexType name="ExchangedDocumentContextType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="TestIndicator" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IndicatorType" minOccurs="0"/&gt;
 *         &lt;element name="BusinessProcessSpecifiedDocumentContextParameter" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}DocumentContextParameterType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="GuidelineSpecifiedDocumentContextParameter" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}DocumentContextParameterType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ExchangedDocumentContextType", propOrder = {
    "testIndicator",
    "businessProcessSpecifiedDocumentContextParameter",
    "guidelineSpecifiedDocumentContextParameter"
})
public class ExchangedDocumentContextType {

    @XmlElement(name = "TestIndicator")
    protected IndicatorType testIndicator;
    @XmlElement(name = "BusinessProcessSpecifiedDocumentContextParameter")
    protected List<DocumentContextParameterType> businessProcessSpecifiedDocumentContextParameter;
    @XmlElement(name = "GuidelineSpecifiedDocumentContextParameter")
    protected List<DocumentContextParameterType> guidelineSpecifiedDocumentContextParameter;

    /**
     * Ruft den Wert der testIndicator-Eigenschaft ab.
     * 
     * @return IndicatorType
     *     
     */
    public IndicatorType getTestIndicator() {
        return testIndicator;
    }

    /**
     * Legt den Wert der testIndicator-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link IndicatorType }
     *     
     */
    public void setTestIndicator(IndicatorType value) {
        this.testIndicator = value;
    }

    /**
     * Gets the value of the businessProcessSpecifiedDocumentContextParameter property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the businessProcessSpecifiedDocumentContextParameter property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getBusinessProcessSpecifiedDocumentContextParameter().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DocumentContextParameterType }
     * 
     * 
     */
    public List<DocumentContextParameterType> getBusinessProcessSpecifiedDocumentContextParameter() {
        if (businessProcessSpecifiedDocumentContextParameter == null) {
            businessProcessSpecifiedDocumentContextParameter = new ArrayList<DocumentContextParameterType>();
        }
        return this.businessProcessSpecifiedDocumentContextParameter;
    }

    /**
     * Gets the value of the guidelineSpecifiedDocumentContextParameter property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the guidelineSpecifiedDocumentContextParameter property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getGuidelineSpecifiedDocumentContextParameter().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DocumentContextParameterType }
     * 
     * 
     */
    public List<DocumentContextParameterType> getGuidelineSpecifiedDocumentContextParameter() {
        if (guidelineSpecifiedDocumentContextParameter == null) {
            guidelineSpecifiedDocumentContextParameter = new ArrayList<DocumentContextParameterType>();
        }
        return this.guidelineSpecifiedDocumentContextParameter;
    }

}
