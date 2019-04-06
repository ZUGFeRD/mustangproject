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

public class IZUGFeRDExportableContactImpl implements IZUGFeRDExportableContact {
	private String name;
	private String zIP;
	private String vATID;
	private String country;
	private String location;
	private String street;

	@Override
	public String getName() {
		return name;
	}

	@Override
	public String getZIP() {
		return zIP;
	}

	@Override
	public String getVATID() {
		return vATID;
	}

	@Override
	public String getCountry() {
		return country;
	}

	@Override
	public String getLocation() {
		return location;
	}

	@Override
	public String getStreet() {
		return street;
	}

	public IZUGFeRDExportableContactImpl setName(String name) {
		this.name = name;
		return this;
	}

	public IZUGFeRDExportableContactImpl setZIP(String zIP) {
		this.zIP = zIP;
		return this;
	}

	public IZUGFeRDExportableContactImpl setVATID(String vATID) {
		this.vATID = vATID;
		return this;
	}

	public IZUGFeRDExportableContactImpl setCountry(String country) {
		this.country = country;
		return this;
	}

	public IZUGFeRDExportableContactImpl setLocation(String location) {
		this.location = location;
		return this;
	}

	public IZUGFeRDExportableContactImpl setStreet(String street) {
		this.street = street;
		return this;
	}
}
