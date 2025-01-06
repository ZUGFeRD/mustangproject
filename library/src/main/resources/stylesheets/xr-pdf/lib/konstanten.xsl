<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" 
              	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
              	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
               	xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
               	xmlns:xs="http://www.w3.org/2001/XMLSchema"
               	xmlns:xrv="http://www.example.org/XRechnung-Viewer"
               	xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions"                 	
               	version="2.0">

  <!-- ==========================================================================
  == Schriften
  =========================================================================== -->

  <xsl:variable name="fontSans">SourceSansPro</xsl:variable>
  <xsl:variable name="fontSerif">SourceSerifPro</xsl:variable>

  <xsl:variable name="amount-picture" select="xrf:_('amount-format')"/>
  <xsl:variable name="percentage-picture" select="xrf:_('percentage-format')"/>

  
  <!-- ==========================================================================
  == Attribute-Sets
  =========================================================================== -->

  <!-- Fliesstext -->
  <xsl:attribute-set name="fliesstext">
    <xsl:attribute name="font-family"><xsl:value-of select="$fontSans"/></xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">12pt</xsl:attribute>
    <xsl:attribute name="hyphenation-ladder-count">3</xsl:attribute>
    <xsl:attribute name="hyphenate">true</xsl:attribute>
    <xsl:attribute name="language">de</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- H1 Marker -->
  <xsl:attribute-set name="marker">
    <xsl:attribute name="font-size">18pt</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$fontSerif"/></xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="span">all</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- H1 -->
  <xsl:attribute-set name="h1">
    <xsl:attribute name="font-size">18pt</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$fontSerif"/></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="margin-bottom">4mm</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="span">all</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>    
  </xsl:attribute-set>
  
  <!-- H2-Container -->
  <xsl:attribute-set name="h2-container">
    <xsl:attribute name="border-top">0.5pt solid</xsl:attribute>
    <xsl:attribute name="padding-top">2.5pt</xsl:attribute>
    <xsl:attribute name="span">all</xsl:attribute>
    <xsl:attribute name="margin-bottom">4mm</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>    
  </xsl:attribute-set>
  
  <!-- H2 -->
  <xsl:attribute-set name="h2">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$fontSans"/></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="border">0.5pt solid</xsl:attribute>
    <xsl:attribute name="padding">4pt 6pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    <xsl:attribute name="margin">0</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- H3 -->
  <xsl:attribute-set name="h3">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$fontSans"/></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="margin-bottom">1mm</xsl:attribute>
    <xsl:attribute name="margin-left">2mm</xsl:attribute>
    <xsl:attribute name="margin-top">2mm</xsl:attribute>
    <xsl:attribute name="span">all</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Separator -->
  <xsl:attribute-set name="separator">
    <xsl:attribute name="margin-left">2mm</xsl:attribute>
    <xsl:attribute name="margin-bottom">3mm</xsl:attribute>
    <xsl:attribute name="border-bottom">0.5pt dotted</xsl:attribute>
    <xsl:attribute name="color">#999999</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Wert-Felder -->
  <xsl:variable name="wertHG">#eeeeee</xsl:variable>
  <xsl:variable name="wert-legende-breite">28</xsl:variable>
   
  <xsl:attribute-set name="wert-legende">
    <xsl:attribute name="font-size">7pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>        
    <xsl:attribute name="padding-top">1mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">1mm</xsl:attribute>
    <xsl:attribute name="margin-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="wert-ausgabe">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">10pt</xsl:attribute>
    <xsl:attribute name="background-color"><xsl:value-of select="$wertHG"/></xsl:attribute>
    <xsl:attribute name="padding-top">1mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">1mm</xsl:attribute>
    <xsl:attribute name="padding-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  </xsl:attribute-set>
   
  <!-- Rechnung-Felder -->
  <xsl:attribute-set name="rechnung-legende">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-left">0mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
    <xsl:attribute name="margin-left">0mm</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="rechnung-steuer">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-left">0mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
    <xsl:attribute name="margin-left">0mm</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="rechnung-wert">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="padding-top">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-left">0mm</xsl:attribute>
    <xsl:attribute name="padding-right">0mm</xsl:attribute>
    <xsl:attribute name="margin-left">0mm</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="rechnung-legende-summe">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="padding-top">0.4mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-left">0mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
    <xsl:attribute name="border-top">0.1pt solid #999999</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="rechnung-steuer-summe">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="padding-top">0.4mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-left">0mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
    <xsl:attribute name="border-top">0.1pt solid #999999</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="rechnung-wert-summe">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="padding-top">0.4mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">0.2mm</xsl:attribute>
    <xsl:attribute name="padding-left">0mm</xsl:attribute>
    <xsl:attribute name="padding-right">0mm</xsl:attribute>
    <xsl:attribute name="border-top">0.1pt solid #999999</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Box-Container -->
  <xsl:attribute-set name="box-container-kapitel">
    <xsl:attribute name="margin-bottom">10mm</xsl:attribute>
  </xsl:attribute-set>
   
  <xsl:attribute-set name="box-container-bereich">    
    <xsl:attribute name="margin-bottom">2mm</xsl:attribute>
    <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    <xsl:attribute name="span">all</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="box-container-inner">
    <xsl:attribute name="margin-bottom">2mm</xsl:attribute>    
  </xsl:attribute-set>
  
  <!-- Tabular invoice lines -->
  <xsl:attribute-set name="invoicelines-table">
    <xsl:attribute name="padding-left">2pt</xsl:attribute>
    <xsl:attribute name="padding-right">2pt</xsl:attribute>
    <xsl:attribute name="width">100%</xsl:attribute>
    <xsl:attribute name="table-layout">fixed</xsl:attribute>
    <xsl:attribute name="margin-bottom">2mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="invoicelines-table-header">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="invoicelines-table-row">
    <!-- Nested sub-invoice lines will recursively decrease font-size -->    
    <xsl:attribute name="font-size" select="if (self::xr:SUB_INVOICE_LINE) then '90%' else '100%'"/>
  </xsl:attribute-set>

  <xsl:attribute-set name="invoicelines-nested-info">
    <xsl:attribute name="font-size">80%</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>    
  </xsl:attribute-set>  

  <xsl:attribute-set name="invoicelines-allowances-table">
    <xsl:attribute name="padding-left">2pt</xsl:attribute>
    <xsl:attribute name="padding-right">2pt</xsl:attribute>
    <xsl:attribute name="width">100%</xsl:attribute>
    <xsl:attribute name="table-layout">fixed</xsl:attribute>
    <xsl:attribute name="font-size">80%</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>    
  </xsl:attribute-set>
  
</xsl:stylesheet>
