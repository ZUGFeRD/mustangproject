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
	 * VAT percent of the product (e.g. 19, or 5.1 if you like)
	 *
	 * @return VAT percent of the product
	 */
	BigDecimal getVATPercent();

}
