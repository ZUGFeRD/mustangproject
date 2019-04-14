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

public interface IZUGFeRDTradeSettlementPayment {

	/**
	 * get payment information text. e.g. Bank transfer
	 *
	 * @return payment information text
	 */
	default String getOwnPaymentInfoText() {
		return null;
	}

	/**
	 * BIC of the sender
	 *
	 * @return the BIC code of the recipient sender's bank
	 */
	default String getOwnBIC() {
		return null;
	}


	/**
	 * BLZ of the sender
	 *
	 * @return the BLZ code of the recipient sender's bank
	 */
	default String getOwnBLZ() {
		return null;
	}


	/**
	 * Bank name of the sender
	 *
	 * @return the name of the sender's bank
	 */
	default String getOwnBankName() {
		return null;
	}


	/**
	 * IBAN of the sender
	 *
	 * @return the IBAN of the invoice sender's bank account
	 */
	default String getOwnIBAN() {
		return null;
	}


	/**
	 * IBAN of the sender
	 *
	 * @return the Account Number of the invoice sender's bank account
	 */
	default String getOwnKto() {
		return null;
	}

}
