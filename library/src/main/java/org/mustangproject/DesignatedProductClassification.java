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
import org.mustangproject.ZUGFeRD.IDesignatedProductClassification;

/**
 * An implementation of {@link IDesignatedProductClassification} for describing a {@link org.mustangproject.Product}
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class DesignatedProductClassification implements IDesignatedProductClassification {
	private ClassCode classCode;
	private String className;

	/**
	 * A schemed product descriptor
	 *
	 * @param classCode an UNTDID 7143 schemed class code
	 * @param className a verbal description of the class code
	 */
	public DesignatedProductClassification(ClassCode classCode, String className) {
		this.classCode = classCode;
		this.className = className;
	}

	/**
	 * A schemed product descriptor
	 *
	 * @param classCode an UNTDID 7143 schemed class code
	 */
	public DesignatedProductClassification(ClassCode classCode) {
		this(classCode, null);
	}

	/**
	 * Bean constructor for schemed product descriptor
	 */
	public DesignatedProductClassification() {
		classCode = null;// we need this constructor for jackson, i.e. to be able to JSON
	}

	@Override
	public ClassCode getClassCode() {
		return classCode;
	}

	@Override
	public String getClassName() {
		return className;
	}

	/**
	 * Set the human-readable name of the class code
	 *
	 * @param className the name of the class code (can be {@code null})
	 */
	public void setClassName(String className) {
		this.className = className;
	}
}
