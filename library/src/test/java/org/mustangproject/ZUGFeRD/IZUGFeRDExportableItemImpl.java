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

public class IZUGFeRDExportableItemImpl implements IZUGFeRDExportableItem {
	private IZUGFeRDExportableProduct product;
	private IZUGFeRDAllowanceCharge[] itemAllowances;
	private IZUGFeRDAllowanceCharge[] itemCharges;
	private BigDecimal price;
	private BigDecimal quantity;

	@Override
	public IZUGFeRDExportableProduct getProduct() {
		return product;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemAllowances() {
		return itemAllowances;
	}

	@Override
	public IZUGFeRDAllowanceCharge[] getItemCharges() {
		return itemCharges;
	}

	@Override
	public BigDecimal getPrice() {
		return price;
	}

	@Override
	public BigDecimal getQuantity() {
		return quantity;
	}

	public IZUGFeRDExportableItemImpl setProduct(IZUGFeRDExportableProduct product) {
		this.product = product;
		return this;
	}

	public IZUGFeRDExportableItemImpl setItemAllowances(IZUGFeRDAllowanceCharge[] itemAllowances) {
		this.itemAllowances = itemAllowances;
		return this;
	}

	public IZUGFeRDExportableItemImpl setItemCharges(IZUGFeRDAllowanceCharge[] itemCharges) {
		this.itemCharges = itemCharges;
		return this;
	}

	public IZUGFeRDExportableItemImpl setPrice(BigDecimal price) {
		this.price = price;
		return this;
	}

	public IZUGFeRDExportableItemImpl setQuantity(BigDecimal quantity) {
		this.quantity = quantity;
		return this;
	}
}
