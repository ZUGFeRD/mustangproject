/** **********************************************************************
 *
 * Copyright 2019 by ak on 12.04.19.
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

public class IZUGFeRDTradeSettlementPaymentImpl implements IZUGFeRDTradeSettlementPayment {

	private String ownKto;
	private String ownBLZ;
	private String ownBIC;
	private String ownBankName;
	private String ownIBAN;
	private String ownPaymentInfoText;

	@Override
	public String getOwnBIC() {
		return ownBIC;
	}

	@Override
	public String getOwnIBAN() {
		return ownIBAN;
	}

	@Override
	public String getOwnPaymentInfoText() {
		return ownPaymentInfoText;
	}

	public IZUGFeRDTradeSettlementPaymentImpl setOwnBLZ(String ownBLZ) {
		this.ownBLZ = ownBLZ;
		return this;
	}

	public IZUGFeRDTradeSettlementPaymentImpl setOwnBIC(String ownBIC) {
		this.ownBIC = ownBIC;
		return this;
	}

	public IZUGFeRDTradeSettlementPaymentImpl setOwnBankName(String ownBankName) {
		this.ownBankName = ownBankName;
		return this;
	}

	public IZUGFeRDTradeSettlementPaymentImpl setOwnKto(String ownKto) {
		this.ownKto = ownKto;
		return this;
	}

	public IZUGFeRDTradeSettlementPaymentImpl setOwnIBAN(String ownIBAN) {
		this.ownIBAN = ownIBAN;
		return this;
	}

	public IZUGFeRDTradeSettlementPaymentImpl setOwnPaymentInfoText(String ownPaymentInfoText) {
		this.ownPaymentInfoText = ownPaymentInfoText;
		return this;
	}

}
