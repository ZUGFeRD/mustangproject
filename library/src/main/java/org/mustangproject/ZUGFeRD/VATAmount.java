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
import java.math.RoundingMode;

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


	protected BigDecimal basis, calculated, applicablePercent;

	protected String categoryCode;

	protected String vatExemptionReasonText;

	protected String dueDateTypeCode;


	public VATAmount(BigDecimal basis, BigDecimal calculated, String categoryCode) {
		super();
		this.basis = basis;
		this.calculated = calculated;
		this.categoryCode = categoryCode;
		this.dueDateTypeCode = null;
	}

	public VATAmount(BigDecimal basis, BigDecimal calculated, String categoryCode, String dueDateTypeCode) {
		super();
		this.basis = basis;
		this.calculated = calculated;
		this.categoryCode = categoryCode;
		this.dueDateTypeCode = dueDateTypeCode;
	}

	public BigDecimal getApplicablePercent() {
		return applicablePercent;
	}

	public VATAmount setApplicablePercent(BigDecimal applicablePercent) {

		this.applicablePercent = applicablePercent;
		return this;
	}

	public BigDecimal getBasis() {
		return basis;
	}

	public VATAmount setBasis(BigDecimal basis) {
		this.basis = basis.setScale(2, RoundingMode.HALF_UP);
		return this;
	}

	public BigDecimal getCalculated() {
		return calculated;
	}

	public VATAmount setCalculated(BigDecimal calculated) {
		this.calculated = calculated;
		return this;
	}

	public String getVatExemptionReasonText() {
		return vatExemptionReasonText;
	}

	public VATAmount setVatExemptionReasonText(String theText) {
		this.vatExemptionReasonText = theText;
		return this;
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
	 * @return fluent setter
	 */
	@Deprecated
	public VATAmount setDocumentCode(String documentCode) {
		this.categoryCode = documentCode;
		return this;
	}

	public String getCategoryCode() {
		return categoryCode;
	}

	public VATAmount setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
		return this;
	}

	public String getDueDateTypeCode() {
		return dueDateTypeCode;
	}

	public VATAmount setDueDateTypeCode(String dueDateTypeCode) {
		this.dueDateTypeCode = dueDateTypeCode;
		return this;
	}

	public VATAmount add(VATAmount v) {
		return new VATAmount(basis.add(v.getBasis()), calculated.add(v.getCalculated()), this.categoryCode, this.dueDateTypeCode).setVatExemptionReasonText(v.getVatExemptionReasonText() != null ? v.getVatExemptionReasonText(): this.vatExemptionReasonText);
	}

	public VATAmount subtract(VATAmount v) {
		return new VATAmount(basis.subtract(v.getBasis()), calculated.subtract(v.getCalculated()), this.categoryCode, this.dueDateTypeCode).setVatExemptionReasonText(v.getVatExemptionReasonText());
	}

}
