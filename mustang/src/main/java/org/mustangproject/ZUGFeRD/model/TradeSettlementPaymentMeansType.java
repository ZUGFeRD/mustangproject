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
 * Java-Klasse f�r TradeSettlementPaymentMeansType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradeSettlementPaymentMeansType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="TypeCode" type="{urn:un:unece:uncefact:data:standard:QualifiedDataType:12}PaymentMeansCodeType" minOccurs="0"/&gt;
 *         &lt;element name="Information" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ID" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}IDType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="PayerPartyDebtorFinancialAccount" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}DebtorFinancialAccountType" minOccurs="0"/&gt;
 *         &lt;element name="PayeePartyCreditorFinancialAccount" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}CreditorFinancialAccountType" minOccurs="0"/&gt;
 *         &lt;element name="PayerSpecifiedDebtorFinancialInstitution" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}DebtorFinancialInstitutionType" minOccurs="0"/&gt;
 *         &lt;element name="PayeeSpecifiedCreditorFinancialInstitution" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}CreditorFinancialInstitutionType" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradeSettlementPaymentMeansType", propOrder = {
		"typeCode",
		"information",
		"id",
		"payerPartyDebtorFinancialAccount",
		"payeePartyCreditorFinancialAccount",
		"payerSpecifiedDebtorFinancialInstitution",
		"payeeSpecifiedCreditorFinancialInstitution"
})
public class TradeSettlementPaymentMeansType {

	@XmlElement(name = "TypeCode")
	protected PaymentMeansCodeType typeCode;
	@XmlElement(name = "Information")
	protected List<TextType> information;
	@XmlElement(name = "ID")
	protected List<IDType> id;
	@XmlElement(name = "PayerPartyDebtorFinancialAccount")
	protected DebtorFinancialAccountType payerPartyDebtorFinancialAccount;
	@XmlElement(name = "PayeePartyCreditorFinancialAccount")
	protected CreditorFinancialAccountType payeePartyCreditorFinancialAccount;
	@XmlElement(name = "PayerSpecifiedDebtorFinancialInstitution")
	protected DebtorFinancialInstitutionType payerSpecifiedDebtorFinancialInstitution;
	@XmlElement(name = "PayeeSpecifiedCreditorFinancialInstitution")
	protected CreditorFinancialInstitutionType payeeSpecifiedCreditorFinancialInstitution;


	/**
	 * Ruft den Wert der typeCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link PaymentMeansCodeType }
	 */
	public PaymentMeansCodeType getTypeCode() {
		return typeCode;
	}


	/**
	 * Legt den Wert der typeCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link PaymentMeansCodeType }
	 */
	public void setTypeCode(PaymentMeansCodeType value) {
		typeCode = value;
	}


	/**
	 * Gets the value of the information property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the information property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getInformation().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TextType }
	 */
	public List<TextType> getInformation() {
		if (information == null) {
			information = new ArrayList<>();
		}
		return information;
	}


	/**
	 * Gets the value of the id property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the id property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getID().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link IDType }
	 */
	public List<IDType> getID() {
		if (id == null) {
			id = new ArrayList<>();
		}
		return id;
	}


	/**
	 * Ruft den Wert der payerPartyDebtorFinancialAccount-Eigenschaft ab.
	 *
	 * @return possible object is {@link DebtorFinancialAccountType }
	 */
	public DebtorFinancialAccountType getPayerPartyDebtorFinancialAccount() {
		return payerPartyDebtorFinancialAccount;
	}


	/**
	 * Legt den Wert der payerPartyDebtorFinancialAccount-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DebtorFinancialAccountType }
	 */
	public void setPayerPartyDebtorFinancialAccount(DebtorFinancialAccountType value) {
		payerPartyDebtorFinancialAccount = value;
	}


	/**
	 * Ruft den Wert der payeePartyCreditorFinancialAccount-Eigenschaft ab.
	 *
	 * @return possible object is {@link CreditorFinancialAccountType }
	 */
	public CreditorFinancialAccountType getPayeePartyCreditorFinancialAccount() {
		return payeePartyCreditorFinancialAccount;
	}


	/**
	 * Legt den Wert der payeePartyCreditorFinancialAccount-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link CreditorFinancialAccountType }
	 */
	public void setPayeePartyCreditorFinancialAccount(CreditorFinancialAccountType value) {
		payeePartyCreditorFinancialAccount = value;
	}


	/**
	 * Ruft den Wert der payerSpecifiedDebtorFinancialInstitution-Eigenschaft ab.
	 *
	 * @return possible object is {@link DebtorFinancialInstitutionType }
	 */
	public DebtorFinancialInstitutionType getPayerSpecifiedDebtorFinancialInstitution() {
		return payerSpecifiedDebtorFinancialInstitution;
	}


	/**
	 * Legt den Wert der payerSpecifiedDebtorFinancialInstitution-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link DebtorFinancialInstitutionType }
	 */
	public void setPayerSpecifiedDebtorFinancialInstitution(DebtorFinancialInstitutionType value) {
		payerSpecifiedDebtorFinancialInstitution = value;
	}


	/**
	 * Ruft den Wert der payeeSpecifiedCreditorFinancialInstitution-Eigenschaft ab.
	 *
	 * @return possible object is {@link CreditorFinancialInstitutionType }
	 */
	public CreditorFinancialInstitutionType getPayeeSpecifiedCreditorFinancialInstitution() {
		return payeeSpecifiedCreditorFinancialInstitution;
	}


	/**
	 * Legt den Wert der payeeSpecifiedCreditorFinancialInstitution-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link CreditorFinancialInstitutionType }
	 */
	public void setPayeeSpecifiedCreditorFinancialInstitution(CreditorFinancialInstitutionType value) {
		payeeSpecifiedCreditorFinancialInstitution = value;
	}

}
