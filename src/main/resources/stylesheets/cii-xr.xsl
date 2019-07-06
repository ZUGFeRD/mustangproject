<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
                xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
                xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
                xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
                xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
                xmlns:saxon="http://saxon.sf.net/"
                exclude-result-prefixes="#all"
                version="2.0">
   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p>
            <xd:b>Author:</xd:b> KoSIT Bremen (kosit@finanzen.bremen.de)</xd:p>
         <xd:b>Fassung vom: 2019-03-18+01:00</xd:b>
         <xd:p>Überführt eine zur EN 16931 konforme elektronische Rechnung in der konkreten Syntax UNCEFACT.CII.D16B in eine Instanz gemäß des Schemas für den Namensraum urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1.</xd:p>
         <xd:p>Das Skript setzt voraus, dass das zu verarbeitende Dokument valide bzgl. des XML Schemas und der Schematron-Regeln der Quelle ist. Für nicht valide Dokumente ist das Ergebnis nicht definiert.</xd:p>
      </xd:desc>
   </xd:doc>

   <xsl:output method="xml" indent="yes"/>

   <xsl:template match="/rsm:CrossIndustryInvoice">
      <xr:invoice>
         <xsl:variable name="current-bg" as="element()" select="."/>
         <xsl:apply-templates mode="BT-1" select="./rsm:ExchangedDocument/ram:ID"/>
         <xsl:apply-templates mode="BT-2"
                              select="./rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format = '102']"/>
         <xsl:apply-templates mode="BT-3" select="./rsm:ExchangedDocument/ram:TypeCode"/>
         <xsl:apply-templates mode="BT-5"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
         <xsl:apply-templates mode="BT-6"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode"/>
         <xsl:apply-templates mode="BT-7"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString[@format = '102']"/>
         <xsl:apply-templates mode="BT-8"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode"/>
         <xsl:apply-templates mode="BT-9"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString[@format = '102']"/>
         <xsl:apply-templates mode="BT-10"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference"/>
         <xsl:apply-templates mode="BT-11"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID"/>
         <xsl:apply-templates mode="BT-12"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID"/>
         <xsl:apply-templates mode="BT-13"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID"/>
         <xsl:apply-templates mode="BT-14"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID"/>
         <xsl:apply-templates mode="BT-15"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID"/>
         <xsl:apply-templates mode="BT-16"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID"/>
         <xsl:apply-templates mode="BT-17"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='50']"/>
         <xsl:apply-templates mode="BT-18"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='130']"/>
         <xsl:apply-templates mode="BT-19"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID"/>
         <xsl:apply-templates mode="BT-20"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description"/>
         <xsl:apply-templates mode="BG-1" select="./rsm:ExchangedDocument/ram:IncludedNote"/>
         <xsl:apply-templates mode="BG-2" select="./rsm:ExchangedDocumentContext"/>
         <xsl:apply-templates mode="BG-3"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument"/>
         <xsl:apply-templates mode="BG-4"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"/>
         <xsl:apply-templates mode="BG-7"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"/>
         <xsl:apply-templates mode="BG-10"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty"/>
         <xsl:apply-templates mode="BG-11"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty"/>
         <xsl:apply-templates mode="BG-13"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty"/>
         <!--Manuell: angepasst für BG-16-->
         <xsl:for-each-group select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans"
                             group-by="ram:TypeCode">
            <xr:PAYMENT_INSTRUCTIONS>
               <xsl:attribute name="xr:id" select="'BG-16'"/>
               <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
               <xsl:apply-templates mode="BT-81" select="current-group()[1]/ram:TypeCode"/>
               <xsl:apply-templates mode="BT-82" select="./ram:Information"/>
               <xsl:apply-templates mode="BT-83"
                                    select="current-group()[1]/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference"/>
               <xsl:apply-templates mode="BG-17"
                                    select="current-group()/ram:PayeePartyCreditorFinancialAccount"/>
               <xsl:apply-templates mode="BG-18"
                                    select="current-group()/ram:ApplicableTradeSettlementFinancialCard"/>
               <xsl:apply-templates mode="BG-19"
                                    select="current-group()/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement"/>
            </xr:PAYMENT_INSTRUCTIONS>
         </xsl:for-each-group>
         <xsl:apply-templates mode="BG-20"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='false']"/>
         <xsl:apply-templates mode="BG-21"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='true']"/>
         <xsl:apply-templates mode="BG-22"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation"/>
         <xsl:apply-templates mode="BG-23"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax"/>
         <xsl:apply-templates mode="BG-24"
                              select="./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument"/>
         <xsl:apply-templates mode="BG-25"
                              select="./rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"/>
      </xr:invoice>
   </xsl:template>
   <xsl:template mode="BT-1"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID">
      <xr:Invoice_number>
         <xsl:attribute name="xr:id" select="'BT-1'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Invoice_number>
   </xsl:template>
   <xsl:template mode="BT-2"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format = '102']">
      <xr:Invoice_issue_date>
         <xsl:attribute name="xr:id" select="'BT-2'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoice_issue_date>
   </xsl:template>
   <xsl:template mode="BT-3"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <xr:Invoice_type_code>
         <xsl:attribute name="xr:id" select="'BT-3'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoice_type_code>
   </xsl:template>
   <xsl:template mode="BT-5"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
      <xr:Invoice_currency_code>
         <xsl:attribute name="xr:id" select="'BT-5'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoice_currency_code>
   </xsl:template>
   <xsl:template mode="BT-6"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
      <xr:VAT_accounting_currency_code>
         <xsl:attribute name="xr:id" select="'BT-6'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:VAT_accounting_currency_code>
   </xsl:template>
   <xsl:template mode="BT-7"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString[@format = '102']">
      <xr:Value_added_tax_point_date>
         <xsl:attribute name="xr:id" select="'BT-7'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Value_added_tax_point_date>
   </xsl:template>
   <xsl:template mode="BT-8"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <xr:Value_added_tax_point_date_code>
         <xsl:attribute name="xr:id" select="'BT-8'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Value_added_tax_point_date_code>
   </xsl:template>
   <xsl:template mode="BT-9"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString[@format = '102']">
      <xr:Payment_due_date>
         <xsl:attribute name="xr:id" select="'BT-9'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Payment_due_date>
   </xsl:template>
   <xsl:template mode="BT-10"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference">
      <xr:Buyer_reference>
         <xsl:attribute name="xr:id" select="'BT-10'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_reference>
   </xsl:template>
   <xsl:template mode="BT-11"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID">
      <xr:Project_reference>
         <xsl:attribute name="xr:id" select="'BT-11'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Project_reference>
   </xsl:template>
   <xsl:template mode="BT-12"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID">
      <xr:Contract_reference>
         <xsl:attribute name="xr:id" select="'BT-12'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Contract_reference>
   </xsl:template>
   <xsl:template mode="BT-13"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
      <xr:Purchase_order_reference>
         <xsl:attribute name="xr:id" select="'BT-13'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Purchase_order_reference>
   </xsl:template>
   <xsl:template mode="BT-14"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID">
      <xr:Sales_order_reference>
         <xsl:attribute name="xr:id" select="'BT-14'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Sales_order_reference>
   </xsl:template>
   <xsl:template mode="BT-15"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID">
      <xr:Receiving_advice_reference>
         <xsl:attribute name="xr:id" select="'BT-15'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Receiving_advice_reference>
   </xsl:template>
   <xsl:template mode="BT-16"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID">
      <xr:Despatch_advice_reference>
         <xsl:attribute name="xr:id" select="'BT-16'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Despatch_advice_reference>
   </xsl:template>
   <xsl:template mode="BT-17"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='50']">
      <xr:Tender_or_lot_reference>
         <xsl:attribute name="xr:id" select="'BT-17'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Tender_or_lot_reference>
   </xsl:template>
   <xsl:template mode="BT-18"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='130']">
      <xr:Invoiced_object_identifier>
         <xsl:attribute name="xr:id" select="'BT-18'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme">
            <xsl:with-param name="schemeID" select="following-sibling::ram:ReferenceTypeCode"/>
         </xsl:call-template>
      </xr:Invoiced_object_identifier>
   </xsl:template>
   <xsl:template mode="BT-19"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <xr:Buyer_accounting_reference>
         <xsl:attribute name="xr:id" select="'BT-19'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_accounting_reference>
   </xsl:template>
   <xsl:template mode="BT-20"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description">
      <xr:Payment_terms>
         <xsl:attribute name="xr:id" select="'BT-20'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_terms>
   </xsl:template>
   <xsl:template mode="BG-1"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-21" select="./ram:SubjectCode"/>
         <xsl:apply-templates mode="BT-22" select="./ram:Content"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_NOTE>
            <xsl:attribute name="xr:id" select="'BG-1'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_NOTE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-21"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode">
      <xr:Invoice_note_subject_code>
         <xsl:attribute name="xr:id" select="'BT-21'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoice_note_subject_code>
   </xsl:template>
   <xsl:template mode="BT-22"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Content">
      <xr:Invoice_note>
         <xsl:attribute name="xr:id" select="'BT-22'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_note>
   </xsl:template>
   <xsl:template mode="BG-2"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-23"
                              select="./ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
         <xsl:apply-templates mode="BT-24"
                              select="./ram:GuidelineSpecifiedDocumentContextParameter/ram:ID"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PROCESS_CONTROL>
            <xsl:attribute name="xr:id" select="'BG-2'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PROCESS_CONTROL>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-23"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID">
      <xr:Business_process_type>
         <xsl:attribute name="xr:id" select="'BT-23'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Business_process_type>
   </xsl:template>
   <xsl:template mode="BT-24"
                 match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID">
      <xr:Specification_identifier>
         <xsl:attribute name="xr:id" select="'BT-24'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Specification_identifier>
   </xsl:template>
   <xsl:template mode="BG-3"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-25" select="./ram:IssuerAssignedID"/>
         <xsl:apply-templates mode="BT-26"
                              select="./ram:FormattedIssueDateTime/qdt:DateTimeString[@format = '102']"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <xr:Preceding_Invoice_reference>
         <xsl:attribute name="xr:id" select="'BT-25'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Preceding_Invoice_reference>
   </xsl:template>
   <xsl:template mode="BT-26"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString[@format = '102']">
      <xr:Preceding_Invoice_issue_date>
         <xsl:attribute name="xr:id" select="'BT-26'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Preceding_Invoice_issue_date>
   </xsl:template>
   <xsl:template mode="BG-4"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty der Instanz in konkreter Syntax wird auf 10 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-27" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-28"
                              select="./ram:SpecifiedLegalOrganization/ram:TradingBusinessName"/>
         <xsl:apply-templates mode="BT-29" select="./ram:GlobalID[exists(@schemeID)]"/>
         <xsl:apply-templates mode="BT-29"
                              select="./ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]"/>
         <xsl:apply-templates mode="BT-30" select="./ram:SpecifiedLegalOrganization/ram:ID"/>
         <xsl:apply-templates mode="BT-31"
                              select="./ram:SpecifiedTaxRegistration/ram:ID[@schemeID=('VA', 'VAT')]"/>
         <xsl:apply-templates mode="BT-32"
                              select="./ram:SpecifiedTaxRegistration/ram:ID[@schemeID='FC']"/>
         <xsl:apply-templates mode="BT-33" select="./ram:Description"/>
         <xsl:apply-templates mode="BT-34" select="./ram:URIUniversalCommunication/ram:URIID"/>
         <xsl:apply-templates mode="BG-5" select="./ram:PostalTradeAddress"/>
         <xsl:apply-templates mode="BG-6" select="./ram:DefinedTradeContact"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name">
      <xr:Seller_name>
         <xsl:attribute name="xr:id" select="'BT-27'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_name>
   </xsl:template>
   <xsl:template mode="BT-28"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
      <xr:Seller_trading_name>
         <xsl:attribute name="xr:id" select="'BT-28'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_trading_name>
   </xsl:template>
   <xsl:template mode="BT-29"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[exists(@schemeID)]">
      <xr:Seller_identifier>
         <xsl:attribute name="xr:id" select="'BT-29'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Seller_identifier>
   </xsl:template>
   <xsl:template mode="BT-29"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]">
      <xr:Seller_identifier>
         <xsl:attribute name="xr:id" select="'BT-29'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Seller_identifier>
   </xsl:template>
   <xsl:template mode="BT-30"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <xr:Seller_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-30'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Seller_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-31"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID=('VA', 'VAT')]">
      <xr:Seller_VAT_identifier>
         <xsl:attribute name="xr:id" select="'BT-31'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Seller_VAT_identifier>
   </xsl:template>
   <xsl:template mode="BT-32"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID='FC']">
      <xr:Seller_tax_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-32'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Seller_tax_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-33"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Description">
      <xr:Seller_additional_legal_information>
         <xsl:attribute name="xr:id" select="'BT-33'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_additional_legal_information>
   </xsl:template>
   <xsl:template mode="BT-34"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <xr:Seller_electronic_address>
         <xsl:attribute name="xr:id" select="'BT-34'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Seller_electronic_address>
   </xsl:template>
   <xsl:template mode="BG-5"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-35" select="./ram:LineOne"/>
         <xsl:apply-templates mode="BT-36" select="./ram:LineTwo"/>
         <xsl:apply-templates mode="BT-162" select="./ram:LineThree"/>
         <xsl:apply-templates mode="BT-37" select="./ram:CityName"/>
         <xsl:apply-templates mode="BT-38" select="./ram:PostcodeCode"/>
         <xsl:apply-templates mode="BT-39" select="./ram:CountrySubDivisionName"/>
         <xsl:apply-templates mode="BT-40" select="./ram:CountryID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineOne">
      <xr:Seller_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-35'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-36"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineTwo">
      <xr:Seller_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-36'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-162"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineThree">
      <xr:Seller_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-162'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-37"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CityName">
      <xr:Seller_city>
         <xsl:attribute name="xr:id" select="'BT-37'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_city>
   </xsl:template>
   <xsl:template mode="BT-38"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <xr:Seller_post_code>
         <xsl:attribute name="xr:id" select="'BT-38'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_post_code>
   </xsl:template>
   <xsl:template mode="BT-39"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName">
      <xr:Seller_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-39'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-40"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <xr:Seller_country_code>
         <xsl:attribute name="xr:id" select="'BT-40'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Seller_country_code>
   </xsl:template>
   <xsl:template mode="BG-6"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-41" select="./ram:DepartmentName"/>
         <xsl:apply-templates mode="BT-41" select="./ram:PersonName"/>
         <xsl:apply-templates mode="BT-42"
                              select="./ram:TelephoneUniversalCommunication/ram:CompleteNumber"/>
         <xsl:apply-templates mode="BT-43" select="./ram:EmailURIUniversalCommunication/ram:URIID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:DepartmentName">
      <xr:Seller_contact_point>
         <xsl:attribute name="xr:id" select="'BT-41'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_point>
   </xsl:template>
   <xsl:template mode="BT-41"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:PersonName">
      <xr:Seller_contact_point>
         <xsl:attribute name="xr:id" select="'BT-41'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_point>
   </xsl:template>
   <xsl:template mode="BT-42"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:CompleteNumber">
      <xr:Seller_contact_telephone_number>
         <xsl:attribute name="xr:id" select="'BT-42'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_telephone_number>
   </xsl:template>
   <xsl:template mode="BT-43"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <xr:Seller_contact_email_address>
         <xsl:attribute name="xr:id" select="'BT-43'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_contact_email_address>
   </xsl:template>
   <xsl:template mode="BG-7"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty der Instanz in konkreter Syntax wird auf 8 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-44" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-45"
                              select="./ram:SpecifiedLegalOrganization/ram:TradingBusinessName"/>
         <xsl:apply-templates mode="BT-46"
                              select="./ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]"/>
         <xsl:apply-templates mode="BT-46" select="./ram:GlobalID[exists(@schemeID)]"/>
         <xsl:apply-templates mode="BT-47" select="./ram:SpecifiedLegalOrganization/ram:ID"/>
         <xsl:apply-templates mode="BT-48"
                              select="./ram:SpecifiedTaxRegistration/ram:ID[@schemeID=('VA', 'VAT')]"/>
         <xsl:apply-templates mode="BT-49" select="./ram:URIUniversalCommunication/ram:URIID"/>
         <xsl:apply-templates mode="BG-8" select="./ram:PostalTradeAddress"/>
         <xsl:apply-templates mode="BG-9" select="./ram:DefinedTradeContact"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name">
      <xr:Buyer_name>
         <xsl:attribute name="xr:id" select="'BT-44'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_name>
   </xsl:template>
   <xsl:template mode="BT-45"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
      <xr:Buyer_trading_name>
         <xsl:attribute name="xr:id" select="'BT-45'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_trading_name>
   </xsl:template>
   <xsl:template mode="BT-46"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]">
      <xr:Buyer_identifier>
         <xsl:attribute name="xr:id" select="'BT-46'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Buyer_identifier>
   </xsl:template>
   <xsl:template mode="BT-46"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[exists(@schemeID)]">
      <xr:Buyer_identifier>
         <xsl:attribute name="xr:id" select="'BT-46'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Buyer_identifier>
   </xsl:template>
   <xsl:template mode="BT-47"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <xr:Buyer_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-47'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Buyer_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-48"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID=('VA', 'VAT')]">
      <xr:Buyer_VAT_identifier>
         <xsl:attribute name="xr:id" select="'BT-48'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Buyer_VAT_identifier>
   </xsl:template>
   <xsl:template mode="BT-49"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <xr:Buyer_electronic_address>
         <xsl:attribute name="xr:id" select="'BT-49'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Buyer_electronic_address>
   </xsl:template>
   <xsl:template mode="BG-8"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-50" select="./ram:LineOne"/>
         <xsl:apply-templates mode="BT-51" select="./ram:LineTwo"/>
         <xsl:apply-templates mode="BT-163" select="./ram:LineThree"/>
         <xsl:apply-templates mode="BT-52" select="./ram:CityName"/>
         <xsl:apply-templates mode="BT-53" select="./ram:PostcodeCode"/>
         <xsl:apply-templates mode="BT-54" select="./ram:CountrySubDivisionName"/>
         <xsl:apply-templates mode="BT-55" select="./ram:CountryID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineOne">
      <xr:Buyer_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-50'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-51"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineTwo">
      <xr:Buyer_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-51'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-163"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineThree">
      <xr:Buyer_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-163'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-52"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CityName">
      <xr:Buyer_city>
         <xsl:attribute name="xr:id" select="'BT-52'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_city>
   </xsl:template>
   <xsl:template mode="BT-53"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <xr:Buyer_post_code>
         <xsl:attribute name="xr:id" select="'BT-53'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_post_code>
   </xsl:template>
   <xsl:template mode="BT-54"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName">
      <xr:Buyer_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-54'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-55"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <xr:Buyer_country_code>
         <xsl:attribute name="xr:id" select="'BT-55'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Buyer_country_code>
   </xsl:template>
   <xsl:template mode="BG-9"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-56" select="./ram:DepartmentName"/>
         <xsl:apply-templates mode="BT-56" select="./ram:PersonName"/>
         <xsl:apply-templates mode="BT-57"
                              select="./ram:TelephoneUniversalCommunication/ram:CompleteNumber"/>
         <xsl:apply-templates mode="BT-58" select="./ram:EmailURIUniversalCommunication/ram:URIID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:DepartmentName">
      <xr:Buyer_contact_point>
         <xsl:attribute name="xr:id" select="'BT-56'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_point>
   </xsl:template>
   <xsl:template mode="BT-56"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:PersonName">
      <xr:Buyer_contact_point>
         <xsl:attribute name="xr:id" select="'BT-56'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_point>
   </xsl:template>
   <xsl:template mode="BT-57"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:CompleteNumber">
      <xr:Buyer_contact_telephone_number>
         <xsl:attribute name="xr:id" select="'BT-57'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_telephone_number>
   </xsl:template>
   <xsl:template mode="BT-58"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <xr:Buyer_contact_email_address>
         <xsl:attribute name="xr:id" select="'BT-58'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Buyer_contact_email_address>
   </xsl:template>
   <xsl:template mode="BG-10"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-59" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-60" select="./ram:GlobalID[exists(@schemeID)]"/>
         <xsl:apply-templates mode="BT-60"
                              select="./ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]"/>
         <xsl:apply-templates mode="BT-61" select="./ram:SpecifiedLegalOrganization/ram:ID/@schemeID"/>
         <xsl:apply-templates mode="BT-61" select="./ram:SpecifiedLegalOrganization/ram:ID"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PAYEE>
            <xsl:attribute name="xr:id" select="'BG-10'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PAYEE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-59"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Name">
      <xr:Payee_name>
         <xsl:attribute name="xr:id" select="'BT-59'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payee_name>
   </xsl:template>
   <xsl:template mode="BT-60"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID[exists(@schemeID)]">
      <xr:Payee_identifier>
         <xsl:attribute name="xr:id" select="'BT-60'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Payee_identifier>
   </xsl:template>
   <xsl:template mode="BT-60"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]">
      <xr:Payee_identifier>
         <xsl:attribute name="xr:id" select="'BT-60'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Payee_identifier>
   </xsl:template>
   <xsl:template mode="BT-61"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID">
      <xr:Payee_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-61'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Payee_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BT-61"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <xr:Payee_legal_registration_identifier>
         <xsl:attribute name="xr:id" select="'BT-61'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payee_legal_registration_identifier>
   </xsl:template>
   <xsl:template mode="BG-11"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-62" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-63" select="./ram:SpecifiedTaxRegistration/ram:ID"/>
         <xsl:apply-templates mode="BG-12" select="./ram:PostalTradeAddress"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Name">
      <xr:Seller_tax_representative_name>
         <xsl:attribute name="xr:id" select="'BT-62'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Seller_tax_representative_name>
   </xsl:template>
   <xsl:template mode="BT-63"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <xr:Seller_tax_representative_VAT_identifier>
         <xsl:attribute name="xr:id" select="'BT-63'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Seller_tax_representative_VAT_identifier>
   </xsl:template>
   <xsl:template mode="BG-12"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-64" select="./ram:LineOne"/>
         <xsl:apply-templates mode="BT-65" select="./ram:LineTwo"/>
         <xsl:apply-templates mode="BT-164" select="./ram:LineThree"/>
         <xsl:apply-templates mode="BT-66" select="./ram:CityName"/>
         <xsl:apply-templates mode="BT-67" select="./ram:PostcodeCode"/>
         <xsl:apply-templates mode="BT-68" select="./ram:CountrySubDivisionName"/>
         <xsl:apply-templates mode="BT-69" select="./ram:CountryID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineOne">
      <xr:Tax_representative_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-64'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-65"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineTwo">
      <xr:Tax_representative_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-65'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-164"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:LineThree">
      <xr:Tax_representative_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-164'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-66"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CityName">
      <xr:Tax_representative_city>
         <xsl:attribute name="xr:id" select="'BT-66'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_city>
   </xsl:template>
   <xsl:template mode="BT-67"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <xr:Tax_representative_post_code>
         <xsl:attribute name="xr:id" select="'BT-67'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_post_code>
   </xsl:template>
   <xsl:template mode="BT-68"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName">
      <xr:Tax_representative_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-68'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Tax_representative_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-69"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <xr:Tax_representative_country_code>
         <xsl:attribute name="xr:id" select="'BT-69'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Tax_representative_country_code>
   </xsl:template>
   <xsl:template mode="BG-13"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-70" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-71" select="./ram:GlobalID[exists(@schemeID)]"/>
         <xsl:apply-templates mode="BT-71"
                              select="./ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]"/>
         <xsl:apply-templates mode="BT-72"
                              select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString[@format = '102']"/>
         <xsl:apply-templates mode="BG-14"
                              select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod"/>
         <xsl:apply-templates mode="BG-15" select="./ram:PostalTradeAddress"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Name">
      <xr:Deliver_to_party_name>
         <xsl:attribute name="xr:id" select="'BT-70'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_party_name>
   </xsl:template>
   <xsl:template mode="BT-71"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[exists(@schemeID)]">
      <xr:Deliver_to_location_identifier>
         <xsl:attribute name="xr:id" select="'BT-71'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Deliver_to_location_identifier>
   </xsl:template>
   <xsl:template mode="BT-71"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID[empty(following-sibling::ram:GlobalID/@schemeID)]">
      <xr:Deliver_to_location_identifier>
         <xsl:attribute name="xr:id" select="'BT-71'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Deliver_to_location_identifier>
   </xsl:template>
   <xsl:template mode="BT-72"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString[@format = '102']">
      <xr:Actual_delivery_date>
         <xsl:attribute name="xr:id" select="'BT-72'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Actual_delivery_date>
   </xsl:template>
   <xsl:template mode="BG-14"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-73"
                              select="./ram:StartDateTime/udt:DateTimeString[@format = '102']"/>
         <xsl:apply-templates mode="BT-74"
                              select="./ram:EndDateTime/udt:DateTimeString[@format = '102']"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICING_PERIOD>
            <xsl:attribute name="xr:id" select="'BG-14'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICING_PERIOD>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-73"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format = '102']">
      <xr:Invoicing_period_start_date>
         <xsl:attribute name="xr:id" select="'BT-73'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoicing_period_start_date>
   </xsl:template>
   <xsl:template mode="BT-74"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format = '102']">
      <xr:Invoicing_period_end_date>
         <xsl:attribute name="xr:id" select="'BT-74'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoicing_period_end_date>
   </xsl:template>
   <xsl:template mode="BG-15"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-75" select="./ram:LineOne"/>
         <xsl:apply-templates mode="BT-76" select="./ram:LineTwo"/>
         <xsl:apply-templates mode="BT-165" select="./ram:LineThree"/>
         <xsl:apply-templates mode="BT-77" select="./ram:CityName"/>
         <xsl:apply-templates mode="BT-78" select="./ram:PostcodeCode"/>
         <xsl:apply-templates mode="BT-79" select="./ram:CountrySubDivisionName"/>
         <xsl:apply-templates mode="BT-80" select="./ram:CountryID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineOne">
      <xr:Deliver_to_address_line_1>
         <xsl:attribute name="xr:id" select="'BT-75'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_address_line_1>
   </xsl:template>
   <xsl:template mode="BT-76"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineTwo">
      <xr:Deliver_to_address_line_2>
         <xsl:attribute name="xr:id" select="'BT-76'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_address_line_2>
   </xsl:template>
   <xsl:template mode="BT-165"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:LineThree">
      <xr:Deliver_to_address_line_3>
         <xsl:attribute name="xr:id" select="'BT-165'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_address_line_3>
   </xsl:template>
   <xsl:template mode="BT-77"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CityName">
      <xr:Deliver_to_city>
         <xsl:attribute name="xr:id" select="'BT-77'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_city>
   </xsl:template>
   <xsl:template mode="BT-78"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <xr:Deliver_to_post_code>
         <xsl:attribute name="xr:id" select="'BT-78'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_post_code>
   </xsl:template>
   <xsl:template mode="BT-79"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName">
      <xr:Deliver_to_country_subdivision>
         <xsl:attribute name="xr:id" select="'BT-79'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Deliver_to_country_subdivision>
   </xsl:template>
   <xsl:template mode="BT-80"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <xr:Deliver_to_country_code>
         <xsl:attribute name="xr:id" select="'BT-80'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Deliver_to_country_code>
   </xsl:template>
   <xsl:template mode="BG-16"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans der Instanz in konkreter Syntax wird auf 6 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-81" select="./ram:TypeCode"/>
         <xsl:apply-templates mode="BT-82" select="./ram:Information"/>
         <xsl:apply-templates mode="BT-83"
                              select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference"/>
         <xsl:apply-templates mode="BG-17" select="./ram:PayeePartyCreditorFinancialAccount"/>
         <xsl:apply-templates mode="BG-18" select="./ram:ApplicableTradeSettlementFinancialCard"/>
         <xsl:apply-templates mode="BG-19"
                              select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PAYMENT_INSTRUCTIONS>
            <xsl:attribute name="xr:id" select="'BG-16'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PAYMENT_INSTRUCTIONS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-81"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode">
      <xr:Payment_means_type_code>
         <xsl:attribute name="xr:id" select="'BT-81'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Payment_means_type_code>
   </xsl:template>
   <xsl:template mode="BT-82"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:Information">
      <xr:Payment_means_text>
         <xsl:attribute name="xr:id" select="'BT-82'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_means_text>
   </xsl:template>
   <xsl:template mode="BT-83"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference">
      <xr:Remittance_information>
         <xsl:attribute name="xr:id" select="'BT-83'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Remittance_information>
   </xsl:template>
   <xsl:template mode="BG-17"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-84" select="./ram:ProprietaryID"/>
         <xsl:apply-templates mode="BT-84" select="./ram:IBANID"/>
         <xsl:apply-templates mode="BT-85" select="./ram:AccountName"/>
         <xsl:apply-templates mode="BT-86"
                              select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID"/>
         <xsl:apply-templates mode="BT-86"
                              select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID">
      <xr:Payment_account_identifier>
         <xsl:attribute name="xr:id" select="'BT-84'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payment_account_identifier>
   </xsl:template>
   <xsl:template mode="BT-84"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID">
      <xr:Payment_account_identifier>
         <xsl:attribute name="xr:id" select="'BT-84'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payment_account_identifier>
   </xsl:template>
   <xsl:template mode="BT-85"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:AccountName">
      <xr:Payment_account_name>
         <xsl:attribute name="xr:id" select="'BT-85'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_account_name>
   </xsl:template>
   <xsl:template mode="BT-86"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID">
      <xr:Payment_service_provider_identifier>
         <xsl:attribute name="xr:id" select="'BT-86'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payment_service_provider_identifier>
   </xsl:template>
   <xsl:template mode="BT-86"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID">
      <xr:Payment_service_provider_identifier>
         <xsl:attribute name="xr:id" select="'BT-86'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Payment_service_provider_identifier>
   </xsl:template>
   <xsl:template mode="BG-18"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-87" select="./ram:ID"/>
         <xsl:apply-templates mode="BT-88" select="./ram:CardholderName"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard/ram:ID">
      <xr:Payment_card_primary_account_number>
         <xsl:attribute name="xr:id" select="'BT-87'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_card_primary_account_number>
   </xsl:template>
   <xsl:template mode="BT-88"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard/ram:CardholderName">
      <xr:Payment_card_holder_name>
         <xsl:attribute name="xr:id" select="'BT-88'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Payment_card_holder_name>
   </xsl:template>
   <xsl:template mode="BG-19"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement der Instanz in konkreter Syntax wird auf 3 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-89"
                              select="./ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID"/>
         <xsl:apply-templates mode="BT-90" select="./ram:CreditorReferenceID"/>
         <xsl:apply-templates mode="BT-91"
                              select="./ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:DIRECT_DEBIT>
            <xsl:attribute name="xr:id" select="'BG-19'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:DIRECT_DEBIT>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-89"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID">
      <xr:Mandate_reference_identifier>
         <xsl:attribute name="xr:id" select="'BT-89'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Mandate_reference_identifier>
   </xsl:template>
   <xsl:template mode="BT-90"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID">
      <xr:Bank_assigned_creditor_identifier>
         <xsl:attribute name="xr:id" select="'BT-90'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Bank_assigned_creditor_identifier>
   </xsl:template>
   <xsl:template mode="BT-91"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID">
      <xr:Debited_account_identifier>
         <xsl:attribute name="xr:id" select="'BT-91'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Debited_account_identifier>
   </xsl:template>
   <xsl:template mode="BG-20"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='false']">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='false'] der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-92" select="./ram:ActualAmount"/>
         <xsl:apply-templates mode="BT-93" select="./ram:BasisAmount"/>
         <xsl:apply-templates mode="BT-94" select="./ram:CalculationPercent"/>
         <xsl:apply-templates mode="BT-95" select="./ram:CategoryTradeTax/ram:CategoryCode"/>
         <xsl:apply-templates mode="BT-96" select="./ram:CategoryTradeTax/ram:RateApplicablePercent"/>
         <xsl:apply-templates mode="BT-97" select="./ram:Reason"/>
         <xsl:apply-templates mode="BT-98" select="./ram:ReasonCode"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount">
      <xr:Document_level_allowance_amount>
         <xsl:attribute name="xr:id" select="'BT-92'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_allowance_amount>
   </xsl:template>
   <xsl:template mode="BT-93"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount">
      <xr:Document_level_allowance_base_amount>
         <xsl:attribute name="xr:id" select="'BT-93'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_allowance_base_amount>
   </xsl:template>
   <xsl:template mode="BT-94"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CalculationPercent">
      <xr:Document_level_allowance_percentage>
         <xsl:attribute name="xr:id" select="'BT-94'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_allowance_percentage>
   </xsl:template>
   <xsl:template mode="BT-95"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode">
      <xr:Document_level_allowance_VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-95'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Document_level_allowance_VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-96"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent">
      <xr:Document_level_allowance_VAT_rate>
         <xsl:attribute name="xr:id" select="'BT-96'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_allowance_VAT_rate>
   </xsl:template>
   <xsl:template mode="BT-97"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:Reason">
      <xr:Document_level_allowance_reason>
         <xsl:attribute name="xr:id" select="'BT-97'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Document_level_allowance_reason>
   </xsl:template>
   <xsl:template mode="BT-98"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode">
      <xr:Document_level_allowance_reason_code>
         <xsl:attribute name="xr:id" select="'BT-98'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Document_level_allowance_reason_code>
   </xsl:template>
   <xsl:template mode="BG-21"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='true']">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='true'] der Instanz in konkreter Syntax wird auf 7 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-99" select="./ram:ActualAmount"/>
         <xsl:apply-templates mode="BT-100" select="./ram:BasisAmount"/>
         <xsl:apply-templates mode="BT-101" select="./ram:CalculationPercent"/>
         <xsl:apply-templates mode="BT-102" select="./ram:CategoryTradeTax/ram:CategoryCode"/>
         <xsl:apply-templates mode="BT-103" select="./ram:CategoryTradeTax/ram:RateApplicablePercent"/>
         <xsl:apply-templates mode="BT-104" select="./ram:Reason"/>
         <xsl:apply-templates mode="BT-105" select="./ram:ReasonCode"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount">
      <xr:Document_level_charge_amount>
         <xsl:attribute name="xr:id" select="'BT-99'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_charge_amount>
   </xsl:template>
   <xsl:template mode="BT-100"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount">
      <xr:Document_level_charge_base_amount>
         <xsl:attribute name="xr:id" select="'BT-100'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Document_level_charge_base_amount>
   </xsl:template>
   <xsl:template mode="BT-101"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CalculationPercent">
      <xr:Document_level_charge_percentage>
         <xsl:attribute name="xr:id" select="'BT-101'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_charge_percentage>
   </xsl:template>
   <xsl:template mode="BT-102"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:CategoryCode">
      <xr:Document_level_charge_VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-102'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Document_level_charge_VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-103"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent">
      <xr:Document_level_charge_VAT_rate>
         <xsl:attribute name="xr:id" select="'BT-103'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Document_level_charge_VAT_rate>
   </xsl:template>
   <xsl:template mode="BT-104"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:Reason">
      <xr:Document_level_charge_reason>
         <xsl:attribute name="xr:id" select="'BT-104'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Document_level_charge_reason>
   </xsl:template>
   <xsl:template mode="BT-105"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode">
      <xr:Document_level_charge_reason_code>
         <xsl:attribute name="xr:id" select="'BT-105'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Document_level_charge_reason_code>
   </xsl:template>
   <xsl:template mode="BG-22"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation der Instanz in konkreter Syntax wird auf 10 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-106" select="./ram:LineTotalAmount"/>
         <xsl:apply-templates mode="BT-107" select="./ram:AllowanceTotalAmount"/>
         <xsl:apply-templates mode="BT-108" select="./ram:ChargeTotalAmount"/>
         <xsl:apply-templates mode="BT-109" select="./ram:TaxBasisTotalAmount"/>
         <xsl:apply-templates mode="BT-110"
                              select="./ram:TaxTotalAmount[@currencyID = parent::ram:SpecifiedTradeSettlementHeaderMonetarySummation/preceding-sibling::ram:TaxCurrencyCode]"/>
         <xsl:apply-templates mode="BT-111"
                              select="./ram:TaxTotalAmount[@currencyID = parent::ram:SpecifiedTradeSettlementHeaderMonetarySummation/preceding-sibling::ram:InvoiceCurrencyCode]"/>
         <xsl:apply-templates mode="BT-112" select="./ram:GrandTotalAmount"/>
         <xsl:apply-templates mode="BT-113" select="./ram:TotalPrepaidAmount"/>
         <xsl:apply-templates mode="BT-114" select="./ram:RoundingAmount"/>
         <xsl:apply-templates mode="BT-115" select="./ram:DuePayableAmount"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount">
      <xr:Sum_of_Invoice_line_net_amount>
         <xsl:attribute name="xr:id" select="'BT-106'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Sum_of_Invoice_line_net_amount>
   </xsl:template>
   <xsl:template mode="BT-107"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount">
      <xr:Sum_of_allowances_on_document_level>
         <xsl:attribute name="xr:id" select="'BT-107'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Sum_of_allowances_on_document_level>
   </xsl:template>
   <xsl:template mode="BT-108"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount">
      <xr:Sum_of_charges_on_document_level>
         <xsl:attribute name="xr:id" select="'BT-108'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Sum_of_charges_on_document_level>
   </xsl:template>
   <xsl:template mode="BT-109"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount">
      <xr:Invoice_total_amount_without_VAT>
         <xsl:attribute name="xr:id" select="'BT-109'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_amount_without_VAT>
   </xsl:template>
   <xsl:template mode="BT-110"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = parent::ram:SpecifiedTradeSettlementHeaderMonetarySummation/preceding-sibling::ram:TaxCurrencyCode]">
      <xr:Invoice_total_VAT_amount>
         <xsl:attribute name="xr:id" select="'BT-110'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_VAT_amount>
   </xsl:template>
   <xsl:template mode="BT-111"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID = parent::ram:SpecifiedTradeSettlementHeaderMonetarySummation/preceding-sibling::ram:InvoiceCurrencyCode]">
      <xr:Invoice_total_VAT_amount_in_accounting_currency>
         <xsl:attribute name="xr:id" select="'BT-111'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_VAT_amount_in_accounting_currency>
   </xsl:template>
   <xsl:template mode="BT-112"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount">
      <xr:Invoice_total_amount_with_VAT>
         <xsl:attribute name="xr:id" select="'BT-112'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_total_amount_with_VAT>
   </xsl:template>
   <xsl:template mode="BT-113"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount">
      <xr:Paid_amount>
         <xsl:attribute name="xr:id" select="'BT-113'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Paid_amount>
   </xsl:template>
   <xsl:template mode="BT-114"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount">
      <xr:Rounding_amount>
         <xsl:attribute name="xr:id" select="'BT-114'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Rounding_amount>
   </xsl:template>
   <xsl:template mode="BT-115"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount">
      <xr:Amount_due_for_payment>
         <xsl:attribute name="xr:id" select="'BT-115'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Amount_due_for_payment>
   </xsl:template>
   <xsl:template mode="BG-23"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax der Instanz in konkreter Syntax wird auf 6 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-116" select="./ram:BasisAmount"/>
         <xsl:apply-templates mode="BT-117" select="./ram:CalculatedAmount"/>
         <xsl:apply-templates mode="BT-118" select="./ram:CategoryCode"/>
         <xsl:apply-templates mode="BT-119" select="./ram:RateApplicablePercent"/>
         <xsl:apply-templates mode="BT-120" select="./ram:ExemptionReason"/>
         <xsl:apply-templates mode="BT-121" select="./ram:ExemptionReasonCode"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount">
      <xr:VAT_category_taxable_amount>
         <xsl:attribute name="xr:id" select="'BT-116'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:VAT_category_taxable_amount>
   </xsl:template>
   <xsl:template mode="BT-117"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount">
      <xr:VAT_category_tax_amount>
         <xsl:attribute name="xr:id" select="'BT-117'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:VAT_category_tax_amount>
   </xsl:template>
   <xsl:template mode="BT-118"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <xr:VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-118'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-119"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent">
      <xr:VAT_category_rate>
         <xsl:attribute name="xr:id" select="'BT-119'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:VAT_category_rate>
   </xsl:template>
   <xsl:template mode="BT-120"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason">
      <xr:VAT_exemption_reason_text>
         <xsl:attribute name="xr:id" select="'BT-120'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:VAT_exemption_reason_text>
   </xsl:template>
   <xsl:template mode="BT-121"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <xr:VAT_exemption_reason_code>
         <xsl:attribute name="xr:id" select="'BT-121'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:VAT_exemption_reason_code>
   </xsl:template>
   <xsl:template mode="BG-24"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument der Instanz in konkreter Syntax wird auf 4 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-122"
                              select="./ram:IssuerAssignedID[following-sibling::ram:TypeCode='916']"/>
         <xsl:apply-templates mode="BT-123" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-124" select="./ram:URIID"/>
         <xsl:apply-templates mode="BT-125" select="./ram:AttachmentBinaryObject"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:ADDITIONAL_SUPPORTING_DOCUMENTS>
            <xsl:attribute name="xr:id" select="'BG-24'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:ADDITIONAL_SUPPORTING_DOCUMENTS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-122"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='916']">
      <xr:Supporting_document_reference>
         <xsl:attribute name="xr:id" select="'BT-122'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Supporting_document_reference>
   </xsl:template>
   <xsl:template mode="BT-123"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:Name">
      <xr:Supporting_document_description>
         <xsl:attribute name="xr:id" select="'BT-123'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Supporting_document_description>
   </xsl:template>
   <xsl:template mode="BT-124"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:URIID">
      <xr:External_document_location>
         <xsl:attribute name="xr:id" select="'BT-124'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:External_document_location>
   </xsl:template>
   <xsl:template mode="BT-125"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject">
      <xr:Attached_document>
         <xsl:attribute name="xr:id" select="'BT-125'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="binary_object"/>
      </xr:Attached_document>
   </xsl:template>
   <xsl:template mode="BG-25"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem der Instanz in konkreter Syntax wird auf 14 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-126" select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
         <xsl:apply-templates mode="BT-127"
                              select="./ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:Content"/>
         <xsl:apply-templates mode="BT-128"
                              select="./ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='130']"/>
         <xsl:apply-templates mode="BT-129"
                              select="./ram:SpecifiedLineTradeDelivery/ram:BilledQuantity"/>
         <xsl:apply-templates mode="BT-130"
                              select="./ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode"/>
         <xsl:apply-templates mode="BT-131"
                              select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"/>
         <xsl:apply-templates mode="BT-132"
                              select="./ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID"/>
         <xsl:apply-templates mode="BT-133"
                              select="./ram:SpecifiedLineTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID"/>
         <xsl:apply-templates mode="BG-26"
                              select="./ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod"/>
         <xsl:apply-templates mode="BG-27"
                              select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='false']"/>
         <xsl:apply-templates mode="BG-28"
                              select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='true']"/>
         <xsl:apply-templates mode="BG-29" select="./ram:SpecifiedLineTradeAgreement"/>
         <xsl:apply-templates mode="BG-30"
                              select="./ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax"/>
         <xsl:apply-templates mode="BG-31" select="./ram:SpecifiedTradeProduct"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_LINE>
            <xsl:attribute name="xr:id" select="'BG-25'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_LINE>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-126"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID">
      <xr:Invoice_line_identifier>
         <xsl:attribute name="xr:id" select="'BT-126'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Invoice_line_identifier>
   </xsl:template>
   <xsl:template mode="BT-127"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:Content">
      <xr:Invoice_line_note>
         <xsl:attribute name="xr:id" select="'BT-127'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_note>
   </xsl:template>
   <xsl:template mode="BT-128"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='130']">
      <xr:Invoice_line_object_identifier>
         <xsl:attribute name="xr:id" select="'BT-128'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme">
            <xsl:with-param name="schemeID" select="following-sibling::ram:ReferenceTypeCode"/>
         </xsl:call-template>
      </xr:Invoice_line_object_identifier>
   </xsl:template>
   <xsl:template mode="BT-129"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
      <xr:Invoiced_quantity>
         <xsl:attribute name="xr:id" select="'BT-129'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="quantity"/>
      </xr:Invoiced_quantity>
   </xsl:template>
   <xsl:template mode="BT-130"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode">
      <xr:Invoiced_quantity_unit_of_measure_code>
         <xsl:attribute name="xr:id" select="'BT-130'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoiced_quantity_unit_of_measure_code>
   </xsl:template>
   <xsl:template mode="BT-131"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount">
      <xr:Invoice_line_net_amount>
         <xsl:attribute name="xr:id" select="'BT-131'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_net_amount>
   </xsl:template>
   <xsl:template mode="BT-132"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <xr:Referenced_purchase_order_line_reference>
         <xsl:attribute name="xr:id" select="'BT-132'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="document_reference"/>
      </xr:Referenced_purchase_order_line_reference>
   </xsl:template>
   <xsl:template mode="BT-133"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <xr:Invoice_line_Buyer_accounting_reference>
         <xsl:attribute name="xr:id" select="'BT-133'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_Buyer_accounting_reference>
   </xsl:template>
   <xsl:template mode="BG-26"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-134"
                              select="./ram:StartDateTime/udt:DateTimeString[@format='102']"/>
         <xsl:apply-templates mode="BT-135"
                              select="./ram:EndDateTime/udt:DateTimeString[@format='102']"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:INVOICE_LINE_PERIOD>
            <xsl:attribute name="xr:id" select="'BG-26'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:INVOICE_LINE_PERIOD>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-134"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format='102']">
      <xr:Invoice_line_period_start_date>
         <xsl:attribute name="xr:id" select="'BT-134'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoice_line_period_start_date>
   </xsl:template>
   <xsl:template mode="BT-135"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format='102']">
      <xr:Invoice_line_period_end_date>
         <xsl:attribute name="xr:id" select="'BT-135'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="date"/>
      </xr:Invoice_line_period_end_date>
   </xsl:template>
   <xsl:template mode="BG-27"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='false']">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='false'] der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-136" select="./ram:ActualAmount"/>
         <xsl:apply-templates mode="BT-137" select="./ram:BasisAmount"/>
         <xsl:apply-templates mode="BT-138" select="./ram:CalculationPercent"/>
         <xsl:apply-templates mode="BT-139" select="./ram:Reason"/>
         <xsl:apply-templates mode="BT-140" select="./ram:ReasonCode"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount">
      <xr:Invoice_line_allowance_amount>
         <xsl:attribute name="xr:id" select="'BT-136'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_allowance_amount>
   </xsl:template>
   <xsl:template mode="BT-137"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount">
      <xr:Invoice_line_allowance_base_amount>
         <xsl:attribute name="xr:id" select="'BT-137'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_allowance_base_amount>
   </xsl:template>
   <xsl:template mode="BT-138"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CalculationPercent">
      <xr:Invoice_line_allowance_percentage>
         <xsl:attribute name="xr:id" select="'BT-138'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Invoice_line_allowance_percentage>
   </xsl:template>
   <xsl:template mode="BT-139"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:Reason">
      <xr:Invoice_line_allowance_reason>
         <xsl:attribute name="xr:id" select="'BT-139'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_allowance_reason>
   </xsl:template>
   <xsl:template mode="BT-140"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode">
      <xr:Invoice_line_allowance_reason_code>
         <xsl:attribute name="xr:id" select="'BT-140'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoice_line_allowance_reason_code>
   </xsl:template>
   <xsl:template mode="BG-28"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='true']">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator='true'] der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-141" select="./ram:ActualAmount"/>
         <xsl:apply-templates mode="BT-142" select="./ram:BasisAmount"/>
         <xsl:apply-templates mode="BT-143" select="./ram:CalculationPercent"/>
         <xsl:apply-templates mode="BT-144" select="./ram:Reason"/>
         <xsl:apply-templates mode="BT-145" select="./ram:ReasonCode"/>
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
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount">
      <xr:Invoice_line_charge_amount>
         <xsl:attribute name="xr:id" select="'BT-141'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_charge_amount>
   </xsl:template>
   <xsl:template mode="BT-142"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount">
      <xr:Invoice_line_charge_base_amount>
         <xsl:attribute name="xr:id" select="'BT-142'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="amount"/>
      </xr:Invoice_line_charge_base_amount>
   </xsl:template>
   <xsl:template mode="BT-143"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CalculationPercent">
      <xr:Invoice_line_charge_percentage>
         <xsl:attribute name="xr:id" select="'BT-143'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Invoice_line_charge_percentage>
   </xsl:template>
   <xsl:template mode="BT-144"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:Reason">
      <xr:Invoice_line_charge_reason>
         <xsl:attribute name="xr:id" select="'BT-144'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Invoice_line_charge_reason>
   </xsl:template>
   <xsl:template mode="BT-145"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode">
      <xr:Invoice_line_charge_reason_code>
         <xsl:attribute name="xr:id" select="'BT-145'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoice_line_charge_reason_code>
   </xsl:template>
   <xsl:template mode="BG-29"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement der Instanz in konkreter Syntax wird auf 5 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-146" select="./ram:NetPriceProductTradePrice/ram:ChargeAmount"/>
         <xsl:apply-templates mode="BT-147"
                              select="./ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount"/>
         <xsl:apply-templates mode="BT-148"
                              select="./ram:GrossPriceProductTradePrice/ram:ChargeAmount"/>
         <xsl:apply-templates mode="BT-149"
                              select="./ram:NetPriceProductTradePrice/ram:BasisQuantity"/>
         <xsl:apply-templates mode="BT-149"
                              select="./ram:GrossPriceProductTradePrice/ram:BasisQuantity"/>
         <xsl:apply-templates mode="BT-150"
                              select="./ram:GrossPriceProductTradePrice/ram:BasisQuantity/@unitCode"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:PRICE_DETAILS>
            <xsl:attribute name="xr:id" select="'BG-29'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:PRICE_DETAILS>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-146"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount">
      <xr:Item_net_price>
         <xsl:attribute name="xr:id" select="'BT-146'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="unit_price_amount"/>
      </xr:Item_net_price>
   </xsl:template>
   <xsl:template mode="BT-147"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount">
      <xr:Item_price_discount>
         <xsl:attribute name="xr:id" select="'BT-147'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="unit_price_amount"/>
      </xr:Item_price_discount>
   </xsl:template>
   <xsl:template mode="BT-148"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount">
      <xr:Item_gross_price>
         <xsl:attribute name="xr:id" select="'BT-148'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="unit_price_amount"/>
      </xr:Item_gross_price>
   </xsl:template>
   <xsl:template mode="BT-149"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity">
      <xr:Item_price_base_quantity>
         <xsl:attribute name="xr:id" select="'BT-149'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="quantity"/>
      </xr:Item_price_base_quantity>
   </xsl:template>
   <xsl:template mode="BT-149"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity">
      <xr:Item_price_base_quantity>
         <xsl:attribute name="xr:id" select="'BT-149'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="quantity"/>
      </xr:Item_price_base_quantity>
   </xsl:template>
   <xsl:template mode="BT-150"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity/@unitCode">
      <xr:Item_price_base_quantity_unit_of_measure>
         <xsl:attribute name="xr:id" select="'BT-150'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Item_price_base_quantity_unit_of_measure>
   </xsl:template>
   <xsl:template mode="BG-30"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-151" select="./ram:CategoryCode"/>
         <xsl:apply-templates mode="BT-152" select="./ram:RateApplicablePercent"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:LINE_VAT_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-30'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:LINE_VAT_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-151"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <xr:Invoiced_item_VAT_category_code>
         <xsl:attribute name="xr:id" select="'BT-151'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Invoiced_item_VAT_category_code>
   </xsl:template>
   <xsl:template mode="BT-152"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent">
      <xr:Invoiced_item_VAT_rate>
         <xsl:attribute name="xr:id" select="'BT-152'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="percentage"/>
      </xr:Invoiced_item_VAT_rate>
   </xsl:template>
   <xsl:template mode="BG-31"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct der Instanz in konkreter Syntax wird auf 8 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-153" select="./ram:Name"/>
         <xsl:apply-templates mode="BT-154" select="./ram:Description"/>
         <xsl:apply-templates mode="BT-155" select="./ram:SellerAssignedID"/>
         <xsl:apply-templates mode="BT-156" select="./ram:BuyerAssignedID"/>
         <xsl:apply-templates mode="BT-157" select="./ram:GlobalID"/>
         <xsl:apply-templates mode="BT-158"
                              select="./ram:DesignatedProductClassification/ram:ClassCode"/>
         <xsl:apply-templates mode="BT-159" select="./ram:OriginTradeCountry/ram:ID"/>
         <xsl:apply-templates mode="BG-32" select="./ram:ApplicableProductCharacteristic"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:ITEM_INFORMATION>
            <xsl:attribute name="xr:id" select="'BG-31'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:ITEM_INFORMATION>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-153"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:Name">
      <xr:Item_name>
         <xsl:attribute name="xr:id" select="'BT-153'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_name>
   </xsl:template>
   <xsl:template mode="BT-154"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:Description">
      <xr:Item_description>
         <xsl:attribute name="xr:id" select="'BT-154'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_description>
   </xsl:template>
   <xsl:template mode="BT-155"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:SellerAssignedID">
      <xr:Item_Sellers_identifier>
         <xsl:attribute name="xr:id" select="'BT-155'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Item_Sellers_identifier>
   </xsl:template>
   <xsl:template mode="BT-156"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BuyerAssignedID">
      <xr:Item_Buyers_identifier>
         <xsl:attribute name="xr:id" select="'BT-156'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier"/>
      </xr:Item_Buyers_identifier>
   </xsl:template>
   <xsl:template mode="BT-157"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID">
      <xr:Item_standard_identifier>
         <xsl:attribute name="xr:id" select="'BT-157'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme"/>
      </xr:Item_standard_identifier>
   </xsl:template>
   <xsl:template mode="BT-158"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode">
      <xr:Item_classification_identifier>
         <xsl:attribute name="xr:id" select="'BT-158'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="identifier-with-scheme-and-version"/>
      </xr:Item_classification_identifier>
   </xsl:template>
   <xsl:template mode="BT-159"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry/ram:ID">
      <xr:Item_country_of_origin>
         <xsl:attribute name="xr:id" select="'BT-159'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="code"/>
      </xr:Item_country_of_origin>
   </xsl:template>
   <xsl:template mode="BG-32"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic">
      <xsl:variable name="bg-contents" as="item()*"><!--Der Pfad /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic der Instanz in konkreter Syntax wird auf 2 Objekte der EN 16931 abgebildet. -->
         <xsl:apply-templates mode="BT-160" select="./ram:Description"/>
         <xsl:apply-templates mode="BT-161" select="./ram:Value"/>
      </xsl:variable>
      <xsl:if test="$bg-contents">
         <xr:ITEM_ATTRIBUTES>
            <xsl:attribute name="xr:id" select="'BG-32'"/>
            <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
            <xsl:sequence select="$bg-contents"/>
         </xr:ITEM_ATTRIBUTES>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="BT-160"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Description">
      <xr:Item_attribute_name>
         <xsl:attribute name="xr:id" select="'BT-160'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_attribute_name>
   </xsl:template>
   <xsl:template mode="BT-161"
                 match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Value">
      <xr:Item_attribute_value>
         <xsl:attribute name="xr:id" select="'BT-161'"/>
         <xsl:attribute name="xr:src" select="xr:src-path(.)"/>
         <xsl:call-template name="text"/>
      </xr:Item_attribute_value>
   </xsl:template>
   <xsl:template name="text">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="date">
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.), '^[0-9]{8}$')">
            <xsl:value-of select="xs:date( concat(substring(.,1,4), '-', substring(.,5,2), '-', substring(.,7,2) ) )"/>
         </xsl:when>
         <xsl:otherwise>ILLEGAL DATE FORMAT: &lt;para&gt;Mit diesem Datentyp wird ein kalendarisches Datum abgebildet, wie es in der ISO 8601 Spezifikation &lt;quote&gt;Calendar date complete representation&lt;/quote&gt; beschrieben ist (siehe ISO 8601:2004, Abschnitt 5.2.1.1). Das Datum beinhaltet keine Zeitangabe. Das konkret zu verwendende Format ist abhängig von der genutzten Syntax.&lt;/para&gt;
&lt;para&gt;Der Datentyp basiert auf dem Typ &lt;quote&gt;Date Time. Type&lt;/quote&gt;, wie in ISO 15000-5:2014 Anhang B definiert.&lt;/para&gt;</xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="identifier-with-scheme-and-version">
      <xsl:param name="schemeID" as="element()?"/>
      <xsl:if test="@listID | @schemeID">
         <xsl:attribute name="scheme_identifier" select="($schemeID, @listID, @schemeID)[1]"/>
      </xsl:if>
      <xsl:if test="@schemeVersionID | @listVersionID">
         <xsl:attribute name="scheme_version_identifier"
                        select="(@listVersionID, @schemeVersionID)[1]"/>
      </xsl:if>
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="identifier-with-scheme">
      <xsl:param name="schemeID" as="element()?"/>
      <xsl:if test="@schemeID">
         <xsl:attribute name="scheme_identifier" select="($schemeID, @listID, @schemeID)[1]"/>
      </xsl:if>
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="identifier">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="code">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="amount">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="percentage">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="binary_object">
      <xsl:if test="@mimeCode">
         <xsl:attribute name="mime_code">
            <xsl:value-of select="@mimeCode"/>
         </xsl:attribute>
      </xsl:if>
      <xsl:if test="@filename">
         <xsl:attribute name="filename">
            <xsl:value-of select="@filename"/>
         </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="unit_price_amount">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="quantity">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template name="document_reference">
      <xsl:value-of select="."/>
   </xsl:template>
   <xd:doc>
      <xd:desc> Liefert einen XPath-Pfad, welches $n eindeutig identifiziert. </xd:desc>
      <xd:param name="n"/>
   </xd:doc>
   <xsl:function name="xr:src-path" as="xs:string">
      <xsl:param name="n" as="node()"/>
      <xsl:variable name="segments" as="xs:string*">
         <xsl:apply-templates select="$n" mode="xr:src-path"/>
      </xsl:variable>
      <xsl:sequence select="string-join($segments, '')"/>
   </xsl:function>
   <xd:doc>
      <xd:desc> Liefert einen XPath-Pfad, welches $n eindeutig identifiziert. </xd:desc>
      <xd:param name="n"/>
   </xd:doc>
   <xsl:template match="node() | @*" mode="xr:src-path">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.) = name(current())] or following-sibling::*[name(.) = name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.) = name(current())]) + 1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
