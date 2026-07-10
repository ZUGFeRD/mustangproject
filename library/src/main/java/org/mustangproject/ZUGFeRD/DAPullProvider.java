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

import static org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat.DATE;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Optional;

import org.mustangproject.EStandard;
import org.mustangproject.FileAttachment;
import org.mustangproject.Invoice;
import org.mustangproject.XMLTools;

/***
 *
 */
public class DAPullProvider extends ZUGFeRD2PullProvider {

	protected IExportableTransaction trans;
	protected Profile profile = Profiles.getByName(EStandard.despatchadvice,"pilot", 1);


	@Override
	public void generateXML(IExportableTransaction trans) {
		this.trans = trans;

		final String typecode = "220";
		/*if (trans.getDocumentCode() != null) {
			typecode = trans.getDocumentCode();
		}*/

		String testBooleanStr="true";
		StringBuilder xml = new StringBuilder("<SCRDMCCBDACIDAMessageStructure\n" +
				"        xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:25\"\n" +
				"        xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:101\"\n" +
				"        xmlns:px=\"urn:un:unece:uncefact:data:standard:SCRDMCCBDACIDAMessageStructure:1\">\n"
				// + "
				// xsi:schemaLocation=\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100
				// ../Schema/ZUGFeRD1p0.xsd\""
				+ "<px:ExchangedDocumentContext>"
				// + "
				+" <ram:TestIndicator><udt:Indicator>"+testBooleanStr+"</udt:Indicator></ram:TestIndicator>\n"
				//
				+ "<ram:BusinessProcessSpecifiedDocumentContextParameter>"
				+ "<ram:ID>" + getProfile().getID() + "</ram:ID>"
				+ "</ram:BusinessProcessSpecifiedDocumentContextParameter>"
				+ "</px:ExchangedDocumentContext>"
				+ "<px:ExchangedDocument>"
				+ "<ram:ID>" + XMLTools.encodeXML(trans.getNumber()) + "</ram:ID>"
				// + " <ram:Name>RECHNUNG</ram:Name>"
				// + "<ram:TypeCode>380</ram:TypeCode>"
				+ "<ram:TypeCode>" + typecode + "</ram:TypeCode>"
				+ "<ram:IssueDateTime>"
				+ DATE.udtFormat(trans.getIssueDate()) + "</ram:IssueDateTime>" // date
				+ buildNotes(trans)

				+ "</px:ExchangedDocument>"
				+ "<px:SupplyChainTradeTransaction>");
		int lineID = 0;
		for (final IZUGFeRDExportableItem currentItem : trans.getZFItems()) {
			lineID++;
			if (currentItem.getProduct().getTaxExemptionReason() != null) {
				//	exemptionReason = "<ram:ExemptionReason>" + XMLTools.encodeXML(currentItem.getProduct().getTaxExemptionReason()) + "</ram:ExemptionReason>";
			}
            final LineCalculator lc = currentItem.getCalculation();
			xml.append("<ram:IncludedSupplyChainTradeLineItem>" +
					"<ram:AssociatedDocumentLineDocument>"
					+ "<ram:LineID>" + lineID + "</ram:LineID>"
          + buildItemNotes(currentItem)
					+ "</ram:AssociatedDocumentLineDocument>"

					+ "<ram:SpecifiedTradeProduct>");
			// + " <GlobalID schemeID=\"0160\">4012345001235</GlobalID>"
			if (currentItem.getProduct().getSellerAssignedID() != null) {
				xml.append("<ram:SellerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getSellerAssignedID()) + "</ram:SellerAssignedID>");
			}
			if (currentItem.getProduct().getBuyerAssignedID() != null) {
				xml.append("<ram:BuyerAssignedID>"
						+ XMLTools.encodeXML(currentItem.getProduct().getBuyerAssignedID()) + "</ram:BuyerAssignedID>");
			}
			// Product-level (GrossPrice / product section): ActualAmount must be per-unit (BT-147)
			final IZUGFeRDExportableItem itemForProduct = currentItem;
			IAbsoluteValueProvider perUnitProvider = new IAbsoluteValueProvider() {
				@Override
				public BigDecimal getValue() {
					return itemForProduct.getPrice();
				}
				@Override
				public BigDecimal getQuantity() {
					return BigDecimal.ONE;
				}
			};
			String allowanceChargeStr = "";
			if (currentItem.getItemAllowances() != null) {
				for (final IZUGFeRDAllowanceCharge allowance : currentItem.getItemAllowances()) {
					allowanceChargeStr += getAllowanceChargeStr(allowance, perUnitProvider);
				}
			}
			if (currentItem.getItemCharges() != null) {
				for (final IZUGFeRDAllowanceCharge charge : currentItem.getItemCharges()) {
					allowanceChargeStr += getAllowanceChargeStr(charge, perUnitProvider);
				}
			}


			xml.append("<ram:Name>" + XMLTools.encodeXML(currentItem.getProduct().getName()) + "</ram:Name>"
					+ "<ram:Description>" + XMLTools.encodeXML(currentItem.getProduct().getDescription())
					+ "</ram:Description>"
					+ "</ram:SpecifiedTradeProduct>"

					+ "<ram:SpecifiedLineTradeDelivery>"
					+ "<ram:DespatchedQuantity unitCode=\"" + XMLTools.encodeXML(currentItem.getProduct().getUnit()) + "\">"
					+ quantityFormat(currentItem.getQuantity()) + "</ram:DespatchedQuantity>"
					+ "</ram:SpecifiedLineTradeDelivery>"
					+ "<ram:SpecifiedLineTradeSettlement>");
			if ((currentItem.getDetailedDeliveryPeriodFrom() != null) || (currentItem.getDetailedDeliveryPeriodTo() != null)) {
				xml.append("<ram:BillingSpecifiedPeriod>");
				if (currentItem.getDetailedDeliveryPeriodFrom() != null) {
					xml.append("<ram:StartDateTime>" + DATE.udtFormat(currentItem.getDetailedDeliveryPeriodFrom()) + "</ram:StartDateTime>");
				}
				if (currentItem.getDetailedDeliveryPeriodTo() != null) {
					xml.append("<ram:EndDateTime>" + DATE.udtFormat(currentItem.getDetailedDeliveryPeriodTo()) + "</ram:EndDateTime>");
				}
				xml.append("</ram:BillingSpecifiedPeriod>");

			}

			xml.append("<ram:SpecifiedTradeSettlementLineMonetarySummation>"
					+ "<ram:LineTotalAmount>" + currencyFormat(lc.getItemTotalNetAmount())
					+ "</ram:LineTotalAmount>" // currencyID=\"EUR\"
					+ "</ram:SpecifiedTradeSettlementLineMonetarySummation>");
		/*	if (currentItem.getAdditionalReferencedDocumentID() != null) {
				xml.append("<ram:AdditionalReferencedDocument><ram:IssuerAssignedID>" + currentItem.getAdditionalReferencedDocumentID() + "</ram:IssuerAssignedID><ram:TypeCode>130</ram:TypeCode></ram:AdditionalReferencedDocument>");

			}*/
			xml.append("</ram:SpecifiedLineTradeSettlement>"
					+ "</ram:IncludedSupplyChainTradeLineItem>");

		}

		xml.append("<ram:ApplicableHeaderTradeAgreement>");
		if (trans.getReferenceNumber() != null) {
			xml.append("<ram:BuyerReference>" + XMLTools.encodeXML(trans.getReferenceNumber()) + "</ram:BuyerReference>");

		}
		xml.append("<ram:SellerTradeParty>"
				+ getTradePartyAsXML(trans.getSender(), true, false)
				+ "</ram:SellerTradeParty>"
				+ "<ram:BuyerTradeParty>");
		// + " <ID>GE2020211</ID>"
		// + " <GlobalID schemeID=\"0088\">4000001987658</GlobalID>"

		xml.append(getTradePartyAsXML(trans.getRecipient(), false, false));
		xml.append("</ram:BuyerTradeParty>");

		if (trans.getSellerOrderReferencedDocumentID() != null) {
			xml.append("<ram:SellerOrderReferencedDocument>"
					+ "<ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(trans.getSellerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>"
					+ "</ram:SellerOrderReferencedDocument>");
		}
		if (trans.getBuyerOrderReferencedDocumentID() != null) {
			xml.append("<ram:BuyerOrderReferencedDocument>"
					+ "<ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(trans.getBuyerOrderReferencedDocumentID()) + "</ram:IssuerAssignedID>"
					+ "</ram:BuyerOrderReferencedDocument>");
		}
		if (trans.getContractReferencedDocument() != null) {
			xml.append("<ram:ContractReferencedDocument>"
					+ "<ram:IssuerAssignedID>"
					+ XMLTools.encodeXML(trans.getContractReferencedDocument()) + "</ram:IssuerAssignedID>"
					+ "</ram:ContractReferencedDocument>");
		}

		// Additional Documents of XRechnung (Rechnungsbegruendende Unterlagen - BG-24 XRechnung)
		if (trans.getAdditionalReferencedDocuments() != null) {
			for (final FileAttachment f : trans.getAdditionalReferencedDocuments()) {
				final String documentContent = Base64.getEncoder().encodeToString(f.getData());
				xml.append("<ram:AdditionalReferencedDocument>"
						+ "<ram:IssuerAssignedID>" + f.getFilename() + "</ram:IssuerAssignedID>"
						+ "<ram:TypeCode>916</ram:TypeCode>"
						+ "<ram:Name>" + f.getDescription() + "</ram:Name>"
						+ "<ram:AttachmentBinaryObject mimeCode=\"" + f.getMimetype() + "\"\n"
						+ "filename=\"" + f.getFilename() + "\">" + documentContent + "</ram:AttachmentBinaryObject>"
						+ "</ram:AdditionalReferencedDocument>");
			}
		}

		if (trans.getSpecifiedProcuringProjectID() != null) {
			xml.append("<ram:SpecifiedProcuringProject>"
					+ "<ram:ID>"
					+ XMLTools.encodeXML(trans.getSpecifiedProcuringProjectID()) + "</ram:ID>");
			if (trans.getSpecifiedProcuringProjectName() != null) {
				xml.append("<ram:Name >" + XMLTools.encodeXML(trans.getSpecifiedProcuringProjectName()) + "</ram:Name>");
			}
			xml.append("</ram:SpecifiedProcuringProject>");
		}
		xml.append("</ram:ApplicableHeaderTradeAgreement>"
				+ "<ram:ApplicableHeaderTradeDelivery>");
		if (this.trans.getDeliveryAddress() != null) {
			xml.append("<ram:ShipToTradeParty>" +
					getTradePartyAsXML(this.trans.getDeliveryAddress(), false, true) +
					"</ram:ShipToTradeParty>");
		}
		xml.append(" <ram:ActualDespatchSupplyChainEvent>\n" +
				"                <ram:OccurrenceDateTime>\n" +
				"                    <udt:DateTimeString\n" +
				"                            format=\"102\">"+ DATE.udtFormat(trans.getDeliveryDate() )+"</udt:DateTimeString>\n" +
				"                </ram:OccurrenceDateTime>\n" +
				"            </ram:ActualDespatchSupplyChainEvent>");

/*
		xml += "<ram:ActualDeliverySupplyChainEvent>"
				+ "<ram:OccurrenceDateTime>";

		if (trans.getDeliveryDate() != null) {
			xml += DATE.udtFormat(trans.getDeliveryDate());
		} else {
			throw new IllegalStateException("No delivery date provided");
		}
		xml += "</ram:OccurrenceDateTime>\n";
		xml += "</ram:ActualDeliverySupplyChainEvent>\n"

 */
		/*
		 * + "<DeliveryNoteReferencedDocument>\n" +
		 * "<IssueDateTime format=\"102\">20130603</IssueDateTime>\n" +
		 * "<ID>2013-51112</ID>\n" +
		 * "</DeliveryNoteReferencedDocument>\n"
		 */
		xml.append("</ram:ApplicableHeaderTradeDelivery>\n");
		// + " <IncludedSupplyChainTradeLineItem>"
		// + " <AssociatedDocumentLineDocument>"
		// + " <IncludedNote>"
		// + " <Content>Wir erlauben uns Ihnen folgende Positionen aus der Lieferung Nr.
		// 2013-51112 in Rechnung zu stellen:</Content>\n"
		// + " </IncludedNote>\n"
		// + " </AssociatedDocumentLineDocument>\n"
		// + " </IncludedSupplyChainTradeLineItem>\n";

		xml.append("</px:SupplyChainTradeTransaction>"
				+ "</SCRDMCCBDACIDAMessageStructure>");

		final byte[] zugferdRaw;
		zugferdRaw = xml.toString().getBytes(StandardCharsets.UTF_8);

		zugferdData = XMLTools.removeBOM(zugferdRaw);
	}


	@Override
	public void setProfile(Profile p) {
		profile = p;
	}

	@Override
	public Profile getProfile() {
		return profile;
	}

  @Override
  protected String buildNotes(IExportableTransaction exportableTransaction) {
    Invoice copyWithoutRebateInfo = new Invoice()
        .setOwnOrganisationFullPlaintextInfo(exportableTransaction.getOwnOrganisationFullPlaintextInfo())
        .addNotes(exportableTransaction.getNotesWithSubjectCode());
    if(exportableTransaction.getNotes() != null) {
      for (String note : exportableTransaction.getNotes()) {
        copyWithoutRebateInfo.addNote(note);
      }
    }
    Optional.ofNullable(exportableTransaction.getSubjectNote()).ifPresent(copyWithoutRebateInfo::addNote);
    return super.buildNotes(copyWithoutRebateInfo);
  }
}
