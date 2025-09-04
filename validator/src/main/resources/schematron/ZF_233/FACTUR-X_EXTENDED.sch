<?xml version="1.0" encoding="UTF-8" standalone="no"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="iso">
  <title>Schema for Factur-X; 1.07.3; EN16931-CONFORMANT-EXTENDED</title>
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"/>
  <ns prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"/>
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>
  <pattern>
    <rule context="//ram:AdditionalReferencedDocument">
      <assert id="FX-SCH-A-000280" test="(ram:IssuerAssignedID!='')">[BR-52]-Chaque document auxiliaire supplémentaire (BG-24) doit contenir une référence au document auxiliaire (BT-122).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert id="FX-SCH-A-000047" test="(ram:BasisAmount)">[BR-45]-Chaque ventilation de TVA (BG-23) doit contenir une catégorie de TVA de montant assujetti à l'impôt (BT-116).</assert>
      <assert id="FX-SCH-A-000048" test="(ram:CalculatedAmount)">[BR-46]-Chaque ventilation de TVA (BG-23) doit contenir un montant de taxe correspondant à la catégorie de TVA (BT-117).</assert>
      <assert id="FX-SCH-A-000049" test="(ram:CategoryCode)">[BR-47]-Chaque ventilation de TVA (BG-23) doit être définie par un code de catégorie de TVA (BT-118).</assert>
      <assert id="FX-SCH-A-000050" test="(ram:RateApplicablePercent) or (ram:CategoryCode = 'O')">[BR-48]-Chaque ventilation de TVA (BG-23) doit contenir un taux de catégorie de TVA (BT-119),except if the Invoice is not subject to VAT.,</assert>
      <assert id="FX-SCH-A-000051" test="((ram:TaxPointDate) and not (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and not (ram:DueDateTypeCode))">[BR-CO-03]-La date de taxation de la TVA (BT-7) et le code de date de taxation de la TVA  (BT-8) s'excluent mutuellement.</assert>
      <assert id="FX-SCH-A-000053" test="string-length(substring-after(ram:BasisAmount,'.'))&lt;=2">[BR-DEC-19]-Le nombre maximal de décimales permis pour  la catégorie de TVA du montant imposable (BT-116) est de 2.</assert>
      <assert id="FX-SCH-A-000054" test="string-length(substring-after(ram:CalculatedAmount,'.'))&lt;=2">[BR-DEC-20]-Le nombre maximal de décimales permis pour  la catégorie de TVA du montant de taxe (BT-117) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'Z']">
      <assert id="FX-SCH-A-000446" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='Z']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'Z'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='Z'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-Z-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z).</assert>
      <assert id="FX-SCH-A-000348" test="../ram:CalculatedAmount = 0">[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</assert>
      <assert id="FX-SCH-A-000349" test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)">[BR-Z-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.='S']">
      <assert id="FX-SCH-A-000351" test="not(../ram:ExemptionReason) and not (../ram:ExemptionReasonCode)">[BR-S-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
      <assert id="FX-SCH-A-000447" test="every $rate in ../ram:RateApplicablePercent/xs:decimal(.) satisfies (&#13;&#10;            for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance&#13;&#10;        )">[BR-FXEXT-S-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is equal to “S” ("Standard rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard rated" (S) and the VAT rate (BT-152, BT-96, BT-103, BT-X-274) equals the VAT category rate (BT-119).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S']">
      <assert id="FX-SCH-A-000448" test="for&#13;&#10; $BT117 in xs:decimal(ram:CalculatedAmount), &#13;&#10; $BT116 in xs:decimal(ram:BasisAmount),&#13;&#10; $BT118 in xs:decimal(ram:RateApplicablePercent),&#13;&#10; $calculatedAmount in xs:decimal(round($BT116 * $BT118 * xs:decimal(100)) div xs:decimal(100*100)),&#13;&#10; $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem)),&#13;&#10; $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),&#13;&#10; $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10; $tolerance in xs:decimal(0.01),&#13;&#10; $maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),&#13;&#10; $diff in xs:decimal($BT117 - $calculatedAmount),&#13;&#10; $abs in xs:decimal(abs($diff))&#13;&#10;return&#13;&#10; $abs le $maxTolerance">[BR-FXEXT-S-09]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is equal to “S” ("Standard rated"), Absolute Value of (VAT  category  tax  amount  (BT-117) - VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119)/100) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Standard rated " (S), and the VAT rate (BT-152, BT-96, BT-103, BT-X-274) equals the VAT category rate (BT-119).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert id="FX-SCH-A-000059" test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)">[BR-29]-Si la date de début de la période de facturation (BT-73) et la date de fin de la période de facturation (BT-74) sont tout deux précisées, la date de fin de la période de facturation (BT-74) doit être postérieure ou égale à la date de début de la période de facturation.(BT-73).</assert>
      <assert id="FX-SCH-A-000060" test="(ram:StartDateTime) or (ram:EndDateTime)">[BR-CO-19]-Si la période de facturation (BG-14) est utilisée, la date de début de la période de facturation (BT-73) ou la date de fin de la période de facturation (BT-74) doit être précisée.,the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled,or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='false']">
      <assert id="FX-SCH-A-000061" test="(../ram:ActualAmount)">[BR-31]-Chaque remise au niveau de document (BG-20) doit avoir un montant de remises au niveau de document (BT-92).</assert>
      <assert id="FX-SCH-A-000062" test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">[BR-32]-Chaque remise au niveau de document (BG-20)doit avoir un code de catégorie TVA pour les remises au niveau de document (BT-95).</assert>
      <assert id="FX-SCH-A-000063" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-33]-Chaque remise au niveau de document (BG-20)doit avoir un motif de remises (BT-97) ou un code de motif de remises au niveau de document (BT-98).</assert>
      <assert id="FX-SCH-A-000064" test="true()">[BR-CO-05]-Le code de motif de remises (BT-98) et le motif de remises au niveau de document doivent indiquer le même type de remises. ,,,,,,,,,,,,,,</assert>
      <assert id="FX-SCH-A-000065" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-CO-21]-Chaque remise au niveau de document (BG-20)doit avoir un motif de remises (BT-97) ou un code de motif de remises au niveau de document (BT-98),ou les deux.,</assert>
      <assert id="FX-SCH-A-000066" test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">[BR-DEC-01]-Le nombre maximal de décimales permis pour le montant de remises au niveau de document (BT-92) est de 2.</assert>
      <assert id="FX-SCH-A-000067" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">[BR-DEC-02]-Le nombre maximal de décimales permis pour le montant de base au niveau de document (BT-93) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='true']">
      <assert id="FX-SCH-A-000068" test="(../ram:ActualAmount)">[BR-36]-Chaque charge au niveau de document (BG-21)doit avoir un montant de charge au niveau de document (BT-99).</assert>
      <assert id="FX-SCH-A-000069" test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">[BR-37]-Chaque charge au niveau de document (BG-21)doit avoir un code de catégorie de  TVA pour charges au niveu du document (BT-102).</assert>
      <assert id="FX-SCH-A-000070" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-38]-Chaque charge au niveau de document (BG-21) doit avoir un motif de charge (BT-104) ou un code de motif de charge au niveau de document (BT-105).</assert>
      <assert id="FX-SCH-A-000071" test="true()">[BR-CO-06]-Le code du motif de charge (BT-105) et le motif de charge au niveau de document (BT-104) doivent indiquer le même type de charge. ,,,,,,,,,,,,,,</assert>
      <assert id="FX-SCH-A-000072" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-CO-22]-Chaque charge au niveau de document (BG-21) doit avoir un motif de charge (BT-104) ou un code de motif de charge au niveau de document (BT-105),ou les deux.,</assert>
      <assert id="FX-SCH-A-000073" test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">[BR-DEC-05]-Le nombre maximal de décimales permis pour le montant de charge au niveau de document (BT-99) est de 2.</assert>
      <assert id="FX-SCH-A-000074" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">[BR-DEC-06]-Le nombre maximal de décimales permis pour le montant de base de charges au niveau de document (BT-100) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic">
      <assert id="FX-SCH-A-000199" test="(ram:Description) and (ram:Value)">[BR-54]-Chaque attribut d'élément (BG-32) doit contenir un nom d'attribut d'élément (BT-160) et une valeur d'attribut d'élément (BT-161).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic/ram:TypeCode">
      <assert flag="warning" id="FX-SCH-A-000345" test="not(contains(normalize-space(.), ' ')) and contains(' A AAA AAB AAC AAD AAF AAG AAH AAI AAJ AAK AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABS ABT ABX ABY ABZ ACA ACE ACG ACN ACP ACS ACV ACW ACX ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX B BL BMY BMZ BNA BNB BNC BND BNE BNF BNG BNH BNI BNJ BNK BNL BNM BNN BNO BNP BNQ BNR BNS BNT BNU BNV BNW BNX BNY BNZ BR BRA BRB BRC BRD BRE BRF BRG BRH BRI BRJ BRK BRL BRM BRN BRO BRP BRQ BRR BRS BRT BRU BRV BS BSW BSX BSY BSZ BTA BTB BTC BTD BTE BTF BTG BTH BTI BTJ BTK BTL BTM BW CHN CHO CM CT CV CZ D DI DL DN DP DR DS DW E EA F FI FL FN FV GG GW HF HM HT IB ID L LM LN LND M MO MW N OD PRS PTN RA RF RJ RMW RP RUN RY SQ T TC TH TN TT VGM VH VW WA WD WM WU XH XQ XZ YS ZAL ZAS ZB ZBI ZC ZCA ZCB ZCE ZCL ZCO ZCR ZCU ZFE ZFS ZGE ZH ZK ZMG ZMN ZMO ZN ZNA ZNB ZNI ZO ZP ZPB ZS ZSB ZSE ZSI ZSL ZSN ZTA ZTE ZTI ZV ZW ZWA ZZN ZZR ZZZ BEST_BEFORE_DATE COLOR_TEXT COMMISSION DEPOSIT_SYSTEM DEPOSIT_TYPE ENERGY_CLASS EXPIRATION_DATE FEE KIND_OF_ARTICLE MATERIAL METER_LOCATION METER_NUMBER ORGANIC_CONTROL_BODY PACKAGING_MATERIAL PACKAGING_TYPE PROMOTIONAL_VARIANT SEAL_NUMBER SIZE_CODE SIZE_TEXT TRADING_UNIT WASTE_CODE WASTE_FRACTION WEEE_NUMBER ', concat(' ', normalize-space(.), ' '))">[BR-FXEXT-04]-Pour garantir le traitement automatisé des attributs d'articles sans réconciliation bilatérale,seules les valeurs de la liste de codes UNTDED 6313+Factur-X-Extension doivent être utilisées.,</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableTradeSettlementFinancialCard">
      <assert id="FX-SCH-A-000281" test="string-length(ram:ID)&lt;=10">[BR-51]-Conformément aux normes de sécurité relatives aux paiements par carte, une facture ne doit jamais contenir le numéro complet du compte principal de la carte (BT-87). À l'heure actuelle, le PCI Security Standards Council a défini que les 6 premiers chiffres et les 4 derniers chiffres constituent le nombre maximal de chiffres pouvant être affichés..</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:AssociatedDocumentLineDocument/ram:IncludedNote[ram:SubjectCode]">
      <assert id="FX-SCH-A-000301" test="(ram:ContentCode) or (ram:Content)">[BR-FXEXT-02]-Si le code sujet du texte libre de la ligne de facture (BT-X-10) est spécifié,il faut préciser soit le texte libre de la ligne de facture codée (BT-X-9), soit le texte libre de la ligne de facture (BT-127),,ou les deux. En cas où les deux, BT-X-9 et BT-127, sont spécifiés.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem">
      <assert id="FX-SCH-A-000200" test="(ram:AssociatedDocumentLineDocument/ram:LineID!='')">[BR-21]-Chaque ligne de facture (BG-25) doit have un identifiant de ligne de facture (BT-126).</assert>
      <assert id="FX-SCH-A-000201" test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)">[BR-22]-Chaque ligne de facture (BG-25) doit have une quantité facturée (BT-129).</assert>
      <assert id="FX-SCH-A-000202" test="(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode)">[BR-23]-Une ligne de facture (BG-25) doit avoir un code d'unité de mesure de quantité facturée (BT-130).</assert>
      <assert id="FX-SCH-A-000203" test="(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)">[BR-24]-Chaque ligne de facture (BG-25) doit avoir un montant net de ligne de facture (BT-131).</assert>
      <assert id="FX-SCH-A-000204" test="(ram:SpecifiedTradeProduct/ram:Name!='')">[BR-25]-Chaque ligne de facture (BG-25) doit contenir le nom d'article (BT-153).</assert>
      <assert id="FX-SCH-A-000205" test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)">[BR-26]-Chaque ligne de facture (BG-25) doit  contenir le prix net de l'article (BT-146).</assert>
      <assert id="FX-SCH-A-000206" test="(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount) &gt;= 0">[BR-27]-Le prix net de l'article (BT-146) ne doit pas être négatif.</assert>
      <assert id="FX-SCH-A-000207" test="(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount &gt;= 0) or not(ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount)">[BR-28]-Le prix brut de l'article (BT-148) ne doit pas être négatif.</assert>
      <assert id="FX-SCH-A-000208" test="ram:SpecifiedTradeProduct/ram:GlobalID/@schemeID!='' or not (ram:SpecifiedTradeProduct/ram:GlobalID)">[BR-64]-L'identifiant standard d'article (BT-157) doit avoir un identifiant de schéma.</assert>
      <assert id="FX-SCH-A-000209" test="(ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode/@listID!='') or not (ram:SpecifiedTradeProduct/ram:DesignatedProductClassification)">[BR-65]-L'identifiant de classification de l'article (BT-158) doit avoir un identifiant de schéma.</assert>
      <assert id="FX-SCH-A-000210" test="(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">[BR-CO-04]-Chaque ligne de facture (BG-25) doit être catégorisé avec un code de catégorie de TVA d'article facturé (BT-151).</assert>
      <assert id="FX-SCH-A-000211" test="string-length(substring-after(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount,'.'))&lt;=2">[BR-DEC-23]-Le nombre maximal de décimales permis pour le montant net de la ligne de facture  (BT-131) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:PayeeTradeParty">
      <assert id="FX-SCH-A-000075" test="(ram:Name) and (not(ram:Name = ../ram:SellerTradeParty/ram:Name) and not(ram:ID = ../ram:SellerTradeParty/ram:ID) and not(ram:SpecifiedLegalOrganization/ram:ID = ../ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID))">[BR-17]-le nom du bénéficiaire (BT-59) doit être indiqué sur la facture,si le bénéficiaire (BG-10) est différent du vendeur (BG-4).,</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTaxRepresentativeTradeParty">
      <assert id="FX-SCH-A-000076" test="(ram:Name)">[BR-18]-Le nom du représentant fiscal du vendeur (BT-62) doit être indiqué sur la facture,si le vendeur (BG-4) dispose d'un représentant fiscal (BG-11).,</assert>
      <assert id="FX-SCH-A-000077" test="(ram:PostalTradeAddress)">[BR-19]-L'adresse postale du représentant fiscal du vendeur (BG-12) doit être indiqué sur la facture,si le vendeur (BG-4) dispose d'un représentant fiscal (BG-11).,</assert>
      <assert id="FX-SCH-A-000078" test="(ram:PostalTradeAddress/ram:CountryID)">[BR-20]-L'adresse postale du représentant fiscal du vendeur (BG-12) doit contenir un code de pays du représentant fiscal (BT-69).,si le vendeur (BG-4) dispose d'un représentant fiscal (BG-11).,</assert>
      <assert id="FX-SCH-A-000079" test="(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']!='')">[BR-56]-Chaque partie du représentant fiscal du vendeur (BG-11) doit avoir un identifiant de TVA du représentant fiscal du vendeur (BT-63).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTradeParty">
      <assert id="FX-SCH-A-000001" test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])">[BR-CO-26]-Permettant à l'acheteur d'identifier son fournisseur de manière automatique,l'identifiant du vendeur (BT-29),L'identifiant d'enregistrement légal du vendeur (BT-30) et/ou l'identifiant TVA du vendeur (BT-31) doivent être présents.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert id="FX-SCH-A-000212" test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)">[BR-30]-Si la date de début de la période de la ligne de facture (BT-134) et la date de fin de la période de la ligne de facture (BT-135) sont toutes deux indiquées, la date de fin de la période de la ligne de facture (BT-135) doit être postérieure ou égale à la date de début de la période de la ligne de facture (BT-134).</assert>
      <assert id="FX-SCH-A-000213" test="(ram:StartDateTime) or (ram:EndDateTime)">[BR-CO-20]-Si la période de ligne de facture (BG-26) est employée,, la date de début de la période de ligne de facture (BT-134) ou la date de fin de la période de ligne de facture (BT-135) doit être remplie,,ou les deux.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']">
      <assert id="FX-SCH-A-000214" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-42]-Chaque remise sur ligne de facture (BG-27) doit avoir un motif de remise sur ligne de facture (BT-139) ou un code de motif de remise sur ligne de facture (BT-140).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']&#13;&#10;">
      <assert id="FX-SCH-A-000215" test="(../ram:ActualAmount)">[BR-41]-Chaque remise de ligne de facture (BG-27) doit avoir un montant de remise par ligne de facture (BT-136).</assert>
      <assert id="FX-SCH-A-000216" test="true()">[BR-CO-07]-Le code motif de remise sur ligne de facture (BT-140) et le motif de remise sur ligne de facture (BT-139) doivent indiquer le même type de motif de remise.</assert>
      <assert id="FX-SCH-A-000217" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-CO-23]-Chaque remise sur ligne de facture (BG-27) doit contenir un motif de remise sur ligne de facture (BT-139) ou un code de motif de remise sur ligne de facture (BT-140),,ou les deux.,</assert>
      <assert id="FX-SCH-A-000218" test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">[BR-DEC-24]-Le nombre maximal de décimales permis pour le montant de la remise sur ligne de facture (BT-136) est de 2.</assert>
      <assert id="FX-SCH-A-000219" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">[BR-DEC-25]-Le nombre maximal de décimales permis pour le montant de base de la remise sur ligne de facture (BT-137) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'true']">
      <assert id="FX-SCH-A-000220" test="(../ram:ActualAmount)">[BR-43]-Chaque ligne de facture (BG-28) doit contenir un montant de ligne de facture (BT-141).</assert>
      <assert id="FX-SCH-A-000221" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-44]-Chaque ligne de facture (BG-28) doit contenir un motif de facturation (BT-144) ou un code de motif de facturation (BT-145).</assert>
      <assert id="FX-SCH-A-000222" test="true()">[BR-CO-08]-Le code motif de charges de la ligne de facture (BT-145) et le motif de charges de la ligne de facture (BT-144) doivent indiquer le même type de motif de charges.</assert>
      <assert id="FX-SCH-A-000223" test="(../ram:Reason) or (../ram:ReasonCode)">[BR-CO-24]-Chaque ligne de facture (BG-28) doit contenir un motif de facturation (BT-144) ou un code de motif de facturation (BT-145), ,ou les deux.,</assert>
      <assert id="FX-SCH-A-000224" test="string-length(substring-after(../ram:ActualAmount,'.'))&lt;=2">[BR-DEC-27]-Le nombre maximal de décimales permis pour le montant des charges par ligne de facture (BT-141) est de 2.</assert>
      <assert id="FX-SCH-A-000225" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">[BR-DEC-28]-Le nombre maximal de décimales permis pour le montant de base de la ligne de facture (BT-142) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']">
      <assert id="FX-SCH-A-000002" test="contains(' 1A AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', substring(.,1,2), ' '))">[BR-CO-09]-L'identifiant de TVA du vendeur (BT-31),le numéro d'identification TVA du représentant fiscal du vendeur (BT-63) et le numéro d'identification TVA de l'acheteur (BT-48) doivent contenir un préfixe conforme au code ISO 3166-1 alpha-2, permettant d'identifier le pays émetteur. ,Pour la Grèce on peut utiliser le préfixe ‘EL’.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[not(ancestor::ram:SellerTradeParty)]">
      <assert id="FX-SCH-A-000302" test="@schemeID='VA'">[BR-FXEXT-03]-Seul un numéro d'identification TVA peut être fourni pour les partenaires commerciaux suivants : le destinataire au niveau de ligne (BT-X-66),le destinataire ultime au niveau de ligne (BT-X-84),l'agent commercial (BT-X-340),le représentant fiscal de l'acheteur (BT-X-367),,le produit-utilisateur ultime (BT-X-144),l'agent acheteur(BT-X-411),le destinataire au niveau de document  (BT-X-161),le destinataire ultime au niveau de document (BT-X-180),le lieu d'expédition (BT-X-199),le facturier (BT-X-223),le destinataire de la facture (BT-X-242),le bénéficiaire au niveau de document (BT-X-257),le payeur (BT-X-481),ou le bénéficiaire spécifique aux termes de paiement (BT-X-509).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge">
      <assert id="FX-SCH-A-000080" test="(ram:ChargeIndicator)">[BR-66]-Chaque charge voire remise commerciale spécifiée (BG-20)(BG-21) doit contenir un indicateur de charge. ,,,,,,,,,,,,,,</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']">
      <assert id="FX-SCH-A-000352" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="FX-SCH-A-000353" test="ram:RateApplicablePercent = 0">[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'E']">
      <assert id="FX-SCH-A-000354" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000355" test="ram:RateApplicablePercent = 0">[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'G']">
      <assert id="FX-SCH-A-000356" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000357" test="ram:RateApplicablePercent = 0">[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'K']">
      <assert id="FX-SCH-A-000358" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="FX-SCH-A-000359" test="ram:RateApplicablePercent = 0">[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'L']">
      <assert id="FX-SCH-A-000360" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-AF-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000361" test="ram:RateApplicablePercent &gt; 0">[BR-AF-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'M']">
      <assert id="FX-SCH-A-000362" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-AG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000363" test="ram:RateApplicablePercent &gt;= 0">[BR-AG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'O']">
      <assert id="FX-SCH-A-000365" test="not(ram:RateApplicablePercent)">[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'S']">
      <assert id="FX-SCH-A-000366" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000367" test="ram:RateApplicablePercent &gt; 0">[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']">
      <assert id="FX-SCH-A-000368" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000369" test="ram:RateApplicablePercent = 0">[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']">
      <assert id="FX-SCH-A-000370" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="FX-SCH-A-000371" test="ram:RateApplicablePercent = 0">[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'E']">
      <assert id="FX-SCH-A-000372" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000373" test="ram:RateApplicablePercent = 0">[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'G']">
      <assert id="FX-SCH-A-000374" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000375" test="ram:RateApplicablePercent = 0">[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'K']">
      <assert id="FX-SCH-A-000376" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="FX-SCH-A-000377" test="ram:RateApplicablePercent = 0">[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'L']">
      <assert id="FX-SCH-A-000378" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-AF-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000379" test="ram:RateApplicablePercent &gt; 0">[BR-AF-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'M']">
      <assert id="FX-SCH-A-000380" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-AG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000381" test="ram:RateApplicablePercent &gt;= 0">[BR-AG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'O']">
      <assert id="FX-SCH-A-000383" test="not(ram:RateApplicablePercent)">[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'S']">
      <assert id="FX-SCH-A-000384" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000385" test="ram:RateApplicablePercent &gt; 0">[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']">
      <assert id="FX-SCH-A-000386" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000387" test="ram:RateApplicablePercent = 0">[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert id="FX-SCH-A-000303" test="for $calculatedAmount in xs:decimal(round(sum(../../ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * xs:decimal(100)) div xs:decimal(100)),&#13;&#10;            $totalAmount in xs:decimal(ram:LineTotalAmount),&#13;&#10;            $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem)),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $nbLineItems * $tolerance,&#13;&#10;            $diff in xs:decimal($totalAmount - $calculatedAmount),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance">[BR-FXEXT-CO-10]-Valeur absolue de (somme des montants nets de ligne de facture (BT-106) - Σ montants nets de ligne de facture(BT-131))&lt;= 0,01 * nombre des montants nets au niveau de ligne (BT-131).,</assert>
      <assert id="FX-SCH-A-000117" test="(ram:LineTotalAmount)">[BR-12]-La facture doit contenir le montant net de la somme de la ligne de facture (BT-106).</assert>
      <assert id="FX-SCH-A-000003" test="(ram:TaxBasisTotalAmount)">[BR-13]-Un facture doit contenir le montant total de la facture H.T. (BT-109).</assert>
      <assert id="FX-SCH-A-000004" test="(ram:GrandTotalAmount)">[BR-14]-Un facture doit contenir le montant total de la facture T.T. (BT-112).</assert>
      <assert id="FX-SCH-A-000005" test="(ram:DuePayableAmount)">[BR-15]-Un facture doit contenir montant à payer (BT-115).</assert>
      <assert id="FX-SCH-A-000304" test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']) and not (ram:AllowanceTotalAmount)) or&#13;&#10;(for $calculatedAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:ActualAmount)* 10 * 10 ) div 100),&#13;&#10;            $totalAmount in xs:decimal(ram:AllowanceTotalAmount),&#13;&#10;            $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $nbAllowanceItems * $tolerance,&#13;&#10;            $diff in xs:decimal($totalAmount - $calculatedAmount),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance)">[BR-FXEXT-CO-11]-Valeur absolue de (Somme des remises au niveau de document (BT-107) - Σ Montants des remises au niveau de document (BT-92))&lt;= 0,01 * Nombre de montants de remises au niveau de document (BT-92).,</assert>
      <assert id="FX-SCH-A-000305" test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true'])and not (ram:ChargeTotalAmount)) &#13;&#10;or&#13;&#10;(for $calculatedAmount in xs:decimal(xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:ActualAmount)* 100 ) div 100)+ xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100)),&#13;&#10;            $totalAmount in xs:decimal(ram:ChargeTotalAmount),&#13;&#10;                        $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $nbChargeItems * $tolerance,&#13;&#10;            $diff in xs:decimal($totalAmount - $calculatedAmount),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance)">[BR-FXEXT-CO-12]-Valeur absolue de (Somme des charges au niveau de document (BT-108) - Σ Montants des charges au niveau de document (BT-99) - Σ Montants des frais de service logistique (BT-x-272))&lt;= 0,01 * (Nombre de montants des charges au niveau de document (BT-99) + Nombre de montants des frais liés aux services logistiques) (BT-X-272)).,</assert>
      <assert id="FX-SCH-A-000306" test="for $BT109 in xs:decimal(ram:TaxBasisTotalAmount),&#13;&#10;   $BT131Sum in xs:decimal(round(sum(../../ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * xs:decimal(100)) div xs:decimal(100)),&#13;&#10;   $BT92Sum in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:ActualAmount)* 10 * 10 ) div 100),&#13;&#10;   $BT99Sum in xs:decimal(xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:ActualAmount)* 100 ) div 100)+ xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100)),&#13;&#10;   $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem)),&#13;&#10;   $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),&#13;&#10;   $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10;            $tolerance in xs:decimal(0.01),&#13;&#10;            $maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),&#13;&#10;            $diff in xs:decimal($BT109 - $BT131Sum + $BT92Sum - $BT99Sum),&#13;&#10;            $abs in xs:decimal(abs($diff))&#13;&#10;        return&#13;&#10;        $abs le $maxTolerance">[BR-FXEXT-CO-13]-Valeur absolue de (montant total de la facture hors TVA (BT-109) - ∑ montants nets des lignes de facture (BT-131) + Σ montants des remises au niveau de document (BT-92) - Σ montants des charges au niveau de document (BT-99)) &lt;= 0,01 * (Nombre de montants nets par ligne (BT-131) + Nombre de montants de remises au niveau de document (BT-92) + Nombre de montants de charges au niveau de document (BT-99)).,</assert>
      <assert id="FX-SCH-A-000307" test="for $Currency in ../ram:InvoiceCurrencyCode,&#13;&#10;   $BT109 in xs:decimal(ram:TaxBasisTotalAmount),&#13;&#10;   $BT110 in xs:decimal(ram:TaxTotalAmount[@currencyID=$Currency]),   &#13;&#10;   $BT112 in xs:decimal(ram:GrandTotalAmount),&#13;&#10;   $nbTaxTotalAmountInvoiceCurrency in count (ram:TaxTotalAmount[@currencyID=$Currency] ),&#13;&#10;   $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem)),&#13;&#10;   $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),&#13;&#10;   $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),&#13;&#10;   $tolerance in xs:decimal(0.01),&#13;&#10;   $maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),&#13;&#10;   $diff in xs:decimal($BT112 - $BT110 - $BT109),&#13;&#10;   $abs in xs:decimal(abs($diff))&#13;&#10;return&#13;&#10;  ($abs le $maxTolerance and $nbTaxTotalAmountInvoiceCurrency eq 1) or&#13;&#10;  ($BT109 eq $BT112 and $nbTaxTotalAmountInvoiceCurrency ne 1)">[BR-FXEXT-CO-15]-Si la TVA du montant total de la facture (BT-110),,dont la devise (BT-110-0) est égal à BT-5,,est présente,la valeur absolue de (montant total de la facture avec TVA (BT-112) - montant total de la facture sans TVA (BT-109) - montant total de la TVA sur la facture (BT-110)) &lt;= 0,,01 * (Nombre de montants nets par ligne (BT-131) + Nombre de montants de remises au niveau de document (BT-92) + Nombre de montants de charges au niveau de document (BT-99) + Nombre de montants de frais de service logistique(BT-X-272). Sinon,le montant total de la facture avec TVA (BT-112) est égal au montant total de la facture sans TVA (BT-109).,,,,,</assert>
      <assert id="FX-SCH-A-000122" test="(xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) - xs:decimal(ram:TotalPrepaidAmount) + xs:decimal(ram:RoundingAmount)) or &#13;&#10;    ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) + xs:decimal(ram:RoundingAmount)) and not (xs:decimal(ram:TotalPrepaidAmount))) or &#13;&#10;    ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount) - xs:decimal(ram:TotalPrepaidAmount)) and not (xs:decimal(ram:RoundingAmount))) or &#13;&#10;    ((xs:decimal(ram:DuePayableAmount) = xs:decimal(ram:GrandTotalAmount)) and not (xs:decimal(ram:TotalPrepaidAmount)) and not (xs:decimal(ram:RoundingAmount)))">[BR-CO-16]-Montant dû à payer (BT-115) = Montant total de la facture avec TVA (BT-112) - Montant payé (BT-113) + Montant arrondi (BT-114).</assert>
      <assert id="FX-SCH-A-000123" test="string-length(substring-after(ram:LineTotalAmount,'.'))&lt;=2">[BR-DEC-09]-Le nombre maximal de décimales permis pour le montant net de la ligne de facture (BT-106) est de 2.</assert>
      <assert id="FX-SCH-A-000124" test="string-length(substring-after(ram:AllowanceTotalAmount,'.'))&lt;=2">[BR-DEC-10]-Le nombre maximal de décimales permis pour la somme des remises au niveau de document (BT-107) est de 2.</assert>
      <assert id="FX-SCH-A-000125" test="string-length(substring-after(ram:ChargeTotalAmount,'.'))&lt;=2">[BR-DEC-11]-Le nombre maximal de décimales permis pour la somme des charges au niveau de document (BT-108) est de 2.</assert>
      <assert id="FX-SCH-A-000006" test="string-length(substring-after(ram:TaxBasisTotalAmount,'.'))&lt;=2">[BR-DEC-12]-Le nombre maximal de décimales permis pour le montant total de la facture HT (BT-109) est de 2.</assert>
      <assert id="FX-SCH-A-000007" test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]">[BR-DEC-13]-Le nombre maximal de décimales permis pour le montant total de la TVA sur la facture (BT-110) est de 2.</assert>
      <assert id="FX-SCH-A-000008" test="string-length(substring-after(ram:GrandTotalAmount,'.'))&lt;=2">[BR-DEC-14]-Le nombre maximal de décimales permis pour le montant total de la facture TTC  (BT-112) est de 2.</assert>
      <assert id="FX-SCH-A-000126" test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and . = round(. * 100) div 100) or not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">[BR-DEC-15]-Le nombre maximal de décimales permis pour le montant total de la TVA sur la facture en devise comptable (BT-111) est de 2.</assert>
      <assert id="FX-SCH-A-000127" test="string-length(substring-after(ram:TotalPrepaidAmount,'.'))&lt;=2">[BR-DEC-16]-Le nombre maximal de décimales permis pour le montant payé (BT-113) est de 2.</assert>
      <assert id="FX-SCH-A-000128" test="string-length(substring-after(ram:RoundingAmount,'.'))&lt;=2">[BR-DEC-17]-Le nombre maximal de décimales permis pour le montant arrondi (BT-114) est de 2.</assert>
      <assert id="FX-SCH-A-000009" test="string-length(substring-after(ram:DuePayableAmount,'.'))&lt;=2">[BR-DEC-18]-Le nombre maximal de décimales permis pour le montant dû à payer (BT-115) est de 2.</assert>
      <assert id="FX-SCH-A-000129" test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) or (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and (ram:TaxTotalAmount/@currencyID = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) and not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode))">[BR-53]-Si le code de devise comptable de la TVA (BT-6) est présent, ,le montant total de la TVA de la facture dans la devise comptable (BT-111) doit être fourni.,</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]">
      <assert id="FX-SCH-A-000130" test=". = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount)*10*10)div 100)">[BR-CO-14]-Montant total de TVA sur la facture (BT-110) = Σ Montant de la taxe sur la catégorie TVA (BT-117).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans">
      <assert id="FX-SCH-A-000131" test="(ram:TypeCode)">[BR-49]-L'instruction de paiement (BG-16) doit spécifier le code correspondant au mode de moyen de paiement.(BT-81).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode='30' or ram:TypeCode='58']/ram:PayeePartyCreditorFinancialAccount">
      <assert id="FX-SCH-A-000133" test="(ram:IBANID) or (ram:ProprietaryID)">[BR-50]-Une facture contenant de l'information concernant le virement bancaire (BG-16) doit également contenir un identifiant de compte de paiement (BT-84).</assert>
      <assert id="FX-SCH-A-000134" test="(ram:IBANID) or (ram:ProprietaryID)">[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, ,transfert local de credit ou transfert de crédit international Non-SEPA, ,l'identifiant du compte de paiement (BT-84) doit être présent.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans[some $code in tokenize('30 58', '\s')  satisfies normalize-space(ram:TypeCode) = $code]">
      <assert id="FX-SCH-A-000132" test="(ram:PayeePartyCreditorFinancialAccount/ram:IBANID or ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID) and not(ram:PayeePartyCreditorFinancialAccount/ram:IBANID and ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID)&#13;&#10;">[BR-CO-27]-Il est obligatoire d'utiliser soit l'IBAN soit un identifiant propriétaire (BT-84).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert id="FX-SCH-A-000135" test="ram:ApplicableTradeTax">[BR-CO-18]-Une facture doit contenir au moins un groupe de ventilation de la TVA (BG-23).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'AE']">
      <assert id="FX-SCH-A-000449" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'AE'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='AE'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-AE-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse Charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reversed Charge" (AE).</assert>
      <assert id="FX-SCH-A-000388" test="../ram:CalculatedAmount = 0">[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</assert>
      <assert id="FX-SCH-A-000389" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">[BR-AE-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'E']">
      <assert id="FX-SCH-A-000450" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='E'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-E-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Exempt from VAT" (E).</assert>
      <assert id="FX-SCH-A-000390" test="../ram:CalculatedAmount = 0">[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
      <assert id="FX-SCH-A-000391" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">[BR-E-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'G']">
      <assert id="FX-SCH-A-000451" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'G'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='G'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-G-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export outside the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Export outside the EU " (G).</assert>
      <assert id="FX-SCH-A-000392" test="../ram:CalculatedAmount = 0">[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</assert>
      <assert id="FX-SCH-A-000393" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">[BR-G-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.= 'K']">
      <assert id="FX-SCH-A-000452" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'K'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='K'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-IC-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Intra-community supply " (K)</assert>
      <assert id="FX-SCH-A-000394" test="../ram:CalculatedAmount = 0">[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</assert>
      <assert id="FX-SCH-A-000395" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">[BR-IC-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
      <assert id="FX-SCH-A-000396" test="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)">[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</assert>
      <assert id="FX-SCH-A-000397" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']">
      <assert id="FX-SCH-A-000453" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'L'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='L'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-AF-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Canary Islands tax " (L).</assert>
      <assert id="FX-SCH-A-000398" test="true()">[BR-AF-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert id="FX-SCH-A-000399" test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)">[BR-AF-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']">
      <assert id="FX-SCH-A-000454" test="for &#13;&#10;    $basisAmount in xs:decimal(../ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'M'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='M'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-AG-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Ceuta and Mellita tax " (M).</assert>
      <assert id="FX-SCH-A-000400" test="true()">[BR-AG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
      <assert id="FX-SCH-A-000401" test="not(ram:ExemptionReason) and not (ram:ExemptionReasonCode)">[BR-AG-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']">
      <assert id="FX-SCH-A-000455" test="for &#13;&#10;    $basisAmount in xs:decimal(ram:BasisAmount),&#13;&#10;    $lineAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100), &#13;&#10;       $chargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O']/xs:decimal(ram:AppliedAmount)) * 100) div 100),&#13;&#10;    $allowanceAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount)) * 100) div 100),&#13;&#10;    $calculatedAmount in xs:decimal($lineAmount + $chargeAmount + $logisticChargeAmount - $allowanceAmount),&#13;&#10;    $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'O'])),&#13;&#10;    $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='O'])),&#13;&#10;    $nbLogisticCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O'])),&#13;&#10;    $tolerance in xs:decimal(0.01),&#13;&#10;    $maxTolerance in $tolerance * ($nbLineItems + $nbAllowancesOrCharges + $nbLogisticCharges),&#13;&#10;    $diff in xs:decimal($basisAmount - $calculatedAmount),&#13;&#10;    $abs in xs:decimal(abs($diff))&#13;&#10;            return&#13;&#10;                $abs le $maxTolerance">[BR-FXEXT-O-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charges amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Not subject to VAT " (O).</assert>
      <assert id="FX-SCH-A-000402" test="ram:CalculatedAmount = 0">[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</assert>
      <assert id="FX-SCH-A-000403" test="(ram:ExemptionReason) or (ram:ExemptionReasonCode)">[BR-O-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'AE']">
      <assert id="FX-SCH-A-000417" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="FX-SCH-A-000418" test="ram:RateApplicablePercent = 0">[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'E']">
      <assert id="FX-SCH-A-000419" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000420" test="ram:RateApplicablePercent = 0">[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'G']">
      <assert id="FX-SCH-A-000421" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000422" test="ram:RateApplicablePercent = 0">[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'K']">
      <assert id="FX-SCH-A-000423" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="FX-SCH-A-000424" test="ram:RateApplicablePercent = 0">[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']">
      <assert id="FX-SCH-A-000425" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-AF-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000426" test="ram:RateApplicablePercent &gt; 0">[BR-AF-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be greater than 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']">
      <assert id="FX-SCH-A-000427" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-AG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000428" test="ram:RateApplicablePercent &gt;= 0">[BR-AG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']">
      <assert id="FX-SCH-A-000430" test="not(ram:RateApplicablePercent)">[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'S']">
      <assert id="FX-SCH-A-000431" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000432" test="ram:RateApplicablePercent &gt; 0">[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'Z']">
      <assert id="FX-SCH-A-000433" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="FX-SCH-A-000434" test="ram:RateApplicablePercent = 0">[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice">
      <assert id="FX-SCH-A-000253" test="//ram:IncludedSupplyChainTradeLineItem">[BR-16]-La facture doit contenir une ligne de facture au minimum (BG-25).</assert>
      <assert id="FX-SCH-A-000155" test="(number(//ram:DuePayableAmount) &gt; 0 and ((//ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime) or (//ram:SpecifiedTradePaymentTerms/ram:Description))) or not(number(//ram:DuePayableAmount) &gt; 0)">[BR-CO-25]-En cas où le montant à payer (BT-115) est positif,soit la date d'échéance du paiement (BT-9), soit les conditions de paiement (BT-20) doivent être présentes.,</assert>
      <assert id="FX-SCH-A-000010" test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != '')">[BR-01]-La facture doit contenir un identifiant de spécification (BT-24).</assert>
      <assert id="FX-SCH-A-000011" test="(rsm:ExchangedDocument/ram:ID !='')">[BR-02]-La facture doit contenir un n° de facture (BT-1).</assert>
      <assert id="FX-SCH-A-000012" test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format='102']!='')">[BR-03]-La facture doit contenir une date d'émission de facture (BT-2).</assert>
      <assert id="FX-SCH-A-000013" test="(rsm:ExchangedDocument/ram:TypeCode!='')">[BR-04]-La facture doit contenir un code de type de facture (BT-3).</assert>
      <assert id="FX-SCH-A-000014" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!='')">[BR-05]-La facture doit contenir un code devise de la facture (BT-5).</assert>
      <assert id="FX-SCH-A-000015" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!='')">[BR-06]-La facture doit contenir le nom du vendeur (BT-27).</assert>
      <assert id="FX-SCH-A-000016" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!='')">[BR-07]-La facture doit contenir le nom de l'acheteur (BT-44).</assert>
      <assert id="FX-SCH-A-000017" test="//ram:SellerTradeParty/ram:PostalTradeAddress">[BR-08]-La facture doit contenir l'adresse du vendeur (BG-5).</assert>
      <assert id="FX-SCH-A-000018" test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">[BR-09]-L'adresse postale du vendeur (BG-5) doit coontenir le code de pays du vendeur (BT-40).</assert>
      <assert id="FX-SCH-A-000156" test="//ram:BuyerTradeParty/ram:PostalTradeAddress">[BR-10]-La facture doit contenir l'adresse postale de l'acheteur (BG-8).</assert>
      <assert id="FX-SCH-A-000157" test="//ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">[BR-11]-L'adresse postale de l'acheteur doir contenir le code du pays de l'acheteur (BT-55).</assert>
      <assert id="FX-SCH-A-000158" test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication)">[BR-62]-L'adresse électronique du vendeur (BT-34) doit contenir un identifiant de schéma.</assert>
      <assert id="FX-SCH-A-000159" test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication)">[BR-63]-L'adresse électronique de l'achetur (BT-49) doit contenir un identifiant de schéma.</assert>
      <assert id="FX-SCH-A-000435" test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) and     ((count(//ram:CategoryTradeTax[ram:CategoryCode='S']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='S']))">[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</assert>
      <assert id="FX-SCH-A-000436" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='Z'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='Z'])))">[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".</assert>
      <assert id="FX-SCH-A-000437" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='E'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='E'])))">[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Exempt from VAT” shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</assert>
      <assert id="FX-SCH-A-000438" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='AE'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='AE'])))">[BR-AE-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Reverse charge" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</assert>
      <assert id="FX-SCH-A-000439" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='K'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='K'])))">[BR-IC-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Intra-community supply" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</assert>
      <assert id="FX-SCH-A-000440" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='G'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=1 and (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='G'])))">[BR-G-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</assert>
      <assert id="FX-SCH-A-000441" test="not(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O']) or ( &#13;&#10;    count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O'])=1 and &#13;&#10;    (exists(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O']) or&#13;&#10;    exists(//ram:CategoryTradeTax[ram:CategoryCode='O'])))">[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</assert>
      <assert id="FX-SCH-A-000442" test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) and &#13;&#10;    ((count(//ram:CategoryTradeTax[ram:CategoryCode='L']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='L']))">[BR-AF-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IGIC" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</assert>
      <assert id="FX-SCH-A-000443" test="((count(//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) &gt;=2 or not (//ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) and &#13;&#10;    ((count(//ram:CategoryTradeTax[ram:CategoryCode='M']) + count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])) &gt;=2 or not (//ram:CategoryTradeTax[ram:CategoryCode='M']))">[BR-AG-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IPSI" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</assert>
      <assert id="FX-SCH-A-000263" test="(not(//ram:CountryID != 'IT') and //ram:CategoryCode ='B') or (not(//ram:CategoryCode ='B'))">[BR-B-01]-Une facture dont le code de catégorie de TVA (BT-151,BT-95 ou BT-102) BT-95 ou BT-102) est "Paiement fractionné" doit être une facture italienne nationale.,</assert>
      <assert id="FX-SCH-A-000444" test="(//ram:CategoryCode ='B' and (not(//ram:CategoryCode ='S'))) or (not(//ram:CategoryCode ='B'))">[BR-B-02]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment" shall not contain an invoice line (BG-25), a Document level allowance (BG-20) or  a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated”.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode]">
      <assert id="FX-SCH-A-000318" test="(ram:ContentCode) or (ram:Content)">[BR-FXEXT-01]-Si le code du sujet du texte libre de la facture (BT-21) est spécifié,on doit préciser soit le texte libre du message codé (BT-X-5), soit le texte libre du message (BT-22),ou les deux. Si les deux BT-X-5 et BT-22 sont spécifiés,les deux deux doivent avoir la même signification.,,</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery">
      <assert id="FX-SCH-A-000170" test="(ram:ShipToTradeParty/ram:PostalTradeAddress and ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID!='') or not (ram:ShipToTradeParty/ram:PostalTradeAddress)">[BR-57]-Chaque adresse de livraison (BG-15) doit contenir un code de pays de livraison (BT-80).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <assert id="FX-SCH-A-000182" test="(ram:IssuerAssignedID!='')">[BR-55]-Chaque référecne de facture précédente (BG-3) doit contenir une référence de la facture précédente (BT-25).</assert>
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000283" test="count(ram:Name)&lt;=1">L'élément  'ram:Name' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000315" test="count(ram:LanguageID)&lt;=1">L'élément 'ram:LanguageID' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod">
      <assert id="FX-SCH-A-000316" test="count(ram:CompleteDateTime)=1">L'élément 'ram:CompleteDateTime' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:CompleteDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000317" test="count(ram:Content)&lt;=1">L'élément 'ram:Content' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000161" test="count(ram:SubjectCode)&lt;=1">L'élément 'ram:SubjectCode' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:ContentCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue4" value="."/>
      <assert id="FX-SCH-A-000162" test="string-length($codeValue4)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=4]/enumeration[@value=$codeValue4]">La valeur de 'ram:SubjectCode' n'est pas permise.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:LanguageID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <let name="codeValue2" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue2)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=2]/enumeration[@value=$codeValue2]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <assert id="FX-SCH-A-000024" test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1">L'élément 'ram:BusinessProcessSpecifiedDocumentContextParameter' peut apparaître au maximum une fois.</assert>
      <assert id="FX-SCH-A-000025" test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1">L'élément 'ram:GuidelineSpecifiedDocumentContextParameter' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID">
      <let name="codeValue1" value="."/>
      <assert id="FX-SCH-A-000026" test="string-length($codeValue1)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=1]/enumeration[@value=$codeValue1]">La valeur de 'ram:ID' n'est pas permise.</assert>
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction">
      <assert id="FX-SCH-A-000265" test="count(ram:IncludedSupplyChainTradeLineItem)&gt;=1">L'élément  'ram:IncludedSupplyChainTradeLineItem' doit apparaître au moins 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert id="FX-SCH-A-000027" test="count(ram:SellerTradeParty)=1">L'élément 'ram:SellerTradeParty' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000028" test="count(ram:BuyerTradeParty)=1">L'élément 'ram:BuyerTradeParty' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ not(ram:TypeCode=&quot;916&quot;) and  not(ram:TypeCode=&quot;50&quot;) and  not(ram:TypeCode=&quot;130&quot;)]">
      <report test="true()">
	Element variant 'ram:AdditionalReferencedDocument[ not(ram:TypeCode="916") and  not(ram:TypeCode="50") and  not(ram:TypeCode="130")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue15" value="."/>
      <assert id="FX-SCH-A-000282" test="string-length($codeValue15)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">La valeur de 'ram:ReferenceTypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:TypeCode">
      <let name="codeValue33" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue33)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=33]/enumeration[@value=$codeValue33]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue32" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue32)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=32]/enumeration[@value=$codeValue32]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000283" test="count(ram:Name)&lt;=1">L'élément  'ram:Name' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000284" test="count(ram:AttachmentBinaryObject)&lt;=1">L'élément  'ram:AttachmentBinaryObject' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject">
      <assert id="FX-SCH-A-000285" test="@mimeCode">L'attribut '@mimeCode' est requis dans ce contexte.</assert>
      <let name="codeValue14" value="@mimeCode"/>
      <assert id="FX-SCH-A-000287" test="string-length($codeValue14)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=14]/enumeration[@value=$codeValue14]">La valeur de '@mimeCode' n'est pas permise.</assert>
      <assert id="FX-SCH-A-000286" test="@filename">L'attribut '@filename' est requis dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue31" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue31)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=31]/enumeration[@value=$codeValue31]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <assert id="FX-SCH-A-000319" test="count(ram:DeliveryTypeCode)=1">L'élément 'ram:DeliveryTypeCode' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:DeliveryTypeCode">
      <let name="codeValue30" value="."/>
      <assert id="FX-SCH-A-000320" test="string-length($codeValue30)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=30]/enumeration[@value=$codeValue30]">La valeur de 'ram:DeliveryTypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000169" test="count(ram:SpecifiedTaxRegistration)=1">L'élément 'ram:SpecifiedTaxRegistration' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">L'élément 'ram:Description' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000032" test="count(ram:PostalTradeAddress)=1">L'élément 'ram:PostalTradeAddress' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue28" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue28)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=28]/enumeration[@value=$codeValue28]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue15" value="."/>
      <assert id="FX-SCH-A-000282" test="string-length($codeValue15)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">La valeur de 'ram:ReferenceTypeCode' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000032" test="count(ram:PostalTradeAddress)=1">L'élément 'ram:PostalTradeAddress' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000169" test="count(ram:SpecifiedTaxRegistration)=1">L'élément 'ram:SpecifiedTaxRegistration' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue29" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue29)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=29]/enumeration[@value=$codeValue29]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">L'élément 'ram:Description' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000032" test="count(ram:PostalTradeAddress)=1">L'élément 'ram:PostalTradeAddress' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000346" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000347" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000171" test="count(ram:OccurrenceDateTime)=1">L'élément 'ram:OccurrenceDateTime' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000322" test="count(ram:ModeCode)=1">L'élément 'ram:ModeCode' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment/ram:SpecifiedLogisticsTransportMovement/ram:ModeCode">
      <let name="codeValue34" value="."/>
      <assert id="FX-SCH-A-000346" test="string-length($codeValue34)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=34]/enumeration[@value=$codeValue34]">La valeur de 'ram:ModeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert id="FX-SCH-A-000172" test="count(ram:PaymentReference)&lt;=1">L'élément 'ram:PaymentReference' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000038" test="count(ram:InvoiceCurrencyCode)=1">L'élément 'ram:InvoiceCurrencyCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000173" test="count(ram:ApplicableTradeTax)&gt;=1">L'élément 'ram:ApplicableTradeTax' doit apparaître au moin une fois.</assert>
      <assert id="FX-SCH-A-000039" test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">L'élément 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert id="FX-SCH-A-000176" test="count(ram:CalculatedAmount)=1">L'élément 'ram:CalculatedAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000177" test="count(ram:BasisAmount)=1">L'élément 'ram:BasisAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000323" test="count(ram:LineTotalBasisAmount)&lt;=1">L'élément 'ram:LineTotalBasisAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000324" test="count(ram:AllowanceChargeBasisAmount)&lt;=1">L'élément 'ram:AllowanceChargeBasisAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <let name="codeValue38" value="."/>
      <assert id="FX-SCH-A-000180" test="string-length($codeValue38)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=38]/enumeration[@value=$codeValue38]">La valeur de 'ram:DueDateTypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-000181" test="string-length($codeValue20)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">La valeur de 'ram:ExemptionReasonCode' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue37" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue37)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=37]/enumeration[@value=$codeValue37]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue24)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">L'élément 'ram:Description' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:CompleteDateTime">
      <report test="true()">
	Element 'ram:CompleteDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
      <let name="codeValue35" value="."/>
      <assert id="FX-SCH-A-000040" test="string-length($codeValue35)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=35]/enumeration[@value=$codeValue35]">La valeur de 'ram:InvoiceCurrencyCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue43" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue43)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=43]/enumeration[@value=$codeValue43]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:TypeCode">
      <let name="codeValue44" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue44)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=44]/enumeration[@value=$codeValue44]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment">
      <assert id="FX-SCH-A-000325" test="count(ram:IncludedTradeTax)&gt;=1">L'élément 'ram:IncludedTradeTax' doit apparaître au moins 1 fois.</assert>
      <assert id="FX-SCH-A-000326" test="count(ram:InvoiceSpecifiedReferencedDocument)&lt;=1">L'élément 'ram:InvoiceSpecifiedReferencedDocument' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:FormattedReceivedDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax">
      <assert id="FX-SCH-A-000176" test="count(ram:CalculatedAmount)=1">L'élément 'ram:CalculatedAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-000181" test="string-length($codeValue20)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">La valeur de 'ram:ExemptionReasonCode' n'est pas permise.</assert>
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
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue24)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue45" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue45)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=45]/enumeration[@value=$codeValue45]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:PaidAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge">
      <assert id="FX-SCH-A-000294" test="count(ram:Description)=1">L'élément  'ram:Description' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000327" test="count(ram:AppliedAmount)=1">L'élément 'ram:AppliedAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000328" test="count(ram:AppliedTradeTax)&gt;=1">L'élément 'ram:AppliedTradeTax' doit apparaître au moins 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax">
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000329" test="count(ram:RateApplicablePercent)=1">L'élément 'ram:RateApplicablePercent' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:ExemptionReason">
      <report test="true()">
	Element 'ram:ExemptionReason' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:ExemptionReasonCode">
      <report test="true()">
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</report>
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
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue24)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">L'élément 'ram:ChargeIndicator' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">L'élément 'ram:ActualAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000185" test="count(ram:CategoryTradeTax)=1">L'élément 'ram:CategoryTradeTax' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReason">
      <report test="true()">
	Element 'ram:ExemptionReason' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <report test="true()">
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</report>
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
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue24)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue39" value="."/>
      <assert id="FX-SCH-A-000186" test="string-length($codeValue39)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=39]/enumeration[@value=$codeValue39]">La valeur de 'ram:ReasonCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">L'élément 'ram:ChargeIndicator' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">L'élément 'ram:ActualAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000185" test="count(ram:CategoryTradeTax)=1">L'élément 'ram:CategoryTradeTax' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReason">
      <report test="true()">
	Element 'ram:ExemptionReason' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <report test="true()">
	Element 'ram:ExemptionReasonCode' is marked as not used in the given context.</report>
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
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue24)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode">
      <let name="codeValue40" value="."/>
      <assert id="FX-SCH-A-000186" test="string-length($codeValue40)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=40]/enumeration[@value=$codeValue40]">La valeur de 'ram:ReasonCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms">
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">L'élément 'ram:Description' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000188" test="count(ram:DirectDebitMandateID)&lt;=1">L'élément 'ram:DirectDebitMandateID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000330" test="count(ram:PartialPaymentAmount)&lt;=1">L'élément 'ram:PartialPaymentAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000331" test="count(ram:PayeeTradeParty)&lt;=1">L'élément 'ram:PayeeTradeParty' ne peut apparaître qu'au maximum une fois.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisPeriodMeasure">
      <assert id="FX-SCH-A-000277" test="@unitCode">L'attribut '@unitCode' est requis dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PartialPaymentAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert id="FX-SCH-A-000189" test="count(ram:LineTotalAmount)=1">L'élément 'ram:LineTotalAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000190" test="count(ram:ChargeTotalAmount)&lt;=1">L'élément 'ram:ChargeTotalAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000191" test="count(ram:AllowanceTotalAmount)&lt;=1">L'élément 'ram:AllowanceTotalAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000041" test="count(ram:TaxBasisTotalAmount)=1">L'élément 'ram:TaxBasisTotalAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000042" test="count(ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode])&lt;=1">La variante de l'élément 'ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000192" test="count(ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode])&lt;=1">La variante de l'élément 'ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000290" test="count(ram:RoundingAmount)&lt;=1">L'élément  'ram:RoundingAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000043" test="count(ram:GrandTotalAmount)=1">L'élément 'ram:GrandTotalAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000193" test="count(ram:TotalPrepaidAmount)&lt;=1">L'élément 'ram:TotalPrepaidAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000044" test="count(ram:DuePayableAmount)=1">L'élément 'ram:DuePayableAmount' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000046" test="@currencyID">L'attribut '@currencyID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue41" value="@currencyID"/>
      <assert id="FX-SCH-A-000045" test="string-length($codeValue41)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=41]/enumeration[@value=$codeValue41]">La valeur de '@currencyID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]">
      <assert id="FX-SCH-A-000046" test="@currencyID">L'attribut '@currencyID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue42" value="@currencyID"/>
      <assert id="FX-SCH-A-000045" test="string-length($codeValue42)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=42]/enumeration[@value=$codeValue42]">La valeur de '@currencyID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans">
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000291" test="count(ram:Information)&lt;=1">L'élément  'ram:Information' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000194" test="count(ram:PayeePartyCreditorFinancialAccount)&lt;=1">L'élément 'ram:PayeePartyCreditorFinancialAccount' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000292" test="count(ram:BICID)=1">L'élément  'ram:BICID' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount">
      <assert id="FX-SCH-A-000195" test="count(ram:IBANID)=1">L'élément 'ram:IBANID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode">
      <let name="codeValue36" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue36)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=36]/enumeration[@value=$codeValue36]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:ConversionRateDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:SourceCurrencyCode">
      <let name="codeValue35" value="."/>
      <assert id="FX-SCH-A-000332" test="string-length($codeValue35)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=35]/enumeration[@value=$codeValue35]">La valeur de 'ram:SourceCurrencyCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:TargetCurrencyCode">
      <let name="codeValue35" value="."/>
      <assert id="FX-SCH-A-000333" test="string-length($codeValue35)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=35]/enumeration[@value=$codeValue35]">La valeur de 'ram:TargetCurrencyCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
      <let name="codeValue35" value="."/>
      <assert id="FX-SCH-A-000196" test="string-length($codeValue35)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=35]/enumeration[@value=$codeValue35]">La valeur de 'ram:TaxCurrencyCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <assert id="FX-SCH-A-000266" test="count(ram:AssociatedDocumentLineDocument)=1">L'élément  'ram:AssociatedDocumentLineDocument' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000267" test="count(ram:SpecifiedTradeProduct)=1">L'élément  'ram:SpecifiedTradeProduct' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000268" test="count(ram:SpecifiedLineTradeAgreement)=1">L'élément  'ram:SpecifiedLineTradeAgreement' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000269" test="count(ram:SpecifiedLineTradeDelivery)=1">L'élément  'ram:SpecifiedLineTradeDelivery' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument">
      <assert id="FX-SCH-A-000270" test="count(ram:LineID)=1">L'élément  'ram:LineID' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote">
      <assert id="FX-SCH-A-000317" test="count(ram:Content)&lt;=1">L'élément 'ram:Content' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000161" test="count(ram:SubjectCode)&lt;=1">L'élément 'ram:SubjectCode' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:ContentCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue4" value="."/>
      <assert id="FX-SCH-A-000162" test="string-length($codeValue4)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=4]/enumeration[@value=$codeValue4]">La valeur de 'ram:SubjectCode' n'est pas permise.</assert>
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
      <let name="codeValue5" value="."/>
      <assert id="FX-SCH-A-000334" test="string-length($codeValue5)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=5]/enumeration[@value=$codeValue5]">La valeur de 'ram:LineStatusCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode">
      <let name="codeValue6" value="."/>
      <assert id="FX-SCH-A-000335" test="string-length($codeValue6)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=6]/enumeration[@value=$codeValue6]">La valeur de 'ram:LineStatusReasonCode' n'est pas permise.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:ParentLineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement">
      <assert id="FX-SCH-A-000272" test="count(ram:NetPriceProductTradePrice)=1">L'élément  'ram:NetPriceProductTradePrice' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000283" test="count(ram:Name)&lt;=1">L'élément  'ram:Name' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000284" test="count(ram:AttachmentBinaryObject)&lt;=1">L'élément  'ram:AttachmentBinaryObject' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject">
      <assert id="FX-SCH-A-000285" test="@mimeCode">L'attribut '@mimeCode' est requis dans ce contexte.</assert>
      <let name="codeValue14" value="@mimeCode"/>
      <assert id="FX-SCH-A-000287" test="string-length($codeValue14)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=14]/enumeration[@value=$codeValue14]">La valeur de '@mimeCode' n'est pas permise.</assert>
      <assert id="FX-SCH-A-000286" test="@filename">L'attribut '@filename' est requis dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue15" value="."/>
      <assert id="FX-SCH-A-000282" test="string-length($codeValue15)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">La valeur de 'ram:ReferenceTypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:TypeCode">
      <let name="codeValue13" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue13)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000273" test="count(ram:ChargeAmount)=1">L'élément  'ram:ChargeAmount' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">L'élément 'ram:ChargeIndicator' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">L'élément 'ram:ActualAmount' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue16" value="."/>
      <assert id="FX-SCH-A-000186" test="string-length($codeValue16)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=16]/enumeration[@value=$codeValue16]">La valeur de 'ram:ReasonCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">L'élément 'ram:ChargeIndicator' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">L'élément 'ram:ActualAmount' doit apparaître exactement une fois.</assert>
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
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode">
      <let name="codeValue17" value="."/>
      <assert id="FX-SCH-A-000186" test="string-length($codeValue17)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=17]/enumeration[@value=$codeValue17]">La valeur de 'ram:ReasonCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity">
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:IncludedTradeTax">
      <report test="true()">
	Element 'ram:IncludedTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice">
      <assert id="FX-SCH-A-000273" test="count(ram:ChargeAmount)=1">L'élément  'ram:ChargeAmount' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000336" test="count(ram:IncludedTradeTax)&lt;=1">L'élément 'ram:IncludedTradeTax' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:AppliedTradeAllowanceCharge">
      <report test="true()">
	Element 'ram:AppliedTradeAllowanceCharge' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity">
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax">
      <assert id="FX-SCH-A-000176" test="count(ram:CalculatedAmount)=1">L'élément 'ram:CalculatedAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000329" test="count(ram:RateApplicablePercent)=1">L'élément 'ram:RateApplicablePercent' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-000181" test="string-length($codeValue20)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">La valeur de 'ram:ExemptionReasonCode' n'est pas permise.</assert>
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
      <let name="codeValue18" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue18)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=18]/enumeration[@value=$codeValue18]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery">
      <assert id="FX-SCH-A-000276" test="count(ram:BilledQuantity)=1">L'élément  'ram:BilledQuantity' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent">
      <assert id="FX-SCH-A-000171" test="count(ram:OccurrenceDateTime)=1">L'élément 'ram:OccurrenceDateTime' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
      <assert id="FX-SCH-A-000277" test="@unitCode">L'attribut '@unitCode' est requis dans ce contexte.</assert>
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ChargeFreeQuantity">
      <assert id="FX-SCH-A-000277" test="@unitCode">L'attribut '@unitCode' est requis dans ce contexte.</assert>
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000277" test="@unitCode">L'attribut '@unitCode' est requis dans ce contexte.</assert>
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">L'élément 'ram:RoleCode' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">L'élément 'ram:URIUniversalCommunication' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">L'élément 'ram:SpecifiedTaxRegistration' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
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
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">L'élément  'ram:CompleteNumber' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue21" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue21)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=21]/enumeration[@value=$codeValue21]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">L'élément 'ram:CountrySubDivisionName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue22" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue22)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=22]/enumeration[@value=$codeValue22]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">L'élément 'ram:URIID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue23" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue23)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=23]/enumeration[@value=$codeValue23]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement">
      <assert id="FX-SCH-A-000173" test="count(ram:ApplicableTradeTax)&gt;=1">L'élément 'ram:ApplicableTradeTax' doit apparaître au moin une fois.</assert>
      <assert id="FX-SCH-A-000279" test="count(ram:SpecifiedTradeSettlementLineMonetarySummation)=1">L'élément  'ram:SpecifiedTradeSettlementLineMonetarySummation' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000337" test="count(ram:InvoiceReferencedDocument)&lt;=1">L'élément 'ram:InvoiceReferencedDocument' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000175" test="count(ram:ReceivableSpecifiedTradeAccountingAccount)&lt;=1">L'élément 'ram:ReceivableSpecifiedTradeAccountingAccount' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue15" value="."/>
      <assert id="FX-SCH-A-000282" test="string-length($codeValue15)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=15]/enumeration[@value=$codeValue15]">La valeur de 'ram:ReferenceTypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:TypeCode">
      <let name="codeValue13" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue13)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=13]/enumeration[@value=$codeValue13]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax">
      <assert id="FX-SCH-A-000338" test="count(ram:CalculatedAmount)&lt;=1">L'élément 'ram:CalculatedAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">L'élément 'ram:CategoryCode' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue19" value="."/>
      <assert id="FX-SCH-A-000179" test="string-length($codeValue19)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=19]/enumeration[@value=$codeValue19]">La valeur de 'ram:CategoryCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-000181" test="string-length($codeValue20)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=20]/enumeration[@value=$codeValue20]">La valeur de 'ram:ExemptionReasonCode' n'est pas permise.</assert>
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
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue24)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=24]/enumeration[@value=$codeValue24]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue12" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue12)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=12]/enumeration[@value=$codeValue12]">La valeur de '@format' n'est pas permise.</assert>
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
      <let name="codeValue27" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue27)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=27]/enumeration[@value=$codeValue27]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">L'élément 'ram:ChargeIndicator' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">L'élément 'ram:ActualAmount' doit apparaître exactement une fois.</assert>
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
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-000186" test="string-length($codeValue25)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=25]/enumeration[@value=$codeValue25]">La valeur de 'ram:ReasonCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">L'élément 'ram:ChargeIndicator' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">L'élément 'ram:ActualAmount' doit apparaître exactement une fois.</assert>
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
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-000186" test="string-length($codeValue26)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=26]/enumeration[@value=$codeValue26]">La valeur de 'ram:ReasonCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation">
      <assert id="FX-SCH-A-000189" test="count(ram:LineTotalAmount)=1">L'élément 'ram:LineTotalAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000190" test="count(ram:ChargeTotalAmount)&lt;=1">L'élément 'ram:ChargeTotalAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000191" test="count(ram:AllowanceTotalAmount)&lt;=1">L'élément 'ram:AllowanceTotalAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000339" test="count(ram:TaxTotalAmount)&lt;=1">L'élément 'ram:TaxTotalAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000340" test="count(ram:GrandTotalAmount)&lt;=1">L'élément 'ram:GrandTotalAmount' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000341" test="count(ram:TotalAllowanceChargeAmount)&lt;=1">L'élément 'ram:TotalAllowanceChargeAmount' ne peut apparaître qu'au maximum une fois.</assert>
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
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TotalAllowanceChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct">
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">L'élément 'ram:Description' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic">
      <assert id="FX-SCH-A-000294" test="count(ram:Description)=1">L'élément  'ram:Description' doit apparaître exactement 1 fois.</assert>
      <assert id="FX-SCH-A-000295" test="count(ram:Value)=1">L'élément  'ram:Value' doit apparaître exactement 1 fois.</assert>
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
      <assert id="FX-SCH-A-000342" test="count(ram:ClassName)&lt;=1">L'élément 'ram:ClassName' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode">
      <assert id="FX-SCH-A-000296" test="@listID">L'attribut '@listID' est requis dans ce contexte.</assert>
      <let name="codeValue8" value="@listID"/>
      <assert id="FX-SCH-A-000297" test="string-length($codeValue8)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=8]/enumeration[@value=$codeValue8]">La valeur de '@listID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue7" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue7)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=7]/enumeration[@value=$codeValue7]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">L'élément 'ram:ID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000343" test="count(ram:IndustryAssignedID)&lt;=1">L'élément 'ram:IndustryAssignedID' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">L'élément 'ram:Description' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000344" test="count(ram:UnitQuantity)&lt;=1">L'élément 'ram:UnitQuantity' ne peut apparaître qu'au maximum une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:BuyerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:GlobalID">
      <assert id="FX-SCH-A-000037" test="@schemeID">L'attribut '@schemeID' est obligatoire dans ce contexte.</assert>
      <let name="codeValue10" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue10)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=10]/enumeration[@value=$codeValue10]">La valeur de '@schemeID' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000277" test="@unitCode">L'attribut '@unitCode' est requis dans ce contexte.</assert>
      <let name="codeValue11" value="@unitCode"/>
      <assert id="FX-SCH-A-000275" test="string-length($codeValue11)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=11]/enumeration[@value=$codeValue11]">La valeur de '@unitCode' n'est pas permise.</assert>
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
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ModelID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry/ram:ID">
      <let name="codeValue9" value="."/>
      <assert id="FX-SCH-A-000026" test="string-length($codeValue9)=0 or document('FACTUR-X_EXTENDED_codedb.xml')/codedb/cl[@id=9]/enumeration[@value=$codeValue9]">La valeur de 'ram:ID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:SellerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
</schema>