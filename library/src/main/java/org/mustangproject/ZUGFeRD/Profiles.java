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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Profiles {
	static Map<String, Profile> zf2Map = Stream.of(new Object[][]{
			{"MINIMUM", new Profile("MINIMUM", "urn:factur-x.eu:1p0:minimum")},
			{"BASICWL", new Profile("BASICWL", "urn:factur-x.eu:1p0:basicwl")},
			{"BASIC", new Profile("BASIC", "urn:cen.eu:en16931:2017#compliant#urn:factur-x.eu:1p0:basic")},
			{"EN16931", new Profile("EN16931", "urn:cen.eu:en16931:2017")},
			{"EXTENDED", new Profile("EXTENDED", "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended")},
			{"XRECHNUNG", new Profile("XRECHNUNG", "urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_1.2")}

	}).collect(Collectors.toMap(data -> (String) data[0], data -> (Profile) data[1]));
	static Map<String, Profile> zf1Map = Stream.of(new Object[][]{
			{"BASIC", new Profile("BASIC", "urn:ferd:CrossIndustryDocument:invoice:1p0:basic")},
			{"COMFORT", new Profile("COMFORT", "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort")},
			{"EXTENDED", new Profile("EXTENDED", "urn:ferd:CrossIndustryDocument:invoice:1p0:extended")},


	}).collect(Collectors.toMap(data -> (String) data[0], data -> (Profile) data[1]));


	public static Profile getByName(String name, int version) {
		Profile result=null;
		if (version==1) {
			result=zf1Map.get(name.toUpperCase());
		} else {
			result=zf2Map.get(name.toUpperCase());
		}
		if (result==null) { throw new RuntimeException("Profile not found"); }
		return result;
	}
	public static Profile getByName(String name) {
		return getByName(name, ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion);
	}

}
