<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
        xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
        xmlns:u="utils"
        queryBinding="xslt2">
   <title>Schematron Version @xr-schematron.version.full@ - XRechnung @xrechnung.version@ compatible - UBL - Invoice / Creditnote</title>
   <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
   <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
   <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
   <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
   <ns prefix="cn"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
   <ns prefix="ubl-invoice"
       uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
   <ns prefix="ubl-creditnote"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
   <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
   <ns uri="utils" prefix="u"/>
   <!--BEGIN Parameters from PEPPOL-->
   <let name="profile"
        value="       if (/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')) then         tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]       else         'Unknown'"/>
   <let name="supplierCountry"
        value="       if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then         upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))       else         if (/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then           upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))         else           if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then             upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))           else             'XX'"/>
   <let name="customerCountry"
        value="   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))   else   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))   else   'XX'"/>
   <let name="documentCurrencyCode" value="/*/cbc:DocumentCurrencyCode"/>
   <let name="slackValue"
        value="if($documentCurrencyCode = 'HUF') then 0.5 else 0.02"/>
   <let name="isGreekSender"
        value="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
   <let name="isGreekReceiver"
        value="($customerCountry ='GR') or ($customerCountry ='EL')"/>
   <let name="isGreekSenderandReceiver"
        value="$isGreekSender and $isGreekReceiver"/>
   <let name="accountingSupplierCountry"
        value="     if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then     upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))     else     if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then     upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))     else     'XX'"/>
   <!--END Parameters from PEPPOL-->
   <phase id="xrechnung-model">
      <active pattern="variable-pattern"/>
      <active pattern="ubl-pattern"/>
      <active pattern="ubl-extension-pattern"/>
      <active pattern="peppol-ubl-pattern-1"/>
      <active pattern="peppol-ubl-pattern-2"/>
   </phase>
   <include href="../common.sch"/>
   <!--BEGIN Functions from PEPPOL-->
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:gln"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:slack"
             as="xs:boolean">
      <param name="exp" as="xs:decimal"/>
      <param name="val" as="xs:decimal"/>
      <param name="slack" as="xs:decimal"/>
      <value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod11"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod97-0208"
             as="xs:boolean">
      <param name="val"/>
      <variable name="checkdigits" select="substring($val,9,2)"/>
      <variable name="calculated_digits"
                select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
      <value-of select="number($checkdigits) = number($calculated_digits)"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCodiceIPA"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
      <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF16"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVAseIT"
             as="xs:boolean">
      <param name="arg" as="xs:string"/>
      <variable name="paese" select="substring($arg,1,2)"/>
      <variable name="codice" select="substring($arg,3)"/>
      <sequence select="     if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then     (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:addPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string"/>
      <param name="pari" as="xs:integer"/>
      <variable name="tappo"
                select="if (not($arg castable as xs:integer)) then 0 else 1"/>
      <variable name="mapper"
                select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
      <param name="val"/>
      <value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:TinVerification"
             as="xs:boolean">
      <param name="val" as="xs:string"/>
      <variable name="digits"
                select="    for $ch in string-to-codepoints($val)    return codepoints-to-string($ch)"/>
      <variable name="checksum"
                select="    (number($digits[8])*2) +    (number($digits[7])*4) +    (number($digits[6])*8) +    (number($digits[5])*16) +    (number($digits[4])*32) +    (number($digits[3])*64) +    (number($digits[2])*128) +    (number($digits[1])*256) "/>
      <value-of select="($checksum  mod 11) mod 10 = number($digits[9])"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkSEOrgnr"
             as="xs:boolean">
      <param name="number" as="xs:string"/>
      <choose>
         <when test="not(matches($number, '^\d+$'))">
            <sequence select="false()"/>
         </when>
         <otherwise>
            <variable name="mainPart" select="substring($number, 1, 9)"/>
            <variable name="checkDigit" select="substring($number, 10, 1)"/>
            <variable name="sum" as="xs:integer">
               <value-of select="sum(       for $pos in 1 to string-length($mainPart) return         if ($pos mod 2 = 1)         then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +           (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10         else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      )"/>
            </variable>
            <variable name="calculatedCheckDigit" select="(10 - $sum mod 10) mod 10"/>
            <sequence select="$calculatedCheckDigit = number($checkDigit)"/>
         </otherwise>
      </choose>
   </function>
   <!--END Functions from PEPPOL-->
   <!--BEGIN Pattern from PEPPOL-->
   <pattern id="peppol-ubl-pattern-1">
      <rule context="//*[not(*) and not(normalize-space())]">
         <assert id="PEPPOL-EN16931-R008" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
      </rule>
   </pattern>
   <pattern id="peppol-ubl-pattern-2">
      <rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
         <assert id="PEPPOL-EN16931-R001" test="cbc:ProfileID" flag="fatal">Business process MUST be provided.</assert>
         <assert id="PEPPOL-EN16931-R053"
                 test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1"
                 flag="fatal">Only one tax total with tax subtotals MUST be provided.</assert>
         <assert id="PEPPOL-EN16931-R054"
                 test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)"
                 flag="fatal">Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</assert>
         <assert id="PEPPOL-EN16931-R055"
                 test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) "
                 flag="fatal">Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</assert>
      </rule>
      <rule context="cbc:TaxCurrencyCode">
         <assert id="PEPPOL-EN16931-R005"
                 test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))"
                 flag="fatal">VAT accounting currency code MUST be different from invoice currency code when provided.</assert>
      </rule>
      <rule context="cac:AccountingCustomerParty/cac:Party">
         <assert id="PEPPOL-EN16931-R010" test="cbc:EndpointID" flag="fatal">Buyer electronic address MUST be provided</assert>
      </rule>
      <rule context="cac:AccountingSupplierParty/cac:Party">
         <assert id="PEPPOL-EN16931-R020" test="cbc:EndpointID" flag="fatal">Seller electronic address MUST be provided</assert>
      </rule>
      <rule context="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
         <assert id="PEPPOL-EN16931-R041" test="false()" flag="fatal">Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</assert>
      </rule>
      <rule context="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
         <assert id="PEPPOL-EN16931-R042" test="false()" flag="fatal">Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</assert>
      </rule>
      <rule context="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge">
         <assert id="PEPPOL-EN16931-R040"
                 test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, $slackValue)"
                 flag="fatal">Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</assert>
         <assert id="PEPPOL-EN16931-R043"
                 test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'"
                 flag="fatal">Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
      </rule>
      <rule context="         cac:PaymentMeans[some $code in tokenize('49 59', '\s')           satisfies normalize-space(cbc:PaymentMeansCode) = $code]">
         <assert id="PEPPOL-EN16931-R061"
                 test="cac:PaymentMandate/cbc:ID"
                 flag="fatal">Mandate reference MUST be provided for direct debit.</assert>
      </rule>
      <rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
         <assert id="PEPPOL-EN16931-R110"
                 test="xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)"
                 flag="fatal">Start date of line period MUST be within invoice period.</assert>
      </rule>
      <rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
         <assert id="PEPPOL-EN16931-R111"
                 test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)"
                 flag="fatal">End date of line period MUST be within invoice period.</assert>
      </rule>
      <rule context="cac:InvoiceLine | cac:CreditNoteLine">
         <let name="lineExtensionAmount"
              value="           if (cbc:LineExtensionAmount) then             xs:decimal(cbc:LineExtensionAmount)           else             0"/>
         <let name="quantity"
              value="           if (/ubl-invoice:Invoice) then             (if (cbc:InvoicedQuantity) then               xs:decimal(cbc:InvoicedQuantity)             else               1)           else             (if (cbc:CreditedQuantity) then               xs:decimal(cbc:CreditedQuantity)             else               1)"/>
         <let name="priceAmount"
              value="           if (cac:Price/cbc:PriceAmount) then             xs:decimal(cac:Price/cbc:PriceAmount)           else             0"/>
         <let name="baseQuantity"
              value="           if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then             xs:decimal(cac:Price/cbc:BaseQuantity)           else             1"/>
         <let name="allowancesTotal"
              value="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
         <let name="chargesTotal"
              value="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
         <assert id="PEPPOL-EN16931-R120"
                 test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, $slackValue)"
                 flag="fatal">Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</assert>
         <assert id="PEPPOL-EN16931-R121"
                 test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0"
                 flag="fatal">Base quantity MUST be a positive number above zero.</assert>
         <assert id="PEPPOL-EN16931-R101"
                 test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))"
                 flag="fatal">Element Document reference can only be used for Invoice line object</assert>
      </rule>
      <rule context="cac:Price/cac:AllowanceCharge">
         <assert id="PEPPOL-EN16931-R044"
                 test="normalize-space(cbc:ChargeIndicator) = 'false'"
                 flag="fatal">Charge on price level is NOT allowed. Only value 'false' allowed.</assert>
         <assert id="PEPPOL-EN16931-R046"
                 test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)"
                 flag="fatal">Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
      </rule>
      <rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
         <let name="hasQuantity"
              value="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity"/>
         <let name="quantity"
              value="           if (/ubl-invoice:Invoice) then             ../../cbc:InvoicedQuantity           else             ../../cbc:CreditedQuantity"/>
         <assert id="PEPPOL-EN16931-R130"
                 test="not($hasQuantity) or @unitCode = $quantity/@unitCode"
                 flag="fatal">Unit code of price base quantity MUST be same as invoiced quantity.</assert>
      </rule>
   </pattern>
   <!--END Pattern from PEPPOL-->
   <pattern id="ubl-pattern">
      <rule context="/ubl:Invoice | /cn:CreditNote">
         <assert test="cac:PaymentMeans" flag="fatal" id="BR-DE-1">[BR-DE-1] Eine Rechnung (INVOICE) muss Angaben zu "PAYMENT INSTRUCTIONS" (BG-16) enthalten.</assert>
         <assert test="cbc:BuyerReference[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-15">[BR-DE-15] Das Element "Buyer reference" (BT-10) muss übermittelt werden.</assert>
         <let name="supportedVATCodes"
              value="('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')"/>
         <let name="BT-31orBT-32Path"
              value="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))]"/>
         <let name="BT-95-UBL-Inv"
              value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and         following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
         <let name="BT-95-UBL-CN"
              value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']"/>
         <let name="BT-102"
              value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']"/>
         <let name="BT-151"
              value="(cac:InvoiceLine | cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
         <!-- If one of BT-95, BT-102, BT-151 is in List of supportedVATCodes then either BG-11=cac:TaxRepresentativeParty or $BT-31orBT-32Path has to exist -->
         <assert test="         (not(           ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or           ($BT-102 = $supportedVATCodes) or           ($BT-151 = $supportedVATCodes)         ) or         (cac:TaxRepresentativeParty, $BT-31orBT-32Path))         "
                 flag="fatal"
                 id="BR-DE-16">[BR-DE-16] Wenn in einer Rechnung die Steuercodes S, Z, E, AE, K, G, L oder M verwendet werden, muss mindestens eines der Elemente "Seller VAT identifier" (BT-31), "Seller tax registration identifier" (BT-32)
        oder "SELLER TAX REPRESENTATIVE PARTY" (BG-11) übermittelt werden.</assert>
         <let name="supportedInvAndCNTypeCodes"
              value="('326', '380', '384', '389', '381', '875', '876', '877')"/>
         <assert test="cbc:InvoiceTypeCode = $supportedInvAndCNTypeCodes         or cbc:CreditNoteTypeCode = $supportedInvAndCNTypeCodes"
                 flag="warning"
                 id="BR-DE-17">[BR-DE-17] Mit dem Element "Invoice type code" (BT-3) sollen ausschließlich folgende Codes aus der Codeliste UNTDID 1001 übermittelt werden: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice) und 381 (Credit note),875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
         <assert test="every $line in             cac:PaymentTerms/cbc:Note[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')]              satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX)                                  and                                 matches( cac:PaymentTerms/cbc:Note[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )"
                 flag="fatal"
                 id="BR-DE-18">[BR-DE-18] Skonto Zeilen in <name/> müssen diesem regulärem Ausdruck entsprechen: <value-of select="$XR-SKONTO-REGEX"/>. Die Informationen zur Gewährung von Skonto müssen wie folgt im Element "Payment terms" (BT-20) übermittelt werden: Anzugeben ist im ersten Segment "SKONTO", im zweiten "TAGE=n", im dritten "PROZENT=n". Prozentzahlen sind ohne Vorzeichen sowie mit Punkt getrennt von zwei Nachkommastellen anzugeben. Liegt dem zu berechnenden Betrag nicht BT-115, "fälliger Betrag" zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung, ist der Grundwert zur Berechnung von Skonto als viertes Segment "BASISBETRAG=n" gemäß dem semantischen Datentypen Amount anzugeben. Jeder Eintrag beginnt mit einer #, die Segmente sind mit einer # getrennt und eine Zeile schließt mit einer # ab. Am Ende einer vollständigen Skontoangabe muss ein XML-konformer Zeilenumbruch folgen. Alle Angaben zur Gewährung von Skonto müssen in Großbuchstaben gemacht werden. Zusätzliches Whitespace (Leerzeichen, Tabulatoren oder Zeilenumbrüche) ist nicht zulässig. Andere Zeichen oder Texte als in den oberen Vorgaben genannt sind nicht zulässig.</assert>
         <assert test="cbc:CustomizationID = $XR-CIUS-ID or                     cbc:CustomizationID = $XR-EXTENSION-ID"
                 flag="warning"
                 id="BR-DE-21">[BR-DE-21] Das Element "Specification identifier" (BT-24) soll syntaktisch der Kennung des Standards XRechnung entsprechen.</assert>
         <assert test="count(cac:AdditionalDocumentReference) =                      count(cac:AdditionalDocumentReference[not(./cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename = preceding-sibling::cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)])"
                 flag="fatal"
                 id="BR-DE-22">[BR-DE-22] Das "filename"-Attribut aller "EmbeddedDocumentBinaryObject"-Elemente muss eindeutig sein</assert>
         <assert test="((not(cbc:InvoiceTypeCode = 384 or cbc:CreditNoteTypeCode = 384) or                     (cac:BillingReference/cac:InvoiceDocumentReference)))"
                 flag="warning"
                 id="BR-DE-26">[BR-DE-26] Wenn im Element "Invoice type code" (BT-3) der Code 384 (Corrected invoice) übergeben wird, soll PRECEDING INVOICE REFERENCE BG-3 mind. einmal vorhanden sein.</assert>
         <assert test="not(cac:PaymentMeans/cac:PaymentMandate)                        or (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='SEPA']                          | cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID='SEPA'])"
                 flag="fatal"
                 id="BR-DE-30">[BR-DE-30] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Bank assigned creditor identifier" BT-90 übermittelt werden.</assert>
         <assert test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)"
                 flag="fatal"
                 id="BR-DE-31">[BR-DE-31] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Debited account identifier" BT-91 übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:AccountingSupplierParty | /cn:CreditNote/cac:AccountingSupplierParty">
         <assert test="cac:Party/cac:Contact" flag="fatal" id="BR-DE-2">[BR-DE-2] Die Gruppe "SELLER CONTACT" (BG-6) muss übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
         <assert test="cbc:CityName[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-3">[BR-DE-3] Das Element "Seller city" (BT-37) muss übermittelt werden.</assert>
         <assert test="cbc:PostalZone[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-4">[BR-DE-4] Das Element "Seller post code" (BT-38) muss übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact">
         <assert test="cbc:Name[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-5">[BR-DE-5] Das Element "Seller contact point" (BT-41) muss übermittelt werden.</assert>
         <assert test="cbc:Telephone[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-6">[BR-DE-6] Das Element "Seller contact telephone number" (BT-42) muss übermittelt werden.</assert>
         <assert test="cbc:ElectronicMail[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-7">[BR-DE-7] Das Element "Seller contact email address" (BT-43) muss übermittelt werden.</assert>
         <assert test="matches(normalize-space(cbc:Telephone), $XR-TELEPHONE-REGEX)"
                 flag="warning"
                 id="BR-DE-27">[BR-DE-27] In BT-42 sollen mindestens drei Ziffern enthalten sein.</assert>
         <assert test="matches(normalize-space(cbc:ElectronicMail), $XR-EMAIL-REGEX)"
                 flag="warning"
                 id="BR-DE-28">[BR-DE-28] In BT-43 soll genau ein @-Zeichen enthalten sein, welches nicht von einem Leerzeichen, einem Punkt, aber mindestens zwei Zeichen auf beiden Seiten flankiert werden soll. Ein Punkt sollte nicht am Anfang oder am Ende stehen.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cbc:CityName[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-8">[BR-DE-8] Das Element "Buyer city" (BT-52) muss übermittelt werden.</assert>
         <assert test="cbc:PostalZone[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-9">[BR-DE-9] Das Element "Buyer post code" (BT-53) muss übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /cn:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address">
         <assert test="cbc:CityName[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-10">[BR-DE-10] Das Element "Deliver to city" (BT-77) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
         <assert test="cbc:PostalZone[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-11">[BR-DE-11] Das Element "Deliver to post code" (BT-78) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)] | /cn:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)]">
      <!-- check for PaymentMeansCode 30 was not added by purpose in 2.1.1. -->
         <assert test="not(cbc:PaymentMeansCode = '58') or                     matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
                 flag="warning"
                 id="BR-DE-19">[BR-DE-19] "Payment account identifier" (BT-84) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 58 SEPA als Zahlungsmittel gefordert wird.</assert>
         <assert test="cac:PayeeFinancialAccount" flag="fatal" id="BR-DE-23-a">[BR-DE-23-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), muss BG-17 "CREDIT TRANSFER" übermittelt werden.</assert>
         <assert test="not(cac:CardAccount) and                     not(cac:PaymentMandate)"
                 flag="fatal"
                 id="BR-DE-23-b">[BR-DE-23-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), dürfen BG-18 und BG-19 nicht übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)] |/cn:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)]">
         <assert test="cac:CardAccount" flag="fatal" id="BR-DE-24-a">[BR-DE-24-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), muss genau BG-18 "PAYMENT CARD INFORMATION" übermittelt werden.</assert>
         <assert test="not(cac:PayeeFinancialAccount) and                     not(cac:PaymentMandate)"
                 flag="fatal"
                 id="BR-DE-24-b">[BR-DE-24-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), dürfen BG-17 und BG-19 nicht übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = 59] | /cn:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = 59]">
         <assert test="not(cbc:PaymentMeansCode = '59') or                     matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
                 flag="warning"
                 id="BR-DE-20">[BR-DE-20] "Debited account identifier" (BT-91) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 59 SEPA als Zahlungsmittel gefordert wird.</assert>
         <assert test="cac:PaymentMandate" flag="fatal" id="BR-DE-25-a">[BR-DE-25-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), muss genau BG-19 "DIRECT DEBIT" übermittelt werden.</assert>
         <assert test="not(cac:PayeeFinancialAccount) and                     not(cac:CardAccount)"
                 flag="fatal"
                 id="BR-DE-25-b">[BR-DE-25-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), dürfen BG-17 und BG-18 nicht übermittelt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal">
         <assert test="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-14">[BR-DE-14] Das Element "VAT category rate" (BT-119) muss übermittelt werden.</assert>
      </rule>
   </pattern>
   <pattern id="ubl-extension-pattern">
      <let name="isExtension"
           value="exists(/ubl:Invoice/cbc:CustomizationID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] | /cn:CreditNote/cbc:CustomizationID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] )"/>
      <rule context="cbc:EmbeddedDocumentBinaryObject[$isExtension]">
         <assert test=".[@mimeCode = 'application/pdf' or         @mimeCode = 'image/png' or         @mimeCode = 'image/jpeg' or         @mimeCode = 'text/csv' or         @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or         @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet' or         @mimeCode = 'application/xml']"
                 id="BR-DEX-01"
                 flag="fatal">[BR-DEX-01] Das Element <name/> "Attached Document" (BT-125) benutzt einen nicht zulässigen MIME-Code: <value-of select="@mimeCode"/>. Im Falle einer Extension darf zusätzlich zu der Liste der mime codes (definiert in Abschnitt 8.2, "Binary Object") der MIME-Code application/xml genutzt werden.</assert>
      </rule>
      <rule context="/ubl:Invoice[$isExtension]">
         <assert test="(every $invoiceline          in /ubl:Invoice/cac:InvoiceLine[ exists (./cac:SubInvoiceLine) ]          satisfies $invoiceline/xs:decimal(cbc:LineExtensionAmount) = sum($invoiceline/cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))) and         (count( //cac:SubInvoiceLine [xs:decimal(cbc:LineExtensionAmount) = sum(child::cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))]) = count(//cac:SubInvoiceLine [count(cac:SubInvoiceLine) &gt; 0]))"
                 flag="warning"
                 id="BR-DEX-02">[BR-DEX-02] Der Wert von "Invoice line net amount" (BT-131) einer "INVOICE LINE"
        (BG-25) oder einer "SUB INVOICE LINE" (BG-DEX-01) soll der Summe
        der "Invoice line net amount" (BT-131) der direkt darunterliegenden "SUB
        INVOICE LINE" (BG-DEX-01) entsprechen.</assert>
         <assert test="not(exists(//cac:SubInvoiceLine/cac:Item[ count ( cac:ClassifiedTaxCategory) != 1]))"
                 flag="fatal"
                 id="BR-DEX-03">[BR-DEX-03] Eine Sub Invoice Line (BG-DEX-01) muss genau eine "SUB INVOICE LINE VAT INFORMATION" (BG-DEX-06) enthalten.</assert>
      </rule>
      <rule context="cac:LegalMonetaryTotal[$isExtension]">
         <let name="prepaidamount"
              value="if (exists(cbc:PrepaidAmount)) then (xs:decimal(cbc:PrepaidAmount)) else (0)"/>
         <let name="payableroundingamount"
              value="if (exists(cbc:PayableRoundingAmount)) then (xs:decimal(cbc:PayableRoundingAmount)) else (0)"/>
         <let name="thirdpartyprepaidamount"
              value="if (exists(../cac:PrepaidPayment/cbc:PaidAmount[boolean(normalize-space(xs:string(.)))])) then (sum(../cac:PrepaidPayment/xs:decimal(cbc:PaidAmount))) else (0)"/>
         <assert test="(round((xs:decimal(cbc:PayableAmount) - $payableroundingamount) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - $prepaidamount + $thirdpartyprepaidamount) * 10 * 10) div 100)"
                 flag="fatal"
                 id="BR-DEX-09">[BR-DEX-09] Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) + Rounding amount (BT-114) - Σ Third party payment amount (BT-DEX-002).</assert>
      </rule>
      <rule context="cac:PartyIdentification/cbc:ID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))"
                 flag="fatal"
                 id="BR-DEX-04">[BR-DEX-04] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-05">[BR-DEX-05] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="cac:StandardItemIdentification/cbc:ID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-06">[BR-DEX-06] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($CEF-EAS-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-07">[BR-DEX-07] Any scheme identifier for an Endpoint Identifier in <name/> MUST belong to the CEF EAS code list. </assert>
      </rule>
      <rule context="cac:DeliveryLocation/cbc:ID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-08">[BR-DEX-08] Any scheme identifier for a Delivery location identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="/ubl:Invoice/cac:PrepaidPayment[$isExtension]">
         <assert test="cbc:ID[boolean(normalize-space(xs:string(.)))]"
                 flag="fatal"
                 id="BR-DEX-10">[BR-DEX-10] Das Element "Third party payment type" BT-DEX-001 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</assert>
         <assert test="cbc:PaidAmount[boolean(normalize-space(xs:string(.)))]"
                 flag="fatal"
                 id="BR-DEX-11">[BR-DEX-11] Das Element "Third party payment amount" BT-DEX-002 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</assert>
         <assert test="cbc:InstructionID[boolean(normalize-space(xs:string(.)))]"
                 flag="fatal"
                 id="BR-DEX-12">[BR-DEX-12] Das Element "Third party payment description" BT-DEX-003 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</assert>
         <assert test="string-length(substring-after(cbc:PaidAmount, '.')) &lt;= 2"
                 flag="fatal"
                 id="BR-DEX-13">[BR-DEX-13] Die maximale Anzahl zulässiger Nachkommastellen für das Element "Third party payment amount" (BT-DEX-002) ist 2.</assert>
         <assert test="cbc:PaidAmount/@currencyID = parent::node()/cbc:DocumentCurrencyCode"
                 flag="fatal"
                 id="BR-DEX-14">[BR-DEX-14] Die Währungsangabe von "Third party payment amount" BT-DEX-002 muss BT-5 ("Invoice currency code") entsprechen.</assert>
      </rule>
   </pattern>
</schema>
