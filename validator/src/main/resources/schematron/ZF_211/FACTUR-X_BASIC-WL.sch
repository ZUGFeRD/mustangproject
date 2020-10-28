<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    schemaVersion="iso">
  <title>Schema for FACTUR-X; 1.0; ACCOUNTING INFORMATION, No XML Invoice, (BASIC WITHOUT LINE)</title>
  <ns uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" prefix="rsm"/>
  <ns uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" prefix="qdt"/>
  <ns uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" prefix="ram"/>
  <ns uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" prefix="udt"/>
  <pattern>
    <rule context="//ram:AdditionalReferencedDocument">
      <assert test="(ram:IssuerAssignedID!=&apos;&apos;)">
	Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="(ram:BasisAmount)">
	Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</assert>
      <assert test="(ram:CalculatedAmount)">
	Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</assert>
      <assert test="(ram:CategoryCode)">
	Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</assert>
      <assert test="(ram:RateApplicablePercent) or (ram:CategoryCode = &apos;O&apos;)">
	Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</assert>
      <assert test="((ram:TaxPointDate) and not (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and not (ram:DueDateTypeCode))">
	Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</assert>
      <assert test="ram:CalculatedAmount = round(ram:BasisAmount * ram:RateApplicablePercent) div 100 +0 or not (ram:RateApplicablePercent)">
	VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</assert>
      <assert test="string-length(substring-after(ram:BasisAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</assert>
      <assert test="string-length(substring-after(ram:CalculatedAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;Z&apos;]">
      <assert test="../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;Z&apos;]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos;]/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;Z&apos;]/ram:ActualAmount)*10*10)div 100)">
	In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Zero rated".</assert>
      <assert test="../ram:CalculatedAmount = 0">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</assert>
      <assert test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.=&apos;S&apos;]">
      <assert test="../ram:CalculatedAmount = round(../ram:BasisAmount * ../ram:RateApplicablePercent) div 100 +0">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert test="(ram:EndDateTime/udt:DateTimeString[@format = &apos;102&apos;]) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = &apos;102&apos;]) or not (ram:EndDateTime) or not (ram:StartDateTime)">
	If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</assert>
      <assert test="(ram:StartDateTime) or (ram:EndDateTime)">
	If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]">
      <assert test="(ram:ActualAmount)">
	Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</assert>
      <assert test="(ram:CategoryTradeTax/ram:CategoryCode)">
	Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</assert>
      <assert test="true()">
	Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</assert>
      <assert test="string-length(substring-after(ram:ActualAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</assert>
      <assert test="string-length(substring-after(ram:BasisAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]">
      <assert test="(ram:ActualAmount)">
	Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</assert>
      <assert test="(ram:CategoryTradeTax/ram:CategoryCode)">
	Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Document level charge (BG-21) shall have a Document level charge reason (BT-104) or a Document level charge reason code (BT-105).</assert>
      <assert test="true()">
	Document level charge reason code (BT-105) and Document level charge reason (BT-104) shall indicate the same type of charge.</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Document level charge (BG-21) shall contain a Document level charge reason (BT-104) or a Document level charge reason code (BT-105), or both.</assert>
      <assert test="string-length(substring-after(ram:ActualAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Document level charge amount (BT-92) is 2.</assert>
      <assert test="string-length(substring-after(ram:BasisAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Document level charge base amount (BT-93) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic">
      <assert test="(ram:Description) and (ram:Value)">
	Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableTradeSettlementFinancialCard">
      <assert test="string-length(ram:ID)&lt;=6 and string-length(ram:ID)&gt;=4">
	The last 4 to 6 digits of the Payment card primary account number (BT-87) shall be present if Payment card information (BG-18) is provided in the Invoice.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem">
      <assert test="(ram:AssociatedDocumentLineDocument/ram:LineID!=&apos;&apos;)">
	Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</assert>
      <assert test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)">
	Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</assert>
      <assert test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode)">
	An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130).</assert>
      <assert test="(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)">
	Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</assert>
      <assert test="(ram:SpecifiedTradeProduct/ram:Name!=&apos;&apos;)">
	Each Invoice line (BG-25) shall contain the Item name (BT-153).</assert>
      <assert test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)">
	Each Invoice line (BG-25) shall contain the Item net price (BT-146).</assert>
      <assert test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount) &gt;= 0">
	The Item net price (BT-146) shall NOT be negative.</assert>
      <assert test="(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount &gt;= 0) or not(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount)">
	The Item gross price (BT-148) shall NOT be negative.</assert>
      <assert test="ram:SpecifiedTradeProduct/ram:GlobalID/@schemeID!=&apos;&apos; or not (ram:SpecifiedTradeProduct/ram:GlobalID)">
	The Item standard identifier (BT-157) shall have a Scheme identifier</assert>
      <assert test="(ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode/@listID!=&apos;&apos;) or not (ram:SpecifiedTradeProduct/ram:DesignatedProductClassification)">
	The Item classification identifier (BT-158) shall have a Scheme identifier</assert>
      <assert test="(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode)">
	Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</assert>
      <assert test="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
	An Invoice shall at least have one VAT breakdown group (BG-23).</assert>
      <assert test="string-length(substring-after(ram:SpecifiedTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:PayeeTradeParty">
      <assert test="(ram:Name) and (not(ram:Name = ../ram:SellerTradeParty/ram:Name) and not(ram:ID = ../ram:SellerTradeParty/ram:ID) and not(ram:SpecifiedLegalOrganization/ram:ID = ../ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID))">
	The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTaxRepresentativeTradeParty">
      <assert test="(ram:Name)">
	The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert test="(ram:PostalTradeAddress)">
	The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert test="(ram:PostalTradeAddress/ram:CountryID)">
	The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert test="(ram:SpecifiedTaxRegistration/ram:ID[@schemeID=&apos;VA&apos;]!=&apos;&apos;)">
	Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTradeParty">
      <assert test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID=&apos;VA&apos;])">
	In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert test="(ram:EndDateTime/udt:DateTimeString[@format = &apos;102&apos;]) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = &apos;102&apos;]) or not (ram:EndDateTime) or not (ram:StartDateTime)">
	If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</assert>
      <assert test="(ram:StartDateTime) or (ram:EndDateTime)">
	If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator = &apos;false&apos;]">
      <assert test="(ram:ActualAmount)">
	Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</assert>
      <assert test="true()">
	Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</assert>
      <assert test="string-length(substring-after(ram:ActualAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</assert>
      <assert test="string-length(substring-after(ram:BasisAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator = &apos;true&apos;]">
      <assert test="(ram:ActualAmount)">
	Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Invoice line charge (BG-28) shall have an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145).</assert>
      <assert test="true()">
	Invoice line charge reason code (BT-145) and Invoice line charge reason (BT144) shall indicate the same type of charge reason.</assert>
      <assert test="(ram:Reason) or (ram:ReasonCode)">
	Each Invoice line charge (BG-28) shall contain an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145), or both.</assert>
      <assert test="string-length(substring-after(ram:ActualAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</assert>
      <assert test="string-length(substring-after(ram:BasisAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID=&apos;VA&apos;]">
      <assert test="contains(&apos; EL AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW &apos;, concat(&apos; &apos;, substring(.,1,2), &apos; &apos;))">
	The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;AE&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Reverse charge” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;E&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Exempt from VAT” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;G&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Export outside the EU” shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;K&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Intra-community supply” shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “IGIC” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “IPSI” shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Not subject to VAT” shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</assert>
      <assert test="not(ram:RateApplicablePercent)">
	A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;S&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Standard rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;Z&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is “Zero rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;AE&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Reverse charge” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;E&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Exempt from VAT” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;G&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Export outside the EU” shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;K&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Intra-community supply” shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “IGIC” shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “IPSI” shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Not subject to VAT” shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</assert>
      <assert test="not(ram:RateApplicablePercent)">
	A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;S&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is “Standard rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:CategoryTradeTax[ram:CategoryCode = &apos;Z&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is “Zero rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert test="(ram:TaxBasisTotalAmount)">
	An Invoice shall have the Invoice total amount without VAT (BT-109).</assert>
      <assert test="(ram:GrandTotalAmount)">
	An Invoice shall have the Invoice total amount with VAT (BT-112).</assert>
      <assert test="(ram:DuePayableAmount)">
	An Invoice shall have the Amount due for payment (BT-115).</assert>
      <assert test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;])and not (ram:AllowanceTotalAmount)) or ram:AllowanceTotalAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos;]/ram:ActualAmount)* 10 * 10 ) div 100)">
	Sum of allowances on document level (BT-107) = S Document level allowance amount (BT-92).</assert>
      <assert test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;])and not (ram:ChargeTotalAmount)) or ram:ChargeTotalAmount = &#13;&#10;((round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos;]/ram:ActualAmount)* 10 * 10 ) div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100))">
	Sum of charges on document level (BT-108) = S Document level charge amount (BT-99).</assert>
      <assert test="(ram:GrandTotalAmount = round(ram:TaxBasisTotalAmount*100 + ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]*100 +0) div 100) or ((ram:GrandTotalAmount = ram:TaxBasisTotalAmount) and not (ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]))">
	Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</assert>
      <assert test="string-length(substring-after(ram:LineTotalAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</assert>
      <assert test="string-length(substring-after(ram:AllowanceTotalAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</assert>
      <assert test="string-length(substring-after(ram:ChargeTotalAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</assert>
      <assert test="string-length(substring-after(ram:TaxBasisTotalAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</assert>
      <assert test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]">
	The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</assert>
      <assert test="string-length(substring-after(ram:GrandTotalAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</assert>
      <assert test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and . = round(. * 100) div 100) or not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">
	The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</assert>
      <assert test="string-length(substring-after(ram:TotalPrepaidAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</assert>
      <assert test="string-length(substring-after(ram:RoundingAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</assert>
      <assert test="string-length(substring-after(ram:DuePayableAmount,&apos;.&apos;))&lt;=2">
	The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.</assert>
      <assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) or (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and (ram:TaxTotalAmount/@currencyID = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) and not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode))">
	If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</assert>
      <assert test="(ram:TaxBasisTotalAmount = (round(ram:LineTotalAmount*100 - ram:AllowanceTotalAmount*100 + ram:ChargeTotalAmount*100) div 100)) or ((ram:TaxBasisTotalAmount = (round(ram:LineTotalAmount*100 - ram:AllowanceTotalAmount*100) div 100)) and not (ram:ChargeTotalAmount)) or ((ram:TaxBasisTotalAmount = (round(ram:LineTotalAmount*100 + ram:ChargeTotalAmount*100) div 100)) and not (ram:AllowanceTotalAmount)) or ((ram:TaxBasisTotalAmount = (round(ram:LineTotalAmount * 100) div 100)) and not (ram:ChargeTotalAmount) and not (ram:AllowanceTotalAmount))">
	Invoice total amount without VAT (BT-109) = S Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</assert>
      <assert test="(ram:DuePayableAmount = (round(ram:GrandTotalAmount*100 - ram:TotalPrepaidAmount*100 + ram:RoundingAmount*100) div 100)) or ((ram:DuePayableAmount = ram:GrandTotalAmount + ram:RoundingAmount) and not (ram:TotalPrepaidAmount)) or ((ram:DuePayableAmount = (round(ram:GrandTotalAmount*100 - ram:TotalPrepaidAmount*100) div 100)) and not (ram:RoundingAmount)) or ((ram:DuePayableAmount = (round(ram:GrandTotalAmount*100) div 100)) and not (ram:TotalPrepaidAmount) and not (ram:RoundingAmount))">
	Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</assert>
      <assert test="(ram:LineTotalAmount)">
	An Invoice shall have the Sum of Invoice line net amount (BT-106).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]">
      <assert test=". = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount)*10*10)div 100)">
	Invoice total VAT amount (BT-110) = S VAT category tax amount (BT-117).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans">
      <assert test="(ram:TypeCode)">
	A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode=&apos;30&apos; or ram:TypeCode=&apos;58&apos;]/ram:PayerPartyDebtorFinancialAccount">
      <assert test="(ram:IBANID) or (ram:ProprietaryID)">
	A Payment account identifier (BT-84) shall be present if Credit transfer (BG-16) information is provided in the Invoice.</assert>
      <assert test="(ram:IBANID) or (ram:ProprietaryID)">
	If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;AE&apos;]">
      <assert test="../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;AE&apos;]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos;]/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;AE&apos;]/ram:ActualAmount)*10*10)div 100)">
	In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Reverse charge".</assert>
      <assert test="../ram:CalculatedAmount = 0">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is “Reverse charge” shall be 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;E&apos;]">
      <assert test="../ram:CalculatedAmount = 0">
	The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = &apos;G&apos;]">
      <assert test="../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;G&apos;]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos;]/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;G&apos;]/ram:ActualAmount)*10*10)div 100)">
	In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Export outside the EU".</assert>
      <assert test="../ram:CalculatedAmount = 0">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is “Export outside the EU” shall be 0 (zero).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.= &apos;K&apos;]">
      <assert test="../ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;K&apos;]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos;]/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;K&apos;]/ram:ActualAmount)*10*10)div 100)">
	In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Intra-community supply".</assert>
      <assert test="../ram:CalculatedAmount = 0">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
      <assert test="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)">
	In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</assert>
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
	In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;L&apos; and ram:RateApplicablePercent=ram:ApplicableTradeTax/ram:RateApplicablePercent]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:RateApplicablePercent=ram:CategoryTradeTax/ram:RateApplicablePercent]/ram:ActualAmount)*10*10) div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;L&apos; and ram:RateApplicablePercent=ram:CategoryTradeTax/ram:RateApplicablePercent]/ram:ActualAmount)*10*10) div 100)">
	For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “IGIC” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
      <assert test="true()">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;M&apos; and ram:RateApplicablePercent=ram:ApplicableTradeTax/ram:RateApplicablePercent]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:RateApplicablePercent=ram:CategoryTradeTax/ram:RateApplicablePercent]/ram:ActualAmount)*10*10) div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;M&apos; and ram:RateApplicablePercent=ram:CategoryTradeTax/ram:RateApplicablePercent]/ram:ActualAmount)*10*10) div 100)">
	For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “IPSI” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
      <assert test="true()">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="ram:BasisAmount = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = &apos;O&apos; and ram:RateApplicablePercent=ram:ApplicableTradeTax/ram:RateApplicablePercent]/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)*10*10)div 100) + (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;true&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos; and ram:RateApplicablePercent=ram:CategoryTradeTax/ram:RateApplicablePercent]/ram:ActualAmount)*10*10)div 100) - (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&apos;false&apos; and ram:CategoryTradeTax/ram:CategoryCode=&apos;O&apos;]/ram:ActualAmount)*10*10)div 100)">
	In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are “Not subject to VAT".</assert>
      <assert test="ram:CalculatedAmount = 0">
	The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is “Not subject to VAT” shall be 0 (zero).</assert>
      <assert test="(ram:ExemptionReason) or (ram:ExemptionReasonCode)">
	A VAT Breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
      <assert test="not(//ram:ApplicableTradeTax[ram:CategoryCode != &apos;O&apos;])">
	An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain other VAT breakdown groups (BG-23).</assert>
      <assert test="not(//ram:ApplicableTradeTax[ram:CategoryCode != &apos;O&apos;])">
	An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is not "Not subject to VAT".</assert>
      <assert test="not(//ram:CategoryTradeTax[ram:CategoryCode != &apos;O&apos;])">
	An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level allowances (BG-20) where Document level allowance VAT category code (BT-95) is not "Not subject to VAT".</assert>
      <assert test="not(//ram:CategoryTradeTax[ram:CategoryCode != &apos;O&apos;])">
	An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level charges (BG-21) where Document level charge VAT category code (BT-102) is not "Not subject to VAT".</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;AE&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Reverse charge” shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;E&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Exempt from VAT” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;G&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Export outside the EU” shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;K&apos;]">
      <assert test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Intra-community supply” shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;L&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “IGIC” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;M&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “IPSI” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;O&apos;]">
      <assert test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]) and not (/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;])">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Not subject to VAT” shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-46).</assert>
      <assert test="not(ram:RateApplicablePercent)">
	An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;S&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is “Standard rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent &gt; 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = &apos;Z&apos;]">
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos; or @schemeID = &apos;FC&apos;] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = &apos;VA&apos;]">
	An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is “Zero rated” shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert test="ram:RateApplicablePercent = 0">
	In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice">
      <assert test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != &apos;&apos;)">
	An Invoice shall have a Specification identifier (BT-24).</assert>
      <assert test="(rsm:ExchangedDocument/ram:ID !=&apos;&apos;)">
	An Invoice shall have an Invoice number (BT-1).</assert>
      <assert test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format=&apos;102&apos;]!=&apos;&apos;)">
	An Invoice shall have an Invoice issue date (BT-2).</assert>
      <assert test="(rsm:ExchangedDocument/ram:TypeCode!=&apos;&apos;)">
	An Invoice shall have an Invoice type code (BT-3).</assert>
      <assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!=&apos;&apos;)">
	An Invoice shall have an Invoice currency code (BT-5).</assert>
      <assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!=&apos;&apos;)">
	An Invoice shall contain the Seller name (BT-27).</assert>
      <assert test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!=&apos;&apos;)">
	An Invoice shall contain the Buyer name (BT-44).</assert>
      <assert test="//ram:SellerTradeParty/ram:PostalTradeAddress">
	An Invoice shall contain the Seller postal address (BG-5).</assert>
      <assert test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=&apos;&apos;">
	The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID!=&apos;&apos; or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication)">
	The Seller electronic address (BT-34) shall have a Scheme identifier.</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID!=&apos;&apos; or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication)">
	The Buyer electronic address (BT-49) shall have a Scheme identifier.</assert>
      <assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;])) and     ((count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;S&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;S&apos;])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode=&apos;S&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated” shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;Z&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;])=1 and (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;Z&apos;] or //ram:CategoryTradeTax[ram:CategoryCode=&apos;Z&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Zero rated” shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;E&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;])=1 and (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;E&apos;] or //ram:CategoryTradeTax[ram:CategoryCode=&apos;E&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Exempt from VAT” shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;AE&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;])=1 and (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;AE&apos;] or //ram:CategoryTradeTax[ram:CategoryCode=&apos;AE&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Reverse charge” shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;K&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;])=1 and (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;K&apos;] or //ram:CategoryTradeTax[ram:CategoryCode=&apos;K&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Intra-community supply” shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</assert>
      <assert test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;G&apos;])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;])=1 and (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;G&apos;] or //ram:CategoryTradeTax[ram:CategoryCode=&apos;G&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Export outside the EU” shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</assert>
      <assert test="not(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;]) or (     count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;])=1 and     (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;O&apos;] or    //ram:CategoryTradeTax[ram:CategoryCode=&apos;O&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Not subject to VAT” shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</assert>
      <assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;])) and     ((count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;L&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;L&apos;])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode=&apos;L&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “IGIC” shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</assert>
      <assert test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;])) and     ((count(//ram:CategoryTradeTax[ram:CategoryCode=&apos;M&apos;]) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode=&apos;M&apos;])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode=&apos;M&apos;]))">
	An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “IPSI” shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</assert>
      <assert test="(number(//ram:DuePayableAmount) &gt; 0 and ((//ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime) or (//ram:SpecifiedTradePaymentTerms/ram:Description))) or not(number(//ram:DuePayableAmount)&gt;0)">
	In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</assert>
      <assert test="//ram:BuyerTradeParty/ram:PostalTradeAddress">
	An Invoice shall contain the Buyer postal address (BG-8).</assert>
      <assert test="//ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID!=&apos;&apos;">
	The Buyer postal address shall contain a Buyer country code (BT-55).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:CategoryCode">
      <report test="true()">
	Element 'ram:CategoryCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ControlRequirementIndicator">
      <report test="true()">
	Element 'ram:ControlRequirementIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote">
      <assert test="count(ram:Content)=1">
	Element 'ram:Content' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:ContentCode">
      <report test="true()">
	Element 'ram:ContentCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Content[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Content[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Subject">
      <report test="true()">
	Element 'ram:Subject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue3" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of 'ram:SubjectCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listAgencyName]">
      <report test="true()">
	Attribute @listAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listName]">
      <report test="true()">
	Attribute @listName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listSchemeURI]">
      <report test="true()">
	Attribute @listSchemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTime">
      <report test="true()">
	Element 'udt:DateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format]">
      <let name="codeValue2" value="@format"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:LanguageID">
      <report test="true()">
	Element 'ram:LanguageID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:Purpose">
      <report test="true()">
	Element 'ram:Purpose' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:PurposeCode">
      <report test="true()">
	Element 'ram:PurposeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:RevisionDateTime">
      <report test="true()">
	Element 'ram:RevisionDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <let name="codeValue1" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=1]/enumeration[@value=$codeValue1]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:VersionID">
      <report test="true()">
	Element 'ram:VersionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <assert test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1">
	Element 'ram:BusinessProcessSpecifiedDocumentContextParameter' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1">
	Element 'ram:GuidelineSpecifiedDocumentContextParameter' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:ApplicationSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:ApplicationSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BIMSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:BIMSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:SpecifiedDocumentVersion">
      <report test="true()">
	Element 'ram:SpecifiedDocumentVersion' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:Value">
      <report test="true()">
	Element 'ram:Value' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:SpecifiedDocumentVersion">
      <report test="true()">
	Element 'ram:SpecifiedDocumentVersion' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:Value">
      <report test="true()">
	Element 'ram:Value' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:MessageStandardSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:MessageStandardSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:ScenarioSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:ScenarioSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:SpecifiedTransactionID">
      <report test="true()">
	Element 'ram:SpecifiedTransactionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:SubsetSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:SubsetSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:TestIndicator">
      <report test="true()">
	Element 'ram:TestIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert test="count(ram:SellerTradeParty)=1">
	Element 'ram:SellerTradeParty' must occur exactly 1 times.</assert>
      <assert test="count(ram:BuyerTradeParty)=1">
	Element 'ram:BuyerTradeParty' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument">
      <report test="true()">
	Element 'ram:AdditionalReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <report test="true()">
	Element 'ram:ApplicableTradeDeliveryTerms' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      <report test="true()">
	Element 'ram:BuyerAgentTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAssignedAccountantTradeParty">
      <report test="true()">
	Element 'ram:BuyerAssignedAccountantTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:AttachedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime">
      <report test="true()">
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Information">
      <report test="true()">
	Element 'ram:Information' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:SectionName">
      <report test="true()">
	Element 'ram:SectionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:StatusCode">
      <report test="true()">
	Element 'ram:StatusCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty">
      <report test="true()">
	Element 'ram:BuyerRequisitionerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty">
      <report test="true()">
	Element 'ram:BuyerTaxRepresentativeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID]">
      <let name="codeValue8" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=8]/enumeration[@value=$codeValue8]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:AdditionalStreetName">
      <report test="true()">
	Element 'ram:AdditionalStreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:AttentionOf">
      <report test="true()">
	Element 'ram:AttentionOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:BuildingName">
      <report test="true()">
	Element 'ram:BuildingName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:BuildingNumber">
      <report test="true()">
	Element 'ram:BuildingNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CareOf">
      <report test="true()">
	Element 'ram:CareOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CityName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CityName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CitySubDivisionName">
      <report test="true()">
	Element 'ram:CitySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryName">
      <report test="true()">
	Element 'ram:CountryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionID">
      <report test="true()">
	Element 'ram:CountrySubDivisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:DepartmentName">
      <report test="true()">
	Element 'ram:DepartmentName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineFive">
      <report test="true()">
	Element 'ram:LineFive' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineFour">
      <report test="true()">
	Element 'ram:LineFour' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostOfficeBox">
      <report test="true()">
	Element 'ram:PostOfficeBox' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyName]">
      <report test="true()">
	Attribute @listAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listName]">
      <report test="true()">
	Attribute @listName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listSchemeURI]">
      <report test="true()">
	Attribute @listSchemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:StreetName">
      <report test="true()">
	Element 'ram:StreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:AuthorizedLegalRegistration">
      <report test="true()">
	Element 'ram:AuthorizedLegalRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]">
      <let name="codeValue9" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=9]/enumeration[@value=$codeValue9]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:LegalClassificationCode">
      <report test="true()">
	Element 'ram:LegalClassificationCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
      <report test="true()">
	Element 'ram:TradingBusinessName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:AssociatedRegisteredTax">
      <report test="true()">
	Element 'ram:AssociatedRegisteredTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]">
      <let name="codeValue10" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=10]/enumeration[@value=$codeValue10]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:ChannelCode">
      <report test="true()">
	Element 'ram:ChannelCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID]">
      <let name="codeValue6" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=6]/enumeration[@value=$codeValue6]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:AttachedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime">
      <report test="true()">
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:Information">
      <report test="true()">
	Element 'ram:Information' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:SectionName">
      <report test="true()">
	Element 'ram:SectionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:StatusCode">
      <report test="true()">
	Element 'ram:StatusCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:DemandForecastReferencedDocument">
      <report test="true()">
	Element 'ram:DemandForecastReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:OrderResponseReferencedDocument">
      <report test="true()">
	Element 'ram:OrderResponseReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PriceListReferencedDocument">
      <report test="true()">
	Element 'ram:PriceListReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty">
      <report test="true()">
	Element 'ram:ProductEndUserTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PromotionalDealReferencedDocument">
      <report test="true()">
	Element 'ram:PromotionalDealReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PurchaseConditionsReferencedDocument">
      <report test="true()">
	Element 'ram:PurchaseConditionsReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument">
      <report test="true()">
	Element 'ram:QuotationReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:Reference">
      <report test="true()">
	Element 'ram:Reference' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionerReferencedDocument">
      <report test="true()">
	Element 'ram:RequisitionerReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty">
      <report test="true()">
	Element 'ram:SalesAgentTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerAssignedAccountantTradeParty">
      <report test="true()">
	Element 'ram:SellerAssignedAccountantTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument">
      <report test="true()">
	Element 'ram:SellerOrderReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty">
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)=1">
	Element 'ram:SpecifiedTaxRegistration' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:AdditionalStreetName">
      <report test="true()">
	Element 'ram:AdditionalStreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:AttentionOf">
      <report test="true()">
	Element 'ram:AttentionOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:BuildingName">
      <report test="true()">
	Element 'ram:BuildingName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:BuildingNumber">
      <report test="true()">
	Element 'ram:BuildingNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CareOf">
      <report test="true()">
	Element 'ram:CareOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CityName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CityName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CitySubDivisionName">
      <report test="true()">
	Element 'ram:CitySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryName">
      <report test="true()">
	Element 'ram:CountryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionID">
      <report test="true()">
	Element 'ram:CountrySubDivisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:DepartmentName">
      <report test="true()">
	Element 'ram:DepartmentName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineFive">
      <report test="true()">
	Element 'ram:LineFive' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineFour">
      <report test="true()">
	Element 'ram:LineFour' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostOfficeBox">
      <report test="true()">
	Element 'ram:PostOfficeBox' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyName]">
      <report test="true()">
	Attribute @listAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listName]">
      <report test="true()">
	Attribute @listName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listSchemeURI]">
      <report test="true()">
	Attribute @listSchemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:StreetName">
      <report test="true()">
	Element 'ram:StreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization">
      <report test="true()">
	Element 'ram:SpecifiedLegalOrganization' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:AssociatedRegisteredTax">
      <report test="true()">
	Element 'ram:AssociatedRegisteredTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]">
      <let name="codeValue11" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=11]/enumeration[@value=$codeValue11]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <report test="true()">
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID]">
      <let name="codeValue4" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=4]/enumeration[@value=$codeValue4]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:AdditionalStreetName">
      <report test="true()">
	Element 'ram:AdditionalStreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:AttentionOf">
      <report test="true()">
	Element 'ram:AttentionOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:BuildingName">
      <report test="true()">
	Element 'ram:BuildingName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:BuildingNumber">
      <report test="true()">
	Element 'ram:BuildingNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CareOf">
      <report test="true()">
	Element 'ram:CareOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CityName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CityName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CitySubDivisionName">
      <report test="true()">
	Element 'ram:CitySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryName">
      <report test="true()">
	Element 'ram:CountryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionID">
      <report test="true()">
	Element 'ram:CountrySubDivisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:DepartmentName">
      <report test="true()">
	Element 'ram:DepartmentName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineFive">
      <report test="true()">
	Element 'ram:LineFive' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineFour">
      <report test="true()">
	Element 'ram:LineFour' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostOfficeBox">
      <report test="true()">
	Element 'ram:PostOfficeBox' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyName]">
      <report test="true()">
	Attribute @listAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listName]">
      <report test="true()">
	Attribute @listName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listSchemeURI]">
      <report test="true()">
	Attribute @listSchemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:StreetName">
      <report test="true()">
	Element 'ram:StreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:AuthorizedLegalRegistration">
      <report test="true()">
	Element 'ram:AuthorizedLegalRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]">
      <let name="codeValue5" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=5]/enumeration[@value=$codeValue5]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:LegalClassificationCode">
      <report test="true()">
	Element 'ram:LegalClassificationCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:AssociatedRegisteredTax">
      <report test="true()">
	Element 'ram:AssociatedRegisteredTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]">
      <let name="codeValue7" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=7]/enumeration[@value=$codeValue7]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication">
      <assert test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:ChannelCode">
      <report test="true()">
	Element 'ram:ChannelCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID]">
      <let name="codeValue6" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=6]/enumeration[@value=$codeValue6]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject">
      <report test="true()">
	Element 'ram:SpecifiedProcuringProject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SupplyInstructionReferencedDocument">
      <report test="true()">
	Element 'ram:SupplyInstructionReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument">
      <report test="true()">
	Element 'ram:UltimateCustomerOrderReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery">
      <assert test="(ram:ShipToTradeParty/ram:PostalTradeAddress and ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID!=&apos;&apos;) or not (ram:ShipToTradeParty/ram:PostalTradeAddress)">
	Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:DescriptionBinaryObject">
      <report test="true()">
	Element 'ram:DescriptionBinaryObject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:EarliestOccurrenceDateTime">
      <report test="true()">
	Element 'ram:EarliestOccurrenceDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:LatestOccurrenceDateTime">
      <report test="true()">
	Element 'ram:LatestOccurrenceDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTime">
      <report test="true()">
	Element 'udt:DateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString[@format]">
      <let name="codeValue2" value="@format"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceLogisticsLocation">
      <report test="true()">
	Element 'ram:OccurrenceLogisticsLocation' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod">
      <report test="true()">
	Element 'ram:OccurrenceSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:UnitQuantity">
      <report test="true()">
	Element 'ram:UnitQuantity' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDespatchSupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualDespatchSupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualPickUpSupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualPickUpSupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualReceiptSupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualReceiptSupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:AdditionalReferencedDocument">
      <report test="true()">
	Element 'ram:AdditionalReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ConsumptionReportReferencedDocument">
      <report test="true()">
	Element 'ram:ConsumptionReportReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument">
      <report test="true()">
	Element 'ram:DeliveryNoteReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:AttachedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime">
      <report test="true()">
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Information">
      <report test="true()">
	Element 'ram:Information' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:SectionName">
      <report test="true()">
	Element 'ram:SectionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:StatusCode">
      <report test="true()">
	Element 'ram:StatusCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:PackingListReferencedDocument">
      <report test="true()">
	Element 'ram:PackingListReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:PreviousDeliverySupplyChainEvent">
      <report test="true()">
	Element 'ram:PreviousDeliverySupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument">
      <report test="true()">
	Element 'ram:ReceivingAdviceReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment">
      <report test="true()">
	Element 'ram:RelatedSupplyChainConsignment' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty">
      <report test="true()">
	Element 'ram:ShipFromTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GlobalID)&lt;=1">
	Element 'ram:GlobalID' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeID]">
      <let name="codeValue12" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=12]/enumeration[@value=$codeValue12]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:AdditionalStreetName">
      <report test="true()">
	Element 'ram:AdditionalStreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:AttentionOf">
      <report test="true()">
	Element 'ram:AttentionOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:BuildingName">
      <report test="true()">
	Element 'ram:BuildingName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:BuildingNumber">
      <report test="true()">
	Element 'ram:BuildingNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CareOf">
      <report test="true()">
	Element 'ram:CareOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CityName[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CityName[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CitySubDivisionName">
      <report test="true()">
	Element 'ram:CitySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryName">
      <report test="true()">
	Element 'ram:CountryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionID">
      <report test="true()">
	Element 'ram:CountrySubDivisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName">
      <report test="true()">
	Element 'ram:CountrySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:DepartmentName">
      <report test="true()">
	Element 'ram:DepartmentName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineFive">
      <report test="true()">
	Element 'ram:LineFive' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineFour">
      <report test="true()">
	Element 'ram:LineFour' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineOne[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineThree[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineTwo[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostOfficeBox">
      <report test="true()">
	Element 'ram:PostOfficeBox' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listAgencyName]">
      <report test="true()">
	Attribute @listAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listName]">
      <report test="true()">
	Attribute @listName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listSchemeURI]">
      <report test="true()">
	Attribute @listSchemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:StreetName">
      <report test="true()">
	Element 'ram:StreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization">
      <report test="true()">
	Element 'ram:SpecifiedLegalOrganization' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <report test="true()">
	Element 'ram:SpecifiedTaxRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <report test="true()">
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty">
      <report test="true()">
	Element 'ram:UltimateShipToTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert test="count(ram:PaymentReference)&lt;=1">
	Element 'ram:PaymentReference' may occur at maximum 1 times.</assert>
      <assert test="count(ram:InvoiceCurrencyCode)=1">
	Element 'ram:InvoiceCurrencyCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:ApplicableTradeTax)&gt;=1">
	Element 'ram:ApplicableTradeTax' must occur at least 1 times.</assert>
      <assert test="count(ram:SpecifiedTradePaymentTerms)&lt;=1">
	Element 'ram:SpecifiedTradePaymentTerms' may occur at maximum 1 times.</assert>
      <assert test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">
	Element 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:BasisAmount)=1">
	Element 'ram:BasisAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BuyerDeductibleTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:BuyerDeductibleTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BuyerNonDeductibleTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:BuyerNonDeductibleTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BuyerRepayableTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:BuyerRepayableTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedRate">
      <report test="true()">
	Element 'ram:CalculatedRate' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculationSequenceNumeric">
      <report test="true()">
	Element 'ram:CalculationSequenceNumeric' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <let name="codeValue17" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=17]/enumeration[@value=$codeValue17]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryName">
      <report test="true()">
	Element 'ram:CategoryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CurrencyCode">
      <report test="true()">
	Element 'ram:CurrencyCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CustomsDutyIndicator">
      <report test="true()">
	Element 'ram:CustomsDutyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue18" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=18]/enumeration[@value=$codeValue18]">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listAgencyName]">
      <report test="true()">
	Attribute @listAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listName]">
      <report test="true()">
	Attribute @listName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listSchemeURI]">
      <report test="true()">
	Attribute @listSchemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:InformationAmount">
      <report test="true()">
	Element 'ram:InformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:Jurisdiction">
      <report test="true()">
	Element 'ram:Jurisdiction' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:PlaceApplicableTradeLocation">
      <report test="true()">
	Element 'ram:PlaceApplicableTradeLocation' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent[@format]">
      <report test="true()">
	Attribute @format' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:SellerPayableTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SellerPayableTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:SellerRefundableTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SellerRefundableTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ServiceSupplyTradeCountry">
      <report test="true()">
	Element 'ram:ServiceSupplyTradeCountry' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:SpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxBasisAllowanceRate">
      <report test="true()">
	Element 'ram:TaxBasisAllowanceRate' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:Type">
      <report test="true()">
	Element 'ram:Type' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <let name="codeValue16" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=16]/enumeration[@value=$codeValue16]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:UnitBasisAmount">
      <report test="true()">
	Element 'ram:UnitBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:CompleteDateTime">
      <report test="true()">
	Element 'ram:CompleteDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:ContinuousIndicator">
      <report test="true()">
	Element 'ram:ContinuousIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:DurationMeasure">
      <report test="true()">
	Element 'ram:DurationMeasure' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTime">
      <report test="true()">
	Element 'udt:DateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format]">
      <let name="codeValue2" value="@format"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:InclusiveIndicator">
      <report test="true()">
	Element 'ram:InclusiveIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:OpenIndicator">
      <report test="true()">
	Element 'ram:OpenIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:PurposeCode">
      <report test="true()">
	Element 'ram:PurposeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:SeasonCode">
      <report test="true()">
	Element 'ram:SeasonCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateFlexibilityCode">
      <report test="true()">
	Element 'ram:StartDateFlexibilityCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTime">
      <report test="true()">
	Element 'udt:DateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format]">
      <let name="codeValue2" value="@format"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditReason">
      <report test="true()">
	Element 'ram:CreditReason' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditReasonCode">
      <report test="true()">
	Element 'ram:CreditReasonCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceIssuerID">
      <report test="true()">
	Element 'ram:CreditorReferenceIssuerID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceType">
      <report test="true()">
	Element 'ram:CreditorReferenceType' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceTypeCode">
      <report test="true()">
	Element 'ram:CreditorReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:DuePayableAmount">
      <report test="true()">
	Element 'ram:DuePayableAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:FactoringAgreementReferencedDocument">
      <report test="true()">
	Element 'ram:FactoringAgreementReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:FactoringListReferencedDocument">
      <report test="true()">
	Element 'ram:FactoringListReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceApplicableTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:InvoiceApplicableTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceDateTime">
      <report test="true()">
	Element 'ram:InvoiceDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceIssuerReference">
      <report test="true()">
	Element 'ram:InvoiceIssuerReference' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <assert test="(ram:IssuerAssignedID!=&apos;&apos;)">
	Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</assert>
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:AttachedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString[@format]">
      <let name="codeValue22" value="@format"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=22]/enumeration[@value=$codeValue22]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:Information">
      <report test="true()">
	Element 'ram:Information' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:SectionName">
      <report test="true()">
	Element 'ram:SectionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:StatusCode">
      <report test="true()">
	Element 'ram:StatusCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      <report test="true()">
	Element 'ram:InvoiceeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      <report test="true()">
	Element 'ram:InvoicerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:LetterOfCreditReferencedDocument">
      <report test="true()">
	Element 'ram:LetterOfCreditReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:NextInvoiceDateTime">
      <report test="true()">
	Element 'ram:NextInvoiceDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayableSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:PayableSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <assert test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GlobalID)&lt;=1">
	Element 'ram:GlobalID' may occur at maximum 1 times.</assert>
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeID]">
      <let name="codeValue13" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=13]/enumeration[@value=$codeValue13]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:AuthorizedLegalRegistration">
      <report test="true()">
	Element 'ram:AuthorizedLegalRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]">
      <let name="codeValue14" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=14]/enumeration[@value=$codeValue14]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:LegalClassificationCode">
      <report test="true()">
	Element 'ram:LegalClassificationCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
      <report test="true()">
	Element 'ram:TradingBusinessName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <report test="true()">
	Element 'ram:SpecifiedTaxRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <report test="true()">
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      <report test="true()">
	Element 'ram:PayerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentApplicableTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:PaymentApplicableTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentCurrencyCode">
      <report test="true()">
	Element 'ram:PaymentCurrencyCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ProFormaInvoiceReferencedDocument">
      <report test="true()">
	Element 'ram:ProFormaInvoiceReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PurchaseSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:PurchaseSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:AmountTypeCode">
      <report test="true()">
	Element 'ram:AmountTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:CostReferenceDimensionPattern">
      <report test="true()">
	Element 'ram:CostReferenceDimensionPattern' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:SetTriggerCode">
      <report test="true()">
	Element 'ram:SetTriggerCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SalesSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SalesSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment">
      <report test="true()">
	Element 'ram:SpecifiedAdvancePayment' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedFinancialAdjustment">
      <report test="true()">
	Element 'ram:SpecifiedFinancialAdjustment' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge">
      <report test="true()">
	Element 'ram:SpecifiedLogisticsServiceCharge' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge">
      <assert test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryTradeTax)=1">
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:ActualTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CalculationPercent[@format]">
      <report test="true()">
	Attribute @format' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:BuyerDeductibleTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:BuyerDeductibleTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:BuyerNonDeductibleTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:BuyerNonDeductibleTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:BuyerRepayableTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:BuyerRepayableTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CalculatedRate">
      <report test="true()">
	Element 'ram:CalculatedRate' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CalculationSequenceNumeric">
      <report test="true()">
	Element 'ram:CalculationSequenceNumeric' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode">
      <let name="codeValue20" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=20]/enumeration[@value=$codeValue20]">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryName">
      <report test="true()">
	Element 'ram:CategoryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CurrencyCode">
      <report test="true()">
	Element 'ram:CurrencyCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CustomsDutyIndicator">
      <report test="true()">
	Element 'ram:CustomsDutyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:ExemptionReason">
      <report test="true()">
	Element 'ram:ExemptionReason' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <report test="true()">
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:InformationAmount">
      <report test="true()">
	Element 'ram:InformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:Jurisdiction">
      <report test="true()">
	Element 'ram:Jurisdiction' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:PlaceApplicableTradeLocation">
      <report test="true()">
	Element 'ram:PlaceApplicableTradeLocation' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent[@format]">
      <report test="true()">
	Attribute @format' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:SellerPayableTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SellerPayableTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:SellerRefundableTaxSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SellerRefundableTaxSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:ServiceSupplyTradeCountry">
      <report test="true()">
	Element 'ram:ServiceSupplyTradeCountry' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:SpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TaxBasisAllowanceRate">
      <report test="true()">
	Element 'ram:TaxBasisAllowanceRate' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:Type">
      <report test="true()">
	Element 'ram:Type' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TypeCode">
      <let name="codeValue19" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=19]/enumeration[@value=$codeValue19]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TypeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TypeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TypeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:TypeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:UnitBasisAmount">
      <report test="true()">
	Element 'ram:UnitBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator/udt:IndicatorString">
      <report test="true()">
	Element 'udt:IndicatorString' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:PrepaidIndicator">
      <report test="true()">
	Element 'ram:PrepaidIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:Reason[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:Reason[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:UnitBasisAmount">
      <report test="true()">
	Element 'ram:UnitBasisAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms">
      <assert test="count(ram:DirectDebitMandateID)&lt;=1">
	Element 'ram:DirectDebitMandateID' may occur at maximum 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms">
      <report test="true()">
	Element 'ram:ApplicableTradePaymentDiscountTerms' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms">
      <report test="true()">
	Element 'ram:ApplicableTradePaymentPenaltyTerms' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTime">
      <report test="true()">
	Element 'udt:DateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString[@format]">
      <let name="codeValue2" value="@format"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:FromEventCode">
      <report test="true()">
	Element 'ram:FromEventCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:InstructionTypeCode">
      <report test="true()">
	Element 'ram:InstructionTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PartialPaymentAmount">
      <report test="true()">
	Element 'ram:PartialPaymentAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PartialPaymentPercent">
      <report test="true()">
	Element 'ram:PartialPaymentPercent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty">
      <report test="true()">
	Element 'ram:PayeeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PaymentMeansID">
      <report test="true()">
	Element 'ram:PaymentMeansID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:SettlementPeriodMeasure">
      <report test="true()">
	Element 'ram:SettlementPeriodMeasure' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementFinancialCard">
      <report test="true()">
	Element 'ram:SpecifiedTradeSettlementFinancialCard' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert test="count(ram:LineTotalAmount)=1">
	Element 'ram:LineTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:ChargeTotalAmount)&lt;=1">
	Element 'ram:ChargeTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:AllowanceTotalAmount)&lt;=1">
	Element 'ram:AllowanceTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:TaxBasisTotalAmount)=1">
	Element 'ram:TaxBasisTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TaxTotalAmount)&lt;=1">
	Element 'ram:TaxTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GrandTotalAmount)=1">
	Element 'ram:GrandTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TotalPrepaidAmount)&lt;=1">
	Element 'ram:TotalPrepaidAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:DuePayableAmount)=1">
	Element 'ram:DuePayableAmount' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrossLineTotalAmount">
      <report test="true()">
	Element 'ram:GrossLineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:InformationAmount">
      <report test="true()">
	Element 'ram:InformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:NetIncludingTaxesLineTotalAmount">
      <report test="true()">
	Element 'ram:NetIncludingTaxesLineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:NetLineTotalAmount">
      <report test="true()">
	Element 'ram:NetLineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ProductValueExcludingTobaccoTaxInformationAmount">
      <report test="true()">
	Element 'ram:ProductValueExcludingTobaccoTaxInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RetailValueExcludingTaxInformationAmount">
      <report test="true()">
	Element 'ram:RetailValueExcludingTaxInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount">
      <report test="true()">
	Element 'ram:RoundingAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID]">
      <let name="codeValue21" value="@currencyID"/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=21]/enumeration[@value=$codeValue21]">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalAllowanceChargeAmount">
      <report test="true()">
	Element 'ram:TotalAllowanceChargeAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalDepositFeeInformationAmount">
      <report test="true()">
	Element 'ram:TotalDepositFeeInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalDiscountAmount">
      <report test="true()">
	Element 'ram:TotalDiscountAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalRetailValueInformationAmount">
      <report test="true()">
	Element 'ram:TotalRetailValueInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard">
      <report test="true()">
	Element 'ram:ApplicableTradeSettlementFinancialCard' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:GuaranteeMethodCode">
      <report test="true()">
	Element 'ram:GuaranteeMethodCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:Information">
      <report test="true()">
	Element 'ram:Information' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:AccountName">
      <report test="true()">
	Element 'ram:AccountName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution">
      <report test="true()">
	Element 'ram:PayeeSpecifiedCreditorFinancialInstitution' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount">
      <assert test="count(ram:IBANID)=1">
	Element 'ram:IBANID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:AccountName">
      <report test="true()">
	Element 'ram:AccountName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:ProprietaryID">
      <report test="true()">
	Element 'ram:ProprietaryID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerSpecifiedDebtorFinancialInstitution">
      <report test="true()">
	Element 'ram:PayerSpecifiedDebtorFinancialInstitution' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PaymentChannelCode">
      <report test="true()">
	Element 'ram:PaymentChannelCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PaymentMethodCode">
      <report test="true()">
	Element 'ram:PaymentMethodCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode">
      <let name="codeValue15" value="."/>
      <assert test="document(&apos;FACTUR-X_BASIC-WL_codedb.xml&apos;)//cl[@id=15]/enumeration[@value=$codeValue15]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SubtotalCalculatedTradeTax">
      <report test="true()">
	Element 'ram:SubtotalCalculatedTradeTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:TaxApplicableTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
      <report test="true()">
	Element 'ram:TaxCurrencyCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:UltimatePayeeTradeParty">
      <report test="true()">
	Element 'ram:UltimatePayeeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <report test="true()">
	Element 'ram:IncludedSupplyChainTradeLineItem' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ValuationBreakdownStatement">
      <report test="true()">
	Element 'rsm:ValuationBreakdownStatement' is marked as not used in the given context.</report>
    </rule>
  </pattern>
</schema>
