<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="ubl-model"
  id="model-pattern">
  <param name="BR-DE-01" value="cac:PaymentMeans" />
  <param name="BR-DE-02" value="cac:Party/cac:Contact" />
  <param name="BR-DE-03" value="cbc:CityName[boolean(normalize-space(.))]" />
  <param name="BR-DE-04" value="cbc:PostalZone[boolean(normalize-space(.))]" />
  <param name="BR-DE-05" value="cbc:Name[boolean(normalize-space(.))]" />
  <param name="BR-DE-06" value="cbc:Telephone[boolean(normalize-space(.))]" />
  <param name="BR-DE-07" value="cbc:ElectronicMail[boolean(normalize-space(.))]" />
  <param name="BR-DE-08" value="cbc:CityName[boolean(normalize-space(.))]" />
  <param name="BR-DE-09" value="cbc:PostalZone[boolean(normalize-space(.))]" />
  <param name="BR-DE-10" value="cbc:CityName[boolean(normalize-space(.))]" />
  <param name="BR-DE-11" value="cbc:PostalZone[boolean(normalize-space(.))]" />
  <param name="BR-DE-13"
    value="count((cac:PaymentMeans/cac:PayeeFinancialAccount)[1]) + count(cac:PaymentMeans/cac:CardAccount) + count(cac:PaymentMeans/cac:PaymentMandate) = 1" />
  <param name="BR-DE-14"
    value="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]" />
  <param name="BR-DE-15" value="cbc:BuyerReference[boolean(normalize-space(.))]" />
  <param name="BR-DE-16"
    value="(cac:TaxRepresentativeParty, cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))])" />
  <param name="BR-DE-17"
    value="cbc:InvoiceTypeCode = ('326', '380', '384', '389', '381', '875', '876', '877')" />
  <param name="BR-DE-18"
    value="every $line in cac:PaymentTerms/cbc:Note/tokenize(.,'(\r\n|\r|\n)') satisfies if(count(tokenize($line,'#')) &gt; 1) then tokenize($line,'#')[1]='' and (tokenize($line,'#')[2]='SKONTO' or tokenize($line,'#')[2]='VERZUG') and string-length(replace(tokenize($line,'#')[3],'TAGE=[0-9]+',''))=0 and string-length(replace(tokenize($line,'#')[4],'PROZENT=[0-9]+\.[0-9]{2}',''))=0 and (tokenize($line,'#')[5]='' and empty(tokenize($line,'#')[6]) or string-length(replace(tokenize($line,'#')[5],'BASISBETRAG=[0-9]+\.[0-9]{2}',''))=0 and tokenize($line,'#')[6]='' and empty(tokenize($line,'#')[7])) else true()" />
  <param name="BR-DE-19"
    value="   not(cbc:PaymentMeansCode = '58') or          matches(cac:PayeeFinancialAccount/cbc:ID, '[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}') and          xs:integer(         replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(         upper-case(concat(substring(cac:PayeeFinancialAccount/cbc:ID,5),substring(cac:PayeeFinancialAccount/cbc:ID,1,4)))         ,'A','10'),'B','11'),'C','12'),'D','13'),'E','14'),'F','15'),'G','16'),'H','17'),'I','18'),'J','19'),'K','20'),'L','21'),'M','22')         ,'N','23'),'O','24'),'P','25'),'Q','26'),'R','27'),'S','28'),'T','29'),'U','30'),'V','31'),'W','32'),'X','33'),'Y','34'),'Z','35')         ) mod 97 = 1     " />
  <param name="BR-DE-20"
    value="not(cbc:PaymentMeansCode = '59') or matches(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}') and          xs:integer(         replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(         upper-case(concat(substring(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID,5),substring(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID,1,4)))         ,'A','10'),'B','11'),'C','12'),'D','13'),'E','14'),'F','15'),'G','16'),'H','17'),'I','18'),'J','19'),'K','20'),'L','21'),'M','22')         ,'N','23'),'O','24'),'P','25'),'Q','26'),'R','27'),'S','28'),'T','29'),'U','30'),'V','31'),'W','32'),'X','33'),'Y','34'),'Z','35') ) mod 97 = 1" />
  <param name="BR-DE-21"
    value="cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_1.2'" />

  <param name="INVOICE" value="//ubl:Invoice" />
  <param name="BG-4_SELLER" value="//ubl:Invoice/cac:AccountingSupplierParty" />
  <param name="BG-5_SELLER_POSTAL_ADDRESS"
    value="//ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />
  <param name="BG-6_SELLER_CONTACT"
    value="//ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact" />

  <param name="BG-8_BUYER_POSTAL_ADDRESS"
    value="//ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

  <param name="BG-15_DELIVER_TO_ADDRESS"
    value="//ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address" />

  <param name="BG-16_PAYMENT_INSTRUCTIONS"
    value="//ubl:Invoice/cac:PaymentMeans" />

  <param name="BG-23_VAT_BREAKDOWN"
    value="//ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" />

</pattern>
