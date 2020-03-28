<!--
 Copyright 2018 Jochen Staerk
 
  Use is subject to license terms.
 
  Licensed under the Apache License, Version 2.0 (the "License"); you may not
  use this file except in compliance with the License. You may obtain a copy
  of the License at http://www.apache.org/licenses/LICENSE-2.0.
 
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 
  See the License for the specific language governing permissions and
  limitations under the License.
  -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
	
	xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
	xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
	xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
	>
	<!-- use saxon6 java -cp saxon.jar com.icl.saxon.StyleSheet -o target.xml 
		ZUGFeRD-invoice.xml v1to2.xsl see also http://www.lenzconsulting.com/namespaces-in-xslt/ 
		extension-element-prefixes="exsl str datetime uw" -->
	<xsl:output encoding="UTF-8" indent="yes" method="xml" />

<!-- copy elements and all attributes but remove namespaces start
Will otherwise add sth like  xmlns:rsm="urn:ferd:CrossIndustryDocument:invoice:1p0" on elements.
src: https://stackoverflow.com/questions/12465002/remove-namespace-declaration-from-xslt-stylesheet-with-xslt 
This only seems to work in saxon, in xalan namespaces are still created-->	
<!-- Copy elements -->
<xsl:template match="*" priority="-1">
   <xsl:element name="{name()}">
      <xsl:apply-templates select="node()|@*"/>
   </xsl:element>
</xsl:template>

<!-- Copy all other nodes -->
<xsl:template match="node()|@*" priority="-2">
   <xsl:copy />      
</xsl:template>
<!-- copy elements and all attributes but remove namespaces end -->	

	<xsl:template match="//*[local-name() = 'CrossIndustryDocument']">
		<!-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" 
			xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" 
			xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" -->
			<rsm:CrossIndustryInvoice xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
	xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
    xmlns:qdt="urn:un:unece:uncefact:data:Standard:QualifiedDataType:100"
    xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100">
   <xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
Migrated by Mustangproject XSLT
<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
		   
			<xsl:apply-templates select="*" />
		</rsm:CrossIndustryInvoice>
	</xsl:template>

	<!-- xsl:template match="//*[local-name() = 'HeaderExchangedDocument']"> 
		<xsl:copy> <xsl:apply-templates select="@*|node()" /> </xsl:copy> </xsl:template> -->

	<!-- element remode -->
	<xsl:template match="//*[local-name() = 'TestIndicator']">
	<!-- Testindicator element has been removed -->
	</xsl:template>
	
	<!-- element rename -->
	<xsl:template match="//*[local-name() = 'SpecifiedExchangedDocumentContext']">
		<xsl:element name="rsm:ExchangedDocumentContext">
			<xsl:apply-templates select="@*|node()" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="//*[local-name() = 'HeaderExchangedDocument']">
		<rsm:ExchangedDocument>
			<xsl:apply-templates select="@*|node()" />
		</rsm:ExchangedDocument>
	</xsl:template>


	<xsl:template match="//*[local-name() = 'ApplicablePercent']">
		<ram:RateApplicablePercent>
			<xsl:apply-templates select="@*|node()" />
		</ram:RateApplicablePercent>
	</xsl:template>
	

	<xsl:template match="//*[local-name() = 'SpecifiedSupplyChainTradeDelivery']">
		<ram:SpecifiedLineTradeDelivery>
			<xsl:apply-templates select="@*|node()" />
		</ram:SpecifiedLineTradeDelivery>
	</xsl:template>

	<xsl:template match="//*[local-name() = 'SpecifiedLineTradeAgreement']">
		<ram:AssociatedDocumentLineDocument>
			<xsl:apply-templates select="@*|node()" />
		</ram:AssociatedDocumentLineDocument>
	</xsl:template>


	<xsl:template
		match="//*[local-name() = 'SpecifiedSupplyChainTradeAgreement']">
		<ram:SpecifiedLineTradeAgreement>
			<xsl:apply-templates select="@*|node()" />
		</ram:SpecifiedLineTradeAgreement>
	</xsl:template>

	<xsl:template
		match="//*[local-name() = 'SpecifiedSupplyChainTradeSettlement']">
		<ram:SpecifiedLineTradeSettlement>
			<xsl:apply-templates select="@*|node()" />
		</ram:SpecifiedLineTradeSettlement>
	</xsl:template>

	<!-- SpecifiedTradeSettlementMonetarySummation -> SpecifiedTradeSettlementLineMonetarySummation 
		unterhalb SpecifiedLineTradeSettlement -> SpecifiedTradeSettlementHeaderMonetarySummation 
		unterhalb ApplicableHeaderTradeSettlement -->

	<xsl:template
		match="//*[local-name()='SpecifiedSupplyChainTradeSettlement']/*[local-name()='SpecifiedTradeSettlementMonetarySummation']">
		<ram:SpecifiedTradeSettlementLineMonetarySummation>
			<xsl:apply-templates select="@*|node()" />
		</ram:SpecifiedTradeSettlementLineMonetarySummation>
	</xsl:template>

	<!-- ApplicableSupplyChainTradeSettlement -->
	<xsl:template
		match="//*[local-name() = 'ApplicableSupplyChainTradeSettlement']/*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']">
		<ram:SpecifiedTradeSettlementHeaderMonetarySummation>
			<xsl:apply-templates select="@*|node()" />
		</ram:SpecifiedTradeSettlementHeaderMonetarySummation>
	</xsl:template>

	<xsl:template
		match="//*[local-name() = 'ApplicableSupplyChainTradeAgreement']">
		<ram:ApplicableHeaderTradeAgreement>
			<xsl:apply-templates select="@*|node()" />
		</ram:ApplicableHeaderTradeAgreement>
	</xsl:template>

	<xsl:template
		match="//*[local-name() = 'ApplicableSupplyChainTradeDelivery']">
		<ram:ApplicableHeaderTradeDelivery>
			<xsl:apply-templates select="@*|node()" />
		</ram:ApplicableHeaderTradeDelivery>
	</xsl:template>

	<xsl:template
		match="//*[local-name() = 'ApplicableSupplyChainTradeSettlement']">
		<ram:ApplicableHeaderTradeSettlement>
			<xsl:apply-templates select="@*|node()" />
		</ram:ApplicableHeaderTradeSettlement>
	</xsl:template>
	
	<xsl:template
		match="//*[local-name() = 'SpecifiedTradeAccountingAccount']">
		<ram:ReceivableSpecifiedTradeAccountingAccount>
			<xsl:apply-templates select="@*|node()" />
		</ram:ReceivableSpecifiedTradeAccountingAccount>
	</xsl:template>
	<!-- rename hierarchical -->
	
	

	<xsl:template
		match="//*[local-name() = 'BuyerOrderReferencedDocument' or local-name() = 'DeliveryNoteReferencedDocument' or local-name() = 'AdditionalReferencedDocument' or local-name() = 'ContractReferencedDocument']/*[local-name() = 'ID']">
		<ram:IssuerAssignedID>
			<xsl:apply-templates select="@*|node()" />
		</ram:IssuerAssignedID>
	</xsl:template>
	
	

	<xsl:template
		match="//*[local-name() = 'ContractReferencedDocument']/*[local-name() = 'TypeCode']">
		<ram:ReferenceTypeCode>
			<xsl:apply-templates select="@*|node()" />
		</ram:ReferenceTypeCode>
	</xsl:template>
	
	<!-- rename and add -->
 
	<xsl:template match="//*[local-name() != 'HeaderExchangedDocument']/*[local-name() = 'IssueDateTime']">
		<ram:FormattedIssueDateTime>
			<qdt:DateTimeString>
				<xsl:apply-templates select="@*|node()" />
			</qdt:DateTimeString>
		</ram:FormattedIssueDateTime>
	</xsl:template>

 
	<!-- rename and reorder -->
	<xsl:template
		match="//*[local-name() = 'SpecifiedSupplyChainTradeTransaction']">
		<rsm:SupplyChainTradeTransaction><!-- surplus namespaces -->
			<xsl:apply-templates
				select="./*[local-name() = 'IncludedSupplyChainTradeLineItem']" />
			<!-- now copy any other children that we haven't explicitly reordered; 
				again, possibly this is not what you want -->
			<xsl:apply-templates
				select="./*[not(local-name() = 'IncludedSupplyChainTradeLineItem')]" />

		</rsm:SupplyChainTradeTransaction>
	</xsl:template>
	
	<xsl:template
		match="//*[local-name() = 'BuyerOrderReferencedDocument' or local-name() = 'DeliveryNoteReferencedDocument' or local-name() = 'AdditionalReferencedDocument' or local-name() = 'ContractReferencedDocument']">
		<xsl:element name="{name()}">

			<xsl:apply-templates
				select="./*[local-name() = 'ID']" />
			<xsl:apply-templates
				select="./*[local-name() = 'TypeCode']" />
			<xsl:apply-templates
				select="./*[not(local-name() = 'ID' or local-name() = 'TypeCode')]" />
		</xsl:element>
	</xsl:template>

	<!-- innerhalb IncludedSupplyChainTradeLineItem zuerst AssociatedDocumentLineDocument 
		dann SpecifiedTradeProduct -->
	<xsl:template match="//*[local-name() = 'IncludedSupplyChainTradeLineItem']">
		<ram:IncludedSupplyChainTradeLineItem>
			<xsl:apply-templates
				select="./*[local-name() = 'AssociatedDocumentLineDocument']" />
			<xsl:apply-templates select="./*[local-name() = 'SpecifiedTradeProduct']" />
			<!-- now copy any other children that we haven't explicitly reordered; 
				again, possibly this is not what you want -->

			<xsl:apply-templates
				select="./*[not(local-name() = 'AssociatedDocumentLineDocument' or local-name() = 'SpecifiedTradeProduct')]" />

		</ram:IncludedSupplyChainTradeLineItem>
	</xsl:template>

	<xsl:template
		match="//*[local-name() = 'SpecifiedLineTradeSettlement']">
		<ram:SpecifiedLineTradeSettlement>

			<xsl:apply-templates
				select="./*[not(local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation' or local-name() = 'SpecifiedTradeSettlementLineMonetarySummation' or local-name() = 'SpecifiedTradeAccountingAccount')]" />
			<xsl:apply-templates
				select="./*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']" />
			<xsl:apply-templates
				select="./*[local-name() = 'SpecifiedTradeSettlementLineMonetarySummation']" />
			<xsl:apply-templates
				select="./*[local-name() = 'SpecifiedTradeAccountingAccount']" />

		</ram:SpecifiedLineTradeSettlement>
	</xsl:template>
	<xsl:template
		match="//*[local-name() = 'ApplicableHeaderTradeSettlement' or local-name() = 'SpecifiedLineTradeSettlement']">
 		<xsl:element name="{name()}">
  
			<xsl:apply-templates
				select="./*[not(local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation' or local-name() = 'SpecifiedTradeSettlementMonetarySummation' or local-name() = 'SpecifiedTradeAccountingAccount')]" />
			<!--  xsl:apply-templates
				select="./*[local-name() = 'SpecifiedTradeSettlementHeaderMonetarySummation']" /-->
			<xsl:apply-templates
				select="./*[local-name() = 'SpecifiedTradeSettlementMonetarySummation']" />
			<xsl:apply-templates
				select="./*[local-name() = 'SpecifiedTradeAccountingAccount']" />

		</xsl:element>
  	</xsl:template>
	
		 	
	<!-- unterhalb von SupplyChainTradeTransaction muss zuerst die IncludedSupplyChainTradeLineItem 
		kommen -->
	<!-- rest -->
	<!-- this is the identity transform: it copies everything that isn't matched 
		by a more specific template -->
	
</xsl:stylesheet>