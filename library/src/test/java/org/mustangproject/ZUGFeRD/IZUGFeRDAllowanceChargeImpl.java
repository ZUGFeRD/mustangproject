/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public class IZUGFeRDAllowanceChargeImpl implements IZUGFeRDAllowanceCharge {
	private BigDecimal totalAmount;
	private String reason;
	private BigDecimal taxPercent;
	boolean isCharge=true;

	@Override
	public BigDecimal getTotalAmount(IAbsoluteValueProvider currentItem) {
		return totalAmount;
	}

	@Override
	public String getReason() {
		return reason;
	}

	@Override
	public BigDecimal getTaxPercent() {
		return taxPercent;
	}

	@Override
	public boolean isCharge() {
		return isCharge;
	}

	public IZUGFeRDAllowanceChargeImpl setAllowance() {
		isCharge = false;
		return this;
	}

	public IZUGFeRDAllowanceChargeImpl setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
		return this;
	}

	public IZUGFeRDAllowanceChargeImpl setReason(String reason) {
		this.reason = reason;
		return this;
	}

	public IZUGFeRDAllowanceChargeImpl setTaxPercent(BigDecimal taxPercent) {
		this.taxPercent = taxPercent;
		return this;
	}
}
