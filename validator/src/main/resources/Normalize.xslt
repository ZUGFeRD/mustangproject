<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">
	<xsl:output method="xml"
	            indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- Move all namespace declarations to the top -->
	<xsl:template match="xsl:stylesheet">
		<xsl:element name="{name()}">
			<xsl:copy-of select="//namespace::*"/>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<!-- Avoid "net.sf.saxon.trans.XPathException: A function that computes atomic values should use xsl:sequence rather than xsl:value-of" -->
	<xsl:template match="xsl:function[@as='xs:boolean' or @as='xs:decimal' or @as='xs:integer' or @as='xs:string']/xsl:value-of">
		<xsl:element name="xsl:sequence">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<!-- Avoid "SXWN9026: Comparison of xs:untypedAtomic? to xs:boolean will fail unless the first operand is empty" -->
	<xsl:template match="xsl:value-of[matches(@select,'if\s?\([^()]+ eq fn:true\(\)\)')]/@select">
		<xsl:attribute name="select">
			<xsl:value-of select="replace(.,'(if\s?\()([^()]+)( eq fn:true\(\)\))','$1xs:boolean($2)$3')"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Avoid "SXWN9009: An empty xsl:for-each instruction has no effect" -->
	<xsl:template match="xsl:for-each[xsl:for-each[not(child::node())] and count(child::node()) eq 1]"/>
	<!-- Normalize text elements -->
	<xsl:template match="svrl:text|xsl:text">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>
	<!-- Normalize comments -->
	<xsl:template match="//comment()">
		<xsl:choose>
			<!-- Work on comments with non-empty first line -->
			<xsl:when test="matches(.,'^[ \t]*\S.*$','s')">
				<xsl:comment>
					<xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
				</xsl:comment>
			</xsl:when>
			<!-- Copy all other comments -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Normalize attributes -->
	<xsl:template match="@*">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Basic match -->
	<xsl:template match="/|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
