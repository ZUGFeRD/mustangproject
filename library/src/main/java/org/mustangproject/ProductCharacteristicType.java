/**
 * *********************************************************************
 * <p>
 * Copyright (c) 2024 Jan N. Klug
 * <p>
 * Use is subject to license terms.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * <p>
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p>
 * **********************************************************************
 */
package org.mustangproject;

import java.math.BigDecimal;

import org.mustangproject.ZUGFeRD.IProductCharacteristicType;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * An implementation of {@link IProductCharacteristicType} for describing a {@link org.mustangproject.Product}
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ProductCharacteristicType implements IProductCharacteristicType {
	private ClassCode typeCode;
	private String description;
	private BigDecimal valueMeasure;
	private String unitCode;
	private String value;

	/**
	 * A schemed product characteristic
	 *
	 * @param typeCode an UNTDID 6313 schemed class code
	 */
	public ProductCharacteristicType(ClassCode typeCode) {
		this.typeCode = typeCode;
	}

	/**
	 * Bean constructor for schemed product descriptor
	 */
	public ProductCharacteristicType() {
		typeCode = null; // we need this constructor for jackson, i.e. to be able to JSON
	}

	@Override
	public ClassCode getTypeCode() {
		return typeCode;
	}

	/**
	 * @param typeCode the typeCode to set
	 */
	public ProductCharacteristicType setTypeCode(ClassCode typeCode) {
		this.typeCode = typeCode;
		return this;
	}

	/**
	 * @return the description
	 */
	@Override
	public String getDescription() {
		return description;
	}

	/**
	 * Set the description of the characteristic
	 *
	 * @param description the description of the characteristic (cannot be {@code null})
	 */
	public ProductCharacteristicType setDescription(String description) {
		this.description = description;
		return this;
	}

	/**
	 * @return the unitCode
	 */
	public String getUnitCode() {
		return unitCode;
	}

	/**
	 * Set the unit code for the value measure.
	 *
	 * @param unitCode the unitCode to set
	 */
	public ProductCharacteristicType setUnitCode(String unitCode) {
		this.unitCode = unitCode;
		return this;
	}

	/**
	 * @return the valueMeasure
	 */
	public BigDecimal getValueMeasure() {
		return valueMeasure;
	}

	/**
	 * Set the numerical value of the characteristic
	 *
	 * @param valueMeasure the valueMeasure to set
	 */
	public ProductCharacteristicType setValueMeasure(BigDecimal valueMeasure) {
		this.valueMeasure = valueMeasure;
		return this;
	}

	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}

	/**
	 * Set the string value of the characteristic
	 *
	 * @param value the value to set
	 */
	public ProductCharacteristicType setValue(String value) {
		this.value = value;
		return this;
	}
}
