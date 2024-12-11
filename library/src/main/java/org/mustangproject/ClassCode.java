/**
 * *********************************************************************
 * <p>
 * Copyright (c) 2024 Jan N. Klug
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
package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

/**
 * A schemed classification for products. The scheme can be anything defined in UNTDID 7143.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ClassCode {
	private String listID;
	private String code;
	private String listVersionID;

	/**
	 * A UNTDID 7143 schemed classification code
	 *
	 * @param listID the scheme from UNTDID 7143
	 * @param code the classification code
	 * @param listVersionID an (optional) version of the scheme
	 */
	public ClassCode(String listID, String code, String listVersionID) {
		this.listID = listID;
		this.code = code;
		this.listVersionID = listVersionID;
	}

	/**
	 * A UNTDID 7143 schemed classification code
	 *
	 * @param listID the scheme from UNTDID 7143
	 * @param code the classification code
	 */
	public ClassCode(String listID, String code) {
		this(listID, code, null);
	}

	/***
	 * bean constructor
	 */
	public ClassCode() {
	}


	/***
	 * Set the version for the scheme returned by {@link #getListID()}
	 * @param listVersionID the scheme version
	 */
	public void setListVersionID(String listVersionID) {
		this.listVersionID = listVersionID;
	}

	/**
	 * Get the scheme (according to UNTDID 7143) that describes the value returned by {@link #getCode()},
	 * potentially versioned by {@link  #getListVersionID()}
	 *
	 * @return the scheme
	 */
	public String getListID() {
		return listID;
	}

	/**
	 * Get the code that (following the scheme returned by {@link #getListID()}) describes the product
	 *
	 * @return the classification code itself
	 */
	public String getCode() {
		return code;
	}

	/**
	 * Get the (optional) version for the scheme returned by {@link #getListID()}
	 *
	 * @return the version or {@code null} if not set
	 */
	public String getListVersionID() {
		return listVersionID;
	}

	public static ClassCode fromNode(Node node) {
		NamedNodeMap attrs = node.getAttributes();
		if (attrs != null && attrs.getNamedItem("listID") != null) {
			ClassCode classCode = new ClassCode(attrs.getNamedItem("listID").getNodeValue(), node.getTextContent());
			if (attrs.getNamedItem("listVersionID") != null) {
				classCode.setListVersionID(attrs.getNamedItem("listVersionID").getNodeValue());
			}
			return classCode;
		}
		return null;
	}
}
