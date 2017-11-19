package org.mustangproject.ZUGFeRD.model;

import java.util.HashMap;
import java.util.Map;

import com.sun.xml.bind.marshaller.NamespacePrefixMapper;

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
