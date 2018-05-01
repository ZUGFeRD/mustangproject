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
package org.mustangproject.ZUGFeRD.model;

import com.sun.xml.bind.marshaller.NamespacePrefixMapper;
import java.util.HashMap;
import java.util.Map;

public class ZFNamespacePrefixMapper extends NamespacePrefixMapper {

	private Map<String, String> namespaceMap = new HashMap<>();

	/**
	 * Create mappings.
	 */
	public ZFNamespacePrefixMapper() {

		namespaceMap.put("urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12", "ram");
		namespaceMap.put("urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15", "udt");
		namespaceMap.put("urn:ferd:CrossIndustryDocument:invoice:1p0", "rsm");
	}

	/* (non-Javadoc)
	 * Returning null when not found based on spec.
	 * @see com.sun.xml.bind.marshaller.NamespacePrefixMapper#getPreferredPrefix(java.lang.String, java.lang.String, boolean)
	 */
	@Override
	public String getPreferredPrefix(String namespaceUri, String suggestion, boolean requirePrefix) {
		return namespaceMap.getOrDefault(namespaceUri, suggestion);
	}

}
