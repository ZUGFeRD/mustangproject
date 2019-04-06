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

public class IZUGFeRDExportableProductImpl implements IZUGFeRDExportableProduct {
	private String unit;
	private String name;
	private String description;
	private BigDecimal vatPercent;

	@Override
	public String getUnit() {
		return unit;
	}

	@Override
	public String getName() {
		return name;
	}

	@Override
	public String getDescription() {
		return description;
	}

	@Override
	public BigDecimal getVATPercent() {
		return vatPercent;
	}

	public IZUGFeRDExportableProductImpl setUnit(String unit) {
		this.unit = unit;
		return this;
	}

	public IZUGFeRDExportableProductImpl setName(String name) {
		this.name = name;
		return this;
	}

	public IZUGFeRDExportableProductImpl setDescription(String description) {
		this.description = description;
		return this;
	}

	public IZUGFeRDExportableProductImpl setVatPercent(BigDecimal vatPercent) {
		this.vatPercent = vatPercent;
		return this;
	}
}
