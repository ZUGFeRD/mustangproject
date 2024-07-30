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

import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.EStandard;
import org.mustangproject.XMLTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UBLDAPullProvider implements IXMLProvider {
  private static final Logger LOGGER = LoggerFactory.getLogger (UBLDAPullProvider.class);

	protected IExportableTransaction trans;
	protected TransactionCalculator calc;
	byte[] ublData;
	protected Profile profile = Profiles.getByName(EStandard.ubldespatchadvice, "basic", 1);


	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;
		this.calc = new TransactionCalculator(trans);

		final SimpleDateFormat ublDateFormat = new SimpleDateFormat("yyyy-MM-dd");


		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
				"<DespatchAdvice xmlns=\"urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2\" xmlns:cac=\"urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2\" xmlns:cbc=\"urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2\" xmlns:cec=\"urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2\" xmlns:csc=\"urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2\">\n" +
				"  <cbc:UBLVersionID>2.2</cbc:UBLVersionID>\n" +
				"  <cbc:CustomizationID>1Lieferschein</cbc:CustomizationID>\n" +
				"  <cbc:ProfileID>ubl-xml-only</cbc:ProfileID>\n" +
				"  <cbc:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</cbc:ID>\n" +
				"  <cbc:IssueDate>" + ublDateFormat.format(trans.getIssueDate()) + "</cbc:IssueDate>\n" +
				"  <cbc:DespatchAdviceTypeCode>900</cbc:DespatchAdviceTypeCode>\n";
		if (trans.getReferenceNumber() != null) {
			xml += "<cac:OrderReference>  <cbc:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</cbc:ID></cac:OrderReference>\n";

		}
		xml += "  <cac:DespatchSupplierParty>" + getPartyXML(trans.getSender()) + "</cac:DespatchSupplierParty>\n" +
				"  <cac:DeliveryCustomerParty>" + getPartyXML(trans.getRecipient()) + "</cac:DeliveryCustomerParty>\n";
		if (trans.getDeliveryDate() != null) {
			xml += "   <cac:Shipment><cbc:ID>1</cbc:ID><cac:Delivery><cbc:ActualDeliveryDate>" + ublDateFormat.format(trans.getDeliveryDate()) + "</cbc:ActualDeliveryDate></cac:Delivery></cac:Shipment>";
		}
		int i = 1;
		for (IZUGFeRDExportableItem item : trans.getZFItems()) {
			xml +=
					"  <cac:DespatchLine>\n" +
							"    <cbc:ID>" + XMLTools.encodeXML(Integer.toString(i++)) + "</cbc:ID>\n" +
							"    <cbc:DeliveredQuantity unitCode=\"" + XMLTools.encodeXML(item.getProduct().getUnit()) + "\">" + item.getQuantity() + "</cbc:DeliveredQuantity>\n" +
							"    <cac:OrderLineReference>\n" +
							"      <cbc:LineID>" + XMLTools.encodeXML(item.getBuyerOrderReferencedDocumentLineID()) + "</cbc:LineID>\n" +
							"    </cac:OrderLineReference>\n" +
							"    <cac:Item>\n" +
							"      <cbc:Name>" + XMLTools.encodeXML(item.getProduct().getName()) + "</cbc:Name>\n" +
							"    </cac:Item>\n" +
							"  </cac:DespatchLine>\n";

		}
		xml += "</DespatchAdvice>\n";
		final byte[] ublRaw;
		ublRaw = xml.getBytes(StandardCharsets.UTF_8);

		ublData = XMLTools.removeBOM(ublRaw);
	}

	public String getPartyXML(IZUGFeRDExportableTradeParty tp) {
		return "<cac:Party>\n" +
				"      <cac:PostalAddress>\n" +
				"        <cbc:CityName>" + XMLTools.encodeXML(tp.getLocation()) + "</cbc:CityName>\n" +
				"        <cac:AddressLine>\n" +
				"          <cbc:Line>" + XMLTools.encodeXML(tp.getName()) + "</cbc:Line>\n" +
				"        </cac:AddressLine>\n" +
				"        <cac:AddressLine>\n" +
				"          <cbc:Line>" + XMLTools.encodeXML(tp.getStreet()) + "</cbc:Line>\n" +
				"        </cac:AddressLine>\n" +
				"        <cac:Country>\n" +
				"          <cbc:IdentificationCode>" + XMLTools.encodeXML(tp.getCountry()) + "</cbc:IdentificationCode>\n" +
				"        </cac:Country>\n" +
				"      </cac:PostalAddress>\n" +
				"    </cac:Party>";
	}


	@Override
	public byte[] getXML() {

		byte[] res = ublData;

		final StringWriter sw = new StringWriter();
		Document document = null;
		try {
			document = DocumentHelper.parseText(new String(ublData));
		} catch (final DocumentException e1) {
			LOGGER.error ("Failed to parse UBL", e1);
		}
		try {
			final OutputFormat format = OutputFormat.createPrettyPrint();
			format.setTrimText(false);
			final XMLWriter writer = new XMLWriter(sw, format);
			writer.write(document);
			res = sw.toString().getBytes(StandardCharsets.UTF_8);

		} catch (final IOException e) {
			LOGGER.error ("Failed to write XML", e);
		}

		return res;

	}

	@Override
	public void setTest() {

	}

	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

	@Override
	public Profile getProfile() {
		return profile;
	}

}
