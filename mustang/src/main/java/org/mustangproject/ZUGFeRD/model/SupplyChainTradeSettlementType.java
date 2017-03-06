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
 * Java-Klasse f�r SupplyChainTradeSettlementType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="SupplyChainTradeSettlementType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="PaymentReference" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}TextType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="InvoiceCurrencyCode" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}CodeType" minOccurs="0"/&gt;
 *         &lt;element name="InvoiceeTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" minOccurs="0"/&gt;
 *         &lt;element name="PayeeTradeParty" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePartyType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedTradeSettlementPaymentMeans" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeSettlementPaymentMeansType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ApplicableTradeTax" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeTaxType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="BillingSpecifiedPeriod" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}SpecifiedPeriodType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedTradeAllowanceCharge" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeAllowanceChargeType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedLogisticsServiceCharge" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}LogisticsServiceChargeType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedTradePaymentTerms" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradePaymentTermsType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedTradeAccountingAccount" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeAccountingAccountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="SpecifiedTradeSettlementMonetarySummation" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeSettlementMonetarySummationType" minOccurs="0"/&gt;
 *         &lt;element name="ReceivableSpecifiedTradeAccountingAccount" type="{urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12}TradeAccountingAccountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SupplyChainTradeSettlementType", propOrder = {
		"paymentReference",
		"invoiceCurrencyCode",
		"invoiceeTradeParty",
		"payeeTradeParty",
		"specifiedTradeSettlementPaymentMeans",
		"applicableTradeTax",
		"billingSpecifiedPeriod",
		"specifiedTradeAllowanceCharge",
		"specifiedLogisticsServiceCharge",
		"specifiedTradePaymentTerms",
		"specifiedTradeAccountingAccount",
		"specifiedTradeSettlementMonetarySummation",
		"receivableSpecifiedTradeAccountingAccount"
})
public class SupplyChainTradeSettlementType {

	@XmlElement(name = "PaymentReference")
	protected List<TextType> paymentReference;
	@XmlElement(name = "InvoiceCurrencyCode")
	protected CodeType invoiceCurrencyCode;
	@XmlElement(name = "InvoiceeTradeParty")
	protected TradePartyType invoiceeTradeParty;
	@XmlElement(name = "PayeeTradeParty")
	protected List<TradePartyType> payeeTradeParty;
	@XmlElement(name = "SpecifiedTradeSettlementPaymentMeans")
	protected List<TradeSettlementPaymentMeansType> specifiedTradeSettlementPaymentMeans;
	@XmlElement(name = "ApplicableTradeTax")
	protected List<TradeTaxType> applicableTradeTax;
	@XmlElement(name = "BillingSpecifiedPeriod")
	protected List<SpecifiedPeriodType> billingSpecifiedPeriod;
	@XmlElement(name = "SpecifiedTradeAllowanceCharge")
	protected List<TradeAllowanceChargeType> specifiedTradeAllowanceCharge;
	@XmlElement(name = "SpecifiedLogisticsServiceCharge")
	protected List<LogisticsServiceChargeType> specifiedLogisticsServiceCharge;
	@XmlElement(name = "SpecifiedTradePaymentTerms")
	protected List<TradePaymentTermsType> specifiedTradePaymentTerms;
	@XmlElement(name = "SpecifiedTradeAccountingAccount")
	protected List<TradeAccountingAccountType> specifiedTradeAccountingAccount;
	@XmlElement(name = "SpecifiedTradeSettlementMonetarySummation")
	protected TradeSettlementMonetarySummationType specifiedTradeSettlementMonetarySummation;
	@XmlElement(name = "ReceivableSpecifiedTradeAccountingAccount")
	protected List<TradeAccountingAccountType> receivableSpecifiedTradeAccountingAccount;


	/**
	 * Gets the value of the paymentReference property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the paymentReference property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getPaymentReference().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TextType }
	 */
	public List<TextType> getPaymentReference() {
		if (paymentReference == null) {
			paymentReference = new ArrayList<>();
		}
		return paymentReference;
	}


	/**
	 * Ruft den Wert der invoiceCurrencyCode-Eigenschaft ab.
	 *
	 * @return possible object is {@link CodeType }
	 */
	public CodeType getInvoiceCurrencyCode() {
		return invoiceCurrencyCode;
	}


	/**
	 * Legt den Wert der invoiceCurrencyCode-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link CodeType }
	 */
	public void setInvoiceCurrencyCode(CodeType value) {
		invoiceCurrencyCode = value;
	}


	/**
	 * Ruft den Wert der invoiceeTradeParty-Eigenschaft ab.
	 *
	 * @return possible object is {@link TradePartyType }
	 */
	public TradePartyType getInvoiceeTradeParty() {
		return invoiceeTradeParty;
	}


	/**
	 * Legt den Wert der invoiceeTradeParty-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TradePartyType }
	 */
	public void setInvoiceeTradeParty(TradePartyType value) {
		invoiceeTradeParty = value;
	}


	/**
	 * Gets the value of the payeeTradeParty property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the payeeTradeParty property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getPayeeTradeParty().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradePartyType }
	 */
	public List<TradePartyType> getPayeeTradeParty() {
		if (payeeTradeParty == null) {
			payeeTradeParty = new ArrayList<>();
		}
		return payeeTradeParty;
	}


	/**
	 * Gets the value of the specifiedTradeSettlementPaymentMeans property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the specifiedTradeSettlementPaymentMeans property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getSpecifiedTradeSettlementPaymentMeans().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradeSettlementPaymentMeansType }
	 */
	public List<TradeSettlementPaymentMeansType> getSpecifiedTradeSettlementPaymentMeans() {
		if (specifiedTradeSettlementPaymentMeans == null) {
			specifiedTradeSettlementPaymentMeans = new ArrayList<>();
		}
		return specifiedTradeSettlementPaymentMeans;
	}


	/**
	 * Gets the value of the applicableTradeTax property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the applicableTradeTax property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getApplicableTradeTax().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradeTaxType }
	 */
	public List<TradeTaxType> getApplicableTradeTax() {
		if (applicableTradeTax == null) {
			applicableTradeTax = new ArrayList<>();
		}
		return applicableTradeTax;
	}


	/**
	 * Gets the value of the billingSpecifiedPeriod property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the billingSpecifiedPeriod property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getBillingSpecifiedPeriod().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link SpecifiedPeriodType }
	 */
	public List<SpecifiedPeriodType> getBillingSpecifiedPeriod() {
		if (billingSpecifiedPeriod == null) {
			billingSpecifiedPeriod = new ArrayList<>();
		}
		return billingSpecifiedPeriod;
	}


	/**
	 * Gets the value of the specifiedTradeAllowanceCharge property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the specifiedTradeAllowanceCharge property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getSpecifiedTradeAllowanceCharge().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradeAllowanceChargeType }
	 */
	public List<TradeAllowanceChargeType> getSpecifiedTradeAllowanceCharge() {
		if (specifiedTradeAllowanceCharge == null) {
			specifiedTradeAllowanceCharge = new ArrayList<>();
		}
		return specifiedTradeAllowanceCharge;
	}


	/**
	 * Gets the value of the specifiedLogisticsServiceCharge property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the specifiedLogisticsServiceCharge property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getSpecifiedLogisticsServiceCharge().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link LogisticsServiceChargeType }
	 */
	public List<LogisticsServiceChargeType> getSpecifiedLogisticsServiceCharge() {
		if (specifiedLogisticsServiceCharge == null) {
			specifiedLogisticsServiceCharge = new ArrayList<>();
		}
		return specifiedLogisticsServiceCharge;
	}


	/**
	 * Gets the value of the specifiedTradePaymentTerms property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the specifiedTradePaymentTerms property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getSpecifiedTradePaymentTerms().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradePaymentTermsType }
	 */
	public List<TradePaymentTermsType> getSpecifiedTradePaymentTerms() {
		if (specifiedTradePaymentTerms == null) {
			specifiedTradePaymentTerms = new ArrayList<>();
		}
		return specifiedTradePaymentTerms;
	}


	/**
	 * Gets the value of the specifiedTradeAccountingAccount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the specifiedTradeAccountingAccount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getSpecifiedTradeAccountingAccount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradeAccountingAccountType }
	 */
	public List<TradeAccountingAccountType> getSpecifiedTradeAccountingAccount() {
		if (specifiedTradeAccountingAccount == null) {
			specifiedTradeAccountingAccount = new ArrayList<>();
		}
		return specifiedTradeAccountingAccount;
	}


	/**
	 * Ruft den Wert der specifiedTradeSettlementMonetarySummation-Eigenschaft ab.
	 *
	 * @return possible object is {@link TradeSettlementMonetarySummationType }
	 */
	public TradeSettlementMonetarySummationType getSpecifiedTradeSettlementMonetarySummation() {
		return specifiedTradeSettlementMonetarySummation;
	}


	/**
	 * Legt den Wert der specifiedTradeSettlementMonetarySummation-Eigenschaft fest.
	 *
	 * @param value allowed object is {@link TradeSettlementMonetarySummationType }
	 */
	public void setSpecifiedTradeSettlementMonetarySummation(TradeSettlementMonetarySummationType value) {
		specifiedTradeSettlementMonetarySummation = value;
	}


	/**
	 * Gets the value of the receivableSpecifiedTradeAccountingAccount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the receivableSpecifiedTradeAccountingAccount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getReceivableSpecifiedTradeAccountingAccount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link TradeAccountingAccountType }
	 */
	public List<TradeAccountingAccountType> getReceivableSpecifiedTradeAccountingAccount() {
		if (receivableSpecifiedTradeAccountingAccount == null) {
			receivableSpecifiedTradeAccountingAccount = new ArrayList<>();
		}
		return receivableSpecifiedTradeAccountingAccount;
	}

}
