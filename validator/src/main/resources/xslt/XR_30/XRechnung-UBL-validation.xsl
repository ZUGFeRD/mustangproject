<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
               xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
               xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
               xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:u="utils"
               xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
               xmlns:ubl-creditnote="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
               xmlns:ubl-invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
               xmlns:xr="xrechnung"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="2.0">
   <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/"
                    xmlns:dct="http://purl.org/dc/terms/"
                    xmlns:skos="http://www.w3.org/2004/02/skos/core#">
      <dct:creator>
         <dct:Agent>
            <skos:prefLabel>SchXslt/1.10.1 SAXON/HE 12.8</skos:prefLabel>
            <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
         </dct:Agent>
      </dct:creator>
      <dct:created>2026-09-02T11:31:12.927602434Z</dct:created>
   </rdf:Description>
   <xsl:output indent="yes"/>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="xr:checkIBAN"
                 as="xs:boolean">
      <xsl:param name="iban" as="xs:string"/>
      <xsl:variable name="normalizedIban"
                    select="normalize-space(replace($iban, '([\s])', ''))"/>
      <xsl:sequence select="matches($normalizedIban, $XR-IBAN-REGEX) and                           xs:integer(string-join(for $cp in string-to-codepoints(concat(substring($normalizedIban,5),upper-case(substring($normalizedIban,1,2)),substring($normalizedIban,3,2))) return (if($cp &gt; 64) then string($cp - 55) else string($cp - 48)),'')) mod 97 = 1"/>
   </xsl:function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:gln"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <sequence select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:slack"
             as="xs:boolean">
      <param name="exp" as="xs:decimal"/>
      <param name="val" as="xs:decimal"/>
      <param name="slack" as="xs:decimal"/>
      <sequence select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
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
      <sequence select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod97-0208"
             as="xs:boolean">
      <param name="val"/>
      <variable name="checkdigits" select="substring($val,9,2)"/>
      <variable name="calculated_digits"
                select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
      <sequence select="number($checkdigits) = number($calculated_digits)"/>
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
      <sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:TinVerification"
             as="xs:boolean">
      <param name="val" as="xs:string"/>
      <variable name="digits"
                select="    for $ch in string-to-codepoints($val)    return codepoints-to-string($ch)"/>
      <variable name="checksum"
                select="    (number($digits[8])*2) +    (number($digits[7])*4) +    (number($digits[6])*8) +    (number($digits[5])*16) +    (number($digits[4])*32) +    (number($digits[3])*64) +    (number($digits[2])*128) +    (number($digits[1])*256) "/>
      <sequence select="($checksum  mod 11) mod 10 = number($digits[9])"/>
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
               <sequence select="xs:integer(sum(       for $pos in 1 to string-length($mainPart) return        if ($pos mod 2 = 1)        then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +          (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10        else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      ))"/>
            </variable>
            <variable name="calculatedCheckDigit" select="(10 - $sum mod 10) mod 10"/>
            <sequence select="$calculatedCheckDigit = number($checkDigit)"/>
         </otherwise>
      </choose>
   </function>
   <xsl:param name="profile"
              select="        if (normalize-space(/*/cbc:ProfileID) = (         'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0',         'urn:peppol:france:billing:regulated',         'urn:peppol:france:billing:non-regulated'        ))        then '01'        else if (normalize-space(/*/cbc:ProfileID) = 'urn:peppol:bis:billing_with_response')        then '02'        else 'Unknown'      "/>
   <xsl:param name="supplierCountry"
              select="       if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then         upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))       else         if (/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then           upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))         else           if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then             upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))           else             'XX'"/>
   <xsl:param name="customerCountry"
              select="   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))   else   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))   else   'XX'"/>
   <xsl:param name="supplierCountryIsDE"
              select="(upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')"/>
   <xsl:param name="customerCountryIsDE"
              select="(upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')"/>
   <xsl:param name="documentCurrencyCode" select="/*/cbc:DocumentCurrencyCode"/>
   <xsl:param name="slackValue"
              select="if($documentCurrencyCode = 'HUF') then 0.5 else 0.02"/>
   <xsl:param name="isGreekSender"
              select="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
   <xsl:param name="isGreekReceiver"
              select="($customerCountry ='GR') or ($customerCountry ='EL')"/>
   <xsl:param name="isGreekSenderandReceiver"
              select="$isGreekSender and $isGreekReceiver"/>
   <xsl:param name="accountingSupplierCountry"
              select="     if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then     upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))     else     if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then     upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))     else     'XX'"/>
   <xsl:variable name="XR-MAJOR-MINOR-VERSION" select="'3.0'"/>
   <xsl:variable name="CVD-MAJOR-MINOR-VERSION" select="'0.9'"/>
   <xsl:variable name="XR-CIUS-ID"
                 select="concat('urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION )"/>
   <xsl:variable name="XR-EXTENSION-ID"
                 select="concat($XR-CIUS-ID, '#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_' ,$XR-MAJOR-MINOR-VERSION )"/>
   <xsl:variable name="XR-CVD-ID"
                 select="concat($XR-CIUS-ID, '#compliant#urn:xeinkauf.de:kosit:xrechnung:cvd_' , $CVD-MAJOR-MINOR-VERSION )"/>
   <xsl:variable name="XR-SKONTO-REGEX"
                 select="'(^|\r?\n)#(SKONTO)#TAGE=([0-9]+#PROZENT=[0-9]+\.[0-9]{2})(#BASISBETRAG=-?[0-9]+\.[0-9]{2})?#$'"/>
   <xsl:variable name="XR-EMAIL-REGEX" select="'^[^@\s]+@([^@.\s]+\.)+[^@.\s]+$'"/>
   <xsl:variable name="XR-TELEPHONE-REGEX" select="'.*([0-9].*){3,}.*'"/>
   <xsl:variable name="XR-URL-REGEX" select="'^([a-zA-Z])([a-zA-Z0-9+.-])+:.*'"/>
   <xsl:variable name="XR-IBAN-REGEX" select="'^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$'"/>
   <xsl:variable name="DIGA-CODES" select="' XR01 XR02 XR03 '"/>
   <xsl:variable name="ISO-6523-ICD-CODES"
                 select="' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244 0245 0246 0247 0248 '"/>
   <xsl:variable name="ISO-6523-ICD-EXT-CODES"
                 select="concat($DIGA-CODES, $ISO-6523-ICD-CODES)"/>
   <xsl:variable name="CEF-EAS-CODES"
                 select="' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0154 0158 0170 0177 0183 0184 0188 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0218 0219 0220 0221 0225 0230 0235 0240 0244 0242 0245 0246 0248 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 AN AQ AS AU EM '"/>
   <xsl:variable name="CEF-EAS-EXT-CODES" select="concat($DIGA-CODES, $CEF-EAS-CODES)"/>
   <xsl:variable name="CVD-CODE" select="' CVD '"/>
   <xsl:variable name="UNTDID-7143-CODES"
                 select="' AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EMD EN FS GB GN GMN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PPI PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ '"/>
   <xsl:variable name="UNTDID-7143-CVD-CODES"
                 select="concat($CVD-CODE, $UNTDID-7143-CODES)"/>
   <xsl:variable name="CVD-VEHICLE-CATEGORY"
                 select="('M1', 'M2', 'M3', 'N1', 'N2', 'N3')"/>
   <xsl:variable name="CVA-CODES" select="('clean', 'zero-emission', 'other')"/>
   <xsl:variable name="isExtension"
                 select="exists(/ubl:Invoice/cbc:CustomizationID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] | /cn:CreditNote/cbc:CustomizationID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] )"/>
   <xsl:variable name="isCVD"
                 select="(/ubl:Invoice | /cn:CreditNote)/cbc:CustomizationID/text() = $XR-CVD-ID"/>
   <xsl:param name="schxslt.validate.initial-document-uri" as="xs:string?"/>
   <xsl:template name="schxslt.validate">
      <xsl:apply-templates select="document($schxslt.validate.initial-document-uri)"/>
   </xsl:template>
   <xsl:template match="root()">
      <xsl:param name="schxslt.validate.recursive-call"
                 as="xs:boolean"
                 select="false()"/>
      <xsl:choose>
         <xsl:when test="not($schxslt.validate.recursive-call) and (normalize-space($schxslt.validate.initial-document-uri) != '')">
            <xsl:apply-templates select="document($schxslt.validate.initial-document-uri)">
               <xsl:with-param name="schxslt.validate.recursive-call"
                               as="xs:boolean"
                               select="true()"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="metadata" as="element()?">
               <svrl:metadata xmlns:dct="http://purl.org/dc/terms/"
                              xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                              xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <dct:creator>
                     <dct:Agent>
                        <skos:prefLabel>
                           <xsl:value-of separator="/"
                                         select="(system-property('xsl:product-name'), system-property('xsl:product-version'))"/>
                        </skos:prefLabel>
                     </dct:Agent>
                  </dct:creator>
                  <dct:created>
                     <xsl:value-of select="current-dateTime()"/>
                  </dct:created>
                  <dct:source>
                     <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/">
                        <dct:creator>
                           <dct:Agent>
                              <skos:prefLabel>SchXslt/1.10.1 SAXON/HE 12.8</skos:prefLabel>
                              <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
                           </dct:Agent>
                        </dct:creator>
                        <dct:created>2026-09-02T11:31:12.927602434Z</dct:created>
                     </rdf:Description>
                  </dct:source>
               </svrl:metadata>
            </xsl:variable>
            <xsl:variable name="report" as="element(schxslt:report)">
               <schxslt:report>
                  <xsl:call-template name="d13e238"/>
               </schxslt:report>
            </xsl:variable>
            <xsl:variable name="schxslt:report" as="node()*">
               <xsl:sequence select="$metadata"/>
               <xsl:for-each select="$report/schxslt:document">
                  <xsl:for-each select="schxslt:pattern">
                     <xsl:sequence select="node()"/>
                     <xsl:sequence select="../schxslt:rule[@pattern = current()/@id]/node()"/>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:variable>
            <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    title="Schematron Version 2.6.0 - XRechnung 3.0.2 compatible - UBL - Invoice / Creditnote">
               <svrl:ns-prefix-in-attribute-values prefix="cbc"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="cac"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="ext"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="ubl"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="cn"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="ubl-invoice"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="ubl-creditnote"
                                                   uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
               <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
               <svrl:ns-prefix-in-attribute-values prefix="xr" uri="xrechnung"/>
               <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils"/>
               <xsl:sequence select="$schxslt:report"/>
            </svrl:schematron-output>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="/" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template name="d13e238">
      <schxslt:document>
         <schxslt:pattern id="d13e238">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="variable-pattern"
                                    id="variable-pattern">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e298">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="peppol-ubl-pattern-1"
                                    id="peppol-ubl-pattern-1">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e307">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="peppol-ubl-pattern-2"
                                    id="peppol-ubl-pattern-2">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e430">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="ubl-pattern"
                                    id="ubl-pattern">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e600">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="ubl-extension-pattern"
                                    id="ubl-extension-pattern">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e695">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="ubl-cvd-pattern"
                                    id="ubl-cvd-pattern">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="d13e238" select="root()"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="//*[not(*) and not(normalize-space())]"
                 priority="38"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e298']">
            <schxslt:rule pattern="d13e298">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "//*[not(*) and not(normalize-space())]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//*[not(*) and not(normalize-space())]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e298">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//*[not(*) and not(normalize-space())]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(self::cbc:ID[parent::cac:OrderReference])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R008">
                     <xsl:attribute name="test">self::cbc:ID[parent::cac:OrderReference]</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R008]-Document MUST not contain empty elements.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e298')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl-creditnote:CreditNote | ubl-invoice:Invoice"
                 priority="37"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "ubl-creditnote:CreditNote | ubl-invoice:Invoice" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-creditnote:CreditNote | ubl-invoice:Invoice</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-creditnote:CreditNote | ubl-invoice:Invoice</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:ProfileID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R001">
                     <xsl:attribute name="test">cbc:ProfileID</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R001]-Business process MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(count(cac:TaxTotal[cac:TaxSubtotal]) = 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R053">
                     <xsl:attribute name="test">count(cac:TaxTotal[cac:TaxSubtotal]) = 1</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R053]-Only one tax total with tax subtotals MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R054">
                     <xsl:attribute name="test">count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R054]-Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) )">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R055">
                     <xsl:attribute name="test">not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) </xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R055]-Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:TaxCurrencyCode" priority="36" mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:TaxCurrencyCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:TaxCurrencyCode</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text())))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R005">
                     <xsl:attribute name="test">not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R005]-VAT accounting currency code MUST be different from invoice currency code when provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party"
                 priority="35"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:AccountingCustomerParty/cac:Party" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingCustomerParty/cac:Party</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:EndpointID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R010">
                     <xsl:attribute name="test">cbc:EndpointID</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R010]-Buyer electronic address MUST be provided</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party"
                 priority="34"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:AccountingSupplierParty/cac:Party" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:AccountingSupplierParty/cac:Party</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:EndpointID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R020">
                     <xsl:attribute name="test">cbc:EndpointID</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R020]-Seller electronic address MUST be provided</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]"
                 priority="33"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R041">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R041]-Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]"
                 priority="32"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R042">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R042]-Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge"
                 priority="31"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, $slackValue))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R040">
                     <xsl:attribute name="test">not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, $slackValue)</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R040]-Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R043">
                     <xsl:attribute name="test">normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R043]-Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="         cac:PaymentMeans[some $code in tokenize('49 59', '\s')           satisfies normalize-space(cbc:PaymentMeansCode) = $code]"
                 priority="30"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context " cac:PaymentMeans[some $code in tokenize('49 59', '\s') satisfies normalize-space(cbc:PaymentMeansCode) = $code]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">         cac:PaymentMeans[some $code in tokenize('49 59', '\s')           satisfies normalize-space(cbc:PaymentMeansCode) = $code]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">         cac:PaymentMeans[some $code in tokenize('49 59', '\s')           satisfies normalize-space(cbc:PaymentMeansCode) = $code]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cac:PaymentMandate/cbc:ID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R061">
                     <xsl:attribute name="test">cac:PaymentMandate/cbc:ID</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R061]-Mandate reference MUST be provided for direct debit.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate"
                 priority="29"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R110">
                     <xsl:attribute name="test">xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R110]-Start date of line period MUST be within invoice period.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate"
                 priority="28"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R111">
                     <xsl:attribute name="test">xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R111]-End date of line period MUST be within invoice period.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine | cac:CreditNoteLine"
                 priority="27"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="lineExtensionAmount"
                    select="           if (cbc:LineExtensionAmount) then             xs:decimal(cbc:LineExtensionAmount)           else             0"/>
      <xsl:variable name="quantity"
                    select="           if (/ubl-invoice:Invoice) then             (if (cbc:InvoicedQuantity) then               xs:decimal(cbc:InvoicedQuantity)             else               1)           else             (if (cbc:CreditedQuantity) then               xs:decimal(cbc:CreditedQuantity)             else               1)"/>
      <xsl:variable name="priceAmount"
                    select="           if (cac:Price/cbc:PriceAmount) then             xs:decimal(cac:Price/cbc:PriceAmount)           else             0"/>
      <xsl:variable name="baseQuantity"
                    select="           if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then             xs:decimal(cac:Price/cbc:BaseQuantity)           else             1"/>
      <xsl:variable name="allowancesTotal"
                    select="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
      <xsl:variable name="chargesTotal"
                    select="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:InvoiceLine | cac:CreditNoteLine" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine | cac:CreditNoteLine</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:InvoiceLine | cac:CreditNoteLine</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, $slackValue))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="PEPPOL-EN16931-R120">
                     <xsl:attribute name="test">u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, $slackValue)</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R120]-Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R121">
                     <xsl:attribute name="test">not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R121]-Base quantity MUST be a positive number above zero.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130')))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R101">
                     <xsl:attribute name="test">(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R101]-Element Document reference can only be used for Invoice line object</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:Price/cac:AllowanceCharge" priority="26" mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:Price/cac:AllowanceCharge" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:Price/cac:AllowanceCharge</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:Price/cac:AllowanceCharge</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(normalize-space(cbc:ChargeIndicator) = 'false')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R044">
                     <xsl:attribute name="test">normalize-space(cbc:ChargeIndicator) = 'false'</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R044]-Charge on price level is NOT allowed. Only value 'false' allowed.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R046">
                     <xsl:attribute name="test">not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R046]-Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:Price/cbc:BaseQuantity[@unitCode]"
                 priority="25"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="hasQuantity"
                    select="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity"/>
      <xsl:variable name="quantity"
                    select="           if (/ubl-invoice:Invoice) then             ../../cbc:InvoicedQuantity           else             ../../cbc:CreditedQuantity"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e307']">
            <schxslt:rule pattern="d13e307">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:Price/cbc:BaseQuantity[@unitCode]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:Price/cbc:BaseQuantity[@unitCode]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e307">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:Price/cbc:BaseQuantity[@unitCode]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not($hasQuantity) or @unitCode = $quantity/@unitCode)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="PEPPOL-EN16931-R130">
                     <xsl:attribute name="test">not($hasQuantity) or @unitCode = $quantity/@unitCode</xsl:attribute>
                     <svrl:text>[PEPPOL-EN16931-R130]-Unit code of price base quantity MUST be same as invoiced quantity.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e307')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice | /cn:CreditNote" priority="24" mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="supportedVATCodes"
                    select="('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')"/>
      <xsl:variable name="BT-31orBT-32Path"
                    select="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))]"/>
      <xsl:variable name="BT-95-UBL-Inv"
                    select="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and         following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
      <xsl:variable name="BT-95-UBL-CN"
                    select="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']"/>
      <xsl:variable name="BT-102"
                    select="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']"/>
      <xsl:variable name="BT-151"
                    select="(cac:InvoiceLine | cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
      <xsl:variable name="supportedInvAndCNTypeCodes"
                    select="('326', '380', '384', '389', '381', '875', '876', '877')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice | /cn:CreditNote" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice | /cn:CreditNote</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cac:PaymentMeans)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-1">
                     <xsl:attribute name="test">cac:PaymentMeans</xsl:attribute>
                     <svrl:text>[BR-DE-1] Eine Rechnung (INVOICE) muss Angaben zu "PAYMENT INSTRUCTIONS" (BG-16) enthalten.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:BuyerReference[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-15">
                     <xsl:attribute name="test">cbc:BuyerReference[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-15] Das Element "Buyer reference" (BT-10) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(         (not(           ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or           ($BT-102 = $supportedVATCodes) or           ($BT-151 = $supportedVATCodes)         ) or         (cac:TaxRepresentativeParty, $BT-31orBT-32Path))         )">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-16">
                     <xsl:attribute name="test">         (not(           ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or           ($BT-102 = $supportedVATCodes) or           ($BT-151 = $supportedVATCodes)         ) or         (cac:TaxRepresentativeParty, $BT-31orBT-32Path))         </xsl:attribute>
                     <svrl:text>[BR-DE-16] Wenn in einer Rechnung die Steuercodes S, Z, E, AE, K, G, L oder M verwendet werden, muss mindestens eines der Elemente "Seller VAT identifier" (BT-31), "Seller tax registration identifier" (BT-32)
        oder "SELLER TAX REPRESENTATIVE PARTY" (BG-11) übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(normalize-space(cbc:InvoiceTypeCode) = $supportedInvAndCNTypeCodes         or normalize-space(cbc:CreditNoteTypeCode) = $supportedInvAndCNTypeCodes)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-17">
                     <xsl:attribute name="test">normalize-space(cbc:InvoiceTypeCode) = $supportedInvAndCNTypeCodes         or normalize-space(cbc:CreditNoteTypeCode) = $supportedInvAndCNTypeCodes</xsl:attribute>
                     <svrl:text>[BR-DE-17] Mit dem Element "Invoice type code" (BT-3) sollen ausschließlich folgende Codes aus der Codeliste UNTDID 1001 übermittelt werden: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice) und 381 (Credit note),875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $line in             cac:PaymentTerms/cbc:Note[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')]              satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX)                                  and                                 matches( cac:PaymentTerms/cbc:Note[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-18">
                     <xsl:attribute name="test">every $line in             cac:PaymentTerms/cbc:Note[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')]              satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX)                                  and                                 matches( cac:PaymentTerms/cbc:Note[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )</xsl:attribute>
                     <svrl:text>[BR-DE-18] Skonto Zeilen in <xsl:value-of select="name()"/> müssen diesem regulärem Ausdruck entsprechen: <xsl:value-of select="$XR-SKONTO-REGEX"/>. Die Informationen zur Gewährung von Skonto müssen wie folgt im Element "Payment terms" (BT-20) übermittelt werden: Anzugeben ist im ersten Segment "SKONTO", im zweiten "TAGE=n", im dritten "PROZENT=n". Prozentzahlen sind ohne Vorzeichen sowie mit Punkt getrennt von zwei Nachkommastellen anzugeben. Liegt dem zu berechnenden Betrag nicht BT-115, "fälliger Betrag" zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung, ist der Grundwert zur Berechnung von Skonto als viertes Segment "BASISBETRAG=n" gemäß dem semantischen Datentypen Amount anzugeben. Jeder Eintrag beginnt mit einer #, die Segmente sind mit einer # getrennt und eine Zeile schließt mit einer # ab. Am Ende einer vollständigen Skontoangabe muss ein XML-konformer Zeilenumbruch folgen. Alle Angaben zur Gewährung von Skonto müssen in Großbuchstaben gemacht werden. Zusätzliches Whitespace (Leerzeichen, Tabulatoren oder Zeilenumbrüche) ist nicht zulässig. Andere Zeichen oder Texte als in den oberen Vorgaben genannt sind nicht zulässig.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:CustomizationID = $XR-CIUS-ID or                     cbc:CustomizationID = $XR-EXTENSION-ID or                     cbc:CustomizationID = $XR-CVD-ID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-21">
                     <xsl:attribute name="test">cbc:CustomizationID = $XR-CIUS-ID or                     cbc:CustomizationID = $XR-EXTENSION-ID or                     cbc:CustomizationID = $XR-CVD-ID</xsl:attribute>
                     <svrl:text>[BR-DE-21] Das Element "Specification identifier" (BT-24) soll syntaktisch der Kennung des Standards XRechnung entsprechen.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(count(cac:AdditionalDocumentReference) =                      count(cac:AdditionalDocumentReference[not(./cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename = preceding-sibling::cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)]))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-22">
                     <xsl:attribute name="test">count(cac:AdditionalDocumentReference) =                      count(cac:AdditionalDocumentReference[not(./cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename = preceding-sibling::cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)])</xsl:attribute>
                     <svrl:text>[BR-DE-22] Das "filename"-Attribut aller "EmbeddedDocumentBinaryObject"-Elemente muss eindeutig sein</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(((not(normalize-space(cbc:InvoiceTypeCode) = '384' or normalize-space(cbc:CreditNoteTypeCode) = '384') or                     (cac:BillingReference/cac:InvoiceDocumentReference))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-26">
                     <xsl:attribute name="test">((not(normalize-space(cbc:InvoiceTypeCode) = '384' or normalize-space(cbc:CreditNoteTypeCode) = '384') or                     (cac:BillingReference/cac:InvoiceDocumentReference)))</xsl:attribute>
                     <svrl:text>[BR-DE-26] Wenn im Element "Invoice type code" (BT-3) der Code 384 (Corrected invoice) übergeben wird, soll PRECEDING INVOICE REFERENCE BG-3 mind. einmal vorhanden sein.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:PaymentMeans/cac:PaymentMandate)                        or (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='SEPA']                          | cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID='SEPA']))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-30">
                     <xsl:attribute name="test">not(cac:PaymentMeans/cac:PaymentMandate)                        or (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='SEPA']                          | cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID='SEPA'])</xsl:attribute>
                     <svrl:text>[BR-DE-30] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Bank assigned creditor identifier" BT-90 übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-31">
                     <xsl:attribute name="test">not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)</xsl:attribute>
                     <svrl:text>[BR-DE-31] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Debited account identifier" BT-91 übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:Delivery/cbc:ActualDeliveryDate         or cac:InvoicePeriod         or (every $line in (cac:InvoiceLine | cac:CreditNoteLine) satisfies $line/cac:InvoicePeriod))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="information"
                                      id="BR-DE-TMP-32">
                     <xsl:attribute name="test">cac:Delivery/cbc:ActualDeliveryDate         or cac:InvoicePeriod         or (every $line in (cac:InvoiceLine | cac:CreditNoteLine) satisfies $line/cac:InvoicePeriod)</xsl:attribute>
                     <svrl:text>
        [BR-DE-TMP-32] Eine Rechnung sollte zur Angabe des Liefer-/Leistungsdatums entweder BT-72 "Actual delivery date", BG-14 "Invoicing period" oder in jeder Rechnungsposition BG-26 "Invoice line period" enthalten.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference | /cn:CreditNote/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"
                 priority="23"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference | /cn:CreditNote/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference | /cn:CreditNote/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference | /cn:CreditNote/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(matches(cbc:URI, $XR-URL-REGEX))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-TMP-2">
                     <xsl:attribute name="test">matches(cbc:URI, $XR-URL-REGEX)</xsl:attribute>
                     <svrl:text>[BR-TMP-2] BT-124 "External document location" muss eine absolute URL mit gültigem Schema enthalten.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate |        cbc:IssueDate | cbc:TaxPointDate | cbc:PaymentDueDate"
                 priority="22"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:IssueDate | cbc:DueDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate | cbc:IssueDate | cbc:TaxPointDate | cbc:PaymentDueDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate | cbc:DueDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate |        cbc:IssueDate | cbc:TaxPointDate | cbc:PaymentDueDate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate | cbc:DueDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate |        cbc:IssueDate | cbc:TaxPointDate | cbc:PaymentDueDate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(matches(normalize-space(text()), '^\d{4}-\d{2}-\d{2}$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-TMP-6">
                     <xsl:attribute name="test">matches(normalize-space(text()), '^\d{4}-\d{2}-\d{2}$')</xsl:attribute>
                     <svrl:text>[BR-TMP-6] Datumsangaben in UBL müssen im Format JJJJ-MM-TT (YYYY-MM-DD) übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty | /cn:CreditNote/cac:AccountingSupplierParty"
                 priority="21"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:AccountingSupplierParty | /cn:CreditNote/cac:AccountingSupplierParty" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty | /cn:CreditNote/cac:AccountingSupplierParty</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty | /cn:CreditNote/cac:AccountingSupplierParty</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cac:Party/cac:Contact)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-2">
                     <xsl:attribute name="test">cac:Party/cac:Contact</xsl:attribute>
                     <svrl:text>[BR-DE-2] Die Gruppe "SELLER CONTACT" (BG-6) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress"
                 priority="20"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:CityName[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-3">
                     <xsl:attribute name="test">cbc:CityName[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-3] Das Element "Seller city" (BT-37) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:PostalZone[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-4">
                     <xsl:attribute name="test">cbc:PostalZone[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-4] Das Element "Seller post code" (BT-38) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact"
                 priority="19"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:Name[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-5">
                     <xsl:attribute name="test">cbc:Name[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-5] Das Element "Seller contact point" (BT-41) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:Telephone[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-6">
                     <xsl:attribute name="test">cbc:Telephone[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-6] Das Element "Seller contact telephone number" (BT-42) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:ElectronicMail[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-7">
                     <xsl:attribute name="test">cbc:ElectronicMail[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-7] Das Element "Seller contact email address" (BT-43) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(matches(normalize-space(cbc:Telephone), $XR-TELEPHONE-REGEX))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-27">
                     <xsl:attribute name="test">matches(normalize-space(cbc:Telephone), $XR-TELEPHONE-REGEX)</xsl:attribute>
                     <svrl:text>[BR-DE-27] In BT-42 sollen mindestens drei Ziffern enthalten sein.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(matches(normalize-space(cbc:ElectronicMail), $XR-EMAIL-REGEX))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-28">
                     <xsl:attribute name="test">matches(normalize-space(cbc:ElectronicMail), $XR-EMAIL-REGEX)</xsl:attribute>
                     <svrl:text>[BR-DE-28] In BT-43 soll genau ein @-Zeichen enthalten sein, welches nicht von einem Leerzeichen, einem Punkt, aber mindestens zwei Zeichen auf beiden Seiten flankiert werden soll. Ein Punkt sollte nicht am Anfang oder am Ende stehen.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress"
                 priority="18"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:CityName[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-8">
                     <xsl:attribute name="test">cbc:CityName[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-8] Das Element "Buyer city" (BT-52) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:PostalZone[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-9">
                     <xsl:attribute name="test">cbc:PostalZone[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-9] Das Element "Buyer post code" (BT-53) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /cn:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address"
                 priority="17"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /cn:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /cn:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /cn:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:CityName[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-10">
                     <xsl:attribute name="test">cbc:CityName[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-10] Das Element "Deliver to city" (BT-77) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:PostalZone[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-11">
                     <xsl:attribute name="test">cbc:PostalZone[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-11] Das Element "Deliver to post code" (BT-78) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')]"
                 priority="16"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not(normalize-space(cbc:PaymentMeansCode) = '58') or                     xr:checkIBAN(string(cac:PayeeFinancialAccount/cbc:ID)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-19">
                     <xsl:attribute name="test">not(normalize-space(cbc:PaymentMeansCode) = '58') or                     xr:checkIBAN(string(cac:PayeeFinancialAccount/cbc:ID))</xsl:attribute>
                     <svrl:text>[BR-DE-19] "Payment account identifier" (BT-84) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 58 SEPA als Zahlungsmittel gefordert wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:PayeeFinancialAccount)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-23-a">
                     <xsl:attribute name="test">cac:PayeeFinancialAccount</xsl:attribute>
                     <svrl:text>[BR-DE-23-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), muss BG-17 "CREDIT TRANSFER" übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:CardAccount) and                     not(cac:PaymentMandate))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-23-b">
                     <xsl:attribute name="test">not(cac:CardAccount) and                     not(cac:PaymentMandate)</xsl:attribute>
                     <svrl:text>[BR-DE-23-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), dürfen BG-18 und BG-19 nicht übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')] |/cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')]"
                 priority="15"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')] |/cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')] |/cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')] |/cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cac:CardAccount)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-24-a">
                     <xsl:attribute name="test">cac:CardAccount</xsl:attribute>
                     <svrl:text>[BR-DE-24-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), muss genau BG-18 "PAYMENT CARD INFORMATION" übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:PayeeFinancialAccount) and                     not(cac:PaymentMandate))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-24-b">
                     <xsl:attribute name="test">not(cac:PayeeFinancialAccount) and                     not(cac:PaymentMandate)</xsl:attribute>
                     <svrl:text>[BR-DE-24-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), dürfen BG-17 und BG-19 nicht übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59'] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59']"
                 priority="14"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59'] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59'] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59'] | /cn:CreditNote/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not(normalize-space(cbc:PaymentMeansCode) = '59') or                     xr:checkIBAN(string(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DE-20">
                     <xsl:attribute name="test">not(normalize-space(cbc:PaymentMeansCode) = '59') or                     xr:checkIBAN(string(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID))</xsl:attribute>
                     <svrl:text>[BR-DE-20] "Debited account identifier" (BT-91) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 59 SEPA als Zahlungsmittel gefordert wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:PaymentMandate)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-25-a">
                     <xsl:attribute name="test">cac:PaymentMandate</xsl:attribute>
                     <svrl:text>[BR-DE-25-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), muss genau BG-19 "DIRECT DEBIT" übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:PayeeFinancialAccount) and                     not(cac:CardAccount))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-25-b">
                     <xsl:attribute name="test">not(cac:PayeeFinancialAccount) and                     not(cac:CardAccount)</xsl:attribute>
                     <svrl:text>[BR-DE-25-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), dürfen BG-17 und BG-18 nicht übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal"
                 priority="13"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e430']">
            <schxslt:rule pattern="d13e430">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e430">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-14">
                     <xsl:attribute name="test">cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>[BR-DE-14] Das Element "VAT category rate" (BT-119) muss übermittelt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e430')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EmbeddedDocumentBinaryObject[$isExtension]"
                 priority="12"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EmbeddedDocumentBinaryObject[$isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EmbeddedDocumentBinaryObject[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EmbeddedDocumentBinaryObject[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(.[@mimeCode = 'application/pdf' or         @mimeCode = 'image/png' or         @mimeCode = 'image/jpeg' or         @mimeCode = 'text/csv' or         @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or         @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet' or         @mimeCode = 'application/xml'])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-01">
                     <xsl:attribute name="test">.[@mimeCode = 'application/pdf' or         @mimeCode = 'image/png' or         @mimeCode = 'image/jpeg' or         @mimeCode = 'text/csv' or         @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or         @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet' or         @mimeCode = 'application/xml']</xsl:attribute>
                     <svrl:text>[BR-DEX-01] Das Element <xsl:value-of select="name()"/> "Attached Document" (BT-125) benutzt einen nicht zulässigen MIME-Code: <xsl:value-of select="@mimeCode"/>. Im Falle einer Extension darf zusätzlich zu der Liste der mime codes (definiert in Abschnitt 8.2, "Binary Object") der MIME-Code application/xml genutzt werden.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice[$isExtension]" priority="11" mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice[$isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not((every $invoiceline          in /ubl:Invoice/cac:InvoiceLine[ exists (./cac:SubInvoiceLine) ]          satisfies $invoiceline/xs:decimal(cbc:LineExtensionAmount) = sum($invoiceline/cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))) and         (count( //cac:SubInvoiceLine [count(cac:SubInvoiceLine) &gt; 0 and xs:decimal(cbc:LineExtensionAmount) = sum(cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))]) = count(//cac:SubInvoiceLine [count(cac:SubInvoiceLine) &gt; 0])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="warning"
                                      id="BR-DEX-02">
                     <xsl:attribute name="test">(every $invoiceline          in /ubl:Invoice/cac:InvoiceLine[ exists (./cac:SubInvoiceLine) ]          satisfies $invoiceline/xs:decimal(cbc:LineExtensionAmount) = sum($invoiceline/cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))) and         (count( //cac:SubInvoiceLine [count(cac:SubInvoiceLine) &gt; 0 and xs:decimal(cbc:LineExtensionAmount) = sum(cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))]) = count(//cac:SubInvoiceLine [count(cac:SubInvoiceLine) &gt; 0]))</xsl:attribute>
                     <svrl:text>[BR-DEX-02] Der Wert von "Invoice line net amount" (BT-131) einer "INVOICE LINE"
        (BG-25) oder einer "SUB INVOICE LINE" (BG-DEX-01) soll der Summe
        der "Invoice line net amount" (BT-131) der direkt darunterliegenden "SUB
        INVOICE LINE" (BG-DEX-01) entsprechen.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(exists(//cac:SubInvoiceLine/cac:Item[ count ( cac:ClassifiedTaxCategory) != 1])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-03">
                     <xsl:attribute name="test">not(exists(//cac:SubInvoiceLine/cac:Item[ count ( cac:ClassifiedTaxCategory) != 1]))</xsl:attribute>
                     <svrl:text>[BR-DEX-03] Eine Sub Invoice Line (BG-DEX-01) muss genau eine "SUB INVOICE LINE VAT INFORMATION" (BG-DEX-06) enthalten.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:LegalMonetaryTotal[$isExtension]"
                 priority="10"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="prepaidamount"
                    select="if (exists(cbc:PrepaidAmount)) then (xs:decimal(cbc:PrepaidAmount)) else (0)"/>
      <xsl:variable name="payableroundingamount"
                    select="if (exists(cbc:PayableRoundingAmount)) then (xs:decimal(cbc:PayableRoundingAmount)) else (0)"/>
      <xsl:variable name="thirdpartyprepaidamount"
                    select="if (exists(../cac:PrepaidPayment/cbc:PaidAmount[boolean(normalize-space(xs:string(.)))])) then (sum(../cac:PrepaidPayment/xs:decimal(cbc:PaidAmount))) else (0)"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:LegalMonetaryTotal[$isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:LegalMonetaryTotal[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:LegalMonetaryTotal[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not((round((xs:decimal(cbc:PayableAmount) - $payableroundingamount) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - $prepaidamount + $thirdpartyprepaidamount) * 10 * 10) div 100))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-09">
                     <xsl:attribute name="test">(round((xs:decimal(cbc:PayableAmount) - $payableroundingamount) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - $prepaidamount + $thirdpartyprepaidamount) * 10 * 10) div 100)</xsl:attribute>
                     <svrl:text>[BR-DEX-09] Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) + Rounding amount (BT-114) + Σ Third party payment amount (BT-DEX-002).</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:PartyIdentification/cbc:ID[@schemeID and $isExtension]"
                 priority="9"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:PartyIdentification/cbc:ID[@schemeID and $isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PartyIdentification/cbc:ID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PartyIdentification/cbc:ID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-04">
                     <xsl:attribute name="test">((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))</xsl:attribute>
                     <svrl:text>[BR-DEX-04] Any scheme identifier in <xsl:value-of select="name()"/> MUST be coded using one of the ISO 6523 ICD list. </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity/cbc:CompanyID[@schemeID and $isExtension]"
                 priority="8"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:PartyLegalEntity/cbc:CompanyID[@schemeID and $isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PartyLegalEntity/cbc:CompanyID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:PartyLegalEntity/cbc:CompanyID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-05">
                     <xsl:attribute name="test">((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))</xsl:attribute>
                     <svrl:text>[BR-DEX-05] Any scheme identifier in <xsl:value-of select="name()"/> MUST be coded using one of the ISO 6523 ICD list. </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:StandardItemIdentification/cbc:ID[@schemeID and $isExtension]"
                 priority="7"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:StandardItemIdentification/cbc:ID[@schemeID and $isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:StandardItemIdentification/cbc:ID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:StandardItemIdentification/cbc:ID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-06">
                     <xsl:attribute name="test">((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))</xsl:attribute>
                     <svrl:text>[BR-DEX-06] Any scheme identifier in <xsl:value-of select="name()"/> MUST be coded using one of the ISO 6523 ICD list. </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID and $isExtension]"
                 priority="6"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID and $isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@schemeID), ' ')) and contains($CEF-EAS-EXT-CODES, concat(' ', normalize-space(@schemeID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-07">
                     <xsl:attribute name="test">((not(contains(normalize-space(@schemeID), ' ')) and contains($CEF-EAS-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))</xsl:attribute>
                     <svrl:text>[BR-DEX-07] Any scheme identifier for an Endpoint Identifier in <xsl:value-of select="name()"/> MUST belong to the CEF EAS code list. </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cac:DeliveryLocation/cbc:ID[@schemeID and $isExtension]"
                 priority="5"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cac:DeliveryLocation/cbc:ID[@schemeID and $isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:DeliveryLocation/cbc:ID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cac:DeliveryLocation/cbc:ID[@schemeID and $isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-08">
                     <xsl:attribute name="test">((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))</xsl:attribute>
                     <svrl:text>[BR-DEX-08] Any scheme identifier for a Delivery location identifier in <xsl:value-of select="name()"/> MUST be coded using one of the ISO 6523 ICD list. </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:Invoice/cac:PrepaidPayment[$isExtension]"
                 priority="4"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e600']">
            <schxslt:rule pattern="d13e600">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:Invoice/cac:PrepaidPayment[$isExtension]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PrepaidPayment[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e600">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:Invoice/cac:PrepaidPayment[$isExtension]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:ID[boolean(normalize-space(xs:string(.)))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-10">
                     <xsl:attribute name="test">cbc:ID[boolean(normalize-space(xs:string(.)))]</xsl:attribute>
                     <svrl:text>[BR-DEX-10] Das Element "Third party payment type" BT-DEX-001 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:PaidAmount[boolean(normalize-space(xs:string(.)))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-11">
                     <xsl:attribute name="test">cbc:PaidAmount[boolean(normalize-space(xs:string(.)))]</xsl:attribute>
                     <svrl:text>[BR-DEX-11] Das Element "Third party payment amount" BT-DEX-002 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:InstructionID[boolean(normalize-space(xs:string(.)))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-12">
                     <xsl:attribute name="test">cbc:InstructionID[boolean(normalize-space(xs:string(.)))]</xsl:attribute>
                     <svrl:text>[BR-DEX-12] Das Element "Third party payment description" BT-DEX-003 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(string-length(substring-after(cbc:PaidAmount, '.')) &lt;= 2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-13">
                     <xsl:attribute name="test">string-length(substring-after(cbc:PaidAmount, '.')) &lt;= 2</xsl:attribute>
                     <svrl:text>[BR-DEX-13] Die maximale Anzahl zulässiger Nachkommastellen für das Element "Third party payment amount" (BT-DEX-002) ist 2.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:PaidAmount/@currencyID = parent::node()/cbc:DocumentCurrencyCode)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DEX-14">
                     <xsl:attribute name="test">cbc:PaidAmount/@currencyID = parent::node()/cbc:DocumentCurrencyCode</xsl:attribute>
                     <svrl:text>[BR-DEX-14] Die Währungsangabe von "Third party payment amount" BT-DEX-002 muss BT-5 ("Invoice currency code") entsprechen.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e600')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="(/ubl:Invoice | /cn:CreditNote)[$isCVD]"
                 priority="3"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e695']">
            <schxslt:rule pattern="d13e695">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "(/ubl:Invoice | /cn:CreditNote)[$isCVD]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice | /cn:CreditNote)[$isCVD]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e695">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice | /cn:CreditNote)[$isCVD]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(cac:OriginatorDocumentReference/cbc:ID[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-02">
                     <xsl:attribute name="test">cac:OriginatorDocumentReference/cbc:ID[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-02] Das Element <xsl:value-of select="name()"/> "Tender or lot reference" (BT-17) muss übermittelt werden.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:ContractDocumentReference/cbc:ID[boolean(normalize-space(.))])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-01">
                     <xsl:attribute name="test">cac:ContractDocumentReference/cbc:ID[boolean(normalize-space(.))]</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-01] Das Element <xsl:value-of select="name()"/> "Contract reference" (BT-12) muss übermittelt werden.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((cac:InvoiceLine/cac:Item | cac:CreditNoteLine/cac:Item)[cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'CVD'         and         cac:AdditionalItemProperty/cbc:Name = 'cva'])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-03">
                     <xsl:attribute name="test">(cac:InvoiceLine/cac:Item | cac:CreditNoteLine/cac:Item)[cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'CVD'         and         cac:AdditionalItemProperty/cbc:Name = 'cva']</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-03] In einer Rechnung muss mindestens eine <xsl:value-of select="name()"/> INVOICE LINE (BG-25) enthalten sein, in der der Scheme identifier von <xsl:value-of select="name()"/> "Item classification identifier" (BT-158) den Wert 'CVD' und der <xsl:value-of select="name()"/> "Item attribute name" (BT-160) den Wert 'cva' enthält.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e695')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item"
                 priority="2"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e695']">
            <schxslt:rule pattern="d13e695">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e695">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not(cac:CommodityClassification/cbc:ItemClassificationCode[@listID = 'CVD']) or count(cac:AdditionalItemProperty[cbc:Name = 'cva']) = 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-06-a">
                     <xsl:attribute name="test">not(cac:CommodityClassification/cbc:ItemClassificationCode[@listID = 'CVD']) or count(cac:AdditionalItemProperty[cbc:Name = 'cva']) = 1</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-06-a] Wenn der Scheme identifier von <xsl:value-of select="name()"/> "Item classification identifier" (BT-158) mit dem Wert 'CVD' angegeben ist, muss in derselben Rechnungszeile genau ein <xsl:value-of select="name()"/> "Item attribute name" (BT-160) mit dem Wert 'cva' vorhanden sein.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cac:AdditionalItemProperty[cbc:Name = 'cva']) or count(cac:CommodityClassification/cbc:ItemClassificationCode[@listID = 'CVD']) = 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-06-b">
                     <xsl:attribute name="test">not(cac:AdditionalItemProperty[cbc:Name = 'cva']) or count(cac:CommodityClassification/cbc:ItemClassificationCode[@listID = 'CVD']) = 1</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-06-b] Wenn <xsl:value-of select="name()"/> "Item attribute name" (BT-160) mit dem Wert 'cva' angegeben ist, muss in derselben Rechnungszeile genau ein <xsl:value-of select="name()"/> "Item classification identifier" (BT-158) mit dem Scheme identifier 'CVD' vorhanden sein.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e695')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"
                 priority="1"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e695']">
            <schxslt:rule pattern="d13e695">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e695">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(((not(contains(normalize-space(@listID), ' ')) and contains($UNTDID-7143-CVD-CODES, concat(' ', normalize-space(@listID), ' ')))))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-TMP-CVD-01">
                     <xsl:attribute name="test">((not(contains(normalize-space(@listID), ' ')) and contains($UNTDID-7143-CVD-CODES, concat(' ', normalize-space(@listID), ' '))))</xsl:attribute>
                     <svrl:text>
        [BR-TMP-CVD-01] Das Bildungsschema für <xsl:value-of select="name()"/> "Item classification identifier" (BT-158) ist aus der Codeliste UNTDID 7143 zu wählen.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(normalize-space(@listID) = 'CVD') or normalize-space(.) = $CVD-VEHICLE-CATEGORY)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-04">
                     <xsl:attribute name="test">not(normalize-space(@listID) = 'CVD') or normalize-space(.) = $CVD-VEHICLE-CATEGORY</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-04] Ein <xsl:value-of select="name()"/> "Item classification identifier" (BT-158) mit dem Scheme identifier 'CVD' muss einen Wert aus der Liste der zulässigen Fahrzeugkategorien enthalten.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e695')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty[cbc:Name = 'cva']"
                 priority="0"
                 mode="d13e238">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e695']">
            <schxslt:rule pattern="d13e695">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty[cbc:Name = 'cva']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty[cbc:Name = 'cva']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e695">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(/ubl:Invoice[$isCVD]/cac:InvoiceLine | /cn:CreditNote[$isCVD]/cac:CreditNoteLine)/cac:Item/cac:AdditionalItemProperty[cbc:Name = 'cva']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(normalize-space(cbc:Value) = $CVA-CODES)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      flag="fatal"
                                      id="BR-DE-CVD-05">
                     <xsl:attribute name="test">normalize-space(cbc:Value) = $CVA-CODES</xsl:attribute>
                     <svrl:text>
        [BR-DE-CVD-05] Wenn innerhalb von <xsl:value-of select="name()"/> ITEM ATTRIBUTES (BG-32) der <xsl:value-of select="name()"/> "Item attribute name" (BT-160) den Wert 'cva' hat, muss der <xsl:value-of select="name()"/> "Item attribute value" (BT-161) einen der zulässigen Werte enthalten.
      </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd13e695')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:function name="schxslt:location" as="xs:string">
      <xsl:param name="node" as="node()"/>
      <xsl:variable name="segments" as="xs:string*">
         <xsl:for-each select="($node/ancestor-or-self::node())">
            <xsl:variable name="position">
               <xsl:number level="single"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test=". instance of element()">
                  <xsl:value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of attribute()">
                  <xsl:value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))"/>
               </xsl:when>
               <xsl:when test=". instance of processing-instruction()">
                  <xsl:value-of select="concat('processing-instruction(&#34;', name(.), '&#34;)[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of comment()">
                  <xsl:value-of select="concat('comment()[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of text()">
                  <xsl:value-of select="concat('text()[', $position, ']')"/>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="concat('/', string-join($segments, '/'))"/>
   </xsl:function>
</xsl:transform>
