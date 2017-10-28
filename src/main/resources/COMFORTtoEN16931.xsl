<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12"
	xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15"
	xmlns:rsm="urn:ferd:CrossIndustryDocument:invoice:1p0">
	<!-- use saxon6 java -cp saxon.jar com.icl.saxon.StyleSheet -o target.xml 
		ZUGFeRD-invoice.xml v1to2.xsl see also http://www.lenzconsulting.com/namespaces-in-xslt/ 
		extension-element-prefixes="exsl str datetime uw" -->
	<xsl:output encoding="UTF-8" indent="yes" method="xml" />

	<xsl:template match="//*[local-name() = 'CrossIndustryDocument']">
		<!-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" 
			xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" 
			xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" -->
		<xsl:element name="rsm:CrossIndustryInvoice" >
		   
			<xsl:apply-templates select="*" />
		</xsl:element>
	</xsl:template>

	<!-- xsl:template match="//*[local-name() = 'HeaderExchangedDocument']"> 
		<xsl:copy> <xsl:apply-templates select="@*|node()" /> </xsl:copy> </xsl:template> -->

	<!-- attribute rename -->
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

	<!-- rename and reorder -->
	<xsl:template
		match="//*[local-name() = 'SpecifiedSupplyChainTradeTransaction']">
		<rsm:SupplyChainTradeTransaction><!-- surplus namespaces -->
			<xsl:apply-templates
				select="//*[local-name() = 'IncludedSupplyChainTradeLineItem']" />
			<!-- now copy any other children that we haven't explicitly reordered; 
				again, possibly this is not what you want -->
			<xsl:apply-templates
				select="./*[not(local-name() = 'IncludedSupplyChainTradeLineItem')]" />

		</rsm:SupplyChainTradeTransaction>
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


	<!-- unterhalb von SupplyChainTradeTransaction muss zuerst die IncludedSupplyChainTradeLineItem 
		kommen -->
	<!-- rest -->
	<!-- this is the identity transform: it copies everything that isn't matched 
		by a more specific template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" /><!-- @*|node() -->
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>