<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="ubl-model" id="model-pattern">
  <param name="BR-DE-01" value="cac:PaymentMeans"/>
  <param name="BR-DE-02" value="cac:Party/cac:Contact"/>
  <param name="BR-DE-03" value="cbc:CityName[boolean(normalize-space(.))]"/>
  <param name="BR-DE-04" value="cbc:PostalZone[boolean(normalize-space(.))]"/>
  <param name="BR-DE-05" value="cbc:Name[boolean(normalize-space(.))]"/>
  <param name="BR-DE-06" value="cbc:Telephone[boolean(normalize-space(.))]"/>
  <param name="BR-DE-07" value="cbc:ElectronicMail[boolean(normalize-space(.))]"/>
  <param name="BR-DE-08" value="cbc:CityName[boolean(normalize-space(.))]"/>
  <param name="BR-DE-09" value="cbc:PostalZone[boolean(normalize-space(.))]"/>
  <param name="BR-DE-10" value="cbc:CityName[boolean(normalize-space(.))]"/>
  <param name="BR-DE-11" value="cbc:PostalZone[boolean(normalize-space(.))]"/>
  <param name="BR-DE-13"
    value="count((cac:PaymentMeans/cac:PayeeFinancialAccount)[1]) + count(cac:PaymentMeans/cac:CardAccount) + count(cac:PaymentMeans/cac:PaymentMandate) = 1"/>
  <param name="BR-DE-14" value="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]"/>
  <param name="BR-DE-15" value="cbc:BuyerReference[boolean(normalize-space(.))]"/>
  <!-- In BR-DE-16 'if a then b else true' has been reshaped to 'not a or b' -->
  <param name="BR-DE-16" value="not((cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and following-sibling::cac:TaxScheme/cbc:ID = 'VAT'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or (cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or
    (cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or (cac:TaxRepresentativeParty, cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))])"/>
  <param name="BR-DE-17"
    value="cbc:InvoiceTypeCode = ('326', '380', '384', '389', '381', '875', '876', '877')"/>
  <param name="BR-DE-18"
    value="every $line 
             in cac:PaymentTerms/cbc:Note[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')] 
           satisfies matches (
                       normalize-space ($line),
                       $XR-SKONTO-REGEX
                   ) and matches( cac:PaymentTerms/cbc:Note[1]/text(), '\n\s*$' )
          " />
   
  <param name="BR-DE-19"
    value="not(cbc:PaymentMeansCode = '58') or  matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then $cp - 55 else  $cp - 48),'')) mod 97 = 1"/>
  <param name="BR-DE-20"
    value="not(cbc:PaymentMeansCode = '59') or  matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then $cp - 55 else  $cp - 48),'')) mod 97 = 1"/>
    
  <param name="BR-DE-21"
    value="cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_2.0' or cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_2.0#conformant#urn:xoev-de:kosit:extension:xrechnung_2.0'"/>


  <param name="INVOICE" value="//ubl:Invoice"/>
  <param name="BG-4_SELLER" value="//ubl:Invoice/cac:AccountingSupplierParty"/>
  <param name="BG-5_SELLER_POSTAL_ADDRESS"
    value="//ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress"/>
  <param name="BG-6_SELLER_CONTACT"
    value="//ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact"/>

  <param name="BG-8_BUYER_POSTAL_ADDRESS"
    value="//ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress"/>

  <param name="BG-15_DELIVER_TO_ADDRESS"
    value="//ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address"/>

  <param name="BG-16_PAYMENT_INSTRUCTIONS" value="//ubl:Invoice/cac:PaymentMeans"/>

  <param name="BG-23_VAT_BREAKDOWN" value="//ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal"/>

</pattern>
