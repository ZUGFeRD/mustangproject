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

import org.mustangproject.SchemedID;

/**
 * A product instances by batch id and / or serial id
 */
public interface ITradeProductInstanceType {
	/**
	 * @return the batch id
	 */
	default SchemedID getBatchID() {
		return null;
	}

	/**
	 * @return the serial id
	 */
	default SchemedID getSupplierAssignedSerialID() {
		return null;
	}
}
