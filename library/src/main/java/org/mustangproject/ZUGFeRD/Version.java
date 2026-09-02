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

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class Version {

	/**
	 * The version of this library, as declared in the maven project.
	 * Never null, it is "unknown" if the version resource could not be read.
	 */
	public static final String VERSION = readVersion();

	private static final String UNKNOWN = "unknown";
	private static final String RESOURCE = "version.properties";

	private Version() {
		// constants only, not meant to be instantiated
	}

	/**
	 * Reads the maven project version from version.properties, which is generated
	 * by the maven resource filtering configured in library/pom.xml.
	 *
	 * @return the project version, or "unknown" if the resource is missing or unreadable
	 */
	private static String readVersion() {
		try (InputStream in = Version.class.getResourceAsStream(RESOURCE)) {
			if (in == null) {
				return UNKNOWN;
			}
			final Properties properties = new Properties();
			properties.load(in);
			return properties.getProperty("version", UNKNOWN);
		} catch (final IOException e) {
			return UNKNOWN;
		}
	}
}
