<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2"
    schemaVersion="iso">
  <title>Schema for Factur-X; 1.09; EN16931-CONFORMANT-EXTENDED</title>
  <ns uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" prefix="rsm"/>
  <ns uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" prefix="qdt"/>
  <ns uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" prefix="ram"/>
  <ns uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" prefix="udt"/>
  <pattern>
    <rule context="//*[not(*) and not(normalize-space())]">
      <assert test="false" flag="warning">
	[PEPPOL-EN16931-R008]-Document MUST not contain empty elements. (still status warning)</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:AdditionalReferencedDocument">
      <assert test="(ram:IssuerAssignedID!=&apos;&apos;)">
	[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="(ram:BasisAmount)">
	[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</assert>
      <assert test="(ram:CalculatedAmount)">
	[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</assert>
      <assert test="(ram:CategoryCode)">
	[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</assert>
      <assert test="(ram:RateApplicablePercent) or (ram:CategoryCode = &apos;O&apos;)">
	[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</assert>
      <assert test="((ram:TaxPointDate) and not (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and not (ram:DueDateTypeCode))">
	[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</assert>
      <assert test="string-length(substring-after(ram:BasisAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</assert>
      <assert test="string-length(substring-after(ram:CalculatedAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;Z&apos;]">
      <assert test="../ram:CalculatedAmount = 0">
	[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-AE-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reverse charge" (AE), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-AE-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reverse charge" (AE), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value ""DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;AE&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-AE-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reverse charge" (AE), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.             </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-E-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Exempt from VAT" (E), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value ""DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-E-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Exempt from VAT" (E), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.        </assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;E&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;E&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;E&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-E-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Exempt from VAT" (E), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-G-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export  outside  the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Export  outside  the EU" (G), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-G-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export  outside  the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Export  outside  the EU" (G), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;G&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-G-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export  outside  the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Export  outside  the EU" (G), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-IC-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Intra-community supply" (K), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-IC-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Intra-community supply" (K), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;K&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-IC-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Intra-community supply" (K), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-AF-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Canary Islands tax" (L), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-AF-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Canary Islands tax" (L), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;L&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-AF-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Canary Islands tax" (L), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-AG-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Ceuta and Mellita tax" (M), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-AG-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Ceuta and Mellita tax" (M), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;M&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-AG-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Ceuta and Mellita tax" (M), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified. </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos; and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos;]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos; and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos;])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos;]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos;]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-O-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Not subject to VAT" (O), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos;]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;]/xs:decimal(ram:ActualAmount)) * 100) div 100),        &#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos;])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos;]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos;]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-O-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Not subject to VAT" (O), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos; and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos; and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;O&apos; and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-O-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Not subject to VAT" (O) and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $vATAmountBT117 in xs:decimal(ram:CalculatedAmount),&#13;&#10;        $calculatedBT117 in xs:decimal(round($basisAmount * $rate div 100 * 100) div 100)&#13;&#10;        return &#13;&#10;        (abs($vATAmountBT117 - $calculatedBT117) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($vATAmountBT117 - $calculatedBT117) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-S-09b] - For each different value of VAT rate (BT-119) where the VAT category code (BT-118) is equal to “S” ("Standard rated"), Absolute Value of (VAT  category  tax  amount  (BT-117) - VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119)/100) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level allowance amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Standard rated " (S), and the VAT rate (BT-152, BT-96, BT-103, BT-X-274) equals the VAT category rate (BT-119), and only for lines where the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or  ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-S08b]-In a VAT breakdown (BG-23), for each different value of VAT rate (BT-119) where VAT category code (BT-118) is equal to “S” ("Standard Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard Rated" (S), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified,  or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176), and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-S-08ini] - In a VAT breakdown (BG-23), for each different value of VAT rate (BT-119), where VAT category code (BT-118) is equal to “S” ("Standard Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard Rated" (S), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;S&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;S&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-S-08rev] - In a VAT breakdown (BG-23), for each different value of VAT rate (BT-119), where VAT category code (BT-118) is equal to “S” ("Standard Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard Rated" (S), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;][upper-case(ram:TypeCode) = &apos;VAT&apos;]">
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return &#13;&#10;        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-Z-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.   </assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;S&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))" flag="warning">
	[BR-FXEXT-Z-08ini] - Without Exemption reason EN16931_2017 - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.    </assert>
      <assert test="(for  &#13;&#10;        $rate in xs:decimal(ram:RateApplicablePercent),&#13;&#10;        $exempReasonText in normalize-space(ram:ExemptionReason),&#13;&#10;        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),&#13;&#10;        $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),&#13;&#10;        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;) and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos; and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),&#13;&#10;        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode=&apos;Z&apos; and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))&#13;&#10;        return      &#13;&#10;        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))" flag="warning">
	[BR-FXEXT-Z-08rev] - With Exemption reason EN16931_2026  - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert test="(ram:EndDateTime/udt:DateTimeString[@format = &apos;102&apos;]) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = &apos;102&apos;]) or not (ram:EndDateTime) or not (ram:StartDateTime)">
	[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</assert>
      <assert test="(ram:StartDateTime) or (ram:EndDateTime)">
	[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator=&apos;false&apos;]">
      <assert test="(../ram:ActualAmount)">
	[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</assert>
      <assert test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = &apos;VAT&apos;]/ram:CategoryCode)">
	[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</assert>
      <assert test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</assert>
      <assert test="true()">
	[BR-CO-05]-Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</assert>
      <assert test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</assert>
      <assert test="string-length(substring-after(../ram:ActualAmount[1],&apos;.&apos;))&lt;=2">
	[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</assert>
      <assert test="string-length(substring-after(../ram:BasisAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator=&apos;true&apos;]">
      <assert test="(../ram:ActualAmount)">
	[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</assert>
      <assert test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = &apos;VAT&apos;]/ram:CategoryCode)">
	[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</assert>
      <assert test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-FXEXT-BR-38]-Each Document level charge or tax (BG-21) shall contain a Document level charge or tax reason (BT-104) or a Document level charge reason code (BT-105) or Document level non-VAT tax code (BT-177), or both reason and code.</assert>
      <assert test="string-length(substring-after(../ram:ActualAmount[1],&apos;.&apos;))&lt;=2">
	[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</assert>
      <assert test="string-length(substring-after(../ram:BasisAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic">
      <assert test="(ram:Description) and (ram:Value)">
	[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic/ram:TypeCode">
      <assert test="not(contains(normalize-space(.), &apos; &apos;)) and contains(&apos; A AAA AAB AAC AAD AAF AAG AAH AAI AAJ AAK AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABS ABT ABX ABY ABZ ACA ACE ACG ACN ACP ACS ACV ACW ACX ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX B BL BMY BMZ BNA BNB BNC BND BNE BNF BNG BNH BNI BNJ BNK BNL BNM BNN BNO BNP BNQ BNR BNS BNT BNU BNV BNW BNX BNY BNZ BR BRA BRB BRC BRD BRE BRF BRG BRH BRI BRJ BRK BRL BRM BRN BRO BRP BRQ BRR BRS BRT BRU BRV BS BSW BSX BSY BSZ BTA BTB BTC BTD BTE BTF BTG BTH BTI BTJ BTK BTL BTM BW CHN CHO CM CT CV CZ D DI DL DN DP DR DS DW E EA F FI FL FN FV GG GW HF HM HT IB ID L LM LN LND M MO MW N OD PRS PTN RA RF RJ RMW RP RUN RY SQ T TC TH TN TT VGM VH VW WA WD WM WU XH XQ XZ YS ZAL ZAS ZB ZBI ZC ZCA ZCB ZCE ZCL ZCO ZCR ZCU ZFE ZFS ZGE ZH ZK ZMG ZMN ZMO ZN ZNA ZNB ZNI ZO ZP ZPB ZS ZSB ZSE ZSI ZSL ZSN ZTA ZTE ZTI ZV ZW ZWA ZZN ZZR ZZZ BEST_BEFORE_DATE COLOR_TEXT COMMISSION DEPOSIT_SYSTEM DEPOSIT_TYPE ENERGY_CLASS EXPIRATION_DATE FEE KIND_OF_ARTICLE MATERIAL METER_LOCATION METER_NUMBER ORGANIC_CONTROL_BODY PACKAGING_MATERIAL PACKAGING_TYPE PROMOTIONAL_VARIANT SEAL_NUMBER SIZE_CODE SIZE_TEXT TRADING_UNIT WASTE_CODE WASTE_FRACTION WEEE_NUMBER &apos;, concat(&apos; &apos;, normalize-space(.), &apos; &apos;))" flag="warning">
	[BR-FXEXT-04]-To ensure automated processing of the article attributes without bilateral reconciliation, only values from the code list UNTDED 6313+Factur-X-Extension should be used. </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableTradeSettlementFinancialCard">
      <assert test="string-length(normalize-space(ram:ID)) &lt;= 10">
	[BR-51]-In accordance with card payments security standards an invoice should never include a full card primary account number (BT-87). At the moment PCI Security Standards Council has defined that the first 6 digits and last 4 digits are the maximum number of digits to be shown.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:AssociatedDocumentLineDocument/ram:IncludedNote[ram:SubjectCode]">
      <assert test="(ram:ContentCode) or (ram:Content)">
	[BR-FXEXT-02]-If the invoice line item free text subject code (BT-X-10) is specified, either the coded invoice line item free text (BT-X-9) or the invoice line item free text (BT-127) must be specified, or both. If both BT-X-9 and BT-127 are specified, both must have the same meaning.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem">
      <assert test="  not(&#13;&#10;        (&#13;&#10;          normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID) != &apos;&apos;&#13;&#10;          and&#13;&#10;          normalize-space(&#13;&#10;            (ram:LineStatusReasonCode&#13;&#10;             | ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode&#13;&#10;             | ram:SpecifiedLineTradeSettlement/ram:LineStatusReasonCode)[1]&#13;&#10;          ) = &apos;&apos;&#13;&#10;        )&#13;&#10;        or&#13;&#10;        (&#13;&#10;          (some $other in ../ram:IncludedSupplyChainTradeLineItem&#13;&#10;           satisfies (&#13;&#10;             not($other is .)&#13;&#10;             and normalize-space($other/ram:AssociatedDocumentLineDocument/ram:ParentLineID)&#13;&#10;                 = normalize-space(ram:AssociatedDocumentLineDocument/ram:LineID)&#13;&#10;           ))&#13;&#10;          and&#13;&#10;          normalize-space(&#13;&#10;            (ram:LineStatusReasonCode&#13;&#10;             | ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode&#13;&#10;             | ram:SpecifiedLineTradeSettlement/ram:LineStatusReasonCode)[1]&#13;&#10;          ) = &apos;&apos;&#13;&#10;        )&#13;&#10;      )">
	[BR-FXEXT-06]-If the "ID of the parent line" (BT-X-304) is used, the "Subtype of the invoice item" (BT-X-8) must be specified for each item (BG-25)"</assert>
      <assert test="every $item in //ram:IncludedSupplyChainTradeLineItem[&#13;&#10;        ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;GROUP&apos;&#13;&#10;        and normalize-space(ram:SpecifiedLineTradeSettlement/&#13;&#10;                            ram:SpecifiedTradeSettlementLineMonetarySummation/&#13;&#10;                            ram:LineTotalAmount) != &apos;&apos;&#13;&#10;      ]&#13;&#10;      satisfies&#13;&#10;        number(normalize-space($item/ram:SpecifiedLineTradeSettlement/&#13;&#10;                               ram:SpecifiedTradeSettlementLineMonetarySummation/&#13;&#10;                               ram:LineTotalAmount))&#13;&#10;        =&#13;&#10;        sum(&#13;&#10;          for $child in //ram:IncludedSupplyChainTradeLineItem[&#13;&#10;            normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID)&#13;&#10;              = normalize-space($item/ram:AssociatedDocumentLineDocument/ram:LineID)&#13;&#10;            and (ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;&#13;&#10;                 or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;GROUP&apos;)&#13;&#10;          ]&#13;&#10;          return number(normalize-space(&#13;&#10;            $child/ram:SpecifiedLineTradeSettlement/&#13;&#10;            ram:SpecifiedTradeSettlementLineMonetarySummation/&#13;&#10;            ram:LineTotalAmount))&#13;&#10;        )">
	[BR-FXEXT-08]-If the "Subtype of invoice item" (BT-X-8) has the value "Subtotal" (GROUP) and the "Net amount of the invoice item" (BT-131) is specified, it must correspond to the sum of the BT-131 of the next lower levels for which the "Subtype of the invoice item" (BT-X-8) has the value "Regular item (standard case)" (DETAIL) or "Subtotal" (GROUP). As a consequence, all lower levels shall contain a BT-131 value, when BT-X-8 has the value DETAIL or GROUP.</assert>
      <assert test="(ram:AssociatedDocumentLineDocument/ram:LineID!=&apos;&apos;)">
	[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</assert>
      <assert test="(ram:SpecifiedTradeProduct/ram:Name!=&apos;&apos;)">
	[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</assert>
      <assert test="ram:SpecifiedTradeProduct/ram:GlobalID/@schemeID!=&apos;&apos; or not (ram:SpecifiedTradeProduct/ram:GlobalID)">
	[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</assert>
      <assert test="(ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode/@listID!=&apos;&apos;) or not (ram:SpecifiedTradeProduct/ram:DesignatedProductClassification)">
	[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</assert>
      <assert test="string-length(substring-after(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem&#13;&#10;               [normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID) != &apos;&apos;]">
      <assert test="some $p in //ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID&#13;&#10;      satisfies normalize-space($p)&#13;&#10;                = normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID)&#13;&#10;    ">
	[BR-FXEXT-11]-Each "ID of parent line" (BT-X-304) must refer to an existing "ID of invoice item" (BT-126).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument[not(ram:LineStatusReasonCode) or ram:LineStatusReasonCode = &apos;DETAIL&apos;]">
      <assert test="(../ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)">
	[BR-FXEXT-BR-22]-Each invoice line item "INVOICE LINE" (BG-25) must contain the quantity of goods or services invoiced in the relevant line item as a line item "Invoiced quantity" (BT-129) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
      <assert test="(../ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode)">
	[BR-FXEXT-BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
      <assert test="(../ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)">
	[BR-FXEXT-BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131), if the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert test="(../ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)">
	[BR-FXEXT-BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
      <assert test="(../ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[upper-case(ram:TypeCode) = &apos;VAT&apos;]/ram:CategoryCode)">
	[BR-FXEXT-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;GROUP&apos; and exists(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)]">
      <assert test="(for&#13;&#10;        $lineID in ram:AssociatedDocumentLineDocument/ram:LineID,&#13;&#10;        $numberChildWG in count(//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID = $lineID and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;GROUP&apos;]),&#13;&#10;        $numberChildWGAndBT131 in count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID = $lineID and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;GROUP&apos;]/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)&#13;&#10;        return&#13;&#10;        ($numberChildWG = $numberChildWGAndBT131))">
	[BR-FXEXT-12]-If the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value  "GROUP" and if the "Invoice line net amount" (BT-131) is specified, all lower levels which has "Subtype of invoice line item" (EXT-FR-FE-163) equal to "GROUP" MUST contain a "Invoice line net amount" (BT-131) value.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:PayeeTradeParty">
      <assert test="(ram:Name) and (not(ram:Name = ../ram:SellerTradeParty/ram:Name) and not(ram:ID = ../ram:SellerTradeParty/ram:ID) and not(ram:SpecifiedLegalOrganization/ram:ID = ../ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID))">
	[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTaxRepresentativeTradeParty">
      <assert test="normalize-space(ram:Name) != &apos;&apos;">
	[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert test="(ram:PostalTradeAddress)">
	[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert test="normalize-space(ram:PostalTradeAddress/ram:CountryID) != &apos;&apos;">
	[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert test="(ram:SpecifiedTaxRegistration/ram:ID[@schemeID=&apos;VA&apos;]!=&apos;&apos;)">
	[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTradeParty">
      <assert test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID=&apos;VA&apos;])">
	[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert test="(ram:EndDateTime/udt:DateTimeString[@format = &apos;102&apos;]) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = &apos;102&apos;]) or not (ram:EndDateTime) or not (ram:StartDateTime)">
	[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</assert>
      <assert test="(ram:StartDateTime) or (ram:EndDateTime)">
	[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = &apos;false&apos;]">
      <assert test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = &apos;false&apos;]&#13;&#10;">
      <assert test="(../ram:ActualAmount)">
	[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</assert>
      <assert test="true()">
	[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</assert>
      <assert test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</assert>
      <assert test="string-length(substring-after(../ram:ActualAmount[1],&apos;.&apos;))&lt;=2">
	[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</assert>
      <assert test="string-length(substring-after(../ram:BasisAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = &apos;true&apos;]">
      <assert test="(../ram:ActualAmount)">
	[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</assert>
      <assert test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-FXEXT-BR-44]-Each Invoice line charge or tax (BG-28) shall have an Invoice line charge or tax reason (BT-144), an Invoice line charge reason code (BT-145) or an Invoice line-level non-VAT tax type code (BT-193).</assert>
      <assert test="string-length(substring-after(../ram:ActualAmount[1],&apos;.&apos;))&lt;=2">
	[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</assert>
      <assert test="string-length(substring-after(../ram:BasisAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID=&apos;VA&apos;]">
      <assert test="contains(&apos; 1A AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW &apos;, concat(&apos; &apos;, substring(.,1,2), &apos; &apos;))">
	[BR-CO-09]-The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[not(ancestor::ram:SellerTradeParty)]">
      <assert test="@schemeID=&apos;VA&apos;">
	[BR-FXEXT-03]-Only a VAT registration ID may be provided for the following business partners: the line level Ship-To (BT-X-66), the line level Ultimate-Ship-To (BT-X-84), the Sales-Agent (BT-X-340), the Buyer-Tax-Representative (BT-X-367), the Product-Enduser (BT-X-144), the Buyer-Agent (BT-X-411), the document level Ship-To (BT-X-161), the document level Ultimate-Ship-To (BT-X-180), the Ship-From (BT-X-199), the Invoicer (BT-X-223), the Invoicee (BT-X-242), the document level Payee (BT-X-257), the Payer (BT-X-481), or the payment-term-specific Payee (BT-X-509).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge">
      <assert test="(ram:ChargeIndicator)">
	[CII-SR-463]-Each Specified Trade Allowance Charge (BG-20)(BG-21) shall contain a Charge Indicator.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;AE&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;E&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;G&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;K&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-AF-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	[BR-AF-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-AG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt;= 0">
	[BR-AG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="not(ram:RateApplicablePercent)">
	[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;S&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;Z&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;AE&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;E&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;G&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;K&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-AF-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	[BR-AF-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-AG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt;= 0">
	[BR-AG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="not(ram:RateApplicablePercent)">
	[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;S&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;Z&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert test="for $calculatedAmount in xs:decimal(round(sum(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)&#13;&#10; or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * xs:decimal(100)) div xs:decimal(100)),&#13;&#10;            $totalAmount in xs:decimal(ram:LineTotalAmount),&#13;&#10;            $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem)),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $nbLineItems * $tolerance,&#13;&#10;            $diff in xs:decimal($totalAmount - $calculatedAmount),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance">
	[BR-FXEXT-CO-10]-Absolute Value of (Sum of Invoice line net amount (BT-106) - Σ Invoice line net amounts (BT-131))&lt;= 0,01 * Number of line net amounts (BT-131).</assert>
      <assert test="(ram:LineTotalAmount)">
	[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</assert>
      <assert test="(ram:TaxBasisTotalAmount)">
	[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</assert>
      <assert test="(ram:GrandTotalAmount)">
	[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</assert>
      <assert test="(ram:DuePayableAmount)">
	[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</assert>
      <assert test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]) and not (ram:AllowanceTotalAmount)) or&#13;&#10;(for $calculatedAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:ActualAmount)* 10 * 10 ) div 100),&#13;&#10;            $totalAmount in xs:decimal(ram:AllowanceTotalAmount),&#13;&#10;            $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;])),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $nbAllowanceItems * $tolerance,&#13;&#10;            $diff in xs:decimal($totalAmount - $calculatedAmount),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance)">
	[BR-FXEXT-CO-11]-Absolute Value of (Sum of allowances on document level (BT-107) - Σ Document level allowance amounts (BT-92))&lt;= 0,01 * Number of Document level allowance amounts (BT-92).</assert>
      <assert test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;])and not (ram:ChargeTotalAmount)) &#13;&#10;or&#13;&#10;(for $calculatedAmount in xs:decimal(xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:ActualAmount)* 100 ) div 100)+ xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100)),&#13;&#10;            $totalAmount in xs:decimal(ram:ChargeTotalAmount),&#13;&#10;                        $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $nbChargeItems * $tolerance,&#13;&#10;            $diff in xs:decimal($totalAmount - $calculatedAmount),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance)">
	[BR-FXEXT-CO-12]-Absolute Value of (Sum of charges on document level (BT-108) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272))&lt;= 0,01 * (Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)).</assert>
      <assert test="for $BT109 in xs:decimal(ram:TaxBasisTotalAmount),&#13;&#10;			$BT131Sum in xs:decimal(round(sum(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)&#13;&#10; or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;]/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * xs:decimal(100)) div xs:decimal(100)),&#13;&#10;			$BT92Sum in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:ActualAmount)* 10 * 10 ) div 100),&#13;&#10;			$BT99Sum in xs:decimal(xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:ActualAmount)* 100 ) div 100)+ xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100)),&#13;&#10;			$nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)&#13;&#10; or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;])),&#13;&#10;			$nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;])),&#13;&#10;			$nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),&#13;&#10;            $diff in xs:decimal($BT109 - $BT131Sum + $BT92Sum - $BT99Sum),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance">
	[BR-FXEXT-CO-13]-Absolute Value of (Invoice total amount without VAT (BT-109) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99)) &lt;= 0,01 * (Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99)).</assert>
      <assert test="for $Currency in ../ram:InvoiceCurrencyCode,&#13;&#10;			$BT109 in xs:decimal(ram:TaxBasisTotalAmount),&#13;&#10;			$BT110 in xs:decimal(ram:TaxTotalAmount[@currencyID=$Currency]),			&#13;&#10;			$BT112 in xs:decimal(ram:GrandTotalAmount),&#13;&#10;			$nbTaxTotalAmountInvoiceCurrency in count (ram:TaxTotalAmount[@currencyID=$Currency] ),&#13;&#10;			$nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)&#13;&#10; or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = &apos;DETAIL&apos;])),&#13;&#10;			$nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;])),&#13;&#10;			$nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10;			$tolerance in xs:decimal(0.01),&#13;&#10;			$maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),&#13;&#10;			$diff in xs:decimal($BT112 - $BT110 - $BT109),&#13;&#10;			$abs in xs:decimal(abs($diff))&#13;&#10;return&#13;&#10;		($abs le $maxTolerance and $nbTaxTotalAmountInvoiceCurrency eq 1) or&#13;&#10;		($BT109 eq $BT112 and $nbTaxTotalAmountInvoiceCurrency ne 1)">
	[BR-FXEXT-CO-15]-If Invoice Total VAT amount (BT-110) ,where currency (BT-110-0) is equal to BT-5, is present, then the Absolute Value of (Invoice total amount with VAT (BT-112) - Invoice total amount without VAT (BT-109) - Invoice total VAT amount (BT-110)) &lt;= 0,01 * (Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charges amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272). Else, Invoice total amount with VAT (BT-112) is equal to Invoice total amount without VAT (BT-109).</assert>
      <assert test="xs:decimal(ram:DuePayableAmount) = xs:decimal(sum(ram:GrandTotalAmount/xs:decimal(.))) - xs:decimal(sum(ram:TotalPrepaidAmount/xs:decimal(.))) + xs:decimal(sum(ram:RoundingAmount/xs:decimal(.))) + xs:decimal(sum(../ram:SpecifiedFinancialAdjustment/ram:ActualAmount/xs:decimal(.)))">
	[BR-FXEXT-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) + Rounding amount (BT-114) + Sum of Charge amount collected on behalf of a third party (BT-179).</assert>
      <assert test="string-length(substring-after(ram:LineTotalAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</assert>
      <assert test="string-length(substring-after(ram:AllowanceTotalAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowances on document level (BT-107) is 2.</assert>
      <assert test="string-length(substring-after(ram:ChargeTotalAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</assert>
      <assert test="string-length(substring-after(ram:TaxBasisTotalAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</assert>
      <assert test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]">
	[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</assert>
      <assert test="string-length(substring-after(ram:GrandTotalAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</assert>
      <assert test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and . = round(. * 100) div 100) or not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">
	[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</assert>
      <assert test="string-length(substring-after(ram:TotalPrepaidAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</assert>
      <assert test="string-length(substring-after(ram:RoundingAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</assert>
      <assert test="string-length(substring-after(ram:DuePayableAmount,&apos;.&apos;))&lt;=2">
	[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.</assert>
      <assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) or (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and (ram:TaxTotalAmount/@currencyID = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) and not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode))">
	[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]">
      <assert test=". = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount)*10*10)div 100)">
	[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans">
      <assert test="(ram:TypeCode)">
	[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</assert>
      <assert test="(ram:PayeeSpecifiedCreditorFinancialInstitution or ram:PayerSpecifiedDebtorFinancialInstitution) or (not(ram:PayeeSpecifiedCreditorFinancialInstitution) and not(ram:PayerSpecifiedDebtorFinancialInstitution))">
	[CII-SR-464]-Only one BT-86 element is allowed on an invoice.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode=&apos;30&apos; or ram:TypeCode=&apos;58&apos;]/ram:PayeePartyCreditorFinancialAccount">
      <assert test="normalize-space(ram:IBANID) != &apos;&apos; or normalize-space(ram:ProprietaryID) != &apos;&apos;">
	[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-16) information is provided in the Invoice.</assert>
      <assert test="(ram:IBANID) or (ram:ProprietaryID)">
	[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans[some $code in tokenize(&apos;30 58&apos;, &apos;\s&apos;)  satisfies normalize-space(ram:TypeCode) = $code]">
      <assert test="(ram:PayeePartyCreditorFinancialAccount/ram:IBANID or ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID) and not(ram:PayeePartyCreditorFinancialAccount/ram:IBANID and ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID)&#13;&#10;">
	[BR-CO-27]-Either the IBAN or a Proprietary ID (BT-84) shall be used.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert test="ram:ApplicableTradeTax">
	[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;AE&apos;]">
      <assert test="../ram:CalculatedAmount = 0">
	[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-AE-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;E&apos;]">
      <assert test="../ram:CalculatedAmount = 0">
	[BR-E-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-E-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;G&apos;]">
      <assert test="../ram:CalculatedAmount = 0">
	[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-G-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.= &apos;K&apos;]">
      <assert test="../ram:CalculatedAmount = 0">
	[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-IC-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
      <assert test="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)">
	[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</assert>
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
	[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="true()">
	[BR-AF-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="true()">
	[BR-AG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="ram:CalculatedAmount = 0">
	[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</assert>
      <assert test="(ram:ExemptionReason) or (ram:ExemptionReasonCode)">
	[BR-O-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;AE&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;E&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;G&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;K&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-AF-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	[BR-AF-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be greater than 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-AG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt;= 0">
	[BR-AG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="not(ram:RateApplicablePercent)">
	[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;S&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;Z&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = (&apos;VA&apos;, &apos;FC&apos;)] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//udt:DateTimeString[@format = &apos;102&apos;]">
      <assert test="matches(.,&apos;^\s*(\d{4})(1[0-2]|0[1-9]){1}(3[01]|[12][0-9]|0[1-9]){1}\s*$&apos;)">
	[CII-DT-097]-Date time string with format attribute 102 shall be YYYYMMDD.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//udt:DateTimeString[@format = &apos;205&apos;]">
      <assert test="matches(., &apos;^\s*(\d{4})(1[0-2]|0[1-9])(3[01]|[12][0-9]|0[1-9])([01][0-9]|2[0-3])[0-5][0-9]\s*$&apos;)">
	[BR-FXEXT-CII-DT-097a]-Date time string with format attribute 205 shall be YYYYMMDDHHMMSS.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="//ram:IncludedSupplyChainTradeLineItem">
	[BR-16]-An Invoice shall have at least one Invoice line (BG-25).</assert>
      <assert test="(number(//ram:DuePayableAmount) &gt; 0 and ((//ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime) or (//ram:SpecifiedTradePaymentTerms/ram:Description))) or not(number(//ram:DuePayableAmount) &gt; 0)">
	[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</assert>
      <assert test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != &apos;&apos;)">
	[BR-01]-An Invoice shall have a Specification identifier (BT-24).</assert>
      <assert test="(rsm:ExchangedDocument/ram:ID !=&apos;&apos;)">
	[BR-02]-An Invoice shall have an Invoice number (BT-1).</assert>
      <assert test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format=&apos;102&apos;]!=&apos;&apos;)">
	[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</assert>
      <assert test="(rsm:ExchangedDocument/ram:TypeCode!=&apos;&apos;)">
	[BR-04]-An Invoice shall have an Invoice type code (BT-3).</assert>
      <assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!=&apos;&apos;)">
	[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</assert>
      <assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!=&apos;&apos;)">
	[BR-06]-An Invoice shall contain the Seller name (BT-27).</assert>
      <assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!=&apos;&apos;)">
	[BR-07]-An Invoice shall contain the Buyer name (BT-44).</assert>
      <assert test="//ram:SellerTradeParty/ram:PostalTradeAddress">
	[BR-08]-An Invoice shall contain the Seller postal address (BG-5).</assert>
      <assert test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=&apos;&apos;">
	[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</assert>
      <assert test="//ram:BuyerTradeParty/ram:PostalTradeAddress">
	[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</assert>
      <assert test="//ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID!=&apos;&apos;">
	[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</assert>
      <assert test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != &apos;&apos; or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication)">
	[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</assert>
      <assert test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != &apos;&apos; or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication)">
	[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.</assert>
      <assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;])) and     ((count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;S&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode=&apos;S&apos;]))">
	[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;Z&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;]) or exists(//ram:CategoryTradeTax[ram:CategoryCode=&apos;Z&apos;])))">
	[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;E&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;]) or exists(//ram:CategoryTradeTax[ram:CategoryCode=&apos;E&apos;])))">
	[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Exempt from VAT” shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;AE&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;]) or exists(//ram:CategoryTradeTax[ram:CategoryCode=&apos;AE&apos;])))">
	[BR-AE-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Reverse charge" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;K&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;]) or exists(//ram:CategoryTradeTax[ram:CategoryCode=&apos;K&apos;])))">
	[BR-IC-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Intra-community supply" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;G&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;]) or exists(//ram:CategoryTradeTax[ram:CategoryCode=&apos;G&apos;])))">
	[BR-G-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</assert>
      <assert test="not(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;]) or ( &#13;&#10;    count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;])=1 and &#13;&#10;    (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;]) or&#13;&#10;    exists(//ram:CategoryTradeTax[ram:CategoryCode=&apos;O&apos;])))">
	[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</assert>
      <assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;])) and &#13;&#10;    ((count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;L&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode=&apos;L&apos;]))">
	[BR-AF-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IGIC" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</assert>
      <assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;])) and &#13;&#10;    ((count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;M&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode=&apos;M&apos;]))">
	[BR-AG-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IPSI" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</assert>
      <assert test="(not(//ram:CountryID != &apos;IT&apos;) and //ram:CategoryCode =&apos;B&apos;) or (not(//ram:CategoryCode =&apos;B&apos;))">
	[BR-B-01]-An Invoice where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment” shall be a domestic Italian invoice.</assert>
      <assert test="(//ram:CategoryCode =&apos;B&apos; and (not(//ram:CategoryCode =&apos;S&apos;))) or (not(//ram:CategoryCode =&apos;B&apos;))">
	[BR-B-02]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment" shall not contain an invoice line (BG-25), a Document level allowance (BG-20) or  a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated”.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode]">
      <assert test="(ram:ContentCode) or (ram:Content)">
	[BR-FXEXT-01]-If the Invoice Free Text subject Code (BT-21) is specified, either the coded message free text (BT-X-5) or the message free text (BT-22) must be specified, or both. If both BT-X-5 and BT-22 are specified, both must have the same meaning.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert test="not(ram:SellerTradeParty/ram:DefinedTradeContact/ram:PersonName and ram:SellerTradeParty/ram:DefinedTradeContact/ram:DepartmentName)">
	[CII-SR-465]-Only one BT-41 element is allowed on an invoice.</assert>
      <assert test="not(ram:BuyerTradeParty/ram:DefinedTradeContact/ram:PersonName and ram:BuyerTradeParty/ram:DefinedTradeContact/ram:DepartmentName)">
	[CII-SR-466]-Only one BT-56 element is allowed on an invoice.</assert>
      <assert test="count(ram:SellerTradeParty)=1">
	Element 'ram:SellerTradeParty' must occur exactly 1 times.</assert>
      <assert test="count(ram:BuyerTradeParty)=1">
	Element 'ram:BuyerTradeParty' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery">
      <assert test="(ram:ShipToTradeParty/ram:PostalTradeAddress and ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID!=&apos;&apos;) or not (ram:ShipToTradeParty/ram:PostalTradeAddress)">
	[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <assert test="(ram:IssuerAssignedID!=&apos;&apos;)">
	[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</assert>
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
      <assert test="count(ram:Name)&lt;=1">
	Element 'ram:Name' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:LanguageID)&lt;=1">
	Element 'ram:LanguageID' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod">
      <assert test="count(ram:CompleteDateTime)=1">
	Element 'ram:CompleteDateTime' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:CompleteDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:EndDateTime">
      <report test="true()">
	Element 'ram:EndDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:StartDateTime">
      <report test="true()">
	Element 'ram:StartDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote">
      <assert test="count(ram:Content)&lt;=1">
	Element 'ram:Content' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SubjectCode)&lt;=1">
	Element 'ram:SubjectCode' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:ContentCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue5" value="."/>
      <assert test="string-length($codeValue5)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=5]/enumeration[@value=$codeValue5]">
	Value of 'ram:SubjectCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:LanguageID">
      <let name="codeValue4" value="."/>
      <assert test="string-length($codeValue4)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=4]/enumeration[@value=$codeValue4]">
	Value of 'ram:LanguageID' is not allowed.</assert>
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <let name="codeValue2" value="."/>
      <assert test="string-length($codeValue2)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <assert test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1">
	Element 'ram:BusinessProcessSpecifiedDocumentContextParameter' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1">
	Element 'ram:GuidelineSpecifiedDocumentContextParameter' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID">
      <let name="codeValue1" value="."/>
      <assert test="string-length($codeValue1)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=1]/enumeration[@value=$codeValue1]">
	Value of 'ram:ID' is not allowed.</assert>
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction">
      <assert test="count(ram:IncludedSupplyChainTradeLineItem)&gt;=1">
	Element 'ram:IncludedSupplyChainTradeLineItem' must occur at least 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ not(ram:TypeCode=&quot;916&quot;) and  not(ram:TypeCode=&quot;50&quot;) and  not(ram:TypeCode=&quot;130&quot;)]">
      <report test="true()">
	Element variant 'ram:AdditionalReferencedDocument[ not(ram:TypeCode="916") and  not(ram:TypeCode="50") and  not(ram:TypeCode="130")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:ReferenceTypeCode">
      <let name="codeValue20" value="."/>
      <assert test="string-length($codeValue20)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:TypeCode">
      <let name="codeValue40" value="."/>
      <assert test="string-length($codeValue40)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=40]/enumeration[@value=$codeValue40]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:TypeCode">
      <let name="codeValue39" value="."/>
      <assert test="string-length($codeValue39)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=39]/enumeration[@value=$codeValue39]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:Name)&lt;=1">
	Element 'ram:Name' may occur at maximum 1 times.</assert>
      <assert test="count(ram:AttachmentBinaryObject)&lt;=1">
	Element 'ram:AttachmentBinaryObject' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject">
      <assert test="@mimeCode">
	Attribute '@mimeCode' is required in this context.</assert>
      <let name="codeValue19" value="@mimeCode"/>
      <assert test="string-length($codeValue19)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">
	Value of '@mimeCode' is not allowed.</assert>
      <assert test="@filename">
	Attribute '@filename' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:TypeCode">
      <let name="codeValue38" value="."/>
      <assert test="string-length($codeValue38)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=38]/enumeration[@value=$codeValue38]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <assert test="count(ram:DeliveryTypeCode)=1">
	Element 'ram:DeliveryTypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:DeliveryTypeCode">
      <let name="codeValue36" value="."/>
      <assert test="string-length($codeValue36)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=36]/enumeration[@value=$codeValue36]">
	Value of 'ram:DeliveryTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:RelevantTradeLocation/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)=1">
	Element 'ram:SpecifiedTaxRegistration' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue34" value="@schemeID"/>
      <assert test="string-length($codeValue34)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=34]/enumeration[@value=$codeValue34]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode">
      <let name="codeValue37" value="."/>
      <assert test="string-length($codeValue37)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=37]/enumeration[@value=$codeValue37]">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)=1">
	Element 'ram:SpecifiedTaxRegistration' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue35" value="@schemeID"/>
      <assert test="string-length($codeValue35)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=35]/enumeration[@value=$codeValue35]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent">
      <assert test="count(ram:OccurrenceDateTime)=1">
	Element 'ram:OccurrenceDateTime' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment/ram:SpecifiedLogisticsTransportMovement">
      <assert test="count(ram:ModeCode)=1">
	Element 'ram:ModeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment/ram:SpecifiedLogisticsTransportMovement/ram:ModeCode">
      <let name="codeValue41" value="."/>
      <assert test="string-length($codeValue41)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=41]/enumeration[@value=$codeValue41]">
	Value of 'ram:ModeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert test="count(ram:PaymentReference)&lt;=1">
	Element 'ram:PaymentReference' may occur at maximum 1 times.</assert>
      <assert test="count(ram:InvoiceCurrencyCode)=1">
	Element 'ram:InvoiceCurrencyCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:ApplicableTradeTax)&gt;=1">
	Element 'ram:ApplicableTradeTax' must occur at least 1 times.</assert>
      <assert test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">
	Element 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:BasisAmount)=1">
	Element 'ram:BasisAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:LineTotalBasisAmount)&lt;=1">
	Element 'ram:LineTotalBasisAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:AllowanceChargeBasisAmount)&lt;=1">
	Element 'ram:AllowanceChargeBasisAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <let name="codeValue27" value="."/>
      <assert test="string-length($codeValue27)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=27]/enumeration[@value=$codeValue27]">
	Value of 'ram:DueDateTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert test="string-length($codeValue25)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:LineTotalBasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue44" value="@format"/>
      <assert test="string-length($codeValue44)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=44]/enumeration[@value=$codeValue44]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert test="string-length($codeValue26)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:CompleteDateTime">
      <report test="true()">
	Element 'ram:CompleteDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert test="string-length($codeValue42)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=42]/enumeration[@value=$codeValue42]">
	Value of 'ram:InvoiceCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">
      <let name="codeValue51" value="."/>
      <assert test="string-length($codeValue51)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=51]/enumeration[@value=$codeValue51]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:TypeCode">
      <let name="codeValue52" value="."/>
      <assert test="string-length($codeValue52)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=52]/enumeration[@value=$codeValue52]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment">
      <assert test="count(ram:IncludedTradeTax)&gt;=1">
	Element 'ram:IncludedTradeTax' must occur at least 1 times.</assert>
      <assert test="count(ram:InvoiceSpecifiedReferencedDocument)&lt;=1">
	Element 'ram:InvoiceSpecifiedReferencedDocument' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:FormattedReceivedDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax">
      <assert test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert test="string-length($codeValue25)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert test="string-length($codeValue26)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:TypeCode">
      <let name="codeValue53" value="."/>
      <assert test="string-length($codeValue53)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=53]/enumeration[@value=$codeValue53]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:PaidAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedFinancialAdjustment">
      <assert test="count(ram:Reason)=1">
	Element 'ram:Reason' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedFinancialAdjustment/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge">
      <assert test="count(ram:Description)=1">
	Element 'ram:Description' must occur exactly 1 times.</assert>
      <assert test="count(ram:AppliedAmount)=1">
	Element 'ram:AppliedAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:AppliedTradeTax)&gt;=1">
	Element 'ram:AppliedTradeTax' must occur at least 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:RateApplicablePercent)=1">
	Element 'ram:RateApplicablePercent' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue48" value="."/>
      <assert test="string-length($codeValue48)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=48]/enumeration[@value=$codeValue48]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert test="string-length($codeValue26)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryTradeTax)=1">
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert test="string-length($codeValue25)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert test="string-length($codeValue26)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue45" value="."/>
      <assert test="string-length($codeValue45)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=45]/enumeration[@value=$codeValue45]">
	Value of 'ram:ReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryTradeTax)=1">
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert test="string-length($codeValue25)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert test="string-length($codeValue26)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[ not(not (@listID)) and  not(@listID=&quot;5153&quot;)]">
      <report test="true()">
	Element variant 'ram:ReasonCode[ not(not (@listID)) and  not(@listID="5153")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[@listID=&quot;5153&quot;]">
      <let name="codeValue47" value="."/>
      <assert test="string-length($codeValue47)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=47]/enumeration[@value=$codeValue47]">
	Value of 'ram:ReasonCode[@listID="5153"]' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[not (@listID)]">
      <let name="codeValue46" value="."/>
      <assert test="string-length($codeValue46)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=46]/enumeration[@value=$codeValue46]">
	Value of 'ram:ReasonCode[not (@listID)]' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms">
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:DirectDebitMandateID)&lt;=1">
	Element 'ram:DirectDebitMandateID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:PartialPaymentAmount)&lt;=1">
	Element 'ram:PartialPaymentAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:PayeeTradeParty)&lt;=1">
	Element 'ram:PayeeTradeParty' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms/ram:ActualDiscountAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms/ram:BasisDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:ActualPenaltyAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisPeriodMeasure">
      <assert test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PartialPaymentAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert test="count(ram:LineTotalAmount)=1">
	Element 'ram:LineTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:ChargeTotalAmount)&lt;=1">
	Element 'ram:ChargeTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:AllowanceTotalAmount)&lt;=1">
	Element 'ram:AllowanceTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TaxBasisTotalAmount)=1">
	Element 'ram:TaxBasisTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert test="count(ram:RoundingAmount)&lt;=1">
	Element 'ram:RoundingAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GrandTotalAmount)=1">
	Element 'ram:GrandTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TotalPrepaidAmount)&lt;=1">
	Element 'ram:TotalPrepaidAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:DuePayableAmount)=1">
	Element 'ram:DuePayableAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]">
      <report test="true()">
	Element variant 'ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]">
      <let name="codeValue49" value="@currencyID"/>
      <assert test="string-length($codeValue49)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=49]/enumeration[@value=$codeValue49]">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]">
      <let name="codeValue50" value="@currencyID"/>
      <assert test="string-length($codeValue50)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=50]/enumeration[@value=$codeValue50]">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:Information)&lt;=1">
	Element 'ram:Information' may occur at maximum 1 times.</assert>
      <assert test="count(ram:PayeePartyCreditorFinancialAccount)&lt;=1">
	Element 'ram:PayeePartyCreditorFinancialAccount' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution">
      <assert test="count(ram:BICID)=1">
	Element 'ram:BICID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount">
      <assert test="count(ram:IBANID)=1">
	Element 'ram:IBANID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerSpecifiedDebtorFinancialInstitution/ram:BICID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode">
      <let name="codeValue43" value="."/>
      <assert test="string-length($codeValue43)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=43]/enumeration[@value=$codeValue43]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:ConversionRateDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:SourceCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert test="string-length($codeValue42)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=42]/enumeration[@value=$codeValue42]">
	Value of 'ram:SourceCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:TargetCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert test="string-length($codeValue42)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=42]/enumeration[@value=$codeValue42]">
	Value of 'ram:TargetCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert test="string-length($codeValue42)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=42]/enumeration[@value=$codeValue42]">
	Value of 'ram:TaxCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <assert test="count(ram:AssociatedDocumentLineDocument)=1">
	Element 'ram:AssociatedDocumentLineDocument' must occur exactly 1 times.</assert>
      <assert test="count(ram:SpecifiedTradeProduct)=1">
	Element 'ram:SpecifiedTradeProduct' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument">
      <assert test="count(ram:LineID)=1">
	Element 'ram:LineID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote">
      <assert test="count(ram:Content)&lt;=1">
	Element 'ram:Content' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SubjectCode)&lt;=1">
	Element 'ram:SubjectCode' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:ContentCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue5" value="."/>
      <assert test="string-length($codeValue5)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=5]/enumeration[@value=$codeValue5]">
	Value of 'ram:SubjectCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusCode">
      <let name="codeValue6" value="."/>
      <assert test="string-length($codeValue6)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=6]/enumeration[@value=$codeValue6]">
	Value of 'ram:LineStatusCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode">
      <let name="codeValue7" value="."/>
      <assert test="string-length($codeValue7)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=7]/enumeration[@value=$codeValue7]">
	Value of 'ram:LineStatusReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:ParentLineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:Name)&lt;=1">
	Element 'ram:Name' may occur at maximum 1 times.</assert>
      <assert test="count(ram:AttachmentBinaryObject)&lt;=1">
	Element 'ram:AttachmentBinaryObject' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject">
      <assert test="@mimeCode">
	Attribute '@mimeCode' is required in this context.</assert>
      <let name="codeValue19" value="@mimeCode"/>
      <assert test="string-length($codeValue19)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">
	Value of '@mimeCode' is not allowed.</assert>
      <assert test="@filename">
	Attribute '@filename' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:ReferenceTypeCode">
      <let name="codeValue20" value="."/>
      <assert test="string-length($codeValue20)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:TypeCode">
      <let name="codeValue18" value="."/>
      <assert test="string-length($codeValue18)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=18]/enumeration[@value=$codeValue18]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <assert test="count(ram:DeliveryTypeCode)=1">
	Element 'ram:DeliveryTypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:DeliveryTypeCode">
      <let name="codeValue16" value="."/>
      <assert test="string-length($codeValue16)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=16]/enumeration[@value=$codeValue16]">
	Value of 'ram:DeliveryTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:RelevantTradeLocation/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice">
      <assert test="count(ram:ChargeAmount)=1">
	Element 'ram:ChargeAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue21" value="."/>
      <assert test="string-length($codeValue21)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">
	Value of 'ram:ReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[ not(@listID=&quot;5153&quot;) and  not(not (@listID))]">
      <report test="true()">
	Element variant 'ram:ReasonCode[ not(@listID="5153") and  not(not (@listID))]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[@listID=&quot;5153&quot;]">
      <let name="codeValue22" value="."/>
      <assert test="string-length($codeValue22)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">
	Value of 'ram:ReasonCode[@listID="5153"]' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[not (@listID)]">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:IncludedTradeTax">
      <report test="true()">
	Element 'ram:IncludedTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty">
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice">
      <assert test="count(ram:ChargeAmount)=1">
	Element 'ram:ChargeAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:IncludedTradeTax)&lt;=1">
	Element 'ram:IncludedTradeTax' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:AppliedTradeAllowanceCharge">
      <report test="true()">
	Element 'ram:AppliedTradeAllowanceCharge' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax">
      <assert test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:RateApplicablePercent)=1">
	Element 'ram:RateApplicablePercent' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert test="string-length($codeValue25)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:TypeCode">
      <let name="codeValue23" value="."/>
      <assert test="string-length($codeValue23)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent">
      <assert test="count(ram:OccurrenceDateTime)=1">
	Element 'ram:OccurrenceDateTime' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ChargeFreeQuantity">
      <assert test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:PackageQuantity">
      <assert test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:PerPackageUnitQuantity">
      <assert test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement">
      <assert test="count(ram:InvoiceReferencedDocument)&lt;=1">
	Element 'ram:InvoiceReferencedDocument' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime">
      <report test="true()">
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:ReferenceTypeCode">
      <let name="codeValue20" value="."/>
      <assert test="string-length($codeValue20)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:TypeCode">
      <let name="codeValue18" value="."/>
      <assert test="string-length($codeValue18)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=18]/enumeration[@value=$codeValue18]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax">
      <assert test="count(ram:CalculatedAmount)&lt;=1">
	Element 'ram:CalculatedAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert test="string-length($codeValue24)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <let name="codeValue27" value="."/>
      <assert test="string-length($codeValue27)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=27]/enumeration[@value=$codeValue27]">
	Value of 'ram:DueDateTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert test="string-length($codeValue25)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert test="string-length($codeValue26)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:CompleteDateTime">
      <report test="true()">
	Element 'ram:CompleteDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert test="string-length($codeValue3)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert test="string-length($codeValue17)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">
      <let name="codeValue33" value="."/>
      <assert test="string-length($codeValue33)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=33]/enumeration[@value=$codeValue33]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue28" value="."/>
      <assert test="string-length($codeValue28)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=28]/enumeration[@value=$codeValue28]">
	Value of 'ram:ReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[ not(not (@listID)) and  not(@listID=&quot;5153&quot;)]">
      <report test="true()">
	Element variant 'ram:ReasonCode[ not(not (@listID)) and  not(@listID="5153")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[@listID=&quot;5153&quot;]">
      <let name="codeValue30" value="."/>
      <assert test="string-length($codeValue30)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=30]/enumeration[@value=$codeValue30]">
	Value of 'ram:ReasonCode[@listID="5153"]' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[not (@listID)]">
      <let name="codeValue29" value="."/>
      <assert test="string-length($codeValue29)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=29]/enumeration[@value=$codeValue29]">
	Value of 'ram:ReasonCode[not (@listID)]' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation">
      <assert test="count(ram:LineTotalAmount)&lt;=1">
	Element 'ram:LineTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:ChargeTotalAmount)&lt;=1">
	Element 'ram:ChargeTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:AllowanceTotalAmount)&lt;=1">
	Element 'ram:AllowanceTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GrandTotalAmount)&lt;=1">
	Element 'ram:GrandTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TotalAllowanceChargeAmount)&lt;=1">
	Element 'ram:TotalAllowanceChargeAmount' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:AllowanceTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:ChargeTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[ not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode) and  not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">
      <report test="true()">
	Element variant 'ram:TaxTotalAmount[ not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode) and  not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]">
      <let name="codeValue31" value="@currencyID"/>
      <assert test="string-length($codeValue31)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=31]/enumeration[@value=$codeValue31]">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode]">
      <let name="codeValue32" value="@currencyID"/>
      <assert test="string-length($codeValue32)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=32]/enumeration[@value=$codeValue32]">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TotalAllowanceChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct">
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic">
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Value)&lt;=1">
	Element 'ram:Value' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BatchID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BuyerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification">
      <assert test="count(ram:ClassName)&lt;=1">
	Element 'ram:ClassName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode">
      <assert test="@listID">
	Attribute '@listID' is required in this context.</assert>
      <let name="codeValue9" value="@listID"/>
      <assert test="string-length($codeValue9)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">
	Value of '@listID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue8" value="@schemeID"/>
      <assert test="string-length($codeValue8)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=8]/enumeration[@value=$codeValue8]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:IndustryAssignedID)&lt;=1">
	Element 'ram:IndustryAssignedID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:UnitQuantity)&lt;=1">
	Element 'ram:UnitQuantity' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:BuyerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue14" value="@schemeID"/>
      <assert test="string-length($codeValue14)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=14]/enumeration[@value=$codeValue14]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:IndustryAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:SellerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:UnitQuantity">
      <assert test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert test="string-length($codeValue15)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IndividualTradeProductInstance/ram:BatchID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IndividualTradeProductInstance/ram:SupplierAssignedSerialID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IndustryAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty">
      <assert test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=2">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 2 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=2">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 2 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert test="string-length($codeValue11)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="string-length($codeValue12)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert test="string-length($codeValue13)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ModelID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry/ram:ID">
      <let name="codeValue10" value="."/>
      <assert test="string-length($codeValue10)=0 or document(&apos;FACTUR-X_EXTENDED_codedb.xml&apos;)/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of 'ram:ID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:SellerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
</schema>
