<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	        xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
	        xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"
	        xmlns:xrv="http://www.example.org/XRechnung-Viewer"          
	        version="2.0">


  <!-- ==========================================================================
       == Imports
       =========================================================================== -->
  <xsl:import href="common-xr.xsl"/>
  
  <xsl:import href="xr-content.xsl"/>

  <xsl:import href="xr-pdf/lib/konstanten.xsl"/>
  <xsl:import href="xr-pdf/lib/structure/layout-master-set.xsl"/>
  <xsl:import href="xr-pdf/lib/structure/content-templates.xsl"/>
  <xsl:import href="xr-pdf/lib/structure/page-sequence.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="utf-8" /> 

  <!-- FO engine used can be specified. Specific extensions will be then enabled. 
       Supported values are: 
            axf - Antenna House XSL Formatter
            fop - Apache FOP
       -->
  <xsl:param name="foengine"/>
  
  <!-- Layout of invoce lines: 
            normal - default behaviour
            tabular - table like
       -->
  <xsl:param name="invoiceline-layout">normal</xsl:param>

  <!-- Numbering of invoice line/sub lines 
            normal - use numbers from invoice
            1.1    - use multilevel arabic numbering
            1.i    - use mixture of arabic and roman numbering
            00001  - use arabic numbering and align them
                   - any picture string supported by xsl:number instruction can be used
       -->
  <xsl:param name="invoiceline-numbering">normal</xsl:param>
  
  <!-- This parameter can be used when different proportions of table columns
       are needed for tabular layout
       -->
  <xsl:param name="tabular-layout-widths">2 7 2 2 2 2 1.3 2</xsl:param>
  
  <xsl:param name="axf.extensions" select="if ($foengine eq 'axf') then true() else false()"/>
  <xsl:param name="fop.extensions" select="if ($foengine eq 'fop') then true() else false()"/>


  <!-- ==========================================================================
       == Basic structure
       =========================================================================== -->
  <xsl:template match="xr:invoice">
    <fo:root xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
      language="{$lang}" font-family="{$fontSans}">
      <xsl:call-template name="generiere-layout-master-set"/>
      <fo:declarations>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
              <dc:title><xsl:value-of select="xr:Invoice_number"/></dc:title>
              <!--
              <dc:creator></dc:creator>
              <dc:description></dc:description>
              -->
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
        <xsl:for-each select="xr:ADDITIONAL_SUPPORTING_DOCUMENTS">
          <xsl:apply-templates mode="binary-declaration" select="xr:Attached_document">
            <xsl:with-param name="identifier" select="xr:Attached_document/@filename"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </fo:declarations>
      <xsl:call-template name="generiere-page-sequence">
        <xsl:with-param name="body-content-flow">
          <fo:flow flow-name="xrBody"
            xsl:use-attribute-sets="fliesstext">
            <xsl:call-template name="uebersicht"/>
            <xsl:call-template name="details"/>
            <xsl:call-template name="zusaetze"/>
            <xsl:call-template name="anlagen"/>
            <xsl:call-template name="laufzettel"/>
            <fo:block id="seitenzahlLetzteSeite"></fo:block>
          </fo:flow>
        </xsl:with-param>
      </xsl:call-template>     
    </fo:root>
  </xsl:template>
  
  <xsl:template name="betragsUebersicht">
    <xsl:param name="betraege"/>
    <xsl:param name="gruende"/>
    <!-- TODO -->
  </xsl:template>
  
</xsl:stylesheet>
