package org.mustangproject.ZUGFeRD;

public class ZUGFeRDMigrator {

	public String migrateFromV1ToV2(String xml) {
/***
 * http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
 * http://www.ferd-net.de/upload/Dokumente/FACTUR-X_ZUGFeRD_2p0_Teil1_Profil_EN16931_1p03.pdf
http://countwordsfree.com/xmlviewer
 */
		// todo: attributes may also be in single quotes, this one hardcodedly expects
		// double ones
		xml = xml.replace("\"urn:ferd:CrossIndustryDocument:invoice:1p0",
				"\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100");
		xml = xml.replace("urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12",
				"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100");
		xml = xml.replace("urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15",
				"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100");
		xml = xml.replace("rsm:CrossIndustryDocument", "rsm:CrossIndustryInvoice");
		
		xml = xml.replace("rsm:SpecifiedExchangedDocumentContext", "rsm:ExchangedDocumentContext");
		xml = xml.replace("rsm:HeaderExchangedDocument", "rsm:ExchangedDocument");
		xml = xml.replace("rsm:SpecifiedSupplyChainTradeTransaction", "rsm:SupplyChainTradeTransaction");
		xml = xml.replace("ram:ApplicableSupplyChainTradeAgreement", "ram:ApplicableHeaderTradeAgreement");
		xml = xml.replace("ram:ApplicableSupplyChainTradeDelivery", "ram:ApplicableHeaderTradeDelivery");
		xml = xml.replace("ram:ApplicableSupplyChainTradeSettlement", "ram:ApplicableHeaderTradeSettlement");
		xml = xml.replace("ram:ApplicablePercent", "ram:RateApplicablePercent");
		xml = xml.replace("ram:SpecifiedSupplyChainTradeDelivery", "ram:SpecifiedLineTradeDelivery");
		xml = xml.replace("ram:SpecifiedSupplyChainTradeSettlement", "ram:SpecifiedLineTradeSettlement");
		xml = xml.replace("ram:SpecifiedTradeSettlementMonetarySummation", "ram:SpecifiedTradeSettlementLineMonetarySummation");
		//xml = xml.replace("ram:SpecifiedTradeSettlementLineMonetarySummation", "ram:SpecifiedTradeSettlementHeaderMonetarySummation");
		//ram:SpecifiedTradeSettlementLineMonetarySummation bleibt unterhalb von ram:SpecifiedLineTradeSettlement
		//xml = xml.replace("ram:IssueDateTime","ram:FormattedIssueDateTime");
		xml = xml.replace("ram:SpecifiedTradeAccountingAccount","ram:SalesSpecifiedTradeAccountingAccount");
		xml = xml.replace("ram:SpecifiedSupplyChainTradeAgreement","ram:SpecifiedLineTradeAgreement");
		//xml = xml.replace("ram:ID","ram:GlobalID");
		
		//ram:ID unterhalb von ram:ContractReferencedDocument zu ram:IssuerAssignedID
		
		//http://www.unece.org/fileadmin/DAM/cefact/xml/XML-Naming-And-Design-Rules-V2_1.pdf
		/*
		xml = xml.replace("rsm:SpecifiedExchangedDocumentContext", "rsm:CIExchangedDocumentContext");
		xml = xml.replace("rsm:HeaderExchangedDocument", "rsm:CIIHExchangedDocument");
		xml = xml.replace("SpecifiedSupplyChainTradeTransaction", "CIIHSupplyChainTradeTransaction");
		xml = xml.replace("ram:GuidelineSpecifiedDocumentContextParameter",
				"ram:GuidelineSpecifiedCIDocumentContextParameter");
		xml = xml.replace("ram:IncludedNote", "ram:IncludedCINote");
		xml = xml.replace("ram:ApplicableSupplyChainTradeAgreement", "ram:ApplicableCIIHSupplyChainTradeAgreement");
		xml = xml.replace("ram:SellerTradeParty", "ram:SellerCITradeParty");
		xml = xml.replace("ram:BuyerTradeParty", "ram:BuyerCITradeParty");
		xml = xml.replace("ram:ApplicableSupplyChainTradeDelivery", "ram:ApplicableCIIHSupplyChainTradeDelivery");
		xml = xml.replace("ram:ApplicableSupplyChainTradeSettlement", "ram:ApplicableCIIHSupplyChainTradeSettlement");
		xml = xml.replace("ram:IncludedSupplyChainTradeLineItem", "ram:IncludedCIILSupplyChainTradeLineItem");
		xml = xml.replace("ram:AssociatedDocumentLineDocument", "ram:AssociatedCIILDocumentLineDocument");
		xml = xml.replace("ram:SpecifiedSupplyChainTradeDelivery", "ram:SpecifiedCIILSupplyChainTradeDelivery");
		xml = xml.replace("ram:SpecifiedSupplyChainTradeSettlement", "ram:SpecifiedCIILSupplyChainTradeSettlement");
		xml = xml.replace("ram:SpecifiedTradeProduct", "ram:SpecifiedCITradeProduct");
		xml = xml.replace("ram:ActualDeliverySupplyChainEvent", "ram:ActualDeliveryCISupplyChainEvent");
		xml = xml.replace("ram:SpecifiedTradeSettlementPaymentMeans", "ram:SpecifiedCITradeSettlementPaymentMeans");
		xml = xml.replace("ram:PayeePartyCreditorFinancialAccount", "ram:PayeePartyCICreditorFinancialAccount");
		xml = xml.replace("ram:PayeeSpecifiedCreditorFinancialInstitution",
				"ram:PayeeSpecifiedCICreditorFinancialInstitution");
		xml = xml.replace("ram:ApplicableTradeTax", "ram:ApplicableCITradeTax");
		xml = xml.replace("ram:ApplicablePercent", "ram:RateApplicablePercent");
		xml = xml.replace("ram:PostalTradeAddress", "ram:PostalCITradeAddress");

		xml = xml.replace("ram:ApplicableTradePaymentDiscountTerms", "ram:ApplicableCITradePaymentDiscountTerms");
		xml = xml.replace("ram:ApplicableProductCharacteristic", "ram:ApplicableCIProductCharacteristic");
		xml = xml.replace("ram:ShipToTradeParty", "ram:ShipToCITradeParty");
		xml = xml.replace("ram:ShipFromTradeParty", "ram:ShipFromCITradeParty");
		xml = xml.replace("ram:ReceivableSpecifiedTradeAccountingAccount",
				"ram:ReceivableSpecifiedCITradeAccountingAccount");
		xml = xml.replace("ram:ContractReferencedDocument", "ram:ContractReferencedCIReferencedDocument");
		// "ram:SpecifiedTradeAccountingAccount ram:SalesSpecifiedTradeAccountingAccount
		// oder ReceivablesSpecifiedTradeAccountingAccount oder
		// PurchaseSpecifiedTradeAccountingAccount
		xml = xml.replace("ram:AdditionalReferencedDocument", "ram:AdditionalReferencedCIReferencedDocument");
		xml = xml.replace("ram:TelephoneUniversalCommunication", "ram:TelephoneCIUniversalCommunication");
		xml = xml.replace("ram:EmailURIUniversalCommunication", "ram:EmailURICIUniversalCommunication");
		xml = xml.replace("ram:AdditionalReferencedDocument", "ram:AdditionalReferencedCIReferencedDocument");
		xml = xml.replace("ram:IncludedReferencedProduct", "ram:IncludedReferencedProduct");

		xml = xml.replace("ram:DefinedTradeContact", "ram:DefinedCITradeContact");
		xml = xml.replace("ram:BillingSpecifiedPeriod", "ram:BillingCISpecifiedPeriod");
		xml = xml.replace("ram:BuyerOrderReferencedDocument", "ram:BuyerOrderReferencedCIReferencedDocument");
		xml = xml.replace("ram:DeliveryNoteReferencedDocument", "ram:DeliveryNoteReferencedCIReferencedDocument");
		xml = xml.replace("ram:SpecifiedTradeAllowanceCharge", "ram:SpecifiedCITradeAllowanceCharge");
		xml = xml.replace("ram:SpecifiedLogisticsServiceCharge", "ram:SpecifiedCILogisticsServiceCharge");
		xml = xml.replace("ram:AppliedTradeAllowanceCharge", "ram:AppliedCITradeAllowanceCharge");
		xml = xml.replace("ram:InvoiceeTradeParty", "ram:InvoiceeCITradeParty");
		xml = xml.replace("ram:CategoryTradeTax", "ram:CategoryCITradeTax");
		xml = xml.replace("ram:SpecifiedTaxRegistration", "ram:SpecifiedCITaxRegistration");
		xml = xml.replace("ram:PostalTradeAddress", "ram:PostalCITradeAddress");
		xml = xml.replace("ram:SpecifiedTradePaymentTerms", "ram:SpecifiedCITradePaymentTerms");
		xml = xml.replace("ram:SpecifiedSupplyChainTradeAgreement", "ram:SpecifiedCIILSupplyChainTradeAgreement");
		xml = xml.replace("ram:GrossPriceProductTradePrice", "ram:GrossPriceProductCITradePrice");
		xml = xml.replace("ram:NetPriceProductTradePrice", "ram:NetPriceProductCITradePrice");
		xml = xml.replaceAll("(?s)\\<ram:TestIndicator.*\\/ram:TestIndicator>", "");
		// remove manually for the time being:
		// xml=xml.replaceAll("ram:TestIndicator>(.*?)/ram:TestIndicator>", "");
		// one ram:SpecifiedCIILTradeSettlementMonetarySummation will have to be
		// ram:SpecifiedCIIHTradeSettlementMonetarySummation afterwards

		String summationClose = "</ram:SpecifiedTradeSettlementMonetarySummation>";
		int posFirstSummation = xml.indexOf(summationClose) + summationClose.length();
		// if ram:SpecifiedTradeSettlementMonetarySummation were not found indexOf would
		// return -1, therefore,
		// to check if it
		if (posFirstSummation > summationClose.length()) {
			String xmlAfterFirstSummation = xml.substring(posFirstSummation);
			String xmlBeforeIncludingFirstSummation = xml.substring(0, posFirstSummation);
			// replace only once the header

			xmlBeforeIncludingFirstSummation = xmlBeforeIncludingFirstSummation.replace(
					"ram:SpecifiedTradeSettlementMonetarySummation",
					"ram:SpecifiedCIIHTradeSettlementMonetarySummation");
			// reconstruct the document now with a replaced first
			// ram:SpecifiedTradeSettlementMonetarySummation to SpecifiedCIIH...
			xml = xmlBeforeIncludingFirstSummation + xmlAfterFirstSummation;

		}
		// replace the rest of the ram:SpecifiedTradeSettlementMonetarySummation with
		// the line value SpecifiedCIIL...
		xml = xml.replace("ram:SpecifiedTradeSettlementMonetarySummation",
				"ram:SpecifiedCIILTradeSettlementMonetarySummation");

		// the rest of the ram:SpecifiedTradeSettlementMonetarySummation should be in
		// ram:ApplicableSupplyChainTradeSettlement
		// xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTradeSettlementMonetarySummation"),
		// "ram:SpecifiedCIILTradeSettlementMonetarySummation");
		 * 
		 */
		return xml;
	}

}
