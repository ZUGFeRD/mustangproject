<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="model"
    id="CII-model">
    <param name="BR-DE-01"
        value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans" />
    <param name="BR-DE-02" value="ram:DefinedTradeContact" />
    <param name="BR-DE-03" value="ram:CityName[boolean(normalize-space(.))]" />
    <param name="BR-DE-04" value="ram:PostcodeCode[boolean(normalize-space(.))]" />
    <param name="BR-DE-05"
        value="(ram:PersonName,ram:DepartmentName)[boolean(normalize-space(.))]" />
    <param name="BR-DE-06"
        value="ram:TelephoneUniversalCommunication/ram:CompleteNumber[boolean(normalize-space(.))]" />
    <param name="BR-DE-07"
        value="ram:EmailURIUniversalCommunication/ram:URIID[boolean(normalize-space(.))]" />
    <param name="BR-DE-08" value="ram:CityName[boolean(normalize-space(.))]" />
    <param name="BR-DE-09" value="ram:PostcodeCode[boolean(normalize-space(.))]" />
    <param name="BR-DE-10" value="ram:CityName[boolean(normalize-space(.))]" />
    <param name="BR-DE-11" value="ram:PostcodeCode[boolean(normalize-space(.))]" />
    <!-- Für BG-19 wird jedes Informationselement der Gruppe einzeln aufgeführt, der Pfad zu BG-19 (DIRECT DEBIT) zu unspezifisch ist und
        sich mit den Pfaden zu BG-17 und BG-18 überschneidet.  -->
    <param name="BR-DE-13"
        value="count((rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount)[1]) + count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard) + count((rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID, rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID, rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID)[1]) = 1" />
    <param name="BR-DE-14"
        value="ram:RateApplicablePercent[boolean(normalize-space(.))]" />
    <param name="BR-DE-15"
        value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[boolean(normalize-space(.))]" />
    <param name="BR-DE-16"
        value="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA' or @schemeID='VAT' or @schemeID='FC'][boolean(normalize-space(.))], rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty)" />
    <param name="BR-DE-17"
        value="rsm:ExchangedDocument/ram:TypeCode = ('326', '380', '384', '389', '381', '875', '876', '877')" />
    <param name="BR-DE-18"
        value="every $line in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description/tokenize(.,'(\r\n|\r|\n)') satisfies if(count(tokenize($line,'#')) &gt; 1) then tokenize($line,'#')[1]='' and (tokenize($line,'#')[2]='SKONTO' or tokenize($line,'#')[2]='VERZUG') and string-length(replace(tokenize($line,'#')[3],'TAGE=[0-9]+',''))=0 and string-length(replace(tokenize($line,'#')[4],'PROZENT=[0-9]+\.[0-9]{2}',''))=0 and (tokenize($line,'#')[5]='' and empty(tokenize($line,'#')[6]) or string-length(replace(tokenize($line,'#')[5],'BASISBETRAG=[0-9]+\.[0-9]{2}',''))=0 and tokenize($line,'#')[6]='' and empty(tokenize($line,'#')[7])) else true()" />
    <param name="BR-DE-19"
        value="         not(ram:TypeCode = '58') or          matches(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and          xs:integer(         replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(         upper-case(concat(substring(ram:PayeePartyCreditorFinancialAccount/ram:IBANID,5),substring(ram:PayeePartyCreditorFinancialAccount/ram:IBANID,1,4)))         ,'A','10'),'B','11'),'C','12'),'D','13'),'E','14'),'F','15'),'G','16'),'H','17'),'I','18'),'J','19'),'K','20'),'L','21'),'M','22')         ,'N','23'),'O','24'),'P','25'),'Q','26'),'R','27'),'S','28'),'T','29'),'U','30'),'V','31'),'W','32'),'X','33'),'Y','34'),'Z','35')         ) mod 97 = 1         " />
    <param name="BR-DE-20"
        value="         not(ram:TypeCode = '59') or          matches(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and          xs:integer(         replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(         upper-case(concat(substring(ram:PayerPartyDebtorFinancialAccount/ram:IBANID,5),substring(ram:PayerPartyDebtorFinancialAccount/ram:IBANID,1,4)))         ,'A','10'),'B','11'),'C','12'),'D','13'),'E','14'),'F','15'),'G','16'),'H','17'),'I','18'),'J','19'),'K','20'),'L','21'),'M','22')         ,'N','23'),'O','24'),'P','25'),'Q','26'),'R','27'),'S','28'),'T','29'),'U','30'),'V','31'),'W','32'),'X','33'),'Y','34'),'Z','35')         ) mod 97 = 1" />
    <param name="BR-DE-21"
        value="ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_1.2'" />

    <param name="INVOICE" value="//rsm:CrossIndustryInvoice" />
    <param name="BG-2_PROCESS_CONTROL"
        value="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext" />
    <param name="BG-4_SELLER"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" />
    <param name="BG-5_SELLER_POSTAL_ADDRESS"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress" />
    <param name="BG-6_SELLER_CONTACT"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact" />

    <param name="BG-8_BUYER_POSTAL_ADDRESS"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress" />

    <param name="BG-15_DELIVER_TO_ADDRESS"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress" />

    <param name="BG-16_PAYMENT_INSTRUCTIONS"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans" />

    <param name="BG-23_VAT_BREAKDOWN"
        value="//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />

</pattern>
