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
 * Java-Klasse f�r TradeSettlementMonetarySummationType complex type.
 * <p>
 * Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist. <pre>
 * &lt;complexType name="TradeSettlementMonetarySummationType"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="LineTotalAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="ChargeTotalAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="AllowanceTotalAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="TaxBasisTotalAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="TaxTotalAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="GrandTotalAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="TotalPrepaidAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="TotalAllowanceChargeAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="DuePayableAmount" type="{urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15}AmountType" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "TradeSettlementMonetarySummationType", propOrder = {
		"lineTotalAmount",
		"chargeTotalAmount",
		"allowanceTotalAmount",
		"taxBasisTotalAmount",
		"taxTotalAmount",
		"grandTotalAmount",
		"totalPrepaidAmount",
		"totalAllowanceChargeAmount",
		"duePayableAmount"
})
public class TradeSettlementMonetarySummationType {

	@XmlElement(name = "LineTotalAmount")
	protected List<AmountType> lineTotalAmount;
	@XmlElement(name = "ChargeTotalAmount")
	protected List<AmountType> chargeTotalAmount;
	@XmlElement(name = "AllowanceTotalAmount")
	protected List<AmountType> allowanceTotalAmount;
	@XmlElement(name = "TaxBasisTotalAmount")
	protected List<AmountType> taxBasisTotalAmount;
	@XmlElement(name = "TaxTotalAmount")
	protected List<AmountType> taxTotalAmount;
	@XmlElement(name = "GrandTotalAmount")
	protected List<AmountType> grandTotalAmount;
	@XmlElement(name = "TotalPrepaidAmount")
	protected List<AmountType> totalPrepaidAmount;
	@XmlElement(name = "TotalAllowanceChargeAmount")
	protected List<AmountType> totalAllowanceChargeAmount;
	@XmlElement(name = "DuePayableAmount")
	protected List<AmountType> duePayableAmount;


	/**
	 * Gets the value of the lineTotalAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the lineTotalAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getLineTotalAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getLineTotalAmount() {
		if (lineTotalAmount == null) {
			lineTotalAmount = new ArrayList<>();
		}
		return lineTotalAmount;
	}


	/**
	 * Gets the value of the chargeTotalAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the chargeTotalAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getChargeTotalAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getChargeTotalAmount() {
		if (chargeTotalAmount == null) {
			chargeTotalAmount = new ArrayList<>();
		}
		return chargeTotalAmount;
	}


	/**
	 * Gets the value of the allowanceTotalAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the allowanceTotalAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getAllowanceTotalAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getAllowanceTotalAmount() {
		if (allowanceTotalAmount == null) {
			allowanceTotalAmount = new ArrayList<>();
		}
		return allowanceTotalAmount;
	}


	/**
	 * Gets the value of the taxBasisTotalAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the taxBasisTotalAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getTaxBasisTotalAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getTaxBasisTotalAmount() {
		if (taxBasisTotalAmount == null) {
			taxBasisTotalAmount = new ArrayList<>();
		}
		return taxBasisTotalAmount;
	}


	/**
	 * Gets the value of the taxTotalAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the taxTotalAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getTaxTotalAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getTaxTotalAmount() {
		if (taxTotalAmount == null) {
			taxTotalAmount = new ArrayList<>();
		}
		return taxTotalAmount;
	}


	/**
	 * Gets the value of the grandTotalAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the grandTotalAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getGrandTotalAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getGrandTotalAmount() {
		if (grandTotalAmount == null) {
			grandTotalAmount = new ArrayList<>();
		}
		return grandTotalAmount;
	}


	/**
	 * Gets the value of the totalPrepaidAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the totalPrepaidAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getTotalPrepaidAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getTotalPrepaidAmount() {
		if (totalPrepaidAmount == null) {
			totalPrepaidAmount = new ArrayList<>();
		}
		return totalPrepaidAmount;
	}


	/**
	 * Gets the value of the totalAllowanceChargeAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the totalAllowanceChargeAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getTotalAllowanceChargeAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getTotalAllowanceChargeAmount() {
		if (totalAllowanceChargeAmount == null) {
			totalAllowanceChargeAmount = new ArrayList<>();
		}
		return totalAllowanceChargeAmount;
	}


	/**
	 * Gets the value of the duePayableAmount property.
	 * <p>
	 * This accessor method returns a reference to the live list, not a snapshot. Therefore any modification you make to the returned list will be present
	 * inside the JAXB object. This is why there is not a <CODE>set</CODE> method for the duePayableAmount property.
	 * <p>
	 * For example, to add a new item, do as follows: <pre>
	 *    getDuePayableAmount().add(newItem);
	 * </pre>
	 * <p>
	 * Objects of the following type(s) are allowed in the list {@link AmountType }
	 */
	public List<AmountType> getDuePayableAmount() {
		if (duePayableAmount == null) {
			duePayableAmount = new ArrayList<>();
		}
		return duePayableAmount;
	}

}
