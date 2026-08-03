/*
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
 * The interface for logistic charges, to be used by the pull provider
 *
 * <xs:complexType name="LogisticsServiceChargeType">
 *   <xs:sequence>
 *     <xs:element name="Description" type="udt:TextType"/>
 *     <xs:element name="AppliedAmount" type="udt:AmountType"/>
 *     <xs:element name="AppliedTradeTax" type="ram:TradeTaxType" maxOccurs="unbounded"/>
 *   </xs:sequence>
 * </xs:complexType>
 */
public interface IZUGFeRDLogisticsServiceCharge extends IZUGFeRDTradeTax {

	/***
	 * get a description for the logistic charge
	 * @return the description
	 */
	String getDescription();

	/***
	 * get the amount of the logistic charge
	 * @return the amount
	 */
	BigDecimal getAppliedAmount();
}
