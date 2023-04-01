<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
        xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
        xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
        xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
        xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
        queryBinding="xslt2"
        defaultPhase="xrechnung-model">
  <title>Schematron Version 1.8.0 - XRechnung 2.3.1 compatible - CII</title>
  <ns prefix="rsm"  uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
  <ns prefix="ccts" uri="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" />
  <ns prefix="udt"  uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
  <ns prefix="qdt"  uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
  <ns prefix="ram"  uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />

  <phase id="xrechnung-model">
    <active pattern="variable-pattern" />
    <active pattern="cii-pattern" />
    <active pattern="cii-extension-pattern" />
  </phase>

<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="variable-pattern">
    <!-- This pattern solely serves for declaring global variables (in XSLT speak) -->

    <let name="XR-MAJOR-MINOR-VERSION" value="'2.3'"/>
    <let name="XR-CIUS-ID" value="concat('urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_', $XR-MAJOR-MINOR-VERSION )"/>
    <let name="XR-EXTENSION-ID" value="concat($XR-CIUS-ID, '#conformant#urn:xoev-de:kosit:extension:xrechnung_' ,$XR-MAJOR-MINOR-VERSION )"/>
    <let name="XR-SKONTO-REGEX"  value="'#(SKONTO|VERZUG)#TAGE=([0-9]+#PROZENT=[0-9]+\.[0-9]{2})(#BASISBETRAG=-?[0-9]+\.[0-9]{2})?#$'" />
    <!--
    <let name="XR-EMAIL-REGEX"  value="'^[0-9a-zA-Z]([0-9a-zA-Z\.]*)[^\.\s@]@[^\.\s@]([0-9a-zA-Z\.]*)[0-9a-zA-Z]$'" />
     -->
    <let name="XR-EMAIL-REGEX"  value="'^[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+(\.[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+)*@([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$'" />

    <let name="XR-TELEPHONE-REGEX"  value="'.*([0-9].*){3,}.*'" />
    <let name="BT-81" value="'rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode'"/>
    <let name="DIGA-CODES" value="' XR01 XR02 XR03 '" />
    <!-- ISO 6523 and EAS Codelists including XR01 XR02 XR03 (applicable to extension only) -->
    <let name="ISO-6523-ICD-CODES" value="' 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 '" />
    <let name="ISO-6523-ICD-EXT-CODES" value="concat($DIGA-CODES, $ISO-6523-ICD-CODES)"/>

    <let name="CEF-EAS-CODES" value="' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0218 0219 0220 9901 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957 9959 AN AQ AS AU EM '" />
    <let name="CEF-EAS-EXT-CODES" value="concat($DIGA-CODES, $CEF-EAS-CODES)" />

</pattern>

  <pattern id="cii-pattern">
    <rule context="/rsm:CrossIndustryInvoice">

        <!-- Only if BG-19 exists, rules BR-DE-29, BR-DE-30 and BR-DE-31 should fail on missing elements BT-89, BT-90 or BT-91.
            Because there is no specific (sub-)element for BG-19 in CII, are making use of the semantic definition that BG-19 has three mandatory elements and,
            accordingly, either all of the three BTs must exist or none. -->
        <let name="BT-89-path" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID"/>
        <let name="BT-90-path" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID"/>
        <let name="BT-91-path" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID"/>
        <let name="BG-19-not-existing" value="not(exists(($BT-89-path, $BT-90-path, $BT-91-path)))" />
        <assert test="(($BT-90-path or $BT-91-path) and $BT-89-path) or $BG-19-not-existing"
              flag="fatal"
              id="BR-DE-29">[BR-DE-29] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Mandate reference identifier" BT-89 übermittelt werden.</assert>
        <assert test="(($BT-89-path or $BT-91-path) and $BT-90-path) or $BG-19-not-existing"
              flag="fatal"
              id="BR-DE-30"
        >[BR-DE-30] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Bank assigned creditor identifier" BT-90 übermittelt werden.</assert>
        <assert test="(($BT-89-path or $BT-90-path) and $BT-91-path) or $BG-19-not-existing"
              flag="fatal"
              id="BR-DE-31"
        >[BR-DE-31] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Debited account identifier" BT-91 übermittelt werden.</assert>
<assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans"
              flag="fatal"
              id="BR-DE-1"
          >[BR-DE-1] Eine Rechnung (INVOICE) muss Angaben zu "PAYMENT INSTRUCTIONS" (BG-16) enthalten.</assert>
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-15"
          >[BR-DE-15] Das Element "Buyer reference" (BT-10) muss übermittelt werden.</assert>
      <assert test="not((rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode = 'VAT' and
                         rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or
                        (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax = 'VAT' and
                         rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or
                        (rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode = 'VAT' and
                         rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or
                    ((rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA' or
                                                                                                                                                  @schemeID='VAT' or
                                                                                                                                                  @schemeID='FC'][boolean(normalize-space(.))], rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty))"
              flag="fatal"
              id="BR-DE-16"
          >[BR-DE-16] In der Rechnung muss mindestens eines der Elemente "Seller VAT identifier" (BT-31), "Seller tax registration identifier" (BT-32) oder "SELLER TAX REPRESENTATIVE PARTY" (BG-11) übermittelt werden.</assert>
      <assert test="rsm:ExchangedDocument/ram:TypeCode = ('326', '380', '384', '389', '381', '875', '876', '877')"
              flag="warning"
              id="BR-DE-17"
          >[BR-DE-17] Mit dem Element "Invoice type code" (BT-3) sollen ausschließlich folgende Codes aus der Codeliste UNTDID 1001 übermittelt werden: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice) und 381 (Credit note),875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
      <assert test="every $line 
                      in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')] 
                      satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX ) and
                    matches( rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )"                    
              flag="fatal"
              id="BR-DE-18"
          >[BR-DE-18] Skonto/Verzug Zeilen in <name/> muessen diesem regulärem Ausdruck entsprechen: <value-of select="$XR-SKONTO-REGEX"/>. Die Informationen zur Gewährung von Skonto oder zur Berechnung von Verzugszinsen müssen wie folgt im Element "Payment terms" (BT-20) übermittelt werden: Anzugeben ist im ersten Segment "SKONTO" oder "VERZUG", im zweiten "TAGE=n", im dritten "PROZENT=n". Prozentzahlen sind ohne Vorzeichen sowie mit Punkt getrennt von zwei Nachkommastellen anzugeben. Liegt dem zu berechnenden Betrag nicht BT-115, "fälliger Betrag" zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung, ist der Grundwert zur Berechnung von Skonto oder Verzugszins als viertes Segment "BASISBETRAG=n" gemäß dem semantischen Datentypen Amount anzugeben. Jeder Eintrag beginnt mit einer #, die Segmente sind mit einer # getrennt und eine Zeile schließt mit einer # ab. Am Ende einer vollständigen Skonto oder Verzugsangabe muss ein XML-konformer Zeilenumbruch folgen. Alle Angaben zur Gewährung von Skonto oder zur Berechnung von Verzugszinsen müssen in Großbuchstaben gemacht werden. Zusätzliches Whitespace (Leerzeichen, Tabulatoren oder Zeilenumbrüche) ist nicht zulässig. Andere Zeichen oder Texte als in den oberen Vorgaben genannt sind nicht zulässig.</assert>
      
      <assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms[count(ram:Description) &lt; 2]" 
              flag="fatal" 
              id="BR-DE-18-a"
              >[BR-DE-18-a] BT-20 darf nicht mehrfach vorhanden sein.</assert>

      <assert test="count(//ram:AdditionalReferencedDocument) = count(//ram:AdditionalReferencedDocument[not(./ram:AttachmentBinaryObject/@filename = preceding-sibling::ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject/@filename)])"
              flag="fatal"
              id="BR-DE-22"
          >[BR-DE-22] Not all filename attributes of the embeddedDocumentBinaryObject elements are unique</assert>
      <assert test="not(rsm:ExchangedDocument/ram:TypeCode = 384) or
                    (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument)"
              flag="warning"
              id="BR-DE-26"
          >[BR-DE-26] Wenn im Element Invoice type code (BT-3) der Code 384 (Corrected invoice) übergeben wird, soll PRECEDING INVOICE REFERENCE BG-3 mind. einmal vorhanden sein.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <assert test="ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = $XR-CIUS-ID or
                    ram:GuidelineSpecifiedDocumentContextParameter/ram:ID = $XR-EXTENSION-ID"
              flag="warning"
              id="BR-DE-21"
          >[BR-DE-21] Das Element "Specification identifier" (BT-24) soll syntaktisch der Kennung des Standards XRechnung entsprechen.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert test="ram:DefinedTradeContact"
              flag="fatal"
              id="BR-DE-2"
          >[BR-DE-2] Die Gruppe "SELLER CONTACT" (BG-6) muss übermittelt werden.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert test="ram:CityName[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-3"
          >[BR-DE-3] Das Element "Seller city" (BT-37) muss übermittelt werden.</assert>
      <assert test="ram:PostcodeCode[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-4"
          >[BR-DE-4] Das Element "Seller post code" (BT-38) muss übermittelt werden.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact">
      <assert test="(ram:PersonName,ram:DepartmentName)[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-5"
          >[BR-DE-5] Das Element "Seller contact point" (BT-41) muss übermittelt werden.</assert>
      <assert test="ram:TelephoneUniversalCommunication/ram:CompleteNumber[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-6"
          >[BR-DE-6] Das Element "Seller contact telephone number" (BT-42) muss übermittelt werden.</assert>
      <assert test="ram:EmailURIUniversalCommunication/ram:URIID[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-7"
          >[BR-DE-7] Das Element "Seller contact email address" (BT-43) muss übermittelt werden.</assert>
      <assert test="matches(normalize-space(ram:TelephoneUniversalCommunication/ram:CompleteNumber), $XR-TELEPHONE-REGEX)"
        flag="warning"
        id="BR-DE-27"
        >[BR-DE-27] In BT-42 sollen mindestens drei Ziffern enthalten sein.</assert>
      <assert test="matches(normalize-space(ram:EmailURIUniversalCommunication/ram:URIID), $XR-EMAIL-REGEX)"
        flag="warning"
        id="BR-DE-28"
        >[BR-DE-28] In BT-43 soll genau ein @-Zeichen enthalten sein, welches nicht von einem Leerzeichen, einem Punkt, aber mindestens zwei Zeichen auf beiden Seiten flankiert werden soll. Ein Punkt sollte nicht am Anfang oder am Ende stehen.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <assert test="ram:CityName[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-8"
          >[BR-DE-8] Das Element "Buyer city" (BT-52) muss übermittelt werden.</assert>
      <assert test="ram:PostcodeCode[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-9"
          >[BR-DE-9] Das Element "Buyer post code" (BT-53) muss übermittelt werden.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert test="ram:CityName[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-10"
          >[BR-DE-10] Das Element "Deliver to city" (BT-77) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
      <assert test="ram:PostcodeCode[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-11"
          >[BR-DE-11] Das Element "Deliver to post code" (BT-78) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
    </rule>
    
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode = (30,58)]">
      <assert test="not(ram:TypeCode = '58') or
                    matches(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and
                    xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then $cp - 55 else  $cp - 48),'')) mod 97 = 1"
              flag="warning"
              id="BR-DE-19"
        >[BR-DE-19] "Payment account identifier" (BT-84) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 58 SEPA als Zahlungsmittel gefordert wird.</assert>
      <assert test="ram:PayeePartyCreditorFinancialAccount"
              flag="fatal"
              id="BR-DE-23-a"
        >[BR-DE-23-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), muss BG-17 "CREDIT TRANSFER" übermittelt werden.</assert>
      <assert test="not(ram:ApplicableTradeSettlementFinancialCard) and
                    not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID or
                        /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID or
                        ram:PayerPartyDebtorFinancialAccount/ram:IBANID)"
              flag="fatal"
              id="BR-DE-23-b"
        >[BR-DE-23-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), dürfen BG-18 und BG-19 nicht übermittelt werden.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode = (48,54,55)]">
      <assert test="ram:ApplicableTradeSettlementFinancialCard"
              flag="fatal"
              id="BR-DE-24-a"
        >[BR-DE-24-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), muss genau BG-18 "PAYMENT CARD INFORMATION" übermittelt werden.</assert>
      <assert test="not(ram:PayeePartyCreditorFinancialAccount) and
                    not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID or
                        /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID or
                        ram:PayerPartyDebtorFinancialAccount/ram:IBANID)"
              flag="fatal"
              id="BR-DE-24-b"
        >[BR-DE-24-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), dürfen BG-17 und BG-19 nicht übermittelt werden.</assert>
    </rule>
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode = 59]">
      <assert test="not(ram:TypeCode = '59') or
                    matches(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and
                    xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then $cp - 55 else  $cp - 48),'')) mod 97 = 1"
              flag="warning"
              id="BR-DE-20"
        >[BR-DE-20] "Debited account identifier" (BT-91) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 59 SEPA als Zahlungsmittel gefordert wird.</assert>
      <assert test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID or
                    /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID or
                    ram:PayerPartyDebtorFinancialAccount/ram:IBANID"
              flag="fatal"
              id="BR-DE-25-a"
        >[BR-DE-25-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), muss genau BG-19 "DIRECT DEBIT" übermittelt werden.</assert>        
      <assert test="not(ram:PayeePartyCreditorFinancialAccount) and
                    not(ram:ApplicableTradeSettlementFinancialCard)"
              flag="fatal"
              id="BR-DE-25-b"
        >[BR-DE-25-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), dürfen BG-17 und BG-18 nicht übermittelt werden.</assert>        
    </rule>
    
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert test="ram:RateApplicablePercent[boolean(normalize-space(.))]"
              flag="fatal"
              id="BR-DE-14"
          >[BR-DE-14] Das Element "VAT category rate" (BT-119) muss übermittelt werden.</assert>
    </rule>
  </pattern>
  <pattern id="cii-extension-pattern">
    <!-- robust version of testing extension https://stackoverflow.com/questions/3206975/xpath-selecting-elements-that-equal-a-value  -->
    <let name="isExtension"
        value="exists(/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xoev-de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] )" />
    
      <rule context="//ram:GlobalID[@schemeID and $isExtension][not(ancestor::ram:SpecifiedTradeProduct) and not(ancestor::ram:ShipToTradeParty)]">
        <!-- BR-DEX-04
    Überschreibt BR-CL-10 und ergänzt um XR01, XR02, XR03
      -->
          <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
            flag="fatal"
            id="BR-DEX-04"
              >[BR-DEX-04] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="ram:ID[@schemeID and $isExtension][not(ancestor::ram:SpecifiedTaxRegistration)]">
        <!-- BR-DEX-05
    Überschreibt BR-CL-11 und ergänzt um XR01, XR02, XR03
      -->
          <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
            flag="fatal"
            id="BR-DEX-05"
              >[BR-DEX-05] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>
      <rule context="ram:SpecifiedTradeProduct/ram:GlobalID[@schemeID and $isExtension]">
        <!-- BR-DEX-06
    Überschreibt BR-CL-21 und ergänzt um XR01, XR02, XR03
      -->
          <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
            flag="fatal"
            id="BR-DEX-06"
              >[BR-DEX-06] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
      </rule>    
      <rule context="ram:URIUniversalCommunication/ram:URIID[@schemeID and $isExtension]">
        <!-- BR-DEX-07
    Überschreibt BR-CL-25 und ergänzt um XR01, XR02, XR03
      -->
          <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($CEF-EAS-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
            flag="fatal"
            id="BR-DEX-07"
              >[BR-DEX-07] Any scheme identifier for an Endpoint Identifier in <name/> MUST belong to the CEF EAS code list. </assert>
      </rule>
      <rule context="ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[@schemeID and $isExtension]">
        <!-- BR-DEX-08
    Überschreibt BR-CL-26 und ergänzt um XR01, XR02, XR03
      -->
          <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
            flag="fatal"
            id="BR-DEX-08"
              >[BR-DEX-08] Any scheme identifier for a Delivery location identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
    </rule>
  </pattern>
</schema>
