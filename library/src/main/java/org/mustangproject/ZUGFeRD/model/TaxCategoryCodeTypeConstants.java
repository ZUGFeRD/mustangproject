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
package org.mustangproject.ZUGFeRD.model;

import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class TaxCategoryCodeTypeConstants {
	public static final String STANDARDRATE = "S";
	public static final String REVERSECHARGE = "AE";
	public static final String TAXEXEMPT = "E";
	public static final String ZEROTAXPRODUCTS = "Z";
	public static final String UNTAXEDSERVICE = "O";
	public static final String INTRACOMMUNITY = "K";
	public static final String FREEEXPORT = "G";

	public static Set<String> CATEGORY_CODES_WITH_EXEMPTION_REASON = Stream.of(INTRACOMMUNITY, REVERSECHARGE, TAXEXEMPT, FREEEXPORT, UNTAXEDSERVICE).collect(Collectors.toSet());
}
