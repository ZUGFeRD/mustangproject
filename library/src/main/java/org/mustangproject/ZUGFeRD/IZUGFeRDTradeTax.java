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
import java.util.Date;

import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants;

/**
 * The interface for allowances or charges, to be used by the pullprovider
 * @author AlexanderSchmidt
 * <xs:complexType name="TradeTaxType">
 *   <xs:sequence>
 *     <xs:element name="CalculatedAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="TypeCode" type="qdt:TaxTypeCodeType"/>
 *     <xs:element name="ExemptionReason" type="udt:TextType" minOccurs="0"/>
 *     <xs:element name="BasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="LineTotalBasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="AllowanceChargeBasisAmount" type="udt:AmountType" minOccurs="0"/>
 *     <xs:element name="CategoryCode" type="qdt:TaxCategoryCodeType"/>
 *     <xs:element name="ExemptionReasonCode" type="udt:CodeType" minOccurs="0"/>
 *     <xs:element name="TaxPointDate" type="udt:DateType" minOccurs="0"/>
 *     <xs:element name="DueDateTypeCode" type="qdt:TimeReferenceCodeType" minOccurs="0"/>
 *     <xs:element name="RateApplicablePercent" type="udt:PercentType" minOccurs="0"/>
 *   </xs:sequence>
 * </xs:complexType>
 */
public interface IZUGFeRDTradeTax {

	/***
	 * returns the calculated amount
	 * @return null or the basis
	 */
	default BigDecimal getTaxCalculatedAmount() {
		return null;
	}

	/***
	 * the the reason (text) why this allowance/charge is tax free
	 * @return the reason text
	 */
	String getTaxExemptionReason();

	/***
	 * returns a basis the percentage is calculated from
	 * @return null or the basis
	 */
	default BigDecimal getTaxBasisAmount() {
		return null;
	}

	/***
	 * returns the line total basis amount
	 * @return null or the basis
	 */
	default BigDecimal getTaxLineTotalBasisAmount() {
		return null;
	}

	/***
	 * returns the allowance & charge basis amount
	 * @return null or the basis
	 */
	default BigDecimal getTaxAllowanceChargeBasisAmount() {
		return null;
	}

	/***
	 * the category ID why this has been applied
	 * @return default value Standard rate=S
	 */
	default String getTaxCategoryCode() {
		return TaxCategoryCodeTypeConstants.STANDARDRATE;
	}

	/***
	 * the the reason code why this allowance/charge is tax free
	 * @return the reason code
	 */
	default String getTaxExemptionReasonCode() {
		return null;
	}

	/***
	 *
	 * @return
	 */
	default Date getTaxPointDate() {
		return null;
	}

	/***
	 *
	 * @return
	 */
	default String getTaxDueDateTypeCode() {
		return null;
	}

	/***
	 * get the applicable tax percentage for the allowance/charge
	 * @return the percentage
	 */
	default BigDecimal getTaxRateApplicablePercent() {
		return null;
	}
}
