<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  queryBinding="xslt2"
  defaultPhase="xrechnung-model">
  <title>Schematron Version 1.8.2 - XRechnung 2.3.1 compatible - UBL - Invoice / Creditnote</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
  <ns prefix="xs"  uri="http://www.w3.org/2001/XMLSchema" />
  
  <phase id="xrechnung-model">
    <active pattern="variable-pattern" />
    <active pattern="ubl-pattern" />
    <active pattern="ubl-extension-pattern" />
  </phase>
  
  <include href="../common.sch" />
  
  <pattern id="ubl-pattern">
    <rule context="/ubl:Invoice | /cn:CreditNote">
      <assert test="cac:PaymentMeans"
        flag="fatal"
        id="BR-DE-1"
        >[BR-DE-1] Eine Rechnung (INVOICE) muss Angaben zu "PAYMENT INSTRUCTIONS" (BG-16) enthalten.</assert>
      <assert test="cbc:BuyerReference[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-15"
        >[BR-DE-15] Das Element "Buyer reference" (BT-10) muss übermittelt werden.</assert>
      
      <let name="supportedVATCodes" value="('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')" />
      <let name="BT-31orBT-32Path" value="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))]" />      
      <let name="BT-95-UBL-Inv" value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and
        following-sibling::cac:TaxScheme/cbc:ID = 'VAT']" />
      <let name="BT-95-UBL-CN" value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']" />
      <let name="BT-102" value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']" />
      <let name="BT-151" value="(cac:InvoiceLine | cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" />
      <!-- If one of BT-95, BT-102, BT-151 is in List of supportedVATCodes then either BG-11=cac:TaxRepresentativeParty or $BT-31orBT-32Path has to exist -->
      <assert test="
        (not(
          ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or
          ($BT-102 = $supportedVATCodes) or
          ($BT-151 = $supportedVATCodes)
        ) or
        (cac:TaxRepresentativeParty, $BT-31orBT-32Path))
        "
        flag="fatal"
        id="BR-DE-16"
        >[BR-DE-16] Wenn in einer Rechnung die Steuercodes S, Z, E, AE, K, G, L oder M verwendet werden, muss mindestens eines der Elemente "Seller VAT identifier" (BT-31), "Seller tax registration identifier" (BT-32)
        oder "SELLER TAX REPRESENTATIVE PARTY" (BG-11) übermittelt werden.</assert>
      <let name="supportedInvAndCNTypeCodes" value="('326', '380', '384', '389', '381', '875', '876', '877')" />
      <assert test="cbc:InvoiceTypeCode = $supportedInvAndCNTypeCodes
        or cbc:CreditNoteTypeCode = $supportedInvAndCNTypeCodes"
        flag="warning"
        id="BR-DE-17"
        >[BR-DE-17] Mit dem Element "Invoice type code" (BT-3) sollen ausschließlich folgende Codes aus der Codeliste UNTDID 1001 übermittelt werden: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice) und 381 (Credit note),875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
      <assert test="every $line in
            cac:PaymentTerms/cbc:Note[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')] 
            satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX) 
                                and
                                matches( cac:PaymentTerms/cbc:Note[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )"
        flag="fatal"
        id="BR-DE-18"
        >[BR-DE-18] Skonto/Verzug Zeilen in <name/> müssen diesem regulärem Ausdruck entsprechen: <value-of select="$XR-SKONTO-REGEX"/>. Die Informationen zur Gewährung von Skonto oder zur Berechnung von Verzugszinsen müssen wie folgt im Element "Payment terms" (BT-20) übermittelt werden: Anzugeben ist im ersten Segment "SKONTO" oder "VERZUG", im zweiten "TAGE=n", im dritten "PROZENT=n". Prozentzahlen sind ohne Vorzeichen sowie mit Punkt getrennt von zwei Nachkommastellen anzugeben. Liegt dem zu berechnenden Betrag nicht BT-115, "fälliger Betrag" zugrunde, sondern nur ein Teil des fälligen Betrags der Rechnung, ist der Grundwert zur Berechnung von Skonto oder Verzugszins als viertes Segment "BASISBETRAG=n" gemäß dem semantischen Datentypen Amount anzugeben. Jeder Eintrag beginnt mit einer #, die Segmente sind mit einer # getrennt und eine Zeile schließt mit einer # ab. Am Ende einer vollständigen Skonto oder Verzugsangabe muss ein XML-konformer Zeilenumbruch folgen. Alle Angaben zur Gewährung von Skonto oder zur Berechnung von Verzugszinsen müssen in Großbuchstaben gemacht werden. Zusätzliches Whitespace (Leerzeichen, Tabulatoren oder Zeilenumbrüche) ist nicht zulässig. Andere Zeichen oder Texte als in den oberen Vorgaben genannt sind nicht zulässig.</assert>
      <assert test="cbc:CustomizationID = $XR-CIUS-ID or
                    cbc:CustomizationID = $XR-EXTENSION-ID"
        flag="warning"
        id="BR-DE-21"
        >[BR-DE-21] Das Element "Specification identifier" (BT-24) soll syntaktisch der Kennung des Standards XRechnung entsprechen.</assert>
      <assert test="count(cac:AdditionalDocumentReference) = 
                    count(cac:AdditionalDocumentReference[not(./cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename = preceding-sibling::cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)])"
        flag="fatal"
        id="BR-DE-22"
        >[BR-DE-22] Das "filename"-Attribut aller "EmbeddedDocumentBinaryObject"-Elemente muss eindeutig sein</assert>

      <assert test="((not(cbc:InvoiceTypeCode = 384 or cbc:CreditNoteTypeCode = 384) or
                    (cac:BillingReference/cac:InvoiceDocumentReference)))"
        flag="warning"
        id="BR-DE-26"
        >[BR-DE-26] Wenn im Element "Invoice type code" (BT-3) der Code 384 (Corrected invoice) übergeben wird, soll PRECEDING INVOICE REFERENCE BG-3 mind. einmal vorhanden sein.</assert>
      <assert test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cbc:ID)"
        flag="fatal"
        id="BR-DE-29"
        >[BR-DE-29] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Mandate reference identifier" BT-89 übermittelt werden.</assert>
      <assert test="not(cac:PaymentMeans/cac:PaymentMandate) 
                      or (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='SEPA'] 
                        | cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID='SEPA'])"
        flag="fatal"
        id="BR-DE-30"
        >[BR-DE-30] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Bank assigned creditor identifier" BT-90 übermittelt werden.</assert>
      <assert test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)"
        flag="fatal"
        id="BR-DE-31"
        >[BR-DE-31] Wenn "DIRECT DEBIT" BG-19 vorhanden ist, dann muss "Debited account identifier" BT-91 übermittelt werden.</assert>
      
    </rule>    
    
    <rule context="/ubl:Invoice/cac:AccountingSupplierParty | /cn:CreditNote/cac:AccountingSupplierParty">
      <assert test="cac:Party/cac:Contact"
        flag="fatal"
        id="BR-DE-2"
        >[BR-DE-2] Die Gruppe "SELLER CONTACT" (BG-6) muss übermittelt werden.</assert>
    </rule>
    
    <rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
      <assert test="cbc:CityName[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-3"
        >[BR-DE-3] Das Element "Seller city" (BT-37) muss übermittelt werden.</assert>
      <assert test="cbc:PostalZone[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-4"
        >[BR-DE-4] Das Element "Seller post code" (BT-38) muss übermittelt werden.</assert>
    </rule>
    
    <rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /cn:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact">
      <assert test="cbc:Name[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-5"
        >[BR-DE-5] Das Element "Seller contact point" (BT-41) muss übermittelt werden.</assert>
      <assert test="cbc:Telephone[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-6"
        >[BR-DE-6] Das Element "Seller contact telephone number" (BT-42) muss übermittelt werden.</assert>
      <assert test="cbc:ElectronicMail[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-7"
        >[BR-DE-7] Das Element "Seller contact email address" (BT-43) muss übermittelt werden.</assert>
      <assert test="matches(normalize-space(cbc:Telephone), $XR-TELEPHONE-REGEX)"
        flag="warning"
        id="BR-DE-27"
        >[BR-DE-27] In BT-42 sollen mindestens drei Ziffern enthalten sein.</assert>
      <assert test="matches(normalize-space(cbc:ElectronicMail), $XR-EMAIL-REGEX)"
        flag="warning"
        id="BR-DE-28"
        >[BR-DE-28] In BT-43 soll genau ein @-Zeichen enthalten sein, welches nicht von einem Leerzeichen, einem Punkt, aber mindestens zwei Zeichen auf beiden Seiten flankiert werden soll. Ein Punkt sollte nicht am Anfang oder am Ende stehen.</assert>
    </rule>
    
    <rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /cn:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
      <assert test="cbc:CityName[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-8"
        >[BR-DE-8] Das Element "Buyer city" (BT-52) muss übermittelt werden.</assert>
      <assert test="cbc:PostalZone[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-9"
        >[BR-DE-9] Das Element "Buyer post code" (BT-53) muss übermittelt werden.</assert>
    </rule>
    
    <rule context="/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /cn:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address">
      <assert test="cbc:CityName[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-10"
        >[BR-DE-10] Das Element "Deliver to city" (BT-77) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
      <assert test="cbc:PostalZone[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-11"
        >[BR-DE-11] Das Element "Deliver to post code" (BT-78) muss übermittelt werden, wenn die Gruppe "DELIVER TO ADDRESS" (BG-15) übermittelt wird.</assert>
    </rule>
    
    <rule context="/ubl:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)] | /cn:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)]">
      <!-- check for PaymentMeansCode 30 was not added by purpose in 2.1.1. -->
      <assert test="not(cbc:PaymentMeansCode = '58') or
                    matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and
                    xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
        flag="warning"
        id="BR-DE-19"
        >[BR-DE-19] "Payment account identifier" (BT-84) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 58 SEPA als Zahlungsmittel gefordert wird.</assert>
      <assert test="cac:PayeeFinancialAccount"
        flag="fatal"
        id="BR-DE-23-a"
        >[BR-DE-23-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), muss BG-17 "CREDIT TRANSFER" übermittelt werden.</assert>
      <assert test="not(cac:CardAccount) and
                    not(cac:PaymentMandate)"
        flag="fatal"
        id="BR-DE-23-b"
        >[BR-DE-23-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Überweisungen enthält (30, 58), dürfen BG-18 und BG-19 nicht übermittelt werden.</assert>     
    </rule>
    
    <rule context="/ubl:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)] |/cn:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)]">
      <assert test="cac:CardAccount"
        flag="fatal"
        id="BR-DE-24-a"
        >[BR-DE-24-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), muss genau BG-18 "PAYMENT CARD INFORMATION" übermittelt werden.</assert>
      <assert test="not(cac:PayeeFinancialAccount) and
                    not(cac:PaymentMandate)"
        flag="fatal"
        id="BR-DE-24-b"
        >[BR-DE-24-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Kartenzahlungen enthält (48, 54, 55), dürfen BG-17 und BG-19 nicht übermittelt werden.</assert>
    </rule>
    
    <rule context="/ubl:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = 59] | /cn:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = 59]">
      <assert test="not(cbc:PaymentMeansCode = '59') or
                    matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and
                    xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1"
        flag="warning"
        id="BR-DE-20"
        >[BR-DE-20] "Debited account identifier" (BT-91) soll eine korrekte IBAN enthalten, wenn in "Payment means type code" (BT-81) mit dem Code 59 SEPA als Zahlungsmittel gefordert wird.</assert>
      <assert test="cac:PaymentMandate"
        flag="fatal"
        id="BR-DE-25-a"
        >[BR-DE-25-a] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), muss genau BG-19 "DIRECT DEBIT" übermittelt werden.</assert>        
      <assert test="not(cac:PayeeFinancialAccount) and
                    not(cac:CardAccount)"
        flag="fatal"
        id="BR-DE-25-b"
        >[BR-DE-25-b] Wenn BT-81 "Payment means type code" einen Schlüssel für Lastschriften enthält (59), dürfen BG-17 und BG-18 nicht übermittelt werden.</assert>        
    </rule>
    
    <rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal">
      <assert test="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]"
        flag="fatal"
        id="BR-DE-14"
        >[BR-DE-14] Das Element "VAT category rate" (BT-119) muss übermittelt werden.</assert>
    </rule>
  </pattern>
  
  <pattern id="ubl-extension-pattern">
    <!-- robust version of testing extension https://stackoverflow.com/questions/3206975/xpath-selecting-elements-that-equal-a-value  -->
    <let name="isExtension"
      value="exists(/ubl:Invoice/cbc:CustomizationID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xoev-de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] | /cn:CreditNote/cbc:CustomizationID[text() = concat( 'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_', $XR-MAJOR-MINOR-VERSION ,'#conformant#urn:xoev-de:kosit:extension:xrechnung_', $XR-MAJOR-MINOR-VERSION) ] )" />
    
    <rule context="cbc:EmbeddedDocumentBinaryObject[$isExtension]">
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
    
    <rule context="/ubl:Invoice[$isExtension]">
      <!-- BR-DEX-02
         this rule consists of two parts:
         part one proofs in every invoiceline whether the lineextensionamount of it is equal to the sum of lineExtensionAmount of the ancillary subinvoicelines
         part two proofs whether the count of invoice lines with correct lineextensionamounts according to part one is equal to the count of subinvoicelines with including subinvoicelines
         every amount has to be cast to decimal cause of floating point problems -->
      <assert test="(every $invoiceline 
        in /ubl:Invoice/cac:InvoiceLine[ exists (./cac:SubInvoiceLine) ] 
        satisfies $invoiceline/xs:decimal(cbc:LineExtensionAmount) = sum($invoiceline/cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))) and
        (count( //cac:SubInvoiceLine [xs:decimal(cbc:LineExtensionAmount) = sum(child::cac:SubInvoiceLine/xs:decimal(cbc:LineExtensionAmount))]) = count(//cac:SubInvoiceLine [count(cac:SubInvoiceLine) > 0]))"
        flag="warning"
        id="BR-DEX-02"
        >[BR-DEX-02] Der Wert von "Invoice line net amount" (BT-131) einer "INVOICE LINE"
        (BG-25) oder einer "SUB INVOICE LINE" (BG-DEX-01) soll der Summe
        der "Invoice line net amount" (BT-131) der direkt darunterliegenden "SUB
        INVOICE LINE" (BG-DEX-01) entsprechen.</assert>
      
      <!-- BR-DEX-03
         this rule checks the existence of cac:Item/cac:ClassifiedTaxCategory in every sub invoice line -->
      <assert test="not(exists(//cac:SubInvoiceLine/cac:Item[ count ( cac:ClassifiedTaxCategory) != 1]))"
        flag="fatal"
        id="BR-DEX-03"
        >[BR-DEX-03] Eine Sub Invoice Line (BG-DEX-01) muss genau eine "SUB INVOICE LINE VAT INFORMATION" (BG-DEX-06) enthalten.</assert>
    </rule>
    <rule context="cac:LegalMonetaryTotal[$isExtension]">
      <let name="prepaidamount" value="if (exists(cbc:PrepaidAmount)) then (xs:decimal(cbc:PrepaidAmount)) else (0)"/>
      <let name="payableroundingamount" value="if (exists(cbc:PayableRoundingAmount)) then (xs:decimal(cbc:PayableRoundingAmount)) else (0)" />
      <let name="thirdpartyprepaidamount" value="if (exists(../cac:PrepaidPayment/cbc:PaidAmount[boolean(normalize-space(xs:string(.)))])) then (sum(../cac:PrepaidPayment/xs:decimal(cbc:PaidAmount))) else (0)" />
      <!-- BR-DEX-09
        Overrides BR-CO-16
        Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) + Rounding amount (BT-114) - Σ Third party payment amount (BR-DEX-002).
          -->
      <assert test="(round((xs:decimal(cbc:PayableAmount) - $payableroundingamount) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - $prepaidamount + $thirdpartyprepaidamount) * 10 * 10) div 100)"
        flag="fatal"
        id="BR-DEX-09"
        >[BR-DEX-09] Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) + Rounding amount (BT-114) - Σ Third party payment amount (BT-DEX-002).</assert>
    </rule>
    <rule context="cac:PartyIdentification/cbc:ID[@schemeID and $isExtension]">
      <!-- BR-DEX-04
        Überschreibt BR-CL-10 und ergänzt um XR01, XR02, XR03
          -->
      <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))"
        flag="fatal"
        id="BR-DEX-04"
        >[BR-DEX-04] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
    </rule>
    <rule context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID and $isExtension]">
      <!-- BR-DEX-05
        Überschreibt BR-CL-11 und ergänzt um XR01, XR02, XR03
          -->
      <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
        flag="fatal"
        id="BR-DEX-05"
        >[BR-DEX-05] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
    </rule>
    <rule context="cac:StandardItemIdentification/cbc:ID[@schemeID and $isExtension]">
      <!-- BR-DEX-06
        Überschreibt BR-CL-21 und ergänzt um XR01, XR02, XR03
          -->
      <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
        flag="fatal"
        id="BR-DEX-06"
        >[BR-DEX-06] Any scheme identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
    </rule>    
    <rule context="cbc:EndpointID[@schemeID and $isExtension]">
      <!-- BR-DEX-07
        Überschreibt BR-CL-25 und ergänzt um XR01, XR02, XR03
          -->
      <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($CEF-EAS-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
        flag="fatal"
        id="BR-DEX-07"
        >[BR-DEX-07] Any scheme identifier for an Endpoint Identifier in <name/> MUST belong to the CEF EAS code list. </assert>
    </rule>
    <rule context="cac:DeliveryLocation/cbc:ID[@schemeID and $isExtension]">
      <!-- BR-DEX-08
        Überschreibt BR-CL-26 und ergänzt um XR01, XR02, XR03
          -->
      <assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains($ISO-6523-ICD-EXT-CODES, concat(' ', normalize-space(@schemeID), ' '))))"
        flag="fatal"
        id="BR-DEX-08"
        >[BR-DEX-08] Any scheme identifier for a Delivery location identifier in <name/> MUST be coded using one of the ISO 6523 ICD list. </assert>
    </rule>
    <rule context="/ubl:Invoice/cac:PrepaidPayment[$isExtension]">
      <assert test="cbc:ID[boolean(normalize-space(xs:string(.)))]"
        flag="fatal"
        id="BR-DEX-10"
        >[BR-DEX-10] Das Element "Third party payment type" BT-DEX-001 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</assert>
      <assert test="cbc:PaidAmount[boolean(normalize-space(xs:string(.)))]"
        flag="fatal"
        id="BR-DEX-11"
        >[BR-DEX-11] Das Element "Third party payment amount" BT-DEX-002 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</assert>
      <assert test="cbc:InstructionID[boolean(normalize-space(xs:string(.)))]"
        flag="fatal"
        id="BR-DEX-12"
        >[BR-DEX-12] Das Element "Third party payment description" BT-DEX-003 muss übermittelt werden, wenn die Gruppe "THIRD PARTY PAYMENT" (BG-DEX-09) übermittelt wird.</assert>
      <assert test="string-length(substring-after(cbc:PaidAmount, '.')) &lt;= 2"
        flag="fatal"
        id="BR-DEX-13"
        >[BR-DEX-13] Die maximale Anzahl zulässiger Nachkommastellen für das Element "Third party payment amount" (BT-DEX-002) ist 2."</assert>
      <assert test="cbc:PaidAmount/@currencyID = parent::node()/cbc:DocumentCurrencyCode"
        flag="fatal"
        id="BR-DEX-14"
        >[BR-DEX-14] Die Währungsangabe von "Third party payment amount" BT-DEX-002 muss BT-5 ("Invoice currency code") entsprechen.</assert>
    </rule>
  </pattern>
</schema>
