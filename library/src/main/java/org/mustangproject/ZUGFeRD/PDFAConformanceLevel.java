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

public enum PDFAConformanceLevel {
	ACCESSIBLE("A"), BASIC("B"), UNICODE("U");

	private final String letter;

	PDFAConformanceLevel(String letter) {
		this.letter = letter;
	}

	public String getLetter() {
		return letter;
	}

	public static PDFAConformanceLevel findByLetter(String letter) {
		for (PDFAConformanceLevel candidate : values()) {
			if (candidate.letter.equals(letter)) {
				return candidate;
			}
		}
		throw new IllegalArgumentException("PDF conformance level <" + letter + "> is unknown.");
	}
}
