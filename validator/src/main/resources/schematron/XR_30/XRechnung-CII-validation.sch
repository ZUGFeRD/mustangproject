<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
        xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
        xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
        xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
        xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        queryBinding="xslt2"
        xmlns:u="utils">
  <title>Schematron Version @xr-schematron.version.full@ - XRechnung @xrechnung.version@ compatible - CII</title>
  <ns prefix="rsm"  uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
  <ns prefix="ccts" uri="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" />
  <ns prefix="udt"  uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
  <ns prefix="qdt"  uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
  <ns prefix="ram"  uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />

  <xsl:function as="xs:decimal" name="u:decimalOrZero">
    <xsl:param name="element" />
    <xsl:sequence select="if (boolean($element)) then xs:decimal($element) else 0" />
  </xsl:function>

  <phase id="xrechnung-model">
    <active pattern="variable-pattern" />
    <active pattern="cii-pattern" />
    <active pattern="cii-extension-pattern" />
  </phase>

  <include href="../common.sch" />

  <pattern id="cii-pattern">
    <rule context="/rsm:CrossIndustryInvoice">

        <!-- Only if BG-19 exists, rules BR-DE-30 and BR-DE-31 should fail on missing elements BT-90 or BT-91.
            Because there is no specific (sub-)element for BG-19 in CII, are making use of the semantic definition that BG-19 has three mandatory elements and,
            accordingly, either all of the three BTs must exist or none. -->
        <let name="BT-89-path" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID"/>
        <let name="BT-90-path" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID"/>
        <let name="BT-91-path" value="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID"/>
        <let name="BG-19-not-existing" value="not(exists(($BT-89-path, $BT-90-path, $BT-91-path)))" />
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
                    ((rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[normalize-space(@schemeID)='VA' or
                                                                                                                                                  normalize-space(@schemeID)='FC'][boolean(normalize-space(.))], rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty))"
              flag="fatal"
              id="BR-DE-16"
          >[BR-DE-16] Wenn in einer Rechnung die Steuercodes S, Z, E, AE, K, G, L oder M verwendet werden, muss mindestens eines der Elemente "Seller VAT identifier" (BT-31), "Seller tax registration identifier" (BT-32)
          oder "SELLER TAX REPRESENTATIVE PARTY" (BG-11) übermittelt werden.
      </assert>
      <assert test="normalize-space(rsm:ExchangedDocument/ram:TypeCode) = ('326', '380', '384', '389', '381', '875', '876', '877')"
              flag="warning"
              id="BR-DE-17"
          >[BR-DE-17] Mit dem Element "Invoice type code" (BT-3) sollen ausschließlich folgende Codes aus der Codeliste UNTDID 1001 übermittelt werden: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice) und 381 (Credit note),875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
      <assert test="every $line 
                      in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')] 
                      satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX ) and
                    matches( rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )"                    
              flag="fatal"
              id="BR-DE-18"
          >[BR-DE-18] Skonto Zeilen in <name/> muessen diesem regulärem Ausdruck entsprechen: <value-of select="$XR-SKONTO-REGEX"/>. Die Informationen zur Gewährung von Skonto müssen wie folgt im Element "Payment terms" (BT-20) übermittelt werden: Anzugeben ist im ersten Segment "SKONTO", im zweiten "TAGE=n", im dritten "PROZENT=n". Prozentzahlen sind ohne Vorzeichen sowie mit Punkt getrennt von zwei Nachkommastellen anzugeben. Liegt dem zu berechnenden Betrag nicht BT-115, "fälliger Betrag" zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung, ist der Grundwert zur Berechnung von Skonto als viertes Segment "BASISBETRAG=n" gemäß dem semantischen Datentypen Amount anzugeben. Jeder Eintrag beginnt mit einer #, die Segmente sind mit einer # getrennt und eine Zeile schließt mit einer # ab. Am Ende einer vollständigen Skontoangabe muss ein XML-konformer Zeilenumbruch folgen. Alle Angaben zur Gewährung von Skonto müssen in Großbuchstaben gemacht werden. Zusätzliches Whitespace (Leerzeichen, Tabulatoren oder Zeilenumbrüche) ist nicht zulässig. Andere Zeichen oder Texte als in den oberen Vorgaben genannt sind nicht zulässig.</assert>

      <assert test="count(//ram:AdditionalReferencedDocument) = count(//ram:AdditionalReferencedDocument[not(./ram:AttachmentBinaryObject/@filename = preceding-sibling::ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject/@filename)])"
              flag="fatal"
              id="BR-DE-22"
          >[BR-DE-22] Not all filename attributes of the embeddedDocumentBinaryObject elements are unique</assert>
      <assert test="not(normalize-space(rsm:ExchangedDocument/ram:TypeCode) = '384') or
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
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode = '916']">
        <assert test="not(exists(ram:URIID)) or (matches(ram:URIID, $XR-URL-REGEX))"
            flag="warning"
              id="BR-TMP-2">[BR-TMP-2] BT-124 "External document location" muss eine absolute URL mit gültigem Schema enthalten.</assert>
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
    
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[normalize-space(ram:TypeCode) = ('30','58')]">
      <assert test="not(normalize-space(ram:TypeCode) = '58') or
                    matches(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and
                    xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(ram:PayeePartyCreditorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
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
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[normalize-space(ram:TypeCode) = ('48','54','55')]">
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
  
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans[normalize-space(ram:TypeCode) = '59']">
      <assert test="not(normalize-space(ram:TypeCode) = '59') or
                    matches(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and
                    xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(ram:PayerPartyDebtorFinancialAccount/ram:IBANID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
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
        value="exists(/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xeinkauf.de:kosit:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xeinkauf.de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] )" />
    
      <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument[$isExtension]">
          <assert test="not(exists(//ram:ParentLineID))"
              flag="warning"
              id="BR-DEX-15">
              [BR-DEX-15] This CII file might use the concept of Sub Invoice Lines. However XRechnung does not support this.
          </assert>
      </rule>
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

      <rule context="ram:AttachmentBinaryObject[$isExtension]">
          <!-- BR-DEX-01
        checks whether an EmbeddedCocumentBinaryObject has a valid mimeCode (incl. XML)
        -->
          <assert test=".[@mimeCode = 'application/pdf' or
              @mimeCode = 'image/png' or
              @mimeCode = 'image/jpeg' or
              @mimeCode = 'text/csv' or
              @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or
              @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet' or
              @mimeCode = 'application/xml']"
              id="BR-DEX-01"
              flag="fatal"
              >[BR-DEX-01] Das Element <name /> "Attached Document" (BT-125) benutzt einen nicht zulässigen MIME-Code: <value-of
                  select="@mimeCode" />. Im Falle einer Extension darf zusätzlich zu der Liste der mime codes (definiert in Abschnitt 8.2, "Binary Object") der MIME-Code application/xml genutzt werden.</assert>
      </rule>
  </pattern>
</schema>
