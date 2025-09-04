<?xml version="1.0" encoding="UTF-8" standalone="no"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="iso">
  <title>Schema for Factur-X; 1.07.3; Accounting, MINIMUM</title>
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"/>
  <ns prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"/>
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>
  <pattern>
    <rule context="//ram:SellerTradeParty">
      <assert id="FX-SCH-A-000001" test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])">[BR-CO-26]-Permettant à l'acheteur d'identifier son fournisseur de manière automatique,l'identifiant du vendeur (BT-29),L'identifiant d'enregistrement légal du vendeur (BT-30) et/ou l'identifiant TVA du vendeur (BT-31) doivent être présents.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']">
      <assert id="FX-SCH-A-000002" test="contains(' 1A AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', substring(.,1,2), ' '))">[BR-CO-09]-L'identifiant de TVA du vendeur (BT-31),le numéro d'identification TVA du représentant fiscal du vendeur (BT-63) et le numéro d'identification TVA de l'acheteur (BT-48) doivent contenir un préfixe conforme au code ISO 3166-1 alpha-2, permettant d'identifier le pays émetteur. ,Pour la Grèce on peut utiliser le préfixe ‘EL’.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert id="FX-SCH-A-000003" test="(ram:TaxBasisTotalAmount)">[BR-13]-Un facture doit contenir le montant total de la facture H.T. (BT-109).</assert>
      <assert id="FX-SCH-A-000004" test="(ram:GrandTotalAmount)">[BR-14]-Un facture doit contenir le montant total de la facture T.T. (BT-112).</assert>
      <assert id="FX-SCH-A-000005" test="(ram:DuePayableAmount)">[BR-15]-Un facture doit contenir montant à payer (BT-115).</assert>
      <assert id="FX-SCH-A-000006" test="string-length(substring-after(ram:TaxBasisTotalAmount,'.'))&lt;=2">[BR-DEC-12]-Le nombre maximal de décimales permis pour le montant total de la facture HT (BT-109) est de 2.</assert>
      <assert id="FX-SCH-A-000007" test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]">[BR-DEC-13]-Le nombre maximal de décimales permis pour le montant total de la TVA sur la facture (BT-110) est de 2.</assert>
      <assert id="FX-SCH-A-000008" test="string-length(substring-after(ram:GrandTotalAmount,'.'))&lt;=2">[BR-DEC-14]-Le nombre maximal de décimales permis pour le montant total de la facture TTC  (BT-112) est de 2.</assert>
      <assert id="FX-SCH-A-000009" test="string-length(substring-after(ram:DuePayableAmount,'.'))&lt;=2">[BR-DEC-18]-Le nombre maximal de décimales permis pour le montant dû à payer (BT-115) est de 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice">
      <assert id="FX-SCH-A-000010" test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != '')">[BR-01]-La facture doit contenir un identifiant de spécification (BT-24).</assert>
      <assert id="FX-SCH-A-000011" test="(rsm:ExchangedDocument/ram:ID !='')">[BR-02]-La facture doit contenir un n° de facture (BT-1).</assert>
      <assert id="FX-SCH-A-000012" test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format='102']!='')">[BR-03]-La facture doit contenir une date d'émission de facture (BT-2).</assert>
      <assert id="FX-SCH-A-000013" test="(rsm:ExchangedDocument/ram:TypeCode!='')">[BR-04]-La facture doit contenir un code de type de facture (BT-3).</assert>
      <assert id="FX-SCH-A-000014" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!='')">[BR-05]-La facture doit contenir un code devise de la facture (BT-5).</assert>
      <assert id="FX-SCH-A-000015" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!='')">[BR-06]-La facture doit contenir le nom du vendeur (BT-27).</assert>
      <assert id="FX-SCH-A-000016" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!='')">[BR-07]-La facture doit contenir le nom de l'acheteur (BT-44).</assert>
      <assert id="FX-SCH-A-000017" test="//ram:SellerTradeParty/ram:PostalTradeAddress">[BR-08]-La facture doit contenir l'adresse du vendeur (BG-5).</assert>
      <assert id="FX-SCH-A-000018" test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">[BR-09]-L'adresse postale du vendeur (BG-5) doit coontenir le code de pays du vendeur (BT-40).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">L'élément 'ram:TypeCode' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">L'attribut '@format' est obligatoire dans ce contexte.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000022" test="string-length($codeValue3)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=3]/enumeration[@value=$codeValue3]">La valeur de '@format' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <let name="codeValue2" value="."/>
      <assert id="FX-SCH-A-000023" test="string-length($codeValue2)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=2]/enumeration[@value=$codeValue2]">La valeur de 'ram:TypeCode' n'est pas permise.</assert>
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
      <assert id="FX-SCH-A-000026" test="string-length($codeValue1)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=1]/enumeration[@value=$codeValue1]">La valeur de 'ram:ID' n'est pas permise.</assert>
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert id="FX-SCH-A-000027" test="count(ram:SellerTradeParty)=1">L'élément 'ram:SellerTradeParty' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000028" test="count(ram:BuyerTradeParty)=1">L'élément 'ram:BuyerTradeParty' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">L'élément 'ram:IssuerAssignedID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">L'élément 'ram:ID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue4" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue4)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=4]/enumeration[@value=$codeValue4]">La valeur de '@schemeID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration">
      <report test="true()">
	Element 'ram:SpecifiedTaxRegistration' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">L'élément 'ram:Name' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000032" test="count(ram:PostalTradeAddress)=1">L'élément 'ram:PostalTradeAddress' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000346" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000347" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">L'élément 'ram:CountryID' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue5" value="."/>
      <assert id="FX-SCH-A-000036" test="string-length($codeValue5)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=5]/enumeration[@value=$codeValue5]">La valeur de 'ram:CountryID' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue4" value="@schemeID"/>
      <assert id="FX-SCH-A-000031" test="string-length($codeValue4)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=4]/enumeration[@value=$codeValue4]">La valeur de '@schemeID' n'est pas permise.</assert>
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
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert id="FX-SCH-A-000038" test="count(ram:InvoiceCurrencyCode)=1">L'élément 'ram:InvoiceCurrencyCode' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000039" test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">L'élément 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
      <let name="codeValue6" value="."/>
      <assert id="FX-SCH-A-000040" test="string-length($codeValue6)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=6]/enumeration[@value=$codeValue6]">La valeur de 'ram:InvoiceCurrencyCode' n'est pas permise.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert id="FX-SCH-A-000041" test="count(ram:TaxBasisTotalAmount)=1">L'élément 'ram:TaxBasisTotalAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000042" test="count(ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode])&lt;=1">La variante de l'élément 'ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]' ne peut apparaître qu'au maximum une fois.</assert>
      <assert id="FX-SCH-A-000043" test="count(ram:GrandTotalAmount)=1">L'élément 'ram:GrandTotalAmount' doit apparaître exactement une fois.</assert>
      <assert id="FX-SCH-A-000044" test="count(ram:DuePayableAmount)=1">L'élément 'ram:DuePayableAmount' doit apparaître exactement une fois.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount">
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
      <let name="codeValue7" value="@currencyID"/>
      <assert id="FX-SCH-A-000045" test="string-length($codeValue7)=0 or document('FACTUR-X_MINIMUM_codedb.xml')/codedb/cl[@id=7]/enumeration[@value=$codeValue7]">La valeur de '@currencyID' n'est pas permise.</assert>
    </rule>
  </pattern>
</schema>