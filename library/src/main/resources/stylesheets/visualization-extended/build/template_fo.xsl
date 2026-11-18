<?xml version="1.0" encoding="UTF-8"?>
<!--
  ZUGFeRD 2.5.2 / Factur-X 1.09.2 - Profil EXTENDED - PDF-Visualisierung (XSL-FO)
  ==============================================================================
  Wandelt eine ZUGFeRD/Factur-X CII-Rechnung (rsm:CrossIndustryInvoice) in
  XSL-FO um, z. B. für Apache FOP. Inhalt und Beschriftungen entsprechen der
  HTML-Visualisierung (ZUGFeRD_EXTENDED_html.xsl); alle im Profil EXTENDED
  vorgesehenen Informationen werden dargestellt.

  Parameter
    lang      de | en | fr   Sprache der Beschriftungen (Standard: de)
    showBT    (leer) | true  Falls gesetzt (nicht leer und nicht false/0/no/nein),
                             werden die BT-/BG-/BT-X-Kennungen neben den
                             Feldnamen angezeigt.
    details   true | false   Alle Angaben je Position in kleiner Schrift unter
                             der Position ausgeben (Standard: true)
    font      Schriftfamilie (Standard: SourceSansPro, wie in der
              fop-config.xconf von Mustang). Für PDF/A muss die Schrift in
              der FOP-Konfiguration eingebettet sein.

  Profile
    Verarbeitet alle Profile (MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED,
    XRECHNUNG); nicht vorhandene Angaben bzw. Abschnitte werden ausgelassen.

  Anlagen (AttachmentBinaryObject) werden über die FOP-Erweiterung
  pdf:embedded-file als Dateien in das PDF eingebettet (im PDF-Viewer unter
  "Anlagen"/"Attachments"). Sie werden bewusst nicht verlinkt, da FOP solche
  Verweise als JavaScript-Aktion umsetzt, die in PDF/A nicht zulässig ist.

  Aufruf (Beispiele)
    java -jar saxon-he.jar -s:rechnung.xml -xsl:ZUGFeRD_EXTENDED_fo.xsl -o:rechnung.fo lang=en showBT=true
    fop -c fop-config.xconf -pdfprofile PDF/A-3b -fo rechnung.fo -pdf rechnung.pdf
    (oder direkt: fop -xml rechnung.xml -xsl ZUGFeRD_EXTENDED_fo.xsl -pdf rechnung.pdf)

  XSLT 1.0. Optional wird exsl:node-set genutzt, falls vorhanden (siehe
  Ligaturen unten); sonst keine Erweiterungsfunktionen. Die Beschriftungen, Codelisten und
  BT-Zuordnungen sind in diesem Stylesheet eingebettet (zv:data) und werden
  per document('') gelesen - das Stylesheet muss daher mit einer System-ID
  (Datei-/URL-Pfad) geladen werden.

  Diese Datei wird von build/build_xsl.py erzeugt - Änderungen bitte in
  build/template_fo.xsl, build/common.xsl bzw. build/build_xsl.py vornehmen.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
  xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
  xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
  xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
  xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
  xmlns:zv="urn:mustangproject:zugferd:visualization"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="rsm ram udt qdt zv exsl">

  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

<!--@@COMMON@@-->

  <xsl:param name="details" select="'true'"/>
  <xsl:param name="font" select="'SourceSansPro'"/>

  <xsl:variable name="detNorm" select="translate(normalize-space($details),'FALSENOI','falsenoi')"/>
  <xsl:variable name="DETON" select="not($detNorm='false' or $detNorm='0' or $detNorm='no' or $detNorm='nein' or $detNorm='off')"/>

  <!-- Farben (wie HTML) -->
  <xsl:variable name="cFg"      select="'#1c2330'"/>
  <xsl:variable name="cMuted"   select="'#5f6b7c'"/>
  <xsl:variable name="cLine"    select="'#c9d0da'"/>
  <xsl:variable name="cSoft"    select="'#f5f7fa'"/>
  <xsl:variable name="cAcc"     select="'#1f4e8c'"/>
  <xsl:variable name="cAccSoft" select="'#e8eff8'"/>

  <!-- Breite der Beschriftungsspalte bei Feldern -->
  <xsl:variable name="KW" select="'32mm'"/>

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyzäöüàâáçéèêëîïíôóûùúÿœæ'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜÀÂÁÇÉÈÊËÎÏÍÔÓÛÙÚŸŒÆ'"/>

  <xsl:attribute-set name="h2">
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="font-weight">700</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$cAcc"/></xsl:attribute>
    <xsl:attribute name="border-bottom">1.2pt solid <xsl:value-of select="$cAcc"/></xsl:attribute>
    <xsl:attribute name="padding-bottom">1.5pt</xsl:attribute>
    <xsl:attribute name="space-before">12pt</xsl:attribute>
    <xsl:attribute name="space-after">5pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="tbl">
    <xsl:attribute name="table-layout">fixed</xsl:attribute>
    <xsl:attribute name="width">100%</xsl:attribute>
    <xsl:attribute name="border-collapse">collapse</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="th">
    <xsl:attribute name="font-size">7pt</xsl:attribute>
    <xsl:attribute name="font-weight">700</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$cMuted"/></xsl:attribute>
    <xsl:attribute name="border-bottom">0.8pt solid <xsl:value-of select="$cFg"/></xsl:attribute>
    <xsl:attribute name="padding">2pt 3pt</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="td">
    <xsl:attribute name="border-bottom">0.4pt solid <xsl:value-of select="$cLine"/></xsl:attribute>
    <xsl:attribute name="padding">2.5pt 3pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="box">
    <xsl:attribute name="border">0.5pt solid <xsl:value-of select="$cLine"/></xsl:attribute>
    <xsl:attribute name="padding">5pt 6pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- ================================================================== -->
  <!--  Einstieg                                                           -->
  <!-- ================================================================== -->

  <xsl:template match="/">
    <xsl:choose>
      <!-- Zweiter Durchgang (nur falls exsl:node-set verfügbar ist, z. B. Saxon,
           Xalan, libxslt): FOP setzt bei OpenType-Schriften wie Source Sans Pro
           die Ligatur "ft" als Glyphe ohne Unicode-Zuordnung; im PDF wären dann
           Suche und Kopieren von Wörtern wie "Auftrag" gestört. Ein Wortverbinder
           (U+2060) zwischen f und t verhindert die Ligatur, ohne das Schriftbild
           zu ändern. -->
      <xsl:when test="function-available('exsl:node-set')">
        <xsl:variable name="fo"><xsl:call-template name="main"/></xsl:variable>
        <xsl:apply-templates select="exsl:node-set($fo)/node()" mode="lig"/>
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="main"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@* | node()" mode="lig">
    <xsl:copy><xsl:apply-templates select="@* | node()" mode="lig"/></xsl:copy>
  </xsl:template>

  <xsl:template match="fo:declarations" mode="lig">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()[contains(.,'ft')]" mode="lig">
    <xsl:call-template name="noLig"><xsl:with-param name="s" select="string(.)"/></xsl:call-template>
  </xsl:template>

  <xsl:template name="noLig">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="contains($s,'ft')">
        <xsl:value-of select="substring-before($s,'ft')"/>
        <xsl:text>f&#x2060;</xsl:text>
        <xsl:call-template name="noLig"><xsl:with-param name="s" select="concat('t',substring-after($s,'ft'))"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="main">
    <xsl:choose>
      <xsl:when test="$CII">
        <xsl:apply-templates select="$CII"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:root font-family="{$font}" font-size="10pt">
          <fo:layout-master-set>
            <fo:simple-page-master master-name="A4" page-height="297mm" page-width="210mm" margin="20mm">
              <fo:region-body/>
            </fo:simple-page-master>
          </fo:layout-master-set>
          <fo:page-sequence master-reference="A4">
            <fo:flow flow-name="xsl-region-body">
              <fo:block><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.nocii'"/></xsl:call-template></fo:block>
            </fo:flow>
          </fo:page-sequence>
        </fo:root>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rsm:CrossIndustryInvoice">
    <xsl:variable name="docType">
      <xsl:call-template name="codeName">
        <xsl:with-param name="list" select="'1001'"/>
        <xsl:with-param name="v" select="$DOC/ram:TypeCode"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="string($docType)!=''"><xsl:value-of select="$docType"/></xsl:when>
        <xsl:otherwise><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.invoice'"/></xsl:call-template></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:root xml:lang="{$L}" font-family="{$font}" font-size="8.5pt" line-height="1.3" color="{$cFg}">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="A4" page-height="297mm" page-width="210mm"
                               margin-top="14mm" margin-bottom="9mm" margin-left="18mm" margin-right="16mm">
          <fo:region-body margin-bottom="11mm"/>
          <fo:region-after extent="7mm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:declarations>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
              <dc:title><rdf:Alt><rdf:li xml:lang="x-default"><xsl:value-of select="concat($title,' ',normalize-space($DOC/ram:ID))"/></rdf:li></rdf:Alt></dc:title>
              <xsl:if test="normalize-space($A/ram:SellerTradeParty/ram:Name) != ''">
                <dc:creator><rdf:Seq><rdf:li><xsl:value-of select="normalize-space($A/ram:SellerTradeParty/ram:Name)"/></rdf:li></rdf:Seq></dc:creator>
              </xsl:if>
              <dc:description><rdf:Alt><rdf:li xml:lang="x-default"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.footer'"/></xsl:call-template></rdf:li></rdf:Alt></dc:description>
            </rdf:Description>
            <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
              <xmp:CreatorTool>ZUGFeRD 2.5.2 EXTENDED PDF visualization (XSLT)</xmp:CreatorTool>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
        <xsl:for-each select="//ram:AttachmentBinaryObject[normalize-space(.) != '']">
          <xsl:variable name="fn"><xsl:call-template name="attName"/></xsl:variable>
          <pdf:embedded-file filename="{$fn}" src="url('data:{normalize-space(@mimeCode)};base64,{translate(.,' &#9;&#10;&#13;','')}')">
            <xsl:if test="../ram:Name | ../ram:IssuerAssignedID">
              <xsl:attribute name="description"><xsl:value-of select="normalize-space((../ram:Name | ../ram:IssuerAssignedID)[1])"/></xsl:attribute>
            </xsl:if>
          </pdf:embedded-file>
        </xsl:for-each>
      </fo:declarations>
      <fo:page-sequence master-reference="A4">
        <fo:static-content flow-name="xsl-region-after">
          <fo:table xsl:use-attribute-sets="tbl" font-size="7pt" color="{$cMuted}">
            <fo:table-column column-width="proportional-column-width(3)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell border-top="0.4pt solid {$cLine}" padding-top="2pt">
                  <fo:block>
                    <xsl:value-of select="$title"/><xsl:text> </xsl:text><xsl:value-of select="$DOC/ram:ID"/>
                    <xsl:text> · </xsl:text>
                    <xsl:value-of select="$A/ram:SellerTradeParty/ram:Name"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border-top="0.4pt solid {$cLine}" padding-top="2pt">
                  <fo:block text-align="end">
                    <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.page'"/></xsl:call-template>
                    <xsl:text> </xsl:text><fo:page-number/><xsl:text> </xsl:text>
                    <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.pageof'"/></xsl:call-template>
                    <xsl:text> </xsl:text><fo:page-number-citation ref-id="zv-last"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <xsl:if test="$CTX/ram:TestIndicator/udt:Indicator='true'">
            <fo:block background-color="#fff1d6" border="0.5pt solid #f0c36d" color="#7a4b00" padding="3pt" space-after="8pt" font-weight="700" text-align="center">
              <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.testbanner'"/></xsl:call-template>
            </fo:block>
          </xsl:if>
          <xsl:if test="$DOC/ram:CopyIndicator/udt:Indicator='true'">
            <fo:block background-color="#eef2f7" border="0.5pt solid #c7d1de" color="{$cMuted}" padding="3pt" space-after="8pt" font-weight="700" text-align="center">
              <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.copybanner'"/></xsl:call-template>
            </fo:block>
          </xsl:if>

          <xsl:call-template name="header">
            <xsl:with-param name="title" select="$title"/>
          </xsl:call-template>
          <xsl:call-template name="notes"/>
          <xsl:call-template name="otherParties"/>
          <xsl:call-template name="references"/>
          <xsl:call-template name="lines"/>
          <xsl:call-template name="docAllowances"/>
          <xsl:call-template name="logistics"/>
          <xsl:call-template name="vatBreakdown"/>
          <xsl:call-template name="totals"/>
          <xsl:call-template name="payment"/>
          <xsl:call-template name="furtherSettlement"/>
          <xsl:call-template name="footer"/>
          <fo:block id="zv-last" font-size="1pt" line-height="1pt"/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Kopf: Verkäufer, Käufer, Eckdaten                                  -->
  <!-- ================================================================== -->

  <xsl:template name="header">
    <xsl:param name="title"/>
    <fo:table xsl:use-attribute-sets="tbl">
      <fo:table-column column-width="proportional-column-width(55)"/>
      <fo:table-column column-width="proportional-column-width(45)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell padding-end="8pt">
            <xsl:apply-templates select="$A/ram:SellerTradeParty" mode="party">
              <xsl:with-param name="main" select="'seller'"/>
            </xsl:apply-templates>
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block text-align="end" font-size="17pt" font-weight="700" line-height="1.15" color="{$cAcc}">
              <xsl:value-of select="$title"/>
              <xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:TypeCode"/></xsl:call-template>
            </fo:block>
            <fo:block text-align="end" font-size="10.5pt" space-before="2pt">
              <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.docno'"/></xsl:call-template>
              <xsl:text> </xsl:text>
              <fo:inline font-weight="700"><xsl:value-of select="$DOC/ram:ID"/></fo:inline>
              <xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:ID"/></xsl:call-template>
            </fo:block>
            <xsl:if test="$DOC/ram:Name">
              <fo:block text-align="end" color="{$cMuted}">
                <xsl:value-of select="$DOC/ram:Name"/>
                <xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:Name"/></xsl:call-template>
              </fo:block>
            </xsl:if>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <fo:table xsl:use-attribute-sets="tbl" space-before="12pt">
      <fo:table-column column-width="proportional-column-width(55)"/>
      <fo:table-column column-width="proportional-column-width(45)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell padding-end="8pt">
            <xsl:apply-templates select="$A/ram:BuyerTradeParty" mode="party">
              <xsl:with-param name="main" select="'buyer'"/>
            </xsl:apply-templates>
            <fo:block/>
          </fo:table-cell>
          <fo:table-cell background-color="{$cSoft}" padding="5pt 7pt">
            <xsl:call-template name="row">
              <xsl:with-param name="k" select="'ui.invdate'"/>
              <xsl:with-param name="n" select="$DOC/ram:IssueDateTime"/>
            </xsl:call-template>
            <xsl:for-each select="$D/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime">
              <xsl:call-template name="row"><xsl:with-param name="k" select="'ui.deliverydate'"/></xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$S/ram:BillingSpecifiedPeriod">
              <xsl:call-template name="kv">
                <xsl:with-param name="k">
                  <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.period'"/></xsl:call-template>
                  <xsl:call-template name="bt"/>
                </xsl:with-param>
                <xsl:with-param name="v"><xsl:call-template name="period"/></xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$S/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime">
              <xsl:call-template name="row"><xsl:with-param name="k" select="'ui.duedate'"/></xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$DOC/ram:EffectiveSpecifiedPeriod/ram:CompleteDateTime">
              <xsl:call-template name="row"/>
            </xsl:for-each>
            <xsl:for-each select="$A/ram:BuyerReference">
              <xsl:call-template name="row"/>
            </xsl:for-each>
            <xsl:for-each select="$A/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
              <xsl:call-template name="row"><xsl:with-param name="k" select="'ui.orderno'"/></xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$S/ram:InvoiceCurrencyCode | $S/ram:TaxCurrencyCode">
              <xsl:call-template name="row"/>
            </xsl:for-each>
            <xsl:for-each select="$SUM/ram:DuePayableAmount">
              <fo:block border-top="0.5pt solid {$cLine}" space-before="3pt" padding-top="3pt" font-weight="700" font-size="10pt">
                <xsl:call-template name="kv">
                  <xsl:with-param name="k"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></xsl:with-param>
                  <xsl:with-param name="v"><xsl:call-template name="amt"><xsl:with-param name="n" select="."/><xsl:with-param name="cur" select="true()"/></xsl:call-template></xsl:with-param>
                  <xsl:with-param name="kcolor" select="$cFg"/>
                </xsl:call-template>
              </fo:block>
            </xsl:for-each>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

    <!-- Allgemeine Angaben (Kontext, Sprache, Referenz Rechnungssteller ...) -->
    <xsl:variable name="info" select="$CTX/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID
                                    | $CTX/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID
                                    | $CTX/ram:TestIndicator
                                    | $DOC/ram:TypeCode | $DOC/ram:CopyIndicator | $DOC/ram:LanguageID
                                    | $S/ram:InvoiceIssuerReference"/>
    <fo:block xsl:use-attribute-sets="box" space-before="10pt" font-size="7.5pt">
      <fo:block color="{$cAcc}" font-weight="700" space-after="2pt" keep-with-next.within-page="always">
        <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.general'"/></xsl:call-template>
        <fo:inline color="{$cMuted}" font-weight="400">
          <xsl:text> · </xsl:text>
          <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.profile'"/></xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="profileName"/>
        </fo:inline>
      </fo:block>
      <xsl:call-template name="cols2">
        <xsl:with-param name="nodes" select="$info"/>
        <xsl:with-param name="mode" select="'f'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Bemerkungen                                                        -->
  <!-- ================================================================== -->

  <xsl:template name="notes">
    <xsl:if test="$DOC/ram:IncludedNote">
      <xsl:call-template name="h2">
        <xsl:with-param name="k" select="'ui.notes'"/>
        <xsl:with-param name="n" select="$DOC/ram:IncludedNote"/>
      </xsl:call-template>
      <xsl:for-each select="$DOC/ram:IncludedNote">
        <fo:block border-left="2pt solid {$cAccSoft}" padding-start="6pt" space-before="3pt" space-after="3pt">
          <xsl:if test="ram:SubjectCode or ram:ContentCode">
            <fo:block font-size="7.5pt" color="{$cMuted}">
              <xsl:for-each select="ram:SubjectCode">
                <xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/>
              </xsl:for-each>
              <xsl:for-each select="ram:ContentCode">
                <xsl:if test="../ram:SubjectCode"><xsl:text> · </xsl:text></xsl:if>
                <xsl:call-template name="lbl"/><xsl:text>: </xsl:text><xsl:value-of select="."/><xsl:call-template name="bt"/>
              </xsl:for-each>
            </fo:block>
          </xsl:if>
          <xsl:call-template name="pre">
            <xsl:with-param name="s" select="ram:Content"/>
            <xsl:with-param name="bt" select="ram:Content"/>
          </xsl:call-template>
        </fo:block>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Weitere Beteiligte                                                 -->
  <!-- ================================================================== -->

  <xsl:template name="otherParties">
    <xsl:variable name="parties" select="$A/ram:SellerTaxRepresentativeTradeParty | $A/ram:SalesAgentTradeParty
                                       | $A/ram:BuyerTaxRepresentativeTradeParty | $A/ram:BuyerAgentTradeParty
                                       | $A/ram:ProductEndUserTradeParty
                                       | $D/ram:ShipToTradeParty | $D/ram:UltimateShipToTradeParty | $D/ram:ShipFromTradeParty
                                       | $S/ram:InvoicerTradeParty | $S/ram:InvoiceeTradeParty
                                       | $S/ram:PayeeTradeParty | $S/ram:PayerTradeParty"/>
    <xsl:if test="$parties">
      <xsl:call-template name="h2"><xsl:with-param name="k" select="'ui.parties'"/></xsl:call-template>
      <xsl:call-template name="grid2">
        <xsl:with-param name="nodes" select="$parties"/>
        <xsl:with-param name="mode" select="'party'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Darstellung einer beliebigen Partei (TradePartyType) -->
  <xsl:template match="*" mode="party">
    <xsl:param name="main" select="''"/>
    <fo:block keep-together.within-page="always">
      <xsl:if test="$main = ''">
        <xsl:attribute name="border">0.5pt solid <xsl:value-of select="$cLine"/></xsl:attribute>
        <xsl:attribute name="padding">4pt 6pt</xsl:attribute>
        <xsl:attribute name="space-after">4pt</xsl:attribute>
      </xsl:if>
      <fo:block font-size="6.5pt" color="{$cMuted}">
        <xsl:call-template name="uc"><xsl:with-param name="s"><xsl:call-template name="lbl"/></xsl:with-param></xsl:call-template>
        <xsl:call-template name="bt"/>
      </fo:block>
      <xsl:for-each select="ram:Name">
        <fo:block font-weight="700">
          <xsl:attribute name="font-size">
            <xsl:choose>
              <xsl:when test="$main = 'seller'">12pt</xsl:when>
              <xsl:when test="$main = 'buyer'">10pt</xsl:when>
              <xsl:otherwise>9pt</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="."/><xsl:call-template name="bt"/>
        </fo:block>
      </xsl:for-each>
      <xsl:for-each select="ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
        <fo:block color="{$cMuted}"><xsl:value-of select="."/><xsl:call-template name="bt"/></fo:block>
      </xsl:for-each>
      <xsl:apply-templates select="ram:PostalTradeAddress" mode="addr"/>
      <fo:block font-size="7.5pt" space-before="2pt">
        <xsl:apply-templates select="ram:ID | ram:GlobalID | ram:RoleCode
                                   | ram:SpecifiedTaxRegistration/ram:ID
                                   | ram:SpecifiedLegalOrganization/ram:ID
                                   | ram:URIUniversalCommunication/ram:URIID
                                   | ram:Description" mode="f"/>
        <xsl:for-each select="ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
          <xsl:call-template name="kv">
            <xsl:with-param name="k"><xsl:call-template name="lbl"><xsl:with-param name="n" select=".."/></xsl:call-template></xsl:with-param>
            <xsl:with-param name="v"><xsl:apply-templates select="." mode="addrInline"/></xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="ram:DefinedTradeContact">
          <fo:block border-top="0.4pt dashed {$cLine}" space-before="2pt" padding-top="2pt">
            <xsl:apply-templates select="ram:PersonName | ram:DepartmentName | ram:TypeCode
                                       | ram:TelephoneUniversalCommunication/ram:CompleteNumber
                                       | ram:FaxUniversalCommunication/ram:CompleteNumber
                                       | ram:EmailURIUniversalCommunication/ram:URIID" mode="f"/>
          </fo:block>
        </xsl:for-each>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="*" mode="addr">
    <fo:block space-before="1pt">
      <xsl:for-each select="ram:LineOne | ram:LineTwo | ram:LineThree">
        <fo:block><xsl:value-of select="."/><xsl:call-template name="bt"/></fo:block>
      </xsl:for-each>
      <xsl:if test="ram:PostcodeCode or ram:CityName">
        <fo:block>
          <xsl:value-of select="ram:PostcodeCode"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:PostcodeCode"/></xsl:call-template>
          <xsl:if test="ram:PostcodeCode and ram:CityName"><xsl:text> </xsl:text></xsl:if>
          <xsl:value-of select="ram:CityName"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CityName"/></xsl:call-template>
        </fo:block>
      </xsl:if>
      <xsl:for-each select="ram:CountrySubDivisionName">
        <fo:block><xsl:value-of select="."/><xsl:call-template name="bt"/></fo:block>
      </xsl:for-each>
      <xsl:for-each select="ram:CountryID">
        <fo:block><xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/></fo:block>
      </xsl:for-each>
    </fo:block>
  </xsl:template>

  <!-- Anschrift einzeilig (innerhalb eines Feldwerts) -->
  <xsl:template match="*" mode="addrInline">
    <xsl:for-each select="ram:LineOne | ram:LineTwo | ram:LineThree | ram:PostcodeCode | ram:CityName | ram:CountrySubDivisionName | ram:CountryID">
      <xsl:if test="position() &gt; 1">
        <xsl:choose>
          <xsl:when test="self::ram:CityName and preceding-sibling::ram:PostcodeCode"><xsl:text> </xsl:text></xsl:when>
          <xsl:otherwise><xsl:text>, </xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/>
    </xsl:for-each>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Referenzen                                                         -->
  <!-- ================================================================== -->

  <xsl:template name="references">
    <xsl:variable name="docs" select="$A/ram:SellerOrderReferencedDocument | $A/ram:BuyerOrderReferencedDocument
                                    | $A/ram:QuotationReferencedDocument | $A/ram:ContractReferencedDocument
                                    | $A/ram:AdditionalReferencedDocument | $A/ram:UltimateCustomerOrderReferencedDocument
                                    | $D/ram:DespatchAdviceReferencedDocument | $D/ram:ReceivingAdviceReferencedDocument
                                    | $D/ram:DeliveryNoteReferencedDocument
                                    | $S/ram:InvoiceReferencedDocument"/>
    <xsl:variable name="misc" select="$A/ram:SpecifiedProcuringProject | $A/ram:ApplicableTradeDeliveryTerms
                                    | $D/ram:RelatedSupplyChainConsignment"/>
    <xsl:if test="$docs or $misc">
      <xsl:call-template name="h2"><xsl:with-param name="k" select="'ui.refs'"/></xsl:call-template>
      <xsl:if test="$docs">
        <fo:table xsl:use-attribute-sets="tbl">
          <fo:table-column column-width="proportional-column-width(22)"/>
          <fo:table-column column-width="proportional-column-width(20)"/>
          <fo:table-column column-width="proportional-column-width(8)"/>
          <fo:table-column column-width="proportional-column-width(12)"/>
          <fo:table-column column-width="proportional-column-width(38)"/>
          <fo:table-header>
            <fo:table-row>
              <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.document'"/></xsl:call-template>
              <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.number'"/></xsl:call-template>
              <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.lineref'"/></xsl:call-template>
              <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.date'"/></xsl:call-template>
              <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.moreinfo'"/></xsl:call-template>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:for-each select="$docs">
              <fo:table-row keep-together.within-page="always">
                <fo:table-cell xsl:use-attribute-sets="td"><fo:block><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></fo:block></fo:table-cell>
                <fo:table-cell xsl:use-attribute-sets="td"><fo:block><xsl:value-of select="ram:IssuerAssignedID"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:IssuerAssignedID"/></xsl:call-template></fo:block></fo:table-cell>
                <fo:table-cell xsl:use-attribute-sets="td"><fo:block><xsl:value-of select="ram:LineID"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:LineID"/></xsl:call-template></fo:block></fo:table-cell>
                <fo:table-cell xsl:use-attribute-sets="td">
                  <fo:block>
                    <xsl:for-each select="ram:FormattedIssueDateTime">
                      <xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell xsl:use-attribute-sets="td">
                  <fo:block font-size="7.5pt">
                    <xsl:apply-templates select="ram:TypeCode | ram:ReferenceTypeCode | ram:Name | ram:URIID" mode="inline"/>
                    <xsl:for-each select="ram:AttachmentBinaryObject">
                      <fo:inline><xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/></fo:inline>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </xsl:if>
      <xsl:if test="$misc">
        <fo:block space-before="4pt">
          <xsl:call-template name="cols2">
            <xsl:with-param name="nodes" select="$misc"/>
            <xsl:with-param name="mode" select="'g'"/>
          </xsl:call-template>
        </fo:block>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Rechnungspositionen                                                -->
  <!-- ================================================================== -->

  <xsl:template name="lines">
    <xsl:if test="$T/ram:IncludedSupplyChainTradeLineItem">
      <xsl:call-template name="h2">
        <xsl:with-param name="k" select="'ui.lines'"/>
        <xsl:with-param name="n" select="$T/ram:IncludedSupplyChainTradeLineItem"/>
      </xsl:call-template>
      <fo:table xsl:use-attribute-sets="tbl">
        <fo:table-column column-width="proportional-column-width(9)"/>
        <fo:table-column column-width="proportional-column-width(38)"/>
        <fo:table-column column-width="proportional-column-width(9)"/>
        <fo:table-column column-width="proportional-column-width(11)"/>
        <fo:table-column column-width="proportional-column-width(12)"/>
        <fo:table-column column-width="proportional-column-width(8)"/>
        <fo:table-column column-width="proportional-column-width(13)"/>
        <fo:table-header>
          <fo:table-row>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.pos'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.item'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.qty'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.unit'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.unitprice'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.vat'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.linenet'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:apply-templates select="$T/ram:IncludedSupplyChainTradeLineItem"/>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ram:IncludedSupplyChainTradeLineItem">
    <xsl:variable name="ad" select="ram:AssociatedDocumentLineDocument"/>
    <xsl:variable name="p"  select="ram:SpecifiedTradeProduct"/>
    <xsl:variable name="ag" select="ram:SpecifiedLineTradeAgreement"/>
    <xsl:variable name="dl" select="ram:SpecifiedLineTradeDelivery"/>
    <xsl:variable name="st" select="ram:SpecifiedLineTradeSettlement"/>
    <xsl:variable name="depth"><xsl:call-template name="depth"><xsl:with-param name="li" select="."/></xsl:call-template></xsl:variable>
    <xsl:variable name="rc" select="normalize-space($ad/ram:LineStatusReasonCode)"/>
    <xsl:variable name="rowBB">
      <xsl:choose>
        <xsl:when test="$DETON">none</xsl:when>
        <xsl:otherwise>0.4pt solid <xsl:value-of select="$cLine"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:table-row keep-together.within-page="always">
      <xsl:choose>
        <xsl:when test="$rc = 'GROUP'"><xsl:attribute name="background-color"><xsl:value-of select="$cSoft"/></xsl:attribute></xsl:when>
        <xsl:when test="$rc = 'INFORMATION'"><xsl:attribute name="color"><xsl:value-of select="$cMuted"/></xsl:attribute></xsl:when>
      </xsl:choose>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}" padding-start="{3 + number($depth) * 3}pt">
        <fo:block color="{$cMuted}" font-size="7.5pt">
          <xsl:value-of select="$ad/ram:LineID"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="$ad/ram:LineID"/></xsl:call-template>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}">
        <fo:block font-weight="700">
          <xsl:if test="$rc = 'INFORMATION'">
            <xsl:attribute name="font-weight">400</xsl:attribute>
            <xsl:attribute name="font-style">italic</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$p/ram:Name"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="$p/ram:Name"/></xsl:call-template>
          <xsl:if test="$rc!='' and $rc!='DETAIL'">
            <xsl:text> </xsl:text>
            <fo:inline font-size="6.5pt" font-weight="700" font-style="normal" background-color="{$cAccSoft}" color="{$cAcc}">
              <xsl:text>&#160;</xsl:text>
              <xsl:call-template name="codeName"><xsl:with-param name="list" select="'linereason'"/><xsl:with-param name="v" select="$rc"/></xsl:call-template>
              <xsl:text>&#160;</xsl:text>
            </fo:inline>
          </xsl:if>
        </fo:block>
        <xsl:for-each select="$ad/ram:ParentLineID">
          <fo:block font-size="7.5pt" color="{$cMuted}">
            <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.partof'"/></xsl:call-template>
            <xsl:text> </xsl:text><xsl:value-of select="."/><xsl:call-template name="bt"/>
          </fo:block>
        </xsl:for-each>
        <xsl:for-each select="$p/ram:Description">
          <xsl:call-template name="pre">
            <xsl:with-param name="s" select="."/>
            <xsl:with-param name="bt" select="."/>
            <xsl:with-param name="size" select="'8pt'"/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="$p/ram:SellerAssignedID or $p/ram:BuyerAssignedID or $p/ram:GlobalID or $p/ram:ID">
          <fo:block font-size="7.5pt" color="{$cMuted}">
            <xsl:apply-templates select="$p/ram:SellerAssignedID | $p/ram:BuyerAssignedID | $p/ram:GlobalID | $p/ram:ID" mode="inline"/>
          </fo:block>
        </xsl:if>
        <xsl:for-each select="$st/ram:BillingSpecifiedPeriod">
          <fo:block font-size="7.5pt" color="{$cMuted}">
            <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.period'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="period"/><xsl:call-template name="bt"/>
          </fo:block>
        </xsl:for-each>
        <xsl:for-each select="$ad/ram:IncludedNote">
          <fo:block font-size="7.5pt" color="{$cMuted}">
            <xsl:if test="ram:SubjectCode"><xsl:apply-templates select="ram:SubjectCode" mode="v"/><xsl:text>: </xsl:text></xsl:if>
            <xsl:call-template name="pre">
              <xsl:with-param name="s" select="ram:Content"/>
              <xsl:with-param name="bt" select="ram:Content"/>
              <xsl:with-param name="size" select="'7.5pt'"/>
            </xsl:call-template>
          </fo:block>
        </xsl:for-each>
        <xsl:for-each select="$st/ram:SpecifiedTradeAllowanceCharge">
          <fo:block font-size="7.5pt" color="{$cMuted}">
            <xsl:call-template name="lbl"/>
            <xsl:call-template name="bt"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="acReason"/>
            <xsl:if test="ram:CalculationPercent">
              <xsl:text> (</xsl:text>
              <xsl:call-template name="num"><xsl:with-param name="v" select="ram:CalculationPercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
              <xsl:text>&#160;%</xsl:text>
              <xsl:if test="ram:BasisAmount">
                <xsl:text> </xsl:text><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.of'"/></xsl:call-template><xsl:text> </xsl:text>
                <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template>
              </xsl:if>
              <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:text> </xsl:text>
            <fo:inline color="{$cFg}" font-weight="700">
              <xsl:if test="ram:ChargeIndicator/udt:Indicator='false'">&#8722;&#160;</xsl:if>
              <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ActualAmount"/></xsl:call-template>
            </fo:inline>
          </fo:block>
        </xsl:for-each>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}" text-align="end">
        <fo:block>
          <xsl:call-template name="num"><xsl:with-param name="v" select="$dl/ram:BilledQuantity"/><xsl:with-param name="p" select="$P_QTY"/></xsl:call-template>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="$dl/ram:BilledQuantity"/></xsl:call-template>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}">
        <fo:block font-size="7.5pt">
          <xsl:call-template name="unitName"><xsl:with-param name="u" select="$dl/ram:BilledQuantity/@unitCode"/></xsl:call-template>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}" text-align="end">
        <fo:block>
          <xsl:for-each select="$ag/ram:NetPriceProductTradePrice">
            <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
            <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
            <xsl:call-template name="perBasis"/>
          </xsl:for-each>
        </fo:block>
        <xsl:for-each select="$ag/ram:GrossPriceProductTradePrice[normalize-space(ram:ChargeAmount) != normalize-space(../ram:NetPriceProductTradePrice/ram:ChargeAmount)]">
          <fo:block font-size="7.5pt" color="{$cMuted}">
            <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.gross'"/></xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
            <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
            <xsl:call-template name="perBasis"/>
          </fo:block>
        </xsl:for-each>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}" text-align="end">
        <fo:block/>
        <xsl:for-each select="$st/ram:ApplicableTradeTax">
          <fo:block>
            <xsl:if test="ram:RateApplicablePercent">
              <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
              <xsl:text>&#160;% </xsl:text>
            </xsl:if>
            <fo:inline color="{$cMuted}"><xsl:value-of select="ram:CategoryCode"/></fo:inline>
            <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CategoryCode"/></xsl:call-template>
          </fo:block>
        </xsl:for-each>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="td" border-bottom="{$rowBB}" text-align="end">
        <fo:block>
          <xsl:for-each select="$st/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount">
            <xsl:call-template name="amt"><xsl:with-param name="n" select="."/></xsl:call-template>
            <xsl:call-template name="bt"/>
          </xsl:for-each>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <xsl:if test="$DETON">
      <fo:table-row keep-with-previous.within-page="always">
        <fo:table-cell xsl:use-attribute-sets="td" padding-top="0pt"><fo:block/></fo:table-cell>
        <fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="td" padding-top="0pt">
          <fo:block font-size="6.5pt" line-height="1.25" color="{$cMuted}" background-color="{$cSoft}" padding="2pt 4pt">
            <fo:block font-weight="700" color="{$cAcc}">
              <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.linedetails'"/></xsl:call-template>
            </fo:block>
            <xsl:apply-templates select="*" mode="c"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Zu- und Abschläge auf Dokumentebene                                -->
  <!-- ================================================================== -->

  <xsl:template name="docAllowances">
    <xsl:if test="$S/ram:SpecifiedTradeAllowanceCharge">
      <xsl:call-template name="h2"><xsl:with-param name="k" select="'ui.allowances'"/></xsl:call-template>
      <fo:table xsl:use-attribute-sets="tbl">
        <fo:table-column column-width="proportional-column-width(14)"/>
        <fo:table-column column-width="proportional-column-width(40)"/>
        <fo:table-column column-width="proportional-column-width(13)"/>
        <fo:table-column column-width="proportional-column-width(7)"/>
        <fo:table-column column-width="proportional-column-width(11)"/>
        <fo:table-column column-width="proportional-column-width(15)"/>
        <fo:table-header>
          <fo:table-row>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.kind'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.reason'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.basis'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="text" select="'%'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.vat'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.amount'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="$S/ram:SpecifiedTradeAllowanceCharge">
            <fo:table-row keep-together.within-page="always">
              <fo:table-cell xsl:use-attribute-sets="td"><fo:block><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></fo:block></fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                  <xsl:call-template name="acReason"/>
                </fo:block>
                <xsl:if test="ram:SequenceNumeric | ram:BasisQuantity | ram:CategoryTradeTax/ram:TypeCode[. != 'VAT'] | ram:CategoryTradeTax/ram:ExemptionReason | ram:CategoryTradeTax/ram:ExemptionReasonCode">
                  <fo:block font-size="7.5pt">
                    <xsl:apply-templates select="ram:SequenceNumeric | ram:BasisQuantity" mode="inline"/>
                    <xsl:for-each select="ram:CategoryTradeTax">
                      <xsl:apply-templates select="ram:TypeCode[. != 'VAT'] | ram:ExemptionReason | ram:ExemptionReasonCode" mode="inline"/>
                    </xsl:for-each>
                  </fo:block>
                </xsl:if>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end"><fo:block><xsl:call-template name="amt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template></fo:block></fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end"><fo:block><xsl:call-template name="num"><xsl:with-param name="v" select="ram:CalculationPercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template></fo:block></fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end">
                <fo:block>
                  <xsl:for-each select="ram:CategoryTradeTax">
                    <xsl:if test="ram:RateApplicablePercent">
                      <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
                      <xsl:text>&#160;% </xsl:text>
                    </xsl:if>
                    <fo:inline color="{$cMuted}"><xsl:value-of select="ram:CategoryCode"/></fo:inline>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end">
                <fo:block>
                  <xsl:if test="ram:ChargeIndicator/udt:Indicator='false'">&#8722;&#160;</xsl:if>
                  <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ActualAmount"/></xsl:call-template>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Logistikgebühren                                                   -->
  <!-- ================================================================== -->

  <xsl:template name="logistics">
    <xsl:if test="$S/ram:SpecifiedLogisticsServiceCharge">
      <xsl:call-template name="h2">
        <xsl:with-param name="k" select="'ui.logistics'"/>
        <xsl:with-param name="n" select="$S/ram:SpecifiedLogisticsServiceCharge"/>
      </xsl:call-template>
      <fo:table xsl:use-attribute-sets="tbl">
        <fo:table-column column-width="proportional-column-width(64)"/>
        <fo:table-column column-width="proportional-column-width(18)"/>
        <fo:table-column column-width="proportional-column-width(18)"/>
        <fo:table-header>
          <fo:table-row>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.description'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.vat'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.amount'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="$S/ram:SpecifiedLogisticsServiceCharge">
            <fo:table-row keep-together.within-page="always">
              <fo:table-cell xsl:use-attribute-sets="td"><fo:block><xsl:value-of select="ram:Description"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:Description"/></xsl:call-template></fo:block></fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end">
                <fo:block/>
                <xsl:for-each select="ram:AppliedTradeTax">
                  <fo:block>
                    <xsl:if test="ram:RateApplicablePercent">
                      <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
                      <xsl:text>&#160;% </xsl:text>
                    </xsl:if>
                    <fo:inline color="{$cMuted}"><xsl:value-of select="ram:CategoryCode"/></fo:inline>
                  </fo:block>
                </xsl:for-each>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end"><fo:block><xsl:call-template name="amt"><xsl:with-param name="n" select="ram:AppliedAmount"/></xsl:call-template></fo:block></fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Umsatzsteueraufschlüsselung                                        -->
  <!-- ================================================================== -->

  <xsl:template name="vatBreakdown">
    <xsl:if test="$S/ram:ApplicableTradeTax">
      <xsl:call-template name="h2">
        <xsl:with-param name="k" select="'ui.vatbreakdown'"/>
        <xsl:with-param name="n" select="$S/ram:ApplicableTradeTax"/>
      </xsl:call-template>
      <fo:table xsl:use-attribute-sets="tbl">
        <fo:table-column column-width="proportional-column-width(52)"/>
        <fo:table-column column-width="proportional-column-width(12)"/>
        <fo:table-column column-width="proportional-column-width(18)"/>
        <fo:table-column column-width="proportional-column-width(18)"/>
        <fo:table-header>
          <fo:table-row>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.category'"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.rate'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.taxbase'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
            <xsl:call-template name="th"><xsl:with-param name="k" select="'ui.taxamount'"/><xsl:with-param name="num" select="true()"/></xsl:call-template>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="$S/ram:ApplicableTradeTax">
            <fo:table-row keep-together.within-page="always">
              <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                  <xsl:apply-templates select="ram:CategoryCode" mode="v"/>
                  <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CategoryCode"/></xsl:call-template>
                </fo:block>
                <xsl:variable name="more" select="ram:TypeCode[. != 'VAT'] | ram:ExemptionReason | ram:ExemptionReasonCode
                                                | ram:LineTotalBasisAmount | ram:AllowanceChargeBasisAmount
                                                | ram:TaxPointDate | ram:DueDateTypeCode"/>
                <xsl:if test="$more">
                  <fo:block font-size="7.5pt"><xsl:apply-templates select="$more" mode="inline"/></fo:block>
                </xsl:if>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end">
                <fo:block>
                  <xsl:if test="ram:RateApplicablePercent">
                    <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
                    <xsl:text>&#160;%</xsl:text>
                    <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:RateApplicablePercent"/></xsl:call-template>
                  </xsl:if>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end">
                <fo:block>
                  <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template>
                  <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="td" text-align="end">
                <fo:block>
                  <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:CalculatedAmount"/></xsl:call-template>
                  <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CalculatedAmount"/></xsl:call-template>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Summen                                                             -->
  <!-- ================================================================== -->

  <xsl:template name="totals">
    <xsl:if test="$SUM/*">
      <fo:table xsl:use-attribute-sets="tbl" space-before="10pt" keep-together.within-page="always">
        <fo:table-column column-width="proportional-column-width(44)"/>
        <fo:table-column column-width="proportional-column-width(36)"/>
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-body>
          <xsl:for-each select="$SUM/*">
            <xsl:variable name="ln" select="local-name()"/>
            <xsl:variable name="cls">
              <xsl:choose>
                <xsl:when test="$ln='GrandTotalAmount'">grand</xsl:when>
                <xsl:when test="$ln='DuePayableAmount'">due</xsl:when>
                <xsl:when test="$ln='TaxBasisTotalAmount'">sub</xsl:when>
                <xsl:otherwise>std</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <fo:table-row>
              <xsl:if test="$cls != 'std'"><xsl:attribute name="font-weight">700</xsl:attribute></xsl:if>
              <xsl:if test="$cls = 'due'">
                <xsl:attribute name="font-size">10pt</xsl:attribute>
                <xsl:attribute name="color"><xsl:value-of select="$cAcc"/></xsl:attribute>
              </xsl:if>
              <fo:table-cell><fo:block/></fo:table-cell>
              <fo:table-cell padding="2.5pt 4pt">
                <xsl:call-template name="totalCellStyle"><xsl:with-param name="cls" select="$cls"/></xsl:call-template>
                <fo:block>
                  <xsl:call-template name="lbl"/>
                  <xsl:if test="@currencyID and @currencyID != $S/ram:InvoiceCurrencyCode">
                    <xsl:text> (</xsl:text><xsl:value-of select="@currencyID"/><xsl:text>)</xsl:text>
                  </xsl:if>
                  <xsl:call-template name="bt"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell padding="2.5pt 4pt" text-align="end">
                <xsl:call-template name="totalCellStyle"><xsl:with-param name="cls" select="$cls"/></xsl:call-template>
                <fo:block>
                  <xsl:if test="$ln='AllowanceTotalAmount' or $ln='TotalPrepaidAmount'">&#8722;&#160;</xsl:if>
                  <xsl:call-template name="amt"><xsl:with-param name="n" select="."/><xsl:with-param name="cur" select="true()"/></xsl:call-template>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </xsl:if>
  </xsl:template>

  <xsl:template name="totalCellStyle">
    <xsl:param name="cls"/>
    <xsl:attribute name="border-bottom">0.4pt solid <xsl:value-of select="$cLine"/></xsl:attribute>
    <xsl:if test="$cls = 'grand'"><xsl:attribute name="border-top">1pt solid <xsl:value-of select="$cFg"/></xsl:attribute></xsl:if>
    <xsl:if test="$cls = 'due'"><xsl:attribute name="background-color"><xsl:value-of select="$cAccSoft"/></xsl:attribute></xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Zahlung                                                            -->
  <!-- ================================================================== -->

  <xsl:template name="payment">
    <xsl:if test="$S/ram:SpecifiedTradeSettlementPaymentMeans or $S/ram:SpecifiedTradePaymentTerms
                  or $S/ram:PaymentReference or $S/ram:CreditorReferenceID">
      <xsl:call-template name="h2"><xsl:with-param name="k" select="'ui.payment'"/></xsl:call-template>
      <xsl:if test="$S/ram:PaymentReference or $S/ram:CreditorReferenceID">
        <fo:block space-after="5pt">
          <xsl:call-template name="cols2">
            <xsl:with-param name="nodes" select="$S/ram:PaymentReference | $S/ram:CreditorReferenceID"/>
            <xsl:with-param name="mode" select="'f'"/>
          </xsl:call-template>
        </fo:block>
      </xsl:if>
      <xsl:if test="$S/ram:SpecifiedTradeSettlementPaymentMeans | $S/ram:SpecifiedTradePaymentTerms">
        <xsl:call-template name="grid2">
          <xsl:with-param name="nodes" select="$S/ram:SpecifiedTradeSettlementPaymentMeans | $S/ram:SpecifiedTradePaymentTerms"/>
          <xsl:with-param name="mode" select="'pay'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ram:SpecifiedTradeSettlementPaymentMeans" mode="pay">
    <fo:block xsl:use-attribute-sets="box" keep-together.within-page="always" space-after="4pt">
      <fo:block font-weight="700" space-after="2pt">
        <xsl:apply-templates select="ram:TypeCode" mode="v"/>
        <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:TypeCode"/></xsl:call-template>
      </fo:block>
      <xsl:for-each select="ram:Information">
        <xsl:call-template name="pre"><xsl:with-param name="s" select="."/><xsl:with-param name="bt" select="."/></xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="ram:ApplicableTradeSettlementFinancialCard | ram:PayerPartyDebtorFinancialAccount
                                 | ram:PayeePartyCreditorFinancialAccount | ram:PayerSpecifiedDebtorFinancialInstitution
                                 | ram:PayeeSpecifiedCreditorFinancialInstitution" mode="g"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="ram:SpecifiedTradePaymentTerms" mode="pay">
    <fo:block xsl:use-attribute-sets="box" keep-together.within-page="always" space-after="4pt">
      <fo:block font-weight="700" space-after="2pt">
        <xsl:call-template name="lbl"/>
        <xsl:call-template name="bt"/>
      </fo:block>
      <xsl:for-each select="ram:Description">
        <xsl:call-template name="pre"><xsl:with-param name="s" select="."/><xsl:with-param name="bt" select="."/></xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="ram:DueDateDateTime | ram:DirectDebitMandateID | ram:PartialPaymentAmount" mode="f"/>
      <xsl:apply-templates select="ram:ApplicableTradePaymentDiscountTerms | ram:ApplicableTradePaymentPenaltyTerms" mode="g"/>
      <xsl:apply-templates select="ram:PayeeTradeParty" mode="party"/>
    </fo:block>
  </xsl:template>

  <!-- Anzahlungen, finanzielle Anpassungen, Währungsumrechnung, Buchungskonten -->
  <xsl:template name="furtherSettlement">
    <xsl:variable name="x" select="$S/ram:SpecifiedAdvancePayment | $S/ram:SpecifiedFinancialAdjustment
                                 | $S/ram:TaxApplicableTradeCurrencyExchange
                                 | $S/ram:ReceivableSpecifiedTradeAccountingAccount"/>
    <xsl:if test="$x">
      <xsl:call-template name="h2"><xsl:with-param name="k" select="'ui.furthersettlement'"/></xsl:call-template>
      <xsl:call-template name="cols2">
        <xsl:with-param name="nodes" select="$x"/>
        <xsl:with-param name="mode" select="'g'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="footer">
    <fo:block space-before="18pt" border-top="0.4pt solid {$cLine}" padding-top="3pt" font-size="7pt" color="{$cMuted}" keep-with-previous.within-page="always">
      <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.footer'"/></xsl:call-template>
      <xsl:text> · ZUGFeRD 2.5.2 / Factur-X 1.09.2 · </xsl:text>
      <xsl:call-template name="profileName"/>
      <xsl:text> · </xsl:text>
      <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.version'"/></xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Layout-Bausteine                                                   -->
  <!-- ================================================================== -->

  <!-- Abschnittsüberschrift -->
  <xsl:template name="h2">
    <xsl:param name="k"/>
    <xsl:param name="n" select="/.."/>
    <fo:block xsl:use-attribute-sets="h2">
      <xsl:call-template name="uc"><xsl:with-param name="s"><xsl:call-template name="t"><xsl:with-param name="k" select="$k"/></xsl:call-template></xsl:with-param></xsl:call-template>
      <xsl:if test="$n">
        <xsl:call-template name="bt"><xsl:with-param name="n" select="$n"/></xsl:call-template>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Tabellenkopfzelle -->
  <xsl:template name="th">
    <xsl:param name="k" select="''"/>
    <xsl:param name="text" select="''"/>
    <xsl:param name="num" select="false()"/>
    <fo:table-cell xsl:use-attribute-sets="th">
      <fo:block>
        <xsl:if test="$num"><xsl:attribute name="text-align">end</xsl:attribute></xsl:if>
        <xsl:choose>
          <xsl:when test="$k != ''"><xsl:call-template name="t"><xsl:with-param name="k" select="$k"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- Knoten in zwei Spalten (erste Hälfte links, zweite rechts) -->
  <xsl:template name="cols2">
    <xsl:param name="nodes"/>
    <xsl:param name="mode" select="'f'"/>
    <xsl:variable name="half" select="ceiling(count($nodes) div 2)"/>
    <fo:table xsl:use-attribute-sets="tbl">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell padding-end="10pt">
            <fo:block/>
            <xsl:call-template name="applyMode">
              <xsl:with-param name="nodes" select="$nodes[position() &lt;= $half]"/>
              <xsl:with-param name="mode" select="$mode"/>
            </xsl:call-template>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block/>
            <xsl:call-template name="applyMode">
              <xsl:with-param name="nodes" select="$nodes[position() &gt; $half]"/>
              <xsl:with-param name="mode" select="$mode"/>
            </xsl:call-template>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- Kästen paarweise nebeneinander -->
  <xsl:template name="grid2">
    <xsl:param name="nodes"/>
    <xsl:param name="mode"/>
    <fo:table xsl:use-attribute-sets="tbl">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <xsl:for-each select="$nodes[position() mod 2 = 1]">
          <xsl:variable name="i" select="position()"/>
          <fo:table-row>
            <fo:table-cell padding-end="4pt">
              <xsl:call-template name="applyMode">
                <xsl:with-param name="nodes" select="."/>
                <xsl:with-param name="mode" select="$mode"/>
              </xsl:call-template>
            </fo:table-cell>
            <fo:table-cell padding-start="4pt">
              <fo:block/>
              <xsl:call-template name="applyMode">
                <xsl:with-param name="nodes" select="$nodes[position() = 2 * $i]"/>
                <xsl:with-param name="mode" select="$mode"/>
              </xsl:call-template>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template name="applyMode">
    <xsl:param name="nodes"/>
    <xsl:param name="mode"/>
    <xsl:choose>
      <xsl:when test="$mode = 'f'"><xsl:apply-templates select="$nodes" mode="f"/></xsl:when>
      <xsl:when test="$mode = 'g'"><xsl:apply-templates select="$nodes" mode="g"/></xsl:when>
      <xsl:when test="$mode = 'party'"><xsl:apply-templates select="$nodes" mode="party"/></xsl:when>
      <xsl:when test="$mode = 'pay'"><xsl:apply-templates select="$nodes" mode="pay"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Beschriftung/Wert-Zeile (k und v als Ergebnisbaum) -->
  <xsl:template name="kv">
    <xsl:param name="k"/>
    <xsl:param name="v"/>
    <xsl:param name="kcolor" select="$cMuted"/>
    <fo:list-block provisional-distance-between-starts="{$KW}" provisional-label-separation="5pt" space-before="0.8pt">
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
          <fo:block color="{$kcolor}"><xsl:copy-of select="$k"/></fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
          <fo:block><xsl:copy-of select="$v"/></fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </xsl:template>

  <!-- Mehrzeiliger Text (Zeilenumbrüche bleiben erhalten) -->
  <xsl:template name="pre">
    <xsl:param name="s"/>
    <xsl:param name="bt" select="/.."/>
    <xsl:param name="size" select="''"/>
    <fo:block linefeed-treatment="preserve" white-space-collapse="true" white-space-treatment="ignore-if-surrounding-linefeed">
      <xsl:if test="$size != ''"><xsl:attribute name="font-size"><xsl:value-of select="$size"/></xsl:attribute></xsl:if>
      <xsl:call-template name="trim"><xsl:with-param name="s" select="translate(string($s),'&#9;&#13;','  ')"/></xsl:call-template>
      <xsl:if test="$bt"><xsl:call-template name="bt"><xsl:with-param name="n" select="$bt"/></xsl:call-template></xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Leerraum am Anfang und Ende entfernen, Zeilenumbrüche innen behalten -->
  <xsl:template name="trim">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="$s = ''"/>
      <xsl:when test="normalize-space(substring($s,1,1)) = ''">
        <xsl:call-template name="trim"><xsl:with-param name="s" select="substring($s,2)"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="normalize-space(substring($s,string-length($s),1)) = ''">
        <xsl:call-template name="trim"><xsl:with-param name="s" select="substring($s,1,string-length($s) - 1)"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="uc">
    <xsl:param name="s"/>
    <xsl:value-of select="translate($s,$LOWER,$UPPER)"/>
  </xsl:template>

  <!-- Umbruchmöglichkeiten (Nullbreite-Leerzeichen) in langen URLs/E-Mail-Adressen -->
  <xsl:template name="brk">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="string-length($s) &lt;= 1"><xsl:value-of select="$s"/></xsl:when>
      <xsl:otherwise>
        <xsl:variable name="c" select="substring($s,1,1)"/>
        <xsl:value-of select="$c"/>
        <xsl:if test="contains('/?&amp;=@._-:#;,', $c)"><xsl:text>&#8203;</xsl:text></xsl:if>
        <xsl:call-template name="brk"><xsl:with-param name="s" select="substring($s,2)"/></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Dateiname einer eingebetteten Anlage (eindeutig) -->
  <xsl:template name="attName">
    <xsl:variable name="f" select="normalize-space(@filename)"/>
    <xsl:variable name="i" select="count(preceding::ram:AttachmentBinaryObject[normalize-space(.) != '']) + 1"/>
    <xsl:choose>
      <xsl:when test="$f = ''"><xsl:value-of select="concat('attachment-',$i)"/></xsl:when>
      <xsl:when test="preceding::ram:AttachmentBinaryObject[normalize-space(.) != ''][normalize-space(@filename) = $f]"><xsl:value-of select="concat($i,'-',$f)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$f"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Generische Darstellung (vollständig, schemagesteuert)              -->
  <!-- ================================================================== -->

  <xsl:template match="*" mode="g">
    <xsl:variable name="ln" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="substring($ln, string-length($ln) - 9) = 'TradeParty'">
        <xsl:apply-templates select="." mode="party"/>
      </xsl:when>
      <xsl:when test="$ln = 'PostalTradeAddress'">
        <xsl:call-template name="kv">
          <xsl:with-param name="k"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></xsl:with-param>
          <xsl:with-param name="v"><xsl:apply-templates select="." mode="addrInline"/></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="not(*) or udt:DateTimeString or qdt:DateTimeString or udt:DateString or udt:Indicator">
        <xsl:apply-templates select="." mode="f"/>
      </xsl:when>
      <!-- einfache Hüllen (z. B. URIUniversalCommunication/URIID) direkt als Feld -->
      <xsl:when test="count(*) = 1 and not(*/*[not(self::udt:DateTimeString or self::qdt:DateTimeString or self::udt:DateString or self::udt:Indicator)])">
        <xsl:apply-templates select="*" mode="f"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:block border-left="1pt solid {$cLine}" padding-start="5pt" space-before="3pt" space-after="3pt">
          <fo:block font-weight="700" keep-with-next.within-page="always"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></fo:block>
          <xsl:apply-templates select="*" mode="g"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Kompakte Variante für die Detailangaben je Position: Felder fließen
       als "Beschriftung: Wert" hintereinander, Gruppen als eigene Absätze -->
  <xsl:template match="*" mode="c">
    <xsl:choose>
      <xsl:when test="not(*) or udt:DateTimeString or qdt:DateTimeString or udt:DateString or udt:Indicator">
        <fo:block><xsl:apply-templates select="." mode="inline"/></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:if test="ancestor::*[2][self::ram:IncludedSupplyChainTradeLineItem] or count(ancestor::*) &lt; 5">
            <xsl:attribute name="space-before">1.5pt</xsl:attribute>
          </xsl:if>
          <xsl:if test="not(parent::ram:IncludedSupplyChainTradeLineItem)">
            <xsl:attribute name="start-indent">from-parent(start-indent) + 6pt</xsl:attribute>
          </xsl:if>
          <fo:inline font-weight="700" color="{$cFg}"><xsl:call-template name="lbl"/></fo:inline>
          <xsl:call-template name="bt"/>
          <xsl:text>: </xsl:text>
          <xsl:apply-templates select="*[not(*) or udt:DateTimeString or qdt:DateTimeString or udt:DateString or udt:Indicator]" mode="inline"/>
          <xsl:apply-templates select="*[* and not(udt:DateTimeString or qdt:DateTimeString or udt:DateString or udt:Indicator)]" mode="c"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Feld: Beschriftung + Wert -->
  <xsl:template match="*" mode="f">
    <xsl:call-template name="kv">
      <xsl:with-param name="k"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></xsl:with-param>
      <xsl:with-param name="v"><xsl:apply-templates select="." mode="v"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Feld kompakt in einer Zeile -->
  <xsl:template match="*" mode="inline">
    <fo:inline>
      <fo:inline color="{$cMuted}"><xsl:call-template name="lbl"/>: </fo:inline>
      <fo:inline color="{$cFg}"><xsl:apply-templates select="." mode="v"/></fo:inline>
      <xsl:call-template name="bt"/>
    </fo:inline>
    <xsl:text>&#160;&#160; </xsl:text>
  </xsl:template>

  <xsl:template name="row">
    <xsl:param name="k" select="''"/>
    <xsl:param name="n" select="."/>
    <xsl:call-template name="kv">
      <xsl:with-param name="k">
        <xsl:choose>
          <xsl:when test="$k!=''"><xsl:call-template name="t"><xsl:with-param name="k" select="$k"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:call-template name="lbl"><xsl:with-param name="n" select="$n"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="bt"><xsl:with-param name="n" select="$n"/></xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="v"><xsl:apply-templates select="$n" mode="v"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Ausgabe-Primitive für den gemeinsamen Teil (common.xsl)            -->
  <!-- ================================================================== -->

  <xsl:variable name="btEmit" select="$BTON"/>

  <xsl:template name="w">
    <xsl:param name="c" select="''"/>
    <xsl:param name="x"/>
    <xsl:param name="title" select="''"/>
    <xsl:choose>
      <xsl:when test="$c = 'cd'"><fo:inline color="{$cMuted}" font-size="0.92em"><xsl:copy-of select="$x"/></fo:inline></xsl:when>
      <xsl:when test="$c = 'nw'"><fo:inline keep-together.within-line="always"><xsl:copy-of select="$x"/></fo:inline></xsl:when>
      <xsl:otherwise><xsl:copy-of select="$x"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="lnk">
    <xsl:param name="href"/>
    <fo:basic-link external-destination="url('{translate($href,&quot;'&quot;,'')}')" color="{$cAcc}">
      <xsl:call-template name="brk"><xsl:with-param name="s" select="string(.)"/></xsl:call-template>
    </fo:basic-link>
  </xsl:template>

  <xsl:template name="attachment">
    <xsl:variable name="fn"><xsl:call-template name="attName"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="normalize-space(.) != ''">
        <!-- kein Link: FOP setzt Verweise auf eingebettete Dateien als JavaScript-Aktion um (in PDF/A unzulässig) -->
        <fo:inline font-weight="700">
          <xsl:call-template name="brk"><xsl:with-param name="s" select="string($fn)"/></xsl:call-template>
        </fo:inline>
        <fo:inline color="{$cMuted}" font-size="0.92em">
          <xsl:text> (</xsl:text><xsl:value-of select="@mimeCode"/><xsl:text>, </xsl:text>
          <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.embedded'"/></xsl:call-template>
          <xsl:text>)</xsl:text>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fn"/>
        <fo:inline color="{$cMuted}" font-size="0.92em"><xsl:text> (</xsl:text><xsl:value-of select="@mimeCode"/><xsl:text>)</xsl:text></fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Lange Zeichenketten ohne Leerzeichen (URNs, IDs) erhalten Umbruchstellen -->
  <xsl:template name="txt">
    <xsl:choose>
      <xsl:when test="string-length(.) &gt; 24 and not(contains(normalize-space(.),' '))">
        <xsl:call-template name="brk"><xsl:with-param name="s" select="string(.)"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="btOut">
    <xsl:param name="id"/>
    <xsl:text> </xsl:text>
    <fo:inline font-size="6pt" font-weight="400" font-style="normal" color="#8a5300" background-color="#fff3d9" keep-together.within-line="always">
      <xsl:text>&#160;</xsl:text><xsl:value-of select="$id"/><xsl:text>&#160;</xsl:text>
    </fo:inline>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Eingebettete Daten: Beschriftungen, Codelisten, BT-Zuordnung       -->
  <!-- ================================================================== -->

  <zv:data>
<!--@@DATA@@-->
  </zv:data>

</xsl:stylesheet>
