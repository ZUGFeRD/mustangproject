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

import org.mustangproject.ZUGFeRD.model.TaxCategoryCodeTypeConstants;

/**
 * The interface for allowances or charges, to be used by the pullprovider
 * @author AlexanderSchmidt
 */
public interface IZUGFeRDAllowanceCharge {

	/***
	 * returns the absolute amount, even if it was relative in the first place
	 * @param trans the class delivering the initial value
	 * @return the calculated value (e.g. when percentage)
	 */
	BigDecimal getTotalAmount(IAbsoluteValueProvider trans);

	/***
	 * returns a percentage, if relative abount, or null for absolute amounts
	 * @return null or Percentage as Bigdecimal
	 */
	default BigDecimal getPercent() {return null;}

	/***
	 * returns a basis the precentage is calculated from
	 * @return null or the basis
	 */
	default BigDecimal getBasisAmount() {return null;}

	/***
	 * get a description for the allowance/charge
	 * @return the description
	 */
	String getReason();

	/***
	 * get the code for the allowance/charge
	 * @return the code
	 */
	String getReasonCode();

	/***
	 * get the applicable tax percentage for the allowance/charge
	 * @return the percentage
	 */
	BigDecimal getTaxPercent();

	/***
	 * the category ID why this has been applied
	 * @return default value Standard rate=S
	 */
	default String getCategoryCode() {
		return TaxCategoryCodeTypeConstants.STANDARDRATE;
	}

	/***
	 * is this in reality a charge and now allowance
	 * @return true if amnount to be treated negative
	 */
	public boolean isCharge();
}
