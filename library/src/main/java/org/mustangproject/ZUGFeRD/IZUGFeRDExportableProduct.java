/**
 * *********************************************************************
 * <p>
 * Copyright 2018 Jochen Staerk
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

import java.math.BigDecimal;

/**
 * Mustangproject's ZUGFeRD implementation
 * Necessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 *
 * @author jstaerk
 * @version 1.2.0
 * dated 2014-05-10
 */

public interface IZUGFeRDExportableProduct {

	/**
	 * Unit code of the product
	 * Most common ones are
	 * C62	one (piece)
	 * DAY	day
	 * HAR	hectare
	 * HUR	hour
	 * KGM	kilogram
	 * KTM	kilometre
	 * KWH	kilowatt hour
	 * LS	lump sum
	 * LTR	litre
	 * MIN	minute
	 * MMK	square millimetre
	 * MMT	millimetre
	 * MTK	square metre
	 * MTQ	cubic metre
	 * MTR	metre
	 * NAR	number of articles
	 * NPR	number of pairs
	 * P1	percent
	 * SET	set
	 * TNE	tonne (metric ton)
	 * WEE	week
	 *
	 * @return a UN/ECE rec 20 unit code see https://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_rev3_Annex2e.pdf
	 */
	String getUnit();

	/**
	 * Short name of the product
	 *
	 * @return Short name of the product
	 */
	String getName();

	/**
	 * long description of the product
	 *
	 * @return long description of the product
	 */
	String getDescription();

	/**
	 * Get the ID that had been assigned by the seller to
	 * identify the product
	 *
	 * @return seller assigned product ID
	 */
	default String getSellerAssignedID() {
		return null;
	}

	/**
	 * Get the ID that had been assigned by the buyer to
	 * identify the product
	 *
	 * @return buyer assigned product ID
	 */
	default String getBuyerAssignedID() {
		return null;
	}

	/**
	 * VAT percent of the product (e.g. 19, or 5.1 if you like)
	 *
	 * @return VAT percent of the product
	 */
	BigDecimal getVATPercent();

	default boolean isIntraCommunitySupply() {
		return false;
	}

	default String getTaxCategoryCode() {
		if (isIntraCommunitySupply()) {
			return "K";
		} else if (getVATPercent().equals(new BigDecimal(0))) {
			return "Z"; // zero rated goods
		} else {
			return "S"; // one of the "standard" rates (not neccessarily a default rate, even a deducted VAT is standard calculation)
		}
	}

	default String getTaxExemptionReason() {
		if (isIntraCommunitySupply())
			return "Intra-community supply";
		return null;
	}
}
