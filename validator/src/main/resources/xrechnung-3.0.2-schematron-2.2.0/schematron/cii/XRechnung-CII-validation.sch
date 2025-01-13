<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
        xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
        xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
        xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
        xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:u="utils"
        queryBinding="xslt2">
   <title>Schematron Version @xr-schematron.version.full@ - XRechnung @xrechnung.version@ compatible - CII</title>
   <ns prefix="rsm"
       uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"/>
   <ns prefix="ccts"
       uri="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"/>
   <ns prefix="udt"
       uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>
   <ns prefix="qdt"
       uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"/>
   <ns prefix="ram"
       uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
   <ns uri="utils" prefix="u"/>
   <!--BEGIN Parameters from PEPPOL-->
   <let name="profile"
        value="             if (/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter and matches(normalize-space(/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')) then                 tokenize(normalize-space(/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID), ':')[7]             else                 'Unknown'"/>
   <let name="supplierCountry"
        value="             if (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction[1]/ram:ApplicableHeaderTradeAgreement[1]/ram:SellerTradeParty[1]/ram:SpecifiedTaxRegistration[ram:ID/@schemeID = 'VAT']/substring(ram:ID, 1, 2)) then                 upper-case(normalize-space(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction[1]/ram:ApplicableHeaderTradeAgreement[1]/ram:SellerTradeParty[1]/ram:SpecifiedTaxRegistration[ram:ID/@schemeID = 'VAT']/substring(ram:ID, 1, 2)))             else                 if (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID = 'VAT']/substring(ram:ID, 1, 2)) then                     upper-case(normalize-space(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID = 'VAT']/substring(ram:ID, 1, 2)))                 else                     if (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID) then                         upper-case(normalize-space(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID))                     else                         'XX'"/>
   <let name="documentCurrencyCode"
        value="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
   <let name="slackValue"
        value="if($documentCurrencyCode = 'HUF') then 0.5 else 0.02"/>
   <let name="taxCurrencyCode"
        value="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode"/>
   <!--END Parameters from PEPPOL-->
   <xsl:function as="xs:decimal" name="u:decimalOrZero">
      <xsl:param name="element"/>
      <xsl:value-of select="if (boolean($element)) then xs:decimal($element) else 0"/>
   </xsl:function>
   <phase id="xrechnung-model">
      <active pattern="variable-pattern"/>
      <active pattern="cii-pattern"/>
      <active pattern="cii-extension-pattern"/>
      <active pattern="peppol-cii-pattern-0-a"/>
      <active pattern="peppol-cii-pattern-0-b"/>
      <active pattern="peppol-cii-pattern-1"/>
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
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )   then   (    if ((string-length($arg) = 16))    then    (     if (u:checkCF16($arg))     then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()     )   )   else   (    false()   )   "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF16"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and       (substring($arg,7,2) castable as xs:integer) and       (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and       (substring($arg,10,2) castable as xs:integer) and       (substring($arg,12,3) castable as xs:string) and       (substring($arg,15,1) castable as xs:integer) and       (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )     then true()     else false()     "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVAseIT"
             as="xs:boolean">
      <param name="arg" as="xs:string"/>
      <variable name="paese" select="substring($arg,1,2)"/>
      <variable name="codice" select="substring($arg,3)"/>
      <sequence select="     if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then     (      true()     )     else     (      false()     )    )    else    (     true()    )    "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xs:integer))      then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:addPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string"/>
      <param name="pari" as="xs:integer"/>
      <variable name="tappo"
                select="if (not($arg castable as xs:integer)) then 0 else 1"/>
      <variable name="mapper"
                select="if ($tappo = 0) then 0 else                   ( if ($pari = 1)                    then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                    else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
      <param name="val"/>
      <value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
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
   <pattern id="peppol-cii-pattern-1">
      <rule context="rsm:ExchangedDocumentContext">
         <assert id="PEPPOL-EN16931-R001"
                 test="ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"
                 flag="fatal">Business process MUST be provided.</assert>
      </rule>
      <rule context="ram:ApplicableHeaderTradeSettlement">
         <assert id="PEPPOL-EN16931-R005"
                 test="not(ram:TaxCurrencyCode) or normalize-space(ram:TaxCurrencyCode/text()) != normalize-space(ram:InvoiceCurrencyCode/text())"
                 flag="fatal">VAT accounting currency code MUST be different from invoice currency code when provided.</assert>
         <assert id="PEPPOL-EN16931-R053"
                 test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = $documentCurrencyCode]) &lt;=1"
                 flag="fatal">No more than one tax total amount must be provided where currency id equals document currency code.</assert>
         <assert id="PEPPOL-EN16931-R054"
                 test="                     count(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID != $documentCurrencyCode]) = (if (ram:TaxCurrencyCode) then                         1                     else                         0)"
                 flag="fatal">Only one tax total amount must be provided where currency id equals tax currency code, if tax currency code (BT-6) is provided.</assert>
         <assert id="PEPPOL-EN16931-R055"
                 test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = $documentCurrencyCode]) or (ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = $taxCurrencyCode] &lt; 0 and ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = $documentCurrencyCode] &lt; 0) or (ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = $taxCurrencyCode] &gt;= 0 and ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = $documentCurrencyCode] &gt;= 0)"
                 flag="fatal">Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</assert>
      </rule>
      <rule context="ram:BuyerTradeParty">
         <assert id="PEPPOL-EN16931-R010"
                 test="ram:URIUniversalCommunication/ram:URIID"
                 flag="fatal">Buyer electronic address MUST be provided</assert>
      </rule>
      <rule context="ram:SellerTradeParty">
         <assert id="PEPPOL-EN16931-R020"
                 test="ram:URIUniversalCommunication/ram:URIID"
                 flag="fatal">Seller electronic address MUST be provided</assert>
      </rule>
      <rule context="ram:SpecifiedTradeAllowanceCharge[ram:CalculationPercent and not(ram:BasisAmount)]">
         <assert id="PEPPOL-EN16931-R041" test="false()" flag="fatal">Allowance/charge base
                amount MUST be provided when allowance/charge percentage is provided.</assert>
      </rule>
      <rule context="ram:SpecifiedTradeAllowanceCharge[not(ram:CalculationPercent) and ram:BasisAmount]">
         <assert id="PEPPOL-EN16931-R042" test="false()" flag="fatal">Allowance/charge percentage
                MUST be provided when allowance/charge base amount is provided.</assert>
      </rule>
      <rule context="ram:SpecifiedTradeAllowanceCharge">
         <assert id="PEPPOL-EN16931-R040"
                 test="not(ram:CalculationPercent and ram:BasisAmount) or u:slack(if (ram:ActualAmount) then ram:ActualAmount else 0, (xs:decimal(ram:BasisAmount) * xs:decimal(ram:CalculationPercent)) div 100, $slackValue)"
                 flag="fatal">Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</assert>
         <assert id="PEPPOL-EN16931-R043-1"
                 test="normalize-space(ram:ChargeIndicator/udt:Indicator/text()) = 'true' or normalize-space(ram:ChargeIndicator/udt:Indicator/text()) = 'false'"
                 flag="fatal">Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
      </rule>
      <rule context="ram:AppliedTradeAllowanceCharge">
         <assert id="PEPPOL-EN16931-R043-2"
                 test="normalize-space(ram:ChargeIndicator/udt:Indicator/text()) = 'true' or normalize-space(ram:ChargeIndicator/udt:Indicator/text()) = 'false'"
                 flag="fatal">Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
      </rule>
      <rule context="                 ram:SpecifiedTradeSettlementPaymentMeans[some $code in tokenize('49 59', '\s')                     satisfies normalize-space(ram:TypeCode) = $code]">
         <assert id="PEPPOL-EN16931-R061"
                 test="../ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID"
                 flag="fatal">Mandate reference MUST be provided for direct debit.</assert>
      </rule>
      <rule context="rsm:SupplyChainTradeTransaction[ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime]/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime">
         <assert id="PEPPOL-EN16931-R110"
                 test="udt:DateTimeString &gt;= ../../../../ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 flag="fatal">Start date of line period MUST be within invoice period.</assert>
      </rule>
      <rule context="rsm:SupplyChainTradeTransaction[ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime]/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime">
         <assert id="PEPPOL-EN16931-R111"
                 test="udt:DateTimeString &lt;= ../../../../ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 flag="fatal">End date of line period MUST be within invoice period.</assert>
      </rule>
      <rule context="ram:IncludedSupplyChainTradeLineItem">
         <let name="lineExtensionAmount"
              value="                     if (ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) then                         xs:decimal(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)                     else                         0"/>
         <let name="quantity"
              value="                     if (ram:SpecifiedLineTradeDelivery/ram:BilledQuantity) then                         xs:decimal(ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)                     else                         1"/>
         <let name="priceAmount"
              value="                     if (ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount) then                         xs:decimal(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)                     else                         0"/>
         <let name="baseQuantity"
              value="                     if (ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity and xs:decimal(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity) != 0) then                         xs:decimal(ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity)                     else                         1"/>
         <let name="allowancesTotal"
              value="                     if (ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[normalize-space(ram:ChargeIndicator/udt:Indicator) = 'false']) then                         round(sum(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[normalize-space(ram:ChargeIndicator/udt:Indicator) = 'false']/ram:ActualAmount/xs:decimal(.)) * 10 * 10) div 100                     else                         0"/>
         <let name="chargesTotal"
              value="                     if (ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[normalize-space(ram:ChargeIndicator/udt:Indicator) = 'true']) then                         round(sum(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[normalize-space(ram:ChargeIndicator/udt:Indicator) = 'true']/ram:ActualAmount/xs:decimal(.)) * 10 * 10) div 100                     else                         0"/>
         <assert id="PEPPOL-EN16931-R101"
                 test="(not(ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument) or (ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:TypeCode='130'))"
                 flag="fatal">Element Additional referenced document can only be used for Invoice line object.</assert>
      </rule>
      <rule context="ram:NetPriceProductTradePrice | ram:GrossPriceProductTradePrice">
         <assert id="PEPPOL-EN16931-R121"
                 test="not(ram:BasisQuantity) or xs:decimal(ram:BasisQuantity) &gt; 0"
                 flag="fatal">Base quantity MUST be a positive number above zero.</assert>
      </rule>
      <rule context="ram:NetPriceProductTradePrice/ram:BasisQuantity[@unitCode] | ram:GrossPriceProductTradePrice/ram:BasisQuantity[@unitCode]">
         <assert id="PEPPOL-EN16931-R130"
                 test="@unitCode = ../../../ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode"
                 flag="fatal">Unit code of price base quantity MUST be same as invoiced quantity.</assert>
      </rule>
   </pattern>
   <pattern id="peppol-cii-pattern-0-a">
      <rule context="//*[not(name() = 'ram:ApplicableHeaderTradeDelivery') and not(*) and not(normalize-space())]">
         <assert id="PEPPOL-EN16931-R008" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
      </rule>
   </pattern>
   <pattern id="peppol-cii-pattern-0-b">
      <rule context="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice">
         <assert id="PEPPOL-EN16931-R044"
                 test="not(ram:AppliedTradeAllowanceCharge/ram:ActualAmount) or ram:AppliedTradeAllowanceCharge/ram:ChargeIndicator/udt:Indicator = 'false'"
                 flag="fatal">Charge on price level is NOT allowed. Only value 'false' allowed.</assert>
         <assert id="PEPPOL-EN16931-R046"
                 test="not(ram:ChargeAmount) or xs:decimal(../ram:NetPriceProductTradePrice/ram:ChargeAmount) = xs:decimal(ram:ChargeAmount) - u:decimalOrZero(ram:AppliedTradeAllowanceCharge/ram:ActualAmount)"
                 flag="fatal">Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
      </rule>
   </pattern>
   <!--END Pattern from PEPPOL-->
   <pattern id="cii-pattern">
      <rule context="/rsm:CrossIndustryInvoice">

        <!-- Only if BG-19 exists, rules BR-DE-30 and BR-DE-31 should fail on missing elements BT-90 or BT-91.
            Because there is no specific (sub-)element for BG-19 in CII, are making use of the semantic definition that BG-19 has three mandatory elements and,
            accordingly, either all of the three BTs must exist or none. -->
         <let name="BT-89-path"
              value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID"/>
         <let name="BT-90-path"
              value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID"/>
         <let name="BT-91-path"
              value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID"/>
         <let name="BG-19-not-existing"
              value="not(exists(($BT-89-path, $BT-90-path, $BT-91-path)))"/>
         <assert test="(($BT-89-path or $BT-91-path) and $BT-90-path) or $BG-19-not-existing"
                 flag="fatal"
                 id="BR-DE-30">[BR-DE-30] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Bank assigned creditor identifier" BT-90 übermittelt werden.</assert>
         <assert test="(($BT-89-path or $BT-90-path) and $BT-91-path) or $BG-19-not-existing"
                 flag="fatal"
                 id="BR-DE-31">[BR-DE-31] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Debited account identifier" BT-91 übermittelt werden.</assert>
         <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans"
                 flag="fatal"
                 id="BR-DE-1">[BR-DE-1] Eine Rechnung (INVOICE) muss Angaben zu "PAYMENT INSTRUCTIONS" (BG-16) enthalten.</assert>
         <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-15">[BR-DE-15] Das Element "Buyer reference" (BT-10) muss übermittelt werden.</assert>
         <assert test="not((rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode = 'VAT' and                          rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or                         (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax = 'VAT' and                          rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or                         (rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode = 'VAT' and                          rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or                     ((rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA' or                                                                                                                                                   @schemeID='FC'][boolean(normalize-space(.))], rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty))"
                 flag="fatal"
                 id="BR-DE-16">[BR-DE-16] Wenn in einer Rechnung die Steuercodes S, Z, E, AE, K, G, L oder M verwendet werden, muss mindestens eines der Elemente "Seller VAT identifier" (BT-31), "Seller tax registration identifier" (BT-32)
          oder "SELLER TAX REPRESENTATIVE PARTY" (BG-11) übermittelt werden.
      </assert>
         <assert test="rsm:ExchangedDocument/ram:TypeCode = ('326', '380', '384', '389', '381', '875', '876', '877')"
                 flag="warning"
                 id="BR-DE-17">[BR-DE-17] Mit dem Element "Invoice type code" (BT-3) sollen ausschließlich folgende Codes aus der Codeliste UNTDID 1001 übermittelt werden: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice) und 381 (Credit note),875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
         <assert test="every $line                        in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')]                        satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX ) and                     matches( rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )"
                 flag="fatal"
                 id="BR-DE-18">[BR-DE-18] Skonto Zeilen in <name/> muessen diesem regulärem Ausdruck entsprechen: <value-of select="$XR-SKONTO-REGEX"/>. Die Informationen zur Gewährung von Skonto müssen wie folgt im Element "Payment terms" (BT-20) übermittelt werden: Anzugeben ist im ersten Segment "SKONTO", im zweiten "TAGE=n", im dritten "PROZENT=n". Prozentzahlen sind ohne Vorzeichen sowie mit Punkt getrennt von zwei Nachkommastellen anzugeben. Liegt dem zu berechnenden Betrag nicht BT-115, "fälliger Betrag" zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung, ist der Grundwert zur Berechnung von Skonto als viertes Segment "BASISBETRAG=n" gemäß dem semantischen Datentypen Amount anzugeben. Jeder Eintrag beginnt mit einer #, die Segmente sind mit einer # getrennt und eine Zeile schließt mit einer # ab. Am Ende einer vollständigen Skontoangabe muss ein XML-konformer Zeilenumbruch folgen. Alle Angaben zur Gewährung von Skonto müssen in Großbuchstaben gemacht werden. Zusätzliches Whitespace (Leerzeichen, Tabulatoren oder Zeilenumbrüche) ist nicht zulässig. Andere Zeichen oder Texte als in den oberen Vorgaben genannt sind nicht zulässig.</assert>
         <assert test="count(//ram:AdditionalReferencedDocument) = count(//ram:AdditionalReferencedDocument[not(./ram:AttachmentBinaryObject/@filename = preceding-sibling::ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject/@filename)])"
                 flag="fatal"
                 id="BR-DE-22">[BR-DE-22] Not all filename attributes of the embeddedDocumentBinaryObject elements are unique</assert>
         <assert test="not(rsm:ExchangedDocument/ram:TypeCode = 384) or                     (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument)"
                 flag="warning"
                 id="BR-DE-26">[BR-DE-26] Wenn im Element Invoice type code (BT-3) der Code 384 (Corrected invoice) übergeben wird, soll PRECEDING INVOICE REFERENCE BG-3 mind. einmal vorhanden sein.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
         <assert test="ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = $XR-CIUS-ID or                     ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = $XR-EXTENSION-ID"
                 flag="warning"
                 id="BR-DE-21">[BR-DE-21] Das Element "Specification identifier" (BT-24) soll syntaktisch der Kennung des Standards XRechnung entsprechen.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
         <assert test="ram:DefinedTradeContact" flag="fatal" id="BR-DE-2">[BR-DE-2] Die Gruppe "SELLER CONTACT" (BG-6) muss übermittelt werden.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
         <assert test="ram:CityName[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-3">[BR-DE-3] Das Element "Seller city" (BT-37) muss übermittelt werden.</assert>
         <assert test="ram:PostcodeCode[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-4">[BR-DE-4] Das Element "Seller post code" (BT-38) muss übermittelt werden.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact">
         <assert test="(ram:PersonName,ram:DepartmentName)[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-5">[BR-DE-5] Das Element "Seller contact point" (BT-41) muss übermittelt werden.</assert>
         <assert test="ram:TelephoneUniversalCommunication/ram:CompleteNumber[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-6">[BR-DE-6] Das Element "Seller contact telephone number" (BT-42) muss übermittelt werden.</assert>
         <assert test="ram:EmailURIUniversalCommunication/ram:URIID[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-7">[BR-DE-7] Das Element "Seller contact email address" (BT-43) muss übermittelt werden.</assert>
         <assert test="matches(normalize-space(ram:TelephoneUniversalCommunication/ram:CompleteNumber), $XR-TELEPHONE-REGEX)"
                 flag="warning"
                 id="BR-DE-27">[BR-DE-27] In BT-42 sollen mindestens drei Ziffern enthalten sein.</assert>
         <assert test="matches(normalize-space(ram:EmailURIUniversalCommunication/ram:URIID), $XR-EMAIL-REGEX)"
                 flag="warning"
                 id="BR-DE-28">[BR-DE-28] In BT-43 soll genau ein @-Zeichen enthalten sein, welches nicht von einem Leerzeichen, einem Punkt, aber mindestens zwei Zeichen auf beiden Seiten flankiert werden soll. Ein Punkt sollte nicht am Anfang oder am Ende stehen.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
         <assert test="ram:CityName[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-8">[BR-DE-8] Das Element "Buyer city" (BT-52) muss übermittelt werden.</assert>
         <assert test="ram:PostcodeCode[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-9">[BR-DE-9] Das Element "Buyer post code" (BT-53) muss übermittelt werden.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
         <assert test="ram:CityName[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-10">[BR-DE-10] Das Element "Deliver to city" (BT-77) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
         <assert test="ram:PostcodeCode[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-11">[BR-DE-11] Das Element "Deliver to post code" (BT-78) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode = (30,58)]">
         <assert test="not(ram:TypeCode = '58') or                     matches(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
                 flag="warning"
                 id="BR-DE-19">[BR-DE-19] "Payment account identifier" (BT-84) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 58 SEPA als Zahlungsmittel gefordert wird.</assert>
         <assert test="ram:PayeePartyCreditorFinancialAccount"
                 flag="fatal"
                 id="BR-DE-23-a">[BR-DE-23-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), muss BG-17 "CREDIT TRANSFER" übermittelt werden.</assert>
         <assert test="not(ram:ApplicableTradeSettlementFinancialCard) and                     not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID or                         /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID or                         ram:PayerPartyDebtorFinancialAccount/ram:IBANID)"
                 flag="fatal"
                 id="BR-DE-23-b">[BR-DE-23-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), dürfen BG-18 und BG-19 nicht übermittelt werden.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode = (48,54,55)]">
         <assert test="ram:ApplicableTradeSettlementFinancialCard"
                 flag="fatal"
                 id="BR-DE-24-a">[BR-DE-24-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), muss genau BG-18 "PAYMENT CARD INFORMATION" übermittelt werden.</assert>
         <assert test="not(ram:PayeePartyCreditorFinancialAccount) and                     not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID or                         /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID or                         ram:PayerPartyDebtorFinancialAccount/ram:IBANID)"
                 flag="fatal"
                 id="BR-DE-24-b">[BR-DE-24-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), dürfen BG-17 und BG-19 nicht übermittelt werden.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode = 59]">
         <assert test="not(ram:TypeCode = '59') or                     matches(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
                 flag="warning"
                 id="BR-DE-20">[BR-DE-20] "Debited account identifier" (BT-91) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 59 SEPA als Zahlungsmittel gefordert wird.</assert>
         <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID or                     /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID or                     ram:PayerPartyDebtorFinancialAccount/ram:IBANID"
                 flag="fatal"
                 id="BR-DE-25-a">[BR-DE-25-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), muss genau BG-19 "DIRECT DEBIT" übermittelt werden.</assert>
         <assert test="not(ram:PayeePartyCreditorFinancialAccount) and                     not(ram:ApplicableTradeSettlementFinancialCard)"
                 flag="fatal"
                 id="BR-DE-25-b">[BR-DE-25-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), dürfen BG-17 und BG-18 nicht übermittelt werden.</assert>
      </rule>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
         <assert test="ram:RateApplicablePercent[boolean(normalize-space(.))]"
                 flag="fatal"
                 id="BR-DE-14">[BR-DE-14] Das Element "VAT category rate" (BT-119) muss übermittelt werden.</assert>
      </rule>
   </pattern>
   <pattern id="cii-extension-pattern">
      <let name="isExtension"
           value="exists(/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] )"/>
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument[$isExtension]">
         <assert test="not(exists(//ram:ParentLineID))"
                 flag="warning"
                 id="BR-DEX-15">
              [BR-DEX-15] This CII file might use the concept of Sub Invoice Lines. However XRechnung does not support this.
          </assert>
      </rule>
      <rule context="//ram:GlobalID[@schemeID and $isExtension][not(ancestor::ram:SpecifiedTradeProduct) and not(ancestor::ram:ShipToTradeParty)]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-04">[BR-DEX-04] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="ram:ID[@schemeID and $isExtension][not(ancestor::ram:SpecifiedTaxRegistration)]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-05">[BR-DEX-05] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="ram:SpecifiedTradeProduct/ram:GlobalID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-06">[BR-DEX-06] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="ram:URIUniversalCommunication/ram:URIID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($CEF-EAS-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-07">[BR-DEX-07] Any scheme identifier for an Endpoint Identifier in <name/> MUST belong to the CEF EAS code list. </assert>
      </rule>
      <rule context="ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeID and $isExtension]">
         <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
                 flag="fatal"
                 id="BR-DEX-08">[BR-DEX-08] Any scheme identifier for a Delivery location identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="ram:AttachmentBinaryObject[$isExtension]">
         <assert test=".[@mimeCode = 'application/pdf' or               @mimeCode = 'image/png' or               @mimeCode = 'image/jpeg' or               @mimeCode = 'text/csv' or               @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or               @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet' or               @mimeCode = 'application/xml']"
                 id="BR-DEX-01"
                 flag="fatal">[BR-DEX-01] Das Element <name/> "Attached Document" (BT-125) benutzt einen nicht zulässigen MIME-Code: <value-of select="@mimeCode"/>. Im Falle einer Extension darf zusätzlich zu der Liste der mime codes (definiert in Abschnitt 8.2, "Binary Object") der MIME-Code application/xml genutzt werden.</assert>
      </rule>
   </pattern>
</schema>
