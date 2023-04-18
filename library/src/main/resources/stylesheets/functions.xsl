<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions"  
  exclude-result-prefixes="xs math xrf"
  version="2.0">
  
  <!-- Language of output -->
  <xsl:param name="lang" select="'de'"/>
  
  <!-- Enable fallback lookup based on natural string in German --> 
  <xsl:param name="l10n-nl-lookup" select="false()"/>

  <!-- Filename with language file -->
  <xsl:variable name="l10n-filename" select="'l10n/' || $lang || '.xml'"/>

  <!-- Master localization file is German, it is used when key uses natural text in German to lookup proper key -->
  <xsl:variable name="l10n-master-filename" select="'l10n/de.xml'"/>
  
  <!-- Variable holding contents of l10n file -->
  <xsl:variable name="l10n-doc">
    <xsl:choose>
      <xsl:when test="doc-available($l10n-filename)">
        <xsl:sequence select="doc($l10n-filename)"/>
      </xsl:when>
      <xsl:when test="doc-available($l10n-master-filename)">
        <xsl:sequence select="doc($l10n-master-filename)"/>
        <!--<xsl:message>Unable to find localization for {$lang}. Using default from de.xml.</xsl:message>-->
      </xsl:when>
      <xsl:otherwise>
        <!--<xsl:message>Unable to find localization for {$lang}. Can't load default from de.xml. Using empty localization.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Variable holding contents of master l10n file -->
  <xsl:variable name="l10n-master-doc">
    <xsl:choose>
      <xsl:when test="doc-available($l10n-master-filename)">
        <xsl:sequence select="doc($l10n-master-filename)"/>
        <!--<xsl:message>Unable to find localization for {$lang}. Using default from de.xml.</xsl:message>-->
      </xsl:when>
      <xsl:otherwise>
        <!--<xsl:message>Unable to find localization for {$lang}. Can't load default from de.xml. Using empty localization.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Key for quicker lookups of localized strings -->
  <xsl:key name="l10n" match="entry" use="@key"/>

  <!-- Key for quicker lookups of key for string -->
  <xsl:key name="l10n-key" match="entry" use="normalize-space(.)"/>  

  <!-- Function returning localized string -->
  <xsl:function name="xrf:_" as="xs:string">
    <xsl:param name="key" as="xs:string"/>
    
    <xsl:variable name="localized" select="key('l10n', $key, $l10n-doc)"/>
    
    <xsl:choose>
      <xsl:when test="$localized">
        <xsl:sequence select="string($localized)"/>
      </xsl:when>
      <xsl:when test="$l10n-nl-lookup">
        <!-- Some transformations use natural text in German as translation keys -->
        <xsl:variable name="key2" select="(key('l10n-key', $key, $l10n-master-doc)/@key)[1]"/>
        <xsl:variable name="localized2" select="key('l10n', $key2, $l10n-doc)"/>
        
        <xsl:choose>
          <xsl:when test="$localized2">
            <xsl:sequence select="string($localized2)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$key"/>
            <!--<xsl:message>Unable to find localization for {$key}.</xsl:message>-->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>      
      <xsl:otherwise>
        <xsl:sequence select="'???' || $key || '???'"/>
        <!--<xsl:message>Unable to find localization for {$key}.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- Function returning ID of localized string. 
       ID is holding original BT/BG number from EU norm -->
  <xsl:function name="xrf:get-id" as="xs:string">
    <xsl:param name="key" as="xs:string"/>
    
    <xsl:variable name="localized" select="key('l10n', $key, $l10n-doc)"/>
    
    <xsl:choose>
      <xsl:when test="$localized/@id">
        <xsl:sequence select="$localized/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'???'"/>
        <!--<xsl:message>Unable to find BT/BG id for {$key}.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- We are emulating older template for getting labels in order to maintain backward compatability -->
  <xsl:template name="field-mapping">
    <xsl:param name="identifier"/>
    
    <label><xsl:value-of select="xrf:_($identifier)"/></label>
    <nummer><xsl:value-of select="xrf:get-id($identifier)"/></nummer>
  </xsl:template>
  
  
  <xsl:function name="xrf:field-label" as="xs:string">
    <xsl:param name="identifier"/>
    
    <xsl:sequence select="xrf:_($identifier)"></xsl:sequence>
  </xsl:function>  

  <xsl:variable name="amount-picture" select="xrf:_('amount-format')" />
  <xsl:variable name="at-least-two-picture" select="xrf:_('at-least-two-format')" />

  <xsl:function name="xrf:format-with-at-least-two-digits" as="xs:string">
      <xsl:param name="input-number"/>    
      <xsl:param name="lang"/>    
          
      <xsl:choose>
          <xsl:when test="string-length(substring-after(xs:string($input-number), '.'))>2">
              <xsl:sequence select="format-number($input-number,$at-least-two-picture,$lang)"></xsl:sequence>
          </xsl:when>
          <xsl:otherwise>                
              <xsl:sequence select="format-number($input-number,$amount-picture,$lang)"></xsl:sequence>
          </xsl:otherwise>
      </xsl:choose>                   
  </xsl:function>

</xsl:stylesheet>