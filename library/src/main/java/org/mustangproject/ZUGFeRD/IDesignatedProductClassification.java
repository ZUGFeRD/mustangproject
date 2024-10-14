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

import org.mustangproject.ClassCode;

/**
 * A product classification that allows to describe a product. Classification codes are schemed by the available systems in UNTDID 7143.
 */
public interface IDesignatedProductClassification {
	/**
	 * Classification code
	 *
	 * @return the classification code
	 */
	ClassCode getClassCode();

	/**
	 * an optional, human-readable description of the classifcation code
	 *
	 * @return the name or {@code null} if not set
	 */
	default String getClassName() { return null; }
}
