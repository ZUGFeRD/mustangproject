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

/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD exporter helper class
 * Licensed under the APLv2
 *
 * @author jstaerk
 * @version 1.2.0
 * dated 2015-10-29
 */
public class VATAmount {

	public VATAmount(BigDecimal basis, BigDecimal calculated, String categoryCode) {
		super();
		this.basis = basis;
		this.calculated = calculated;
		this.categoryCode = categoryCode;
	}

	BigDecimal basis, calculated, applicablePercent;

	String categoryCode;

	public BigDecimal getApplicablePercent() {
		return applicablePercent;
	}

	public void setApplicablePercent(BigDecimal applicablePercent) {
		this.applicablePercent = applicablePercent;
	}

	public BigDecimal getBasis() {
		return basis;
	}

	public void setBasis(BigDecimal basis) {
		this.basis = basis;

	}

	public BigDecimal getCalculated() {
		return calculated;
	}

	public void setCalculated(BigDecimal calculated) {
		this.calculated = calculated;
	}

	/**
	 *
	 * @deprecated Use {@link #getCategoryCode() instead}
	 * @return String with category code
	 */
	@Deprecated
	public String getDocumentCode() {
		return categoryCode;
	}

	/**
     * @param documentCode as String
	 * @deprecated Use {@link #setCategoryCode(String)} instead
	 */
	@Deprecated
	public void setDocumentCode(String documentCode) {
		this.categoryCode = documentCode;
	}

	public String getCategoryCode() {
		return categoryCode;
	}

	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}

	public VATAmount add(VATAmount v) {
		return new VATAmount(basis.add(v.getBasis()), calculated.add(v.getCalculated()), this.categoryCode);
	}

	public VATAmount subtract(VATAmount v) {
		return new VATAmount(basis.subtract(v.getBasis()), calculated.subtract(v.getCalculated()), this.categoryCode);
	}

}
