<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
    xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
    xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi"
    version="2.0">

    <xsl:param name="xr-version"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <!-- update XRechnung Version -->
    <!-- CII -->
    <xsl:template match="/*:CrossIndustryInvoice/*:ExchangedDocumentContext/*:GuidelineSpecifiedDocumentContextParameter/*:ID/text()">
        <xsl:value-of select='replace(., "_\d\.\d", $xr-version)'/>
    </xsl:template>

    <!-- UBL Invoice and CreditNote-->
    <xsl:template match="/*:Invoice/*:CustomizationID/text() | /*:CreditNote/*:CustomizationID/text()">
        <xsl:value-of select='replace(., "_\d\.\d", $xr-version)'/>
    </xsl:template>
    
    <!-- remove xsi schemaLocation -->

    <xsl:template match="@*:schemaLocation"></xsl:template>

</xsl:stylesheet>
