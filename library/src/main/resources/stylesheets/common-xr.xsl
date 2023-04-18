<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:include href="functions.xsl"/>

    <xsl:variable name="datepattern" as="xs:string" select="'^[0-9]{8}'" />


    <xsl:template name="text">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template name="date">
        <xsl:variable name="normalizeddate" select="normalize-space(replace(., '-', ''))" />
        <xsl:variable name="datematch" as="xs:boolean"
            select="matches($normalizeddate, $datepattern)" />
        <xsl:variable name="year" as="xs:integer">
            <xsl:variable name="yearstring" select="substring($normalizeddate, 1, 4)" />
            <xsl:value-of select="
                    if (matches($yearstring, '^[0-9]{4}')
                    and xs:integer($yearstring) &gt; 0)
                    then
                        xs:integer($yearstring)
                    else
                        0
                    " />
        </xsl:variable>

        <xsl:variable name="month" as="xs:integer">
            <xsl:variable name="monthstring" select="substring($normalizeddate, 5, 2)" />
            <xsl:value-of select="
                    if (matches($monthstring, '^[0-9]{2}') and xs:integer($monthstring) &gt; 0 and xs:integer($monthstring) &lt; 13) then
                        xs:integer($monthstring)
                    else
                        0" />
        </xsl:variable>

        <xsl:variable name="day" as="xs:integer">
            <xsl:variable name="daystring" select="substring($normalizeddate, 7, 2)" />
            <xsl:value-of select="
                    if (matches($daystring, '^[0-9]{2}') and xs:integer($daystring) &gt; 0 and xs:integer($daystring) &lt; 32) then
                        xs:integer($daystring)
                    else
                        0" />
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$year &gt; 0 and $month &gt; 0 and $day &gt; 0">
                <xsl:value-of
                    select="xs:date(concat($year, '-', format-number($month, '00'), '-', format-number($day, '00')))"
                 />
            </xsl:when>
            <xsl:otherwise>ILLEGAL DATE FORMAT of "<xsl:value-of select="." />".</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="identifier">
        <xsl:if test="@listID | @schemeID">
            <xsl:attribute name="scheme_identifier" select="(@listID, @schemeID)[1]" />
        </xsl:if>
        <xsl:if test="@schemeVersionID | @listVersionID">
            <xsl:attribute name="scheme_version_identifier"
                select="(@listVersionID, @schemeVersionID)[1]" />
        </xsl:if>
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="identifier-with-scheme">
        <xsl:param name="schemeID" as="element()?" />
        <xsl:if test="@schemeID">
            <xsl:attribute name="scheme_identifier" select="($schemeID, @listID, @schemeID)[1]" />
        </xsl:if>
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template name="code">
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="amount">
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="percentage">
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="binary_object">
        <xsl:if test="@mimeCode">
            <xsl:attribute name="mime_code">
                <xsl:value-of select="@mimeCode" />
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="@filename">
            <xsl:attribute name="filename">
                <xsl:value-of select="@filename" />
            </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="unit_price_amount">
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="quantity">
        <xsl:value-of select="." />
    </xsl:template>
    <xsl:template name="document_reference">
        <xsl:value-of select="." />
    </xsl:template>
    <xd:doc>
        <xd:desc> Liefert einen XPath-Pfad, welches $n eindeutig identifiziert. </xd:desc>
        <xd:param name="n" />
    </xd:doc>
    <xsl:function name="xr:src-path" as="xs:string">
        <xsl:param name="n" as="node()" />
        <xsl:variable name="segments" as="xs:string*">
            <xsl:apply-templates select="$n" mode="xr:src-path" />
        </xsl:variable>
        <xsl:sequence select="string-join($segments, '')" />
    </xsl:function>
    <xd:doc>
        <xd:desc> Liefert einen XPath-Pfad, welches $n eindeutig identifiziert. </xd:desc>
        <xd:param name="n" />
    </xd:doc>
    <xsl:template match="node() | @*" mode="xr:src-path">
        <xsl:for-each select="ancestor-or-self::*">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="name(.)" />
            <xsl:if
                test="preceding-sibling::*[name(.) = name(current())] or following-sibling::*[name(.) = name(current())]">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="count(preceding-sibling::*[name(.) = name(current())]) + 1" />
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="not(self::*)">
            <xsl:text />/@<xsl:value-of select="name(.)" />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
