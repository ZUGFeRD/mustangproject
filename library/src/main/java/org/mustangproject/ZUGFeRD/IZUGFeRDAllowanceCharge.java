/*
 * Copyright 2015 AlexanderSchmidt.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

/**
 * The interface for allowances or charges, to be used by the pullprovider
 * @author AlexanderSchmidt
 * 
 * <xs:complexType name="TradeAllowanceChargeType">
 *   <xs:sequence>
 *     <xs:element name="ChargeIndicator" type="udt:IndicatorType"/>
 *     <xs:element name="SequenceNumeric" type="udt:NumericType" minOccurs="0"/>
 *     <xs:element name="CalculationPercent" type="udt:PercentType" minOccurs="0"/>
 *     <xs:element name="BasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="BasisQuantity" type="udt:QuantityType" minOccurs="0"/>
 *     <xs:element name="ActualAmount" type="udt:AmountType"/>
 *     <xs:element name="ReasonCode" type="qdt:AllowanceChargeReasonCodeType" minOccurs="0"/>
 *     <xs:element name="Reason" type="udt:TextType" minOccurs="0"/>
 *     <xs:element name="CategoryTradeTax" type="ram:TradeTaxType" minOccurs="0"/>
 *   </xs:sequence>
 * </xs:complexType>
 */
public interface IZUGFeRDAllowanceCharge extends IZUGFeRDTradeTax {

	/***
	 * is this in reality a charge and now allowance
	 * @return true if amount to be treated negative
	 */
	public boolean isCharge();

	/***
	 * returns the sequence number
	 * @return	sequence number
	 */
	default Integer getSequenceNumeric() {return null;}

	/***
	 * returns a percentage, if relative amount, or null for absolute amounts
	 * @return null or Percentage as BigDecimal
	 */
	default BigDecimal getPercent() {return null;}

	/***
	 * returns a basis the percentage is calculated from
	 * @return null or the basis
	 */
	default BigDecimal getBasisAmount() {return null;}

	/***
	 * returns a basis the percentage is calculated from
	 * @return null or the basis
	 */
	default BigDecimal getBasisQuantity() {return null;}

	/***
	 * returns the absolute amount, even if it was relative in the first place
	 * @param trans the class delivering the initial value
	 * @return the calculated value (e.g. when percentage)
	 */
	BigDecimal getTotalAmount(IAbsoluteValueProvider trans);

	/***
	 * get the code for the allowance/charge
	 * @return the code
	 */
	String getReasonCode();

	/***
	 * get a description for the allowance/charge
	 * @return the description
	 */
	String getReason();


	/*
	 * for backward compatibility
	 */
	/**
	 * @deprecated use getTaxCategoryCode() instead.
	 */
	@Deprecated
	default String getCategoryCode() {
		return getTaxCategoryCode();
	}

	/**
	 * @deprecated use getTaxRateApplicablePercent() instead.
	 */
	@Deprecated
	default BigDecimal getTaxPercent() {
		return getTaxRateApplicablePercent();
	}
}
