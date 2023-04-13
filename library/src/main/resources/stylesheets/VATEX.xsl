<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.VATEX">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='VATEX-EU-132'"><xsl:value-of select="$myparam"/> (Exempt based on article 132 of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1A'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (a) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1B'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (b) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1C'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (c) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1D'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (d) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1E'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (e) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1F'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (f) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1G'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (g) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1H'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (h) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1I'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (i) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1J'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (j) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1K'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (k) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1L'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (l) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1M'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (m) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1N'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (n) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1O'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (o) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1P'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (p) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-132-1Q'"><xsl:value-of select="$myparam"/> (Exempt based on article 132, section 1 (q) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143'"><xsl:value-of select="$myparam"/> (Exempt based on article 143 of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1A'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (a) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1B'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (b) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1C'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (c) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1D'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (d) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1E'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (e) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1F'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (f) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1FA'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (fa) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1G'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (g) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1H'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (h) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1I'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (i) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1J'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (j) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1K'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (k) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-143-1L'"><xsl:value-of select="$myparam"/> (Exempt based on article 143, section 1 (l) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148'"><xsl:value-of select="$myparam"/> (Exempt based on article 148 of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-A'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (a) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-B'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (b) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-C'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (c) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-D'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (d) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-E'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (e) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-F'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (f) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-148-G'"><xsl:value-of select="$myparam"/> (Exempt based on article 148, section (g) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151'"><xsl:value-of select="$myparam"/> (Exempt based on article 151 of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151-1A'"><xsl:value-of select="$myparam"/> (Exempt based on article 151, section 1 (a) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151-1AA'"><xsl:value-of select="$myparam"/> (Exempt based on article 151, section 1 (aa) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151-1B'"><xsl:value-of select="$myparam"/> (Exempt based on article 151, section 1 (b) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151-1C'"><xsl:value-of select="$myparam"/> (Exempt based on article 151, section 1 (c) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151-1D'"><xsl:value-of select="$myparam"/> (Exempt based on article 151, section 1 (d) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-151-1E'"><xsl:value-of select="$myparam"/> (Exempt based on article 151, section 1 (e) of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-309'"><xsl:value-of select="$myparam"/> (Exempt based on article 309 of Council Directive 2006/112/EC)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-AE'"><xsl:value-of select="$myparam"/> (Reverse charge)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-D'"><xsl:value-of select="$myparam"/> (Intra-Community acquisition from second hand means of transport)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-F'"><xsl:value-of select="$myparam"/> (Intra-Community acquisition of second hand goods)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-G'"><xsl:value-of select="$myparam"/> (Export outside the EU)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-I'"><xsl:value-of select="$myparam"/> (Intra-Community acquisition of works of art)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-IC'"><xsl:value-of select="$myparam"/> (Intra-Community supply)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-J'"><xsl:value-of select="$myparam"/> (Intra-Community acquisition of collectors items and antiques)</xsl:when>
      		<xsl:when test="$myparam.upper='VATEX-EU-O'"><xsl:value-of select="$myparam"/> (Not subject to VAT)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>