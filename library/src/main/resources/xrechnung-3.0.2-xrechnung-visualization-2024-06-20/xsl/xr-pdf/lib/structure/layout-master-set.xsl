<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" 
              	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
              	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
               	xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
               	version="2.0">

  <xsl:template name="generiere-layout-master-set">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="A4Hoch" 
                             page-height="297mm" 
                             page-width="210mm">
                             
        <fo:region-body   region-name="xrBody"
                          margin="20mm 10mm 20mm 20mm"
                          column-count="2"
                          column-gap="8mm"/>
                             
        <fo:region-before region-name="header" 
                          extent="20mm"/>
                             
        <fo:region-after  region-name="footer" 
                          extent="20mm"/>
                             
        <fo:region-start  region-name="innen" 
                          extent="20mm"/>
                          
        <fo:region-end    region-name="aussen" 
                          extent="10mm"/>
      </fo:simple-page-master>

      <fo:page-sequence-master master-name="xrDokument">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference master-reference="A4Hoch" />
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
    </fo:layout-master-set>
  </xsl:template>   
</xsl:stylesheet>
