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

import java.nio.charset.StandardCharsets;

public class CustomXMLProvider implements IXMLProvider {

	protected byte[] zugferdData;
	protected Profile profile=Profiles.getByName("EN16931");

	@Override
	public byte[] getXML() {
		return zugferdData;
	}

	public void setXML(byte[] newData) {
		String zf = new String(newData, StandardCharsets.UTF_8);
		/**
		 * rsm:CrossIndustry is ZF/FX/XR (CII 2016b) and rsm:SCRDMCCBDACIOMessageStructure is of course Order-X (CIO 2021)
		 */
		if ((!zf.contains("rsm:CrossIndustry")) && (!zf.contains("rsm:SCRDMCCBDACIOMessageStructure"))) {
			throw new RuntimeException("ZUGFeRD XML does not contain <rsm:CrossIndustry or <rsm:SCRDMCCBDACIOMessageStructure and can thus not be valid");
		}

		zugferdData = newData;
	}

	@Override
	public void generateXML(IExportableTransaction trans) {
		// TODO Auto-generated method stub

	}

	@Override
	public void setTest() {
		// TODO Auto-generated method stub

	}

	@Override
	public Profile getProfile() {
		return profile;
	}

	public void setProfile(Profile level) {
		profile=level;
	}
}
