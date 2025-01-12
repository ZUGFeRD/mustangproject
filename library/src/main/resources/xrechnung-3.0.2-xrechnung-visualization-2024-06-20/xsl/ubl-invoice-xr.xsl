<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
   xmlns:Invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
   xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
   xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
   xmlns:saxon="http://saxon.sf.net/" exclude-result-prefixes="#all" version="2.0">
   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p>
            <xd:b>Author:</xd:b> KoSIT Bremen (kosit@finanzen.bremen.de)</xd:p>
         <xd:b>Fassung vom: 2020-06-30+02:00</xd:b>
         <xd:b>modifiziert durch Dr. Jan Thiele am: 2024-09-26+01:00</xd:b>
         <xd:p>Überführt eine zur EN 16931 konforme elektronische Rechnung in der konkreten Syntax
            UBL.2_1.Invoice in eine Instanz gemäß des Schemas für den Namensraum
            urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1.</xd:p>
         <xd:p>Das Skript setzt voraus, dass das zu verarbeitende Dokument valide bzgl. des XML
            Schemas und der Schematron-Regeln der Quelle ist. Für nicht valide Dokumente ist das
            Ergebnis nicht definiert.</xd:p>
      </xd:desc>
   </xd:doc>

   <xsl:output method="xml" indent="yes"/>

   <xsl:include href="./common-xr.xsl"/>


   <xsl:template match="/Invoice:Invoice">
      <xr:invoice>
         <xsl:variable name="current-bg" as="element()" select="."/>
         <xsl:apply-templates mode="BT-1" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-2" select="./cbc:IssueDate"/>
         <xsl:apply-templates mode="BT-3" select="./cbc:InvoiceTypeCode"/>
         <xsl:apply-templates mode="BT-5" select="./cbc:DocumentCurrencyCode"/>
         <xsl:apply-templates mode="BT-6" select="./cbc:TaxCurrencyCode"/>
         <xsl:apply-templates mode="BT-7" select="./cbc:TaxPointDate"/>
         <xsl:apply-templates mode="BT-8" select="./cac:InvoicePeriod/cbc:DescriptionCode"/>
         <xsl:apply-templates mode="BT-9" select="./cbc:DueDate"/>
         <xsl:apply-templates mode="BT-10" select="./cbc:BuyerReference"/>
         <xsl:apply-templates mode="BT-11" select="./cac:ProjectReference/cbc:ID"/>
         <xsl:apply-templates mode="BT-12" select="./cac:ContractDocumentReference/cbc:ID"/>
         <xsl:apply-templates mode="BT-13" select="./cac:OrderReference/cbc:ID"/>
         <xsl:apply-templates mode="BT-14" select="./cac:OrderReference/cbc:SalesOrderID"/>
         <xsl:apply-templates mode="BT-15" select="./cac:ReceiptDocumentReference/cbc:ID"/>
         <xsl:apply-templates mode="BT-16" select="./cac:DespatchDocumentReference/cbc:ID"/>
         <xsl:apply-templates mode="BT-17" select="./cac:OriginatorDocumentReference/cbc:ID"/>
         <xsl:apply-templates mode="BT-18"
            select="./cac:AdditionalDocumentReference/cbc:ID[following-sibling::cbc:DocumentTypeCode = '130']"/>
         <xsl:apply-templates mode="BT-19" select="./cbc:AccountingCost"/>
         <xsl:apply-templates mode="BT-20" select="./cac:PaymentTerms/cbc:Note"/>
         <!--Manuell erstelltes Template für BG-1-->
         <xsl:for-each-group select="./cbc:Note" group-by="
               if (following-sibling::cbc:Note and matches(., '^[A-Z]{3}$')) then
                  generate-id(following-sibling::cbc:Note[1])
               else
                  generate-id(.)">
            <xr:INVOICE_NOTE>
               <xsl:attribute name="xr:id" select="'BG-1'"/>
               <xsl:attribute name="xr:src" select="xr:src-path($current-bg)"/>
               <xsl:if test="count(current-group()) gt 1">
                  <xr:Invoice_note_subject_code>
                     <xsl:attribute name="xr:id" select="'BT-21'"/>
                     <xsl:attribute name="xr:src" select="xr:src-path(current-group()[1])"/>
                     <!--<xsl:value-of select="current-group()[1]"/>-->
					 <!-- Begin: Jan Thiele -->
					 <xsl:variable name="group_l" select="current-group()[1]"/>
					 <xsl:variable name="group_JT">
						 <xsl:call-template name="code.UNTDID.4451">
							<xsl:with-param name="myparam" select="group_l"/>			
						 </xsl:call-template>
					 </xsl:variable>
					 <xsl:value-of select="$group_JT"/>		 
					 <!-- End: Jan Thiele -->
                  </xr:Invoice_note_subject_code>
               </xsl:if>
               <xr:Invoice_note>
                  <xsl:attribute name="xr:id" select="'BT-22'"/>
                  <xsl:attribute name="xr:src" select="xr:src-path(current-group()[last()])"/>
                  <xsl:value-of select="current-group()[last()]"/>
               </xr:Invoice_note>
            </xr:INVOICE_NOTE>
         </xsl:for-each-group>
         <!--Manuell erstelltes Template für BG-2-->
         <xr:PROCESS_CONTROL>
            <xsl:attribute name="xr:id" select="'BG-2'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:if test="./cbc:ProfileID">
               <xr:Business_process_type_identifier>
                  <xsl:attribute name="xr:id" select="'BT-23'"/>
                  <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
                  <xsl:value-of select="./cbc:ProfileID"/>
               </xr:Business_process_type_identifier>
            </xsl:if>
            <xr:Specification_identifier>
               <xsl:attribute name="xr:id" select="'BT-24'"/>
               <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
               <xsl:value-of select="./cbc:CustomizationID"/>
            </xr:Specification_identifier>
         </xr:PROCESS_CONTROL>
         <xsl:apply-templates mode="BG-3"
            select="./cac:BillingReference/cac:InvoiceDocumentReference"/>
         <xsl:apply-templates mode="BG-4" select="./cac:AccountingSupplierParty"/>
         <xsl:apply-templates mode="BG-7" select="./cac:AccountingCustomerParty"/>
         <xsl:apply-templates mode="BG-10" select="./cac:PayeeParty"/>
         <xsl:apply-templates mode="BG-11" select="./cac:TaxRepresentativeParty"/>
         <xsl:apply-templates mode="BG-13" select="./cac:Delivery"/>
         <xsl:apply-templates mode="BG-14" select="/Invoice:Invoice/cac:InvoicePeriod"/>
         <!--Manuell: angepasst für BG-16-->
         <!--PaymentMeansCode ist [1] in UBL und im semantischen Modell, daher kann auf diesem Attribut gruppiert werden-->
         <xsl:for-each-group select="cac:PaymentMeans" group-by="cbc:PaymentMeansCode">
            <xr:PAYMENT_INSTRUCTIONS>
               <xsl:attribute name="xr:id" select="'BG-16'"/>
               <xsl:attribute name="xr:src" select="xr:src-path($current-bg)"/>
               <xsl:apply-templates mode="BT-81" select="current-group()[1]/cbc:PaymentMeansCode"/>
               <xsl:apply-templates mode="BT-82" select="current-group()[1]/cbc:PaymentMeansCode/@name"/>
               <xsl:for-each-group select="current-group()/cbc:PaymentID" group-by="text()">
                  <xsl:apply-templates mode="BT-83" select="current-group()[1]"/>
               </xsl:for-each-group>
               <xsl:apply-templates mode="BG-17" select="current-group()/cac:PayeeFinancialAccount"/>
               <xsl:apply-templates mode="BG-18" select="current-group()/cac:CardAccount"/>
               <xsl:apply-templates mode="BG-19" select="current-group()/cac:PaymentMandate"/>
            </xr:PAYMENT_INSTRUCTIONS>
         </xsl:for-each-group>
         <xsl:apply-templates mode="BG-20"
            select="./cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BG-21"
            select="./cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BG-22" select="./cac:LegalMonetaryTotal"/>
         <xsl:apply-templates mode="BG-23" select="./cac:TaxTotal/cac:TaxSubtotal"/>
         <xsl:apply-templates mode="BG-24" select="./cac:AdditionalDocumentReference"/>
         <xsl:apply-templates mode="BG-25" select="./cac:InvoiceLine"/>
         <xsl:apply-templates mode="BG-DEX-09" select="./cac:PrepaidPayment"/>
      </xr:invoice>
   </xsl:template>
   <xsl:template mode="BT-1" match="/Invoice:Invoice/cbc:ID">
      <xr:Invoice_number>
         <xsl:attribute name="xr:id" select="'BT-1'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Invoice_number>
   </xsl:template>
   <xsl:template mode="BT-2" match="/Invoice:Invoice/cbc:IssueDate">
      <xr:Invoice_issue_date>
         <xsl:attribute name="xr:id" select="'BT-2'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoice_issue_date>
   </xsl:template>
   <xsl:template mode="BT-3" match="/Invoice:Invoice/cbc:InvoiceTypeCode">
      <xr:Invoice_type_code>
         <xsl:attribute name="xr:id" select="'BT-3'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.untdid.1001">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>
		 <!-- End: Jan Thiele -->
      </xr:Invoice_type_code>
   </xsl:template>
   <xsl:template mode="BT-5" match="/Invoice:Invoice/cbc:DocumentCurrencyCode">
      <xr:Invoice_currency_code>
         <xsl:attribute name="xr:id" select="'BT-5'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Currency-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>
		 <!-- End: Jan Thiele -->
      </xr:Invoice_currency_code>
   </xsl:template>
   <xsl:template mode="BT-6" match="/Invoice:Invoice/cbc:TaxCurrencyCode">
      <xr:VAT_accounting_currency_code>
         <xsl:attribute name="xr:id" select="'BT-6'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Currency-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>
		 <!-- End: Jan Thiele -->
      </xr:VAT_accounting_currency_code>
   </xsl:template>
   <xsl:template mode="BT-7" match="/Invoice:Invoice/cbc:TaxPointDate">
      <xr:Value_added_tax_point_date>
         <xsl:attribute name="xr:id" select="'BT-7'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Value_added_tax_point_date>
   </xsl:template>
   <xsl:template mode="BT-8" match="/Invoice:Invoice/cac:InvoicePeriod/cbc:DescriptionCode">
      <xr:Value_added_tax_point_date_code>
         <xsl:attribute name="xr:id" select="'BT-8'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.2005">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>
		 <!-- End: Jan Thiele -->
      </xr:Value_added_tax_point_date_code>
   </xsl:template>
   <xsl:template mode="BT-9" match="/Invoice:Invoice/cbc:DueDate">
      <xr:Payment_due_date>
         <xsl:attribute name="xr:id" select="'BT-9'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Payment_due_date>
   </xsl:template>
   <xsl:template mode="BT-10" match="/Invoice:Invoice/cbc:BuyerReference">
      <xr:Buyer_reference>
         <xsl:attribute name="xr:id" select="'BT-10'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_reference>
   </xsl:template>
   <xsl:template mode="BT-11" match="/Invoice:Invoice/cac:ProjectReference/cbc:ID">
      <xr:Project_reference>
         <xsl:attribute name="xr:id" select="'BT-11'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Project_reference>
   </xsl:template>
   <xsl:template mode="BT-12" match="/Invoice:Invoice/cac:ContractDocumentReference/cbc:ID">
      <xr:Contract_reference>
         <xsl:attribute name="xr:id" select="'BT-12'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Contract_reference>
   </xsl:template>
   <xsl:template mode="BT-13" match="/Invoice:Invoice/cac:OrderReference/cbc:ID">
      <xr:Purchase_order_reference>
         <xsl:attribute name="xr:id" select="'BT-13'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Purchase_order_reference>
   </xsl:template>
   <xsl:template mode="BT-14" match="/Invoice:Invoice/cac:OrderReference/cbc:SalesOrderID">
      <xr:Sales_order_reference>
         <xsl:attribute name="xr:id" select="'BT-14'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Sales_order_reference>
   </xsl:template>
   <xsl:template mode="BT-15" match="/Invoice:Invoice/cac:ReceiptDocumentReference/cbc:ID">
      <xr:Receiving_advice_reference>
         <xsl:attribute name="xr:id" select="'BT-15'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Receiving_advice_reference>
   </xsl:template>
   <xsl:template mode="BT-16" match="/Invoice:Invoice/cac:DespatchDocumentReference/cbc:ID">
      <xr:Despatch_advice_reference>
         <xsl:attribute name="xr:id" select="'BT-16'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Despatch_advice_reference>
   </xsl:template>
   <xsl:template mode="BT-17" match="/Invoice:Invoice/cac:OriginatorDocumentReference/cbc:ID">
      <xr:Tender_or_lot_reference>
         <xsl:attribute name="xr:id" select="'BT-17'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Tender_or_lot_reference>
   </xsl:template>
   <xsl:template mode="BT-18"
      match="/Invoice:Invoice/cac:AdditionalDocumentReference/cbc:ID[following-sibling::cbc:DocumentTypeCode = '130']">
      <xr:Invoiced_object_identifier>
         <xsl:attribute name="xr:id" select="'BT-18'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.1153"/>
		 <!-- End: Jan Thiele -->
      </xr:Invoiced_object_identifier>
   </xsl:template>
   <xsl:template mode="BT-19" match="/Invoice:Invoice/cbc:AccountingCost">
      <xr:Buyer_accounting_reference>
         <xsl:attribute name="xr:id" select="'BT-19'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_accounting_reference>
   </xsl:template>
   <xsl:template mode="BT-20" match="/Invoice:Invoice/cac:PaymentTerms/cbc:Note">
      <xr:Payment_terms>
         <xsl:attribute name="xr:id" select="'BT-20'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_terms>
   </xsl:template>
   <xsl:template mode="BG-3"
      match="/Invoice:Invoice/cac:BillingReference/cac:InvoiceDocumentReference">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:BillingReference/cac:InvoiceDocumentReference der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-25" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-26" select="./cbc:IssueDate"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PRECEDING_INVOICE_REFERENCE>
            <xsl:attribute name="xr:id" select="'BG-3'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PRECEDING_INVOICE_REFERENCE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-25"
      match="/Invoice:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
      <xr:Preceding_Invoice_reference>
         <xsl:attribute name="xr:id" select="'BT-25'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Preceding_Invoice_reference>
   </xsl:template>
   <xsl:template mode="BT-26"
      match="/Invoice:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate">
      <xr:Preceding_Invoice_issue_date>
         <xsl:attribute name="xr:id" select="'BT-26'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Preceding_Invoice_issue_date>
   </xsl:template>
   <xsl:template mode="BG-4" match="/Invoice:Invoice/cac:AccountingSupplierParty">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AccountingSupplierParty der Instanz in konkreter Syntax wird auf 10 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-27"
            select="./cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
         <xsl:apply-templates mode="BT-28" select="./cac:Party/cac:PartyName/cbc:Name"/>
         <xsl:apply-templates mode="BT-29" select="./cac:Party/cac:PartyIdentification/cbc:ID[not(@schemeID = 'SEPA')]"/>
         <xsl:apply-templates mode="BT-30" select="./cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>
         <xsl:apply-templates mode="BT-31"
            select="./cac:Party/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
         <xsl:apply-templates mode="BT-32"
            select="./cac:Party/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID != 'VAT']"/>
         <xsl:apply-templates mode="BT-33"
            select="./cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm"/>
         <xsl:apply-templates mode="BT-34" select="./cac:Party/cbc:EndpointID"/>
         <xsl:apply-templates mode="BG-5" select="./cac:Party/cac:PostalAddress"/>
         <xsl:apply-templates mode="BG-6" select="./cac:Party/cac:Contact"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SELLER>
            <xsl:attribute name="xr:id" select="'BG-4'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SELLER>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-27"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName">
      <xr:Seller_name>
         <xsl:attribute name="xr:id" select="'BT-27'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_name>
   </xsl:template>
   <xsl:template mode="BT-28"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name">
      <xr:Seller_trading_name>
         <xsl:attribute name="xr:id" select="'BT-28'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_trading_name>
   </xsl:template>
   <xsl:template mode="BT-29"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[not(@schemeID = 'SEPA')]">
      <xr:Seller_identifier>
         <xsl:attribute name="xr:id" select="'BT-29'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Seller_identifier>
   </xsl:template>
   <xsl:template mode="BT-30"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
      <xr:Seller_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-30'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Seller_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-31"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']">
      <xr:Seller_VAT_identifier>
         <xsl:attribute name="xr:id" select="'BT-31'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Seller_VAT_identifier>
   </xsl:template>
   <xsl:template mode="BT-32"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID != 'VAT']">
      <xr:Seller_tax_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-32'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Seller_tax_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-33"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm">
      <xr:Seller_additional_legal_information>
         <xsl:attribute name="xr:id" select="'BT-33'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_additional_legal_information>
   </xsl:template>
   <xsl:template mode="BT-34"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
      <xr:Seller_electronic_address>
         <xsl:attribute name="xr:id" select="'BT-34'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.EAS"/>
		 <!-- End: Jan Thiele -->
      </xr:Seller_electronic_address>
   </xsl:template>
   <xsl:template mode="BG-5"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-35" select="./cbc:StreetName"/>
         <xsl:apply-templates mode="BT-36" select="./cbc:AdditionalStreetName"/>
         <xsl:apply-templates mode="BT-162" select="./cac:AddressLine/cbc:Line"/>
         <xsl:apply-templates mode="BT-37" select="./cbc:CityName"/>
         <xsl:apply-templates mode="BT-38" select="./cbc:PostalZone"/>
         <xsl:apply-templates mode="BT-39" select="./cbc:CountrySubentity"/>
         <xsl:apply-templates mode="BT-40" select="./cac:Country/cbc:IdentificationCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SELLER_POSTAL_ADDRESS>
            <xsl:attribute name="xr:id" select="'BG-5'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SELLER_POSTAL_ADDRESS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-35"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName">
      <xr:Seller_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-35'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-36"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName">
      <xr:Seller_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-36'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-162"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line">
      <xr:Seller_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-162'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-37"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName">
      <xr:Seller_city>
         <xsl:attribute name="xr:id" select="'BT-37'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_city>
   </xsl:template>
   <xsl:template mode="BT-38"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone">
      <xr:Seller_post_code>
         <xsl:attribute name="xr:id" select="'BT-38'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_post_code>
   </xsl:template>
   <xsl:template mode="BT-39"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity">
      <xr:Seller_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-39'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-40"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
      <xr:Seller_country_code>
         <xsl:attribute name="xr:id" select="'BT-40'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Country-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Seller_country_code>
   </xsl:template>
   <xsl:template mode="BG-6"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-41" select="./cbc:Name"/>
         <xsl:apply-templates mode="BT-42" select="./cbc:Telephone"/>
         <xsl:apply-templates mode="BT-43" select="./cbc:ElectronicMail"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SELLER_CONTACT>
            <xsl:attribute name="xr:id" select="'BG-6'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SELLER_CONTACT>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-41"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name">
      <xr:Seller_contact_point>
         <xsl:attribute name="xr:id" select="'BT-41'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_point>
   </xsl:template>
   <xsl:template mode="BT-42"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone">
      <xr:Seller_contact_telephone_number>
         <xsl:attribute name="xr:id" select="'BT-42'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_telephone_number>
   </xsl:template>
   <xsl:template mode="BT-43"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail">
      <xr:Seller_contact_email_address>
         <xsl:attribute name="xr:id" select="'BT-43'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_email_address>
   </xsl:template>
   <xsl:template mode="BG-7" match="/Invoice:Invoice/cac:AccountingCustomerParty">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AccountingCustomerParty der Instanz in konkreter Syntax wird auf 8 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-44"
            select="./cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
         <xsl:apply-templates mode="BT-45" select="./cac:Party/cac:PartyName/cbc:Name"/>
         <xsl:apply-templates mode="BT-46" select="./cac:Party/cac:PartyIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-47" select="./cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>
         <!--<xsl:apply-templates mode="BT-47"
                              select="./cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID"/>-->
         <xsl:apply-templates mode="BT-48"
            select="./cac:Party/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
         <xsl:apply-templates mode="BT-49" select="./cac:Party/cbc:EndpointID"/>
         <xsl:apply-templates mode="BG-8" select="./cac:Party/cac:PostalAddress"/>
         <xsl:apply-templates mode="BG-9" select="./cac:Party/cac:Contact"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:BUYER>
            <xsl:attribute name="xr:id" select="'BG-7'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:BUYER>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-44"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName">
      <xr:Buyer_name>
         <xsl:attribute name="xr:id" select="'BT-44'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_name>
   </xsl:template>
   <xsl:template mode="BT-45"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name">
      <xr:Buyer_trading_name>
         <xsl:attribute name="xr:id" select="'BT-45'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_trading_name>
   </xsl:template>
   <xsl:template mode="BT-46"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
      <xr:Buyer_identifier>
         <xsl:attribute name="xr:id" select="'BT-46'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Buyer_identifier>
   </xsl:template>
   <xsl:template mode="BT-47"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
      <xr:Buyer_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-47'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Buyer_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-48"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']">
      <xr:Buyer_VAT_identifier>
         <xsl:attribute name="xr:id" select="'BT-48'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Buyer_VAT_identifier>
   </xsl:template>
   <xsl:template mode="BT-49"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
      <xr:Buyer_electronic_address>
         <xsl:attribute name="xr:id" select="'BT-49'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
		 <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.EAS"/>
		 <!-- End: Jan Thiele -->
      </xr:Buyer_electronic_address>
   </xsl:template>
   <xsl:template mode="BG-8"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-50" select="./cbc:StreetName"/>
         <xsl:apply-templates mode="BT-51" select="./cbc:AdditionalStreetName"/>
         <xsl:apply-templates mode="BT-163" select="./cac:AddressLine/cbc:Line"/>
         <xsl:apply-templates mode="BT-52" select="./cbc:CityName"/>
         <xsl:apply-templates mode="BT-53" select="./cbc:PostalZone"/>
         <xsl:apply-templates mode="BT-54" select="./cbc:CountrySubentity"/>
         <xsl:apply-templates mode="BT-55" select="./cac:Country/cbc:IdentificationCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:BUYER_POSTAL_ADDRESS>
            <xsl:attribute name="xr:id" select="'BG-8'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:BUYER_POSTAL_ADDRESS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-50"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName">
      <xr:Buyer_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-50'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-51"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName">
      <xr:Buyer_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-51'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-163"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line">
      <xr:Buyer_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-163'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-52"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName">
      <xr:Buyer_city>
         <xsl:attribute name="xr:id" select="'BT-52'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_city>
   </xsl:template>
   <xsl:template mode="BT-53"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone">
      <xr:Buyer_post_code>
         <xsl:attribute name="xr:id" select="'BT-53'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_post_code>
   </xsl:template>
   <xsl:template mode="BT-54"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity">
      <xr:Buyer_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-54'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-55"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
      <xr:Buyer_country_code>
         <xsl:attribute name="xr:id" select="'BT-55'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Country-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Buyer_country_code>
   </xsl:template>
   <xsl:template mode="BG-9"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-56" select="./cbc:Name"/>
         <xsl:apply-templates mode="BT-57" select="./cbc:Telephone"/>
         <xsl:apply-templates mode="BT-58" select="./cbc:ElectronicMail"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:BUYER_CONTACT>
            <xsl:attribute name="xr:id" select="'BG-9'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:BUYER_CONTACT>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-56"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name">
      <xr:Buyer_contact_point>
         <xsl:attribute name="xr:id" select="'BT-56'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_point>
   </xsl:template>
   <xsl:template mode="BT-57"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone">
      <xr:Buyer_contact_telephone_number>
         <xsl:attribute name="xr:id" select="'BT-57'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_telephone_number>
   </xsl:template>
   <xsl:template mode="BT-58"
      match="/Invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail">
      <xr:Buyer_contact_email_address>
         <xsl:attribute name="xr:id" select="'BT-58'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_email_address>
   </xsl:template>
   <xsl:template mode="BG-10" match="/Invoice:Invoice/cac:PayeeParty">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:PayeeParty der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-59" select="./cac:PartyName/cbc:Name"/>
         <xsl:apply-templates mode="BT-60" select="./cac:PartyIdentification/cbc:ID[not(@schemeID = 'SEPA')]"/>
         <xsl:apply-templates mode="BT-61" select="./cac:PartyLegalEntity/cbc:CompanyID"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PAYEE>
            <xsl:attribute name="xr:id" select="'BG-10'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PAYEE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-59" match="/Invoice:Invoice/cac:PayeeParty/cac:PartyName/cbc:Name">
      <xr:Payee_name>
         <xsl:attribute name="xr:id" select="'BT-59'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payee_name>
   </xsl:template>
   <xsl:template mode="BT-60" match="/Invoice:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID[not(@schemeID = 'SEPA')]">
      <xr:Payee_identifier>
         <xsl:attribute name="xr:id" select="'BT-60'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
		 <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Payee_identifier>
   </xsl:template>
   <xsl:template mode="BT-61"
      match="/Invoice:Invoice/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID">
      <xr:Payee_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-61'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
		 <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Payee_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BG-11" match="/Invoice:Invoice/cac:TaxRepresentativeParty">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:TaxRepresentativeParty der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-62" select="./cac:PartyName/cbc:Name"/>
         <xsl:apply-templates mode="BT-63"
            select="./cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
         <xsl:apply-templates mode="BG-12" select="./cac:PostalAddress"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SELLER_TAX_REPRESENTATIVE_PARTY>
            <xsl:attribute name="xr:id" select="'BG-11'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SELLER_TAX_REPRESENTATIVE_PARTY>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-62"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PartyName/cbc:Name">
      <xr:Seller_tax_representative_name>
         <xsl:attribute name="xr:id" select="'BT-62'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_tax_representative_name>
   </xsl:template>
   <xsl:template mode="BT-63"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']">
      <xr:Seller_tax_representative_VAT_identifier>
         <xsl:attribute name="xr:id" select="'BT-63'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Seller_tax_representative_VAT_identifier>
   </xsl:template>
   <xsl:template mode="BG-12" match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-64" select="./cbc:StreetName"/>
         <xsl:apply-templates mode="BT-65" select="./cbc:AdditionalStreetName"/>
         <xsl:apply-templates mode="BT-164" select="./cac:AddressLine/cbc:Line"/>
         <xsl:apply-templates mode="BT-66" select="./cbc:CityName"/>
         <xsl:apply-templates mode="BT-67" select="./cbc:PostalZone"/>
         <xsl:apply-templates mode="BT-68" select="./cbc:CountrySubentity"/>
         <xsl:apply-templates mode="BT-69" select="./cac:Country/cbc:IdentificationCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS>
            <xsl:attribute name="xr:id" select="'BG-12'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-64"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName">
      <xr:Tax_representative_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-64'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-65"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName">
      <xr:Tax_representative_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-65'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-164"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line">
      <xr:Tax_representative_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-164'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-66"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName">
      <xr:Tax_representative_city>
         <xsl:attribute name="xr:id" select="'BT-66'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_city>
   </xsl:template>
   <xsl:template mode="BT-67"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone">
      <xr:Tax_representative_post_code>
         <xsl:attribute name="xr:id" select="'BT-67'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_post_code>
   </xsl:template>
   <xsl:template mode="BT-68"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity">
      <xr:Tax_representative_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-68'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-69"
      match="/Invoice:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
      <xr:Tax_representative_country_code>
         <xsl:attribute name="xr:id" select="'BT-69'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Country-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Tax_representative_country_code>
   </xsl:template>
   <xsl:template mode="BG-13" match="/Invoice:Invoice/cac:Delivery">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:Delivery der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-70" select="./cac:DeliveryParty/cac:PartyName/cbc:Name"/>
         <xsl:apply-templates mode="BT-71" select="./cac:DeliveryLocation/cbc:ID"/>
         <xsl:apply-templates mode="BT-72" select="./cbc:ActualDeliveryDate"/>
         <!--<xsl:apply-templates mode="BG-14" select="/Invoice:Invoice/cac:InvoicePeriod"/>-->
         <xsl:apply-templates mode="BG-15" select="./cac:DeliveryLocation/cac:Address"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DELIVERY_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-13'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DELIVERY_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-70"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name">
      <xr:Deliver_to_party_name>
         <xsl:attribute name="xr:id" select="'BT-70'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_party_name>
   </xsl:template>
   <xsl:template mode="BT-71" match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cbc:ID">
      <xr:Deliver_to_location_identifier>
         <xsl:attribute name="xr:id" select="'BT-71'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Deliver_to_location_identifier>
   </xsl:template>
   <xsl:template mode="BT-72" match="/Invoice:Invoice/cac:Delivery/cbc:ActualDeliveryDate">
      <xr:Actual_delivery_date>
         <xsl:attribute name="xr:id" select="'BT-72'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Actual_delivery_date>
   </xsl:template>
   <xsl:template mode="BG-14" match="/Invoice:Invoice/cac:InvoicePeriod">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:InvoicePeriod der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-73" select="./cbc:StartDate"/>
         <xsl:apply-templates mode="BT-74" select="./cbc:EndDate"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICING_PERIOD>
            <xsl:attribute name="xr:id" select="'BG-14'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICING_PERIOD>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-73" match="/Invoice:Invoice/cac:InvoicePeriod/cbc:StartDate">
      <xr:Invoicing_period_start_date>
         <xsl:attribute name="xr:id" select="'BT-73'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoicing_period_start_date>
   </xsl:template>
   <xsl:template mode="BT-74" match="/Invoice:Invoice/cac:InvoicePeriod/cbc:EndDate">
      <xr:Invoicing_period_end_date>
         <xsl:attribute name="xr:id" select="'BT-74'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoicing_period_end_date>
   </xsl:template>
   <xsl:template mode="BG-15" match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-75" select="./cbc:StreetName"/>
         <xsl:apply-templates mode="BT-76" select="./cbc:AdditionalStreetName"/>
         <xsl:apply-templates mode="BT-165" select="./cac:AddressLine/cbc:Line"/>
         <xsl:apply-templates mode="BT-77" select="./cbc:CityName"/>
         <xsl:apply-templates mode="BT-78" select="./cbc:PostalZone"/>
         <xsl:apply-templates mode="BT-79" select="./cbc:CountrySubentity"/>
         <xsl:apply-templates mode="BT-80" select="./cac:Country/cbc:IdentificationCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DELIVER_TO_ADDRESS>
            <xsl:attribute name="xr:id" select="'BG-15'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DELIVER_TO_ADDRESS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-75"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName">
      <xr:Deliver_to_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-75'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-76"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName">
      <xr:Deliver_to_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-76'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-165"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line">
      <xr:Deliver_to_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-165'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-77"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName">
      <xr:Deliver_to_city>
         <xsl:attribute name="xr:id" select="'BT-77'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_city>
   </xsl:template>
   <xsl:template mode="BT-78"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone">
      <xr:Deliver_to_post_code>
         <xsl:attribute name="xr:id" select="'BT-78'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_post_code>
   </xsl:template>
   <xsl:template mode="BT-79"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity">
      <xr:Deliver_to_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-79'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-80"
      match="/Invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode">
      <xr:Deliver_to_country_code>
         <xsl:attribute name="xr:id" select="'BT-80'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Country-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Deliver_to_country_code>
   </xsl:template>
   <xsl:template mode="BT-81" match="/Invoice:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode">
      <xr:Payment_means_type_code>
         <xsl:attribute name="xr:id" select="'BT-81'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.4461">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Payment_means_type_code>
   </xsl:template>
   <xsl:template mode="BT-82" match="/Invoice:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode/@name">
      <xr:Payment_means_text>
         <xsl:attribute name="xr:id" select="'BT-82'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_means_text>
   </xsl:template>
   <xsl:template mode="BT-83" match="/Invoice:Invoice/cac:PaymentMeans/cbc:PaymentID">
      <xr:Remittance_information>
         <xsl:attribute name="xr:id" select="'BT-83'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Remittance_information>
   </xsl:template>
   <xsl:template mode="BG-17" match="/Invoice:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-84" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-85" select="./cbc:Name"/>
         <xsl:apply-templates mode="BT-86" select="./cac:FinancialInstitutionBranch/cbc:ID"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:CREDIT_TRANSFER>
            <xsl:attribute name="xr:id" select="'BG-17'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:CREDIT_TRANSFER>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-84"
      match="/Invoice:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID">
      <xr:Payment_account_identifier>
         <xsl:attribute name="xr:id" select="'BT-84'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payment_account_identifier>
   </xsl:template>
   <xsl:template mode="BT-85"
      match="/Invoice:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name">
      <xr:Payment_account_name>
         <xsl:attribute name="xr:id" select="'BT-85'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_account_name>
   </xsl:template>
   <xsl:template mode="BT-86"
      match="/Invoice:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID">
      <xr:Payment_service_provider_identifier>
         <xsl:attribute name="xr:id" select="'BT-86'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payment_service_provider_identifier>
   </xsl:template>
   <xsl:template mode="BG-18" match="/Invoice:Invoice/cac:PaymentMeans/cac:CardAccount">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:PaymentMeans/cac:CardAccount der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-87" select="./cbc:PrimaryAccountNumberID"/>
         <xsl:apply-templates mode="BT-88" select="./cbc:HolderName"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PAYMENT_CARD_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-18'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PAYMENT_CARD_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-87"
      match="/Invoice:Invoice/cac:PaymentMeans/cac:CardAccount/cbc:PrimaryAccountNumberID">
      <xr:Payment_card_primary_account_number>
         <xsl:attribute name="xr:id" select="'BT-87'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_card_primary_account_number>
   </xsl:template>
   <xsl:template mode="BT-88"
      match="/Invoice:Invoice/cac:PaymentMeans/cac:CardAccount/cbc:HolderName">
      <xr:Payment_card_holder_name>
         <xsl:attribute name="xr:id" select="'BT-88'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_card_holder_name>
   </xsl:template>
   <xsl:template mode="BG-19" match="/Invoice:Invoice/cac:PaymentMeans/cac:PaymentMandate">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:PaymentMeans/cac:PaymentMandate der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-89" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-90"
            select="/Invoice:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID = 'SEPA']"/>
         <xsl:apply-templates mode="BT-90"
            select="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID = 'SEPA']"/>
         <xsl:apply-templates mode="BT-91" select="./cac:PayerFinancialAccount/cbc:ID"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DIRECT_DEBIT>
            <xsl:attribute name="xr:id" select="'BG-19'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DIRECT_DEBIT>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-89" match="/Invoice:Invoice/cac:PaymentMeans/cac:PaymentMandate/cbc:ID">
      <xr:Mandate_reference_identifier>
         <xsl:attribute name="xr:id" select="'BT-89'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Mandate_reference_identifier>
   </xsl:template>
   <xsl:template mode="BT-90"
      match="/Invoice:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID = 'SEPA']">
      <xr:Bank_assigned_creditor_identifier>
         <xsl:attribute name="xr:id" select="'BT-90'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Bank_assigned_creditor_identifier>
   </xsl:template>
   <xsl:template mode="BT-90"
      match="/Invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID = 'SEPA']">
      <xr:Bank_assigned_creditor_identifier>
         <xsl:attribute name="xr:id" select="'BT-90'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Bank_assigned_creditor_identifier>
   </xsl:template>
   <xsl:template mode="BT-91"
      match="/Invoice:Invoice/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID">
      <xr:Debited_account_identifier>
         <xsl:attribute name="xr:id" select="'BT-91'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Debited_account_identifier>
   </xsl:template>
   <xsl:template mode="BG-20"
      match="/Invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-92"
            select="./cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-93"
            select="./cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-94"
            select="./cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-95"
            select="./cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
         <xsl:apply-templates mode="BT-96"
            select="./cac:TaxCategory/cbc:Percent[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-97"
            select="./cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-98"
            select="./cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'false']"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DOCUMENT_LEVEL_ALLOWANCES>
            <xsl:attribute name="xr:id" select="'BG-20'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DOCUMENT_LEVEL_ALLOWANCES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-92"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Document_level_allowance_amount>
         <xsl:attribute name="xr:id" select="'BT-92'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_allowance_amount>
   </xsl:template>
   <xsl:template mode="BT-93"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Document_level_allowance_base_amount>
         <xsl:attribute name="xr:id" select="'BT-93'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_allowance_base_amount>
   </xsl:template>
   <xsl:template mode="BT-94"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Document_level_allowance_percentage>
         <xsl:attribute name="xr:id" select="'BT-94'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_allowance_percentage>
   </xsl:template>
   <xsl:template mode="BT-95"
      match="/Invoice:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and following-sibling::cac:TaxScheme/cbc:ID = 'VAT']">
      <xr:Document_level_allowance_VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-95'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.5305">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Document_level_allowance_VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-96"
      match="/Invoice:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']">
      <xr:Document_level_allowance_VAT_rate>
         <xsl:attribute name="xr:id" select="'BT-96'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_allowance_VAT_rate>
   </xsl:template>
   <xsl:template mode="BT-97"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Document_level_allowance_reason>
         <xsl:attribute name="xr:id" select="'BT-97'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Document_level_allowance_reason>
   </xsl:template>
   <xsl:template mode="BT-98"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Document_level_allowance_reason_code>
         <xsl:attribute name="xr:id" select="'BT-98'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.5189">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Document_level_allowance_reason_code>
   </xsl:template>
   <xsl:template mode="BG-21"
      match="/Invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-99"
            select="./cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-100"
            select="./cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-101"
            select="./cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-102"
            select="./cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-103"
            select="./cac:TaxCategory/cbc:Percent[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-104"
            select="./cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-105"
            select="./cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'true']"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DOCUMENT_LEVEL_CHARGES>
            <xsl:attribute name="xr:id" select="'BG-21'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DOCUMENT_LEVEL_CHARGES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-99"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_amount>
         <xsl:attribute name="xr:id" select="'BT-99'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_charge_amount>
   </xsl:template>
   <xsl:template mode="BT-100"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_base_amount>
         <xsl:attribute name="xr:id" select="'BT-100'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_charge_base_amount>
   </xsl:template>
   <xsl:template mode="BT-101"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_percentage>
         <xsl:attribute name="xr:id" select="'BT-101'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_charge_percentage>
   </xsl:template>
   <xsl:template mode="BT-102"
      match="/Invoice:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-102'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.5305">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Document_level_charge_VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-103"
      match="/Invoice:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_VAT_rate>
         <xsl:attribute name="xr:id" select="'BT-103'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_charge_VAT_rate>
   </xsl:template>
   <xsl:template mode="BT-104"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_reason>
         <xsl:attribute name="xr:id" select="'BT-104'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Document_level_charge_reason>
   </xsl:template>
   <xsl:template mode="BT-105"
      match="/Invoice:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Document_level_charge_reason_code>
         <xsl:attribute name="xr:id" select="'BT-105'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.7161">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Document_level_charge_reason_code>
   </xsl:template>
   <xsl:template mode="BG-22" match="/Invoice:Invoice/cac:LegalMonetaryTotal">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:LegalMonetaryTotal der Instanz in konkreter Syntax wird auf 10 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-106" select="./cbc:LineExtensionAmount"/>
         <xsl:apply-templates mode="BT-107" select="./cbc:AllowanceTotalAmount"/>
         <xsl:apply-templates mode="BT-108" select="./cbc:ChargeTotalAmount"/>
         <xsl:apply-templates mode="BT-109" select="./cbc:TaxExclusiveAmount"/>
         <xsl:apply-templates mode="BT-110"
            select="/Invoice:Invoice/cac:TaxTotal/cbc:TaxAmount[/Invoice:Invoice/cbc:DocumentCurrencyCode = @currencyID]"/>
         <xsl:apply-templates mode="BT-111"
            select="/Invoice:Invoice/cac:TaxTotal/cbc:TaxAmount[/Invoice:Invoice/cbc:TaxCurrencyCode = @currencyID]"/>
         <xsl:apply-templates mode="BT-112" select="./cbc:TaxInclusiveAmount"/>
         <xsl:apply-templates mode="BT-113" select="./cbc:PrepaidAmount"/>
         <xsl:apply-templates mode="BT-114" select="./cbc:PayableRoundingAmount"/>
         <xsl:apply-templates mode="BT-115" select="./cbc:PayableAmount"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DOCUMENT_TOTALS>
            <xsl:attribute name="xr:id" select="'BG-22'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DOCUMENT_TOTALS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-106"
      match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount">
      <xr:Sum_of_Invoice_line_net_amount>
         <xsl:attribute name="xr:id" select="'BT-106'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Sum_of_Invoice_line_net_amount>
   </xsl:template>
   <xsl:template mode="BT-107"
      match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount">
      <xr:Sum_of_allowances_on_document_level>
         <xsl:attribute name="xr:id" select="'BT-107'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Sum_of_allowances_on_document_level>
   </xsl:template>
   <xsl:template mode="BT-108" match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount">
      <xr:Sum_of_charges_on_document_level>
         <xsl:attribute name="xr:id" select="'BT-108'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Sum_of_charges_on_document_level>
   </xsl:template>
   <xsl:template mode="BT-109"
      match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount">
      <xr:Invoice_total_amount_without_VAT>
         <xsl:attribute name="xr:id" select="'BT-109'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_amount_without_VAT>
   </xsl:template>
   <xsl:template mode="BT-110" match="/Invoice:Invoice/cac:TaxTotal/cbc:TaxAmount">
      <xr:Invoice_total_VAT_amount>
         <xsl:attribute name="xr:id" select="'BT-110'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_VAT_amount>
   </xsl:template>
   <xsl:template mode="BT-111" match="/Invoice:Invoice/cac:TaxTotal/cbc:TaxAmount">
      <xr:Invoice_total_VAT_amount_in_accounting_currency>
         <xsl:attribute name="xr:id" select="'BT-111'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_VAT_amount_in_accounting_currency>
   </xsl:template>
   <xsl:template mode="BT-112"
      match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
      <xr:Invoice_total_amount_with_VAT>
         <xsl:attribute name="xr:id" select="'BT-112'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_amount_with_VAT>
   </xsl:template>
   <xsl:template mode="BT-113" match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount">
      <xr:Paid_amount>
         <xsl:attribute name="xr:id" select="'BT-113'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Paid_amount>
   </xsl:template>
   <xsl:template mode="BT-114"
      match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount">
      <xr:Rounding_amount>
         <xsl:attribute name="xr:id" select="'BT-114'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Rounding_amount>
   </xsl:template>
   <xsl:template mode="BT-115" match="/Invoice:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount">
      <xr:Amount_due_for_payment>
         <xsl:attribute name="xr:id" select="'BT-115'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Amount_due_for_payment>
   </xsl:template>
   <xsl:template mode="BG-23" match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal der Instanz in konkreter Syntax wird auf 6 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-116" select="./cbc:TaxableAmount"/>
         <xsl:apply-templates mode="BT-117" select="./cbc:TaxAmount"/>
         <xsl:apply-templates mode="BT-118"
            select="./cac:TaxCategory/cbc:ID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
         <xsl:apply-templates mode="BT-119" select="./cac:TaxCategory/cbc:Percent"/>
         <xsl:apply-templates mode="BT-120" select="./cac:TaxCategory/cbc:TaxExemptionReason"/>
         <xsl:apply-templates mode="BT-121" select="./cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:VAT_BREAKDOWN>
            <xsl:attribute name="xr:id" select="'BG-23'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:VAT_BREAKDOWN>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-116"
      match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount">
      <xr:VAT_category_taxable_amount>
         <xsl:attribute name="xr:id" select="'BT-116'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:VAT_category_taxable_amount>
   </xsl:template>
   <xsl:template mode="BT-117" match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount">
      <xr:VAT_category_tax_amount>
         <xsl:attribute name="xr:id" select="'BT-117'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:VAT_category_tax_amount>
   </xsl:template>
   <xsl:template mode="BT-118"
      match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID[following-sibling::cac:TaxScheme/cbc:ID = 'VAT']">
      <xr:VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-118'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.5305">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-119"
      match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent">
      <xr:VAT_category_rate>
         <xsl:attribute name="xr:id" select="'BT-119'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:VAT_category_rate>
   </xsl:template>
   <xsl:template mode="BT-120"
      match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReason">
      <xr:VAT_exemption_reason_text>
         <xsl:attribute name="xr:id" select="'BT-120'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:VAT_exemption_reason_text>
   </xsl:template>
   <xsl:template mode="BT-121"
      match="/Invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode">
      <xr:VAT_exemption_reason_code>
         <xsl:attribute name="xr:id" select="'BT-121'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.VATEX">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:VAT_exemption_reason_code>
   </xsl:template>
   <xsl:template mode="BG-24" match="/Invoice:Invoice/cac:AdditionalDocumentReference">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:AdditionalDocumentReference der Instanz in konkreter Syntax wird auf 4 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-122" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-123" select="./cbc:DocumentDescription"/>
         <xsl:apply-templates mode="BT-124" select="./cac:Attachment/cac:ExternalReference/cbc:URI"/>
         <xsl:apply-templates mode="BT-125"
            select="./cac:Attachment/cbc:EmbeddedDocumentBinaryObject"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:ADDITIONAL_SUPPORTING_DOCUMENTS>
            <xsl:attribute name="xr:id" select="'BG-24'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:ADDITIONAL_SUPPORTING_DOCUMENTS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-122" match="/Invoice:Invoice/cac:AdditionalDocumentReference/cbc:ID">
      <xr:Supporting_document_reference>
         <xsl:attribute name="xr:id" select="'BT-122'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Supporting_document_reference>
   </xsl:template>
   <xsl:template mode="BT-123"
      match="/Invoice:Invoice/cac:AdditionalDocumentReference/cbc:DocumentDescription">
      <xr:Supporting_document_description>
         <xsl:attribute name="xr:id" select="'BT-123'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Supporting_document_description>
   </xsl:template>
   <xsl:template mode="BT-124"
      match="/Invoice:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
      <xr:External_document_location>
         <xsl:attribute name="xr:id" select="'BT-124'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:External_document_location>
   </xsl:template>
   <xsl:template mode="BT-125"
      match="/Invoice:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
      <xr:Attached_document>
         <xsl:attribute name="xr:id" select="'BT-125'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="binary_object"/>
      </xr:Attached_document>
   </xsl:template>
   <xsl:template mode="BG-25" match="/Invoice:Invoice/cac:InvoiceLine">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad /Invoice:Invoice/cac:InvoiceLine der Instanz in konkreter Syntax wird auf 15 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-126" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-127" select="./cbc:Note"/>
         <xsl:apply-templates mode="BT-128"
            select="./cac:DocumentReference/cbc:ID[following-sibling::cbc:DocumentTypeCode = '130']"/>
         <!-- Code "130" MUST be used to indicate an invoice object reference. Not used for other additional documents -->
         <xsl:apply-templates mode="BT-129" select="./cbc:InvoicedQuantity"/>
         <xsl:apply-templates mode="BT-130" select="./cbc:InvoicedQuantity/@unitCode"/>
         <xsl:apply-templates mode="BT-131" select="./cbc:LineExtensionAmount"/>
         <xsl:apply-templates mode="BT-132" select="./cac:OrderLineReference/cbc:LineID"/>
         <xsl:apply-templates mode="BT-133" select="./cbc:AccountingCost"/>
         <xsl:apply-templates mode="BG-26" select="./cac:InvoicePeriod"/>
         <xsl:apply-templates mode="BG-27"
            select="./cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BG-28"
            select="./cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BG-29" select="./cac:Price"/>
         <xsl:apply-templates mode="BG-30" select="./cac:Item/cac:ClassifiedTaxCategory"/>
         <xsl:apply-templates mode="BG-31" select="./cac:Item"/>
         <xsl:apply-templates mode="BG-DEX-01" select="cac:SubInvoiceLine"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_LINE>
            <xsl:attribute name="xr:id" select="'BG-25'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_LINE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-126" match="cbc:ID">
      <xr:Invoice_line_identifier>
         <xsl:attribute name="xr:id" select="'BT-126'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Invoice_line_identifier>
   </xsl:template>
   <xsl:template mode="BT-127" match="cbc:Note">
      <xr:Invoice_line_note>
         <xsl:attribute name="xr:id" select="'BT-127'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_note>
   </xsl:template>
   <xsl:template mode="BT-128"
      match="cac:DocumentReference/cbc:ID[following-sibling::cbc:DocumentTypeCode = '130']">
      <xr:Invoice_line_object_identifier>
         <xsl:attribute name="xr:id" select="'BT-128'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
		 <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.1153"/>
		 <!-- End: Jan Thiele -->
      </xr:Invoice_line_object_identifier>
   </xsl:template>
   <xsl:template mode="BT-129" match="cbc:InvoicedQuantity">
      <xr:Invoiced_quantity>
         <xsl:attribute name="xr:id" select="'BT-129'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="quantity"/>
      </xr:Invoiced_quantity>
   </xsl:template>
   <xsl:template mode="BT-130" match="cbc:InvoicedQuantity/@unitCode">
      <xr:Invoiced_quantity_unit_of_measure_code>
         <xsl:attribute name="xr:id" select="'BT-130'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.rec21">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Invoiced_quantity_unit_of_measure_code>
   </xsl:template>
   <xsl:template mode="BT-131" match="cbc:LineExtensionAmount">
      <xr:Invoice_line_net_amount>
         <xsl:attribute name="xr:id" select="'BT-131'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_net_amount>
   </xsl:template>
   <xsl:template mode="BT-132" match="cac:OrderLineReference/cbc:LineID">
      <xr:Referenced_purchase_order_line_reference>
         <xsl:attribute name="xr:id" select="'BT-132'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Referenced_purchase_order_line_reference>
   </xsl:template>
   <xsl:template mode="BT-133" match="cbc:AccountingCost">
      <xr:Invoice_line_Buyer_accounting_reference>
         <xsl:attribute name="xr:id" select="'BT-133'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_Buyer_accounting_reference>
   </xsl:template>
   <xsl:template mode="BG-26" match="cac:InvoicePeriod">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:InvoicePeriod der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-134" select="./cbc:StartDate"/>
         <xsl:apply-templates mode="BT-135" select="./cbc:EndDate"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_LINE_PERIOD>
            <xsl:attribute name="xr:id" select="'BG-26'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_LINE_PERIOD>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-134" match="cac:InvoicePeriod/cbc:StartDate">
      <xr:Invoice_line_period_start_date>
         <xsl:attribute name="xr:id" select="'BT-134'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoice_line_period_start_date>
   </xsl:template>
   <xsl:template mode="BT-135" match="cac:InvoicePeriod/cbc:EndDate">
      <xr:Invoice_line_period_end_date>
         <xsl:attribute name="xr:id" select="'BT-135'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoice_line_period_end_date>
   </xsl:template>
   <xsl:template mode="BG-27" match="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-136"
            select="./cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-137"
            select="./cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-138"
            select="./cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-139"
            select="./cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-140"
            select="./cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'false']"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_LINE_ALLOWANCES>
            <xsl:attribute name="xr:id" select="'BG-27'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_LINE_ALLOWANCES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-136"
      match="cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Invoice_line_allowance_amount>
         <xsl:attribute name="xr:id" select="'BT-136'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_allowance_amount>
   </xsl:template>
   <xsl:template mode="BT-137"
      match="cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Invoice_line_allowance_base_amount>
         <xsl:attribute name="xr:id" select="'BT-137'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_allowance_base_amount>
   </xsl:template>
   <xsl:template mode="BT-138"
      match="cac:AllowanceCharge/cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Invoice_line_allowance_percentage>
         <xsl:attribute name="xr:id" select="'BT-138'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Invoice_line_allowance_percentage>
   </xsl:template>
   <xsl:template mode="BT-139"
      match="cac:AllowanceCharge/cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Invoice_line_allowance_reason>
         <xsl:attribute name="xr:id" select="'BT-139'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_allowance_reason>
   </xsl:template>
   <xsl:template mode="BT-140"
      match="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Invoice_line_allowance_reason_code>
         <xsl:attribute name="xr:id" select="'BT-140'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.5189">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Invoice_line_allowance_reason_code>
   </xsl:template>
   <xsl:template mode="BG-28" match="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-141"
            select="./cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-142"
            select="./cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-143"
            select="./cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-144"
            select="./cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-145"
            select="./cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'true']"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_LINE_CHARGES>
            <xsl:attribute name="xr:id" select="'BG-28'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_LINE_CHARGES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-141"
      match="cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Invoice_line_charge_amount>
         <xsl:attribute name="xr:id" select="'BT-141'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_charge_amount>
   </xsl:template>
   <xsl:template mode="BT-142"
      match="cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Invoice_line_charge_base_amount>
         <xsl:attribute name="xr:id" select="'BT-142'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_charge_base_amount>
   </xsl:template>
   <xsl:template mode="BT-143"
      match="cac:AllowanceCharge/cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Invoice_line_charge_percentage>
         <xsl:attribute name="xr:id" select="'BT-143'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Invoice_line_charge_percentage>
   </xsl:template>
   <xsl:template mode="BT-144"
      match="cac:AllowanceCharge/cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Invoice_line_charge_reason>
         <xsl:attribute name="xr:id" select="'BT-144'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_charge_reason>
   </xsl:template>
   <xsl:template mode="BT-145"
      match="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'true']">
      <xr:Invoice_line_charge_reason_code>
         <xsl:attribute name="xr:id" select="'BT-145'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.7161">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Invoice_line_charge_reason_code>
   </xsl:template>
   <xsl:template mode="BG-29" match="cac:Price">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:Price der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-146" select="./cbc:PriceAmount"/>
         <xsl:apply-templates mode="BT-147"
            select="./cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-148"
            select="./cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-149" select="./cbc:BaseQuantity"/>
         <xsl:apply-templates mode="BT-150" select="./cbc:BaseQuantity/@unitCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PRICE_DETAILS>
            <xsl:attribute name="xr:id" select="'BG-29'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PRICE_DETAILS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-146" match="cac:Price/cbc:PriceAmount">
      <xr:Item_net_price>
         <xsl:attribute name="xr:id" select="'BT-146'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="unit_price_amount"/>
      </xr:Item_net_price>
   </xsl:template>
   <xsl:template mode="BT-147"
      match="cac:Price/cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Item_price_discount>
         <xsl:attribute name="xr:id" select="'BT-147'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="unit_price_amount"/>
      </xr:Item_price_discount>
   </xsl:template>
   <xsl:template mode="BT-148"
      match="cac:Price/cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']">
      <xr:Item_gross_price>
         <xsl:attribute name="xr:id" select="'BT-148'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="unit_price_amount"/>
      </xr:Item_gross_price>
   </xsl:template>
   <xsl:template mode="BT-149" match="cac:Price/cbc:BaseQuantity">
      <xr:Item_price_base_quantity>
         <xsl:attribute name="xr:id" select="'BT-149'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="quantity"/>
      </xr:Item_price_base_quantity>
   </xsl:template>
   <xsl:template mode="BT-150" match="cac:Price/cbc:BaseQuantity/@unitCode">
      <xr:Item_price_base_quantity_unit_of_measure>
         <xsl:attribute name="xr:id" select="'BT-150'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.rec21">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>			 
		 <!-- End: Jan Thiele -->
      </xr:Item_price_base_quantity_unit_of_measure>
   </xsl:template>
   <xsl:template mode="BG-30" match="cac:Item/cac:ClassifiedTaxCategory">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:Item/cac:ClassifiedTaxCategory der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-151" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-152" select="./cbc:Percent"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:LINE_VAT_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-30'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:LINE_VAT_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-151" match="cac:Item/cac:ClassifiedTaxCategory/cbc:ID">
      <xr:Invoiced_item_VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-151'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.UNTDID.5305">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Invoiced_item_VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-152" match="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent">
      <xr:Invoiced_item_VAT_rate>
         <xsl:attribute name="xr:id" select="'BT-152'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Invoiced_item_VAT_rate>
   </xsl:template>
   <xsl:template mode="BG-31" match="cac:Item">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:Item der Instanz in konkreter Syntax wird auf 8 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-153" select="./cbc:Name"/>
         <xsl:apply-templates mode="BT-154" select="./cbc:Description"/>
         <xsl:apply-templates mode="BT-155" select="./cac:SellersItemIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-156" select="./cac:BuyersItemIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-157" select="./cac:StandardItemIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-158"
            select="./cac:CommodityClassification/cbc:ItemClassificationCode"/>
         <xsl:apply-templates mode="BT-159" select="./cac:OriginCountry/cbc:IdentificationCode"/>
         <xsl:apply-templates mode="BG-32" select="./cac:AdditionalItemProperty"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:ITEM_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-31'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:ITEM_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-153" match="cac:Item/cbc:Name">
      <xr:Item_name>
         <xsl:attribute name="xr:id" select="'BT-153'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_name>
   </xsl:template>
   <xsl:template mode="BT-154" match="cac:Item/cbc:Description">
      <xr:Item_description>
         <xsl:attribute name="xr:id" select="'BT-154'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_description>
   </xsl:template>
   <xsl:template mode="BT-155" match="cac:Item/cac:SellersItemIdentification/cbc:ID">
      <xr:Item_Sellers_identifier>
         <xsl:attribute name="xr:id" select="'BT-155'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Item_Sellers_identifier>
   </xsl:template>
   <xsl:template mode="BT-156" match="cac:Item/cac:BuyersItemIdentification/cbc:ID">
      <xr:Item_Buyers_identifier>
         <xsl:attribute name="xr:id" select="'BT-156'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Item_Buyers_identifier>
   </xsl:template>
   <xsl:template mode="BT-157" match="cac:Item/cac:StandardItemIdentification/cbc:ID">
      <xr:Item_standard_identifier>
         <xsl:attribute name="xr:id" select="'BT-157'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
		 <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.6523"/>
		 <!-- End: Jan Thiele -->
      </xr:Item_standard_identifier>
   </xsl:template>
   <xsl:template mode="BT-158"
      match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
      <xr:Item_classification_identifier>
         <xsl:attribute name="xr:id" select="'BT-158'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="identifier"/>-->
         <!-- Begin: Jan Thiele -->
         <xsl:call-template name="identifier.7143"/>
		 <!-- End: Jan Thiele -->
      </xr:Item_classification_identifier>
   </xsl:template>
   <xsl:template mode="BT-159" match="cac:Item/cac:OriginCountry/cbc:IdentificationCode">
      <xr:Item_country_of_origin>
         <xsl:attribute name="xr:id" select="'BT-159'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <!--<xsl:call-template name="code"/>-->
		 <!-- Begin: Jan Thiele -->
		 <xsl:call-template name="code.Country-Codes">
			<xsl:with-param name="myparam" select="."/>			
		 </xsl:call-template>		 
		 <!-- End: Jan Thiele -->
      </xr:Item_country_of_origin>
   </xsl:template>
   <xsl:template mode="BG-32" match="cac:Item/cac:AdditionalItemProperty">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:Item/cac:AdditionalItemProperty der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-160" select="./cbc:Name"/>
         <xsl:apply-templates mode="BT-161" select="./cbc:Value"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:ITEM_ATTRIBUTES>
            <xsl:attribute name="xr:id" select="'BG-32'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:ITEM_ATTRIBUTES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-160" match="cac:Item/cac:AdditionalItemProperty/cbc:Name">
      <xr:Item_attribute_name>
         <xsl:attribute name="xr:id" select="'BT-160'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_attribute_name>
   </xsl:template>
   <xsl:template mode="BT-161" match="cac:Item/cac:AdditionalItemProperty/cbc:Value">
      <xr:Item_attribute_value>
         <xsl:attribute name="xr:id" select="'BT-161'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_attribute_value>
   </xsl:template>
   <xsl:template mode="BG-DEX-01" match="cac:SubInvoiceLine">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine der Instanz in konkreter Syntax wird auf 14 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-126" select="./cbc:ID"/>
         <xsl:apply-templates mode="BT-127" select="./cbc:Note"/>
         <xsl:apply-templates mode="BT-128"
            select="./cac:DocumentReference/cbc:ID[following-sibling::cbc:DocumentTypeCode = '130']"/>
         <xsl:apply-templates mode="BT-129" select="./cbc:InvoicedQuantity"/>
         <xsl:apply-templates mode="BT-130" select="./cbc:InvoicedQuantity/@unitCode"/>
         <xsl:apply-templates mode="BT-131" select="./cbc:LineExtensionAmount"/>
         <xsl:apply-templates mode="BT-132" select="./cac:OrderLineReference/cbc:LineID"/>
         <xsl:apply-templates mode="BT-133" select="./cbc:AccountingCost"/>
         <xsl:apply-templates mode="BG-26" select="./cac:InvoicePeriod"/>
         <xsl:apply-templates mode="BG-27"
            select="./cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BG-28"
            select="./cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BG-29" select="./cac:Price"/>
         <xsl:apply-templates mode="BG-30" select="./cac:Item/cac:ClassifiedTaxCategory"/>
         <xsl:apply-templates mode="BG-31" select="./cac:Item"/>
         <xsl:apply-templates mode="BG-DEX-01" select="cac:SubInvoiceLine"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_LINE>
            <xsl:attribute name="xr:id" select="'BG-DEX-01'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_LINE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-02" match="cac:SubInvoiceLine/cac:Item">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:Item der Instanz in konkreter Syntax wird auf 8 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-153" select="cac:Item/cbc:Name"/>
         <xsl:apply-templates mode="BT-154" select="cac:Item/cbc:Description"/>
         <xsl:apply-templates mode="BT-155" select="cac:Item/cac:SellersItemIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-156" select="cac:Item/cac:BuyersItemIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-157" select="cac:Item/cac:StandardItemIdentification/cbc:ID"/>
         <xsl:apply-templates mode="BT-158"
            select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>
         <xsl:apply-templates mode="BT-159"
            select="cac:Item/cac:OriginCountry/cbc:IdentificationCode"/>
         <xsl:apply-templates mode="BG-DEX-08" select="cac:Item/cac:AdditionalItemProperty"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_ITEM_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-DEX-02'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_ITEM_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-08" match="cac:SubInvoiceLine/cac:Item/cac:AdditionalItemProperty">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:Item/cac:AdditionalItemProperty der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-160" select="cac:Item/cac:AdditionalItemProperty/cbc:Name"/>
         <xsl:apply-templates mode="BT-161" select="cac:Item/cac:AdditionalItemProperty/cbc:Value"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_ITEM_ATTRIBUTES>
            <xsl:attribute name="xr:id" select="'BG-DEX-08'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_ITEM_ATTRIBUTES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-03"
      match="cac:SubInvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-136"
            select="cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-137"
            select="cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-138"
            select="cac:AllowanceCharge/cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-139"
            select="cac:AllowanceCharge/cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-140"
            select="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'false']"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_LINE_ALLOWANCES>
            <xsl:attribute name="xr:id" select="'BG-DEX-03'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_LINE_ALLOWANCES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-04"
      match="cac:SubInvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-141"
            select="cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-142"
            select="cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-143"
            select="cac:AllowanceCharge/cbc:MultiplierFactorNumeric[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-144"
            select="cac:AllowanceCharge/cbc:AllowanceChargeReason[preceding-sibling::cbc:ChargeIndicator = 'true']"/>
         <xsl:apply-templates mode="BT-145"
            select="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[preceding-sibling::cbc:ChargeIndicator = 'true']"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_LINE_CHARGES>
            <xsl:attribute name="xr:id" select="'BG-DEX-04'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_LINE_CHARGES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-05" match="cac:SubInvoiceLine/cac:InvoicePeriod">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:InvoicePeriod der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-134" select="cac:InvoicePeriod/cbc:StartDate"/>
         <xsl:apply-templates mode="BT-135" select="cac:InvoicePeriod/cbc:EndDate"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_LINE_PERIOD>
            <xsl:attribute name="xr:id" select="'BG-DEX-05'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_LINE_PERIOD>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-06" match="cac:SubInvoiceLine/cac:ClassifiedTaxCategory">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:ClassifiedTaxCategory der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-151" select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
         <xsl:apply-templates mode="BT-152" select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"
         />
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_LINE_VAT_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-DEX-06'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_LINE_VAT_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-07" match="cac:SubInvoiceLine/cac:Price">
      <xsl:variable name="bg-contents" as="item()*">
         <!--Der Pfad cac:SubInvoiceLine/cac:Price der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-146" select="cac:Price/cbc:PriceAmount"/>
         <xsl:apply-templates mode="BT-147"
            select="cac:Price/cac:AllowanceCharge/cbc:Amount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-148"
            select="cac:Price/cac:AllowanceCharge/cbc:BaseAmount[preceding-sibling::cbc:ChargeIndicator = 'false']"/>
         <xsl:apply-templates mode="BT-149" select="cac:Price/cbc:BaseQuantity"/>
         <xsl:apply-templates mode="BT-150" select="cac:Price/cbc:BaseQuantity/@unitCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:SUB_INVOICE_PRICE_DETAILS>
            <xsl:attribute name="xr:id" select="'BG-DEX-07'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:SUB_INVOICE_PRICE_DETAILS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BG-DEX-09" match="cac:PrepaidPayment">
      <xsl:variable name="bg-contents" as="item()*">         
         <xsl:apply-templates mode="BT-DEX-001" select="cbc:ID"/>
         <xsl:apply-templates mode="BT-DEX-002" select="cbc:PaidAmount"/>
         <xsl:apply-templates mode="BT-DEX-003" select="cbc:InstructionID"/>   
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:THIRD_PARTY_PAYMENT>
            <xsl:attribute name="xr:id" select="'BG-DEX-09'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:THIRD_PARTY_PAYMENT>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-DEX-001" match="cbc:ID">
      <xr:Third_party_payment_type>
         <xsl:attribute name="xr:id" select="'BT-DEX-001'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Third_party_payment_type>
   </xsl:template>
   <xsl:template mode="BT-DEX-002" match="cbc:PaidAmount">
      <xr:Third_party_payment_amount>
         <xsl:attribute name="xr:id" select="'BT-DEX-002'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Third_party_payment_amount>
   </xsl:template>
   <xsl:template mode="BT-DEX-003" match="cbc:InstructionID">
      <xr:Third_party_payment_description>
         <xsl:attribute name="xr:id" select="'BT-DEX-003'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Third_party_payment_description>
   </xsl:template>
</xsl:stylesheet>
