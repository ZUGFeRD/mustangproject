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
 * Java-Klasse f�r ExchangedDocumentType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="ExchangedDocumentType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="ID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" minOccurs="0"/&gt;
 *         &lt;element name="Name" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="TypeCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}DocumentCodeType" minOccurs="0"/&gt;
 *         &lt;element name="IssueDateTime" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}DateTimeType" minOccurs="0"/&gt;
 *         &lt;element name="CopyIndicator" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IndicatorType" minOccurs="0"/&gt;
 *         &lt;element name="LanguageID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="IncludedNote" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}NoteType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="EffectiveSpecifiedPeriod" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SpecifiedPeriodType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ExchangedDocumentType", propOrder = {
		"id",
		"name",
		"typeCode",
		"issueDateTime",
		"copyIndicator",
		"languageID",
		"includedNote",
		"effectiveSpecifiedPeriod"
})
public class ExchangedDocumentType {

	@XmlElement(name = "ID")
	protected IDType id;
	@XmlElement(name = "Name")
	protected List<TextType> name;
	@XmlElement(name = "TypeCode")
	protected DocumentCodeType typeCode;
	@XmlElement(name = "IssueDateTime")
	protected DateTimeType issueDateTime;
	@XmlElement(name = "CopyIndicator")
	protected IndicatorType copyIndicator;
	@XmlElement(name = "LanguageID")
	protected List<IDType> languageID;
	@XmlElement(name = "IncludedNote")
	protected List<NoteType> includedNote;
	@XmlElement(name = "EffectiveSpecifiedPeriod")
	protected SpecifiedPeriodType effectiveSpecifiedPeriod;


	/**
	 * Ruft den Wert der id-Eigenschaft ab.
	 *
	 * @return possible object is {@link IDType }
	 */
	public IDType getID() {
		return id;
	}


	/**
	 * Legt den Wert der id-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link IDType }
	 */
	public void setID(IDType value) {
		id = value;
	}


	/**
	 * Gets the value of the name property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the name property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getName().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TextType }
	 */
	public List<TextType> getName() {
		if (name == null) {
			name = new ArrayList<>();
		}
		return name;
	}


	/**
	 * Ruft den Wert der typeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link DocumentCodeType }
	 */
	public DocumentCodeType getTypeCode() {
		return typeCode;
	}


	/**
	 * Legt den Wert der typeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DocumentCodeType }
	 */
	public void setTypeCode(DocumentCodeType value) {
		typeCode = value;
	}


	/**
	 * Ruft den Wert der issueDateTime-Eigenschaft ab.
	 *
	 * @return possible object is {@link DateTimeType }
	 */
	public DateTimeType getIssueDateTime() {
		return issueDateTime;
	}


	/**
	 * Legt den Wert der issueDateTime-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DateTimeType }
	 */
	public void setIssueDateTime(DateTimeType value) {
		issueDateTime = value;
	}


	/**
	 * Ruft den Wert der copyIndicator-Eigenschaft ab.
	 *
	 * @return possible object is {@link IndicatorType }
	 */
	public IndicatorType getCopyIndicator() {
		return copyIndicator;
	}


	/**
	 * Legt den Wert der copyIndicator-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link IndicatorType }
	 */
	public void setCopyIndicator(IndicatorType value) {
		copyIndicator = value;
	}


	/**
	 * Gets the value of the languageID property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the languageID property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getLanguageID().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link IDType }
	 */
	public List<IDType> getLanguageID() {
		if (languageID == null) {
			languageID = new ArrayList<>();
		}
		return languageID;
	}


	/**
	 * Gets the value of the includedNote property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the includedNote property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getIncludedNote().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link NoteType }
	 */
	public List<NoteType> getIncludedNote() {
		if (includedNote == null) {
			includedNote = new ArrayList<>();
		}
		return includedNote;
	}


	/**
	 * Ruft den Wert der effectiveSpecifiedPeriod-Eigenschaft ab.
	 *
	 * @return possible object is {@link SpecifiedPeriodType }
	 */
	public SpecifiedPeriodType getEffectiveSpecifiedPeriod() {
		return effectiveSpecifiedPeriod;
	}


	/**
	 * Legt den Wert der effectiveSpecifiedPeriod-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link SpecifiedPeriodType }
	 */
	public void setEffectiveSpecifiedPeriod(SpecifiedPeriodType value) {
		effectiveSpecifiedPeriod = value;
	}

}
