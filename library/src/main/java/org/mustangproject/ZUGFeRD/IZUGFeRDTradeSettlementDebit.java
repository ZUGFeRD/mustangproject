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

import org.mustangproject.XMLTools;

public interface IZUGFeRDTradeSettlementDebit extends IZUGFeRDTradeSettlement {

	@Override
	default String getSettlementXML() {
		String xml = "<ram:SpecifiedTradeSettlementPaymentMeans>"
				+ "<ram:TypeCode>59</ram:TypeCode>"
				+ "<ram:Information>SEPA direct debit</ram:Information>"
				+ "<ram:PayerPartyDebtorFinancialAccount>"
				+ "<ram:IBANID>" + XMLTools.encodeXML(getIBAN()) + "</ram:IBANID>"
				+ "</ram:PayerPartyDebtorFinancialAccount>";
		
		xml += "</ram:SpecifiedTradeSettlementPaymentMeans>";
		return xml;
	}

	@Override
	default String getPaymentXML() {
		return "<ram:DirectDebitMandateID>" + XMLTools.encodeXML(getMandate()) + "</ram:DirectDebitMandateID>";
	}


	/***
	 * @return IBAN of the debtor (optional)
	 */
	String getIBAN();

	/***
	 * @return sepa direct debit mandate reference
	 */
	String getMandate();

}
