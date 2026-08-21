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
package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

import org.mustangproject.ClassCode;

/**
 * A product characteristic that allows to describe a product more detailed.
 */
public interface IProductCharacteristicType {
	/**
	 * Type code, optional
	 *
	 * @return the type code or {@code null} if not set
	 */
	default ClassCode getTypeCode() {
		return null;
	}

	/**
	 * Description, optional
	 *
	 * @return the description or {@code null} if not set
	 */
	default String getDescription() {
		return null;
	}

	/**
	 * ValueMeasure, optional
	 *
	 * @return the value measure or {@code null} if not set
	 */
	default BigDecimal getValueMeasure() {
		return null;
	}

	/**
	 * Unit code, optional
	 *
	 * @return the unit code or {@code null} if not set
	 */
	default String getUnitCode() {
		return null;
	}

	/**
	 * Value, optional
	 *
	 * @return the value or {@code null} if not set
	 */
	default String getValue() {
		return null;
	}
}
