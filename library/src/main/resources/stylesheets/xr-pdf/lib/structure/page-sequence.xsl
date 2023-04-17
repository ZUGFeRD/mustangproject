<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	              xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
	              xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
	              xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions"  	              
	              version="2.0">
  
   <xsl:template name="generiere-page-sequence">
     <xsl:param name="body-content-flow" required="yes" as="node()"/>
    <fo:page-sequence master-reference="xrDokument">
      
      <!-- Header -->
      <fo:static-content flow-name="header">
        <fo:block-container height="10mm"
                            display-align="after">
          <fo:block>
            <fo:table width="100%"
                      font-family="{$fontSans}" 
                      font-size="9pt">
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block font-weight="bold">
                      <xsl:value-of select="xrf:_('_no-content')"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell white-space="nowrap"
                                 text-align="end">
                    <fo:block>
                      <xsl:value-of select="./xr:SELLER/xr:Seller_VAT_identifier"/>/<xsl:value-of select="xr:Invoice_number"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>     
        </fo:block-container> 
        <fo:block-container height="17mm"
                            display-align="after">
          <fo:block xsl:use-attribute-sets="marker">
            <fo:inline>
              <fo:retrieve-marker retrieve-class-name="aktueller-bereich-forts" 
                                  retrieve-position="first-including-carryover"/>
            </fo:inline>
          </fo:block>  
        </fo:block-container>  
      </fo:static-content>

      <!-- Footer -->
      <fo:static-content flow-name="footer">
        <fo:block-container height="12mm"
                            display-align="after">
          <fo:block font-family="{$fontSans}" 
                    font-size="9pt"
                    text-align="center">
            <fo:block><xsl:value-of select="xrf:_('_page')"/><xsl:text> </xsl:text><fo:page-number/> / <fo:page-number-citation ref-id="seitenzahlLetzteSeite"/></fo:block>
          </fo:block>
        </fo:block-container>
      </fo:static-content>
      
      <!-- Content -->
      <xsl:copy-of select="$body-content-flow"/>
      
    </fo:page-sequence>
  </xsl:template>
  
</xsl:stylesheet>