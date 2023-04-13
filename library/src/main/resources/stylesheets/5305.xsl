<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.5305">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='A'"><xsl:value-of select="$myparam"/> (Mixed tax rate)</xsl:when>
      		<xsl:when test="$myparam.upper='AA'"><xsl:value-of select="$myparam"/> (Lower rate)</xsl:when>
      		<xsl:when test="$myparam.upper='AB'"><xsl:value-of select="$myparam"/> (Exempt for resale)</xsl:when>
      		<xsl:when test="$myparam.upper='AC'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) not now due for payment)</xsl:when>
      		<xsl:when test="$myparam.upper='AD'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) due from a previous invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='AE'"><xsl:value-of select="$myparam"/> (VAT Reverse Charge)</xsl:when>
      		<xsl:when test="$myparam.upper='B'"><xsl:value-of select="$myparam"/> (Transferred (VAT))</xsl:when>
      		<xsl:when test="$myparam.upper='C'"><xsl:value-of select="$myparam"/> (Duty paid by supplier)</xsl:when>
      		<xsl:when test="$myparam.upper='D'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) margin scheme - travel agents)</xsl:when>
      		<xsl:when test="$myparam.upper='E'"><xsl:value-of select="$myparam"/> (Exempt from tax)</xsl:when>
      		<xsl:when test="$myparam.upper='F'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) margin scheme - second-hand goods)</xsl:when>
      		<xsl:when test="$myparam.upper='G'"><xsl:value-of select="$myparam"/> (Free export item, tax not charged)</xsl:when>
      		<xsl:when test="$myparam.upper='H'"><xsl:value-of select="$myparam"/> (Higher rate)</xsl:when>
      		<xsl:when test="$myparam.upper='I'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) margin scheme - works of art Margin scheme — Works of art)</xsl:when>
      		<xsl:when test="$myparam.upper='J'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) margin scheme - collector’s items and antiques)</xsl:when>
      		<xsl:when test="$myparam.upper='K'"><xsl:value-of select="$myparam"/> (VAT exempt for EEA intra-community supply of goods and services)</xsl:when>
      		<xsl:when test="$myparam.upper='L'"><xsl:value-of select="$myparam"/> (Canary Islands general indirect tax)</xsl:when>
      		<xsl:when test="$myparam.upper='M'"><xsl:value-of select="$myparam"/> (Tax for production, services and importation in Ceuta and Melilla)</xsl:when>
      		<xsl:when test="$myparam.upper='O'"><xsl:value-of select="$myparam"/> (Services outside scope of tax)</xsl:when>
      		<xsl:when test="$myparam.upper='S'"><xsl:value-of select="$myparam"/> (Standard rate)</xsl:when>
      		<xsl:when test="$myparam.upper='Z'"><xsl:value-of select="$myparam"/> (Zero rated goods)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>