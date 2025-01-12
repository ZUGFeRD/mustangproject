<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format"
              	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              	          xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
               	          xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
               	          xmlns:xs="http://www.w3.org/2001/XMLSchema"
               	          xmlns:xrv="http://www.example.org/XRechnung-Viewer"
               	          xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions"
                          xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
	        version="2.0">


  <xsl:template name="betragsUebersicht"/>


  <!-- ==========================================================================
       == Inhalt eines Kapitels
       =========================================================================== -->
  <xsl:template name="page">
    <xsl:param name="identifier"/>
    <xsl:param name="content"/>

    <xsl:if test="normalize-space($content)">

      <xsl:variable name="heading">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$identifier"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:call-template name="h1">
        <xsl:with-param name="titel" select="$heading/label"/>
      </xsl:call-template>
      
      <xsl:copy-of select="$content"/>

    </xsl:if>
  </xsl:template>


  <!-- ==========================================================================
       == Inhalt eines Abschnittes
       =========================================================================== -->
  <xsl:template name="box">
    <xsl:param name="identifier"/>
    <xsl:param name="content"/>

    <xsl:if test="normalize-space($content)">

      <xsl:variable name="heading">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$identifier"/>
        </xsl:call-template>
      </xsl:variable>
  
      <xsl:call-template name="h2">
        <xsl:with-param name="titel" select="$heading/label"/>
      </xsl:call-template>
  
      <!-- FIXME: keep-together.within-page="always" has been lost during refactor -->
      <xsl:for-each select="$content/*">
        <xsl:copy-of select="."/>
      </xsl:for-each>    
      <fo:block xsl:use-attribute-sets="box-container-bereich"/>    
    </xsl:if>
  </xsl:template>

  <xsl:template name="spanned-box">
    <xsl:param name="identifier"/>
    <xsl:param name="content"/>
    
    <xsl:if test="normalize-space($content)">
      
      <xsl:variable name="heading">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$identifier"/>
        </xsl:call-template>
      </xsl:variable>
      
      <fo:block xsl:use-attribute-sets="box-container-bereich" span="all">
        <xsl:call-template name="h2">
          <xsl:with-param name="titel" select="$heading/label"/>
        </xsl:call-template>
                
        <xsl:for-each select="$content/*">
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </fo:block>
      
    </xsl:if>
  </xsl:template>
  

  <!-- ==========================================================================
       == Inhalt eines Teilbereich eines Abschnittes
       =========================================================================== -->
  <xsl:template name="section">
    <xsl:param name="layout">zweispaltig</xsl:param>
    <xsl:param name="headingId"/>
    <xsl:param name="content"/>
    
    <xsl:if test="normalize-space($content)">
      <xsl:if test="$headingId">
        <xsl:variable name="heading">
          <xsl:call-template name="field-mapping">
            <xsl:with-param name="identifier" select="$headingId"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="h3">
          <xsl:with-param name="titel" select="$heading/label"/>
        </xsl:call-template>
      </xsl:if>
      <fo:block>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:if>    
  </xsl:template>


  <!-- ==========================================================================
       == Inhaltseinheit mit optionaler Überschrift
       =========================================================================== -->
  <xsl:template name="list">
    <xsl:param name="layout">zweispaltig</xsl:param>
    <xsl:param name="headingId"/>
    <xsl:param name="content"/>

    <xsl:if test="normalize-space($content)">

      <xsl:variable name="boxContent">
        <xsl:copy-of select="$content"/>
        <!-- Placeholder for spacing after the box -->
        <fo:block xsl:use-attribute-sets="box-container-inner" line-height="0pt" span="all"/>
      </xsl:variable>

      <xsl:if test="$headingId">
        <xsl:variable name="heading">
          <xsl:call-template name="field-mapping">
            <xsl:with-param name="identifier" select="$headingId"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="h3">
          <xsl:with-param name="titel" select="$heading/label"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:copy-of select="$boxContent"/>
    </xsl:if>
  </xsl:template>


  <!-- ==========================================================================
       ==
       =========================================================================== -->
  <xsl:template name="sub-list">
    <xsl:param name="layout">zweispaltig</xsl:param>
    <xsl:param name="content"/>

    <xsl:if test="normalize-space($content)">      
      <xsl:call-template name="list">
        <xsl:with-param name="layout" select="$layout"/>
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
      <!-- Placeholder for spacing after the box -->
      <fo:block xsl:use-attribute-sets="box-container-inner"  line-height="0pt" span="all"/>        
    </xsl:if>
  </xsl:template>


  <!-- ==========================================================================
       == Ausgabe eines Legende/Wert-Paares
       =========================================================================== -->
  <xsl:template match="@*|*" mode="list-entry">
    <xsl:param name="value"/>
    <xsl:param name="field-mapping-identifier">
      <xsl:value-of select="name()"/>
    </xsl:param>
    <xsl:if test="normalize-space(.)">
      <xsl:variable name="field-mapping">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$field-mapping-identifier"/>
        </xsl:call-template>
      </xsl:variable>
      <fo:list-block margin-bottom="1mm"
                     provisional-distance-between-starts="{$wert-legende-breite}mm">
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block xsl:use-attribute-sets="wert-legende"><xsl:value-of select="$field-mapping/label"/>:</fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block xsl:use-attribute-sets="wert-ausgabe">
              <xsl:choose>
                 <xsl:when test="$value">
                   <xsl:copy-of select="$value"/>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:choose>
                     <xsl:when test="$field-mapping-identifier = 'xr:Payment_due_date'"><xsl:value-of select="format-date(xs:date(.), xrf:_('date-format'))"/></xsl:when>
                     <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                   </xsl:choose>
                 </xsl:otherwise>
               </xsl:choose>
             </fo:block>
           </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="list-entry-bt-7">
    <xsl:param name="value"/>
    <xsl:param name="field-mapping-identifier">
      <xsl:value-of select="name()"/>
    </xsl:param>
    <xsl:if test="normalize-space(.)">
      <xsl:variable name="field-mapping">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$field-mapping-identifier"/>
        </xsl:call-template>
      </xsl:variable>
      <fo:list-block margin-bottom="1mm"
        provisional-distance-between-starts="{$wert-legende-breite}mm">
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block xsl:use-attribute-sets="wert-legende"><xsl:value-of select="$field-mapping/label"/>:</fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block xsl:use-attribute-sets="wert-ausgabe">
              <xsl:choose>
                <xsl:when test="$value">
                  <xsl:copy-of select="$value"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:if>
  </xsl:template>


  <!-- ==========================================================================
       == Ausgabe einer Tabelle
       =========================================================================== -->
  <xsl:template name="value-list">
    <xsl:param name="headingId"/>
    <xsl:param name="headingValue"/>
    <xsl:param name="content"/>

    <xsl:if test="normalize-space($content)">

      <xsl:variable name="boxContent">
        <fo:table xsl:use-attribute-sets="box-container-inner" margin-left="2mm"
                  keep-together.within-column="always">
          <fo:table-column column-number="1" column-width="68%"/>
          <fo:table-column column-number="2" column-width="10%"/>
          <fo:table-column column-number="3" column-width="22%"/>
          <fo:table-header>
            <fo:table-row><fo:table-cell><fo:block/></fo:table-cell></fo:table-row>
          </fo:table-header>
          <fo:table-body start-indent="0"
                         end-indent="0">
            <xsl:copy-of select="$content"/>
          </fo:table-body>
        </fo:table>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$headingId">
          <xsl:variable name="heading">
            <xsl:call-template name="field-mapping">
              <xsl:with-param name="identifier" select="$headingId"/>
            </xsl:call-template>
          </xsl:variable>
          <fo:block margin-left="2mm" font-weight="bold"><fo:inline><xsl:value-of select="$heading/label"/>: </fo:inline><fo:inline><xsl:value-of select="$headingValue"/>
          </fo:inline></fo:block>
          <xsl:copy-of select="$boxContent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$boxContent"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:if>
  </xsl:template>


  <xsl:template match="*|@*" mode="value-list-entry">
    <xsl:param name="value"/>    
    <xsl:param name="field-mapping-identifier">
      <xsl:value-of select="name()"/>
    </xsl:param>
    <xsl:if test="normalize-space(.)">
      <xsl:variable name="field-mapping">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$field-mapping-identifier"/>
        </xsl:call-template>
      </xsl:variable>
      <fo:table-row>
        <fo:table-cell xsl:use-attribute-sets="rechnung-legende"><fo:block><xsl:value-of select="$field-mapping/label"/></fo:block></fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="rechnung-steuer"><fo:block><xsl:value-of select="$field-mapping/art"/></fo:block></fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="rechnung-wert">
          <fo:block>
            <xsl:choose>
              <xsl:when test="$value">
                <xsl:value-of select="$value"/>
              </xsl:when>
              <xsl:otherwise>                
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>           
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*|@*" mode="sum-list-entry">
    <xsl:param name="level"/>
    <xsl:param name="value"/>
    <xsl:param name="field-mapping-identifier">
      <xsl:value-of select="name()"/>
    </xsl:param>
    
    <xsl:if test="normalize-space(.)">
      <xsl:variable name="field-mapping">
        <xsl:call-template name="field-mapping">
          <xsl:with-param name="identifier" select="$field-mapping-identifier"/>
        </xsl:call-template>
      </xsl:variable>
      <fo:table-row>
        <xsl:choose>
          <xsl:when test="$level='final'">
            <fo:table-cell xsl:use-attribute-sets="rechnung-legende-summe" font-weight="bold"><fo:block><xsl:value-of select="$field-mapping/label"/></fo:block></fo:table-cell>
          </xsl:when>
          <xsl:otherwise>
            <fo:table-cell xsl:use-attribute-sets="rechnung-legende-summe"><fo:block><xsl:value-of select="$field-mapping/label"/></fo:block></fo:table-cell>
          </xsl:otherwise>
        </xsl:choose>
        <fo:table-cell xsl:use-attribute-sets="rechnung-steuer-summe"><fo:block><xsl:value-of select="$field-mapping/art"/></fo:block></fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="rechnung-wert-summe">
          <fo:block>
            <xsl:choose>
              <xsl:when test="$value">
                <xsl:value-of select="$value"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>


  <!-- ==========================================================================
       == Ausgabe Resourcen / Links
       =========================================================================== -->

  <xsl:template match="*|@*" mode="internet-link">
    <xsl:param name="title" select="." />

    <xsl:if test="normalize-space(.)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*|@*" mode="file-link">
    <xsl:param name="title" select="'Öffnen'" />

    <xsl:if test="normalize-space(.)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*|@*" mode="binary">
    <xsl:param name="identifier"/>    
    <fo:basic-link>
      <xsl:attribute name="external-destination">url(embedded-file:<xsl:value-of select="encode-for-uri($identifier)"/>)</xsl:attribute>
      <xsl:value-of select="$identifier"/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="*|@*" mode="binary-declaration">
    <xsl:param name="identifier"/>   
      <pdf:embedded-file>
        <xsl:attribute name="filename"><xsl:value-of select="$identifier"/></xsl:attribute>
        <xsl:attribute name="src">data:application/pdf;base64,<xsl:value-of select="normalize-space(.)"/></xsl:attribute>
      </pdf:embedded-file> 
  </xsl:template>

  <!-- ==========================================================================
       == Detailpositionenen
       =========================================================================== -->

  <xsl:template match="xr:INVOICE_LINE">
    <xsl:variable name="identifier">
      <xsl:choose>
        <xsl:when test="$invoiceline-numbering = 'normal'">
          <xsl:value-of select="xr:Invoice_line_identifier"/>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="{$invoiceline-numbering}" 
            level="multiple" 
            count="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
  
    <xsl:call-template name="h2">
      <xsl:with-param name="titel" select="$identifier"/>
    </xsl:call-template>

    <xsl:variable name="content">
      <xsl:call-template name="detailsPosition"/>
    </xsl:variable>

    <xsl:for-each select="$content/*">
      <xsl:copy-of select="."/>
    </xsl:for-each>
    <xsl:apply-templates select="xr:SUB_INVOICE_LINE"/>
    
    <fo:block xsl:use-attribute-sets="box-container-bereich"/>      
  </xsl:template>
  
  <xsl:template match="xr:SUB_INVOICE_LINE">
    <xsl:variable name="identifier">
      <xsl:choose>
        <xsl:when test="$invoiceline-numbering = 'normal'">
          <xsl:value-of select="xr:Invoice_line_identifier"/>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="{$invoiceline-numbering}" 
            level="multiple" 
            count="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:call-template name="h2">
      <xsl:with-param name="titel" select="$identifier"/>
    </xsl:call-template>
    
    <xsl:variable name="content">
      <xsl:call-template name="detailsPosition"/>
    </xsl:variable>
    
    <xsl:for-each select="$content/*">
      <xsl:copy-of select="."/>
    </xsl:for-each>
    <xsl:apply-templates select="xr:SUB_INVOICE_LINE"/>
    <fo:block xsl:use-attribute-sets="box-container-bereich"/>      
  </xsl:template>


  <!-- ==========================================================================
       == Artikeleigenschaften
       =========================================================================== -->
  <xsl:template match="xr:ITEM_ATTRIBUTES">
    <fo:block-container margin-bottom="1mm">
      <fo:block-container margin="0mm">
        <fo:table margin-bottom="1mm">
          <fo:table-column>
            <xsl:attribute name="column-width"><xsl:value-of select="$wert-legende-breite"/>mm</xsl:attribute>
          </fo:table-column>
          <fo:table-column column-width="{86 - $wert-legende-breite}mm"/>
          <fo:table-header>
            <fo:table-row><fo:table-cell><fo:block/></fo:table-cell></fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:table width="100%">
                  <fo:table-header>
                    <fo:table-row><fo:table-cell><fo:block/></fo:table-cell></fo:table-row>
                  </fo:table-header>
                  <fo:table-body>
                    <fo:table-row>
                      <fo:table-cell xsl:use-attribute-sets="wert-ausgabe">
                        <fo:block><xsl:value-of select="xr:Item_attribute_name"/>:</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </fo:table-body>
                </fo:table>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="wert-ausgabe">
                <fo:block><xsl:value-of select="xr:Item_attribute_value"/></fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block-container>
    </fo:block-container>
  </xsl:template>


  <!-- ==========================================================================
       == Headlines
       =========================================================================== -->

  <xsl:template name="h1">
    <xsl:param name="titel"/>
    <!-- Markers are not working with flat blocks approach that must have been used to for two-column layout in FOP -->
    <!--
    <xsl:if test="not($axf.extensions)">
      <fo:block>
        <fo:marker marker-class-name="aktueller-bereich-forts"></fo:marker>
        <fo:leader/>
      </fo:block>
    </xsl:if>
    -->
    <fo:block xsl:use-attribute-sets="h1">
      <xsl:if test="$axf.extensions">
        <xsl:attribute name="axf:suppress-if-first-on-page">true</xsl:attribute>
        <xsl:attribute name="axf:pdftag">h1</xsl:attribute>
      </xsl:if>
      <!--
      <fo:marker marker-class-name="aktueller-bereich-forts">
        <fo:inline font-weight="bold"><xsl:value-of select="$titel"/></fo:inline>
        <xsl:text> (Fortsetzung)</xsl:text>
      </fo:marker>
      -->
      <xsl:value-of select="$titel"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="h2">
    <xsl:param name="titel"/>
    <fo:block xsl:use-attribute-sets="h2-container">
      <xsl:if test="$axf.extensions">
        <xsl:attribute name="axf:pdftag">h2</xsl:attribute>
      </xsl:if>
      <fo:inline xsl:use-attribute-sets="h2">
        <xsl:value-of select="$titel"/>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <xsl:template name="h3">
    <xsl:param name="titel"/>
    <fo:block xsl:use-attribute-sets="h3"><xsl:value-of select="$titel"/></fo:block>
  </xsl:template>

  <!-- ==========================================================================
       == Invoice lines in tabular presentation
       =========================================================================== -->
  
  <xsl:template match="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE" mode="invoiceline-tabular">
    <!-- Process basic information -->
    <fo:table-row xsl:use-attribute-sets="invoicelines-table-row">
      <fo:table-cell>
        <fo:block>
          <xsl:choose>
            <xsl:when test="$invoiceline-numbering = 'normal'">
              <xsl:value-of select="xr:Invoice_line_identifier"/>    
            </xsl:when>
            <xsl:otherwise>
              <xsl:number format="{$invoiceline-numbering}" 
                          level="multiple" 
                          count="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell padding-left="{count(ancestor-or-self::xr:SUB_INVOICE_LINE)}em">        
        <fo:block><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_name"/></fo:block>
      </fo:table-cell>
      <fo:table-cell text-align="center">
        <fo:block>
          <xsl:value-of select="xr:Invoiced_quantity"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="xr:Invoiced_quantity_unit_of_measure_code"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell text-align="right" padding-right="1em">
        <fo:block><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_net_price, $at-least-two-picture, $lang)"/></fo:block>
      </fo:table-cell>
      <fo:table-cell text-align="center">
        <fo:block>
          <xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity_unit_of_measure"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell text-align="center">
        <fo:block><xsl:value-of select="concat(format-number(xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate, $percentage-picture, $lang), '%')"/></fo:block>
      </fo:table-cell>
      <fo:table-cell text-align="center">
        <fo:block><xsl:value-of select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_category_code"/></fo:block>
      </fo:table-cell>
      <fo:table-cell text-align="right">
        <fo:block><xsl:value-of select="format-number(xr:Invoice_line_net_amount, $amount-picture, $lang)"/></fo:block>
      </fo:table-cell>      
    </fo:table-row>

    <xsl:if test="xr:ITEM_INFORMATION/xr:Item_description | xr:Invoice_line_note">
      <fo:table-row xsl:use-attribute-sets="invoicelines-table-row">
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>
        <fo:table-cell padding-left="{count(ancestor-or-self::xr:SUB_INVOICE_LINE)}em" number-columns-spanned="6">        
          <xsl:for-each select="xr:ITEM_INFORMATION/xr:Item_description | xr:Invoice_line_note">
            <fo:block>
              <xsl:value-of select="."/>
            </fo:block>
          </xsl:for-each>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>      
      </fo:table-row>
    </xsl:if>
    
    <xsl:if test="xr:Referenced_purchase_order_line_reference | xr:Invoice_line_Buyer_accounting_reference">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:if test="xr:Referenced_purchase_order_line_reference">
            <xsl:value-of select="xrf:field-label('xr:Referenced_purchase_order_line_reference')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xr:Referenced_purchase_order_line_reference"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="xr:Invoice_line_Buyer_accounting_reference">
            <xsl:value-of select="xrf:field-label('xr:Invoice_line_Buyer_accounting_reference')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xr:Invoice_line_Buyer_accounting_reference"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="xr:Invoice_line_object_identifier">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:value-of select="xrf:field-label('xr:Invoice_line_object_identifier')"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="xr:Invoice_line_object_identifier"/>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="xr:Invoice_line_object_identifier/@scheme_identifier">
            <xsl:value-of select="xrf:field-label('xr:Invoice_line_object_identifier/@scheme_identifier')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xr:Invoice_line_object_identifier/@scheme_identifier"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:if test="xr:INVOICE_LINE_PERIOD">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:if test="xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date">
            <xsl:value-of select="xrf:field-label('xr:Invoice_line_period_start_date')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date, xrf:_('date-format'))"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date">
            <xsl:value-of select="xrf:field-label('xr:Invoice_line_period_end_date')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date, xrf:_('date-format'))"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="xr:PRICE_DETAILS/xr:Item_price_discount | xr:PRICE_DETAILS/xr:Item_gross_price">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:if test="xr:PRICE_DETAILS/xr:Item_price_discount">
            <xsl:value-of select="xrf:field-label('xr:Item_price_discount')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_price_discount, $at-least-two-picture, $lang)"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="xr:PRICE_DETAILS/xr:Item_gross_price">
            <xsl:value-of select="xrf:field-label('xr:Item_gross_price')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_gross_price, $at-least-two-picture, $lang)"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier | xr:ITEM_INFORMATION/xr:Item_Buyers_identifier">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:if test="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier">
            <xsl:value-of select="xrf:field-label('xr:Item_Sellers_identifier')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier">
            <xsl:value-of select="xrf:field-label('xr:Item_Buyers_identifier')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="xr:ITEM_INFORMATION/xr:Item_standard_identifier">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:value-of select="xrf:field-label('xr:Item_standard_identifier')"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier"/>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="xr:ITEM_INFORMATION/xr:Item_standard_identifier/@scheme_identifier">
            <xsl:value-of select="xrf:field-label('xr:Item_standard_identifier/@scheme_identifier')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier/@scheme_identifier"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="xr:ITEM_INFORMATION/xr:Item_country_of_origin">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:value-of select="xrf:field-label('xr:Item_country_of_origin')"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_country_of_origin"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="xr:ITEM_INFORMATION/xr:Item_classification_identifier">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:value-of select="xrf:field-label('xr:Item_classification_identifier')"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="."/>
        </xsl:with-param>
        <xsl:with-param name="col2">
          <xsl:if test="@scheme_identifier">
            <xsl:value-of select="xrf:field-label('xr:Item_classification_identifier/@scheme_identifier')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@scheme_identifier"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col2">
          <xsl:if test="@scheme_version_identifier">
            <xsl:value-of select="xrf:field-label('xr:Item_classification_identifier/@scheme_version_identifier')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@scheme_version_identifier"/>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="xr:ITEM_INFORMATION/xr:ITEM_ATTRIBUTES">
      <xsl:call-template name="invoiceline-tabular-2-col-info">
        <xsl:with-param name="col1">
          <xsl:value-of select="xr:Item_attribute_name"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="xr:Item_attribute_value"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>      

    <xsl:if test="xr:INVOICE_LINE_ALLOWANCES">
      <fo:table-row xsl:use-attribute-sets="invoicelines-table-row">
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>
        <fo:table-cell padding-left="{count(ancestor-or-self::xr:SUB_INVOICE_LINE)}em" number-columns-spanned="6">
          <fo:table xsl:use-attribute-sets="invoicelines-allowances-table">
            <fo:table-column column-width="proportional-column-width(6)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="proportional-column-width(2)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="proportional-column-width(2)"/>
            <fo:table-header xsl:use-attribute-sets="invoicelines-table-header">
              <fo:table-row>
                <fo:table-cell>
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_allowance_reason')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <!-- Standard full description is too long -->
                    <!--<xsl:value-of select="xrf:field-label('xr:Invoice_line_allowance_reason_code')"/>-->
                    Code
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right" padding-right="1em">
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_allowance_base_amount')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="center">
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_allowance_percentage')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_allowance_amount')"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body>
              <xsl:for-each select="xr:INVOICE_LINE_ALLOWANCES">
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_allowance_reason"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_allowance_reason_code"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right" padding-right="1em">
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_allowance_base_amount"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="center">
                    <fo:block>
                      <xsl:value-of select="concat(format-number(xr:Invoice_line_allowance_percentage, $percentage-picture, $lang), '%')"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_allowance_amount"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>      
      </fo:table-row>
    </xsl:if>

    <xsl:if test="xr:INVOICE_LINE_CHARGES">
      <fo:table-row xsl:use-attribute-sets="invoicelines-table-row">
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>
        <fo:table-cell padding-left="{count(ancestor-or-self::xr:SUB_INVOICE_LINE)}em" number-columns-spanned="6">
          <fo:table xsl:use-attribute-sets="invoicelines-allowances-table">
            <fo:table-column column-width="proportional-column-width(6)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="proportional-column-width(2)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="proportional-column-width(2)"/>
            <fo:table-header xsl:use-attribute-sets="invoicelines-table-header">
              <fo:table-row>
                <fo:table-cell>
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_charge_reason')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <!-- Standard full description is too long -->
                    <!--<xsl:value-of select="xrf:field-label('xr:Invoice_line_charge_reason_code')"/>-->
                    Code
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right" padding-right="1em">
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_charge_base_amount')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="center">
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_charge_percentage')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block>
                    <xsl:value-of select="xrf:field-label('xr:Invoice_line_charge_amount')"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body>
              <xsl:for-each select="xr:INVOICE_LINE_CHARGES">
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_charge_reason"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_charge_reason_code"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right" padding-right="1em">
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_charge_base_amount"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="center">
                    <fo:block>
                      <xsl:value-of select="concat(format-number(xr:Invoice_line_charge_percentage, $percentage-picture, $lang), '%')" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right">
                    <fo:block>
                      <xsl:value-of select="xr:Invoice_line_charge_amount"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block/>
        </fo:table-cell>      
      </fo:table-row>
    </xsl:if>

    <xsl:apply-templates select="xr:SUB_INVOICE_LINE" mode="invoiceline-tabular"/>
  </xsl:template>

  <xsl:template name="invoiceline-tabular-2-col-info">
    <xsl:param name="col1"/>
    <xsl:param name="col2"/>

    <fo:table-row xsl:use-attribute-sets="invoicelines-nested-info">
      <fo:table-cell>
        <fo:block/>
      </fo:table-cell>
      <fo:table-cell padding-left="{count(ancestor-or-self::xr:SUB_INVOICE_LINE)}em" number-columns-spanned="6">
        <fo:list-block>
          <fo:list-item provisional-distance-between-starts="50%">
            <fo:list-item-label end-indent="label-end()">
              <fo:block>
                <xsl:copy-of select="$col1"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block>
                <xsl:copy-of select="$col2"/>
              </fo:block>                
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block/>
      </fo:table-cell>      
    </fo:table-row>
    
  </xsl:template>

</xsl:stylesheet>
