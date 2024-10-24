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

import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.mustangproject.EStandard;

public class Profiles {
	static Map<String, Profile> zf2Map = Stream.of(new Object[][]{
			{"MINIMUM", new Profile("MINIMUM", "urn:factur-x.eu:1p0:minimum")},
			{"BASICWL", new Profile("BASICWL", "urn:factur-x.eu:1p0:basicwl")},
			{"BASIC", new Profile("BASIC", "urn:cen.eu:en16931:2017#compliant#urn:factur-x.eu:1p0:basic")},
			{"EN16931", new Profile("EN16931", "urn:cen.eu:en16931:2017")},
			{"EXTENDED", new Profile("EXTENDED", "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended")},
			{"XRECHNUNG", new Profile("XRECHNUNG", "urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0")} // up next: urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_3.0

	}).collect(Collectors.toMap(data -> (String) data[0], data -> (Profile) data[1]));
	static Map<String, Profile> zf1Map = Stream.of(new Object[][]{
			{"BASIC", new Profile("BASIC", "urn:ferd:CrossIndustryDocument:invoice:1p0:basic")},
			{"COMFORT", new Profile("COMFORT", "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort")},
			{"EXTENDED", new Profile("EXTENDED", "urn:ferd:CrossIndustryDocument:invoice:1p0:extended")},


	}).collect(Collectors.toMap(data -> (String) data[0], data -> (Profile) data[1]));
	static Map<String, Profile> ox1Map = Stream.of(new Object[][]{
			{"BASIC", new Profile("BASIC", "urn:order-x.eu:1p0:basic")},
			{"COMFORT", new Profile("COMFORT", "urn:order-x.eu:1p0:comfort")},
			{"EXTENDED", new Profile("EXTENDED", "urn:order-x.eu:1p0:extended")},


	}).collect(Collectors.toMap(data -> (String) data[0], data -> (Profile) data[1]));
	static Map<String, Profile> dx1Map = Stream.of(new Object[][]{
			{"PILOT", new Profile("PILOT", "urn:awv-net.de:CIDA:1.0:pilot")}
	}).collect(Collectors.toMap(data -> (String) data[0], data -> (Profile) data[1]));


	public static Profile getByName(EStandard standard, String name, int version) {
		if (standard == EStandard.orderx) {
			Profile result = null;
			result = ox1Map.get(name.toUpperCase());
			if (result == null) {
				throw new RuntimeException("Profile not found");
			}
			return result;
		} else if (standard == EStandard.despatchadvice) {
			Profile result = null;
			result = dx1Map.get(name.toUpperCase());
			if (result == null) {
				throw new RuntimeException("Profile not found");
			}
			return result;
		} else {
			int generation = version;
			if ((standard==EStandard.facturx) && (version==1)) {
				generation = 2;
			}
			return getByName(name, generation);

		}
	}

	public static Profile getByName(String name, int version) {
		Profile result = null;
		if (version == 1) {
			result = zf1Map.get(name.toUpperCase());
		} else {
			result = zf2Map.get(name.toUpperCase());
		}
		if (result == null) {
			throw new RuntimeException("Profile not found");
		}
		return result;
	}

	public static Profile getByName(String name) {
		return getByName(name, ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion);
	}


	/**
	 * Obtains a profile by name, disregarding version. First searches among
	 * 1.x profiles and fatre that among 2.x profiles.
	 *
	 * @param name profile name to search for
	 *
	 * @return a profile matching the requested name
	 */
	public static Profile getByNameDisregardingVersion(String name)
	{
		Profile result = null;

		result = zf1Map.get(name.toUpperCase());

		if (result == null)
		{
			result = zf2Map.get(name.toUpperCase());
		}

		if (result==null)
		{
			throw new RuntimeException("Profile " + name + " not found");
		}

		return result;
	}
}
