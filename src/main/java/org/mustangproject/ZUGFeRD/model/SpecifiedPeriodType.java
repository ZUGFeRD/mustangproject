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
 * <p>Java-Klasse f�r SpecifiedPeriodType complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * <complexType name="SpecifiedPeriodType">
 *   <complexContent>
 *     <restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       <sequence>
 *         <element name="StartDateTime" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}DateTimeType" minOccurs="0"/>
 *         <element name="EndDateTime" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}DateTimeType" minOccurs="0"/>
 *         <element name="CompleteDateTime" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}DateTimeType" minOccurs="0"/>
 *       </sequence>
 *     </restriction>
 *   </complexContent>
 * </complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SpecifiedPeriodType", propOrder = {
    "startDateTime",
    "endDateTime",
    "completeDateTime"
})
public class SpecifiedPeriodType {

    @XmlElement(name = "StartDateTime")
    protected DateTimeType startDateTime;
    @XmlElement(name = "EndDateTime")
    protected DateTimeType endDateTime;
    @XmlElement(name = "CompleteDateTime")
    protected DateTimeType completeDateTime;

    /**
     * Ruft den Wert der startDateTime-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link DateTimeType }
     *     
     */
    public DateTimeType getStartDateTime() {
        return startDateTime;
    }

    /**
     * Legt den Wert der startDateTime-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link DateTimeType }
     *     
     */
    public void setStartDateTime(DateTimeType value) {
        this.startDateTime = value;
    }

    /**
     * Ruft den Wert der endDateTime-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link DateTimeType }
     *     
     */
    public DateTimeType getEndDateTime() {
        return endDateTime;
    }

    /**
     * Legt den Wert der endDateTime-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link DateTimeType }
     *     
     */
    public void setEndDateTime(DateTimeType value) {
        this.endDateTime = value;
    }

    /**
     * Ruft den Wert der completeDateTime-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link DateTimeType }
     *     
     */
    public DateTimeType getCompleteDateTime() {
        return completeDateTime;
    }

    /**
     * Legt den Wert der completeDateTime-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link DateTimeType }
     *     
     */
    public void setCompleteDateTime(DateTimeType value) {
        this.completeDateTime = value;
    }

}
