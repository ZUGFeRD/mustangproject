<?xml version="1.0" encoding="UTF-8"?>
<!--
  ZUGFeRD 2.5.2 / Factur-X 1.09.2 - Profil EXTENDED - HTML-Visualisierung
  =====================================================================
  Wandelt eine ZUGFeRD/Factur-X CII-Rechnung (rsm:CrossIndustryInvoice) in
  eine lesbare HTML-Darstellung um. Alle im Profil EXTENDED vorgesehenen
  Informationen werden dargestellt (strukturiert oder in den aufklappbaren
  Detailbereichen).

  Parameter
    lang   de | en | fr     Sprache der Beschriftungen (Standard: de)

  Aufruf (Beispiele)
    java -jar saxon-he.jar -s:rechnung.xml -xsl:ZUGFeRD_EXTENDED_html.xsl -o:rechnung.html lang=en
    xsltproc (mit stringparam lang fr) ZUGFeRD_EXTENDED_html.xsl rechnung.xml

  XSLT 1.0, keine Erweiterungsfunktionen. Die Beschriftungen, Codelisten und
  BT-Zuordnungen sind in diesem Stylesheet eingebettet (zv:data) und werden
  per document('') gelesen - das Stylesheet muss daher mit einer System-ID
  (Datei-/URL-Pfad) geladen werden.

  Diese Datei wird von build/build_xsl.py erzeugt - Änderungen bitte in
  build/template.xsl bzw. build/build_xsl.py vornehmen.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
  xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
  xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
  xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
  xmlns:zv="urn:mustangproject:zugferd:visualization"
  exclude-result-prefixes="rsm ram udt qdt zv">

  <xsl:output method="html" encoding="UTF-8" indent="no" doctype-system="about:legacy-compat"/>

  <xsl:param name="lang" select="'de'"/>

  <xsl:variable name="langNorm" select="translate(substring(normalize-space($lang),1,2),'DEFNR','defnr')"/>
  <xsl:variable name="L">
    <xsl:choose>
      <xsl:when test="$langNorm='en' or $langNorm='fr'"><xsl:value-of select="$langNorm"/></xsl:when>
      <xsl:otherwise>de</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:decimal-format name="de" decimal-separator="," grouping-separator="."/>
  <xsl:decimal-format name="en" decimal-separator="." grouping-separator=","/>
  <xsl:decimal-format name="fr" decimal-separator="," grouping-separator="&#x202F;"/>

  <xsl:key name="lbl"  match="zv:l" use="@k"/>
  <xsl:key name="code" match="zv:c" use="concat(@l,'|',@k)"/>
  <xsl:key name="bt"   match="zv:b" use="@p"/>
  <xsl:key name="line" match="ram:IncludedSupplyChainTradeLineItem" use="normalize-space(ram:AssociatedDocumentLineDocument/ram:LineID)"/>

  <xsl:variable name="dictDoc" select="document('')"/>

  <xsl:variable name="UC" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LC" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="CII" select="/rsm:CrossIndustryInvoice"/>
  <xsl:variable name="CTX" select="$CII/rsm:ExchangedDocumentContext"/>
  <xsl:variable name="DOC" select="$CII/rsm:ExchangedDocument"/>
  <xsl:variable name="T"   select="$CII/rsm:SupplyChainTradeTransaction"/>
  <xsl:variable name="A"   select="$T/ram:ApplicableHeaderTradeAgreement"/>
  <xsl:variable name="D"   select="$T/ram:ApplicableHeaderTradeDelivery"/>
  <xsl:variable name="S"   select="$T/ram:ApplicableHeaderTradeSettlement"/>
  <xsl:variable name="SUM" select="$S/ram:SpecifiedTradeSettlementHeaderMonetarySummation"/>

  <!-- Muster in "en"-Schreibweise; werden je Sprache umgesetzt -->
  <xsl:variable name="P_AMT" select="'#,##0.00######'"/>
  <xsl:variable name="P_QTY" select="'#,##0.######'"/>
  <xsl:variable name="P_PCT" select="'#,##0.####'"/>

  <!-- ================================================================== -->
  <!--  Einstieg                                                           -->
  <!-- ================================================================== -->

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$CII">
        <xsl:apply-templates select="$CII"/>
      </xsl:when>
      <xsl:otherwise>
        <html lang="{$L}">
          <head><meta charset="UTF-8"/><title>ZUGFeRD / Factur-X</title></head>
          <body><p><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.nocii'"/></xsl:call-template></p></body>
        </html>
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
    <html lang="{$L}">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="generator" content="ZUGFeRD 2.5.2 EXTENDED HTML visualization (XSLT)"/>
        <title><xsl:value-of select="$title"/><xsl:text> </xsl:text><xsl:value-of select="$DOC/ram:ID"/></title>
        <style><xsl:call-template name="css"/></style>
      </head>
      <body>
        <input type="checkbox" id="zv-bt" class="bt-cb"/>
        <label for="zv-bt" class="bt-switch" title="BT / BG"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.showbt'"/></xsl:call-template></label>
        <div class="page">
          <xsl:if test="$CTX/ram:TestIndicator/udt:Indicator='true'">
            <div class="banner"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.testbanner'"/></xsl:call-template></div>
          </xsl:if>
          <xsl:if test="$DOC/ram:CopyIndicator/udt:Indicator='true'">
            <div class="banner copy"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.copybanner'"/></xsl:call-template></div>
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
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Kopf: Verkäufer, Käufer, Eckdaten                                  -->
  <!-- ================================================================== -->

  <xsl:template name="header">
    <xsl:param name="title"/>
    <header class="head">
      <div class="head-seller">
        <xsl:apply-templates select="$A/ram:SellerTradeParty" mode="party">
          <xsl:with-param name="cls" select="'party main seller'"/>
        </xsl:apply-templates>
      </div>
      <div class="head-title">
        <h1>
          <xsl:value-of select="$title"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:TypeCode"/></xsl:call-template>
        </h1>
        <div class="docno">
          <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.docno'"/></xsl:call-template>
          <xsl:text> </xsl:text>
          <strong><xsl:value-of select="$DOC/ram:ID"/></strong>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:ID"/></xsl:call-template>
        </div>
        <xsl:if test="$DOC/ram:Name">
          <div class="docname"><xsl:value-of select="$DOC/ram:Name"/><xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:Name"/></xsl:call-template></div>
        </xsl:if>
      </div>
    </header>

    <div class="grid2 head2">
      <div>
        <xsl:apply-templates select="$A/ram:BuyerTradeParty" mode="party">
          <xsl:with-param name="cls" select="'party main buyer'"/>
        </xsl:apply-templates>
      </div>
      <div class="facts">
        <xsl:call-template name="row">
          <xsl:with-param name="k" select="'ui.invdate'"/>
          <xsl:with-param name="n" select="$DOC/ram:IssueDateTime"/>
        </xsl:call-template>
        <xsl:for-each select="$D/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime">
          <xsl:call-template name="row"><xsl:with-param name="k" select="'ui.deliverydate'"/></xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$S/ram:BillingSpecifiedPeriod">
          <div class="f">
            <span class="k"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.period'"/></xsl:call-template><xsl:call-template name="bt"/></span>
            <span class="v"><xsl:call-template name="period"/></span>
          </div>
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
          <div class="f due">
            <span class="k"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></span>
            <span class="v"><xsl:call-template name="amt"><xsl:with-param name="n" select="."/><xsl:with-param name="cur" select="true()"/></xsl:call-template></span>
          </div>
        </xsl:for-each>
      </div>
    </div>

    <!-- Allgemeine Angaben (Kontext, Sprache, Referenz Rechnungssteller ...) -->
    <xsl:variable name="info" select="$CTX/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID
                                    | $CTX/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID
                                    | $CTX/ram:TestIndicator
                                    | $DOC/ram:TypeCode | $DOC/ram:CopyIndicator | $DOC/ram:LanguageID
                                    | $S/ram:InvoiceIssuerReference"/>
    <details class="info">
      <summary>
        <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.general'"/></xsl:call-template>
        <span class="cd">
          <xsl:text> · </xsl:text>
          <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.profile'"/></xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="profileName"/>
        </span>
      </summary>
      <div class="cols2">
        <xsl:apply-templates select="$info" mode="f"/>
      </div>
    </details>
  </xsl:template>

  <xsl:template name="profileName">
    <xsl:variable name="g" select="translate(normalize-space($CTX/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID),$UC,$LC)"/>
    <xsl:choose>
      <xsl:when test="contains($g,'extended')">EXTENDED</xsl:when>
      <xsl:when test="contains($g,'xrechnung')">XRECHNUNG</xsl:when>
      <xsl:when test="contains($g,'basicwl')">BASIC WL</xsl:when>
      <xsl:when test="contains($g,'basic')">BASIC</xsl:when>
      <xsl:when test="contains($g,'minimum')">MINIMUM</xsl:when>
      <xsl:when test="contains($g,'en16931')">EN 16931</xsl:when>
      <xsl:otherwise><xsl:value-of select="$CTX/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Bemerkungen                                                        -->
  <!-- ================================================================== -->

  <xsl:template name="notes">
    <xsl:if test="$DOC/ram:IncludedNote">
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.notes'"/></xsl:call-template><xsl:call-template name="bt"><xsl:with-param name="n" select="$DOC/ram:IncludedNote"/></xsl:call-template></h2>
        <xsl:for-each select="$DOC/ram:IncludedNote">
          <div class="note">
            <xsl:if test="ram:SubjectCode or ram:ContentCode">
              <div class="note-h">
                <xsl:for-each select="ram:SubjectCode">
                  <xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/>
                </xsl:for-each>
                <xsl:for-each select="ram:ContentCode">
                  <xsl:if test="../ram:SubjectCode"><xsl:text> · </xsl:text></xsl:if>
                  <xsl:call-template name="lbl"/><xsl:text>: </xsl:text><xsl:value-of select="."/><xsl:call-template name="bt"/>
                </xsl:for-each>
              </div>
            </xsl:if>
            <div class="pre"><xsl:value-of select="ram:Content"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:Content"/></xsl:call-template></div>
          </div>
        </xsl:for-each>
      </section>
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
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.parties'"/></xsl:call-template></h2>
        <div class="grid3">
          <xsl:apply-templates select="$parties" mode="party"/>
        </div>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- Darstellung einer beliebigen Partei (TradePartyType) -->
  <xsl:template match="*" mode="party">
    <xsl:param name="cls" select="'party'"/>
    <div class="{$cls}">
      <div class="ph"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></div>
      <xsl:for-each select="ram:Name">
        <div class="pn"><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
      </xsl:for-each>
      <xsl:for-each select="ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
        <div class="ptn"><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
      </xsl:for-each>
      <xsl:apply-templates select="ram:PostalTradeAddress" mode="addr"/>
      <div class="pf">
        <xsl:apply-templates select="ram:ID | ram:GlobalID | ram:RoleCode
                                   | ram:SpecifiedTaxRegistration/ram:ID
                                   | ram:SpecifiedLegalOrganization/ram:ID
                                   | ram:URIUniversalCommunication/ram:URIID
                                   | ram:Description" mode="f"/>
        <xsl:for-each select="ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
          <div class="f">
            <span class="k"><xsl:call-template name="lbl"><xsl:with-param name="n" select=".."/></xsl:call-template></span>
            <span class="v"><xsl:apply-templates select="." mode="addr"/></span>
          </div>
        </xsl:for-each>
        <xsl:for-each select="ram:DefinedTradeContact">
          <div class="contact">
            <xsl:apply-templates select="ram:PersonName | ram:DepartmentName | ram:TypeCode
                                       | ram:TelephoneUniversalCommunication/ram:CompleteNumber
                                       | ram:FaxUniversalCommunication/ram:CompleteNumber
                                       | ram:EmailURIUniversalCommunication/ram:URIID" mode="f"/>
          </div>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="*" mode="addr">
    <div class="addr">
      <xsl:for-each select="ram:LineOne | ram:LineTwo | ram:LineThree">
        <div><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
      </xsl:for-each>
      <xsl:if test="ram:PostcodeCode or ram:CityName">
        <div>
          <xsl:value-of select="ram:PostcodeCode"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:PostcodeCode"/></xsl:call-template>
          <xsl:if test="ram:PostcodeCode and ram:CityName"><xsl:text> </xsl:text></xsl:if>
          <xsl:value-of select="ram:CityName"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CityName"/></xsl:call-template>
        </div>
      </xsl:if>
      <xsl:for-each select="ram:CountrySubDivisionName">
        <div><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
      </xsl:for-each>
      <xsl:for-each select="ram:CountryID">
        <div><xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/></div>
      </xsl:for-each>
    </div>
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
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.refs'"/></xsl:call-template></h2>
        <xsl:if test="$docs">
          <xsl:call-template name="refTable"><xsl:with-param name="docs" select="$docs"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="$misc">
          <div class="gen cols2"><xsl:apply-templates select="$misc" mode="g"/></div>
        </xsl:if>
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template name="refTable">
    <xsl:param name="docs"/>
    <div class="tw">
      <table class="tbl">
        <thead>
          <tr>
            <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.document'"/></xsl:call-template></th>
            <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.number'"/></xsl:call-template></th>
            <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.lineref'"/></xsl:call-template></th>
            <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.date'"/></xsl:call-template></th>
            <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.moreinfo'"/></xsl:call-template></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="$docs">
            <tr>
              <td><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></td>
              <td><xsl:value-of select="ram:IssuerAssignedID"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:IssuerAssignedID"/></xsl:call-template></td>
              <td><xsl:value-of select="ram:LineID"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:LineID"/></xsl:call-template></td>
              <td class="nw">
                <xsl:for-each select="ram:FormattedIssueDateTime">
                  <xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/>
                </xsl:for-each>
              </td>
              <td>
                <xsl:apply-templates select="ram:TypeCode | ram:ReferenceTypeCode | ram:Name | ram:URIID" mode="inline"/>
                <xsl:for-each select="ram:AttachmentBinaryObject">
                  <span class="im"><xsl:apply-templates select="." mode="v"/><xsl:call-template name="bt"/></span>
                </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Rechnungspositionen                                                -->
  <!-- ================================================================== -->

  <xsl:template name="lines">
    <section>
      <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.lines'"/></xsl:call-template><xsl:call-template name="bt"><xsl:with-param name="n" select="$T/ram:IncludedSupplyChainTradeLineItem"/></xsl:call-template></h2>
      <div class="tw">
        <table class="tbl lines">
          <thead>
            <tr>
              <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.pos'"/></xsl:call-template></th>
              <th class="wide"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.item'"/></xsl:call-template></th>
              <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.qty'"/></xsl:call-template></th>
              <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.unit'"/></xsl:call-template></th>
              <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.unitprice'"/></xsl:call-template></th>
              <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.vat'"/></xsl:call-template></th>
              <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.linenet'"/></xsl:call-template></th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="$T/ram:IncludedSupplyChainTradeLineItem"/>
          </tbody>
        </table>
      </div>
    </section>
  </xsl:template>

  <xsl:template name="depth">
    <xsl:param name="li"/>
    <xsl:param name="n" select="0"/>
    <xsl:variable name="p" select="normalize-space($li/ram:AssociatedDocumentLineDocument/ram:ParentLineID)"/>
    <xsl:choose>
      <xsl:when test="$p!='' and $n &lt; 8 and key('line',$p)">
        <xsl:call-template name="depth">
          <xsl:with-param name="li" select="key('line',$p)[1]"/>
          <xsl:with-param name="n" select="$n + 1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$p!=''"><xsl:value-of select="$n + 1"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$n"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ram:IncludedSupplyChainTradeLineItem">
    <xsl:variable name="ad" select="ram:AssociatedDocumentLineDocument"/>
    <xsl:variable name="p"  select="ram:SpecifiedTradeProduct"/>
    <xsl:variable name="ag" select="ram:SpecifiedLineTradeAgreement"/>
    <xsl:variable name="dl" select="ram:SpecifiedLineTradeDelivery"/>
    <xsl:variable name="st" select="ram:SpecifiedLineTradeSettlement"/>
    <xsl:variable name="depth"><xsl:call-template name="depth"><xsl:with-param name="li" select="."/></xsl:call-template></xsl:variable>
    <xsl:variable name="rc" select="normalize-space($ad/ram:LineStatusReasonCode)"/>
    <tr class="line {translate($rc,$UC,$LC)}">
      <td class="pos" style="padding-left:{0.5 + number($depth) * 1.2}em">
        <xsl:value-of select="$ad/ram:LineID"/>
        <xsl:call-template name="bt"><xsl:with-param name="n" select="$ad/ram:LineID"/></xsl:call-template>
      </td>
      <td class="wide">
        <div class="iname">
          <xsl:value-of select="$p/ram:Name"/>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="$p/ram:Name"/></xsl:call-template>
          <xsl:if test="$rc!='' and $rc!='DETAIL'">
            <span class="badge b-{translate($rc,$UC,$LC)}">
              <xsl:call-template name="codeName"><xsl:with-param name="list" select="'linereason'"/><xsl:with-param name="v" select="$rc"/></xsl:call-template>
            </span>
          </xsl:if>
        </div>
        <xsl:for-each select="$ad/ram:ParentLineID">
          <div class="imeta">
            <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.partof'"/></xsl:call-template>
            <xsl:text> </xsl:text><xsl:value-of select="."/><xsl:call-template name="bt"/>
          </div>
        </xsl:for-each>
        <xsl:for-each select="$p/ram:Description">
          <div class="idesc pre"><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
        </xsl:for-each>
        <xsl:if test="$p/ram:SellerAssignedID or $p/ram:BuyerAssignedID or $p/ram:GlobalID or $p/ram:ID">
          <div class="imeta">
            <xsl:apply-templates select="$p/ram:SellerAssignedID | $p/ram:BuyerAssignedID | $p/ram:GlobalID | $p/ram:ID" mode="inline"/>
          </div>
        </xsl:if>
        <xsl:for-each select="$st/ram:BillingSpecifiedPeriod">
          <div class="imeta">
            <span class="k"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.period'"/></xsl:call-template>: </span>
            <xsl:call-template name="period"/><xsl:call-template name="bt"/>
          </div>
        </xsl:for-each>
        <xsl:for-each select="$ad/ram:IncludedNote">
          <div class="inote pre">
            <xsl:if test="ram:SubjectCode"><span class="cd"><xsl:apply-templates select="ram:SubjectCode" mode="v"/>: </span></xsl:if>
            <xsl:value-of select="ram:Content"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:Content"/></xsl:call-template>
          </div>
        </xsl:for-each>
        <xsl:for-each select="$st/ram:SpecifiedTradeAllowanceCharge">
          <div class="iac">
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
            <strong>
              <xsl:if test="ram:ChargeIndicator/udt:Indicator='false'">&#8722;&#160;</xsl:if>
              <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ActualAmount"/></xsl:call-template>
            </strong>
          </div>
        </xsl:for-each>
        <details class="ldet">
          <summary><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.linedetails'"/></xsl:call-template></summary>
          <div class="gen"><xsl:apply-templates select="*" mode="g"/></div>
        </details>
      </td>
      <td class="num">
        <xsl:call-template name="num"><xsl:with-param name="v" select="$dl/ram:BilledQuantity"/><xsl:with-param name="p" select="$P_QTY"/></xsl:call-template>
        <xsl:call-template name="bt"><xsl:with-param name="n" select="$dl/ram:BilledQuantity"/></xsl:call-template>
      </td>
      <td>
        <xsl:call-template name="unitName"><xsl:with-param name="u" select="$dl/ram:BilledQuantity/@unitCode"/></xsl:call-template>
      </td>
      <td class="num">
        <xsl:for-each select="$ag/ram:NetPriceProductTradePrice">
          <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
          <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
          <xsl:call-template name="perBasis"/>
        </xsl:for-each>
        <xsl:for-each select="$ag/ram:GrossPriceProductTradePrice[normalize-space(ram:ChargeAmount) != normalize-space(../ram:NetPriceProductTradePrice/ram:ChargeAmount)]">
          <div class="cd">
            <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.gross'"/></xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
            <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:ChargeAmount"/></xsl:call-template>
            <xsl:call-template name="perBasis"/>
          </div>
        </xsl:for-each>
      </td>
      <td class="num">
        <xsl:for-each select="$st/ram:ApplicableTradeTax">
          <div>
            <xsl:if test="ram:RateApplicablePercent">
              <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
              <xsl:text>&#160;% </xsl:text>
            </xsl:if>
            <span class="cd" title="{ram:CategoryCode}"><xsl:value-of select="ram:CategoryCode"/></span>
            <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CategoryCode"/></xsl:call-template>
          </div>
        </xsl:for-each>
      </td>
      <td class="num">
        <xsl:for-each select="$st/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount">
          <xsl:call-template name="amt"><xsl:with-param name="n" select="."/></xsl:call-template>
          <xsl:call-template name="bt"/>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="perBasis">
    <xsl:if test="ram:BasisQuantity and number(ram:BasisQuantity) != 1">
      <span class="cd">
        <xsl:text> / </xsl:text>
        <xsl:call-template name="num"><xsl:with-param name="v" select="ram:BasisQuantity"/><xsl:with-param name="p" select="$P_QTY"/></xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:call-template name="unitName"><xsl:with-param name="u" select="ram:BasisQuantity/@unitCode"/></xsl:call-template>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- Grund eines Zu-/Abschlags: Text und/oder Code -->
  <xsl:template name="acReason">
    <xsl:choose>
      <xsl:when test="ram:Reason">
        <xsl:value-of select="ram:Reason"/>
        <xsl:if test="ram:ReasonCode"><span class="cd"> (<xsl:value-of select="ram:ReasonCode"/>)</span></xsl:if>
      </xsl:when>
      <xsl:when test="ram:ReasonCode"><xsl:apply-templates select="ram:ReasonCode" mode="v"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Zu- und Abschläge auf Dokumentebene                                -->
  <!-- ================================================================== -->

  <xsl:template name="docAllowances">
    <xsl:if test="$S/ram:SpecifiedTradeAllowanceCharge">
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.allowances'"/></xsl:call-template></h2>
        <div class="tw">
          <table class="tbl">
            <thead>
              <tr>
                <th><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.kind'"/></xsl:call-template></th>
                <th class="wide"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.reason'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.basis'"/></xsl:call-template></th>
                <th class="num">%</th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.vat'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.amount'"/></xsl:call-template></th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$S/ram:SpecifiedTradeAllowanceCharge">
                <tr>
                  <td><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></td>
                  <td class="wide">
                    <xsl:call-template name="acReason"/>
                    <xsl:apply-templates select="ram:SequenceNumeric | ram:BasisQuantity" mode="inline"/>
                    <xsl:for-each select="ram:CategoryTradeTax">
                      <xsl:apply-templates select="ram:TypeCode[. != 'VAT'] | ram:ExemptionReason | ram:ExemptionReasonCode" mode="inline"/>
                    </xsl:for-each>
                  </td>
                  <td class="num"><xsl:call-template name="amt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template></td>
                  <td class="num"><xsl:call-template name="num"><xsl:with-param name="v" select="ram:CalculationPercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template></td>
                  <td class="num">
                    <xsl:for-each select="ram:CategoryTradeTax">
                      <xsl:if test="ram:RateApplicablePercent">
                        <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
                        <xsl:text>&#160;% </xsl:text>
                      </xsl:if>
                      <span class="cd"><xsl:value-of select="ram:CategoryCode"/></span>
                    </xsl:for-each>
                  </td>
                  <td class="num">
                    <xsl:if test="ram:ChargeIndicator/udt:Indicator='false'">&#8722;&#160;</xsl:if>
                    <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:ActualAmount"/></xsl:call-template>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Logistikgebühren                                                   -->
  <!-- ================================================================== -->

  <xsl:template name="logistics">
    <xsl:if test="$S/ram:SpecifiedLogisticsServiceCharge">
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.logistics'"/></xsl:call-template><xsl:call-template name="bt"><xsl:with-param name="n" select="$S/ram:SpecifiedLogisticsServiceCharge"/></xsl:call-template></h2>
        <div class="tw">
          <table class="tbl">
            <thead>
              <tr>
                <th class="wide"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.description'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.vat'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.amount'"/></xsl:call-template></th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$S/ram:SpecifiedLogisticsServiceCharge">
                <tr>
                  <td class="wide"><xsl:value-of select="ram:Description"/><xsl:call-template name="bt"><xsl:with-param name="n" select="ram:Description"/></xsl:call-template></td>
                  <td class="num">
                    <xsl:for-each select="ram:AppliedTradeTax">
                      <div>
                        <xsl:if test="ram:RateApplicablePercent">
                          <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
                          <xsl:text>&#160;% </xsl:text>
                        </xsl:if>
                        <span class="cd"><xsl:value-of select="ram:CategoryCode"/></span>
                      </div>
                    </xsl:for-each>
                  </td>
                  <td class="num"><xsl:call-template name="amt"><xsl:with-param name="n" select="ram:AppliedAmount"/></xsl:call-template></td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Umsatzsteueraufschlüsselung                                        -->
  <!-- ================================================================== -->

  <xsl:template name="vatBreakdown">
    <xsl:if test="$S/ram:ApplicableTradeTax">
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.vatbreakdown'"/></xsl:call-template><xsl:call-template name="bt"><xsl:with-param name="n" select="$S/ram:ApplicableTradeTax"/></xsl:call-template></h2>
        <div class="tw">
          <table class="tbl">
            <thead>
              <tr>
                <th class="wide"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.category'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.rate'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.taxbase'"/></xsl:call-template></th>
                <th class="num"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.taxamount'"/></xsl:call-template></th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$S/ram:ApplicableTradeTax">
                <tr>
                  <td class="wide">
                    <xsl:apply-templates select="ram:CategoryCode" mode="v"/>
                    <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CategoryCode"/></xsl:call-template>
                    <xsl:apply-templates select="ram:TypeCode[. != 'VAT'] | ram:ExemptionReason | ram:ExemptionReasonCode
                                               | ram:LineTotalBasisAmount | ram:AllowanceChargeBasisAmount
                                               | ram:TaxPointDate | ram:DueDateTypeCode" mode="inline"/>
                  </td>
                  <td class="num">
                    <xsl:if test="ram:RateApplicablePercent">
                      <xsl:call-template name="num"><xsl:with-param name="v" select="ram:RateApplicablePercent"/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
                      <xsl:text>&#160;%</xsl:text>
                      <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:RateApplicablePercent"/></xsl:call-template>
                    </xsl:if>
                  </td>
                  <td class="num">
                    <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template>
                    <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:BasisAmount"/></xsl:call-template>
                  </td>
                  <td class="num">
                    <xsl:call-template name="amt"><xsl:with-param name="n" select="ram:CalculatedAmount"/></xsl:call-template>
                    <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:CalculatedAmount"/></xsl:call-template>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Summen                                                             -->
  <!-- ================================================================== -->

  <xsl:template name="totals">
    <xsl:if test="$SUM">
      <section class="totals-wrap">
        <table class="totals">
          <tbody>
            <xsl:for-each select="$SUM/*">
              <xsl:variable name="ln" select="local-name()"/>
              <tr>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="$ln='GrandTotalAmount'">grand</xsl:when>
                    <xsl:when test="$ln='DuePayableAmount'">due</xsl:when>
                    <xsl:when test="$ln='TaxBasisTotalAmount'">sub</xsl:when>
                    <xsl:otherwise>std</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <td>
                  <xsl:call-template name="lbl"/>
                  <xsl:if test="@currencyID and @currencyID != $S/ram:InvoiceCurrencyCode">
                    <xsl:text> (</xsl:text><xsl:value-of select="@currencyID"/><xsl:text>)</xsl:text>
                  </xsl:if>
                  <xsl:call-template name="bt"/>
                </td>
                <td class="num">
                  <xsl:if test="$ln='AllowanceTotalAmount' or $ln='TotalPrepaidAmount'">&#8722;&#160;</xsl:if>
                  <xsl:call-template name="amt"><xsl:with-param name="n" select="."/><xsl:with-param name="cur" select="true()"/></xsl:call-template>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Zahlung                                                            -->
  <!-- ================================================================== -->

  <xsl:template name="payment">
    <xsl:if test="$S/ram:SpecifiedTradeSettlementPaymentMeans or $S/ram:SpecifiedTradePaymentTerms
                  or $S/ram:PaymentReference or $S/ram:CreditorReferenceID">
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.payment'"/></xsl:call-template></h2>
        <xsl:if test="$S/ram:PaymentReference or $S/ram:CreditorReferenceID">
          <div class="cols2 pay-top">
            <xsl:apply-templates select="$S/ram:PaymentReference | $S/ram:CreditorReferenceID" mode="f"/>
          </div>
        </xsl:if>
        <div class="grid2">
          <xsl:for-each select="$S/ram:SpecifiedTradeSettlementPaymentMeans">
            <div class="box">
              <div class="box-h">
                <xsl:apply-templates select="ram:TypeCode" mode="v"/>
                <xsl:call-template name="bt"><xsl:with-param name="n" select="ram:TypeCode"/></xsl:call-template>
              </div>
              <xsl:for-each select="ram:Information">
                <div class="pre"><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
              </xsl:for-each>
              <xsl:apply-templates select="ram:ApplicableTradeSettlementFinancialCard | ram:PayerPartyDebtorFinancialAccount
                                         | ram:PayeePartyCreditorFinancialAccount | ram:PayerSpecifiedDebtorFinancialInstitution
                                         | ram:PayeeSpecifiedCreditorFinancialInstitution" mode="g"/>
            </div>
          </xsl:for-each>
          <xsl:for-each select="$S/ram:SpecifiedTradePaymentTerms">
            <div class="box">
              <div class="box-h">
                <xsl:call-template name="lbl"/>
                <xsl:call-template name="bt"/>
              </div>
              <xsl:for-each select="ram:Description">
                <div class="pre"><xsl:value-of select="."/><xsl:call-template name="bt"/></div>
              </xsl:for-each>
              <xsl:apply-templates select="ram:DueDateDateTime | ram:DirectDebitMandateID | ram:PartialPaymentAmount" mode="f"/>
              <xsl:apply-templates select="ram:ApplicableTradePaymentDiscountTerms | ram:ApplicableTradePaymentPenaltyTerms" mode="g"/>
              <xsl:apply-templates select="ram:PayeeTradeParty" mode="party"/>
            </div>
          </xsl:for-each>
        </div>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- Anzahlungen, finanzielle Anpassungen, Währungsumrechnung, Buchungskonten -->
  <xsl:template name="furtherSettlement">
    <xsl:variable name="x" select="$S/ram:SpecifiedAdvancePayment | $S/ram:SpecifiedFinancialAdjustment
                                 | $S/ram:TaxApplicableTradeCurrencyExchange
                                 | $S/ram:ReceivableSpecifiedTradeAccountingAccount"/>
    <xsl:if test="$x">
      <section>
        <h2><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.furthersettlement'"/></xsl:call-template></h2>
        <div class="gen grid2"><xsl:apply-templates select="$x" mode="g"/></div>
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template name="footer">
    <footer class="foot">
      <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.footer'"/></xsl:call-template>
      <xsl:text> · ZUGFeRD 2.5.2 / Factur-X 1.09.2 · </xsl:text>
      <xsl:call-template name="profileName"/>
    </footer>
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
        <div class="f">
          <span class="k"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></span>
          <span class="v"><xsl:apply-templates select="." mode="addr"/></span>
        </div>
      </xsl:when>
      <xsl:when test="not(*) or udt:DateTimeString or qdt:DateTimeString or udt:DateString or udt:Indicator">
        <xsl:apply-templates select="." mode="f"/>
      </xsl:when>
      <!-- einfache Hüllen (z. B. URIUniversalCommunication/URIID) direkt als Feld -->
      <xsl:when test="count(*) = 1 and not(*/*[not(self::udt:DateTimeString or self::qdt:DateTimeString or self::udt:DateString or self::udt:Indicator)])">
        <xsl:apply-templates select="*" mode="f"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="grp">
          <div class="gh"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></div>
          <div class="gb"><xsl:apply-templates select="*" mode="g"/></div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Feld: Beschriftung + Wert -->
  <xsl:template match="*" mode="f">
    <div class="f">
      <span class="k"><xsl:call-template name="lbl"/><xsl:call-template name="bt"/></span>
      <span class="v"><xsl:apply-templates select="." mode="v"/></span>
    </div>
  </xsl:template>

  <!-- Feld kompakt in einer Zeile -->
  <xsl:template match="*" mode="inline">
    <span class="im">
      <span class="k"><xsl:call-template name="lbl"/>: </span>
      <xsl:apply-templates select="." mode="v"/>
      <xsl:call-template name="bt"/>
    </span>
  </xsl:template>

  <xsl:template name="row">
    <xsl:param name="k" select="''"/>
    <xsl:param name="n" select="."/>
    <div class="f">
      <span class="k">
        <xsl:choose>
          <xsl:when test="$k!=''"><xsl:call-template name="t"><xsl:with-param name="k" select="$k"/></xsl:call-template></xsl:when>
          <xsl:otherwise><xsl:call-template name="lbl"><xsl:with-param name="n" select="$n"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="bt"><xsl:with-param name="n" select="$n"/></xsl:call-template>
      </span>
      <span class="v"><xsl:apply-templates select="$n" mode="v"/></span>
    </div>
  </xsl:template>

  <xsl:template name="period">
    <xsl:for-each select="ram:StartDateTime"><xsl:apply-templates select="." mode="v"/></xsl:for-each>
    <xsl:if test="ram:StartDateTime or ram:EndDateTime"><xsl:text> &#8211; </xsl:text></xsl:if>
    <xsl:for-each select="ram:EndDateTime"><xsl:apply-templates select="." mode="v"/></xsl:for-each>
    <xsl:for-each select="ram:CompleteDateTime"><xsl:apply-templates select="." mode="v"/></xsl:for-each>
    <xsl:if test="ram:Description"><span class="cd"><xsl:text> </xsl:text><xsl:value-of select="ram:Description"/></span></xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Wertformatierung                                                   -->
  <!-- ================================================================== -->

  <xsl:template match="*" mode="v">
    <xsl:variable name="ln" select="local-name()"/>
    <xsl:variable name="pn" select="local-name(..)"/>
    <xsl:choose>
      <xsl:when test="udt:DateTimeString | qdt:DateTimeString | udt:DateString">
        <xsl:call-template name="date">
          <xsl:with-param name="s" select="normalize-space(*[1])"/>
          <xsl:with-param name="f" select="normalize-space(*[1]/@format)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="udt:Indicator">
        <xsl:call-template name="yesno"><xsl:with-param name="v" select="udt:Indicator"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="$ln = 'AttachmentBinaryObject'">
        <a class="att" download="{@filename}" href="data:{@mimeCode};base64,{translate(.,' &#9;&#10;&#13;','')}">
          <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.download'"/></xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:choose>
            <xsl:when test="normalize-space(@filename)!=''"><xsl:value-of select="@filename"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@mimeCode"/></xsl:otherwise>
          </xsl:choose>
        </a>
        <span class="cd"><xsl:text> (</xsl:text><xsl:value-of select="@mimeCode"/><xsl:text>)</xsl:text></span>
      </xsl:when>
      <xsl:when test="$ln = 'ChargeIndicator'">
        <xsl:call-template name="yesno"><xsl:with-param name="v" select="."/></xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($ln,'Amount')">
        <xsl:call-template name="amt"><xsl:with-param name="n" select="."/><xsl:with-param name="cur" select="true()"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($ln,'Quantity') or $ln = 'ValueMeasure' or $ln = 'BasisPeriodMeasure'">
        <xsl:call-template name="num"><xsl:with-param name="v" select="."/><xsl:with-param name="p" select="$P_QTY"/></xsl:call-template>
        <xsl:if test="@unitCode">
          <xsl:text> </xsl:text>
          <xsl:call-template name="unitName"><xsl:with-param name="u" select="@unitCode"/></xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:when test="contains($ln,'Percent')">
        <xsl:call-template name="num"><xsl:with-param name="v" select="."/><xsl:with-param name="p" select="$P_PCT"/></xsl:call-template>
        <xsl:text>&#160;%</xsl:text>
      </xsl:when>
      <xsl:when test="$ln = 'ConversionRate' or $ln = 'SequenceNumeric'">
        <xsl:call-template name="num"><xsl:with-param name="v" select="."/><xsl:with-param name="p" select="'#,##0.##########'"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="$ln = 'IBANID'">
        <span class="mono"><xsl:call-template name="iban"><xsl:with-param name="s" select="normalize-space(.)"/></xsl:call-template></span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="list"><xsl:call-template name="listFor"/></xsl:variable>
        <xsl:choose>
          <xsl:when test="string($list) != ''">
            <xsl:call-template name="codeDisp">
              <xsl:with-param name="list" select="string($list)"/>
              <xsl:with-param name="list2">
                <xsl:choose>
                  <xsl:when test="$ln='ReasonCode'">nonvat</xsl:when>
                  <xsl:when test="$ln='DueDateTypeCode'">2475</xsl:when>
                  <xsl:when test="$ln='LanguageID'">lang2</xsl:when>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="v" select="."/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="starts-with(normalize-space(.),'http://') or starts-with(normalize-space(.),'https://')">
            <a href="{normalize-space(.)}"><xsl:value-of select="."/></a>
          </xsl:when>
          <xsl:when test="($pn = 'EmailURIUniversalCommunication' or @schemeID = 'EM') and contains(.,'@')">
            <a href="mailto:{normalize-space(.)}"><xsl:value-of select="."/></a>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="scheme"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Codeliste für ein Element ermitteln -->
  <xsl:template name="listFor">
    <xsl:variable name="ln" select="local-name()"/>
    <xsl:variable name="pn" select="local-name(..)"/>
    <xsl:choose>
      <xsl:when test="$ln = 'TypeCode'">
        <xsl:choose>
          <xsl:when test="$pn = 'ExchangedDocument' or substring($pn, string-length($pn) - 17) = 'ReferencedDocument'">1001</xsl:when>
          <xsl:when test="$pn = 'SpecifiedTradeSettlementPaymentMeans'">4461</xsl:when>
          <xsl:when test="$pn = 'ApplicableTradeTax' or $pn = 'IncludedTradeTax' or $pn = 'CategoryTradeTax' or $pn = 'AppliedTradeTax'">5153</xsl:when>
          <xsl:when test="$pn = 'ApplicableProductCharacteristic'">6313</xsl:when>
          <xsl:when test="$pn = 'ReceivableSpecifiedTradeAccountingAccount'">acc</xsl:when>
          <xsl:when test="$pn = 'DefinedTradeContact'">3139</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ln = 'CategoryCode'">5305</xsl:when>
      <xsl:when test="$ln = 'ExemptionReasonCode'">vatex</xsl:when>
      <xsl:when test="$ln = 'DueDateTypeCode'">2005</xsl:when>
      <xsl:when test="$ln = 'SubjectCode'">4451</xsl:when>
      <xsl:when test="$ln = 'ReasonCode'">
        <xsl:choose>
          <xsl:when test="normalize-space(../ram:ChargeIndicator/udt:Indicator) = 'true'">7161</xsl:when>
          <xsl:otherwise>5189</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$ln = 'ReferenceTypeCode'">1153</xsl:when>
      <xsl:when test="$ln = 'DeliveryTypeCode'">incoterms</xsl:when>
      <xsl:when test="$ln = 'ModeCode'">8067</xsl:when>
      <xsl:when test="$ln = 'LineStatusCode'">1229</xsl:when>
      <xsl:when test="$ln = 'LineStatusReasonCode'">linereason</xsl:when>
      <xsl:when test="$ln = 'LanguageID'">lang</xsl:when>
      <xsl:when test="$ln = 'RoleCode'">3035</xsl:when>
      <xsl:when test="$ln = 'CountryID'">country</xsl:when>
      <xsl:when test="$ln = 'InvoiceCurrencyCode' or $ln = 'TaxCurrencyCode' or $ln = 'SourceCurrencyCode' or $ln = 'TargetCurrencyCode'">currency</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Zusatz für schemeID / listID -->
  <xsl:template name="scheme">
    <xsl:variable name="pn" select="local-name(..)"/>
    <xsl:choose>
      <xsl:when test="@schemeID and $pn = 'SpecifiedTaxRegistration'"/>
      <xsl:when test="@schemeID and local-name() = 'URIID'">
        <span class="cd">
          <xsl:text> (</xsl:text>
          <xsl:call-template name="codeOrRaw"><xsl:with-param name="list" select="'eas'"/><xsl:with-param name="v" select="@schemeID"/></xsl:call-template>
          <xsl:text>)</xsl:text>
        </span>
      </xsl:when>
      <xsl:when test="@schemeID">
        <span class="cd">
          <xsl:text> (</xsl:text>
          <xsl:call-template name="codeOrRaw"><xsl:with-param name="list" select="'icd'"/><xsl:with-param name="v" select="@schemeID"/></xsl:call-template>
          <xsl:text>)</xsl:text>
        </span>
      </xsl:when>
      <xsl:when test="@listID">
        <span class="cd">
          <xsl:text> (</xsl:text>
          <xsl:call-template name="codeOrRaw"><xsl:with-param name="list" select="'7143'"/><xsl:with-param name="v" select="@listID"/></xsl:call-template>
          <xsl:if test="@listVersionID"><xsl:text> </xsl:text><xsl:value-of select="@listVersionID"/></xsl:if>
          <xsl:text>)</xsl:text>
        </span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Datum: Formate 102, 203, 205, 610, 616 -->
  <xsl:template name="date">
    <xsl:param name="s"/>
    <xsl:param name="f" select="'102'"/>
    <xsl:choose>
      <xsl:when test="($f = '102' or $f = '') and string-length($s) = 8">
        <xsl:call-template name="ymd">
          <xsl:with-param name="y" select="substring($s,1,4)"/>
          <xsl:with-param name="m" select="substring($s,5,2)"/>
          <xsl:with-param name="d" select="substring($s,7,2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$f = '610' and string-length($s) = 6">
        <xsl:choose>
          <xsl:when test="$L = 'en'"><xsl:value-of select="concat(substring($s,1,4),'-',substring($s,5,2))"/></xsl:when>
          <xsl:when test="$L = 'fr'"><xsl:value-of select="concat(substring($s,5,2),'/',substring($s,1,4))"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="concat(substring($s,5,2),'.',substring($s,1,4))"/></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$f = '616' and string-length($s) = 6">
        <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.week'"/></xsl:call-template>
        <xsl:value-of select="concat(' ',substring($s,5,2),'/',substring($s,1,4))"/>
      </xsl:when>
      <xsl:when test="($f = '203' or $f = '205') and string-length($s) &gt;= 12">
        <xsl:call-template name="ymd">
          <xsl:with-param name="y" select="substring($s,1,4)"/>
          <xsl:with-param name="m" select="substring($s,5,2)"/>
          <xsl:with-param name="d" select="substring($s,7,2)"/>
        </xsl:call-template>
        <xsl:value-of select="concat(' ',substring($s,9,2),':',substring($s,11,2))"/>
        <xsl:if test="string-length($s) &gt; 12"><xsl:value-of select="concat(' ',substring($s,13))"/></xsl:if>
      </xsl:when>
      <xsl:when test="string-length($s) &gt;= 10 and substring($s,5,1) = '-' and substring($s,8,1) = '-'">
        <xsl:call-template name="ymd">
          <xsl:with-param name="y" select="substring($s,1,4)"/>
          <xsl:with-param name="m" select="substring($s,6,2)"/>
          <xsl:with-param name="d" select="substring($s,9,2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ymd">
    <xsl:param name="y"/><xsl:param name="m"/><xsl:param name="d"/>
    <xsl:choose>
      <xsl:when test="$L = 'en'"><xsl:value-of select="concat($y,'-',$m,'-',$d)"/></xsl:when>
      <xsl:when test="$L = 'fr'"><xsl:value-of select="concat($d,'/',$m,'/',$y)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="concat($d,'.',$m,'.',$y)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="yesno">
    <xsl:param name="v"/>
    <xsl:variable name="x" select="translate(normalize-space($v),$UC,$LC)"/>
    <xsl:choose>
      <xsl:when test="$x = 'true' or $x = '1'"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.true'"/></xsl:call-template></xsl:when>
      <xsl:when test="$x = 'false' or $x = '0'"><xsl:call-template name="t"><xsl:with-param name="k" select="'ui.false'"/></xsl:call-template></xsl:when>
      <xsl:otherwise><xsl:value-of select="$v"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Zahl im Sprachformat; Muster in en-Schreibweise -->
  <xsl:template name="num">
    <xsl:param name="v"/>
    <xsl:param name="p" select="$P_AMT"/>
    <xsl:variable name="x" select="normalize-space($v)"/>
    <xsl:choose>
      <xsl:when test="$x = '' or string(number($x)) = 'NaN'"><xsl:value-of select="$x"/></xsl:when>
      <xsl:when test="$L = 'en'"><xsl:value-of select="format-number(number($x), $p, 'en')"/></xsl:when>
      <xsl:when test="$L = 'fr'"><xsl:value-of select="format-number(number($x), translate($p, ',.', '&#x202F;,'), 'fr')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="format-number(number($x), translate($p, ',.', '.,'), 'de')"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="amt">
    <xsl:param name="n"/>
    <xsl:param name="cur" select="false()"/>
    <xsl:if test="$n">
      <span class="nw">
        <xsl:call-template name="num"><xsl:with-param name="v" select="$n"/></xsl:call-template>
        <xsl:if test="$cur">
          <xsl:text>&#160;</xsl:text>
          <xsl:choose>
            <xsl:when test="$n/@currencyID"><xsl:value-of select="$n/@currencyID"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$S/ram:InvoiceCurrencyCode"/></xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="iban">
    <xsl:param name="s"/>
    <xsl:variable name="x" select="translate($s,' ','')"/>
    <xsl:value-of select="substring($x,1,4)"/>
    <xsl:if test="string-length($x) &gt; 4">
      <xsl:text>&#160;</xsl:text>
      <xsl:call-template name="iban"><xsl:with-param name="s" select="substring($x,5)"/></xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="unitName">
    <xsl:param name="u"/>
    <xsl:if test="normalize-space($u) != ''">
      <xsl:variable name="n"><xsl:call-template name="codeName"><xsl:with-param name="list" select="'rec20'"/><xsl:with-param name="v" select="$u"/></xsl:call-template></xsl:variable>
      <span title="{$u}">
        <xsl:choose>
          <xsl:when test="string($n) != ''"><xsl:value-of select="$n"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$u"/></xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Wörterbuch-Zugriff                                                 -->
  <!-- ================================================================== -->

  <!-- UI-Text -->
  <xsl:template name="t">
    <xsl:param name="k"/>
    <xsl:for-each select="$dictDoc">
      <xsl:choose>
        <xsl:when test="key('lbl',$k)"><xsl:apply-templates select="key('lbl',$k)[1]" mode="txt"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$k"/></xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Beschriftung eines Elements: kontextabhängig -->
  <xsl:template name="lbl">
    <xsl:param name="n" select="."/>
    <xsl:variable name="ln" select="local-name($n)"/>
    <xsl:variable name="pn" select="local-name($n/..)"/>
    <xsl:variable name="pg">
      <xsl:choose>
        <xsl:when test="substring($pn, string-length($pn) - 9) = 'TradeParty'">TradeParty</xsl:when>
        <xsl:when test="substring($pn, string-length($pn) - 17) = 'ReferencedDocument'">ReferencedDocument</xsl:when>
        <xsl:when test="$pn = 'ApplicableTradeTax' or $pn = 'IncludedTradeTax' or $pn = 'CategoryTradeTax' or $pn = 'AppliedTradeTax'">TradeTax</xsl:when>
        <xsl:when test="substring($pn, string-length($pn) - 16) = 'ProductTradePrice'">ProductTradePrice</xsl:when>
        <xsl:otherwise><xsl:value-of select="$pn"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="k1" select="concat($pn,'/',$ln)"/>
    <xsl:variable name="kg" select="concat($pg,'/',$ln)"/>
    <xsl:variable name="ks" select="concat($k1,'@',normalize-space($n/@schemeID))"/>
    <xsl:variable name="kc" select="concat($ln,'#',normalize-space($n/ram:ChargeIndicator/udt:Indicator))"/>
    <xsl:for-each select="$dictDoc">
      <xsl:choose>
        <xsl:when test="$n/@schemeID and key('lbl',$ks)"><xsl:apply-templates select="key('lbl',$ks)[1]" mode="txt"/></xsl:when>
        <xsl:when test="key('lbl',$kc)"><xsl:apply-templates select="key('lbl',$kc)[1]" mode="txt"/></xsl:when>
        <xsl:when test="key('lbl',$k1)"><xsl:apply-templates select="key('lbl',$k1)[1]" mode="txt"/></xsl:when>
        <xsl:when test="key('lbl',$kg)"><xsl:apply-templates select="key('lbl',$kg)[1]" mode="txt"/></xsl:when>
        <xsl:when test="key('lbl',$ln)"><xsl:apply-templates select="key('lbl',$ln)[1]" mode="txt"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$ln"/></xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="zv:l | zv:c" mode="txt">
    <xsl:choose>
      <xsl:when test="string(@*[local-name() = $L]) != ''"><xsl:value-of select="@*[local-name() = $L]"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@en"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Codebezeichnung (leer, wenn unbekannt) -->
  <xsl:template name="codeName">
    <xsl:param name="list"/>
    <xsl:param name="v"/>
    <xsl:variable name="vv" select="normalize-space($v)"/>
    <xsl:for-each select="$dictDoc">
      <xsl:apply-templates select="key('code',concat($list,'|',$vv))[1]" mode="txt"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="codeOrRaw">
    <xsl:param name="list"/>
    <xsl:param name="v"/>
    <xsl:variable name="n"><xsl:call-template name="codeName"><xsl:with-param name="list" select="$list"/><xsl:with-param name="v" select="$v"/></xsl:call-template></xsl:variable>
    <xsl:choose>
      <xsl:when test="string($n) != ''"><xsl:value-of select="$n"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$v"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- "Bezeichnung (Code)" -->
  <xsl:template name="codeDisp">
    <xsl:param name="list"/>
    <xsl:param name="list2" select="''"/>
    <xsl:param name="v"/>
    <xsl:variable name="n1"><xsl:call-template name="codeName"><xsl:with-param name="list" select="$list"/><xsl:with-param name="v" select="$v"/></xsl:call-template></xsl:variable>
    <xsl:variable name="n">
      <xsl:choose>
        <xsl:when test="string($n1) != '' or string($list2) = ''"><xsl:value-of select="$n1"/></xsl:when>
        <xsl:otherwise><xsl:call-template name="codeName"><xsl:with-param name="list" select="string($list2)"/><xsl:with-param name="v" select="$v"/></xsl:call-template></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string($n) != ''">
        <xsl:value-of select="$n"/>
        <span class="cd"><xsl:text> (</xsl:text><xsl:value-of select="normalize-space($v)"/><xsl:text>)</xsl:text></span>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$v"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- BT/BG-Kennung zum Element (eingeblendet über Schalter oben rechts) -->
  <xsl:template name="bt">
    <xsl:param name="n" select="."/>
    <xsl:if test="$n">
      <xsl:variable name="p">
        <xsl:for-each select="$n[1]/ancestor-or-self::*[parent::*]">
          <xsl:if test="position() &gt; 1">/</xsl:if>
          <xsl:value-of select="local-name()"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select="$dictDoc">
        <xsl:variable name="b" select="key('bt',concat($p,'/DateTimeString')) | key('bt',concat($p,'/DateString')) | key('bt',concat($p,'/Indicator'))"/>
        <xsl:choose>
          <xsl:when test="$b"><span class="bt"><xsl:value-of select="$b[1]/@id"/></span></xsl:when>
          <xsl:when test="key('bt',$p)"><span class="bt"><xsl:value-of select="key('bt',$p)[1]/@id"/></span></xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->
  <!--  CSS                                                                -->
  <!-- ================================================================== -->

  <xsl:template name="css">
:root{--fg:#1c2330;--muted:#5f6b7c;--line:#dde2ea;--soft:#f5f7fa;--acc:#1f4e8c;--accsoft:#e8eff8;--bg:#ffffff;--page:#eceff4}
*{box-sizing:border-box}
html{-webkit-text-size-adjust:100%}
body{margin:0;background:var(--page);color:var(--fg);font:14px/1.45 "Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif}
.page{max-width:1120px;margin:24px auto;background:var(--bg);padding:40px 48px 28px;box-shadow:0 1px 4px rgba(0,0,0,.08);border-radius:4px}
a{color:var(--acc)}
h1{font-size:26px;line-height:1.2;margin:0 0 6px;color:var(--acc);font-weight:600}
h2{font-size:13px;text-transform:uppercase;letter-spacing:.06em;color:var(--acc);border-bottom:2px solid var(--acc);padding-bottom:4px;margin:30px 0 12px}
section{break-inside:auto}
.banner{background:#fff1d6;border:1px solid #f0c36d;color:#7a4b00;padding:6px 12px;margin:0 0 16px;border-radius:4px;font-weight:600;text-align:center}
.banner.copy{background:#eef2f7;border-color:#c7d1de;color:var(--muted)}
.head{display:grid;grid-template-columns:1fr auto;gap:24px;align-items:start}
.head-title{text-align:right}
.docno{font-size:16px}
.docname{color:var(--muted)}
.head2{margin-top:22px}
.grid2{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px}
.grid3{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:14px}
.cols2{display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:0 28px}
.party{border:1px solid var(--line);border-radius:6px;padding:12px 14px;background:var(--bg);margin:4px 0}
.party.main{border:none;padding:0}
.party.seller .pn{font-size:18px}
.ph{font-size:11px;text-transform:uppercase;letter-spacing:.06em;color:var(--muted);margin-bottom:2px}
.pn{font-weight:600;font-size:15px}
.ptn{color:var(--muted)}
.addr{margin:2px 0 6px}
.pf{font-size:13px}
.contact{border-top:1px dashed var(--line);margin-top:4px;padding-top:4px}
.facts{background:var(--soft);border-radius:6px;padding:12px 16px}
.facts .f.due{border-top:1px solid var(--line);margin-top:6px;padding-top:6px;font-weight:600;font-size:15px}
.f{display:grid;grid-template-columns:minmax(120px,42%) 1fr;gap:1px 12px;padding:2px 0}
.f .k{color:var(--muted)}
.f .v{overflow-wrap:anywhere}
.im{display:inline-block;margin-right:14px}
.im .k{color:var(--muted)}
.cd{color:var(--muted);font-size:.92em}
.nw{white-space:nowrap}
.mono{font-family:ui-monospace,Consolas,"Liberation Mono",monospace}
.pre{white-space:pre-line}
details.info{margin-top:16px;font-size:13px;border:1px solid var(--line);border-radius:6px;padding:6px 12px}
details summary{cursor:pointer;color:var(--acc)}
details.info[open] summary{margin-bottom:6px}
.note{border-left:3px solid var(--accsoft);padding:4px 0 4px 12px;margin:6px 0}
.note-h{font-size:12px;color:var(--muted)}
.tw{overflow-x:auto}
.tbl{width:100%;border-collapse:collapse}
.tbl th{text-align:left;font-size:12px;font-weight:600;color:var(--muted);border-bottom:1px solid var(--fg);padding:6px 8px;white-space:nowrap}
.tbl td{border-bottom:1px solid var(--line);vertical-align:top;padding:7px 8px}
.tbl .num{text-align:right;white-space:nowrap}
.tbl .wide{min-width:240px}
.lines .pos{white-space:nowrap;color:var(--muted)}
.iname{font-weight:600}
.idesc{color:var(--fg);font-size:13px}
.imeta,.inote,.iac{font-size:12.5px;color:var(--muted);margin-top:2px}
.iac strong{color:var(--fg);font-weight:600}
tr.group td{background:var(--soft)}
tr.group .iname{text-transform:none}
tr.information td{color:var(--muted)}
tr.information .iname{font-weight:500;font-style:italic}
.badge{display:inline-block;font-size:10.5px;font-weight:600;padding:1px 6px;border-radius:9px;margin-left:8px;vertical-align:1px;background:var(--accsoft);color:var(--acc)}
.badge.b-information{background:#f1f1f1;color:#666}
.badge.b-group{background:#e6f1e6;color:#2d6a2d}
.ldet{margin-top:4px;font-size:12.5px}
.ldet[open]{background:var(--soft);border-radius:4px;padding:4px 8px 8px}
.gen{font-size:13px}
.grp{border-left:2px solid var(--line);padding:2px 0 2px 10px;margin:6px 0}
.gh{font-weight:600;font-size:12.5px;color:var(--fg)}
.box{border:1px solid var(--line);border-radius:6px;padding:12px 14px}
.box-h{font-weight:600;margin-bottom:4px}
.pay-top{margin-bottom:10px}
.totals-wrap{display:flex;justify-content:flex-end;margin-top:18px}
.totals{border-collapse:collapse;min-width:min(420px,100%)}
.totals td{padding:4px 8px;border-bottom:1px solid var(--line)}
.totals td.num{text-align:right;white-space:nowrap}
.totals tr.sub td{font-weight:600}
.totals tr.grand td{font-weight:700;border-top:2px solid var(--fg)}
.totals tr.due td{font-weight:700;font-size:16px;background:var(--accsoft);color:var(--acc)}
.att{font-weight:600}
.foot{margin-top:36px;border-top:1px solid var(--line);padding-top:8px;font-size:11.5px;color:var(--muted)}
.bt{display:none;font:600 10.5px/1.3 ui-monospace,Consolas,monospace;color:#8a5300;background:#fff3d9;border-radius:3px;padding:0 4px;margin-left:5px;vertical-align:1px;text-transform:none;letter-spacing:0;white-space:nowrap}
.bt-cb{position:absolute;opacity:0;width:1px;height:1px}
.bt-switch{position:fixed;top:10px;right:12px;z-index:5;font-size:12px;background:var(--bg);border:1px solid var(--line);border-radius:14px;padding:3px 10px;cursor:pointer;color:var(--muted);box-shadow:0 1px 3px rgba(0,0,0,.08)}
.bt-cb:checked + .bt-switch{background:var(--acc);border-color:var(--acc);color:#fff}
.bt-cb:focus-visible + .bt-switch{outline:2px solid var(--acc);outline-offset:2px}
.bt-cb:checked ~ .page .bt{display:inline-block}
@media (max-width:720px){
  .page{margin:0;padding:52px 16px 20px;border-radius:0;box-shadow:none}
  .head{grid-template-columns:1fr}
  .head-title{text-align:left;order:-1}
  .f{grid-template-columns:1fr}
  .grid2,.grid3,.cols2{grid-template-columns:1fr}
}
@media print{
  body{background:#fff;font-size:11pt}
  .page{box-shadow:none;margin:0;max-width:none;padding:0}
  .bt-switch{display:none}
  details.ldet{display:none}
  .tbl tr{break-inside:avoid}
}
  </xsl:template>

  <!-- ================================================================== -->
  <!--  Eingebettete Daten: Beschriftungen, Codelisten, BT-Zuordnung       -->
  <!-- ================================================================== -->

  <zv:data>
    <zv:l k="ui.invoice" de="Rechnung" en="Invoice" fr="Facture"/>
    <zv:l k="ui.docno" de="Nr." en="No." fr="N°"/>
    <zv:l k="ui.invdate" de="Rechnungsdatum" en="Invoice date" fr="Date de facture"/>
    <zv:l k="ui.deliverydate" de="Liefer-/Leistungsdatum" en="Delivery date" fr="Date de livraison"/>
    <zv:l k="ui.period" de="Abrechnungszeitraum" en="Invoicing period" fr="Période de facturation"/>
    <zv:l k="ui.duedate" de="Fällig am" en="Due date" fr="Date d'échéance"/>
    <zv:l k="ui.orderno" de="Bestellnummer" en="Purchase order" fr="Numéro de commande"/>
    <zv:l k="ui.general" de="Allgemeine Angaben" en="General information" fr="Informations générales"/>
    <zv:l k="ui.profile" de="Profil" en="Profile" fr="Profil"/>
    <zv:l k="ui.notes" de="Bemerkungen" en="Notes" fr="Notes"/>
    <zv:l k="ui.parties" de="Weitere Beteiligte" en="Other parties" fr="Autres intervenants"/>
    <zv:l k="ui.refs" de="Referenzen" en="References" fr="Références"/>
    <zv:l k="ui.document" de="Dokument" en="Document" fr="Document"/>
    <zv:l k="ui.number" de="Nummer" en="Number" fr="Numéro"/>
    <zv:l k="ui.lineref" de="Position" en="Line" fr="Ligne"/>
    <zv:l k="ui.date" de="Datum" en="Date" fr="Date"/>
    <zv:l k="ui.moreinfo" de="Weitere Angaben" en="Further information" fr="Informations complémentaires"/>
    <zv:l k="ui.lines" de="Rechnungspositionen" en="Invoice lines" fr="Lignes de facture"/>
    <zv:l k="ui.pos" de="Pos." en="Line" fr="Ligne"/>
    <zv:l k="ui.item" de="Bezeichnung" en="Description" fr="Désignation"/>
    <zv:l k="ui.qty" de="Menge" en="Quantity" fr="Quantité"/>
    <zv:l k="ui.unit" de="Einheit" en="Unit" fr="Unité"/>
    <zv:l k="ui.unitprice" de="Einzelpreis netto" en="Net unit price" fr="Prix unitaire HT"/>
    <zv:l k="ui.vat" de="USt." en="VAT" fr="TVA"/>
    <zv:l k="ui.linenet" de="Gesamt netto" en="Net amount" fr="Montant HT"/>
    <zv:l k="ui.linedetails" de="Alle Angaben zur Position" en="All line details" fr="Tous les détails de la ligne"/>
    <zv:l k="ui.partof" de="Unterposition von Pos." en="Sub-line of line" fr="Sous-ligne de la ligne"/>
    <zv:l k="ui.gross" de="Brutto" en="Gross" fr="Brut"/>
    <zv:l k="ui.of" de="von" en="of" fr="de"/>
    <zv:l k="ui.allowances" de="Zu- und Abschläge auf Dokumentebene" en="Document level allowances and charges" fr="Remises et charges au niveau du document"/>
    <zv:l k="ui.kind" de="Art" en="Type" fr="Type"/>
    <zv:l k="ui.reason" de="Grund" en="Reason" fr="Motif"/>
    <zv:l k="ui.basis" de="Basisbetrag" en="Base amount" fr="Montant de base"/>
    <zv:l k="ui.amount" de="Betrag" en="Amount" fr="Montant"/>
    <zv:l k="ui.description" de="Beschreibung" en="Description" fr="Description"/>
    <zv:l k="ui.logistics" de="Logistikgebühren" en="Logistics service charges" fr="Frais de service logistique"/>
    <zv:l k="ui.vatbreakdown" de="Umsatzsteueraufschlüsselung" en="VAT breakdown" fr="Ventilation de la TVA"/>
    <zv:l k="ui.category" de="Kategorie" en="Category" fr="Catégorie"/>
    <zv:l k="ui.rate" de="Steuersatz" en="Rate" fr="Taux"/>
    <zv:l k="ui.taxbase" de="Bemessungsgrundlage" en="Taxable amount" fr="Base d'imposition"/>
    <zv:l k="ui.taxamount" de="Steuerbetrag" en="Tax amount" fr="Montant de la taxe"/>
    <zv:l k="ui.payment" de="Zahlungsinformationen" en="Payment information" fr="Informations de paiement"/>
    <zv:l k="ui.furthersettlement" de="Weitere Abrechnungsangaben" en="Further settlement information" fr="Autres informations de règlement"/>
    <zv:l k="ui.download" de="Herunterladen" en="Download" fr="Télécharger"/>
    <zv:l k="ui.true" de="Ja" en="Yes" fr="Oui"/>
    <zv:l k="ui.false" de="Nein" en="No" fr="Non"/>
    <zv:l k="ui.week" de="KW" en="Week" fr="Semaine"/>
    <zv:l k="ui.showbt" de="BT-Kennungen" en="BT IDs" fr="ID BT"/>
    <zv:l k="ui.testbanner" de="Testrechnung – nicht zur Zahlung" en="Test invoice – not for payment" fr="Facture de test – ne pas payer"/>
    <zv:l k="ui.copybanner" de="Kopie" en="Copy" fr="Copie"/>
    <zv:l k="ui.footer" de="Automatisch erzeugte Darstellung der strukturierten Rechnungsdaten" en="Automatically generated view of the structured invoice data" fr="Représentation générée automatiquement des données structurées de la facture"/>
    <zv:l k="ui.nocii" de="Das Dokument ist keine ZUGFeRD/Factur-X-Rechnung (rsm:CrossIndustryInvoice)." en="The document is not a ZUGFeRD/Factur-X invoice (rsm:CrossIndustryInvoice)." fr="Le document n'est pas une facture ZUGFeRD/Factur-X (rsm:CrossIndustryInvoice)."/>
    <zv:l k="ExchangedDocumentContext" de="Dokumentkontext" en="Document context" fr="Contexte du document"/>
    <zv:l k="TestIndicator" de="Testkennzeichen" en="Test indicator" fr="Indicateur de test"/>
    <zv:l k="BusinessProcessSpecifiedDocumentContextParameter/ID" de="Geschäftsprozess" en="Business process type" fr="Type de processus métier"/>
    <zv:l k="GuidelineSpecifiedDocumentContextParameter/ID" de="Spezifikationskennung" en="Specification identifier" fr="Identifiant de spécification"/>
    <zv:l k="BusinessProcessSpecifiedDocumentContextParameter" de="Geschäftsprozess" en="Business process" fr="Processus métier"/>
    <zv:l k="GuidelineSpecifiedDocumentContextParameter" de="Spezifikation" en="Specification" fr="Spécification"/>
    <zv:l k="ExchangedDocument" de="Dokument" en="Document" fr="Document"/>
    <zv:l k="ExchangedDocument/ID" de="Rechnungsnummer" en="Invoice number" fr="Numéro de facture"/>
    <zv:l k="ExchangedDocument/Name" de="Dokumentenname" en="Document name" fr="Nom du document"/>
    <zv:l k="ExchangedDocument/TypeCode" de="Dokumentart" en="Invoice type" fr="Type de facture"/>
    <zv:l k="IssueDateTime" de="Rechnungsdatum" en="Invoice issue date" fr="Date d'émission"/>
    <zv:l k="CopyIndicator" de="Kopie" en="Copy" fr="Copie"/>
    <zv:l k="LanguageID" de="Sprache" en="Language" fr="Langue"/>
    <zv:l k="IncludedNote" de="Bemerkung" en="Note" fr="Note"/>
    <zv:l k="Content" de="Text" en="Text" fr="Texte"/>
    <zv:l k="ContentCode" de="Textbaustein" en="Content code" fr="Code de contenu"/>
    <zv:l k="SubjectCode" de="Betreff" en="Subject code" fr="Objet"/>
    <zv:l k="EffectiveSpecifiedPeriod" de="Vertragliches Fälligkeitsdatum" en="Contractual due date" fr="Date d'échéance contractuelle"/>
    <zv:l k="EffectiveSpecifiedPeriod/CompleteDateTime" de="Vertragliches Fälligkeitsdatum" en="Contractual due date" fr="Date d'échéance contractuelle"/>
    <zv:l k="CompleteDateTime" de="Zeitpunkt" en="Date" fr="Date"/>
    <zv:l k="SupplyChainTradeTransaction" de="Handelsgeschäft" en="Trade transaction" fr="Transaction commerciale"/>
    <zv:l k="IncludedSupplyChainTradeLineItem" de="Rechnungsposition" en="Invoice line" fr="Ligne de facture"/>
    <zv:l k="AssociatedDocumentLineDocument" de="Positionsangaben" en="Line information" fr="Informations de ligne"/>
    <zv:l k="LineID" de="Position" en="Line ID" fr="Identifiant de ligne"/>
    <zv:l k="AssociatedDocumentLineDocument/LineID" de="Positionsnummer" en="Invoice line identifier" fr="Identifiant de ligne de facture"/>
    <zv:l k="ReferencedDocument/LineID" de="Referenzierte Position" en="Referenced line" fr="Ligne référencée"/>
    <zv:l k="ParentLineID" de="Übergeordnete Position" en="Parent line" fr="Ligne parente"/>
    <zv:l k="LineStatusCode" de="Positionsstatus" en="Line status" fr="Statut de la ligne"/>
    <zv:l k="LineStatusReasonCode" de="Positionsart" en="Line type" fr="Type de ligne"/>
    <zv:l k="SpecifiedTradeProduct" de="Artikel" en="Item information" fr="Informations sur l'article"/>
    <zv:l k="ID" de="Kennung" en="Identifier" fr="Identifiant"/>
    <zv:l k="GlobalID" de="Globale Kennung" en="Global identifier" fr="Identifiant global"/>
    <zv:l k="SpecifiedTradeProduct/ID" de="Artikelkennung" en="Item identifier" fr="Identifiant de l'article"/>
    <zv:l k="SpecifiedTradeProduct/GlobalID" de="Standardkennung (z. B. GTIN)" en="Item standard identifier" fr="Identifiant standard de l'article"/>
    <zv:l k="SellerAssignedID" de="Art.-Nr. Verkäufer" en="Seller's item ID" fr="Réf. vendeur"/>
    <zv:l k="BuyerAssignedID" de="Art.-Nr. Käufer" en="Buyer's item ID" fr="Réf. acheteur"/>
    <zv:l k="IndustryAssignedID" de="Branchenkennung" en="Industry assigned ID" fr="Identifiant sectoriel"/>
    <zv:l k="ModelID" de="Modellkennung" en="Model ID" fr="Identifiant du modèle"/>
    <zv:l k="Name" de="Name" en="Name" fr="Nom"/>
    <zv:l k="SpecifiedTradeProduct/Name" de="Artikelname" en="Item name" fr="Nom de l'article"/>
    <zv:l k="Description" de="Beschreibung" en="Description" fr="Description"/>
    <zv:l k="BatchID" de="Chargennummer" en="Batch (lot) ID" fr="Numéro de lot"/>
    <zv:l k="BrandName" de="Marke" en="Brand name" fr="Marque"/>
    <zv:l k="ModelName" de="Modellname" en="Model name" fr="Nom du modèle"/>
    <zv:l k="ApplicableProductCharacteristic" de="Artikelmerkmal" en="Item attribute" fr="Caractéristique de l'article"/>
    <zv:l k="ApplicableProductCharacteristic/Description" de="Merkmal" en="Attribute name" fr="Caractéristique"/>
    <zv:l k="ApplicableProductCharacteristic/Value" de="Wert" en="Attribute value" fr="Valeur"/>
    <zv:l k="ApplicableProductCharacteristic/TypeCode" de="Merkmalsart" en="Attribute type" fr="Type de caractéristique"/>
    <zv:l k="ValueMeasure" de="Messwert" en="Measured value" fr="Valeur mesurée"/>
    <zv:l k="DesignatedProductClassification" de="Artikelklassifizierung" en="Item classification" fr="Classification de l'article"/>
    <zv:l k="ClassCode" de="Klassifizierungscode" en="Classification code" fr="Code de classification"/>
    <zv:l k="ClassName" de="Klassifizierung" en="Classification name" fr="Nom de la classification"/>
    <zv:l k="IndividualTradeProductInstance" de="Artikelinstanz" en="Item instance" fr="Instance de l'article"/>
    <zv:l k="SupplierAssignedSerialID" de="Seriennummer" en="Serial number" fr="Numéro de série"/>
    <zv:l k="OriginTradeCountry" de="Ursprungsland" en="Country of origin" fr="Pays d'origine"/>
    <zv:l k="OriginTradeCountry/ID" de="Ursprungsland" en="Country of origin" fr="Pays d'origine"/>
    <zv:l k="IncludedReferencedProduct" de="Enthaltener Artikel" en="Included item" fr="Produit inclus"/>
    <zv:l k="UnitQuantity" de="Enthaltene Menge" en="Included quantity" fr="Quantité incluse"/>
    <zv:l k="SpecifiedLineTradeAgreement" de="Vertragsangaben zur Position" en="Line trade agreement" fr="Accord commercial de la ligne"/>
    <zv:l k="SpecifiedLineTradeDelivery" de="Lieferangaben zur Position" en="Line delivery" fr="Livraison de la ligne"/>
    <zv:l k="SpecifiedLineTradeSettlement" de="Abrechnungsangaben zur Position" en="Line settlement" fr="Règlement de la ligne"/>
    <zv:l k="ApplicableTradeDeliveryTerms" de="Lieferbedingungen" en="Delivery terms" fr="Conditions de livraison"/>
    <zv:l k="DeliveryTypeCode" de="Lieferbedingung" en="Delivery terms code" fr="Code des conditions de livraison"/>
    <zv:l k="RelevantTradeLocation" de="Ort der Lieferbedingung" en="Delivery terms location" fr="Lieu des conditions de livraison"/>
    <zv:l k="SellerOrderReferencedDocument" de="Auftragsbestätigung" en="Sales order" fr="Commande vendeur"/>
    <zv:l k="BuyerOrderReferencedDocument" de="Bestellung" en="Purchase order" fr="Bon de commande"/>
    <zv:l k="QuotationReferencedDocument" de="Angebot" en="Quotation" fr="Devis"/>
    <zv:l k="ContractReferencedDocument" de="Vertrag" en="Contract" fr="Contrat"/>
    <zv:l k="AdditionalReferencedDocument" de="Rechnungsbegründendes Dokument" en="Supporting document" fr="Document justificatif"/>
    <zv:l k="UltimateCustomerOrderReferencedDocument" de="Bestellung des Endkunden" en="Ultimate customer order" fr="Commande du client final"/>
    <zv:l k="DespatchAdviceReferencedDocument" de="Lieferavis" en="Despatch advice" fr="Avis d'expédition"/>
    <zv:l k="ReceivingAdviceReferencedDocument" de="Wareneingangsmeldung" en="Receiving advice" fr="Avis de réception"/>
    <zv:l k="DeliveryNoteReferencedDocument" de="Lieferschein" en="Delivery note" fr="Bon de livraison"/>
    <zv:l k="InvoiceReferencedDocument" de="Vorausgegangene Rechnung" en="Preceding invoice" fr="Facture antérieure"/>
    <zv:l k="InvoiceSpecifiedReferencedDocument" de="Anzahlungsrechnung" en="Advance payment invoice" fr="Facture d'acompte"/>
    <zv:l k="IssuerAssignedID" de="Dokumentnummer" en="Document number" fr="Numéro de document"/>
    <zv:l k="URIID" de="URI" en="URI" fr="URI"/>
    <zv:l k="ReferencedDocument/URIID" de="Externe Fundstelle" en="External document location" fr="Emplacement externe"/>
    <zv:l k="TypeCode" de="Art" en="Type code" fr="Code de type"/>
    <zv:l k="ReferencedDocument/TypeCode" de="Dokumentart" en="Document type" fr="Type de document"/>
    <zv:l k="ReferencedDocument/Name" de="Beschreibung" en="Description" fr="Description"/>
    <zv:l k="AttachmentBinaryObject" de="Anhang" en="Attachment" fr="Pièce jointe"/>
    <zv:l k="ReferenceTypeCode" de="Referenzart" en="Reference type" fr="Type de référence"/>
    <zv:l k="FormattedIssueDateTime" de="Dokumentdatum" en="Document date" fr="Date du document"/>
    <zv:l k="GrossPriceProductTradePrice" de="Bruttopreis" en="Gross price" fr="Prix brut"/>
    <zv:l k="NetPriceProductTradePrice" de="Nettopreis" en="Net price" fr="Prix net"/>
    <zv:l k="ChargeAmount" de="Preis" en="Price" fr="Prix"/>
    <zv:l k="GrossPriceProductTradePrice/ChargeAmount" de="Bruttopreis" en="Item gross price" fr="Prix brut"/>
    <zv:l k="NetPriceProductTradePrice/ChargeAmount" de="Nettopreis" en="Item net price" fr="Prix net"/>
    <zv:l k="BasisQuantity" de="Basismenge" en="Base quantity" fr="Quantité de base"/>
    <zv:l k="ProductTradePrice/BasisQuantity" de="Preisbasismenge" en="Item price base quantity" fr="Quantité de base du prix"/>
    <zv:l k="AppliedTradeAllowanceCharge" de="Preisnachlass oder -zuschlag" en="Price allowance or charge" fr="Remise ou majoration sur prix"/>
    <zv:l k="AppliedTradeAllowanceCharge#false" de="Preisnachlass" en="Item price discount" fr="Remise sur prix"/>
    <zv:l k="AppliedTradeAllowanceCharge#true" de="Preiszuschlag" en="Item price charge" fr="Majoration sur prix"/>
    <zv:l k="SpecifiedTradeAllowanceCharge" de="Zu- oder Abschlag" en="Allowance or charge" fr="Remise ou charge"/>
    <zv:l k="SpecifiedTradeAllowanceCharge#false" de="Abschlag" en="Allowance" fr="Remise"/>
    <zv:l k="SpecifiedTradeAllowanceCharge#true" de="Zuschlag" en="Charge" fr="Charge"/>
    <zv:l k="ChargeIndicator" de="Zuschlag" en="Charge indicator" fr="Indicateur de charge"/>
    <zv:l k="SequenceNumeric" de="Berechnungsreihenfolge" en="Calculation sequence" fr="Ordre de calcul"/>
    <zv:l k="CalculationPercent" de="Prozentsatz" en="Percentage" fr="Pourcentage"/>
    <zv:l k="BasisAmount" de="Basisbetrag" en="Base amount" fr="Montant de base"/>
    <zv:l k="ActualAmount" de="Betrag" en="Amount" fr="Montant"/>
    <zv:l k="ReasonCode" de="Grund (Code)" en="Reason code" fr="Code du motif"/>
    <zv:l k="Reason" de="Grund" en="Reason" fr="Motif"/>
    <zv:l k="CategoryTradeTax" de="Umsatzsteuer" en="VAT" fr="TVA"/>
    <zv:l k="IncludedTradeTax" de="Enthaltene Steuer" en="Included tax" fr="Taxe incluse"/>
    <zv:l k="AppliedTradeTax" de="Umsatzsteuer" en="VAT" fr="TVA"/>
    <zv:l k="ApplicableTradeTax" de="Umsatzsteuer" en="VAT" fr="TVA"/>
    <zv:l k="CalculatedAmount" de="Steuerbetrag" en="Tax amount" fr="Montant de la taxe"/>
    <zv:l k="TradeTax/TypeCode" de="Steuerart" en="Tax type" fr="Type de taxe"/>
    <zv:l k="TradeTax/BasisAmount" de="Bemessungsgrundlage" en="Taxable amount" fr="Base d'imposition"/>
    <zv:l k="ExemptionReason" de="Befreiungsgrund" en="Exemption reason" fr="Motif d'exonération"/>
    <zv:l k="ExemptionReasonCode" de="Befreiungsgrund (Code)" en="Exemption reason code" fr="Code du motif d'exonération"/>
    <zv:l k="CategoryCode" de="Umsatzsteuerkategorie" en="VAT category" fr="Catégorie de TVA"/>
    <zv:l k="RateApplicablePercent" de="Steuersatz" en="VAT rate" fr="Taux de TVA"/>
    <zv:l k="LineTotalBasisAmount" de="Positionssumme (Basis)" en="Line total basis amount" fr="Total des lignes (base)"/>
    <zv:l k="AllowanceChargeBasisAmount" de="Zu-/Abschläge (Basis)" en="Allowance/charge basis amount" fr="Remises/charges (base)"/>
    <zv:l k="TaxPointDate" de="Steuerfälligkeit" en="Tax point date" fr="Date d'exigibilité de la TVA"/>
    <zv:l k="DueDateTypeCode" de="Steuerfälligkeit (Code)" en="Tax point date code" fr="Code d'exigibilité de la TVA"/>
    <zv:l k="BilledQuantity" de="Menge" en="Invoiced quantity" fr="Quantité facturée"/>
    <zv:l k="ChargeFreeQuantity" de="Menge ohne Berechnung" en="Charge-free quantity" fr="Quantité gratuite"/>
    <zv:l k="PackageQuantity" de="Anzahl Packstücke" en="Package quantity" fr="Nombre de colis"/>
    <zv:l k="PerPackageUnitQuantity" de="Menge je Packstück" en="Quantity per package" fr="Quantité par colis"/>
    <zv:l k="ActualDeliverySupplyChainEvent" de="Lieferung" en="Delivery" fr="Livraison"/>
    <zv:l k="OccurrenceDateTime" de="Lieferdatum" en="Actual delivery date" fr="Date de livraison effective"/>
    <zv:l k="ActualDeliverySupplyChainEvent/OccurrenceDateTime" de="Liefer-/Leistungsdatum" en="Actual delivery date" fr="Date de livraison effective"/>
    <zv:l k="BillingSpecifiedPeriod" de="Abrechnungszeitraum" en="Invoicing period" fr="Période de facturation"/>
    <zv:l k="StartDateTime" de="Beginn" en="Start date" fr="Date de début"/>
    <zv:l k="EndDateTime" de="Ende" en="End date" fr="Date de fin"/>
    <zv:l k="SpecifiedTradeSettlementLineMonetarySummation" de="Positionssummen" en="Line totals" fr="Totaux de la ligne"/>
    <zv:l k="SpecifiedTradeSettlementLineMonetarySummation/LineTotalAmount" de="Nettobetrag der Position" en="Line net amount" fr="Montant net de la ligne"/>
    <zv:l k="LineTotalAmount" de="Nettobetrag" en="Net amount" fr="Montant net"/>
    <zv:l k="ChargeTotalAmount" de="Summe Zuschläge" en="Sum of charges" fr="Total des charges"/>
    <zv:l k="AllowanceTotalAmount" de="Summe Abschläge" en="Sum of allowances" fr="Total des remises"/>
    <zv:l k="TaxTotalAmount" de="Umsatzsteuer gesamt" en="Total VAT amount" fr="Montant total de TVA"/>
    <zv:l k="GrandTotalAmount" de="Gesamtbetrag" en="Total amount" fr="Montant total"/>
    <zv:l k="TotalAllowanceChargeAmount" de="Summe Zu-/Abschläge" en="Total allowances/charges" fr="Total remises/charges"/>
    <zv:l k="ReceivableSpecifiedTradeAccountingAccount" de="Buchungskonto" en="Accounting account" fr="Compte comptable"/>
    <zv:l k="ReceivableSpecifiedTradeAccountingAccount/ID" de="Kontierung des Käufers" en="Buyer accounting reference" fr="Référence comptable de l'acheteur"/>
    <zv:l k="ReceivableSpecifiedTradeAccountingAccount/TypeCode" de="Kontoart" en="Account type" fr="Type de compte"/>
    <zv:l k="ApplicableHeaderTradeAgreement" de="Vertragsangaben" en="Trade agreement" fr="Accord commercial"/>
    <zv:l k="BuyerReference" de="Käuferreferenz / Leitweg-ID" en="Buyer reference" fr="Référence acheteur"/>
    <zv:l k="SpecifiedProcuringProject" de="Projekt" en="Project reference" fr="Référence de projet"/>
    <zv:l k="SpecifiedProcuringProject/ID" de="Projektnummer" en="Project ID" fr="Identifiant du projet"/>
    <zv:l k="SpecifiedProcuringProject/Name" de="Projektname" en="Project name" fr="Nom du projet"/>
    <zv:l k="ApplicableHeaderTradeDelivery" de="Lieferangaben" en="Delivery information" fr="Informations de livraison"/>
    <zv:l k="RelatedSupplyChainConsignment" de="Sendung" en="Consignment" fr="Envoi"/>
    <zv:l k="SpecifiedLogisticsTransportMovement" de="Transport" en="Transport" fr="Transport"/>
    <zv:l k="ModeCode" de="Verkehrszweig" en="Transport mode" fr="Mode de transport"/>
    <zv:l k="ApplicableHeaderTradeSettlement" de="Abrechnungsangaben" en="Settlement" fr="Règlement"/>
    <zv:l k="CreditorReferenceID" de="Gläubiger-ID" en="Creditor identifier" fr="Identifiant créancier SEPA"/>
    <zv:l k="PaymentReference" de="Verwendungszweck" en="Remittance information" fr="Référence de paiement"/>
    <zv:l k="TaxCurrencyCode" de="Steuerwährung" en="VAT accounting currency" fr="Devise de comptabilisation de la TVA"/>
    <zv:l k="InvoiceCurrencyCode" de="Rechnungswährung" en="Invoice currency" fr="Devise de facturation"/>
    <zv:l k="InvoiceIssuerReference" de="Referenz des Rechnungsstellers" en="Invoice issuer reference" fr="Référence de l'émetteur"/>
    <zv:l k="TaxApplicableTradeCurrencyExchange" de="Währungsumrechnung" en="Currency exchange" fr="Conversion de devise"/>
    <zv:l k="SourceCurrencyCode" de="Ausgangswährung" en="Source currency" fr="Devise source"/>
    <zv:l k="TargetCurrencyCode" de="Zielwährung" en="Target currency" fr="Devise cible"/>
    <zv:l k="ConversionRate" de="Umrechnungskurs" en="Exchange rate" fr="Taux de change"/>
    <zv:l k="ConversionRateDateTime" de="Kursdatum" en="Exchange rate date" fr="Date du taux de change"/>
    <zv:l k="SpecifiedTradeSettlementPaymentMeans" de="Zahlungsart" en="Payment means" fr="Moyen de paiement"/>
    <zv:l k="SpecifiedTradeSettlementPaymentMeans/TypeCode" de="Zahlungsart" en="Payment means" fr="Moyen de paiement"/>
    <zv:l k="Information" de="Erläuterung" en="Payment means text" fr="Libellé du moyen de paiement"/>
    <zv:l k="ApplicableTradeSettlementFinancialCard" de="Zahlungskarte" en="Payment card" fr="Carte de paiement"/>
    <zv:l k="ApplicableTradeSettlementFinancialCard/ID" de="Kartennummer" en="Card number" fr="Numéro de carte"/>
    <zv:l k="CardholderName" de="Karteninhaber" en="Cardholder name" fr="Titulaire de la carte"/>
    <zv:l k="PayerPartyDebtorFinancialAccount" de="Zu belastendes Konto" en="Debited account" fr="Compte à débiter"/>
    <zv:l k="PayeePartyCreditorFinancialAccount" de="Bankverbindung" en="Payment account" fr="Compte de paiement"/>
    <zv:l k="IBANID" de="IBAN" en="IBAN" fr="IBAN"/>
    <zv:l k="AccountName" de="Kontoinhaber" en="Account name" fr="Titulaire du compte"/>
    <zv:l k="ProprietaryID" de="Nationale Kontonummer" en="National account number" fr="Numéro de compte national"/>
    <zv:l k="PayerSpecifiedDebtorFinancialInstitution" de="Bank des Zahlungspflichtigen" en="Payer's bank" fr="Banque du payeur"/>
    <zv:l k="PayeeSpecifiedCreditorFinancialInstitution" de="Bank des Zahlungsempfängers" en="Payee's bank" fr="Banque du bénéficiaire"/>
    <zv:l k="BICID" de="BIC" en="BIC" fr="BIC"/>
    <zv:l k="SpecifiedLogisticsServiceCharge" de="Logistikgebühr" en="Logistics service charge" fr="Frais de service logistique"/>
    <zv:l k="AppliedAmount" de="Betrag" en="Amount" fr="Montant"/>
    <zv:l k="SpecifiedTradePaymentTerms" de="Zahlungsbedingungen" en="Payment terms" fr="Conditions de paiement"/>
    <zv:l k="SpecifiedTradePaymentTerms/Description" de="Zahlungsbedingungen" en="Payment terms" fr="Conditions de paiement"/>
    <zv:l k="DueDateDateTime" de="Fälligkeitsdatum" en="Payment due date" fr="Date d'échéance"/>
    <zv:l k="DirectDebitMandateID" de="Mandatsreferenz" en="Mandate reference" fr="Référence du mandat"/>
    <zv:l k="PartialPaymentAmount" de="Teilzahlungsbetrag" en="Partial payment amount" fr="Montant du paiement partiel"/>
    <zv:l k="ApplicableTradePaymentPenaltyTerms" de="Verzugszuschlag" en="Payment penalty terms" fr="Pénalités de retard"/>
    <zv:l k="ApplicableTradePaymentDiscountTerms" de="Skonto" en="Payment discount terms" fr="Escompte"/>
    <zv:l k="BasisDateTime" de="Basisdatum" en="Base date" fr="Date de référence"/>
    <zv:l k="BasisPeriodMeasure" de="Frist" en="Period" fr="Délai"/>
    <zv:l k="ActualDiscountAmount" de="Skontobetrag" en="Discount amount" fr="Montant de l'escompte"/>
    <zv:l k="ActualPenaltyAmount" de="Zuschlagsbetrag" en="Penalty amount" fr="Montant de la pénalité"/>
    <zv:l k="ApplicableTradePaymentDiscountTerms/CalculationPercent" de="Skontosatz" en="Discount percentage" fr="Taux d'escompte"/>
    <zv:l k="ApplicableTradePaymentPenaltyTerms/CalculationPercent" de="Zuschlagssatz" en="Penalty percentage" fr="Taux de pénalité"/>
    <zv:l k="SpecifiedTradeSettlementHeaderMonetarySummation" de="Summen" en="Document totals" fr="Totaux du document"/>
    <zv:l k="SpecifiedTradeSettlementHeaderMonetarySummation/LineTotalAmount" de="Summe der Positionen" en="Sum of invoice line net amounts" fr="Total des lignes HT"/>
    <zv:l k="TaxBasisTotalAmount" de="Gesamtbetrag ohne USt." en="Invoice total without VAT" fr="Total HT"/>
    <zv:l k="SpecifiedTradeSettlementHeaderMonetarySummation/TaxTotalAmount" de="Umsatzsteuer" en="VAT total" fr="Total TVA"/>
    <zv:l k="RoundingAmount" de="Rundungsbetrag" en="Rounding amount" fr="Montant d'arrondi"/>
    <zv:l k="SpecifiedTradeSettlementHeaderMonetarySummation/GrandTotalAmount" de="Gesamtbetrag inkl. USt." en="Invoice total with VAT" fr="Total TTC"/>
    <zv:l k="TotalPrepaidAmount" de="Bereits gezahlt" en="Paid amount" fr="Montant déjà payé"/>
    <zv:l k="DuePayableAmount" de="Zahlbetrag" en="Amount due for payment" fr="Montant à payer"/>
    <zv:l k="SpecifiedFinancialAdjustment" de="Finanzielle Anpassung" en="Financial adjustment" fr="Ajustement financier"/>
    <zv:l k="SpecifiedAdvancePayment" de="Anzahlung" en="Advance payment" fr="Acompte"/>
    <zv:l k="PaidAmount" de="Gezahlter Betrag" en="Paid amount" fr="Montant payé"/>
    <zv:l k="FormattedReceivedDateTime" de="Zahlungseingang" en="Date received" fr="Date de réception"/>
    <zv:l k="SpecifiedAdvancePayment/IncludedTradeTax" de="Enthaltene Umsatzsteuer" en="Included VAT" fr="TVA incluse"/>
    <zv:l k="SellerTradeParty" de="Verkäufer" en="Seller" fr="Vendeur"/>
    <zv:l k="BuyerTradeParty" de="Käufer" en="Buyer" fr="Acheteur"/>
    <zv:l k="SalesAgentTradeParty" de="Handelsvertreter" en="Sales agent" fr="Agent commercial"/>
    <zv:l k="BuyerTaxRepresentativeTradeParty" de="Steuervertreter des Käufers" en="Buyer tax representative" fr="Représentant fiscal de l'acheteur"/>
    <zv:l k="SellerTaxRepresentativeTradeParty" de="Steuervertreter des Verkäufers" en="Seller tax representative" fr="Représentant fiscal du vendeur"/>
    <zv:l k="ProductEndUserTradeParty" de="Endverbraucher" en="Product end user" fr="Utilisateur final"/>
    <zv:l k="BuyerAgentTradeParty" de="Einkaufsvertreter" en="Buyer agent" fr="Mandataire de l'acheteur"/>
    <zv:l k="ShipToTradeParty" de="Warenempfänger" en="Deliver to party" fr="Destinataire de la livraison"/>
    <zv:l k="UltimateShipToTradeParty" de="Endempfänger" en="Ultimate ship-to party" fr="Destinataire final"/>
    <zv:l k="ShipFromTradeParty" de="Versender" en="Ship-from party" fr="Expéditeur"/>
    <zv:l k="InvoicerTradeParty" de="Rechnungsaussteller" en="Invoicer" fr="Émetteur de la facture"/>
    <zv:l k="InvoiceeTradeParty" de="Rechnungsempfänger" en="Invoicee" fr="Destinataire de la facture"/>
    <zv:l k="PayeeTradeParty" de="Zahlungsempfänger" en="Payee" fr="Bénéficiaire"/>
    <zv:l k="PayerTradeParty" de="Zahlungspflichtiger" en="Payer" fr="Payeur"/>
    <zv:l k="ItemSellerTradeParty" de="Verkäufer der Position" en="Item seller" fr="Vendeur de l'article"/>
    <zv:l k="ManufacturerTradeParty" de="Hersteller" en="Manufacturer" fr="Fabricant"/>
    <zv:l k="TradeParty/ID" de="Kennung" en="Identifier" fr="Identifiant"/>
    <zv:l k="TradeParty/GlobalID" de="Globale Kennung" en="Global identifier" fr="Identifiant global"/>
    <zv:l k="TradeParty/Name" de="Name" en="Name" fr="Nom"/>
    <zv:l k="TradeParty/Description" de="Weitere rechtliche Informationen" en="Additional legal information" fr="Informations juridiques complémentaires"/>
    <zv:l k="RoleCode" de="Rolle" en="Role" fr="Rôle"/>
    <zv:l k="SpecifiedLegalOrganization" de="Registrierung" en="Legal registration" fr="Immatriculation"/>
    <zv:l k="SpecifiedLegalOrganization/ID" de="Registernummer" en="Legal registration ID" fr="Numéro d'immatriculation"/>
    <zv:l k="TradingBusinessName" de="Handelsname" en="Trading name" fr="Nom commercial"/>
    <zv:l k="SpecifiedLegalOrganization/PostalTradeAddress" de="Anschrift laut Register" en="Registered address" fr="Adresse du siège"/>
    <zv:l k="PostalTradeAddress" de="Anschrift" en="Postal address" fr="Adresse postale"/>
    <zv:l k="PostcodeCode" de="Postleitzahl" en="Post code" fr="Code postal"/>
    <zv:l k="LineOne" de="Adresszeile 1" en="Address line 1" fr="Ligne d'adresse 1"/>
    <zv:l k="LineTwo" de="Adresszeile 2" en="Address line 2" fr="Ligne d'adresse 2"/>
    <zv:l k="LineThree" de="Adresszeile 3" en="Address line 3" fr="Ligne d'adresse 3"/>
    <zv:l k="CityName" de="Ort" en="City" fr="Ville"/>
    <zv:l k="CountryID" de="Land" en="Country" fr="Pays"/>
    <zv:l k="CountrySubDivisionName" de="Region" en="Country subdivision" fr="Subdivision du pays"/>
    <zv:l k="DefinedTradeContact" de="Kontakt" en="Contact" fr="Contact"/>
    <zv:l k="PersonName" de="Ansprechpartner" en="Contact person" fr="Personne à contacter"/>
    <zv:l k="DepartmentName" de="Abteilung" en="Department" fr="Service"/>
    <zv:l k="DefinedTradeContact/TypeCode" de="Kontaktart" en="Contact type" fr="Type de contact"/>
    <zv:l k="TelephoneUniversalCommunication" de="Telefon" en="Telephone" fr="Téléphone"/>
    <zv:l k="FaxUniversalCommunication" de="Fax" en="Fax" fr="Fax"/>
    <zv:l k="EmailURIUniversalCommunication" de="E-Mail" en="E-mail" fr="E-mail"/>
    <zv:l k="URIUniversalCommunication" de="Elektronische Adresse" en="Electronic address" fr="Adresse électronique"/>
    <zv:l k="TelephoneUniversalCommunication/CompleteNumber" de="Telefon" en="Telephone" fr="Téléphone"/>
    <zv:l k="FaxUniversalCommunication/CompleteNumber" de="Fax" en="Fax" fr="Fax"/>
    <zv:l k="EmailURIUniversalCommunication/URIID" de="E-Mail" en="E-mail" fr="E-mail"/>
    <zv:l k="URIUniversalCommunication/URIID" de="Elektronische Adresse" en="Electronic address" fr="Adresse électronique"/>
    <zv:l k="CompleteNumber" de="Nummer" en="Number" fr="Numéro"/>
    <zv:l k="SpecifiedTaxRegistration" de="Steuerregistrierung" en="Tax registration" fr="Immatriculation fiscale"/>
    <zv:l k="SpecifiedTaxRegistration/ID" de="Steuerregistrierung" en="Tax registration" fr="Immatriculation fiscale"/>
    <zv:l k="SpecifiedTaxRegistration/ID@VA" de="USt-IdNr." en="VAT identifier" fr="Numéro de TVA intracommunautaire"/>
    <zv:l k="SpecifiedTaxRegistration/ID@FC" de="Steuernummer" en="Tax registration identifier" fr="Identifiant fiscal"/>
    <zv:c l="1001" k="102" de="Steuerbescheid" en="Tax notification" fr="Avis d'imposition"/>
    <zv:c l="1001" k="130" de="Rechnungsdatenblatt" en="Invoicing data sheet" fr="Fiche de données de facturation"/>
    <zv:c l="1001" k="202" de="Direkte Zahlungsbewertung" en="Direct payment valuation" fr="Évaluation de paiement direct"/>
    <zv:c l="1001" k="203" de="Vorläufige Zahlungsbewertung" en="Provisional payment valuation" fr="Évaluation de paiement provisoire"/>
    <zv:c l="1001" k="204" de="Zahlungsbewertung" en="Payment valuation" fr="Évaluation de paiement"/>
    <zv:c l="1001" k="211" de="Abschlagszahlungsanforderung" en="Interim application for payment" fr="Demande de paiement intermédiaire"/>
    <zv:c l="1001" k="218" de="Schlusszahlungsanforderung nach Fertigstellung" en="Final payment request based on completion of work" fr="Demande de paiement final après achèvement"/>
    <zv:c l="1001" k="219" de="Zahlungsanforderung für fertiggestellte Einheiten" en="Payment request for completed units" fr="Demande de paiement pour unités achevées"/>
    <zv:c l="1001" k="261" de="Selbst ausgestellte Gutschrift" en="Self billed credit note" fr="Avoir autofacturé"/>
    <zv:c l="1001" k="262" de="Sammelgutschrift" en="Consolidated credit note - goods and services" fr="Avoir récapitulatif"/>
    <zv:c l="1001" k="295" de="Preisänderungsrechnung" en="Price variation invoice" fr="Facture de révision de prix"/>
    <zv:c l="1001" k="296" de="Gutschrift wegen Preisänderung" en="Credit note for price variation" fr="Avoir pour révision de prix"/>
    <zv:c l="1001" k="308" de="Delkredere-Gutschrift" en="Delcredere credit note" fr="Avoir ducroire"/>
    <zv:c l="1001" k="325" de="Proformarechnung" en="Proforma invoice" fr="Facture pro forma"/>
    <zv:c l="1001" k="326" de="Teilrechnung" en="Partial invoice" fr="Facture partielle"/>
    <zv:c l="1001" k="331" de="Handelsrechnung mit Packliste" en="Commercial invoice which includes a packing list" fr="Facture commerciale avec liste de colisage"/>
    <zv:c l="1001" k="380" de="Rechnung" en="Commercial invoice" fr="Facture"/>
    <zv:c l="1001" k="381" de="Gutschrift" en="Credit note" fr="Avoir"/>
    <zv:c l="1001" k="382" de="Provisionsabrechnung" en="Commission note" fr="Note de commission"/>
    <zv:c l="1001" k="383" de="Belastungsanzeige" en="Debit note" fr="Note de débit"/>
    <zv:c l="1001" k="384" de="Rechnungskorrektur" en="Corrected invoice" fr="Facture rectificative"/>
    <zv:c l="1001" k="385" de="Sammelrechnung" en="Consolidated invoice" fr="Facture récapitulative"/>
    <zv:c l="1001" k="386" de="Vorauszahlungsrechnung" en="Prepayment invoice" fr="Facture d'acompte"/>
    <zv:c l="1001" k="387" de="Mietrechnung" en="Hire invoice" fr="Facture de location"/>
    <zv:c l="1001" k="388" de="Steuerrechnung" en="Tax invoice" fr="Facture fiscale"/>
    <zv:c l="1001" k="389" de="Selbst ausgestellte Rechnung (Gutschriftsverfahren)" en="Self-billed invoice" fr="Autofacture"/>
    <zv:c l="1001" k="390" de="Delkredere-Rechnung" en="Delcredere invoice" fr="Facture ducroire"/>
    <zv:c l="1001" k="393" de="Factoring-Rechnung" en="Factored invoice" fr="Facture affacturée"/>
    <zv:c l="1001" k="394" de="Leasingrechnung" en="Lease invoice" fr="Facture de crédit-bail"/>
    <zv:c l="1001" k="395" de="Konsignationsrechnung" en="Consignment invoice" fr="Facture de consignation"/>
    <zv:c l="1001" k="396" de="Factoring-Gutschrift" en="Factored credit note" fr="Avoir affacturé"/>
    <zv:c l="1001" k="420" de="OCR-Zahlungsgutschrift" en="Optical Character Reading (OCR) payment credit note" fr="Avoir de paiement OCR"/>
    <zv:c l="1001" k="456" de="Belastungsanzeige (Bank)" en="Debit advice" fr="Avis de débit"/>
    <zv:c l="1001" k="457" de="Storno einer Belastung" en="Reversal of debit" fr="Annulation de débit"/>
    <zv:c l="1001" k="458" de="Storno einer Gutschrift" en="Reversal of credit" fr="Annulation de crédit"/>
    <zv:c l="1001" k="471" de="Selbst ausgestellte Rechnungskorrektur" en="Self-billed corrective invoice, invoice type, Corrected" fr="Facture rectificative autofacturée"/>
    <zv:c l="1001" k="472" de="Factoring-Rechnungskorrektur" en="Factored Corrective Invoice, invoice type, Corrected" fr="Facture rectificative affacturée"/>
    <zv:c l="1001" k="473" de="Selbst ausgestellte Factoring-Rechnungskorrektur" en="Self billed Factored corrective invoice, invoice type, Corrected" fr="Facture rectificative autofacturée affacturée"/>
    <zv:c l="1001" k="50" de="Ausschreibung oder Los" en="Validated pricing tender (tender or lot)" fr="Appel d'offres ou lot"/>
    <zv:c l="1001" k="500" de="Selbst ausgestellte Vorauszahlungsrechnung" en="Self Prepayment invoice, invoice type, Original" fr="Facture d'acompte autofacturée"/>
    <zv:c l="1001" k="501" de="Selbst ausgestellte Factoring-Rechnung" en="Self billed factored invoice, invoice type, Original" fr="Autofacture affacturée"/>
    <zv:c l="1001" k="502" de="Selbst ausgestellte Factoring-Gutschrift" en="Self billet factored Credit Note, Credit note type, Corrected" fr="Avoir autofacturé affacturé"/>
    <zv:c l="1001" k="503" de="Gutschrift zur Vorauszahlungsrechnung" en="Prepayment credit note, credit note type, Corrected" fr="Avoir sur facture d'acompte"/>
    <zv:c l="1001" k="527" de="Selbst ausgestellte Belastungsanzeige" en="Self billed debit note" fr="Note de débit autofacturée"/>
    <zv:c l="1001" k="532" de="Gutschrift des Spediteurs" en="Forwarder's credit note" fr="Avoir du transitaire"/>
    <zv:c l="1001" k="553" de="Abweichungsbericht zur Speditionsrechnung" en="Forwarder's invoice discrepancy report" fr="Rapport d'écart sur facture du transitaire"/>
    <zv:c l="1001" k="575" de="Versicherungsrechnung" en="Insurer's invoice" fr="Facture d'assureur"/>
    <zv:c l="1001" k="623" de="Speditionsrechnung" en="Forwarder's invoice" fr="Facture du transitaire"/>
    <zv:c l="1001" k="633" de="Hafengebührenrechnung" en="Port charges documents" fr="Documents de frais portuaires"/>
    <zv:c l="1001" k="71" de="Zahlungsanforderung" en="Request for payment" fr="Demande de paiement"/>
    <zv:c l="1001" k="751" de="Rechnungsinformation für Buchungszwecke" en="Invoice information for accounting purposes" fr="Information de facture pour comptabilisation"/>
    <zv:c l="1001" k="780" de="Frachtrechnung" en="Freight invoice" fr="Facture de fret"/>
    <zv:c l="1001" k="80" de="Belastungsanzeige (Waren/Dienstleistungen)" en="Debit note related to goods or services" fr="Note de débit (biens ou services)"/>
    <zv:c l="1001" k="81" de="Gutschriftsanzeige (Waren/Dienstleistungen)" en="Credit note related to goods or services" fr="Avoir (biens ou services)"/>
    <zv:c l="1001" k="817" de="Schadensmeldung" en="Claim notification" fr="Notification de sinistre"/>
    <zv:c l="1001" k="82" de="Rechnung über Verbrauchsleistungen" en="Metered services invoice" fr="Facture de services mesurés"/>
    <zv:c l="1001" k="83" de="Gutschrift (Finanzkorrektur)" en="Credit note related to financial adjustments" fr="Avoir (ajustements financiers)"/>
    <zv:c l="1001" k="84" de="Belastungsanzeige (Finanzkorrektur)" en="Debit note related to financial adjustments" fr="Note de débit (ajustements financiers)"/>
    <zv:c l="1001" k="870" de="Konsulatsfaktura" en="Consular invoice" fr="Facture consulaire"/>
    <zv:c l="1001" k="875" de="Abschlagsrechnung (Bauleistung)" en="Partial construction invoice" fr="Facture de situation (travaux)"/>
    <zv:c l="1001" k="876" de="Teilschlussrechnung (Bauleistung)" en="Partial final construction invoice" fr="Facture de situation finale partielle (travaux)"/>
    <zv:c l="1001" k="877" de="Schlussrechnung (Bauleistung)" en="Final construction invoice" fr="Facture finale (travaux)"/>
    <zv:c l="1001" k="916" de="Referenzdokument" en="Related document" fr="Document de référence"/>
    <zv:c l="1001" k="935" de="Zollrechnung" en="Customs invoice" fr="Facture douanière"/>
    <zv:c l="1153" k="AAA" en="Order acknowledgement document identifier"/>
    <zv:c l="1153" k="AAB" en="Proforma invoice document identifier"/>
    <zv:c l="1153" k="AAC" en="Documentary credit identifier"/>
    <zv:c l="1153" k="AAD" en="Contract document addendum identifier"/>
    <zv:c l="1153" k="AAE" en="Goods declaration number"/>
    <zv:c l="1153" k="AAF" en="Debit card number"/>
    <zv:c l="1153" k="AAG" en="Offer number"/>
    <zv:c l="1153" k="AAH" en="Bank's batch interbank transaction reference number"/>
    <zv:c l="1153" k="AAI" en="Bank's individual interbank transaction reference number"/>
    <zv:c l="1153" k="AAJ" en="Delivery order number"/>
    <zv:c l="1153" k="AAK" en="Despatch advice number"/>
    <zv:c l="1153" k="AAL" en="Drawing number"/>
    <zv:c l="1153" k="AAM" en="Waybill number"/>
    <zv:c l="1153" k="AAN" en="Delivery schedule number"/>
    <zv:c l="1153" k="AAO" en="Consignment identifier, consignee assigned"/>
    <zv:c l="1153" k="AAP" en="Partial shipment identifier"/>
    <zv:c l="1153" k="AAQ" en="Transport equipment identifier"/>
    <zv:c l="1153" k="AAR" en="Municipality assigned business registry number"/>
    <zv:c l="1153" k="AAS" en="Transport contract document identifier"/>
    <zv:c l="1153" k="AAT" en="Master label number"/>
    <zv:c l="1153" k="AAU" en="Despatch note document identifier"/>
    <zv:c l="1153" k="AAV" en="Enquiry number"/>
    <zv:c l="1153" k="AAW" en="Docket number"/>
    <zv:c l="1153" k="AAX" en="Civil action number"/>
    <zv:c l="1153" k="AAY" en="Carrier's agent reference number"/>
    <zv:c l="1153" k="AAZ" en="Standard Carrier Alpha Code (SCAC) number"/>
    <zv:c l="1153" k="ABA" en="Customs valuation decision number"/>
    <zv:c l="1153" k="ABB" en="End use authorization number"/>
    <zv:c l="1153" k="ABC" en="Anti-dumping case number"/>
    <zv:c l="1153" k="ABD" en="Customs tariff number"/>
    <zv:c l="1153" k="ABE" en="Declarant's reference number"/>
    <zv:c l="1153" k="ABF" en="Repair estimate number"/>
    <zv:c l="1153" k="ABG" en="Customs decision request number"/>
    <zv:c l="1153" k="ABH" en="Sub-house bill of lading number"/>
    <zv:c l="1153" k="ABI" en="Tax payment identifier"/>
    <zv:c l="1153" k="ABJ" en="Quota number"/>
    <zv:c l="1153" k="ABK" en="Transit (onward carriage) guarantee (bond) number"/>
    <zv:c l="1153" k="ABL" en="Customs guarantee number"/>
    <zv:c l="1153" k="ABM" en="Replacing part number"/>
    <zv:c l="1153" k="ABN" en="Seller's catalogue number"/>
    <zv:c l="1153" k="ABO" en="Originator's reference"/>
    <zv:c l="1153" k="ABP" en="Declarant's Customs identity number"/>
    <zv:c l="1153" k="ABQ" en="Importer reference number"/>
    <zv:c l="1153" k="ABR" en="Export clearance instruction reference number"/>
    <zv:c l="1153" k="ABS" en="Import clearance instruction reference number"/>
    <zv:c l="1153" k="ABT" en="Goods declaration document identifier, Customs"/>
    <zv:c l="1153" k="ABU" en="Article number"/>
    <zv:c l="1153" k="ABV" en="Intra-plant routing"/>
    <zv:c l="1153" k="ABW" en="Stock keeping unit number"/>
    <zv:c l="1153" k="ABX" en="Text Element Identifier deletion reference"/>
    <zv:c l="1153" k="ABY" en="Allotment identification (Air)"/>
    <zv:c l="1153" k="ABZ" en="Vehicle licence number"/>
    <zv:c l="1153" k="AC" en="Air cargo transfer manifest"/>
    <zv:c l="1153" k="ACA" en="Cargo acceptance order reference number"/>
    <zv:c l="1153" k="ACB" en="US government agency number"/>
    <zv:c l="1153" k="ACC" en="Shipping unit identification"/>
    <zv:c l="1153" k="ACD" en="Additional reference number"/>
    <zv:c l="1153" k="ACE" en="Related document number"/>
    <zv:c l="1153" k="ACF" en="Addressee reference"/>
    <zv:c l="1153" k="ACG" en="ATA carnet number"/>
    <zv:c l="1153" k="ACH" en="Packaging unit identification"/>
    <zv:c l="1153" k="ACI" en="Outerpackaging unit identification"/>
    <zv:c l="1153" k="ACJ" en="Customer material specification number"/>
    <zv:c l="1153" k="ACK" en="Bank reference"/>
    <zv:c l="1153" k="ACL" en="Principal reference number"/>
    <zv:c l="1153" k="ACN" en="Collection advice document identifier"/>
    <zv:c l="1153" k="ACO" en="Iron charge number"/>
    <zv:c l="1153" k="ACP" en="Hot roll number"/>
    <zv:c l="1153" k="ACQ" en="Cold roll number"/>
    <zv:c l="1153" k="ACR" en="Railway wagon number"/>
    <zv:c l="1153" k="ACT" en="Unique claims reference number of the sender"/>
    <zv:c l="1153" k="ACU" en="Loss/event number"/>
    <zv:c l="1153" k="ACV" en="Estimate order reference number"/>
    <zv:c l="1153" k="ACW" en="Reference number to previous message"/>
    <zv:c l="1153" k="ACX" en="Banker's acceptance"/>
    <zv:c l="1153" k="ACY" en="Duty memo number"/>
    <zv:c l="1153" k="ACZ" en="Equipment transport charge number"/>
    <zv:c l="1153" k="ADA" en="Buyer's item number"/>
    <zv:c l="1153" k="ADB" en="Matured certificate of deposit"/>
    <zv:c l="1153" k="ADC" en="Loan"/>
    <zv:c l="1153" k="ADD" en="Analysis number/test number"/>
    <zv:c l="1153" k="ADE" en="Account number"/>
    <zv:c l="1153" k="ADF" en="Treaty number"/>
    <zv:c l="1153" k="ADG" en="Catastrophe number"/>
    <zv:c l="1153" k="ADI" en="Bureau signing (statement reference)"/>
    <zv:c l="1153" k="ADJ" en="Company / syndicate reference 1"/>
    <zv:c l="1153" k="ADK" en="Company / syndicate reference 2"/>
    <zv:c l="1153" k="ADL" en="Ordering customer consignment reference number"/>
    <zv:c l="1153" k="ADM" en="Shipowner's authorization number"/>
    <zv:c l="1153" k="ADN" en="Inland transport order number"/>
    <zv:c l="1153" k="ADO" en="Container work order reference number"/>
    <zv:c l="1153" k="ADP" en="Statement number"/>
    <zv:c l="1153" k="ADQ" en="Unique market reference"/>
    <zv:c l="1153" k="ADT" en="Group accounting"/>
    <zv:c l="1153" k="ADU" en="Broker reference 1"/>
    <zv:c l="1153" k="ADV" en="Broker reference 2"/>
    <zv:c l="1153" k="ADW" en="Lloyd's claims office reference"/>
    <zv:c l="1153" k="ADX" en="Secure delivery terms and conditions agreement reference"/>
    <zv:c l="1153" k="ADY" en="Report number"/>
    <zv:c l="1153" k="ADZ" en="Trader account number"/>
    <zv:c l="1153" k="AE" en="Authorization for expense (AFE) number"/>
    <zv:c l="1153" k="AEA" en="Government agency reference number"/>
    <zv:c l="1153" k="AEB" en="Assembly number"/>
    <zv:c l="1153" k="AEC" en="Symbol number"/>
    <zv:c l="1153" k="AED" en="Commodity number"/>
    <zv:c l="1153" k="AEE" en="Eur 1 certificate number"/>
    <zv:c l="1153" k="AEF" en="Customer process specification number"/>
    <zv:c l="1153" k="AEG" en="Customer specification number"/>
    <zv:c l="1153" k="AEH" en="Applicable instructions or standards"/>
    <zv:c l="1153" k="AEI" en="Registration number of previous Customs declaration"/>
    <zv:c l="1153" k="AEJ" en="Post-entry reference"/>
    <zv:c l="1153" k="AEK" en="Payment order number"/>
    <zv:c l="1153" k="AEL" en="Delivery number (transport)"/>
    <zv:c l="1153" k="AEM" en="Transport route"/>
    <zv:c l="1153" k="AEN" en="Customer's unit inventory number"/>
    <zv:c l="1153" k="AEO" en="Product reservation number"/>
    <zv:c l="1153" k="AEP" en="Project number"/>
    <zv:c l="1153" k="AEQ" en="Drawing list number"/>
    <zv:c l="1153" k="AER" en="Project specification number"/>
    <zv:c l="1153" k="AES" en="Primary reference"/>
    <zv:c l="1153" k="AET" en="Request for cancellation number"/>
    <zv:c l="1153" k="AEU" en="Supplier's control number"/>
    <zv:c l="1153" k="AEV" en="Shipping note number"/>
    <zv:c l="1153" k="AEW" en="Empty container bill number"/>
    <zv:c l="1153" k="AEX" en="Non-negotiable maritime transport document number"/>
    <zv:c l="1153" k="AEY" en="Substitute air waybill number"/>
    <zv:c l="1153" k="AEZ" en="Despatch note (post parcels) number"/>
    <zv:c l="1153" k="AF" en="Airlines flight identification number"/>
    <zv:c l="1153" k="AFA" en="Through bill of lading number"/>
    <zv:c l="1153" k="AFB" en="Cargo manifest number"/>
    <zv:c l="1153" k="AFC" en="Bordereau number"/>
    <zv:c l="1153" k="AFD" en="Customs item number"/>
    <zv:c l="1153" k="AFE" en="Export Control Commodity number (ECCN)"/>
    <zv:c l="1153" k="AFF" en="Marking/label reference"/>
    <zv:c l="1153" k="AFG" en="Tariff number"/>
    <zv:c l="1153" k="AFH" en="Replenishment purchase order number"/>
    <zv:c l="1153" k="AFI" en="Immediate transportation no. for in bond movement"/>
    <zv:c l="1153" k="AFJ" en="Transportation exportation no. for in bond movement"/>
    <zv:c l="1153" k="AFK" en="Immediate exportation no. for in bond movement"/>
    <zv:c l="1153" k="AFL" en="Associated invoices"/>
    <zv:c l="1153" k="AFM" en="Secondary Customs reference"/>
    <zv:c l="1153" k="AFN" en="Account party's reference"/>
    <zv:c l="1153" k="AFO" en="Beneficiary's reference"/>
    <zv:c l="1153" k="AFP" en="Second beneficiary's reference"/>
    <zv:c l="1153" k="AFQ" en="Applicant's bank reference"/>
    <zv:c l="1153" k="AFR" en="Issuing bank's reference"/>
    <zv:c l="1153" k="AFS" en="Beneficiary's bank reference"/>
    <zv:c l="1153" k="AFT" en="Direct payment valuation number"/>
    <zv:c l="1153" k="AFU" en="Direct payment valuation request number"/>
    <zv:c l="1153" k="AFV" en="Quantity valuation number"/>
    <zv:c l="1153" k="AFW" en="Quantity valuation request number"/>
    <zv:c l="1153" k="AFX" en="Bill of quantities number"/>
    <zv:c l="1153" k="AFY" en="Payment valuation number"/>
    <zv:c l="1153" k="AFZ" en="Situation number"/>
    <zv:c l="1153" k="AGA" en="Agreement to pay number"/>
    <zv:c l="1153" k="AGB" en="Contract party reference number"/>
    <zv:c l="1153" k="AGC" en="Account party's bank reference"/>
    <zv:c l="1153" k="AGD" en="Agent's bank reference"/>
    <zv:c l="1153" k="AGE" en="Agent's reference"/>
    <zv:c l="1153" k="AGF" en="Applicant's reference"/>
    <zv:c l="1153" k="AGG" en="Dispute number"/>
    <zv:c l="1153" k="AGH" en="Credit rating agency's reference number"/>
    <zv:c l="1153" k="AGI" en="Request number"/>
    <zv:c l="1153" k="AGJ" en="Single transaction sequence number"/>
    <zv:c l="1153" k="AGK" en="Application reference number"/>
    <zv:c l="1153" k="AGL" en="Delivery verification certificate"/>
    <zv:c l="1153" k="AGM" en="Number of temporary importation document"/>
    <zv:c l="1153" k="AGN" en="Reference number quoted on statement"/>
    <zv:c l="1153" k="AGO" en="Sender's reference to the original message"/>
    <zv:c l="1153" k="AGP" en="Company issued equipment ID"/>
    <zv:c l="1153" k="AGQ" en="Domestic flight number"/>
    <zv:c l="1153" k="AGR" en="International flight number"/>
    <zv:c l="1153" k="AGS" en="Employer identification number of service bureau"/>
    <zv:c l="1153" k="AGT" en="Service group identification number"/>
    <zv:c l="1153" k="AGU" en="Member number"/>
    <zv:c l="1153" k="AGV" en="Previous member number"/>
    <zv:c l="1153" k="AGW" en="Scheme/plan number"/>
    <zv:c l="1153" k="AGX" en="Previous scheme/plan number"/>
    <zv:c l="1153" k="AGY" en="Receiving party's member identification"/>
    <zv:c l="1153" k="AGZ" en="Payroll number"/>
    <zv:c l="1153" k="AHA" en="Packaging specification number"/>
    <zv:c l="1153" k="AHB" en="Authority issued equipment identification"/>
    <zv:c l="1153" k="AHC" en="Training flight number"/>
    <zv:c l="1153" k="AHD" en="Fund code number"/>
    <zv:c l="1153" k="AHE" en="Signal code number"/>
    <zv:c l="1153" k="AHF" en="Major force program number"/>
    <zv:c l="1153" k="AHG" en="Nomination number"/>
    <zv:c l="1153" k="AHH" en="Laboratory registration number"/>
    <zv:c l="1153" k="AHI" en="Transport contract reference number"/>
    <zv:c l="1153" k="AHJ" en="Payee's reference number"/>
    <zv:c l="1153" k="AHK" en="Payer's reference number"/>
    <zv:c l="1153" k="AHL" en="Creditor's reference number"/>
    <zv:c l="1153" k="AHM" en="Debtor's reference number"/>
    <zv:c l="1153" k="AHN" en="Joint venture reference number"/>
    <zv:c l="1153" k="AHO" en="Chamber of Commerce registration number"/>
    <zv:c l="1153" k="AHP" en="Tax registration number"/>
    <zv:c l="1153" k="AHQ" en="Wool identification number"/>
    <zv:c l="1153" k="AHR" en="Wool tax reference number"/>
    <zv:c l="1153" k="AHS" en="Meat processing establishment registration number"/>
    <zv:c l="1153" k="AHT" en="Quarantine/treatment status reference number"/>
    <zv:c l="1153" k="AHU" en="Request for quote number"/>
    <zv:c l="1153" k="AHV" en="Manual processing authority number"/>
    <zv:c l="1153" k="AHX" en="Rate note number"/>
    <zv:c l="1153" k="AHY" en="Freight Forwarder number"/>
    <zv:c l="1153" k="AHZ" en="Customs release code"/>
    <zv:c l="1153" k="AIA" en="Compliance code number"/>
    <zv:c l="1153" k="AIB" en="Department of transportation bond number"/>
    <zv:c l="1153" k="AIC" en="Export establishment number"/>
    <zv:c l="1153" k="AID" en="Certificate of conformity"/>
    <zv:c l="1153" k="AIE" en="Ministerial certificate of homologation"/>
    <zv:c l="1153" k="AIF" en="Previous delivery instruction number"/>
    <zv:c l="1153" k="AIG" en="Passport number"/>
    <zv:c l="1153" k="AIH" en="Common transaction reference number"/>
    <zv:c l="1153" k="AII" en="Bank's common transaction reference number"/>
    <zv:c l="1153" k="AIJ" en="Customer's individual transaction reference number"/>
    <zv:c l="1153" k="AIK" en="Bank's individual transaction reference number"/>
    <zv:c l="1153" k="AIL" en="Customer's common transaction reference number"/>
    <zv:c l="1153" k="AIM" en="Individual transaction reference number"/>
    <zv:c l="1153" k="AIN" en="Product sourcing agreement number"/>
    <zv:c l="1153" k="AIO" en="Customs transhipment number"/>
    <zv:c l="1153" k="AIP" en="Customs preference inquiry number"/>
    <zv:c l="1153" k="AIQ" en="Packing plant number"/>
    <zv:c l="1153" k="AIR" en="Original certificate number"/>
    <zv:c l="1153" k="AIS" en="Processing plant number"/>
    <zv:c l="1153" k="AIT" en="Slaughter plant number"/>
    <zv:c l="1153" k="AIU" en="Charge card account number"/>
    <zv:c l="1153" k="AIV" en="Event reference number"/>
    <zv:c l="1153" k="AIW" en="Transport section reference number"/>
    <zv:c l="1153" k="AIX" en="Referred product for mechanical analysis"/>
    <zv:c l="1153" k="AIY" en="Referred product for chemical analysis"/>
    <zv:c l="1153" k="AIZ" en="Consolidated invoice number"/>
    <zv:c l="1153" k="AJA" en="Part reference indicator in a drawing"/>
    <zv:c l="1153" k="AJB" en="U.S. Code of Federal Regulations (CFR)"/>
    <zv:c l="1153" k="AJC" en="Purchasing activity clause number"/>
    <zv:c l="1153" k="AJD" en="U.S. Defense Federal Acquisition Regulation Supplement"/>
    <zv:c l="1153" k="AJE" en="Agency clause number"/>
    <zv:c l="1153" k="AJF" en="Circular publication number"/>
    <zv:c l="1153" k="AJG" en="U.S. Federal Acquisition Regulation"/>
    <zv:c l="1153" k="AJH" en="U.S. General Services Administration Regulation"/>
    <zv:c l="1153" k="AJI" en="U.S. Federal Information Resources Management Regulation"/>
    <zv:c l="1153" k="AJJ" en="Paragraph"/>
    <zv:c l="1153" k="AJK" en="Special instructions number"/>
    <zv:c l="1153" k="AJL" en="Site specific procedures, terms, and conditions number"/>
    <zv:c l="1153" k="AJM" en="Master solicitation procedures, terms, and conditions"/>
    <zv:c l="1153" k="AJN" en="U.S. Department of Veterans Affairs Acquisition Regulation"/>
    <zv:c l="1153" k="AJO" en="Military Interdepartmental Purchase Request (MIPR) number"/>
    <zv:c l="1153" k="AJP" en="Foreign military sales number"/>
    <zv:c l="1153" k="AJQ" en="Defense priorities allocation system priority rating"/>
    <zv:c l="1153" k="AJR" en="Wage determination number"/>
    <zv:c l="1153" k="AJS" en="Agreement number"/>
    <zv:c l="1153" k="AJT" en="Standard Industry Classification (SIC) number"/>
    <zv:c l="1153" k="AJU" en="End item number"/>
    <zv:c l="1153" k="AJV" en="Federal supply schedule item number"/>
    <zv:c l="1153" k="AJW" en="Technical document number"/>
    <zv:c l="1153" k="AJX" en="Technical order number"/>
    <zv:c l="1153" k="AJY" en="Suffix"/>
    <zv:c l="1153" k="AJZ" en="Transportation account number"/>
    <zv:c l="1153" k="AKA" en="Container disposition order reference number"/>
    <zv:c l="1153" k="AKB" en="Container prefix"/>
    <zv:c l="1153" k="AKC" en="Transport equipment return reference"/>
    <zv:c l="1153" k="AKD" en="Transport equipment survey reference"/>
    <zv:c l="1153" k="AKE" en="Transport equipment survey report number"/>
    <zv:c l="1153" k="AKF" en="Transport equipment stuffing order"/>
    <zv:c l="1153" k="AKG" en="Vehicle Identification Number (VIN)"/>
    <zv:c l="1153" k="AKH" en="Government bill of lading"/>
    <zv:c l="1153" k="AKI" en="Ordering customer's second reference number"/>
    <zv:c l="1153" k="AKJ" en="Direct debit reference"/>
    <zv:c l="1153" k="AKK" en="Meter reading at the beginning of the delivery"/>
    <zv:c l="1153" k="AKL" en="Meter reading at the end of delivery"/>
    <zv:c l="1153" k="AKM" en="Replenishment purchase order range start number"/>
    <zv:c l="1153" k="AKN" en="Third bank's reference"/>
    <zv:c l="1153" k="AKO" en="Action authorization number"/>
    <zv:c l="1153" k="AKP" en="Appropriation number"/>
    <zv:c l="1153" k="AKQ" en="Product change authority number"/>
    <zv:c l="1153" k="AKR" en="General cargo consignment reference number"/>
    <zv:c l="1153" k="AKS" en="Catalogue sequence number"/>
    <zv:c l="1153" k="AKT" en="Forwarding order number"/>
    <zv:c l="1153" k="AKU" en="Transport equipment survey reference number"/>
    <zv:c l="1153" k="AKV" en="Lease contract reference"/>
    <zv:c l="1153" k="AKW" en="Transport costs reference number"/>
    <zv:c l="1153" k="AKX" en="Transport equipment stripping order"/>
    <zv:c l="1153" k="AKY" en="Prior policy number"/>
    <zv:c l="1153" k="AKZ" en="Policy number"/>
    <zv:c l="1153" k="ALA" en="Procurement budget number"/>
    <zv:c l="1153" k="ALB" en="Domestic inventory management code"/>
    <zv:c l="1153" k="ALC" en="Customer reference number assigned to previous balance of"/>
    <zv:c l="1153" k="ALD" en="Previous credit advice reference number"/>
    <zv:c l="1153" k="ALE" en="Reporting form number"/>
    <zv:c l="1153" k="ALF" en="Authorization number for exception to dangerous goods"/>
    <zv:c l="1153" k="ALG" en="Dangerous goods security number"/>
    <zv:c l="1153" k="ALH" en="Dangerous goods transport licence number"/>
    <zv:c l="1153" k="ALI" en="Previous rental agreement number"/>
    <zv:c l="1153" k="ALJ" en="Next rental agreement reason number"/>
    <zv:c l="1153" k="ALK" en="Consignee's invoice number"/>
    <zv:c l="1153" k="ALL" en="Message batch number"/>
    <zv:c l="1153" k="ALM" en="Previous delivery schedule number"/>
    <zv:c l="1153" k="ALN" en="Physical inventory recount reference number"/>
    <zv:c l="1153" k="ALO" en="Receiving advice number"/>
    <zv:c l="1153" k="ALP" en="Returnable container reference number"/>
    <zv:c l="1153" k="ALQ" en="Returns notice number"/>
    <zv:c l="1153" k="ALR" en="Sales forecast number"/>
    <zv:c l="1153" k="ALS" en="Sales report number"/>
    <zv:c l="1153" k="ALT" en="Previous tax control number"/>
    <zv:c l="1153" k="ALU" en="AGERD (Aerospace Ground Equipment Requirement Data) number"/>
    <zv:c l="1153" k="ALV" en="Registered capital reference"/>
    <zv:c l="1153" k="ALW" en="Standard number of inspection document"/>
    <zv:c l="1153" k="ALX" en="Model"/>
    <zv:c l="1153" k="ALY" en="Financial management reference"/>
    <zv:c l="1153" k="ALZ" en="NOTIfication for COLlection number (NOTICOL)"/>
    <zv:c l="1153" k="AMA" en="Previous request for metered reading reference number"/>
    <zv:c l="1153" k="AMB" en="Next rental agreement number"/>
    <zv:c l="1153" k="AMC" en="Reference number of a request for metered reading"/>
    <zv:c l="1153" k="AMD" en="Hastening number"/>
    <zv:c l="1153" k="AME" en="Repair data request number"/>
    <zv:c l="1153" k="AMF" en="Consumption data request number"/>
    <zv:c l="1153" k="AMG" en="Profile number"/>
    <zv:c l="1153" k="AMH" en="Case number"/>
    <zv:c l="1153" k="AMI" en="Government quality assurance and control level Number"/>
    <zv:c l="1153" k="AMJ" en="Payment plan reference"/>
    <zv:c l="1153" k="AMK" en="Replaced meter unit number"/>
    <zv:c l="1153" k="AML" en="Replenishment purchase order range end number"/>
    <zv:c l="1153" k="AMM" en="Insurer assigned reference number"/>
    <zv:c l="1153" k="AMN" en="Canadian excise entry number"/>
    <zv:c l="1153" k="AMO" en="Premium rate table"/>
    <zv:c l="1153" k="AMP" en="Advise through bank's reference"/>
    <zv:c l="1153" k="AMQ" en="US, Department of Transportation bond surety code"/>
    <zv:c l="1153" k="AMR" en="US, Food and Drug Administration establishment indicator"/>
    <zv:c l="1153" k="AMS" en="US, Federal Communications Commission (FCC) import"/>
    <zv:c l="1153" k="AMT" en="Goods and Services Tax identification number"/>
    <zv:c l="1153" k="AMU" en="Integrated logistic support cross reference number"/>
    <zv:c l="1153" k="AMV" en="Department number"/>
    <zv:c l="1153" k="AMW" en="Buyer's catalogue number"/>
    <zv:c l="1153" k="AMX" en="Financial settlement party's reference number"/>
    <zv:c l="1153" k="AMY" en="Standard's version number"/>
    <zv:c l="1153" k="AMZ" en="Pipeline number"/>
    <zv:c l="1153" k="ANA" en="Account servicing bank's reference number"/>
    <zv:c l="1153" k="ANB" en="Completed units payment request reference"/>
    <zv:c l="1153" k="ANC" en="Payment in advance request reference"/>
    <zv:c l="1153" k="AND" en="Parent file"/>
    <zv:c l="1153" k="ANE" en="Sub file"/>
    <zv:c l="1153" k="ANF" en="CAD file layer convention"/>
    <zv:c l="1153" k="ANG" en="Technical regulation"/>
    <zv:c l="1153" k="ANH" en="Plot file"/>
    <zv:c l="1153" k="ANI" en="File conversion journal"/>
    <zv:c l="1153" k="ANJ" en="Authorization number"/>
    <zv:c l="1153" k="ANK" en="Reference number assigned by third party"/>
    <zv:c l="1153" k="ANL" en="Deposit reference number"/>
    <zv:c l="1153" k="ANM" en="Named bank's reference"/>
    <zv:c l="1153" k="ANN" en="Drawee's reference"/>
    <zv:c l="1153" k="ANO" en="Case of need party's reference"/>
    <zv:c l="1153" k="ANP" en="Collecting bank's reference"/>
    <zv:c l="1153" k="ANQ" en="Remitting bank's reference"/>
    <zv:c l="1153" k="ANR" en="Principal's bank reference"/>
    <zv:c l="1153" k="ANS" en="Presenting bank's reference"/>
    <zv:c l="1153" k="ANT" en="Consignee's reference"/>
    <zv:c l="1153" k="ANU" en="Financial transaction reference number"/>
    <zv:c l="1153" k="ANV" en="Credit reference number"/>
    <zv:c l="1153" k="ANW" en="Receiving bank's authorization number"/>
    <zv:c l="1153" k="ANX" en="Clearing reference"/>
    <zv:c l="1153" k="ANY" en="Sending bank's reference number"/>
    <zv:c l="1153" k="AOA" en="Documentary payment reference"/>
    <zv:c l="1153" k="AOD" en="Accounting file reference"/>
    <zv:c l="1153" k="AOE" en="Sender's file reference number"/>
    <zv:c l="1153" k="AOF" en="Receiver's file reference number"/>
    <zv:c l="1153" k="AOG" en="Source document internal reference"/>
    <zv:c l="1153" k="AOH" en="Principal's reference"/>
    <zv:c l="1153" k="AOI" en="Debit reference number"/>
    <zv:c l="1153" k="AOJ" en="Calendar"/>
    <zv:c l="1153" k="AOK" en="Work shift"/>
    <zv:c l="1153" k="AOL" en="Work breakdown structure"/>
    <zv:c l="1153" k="AOM" en="Organisation breakdown structure"/>
    <zv:c l="1153" k="AON" en="Work task charge number"/>
    <zv:c l="1153" k="AOO" en="Functional work group"/>
    <zv:c l="1153" k="AOP" en="Work team"/>
    <zv:c l="1153" k="AOQ" en="Department"/>
    <zv:c l="1153" k="AOR" en="Statement of work"/>
    <zv:c l="1153" k="AOS" en="Work package"/>
    <zv:c l="1153" k="AOT" en="Planning package"/>
    <zv:c l="1153" k="AOU" en="Cost account"/>
    <zv:c l="1153" k="AOV" en="Work order"/>
    <zv:c l="1153" k="AOW" en="Transportation Control Number (TCN)"/>
    <zv:c l="1153" k="AOX" en="Constraint notation"/>
    <zv:c l="1153" k="AOY" en="ETERMS reference"/>
    <zv:c l="1153" k="AOZ" en="Implementation version number"/>
    <zv:c l="1153" k="AP" en="Accounts receivable number"/>
    <zv:c l="1153" k="APA" en="Incorporated legal reference"/>
    <zv:c l="1153" k="APB" en="Payment instalment reference number"/>
    <zv:c l="1153" k="APC" en="Equipment owner reference number"/>
    <zv:c l="1153" k="APD" en="Cedent's claim number"/>
    <zv:c l="1153" k="APE" en="Reinsurer's claim number"/>
    <zv:c l="1153" k="APF" en="Price/sales catalogue response reference number"/>
    <zv:c l="1153" k="APG" en="General purpose message reference number"/>
    <zv:c l="1153" k="APH" en="Invoicing data sheet reference number"/>
    <zv:c l="1153" k="API" en="Inventory report reference number"/>
    <zv:c l="1153" k="APJ" en="Ceiling formula reference number"/>
    <zv:c l="1153" k="APK" en="Price variation formula reference number"/>
    <zv:c l="1153" k="APL" en="Reference to account servicing bank's message"/>
    <zv:c l="1153" k="APM" en="Party sequence number"/>
    <zv:c l="1153" k="APN" en="Purchaser's request reference"/>
    <zv:c l="1153" k="APO" en="Contractor request reference"/>
    <zv:c l="1153" k="APP" en="Accident reference number"/>
    <zv:c l="1153" k="APQ" en="Commercial account summary reference number"/>
    <zv:c l="1153" k="APR" en="Contract breakdown reference"/>
    <zv:c l="1153" k="APS" en="Contractor registration number"/>
    <zv:c l="1153" k="APT" en="Applicable coefficient identification number"/>
    <zv:c l="1153" k="APU" en="Special budget account number"/>
    <zv:c l="1153" k="APV" en="Authorisation for repair reference"/>
    <zv:c l="1153" k="APW" en="Manufacturer defined repair rates reference"/>
    <zv:c l="1153" k="APX" en="Original submitter log number"/>
    <zv:c l="1153" k="APY" en="Original submitter, parent Data Maintenance Request (DMR)"/>
    <zv:c l="1153" k="APZ" en="Original submitter, child Data Maintenance Request (DMR)"/>
    <zv:c l="1153" k="AQA" en="Entry point assessment log number"/>
    <zv:c l="1153" k="AQB" en="Entry point assessment log number, parent DMR"/>
    <zv:c l="1153" k="AQC" en="Entry point assessment log number, child DMR"/>
    <zv:c l="1153" k="AQD" en="Data structure tag"/>
    <zv:c l="1153" k="AQE" en="Central secretariat log number"/>
    <zv:c l="1153" k="AQF" en="Central secretariat log number, parent Data Maintenance"/>
    <zv:c l="1153" k="AQG" en="Central secretariat log number, child Data Maintenance"/>
    <zv:c l="1153" k="AQH" en="International assessment log number"/>
    <zv:c l="1153" k="AQI" en="International assessment log number, parent Data"/>
    <zv:c l="1153" k="AQJ" en="International assessment log number, child Data Maintenance"/>
    <zv:c l="1153" k="AQK" en="Status report number"/>
    <zv:c l="1153" k="AQL" en="Message design group number"/>
    <zv:c l="1153" k="AQM" en="US Customs Service (USCS) entry code"/>
    <zv:c l="1153" k="AQN" en="Beginning job sequence number"/>
    <zv:c l="1153" k="AQO" en="Sender's clause number"/>
    <zv:c l="1153" k="AQP" en="Dun and Bradstreet Canada's 8 digit Standard Industrial"/>
    <zv:c l="1153" k="AQQ" en="Activite Principale Exercee (APE) identifier"/>
    <zv:c l="1153" k="AQR" en="Dun and Bradstreet US 8 digit Standard Industrial"/>
    <zv:c l="1153" k="AQS" en="Nomenclature Activity Classification Economy (NACE)"/>
    <zv:c l="1153" k="AQT" en="Norme Activite Francaise (NAF) identifier"/>
    <zv:c l="1153" k="AQU" en="Registered contractor activity type"/>
    <zv:c l="1153" k="AQV" en="Statistic Bundes Amt (SBA) identifier"/>
    <zv:c l="1153" k="AQW" en="State or province assigned entity identification"/>
    <zv:c l="1153" k="AQX" en="Institute of Security and Future Market Development (ISFMD)"/>
    <zv:c l="1153" k="AQY" en="File identification number"/>
    <zv:c l="1153" k="AQZ" en="Bankruptcy procedure number"/>
    <zv:c l="1153" k="ARA" en="National government business identification number"/>
    <zv:c l="1153" k="ARB" en="Prior Data Universal Number System (DUNS) number"/>
    <zv:c l="1153" k="ARC" en="Companies Registry Office (CRO) number"/>
    <zv:c l="1153" k="ARD" en="Costa Rican judicial number"/>
    <zv:c l="1153" k="ARE" en="Numero de Identificacion Tributaria (NIT)"/>
    <zv:c l="1153" k="ARF" en="Patron number"/>
    <zv:c l="1153" k="ARG" en="Registro Informacion Fiscal (RIF) number"/>
    <zv:c l="1153" k="ARH" en="Registro Unico de Contribuyente (RUC) number"/>
    <zv:c l="1153" k="ARI" en="Tokyo SHOKO Research (TSR) business identifier"/>
    <zv:c l="1153" k="ARJ" en="Personal identity card number"/>
    <zv:c l="1153" k="ARK" en="Systeme Informatique pour le Repertoire des ENtreprises"/>
    <zv:c l="1153" k="ARL" en="Systeme Informatique pour le Repertoire des ETablissements"/>
    <zv:c l="1153" k="ARM" en="Publication issue number"/>
    <zv:c l="1153" k="ARN" en="Original filing number"/>
    <zv:c l="1153" k="ARO" en="Document page identifier"/>
    <zv:c l="1153" k="ARP" en="Public filing registration number"/>
    <zv:c l="1153" k="ARQ" en="Regiristo Federal de Contribuyentes"/>
    <zv:c l="1153" k="ARR" en="Social security number"/>
    <zv:c l="1153" k="ARS" en="Document volume number"/>
    <zv:c l="1153" k="ART" en="Book number"/>
    <zv:c l="1153" k="ARU" en="Stock exchange company identifier"/>
    <zv:c l="1153" k="ARV" en="Imputation account"/>
    <zv:c l="1153" k="ARW" en="Financial phase reference"/>
    <zv:c l="1153" k="ARX" en="Technical phase reference"/>
    <zv:c l="1153" k="ARY" en="Prior contractor registration number"/>
    <zv:c l="1153" k="ARZ" en="Stock adjustment number"/>
    <zv:c l="1153" k="ASA" en="Dispensation reference"/>
    <zv:c l="1153" k="ASB" en="Investment reference number"/>
    <zv:c l="1153" k="ASC" en="Assuming company"/>
    <zv:c l="1153" k="ASD" en="Budget chapter"/>
    <zv:c l="1153" k="ASE" en="Duty free products security number"/>
    <zv:c l="1153" k="ASF" en="Duty free products receipt authorisation number"/>
    <zv:c l="1153" k="ASG" en="Party information message reference"/>
    <zv:c l="1153" k="ASH" en="Formal statement reference"/>
    <zv:c l="1153" k="ASI" en="Proof of delivery reference number"/>
    <zv:c l="1153" k="ASJ" en="Supplier's credit claim reference number"/>
    <zv:c l="1153" k="ASK" en="Picture of actual product"/>
    <zv:c l="1153" k="ASL" en="Picture of a generic product"/>
    <zv:c l="1153" k="ASM" en="Trading partner identification number"/>
    <zv:c l="1153" k="ASN" en="Prior trading partner identification number"/>
    <zv:c l="1153" k="ASO" en="Password"/>
    <zv:c l="1153" k="ASP" en="Formal report number"/>
    <zv:c l="1153" k="ASQ" en="Fund account number"/>
    <zv:c l="1153" k="ASR" en="Safe custody number"/>
    <zv:c l="1153" k="ASS" en="Master account number"/>
    <zv:c l="1153" k="AST" en="Group reference number"/>
    <zv:c l="1153" k="ASU" en="Accounting transmission number"/>
    <zv:c l="1153" k="ASV" en="Product data file number"/>
    <zv:c l="1153" k="ASW" en="Cadastro Geral do Contribuinte (CGC)"/>
    <zv:c l="1153" k="ASX" en="Foreign resident identification number"/>
    <zv:c l="1153" k="ASY" en="CD-ROM"/>
    <zv:c l="1153" k="ASZ" en="Physical medium"/>
    <zv:c l="1153" k="ATA" en="Financial cancellation reference number"/>
    <zv:c l="1153" k="ATB" en="Purchase for export Customs agreement number"/>
    <zv:c l="1153" k="ATC" en="Judgment number"/>
    <zv:c l="1153" k="ATD" en="Secretariat number"/>
    <zv:c l="1153" k="ATE" en="Previous banking status message reference"/>
    <zv:c l="1153" k="ATF" en="Last received banking status message reference"/>
    <zv:c l="1153" k="ATG" en="Bank's documentary procedure reference"/>
    <zv:c l="1153" k="ATH" en="Customer's documentary procedure reference"/>
    <zv:c l="1153" k="ATI" en="Safe deposit box number"/>
    <zv:c l="1153" k="ATJ" en="Receiving Bankgiro number"/>
    <zv:c l="1153" k="ATK" en="Sending Bankgiro number"/>
    <zv:c l="1153" k="ATL" en="Bankgiro reference"/>
    <zv:c l="1153" k="ATM" en="Guarantee number"/>
    <zv:c l="1153" k="ATN" en="Collection instrument number"/>
    <zv:c l="1153" k="ATO" en="Converted Postgiro number"/>
    <zv:c l="1153" k="ATP" en="Cost centre alignment number"/>
    <zv:c l="1153" k="ATQ" en="Kamer Van Koophandel (KVK) number"/>
    <zv:c l="1153" k="ATR" en="Institut Belgo-Luxembourgeois de Codification (IBLC) number"/>
    <zv:c l="1153" k="ATS" en="External object reference"/>
    <zv:c l="1153" k="ATT" en="Exceptional transport authorisation number"/>
    <zv:c l="1153" k="ATU" en="Clave Unica de Identificacion Tributaria (CUIT)"/>
    <zv:c l="1153" k="ATV" en="Registro Unico Tributario (RUT)"/>
    <zv:c l="1153" k="ATW" en="Flat rack container bundle identification number"/>
    <zv:c l="1153" k="ATX" en="Transport equipment acceptance order reference"/>
    <zv:c l="1153" k="ATY" en="Transport equipment release order reference"/>
    <zv:c l="1153" k="ATZ" en="Ship's stay reference number"/>
    <zv:c l="1153" k="AU" en="Authorization to meet competition number"/>
    <zv:c l="1153" k="AUA" en="Place of positioning reference"/>
    <zv:c l="1153" k="AUB" en="Party reference"/>
    <zv:c l="1153" k="AUC" en="Issued prescription identification"/>
    <zv:c l="1153" k="AUD" en="Collection reference"/>
    <zv:c l="1153" k="AUE" en="Travel service"/>
    <zv:c l="1153" k="AUF" en="Consignment stock contract"/>
    <zv:c l="1153" k="AUG" en="Importer's letter of credit reference"/>
    <zv:c l="1153" k="AUH" en="Performed prescription identification"/>
    <zv:c l="1153" k="AUI" en="Image reference"/>
    <zv:c l="1153" k="AUJ" en="Proposed purchase order reference number"/>
    <zv:c l="1153" k="AUK" en="Application for financial support reference number"/>
    <zv:c l="1153" k="AUL" en="Manufacturing quality agreement number"/>
    <zv:c l="1153" k="AUM" en="Software editor reference"/>
    <zv:c l="1153" k="AUN" en="Software reference"/>
    <zv:c l="1153" k="AUO" en="Software quality reference"/>
    <zv:c l="1153" k="AUP" en="Consolidated orders' reference"/>
    <zv:c l="1153" k="AUQ" en="Customs binding ruling number"/>
    <zv:c l="1153" k="AUR" en="Customs non-binding ruling number"/>
    <zv:c l="1153" k="AUS" en="Delivery route reference"/>
    <zv:c l="1153" k="AUT" en="Net area supplier reference"/>
    <zv:c l="1153" k="AUU" en="Time series reference"/>
    <zv:c l="1153" k="AUV" en="Connecting point to central grid"/>
    <zv:c l="1153" k="AUW" en="Marketing plan identification number (MPIN)"/>
    <zv:c l="1153" k="AUX" en="Entity reference number, previous"/>
    <zv:c l="1153" k="AUY" en="International Standard Industrial Classification (ISIC)"/>
    <zv:c l="1153" k="AUZ" en="Customs pre-approval ruling number"/>
    <zv:c l="1153" k="AV" en="Account payable number"/>
    <zv:c l="1153" k="AVA" en="First financial institution's transaction reference"/>
    <zv:c l="1153" k="AVB" en="Product characteristics directory"/>
    <zv:c l="1153" k="AVC" en="Supplier's customer reference number"/>
    <zv:c l="1153" k="AVD" en="Inventory report request number"/>
    <zv:c l="1153" k="AVE" en="Metering point"/>
    <zv:c l="1153" k="AVF" en="Passenger reservation number"/>
    <zv:c l="1153" k="AVG" en="Slaughterhouse approval number"/>
    <zv:c l="1153" k="AVH" en="Meat cutting plant approval number"/>
    <zv:c l="1153" k="AVI" en="Customer travel service identifier"/>
    <zv:c l="1153" k="AVJ" en="Export control classification number"/>
    <zv:c l="1153" k="AVK" en="Broker reference 3"/>
    <zv:c l="1153" k="AVL" en="Consignment information"/>
    <zv:c l="1153" k="AVM" en="Goods item information"/>
    <zv:c l="1153" k="AVN" en="Dangerous Goods information"/>
    <zv:c l="1153" k="AVO" en="Pilotage services exemption number"/>
    <zv:c l="1153" k="AVP" en="Person registration number"/>
    <zv:c l="1153" k="AVQ" en="Place of packing approval number"/>
    <zv:c l="1153" k="AVR" en="Original Mandate Reference"/>
    <zv:c l="1153" k="AVS" en="Mandate Reference"/>
    <zv:c l="1153" k="AVT" en="Reservation station indentifier"/>
    <zv:c l="1153" k="AVU" en="Unique goods shipment identifier"/>
    <zv:c l="1153" k="AVV" en="Framework Agreement Number"/>
    <zv:c l="1153" k="AVW" en="Hash value"/>
    <zv:c l="1153" k="AVX" en="Movement reference number"/>
    <zv:c l="1153" k="AVY" en="Economic Operators Registration and Identification Number"/>
    <zv:c l="1153" k="AVZ" en="Local Reference Number"/>
    <zv:c l="1153" k="AWA" en="Rate code number"/>
    <zv:c l="1153" k="AWB" en="Air waybill number"/>
    <zv:c l="1153" k="AWC" en="Documentary credit amendment number"/>
    <zv:c l="1153" k="AWD" en="Advising bank's reference"/>
    <zv:c l="1153" k="AWE" en="Cost centre"/>
    <zv:c l="1153" k="AWF" en="Work item quantity determination"/>
    <zv:c l="1153" k="AWG" en="Internal data process number"/>
    <zv:c l="1153" k="AWH" en="Category of work reference"/>
    <zv:c l="1153" k="AWI" en="Policy form number"/>
    <zv:c l="1153" k="AWJ" en="Net area"/>
    <zv:c l="1153" k="AWK" en="Service provider"/>
    <zv:c l="1153" k="AWL" en="Error position"/>
    <zv:c l="1153" k="AWM" en="Service category reference"/>
    <zv:c l="1153" k="AWN" en="Connected location"/>
    <zv:c l="1153" k="AWO" en="Related party"/>
    <zv:c l="1153" k="AWP" en="Latest accounting entry record reference"/>
    <zv:c l="1153" k="AWQ" en="Accounting entry"/>
    <zv:c l="1153" k="AWR" en="Document reference, original"/>
    <zv:c l="1153" k="AWS" en="Hygienic Certificate number, national"/>
    <zv:c l="1153" k="AWT" en="Administrative Reference Code"/>
    <zv:c l="1153" k="AWU" en="Pick-up sheet number"/>
    <zv:c l="1153" k="AWV" en="Phone number"/>
    <zv:c l="1153" k="AWW" en="Buyer's fund number"/>
    <zv:c l="1153" k="AWX" en="Company trading account number"/>
    <zv:c l="1153" k="AWY" en="Reserved goods identifier"/>
    <zv:c l="1153" k="AWZ" en="Handling and movement reference number"/>
    <zv:c l="1153" k="AXA" en="Instruction to despatch reference number"/>
    <zv:c l="1153" k="AXB" en="Instruction for returns number"/>
    <zv:c l="1153" k="AXC" en="Metered services consumption report number"/>
    <zv:c l="1153" k="AXD" en="Order status enquiry number"/>
    <zv:c l="1153" k="AXE" en="Firm booking reference number"/>
    <zv:c l="1153" k="AXF" en="Product inquiry number"/>
    <zv:c l="1153" k="AXG" en="Split delivery number"/>
    <zv:c l="1153" k="AXH" en="Service relation number"/>
    <zv:c l="1153" k="AXI" en="Serial shipping container code"/>
    <zv:c l="1153" k="AXJ" en="Test specification number"/>
    <zv:c l="1153" k="AXK" en="Transport status report number"/>
    <zv:c l="1153" k="AXL" en="Tooling contract number"/>
    <zv:c l="1153" k="AXM" en="Formula reference number"/>
    <zv:c l="1153" k="AXN" en="Pre-agreement number"/>
    <zv:c l="1153" k="AXO" en="Product certification number"/>
    <zv:c l="1153" k="AXP" en="Consignment contract number"/>
    <zv:c l="1153" k="AXQ" en="Product specification reference number"/>
    <zv:c l="1153" k="AXR" en="Payroll deduction advice reference"/>
    <zv:c l="1153" k="AXS" en="TRACES party identification"/>
    <zv:c l="1153" k="AXU" en="Block Stowage Reference"/>
    <zv:c l="1153" k="BA" en="Beginning meter reading actual"/>
    <zv:c l="1153" k="BC" en="Buyer's contract number"/>
    <zv:c l="1153" k="BD" en="Bid number"/>
    <zv:c l="1153" k="BE" en="Beginning meter reading estimated"/>
    <zv:c l="1153" k="BH" en="House bill of lading number"/>
    <zv:c l="1153" k="BM" en="Bill of lading number"/>
    <zv:c l="1153" k="BN" en="Consignment identifier, carrier assigned"/>
    <zv:c l="1153" k="BO" en="Blanket order number"/>
    <zv:c l="1153" k="BR" en="Broker or sales office number"/>
    <zv:c l="1153" k="BT" en="Batch number/lot number"/>
    <zv:c l="1153" k="BTP" en="Battery and accumulator producer registration number"/>
    <zv:c l="1153" k="BW" en="Blended with number"/>
    <zv:c l="1153" k="CAS" en="IATA Cargo Agent CASS Address number"/>
    <zv:c l="1153" k="CAT" en="Matching of entries, balanced"/>
    <zv:c l="1153" k="CAU" en="Entry flagging"/>
    <zv:c l="1153" k="CAV" en="Matching of entries, unbalanced"/>
    <zv:c l="1153" k="CAW" en="Document reference, internal"/>
    <zv:c l="1153" k="CAX" en="European Value Added Tax identification"/>
    <zv:c l="1153" k="CAY" en="Cost accounting document"/>
    <zv:c l="1153" k="CAZ" en="Grid operator's customer reference number"/>
    <zv:c l="1153" k="CBA" en="Ticket control number"/>
    <zv:c l="1153" k="CBB" en="Order shipment grouping reference"/>
    <zv:c l="1153" k="CD" en="Credit note number"/>
    <zv:c l="1153" k="CEC" en="Ceding company"/>
    <zv:c l="1153" k="CED" en="Debit letter number"/>
    <zv:c l="1153" k="CFE" en="Consignee's further order"/>
    <zv:c l="1153" k="CFF" en="Animal farm licence number"/>
    <zv:c l="1153" k="CFO" en="Consignor's further order"/>
    <zv:c l="1153" k="CG" en="Consignee's order number"/>
    <zv:c l="1153" k="CH" en="Customer catalogue number"/>
    <zv:c l="1153" k="CK" en="Cheque number"/>
    <zv:c l="1153" k="CKN" en="Checking number"/>
    <zv:c l="1153" k="CM" en="Credit memo number"/>
    <zv:c l="1153" k="CMR" en="Road consignment note number"/>
    <zv:c l="1153" k="CN" en="Carrier's reference number"/>
    <zv:c l="1153" k="CNO" en="Charges note document attachment indicator"/>
    <zv:c l="1153" k="COF" en="Call off order number"/>
    <zv:c l="1153" k="CP" en="Condition of purchase document number"/>
    <zv:c l="1153" k="CR" en="Customer reference number"/>
    <zv:c l="1153" k="CRN" en="Transport means journey identifier"/>
    <zv:c l="1153" k="CS" en="Condition of sale document number"/>
    <zv:c l="1153" k="CST" en="Team assignment number"/>
    <zv:c l="1153" k="CT" en="Contract number"/>
    <zv:c l="1153" k="CU" en="Consignment identifier, consignor assigned"/>
    <zv:c l="1153" k="CV" en="Container operators reference number"/>
    <zv:c l="1153" k="CW" en="Package number"/>
    <zv:c l="1153" k="CZ" en="Cooperation contract number"/>
    <zv:c l="1153" k="DA" en="Deferment approval number"/>
    <zv:c l="1153" k="DAN" en="Debit account number"/>
    <zv:c l="1153" k="DB" en="Buyer's debtor number"/>
    <zv:c l="1153" k="DI" en="Distributor invoice number"/>
    <zv:c l="1153" k="DL" en="Debit note number"/>
    <zv:c l="1153" k="DM" en="Document identifier"/>
    <zv:c l="1153" k="DQ" en="Delivery note number"/>
    <zv:c l="1153" k="DR" en="Dock receipt number"/>
    <zv:c l="1153" k="EA" en="Ending meter reading actual"/>
    <zv:c l="1153" k="EB" en="Embargo permit number"/>
    <zv:c l="1153" k="ED" en="Export declaration"/>
    <zv:c l="1153" k="EE" en="Ending meter reading estimated"/>
    <zv:c l="1153" k="EEP" en="Electrical and electronic equipment producer registration number"/>
    <zv:c l="1153" k="EI" en="Employer's identification number"/>
    <zv:c l="1153" k="EN" en="Embargo number"/>
    <zv:c l="1153" k="EQ" en="Equipment number"/>
    <zv:c l="1153" k="ER" en="Container/equipment receipt number"/>
    <zv:c l="1153" k="ERN" en="Exporter's reference number"/>
    <zv:c l="1153" k="ET" en="Excess transportation number"/>
    <zv:c l="1153" k="EX" en="Export permit identifier"/>
    <zv:c l="1153" k="FC" en="Fiscal number"/>
    <zv:c l="1153" k="FF" en="Consignment identifier, freight forwarder assigned"/>
    <zv:c l="1153" k="FI" en="File line identifier"/>
    <zv:c l="1153" k="FLW" en="Flow reference number"/>
    <zv:c l="1153" k="FN" en="Freight bill number"/>
    <zv:c l="1153" k="FO" en="Foreign exchange"/>
    <zv:c l="1153" k="FS" en="Final sequence number"/>
    <zv:c l="1153" k="FT" en="Free zone identifier"/>
    <zv:c l="1153" k="FV" en="File version number"/>
    <zv:c l="1153" k="FX" en="Foreign exchange contract number"/>
    <zv:c l="1153" k="GA" en="Standard's number"/>
    <zv:c l="1153" k="GC" en="Government contract number"/>
    <zv:c l="1153" k="GD" en="Standard's code number"/>
    <zv:c l="1153" k="GDN" en="General declaration number"/>
    <zv:c l="1153" k="GN" en="Government reference number"/>
    <zv:c l="1153" k="HS" en="Harmonised system number"/>
    <zv:c l="1153" k="HWB" en="House waybill number"/>
    <zv:c l="1153" k="IA" en="Internal vendor number"/>
    <zv:c l="1153" k="IB" en="In bond number"/>
    <zv:c l="1153" k="ICA" en="IATA cargo agent code number"/>
    <zv:c l="1153" k="ICE" en="Insurance certificate reference number"/>
    <zv:c l="1153" k="ICO" en="Insurance contract reference number"/>
    <zv:c l="1153" k="II" en="Initial sample inspection report number"/>
    <zv:c l="1153" k="IL" en="Internal order number"/>
    <zv:c l="1153" k="INB" en="Intermediary broker"/>
    <zv:c l="1153" k="INN" en="Interchange number new"/>
    <zv:c l="1153" k="INO" en="Interchange number old"/>
    <zv:c l="1153" k="IP" en="Import permit identifier"/>
    <zv:c l="1153" k="IS" en="Invoice number suffix"/>
    <zv:c l="1153" k="IT" en="Internal customer number"/>
    <zv:c l="1153" k="IV" en="Invoice document identifier"/>
    <zv:c l="1153" k="JB" en="Job number"/>
    <zv:c l="1153" k="JE" en="Ending job sequence number"/>
    <zv:c l="1153" k="LA" en="Shipping label serial number"/>
    <zv:c l="1153" k="LAN" en="Loading authorisation identifier"/>
    <zv:c l="1153" k="LAR" en="Lower number in range"/>
    <zv:c l="1153" k="LB" en="Lockbox"/>
    <zv:c l="1153" k="LC" en="Letter of credit number"/>
    <zv:c l="1153" k="LI" en="Document line identifier"/>
    <zv:c l="1153" k="LO" en="Load planning number"/>
    <zv:c l="1153" k="LRC" en="Reservation office identifier"/>
    <zv:c l="1153" k="LS" en="Bar coded label serial number"/>
    <zv:c l="1153" k="MA" en="Ship notice/manifest number"/>
    <zv:c l="1153" k="MB" en="Master bill of lading number"/>
    <zv:c l="1153" k="MF" en="Manufacturer's part number"/>
    <zv:c l="1153" k="MG" en="Meter unit number"/>
    <zv:c l="1153" k="MH" en="Manufacturing order number"/>
    <zv:c l="1153" k="MR" en="Message recipient"/>
    <zv:c l="1153" k="MRN" en="Mailing reference number"/>
    <zv:c l="1153" k="MS" en="Message sender"/>
    <zv:c l="1153" k="MSS" en="Manufacturer's material safety data sheet number"/>
    <zv:c l="1153" k="MWB" en="Master air waybill number"/>
    <zv:c l="1153" k="NA" en="North American hazardous goods classification number"/>
    <zv:c l="1153" k="NF" en="Nota Fiscal"/>
    <zv:c l="1153" k="OH" en="Current invoice number"/>
    <zv:c l="1153" k="OI" en="Previous invoice number"/>
    <zv:c l="1153" k="ON" en="Order document identifier, buyer assigned"/>
    <zv:c l="1153" k="OP" en="Original purchase order"/>
    <zv:c l="1153" k="OR" en="General order number"/>
    <zv:c l="1153" k="PB" en="Payer's financial institution account number"/>
    <zv:c l="1153" k="PC" en="Production code"/>
    <zv:c l="1153" k="PD" en="Promotion deal number"/>
    <zv:c l="1153" k="PE" en="Plant number"/>
    <zv:c l="1153" k="PF" en="Prime contractor contract number"/>
    <zv:c l="1153" k="PI" en="Price list version number"/>
    <zv:c l="1153" k="PK" en="Packing list number"/>
    <zv:c l="1153" k="PL" en="Price list number"/>
    <zv:c l="1153" k="POR" en="Purchase order response number"/>
    <zv:c l="1153" k="PP" en="Purchase order change number"/>
    <zv:c l="1153" k="PQ" en="Payment reference"/>
    <zv:c l="1153" k="PR" en="Price quote number"/>
    <zv:c l="1153" k="PS" en="Purchase order number suffix"/>
    <zv:c l="1153" k="PW" en="Prior purchase order number"/>
    <zv:c l="1153" k="PY" en="Payee's financial institution account number"/>
    <zv:c l="1153" k="RA" en="Remittance advice number"/>
    <zv:c l="1153" k="RC" en="Rail/road routing code"/>
    <zv:c l="1153" k="RCN" en="Railway consignment note number"/>
    <zv:c l="1153" k="RE" en="Release number"/>
    <zv:c l="1153" k="REN" en="Consignment receipt identifier"/>
    <zv:c l="1153" k="RF" en="Export reference number"/>
    <zv:c l="1153" k="RR" en="Payer's financial institution transit routing No.(ACH"/>
    <zv:c l="1153" k="RT" en="Payee's financial institution transit routing No."/>
    <zv:c l="1153" k="SA" en="Sales person number"/>
    <zv:c l="1153" k="SB" en="Sales region number"/>
    <zv:c l="1153" k="SD" en="Sales department number"/>
    <zv:c l="1153" k="SE" en="Serial number"/>
    <zv:c l="1153" k="SEA" en="Allocated seat"/>
    <zv:c l="1153" k="SF" en="Ship from"/>
    <zv:c l="1153" k="SH" en="Previous highest schedule number"/>
    <zv:c l="1153" k="SI" en="SID (Shipper's identifying number for shipment)"/>
    <zv:c l="1153" k="SM" en="Sales office number"/>
    <zv:c l="1153" k="SN" en="Transport equipment seal identifier"/>
    <zv:c l="1153" k="SP" en="Scan line"/>
    <zv:c l="1153" k="SQ" en="Equipment sequence number"/>
    <zv:c l="1153" k="SRN" en="Shipment reference number"/>
    <zv:c l="1153" k="SS" en="Sellers reference number"/>
    <zv:c l="1153" k="STA" en="Station reference number"/>
    <zv:c l="1153" k="SW" en="Swap order number"/>
    <zv:c l="1153" k="SZ" en="Specification number"/>
    <zv:c l="1153" k="TB" en="Trucker's bill of lading"/>
    <zv:c l="1153" k="TCR" en="Terminal operator's consignment reference"/>
    <zv:c l="1153" k="TE" en="Telex message number"/>
    <zv:c l="1153" k="TF" en="Transfer number"/>
    <zv:c l="1153" k="TI" en="TIR carnet number"/>
    <zv:c l="1153" k="TIN" en="Transport instruction number"/>
    <zv:c l="1153" k="TL" en="Tax exemption licence number"/>
    <zv:c l="1153" k="TN" en="Transaction reference number"/>
    <zv:c l="1153" k="TP" en="Test report number"/>
    <zv:c l="1153" k="UAR" en="Upper number of range"/>
    <zv:c l="1153" k="UC" en="Ultimate customer's reference number"/>
    <zv:c l="1153" k="UCN" en="Unique consignment reference number"/>
    <zv:c l="1153" k="UN" en="United Nations Dangerous Goods identifier"/>
    <zv:c l="1153" k="UO" en="Ultimate customer's order number"/>
    <zv:c l="1153" k="URI" en="Uniform Resource Identifier"/>
    <zv:c l="1153" k="VA" en="VAT registration number"/>
    <zv:c l="1153" k="VC" en="Vendor contract number"/>
    <zv:c l="1153" k="VGR" en="Transport equipment gross mass verification reference"/>
    <zv:c l="1153" k="VM" en="Vessel identifier"/>
    <zv:c l="1153" k="VN" en="Order number (vendor)"/>
    <zv:c l="1153" k="VON" en="Voyage number"/>
    <zv:c l="1153" k="VOR" en="Transport equipment gross mass verification order reference"/>
    <zv:c l="1153" k="VP" en="Vendor product number"/>
    <zv:c l="1153" k="VR" en="Vendor ID number"/>
    <zv:c l="1153" k="VS" en="Vendor order number suffix"/>
    <zv:c l="1153" k="VT" en="Motor vehicle identification number"/>
    <zv:c l="1153" k="VV" en="Voucher number"/>
    <zv:c l="1153" k="WE" en="Warehouse entry number"/>
    <zv:c l="1153" k="WM" en="Weight agreement number"/>
    <zv:c l="1153" k="WN" en="Well number"/>
    <zv:c l="1153" k="WR" en="Warehouse receipt number"/>
    <zv:c l="1153" k="WS" en="Warehouse storage location number"/>
    <zv:c l="1153" k="WY" en="Rail waybill number"/>
    <zv:c l="1153" k="XA" en="Company/place registration number"/>
    <zv:c l="1153" k="XC" en="Cargo control number"/>
    <zv:c l="1153" k="XP" en="Previous cargo control number"/>
    <zv:c l="1153" k="ZZZ" en="Mutually defined reference number"/>
    <zv:c l="1229" k="1" en="Added"/>
    <zv:c l="1229" k="10" en="Not found"/>
    <zv:c l="1229" k="100" en="Final response"/>
    <zv:c l="1229" k="101" en="Debit advice requested"/>
    <zv:c l="1229" k="102" en="Transaction not impacted"/>
    <zv:c l="1229" k="103" en="Patient to be notified"/>
    <zv:c l="1229" k="104" en="Healthcare provider to be notified"/>
    <zv:c l="1229" k="105" en="Usual general practitioner to be notified"/>
    <zv:c l="1229" k="106" en="Advice without details"/>
    <zv:c l="1229" k="107" en="Advice with details"/>
    <zv:c l="1229" k="108" en="Amendment requested"/>
    <zv:c l="1229" k="109" en="For information"/>
    <zv:c l="1229" k="11" en="Not amended"/>
    <zv:c l="1229" k="110" en="Withdraw"/>
    <zv:c l="1229" k="111" en="Delivery date change"/>
    <zv:c l="1229" k="112" en="Quantity change"/>
    <zv:c l="1229" k="113" en="Resale and claim"/>
    <zv:c l="1229" k="114" en="Resale"/>
    <zv:c l="1229" k="115" en="Prior addition"/>
    <zv:c l="1229" k="116" en="Expired"/>
    <zv:c l="1229" k="117" en="Hold"/>
    <zv:c l="1229" k="118" en="Open"/>
    <zv:c l="1229" k="119" en="Observe"/>
    <zv:c l="1229" k="12" en="Line item numbers changed"/>
    <zv:c l="1229" k="13" en="Buyer has deducted amount"/>
    <zv:c l="1229" k="14" en="Buyer claims against invoice"/>
    <zv:c l="1229" k="15" en="Charge back by seller"/>
    <zv:c l="1229" k="16" en="Seller will issue credit note"/>
    <zv:c l="1229" k="17" en="Terms changed for new terms"/>
    <zv:c l="1229" k="18" en="Abide outcome of negotiations"/>
    <zv:c l="1229" k="19" en="Seller rejects dispute"/>
    <zv:c l="1229" k="2" en="Deleted"/>
    <zv:c l="1229" k="20" en="Settlement"/>
    <zv:c l="1229" k="21" en="No delivery"/>
    <zv:c l="1229" k="22" en="Call-off delivery"/>
    <zv:c l="1229" k="23" en="Proposed amendment"/>
    <zv:c l="1229" k="24" en="Accepted with amendment, no confirmation required"/>
    <zv:c l="1229" k="25" en="Equipment provisionally repaired"/>
    <zv:c l="1229" k="26" en="Included"/>
    <zv:c l="1229" k="27" en="Upon receipt and verification of documents we shall cover you when due as per your instructions"/>
    <zv:c l="1229" k="28" en="Upon receipt and verification of documents we shall authorize you to debit our account with you when due"/>
    <zv:c l="1229" k="29" en="On receipt of your authenticated advice we shall cover you when due as per your instructions"/>
    <zv:c l="1229" k="3" en="Changed"/>
    <zv:c l="1229" k="30" en="On receipt of your authenticated advice we shall authorize you to debit our account with you when due"/>
    <zv:c l="1229" k="31" en="On receipt of your authenticated advice we shall credit your account with us when due"/>
    <zv:c l="1229" k="32" en="Credit advice requested for direct debit"/>
    <zv:c l="1229" k="33" en="Credit advice and acknowledgement for direct debit"/>
    <zv:c l="1229" k="34" en="Inquiry"/>
    <zv:c l="1229" k="35" en="Checked"/>
    <zv:c l="1229" k="36" en="Not checked"/>
    <zv:c l="1229" k="37" en="Cancelled"/>
    <zv:c l="1229" k="38" en="Replaced"/>
    <zv:c l="1229" k="39" en="New"/>
    <zv:c l="1229" k="4" en="No action"/>
    <zv:c l="1229" k="40" en="Agreed"/>
    <zv:c l="1229" k="41" en="Proposed"/>
    <zv:c l="1229" k="42" en="Already delivered"/>
    <zv:c l="1229" k="43" en="Additional subordinate structures will follow"/>
    <zv:c l="1229" k="44" en="Additional subordinate structures will not follow"/>
    <zv:c l="1229" k="45" en="Result opposed"/>
    <zv:c l="1229" k="46" en="Auction held"/>
    <zv:c l="1229" k="47" en="Legal action pursued"/>
    <zv:c l="1229" k="48" en="Meeting held"/>
    <zv:c l="1229" k="49" en="Result set aside"/>
    <zv:c l="1229" k="5" en="Accepted without amendment"/>
    <zv:c l="1229" k="50" en="Result disputed"/>
    <zv:c l="1229" k="51" en="Countersued"/>
    <zv:c l="1229" k="52" en="Pending"/>
    <zv:c l="1229" k="53" en="Court action dismissed"/>
    <zv:c l="1229" k="54" en="Referred item, accepted"/>
    <zv:c l="1229" k="55" en="Referred item, rejected"/>
    <zv:c l="1229" k="56" en="Debit advice statement line"/>
    <zv:c l="1229" k="57" en="Credit advice statement line"/>
    <zv:c l="1229" k="58" en="Grouped credit advices"/>
    <zv:c l="1229" k="59" en="Grouped debit advices"/>
    <zv:c l="1229" k="6" en="Accepted with amendment"/>
    <zv:c l="1229" k="60" en="Registered"/>
    <zv:c l="1229" k="61" en="Payment denied"/>
    <zv:c l="1229" k="62" en="Approved as amended"/>
    <zv:c l="1229" k="63" en="Approved as submitted"/>
    <zv:c l="1229" k="64" en="Cancelled, no activity"/>
    <zv:c l="1229" k="65" en="Under investigation"/>
    <zv:c l="1229" k="66" en="Initial claim received"/>
    <zv:c l="1229" k="67" en="Not in process"/>
    <zv:c l="1229" k="68" en="Rejected, duplicate"/>
    <zv:c l="1229" k="69" en="Rejected, resubmit with corrections"/>
    <zv:c l="1229" k="7" en="Not accepted"/>
    <zv:c l="1229" k="70" en="Pending, incomplete"/>
    <zv:c l="1229" k="71" en="Under field office investigation"/>
    <zv:c l="1229" k="72" en="Pending, awaiting additional material"/>
    <zv:c l="1229" k="73" en="Pending, awaiting review"/>
    <zv:c l="1229" k="74" en="Reopened"/>
    <zv:c l="1229" k="75" en="Processed by primary, forwarded to additional payer(s)"/>
    <zv:c l="1229" k="76" en="Processed by secondary, forwarded to additional payer(s)"/>
    <zv:c l="1229" k="77" en="Processed by tertiary, forwarded to additional payer(s)"/>
    <zv:c l="1229" k="78" en="Previous payment decision reversed"/>
    <zv:c l="1229" k="79" en="Not our claim, forwarded to another payer(s)"/>
    <zv:c l="1229" k="8" en="Schedule only"/>
    <zv:c l="1229" k="80" en="Transferred to correct insurance carrier"/>
    <zv:c l="1229" k="81" en="Not paid, predetermination pricing only"/>
    <zv:c l="1229" k="82" en="Documentation claim"/>
    <zv:c l="1229" k="83" en="Reviewed"/>
    <zv:c l="1229" k="84" en="Repriced"/>
    <zv:c l="1229" k="85" en="Audited"/>
    <zv:c l="1229" k="86" en="Conditionally paid"/>
    <zv:c l="1229" k="87" en="On appeal"/>
    <zv:c l="1229" k="88" en="Closed"/>
    <zv:c l="1229" k="89" en="Reaudited"/>
    <zv:c l="1229" k="9" en="Amendments"/>
    <zv:c l="1229" k="90" en="Reissued"/>
    <zv:c l="1229" k="91" en="Closed after reopening"/>
    <zv:c l="1229" k="92" en="Redetermined"/>
    <zv:c l="1229" k="93" en="Processed as primary"/>
    <zv:c l="1229" k="94" en="Processed as secondary"/>
    <zv:c l="1229" k="95" en="Processed as tertiary"/>
    <zv:c l="1229" k="96" en="Correction of error"/>
    <zv:c l="1229" k="97" en="Single credit item of a group"/>
    <zv:c l="1229" k="98" en="Single debit item of a group"/>
    <zv:c l="1229" k="99" en="Interim response"/>
    <zv:c l="2005" k="3" de="Rechnungsdatum" en="Invoice document issue date time" fr="Date d'émission de la facture"/>
    <zv:c l="2005" k="35" de="Liefer-/Leistungsdatum" en="Delivery date/time, actual" fr="Date de livraison effective"/>
    <zv:c l="2005" k="432" de="Zahlungsdatum" en="Paid to date" fr="Date de paiement"/>
    <zv:c l="2475" k="29" de="Lieferdatum" en="Date of delivery of goods to establishments/domicile/site" fr="Date de livraison"/>
    <zv:c l="2475" k="5" de="Rechnungsdatum" en="Date of invoice" fr="Date de facture"/>
    <zv:c l="2475" k="72" de="Zahlungsdatum" en="Payment date" fr="Date de paiement"/>
    <zv:c l="3035" k="AB" de="Käufer-Bank" en="Buyer's financial institution" fr="Banque de l'acheteur"/>
    <zv:c l="3035" k="DL" de="Faktor" en="Factor" fr="Factor"/>
    <zv:c l="3035" k="SR" de="Verkäufer-Bank" en="Seller's financial institution" fr="Banque du vendeur"/>
    <zv:c l="3035" k="WD" de="Lager" en="Warehouse depot" fr="Entrepôt"/>
    <zv:c l="3139" k="AA" de="Versicherungskontakt" en="Insurance contact" fr="Contact assurance"/>
    <zv:c l="3139" k="AB" de="Abteilung/Person für Gefahrgutinformationen" en="Dangerous goods contact" fr="Contact marchandises dangereuses"/>
    <zv:c l="3139" k="AD" de="Buchhaltung" en="Accounting contact" fr="Comptabilité"/>
    <zv:c l="3139" k="BJ" de="Abteilung oder Mitarbeiter" en="Department or employee" fr="Service ou employé"/>
    <zv:c l="3139" k="CR" de="Kundenbetreuung" en="Customer relations" fr="Service clientèle"/>
    <zv:c l="3139" k="IC" de="Informationskontakt" en="Information contact" fr="Contact information"/>
    <zv:c l="3139" k="PD" de="Einkauf" en="Purchasing contact" fr="Achats"/>
    <zv:c l="3139" k="SD" de="Versand" en="Shipping contact" fr="Expédition"/>
    <zv:c l="3139" k="SR" de="Vertriebsmitarbeiter" en="Sales representative" fr="Représentant commercial"/>
    <zv:c l="4451" k="AAA" de="Warenbeschreibung" en="Goods item description" fr="Description des marchandises"/>
    <zv:c l="4451" k="AAB" de="Zahlungsbedingungen" en="Payment term" fr="Conditions de paiement"/>
    <zv:c l="4451" k="AAC" en="Dangerous goods additional information"/>
    <zv:c l="4451" k="AAD" en="Dangerous goods technical name"/>
    <zv:c l="4451" k="AAE" en="Acknowledgement description"/>
    <zv:c l="4451" k="AAF" en="Rate additional information"/>
    <zv:c l="4451" k="AAG" en="Party instructions"/>
    <zv:c l="4451" k="AAI" de="Allgemeine Informationen" en="General information" fr="Informations générales"/>
    <zv:c l="4451" k="AAJ" en="Additional conditions of sale/purchase"/>
    <zv:c l="4451" k="AAK" de="Preiskonditionen" en="Price conditions" fr="Conditions de prix"/>
    <zv:c l="4451" k="AAL" en="Goods dimensions in characters"/>
    <zv:c l="4451" k="AAM" en="Equipment re-usage restrictions"/>
    <zv:c l="4451" k="AAN" en="Handling restriction"/>
    <zv:c l="4451" k="AAO" en="Error description (free text)"/>
    <zv:c l="4451" k="AAP" en="Response (free text)"/>
    <zv:c l="4451" k="AAQ" en="Package content's description"/>
    <zv:c l="4451" k="AAR" en="Terms of delivery"/>
    <zv:c l="4451" k="AAS" en="Bill of lading remarks"/>
    <zv:c l="4451" k="AAT" en="Mode of settlement information"/>
    <zv:c l="4451" k="AAU" en="Consignment invoice information"/>
    <zv:c l="4451" k="AAV" en="Clearance invoice information"/>
    <zv:c l="4451" k="AAW" en="Letter of credit information"/>
    <zv:c l="4451" k="AAX" en="License information"/>
    <zv:c l="4451" k="AAY" en="Certification statements"/>
    <zv:c l="4451" k="AAZ" en="Additional export information"/>
    <zv:c l="4451" k="ABA" en="Tariff statements"/>
    <zv:c l="4451" k="ABB" en="Medical history"/>
    <zv:c l="4451" k="ABC" en="Conditions of sale or purchase"/>
    <zv:c l="4451" k="ABD" en="Contract document type"/>
    <zv:c l="4451" k="ABE" en="Additional terms and/or conditions (documentary credit)"/>
    <zv:c l="4451" k="ABF" en="Instructions or information about standby documentary"/>
    <zv:c l="4451" k="ABG" en="Instructions or information about partial shipment(s)"/>
    <zv:c l="4451" k="ABH" en="Instructions or information about transhipment(s)"/>
    <zv:c l="4451" k="ABI" en="Additional handling instructions documentary credit"/>
    <zv:c l="4451" k="ABJ" en="Domestic routing information"/>
    <zv:c l="4451" k="ABK" en="Chargeable category of equipment"/>
    <zv:c l="4451" k="ABL" de="Rechtliche Hinweise" en="Government information" fr="Informations réglementaires"/>
    <zv:c l="4451" k="ABM" en="Onward routing information"/>
    <zv:c l="4451" k="ABN" de="Buchhaltungshinweise" en="Accounting information" fr="Informations comptables"/>
    <zv:c l="4451" k="ABO" en="Discrepancy information"/>
    <zv:c l="4451" k="ABP" en="Confirmation instructions"/>
    <zv:c l="4451" k="ABQ" en="Method of issuance"/>
    <zv:c l="4451" k="ABR" en="Documents delivery instructions"/>
    <zv:c l="4451" k="ABS" en="Additional conditions"/>
    <zv:c l="4451" k="ABT" en="Information/instructions about additional amounts covered"/>
    <zv:c l="4451" k="ABU" en="Deferred payment termed additional"/>
    <zv:c l="4451" k="ABV" en="Acceptance terms additional"/>
    <zv:c l="4451" k="ABW" en="Negotiation terms additional"/>
    <zv:c l="4451" k="ABX" en="Document name and documentary requirements"/>
    <zv:c l="4451" k="ABZ" en="Instructions/information about revolving documentary credit"/>
    <zv:c l="4451" k="ACA" en="Documentary requirements"/>
    <zv:c l="4451" k="ACB" de="Zusätzliche Informationen" en="Additional information" fr="Informations complémentaires"/>
    <zv:c l="4451" k="ACC" en="Factor assignment clause"/>
    <zv:c l="4451" k="ACD" en="Reason"/>
    <zv:c l="4451" k="ACE" en="Dispute"/>
    <zv:c l="4451" k="ACF" en="Additional attribute information"/>
    <zv:c l="4451" k="ACG" en="Absence declaration"/>
    <zv:c l="4451" k="ACH" en="Aggregation statement"/>
    <zv:c l="4451" k="ACI" en="Compilation statement"/>
    <zv:c l="4451" k="ACJ" en="Definitional exception"/>
    <zv:c l="4451" k="ACK" en="Privacy statement"/>
    <zv:c l="4451" k="ACL" en="Quality statement"/>
    <zv:c l="4451" k="ACM" en="Statistical description"/>
    <zv:c l="4451" k="ACN" en="Statistical definition"/>
    <zv:c l="4451" k="ACO" en="Statistical name"/>
    <zv:c l="4451" k="ACP" en="Statistical title"/>
    <zv:c l="4451" k="ACQ" en="Off-dimension information"/>
    <zv:c l="4451" k="ACR" en="Unexpected stops information"/>
    <zv:c l="4451" k="ACS" en="Principles"/>
    <zv:c l="4451" k="ACT" en="Terms and definition"/>
    <zv:c l="4451" k="ACU" en="Segment name"/>
    <zv:c l="4451" k="ACV" en="Simple data element name"/>
    <zv:c l="4451" k="ACW" en="Scope"/>
    <zv:c l="4451" k="ACX" en="Message type name"/>
    <zv:c l="4451" k="ACY" en="Introduction"/>
    <zv:c l="4451" k="ACZ" en="Glossary"/>
    <zv:c l="4451" k="ADA" en="Functional definition"/>
    <zv:c l="4451" k="ADB" en="Examples"/>
    <zv:c l="4451" k="ADC" en="Cover page"/>
    <zv:c l="4451" k="ADD" en="Dependency (syntax) notes"/>
    <zv:c l="4451" k="ADE" en="Code value name"/>
    <zv:c l="4451" k="ADF" en="Code list name"/>
    <zv:c l="4451" k="ADG" en="Clarification of usage"/>
    <zv:c l="4451" k="ADH" en="Composite data element name"/>
    <zv:c l="4451" k="ADI" en="Field of application"/>
    <zv:c l="4451" k="ADJ" en="Type of assets and liabilities"/>
    <zv:c l="4451" k="ADK" en="Promotion information"/>
    <zv:c l="4451" k="ADL" en="Meter condition"/>
    <zv:c l="4451" k="ADM" en="Meter reading information"/>
    <zv:c l="4451" k="ADN" en="Type of transaction reason"/>
    <zv:c l="4451" k="ADO" en="Type of survey question"/>
    <zv:c l="4451" k="ADP" en="Carrier's agent counter information"/>
    <zv:c l="4451" k="ADQ" en="Description of work item on equipment"/>
    <zv:c l="4451" k="ADR" en="Message definition"/>
    <zv:c l="4451" k="ADS" en="Booked item information"/>
    <zv:c l="4451" k="ADT" en="Source of document"/>
    <zv:c l="4451" k="ADU" de="Hinweis" en="Note" fr="Note"/>
    <zv:c l="4451" k="ADV" en="Fixed part of segment clarification text"/>
    <zv:c l="4451" k="ADW" en="Characteristics of goods"/>
    <zv:c l="4451" k="ADX" en="Additional discharge instructions"/>
    <zv:c l="4451" k="ADY" en="Container stripping instructions"/>
    <zv:c l="4451" k="ADZ" en="CSC (Container Safety Convention) plate information"/>
    <zv:c l="4451" k="AEA" en="Cargo remarks"/>
    <zv:c l="4451" k="AEB" en="Temperature control instructions"/>
    <zv:c l="4451" k="AEC" en="Text refers to expected data"/>
    <zv:c l="4451" k="AED" en="Text refers to received data"/>
    <zv:c l="4451" k="AEE" en="Section clarification text"/>
    <zv:c l="4451" k="AEF" en="Information to the beneficiary"/>
    <zv:c l="4451" k="AEG" en="Information to the applicant"/>
    <zv:c l="4451" k="AEH" en="Instructions to the beneficiary"/>
    <zv:c l="4451" k="AEI" en="Instructions to the applicant"/>
    <zv:c l="4451" k="AEJ" en="Controlled atmosphere"/>
    <zv:c l="4451" k="AEK" en="Take off annotation"/>
    <zv:c l="4451" k="AEL" en="Price variation narrative"/>
    <zv:c l="4451" k="AEM" en="Documentary credit amendment instructions"/>
    <zv:c l="4451" k="AEN" en="Standard method narrative"/>
    <zv:c l="4451" k="AEO" en="Project narrative"/>
    <zv:c l="4451" k="AEP" en="Radioactive goods, additional information"/>
    <zv:c l="4451" k="AEQ" en="Bank-to-bank information"/>
    <zv:c l="4451" k="AER" en="Reimbursement instructions"/>
    <zv:c l="4451" k="AES" en="Reason for amending a message"/>
    <zv:c l="4451" k="AET" en="Instructions to the paying and/or accepting and/or"/>
    <zv:c l="4451" k="AEU" en="Interest instructions"/>
    <zv:c l="4451" k="AEV" en="Agent commission"/>
    <zv:c l="4451" k="AEW" en="Remitting bank instructions"/>
    <zv:c l="4451" k="AEX" en="Instructions to the collecting bank"/>
    <zv:c l="4451" k="AEY" en="Collection amount instructions"/>
    <zv:c l="4451" k="AEZ" en="Internal auditing information"/>
    <zv:c l="4451" k="AFA" en="Constraint"/>
    <zv:c l="4451" k="AFB" en="Comment"/>
    <zv:c l="4451" k="AFC" en="Semantic note"/>
    <zv:c l="4451" k="AFD" en="Help text"/>
    <zv:c l="4451" k="AFE" en="Legend"/>
    <zv:c l="4451" k="AFF" en="Batch code structure"/>
    <zv:c l="4451" k="AFG" en="Product application"/>
    <zv:c l="4451" k="AFH" en="Customer complaint"/>
    <zv:c l="4451" k="AFI" en="Probable cause of fault"/>
    <zv:c l="4451" k="AFJ" en="Defect description"/>
    <zv:c l="4451" k="AFK" en="Repair description"/>
    <zv:c l="4451" k="AFL" en="Review comments"/>
    <zv:c l="4451" k="AFM" de="Erläuterungen" en="Title" fr="Explications"/>
    <zv:c l="4451" k="AFN" en="Description of amount"/>
    <zv:c l="4451" k="AFO" en="Responsibilities"/>
    <zv:c l="4451" k="AFP" en="Supplier"/>
    <zv:c l="4451" k="AFQ" en="Purchase region"/>
    <zv:c l="4451" k="AFR" en="Affiliation"/>
    <zv:c l="4451" k="AFS" en="Borrower"/>
    <zv:c l="4451" k="AFT" en="Line of business"/>
    <zv:c l="4451" k="AFU" en="Financial institution"/>
    <zv:c l="4451" k="AFV" en="Business founder"/>
    <zv:c l="4451" k="AFW" en="Business history"/>
    <zv:c l="4451" k="AFX" en="Banking arrangements"/>
    <zv:c l="4451" k="AFY" en="Business origin"/>
    <zv:c l="4451" k="AFZ" en="Brand names' description"/>
    <zv:c l="4451" k="AGA" en="Business financing details"/>
    <zv:c l="4451" k="AGB" en="Competition"/>
    <zv:c l="4451" k="AGC" en="Construction process details"/>
    <zv:c l="4451" k="AGD" en="Construction specialty"/>
    <zv:c l="4451" k="AGE" en="Contract information"/>
    <zv:c l="4451" k="AGF" en="Corporate filing"/>
    <zv:c l="4451" k="AGG" en="Customer information"/>
    <zv:c l="4451" k="AGH" en="Copyright notice"/>
    <zv:c l="4451" k="AGI" en="Contingent debt"/>
    <zv:c l="4451" k="AGJ" en="Conviction details"/>
    <zv:c l="4451" k="AGK" en="Equipment"/>
    <zv:c l="4451" k="AGL" en="Workforce description"/>
    <zv:c l="4451" k="AGM" de="Anmerkungen" en="Exemption" fr="Remarques"/>
    <zv:c l="4451" k="AGN" en="Future plans"/>
    <zv:c l="4451" k="AGO" en="Interviewee conversation information"/>
    <zv:c l="4451" k="AGP" en="Intangible asset"/>
    <zv:c l="4451" k="AGQ" en="Inventory"/>
    <zv:c l="4451" k="AGR" en="Investment"/>
    <zv:c l="4451" k="AGS" en="Intercompany relations information"/>
    <zv:c l="4451" k="AGT" en="Joint venture"/>
    <zv:c l="4451" k="AGU" en="Loan"/>
    <zv:c l="4451" k="AGV" en="Long term debt"/>
    <zv:c l="4451" k="AGW" en="Location"/>
    <zv:c l="4451" k="AGX" en="Current legal structure"/>
    <zv:c l="4451" k="AGY" en="Marital contract"/>
    <zv:c l="4451" k="AGZ" en="Marketing activities"/>
    <zv:c l="4451" k="AHA" en="Merger"/>
    <zv:c l="4451" k="AHB" en="Marketable securities"/>
    <zv:c l="4451" k="AHC" en="Business debt"/>
    <zv:c l="4451" k="AHD" en="Original legal structure"/>
    <zv:c l="4451" k="AHE" en="Employee sharing arrangements"/>
    <zv:c l="4451" k="AHF" en="Organization details"/>
    <zv:c l="4451" k="AHG" en="Public record details"/>
    <zv:c l="4451" k="AHH" en="Price range"/>
    <zv:c l="4451" k="AHI" en="Qualifications"/>
    <zv:c l="4451" k="AHJ" en="Registered activity"/>
    <zv:c l="4451" k="AHK" en="Criminal sentence"/>
    <zv:c l="4451" k="AHL" en="Sales method"/>
    <zv:c l="4451" k="AHM" en="Educational institution information"/>
    <zv:c l="4451" k="AHN" en="Status details"/>
    <zv:c l="4451" k="AHO" en="Sales"/>
    <zv:c l="4451" k="AHP" en="Spouse information"/>
    <zv:c l="4451" k="AHQ" en="Educational degree information"/>
    <zv:c l="4451" k="AHR" en="Shareholding information"/>
    <zv:c l="4451" k="AHS" en="Sales territory"/>
    <zv:c l="4451" k="AHT" en="Accountant's comments"/>
    <zv:c l="4451" k="AHU" en="Exemption law location"/>
    <zv:c l="4451" k="AHV" en="Share classifications"/>
    <zv:c l="4451" k="AHW" en="Forecast"/>
    <zv:c l="4451" k="AHX" en="Event location"/>
    <zv:c l="4451" k="AHY" en="Facility occupancy"/>
    <zv:c l="4451" k="AHZ" en="Import and export details"/>
    <zv:c l="4451" k="AIA" en="Additional facility information"/>
    <zv:c l="4451" k="AIB" en="Inventory value"/>
    <zv:c l="4451" k="AIC" en="Education"/>
    <zv:c l="4451" k="AID" en="Event"/>
    <zv:c l="4451" k="AIE" en="Agent"/>
    <zv:c l="4451" k="AIF" en="Domestically agreed financial statement details"/>
    <zv:c l="4451" k="AIG" en="Other current asset description"/>
    <zv:c l="4451" k="AIH" en="Other current liability description"/>
    <zv:c l="4451" k="AII" en="Former business activity"/>
    <zv:c l="4451" k="AIJ" en="Trade name use"/>
    <zv:c l="4451" k="AIK" en="Signing authority"/>
    <zv:c l="4451" k="AIL" en="Guarantee"/>
    <zv:c l="4451" k="AIM" en="Holding company operation"/>
    <zv:c l="4451" k="AIN" en="Consignment routing"/>
    <zv:c l="4451" k="AIO" en="Letter of protest"/>
    <zv:c l="4451" k="AIP" en="Question"/>
    <zv:c l="4451" k="AIQ" en="Party information"/>
    <zv:c l="4451" k="AIR" en="Area boundaries description"/>
    <zv:c l="4451" k="AIS" en="Advertisement information"/>
    <zv:c l="4451" k="AIT" en="Financial statement details"/>
    <zv:c l="4451" k="AIU" en="Access instructions"/>
    <zv:c l="4451" k="AIV" en="Liquidity"/>
    <zv:c l="4451" k="AIW" en="Credit line"/>
    <zv:c l="4451" k="AIX" en="Warranty terms"/>
    <zv:c l="4451" k="AIY" en="Division description"/>
    <zv:c l="4451" k="AIZ" en="Reporting instruction"/>
    <zv:c l="4451" k="AJA" en="Examination result"/>
    <zv:c l="4451" k="AJB" en="Laboratory result"/>
    <zv:c l="4451" k="ALC" en="Allowance/charge information"/>
    <zv:c l="4451" k="ALD" en="X-ray result"/>
    <zv:c l="4451" k="ALE" en="Pathology result"/>
    <zv:c l="4451" k="ALF" en="Intervention description"/>
    <zv:c l="4451" k="ALG" en="Summary of admittance"/>
    <zv:c l="4451" k="ALH" en="Medical treatment course detail"/>
    <zv:c l="4451" k="ALI" en="Prognosis"/>
    <zv:c l="4451" k="ALJ" en="Instruction to patient"/>
    <zv:c l="4451" k="ALK" en="Instruction to physician"/>
    <zv:c l="4451" k="ALL" en="All documents"/>
    <zv:c l="4451" k="ALM" en="Medicine treatment"/>
    <zv:c l="4451" k="ALN" en="Medicine dosage and administration"/>
    <zv:c l="4451" k="ALO" en="Availability of patient"/>
    <zv:c l="4451" k="ALP" en="Reason for service request"/>
    <zv:c l="4451" k="ALQ" en="Purpose of service"/>
    <zv:c l="4451" k="ARR" en="Arrival conditions"/>
    <zv:c l="4451" k="ARS" en="Service requester's comment"/>
    <zv:c l="4451" k="AUT" de="Echtheitsbescheinigung" en="Authentication" fr="Authentification"/>
    <zv:c l="4451" k="AUU" en="Requested location description"/>
    <zv:c l="4451" k="AUV" en="Medicine administration condition"/>
    <zv:c l="4451" k="AUW" en="Patient information"/>
    <zv:c l="4451" k="AUX" en="Precautionary measure"/>
    <zv:c l="4451" k="AUY" en="Service characteristic"/>
    <zv:c l="4451" k="AUZ" en="Planned event comment"/>
    <zv:c l="4451" k="AVA" en="Expected delay comment"/>
    <zv:c l="4451" k="AVB" en="Transport requirements comment"/>
    <zv:c l="4451" k="AVC" en="Temporary approval condition"/>
    <zv:c l="4451" k="AVD" en="Customs Valuation Information"/>
    <zv:c l="4451" k="AVE" en="Value Added Tax (VAT) margin scheme"/>
    <zv:c l="4451" k="AVF" en="Maritime Declaration of Health"/>
    <zv:c l="4451" k="BAG" en="Passenger baggage information"/>
    <zv:c l="4451" k="BAH" en="Maritime Declaration of Health"/>
    <zv:c l="4451" k="BAI" en="Additional product information address"/>
    <zv:c l="4451" k="BAJ" en="Information to be printed on despatch advice"/>
    <zv:c l="4451" k="BAK" en="Missing goods remarks"/>
    <zv:c l="4451" k="BAL" en="Non-acceptance information"/>
    <zv:c l="4451" k="BAM" en="Returns information"/>
    <zv:c l="4451" k="BAN" en="Sub-line item information"/>
    <zv:c l="4451" k="BAO" en="Test information"/>
    <zv:c l="4451" k="BAP" en="External link"/>
    <zv:c l="4451" k="BAQ" en="VAT exemption reason"/>
    <zv:c l="4451" k="BAR" en="Processing Instructions"/>
    <zv:c l="4451" k="BAS" en="Relay Instructions"/>
    <zv:c l="4451" k="BAT" en="SIMA applicable"/>
    <zv:c l="4451" k="BAU" en="Appeals program code"/>
    <zv:c l="4451" k="BAV" en="SIMA subject"/>
    <zv:c l="4451" k="BAW" en="Surtax applicable"/>
    <zv:c l="4451" k="BAX" en="SIMA security bond"/>
    <zv:c l="4451" k="BAY" en="Surtax subject"/>
    <zv:c l="4451" k="BAZ" en="Safeguard applicable"/>
    <zv:c l="4451" k="BBA" en="Safeguard applicable"/>
    <zv:c l="4451" k="BBB" en="Safeguard subject"/>
    <zv:c l="4451" k="BLC" en="Transport contract document clause"/>
    <zv:c l="4451" k="BLD" en="Instruction to prepare the patient"/>
    <zv:c l="4451" k="BLE" en="Medicine treatment comment"/>
    <zv:c l="4451" k="BLF" en="Examination result comment"/>
    <zv:c l="4451" k="BLG" en="Service request comment"/>
    <zv:c l="4451" k="BLH" en="Prescription reason"/>
    <zv:c l="4451" k="BLI" en="Prescription comment"/>
    <zv:c l="4451" k="BLJ" en="Clinical investigation comment"/>
    <zv:c l="4451" k="BLK" en="Medicinal specification comment"/>
    <zv:c l="4451" k="BLL" en="Economic contribution comment"/>
    <zv:c l="4451" k="BLM" en="Status of a plan"/>
    <zv:c l="4451" k="BLN" en="Random sample test information"/>
    <zv:c l="4451" k="BLO" en="Period of time"/>
    <zv:c l="4451" k="BLP" en="Legislation"/>
    <zv:c l="4451" k="BLQ" en="Security measures requested"/>
    <zv:c l="4451" k="BLR" en="Transport contract document remark"/>
    <zv:c l="4451" k="BLS" en="Previous port of call security information"/>
    <zv:c l="4451" k="BLT" en="Security information"/>
    <zv:c l="4451" k="BLU" en="Waste information"/>
    <zv:c l="4451" k="BLV" en="B2C marketing information, short description"/>
    <zv:c l="4451" k="BLW" en="B2B marketing information, long description"/>
    <zv:c l="4451" k="BLX" en="B2C marketing information, long description"/>
    <zv:c l="4451" k="BLY" en="Product ingredients"/>
    <zv:c l="4451" k="BLZ" en="Location short name"/>
    <zv:c l="4451" k="BMA" en="Packaging material information"/>
    <zv:c l="4451" k="BMB" en="Filler material information"/>
    <zv:c l="4451" k="BMC" en="Ship-to-ship activity information"/>
    <zv:c l="4451" k="BMD" en="Package material description"/>
    <zv:c l="4451" k="BME" en="Consumer level package marking"/>
    <zv:c l="4451" k="BMF" en="SIMA measure in force"/>
    <zv:c l="4451" k="BMG" en="Pre-CARM"/>
    <zv:c l="4451" k="BMH" en="SIMA measure type"/>
    <zv:c l="4451" k="CCI" en="Customs clearance instructions"/>
    <zv:c l="4451" k="CCJ" en="Sub Type Code"/>
    <zv:c l="4451" k="CCK" en="SIMA information"/>
    <zv:c l="4451" k="CCL" en="Time limit end"/>
    <zv:c l="4451" k="CCM" en="Time limit start"/>
    <zv:c l="4451" k="CCN" en="Warehouse time limit"/>
    <zv:c l="4451" k="CCO" en="Value for duty information"/>
    <zv:c l="4451" k="CEX" en="Customs clearance instructions export"/>
    <zv:c l="4451" k="CHG" en="Change information"/>
    <zv:c l="4451" k="CIP" en="Customs clearance instruction import"/>
    <zv:c l="4451" k="CLP" en="Clearance place requested"/>
    <zv:c l="4451" k="CLR" en="Loading remarks"/>
    <zv:c l="4451" k="COI" en="Order information"/>
    <zv:c l="4451" k="CUR" en="Customer remarks"/>
    <zv:c l="4451" k="CUS" de="Zollhinweise" en="Customs declaration information" fr="Informations douanières"/>
    <zv:c l="4451" k="DAR" en="Damage remarks"/>
    <zv:c l="4451" k="DCL" en="Document issuer declaration"/>
    <zv:c l="4451" k="DEL" de="Lieferhinweise" en="Delivery information" fr="Informations de livraison"/>
    <zv:c l="4451" k="DIN" en="Delivery instructions"/>
    <zv:c l="4451" k="DOC" en="Documentation instructions"/>
    <zv:c l="4451" k="DUT" en="Duty declaration"/>
    <zv:c l="4451" k="EUR" en="Effective used routing"/>
    <zv:c l="4451" k="FBC" en="First block to be printed on the transport contract"/>
    <zv:c l="4451" k="GBL" en="Government bill of lading information"/>
    <zv:c l="4451" k="GEN" en="Entire transaction set"/>
    <zv:c l="4451" k="GS7" en="Further information concerning GGVS par. 7"/>
    <zv:c l="4451" k="HAN" en="Consignment handling instruction"/>
    <zv:c l="4451" k="HAZ" en="Hazard information"/>
    <zv:c l="4451" k="ICN" en="Consignment information for consignee"/>
    <zv:c l="4451" k="IIN" en="Insurance instructions"/>
    <zv:c l="4451" k="IMI" en="Invoice mailing instructions"/>
    <zv:c l="4451" k="IND" en="Commercial invoice item description"/>
    <zv:c l="4451" k="INS" en="Insurance information"/>
    <zv:c l="4451" k="INV" de="Rechnungshinweise" en="Invoice instruction" fr="Instructions de facturation"/>
    <zv:c l="4451" k="IRP" en="Information for railway purpose"/>
    <zv:c l="4451" k="ITR" en="Inland transport details"/>
    <zv:c l="4451" k="ITS" en="Testing instructions"/>
    <zv:c l="4451" k="LAN" en="Location Alias"/>
    <zv:c l="4451" k="LIN" en="Line item"/>
    <zv:c l="4451" k="LOI" en="Loading instruction"/>
    <zv:c l="4451" k="MCO" en="Miscellaneous charge order"/>
    <zv:c l="4451" k="MDH" en="Maritime Declaration of Health"/>
    <zv:c l="4451" k="MKS" en="Additional marks/numbers information"/>
    <zv:c l="4451" k="ORI" en="Order instruction"/>
    <zv:c l="4451" k="OSI" en="Other service information"/>
    <zv:c l="4451" k="PAC" en="Packing/marking information"/>
    <zv:c l="4451" k="PAI" de="Zahlungshinweise" en="Payment instructions information" fr="Instructions de paiement"/>
    <zv:c l="4451" k="PAY" en="Payables information"/>
    <zv:c l="4451" k="PKG" en="Packaging information"/>
    <zv:c l="4451" k="PKT" en="Packaging terms information"/>
    <zv:c l="4451" k="PMD" de="Zahlungsbezogene Hinweise" en="Payment detail/remittance information" fr="Détail de paiement"/>
    <zv:c l="4451" k="PMT" de="Zahlungsinformationen" en="Payment information" fr="Informations de paiement"/>
    <zv:c l="4451" k="PRD" en="Product information"/>
    <zv:c l="4451" k="PRF" de="Hinweise zu Preisberechnung" en="Price calculation formula" fr="Formule de prix"/>
    <zv:c l="4451" k="PRI" en="Priority information"/>
    <zv:c l="4451" k="PUR" en="Purchasing information"/>
    <zv:c l="4451" k="QIN" en="Quarantine instructions"/>
    <zv:c l="4451" k="QQD" en="Quality demands/requirements"/>
    <zv:c l="4451" k="QUT" en="Quotation instruction/information"/>
    <zv:c l="4451" k="RAH" en="Risk and handling information"/>
    <zv:c l="4451" k="REG" de="Registerangaben" en="Regulatory information" fr="Informations réglementaires (registre)"/>
    <zv:c l="4451" k="RET" en="Return to origin information"/>
    <zv:c l="4451" k="REV" en="Receivables"/>
    <zv:c l="4451" k="RQR" en="Consignment route"/>
    <zv:c l="4451" k="SAF" en="Safety information"/>
    <zv:c l="4451" k="SIC" en="Consignment documentary instruction"/>
    <zv:c l="4451" k="SIN" en="Special instructions"/>
    <zv:c l="4451" k="SLR" en="Ship line requested"/>
    <zv:c l="4451" k="SPA" en="Special permission for transport, generally"/>
    <zv:c l="4451" k="SPG" en="Special permission concerning the goods to be transported"/>
    <zv:c l="4451" k="SPH" en="Special handling"/>
    <zv:c l="4451" k="SPP" en="Special permission concerning package"/>
    <zv:c l="4451" k="SPT" en="Special permission concerning transport means"/>
    <zv:c l="4451" k="SRN" en="Subsidiary risk number (IATA/DGR)"/>
    <zv:c l="4451" k="SSR" en="Special service request"/>
    <zv:c l="4451" k="SUR" de="Lieferantenhinweise" en="Supplier remarks" fr="Remarques du fournisseur"/>
    <zv:c l="4451" k="TCA" en="Consignment tariff"/>
    <zv:c l="4451" k="TDT" en="Consignment transport"/>
    <zv:c l="4451" k="TRA" en="Transportation information"/>
    <zv:c l="4451" k="TRR" en="Requested tariff"/>
    <zv:c l="4451" k="TXD" de="Steuerhinweise" en="Tax declaration" fr="Informations fiscales"/>
    <zv:c l="4451" k="WHI" en="Warehouse instruction/information"/>
    <zv:c l="4451" k="ZZZ" de="Gegenseitig vereinbart" en="Mutually defined" fr="Défini d'un commun accord"/>
    <zv:c l="4461" k="1" de="Nicht definiert" en="Instrument not defined" fr="Instrument non défini"/>
    <zv:c l="4461" k="10" de="Barzahlung" en="In cash" fr="Espèces"/>
    <zv:c l="4461" k="11" en="ACH savings credit reversal"/>
    <zv:c l="4461" k="12" en="ACH savings debit reversal"/>
    <zv:c l="4461" k="13" en="ACH savings credit"/>
    <zv:c l="4461" k="14" en="ACH savings debit"/>
    <zv:c l="4461" k="15" en="Bookentry credit"/>
    <zv:c l="4461" k="16" en="Bookentry debit"/>
    <zv:c l="4461" k="17" en="ACH demand cash concentration/disbursement (CCD) credit"/>
    <zv:c l="4461" k="18" en="ACH demand cash concentration/disbursement (CCD) debit"/>
    <zv:c l="4461" k="19" en="ACH demand corporate trade payment (CTP) credit"/>
    <zv:c l="4461" k="2" en="Automated clearing house credit"/>
    <zv:c l="4461" k="20" de="Scheck" en="Cheque" fr="Chèque"/>
    <zv:c l="4461" k="21" en="Banker's draft"/>
    <zv:c l="4461" k="22" en="Certified banker's draft"/>
    <zv:c l="4461" k="23" en="Bank cheque (issued by a banking or similar establishment)"/>
    <zv:c l="4461" k="24" en="Bill of exchange awaiting acceptance"/>
    <zv:c l="4461" k="25" en="Certified cheque"/>
    <zv:c l="4461" k="26" en="Local cheque"/>
    <zv:c l="4461" k="27" en="ACH demand corporate trade payment (CTP) debit"/>
    <zv:c l="4461" k="28" en="ACH demand corporate trade exchange (CTX) credit"/>
    <zv:c l="4461" k="29" en="ACH demand corporate trade exchange (CTX) debit"/>
    <zv:c l="4461" k="3" en="Automated clearing house debit"/>
    <zv:c l="4461" k="30" de="Überweisung" en="Credit transfer" fr="Virement"/>
    <zv:c l="4461" k="31" de="Lastschrift (nicht SEPA)" en="Debit transfer" fr="Débit"/>
    <zv:c l="4461" k="32" en="ACH demand cash concentration/disbursement plus (CCD+)"/>
    <zv:c l="4461" k="33" en="ACH demand cash concentration/disbursement plus (CCD+)"/>
    <zv:c l="4461" k="34" en="ACH prearranged payment and deposit (PPD)"/>
    <zv:c l="4461" k="35" en="ACH savings cash concentration/disbursement (CCD) credit"/>
    <zv:c l="4461" k="36" en="ACH savings cash concentration/disbursement (CCD) debit"/>
    <zv:c l="4461" k="37" en="ACH savings corporate trade payment (CTP) credit"/>
    <zv:c l="4461" k="38" en="ACH savings corporate trade payment (CTP) debit"/>
    <zv:c l="4461" k="39" en="ACH savings corporate trade exchange (CTX) credit"/>
    <zv:c l="4461" k="4" en="ACH demand debit reversal"/>
    <zv:c l="4461" k="40" en="ACH savings corporate trade exchange (CTX) debit"/>
    <zv:c l="4461" k="41" en="ACH savings cash concentration/disbursement plus (CCD+)"/>
    <zv:c l="4461" k="42" de="Zahlung auf Bankkonto" en="Payment to bank account" fr="Paiement sur compte bancaire"/>
    <zv:c l="4461" k="43" en="ACH savings cash concentration/disbursement plus (CCD+)"/>
    <zv:c l="4461" k="44" en="Accepted bill of exchange"/>
    <zv:c l="4461" k="45" en="Referenced home-banking credit transfer"/>
    <zv:c l="4461" k="46" en="Interbank debit transfer"/>
    <zv:c l="4461" k="47" en="Home-banking debit transfer"/>
    <zv:c l="4461" k="48" de="Bankkarte" en="Bank card" fr="Carte bancaire"/>
    <zv:c l="4461" k="49" de="Lastschrift" en="Direct debit" fr="Prélèvement"/>
    <zv:c l="4461" k="5" en="ACH demand credit reversal"/>
    <zv:c l="4461" k="50" en="Payment by postgiro"/>
    <zv:c l="4461" k="51" en="FR, norme 6 97-Telereglement CFONB (French Organisation for"/>
    <zv:c l="4461" k="52" en="Urgent commercial payment"/>
    <zv:c l="4461" k="53" en="Urgent Treasury Payment"/>
    <zv:c l="4461" k="54" de="Kreditkarte" en="Credit card" fr="Carte de crédit"/>
    <zv:c l="4461" k="55" de="Debitkarte" en="Debit card" fr="Carte de débit"/>
    <zv:c l="4461" k="56" en="Bankgiro"/>
    <zv:c l="4461" k="57" de="Dauerauftrag" en="Standing agreement" fr="Accord permanent"/>
    <zv:c l="4461" k="58" de="SEPA-Überweisung" en="SEPA credit transfer" fr="Virement SEPA"/>
    <zv:c l="4461" k="59" de="SEPA-Lastschrift" en="SEPA direct debit" fr="Prélèvement SEPA"/>
    <zv:c l="4461" k="6" en="ACH demand credit"/>
    <zv:c l="4461" k="60" en="Promissory note"/>
    <zv:c l="4461" k="61" en="Promissory note signed by the debtor"/>
    <zv:c l="4461" k="62" en="Promissory note signed by the debtor and endorsed by a bank"/>
    <zv:c l="4461" k="63" en="Promissory note signed by the debtor and endorsed by a"/>
    <zv:c l="4461" k="64" en="Promissory note signed by a bank"/>
    <zv:c l="4461" k="65" en="Promissory note signed by a bank and endorsed by another"/>
    <zv:c l="4461" k="66" en="Promissory note signed by a third party"/>
    <zv:c l="4461" k="67" en="Promissory note signed by a third party and endorsed by a"/>
    <zv:c l="4461" k="68" de="Online-Zahlungsdienst" en="Online payment service" fr="Service de paiement en ligne"/>
    <zv:c l="4461" k="69" en="Transfer Advice"/>
    <zv:c l="4461" k="7" en="ACH demand debit"/>
    <zv:c l="4461" k="70" en="Bill drawn by the creditor on the debtor"/>
    <zv:c l="4461" k="74" en="Bill drawn by the creditor on a bank"/>
    <zv:c l="4461" k="75" en="Bill drawn by the creditor, endorsed by another bank"/>
    <zv:c l="4461" k="76" en="Bill drawn by the creditor on a bank and endorsed by a"/>
    <zv:c l="4461" k="77" en="Bill drawn by the creditor on a third party"/>
    <zv:c l="4461" k="78" en="Bill drawn by creditor on third party, accepted and"/>
    <zv:c l="4461" k="8" en="Hold"/>
    <zv:c l="4461" k="9" en="National or regional clearing"/>
    <zv:c l="4461" k="91" en="Not transferable banker's draft"/>
    <zv:c l="4461" k="92" en="Not transferable local cheque"/>
    <zv:c l="4461" k="93" en="Reference giro"/>
    <zv:c l="4461" k="94" en="Urgent giro"/>
    <zv:c l="4461" k="95" en="Free format giro"/>
    <zv:c l="4461" k="96" en="Requested method for payment was not used"/>
    <zv:c l="4461" k="97" de="Verrechnung zwischen Partnern" en="Clearing between partners" fr="Compensation entre partenaires"/>
    <zv:c l="4461" k="98" en="JP, Electronically Recorded Monetary Claims"/>
    <zv:c l="4461" k="ZZZ" de="Gegenseitig vereinbart" en="Mutually defined" fr="Défini d'un commun accord"/>
    <zv:c l="5153" k="VAT" de="Umsatzsteuer" en="Value added tax" fr="Taxe sur la valeur ajoutée"/>
    <zv:c l="5189" k="100" de="Sonderrabatt" en="Special rebate" fr="Rabais spécial"/>
    <zv:c l="5189" k="102" de="Langfristig fest" en="Fixed long term" fr="Fixe à long terme"/>
    <zv:c l="5189" k="103" de="Vorübergehend" en="Temporary" fr="Temporaire"/>
    <zv:c l="5189" k="104" de="Standard" en="Standard" fr="Standard"/>
    <zv:c l="5189" k="105" de="Jahresumsatzrabatt" en="Yearly turnover" fr="Remise sur chiffre d'affaires annuel"/>
    <zv:c l="5189" k="41" de="Bonus für vorzeitige Fertigstellung" en="Bonus for works ahead of schedule" fr="Prime pour travaux en avance"/>
    <zv:c l="5189" k="42" de="Sonstiger Bonus" en="Other bonus" fr="Autre prime"/>
    <zv:c l="5189" k="60" de="Herstellerrabatt für Verbraucher" en="Manufacturer's consumer discount" fr="Remise fabricant au consommateur"/>
    <zv:c l="5189" k="62" de="Rabatt wegen Militärstatus" en="Due to military status" fr="Remise statut militaire"/>
    <zv:c l="5189" k="63" de="Rabatt wegen Arbeitsunfall" en="Due to work accident" fr="Remise accident du travail"/>
    <zv:c l="5189" k="64" de="Sondervereinbarung" en="Special agreement" fr="Accord spécial"/>
    <zv:c l="5189" k="65" de="Rabatt wegen Produktionsfehler" en="Production error discount" fr="Remise pour défaut de production"/>
    <zv:c l="5189" k="66" de="Neueröffnungsrabatt" en="New outlet discount" fr="Remise nouveau point de vente"/>
    <zv:c l="5189" k="67" de="Musterrabatt" en="Sample discount" fr="Remise sur échantillon"/>
    <zv:c l="5189" k="68" de="Auslaufrabatt" en="End-of-range discount" fr="Remise fin de série"/>
    <zv:c l="5189" k="70" de="Incoterm-Rabatt" en="Incoterm discount" fr="Remise Incoterm"/>
    <zv:c l="5189" k="71" de="Mindestumsatzrabatt am Verkaufsort" en="Point of sales threshold allowance" fr="Remise seuil point de vente"/>
    <zv:c l="5189" k="88" de="Material-Zu-/Abschlag" en="Material surcharge/deduction" fr="Majoration/déduction matière"/>
    <zv:c l="5189" k="95" de="Rabatt" en="Discount" fr="Remise"/>
    <zv:c l="5305" k="AE" de="Umkehrung der Steuerschuldnerschaft (Reverse Charge)" en="VAT Reverse charge" fr="Autoliquidation"/>
    <zv:c l="5305" k="E" de="Steuerbefreit" en="Exempt from tax" fr="Exonéré de TVA"/>
    <zv:c l="5305" k="G" de="Steuerfreie Ausfuhr" en="Free export item, tax not charged" fr="Exportation hors UE exonérée"/>
    <zv:c l="5305" k="K" de="Innergemeinschaftliche Lieferung (steuerfrei)" en="VAT exempt for EEA intra-community supply of goods" fr="Livraison intracommunautaire exonérée"/>
    <zv:c l="5305" k="L" de="Kanarische Inseln (IGIC)" en="Canary Islands general indirect tax" fr="Impôt général indirect des îles Canaries"/>
    <zv:c l="5305" k="M" de="Ceuta und Melilla (IPSI)" en="Tax for production, services and importation in Ceuta and Melilla" fr="Taxe de production, services et importation (Ceuta et Melilla)"/>
    <zv:c l="5305" k="O" de="Nicht steuerbar" en="Service outside scope of tax" fr="Hors du champ d'application de la TVA"/>
    <zv:c l="5305" k="S" de="Normalsatz" en="Standard rate" fr="Taux normal"/>
    <zv:c l="5305" k="Z" de="Nullsatz" en="Zero rated goods" fr="Taux zéro"/>
    <zv:c l="6313" k="A" en="Consolidated weight"/>
    <zv:c l="6313" k="AAA" en="Net weight"/>
    <zv:c l="6313" k="AAB" en="Goods item gross weight"/>
    <zv:c l="6313" k="AAC" en="Total net weight"/>
    <zv:c l="6313" k="AAD" en="Consignment gross weight"/>
    <zv:c l="6313" k="AAF" en="Net net weight"/>
    <zv:c l="6313" k="AAG" en="Stern thrust"/>
    <zv:c l="6313" k="AAH" en="Bow thrust"/>
    <zv:c l="6313" k="AAI" en="Hydrate content of an alcoholic product at bottling"/>
    <zv:c l="6313" k="AAJ" en="Number of units per pallet"/>
    <zv:c l="6313" k="AAK" en="Fat content"/>
    <zv:c l="6313" k="AAM" en="Transport means gross weight"/>
    <zv:c l="6313" k="AAN" en="Net tonnage of the vessel"/>
    <zv:c l="6313" k="AAO" en="Humidity"/>
    <zv:c l="6313" k="AAP" en="Voltage"/>
    <zv:c l="6313" k="AAQ" en="Power consumption"/>
    <zv:c l="6313" k="AAR" en="Heat dissipation"/>
    <zv:c l="6313" k="AAS" en="Air flow"/>
    <zv:c l="6313" k="AAT" en="Shock impact"/>
    <zv:c l="6313" k="AAU" en="Operative temperature"/>
    <zv:c l="6313" k="AAV" en="Non operative temperature"/>
    <zv:c l="6313" k="AAW" en="Gross volume"/>
    <zv:c l="6313" k="AAX" en="Net volume"/>
    <zv:c l="6313" k="AAY" en="Water content"/>
    <zv:c l="6313" k="AAZ" en="Tensile stress"/>
    <zv:c l="6313" k="ABA" en="Fibrosity"/>
    <zv:c l="6313" k="ABB" en="Gauge length"/>
    <zv:c l="6313" k="ABC" en="Radius"/>
    <zv:c l="6313" k="ABD" en="Straightness"/>
    <zv:c l="6313" k="ABE" en="Strain"/>
    <zv:c l="6313" k="ABF" en="Item width when unrolled"/>
    <zv:c l="6313" k="ABG" en="Item length when unrolled"/>
    <zv:c l="6313" k="ABH" en="Item area when unrolled"/>
    <zv:c l="6313" k="ABI" en="Original wort"/>
    <zv:c l="6313" k="ABJ" en="Volume"/>
    <zv:c l="6313" k="ABK" en="Angle"/>
    <zv:c l="6313" k="ABL" en="Peg hole horizontal distance from package leftmost edge"/>
    <zv:c l="6313" k="ABM" en="Peg hole vertical distance from package top"/>
    <zv:c l="6313" k="ABN" en="Number of layers per pallet"/>
    <zv:c l="6313" k="ABO" en="Product strengh, chemical"/>
    <zv:c l="6313" k="ABP" en="Product strength basis, chemical"/>
    <zv:c l="6313" k="ABS" en="Item weight"/>
    <zv:c l="6313" k="ABT" en="Payload weight, maximum"/>
    <zv:c l="6313" k="ABX" en="Weight of conveyance"/>
    <zv:c l="6313" k="ABY" en="Conveyance summer dead weight"/>
    <zv:c l="6313" k="ABZ" en="Containerized cargo on vessel's weight"/>
    <zv:c l="6313" k="ACA" en="Non-containerized cargo on vessel's weight"/>
    <zv:c l="6313" k="ACE" en="Ascertained weight"/>
    <zv:c l="6313" k="ACG" en="Chargeable weight"/>
    <zv:c l="6313" k="ACN" en="Estimated gross weight"/>
    <zv:c l="6313" k="ACP" en="Estimated volume"/>
    <zv:c l="6313" k="ACS" en="Vessel overall length"/>
    <zv:c l="6313" k="ACV" en="Loading meters"/>
    <zv:c l="6313" k="ACW" en="Number of axles"/>
    <zv:c l="6313" k="ACX" en="Payload"/>
    <zv:c l="6313" k="ADR" en="Start position in the length"/>
    <zv:c l="6313" k="ADS" en="End position in the length"/>
    <zv:c l="6313" k="ADT" en="Start position in the width"/>
    <zv:c l="6313" k="ADU" en="End position in the width"/>
    <zv:c l="6313" k="ADV" en="Start position in the thickness"/>
    <zv:c l="6313" k="ADW" en="End position in the thickness"/>
    <zv:c l="6313" k="ADX" en="Transport container actual filling weight"/>
    <zv:c l="6313" k="ADY" en="Transport container maximum capacity"/>
    <zv:c l="6313" k="ADZ" en="Declared net weight"/>
    <zv:c l="6313" k="AEA" en="Loading height"/>
    <zv:c l="6313" k="AEB" en="Stacking height"/>
    <zv:c l="6313" k="AEC" en="Calculated weight"/>
    <zv:c l="6313" k="AED" en="Ferrite"/>
    <zv:c l="6313" k="AEE" en="Impurity"/>
    <zv:c l="6313" k="AEF" en="Grain size"/>
    <zv:c l="6313" k="AEG" en="Lanthanides"/>
    <zv:c l="6313" k="AEH" en="Elasticity"/>
    <zv:c l="6313" k="AEI" en="Drained weight"/>
    <zv:c l="6313" k="AEJ" en="Gallium"/>
    <zv:c l="6313" k="AEK" en="Strontium"/>
    <zv:c l="6313" k="AEL" en="Area"/>
    <zv:c l="6313" k="AEM" en="Equipment storage limitation"/>
    <zv:c l="6313" k="AEN" en="Radioactive index of transport"/>
    <zv:c l="6313" k="AEO" en="Radioactivity"/>
    <zv:c l="6313" k="AEP" en="Average gross weight"/>
    <zv:c l="6313" k="AEQ" en="Forward draft"/>
    <zv:c l="6313" k="AER" en="After draft"/>
    <zv:c l="6313" k="AES" en="Acidity"/>
    <zv:c l="6313" k="AET" en="Transport equipment gross weight"/>
    <zv:c l="6313" k="AEU" en="Total transport equipment gross weight"/>
    <zv:c l="6313" k="AEV" en="Acidity of juice"/>
    <zv:c l="6313" k="AEW" en="Penetrometry"/>
    <zv:c l="6313" k="AEX" en="Durofel"/>
    <zv:c l="6313" k="AEY" en="Juice weight per 100 grams"/>
    <zv:c l="6313" k="AEZ" en="Fruit skin colour"/>
    <zv:c l="6313" k="AF" en="Angle of bend"/>
    <zv:c l="6313" k="AFA" en="Fixed incremental measurement"/>
    <zv:c l="6313" k="AFB" en="Durofel D10"/>
    <zv:c l="6313" k="AFC" en="Durofel D25"/>
    <zv:c l="6313" k="AFD" en="Durofel D50"/>
    <zv:c l="6313" k="AFE" en="Maximum stacking weight"/>
    <zv:c l="6313" k="AFF" en="Gross measure cube"/>
    <zv:c l="6313" k="AFG" en="Percentage fat content in dry matter"/>
    <zv:c l="6313" k="AFH" en="Saccharometric content"/>
    <zv:c l="6313" k="AFI" en="Hydrate content of an alcoholic product after bottling"/>
    <zv:c l="6313" k="AFJ" en="Anhydrous content"/>
    <zv:c l="6313" k="AFK" en="Certified weight"/>
    <zv:c l="6313" k="AFL" en="Freeboard"/>
    <zv:c l="6313" k="AFM" en="Maximum vessel draught"/>
    <zv:c l="6313" k="AFN" en="Net explosive weight"/>
    <zv:c l="6313" k="AFO" en="Radioactive criticality safety index"/>
    <zv:c l="6313" k="AFP" en="Waste currently on board"/>
    <zv:c l="6313" k="AFQ" en="Waste to be delivered at waste reception facility"/>
    <zv:c l="6313" k="AFR" en="Waste to be generated until next port of call, estimated"/>
    <zv:c l="6313" k="AFS" en="Waste remaining on board at departure"/>
    <zv:c l="6313" k="AFT" en="Colour depth"/>
    <zv:c l="6313" k="AFU" en="Colour depth, maximum"/>
    <zv:c l="6313" k="AFV" en="Image resolution"/>
    <zv:c l="6313" k="AFW" en="Device resolution, maximum"/>
    <zv:c l="6313" k="AFX" en="Acoustic absorption coefficient"/>
    <zv:c l="6313" k="B" en="Billed weight"/>
    <zv:c l="6313" k="BEST_BEFORE_DATE" en="Best before date"/>
    <zv:c l="6313" k="BL" en="Breaking load"/>
    <zv:c l="6313" k="BMY" en="Platinum"/>
    <zv:c l="6313" k="BMZ" en="Silver"/>
    <zv:c l="6313" k="BNA" en="List"/>
    <zv:c l="6313" k="BNB" en="Trim"/>
    <zv:c l="6313" k="BNC" en="Free water"/>
    <zv:c l="6313" k="BND" en="Bands"/>
    <zv:c l="6313" k="BNE" en="API (American Petroleum Institute) gravity"/>
    <zv:c l="6313" k="BNF" en="Petroleum gross observed volume"/>
    <zv:c l="6313" k="BNG" en="Petroleum gross standard volume"/>
    <zv:c l="6313" k="BNH" en="Volume variance"/>
    <zv:c l="6313" k="BNI" en="Petroleum net standard volume"/>
    <zv:c l="6313" k="BNJ" en="Material on-board quantity, after discharge"/>
    <zv:c l="6313" k="BNK" en="Petroleum total calculated volume"/>
    <zv:c l="6313" k="BNL" en="Petroleum total observed volume"/>
    <zv:c l="6313" k="BNM" en="Innage gauge distance"/>
    <zv:c l="6313" k="BNN" en="Petroleum net standard weight"/>
    <zv:c l="6313" k="BNO" en="Sediment and water in petroleum"/>
    <zv:c l="6313" k="BNP" en="Observed reference height, tank"/>
    <zv:c l="6313" k="BNQ" en="Reference height, tank"/>
    <zv:c l="6313" k="BNR" en="Ullage gauge distance"/>
    <zv:c l="6313" k="BNS" en="Trim correction"/>
    <zv:c l="6313" k="BNT" en="Bow to bridge distance"/>
    <zv:c l="6313" k="BNU" en="Peg hole number"/>
    <zv:c l="6313" k="BNV" en="Number of inner packs"/>
    <zv:c l="6313" k="BNW" en="Number of next level trade items within inner pack"/>
    <zv:c l="6313" k="BNX" en="Number of trade items per pallet layer"/>
    <zv:c l="6313" k="BNY" en="Packed items layer height"/>
    <zv:c l="6313" k="BNZ" en="Packing material weight, skin tight covering"/>
    <zv:c l="6313" k="BR" en="Brightness"/>
    <zv:c l="6313" k="BRA" en="Brakes"/>
    <zv:c l="6313" k="BRB" en="Components labelled for recycling percentage"/>
    <zv:c l="6313" k="BRC" en="Renewable plastic components percentage, by net weight"/>
    <zv:c l="6313" k="BRD" en="Clamp pressure, required"/>
    <zv:c l="6313" k="BRE" en="Break"/>
    <zv:c l="6313" k="BRF" en="Ascertained volume"/>
    <zv:c l="6313" k="BRG" en="Unit weight"/>
    <zv:c l="6313" k="BRH" en="Total volume"/>
    <zv:c l="6313" k="BRI" en="Unit volume"/>
    <zv:c l="6313" k="BRJ" en="Vertical center of gravity"/>
    <zv:c l="6313" k="BRK" en="Maximum allowable transport stacking weight"/>
    <zv:c l="6313" k="BRL" en="Carbon Dioxide"/>
    <zv:c l="6313" k="BRM" en="Number of base units per pallet"/>
    <zv:c l="6313" k="BRN" en="Colony forming unit"/>
    <zv:c l="6313" k="BRO" en="Diluted liquid volume"/>
    <zv:c l="6313" k="BRP" en="Energy efficiency"/>
    <zv:c l="6313" k="BRQ" en="Number of layers"/>
    <zv:c l="6313" k="BRR" en="Maximum demand"/>
    <zv:c l="6313" k="BRS" en="Number of pallet places"/>
    <zv:c l="6313" k="BRT" en="Package net measurement, cubed"/>
    <zv:c l="6313" k="BRU" en="Power factor"/>
    <zv:c l="6313" k="BRV" en="Stacking factor excluding bottom item"/>
    <zv:c l="6313" k="BS" en="Breaking strength"/>
    <zv:c l="6313" k="BSW" en="Breaking strength wet"/>
    <zv:c l="6313" k="BSX" en="Step size"/>
    <zv:c l="6313" k="BSY" en="Number of units per package"/>
    <zv:c l="6313" k="BSZ" en="Number of units per layer"/>
    <zv:c l="6313" k="BTA" en="Weight per running metre"/>
    <zv:c l="6313" k="BTB" en="Weight per square metre"/>
    <zv:c l="6313" k="BTC" en="Acidity of meat"/>
    <zv:c l="6313" k="BTD" en="Slaughtering weight"/>
    <zv:c l="6313" k="BTE" en="Stacking factor including bottom item"/>
    <zv:c l="6313" k="BTF" en="Number of units in the width of a layer"/>
    <zv:c l="6313" k="BTG" en="Number of units in the depth of a layer"/>
    <zv:c l="6313" k="BTH" en="Nestable percentage"/>
    <zv:c l="6313" k="BTI" en="Gross weight including carrier's equipment"/>
    <zv:c l="6313" k="BTJ" en="Sugar content"/>
    <zv:c l="6313" k="BTK" en="Self-accelerating polymerization temperature (SAPT)"/>
    <zv:c l="6313" k="BTL" en="Self-accelerating decomposition temperature (SADT)"/>
    <zv:c l="6313" k="BTM" en="Control temperature"/>
    <zv:c l="6313" k="BW" en="Basis weight"/>
    <zv:c l="6313" k="CHN" en="Change"/>
    <zv:c l="6313" k="CHO" en="Emergency temperature"/>
    <zv:c l="6313" k="CM" en="Colour"/>
    <zv:c l="6313" k="COLOR_TEXT" en="Colour as text"/>
    <zv:c l="6313" k="COMMISSION" en="Commission indicator"/>
    <zv:c l="6313" k="CT" en="Contents of package"/>
    <zv:c l="6313" k="CV" en="Commercial weight"/>
    <zv:c l="6313" k="CZ" en="Core length"/>
    <zv:c l="6313" k="D" en="Destination weight agreement"/>
    <zv:c l="6313" k="DEPOSIT_SYSTEM" en="Deposit system"/>
    <zv:c l="6313" k="DEPOSIT_TYPE" en="Deposit type"/>
    <zv:c l="6313" k="DI" en="Diameter"/>
    <zv:c l="6313" k="DL" en="Delta value L"/>
    <zv:c l="6313" k="DN" en="Density"/>
    <zv:c l="6313" k="DP" en="Depth"/>
    <zv:c l="6313" k="DR" en="Denier"/>
    <zv:c l="6313" k="DS" en="Distance between points"/>
    <zv:c l="6313" k="DW" en="Width, boxcar door"/>
    <zv:c l="6313" k="E" en="Estimated new weight"/>
    <zv:c l="6313" k="EA" en="Elongation"/>
    <zv:c l="6313" k="ENERGY_CLASS" en="Energy efficiency class"/>
    <zv:c l="6313" k="EXPIRATION_DATE" en="Expiration date"/>
    <zv:c l="6313" k="F" en="Deficit weight"/>
    <zv:c l="6313" k="FEE" en="Fee indicator"/>
    <zv:c l="6313" k="FI" en="Filament count"/>
    <zv:c l="6313" k="FL" en="Longitudinal flatness"/>
    <zv:c l="6313" k="FN" en="Flatness"/>
    <zv:c l="6313" k="FV" en="Transverse flatness"/>
    <zv:c l="6313" k="GG" en="Gauge"/>
    <zv:c l="6313" k="GW" en="Gross weight, maximum"/>
    <zv:c l="6313" k="HF" en="Hardness"/>
    <zv:c l="6313" k="HM" en="Height, maximum"/>
    <zv:c l="6313" k="HT" en="Height dimension"/>
    <zv:c l="6313" k="IB" en="Impact energy"/>
    <zv:c l="6313" k="ID" en="Inside diameter"/>
    <zv:c l="6313" k="KIND_OF_ARTICLE" en="Type of article"/>
    <zv:c l="6313" k="L" en="Legal weight"/>
    <zv:c l="6313" k="LM" en="Length, maximum"/>
    <zv:c l="6313" k="LN" en="Length"/>
    <zv:c l="6313" k="LND" en="Lost end"/>
    <zv:c l="6313" k="M" en="Minimum weight"/>
    <zv:c l="6313" k="MATERIAL" en="Material of the product"/>
    <zv:c l="6313" k="METER_LOCATION" en="Metering point designation, e.g. for electricity or gas"/>
    <zv:c l="6313" k="METER_NUMBER" en="Meter number, e.g. for electricity or gas"/>
    <zv:c l="6313" k="MO" en="Moisture"/>
    <zv:c l="6313" k="MW" en="Maximum weight"/>
    <zv:c l="6313" k="N" en="Actual net weight"/>
    <zv:c l="6313" k="OD" en="Outside diameter"/>
    <zv:c l="6313" k="ORGANIC_CONTROL_BODY" en="Organic control body number"/>
    <zv:c l="6313" k="PACKAGING_MATERIAL" en="Packaging material"/>
    <zv:c l="6313" k="PACKAGING_TYPE" en="Type of packaging (code)"/>
    <zv:c l="6313" k="PROMOTIONAL_VARIANT" en="Number of the action variant"/>
    <zv:c l="6313" k="PRS" en="Pre stretch"/>
    <zv:c l="6313" k="PTN" en="Per tonne"/>
    <zv:c l="6313" k="RA" en="Relative humidity"/>
    <zv:c l="6313" k="RF" en="Resistivity"/>
    <zv:c l="6313" k="RJ" en="Rockwell C"/>
    <zv:c l="6313" k="RMW" en="Ream weight"/>
    <zv:c l="6313" k="RP" en="Reduction of area"/>
    <zv:c l="6313" k="RUN" en="Run (process)"/>
    <zv:c l="6313" k="RY" en="Ratio"/>
    <zv:c l="6313" k="SEAL_NUMBER" en="Seal number"/>
    <zv:c l="6313" k="SIZE_CODE" en="Size code"/>
    <zv:c l="6313" k="SIZE_TEXT" en="Size designation"/>
    <zv:c l="6313" k="SQ" en="Shipped quantity"/>
    <zv:c l="6313" k="T" en="Tare weight"/>
    <zv:c l="6313" k="TC" en="Temperature"/>
    <zv:c l="6313" k="TH" en="Thickness"/>
    <zv:c l="6313" k="TN" en="Time period"/>
    <zv:c l="6313" k="TRADING_UNIT" en="Type of trading unit"/>
    <zv:c l="6313" k="TT" en="Time"/>
    <zv:c l="6313" k="VGM" en="Transport equipment verified gross mass (weight)"/>
    <zv:c l="6313" k="VH" en="Height, van door"/>
    <zv:c l="6313" k="VW" en="Width, van door"/>
    <zv:c l="6313" k="WA" en="Weight per unit of area"/>
    <zv:c l="6313" k="WASTE_CODE" en="Waste code (EWC)"/>
    <zv:c l="6313" k="WASTE_FRACTION" en="Waste fraction"/>
    <zv:c l="6313" k="WD" en="Width dimension"/>
    <zv:c l="6313" k="WEEE_NUMBER" en="WEEE registration number"/>
    <zv:c l="6313" k="WM" en="Width, maximum"/>
    <zv:c l="6313" k="WU" en="Weight per unit of length"/>
    <zv:c l="6313" k="XH" en="Side height, flat bed with removable sides"/>
    <zv:c l="6313" k="XQ" en="Squareness"/>
    <zv:c l="6313" k="XZ" en="Spool size"/>
    <zv:c l="6313" k="YS" en="Yield stress"/>
    <zv:c l="6313" k="ZAL" en="Aluminium"/>
    <zv:c l="6313" k="ZAS" en="Arsenic"/>
    <zv:c l="6313" k="ZB" en="Boron"/>
    <zv:c l="6313" k="ZBI" en="Bismuth"/>
    <zv:c l="6313" k="ZC" en="Carbon"/>
    <zv:c l="6313" k="ZCA" en="Calcium"/>
    <zv:c l="6313" k="ZCB" en="Columbium"/>
    <zv:c l="6313" k="ZCE" en="Cerium"/>
    <zv:c l="6313" k="ZCL" en="Chlorine"/>
    <zv:c l="6313" k="ZCO" en="Cobalt"/>
    <zv:c l="6313" k="ZCR" en="Chromium"/>
    <zv:c l="6313" k="ZCU" en="Copper"/>
    <zv:c l="6313" k="ZFE" en="Iron"/>
    <zv:c l="6313" k="ZFS" en="Iron plus silicon"/>
    <zv:c l="6313" k="ZGE" en="Germanium"/>
    <zv:c l="6313" k="ZH" en="Hydrogen"/>
    <zv:c l="6313" k="ZK" en="Potassium"/>
    <zv:c l="6313" k="ZMG" en="Magnesium"/>
    <zv:c l="6313" k="ZMN" en="Manganese"/>
    <zv:c l="6313" k="ZMO" en="Molybdenum"/>
    <zv:c l="6313" k="ZN" en="Nitrogen"/>
    <zv:c l="6313" k="ZNA" en="Sodium"/>
    <zv:c l="6313" k="ZNB" en="Niobium"/>
    <zv:c l="6313" k="ZNI" en="Nickel"/>
    <zv:c l="6313" k="ZO" en="Oxygen"/>
    <zv:c l="6313" k="ZP" en="Phosphorus"/>
    <zv:c l="6313" k="ZPB" en="Lead"/>
    <zv:c l="6313" k="ZS" en="Sulphur"/>
    <zv:c l="6313" k="ZSB" en="Antimony"/>
    <zv:c l="6313" k="ZSE" en="Selenium"/>
    <zv:c l="6313" k="ZSI" en="Silicon"/>
    <zv:c l="6313" k="ZSL" en="Silicium oxyd"/>
    <zv:c l="6313" k="ZSN" en="Tin"/>
    <zv:c l="6313" k="ZTA" en="Tantalium"/>
    <zv:c l="6313" k="ZTE" en="Tellurium"/>
    <zv:c l="6313" k="ZTI" en="Titanium"/>
    <zv:c l="6313" k="ZV" en="Vanadium"/>
    <zv:c l="6313" k="ZW" en="Tungsten"/>
    <zv:c l="6313" k="ZWA" en="Waste content"/>
    <zv:c l="6313" k="ZZN" en="Zinc"/>
    <zv:c l="6313" k="ZZR" en="Zirconium"/>
    <zv:c l="6313" k="ZZZ" en="Mutually defined"/>
    <zv:c l="7143" k="AA" en="Product version number"/>
    <zv:c l="7143" k="AB" en="Assembly"/>
    <zv:c l="7143" k="AC" en="HIBC (Health Industry Bar Code)"/>
    <zv:c l="7143" k="AD" en="Cold roll number"/>
    <zv:c l="7143" k="AE" en="Hot roll number"/>
    <zv:c l="7143" k="AF" en="Slab number"/>
    <zv:c l="7143" k="AG" en="Software revision number"/>
    <zv:c l="7143" k="AH" en="UPC (Universal Product Code) Consumer package code (1-5-5)"/>
    <zv:c l="7143" k="AI" en="UPC (Universal Product Code) Consumer package code (1-5-5-"/>
    <zv:c l="7143" k="AJ" en="Sample number"/>
    <zv:c l="7143" k="AK" en="Pack number"/>
    <zv:c l="7143" k="AL" en="UPC (Universal Product Code) Shipping container code (1-2-"/>
    <zv:c l="7143" k="AM" en="UPC (Universal Product Code)/EAN (European article number)"/>
    <zv:c l="7143" k="AN" en="UPC (Universal Product Code) suffix"/>
    <zv:c l="7143" k="AO" en="State label code"/>
    <zv:c l="7143" k="AP" en="Heat number"/>
    <zv:c l="7143" k="AQ" en="Coupon number"/>
    <zv:c l="7143" k="AR" en="Resource number"/>
    <zv:c l="7143" k="AS" en="Work task number"/>
    <zv:c l="7143" k="AT" en="Price look up number"/>
    <zv:c l="7143" k="AU" en="NSN (North Atlantic Treaty Organization Stock Number)"/>
    <zv:c l="7143" k="AV" en="Refined product code"/>
    <zv:c l="7143" k="AW" en="Exhibit"/>
    <zv:c l="7143" k="AX" en="End item"/>
    <zv:c l="7143" k="AY" en="Federal supply classification"/>
    <zv:c l="7143" k="AZ" en="Engineering data list"/>
    <zv:c l="7143" k="BA" en="Milestone event number"/>
    <zv:c l="7143" k="BB" en="Lot number"/>
    <zv:c l="7143" k="BC" en="National drug code 4-4-2 format"/>
    <zv:c l="7143" k="BD" en="National drug code 5-3-2 format"/>
    <zv:c l="7143" k="BE" en="National drug code 5-4-1 format"/>
    <zv:c l="7143" k="BF" en="National drug code 5-4-2 format"/>
    <zv:c l="7143" k="BG" en="National drug code"/>
    <zv:c l="7143" k="BH" en="Part number"/>
    <zv:c l="7143" k="BI" en="Local Stock Number (LSN)"/>
    <zv:c l="7143" k="BJ" en="Next higher assembly number"/>
    <zv:c l="7143" k="BK" en="Data category"/>
    <zv:c l="7143" k="BL" en="Control number"/>
    <zv:c l="7143" k="BM" en="Special material identification code"/>
    <zv:c l="7143" k="BN" en="Locally assigned control number"/>
    <zv:c l="7143" k="BO" en="Buyer's colour"/>
    <zv:c l="7143" k="BP" en="Buyer's part number"/>
    <zv:c l="7143" k="BQ" en="Variable measure product code"/>
    <zv:c l="7143" k="BR" en="Financial phase"/>
    <zv:c l="7143" k="BS" en="Contract breakdown"/>
    <zv:c l="7143" k="BT" en="Technical phase"/>
    <zv:c l="7143" k="BU" en="Dye lot number"/>
    <zv:c l="7143" k="BV" en="Daily statement of activities"/>
    <zv:c l="7143" k="BW" en="Periodical statement of activities within a bilaterally"/>
    <zv:c l="7143" k="BX" en="Calendar week statement of activities"/>
    <zv:c l="7143" k="BY" en="Calendar month statement of activities"/>
    <zv:c l="7143" k="BZ" en="Original equipment number"/>
    <zv:c l="7143" k="CC" en="Industry commodity code"/>
    <zv:c l="7143" k="CG" en="Commodity grouping"/>
    <zv:c l="7143" k="CL" en="Colour number"/>
    <zv:c l="7143" k="CR" en="Contract number"/>
    <zv:c l="7143" k="CV" en="Customs article number"/>
    <zv:c l="7143" k="DR" en="Drawing revision number"/>
    <zv:c l="7143" k="DW" en="Drawing"/>
    <zv:c l="7143" k="EC" en="Engineering change level"/>
    <zv:c l="7143" k="EF" en="Material code"/>
    <zv:c l="7143" k="EMD" en="EMDN (European Medical Device Nomenclature)"/>
    <zv:c l="7143" k="EN" en="International Article Numbering Association (EAN)"/>
    <zv:c l="7143" k="FS" en="Fish species"/>
    <zv:c l="7143" k="GB" en="Buyer's internal product group code"/>
    <zv:c l="7143" k="GMN" en="Global model number"/>
    <zv:c l="7143" k="GN" en="National product group code"/>
    <zv:c l="7143" k="GS" en="General specification number"/>
    <zv:c l="7143" k="HS" en="Harmonised system"/>
    <zv:c l="7143" k="IB" en="ISBN (International Standard Book Number)"/>
    <zv:c l="7143" k="IN" en="Buyer's item number"/>
    <zv:c l="7143" k="IS" en="ISSN (International Standard Serial Number)"/>
    <zv:c l="7143" k="IT" en="Buyer's style number"/>
    <zv:c l="7143" k="IZ" en="Buyer's size code"/>
    <zv:c l="7143" k="MA" en="Machine number"/>
    <zv:c l="7143" k="MF" en="Manufacturer's (producer's) article number"/>
    <zv:c l="7143" k="MN" en="Model number"/>
    <zv:c l="7143" k="MP" en="Product/service identification number"/>
    <zv:c l="7143" k="NB" en="Batch number"/>
    <zv:c l="7143" k="ON" en="Customer order number"/>
    <zv:c l="7143" k="PD" en="Part number description"/>
    <zv:c l="7143" k="PL" en="Purchaser's order line number"/>
    <zv:c l="7143" k="PO" en="Purchase order number"/>
    <zv:c l="7143" k="PPI" en="Phytosanitary Passport identifier"/>
    <zv:c l="7143" k="PV" en="Promotional variant number"/>
    <zv:c l="7143" k="QS" en="Buyer's qualifier for size"/>
    <zv:c l="7143" k="RC" en="Returnable container number"/>
    <zv:c l="7143" k="RN" en="Release number"/>
    <zv:c l="7143" k="RU" en="Run number"/>
    <zv:c l="7143" k="RY" en="Record keeping of model year"/>
    <zv:c l="7143" k="SA" en="Supplier's article number"/>
    <zv:c l="7143" k="SG" en="Standard group of products (mixed assortment)"/>
    <zv:c l="7143" k="SK" en="SKU (Stock keeping unit)"/>
    <zv:c l="7143" k="SN" en="Serial number"/>
    <zv:c l="7143" k="SRS" en="RSK number"/>
    <zv:c l="7143" k="SRT" en="IFLS (Institut Francais du Libre Service) 5 digit product"/>
    <zv:c l="7143" k="SRU" en="IFLS (Institut Francais du Libre Service) 9 digit product"/>
    <zv:c l="7143" k="SRV" en="GS1 Global Trade Item Number"/>
    <zv:c l="7143" k="SRW" en="EDIS (Energy Data Identification System)"/>
    <zv:c l="7143" k="SRX" en="Slaughter number"/>
    <zv:c l="7143" k="SRY" en="Official animal number"/>
    <zv:c l="7143" k="SRZ" en="Harmonized tariff schedule"/>
    <zv:c l="7143" k="SS" en="Supplier's supplier article number"/>
    <zv:c l="7143" k="SSA" en="46 Level DOT Code"/>
    <zv:c l="7143" k="SSB" en="Airline Tariff 6D"/>
    <zv:c l="7143" k="SSC" en="Title 49 Code of Federal Regulations"/>
    <zv:c l="7143" k="SSD" en="International Civil Aviation Administration code"/>
    <zv:c l="7143" k="SSE" en="Hazardous Materials ID DOT"/>
    <zv:c l="7143" k="SSF" en="Endorsement"/>
    <zv:c l="7143" k="SSG" en="Air Force Regulation 71-4"/>
    <zv:c l="7143" k="SSH" en="Breed"/>
    <zv:c l="7143" k="SSI" en="Chemical Abstract Service (CAS) registry number"/>
    <zv:c l="7143" k="SSJ" en="Engine model designation"/>
    <zv:c l="7143" k="SSK" en="Institutional Meat Purchase Specifications (IMPS) Number"/>
    <zv:c l="7143" k="SSL" en="Price Look-Up code (PLU)"/>
    <zv:c l="7143" k="SSM" en="International Maritime Organization (IMO) Code"/>
    <zv:c l="7143" k="SSN" en="Bureau of Explosives 600-A (rail)"/>
    <zv:c l="7143" k="SSO" en="United Nations Dangerous Goods List"/>
    <zv:c l="7143" k="SSP" en="International Code of Botanical Nomenclature (ICBN)"/>
    <zv:c l="7143" k="SSQ" en="International Code of Zoological Nomenclature (ICZN)"/>
    <zv:c l="7143" k="SSR" en="International Code of Nomenclature for Cultivated Plants"/>
    <zv:c l="7143" k="SSS" en="Distributor's article identifier"/>
    <zv:c l="7143" k="SST" en="Norwegian Classification system ENVA"/>
    <zv:c l="7143" k="SSU" en="Supplier assigned classification"/>
    <zv:c l="7143" k="SSV" en="Mexican classification system AMECE"/>
    <zv:c l="7143" k="SSW" en="German classification system CCG"/>
    <zv:c l="7143" k="SSX" en="Finnish classification system EANFIN"/>
    <zv:c l="7143" k="SSY" en="Canadian classification system ICC"/>
    <zv:c l="7143" k="SSZ" en="French classification system IFLS5"/>
    <zv:c l="7143" k="ST" en="Style number"/>
    <zv:c l="7143" k="STA" en="Dutch classification system CBL"/>
    <zv:c l="7143" k="STB" en="Japanese classification system JICFS"/>
    <zv:c l="7143" k="STC" en="European Union dairy subsidy eligibility classification"/>
    <zv:c l="7143" k="STD" en="GS1 Spain classification system"/>
    <zv:c l="7143" k="STE" en="GS1 Poland classification system"/>
    <zv:c l="7143" k="STF" en="Federal Agency on Technical Regulating and Metrology of the"/>
    <zv:c l="7143" k="STG" en="Efficient Consumer Response (ECR) Austria classification"/>
    <zv:c l="7143" k="STH" en="GS1 Italy classification system"/>
    <zv:c l="7143" k="STI" en="CPV (Common Procurement Vocabulary)"/>
    <zv:c l="7143" k="STJ" en="IFDA (International Foodservice Distributors Association)"/>
    <zv:c l="7143" k="STK" en="AHFS (American Hospital Formulary Service) pharmacologic -"/>
    <zv:c l="7143" k="STL" en="ATC (Anatomical Therapeutic Chemical) classification system"/>
    <zv:c l="7143" k="STM" en="CLADIMED (Classification des Dispositifs Médicaux)"/>
    <zv:c l="7143" k="STN" en="CMDR (Canadian Medical Device Regulations) classification"/>
    <zv:c l="7143" k="STO" en="CNDM (Classificazione Nazionale dei Dispositivi Medici)"/>
    <zv:c l="7143" k="STP" en="UK DM&amp;D (Dictionary of Medicines &amp; Devices) standard coding"/>
    <zv:c l="7143" k="STQ" en="eCl@ss"/>
    <zv:c l="7143" k="STR" en="EDMA (European Diagnostic Manufacturers Association)"/>
    <zv:c l="7143" k="STS" en="EGAR (European Generic Article Register)"/>
    <zv:c l="7143" k="STT" en="GMDN (Global Medical Devices Nomenclature)"/>
    <zv:c l="7143" k="STU" en="GPI (Generic Product Identifier)"/>
    <zv:c l="7143" k="STV" en="HCPCS (Healthcare Common Procedure Coding System)"/>
    <zv:c l="7143" k="STW" en="ICPS (International Classification for Patient Safety)"/>
    <zv:c l="7143" k="STX" en="MedDRA (Medical Dictionary for Regulatory Activities)"/>
    <zv:c l="7143" k="STY" en="Medical Columbus"/>
    <zv:c l="7143" k="STZ" en="NAPCS (North American Product Classification System)"/>
    <zv:c l="7143" k="SUA" en="NHS (National Health Services) eClass"/>
    <zv:c l="7143" k="SUB" en="US FDA (Food and Drug Administration) Product Code"/>
    <zv:c l="7143" k="SUC" en="SNOMED CT (Systematized Nomenclature of Medicine-Clinical"/>
    <zv:c l="7143" k="SUD" en="UMDNS (Universal Medical Device Nomenclature System)"/>
    <zv:c l="7143" k="SUE" en="GS1 Global Returnable Asset Identifier, non-serialised"/>
    <zv:c l="7143" k="SUF" en="IMEI"/>
    <zv:c l="7143" k="SUG" en="Waste Type (EMSA)"/>
    <zv:c l="7143" k="SUH" en="Ship's store classification type"/>
    <zv:c l="7143" k="SUI" en="Emergency fire code"/>
    <zv:c l="7143" k="SUJ" en="Emergency spillage code"/>
    <zv:c l="7143" k="SUK" en="IMDG packing group"/>
    <zv:c l="7143" k="SUL" en="MARPOL Code IBC"/>
    <zv:c l="7143" k="SUM" en="IMDG subsidiary risk class"/>
    <zv:c l="7143" k="TG" en="Transport group number"/>
    <zv:c l="7143" k="TSN" en="Taxonomic Serial Number"/>
    <zv:c l="7143" k="TSO" en="IMDG main hazard class"/>
    <zv:c l="7143" k="TSP" en="EU Combined Nomenclature"/>
    <zv:c l="7143" k="TSQ" en="Therapeutic classification number"/>
    <zv:c l="7143" k="TSR" en="European Waste Catalogue"/>
    <zv:c l="7143" k="TSS" en="Price grouping code"/>
    <zv:c l="7143" k="TST" en="UNSPSC"/>
    <zv:c l="7143" k="TSU" en="EU RoHS Directive"/>
    <zv:c l="7143" k="UA" en="Ultimate customer's article number"/>
    <zv:c l="7143" k="UP" en="UPC (Universal product code)"/>
    <zv:c l="7143" k="VN" en="Vendor item number"/>
    <zv:c l="7143" k="VP" en="Vendor's (seller's) part number"/>
    <zv:c l="7143" k="VS" en="Vendor's supplemental item number"/>
    <zv:c l="7143" k="VX" en="Vendor specification number"/>
    <zv:c l="7143" k="ZZZ" en="Mutually defined"/>
    <zv:c l="7161" k="AA" de="Werbung" en="Advertising" fr="Publicité"/>
    <zv:c l="7161" k="AAA" de="Telekommunikation" en="Telecommunication" fr="Télécommunication"/>
    <zv:c l="7161" k="AAC" en="Technical modification"/>
    <zv:c l="7161" k="AAD" en="Job-order production"/>
    <zv:c l="7161" k="AAE" en="Outlays"/>
    <zv:c l="7161" k="AAF" en="Off-premises"/>
    <zv:c l="7161" k="AAH" en="Additional processing"/>
    <zv:c l="7161" k="AAI" en="Attesting"/>
    <zv:c l="7161" k="AAS" en="Acceptance"/>
    <zv:c l="7161" k="AAT" en="Rush delivery"/>
    <zv:c l="7161" k="AAV" en="Special construction"/>
    <zv:c l="7161" k="AAY" en="Airport facilities"/>
    <zv:c l="7161" k="AAZ" en="Concession"/>
    <zv:c l="7161" k="ABA" en="Compulsory storage"/>
    <zv:c l="7161" k="ABB" en="Fuel removal"/>
    <zv:c l="7161" k="ABC" en="Into plane"/>
    <zv:c l="7161" k="ABD" en="Overtime"/>
    <zv:c l="7161" k="ABF" en="Tooling"/>
    <zv:c l="7161" k="ABK" de="Sonstiges" en="Miscellaneous" fr="Divers"/>
    <zv:c l="7161" k="ABL" de="Verpackungszuschlag" en="Additional packaging" fr="Supplément d'emballage"/>
    <zv:c l="7161" k="ABN" en="Dunnage"/>
    <zv:c l="7161" k="ABR" en="Containerisation"/>
    <zv:c l="7161" k="ABS" en="Carton packing"/>
    <zv:c l="7161" k="ABT" en="Hessian wrapped"/>
    <zv:c l="7161" k="ABU" en="Polyethylene wrap packing"/>
    <zv:c l="7161" k="ACF" en="Miscellaneous treatment"/>
    <zv:c l="7161" k="ACG" en="Enamelling treatment"/>
    <zv:c l="7161" k="ACH" en="Heat treatment"/>
    <zv:c l="7161" k="ACI" en="Plating treatment"/>
    <zv:c l="7161" k="ACJ" en="Painting"/>
    <zv:c l="7161" k="ACK" en="Polishing"/>
    <zv:c l="7161" k="ACL" en="Priming"/>
    <zv:c l="7161" k="ACM" en="Preservation treatment"/>
    <zv:c l="7161" k="ACS" en="Fitting"/>
    <zv:c l="7161" k="ADC" en="Consolidation"/>
    <zv:c l="7161" k="ADE" en="Bill of lading"/>
    <zv:c l="7161" k="ADJ" en="Airbag"/>
    <zv:c l="7161" k="ADK" en="Transfer"/>
    <zv:c l="7161" k="ADL" en="Slipsheet"/>
    <zv:c l="7161" k="ADM" en="Binding"/>
    <zv:c l="7161" k="ADN" en="Repair or replacement of broken returnable package"/>
    <zv:c l="7161" k="ADO" en="Efficient logistics"/>
    <zv:c l="7161" k="ADP" en="Merchandising"/>
    <zv:c l="7161" k="ADQ" en="Product mix"/>
    <zv:c l="7161" k="ADR" de="Sonstige Leistungen" en="Other services" fr="Autres services"/>
    <zv:c l="7161" k="ADT" de="Abholung" en="Pick-up" fr="Enlèvement"/>
    <zv:c l="7161" k="ADW" en="Chronic illness"/>
    <zv:c l="7161" k="ADY" en="New product introduction"/>
    <zv:c l="7161" k="ADZ" en="Direct delivery"/>
    <zv:c l="7161" k="AEA" en="Diversion"/>
    <zv:c l="7161" k="AEB" en="Disconnect"/>
    <zv:c l="7161" k="AEC" en="Distribution"/>
    <zv:c l="7161" k="AED" en="Handling of hazardous cargo"/>
    <zv:c l="7161" k="AEF" en="Rents and leases"/>
    <zv:c l="7161" k="AEH" en="Location differential"/>
    <zv:c l="7161" k="AEI" en="Aircraft refueling"/>
    <zv:c l="7161" k="AEJ" en="Fuel shipped into storage"/>
    <zv:c l="7161" k="AEK" en="Cash on delivery"/>
    <zv:c l="7161" k="AEL" en="Small order processing service"/>
    <zv:c l="7161" k="AEM" en="Clerical or administrative services"/>
    <zv:c l="7161" k="AEN" en="Guarantee"/>
    <zv:c l="7161" k="AEO" en="Collection and recycling"/>
    <zv:c l="7161" k="AEP" en="Copyright fee collection"/>
    <zv:c l="7161" k="AES" en="Veterinary inspection service"/>
    <zv:c l="7161" k="AET" en="Pensioner service"/>
    <zv:c l="7161" k="AEU" en="Medicine free pass holder"/>
    <zv:c l="7161" k="AEV" en="Environmental protection service"/>
    <zv:c l="7161" k="AEW" en="Environmental clean-up service"/>
    <zv:c l="7161" k="AEX" en="National cheque processing service outside account area"/>
    <zv:c l="7161" k="AEY" en="National payment service outside account area"/>
    <zv:c l="7161" k="AEZ" en="National payment service within account area"/>
    <zv:c l="7161" k="AJ" en="Adjustments"/>
    <zv:c l="7161" k="AU" en="Authentication"/>
    <zv:c l="7161" k="CA" en="Cataloguing"/>
    <zv:c l="7161" k="CAB" en="Cartage"/>
    <zv:c l="7161" k="CAD" en="Certification"/>
    <zv:c l="7161" k="CAE" en="Certificate of conformance"/>
    <zv:c l="7161" k="CAF" en="Certificate of origin"/>
    <zv:c l="7161" k="CAI" en="Cutting"/>
    <zv:c l="7161" k="CAJ" en="Consular service"/>
    <zv:c l="7161" k="CAK" en="Customer collection"/>
    <zv:c l="7161" k="CAL" en="Payroll payment service"/>
    <zv:c l="7161" k="CAM" en="Cash transportation"/>
    <zv:c l="7161" k="CAN" en="Home banking service"/>
    <zv:c l="7161" k="CAO" en="Bilateral agreement service"/>
    <zv:c l="7161" k="CAP" en="Insurance brokerage service"/>
    <zv:c l="7161" k="CAQ" en="Cheque generation"/>
    <zv:c l="7161" k="CAR" en="Preferential merchandising location"/>
    <zv:c l="7161" k="CAS" en="Crane"/>
    <zv:c l="7161" k="CAT" en="Special colour service"/>
    <zv:c l="7161" k="CAU" en="Sorting"/>
    <zv:c l="7161" k="CAV" en="Battery collection and recycling"/>
    <zv:c l="7161" k="CAW" en="Product take back fee"/>
    <zv:c l="7161" k="CAX" en="Quality control released"/>
    <zv:c l="7161" k="CAY" en="Quality control held"/>
    <zv:c l="7161" k="CAZ" en="Quality control embargo"/>
    <zv:c l="7161" k="CD" en="Car loading"/>
    <zv:c l="7161" k="CG" en="Cleaning"/>
    <zv:c l="7161" k="CS" en="Cigarette stamping"/>
    <zv:c l="7161" k="CT" en="Count and recount"/>
    <zv:c l="7161" k="DAB" en="Layout/design"/>
    <zv:c l="7161" k="DAC" en="Assortment allowance"/>
    <zv:c l="7161" k="DAD" en="Driver assigned unloading"/>
    <zv:c l="7161" k="DAF" en="Debtor bound"/>
    <zv:c l="7161" k="DAG" en="Dealer allowance"/>
    <zv:c l="7161" k="DAH" en="Allowance transferable to the consumer"/>
    <zv:c l="7161" k="DAI" en="Growth of business"/>
    <zv:c l="7161" k="DAJ" en="Introduction allowance"/>
    <zv:c l="7161" k="DAK" en="Multi-buy promotion"/>
    <zv:c l="7161" k="DAL" en="Partnership"/>
    <zv:c l="7161" k="DAM" en="Return handling"/>
    <zv:c l="7161" k="DAN" en="Minimum order not fulfilled charge"/>
    <zv:c l="7161" k="DAO" en="Point of sales threshold allowance"/>
    <zv:c l="7161" k="DAP" en="Wholesaling discount"/>
    <zv:c l="7161" k="DAQ" en="Documentary credits transfer commission"/>
    <zv:c l="7161" k="DL" en="Delivery"/>
    <zv:c l="7161" k="EG" en="Engraving"/>
    <zv:c l="7161" k="EP" en="Expediting"/>
    <zv:c l="7161" k="ER" en="Exchange rate guarantee"/>
    <zv:c l="7161" k="FAA" en="Fabrication"/>
    <zv:c l="7161" k="FAB" en="Freight equalization"/>
    <zv:c l="7161" k="FAC" en="Freight extraordinary handling"/>
    <zv:c l="7161" k="FC" de="Frachtkosten" en="Freight service" fr="Frais de transport"/>
    <zv:c l="7161" k="FH" en="Filling/handling"/>
    <zv:c l="7161" k="FI" de="Finanzierung" en="Financing" fr="Frais financiers"/>
    <zv:c l="7161" k="GAA" en="Grinding"/>
    <zv:c l="7161" k="HAA" en="Hose"/>
    <zv:c l="7161" k="HD" en="Handling"/>
    <zv:c l="7161" k="HH" en="Hoisting and hauling"/>
    <zv:c l="7161" k="IAA" en="Installation"/>
    <zv:c l="7161" k="IAB" en="Installation and warranty"/>
    <zv:c l="7161" k="ID" en="Inside delivery"/>
    <zv:c l="7161" k="IF" en="Inspection"/>
    <zv:c l="7161" k="IR" en="Installation and training"/>
    <zv:c l="7161" k="IS" en="Invoicing"/>
    <zv:c l="7161" k="KO" en="Koshering"/>
    <zv:c l="7161" k="L1" en="Carrier count"/>
    <zv:c l="7161" k="LA" de="Kennzeichnung" en="Labelling" fr="Étiquetage"/>
    <zv:c l="7161" k="LAA" en="Labour"/>
    <zv:c l="7161" k="LAB" en="Repair and return"/>
    <zv:c l="7161" k="LF" en="Legalisation"/>
    <zv:c l="7161" k="MAE" en="Mounting"/>
    <zv:c l="7161" k="MI" en="Mail invoice"/>
    <zv:c l="7161" k="ML" en="Mail invoice to each location"/>
    <zv:c l="7161" k="NAA" en="Non-returnable containers"/>
    <zv:c l="7161" k="OA" en="Outside cable connectors"/>
    <zv:c l="7161" k="PA" en="Invoice with shipment"/>
    <zv:c l="7161" k="PAA" en="Phosphatizing (steel treatment)"/>
    <zv:c l="7161" k="PC" de="Verpackung" en="Packing" fr="Emballage"/>
    <zv:c l="7161" k="PL" en="Palletizing"/>
    <zv:c l="7161" k="PRV" en="Price variation"/>
    <zv:c l="7161" k="RAB" en="Repacking"/>
    <zv:c l="7161" k="RAC" en="Repair"/>
    <zv:c l="7161" k="RAD" en="Returnable container"/>
    <zv:c l="7161" k="RAF" en="Restocking"/>
    <zv:c l="7161" k="RE" en="Re-delivery"/>
    <zv:c l="7161" k="RF" en="Refurbishing"/>
    <zv:c l="7161" k="RH" en="Rail wagon hire"/>
    <zv:c l="7161" k="RV" en="Loading"/>
    <zv:c l="7161" k="SA" en="Salvaging"/>
    <zv:c l="7161" k="SAA" en="Shipping and handling"/>
    <zv:c l="7161" k="SAD" en="Special packaging"/>
    <zv:c l="7161" k="SAE" en="Stamping"/>
    <zv:c l="7161" k="SAI" en="Consignee unload"/>
    <zv:c l="7161" k="SG" en="Shrink-wrap"/>
    <zv:c l="7161" k="SH" de="Versand" en="Special handling" fr="Expédition"/>
    <zv:c l="7161" k="SM" en="Special finish"/>
    <zv:c l="7161" k="SU" en="Set-up"/>
    <zv:c l="7161" k="TAB" en="Tank renting"/>
    <zv:c l="7161" k="TAC" de="Prüfung" en="Testing" fr="Essais"/>
    <zv:c l="7161" k="TT" en="Transportation - third party billing"/>
    <zv:c l="7161" k="TV" en="Transportation by vendor"/>
    <zv:c l="7161" k="V1" en="Drop yard"/>
    <zv:c l="7161" k="V2" en="Drop dock"/>
    <zv:c l="7161" k="WH" en="Warehousing"/>
    <zv:c l="7161" k="XAA" en="Combine all same day shipment"/>
    <zv:c l="7161" k="YY" en="Split pick-up"/>
    <zv:c l="7161" k="ZZZ" de="Gegenseitig vereinbart" en="Mutually defined" fr="Défini d'un commun accord"/>
    <zv:c l="8067" k="0" de="Nicht angegeben" en="Transport mode not specified" fr="Non spécifié"/>
    <zv:c l="8067" k="1" de="Seeverkehr" en="Maritime transport" fr="Transport maritime"/>
    <zv:c l="8067" k="2" de="Schienenverkehr" en="Rail transport" fr="Transport ferroviaire"/>
    <zv:c l="8067" k="3" de="Straßenverkehr" en="Road transport" fr="Transport routier"/>
    <zv:c l="8067" k="4" de="Luftverkehr" en="Air transport" fr="Transport aérien"/>
    <zv:c l="8067" k="5" de="Post" en="Mail" fr="Courrier"/>
    <zv:c l="8067" k="6" de="Multimodaler Verkehr" en="Multimodal transpo" fr="Transport multimodal"/>
    <zv:c l="8067" k="7" de="Feste Transporteinrichtung" en="Fixed transport installation" fr="Installation de transport fixe"/>
    <zv:c l="8067" k="8" de="Binnenschifffahrt" en="Inland water transport" fr="Navigation intérieure"/>
    <zv:c l="8067" k="9" de="Nicht anwendbar" en="Transport mode not applicable" fr="Non applicable"/>
    <zv:c l="acc" k="1" de="Finanzbuchhaltung" en="Financial" fr="Comptabilité financière"/>
    <zv:c l="acc" k="2" de="Sonderbuchhaltung" en="Subsidiary" fr="Comptabilité spéciale"/>
    <zv:c l="acc" k="3" de="Budget" en="Budget" fr="Budget"/>
    <zv:c l="acc" k="4" de="Kostenrechnung" en="Cost accounting" fr="Comptabilité analytique"/>
    <zv:c l="acc" k="5" de="Forderung" en="Receivable" fr="Créance"/>
    <zv:c l="acc" k="6" de="Verbindlichkeit" en="Payable" fr="Dette"/>
    <zv:c l="acc" k="7" de="Projektbuchhaltung" en="Job cost accounting" fr="Comptabilité de projet"/>
    <zv:c l="country" k="1A" en="Kosovo" fr="Kosovo"/>
    <zv:c l="country" k="AD" de="Andorra" en="Andorra" fr="Andorre"/>
    <zv:c l="country" k="AE" de="Vereinigte Arabische Emirate" en="United Arab Emirates" fr="Émirats arabes unis"/>
    <zv:c l="country" k="AF" en="Afghanistan" fr="Afghanistan"/>
    <zv:c l="country" k="AG" en="Antigua and Barbuda" fr="Antigua-et-Barbuda"/>
    <zv:c l="country" k="AI" en="Anguilla" fr="Anguilla"/>
    <zv:c l="country" k="AL" de="Albanien" en="Albania" fr="Albanie"/>
    <zv:c l="country" k="AM" en="Armenia" fr="Arménie"/>
    <zv:c l="country" k="AO" en="Angola" fr="Angola"/>
    <zv:c l="country" k="AQ" en="Antarctica" fr="Antarctique"/>
    <zv:c l="country" k="AR" de="Argentinien" en="Argentina" fr="Argentine"/>
    <zv:c l="country" k="AS" en="American Samoa" fr="Samoa américaines"/>
    <zv:c l="country" k="AT" de="Österreich" en="Austria" fr="Autriche"/>
    <zv:c l="country" k="AU" de="Australien" en="Australia" fr="Australie"/>
    <zv:c l="country" k="AW" en="Aruba" fr="Aruba"/>
    <zv:c l="country" k="AX" en="Åland Islands" fr="Åland(les Îles)"/>
    <zv:c l="country" k="AZ" en="Azerbaijan" fr="Azerbaïdjan"/>
    <zv:c l="country" k="BA" de="Bosnien und Herzegowina" en="Bosnia and Herzegovina" fr="Bosnie-Herzégovine"/>
    <zv:c l="country" k="BB" en="Barbados" fr="Barbade"/>
    <zv:c l="country" k="BD" en="Bangladesh" fr="Bangladesh"/>
    <zv:c l="country" k="BE" de="Belgien" en="Belgium" fr="Belgique"/>
    <zv:c l="country" k="BF" en="Burkina Faso" fr="Burkina Faso"/>
    <zv:c l="country" k="BG" de="Bulgarien" en="Bulgaria" fr="Bulgarie"/>
    <zv:c l="country" k="BH" en="Bahrain" fr="Bahreïn"/>
    <zv:c l="country" k="BI" en="Burundi" fr="Burundi"/>
    <zv:c l="country" k="BJ" en="Benin" fr="Bénin"/>
    <zv:c l="country" k="BL" en="Saint Barthélemy" fr="Saint-Barthélemy"/>
    <zv:c l="country" k="BM" en="Bermuda" fr="Bermudes"/>
    <zv:c l="country" k="BN" en="Brunei Darussalam" fr="Brunéi Darussalam"/>
    <zv:c l="country" k="BO" en="Bolivia (Plurinational State of)" fr="Bolivie (État plurinational de)"/>
    <zv:c l="country" k="BQ" en="Bonaire, Sint Eustatius and Saba" fr="Bonaire, Saint-Eustache et Saba"/>
    <zv:c l="country" k="BR" de="Brasilien" en="Brazil" fr="Brésil"/>
    <zv:c l="country" k="BS" en="Bahamas (The)" fr="Bahamas (Les)"/>
    <zv:c l="country" k="BT" en="Bhutan" fr="Bhoutan"/>
    <zv:c l="country" k="BV" en="Bouvet Island" fr="Bouvet (l'Île)"/>
    <zv:c l="country" k="BW" en="Botswana" fr="Botswana"/>
    <zv:c l="country" k="BY" de="Belarus" en="Belarus" fr="Bélarus"/>
    <zv:c l="country" k="BZ" en="Belize" fr="Belize"/>
    <zv:c l="country" k="CA" de="Kanada" en="Canada" fr="Canada"/>
    <zv:c l="country" k="CC" en="Cocos (Keeling) Islands" fr="Cocos (les Îles)/ Keeling (les Îles)"/>
    <zv:c l="country" k="CD" en="Congo (the Democratic Republic of the)" fr="Congo (la République démocratique du)"/>
    <zv:c l="country" k="CF" en="Central African Republic" fr="République centrafricaine"/>
    <zv:c l="country" k="CG" en="Congo" fr="Congo"/>
    <zv:c l="country" k="CH" de="Schweiz" en="Switzerland" fr="Suisse"/>
    <zv:c l="country" k="CI" en="Côte d'Ivoire" fr="Côte d'Ivoire"/>
    <zv:c l="country" k="CK" en="Cook Islands" fr="Cook (les Îles)"/>
    <zv:c l="country" k="CL" en="Chile" fr="Chili"/>
    <zv:c l="country" k="CM" en="Cameroon" fr="Cameroun"/>
    <zv:c l="country" k="CN" de="China" en="China" fr="Chine"/>
    <zv:c l="country" k="CO" en="Colombia" fr="Colombie"/>
    <zv:c l="country" k="CR" en="Costa Rica" fr="Costa Rica"/>
    <zv:c l="country" k="CU" en="Cuba" fr="Cuba"/>
    <zv:c l="country" k="CV" en="Cabo Verde" fr="Cabo Verde"/>
    <zv:c l="country" k="CW" en="Curaçao" fr="Curaçao"/>
    <zv:c l="country" k="CX" en="Christmas Island" fr="Christmas (l'Île)"/>
    <zv:c l="country" k="CY" de="Zypern" en="Cyprus" fr="Chypre"/>
    <zv:c l="country" k="CZ" de="Tschechien" en="Czechia" fr="Tchéquie"/>
    <zv:c l="country" k="DE" de="Deutschland" en="Germany" fr="Allemagne"/>
    <zv:c l="country" k="DJ" en="Djibouti" fr="Djibouti"/>
    <zv:c l="country" k="DK" de="Dänemark" en="Denmark" fr="Danemark"/>
    <zv:c l="country" k="DM" en="Dominica" fr="Dominique"/>
    <zv:c l="country" k="DO" en="Dominican Republic" fr="dominicaine (la République)"/>
    <zv:c l="country" k="DZ" en="Algeria" fr="Algérie"/>
    <zv:c l="country" k="EC" en="Ecuador" fr="Équateur"/>
    <zv:c l="country" k="EE" de="Estland" en="Estonia" fr="Estonie"/>
    <zv:c l="country" k="EG" de="Ägypten" en="Egypt" fr="Égypte"/>
    <zv:c l="country" k="EH" en="Western Sahara*" fr="Sahara occidental (le)*"/>
    <zv:c l="country" k="EL" de="Griechenland" en="Greece" fr="Grèce"/>
    <zv:c l="country" k="ER" en="Eritrea" fr="Érythrée"/>
    <zv:c l="country" k="ES" de="Spanien" en="Spain" fr="Espagne"/>
    <zv:c l="country" k="ET" en="Ethiopia" fr="Éthiopie"/>
    <zv:c l="country" k="FI" de="Finnland" en="Finland" fr="Finlande"/>
    <zv:c l="country" k="FJ" en="Fiji" fr="Fidji"/>
    <zv:c l="country" k="FK" en="Falkland Islands (the) [Malvinas]" fr="Falkland (les Îles)/Malouines (les Îles)"/>
    <zv:c l="country" k="FM" en="Micronesia (Federated States of)" fr="Micronésie (États fédérés de)"/>
    <zv:c l="country" k="FO" en="Faroe Islands" fr="Féroé (les Îles)"/>
    <zv:c l="country" k="FR" de="Frankreich" en="France" fr="France"/>
    <zv:c l="country" k="GA" en="Gabon" fr="Gabon"/>
    <zv:c l="country" k="GB" de="Vereinigtes Königreich" en="United Kingdom of Great Britain and Northern Ireland" fr="Royaume-Uni de Grande-Bretagne et d'Irlande du Nord"/>
    <zv:c l="country" k="GD" en="Grenada" fr="Grenade"/>
    <zv:c l="country" k="GE" en="Georgia" fr="Géorgie"/>
    <zv:c l="country" k="GF" en="French Guiana" fr="Guyane française (la )"/>
    <zv:c l="country" k="GG" en="Guernsey" fr="Guernesey"/>
    <zv:c l="country" k="GH" en="Ghana" fr="Ghana"/>
    <zv:c l="country" k="GI" en="Gibraltar" fr="Gibraltar"/>
    <zv:c l="country" k="GL" en="Greenland" fr="Groenland"/>
    <zv:c l="country" k="GM" en="Gambia" fr="Gambie"/>
    <zv:c l="country" k="GN" en="Guinea" fr="Guinée"/>
    <zv:c l="country" k="GP" en="Guadeloupe" fr="Guadeloupe"/>
    <zv:c l="country" k="GQ" en="Equatorial Guinea" fr="Guinée équatoriale"/>
    <zv:c l="country" k="GR" de="Griechenland" en="Greece" fr="Grèce"/>
    <zv:c l="country" k="GS" en="South Georgia and the South Sandwich Islands" fr="Géorgie du Sud-et-les Îles Sandwich du Sud"/>
    <zv:c l="country" k="GT" en="Guatemala" fr="Guatemala"/>
    <zv:c l="country" k="GU" en="Guam" fr="Guam"/>
    <zv:c l="country" k="GW" en="Guinea-Bissau" fr="Guinée-Bissau"/>
    <zv:c l="country" k="GY" en="Guyana" fr="Guyana"/>
    <zv:c l="country" k="HK" de="Hongkong" en="Hong Kong" fr="Hong Kong"/>
    <zv:c l="country" k="HM" en="Heard Island and McDonald Islands" fr="Heard-et-Îles MacDonald (l'Île)"/>
    <zv:c l="country" k="HN" en="Honduras" fr="Honduras"/>
    <zv:c l="country" k="HR" de="Kroatien" en="Croatia" fr="Croatie"/>
    <zv:c l="country" k="HT" en="Haiti" fr="Haïti"/>
    <zv:c l="country" k="HU" de="Ungarn" en="Hungary" fr="Hongrie"/>
    <zv:c l="country" k="ID" en="Indonesia" fr="Indonésie"/>
    <zv:c l="country" k="IE" de="Irland" en="Ireland" fr="Irlande"/>
    <zv:c l="country" k="IL" de="Israel" en="Israel" fr="Israël"/>
    <zv:c l="country" k="IM" en="Isle of Man" fr="Île de Man"/>
    <zv:c l="country" k="IN" de="Indien" en="India" fr="Inde"/>
    <zv:c l="country" k="IO" en="British Indian Ocean Territory" fr="Indien (le Territoire britannique de l'océan)"/>
    <zv:c l="country" k="IQ" en="Iraq" fr="Iraq"/>
    <zv:c l="country" k="IR" en="Iran (Islamic Republic of)" fr="Iran (République Islamique d')"/>
    <zv:c l="country" k="IS" de="Island" en="Iceland" fr="Islande"/>
    <zv:c l="country" k="IT" de="Italien" en="Italy" fr="Italie"/>
    <zv:c l="country" k="JE" en="Jersey" fr="Jersey"/>
    <zv:c l="country" k="JM" en="Jamaica" fr="Jamaïque"/>
    <zv:c l="country" k="JO" en="Jordan" fr="Jordanie"/>
    <zv:c l="country" k="JP" de="Japan" en="Japan" fr="Japon"/>
    <zv:c l="country" k="KE" en="Kenya" fr="Kenya"/>
    <zv:c l="country" k="KG" en="Kyrgyzstan" fr="Kirghizistan"/>
    <zv:c l="country" k="KH" en="Cambodia" fr="Cambodge"/>
    <zv:c l="country" k="KI" en="Kiribati" fr="Kiribati"/>
    <zv:c l="country" k="KM" en="Comoros" fr="Comores"/>
    <zv:c l="country" k="KN" en="Saint Kitts and Nevis" fr="Saint-Kitts-et-Nevis"/>
    <zv:c l="country" k="KP" en="Korea (the Democratic People's Republic of)" fr="Corée (la République populaire démocratique de)"/>
    <zv:c l="country" k="KR" de="Südkorea" en="Korea (the Republic of)" fr="Corée (la République de)"/>
    <zv:c l="country" k="KW" en="Kuwait" fr="Koweït"/>
    <zv:c l="country" k="KY" en="Cayman Islands" fr="Caïmans (les Îles)"/>
    <zv:c l="country" k="KZ" en="Kazakhstan" fr="Kazakhstan"/>
    <zv:c l="country" k="LA" en="Lao People's Democratic Republic" fr="Lao, République démocratique populaire"/>
    <zv:c l="country" k="LB" en="Lebanon" fr="Liban"/>
    <zv:c l="country" k="LC" en="Saint Lucia" fr="Sainte-Lucie"/>
    <zv:c l="country" k="LI" de="Liechtenstein" en="Liechtenstein" fr="Liechtenstein"/>
    <zv:c l="country" k="LK" en="Sri Lanka" fr="Sri Lanka"/>
    <zv:c l="country" k="LR" en="Liberia" fr="Libéria"/>
    <zv:c l="country" k="LS" en="Lesotho" fr="Lesotho"/>
    <zv:c l="country" k="LT" de="Litauen" en="Lithuania" fr="Lituanie"/>
    <zv:c l="country" k="LU" de="Luxemburg" en="Luxembourg" fr="Luxembourg"/>
    <zv:c l="country" k="LV" de="Lettland" en="Latvia" fr="Lettonie"/>
    <zv:c l="country" k="LY" en="Libya" fr="Libye"/>
    <zv:c l="country" k="MA" de="Marokko" en="Morocco" fr="Maroc"/>
    <zv:c l="country" k="MC" de="Monaco" en="Monaco" fr="Monaco"/>
    <zv:c l="country" k="MD" de="Moldau" en="Moldova (the Republic of)" fr="Moldova, République de"/>
    <zv:c l="country" k="ME" de="Montenegro" en="Montenegro" fr="Monténégro"/>
    <zv:c l="country" k="MF" en="Saint Martin (French part)" fr="Saint-Martin (partie française)"/>
    <zv:c l="country" k="MG" en="Madagascar" fr="Madagascar"/>
    <zv:c l="country" k="MH" en="Marshall Islands" fr="Marshall (Îles)"/>
    <zv:c l="country" k="MK" de="Nordmazedonien" en="North Macedonia" fr="Macédoine (l'ex‑République yougoslave de)"/>
    <zv:c l="country" k="ML" en="Mali" fr="Mali"/>
    <zv:c l="country" k="MM" en="Myanmar" fr="Myanmar"/>
    <zv:c l="country" k="MN" en="Mongolia" fr="Mongolie"/>
    <zv:c l="country" k="MO" en="Macao" fr="Macao"/>
    <zv:c l="country" k="MP" en="Northern Mariana Islands" fr="Mariannes du Nord (les Îles)"/>
    <zv:c l="country" k="MQ" en="Martinique" fr="Martinique"/>
    <zv:c l="country" k="MR" en="Mauritania" fr="Mauritanie"/>
    <zv:c l="country" k="MS" en="Montserrat" fr="Montserrat"/>
    <zv:c l="country" k="MT" de="Malta" en="Malta" fr="Malte"/>
    <zv:c l="country" k="MU" en="Mauritius" fr="Maurice"/>
    <zv:c l="country" k="MV" en="Maldives" fr="Maldives"/>
    <zv:c l="country" k="MW" en="Malawi" fr="Malawi"/>
    <zv:c l="country" k="MX" de="Mexiko" en="Mexico" fr="Mexique"/>
    <zv:c l="country" k="MY" en="Malaysia" fr="Malaisie"/>
    <zv:c l="country" k="MZ" en="Mozambique" fr="Mozambique"/>
    <zv:c l="country" k="NA" en="Namibia" fr="Namibie"/>
    <zv:c l="country" k="NC" en="New Caledonia" fr="Nouvelle-Calédonie"/>
    <zv:c l="country" k="NE" en="Niger" fr="Niger"/>
    <zv:c l="country" k="NF" en="Norfolk Island" fr="Norfolk (l'Île)"/>
    <zv:c l="country" k="NG" en="Nigeria" fr="Nigéria"/>
    <zv:c l="country" k="NI" en="Nicaragua" fr="Nicaragua"/>
    <zv:c l="country" k="NL" de="Niederlande" en="Netherlands" fr="Pays-Bas"/>
    <zv:c l="country" k="NO" de="Norwegen" en="Norway" fr="Norvège"/>
    <zv:c l="country" k="NP" en="Nepal" fr="Népal"/>
    <zv:c l="country" k="NR" en="Nauru" fr="Nauru"/>
    <zv:c l="country" k="NU" en="Niue" fr="Niue"/>
    <zv:c l="country" k="NZ" de="Neuseeland" en="New Zealand" fr="Nouvelle-Zélande"/>
    <zv:c l="country" k="OM" en="Oman" fr="Oman"/>
    <zv:c l="country" k="PA" en="Panama" fr="Panama"/>
    <zv:c l="country" k="PE" en="Peru" fr="Pérou"/>
    <zv:c l="country" k="PF" en="French Polynesia" fr="Polynésie française"/>
    <zv:c l="country" k="PG" en="Papua New Guinea" fr="Papouasie-Nouvelle-Guinée"/>
    <zv:c l="country" k="PH" en="Philippines" fr="Philippines"/>
    <zv:c l="country" k="PK" en="Pakistan" fr="Pakistan"/>
    <zv:c l="country" k="PL" de="Polen" en="Poland" fr="Pologne"/>
    <zv:c l="country" k="PM" en="Saint Pierre and Miquelon" fr="Saint-Pierre-et-Miquelon"/>
    <zv:c l="country" k="PN" en="Pitcairn" fr="Pitcairn"/>
    <zv:c l="country" k="PR" en="Puerto Rico" fr="Porto Rico"/>
    <zv:c l="country" k="PS" en="Palestine, State of" fr="Palestine, État de"/>
    <zv:c l="country" k="PT" de="Portugal" en="Portugal" fr="Portugal"/>
    <zv:c l="country" k="PW" en="Palau" fr="Palaos"/>
    <zv:c l="country" k="PY" en="Paraguay" fr="Paraguay"/>
    <zv:c l="country" k="QA" en="Qatar" fr="Qatar"/>
    <zv:c l="country" k="RE" en="Réunion" fr="Réunion (La)"/>
    <zv:c l="country" k="RO" de="Rumänien" en="Romania" fr="Roumanie"/>
    <zv:c l="country" k="RS" de="Serbien" en="Serbia" fr="Serbie"/>
    <zv:c l="country" k="RU" de="Russland" en="Russian Federation" fr="Russie (la Fédération de)"/>
    <zv:c l="country" k="RW" en="Rwanda" fr="Rwanda"/>
    <zv:c l="country" k="SA" de="Saudi-Arabien" en="Saudi Arabia" fr="Arabie saoudite"/>
    <zv:c l="country" k="SB" en="Solomon Islands" fr="Salomon (Îles)"/>
    <zv:c l="country" k="SC" en="Seychelles" fr="Seychelles"/>
    <zv:c l="country" k="SD" en="Sudan" fr="Soudan"/>
    <zv:c l="country" k="SE" de="Schweden" en="Sweden" fr="Suède"/>
    <zv:c l="country" k="SG" de="Singapur" en="Singapore" fr="Singapour"/>
    <zv:c l="country" k="SH" en="Saint Helena, Ascension and Tristan da Cunha" fr="Sainte-Hélène, Ascension et Tristan da Cunha"/>
    <zv:c l="country" k="SI" de="Slowenien" en="Slovenia" fr="Slovénie"/>
    <zv:c l="country" k="SJ" en="Svalbard and Jan Mayen" fr="Svalbard et l'Île Jan Mayen"/>
    <zv:c l="country" k="SK" de="Slowakei" en="Slovakia" fr="Slovaquie"/>
    <zv:c l="country" k="SL" en="Sierra Leone" fr="Sierra Leone"/>
    <zv:c l="country" k="SM" de="San Marino" en="San Marino" fr="Saint-Marin"/>
    <zv:c l="country" k="SN" en="Senegal" fr="Sénégal"/>
    <zv:c l="country" k="SO" en="Somalia" fr="Somalie"/>
    <zv:c l="country" k="SR" en="Suriname" fr="Suriname"/>
    <zv:c l="country" k="SS" en="South Sudan" fr="Soudan du Sud"/>
    <zv:c l="country" k="ST" en="Sao Tome and Principe" fr="Sao Tomé-et-Principe"/>
    <zv:c l="country" k="SV" en="El Salvador" fr="El Salvador"/>
    <zv:c l="country" k="SX" en="Sint Maarten (Dutch part)" fr="Saint-Martin (partie néerlandaise)"/>
    <zv:c l="country" k="SY" en="Syrian Arab Republic" fr="République arabe syrienne"/>
    <zv:c l="country" k="SZ" en="Eswatini" fr="Eswatini"/>
    <zv:c l="country" k="TC" en="Turks and Caicos Islands" fr="Turks-et-Caïcos (les Îles)"/>
    <zv:c l="country" k="TD" en="Chad" fr="Tchad"/>
    <zv:c l="country" k="TF" en="French Southern Territories" fr="Terres australes françaises"/>
    <zv:c l="country" k="TG" en="Togo" fr="Togo"/>
    <zv:c l="country" k="TH" en="Thailand" fr="Thaïlande"/>
    <zv:c l="country" k="TJ" en="Tajikistan" fr="Tadjikistan"/>
    <zv:c l="country" k="TK" en="Tokelau" fr="Tokelau"/>
    <zv:c l="country" k="TL" en="Timor-Leste" fr="Timor-Leste"/>
    <zv:c l="country" k="TM" en="Turkmenistan" fr="Turkménistan"/>
    <zv:c l="country" k="TN" de="Tunesien" en="Tunisia" fr="Tunisie"/>
    <zv:c l="country" k="TO" en="Tonga" fr="Tonga"/>
    <zv:c l="country" k="TR" de="Türkei" en="Türkiye" fr="Turquie"/>
    <zv:c l="country" k="TT" en="Trinidad and Tobago" fr="Trinité-et-Tobago"/>
    <zv:c l="country" k="TV" en="Tuvalu" fr="Tuvalu"/>
    <zv:c l="country" k="TW" de="Taiwan" en="Taiwan (Province of China)" fr="Taïwan (Province de Chine)"/>
    <zv:c l="country" k="TZ" en="Tanzania, the United Republic of" fr="Tanzanie, République-Unie de"/>
    <zv:c l="country" k="UA" de="Ukraine" en="Ukraine" fr="Ukraine"/>
    <zv:c l="country" k="UG" en="Uganda" fr="Ouganda"/>
    <zv:c l="country" k="UM" en="United States Minor Outlying Islands" fr="Îles mineures éloignées des États-Unis"/>
    <zv:c l="country" k="US" de="Vereinigte Staaten" en="United States of America" fr="États-Unis d'Amérique"/>
    <zv:c l="country" k="UY" en="Uruguay" fr="Uruguay"/>
    <zv:c l="country" k="UZ" en="Uzbekistan" fr="Ouzbékistan"/>
    <zv:c l="country" k="VA" de="Vatikanstadt" en="Holy See" fr="Saint-Siège"/>
    <zv:c l="country" k="VC" en="Saint Vincent and the Grenadines" fr="Saint-Vincent-et-les Grenadines"/>
    <zv:c l="country" k="VE" en="Venezuela (Bolivarian Republic of)" fr="Venezuela (République bolivarienne du)"/>
    <zv:c l="country" k="VG" en="Virgin Islands (British)" fr="Vierges britanniques (les Îles)"/>
    <zv:c l="country" k="VI" en="Virgin Islands (U.S.)" fr="Vierges des États-Unis (les Îles)"/>
    <zv:c l="country" k="VN" en="Viet Nam" fr="Viet Nam"/>
    <zv:c l="country" k="VU" en="Vanuatu" fr="Vanuatu"/>
    <zv:c l="country" k="WF" en="Wallis and Futuna" fr="Wallis-et-Futuna"/>
    <zv:c l="country" k="WS" en="Samoa" fr="Samoa"/>
    <zv:c l="country" k="XI" de="Vereinigtes Königreich (Nordirland)" en="United Kingdom (Northern Ireland)" fr="Royaume -Uni (Irelande du Nord)"/>
    <zv:c l="country" k="XK" de="Kosovo" en="Kosovo"/>
    <zv:c l="country" k="YE" en="Yemen" fr="Yémen"/>
    <zv:c l="country" k="YT" en="Mayotte" fr="Mayotte"/>
    <zv:c l="country" k="ZA" de="Südafrika" en="South Africa" fr="Afrique du Sud"/>
    <zv:c l="country" k="ZM" en="Zambia" fr="Zambie"/>
    <zv:c l="country" k="ZW" en="Zimbabwe" fr="Zimbabwe"/>
    <zv:c l="currency" k="AUD" de="Australischer Dollar" en="Australian Dollar" fr="dollar australien"/>
    <zv:c l="currency" k="CAD" de="Kanadischer Dollar" en="Canadian Dollar" fr="dollar canadien"/>
    <zv:c l="currency" k="CHF" de="Schweizer Franken" en="Swiss Franc" fr="franc suisse"/>
    <zv:c l="currency" k="CNY" de="Renminbi Yuan" en="Yuan Renminbi" fr="yuan renminbi"/>
    <zv:c l="currency" k="CZK" de="Tschechische Krone" en="Czech Koruna" fr="couronne tchèque"/>
    <zv:c l="currency" k="DKK" de="Dänische Krone" en="Danish Krone" fr="couronne danoise"/>
    <zv:c l="currency" k="EUR" de="Euro" en="Euro" fr="euro"/>
    <zv:c l="currency" k="GBP" de="Pfund Sterling" en="Pound Sterling" fr="livre sterling"/>
    <zv:c l="currency" k="HUF" de="Forint" en="Forint" fr="forint"/>
    <zv:c l="currency" k="JPY" de="Yen" en="Yen" fr="yen"/>
    <zv:c l="currency" k="NOK" de="Norwegische Krone" en="Norwegian Krone" fr="couronne norvégienne"/>
    <zv:c l="currency" k="PLN" de="Złoty" en="Zloty" fr="zloty"/>
    <zv:c l="currency" k="SEK" de="Schwedische Krone" en="Swedish Krona" fr="couronne suédoise"/>
    <zv:c l="currency" k="USD" de="US-Dollar" en="US Dollar" fr="dollar des États-Unis"/>
    <zv:c l="eas" k="0002" en="System Information et Repertoire des Entreprise et des Etablissements: SIRENE"/>
    <zv:c l="eas" k="0007" en="Organisationsnummer"/>
    <zv:c l="eas" k="0009" en="SIRET-CODE"/>
    <zv:c l="eas" k="0037" en="LY-tunnus"/>
    <zv:c l="eas" k="0060" en="Data Universal Numbering System (D-U-N-S Number)"/>
    <zv:c l="eas" k="0088" en="EAN Location Code"/>
    <zv:c l="eas" k="0096" en="The Danish Business Authority - P-number (DK:P)"/>
    <zv:c l="eas" k="0097" en="FTI - Ediforum Italia, (EDIRA compliant)"/>
    <zv:c l="eas" k="0106" en="Vereniging van Kamers van Koophandel en Fabrieken in Nederland (Association of Chambers of Commerce and Industry in the Netherlands), Scheme (EDIRA compliant)"/>
    <zv:c l="eas" k="0130" en="Directorates of the European Commission"/>
    <zv:c l="eas" k="0135" en="SIA Object Identifiers"/>
    <zv:c l="eas" k="0142" en="SECETI Object Identifiers"/>
    <zv:c l="eas" k="0147" en="Standard Company Code"/>
    <zv:c l="eas" k="0151" en="Australian Business Number (ABN) Scheme"/>
    <zv:c l="eas" k="0154" en="Identification number of economic subjects: (ICO)"/>
    <zv:c l="eas" k="0158" en="Identification number of economic subject (ICO) Act on State Statistics of 29 November 2001, § 27"/>
    <zv:c l="eas" k="0170" en="Teikoku Company Code"/>
    <zv:c l="eas" k="0177" en="Odette International Limited"/>
    <zv:c l="eas" k="0183" en="Numéro d'identification suisse des enterprises (IDE), Swiss Unique Business Identification Number (UIDB)"/>
    <zv:c l="eas" k="0184" en="DIGSTORG"/>
    <zv:c l="eas" k="0188" en="Corporate Number of The Social Security and Tax Number System"/>
    <zv:c l="eas" k="0190" en="Dutch Originator's Identification Number"/>
    <zv:c l="eas" k="0191" en="Centre of Registers and Information Systems of the Ministry of Justice"/>
    <zv:c l="eas" k="0192" en="Enhetsregisteret ved Bronnoysundregisterne"/>
    <zv:c l="eas" k="0193" en="UBL.BE party identifier"/>
    <zv:c l="eas" k="0194" en="KOIOS Open Technical Dictionary"/>
    <zv:c l="eas" k="0195" en="Singapore UEN identifier"/>
    <zv:c l="eas" k="0196" en="Kennitala - Iceland legal id for individuals and legal entities"/>
    <zv:c l="eas" k="0198" en="ERSTORG"/>
    <zv:c l="eas" k="0199" en="Global legal entity identifier (GLEIF)"/>
    <zv:c l="eas" k="0200" en="Legal entity code (Lithuania)"/>
    <zv:c l="eas" k="0201" en="Codice Univoco Unità Organizzativa iPA"/>
    <zv:c l="eas" k="0202" en="Indirizzo di Posta Elettronica Certificata"/>
    <zv:c l="eas" k="0203" en="eDelivery Network Participant identifier"/>
    <zv:c l="eas" k="0204" en="Leitweg-ID"/>
    <zv:c l="eas" k="0205" en="CODDEST"/>
    <zv:c l="eas" k="0208" en="Numero d'entreprise / ondernemingsnummer / Unternehmensnummer"/>
    <zv:c l="eas" k="0209" en="GS1 identification keys"/>
    <zv:c l="eas" k="0210" en="CODICE FISCALE"/>
    <zv:c l="eas" k="0211" en="PARTITA IVA"/>
    <zv:c l="eas" k="0212" en="Finnish Organization Identifier"/>
    <zv:c l="eas" k="0213" en="Finnish Organization Value Add Tax Identifier"/>
    <zv:c l="eas" k="0215" en="Net service ID"/>
    <zv:c l="eas" k="0216" en="OVTcode"/>
    <zv:c l="eas" k="0217" en="The Netherlands Chamber of Commerce and Industry establishment number"/>
    <zv:c l="eas" k="0218" en="Unified registration number (Latvia)"/>
    <zv:c l="eas" k="0221" en="The registered number of the qualified invoice issuer"/>
    <zv:c l="eas" k="0225" en="FRCTC ELECTRONIC ADDRESS"/>
    <zv:c l="eas" k="0230" en="National e-Invoicing Framework"/>
    <zv:c l="eas" k="0235" en="UAE Tax Identification Number (TIN)"/>
    <zv:c l="eas" k="0240" en="Register of legal persons (in French : Répertoire des personnes morales)"/>
    <zv:c l="eas" k="0242" en="OpenPeppol Service Provider Identification Scheme (SPIS)"/>
    <zv:c l="eas" k="0244" en="Tax Identification (Tax ID), Nigeria"/>
    <zv:c l="eas" k="0245" en="Tax identification number (DIČ, Slovakia)"/>
    <zv:c l="eas" k="0246" en="German Electronic Business Address"/>
    <zv:c l="eas" k="0248" en="Oman Value Added Tax Identification Number (VATIN)"/>
    <zv:c l="eas" k="9910" en="Hungary VAT number"/>
    <zv:c l="eas" k="9913" en="Business Registers Network"/>
    <zv:c l="eas" k="9914" en="Österreichische Umsatzsteuer-Identifikationsnummer"/>
    <zv:c l="eas" k="9915" en="Österreichisches Verwaltungs bzw. Organisationskennzeichen"/>
    <zv:c l="eas" k="9918" en="SOCIETY FOR WORLDWIDE INTERBANK FINANCIAL, TELECOMMUNICATION S.W.I.F.T"/>
    <zv:c l="eas" k="9919" en="Kennziffer des Unternehmensregisters"/>
    <zv:c l="eas" k="9920" en="Agencia Española de Administración Tributaria"/>
    <zv:c l="eas" k="9922" en="Andorra VAT number"/>
    <zv:c l="eas" k="9923" en="Albania VAT number"/>
    <zv:c l="eas" k="9924" en="Bosnia and Herzegovina VAT number"/>
    <zv:c l="eas" k="9925" en="Belgium VAT number"/>
    <zv:c l="eas" k="9926" en="Bulgaria VAT number"/>
    <zv:c l="eas" k="9927" en="Switzerland VAT number"/>
    <zv:c l="eas" k="9928" en="Cyprus VAT number"/>
    <zv:c l="eas" k="9929" en="Czech Republic VAT number"/>
    <zv:c l="eas" k="9930" en="Germany VAT number"/>
    <zv:c l="eas" k="9931" en="Estonia VAT number"/>
    <zv:c l="eas" k="9932" en="United Kingdom VAT number"/>
    <zv:c l="eas" k="9933" en="Greece VAT number"/>
    <zv:c l="eas" k="9934" en="Croatia VAT number"/>
    <zv:c l="eas" k="9935" en="Ireland VAT number"/>
    <zv:c l="eas" k="9936" en="Liechtenstein VAT number"/>
    <zv:c l="eas" k="9937" en="Lithuania VAT number"/>
    <zv:c l="eas" k="9938" en="Luxemburg VAT number"/>
    <zv:c l="eas" k="9939" en="Latvia VAT number"/>
    <zv:c l="eas" k="9940" en="Monaco VAT number"/>
    <zv:c l="eas" k="9941" en="Montenegro VAT number"/>
    <zv:c l="eas" k="9942" en="Macedonia, the former Yugoslav Republic of VAT number"/>
    <zv:c l="eas" k="9943" en="Malta VAT number"/>
    <zv:c l="eas" k="9944" en="Netherlands VAT number"/>
    <zv:c l="eas" k="9945" en="Poland VAT number"/>
    <zv:c l="eas" k="9946" en="Portugal VAT number"/>
    <zv:c l="eas" k="9947" en="Romania VAT number"/>
    <zv:c l="eas" k="9948" en="Serbia VAT number"/>
    <zv:c l="eas" k="9949" en="Slovenia VAT number"/>
    <zv:c l="eas" k="9950" en="Slovakia VAT number"/>
    <zv:c l="eas" k="9951" en="San Marino VAT number"/>
    <zv:c l="eas" k="9952" en="Turkey VAT number"/>
    <zv:c l="eas" k="9953" en="Holy See (Vatican City State) VAT number"/>
    <zv:c l="eas" k="9957" en="French VAT number"/>
    <zv:c l="eas" k="9959" en="Employer Identification Number (EIN, USA)"/>
    <zv:c l="eas" k="AN" en="O.F.T.P. (ODETTE File Transfer Protocol)"/>
    <zv:c l="eas" k="AQ" en="X.400 address for mail text"/>
    <zv:c l="eas" k="AS" en="AS2 exchange"/>
    <zv:c l="eas" k="AU" en="File Transfer Protocol"/>
    <zv:c l="eas" k="EM" en="Electronic mail (SMPT)"/>
    <zv:c l="icd" k="0002" en="FR:SIRENE"/>
    <zv:c l="icd" k="0003" en="Codification Numerique des Etablissments Financiers En Be..."/>
    <zv:c l="icd" k="0004" en="NBS/OSI NETWORK"/>
    <zv:c l="icd" k="0005" en="USA FED GOV OSI NETWORK"/>
    <zv:c l="icd" k="0006" en="USA DOD OSI NETWORK"/>
    <zv:c l="icd" k="0007" en="SE:ORGNR"/>
    <zv:c l="icd" k="0008" en="LE NUMERO NATIONAL"/>
    <zv:c l="icd" k="0009" en="FR:SIRET"/>
    <zv:c l="icd" k="0010" en="Organizational Identifiers for Structured Names under ISO..."/>
    <zv:c l="icd" k="0011" en="International Code Designator for the Identification of O..."/>
    <zv:c l="icd" k="0012" en="European Computer Manufacturers Association: ECMA"/>
    <zv:c l="icd" k="0013" en="VSA FTP CODE (FTP = File Transfer Protocol)"/>
    <zv:c l="icd" k="0014" en="NIST/OSI Implememts' Workshop"/>
    <zv:c l="icd" k="0015" en="Electronic Data Interchange: EDI"/>
    <zv:c l="icd" k="0016" en="EWOS Object Identifiers"/>
    <zv:c l="icd" k="0017" en="COMMON LANGUAGE"/>
    <zv:c l="icd" k="0018" en="SNA/OSI Network"/>
    <zv:c l="icd" k="0019" en="Air Transport Industry Services Communications Network"/>
    <zv:c l="icd" k="0020" en="European Laboratory for Particle Physics: CERN"/>
    <zv:c l="icd" k="0021" en="SWIFT"/>
    <zv:c l="icd" k="0022" en="OSF Distributed Computing Object Identification"/>
    <zv:c l="icd" k="0023" en="Nordic University and Research Network: NORDUnet"/>
    <zv:c l="icd" k="0024" en="Digital Equipment Corporation: DEC"/>
    <zv:c l="icd" k="0025" en="OSI ASIA-OCEANIA WORKSHOP"/>
    <zv:c l="icd" k="0026" en="NATO ISO 6523 ICDE coding scheme"/>
    <zv:c l="icd" k="0027" en="Aeronautical Telecommunications Network (ATN)"/>
    <zv:c l="icd" k="0028" en="International Standard ISO 6523"/>
    <zv:c l="icd" k="0029" en="The All-Union Classifier of Enterprises and Organisations"/>
    <zv:c l="icd" k="0030" en="AT&amp;T/OSI Network"/>
    <zv:c l="icd" k="0031" en="EDI Partner Identification Code"/>
    <zv:c l="icd" k="0032" en="Telecom Australia"/>
    <zv:c l="icd" k="0033" en="S G W OSI Internetwork"/>
    <zv:c l="icd" k="0034" en="Reuter Open Address Standard"/>
    <zv:c l="icd" k="0035" en="ISO 6523 - ICD"/>
    <zv:c l="icd" k="0036" en="TeleTrust Object Identifiers"/>
    <zv:c l="icd" k="0037" en="FI:OVT"/>
    <zv:c l="icd" k="0038" en="The Australian GOSIP Network"/>
    <zv:c l="icd" k="0039" en="The OZ DOD OSI Network"/>
    <zv:c l="icd" k="0040" en="Unilever Group Companies"/>
    <zv:c l="icd" k="0041" en="Citicorp Global Information Network"/>
    <zv:c l="icd" k="0042" en="DBP Telekom Object Identifiers"/>
    <zv:c l="icd" k="0043" en="HydroNETT"/>
    <zv:c l="icd" k="0044" en="Thai Industrial Standards Institute (TISI)"/>
    <zv:c l="icd" k="0045" en="ICI Company Identification System"/>
    <zv:c l="icd" k="0046" en="FUNLOC"/>
    <zv:c l="icd" k="0047" en="BULL ODI/DSA/UNIX Network"/>
    <zv:c l="icd" k="0048" en="OSINZ"/>
    <zv:c l="icd" k="0049" en="Auckland Area Health"/>
    <zv:c l="icd" k="0050" en="Firmenich"/>
    <zv:c l="icd" k="0051" en="AGFA-DIS"/>
    <zv:c l="icd" k="0052" en="Society of Motion Picture and Television Engineers (SMPTE)"/>
    <zv:c l="icd" k="0053" en="Migros_Network M_NETOPZ"/>
    <zv:c l="icd" k="0054" en="ISO6523 - ICDPCR"/>
    <zv:c l="icd" k="0055" en="Energy Net"/>
    <zv:c l="icd" k="0056" en="Nokia Object Identifiers (NOI)"/>
    <zv:c l="icd" k="0057" en="Saint Gobain"/>
    <zv:c l="icd" k="0058" en="Siemens Corporate Network"/>
    <zv:c l="icd" k="0059" en="DANZNET"/>
    <zv:c l="icd" k="0060" en="DUNS"/>
    <zv:c l="icd" k="0061" en="SOFFEX OSI"/>
    <zv:c l="icd" k="0062" en="KPN OVN"/>
    <zv:c l="icd" k="0063" en="ascomOSINet"/>
    <zv:c l="icd" k="0064" en="UTC: Uniforme Transport Code"/>
    <zv:c l="icd" k="0065" en="SOLVAY OSI CODING"/>
    <zv:c l="icd" k="0066" en="Roche Corporate Network"/>
    <zv:c l="icd" k="0067" en="ZellwegerOSINet"/>
    <zv:c l="icd" k="0068" en="Intel Corporation OSI"/>
    <zv:c l="icd" k="0069" en="SITA Object Identifier Tree"/>
    <zv:c l="icd" k="0070" en="DaimlerChrysler Corporate Network"/>
    <zv:c l="icd" k="0071" en="LEGO /OSI NETWORK"/>
    <zv:c l="icd" k="0072" en="NAVISTAR/OSI Network"/>
    <zv:c l="icd" k="0073" en="ICD Formatted ATM address"/>
    <zv:c l="icd" k="0074" en="ARINC"/>
    <zv:c l="icd" k="0075" en="Alcanet/Alcatel-Alsthom Corporate Network"/>
    <zv:c l="icd" k="0076" en="Sistema Italiano di Identificazione di ogetti gestito da ..."/>
    <zv:c l="icd" k="0077" en="Sistema Italiano di Indirizzamento di Reti OSI Gestito da..."/>
    <zv:c l="icd" k="0078" en="Mitel terminal or switching equipment"/>
    <zv:c l="icd" k="0079" en="ATM Forum"/>
    <zv:c l="icd" k="0080" en="UK National Health Service Scheme, (EDIRA compliant)"/>
    <zv:c l="icd" k="0081" en="International NSAP"/>
    <zv:c l="icd" k="0082" en="Norwegian Telecommunications Authority's, NTA'S, EDI, ide..."/>
    <zv:c l="icd" k="0083" en="Advanced Telecommunications Modules Limited, Corporate Ne..."/>
    <zv:c l="icd" k="0084" en="Athens Chamber of Commerce &amp; Industry Scheme (EDIRA compl..."/>
    <zv:c l="icd" k="0085" en="Swiss Chambers of Commerce Scheme (EDIRA) compliant"/>
    <zv:c l="icd" k="0086" en="United States Council for International Business (USCIB) ..."/>
    <zv:c l="icd" k="0087" en="National Federation of Chambers of Commerce &amp; Industry of..."/>
    <zv:c l="icd" k="0088" en="GLN"/>
    <zv:c l="icd" k="0089" en="The Association of British Chambers of Commerce Ltd. Sche..."/>
    <zv:c l="icd" k="0090" en="Internet IP addressing - ISO 6523 ICD encoding"/>
    <zv:c l="icd" k="0091" en="Cisco Sysytems / OSI Network"/>
    <zv:c l="icd" k="0093" en="Revenue Canada Business Number Registration (EDIRA compli..."/>
    <zv:c l="icd" k="0094" en="DEUTSCHER INDUSTRIE- UND HANDELSTAG (DIHT) Scheme (EDIRA ..."/>
    <zv:c l="icd" k="0095" en="Hewlett - Packard Company Internal AM Network"/>
    <zv:c l="icd" k="0096" en="DK:P"/>
    <zv:c l="icd" k="0097" en="IT:FTI"/>
    <zv:c l="icd" k="0098" en="CHAMBER OF COMMERCE TEL AVIV-JAFFA Scheme (EDIRA compliant)"/>
    <zv:c l="icd" k="0099" en="Siemens Supervisory Systems Network"/>
    <zv:c l="icd" k="0100" en="PNG_ICD Scheme"/>
    <zv:c l="icd" k="0101" en="South African Code Allocation"/>
    <zv:c l="icd" k="0102" en="HEAG"/>
    <zv:c l="icd" k="0104" en="BT - ICD Coding System"/>
    <zv:c l="icd" k="0105" en="Portuguese Chamber of Commerce and Industry Scheme (EDIRA..."/>
    <zv:c l="icd" k="0106" en="NL:KVK"/>
    <zv:c l="icd" k="0107" en="Association of Swedish Chambers of Commerce and Industry ..."/>
    <zv:c l="icd" k="0108" en="Australian Chambers of Commerce and Industry Scheme (EDIR..."/>
    <zv:c l="icd" k="0109" en="BellSouth ICD AESA (ATM End System Address)"/>
    <zv:c l="icd" k="0110" en="Bell Atlantic"/>
    <zv:c l="icd" k="0111" en="Object Identifiers"/>
    <zv:c l="icd" k="0112" en="ISO register for Standards producing Organizations"/>
    <zv:c l="icd" k="0113" en="OriginNet"/>
    <zv:c l="icd" k="0114" en="Check Point Software Technologies"/>
    <zv:c l="icd" k="0115" en="Pacific Bell Data Communications Network"/>
    <zv:c l="icd" k="0116" en="PSS Object Identifiers"/>
    <zv:c l="icd" k="0117" en="STENTOR-ICD CODING SYSTEM"/>
    <zv:c l="icd" k="0118" en="ATM-Network ZN'96"/>
    <zv:c l="icd" k="0119" en="MCI / OSI Network"/>
    <zv:c l="icd" k="0120" en="Advantis"/>
    <zv:c l="icd" k="0121" en="Affable Software Data Interchange Codes"/>
    <zv:c l="icd" k="0122" en="BB-DATA GmbH"/>
    <zv:c l="icd" k="0123" en="BASF Company ATM-Network"/>
    <zv:c l="icd" k="0124" en="IOTA Identifiers for Organizations for Telecommunications..."/>
    <zv:c l="icd" k="0125" en="Henkel Corporate Network (H-Net)"/>
    <zv:c l="icd" k="0126" en="GTE/OSI Network"/>
    <zv:c l="icd" k="0127" en="Dresdner Bank Corporate Network"/>
    <zv:c l="icd" k="0128" en="BCNR (Swiss Clearing Bank Number)"/>
    <zv:c l="icd" k="0129" en="BPI (Swiss Business Partner Identification) code"/>
    <zv:c l="icd" k="0130" en="Directorates of the European Commission"/>
    <zv:c l="icd" k="0131" en="Code for the Identification of National Organizations"/>
    <zv:c l="icd" k="0132" en="Certicom Object Identifiers"/>
    <zv:c l="icd" k="0133" en="TC68 OID"/>
    <zv:c l="icd" k="0134" en="Infonet Services Corporation"/>
    <zv:c l="icd" k="0135" en="IT:SIA"/>
    <zv:c l="icd" k="0136" en="Cable &amp; Wireless Global ATM End-System Address Plan"/>
    <zv:c l="icd" k="0137" en="Global AESA scheme"/>
    <zv:c l="icd" k="0138" en="France Telecom ATM End System Address Plan"/>
    <zv:c l="icd" k="0139" en="Savvis Communications AESA:."/>
    <zv:c l="icd" k="0140" en="Toshiba Organizations, Partners, And Suppliers' (TOPAS) Code"/>
    <zv:c l="icd" k="0141" en="NATO Commercial and Government Entity system"/>
    <zv:c l="icd" k="0142" en="IT:SECETI"/>
    <zv:c l="icd" k="0143" en="EINESTEINet AG"/>
    <zv:c l="icd" k="0144" en="DoDAAC (Department of Defense Activity Address Code)"/>
    <zv:c l="icd" k="0145" en="DGCP (Direction Générale de la Comptabilité Publique)admi..."/>
    <zv:c l="icd" k="0146" en="DGI (Direction Générale des Impots) code"/>
    <zv:c l="icd" k="0147" en="Standard Company Code"/>
    <zv:c l="icd" k="0148" en="ITU (International Telecommunications Union)Data Network ..."/>
    <zv:c l="icd" k="0149" en="Global Business Identifier"/>
    <zv:c l="icd" k="0150" en="Madge Networks Ltd- ICD ATM Addressing Scheme"/>
    <zv:c l="icd" k="0151" en="Australian Business Number (ABN) Scheme"/>
    <zv:c l="icd" k="0152" en="Edira Scheme Identifier Code"/>
    <zv:c l="icd" k="0153" en="Concert Global Network Services ICD AESA"/>
    <zv:c l="icd" k="0154" en="Identification number of economic subjects: (ICO)"/>
    <zv:c l="icd" k="0155" en="Global Crossing AESA (ATM End System Address)"/>
    <zv:c l="icd" k="0156" en="AUNA"/>
    <zv:c l="icd" k="0157" en="ATM interconnection with the Dutch KPN Telecom"/>
    <zv:c l="icd" k="0158" en="Identification number of economic subject (ICO) Act on St..."/>
    <zv:c l="icd" k="0159" en="ACTALIS Object Identifiers"/>
    <zv:c l="icd" k="0160" en="GTIN - Global Trade Item Number"/>
    <zv:c l="icd" k="0161" en="ECCMA Open Technical Directory"/>
    <zv:c l="icd" k="0162" en="CEN/ISSS Object Identifier Scheme"/>
    <zv:c l="icd" k="0163" en="US-EPA Facility Identifier"/>
    <zv:c l="icd" k="0164" en="TELUS Corporation"/>
    <zv:c l="icd" k="0165" en="FIEIE Object identifiers"/>
    <zv:c l="icd" k="0166" en="Swissguide Identifier Scheme"/>
    <zv:c l="icd" k="0167" en="Priority Telecom ATM End System Address Plan"/>
    <zv:c l="icd" k="0168" en="Vodafone Ireland OSI Addressing"/>
    <zv:c l="icd" k="0169" en="Swiss Federal Business Identification Number. Central Bus..."/>
    <zv:c l="icd" k="0170" en="Teikoku Company Code"/>
    <zv:c l="icd" k="0171" en="Luxembourg CP &amp; CPS (Certification Policy and Certificati..."/>
    <zv:c l="icd" k="0172" en="Project Group “Lists of Properties” (PROLIST®)"/>
    <zv:c l="icd" k="0173" en="eCI@ss"/>
    <zv:c l="icd" k="0174" en="StepNexus"/>
    <zv:c l="icd" k="0175" en="Siemens AG"/>
    <zv:c l="icd" k="0176" en="Paradine GmbH"/>
    <zv:c l="icd" k="0177" en="ODETTE"/>
    <zv:c l="icd" k="0178" en="Route1 MobiNET"/>
    <zv:c l="icd" k="0179" en="Penango Object Identifiers"/>
    <zv:c l="icd" k="0180" en="Lithuanian military PKI"/>
    <zv:c l="icd" k="0183" en="Numéro d'identification suisse des enterprises (IDE), Swi..."/>
    <zv:c l="icd" k="0184" en="DK:DIGST"/>
    <zv:c l="icd" k="0185" en="Perceval Object Code"/>
    <zv:c l="icd" k="0186" en="TrustPoint Object Identifiers"/>
    <zv:c l="icd" k="0187" en="Amazon Unique Identification Scheme"/>
    <zv:c l="icd" k="0188" en="Corporate Number of The Social Security and Tax Number Sy..."/>
    <zv:c l="icd" k="0189" en="European Business Identifier (EBID)"/>
    <zv:c l="icd" k="0190" en="NL:OINO"/>
    <zv:c l="icd" k="0191" en="EE:CC"/>
    <zv:c l="icd" k="0192" en="NO:ORG"/>
    <zv:c l="icd" k="0193" en="UBLBE"/>
    <zv:c l="icd" k="0194" en="KOIOS Open Technical Dictionary"/>
    <zv:c l="icd" k="0195" en="Singapore Nationwide E-lnvoice Framework"/>
    <zv:c l="icd" k="0196" en="Icelandic identifier - Íslensk kennitala"/>
    <zv:c l="icd" k="0197" en="APPLiA Pl Standard"/>
    <zv:c l="icd" k="0198" en="ERSTORG"/>
    <zv:c l="icd" k="0199" en="Legal Entity Identifier (LEI)"/>
    <zv:c l="icd" k="0200" en="Legal entity code (Lithuania)"/>
    <zv:c l="icd" k="0201" en="Codice Univoco Unità Organizzativa iPA"/>
    <zv:c l="icd" k="0202" en="Indirizzo di Posta Elettronica Certificata"/>
    <zv:c l="icd" k="0203" en="eDelivery Network Participant identifier"/>
    <zv:c l="icd" k="0204" en="Leitweg-ID"/>
    <zv:c l="icd" k="0205" en="CODDEST"/>
    <zv:c l="icd" k="0206" en="Registre du Commerce et de l’Industrie : RCI"/>
    <zv:c l="icd" k="0207" en="PiLog Ontology Codification Identifier (POCI)"/>
    <zv:c l="icd" k="0208" en="Numero d'entreprise / ondernemingsnummer / Unternehmensnu..."/>
    <zv:c l="icd" k="0209" en="GS1 identification keys"/>
    <zv:c l="icd" k="0210" en="CODICE FISCALE"/>
    <zv:c l="icd" k="0211" en="PARTITA IVA"/>
    <zv:c l="icd" k="0212" en="Finnish Organization Identifier"/>
    <zv:c l="icd" k="0213" en="Finnish Organization Value Add Tax Identifier"/>
    <zv:c l="icd" k="0214" en="Tradeplace TradePI Standard"/>
    <zv:c l="icd" k="0215" en="Net service ID"/>
    <zv:c l="icd" k="0216" en="OVTcode"/>
    <zv:c l="icd" k="0217" en="The Netherlands Chamber of Commerce and Industry establis..."/>
    <zv:c l="icd" k="0218" en="Unified registration number (Latvia)"/>
    <zv:c l="icd" k="0219" en="Taxpayer registration code (Latvia)"/>
    <zv:c l="icd" k="0220" en="The Register of Natural Persons (Latvia)"/>
    <zv:c l="icd" k="0221" en="The registered number of the qualified invoice issuer"/>
    <zv:c l="icd" k="0222" en="Metadata Registry Support"/>
    <zv:c l="icd" k="0223" en="EU based company"/>
    <zv:c l="icd" k="0224" en="FTCTC CODE ROUTAGE"/>
    <zv:c l="icd" k="0225" en="FRCTC ELECTRONIC ADDRESS"/>
    <zv:c l="icd" k="0226" en="FRCTC Particulier"/>
    <zv:c l="icd" k="0227" en="NON - EU based company"/>
    <zv:c l="icd" k="0228" en="Répertoire des Entreprises et des Etablissements (RIDET)"/>
    <zv:c l="icd" k="0229" en="T.A.H.I.T.I (traitement automatique hiérarchisé des insti..."/>
    <zv:c l="icd" k="0230" en="National e-Invoicing Framework"/>
    <zv:c l="icd" k="0231" en="Single taxable company (France)"/>
    <zv:c l="icd" k="0232" en="NOBB product number"/>
    <zv:c l="icd" k="0233" en="Description not known"/>
    <zv:c l="icd" k="0234" en="Toimitusosoite ID"/>
    <zv:c l="icd" k="0235" en="UAE Tax Identification Number (TIN)"/>
    <zv:c l="icd" k="0236" en="Description not known"/>
    <zv:c l="icd" k="0237" en="CPR (Danish person civil registration number)"/>
    <zv:c l="icd" k="0238" en="Plateforme.s agréée.s à la facturation électronique (PPF/..."/>
    <zv:c l="icd" k="0239" en="EAEU"/>
    <zv:c l="icd" k="0240" en="Register of legal persons (in French : Répertoire des per..."/>
    <zv:c l="icd" k="0241" en="Name unknown"/>
    <zv:c l="icd" k="0242" en="OpenPeppol Service Provider Identification Scheme (SPIS)"/>
    <zv:c l="icd" k="0243" en="Name unknown"/>
    <zv:c l="icd" k="0244" en="Tax Identification (Tax ID), Nigeria"/>
    <zv:c l="icd" k="0245" en="Tax identification number (DIČ, Slovakia)"/>
    <zv:c l="icd" k="0246" en="German Electronic Business Address"/>
    <zv:c l="icd" k="0247" en="Name unknown"/>
    <zv:c l="icd" k="0248" en="Oman Value Added Tax Identification Number (VATIN)"/>
    <zv:c l="icd" k="BY" en="UNTDID codelist 3035, meaning Issued by the Buyer"/>
    <zv:c l="icd" k="SE" en="UNTDID codelist 3035, meaning Issued by the Seller"/>
    <zv:c l="incoterms" k="1" en="Delivery arranged by supplier"/>
    <zv:c l="incoterms" k="2" en="Delivery arranged by logistic service provider"/>
    <zv:c l="incoterms" k="CFR" en="Cost and Freight"/>
    <zv:c l="incoterms" k="CIF" en="Cost, Insurance and Freight"/>
    <zv:c l="incoterms" k="CIP" en="Carriage and Insurance Paid to (insert named place of destination)"/>
    <zv:c l="incoterms" k="CPT" en="Carriage Paid To (insert named place of destination)"/>
    <zv:c l="incoterms" k="DAP" en="Delivered At Place (insert named place of destination)"/>
    <zv:c l="incoterms" k="DDP" en="Delivered Duty Paid (insert named place of destination)"/>
    <zv:c l="incoterms" k="DPU" en="Delivered At Place Unloaded (insert named place of unloading)"/>
    <zv:c l="incoterms" k="EXW" en="Ex Works (insert named place of delivery)"/>
    <zv:c l="incoterms" k="FAS" en="Free Alongside Ship (insert named port of shipment)"/>
    <zv:c l="incoterms" k="FCA" en="Free Carrier (insert named place of delivery)"/>
    <zv:c l="incoterms" k="FOB" en="Free On Board (insert named port of shipment)"/>
    <zv:c l="lang" k="aar" en="Afar"/>
    <zv:c l="lang" k="abk" en="Abkhazian"/>
    <zv:c l="lang" k="ace" en="Achinese"/>
    <zv:c l="lang" k="ach" en="Acoli"/>
    <zv:c l="lang" k="ada" en="Adangme"/>
    <zv:c l="lang" k="ady" en="Adyghe; Adygei"/>
    <zv:c l="lang" k="afa" en="Afro-Asiatic (Other)"/>
    <zv:c l="lang" k="afh" en="Afrihili"/>
    <zv:c l="lang" k="afr" en="Afrikaans"/>
    <zv:c l="lang" k="ain" en="Ainu"/>
    <zv:c l="lang" k="aka" en="Akan"/>
    <zv:c l="lang" k="akk" en="Akkadian"/>
    <zv:c l="lang" k="alb" en="Albanian"/>
    <zv:c l="lang" k="ale" en="Aleut"/>
    <zv:c l="lang" k="alg" en="Algonquian languages"/>
    <zv:c l="lang" k="alt" en="Southern Altai"/>
    <zv:c l="lang" k="amh" en="Amharic"/>
    <zv:c l="lang" k="ang" en="English, Old (ca.450-1100)"/>
    <zv:c l="lang" k="anp" en="Angika"/>
    <zv:c l="lang" k="apa" en="Apache languages"/>
    <zv:c l="lang" k="ara" en="Arabic"/>
    <zv:c l="lang" k="arc" en="Aramaic"/>
    <zv:c l="lang" k="arg" en="Aragonese"/>
    <zv:c l="lang" k="arm" en="Armenian"/>
    <zv:c l="lang" k="arn" en="Mapudungun; Mapuche"/>
    <zv:c l="lang" k="arp" en="Arapaho"/>
    <zv:c l="lang" k="art" en="Artificial (Other)"/>
    <zv:c l="lang" k="arw" en="Arawak"/>
    <zv:c l="lang" k="asm" en="Assamese"/>
    <zv:c l="lang" k="ast" en="Asturian; Bable"/>
    <zv:c l="lang" k="ath" en="Athapascan languages"/>
    <zv:c l="lang" k="aus" en="Australian languages"/>
    <zv:c l="lang" k="ava" en="Avaric"/>
    <zv:c l="lang" k="ave" en="Avestan"/>
    <zv:c l="lang" k="awa" en="Awadhi"/>
    <zv:c l="lang" k="aym" en="Aymara"/>
    <zv:c l="lang" k="aze" en="Azerbaijani"/>
    <zv:c l="lang" k="bad" en="Banda languages"/>
    <zv:c l="lang" k="bai" en="Bamileke languages"/>
    <zv:c l="lang" k="bak" en="Bashkir"/>
    <zv:c l="lang" k="bal" en="Baluchi"/>
    <zv:c l="lang" k="bam" en="Bambara"/>
    <zv:c l="lang" k="ban" en="Balinese"/>
    <zv:c l="lang" k="baq" en="Basque"/>
    <zv:c l="lang" k="bas" en="Basa"/>
    <zv:c l="lang" k="bat" en="Baltic (Other)"/>
    <zv:c l="lang" k="bej" en="Beja"/>
    <zv:c l="lang" k="bel" en="Belarusian"/>
    <zv:c l="lang" k="bem" en="Bemba"/>
    <zv:c l="lang" k="ben" en="Bengali"/>
    <zv:c l="lang" k="ber" en="Berber (Other)"/>
    <zv:c l="lang" k="bho" en="Bhojpuri"/>
    <zv:c l="lang" k="bih" en="Bihari"/>
    <zv:c l="lang" k="bik" en="Bikol"/>
    <zv:c l="lang" k="bin" en="Bini; Edo"/>
    <zv:c l="lang" k="bis" en="Bislama"/>
    <zv:c l="lang" k="bla" en="Siksika"/>
    <zv:c l="lang" k="bnt" en="Bantu (Other)"/>
    <zv:c l="lang" k="bos" en="Bosnian"/>
    <zv:c l="lang" k="bra" en="Braj"/>
    <zv:c l="lang" k="bre" en="Breton"/>
    <zv:c l="lang" k="btk" en="Batak languages"/>
    <zv:c l="lang" k="bua" en="Buriat"/>
    <zv:c l="lang" k="bug" en="Buginese"/>
    <zv:c l="lang" k="bul" en="Bulgarian"/>
    <zv:c l="lang" k="bur" en="Burmese"/>
    <zv:c l="lang" k="byn" en="Blin; Bilin"/>
    <zv:c l="lang" k="cad" en="Caddo"/>
    <zv:c l="lang" k="cai" en="Central American Indian (Other)"/>
    <zv:c l="lang" k="car" en="Galibi Carib"/>
    <zv:c l="lang" k="cat" en="Catalan; Valencian"/>
    <zv:c l="lang" k="cau" en="Caucasian (Other)"/>
    <zv:c l="lang" k="ceb" en="Cebuano"/>
    <zv:c l="lang" k="cel" en="Celtic (Other)"/>
    <zv:c l="lang" k="cha" en="Chamorro"/>
    <zv:c l="lang" k="chb" en="Chibcha"/>
    <zv:c l="lang" k="che" en="Chechen"/>
    <zv:c l="lang" k="chg" en="Chagatai"/>
    <zv:c l="lang" k="chi" en="Chinese"/>
    <zv:c l="lang" k="chk" en="Chuukese"/>
    <zv:c l="lang" k="chm" en="Mari"/>
    <zv:c l="lang" k="chn" en="Chinook jargon"/>
    <zv:c l="lang" k="cho" en="Choctaw"/>
    <zv:c l="lang" k="chp" en="Chipewyan"/>
    <zv:c l="lang" k="chr" en="Cherokee"/>
    <zv:c l="lang" k="chu" en="Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic"/>
    <zv:c l="lang" k="chv" en="Chuvash"/>
    <zv:c l="lang" k="chy" en="Cheyenne"/>
    <zv:c l="lang" k="cmc" en="Chamic languages"/>
    <zv:c l="lang" k="cop" en="Coptic"/>
    <zv:c l="lang" k="cor" en="Cornish"/>
    <zv:c l="lang" k="cos" en="Corsican"/>
    <zv:c l="lang" k="cpe" en="Creoles and pidgins, English based (Other)"/>
    <zv:c l="lang" k="cpf" en="Creoles and pidgins, French-based (Other)"/>
    <zv:c l="lang" k="cpp" en="Creoles and pidgins, Portuguese-based (Other)"/>
    <zv:c l="lang" k="cre" en="Cree"/>
    <zv:c l="lang" k="crh" en="Crimean Tatar; Crimean Turkish"/>
    <zv:c l="lang" k="crp" en="Creoles and pidgins (Other)"/>
    <zv:c l="lang" k="csb" en="Kashubian"/>
    <zv:c l="lang" k="cus" en="Cushitic (Other)"/>
    <zv:c l="lang" k="cze" en="Czech"/>
    <zv:c l="lang" k="dak" en="Dakota"/>
    <zv:c l="lang" k="dan" en="Danish"/>
    <zv:c l="lang" k="dar" en="Dargwa"/>
    <zv:c l="lang" k="day" en="Land Dayak languages"/>
    <zv:c l="lang" k="del" en="Delaware"/>
    <zv:c l="lang" k="den" en="Slave (Athapascan)"/>
    <zv:c l="lang" k="deu" de="Deutsch" en="Deutsch" fr="allemand"/>
    <zv:c l="lang" k="dgr" en="Dogrib"/>
    <zv:c l="lang" k="din" en="Dinka"/>
    <zv:c l="lang" k="div" en="Divehi; Dhivehi; Maldivian"/>
    <zv:c l="lang" k="doi" en="Dogri"/>
    <zv:c l="lang" k="dra" en="Dravidian (Other)"/>
    <zv:c l="lang" k="dsb" en="Lower Sorbian"/>
    <zv:c l="lang" k="dua" en="Duala"/>
    <zv:c l="lang" k="dum" en="Dutch, Middle (ca.1050-1350)"/>
    <zv:c l="lang" k="dut" de="Niederländisch" en="Dutch; Flemish" fr="néerlandais"/>
    <zv:c l="lang" k="dyu" en="Dyula"/>
    <zv:c l="lang" k="dzo" en="Dzongkha"/>
    <zv:c l="lang" k="efi" en="Efik"/>
    <zv:c l="lang" k="egy" en="Egyptian (Ancient)"/>
    <zv:c l="lang" k="eka" en="Ekajuk"/>
    <zv:c l="lang" k="elx" en="Elamite"/>
    <zv:c l="lang" k="eng" de="Englisch" en="English" fr="anglais"/>
    <zv:c l="lang" k="enm" en="English, Middle (1100-1500)"/>
    <zv:c l="lang" k="epo" en="Esperanto"/>
    <zv:c l="lang" k="est" en="Estonian"/>
    <zv:c l="lang" k="ewe" en="Ewe"/>
    <zv:c l="lang" k="ewo" en="Ewondo"/>
    <zv:c l="lang" k="fan" en="Fang"/>
    <zv:c l="lang" k="fao" en="Faroese"/>
    <zv:c l="lang" k="fat" en="Fanti"/>
    <zv:c l="lang" k="fij" en="Fijian"/>
    <zv:c l="lang" k="fil" en="Filipino; Pilipino"/>
    <zv:c l="lang" k="fin" en="Finnish"/>
    <zv:c l="lang" k="fiu" en="Finno-Ugrian (Other)"/>
    <zv:c l="lang" k="fon" en="Fon"/>
    <zv:c l="lang" k="fra" de="Französisch" en="Französisch" fr="français"/>
    <zv:c l="lang" k="fre" de="Französisch" en="French" fr="français"/>
    <zv:c l="lang" k="frm" en="French, Middle (ca.1400-1600)"/>
    <zv:c l="lang" k="fro" en="French, Old (842-ca.1400)"/>
    <zv:c l="lang" k="frr" en="Northern Frisian"/>
    <zv:c l="lang" k="frs" en="Eastern Frisian"/>
    <zv:c l="lang" k="fry" en="Western Frisian"/>
    <zv:c l="lang" k="ful" en="Fulah"/>
    <zv:c l="lang" k="fur" en="Friulian"/>
    <zv:c l="lang" k="gaa" en="Ga"/>
    <zv:c l="lang" k="gay" en="Gayo"/>
    <zv:c l="lang" k="gba" en="Gbaya"/>
    <zv:c l="lang" k="gem" en="Germanic (Other)"/>
    <zv:c l="lang" k="geo" en="Georgian"/>
    <zv:c l="lang" k="ger" de="Deutsch" en="German" fr="allemand"/>
    <zv:c l="lang" k="gez" en="Geez"/>
    <zv:c l="lang" k="gil" en="Gilbertese"/>
    <zv:c l="lang" k="gla" en="Gaelic; Scottish Gaelic"/>
    <zv:c l="lang" k="gle" en="Irish"/>
    <zv:c l="lang" k="glg" en="Galician"/>
    <zv:c l="lang" k="glv" en="Manx"/>
    <zv:c l="lang" k="gmh" en="German, Middle High (ca.1050-1500)"/>
    <zv:c l="lang" k="goh" en="German, Old High (ca.750-1050)"/>
    <zv:c l="lang" k="gon" en="Gondi"/>
    <zv:c l="lang" k="gor" en="Gorontalo"/>
    <zv:c l="lang" k="got" en="Gothic"/>
    <zv:c l="lang" k="grb" en="Grebo"/>
    <zv:c l="lang" k="grc" en="Greek, Ancient (to 1453)"/>
    <zv:c l="lang" k="gre" en="Greek, Modern (1453-)"/>
    <zv:c l="lang" k="grn" en="Guarani"/>
    <zv:c l="lang" k="gsw" en="Swiss German; Alemannic"/>
    <zv:c l="lang" k="guj" en="Gujarati"/>
    <zv:c l="lang" k="gwi" en="Gwich'in"/>
    <zv:c l="lang" k="hai" en="Haida"/>
    <zv:c l="lang" k="hat" en="Haitian; Haitian Creole"/>
    <zv:c l="lang" k="hau" en="Hausa"/>
    <zv:c l="lang" k="haw" en="Hawaiian"/>
    <zv:c l="lang" k="heb" en="Hebrew"/>
    <zv:c l="lang" k="her" en="Herero"/>
    <zv:c l="lang" k="hil" en="Hiligaynon"/>
    <zv:c l="lang" k="him" en="Himachali"/>
    <zv:c l="lang" k="hin" en="Hindi"/>
    <zv:c l="lang" k="hit" en="Hittite"/>
    <zv:c l="lang" k="hmn" en="Hmong"/>
    <zv:c l="lang" k="hmo" en="Hiri Motu"/>
    <zv:c l="lang" k="hsb" en="Upper Sorbian"/>
    <zv:c l="lang" k="hun" en="Hungarian"/>
    <zv:c l="lang" k="hup" en="Hupa"/>
    <zv:c l="lang" k="iba" en="Iban"/>
    <zv:c l="lang" k="ibo" en="Igbo"/>
    <zv:c l="lang" k="ice" en="Icelandic"/>
    <zv:c l="lang" k="ido" en="Ido"/>
    <zv:c l="lang" k="iii" en="Sichuan Yi"/>
    <zv:c l="lang" k="ijo" en="Ijo languages"/>
    <zv:c l="lang" k="iku" en="Inuktitut"/>
    <zv:c l="lang" k="ile" en="Interlingue"/>
    <zv:c l="lang" k="ilo" en="Iloko"/>
    <zv:c l="lang" k="ina" en="Interlingua (International Auxiliary Language Association)"/>
    <zv:c l="lang" k="inc" en="Indic (Other)"/>
    <zv:c l="lang" k="ind" en="Indonesian"/>
    <zv:c l="lang" k="ine" en="Indo-European (Other)"/>
    <zv:c l="lang" k="inh" en="Ingush"/>
    <zv:c l="lang" k="ipk" en="Inupiaq"/>
    <zv:c l="lang" k="ira" en="Iranian (Other)"/>
    <zv:c l="lang" k="iro" en="Iroquoian languages"/>
    <zv:c l="lang" k="ita" de="Italienisch" en="Italian" fr="italien"/>
    <zv:c l="lang" k="jav" en="Javanese"/>
    <zv:c l="lang" k="jbo" en="Lojban"/>
    <zv:c l="lang" k="jpn" en="Japanese"/>
    <zv:c l="lang" k="jpr" en="Judeo-Persian"/>
    <zv:c l="lang" k="jrb" en="Judeo-Arabic"/>
    <zv:c l="lang" k="kaa" en="Kara-Kalpak"/>
    <zv:c l="lang" k="kab" en="Kabyle"/>
    <zv:c l="lang" k="kac" en="Kachin; Jingpho"/>
    <zv:c l="lang" k="kal" en="Kalaallisut; Greenlandic"/>
    <zv:c l="lang" k="kam" en="Kamba"/>
    <zv:c l="lang" k="kan" en="Kannada"/>
    <zv:c l="lang" k="kar" en="Karen languages"/>
    <zv:c l="lang" k="kas" en="Kashmiri"/>
    <zv:c l="lang" k="kau" en="Kanuri"/>
    <zv:c l="lang" k="kaw" en="Kawi"/>
    <zv:c l="lang" k="kaz" en="Kazakh"/>
    <zv:c l="lang" k="kbd" en="Kabardian"/>
    <zv:c l="lang" k="kha" en="Khasi"/>
    <zv:c l="lang" k="khi" en="Khoisan (Other)"/>
    <zv:c l="lang" k="khm" en="Central Khmer"/>
    <zv:c l="lang" k="kho" en="Khotanese"/>
    <zv:c l="lang" k="kik" en="Kikuyu; Gikuyu"/>
    <zv:c l="lang" k="kin" en="Kinyarwanda"/>
    <zv:c l="lang" k="kir" en="Kirghiz; Kyrgyz"/>
    <zv:c l="lang" k="kmb" en="Kimbundu"/>
    <zv:c l="lang" k="kok" en="Konkani"/>
    <zv:c l="lang" k="kom" en="Komi"/>
    <zv:c l="lang" k="kon" en="Kongo"/>
    <zv:c l="lang" k="kor" en="Korean"/>
    <zv:c l="lang" k="kos" en="Kosraean"/>
    <zv:c l="lang" k="kpe" en="Kpelle"/>
    <zv:c l="lang" k="krc" en="Karachay-Balkar"/>
    <zv:c l="lang" k="krl" en="Karelian"/>
    <zv:c l="lang" k="kro" en="Kru languages"/>
    <zv:c l="lang" k="kru" en="Kurukh"/>
    <zv:c l="lang" k="kua" en="Kuanyama; Kwanyama"/>
    <zv:c l="lang" k="kum" en="Kumyk"/>
    <zv:c l="lang" k="kur" en="Kurdish"/>
    <zv:c l="lang" k="kut" en="Kutenai"/>
    <zv:c l="lang" k="lad" en="Ladino"/>
    <zv:c l="lang" k="lah" en="Lahnda"/>
    <zv:c l="lang" k="lam" en="Lamba"/>
    <zv:c l="lang" k="lao" en="Lao"/>
    <zv:c l="lang" k="lat" en="Latin"/>
    <zv:c l="lang" k="lav" en="Latvian"/>
    <zv:c l="lang" k="lez" en="Lezghian"/>
    <zv:c l="lang" k="lim" en="Limburgan; Limburger; Limburgish"/>
    <zv:c l="lang" k="lin" en="Lingala"/>
    <zv:c l="lang" k="lit" en="Lithuanian"/>
    <zv:c l="lang" k="lol" en="Mongo"/>
    <zv:c l="lang" k="loz" en="Lozi"/>
    <zv:c l="lang" k="ltz" en="Luxembourgish; Letzeburgesch"/>
    <zv:c l="lang" k="lua" en="Luba-Lulua"/>
    <zv:c l="lang" k="lub" en="Luba-Katanga"/>
    <zv:c l="lang" k="lug" en="Ganda"/>
    <zv:c l="lang" k="lui" en="Luiseno"/>
    <zv:c l="lang" k="lun" en="Lunda"/>
    <zv:c l="lang" k="luo" en="Luo (Kenya and Tanzania)"/>
    <zv:c l="lang" k="lus" en="Lushai"/>
    <zv:c l="lang" k="mac" en="Macedonian"/>
    <zv:c l="lang" k="mad" en="Madurese"/>
    <zv:c l="lang" k="mag" en="Magahi"/>
    <zv:c l="lang" k="mah" en="Marshallese"/>
    <zv:c l="lang" k="mai" en="Maithili"/>
    <zv:c l="lang" k="mak" en="Makasar"/>
    <zv:c l="lang" k="mal" en="Malayalam"/>
    <zv:c l="lang" k="man" en="Mandingo"/>
    <zv:c l="lang" k="mao" en="Maori"/>
    <zv:c l="lang" k="map" en="Austronesian (Other)"/>
    <zv:c l="lang" k="mar" en="Marathi"/>
    <zv:c l="lang" k="mas" en="Masai"/>
    <zv:c l="lang" k="may" en="Malay"/>
    <zv:c l="lang" k="mdf" en="Moksha"/>
    <zv:c l="lang" k="mdr" en="Mandar"/>
    <zv:c l="lang" k="men" en="Mende"/>
    <zv:c l="lang" k="mga" en="Irish, Middle (900-1200)"/>
    <zv:c l="lang" k="mic" en="Mi'kmaq; Micmac"/>
    <zv:c l="lang" k="min" en="Minangkabau"/>
    <zv:c l="lang" k="mis" en="Miscellaneous languages"/>
    <zv:c l="lang" k="mkh" en="Mon-Khmer (Other)"/>
    <zv:c l="lang" k="mlg" en="Malagasy"/>
    <zv:c l="lang" k="mlt" en="Maltese"/>
    <zv:c l="lang" k="mnc" en="Manchu"/>
    <zv:c l="lang" k="mni" en="Manipuri"/>
    <zv:c l="lang" k="mno" en="Manobo languages"/>
    <zv:c l="lang" k="moh" en="Mohawk"/>
    <zv:c l="lang" k="mol" en="Moldavian"/>
    <zv:c l="lang" k="mon" en="Mongolian"/>
    <zv:c l="lang" k="mos" en="Mossi"/>
    <zv:c l="lang" k="mul" en="Multiple languages"/>
    <zv:c l="lang" k="mun" en="Munda languages"/>
    <zv:c l="lang" k="mus" en="Creek"/>
    <zv:c l="lang" k="mwl" en="Mirandese"/>
    <zv:c l="lang" k="mwr" en="Marwari"/>
    <zv:c l="lang" k="myn" en="Mayan languages"/>
    <zv:c l="lang" k="myv" en="Erzya"/>
    <zv:c l="lang" k="nah" en="Nahuatl languages"/>
    <zv:c l="lang" k="nai" en="North American Indian"/>
    <zv:c l="lang" k="nap" en="Neapolitan"/>
    <zv:c l="lang" k="nau" en="Nauru"/>
    <zv:c l="lang" k="nav" en="Navajo; Navaho"/>
    <zv:c l="lang" k="nbl" en="Ndebele, South; South Ndebele"/>
    <zv:c l="lang" k="nde" en="Ndebele, North; North Ndebele"/>
    <zv:c l="lang" k="ndo" en="Ndonga"/>
    <zv:c l="lang" k="nds" en="Low German; Low Saxon; German, Low; Saxon, Low"/>
    <zv:c l="lang" k="nep" en="Nepali"/>
    <zv:c l="lang" k="new" en="Nepal Bhasa; Newari"/>
    <zv:c l="lang" k="nia" en="Nias"/>
    <zv:c l="lang" k="nic" en="Niger-Kordofanian (Other)"/>
    <zv:c l="lang" k="niu" en="Niuean"/>
    <zv:c l="lang" k="nld" de="Niederländisch" en="Niederländisch" fr="néerlandais"/>
    <zv:c l="lang" k="nno" en="Norwegian Nynorsk; Nynorsk, Norwegian"/>
    <zv:c l="lang" k="nob" en="Bokmål, Norwegian; Norwegian Bokmål"/>
    <zv:c l="lang" k="nog" en="Nogai"/>
    <zv:c l="lang" k="non" en="Norse, Old"/>
    <zv:c l="lang" k="nor" en="Norwegian"/>
    <zv:c l="lang" k="nqo" en="N'Ko"/>
    <zv:c l="lang" k="nso" en="Pedi; Sepedi; Northern Sotho"/>
    <zv:c l="lang" k="nub" en="Nubian languages"/>
    <zv:c l="lang" k="nwc" en="Classical Newari; Old Newari; Classical Nepal Bhasa"/>
    <zv:c l="lang" k="nya" en="Chichewa; Chewa; Nyanja"/>
    <zv:c l="lang" k="nym" en="Nyamwezi"/>
    <zv:c l="lang" k="nyn" en="Nyankole"/>
    <zv:c l="lang" k="nyo" en="Nyoro"/>
    <zv:c l="lang" k="nzi" en="Nzima"/>
    <zv:c l="lang" k="oci" en="Occitan (post 1500); Provençal"/>
    <zv:c l="lang" k="oji" en="Ojibwa"/>
    <zv:c l="lang" k="ori" en="Oriya"/>
    <zv:c l="lang" k="orm" en="Oromo"/>
    <zv:c l="lang" k="osa" en="Osage"/>
    <zv:c l="lang" k="oss" en="Ossetian; Ossetic"/>
    <zv:c l="lang" k="ota" en="Turkish, Ottoman (1500-1928)"/>
    <zv:c l="lang" k="oto" en="Otomian languages"/>
    <zv:c l="lang" k="paa" en="Papuan (Other)"/>
    <zv:c l="lang" k="pag" en="Pangasinan"/>
    <zv:c l="lang" k="pal" en="Pahlavi"/>
    <zv:c l="lang" k="pam" en="Pampanga"/>
    <zv:c l="lang" k="pan" en="Panjabi; Punjabi"/>
    <zv:c l="lang" k="pap" en="Papiamento"/>
    <zv:c l="lang" k="pau" en="Palauan"/>
    <zv:c l="lang" k="peo" en="Persian, Old (ca.600-400 B.C.)"/>
    <zv:c l="lang" k="per" en="Persian"/>
    <zv:c l="lang" k="phi" en="Philippine (Other)"/>
    <zv:c l="lang" k="phn" en="Phoenician"/>
    <zv:c l="lang" k="pli" en="Pali"/>
    <zv:c l="lang" k="pol" en="Polish"/>
    <zv:c l="lang" k="pon" en="Pohnpeian"/>
    <zv:c l="lang" k="por" en="Portuguese"/>
    <zv:c l="lang" k="pra" en="Prakrit languages"/>
    <zv:c l="lang" k="pro" en="Provençal, Old (to 1500)"/>
    <zv:c l="lang" k="pus" en="Pushto"/>
    <zv:c l="lang" k="que" en="Quechua"/>
    <zv:c l="lang" k="raj" en="Rajasthani"/>
    <zv:c l="lang" k="rap" en="Rapanui"/>
    <zv:c l="lang" k="rar" en="Rarotongan; Cook Islands Maori"/>
    <zv:c l="lang" k="roa" en="Romance (Other)"/>
    <zv:c l="lang" k="roh" en="Romansh"/>
    <zv:c l="lang" k="rom" en="Romany"/>
    <zv:c l="lang" k="rum" en="Romanian"/>
    <zv:c l="lang" k="run" en="Rundi"/>
    <zv:c l="lang" k="rup" en="Aromanian; Arumanian; Macedo-Romanian"/>
    <zv:c l="lang" k="rus" en="Russian"/>
    <zv:c l="lang" k="sad" en="Sandawe"/>
    <zv:c l="lang" k="sag" en="Sango"/>
    <zv:c l="lang" k="sah" en="Yakut"/>
    <zv:c l="lang" k="sai" en="South American Indian (Other)"/>
    <zv:c l="lang" k="sal" en="Salishan languages"/>
    <zv:c l="lang" k="sam" en="Samaritan Aramaic"/>
    <zv:c l="lang" k="san" en="Sanskrit"/>
    <zv:c l="lang" k="sas" en="Sasak"/>
    <zv:c l="lang" k="sat" en="Santali"/>
    <zv:c l="lang" k="scc" en="Serbian"/>
    <zv:c l="lang" k="scn" en="Sicilian"/>
    <zv:c l="lang" k="sco" en="Scots"/>
    <zv:c l="lang" k="scr" en="Croatian"/>
    <zv:c l="lang" k="sel" en="Selkup"/>
    <zv:c l="lang" k="sem" en="Semitic (Other)"/>
    <zv:c l="lang" k="sga" en="Irish, Old (to 900)"/>
    <zv:c l="lang" k="sgn" en="Sign Languages"/>
    <zv:c l="lang" k="shn" en="Shan"/>
    <zv:c l="lang" k="sid" en="Sidamo"/>
    <zv:c l="lang" k="sin" en="Sinhala; Sinhalese"/>
    <zv:c l="lang" k="sio" en="Siouan languages"/>
    <zv:c l="lang" k="sit" en="Sino-Tibetan (Other)"/>
    <zv:c l="lang" k="sla" en="Slavic (Other)"/>
    <zv:c l="lang" k="slo" en="Slovak"/>
    <zv:c l="lang" k="slv" en="Slovenian"/>
    <zv:c l="lang" k="sma" en="Southern Sami"/>
    <zv:c l="lang" k="sme" en="Northern Sami"/>
    <zv:c l="lang" k="smi" en="Sami languages (Other)"/>
    <zv:c l="lang" k="smj" en="Lule Sami"/>
    <zv:c l="lang" k="smn" en="Inari Sami"/>
    <zv:c l="lang" k="smo" en="Samoan"/>
    <zv:c l="lang" k="sms" en="Skolt Sami"/>
    <zv:c l="lang" k="sna" en="Shona"/>
    <zv:c l="lang" k="snd" en="Sindhi"/>
    <zv:c l="lang" k="snk" en="Soninke"/>
    <zv:c l="lang" k="sog" en="Sogdian"/>
    <zv:c l="lang" k="som" en="Somali"/>
    <zv:c l="lang" k="son" en="Songhai languages"/>
    <zv:c l="lang" k="sot" en="Sotho, Southern"/>
    <zv:c l="lang" k="spa" de="Spanisch" en="Spanish; Castilian" fr="espagnol"/>
    <zv:c l="lang" k="srd" en="Sardinian"/>
    <zv:c l="lang" k="srn" en="Sranan Tongo"/>
    <zv:c l="lang" k="srr" en="Serer"/>
    <zv:c l="lang" k="ssa" en="Nilo-Saharan (Other)"/>
    <zv:c l="lang" k="ssw" en="Swati"/>
    <zv:c l="lang" k="suk" en="Sukuma"/>
    <zv:c l="lang" k="sun" en="Sundanese"/>
    <zv:c l="lang" k="sus" en="Susu"/>
    <zv:c l="lang" k="sux" en="Sumerian"/>
    <zv:c l="lang" k="swa" en="Swahili"/>
    <zv:c l="lang" k="swe" en="Swedish"/>
    <zv:c l="lang" k="syr" en="Syriac"/>
    <zv:c l="lang" k="tah" en="Tahitian"/>
    <zv:c l="lang" k="tai" en="Tai (Other)"/>
    <zv:c l="lang" k="tam" en="Tamil"/>
    <zv:c l="lang" k="tat" en="Tatar"/>
    <zv:c l="lang" k="tel" en="Telugu"/>
    <zv:c l="lang" k="tem" en="Timne"/>
    <zv:c l="lang" k="ter" en="Tereno"/>
    <zv:c l="lang" k="tet" en="Tetum"/>
    <zv:c l="lang" k="tgk" en="Tajik"/>
    <zv:c l="lang" k="tgl" en="Tagalog"/>
    <zv:c l="lang" k="tha" en="Thai"/>
    <zv:c l="lang" k="tib" en="Tibetan"/>
    <zv:c l="lang" k="tig" en="Tigre"/>
    <zv:c l="lang" k="tir" en="Tigrinya"/>
    <zv:c l="lang" k="tiv" en="Tiv"/>
    <zv:c l="lang" k="tkl" en="Tokelau"/>
    <zv:c l="lang" k="tlh" en="Klingon; tlhIngan-Hol"/>
    <zv:c l="lang" k="tli" en="Tlingit"/>
    <zv:c l="lang" k="tmh" en="Tamashek"/>
    <zv:c l="lang" k="tog" en="Tonga (Nyasa)"/>
    <zv:c l="lang" k="ton" en="Tonga (Tonga Islands)"/>
    <zv:c l="lang" k="tpi" en="Tok Pisin"/>
    <zv:c l="lang" k="tsi" en="Tsimshian"/>
    <zv:c l="lang" k="tsn" en="Tswana"/>
    <zv:c l="lang" k="tso" en="Tsonga"/>
    <zv:c l="lang" k="tuk" en="Turkmen"/>
    <zv:c l="lang" k="tum" en="Tumbuka"/>
    <zv:c l="lang" k="tup" en="Tupi languages"/>
    <zv:c l="lang" k="tur" en="Turkish"/>
    <zv:c l="lang" k="tut" en="Altaic (Other)"/>
    <zv:c l="lang" k="tvl" en="Tuvalu"/>
    <zv:c l="lang" k="twi" en="Twi"/>
    <zv:c l="lang" k="tyv" en="Tuvinian"/>
    <zv:c l="lang" k="udm" en="Udmurt"/>
    <zv:c l="lang" k="uga" en="Ugaritic"/>
    <zv:c l="lang" k="uig" en="Uighur; Uyghur"/>
    <zv:c l="lang" k="ukr" en="Ukrainian"/>
    <zv:c l="lang" k="umb" en="Umbundu"/>
    <zv:c l="lang" k="und" en="Undetermined"/>
    <zv:c l="lang" k="urd" en="Urdu"/>
    <zv:c l="lang" k="uzb" en="Uzbek"/>
    <zv:c l="lang" k="vai" en="Vai"/>
    <zv:c l="lang" k="ven" en="Venda"/>
    <zv:c l="lang" k="vie" en="Vietnamese"/>
    <zv:c l="lang" k="vol" en="Volapük"/>
    <zv:c l="lang" k="vot" en="Votic"/>
    <zv:c l="lang" k="wak" en="Wakashan languages"/>
    <zv:c l="lang" k="wal" en="Walamo"/>
    <zv:c l="lang" k="war" en="Waray"/>
    <zv:c l="lang" k="was" en="Washo"/>
    <zv:c l="lang" k="wel" en="Welsh"/>
    <zv:c l="lang" k="wen" en="Sorbian languages"/>
    <zv:c l="lang" k="wln" en="Walloon"/>
    <zv:c l="lang" k="wol" en="Wolof"/>
    <zv:c l="lang" k="xal" en="Kalmyk; Oirat"/>
    <zv:c l="lang" k="xho" en="Xhosa"/>
    <zv:c l="lang" k="yao" en="Yao"/>
    <zv:c l="lang" k="yap" en="Yapese"/>
    <zv:c l="lang" k="yid" en="Yiddish"/>
    <zv:c l="lang" k="yor" en="Yoruba"/>
    <zv:c l="lang" k="ypk" en="Yupik languages"/>
    <zv:c l="lang" k="zap" en="Zapotec"/>
    <zv:c l="lang" k="zen" en="Zenaga"/>
    <zv:c l="lang" k="zha" en="Zhuang; Chuang"/>
    <zv:c l="lang" k="znd" en="Zande languages"/>
    <zv:c l="lang" k="zul" en="Zulu"/>
    <zv:c l="lang" k="zun" en="Zuni"/>
    <zv:c l="lang" k="zxx" en="No linguistic content"/>
    <zv:c l="lang" k="zza" en="Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki."/>
    <zv:c l="lang2" k="de" de="Deutsch" en="German" fr="allemand"/>
    <zv:c l="lang2" k="en" de="Englisch" en="English" fr="anglais"/>
    <zv:c l="lang2" k="es" de="Spanisch" en="Spanish" fr="espagnol"/>
    <zv:c l="lang2" k="fr" de="Französisch" en="French" fr="français"/>
    <zv:c l="lang2" k="it" de="Italienisch" en="Italian" fr="italien"/>
    <zv:c l="lang2" k="nl" de="Niederländisch" en="Dutch" fr="néerlandais"/>
    <zv:c l="linereason" k="DETAIL" de="Normale Position" en="Regular item position (standard case)" fr="Ligne standard"/>
    <zv:c l="linereason" k="GROUP" de="Gruppe / Zwischensumme" en="Subtotal or group" fr="Groupe / sous-total"/>
    <zv:c l="linereason" k="INFORMATION" de="Nur zur Information" en="For information only" fr="Pour information uniquement"/>
    <zv:c l="nonvat" k="AAA" en="Petroleum tax"/>
    <zv:c l="nonvat" k="AAB" en="Provisional countervailing duty cash"/>
    <zv:c l="nonvat" k="AAC" en="Provisional countervailing duty bond"/>
    <zv:c l="nonvat" k="AAD" en="Tobacco tax"/>
    <zv:c l="nonvat" k="AAE" en="Energy fee"/>
    <zv:c l="nonvat" k="AAF" en="Coffee tax"/>
    <zv:c l="nonvat" k="AAG" en="Harmonised sales tax, Canadian"/>
    <zv:c l="nonvat" k="AAH" en="Quebec sales tax"/>
    <zv:c l="nonvat" k="AAI" en="Canadian provincial sales tax"/>
    <zv:c l="nonvat" k="AAJ" en="Tax on replacement part"/>
    <zv:c l="nonvat" k="AAK" en="Mineral oil tax"/>
    <zv:c l="nonvat" k="AAL" en="Special tax"/>
    <zv:c l="nonvat" k="AAM" en="Insurance tax"/>
    <zv:c l="nonvat" k="AAO" en="Provincial Cannabis Tax"/>
    <zv:c l="nonvat" k="AAP" en="Outstanding duty interest"/>
    <zv:c l="nonvat" k="ADD" en="Anti-dumping duty"/>
    <zv:c l="nonvat" k="BOL" en="Stamp duty (Imposta di Bollo)"/>
    <zv:c l="nonvat" k="CAP" en="Agricultural levy"/>
    <zv:c l="nonvat" k="CAR" en="Car tax"/>
    <zv:c l="nonvat" k="COC" en="Paper consortium tax (Italy)"/>
    <zv:c l="nonvat" k="CST" en="Commodity specific tax"/>
    <zv:c l="nonvat" k="CUD" en="Customs duty"/>
    <zv:c l="nonvat" k="CVD" en="Countervailing duty"/>
    <zv:c l="nonvat" k="ENV" en="Environmental tax"/>
    <zv:c l="nonvat" k="EXC" en="Excise duty"/>
    <zv:c l="nonvat" k="EXP" en="Agricultural export rebate"/>
    <zv:c l="nonvat" k="FET" en="Federal excise tax"/>
    <zv:c l="nonvat" k="FRE" en="Free"/>
    <zv:c l="nonvat" k="GCN" en="General construction tax"/>
    <zv:c l="nonvat" k="GST" en="Goods and services tax"/>
    <zv:c l="nonvat" k="ILL" en="Illuminants tax"/>
    <zv:c l="nonvat" k="IMP" en="Import tax"/>
    <zv:c l="nonvat" k="IND" en="Individual tax"/>
    <zv:c l="nonvat" k="LAC" en="Business license fee"/>
    <zv:c l="nonvat" k="LCN" en="Local construction tax"/>
    <zv:c l="nonvat" k="LDP" en="Light dues payable"/>
    <zv:c l="nonvat" k="LOC" en="Local sales tax"/>
    <zv:c l="nonvat" k="LST" en="Lust tax"/>
    <zv:c l="nonvat" k="MCA" en="Monetary compensatory amount"/>
    <zv:c l="nonvat" k="MCD" en="Miscellaneous cash deposit"/>
    <zv:c l="nonvat" k="OTH" en="Other taxes"/>
    <zv:c l="nonvat" k="PDB" en="Provisional duty bond"/>
    <zv:c l="nonvat" k="PDC" en="Provisional duty cash"/>
    <zv:c l="nonvat" k="PRF" en="Preference duty"/>
    <zv:c l="nonvat" k="SCN" en="Special construction tax"/>
    <zv:c l="nonvat" k="SSS" en="Shifted social securities"/>
    <zv:c l="nonvat" k="STT" en="State/provincial sales tax"/>
    <zv:c l="nonvat" k="SUP" en="Suspended duty"/>
    <zv:c l="nonvat" k="SUR" en="Surtax"/>
    <zv:c l="nonvat" k="SWT" en="Shifted wage tax"/>
    <zv:c l="nonvat" k="TAC" en="Alcohol mark tax"/>
    <zv:c l="nonvat" k="TOT" en="Total"/>
    <zv:c l="nonvat" k="TOX" en="Turnover tax"/>
    <zv:c l="nonvat" k="TTA" en="Tonnage taxes"/>
    <zv:c l="nonvat" k="VAD" en="Valuation deposit"/>
    <zv:c l="rec20" k="10" en="group"/>
    <zv:c l="rec20" k="11" en="outfit"/>
    <zv:c l="rec20" k="13" en="ration"/>
    <zv:c l="rec20" k="14" en="shot"/>
    <zv:c l="rec20" k="15" en="stick, military"/>
    <zv:c l="rec20" k="1I" en="fixed rate"/>
    <zv:c l="rec20" k="20" en="twenty foot container"/>
    <zv:c l="rec20" k="21" en="forty foot container"/>
    <zv:c l="rec20" k="22" en="decilitre per gram"/>
    <zv:c l="rec20" k="23" en="gram per cubic centimetre"/>
    <zv:c l="rec20" k="24" en="theoretical pound"/>
    <zv:c l="rec20" k="25" en="gram per square centimetre"/>
    <zv:c l="rec20" k="27" en="theoretical ton"/>
    <zv:c l="rec20" k="28" en="kilogram per square metre"/>
    <zv:c l="rec20" k="2A" en="radian per second"/>
    <zv:c l="rec20" k="2B" en="radian per second squared"/>
    <zv:c l="rec20" k="2C" en="roentgen"/>
    <zv:c l="rec20" k="2G" en="volt AC"/>
    <zv:c l="rec20" k="2H" en="volt DC"/>
    <zv:c l="rec20" k="2I" en="British thermal unit (international table) per hour"/>
    <zv:c l="rec20" k="2J" en="cubic centimetre per second"/>
    <zv:c l="rec20" k="2K" en="cubic foot per hour"/>
    <zv:c l="rec20" k="2L" en="cubic foot per minute"/>
    <zv:c l="rec20" k="2M" en="centimetre per second"/>
    <zv:c l="rec20" k="2N" en="decibel"/>
    <zv:c l="rec20" k="2P" en="kilobyte"/>
    <zv:c l="rec20" k="2Q" en="kilobecquerel"/>
    <zv:c l="rec20" k="2R" en="kilocurie"/>
    <zv:c l="rec20" k="2U" en="megagram"/>
    <zv:c l="rec20" k="2X" en="metre per minute"/>
    <zv:c l="rec20" k="2Y" en="milliroentgen"/>
    <zv:c l="rec20" k="2Z" en="millivolt"/>
    <zv:c l="rec20" k="33" en="kilopascal square metre per gram"/>
    <zv:c l="rec20" k="34" en="kilopascal per millimetre"/>
    <zv:c l="rec20" k="35" en="millilitre per square centimetre second"/>
    <zv:c l="rec20" k="37" en="ounce per square foot"/>
    <zv:c l="rec20" k="38" en="ounce per square foot per 0,01inch"/>
    <zv:c l="rec20" k="3B" en="megajoule"/>
    <zv:c l="rec20" k="3C" en="manmonth"/>
    <zv:c l="rec20" k="40" en="millilitre per second"/>
    <zv:c l="rec20" k="41" en="millilitre per minute"/>
    <zv:c l="rec20" k="4C" en="centistokes"/>
    <zv:c l="rec20" k="4G" en="microlitre"/>
    <zv:c l="rec20" k="4H" en="micrometre (micron)"/>
    <zv:c l="rec20" k="4K" en="milliampere"/>
    <zv:c l="rec20" k="4L" en="megabyte"/>
    <zv:c l="rec20" k="4M" en="milligram per hour"/>
    <zv:c l="rec20" k="4N" en="megabecquerel"/>
    <zv:c l="rec20" k="4O" en="microfarad"/>
    <zv:c l="rec20" k="4P" en="newton per metre"/>
    <zv:c l="rec20" k="4Q" en="ounce inch"/>
    <zv:c l="rec20" k="4R" en="ounce foot"/>
    <zv:c l="rec20" k="4T" en="picofarad"/>
    <zv:c l="rec20" k="4U" en="pound per hour"/>
    <zv:c l="rec20" k="4W" en="ton (US) per hour"/>
    <zv:c l="rec20" k="4X" en="kilolitre per hour"/>
    <zv:c l="rec20" k="56" en="sitas"/>
    <zv:c l="rec20" k="57" en="mesh"/>
    <zv:c l="rec20" k="58" en="net kilogram"/>
    <zv:c l="rec20" k="59" en="part per million"/>
    <zv:c l="rec20" k="5A" en="barrel (US) per minute"/>
    <zv:c l="rec20" k="5B" en="batch"/>
    <zv:c l="rec20" k="5E" en="MMSCF/day"/>
    <zv:c l="rec20" k="5J" en="hydraulic horse power"/>
    <zv:c l="rec20" k="60" en="percent weight"/>
    <zv:c l="rec20" k="61" en="part per billion (US)"/>
    <zv:c l="rec20" k="74" en="millipascal"/>
    <zv:c l="rec20" k="77" en="milli-inch"/>
    <zv:c l="rec20" k="80" en="pound per square inch absolute"/>
    <zv:c l="rec20" k="81" en="henry"/>
    <zv:c l="rec20" k="85" en="foot pound-force"/>
    <zv:c l="rec20" k="87" en="pound per cubic foot"/>
    <zv:c l="rec20" k="89" en="poise"/>
    <zv:c l="rec20" k="91" en="stokes"/>
    <zv:c l="rec20" k="A10" en="ampere square metre per joule second"/>
    <zv:c l="rec20" k="A11" en="angstrom"/>
    <zv:c l="rec20" k="A12" en="astronomical unit"/>
    <zv:c l="rec20" k="A13" en="attojoule"/>
    <zv:c l="rec20" k="A14" en="barn"/>
    <zv:c l="rec20" k="A15" en="barn per electronvolt"/>
    <zv:c l="rec20" k="A16" en="barn per steradian electronvolt"/>
    <zv:c l="rec20" k="A17" en="barn per steradian"/>
    <zv:c l="rec20" k="A18" en="becquerel per kilogram"/>
    <zv:c l="rec20" k="A19" en="becquerel per cubic metre"/>
    <zv:c l="rec20" k="A2" en="ampere per centimetre"/>
    <zv:c l="rec20" k="A20" en="British thermal unit (international table) per second square foot degree Rankine"/>
    <zv:c l="rec20" k="A21" en="British thermal unit (international table) per pound degree Rankine"/>
    <zv:c l="rec20" k="A22" en="British thermal unit (international table) per second foot degree Rankine"/>
    <zv:c l="rec20" k="A23" en="British thermal unit (international table) per hour square foot degree Rankine"/>
    <zv:c l="rec20" k="A24" en="candela per square metre"/>
    <zv:c l="rec20" k="A26" en="coulomb metre"/>
    <zv:c l="rec20" k="A27" en="coulomb metre squared per volt"/>
    <zv:c l="rec20" k="A28" en="coulomb per cubic centimetre"/>
    <zv:c l="rec20" k="A29" en="coulomb per cubic metre"/>
    <zv:c l="rec20" k="A3" en="ampere per millimetre"/>
    <zv:c l="rec20" k="A30" en="coulomb per cubic millimetre"/>
    <zv:c l="rec20" k="A31" en="coulomb per kilogram second"/>
    <zv:c l="rec20" k="A32" en="coulomb per mole"/>
    <zv:c l="rec20" k="A33" en="coulomb per square centimetre"/>
    <zv:c l="rec20" k="A34" en="coulomb per square metre"/>
    <zv:c l="rec20" k="A35" en="coulomb per square millimetre"/>
    <zv:c l="rec20" k="A36" en="cubic centimetre per mole"/>
    <zv:c l="rec20" k="A37" en="cubic decimetre per mole"/>
    <zv:c l="rec20" k="A38" en="cubic metre per coulomb"/>
    <zv:c l="rec20" k="A39" en="cubic metre per kilogram"/>
    <zv:c l="rec20" k="A4" en="ampere per square centimetre"/>
    <zv:c l="rec20" k="A40" en="cubic metre per mole"/>
    <zv:c l="rec20" k="A41" en="ampere per square metre"/>
    <zv:c l="rec20" k="A42" en="curie per kilogram"/>
    <zv:c l="rec20" k="A43" en="deadweight tonnage"/>
    <zv:c l="rec20" k="A44" en="decalitre"/>
    <zv:c l="rec20" k="A45" en="decametre"/>
    <zv:c l="rec20" k="A47" en="decitex"/>
    <zv:c l="rec20" k="A48" en="degree Rankine"/>
    <zv:c l="rec20" k="A49" en="denier"/>
    <zv:c l="rec20" k="A5" en="ampere square metre"/>
    <zv:c l="rec20" k="A53" en="electronvolt"/>
    <zv:c l="rec20" k="A54" en="electronvolt per metre"/>
    <zv:c l="rec20" k="A55" en="electronvolt square metre"/>
    <zv:c l="rec20" k="A56" en="electronvolt square metre per kilogram"/>
    <zv:c l="rec20" k="A59" en="8-part cloud cover"/>
    <zv:c l="rec20" k="A6" en="ampere per square metre kelvin squared"/>
    <zv:c l="rec20" k="A68" en="exajoule"/>
    <zv:c l="rec20" k="A69" en="farad per metre"/>
    <zv:c l="rec20" k="A7" en="ampere per square millimetre"/>
    <zv:c l="rec20" k="A70" en="femtojoule"/>
    <zv:c l="rec20" k="A71" en="femtometre"/>
    <zv:c l="rec20" k="A73" en="foot per second squared"/>
    <zv:c l="rec20" k="A74" en="foot pound-force per second"/>
    <zv:c l="rec20" k="A75" en="freight ton"/>
    <zv:c l="rec20" k="A76" en="gal"/>
    <zv:c l="rec20" k="A8" en="ampere second"/>
    <zv:c l="rec20" k="A84" en="gigacoulomb per cubic metre"/>
    <zv:c l="rec20" k="A85" en="gigaelectronvolt"/>
    <zv:c l="rec20" k="A86" en="gigahertz"/>
    <zv:c l="rec20" k="A87" en="gigaohm"/>
    <zv:c l="rec20" k="A88" en="gigaohm metre"/>
    <zv:c l="rec20" k="A89" en="gigapascal"/>
    <zv:c l="rec20" k="A9" en="rate"/>
    <zv:c l="rec20" k="A90" en="gigawatt"/>
    <zv:c l="rec20" k="A91" en="gon"/>
    <zv:c l="rec20" k="A93" en="gram per cubic metre"/>
    <zv:c l="rec20" k="A94" en="gram per mole"/>
    <zv:c l="rec20" k="A95" en="gray"/>
    <zv:c l="rec20" k="A96" en="gray per second"/>
    <zv:c l="rec20" k="A97" en="hectopascal"/>
    <zv:c l="rec20" k="A98" en="henry per metre"/>
    <zv:c l="rec20" k="A99" en="bit"/>
    <zv:c l="rec20" k="AA" en="ball"/>
    <zv:c l="rec20" k="AB" en="bulk pack"/>
    <zv:c l="rec20" k="ACR" en="acre"/>
    <zv:c l="rec20" k="ACT" en="activity"/>
    <zv:c l="rec20" k="AD" en="byte"/>
    <zv:c l="rec20" k="AE" en="ampere per metre"/>
    <zv:c l="rec20" k="AH" en="additional minute"/>
    <zv:c l="rec20" k="AI" en="average minute per call"/>
    <zv:c l="rec20" k="AK" en="fathom"/>
    <zv:c l="rec20" k="AL" en="access line"/>
    <zv:c l="rec20" k="AMH" en="ampere hour"/>
    <zv:c l="rec20" k="AMP" en="ampere"/>
    <zv:c l="rec20" k="ANN" de="Jahr" en="year" fr="an"/>
    <zv:c l="rec20" k="APZ" en="troy ounce or apothecary ounce"/>
    <zv:c l="rec20" k="AQ" en="anti-hemophilic factor (AHF) unit"/>
    <zv:c l="rec20" k="AS" en="assortment"/>
    <zv:c l="rec20" k="ASM" en="alcoholic strength by mass"/>
    <zv:c l="rec20" k="ASU" en="alcoholic strength by volume"/>
    <zv:c l="rec20" k="ATM" en="standard atmosphere"/>
    <zv:c l="rec20" k="AWG" en="american wire gauge"/>
    <zv:c l="rec20" k="AY" en="assembly"/>
    <zv:c l="rec20" k="AZ" en="British thermal unit (international table) per pound"/>
    <zv:c l="rec20" k="B1" en="barrel (US) per day"/>
    <zv:c l="rec20" k="B10" en="bit per second"/>
    <zv:c l="rec20" k="B11" en="joule per kilogram kelvin"/>
    <zv:c l="rec20" k="B12" en="joule per metre"/>
    <zv:c l="rec20" k="B13" en="joule per square metre"/>
    <zv:c l="rec20" k="B14" en="joule per metre to the fourth power"/>
    <zv:c l="rec20" k="B15" en="joule per mole"/>
    <zv:c l="rec20" k="B16" en="joule per mole kelvin"/>
    <zv:c l="rec20" k="B17" en="credit"/>
    <zv:c l="rec20" k="B18" en="joule second"/>
    <zv:c l="rec20" k="B19" en="digit"/>
    <zv:c l="rec20" k="B20" en="joule square metre per kilogram"/>
    <zv:c l="rec20" k="B21" en="kelvin per watt"/>
    <zv:c l="rec20" k="B22" en="kiloampere"/>
    <zv:c l="rec20" k="B23" en="kiloampere per square metre"/>
    <zv:c l="rec20" k="B24" en="kiloampere per metre"/>
    <zv:c l="rec20" k="B25" en="kilobecquerel per kilogram"/>
    <zv:c l="rec20" k="B26" en="kilocoulomb"/>
    <zv:c l="rec20" k="B27" en="kilocoulomb per cubic metre"/>
    <zv:c l="rec20" k="B28" en="kilocoulomb per square metre"/>
    <zv:c l="rec20" k="B29" en="kiloelectronvolt"/>
    <zv:c l="rec20" k="B3" en="batting pound"/>
    <zv:c l="rec20" k="B30" en="gibibit"/>
    <zv:c l="rec20" k="B31" en="kilogram metre per second"/>
    <zv:c l="rec20" k="B32" en="kilogram metre squared"/>
    <zv:c l="rec20" k="B33" en="kilogram metre squared per second"/>
    <zv:c l="rec20" k="B34" en="kilogram per cubic decimetre"/>
    <zv:c l="rec20" k="B35" en="kilogram per litre"/>
    <zv:c l="rec20" k="B4" en="barrel, imperial"/>
    <zv:c l="rec20" k="B41" en="kilojoule per kelvin"/>
    <zv:c l="rec20" k="B42" en="kilojoule per kilogram"/>
    <zv:c l="rec20" k="B43" en="kilojoule per kilogram kelvin"/>
    <zv:c l="rec20" k="B44" en="kilojoule per mole"/>
    <zv:c l="rec20" k="B45" en="kilomole"/>
    <zv:c l="rec20" k="B46" en="kilomole per cubic metre"/>
    <zv:c l="rec20" k="B47" en="kilonewton"/>
    <zv:c l="rec20" k="B48" en="kilonewton metre"/>
    <zv:c l="rec20" k="B49" en="kiloohm"/>
    <zv:c l="rec20" k="B50" en="kiloohm metre"/>
    <zv:c l="rec20" k="B52" en="kilosecond"/>
    <zv:c l="rec20" k="B53" en="kilosiemens"/>
    <zv:c l="rec20" k="B54" en="kilosiemens per metre"/>
    <zv:c l="rec20" k="B55" en="kilovolt per metre"/>
    <zv:c l="rec20" k="B56" en="kiloweber per metre"/>
    <zv:c l="rec20" k="B57" en="light year"/>
    <zv:c l="rec20" k="B58" en="litre per mole"/>
    <zv:c l="rec20" k="B59" en="lumen hour"/>
    <zv:c l="rec20" k="B60" en="lumen per square metre"/>
    <zv:c l="rec20" k="B61" en="lumen per watt"/>
    <zv:c l="rec20" k="B62" en="lumen second"/>
    <zv:c l="rec20" k="B63" en="lux hour"/>
    <zv:c l="rec20" k="B64" en="lux second"/>
    <zv:c l="rec20" k="B66" en="megaampere per square metre"/>
    <zv:c l="rec20" k="B67" en="megabecquerel per kilogram"/>
    <zv:c l="rec20" k="B68" en="gigabit"/>
    <zv:c l="rec20" k="B69" en="megacoulomb per cubic metre"/>
    <zv:c l="rec20" k="B7" en="cycle"/>
    <zv:c l="rec20" k="B70" en="megacoulomb per square metre"/>
    <zv:c l="rec20" k="B71" en="megaelectronvolt"/>
    <zv:c l="rec20" k="B72" en="megagram per cubic metre"/>
    <zv:c l="rec20" k="B73" en="meganewton"/>
    <zv:c l="rec20" k="B74" en="meganewton metre"/>
    <zv:c l="rec20" k="B75" en="megaohm"/>
    <zv:c l="rec20" k="B76" en="megaohm metre"/>
    <zv:c l="rec20" k="B77" en="megasiemens per metre"/>
    <zv:c l="rec20" k="B78" en="megavolt"/>
    <zv:c l="rec20" k="B79" en="megavolt per metre"/>
    <zv:c l="rec20" k="B8" en="joule per cubic metre"/>
    <zv:c l="rec20" k="B80" en="gigabit per second"/>
    <zv:c l="rec20" k="B81" en="reciprocal metre squared reciprocal second"/>
    <zv:c l="rec20" k="B82" en="inch per linear foot"/>
    <zv:c l="rec20" k="B83" en="metre to the fourth power"/>
    <zv:c l="rec20" k="B84" en="microampere"/>
    <zv:c l="rec20" k="B85" en="microbar"/>
    <zv:c l="rec20" k="B86" en="microcoulomb"/>
    <zv:c l="rec20" k="B87" en="microcoulomb per cubic metre"/>
    <zv:c l="rec20" k="B88" en="microcoulomb per square metre"/>
    <zv:c l="rec20" k="B89" en="microfarad per metre"/>
    <zv:c l="rec20" k="B90" en="microhenry"/>
    <zv:c l="rec20" k="B91" en="microhenry per metre"/>
    <zv:c l="rec20" k="B92" en="micronewton"/>
    <zv:c l="rec20" k="B93" en="micronewton metre"/>
    <zv:c l="rec20" k="B94" en="microohm"/>
    <zv:c l="rec20" k="B95" en="microohm metre"/>
    <zv:c l="rec20" k="B96" en="micropascal"/>
    <zv:c l="rec20" k="B97" en="microradian"/>
    <zv:c l="rec20" k="B98" en="microsecond"/>
    <zv:c l="rec20" k="B99" en="microsiemens"/>
    <zv:c l="rec20" k="BAR" en="bar [unit of pressure]"/>
    <zv:c l="rec20" k="BB" en="base box"/>
    <zv:c l="rec20" k="BFT" en="board foot"/>
    <zv:c l="rec20" k="BHP" en="brake horse power"/>
    <zv:c l="rec20" k="BIL" en="billion (EUR)"/>
    <zv:c l="rec20" k="BLD" en="dry barrel (US)"/>
    <zv:c l="rec20" k="BLL" en="barrel (US)"/>
    <zv:c l="rec20" k="BP" en="hundred board foot"/>
    <zv:c l="rec20" k="BPM" en="beats per minute"/>
    <zv:c l="rec20" k="BQL" en="becquerel"/>
    <zv:c l="rec20" k="BTU" en="British thermal unit (international table)"/>
    <zv:c l="rec20" k="BUA" en="bushel (US)"/>
    <zv:c l="rec20" k="BUI" en="bushel (UK)"/>
    <zv:c l="rec20" k="C0" en="call"/>
    <zv:c l="rec20" k="C10" en="millifarad"/>
    <zv:c l="rec20" k="C11" en="milligal"/>
    <zv:c l="rec20" k="C12" en="milligram per metre"/>
    <zv:c l="rec20" k="C13" en="milligray"/>
    <zv:c l="rec20" k="C14" en="millihenry"/>
    <zv:c l="rec20" k="C15" en="millijoule"/>
    <zv:c l="rec20" k="C16" en="millimetre per second"/>
    <zv:c l="rec20" k="C17" en="millimetre squared per second"/>
    <zv:c l="rec20" k="C18" en="millimole"/>
    <zv:c l="rec20" k="C19" en="mole per kilogram"/>
    <zv:c l="rec20" k="C20" en="millinewton"/>
    <zv:c l="rec20" k="C21" en="kibibit"/>
    <zv:c l="rec20" k="C22" en="millinewton per metre"/>
    <zv:c l="rec20" k="C23" en="milliohm metre"/>
    <zv:c l="rec20" k="C24" en="millipascal second"/>
    <zv:c l="rec20" k="C25" en="milliradian"/>
    <zv:c l="rec20" k="C26" en="millisecond"/>
    <zv:c l="rec20" k="C27" en="millisiemens"/>
    <zv:c l="rec20" k="C28" en="millisievert"/>
    <zv:c l="rec20" k="C29" en="millitesla"/>
    <zv:c l="rec20" k="C3" en="microvolt per metre"/>
    <zv:c l="rec20" k="C30" en="millivolt per metre"/>
    <zv:c l="rec20" k="C31" en="milliwatt"/>
    <zv:c l="rec20" k="C32" en="milliwatt per square metre"/>
    <zv:c l="rec20" k="C33" en="milliweber"/>
    <zv:c l="rec20" k="C34" en="mole"/>
    <zv:c l="rec20" k="C35" en="mole per cubic decimetre"/>
    <zv:c l="rec20" k="C36" en="mole per cubic metre"/>
    <zv:c l="rec20" k="C37" en="kilobit"/>
    <zv:c l="rec20" k="C38" en="mole per litre"/>
    <zv:c l="rec20" k="C39" en="nanoampere"/>
    <zv:c l="rec20" k="C40" en="nanocoulomb"/>
    <zv:c l="rec20" k="C41" en="nanofarad"/>
    <zv:c l="rec20" k="C42" en="nanofarad per metre"/>
    <zv:c l="rec20" k="C43" en="nanohenry"/>
    <zv:c l="rec20" k="C44" en="nanohenry per metre"/>
    <zv:c l="rec20" k="C45" en="nanometre"/>
    <zv:c l="rec20" k="C46" en="nanoohm metre"/>
    <zv:c l="rec20" k="C47" en="nanosecond"/>
    <zv:c l="rec20" k="C48" en="nanotesla"/>
    <zv:c l="rec20" k="C49" en="nanowatt"/>
    <zv:c l="rec20" k="C50" en="neper"/>
    <zv:c l="rec20" k="C51" en="neper per second"/>
    <zv:c l="rec20" k="C52" en="picometre"/>
    <zv:c l="rec20" k="C53" en="newton metre second"/>
    <zv:c l="rec20" k="C54" en="newton metre squared per kilogram squared"/>
    <zv:c l="rec20" k="C55" en="newton per square metre"/>
    <zv:c l="rec20" k="C56" en="newton per square millimetre"/>
    <zv:c l="rec20" k="C57" en="newton second"/>
    <zv:c l="rec20" k="C58" en="newton second per metre"/>
    <zv:c l="rec20" k="C59" en="octave"/>
    <zv:c l="rec20" k="C60" en="ohm centimetre"/>
    <zv:c l="rec20" k="C61" en="ohm metre"/>
    <zv:c l="rec20" k="C62" de="Stück" en="unit" fr="unité"/>
    <zv:c l="rec20" k="C63" en="parsec"/>
    <zv:c l="rec20" k="C64" en="pascal per kelvin"/>
    <zv:c l="rec20" k="C65" en="pascal second"/>
    <zv:c l="rec20" k="C66" en="pascal second per cubic metre"/>
    <zv:c l="rec20" k="C67" en="pascal second per metre"/>
    <zv:c l="rec20" k="C68" en="petajoule"/>
    <zv:c l="rec20" k="C69" en="phon"/>
    <zv:c l="rec20" k="C7" en="centipoise"/>
    <zv:c l="rec20" k="C70" en="picoampere"/>
    <zv:c l="rec20" k="C71" en="picocoulomb"/>
    <zv:c l="rec20" k="C72" en="picofarad per metre"/>
    <zv:c l="rec20" k="C73" en="picohenry"/>
    <zv:c l="rec20" k="C74" en="kilobit per second"/>
    <zv:c l="rec20" k="C75" en="picowatt"/>
    <zv:c l="rec20" k="C76" en="picowatt per square metre"/>
    <zv:c l="rec20" k="C78" en="pound-force"/>
    <zv:c l="rec20" k="C79" en="kilovolt ampere hour"/>
    <zv:c l="rec20" k="C8" en="millicoulomb per kilogram"/>
    <zv:c l="rec20" k="C80" en="rad"/>
    <zv:c l="rec20" k="C81" en="radian"/>
    <zv:c l="rec20" k="C82" en="radian square metre per mole"/>
    <zv:c l="rec20" k="C83" en="radian square metre per kilogram"/>
    <zv:c l="rec20" k="C84" en="radian per metre"/>
    <zv:c l="rec20" k="C85" en="reciprocal angstrom"/>
    <zv:c l="rec20" k="C86" en="reciprocal cubic metre"/>
    <zv:c l="rec20" k="C87" en="reciprocal cubic metre per second"/>
    <zv:c l="rec20" k="C88" en="reciprocal electron volt per cubic metre"/>
    <zv:c l="rec20" k="C89" en="reciprocal henry"/>
    <zv:c l="rec20" k="C9" en="coil group"/>
    <zv:c l="rec20" k="C90" en="reciprocal joule per cubic metre"/>
    <zv:c l="rec20" k="C91" en="reciprocal kelvin or kelvin to the power minus one"/>
    <zv:c l="rec20" k="C92" en="reciprocal metre"/>
    <zv:c l="rec20" k="C93" en="reciprocal square metre"/>
    <zv:c l="rec20" k="C94" en="reciprocal minute"/>
    <zv:c l="rec20" k="C95" en="reciprocal mole"/>
    <zv:c l="rec20" k="C96" en="reciprocal pascal or pascal to the power minus one"/>
    <zv:c l="rec20" k="C97" en="reciprocal second"/>
    <zv:c l="rec20" k="C99" en="reciprocal second per metre squared"/>
    <zv:c l="rec20" k="CCT" en="carrying capacity in metric ton"/>
    <zv:c l="rec20" k="CDL" en="candela"/>
    <zv:c l="rec20" k="CEL" en="degree Celsius"/>
    <zv:c l="rec20" k="CEN" en="hundred"/>
    <zv:c l="rec20" k="CG" en="card"/>
    <zv:c l="rec20" k="CGM" en="centigram"/>
    <zv:c l="rec20" k="CKG" en="coulomb per kilogram"/>
    <zv:c l="rec20" k="CLF" en="hundred leave"/>
    <zv:c l="rec20" k="CLT" en="centilitre"/>
    <zv:c l="rec20" k="CMK" en="square centimetre"/>
    <zv:c l="rec20" k="CMQ" en="cubic centimetre"/>
    <zv:c l="rec20" k="CMT" de="cm" en="cm" fr="cm"/>
    <zv:c l="rec20" k="CNP" en="hundred pack"/>
    <zv:c l="rec20" k="CNT" en="cental (UK)"/>
    <zv:c l="rec20" k="COU" en="coulomb"/>
    <zv:c l="rec20" k="CTG" en="content gram"/>
    <zv:c l="rec20" k="CTM" en="metric carat"/>
    <zv:c l="rec20" k="CTN" en="content ton (metric)"/>
    <zv:c l="rec20" k="CUR" en="curie"/>
    <zv:c l="rec20" k="CWA" en="hundred pound (cwt) / hundred weight (US)"/>
    <zv:c l="rec20" k="CWI" en="hundred weight (UK)"/>
    <zv:c l="rec20" k="D03" en="kilowatt hour per hour"/>
    <zv:c l="rec20" k="D04" en="lot [unit of weight]"/>
    <zv:c l="rec20" k="D1" en="reciprocal second per steradian"/>
    <zv:c l="rec20" k="D10" en="siemens per metre"/>
    <zv:c l="rec20" k="D11" en="mebibit"/>
    <zv:c l="rec20" k="D12" en="siemens square metre per mole"/>
    <zv:c l="rec20" k="D13" en="sievert"/>
    <zv:c l="rec20" k="D15" en="sone"/>
    <zv:c l="rec20" k="D16" en="square centimetre per erg"/>
    <zv:c l="rec20" k="D17" en="square centimetre per steradian erg"/>
    <zv:c l="rec20" k="D18" en="metre kelvin"/>
    <zv:c l="rec20" k="D19" en="square metre kelvin per watt"/>
    <zv:c l="rec20" k="D2" en="reciprocal second per steradian metre squared"/>
    <zv:c l="rec20" k="D20" en="square metre per joule"/>
    <zv:c l="rec20" k="D21" en="square metre per kilogram"/>
    <zv:c l="rec20" k="D22" en="square metre per mole"/>
    <zv:c l="rec20" k="D23" en="pen gram (protein)"/>
    <zv:c l="rec20" k="D24" en="square metre per steradian"/>
    <zv:c l="rec20" k="D25" en="square metre per steradian joule"/>
    <zv:c l="rec20" k="D26" en="square metre per volt second"/>
    <zv:c l="rec20" k="D27" en="steradian"/>
    <zv:c l="rec20" k="D29" en="terahertz"/>
    <zv:c l="rec20" k="D30" en="terajoule"/>
    <zv:c l="rec20" k="D31" en="terawatt"/>
    <zv:c l="rec20" k="D32" en="terawatt hour"/>
    <zv:c l="rec20" k="D33" en="tesla"/>
    <zv:c l="rec20" k="D34" en="tex"/>
    <zv:c l="rec20" k="D36" en="megabit"/>
    <zv:c l="rec20" k="D41" en="tonne per cubic metre"/>
    <zv:c l="rec20" k="D42" en="tropical year"/>
    <zv:c l="rec20" k="D43" en="unified atomic mass unit"/>
    <zv:c l="rec20" k="D44" en="var"/>
    <zv:c l="rec20" k="D45" en="volt squared per kelvin squared"/>
    <zv:c l="rec20" k="D46" en="volt - ampere"/>
    <zv:c l="rec20" k="D47" en="volt per centimetre"/>
    <zv:c l="rec20" k="D48" en="volt per kelvin"/>
    <zv:c l="rec20" k="D49" en="millivolt per kelvin"/>
    <zv:c l="rec20" k="D5" en="kilogram per square centimetre"/>
    <zv:c l="rec20" k="D50" en="volt per metre"/>
    <zv:c l="rec20" k="D51" en="volt per millimetre"/>
    <zv:c l="rec20" k="D52" en="watt per kelvin"/>
    <zv:c l="rec20" k="D53" en="watt per metre kelvin"/>
    <zv:c l="rec20" k="D54" en="watt per square metre"/>
    <zv:c l="rec20" k="D55" en="watt per square metre kelvin"/>
    <zv:c l="rec20" k="D56" en="watt per square metre kelvin to the fourth power"/>
    <zv:c l="rec20" k="D57" en="watt per steradian"/>
    <zv:c l="rec20" k="D58" en="watt per steradian square metre"/>
    <zv:c l="rec20" k="D59" en="weber per metre"/>
    <zv:c l="rec20" k="D6" en="roentgen per second"/>
    <zv:c l="rec20" k="D60" en="weber per millimetre"/>
    <zv:c l="rec20" k="D61" en="minute [unit of angle]"/>
    <zv:c l="rec20" k="D62" en="second [unit of angle]"/>
    <zv:c l="rec20" k="D63" de="Buch" en="book" fr="livre"/>
    <zv:c l="rec20" k="D65" en="round"/>
    <zv:c l="rec20" k="D68" en="number of words"/>
    <zv:c l="rec20" k="D69" en="inch to the fourth power"/>
    <zv:c l="rec20" k="D73" en="joule square metre"/>
    <zv:c l="rec20" k="D74" en="kilogram per mole"/>
    <zv:c l="rec20" k="D77" en="megacoulomb"/>
    <zv:c l="rec20" k="D78" en="megajoule per second"/>
    <zv:c l="rec20" k="D80" en="microwatt"/>
    <zv:c l="rec20" k="D81" en="microtesla"/>
    <zv:c l="rec20" k="D82" en="microvolt"/>
    <zv:c l="rec20" k="D83" en="millinewton metre"/>
    <zv:c l="rec20" k="D85" en="microwatt per square metre"/>
    <zv:c l="rec20" k="D86" en="millicoulomb"/>
    <zv:c l="rec20" k="D87" en="millimole per kilogram"/>
    <zv:c l="rec20" k="D88" en="millicoulomb per cubic metre"/>
    <zv:c l="rec20" k="D89" en="millicoulomb per square metre"/>
    <zv:c l="rec20" k="D91" en="rem"/>
    <zv:c l="rec20" k="D93" en="second per cubic metre"/>
    <zv:c l="rec20" k="D94" en="second per cubic metre radian"/>
    <zv:c l="rec20" k="D95" en="joule per gram"/>
    <zv:c l="rec20" k="DAA" en="decare"/>
    <zv:c l="rec20" k="DAD" en="ten day"/>
    <zv:c l="rec20" k="DAY" de="Tag" en="day" fr="jour"/>
    <zv:c l="rec20" k="DB" en="dry pound"/>
    <zv:c l="rec20" k="DBM" en="Decibel-milliwatts"/>
    <zv:c l="rec20" k="DBW" en="Decibel watt"/>
    <zv:c l="rec20" k="DD" en="degree [unit of angle]"/>
    <zv:c l="rec20" k="DEC" en="decade"/>
    <zv:c l="rec20" k="DG" en="decigram"/>
    <zv:c l="rec20" k="DJ" en="decagram"/>
    <zv:c l="rec20" k="DLT" en="decilitre"/>
    <zv:c l="rec20" k="DMA" en="cubic decametre"/>
    <zv:c l="rec20" k="DMK" en="square decimetre"/>
    <zv:c l="rec20" k="DMO" en="standard kilolitre"/>
    <zv:c l="rec20" k="DMQ" en="cubic decimetre"/>
    <zv:c l="rec20" k="DMT" en="decimetre"/>
    <zv:c l="rec20" k="DN" en="decinewton metre"/>
    <zv:c l="rec20" k="DPC" en="dozen piece"/>
    <zv:c l="rec20" k="DPR" en="dozen pair"/>
    <zv:c l="rec20" k="DPT" en="displacement tonnage"/>
    <zv:c l="rec20" k="DRA" en="dram (US)"/>
    <zv:c l="rec20" k="DRI" en="dram (UK)"/>
    <zv:c l="rec20" k="DRL" en="dozen roll"/>
    <zv:c l="rec20" k="DT" en="dry ton"/>
    <zv:c l="rec20" k="DTN" en="decitonne"/>
    <zv:c l="rec20" k="DWT" en="pennyweight"/>
    <zv:c l="rec20" k="DZN" en="dozen"/>
    <zv:c l="rec20" k="DZP" en="dozen pack"/>
    <zv:c l="rec20" k="E01" en="newton per square centimetre"/>
    <zv:c l="rec20" k="E07" en="megawatt hour per hour"/>
    <zv:c l="rec20" k="E08" en="megawatt per hertz"/>
    <zv:c l="rec20" k="E09" en="milliampere hour"/>
    <zv:c l="rec20" k="E10" en="degree day"/>
    <zv:c l="rec20" k="E12" en="mille"/>
    <zv:c l="rec20" k="E14" en="kilocalorie (international table)"/>
    <zv:c l="rec20" k="E15" en="kilocalorie (thermochemical) per hour"/>
    <zv:c l="rec20" k="E16" en="million Btu(IT) per hour"/>
    <zv:c l="rec20" k="E17" en="cubic foot per second"/>
    <zv:c l="rec20" k="E18" en="tonne per hour"/>
    <zv:c l="rec20" k="E19" en="ping"/>
    <zv:c l="rec20" k="E20" en="megabit per second"/>
    <zv:c l="rec20" k="E21" en="shares"/>
    <zv:c l="rec20" k="E22" en="TEU"/>
    <zv:c l="rec20" k="E23" en="tyre"/>
    <zv:c l="rec20" k="E25" en="active unit"/>
    <zv:c l="rec20" k="E27" en="dose"/>
    <zv:c l="rec20" k="E28" en="air dry ton"/>
    <zv:c l="rec20" k="E30" en="strand"/>
    <zv:c l="rec20" k="E31" en="square metre per litre"/>
    <zv:c l="rec20" k="E32" en="litre per hour"/>
    <zv:c l="rec20" k="E33" en="foot per thousand"/>
    <zv:c l="rec20" k="E34" en="gigabyte"/>
    <zv:c l="rec20" k="E35" en="terabyte"/>
    <zv:c l="rec20" k="E36" en="petabyte"/>
    <zv:c l="rec20" k="E37" en="pixel"/>
    <zv:c l="rec20" k="E38" en="megapixel"/>
    <zv:c l="rec20" k="E39" en="dots per inch"/>
    <zv:c l="rec20" k="E4" en="gross kilogram"/>
    <zv:c l="rec20" k="E40" en="part per hundred thousand"/>
    <zv:c l="rec20" k="E41" en="kilogram-force per square millimetre"/>
    <zv:c l="rec20" k="E42" en="kilogram-force per square centimetre"/>
    <zv:c l="rec20" k="E43" en="joule per square centimetre"/>
    <zv:c l="rec20" k="E44" en="kilogram-force metre per square centimetre"/>
    <zv:c l="rec20" k="E45" en="milliohm"/>
    <zv:c l="rec20" k="E46" en="kilowatt hour per cubic metre"/>
    <zv:c l="rec20" k="E47" en="kilowatt hour per kelvin"/>
    <zv:c l="rec20" k="E48" de="Serviceeinheit" en="service unit" fr="unité de service"/>
    <zv:c l="rec20" k="E49" en="working day"/>
    <zv:c l="rec20" k="E50" en="accounting unit"/>
    <zv:c l="rec20" k="E51" en="job"/>
    <zv:c l="rec20" k="E52" en="run foot"/>
    <zv:c l="rec20" k="E53" en="test"/>
    <zv:c l="rec20" k="E54" en="trip"/>
    <zv:c l="rec20" k="E55" en="use"/>
    <zv:c l="rec20" k="E56" en="well"/>
    <zv:c l="rec20" k="E57" en="zone"/>
    <zv:c l="rec20" k="E58" en="exabit per second"/>
    <zv:c l="rec20" k="E59" en="exbibyte"/>
    <zv:c l="rec20" k="E60" en="pebibyte"/>
    <zv:c l="rec20" k="E61" en="tebibyte"/>
    <zv:c l="rec20" k="E62" en="gibibyte"/>
    <zv:c l="rec20" k="E63" en="mebibyte"/>
    <zv:c l="rec20" k="E64" en="kibibyte"/>
    <zv:c l="rec20" k="E65" en="exbibit per metre"/>
    <zv:c l="rec20" k="E66" en="exbibit per square metre"/>
    <zv:c l="rec20" k="E67" en="exbibit per cubic metre"/>
    <zv:c l="rec20" k="E68" en="gigabyte per second"/>
    <zv:c l="rec20" k="E69" en="gibibit per metre"/>
    <zv:c l="rec20" k="E70" en="gibibit per square metre"/>
    <zv:c l="rec20" k="E71" en="gibibit per cubic metre"/>
    <zv:c l="rec20" k="E72" en="kibibit per metre"/>
    <zv:c l="rec20" k="E73" en="kibibit per square metre"/>
    <zv:c l="rec20" k="E74" en="kibibit per cubic metre"/>
    <zv:c l="rec20" k="E75" en="mebibit per metre"/>
    <zv:c l="rec20" k="E76" en="mebibit per square metre"/>
    <zv:c l="rec20" k="E77" en="mebibit per cubic metre"/>
    <zv:c l="rec20" k="E78" en="petabit"/>
    <zv:c l="rec20" k="E79" en="petabit per second"/>
    <zv:c l="rec20" k="E80" en="pebibit per metre"/>
    <zv:c l="rec20" k="E81" en="pebibit per square metre"/>
    <zv:c l="rec20" k="E82" en="pebibit per cubic metre"/>
    <zv:c l="rec20" k="E83" en="terabit"/>
    <zv:c l="rec20" k="E84" en="terabit per second"/>
    <zv:c l="rec20" k="E85" en="tebibit per metre"/>
    <zv:c l="rec20" k="E86" en="tebibit per cubic metre"/>
    <zv:c l="rec20" k="E87" en="tebibit per square metre"/>
    <zv:c l="rec20" k="E88" en="bit per metre"/>
    <zv:c l="rec20" k="E89" en="bit per square metre"/>
    <zv:c l="rec20" k="E90" en="reciprocal centimetre"/>
    <zv:c l="rec20" k="E91" en="reciprocal day"/>
    <zv:c l="rec20" k="E92" en="cubic decimetre per hour"/>
    <zv:c l="rec20" k="E93" en="kilogram per hour"/>
    <zv:c l="rec20" k="E94" en="kilomole per second"/>
    <zv:c l="rec20" k="E95" en="mole per second"/>
    <zv:c l="rec20" k="E96" en="degree per second"/>
    <zv:c l="rec20" k="E97" en="millimetre per degree Celcius metre"/>
    <zv:c l="rec20" k="E98" en="degree Celsius per kelvin"/>
    <zv:c l="rec20" k="E99" en="hectopascal per bar"/>
    <zv:c l="rec20" k="EA" de="Stück" en="each" fr="unité"/>
    <zv:c l="rec20" k="EB" en="electronic mail box"/>
    <zv:c l="rec20" k="EQ" en="equivalent gallon"/>
    <zv:c l="rec20" k="F01" en="bit per cubic metre"/>
    <zv:c l="rec20" k="F02" en="kelvin per kelvin"/>
    <zv:c l="rec20" k="F03" en="kilopascal per bar"/>
    <zv:c l="rec20" k="F04" en="millibar per bar"/>
    <zv:c l="rec20" k="F05" en="megapascal per bar"/>
    <zv:c l="rec20" k="F06" en="poise per bar"/>
    <zv:c l="rec20" k="F07" en="pascal per bar"/>
    <zv:c l="rec20" k="F08" en="milliampere per inch"/>
    <zv:c l="rec20" k="F10" en="kelvin per hour"/>
    <zv:c l="rec20" k="F11" en="kelvin per minute"/>
    <zv:c l="rec20" k="F12" en="kelvin per second"/>
    <zv:c l="rec20" k="F13" en="slug"/>
    <zv:c l="rec20" k="F14" en="gram per kelvin"/>
    <zv:c l="rec20" k="F15" en="kilogram per kelvin"/>
    <zv:c l="rec20" k="F16" en="milligram per kelvin"/>
    <zv:c l="rec20" k="F17" en="pound-force per foot"/>
    <zv:c l="rec20" k="F18" en="kilogram square centimetre"/>
    <zv:c l="rec20" k="F19" en="kilogram square millimetre"/>
    <zv:c l="rec20" k="F20" en="pound inch squared"/>
    <zv:c l="rec20" k="F21" en="pound-force inch"/>
    <zv:c l="rec20" k="F22" en="pound-force foot per ampere"/>
    <zv:c l="rec20" k="F23" en="gram per cubic decimetre"/>
    <zv:c l="rec20" k="F24" en="kilogram per kilomol"/>
    <zv:c l="rec20" k="F25" en="gram per hertz"/>
    <zv:c l="rec20" k="F26" en="gram per day"/>
    <zv:c l="rec20" k="F27" en="gram per hour"/>
    <zv:c l="rec20" k="F28" en="gram per minute"/>
    <zv:c l="rec20" k="F29" en="gram per second"/>
    <zv:c l="rec20" k="F30" en="kilogram per day"/>
    <zv:c l="rec20" k="F31" en="kilogram per minute"/>
    <zv:c l="rec20" k="F32" en="milligram per day"/>
    <zv:c l="rec20" k="F33" en="milligram per minute"/>
    <zv:c l="rec20" k="F34" en="milligram per second"/>
    <zv:c l="rec20" k="F35" en="gram per day kelvin"/>
    <zv:c l="rec20" k="F36" en="gram per hour kelvin"/>
    <zv:c l="rec20" k="F37" en="gram per minute kelvin"/>
    <zv:c l="rec20" k="F38" en="gram per second kelvin"/>
    <zv:c l="rec20" k="F39" en="kilogram per day kelvin"/>
    <zv:c l="rec20" k="F40" en="kilogram per hour kelvin"/>
    <zv:c l="rec20" k="F41" en="kilogram per minute kelvin"/>
    <zv:c l="rec20" k="F42" en="kilogram per second kelvin"/>
    <zv:c l="rec20" k="F43" en="milligram per day kelvin"/>
    <zv:c l="rec20" k="F44" en="milligram per hour kelvin"/>
    <zv:c l="rec20" k="F45" en="milligram per minute kelvin"/>
    <zv:c l="rec20" k="F46" en="milligram per second kelvin"/>
    <zv:c l="rec20" k="F47" en="newton per millimetre"/>
    <zv:c l="rec20" k="F48" en="pound-force per inch"/>
    <zv:c l="rec20" k="F49" en="rod [unit of distance]"/>
    <zv:c l="rec20" k="F50" en="micrometre per kelvin"/>
    <zv:c l="rec20" k="F51" en="centimetre per kelvin"/>
    <zv:c l="rec20" k="F52" en="metre per kelvin"/>
    <zv:c l="rec20" k="F53" en="millimetre per kelvin"/>
    <zv:c l="rec20" k="F54" en="milliohm per metre"/>
    <zv:c l="rec20" k="F55" en="ohm per mile (statute mile)"/>
    <zv:c l="rec20" k="F56" en="ohm per kilometre"/>
    <zv:c l="rec20" k="F57" en="milliampere per pound-force per square inch"/>
    <zv:c l="rec20" k="F58" en="reciprocal bar"/>
    <zv:c l="rec20" k="F59" en="milliampere per bar"/>
    <zv:c l="rec20" k="F60" en="degree Celsius per bar"/>
    <zv:c l="rec20" k="F61" en="kelvin per bar"/>
    <zv:c l="rec20" k="F62" en="gram per day bar"/>
    <zv:c l="rec20" k="F63" en="gram per hour bar"/>
    <zv:c l="rec20" k="F64" en="gram per minute bar"/>
    <zv:c l="rec20" k="F65" en="gram per second bar"/>
    <zv:c l="rec20" k="F66" en="kilogram per day bar"/>
    <zv:c l="rec20" k="F67" en="kilogram per hour bar"/>
    <zv:c l="rec20" k="F68" en="kilogram per minute bar"/>
    <zv:c l="rec20" k="F69" en="kilogram per second bar"/>
    <zv:c l="rec20" k="F70" en="milligram per day bar"/>
    <zv:c l="rec20" k="F71" en="milligram per hour bar"/>
    <zv:c l="rec20" k="F72" en="milligram per minute bar"/>
    <zv:c l="rec20" k="F73" en="milligram per second bar"/>
    <zv:c l="rec20" k="F74" en="gram per bar"/>
    <zv:c l="rec20" k="F75" en="milligram per bar"/>
    <zv:c l="rec20" k="F76" en="milliampere per millimetre"/>
    <zv:c l="rec20" k="F77" en="pascal second per kelvin"/>
    <zv:c l="rec20" k="F78" en="inch of water"/>
    <zv:c l="rec20" k="F79" en="inch of mercury"/>
    <zv:c l="rec20" k="F80" en="water horse power"/>
    <zv:c l="rec20" k="F81" en="bar per kelvin"/>
    <zv:c l="rec20" k="F82" en="hectopascal per kelvin"/>
    <zv:c l="rec20" k="F83" en="kilopascal per kelvin"/>
    <zv:c l="rec20" k="F84" en="millibar per kelvin"/>
    <zv:c l="rec20" k="F85" en="megapascal per kelvin"/>
    <zv:c l="rec20" k="F86" en="poise per kelvin"/>
    <zv:c l="rec20" k="F87" en="volt per litre minute"/>
    <zv:c l="rec20" k="F88" en="newton centimetre"/>
    <zv:c l="rec20" k="F89" en="newton metre per degree"/>
    <zv:c l="rec20" k="F90" en="newton metre per ampere"/>
    <zv:c l="rec20" k="F91" en="bar litre per second"/>
    <zv:c l="rec20" k="F92" en="bar cubic metre per second"/>
    <zv:c l="rec20" k="F93" en="hectopascal litre per second"/>
    <zv:c l="rec20" k="F94" en="hectopascal cubic metre per second"/>
    <zv:c l="rec20" k="F95" en="millibar litre per second"/>
    <zv:c l="rec20" k="F96" en="millibar cubic metre per second"/>
    <zv:c l="rec20" k="F97" en="megapascal litre per second"/>
    <zv:c l="rec20" k="F98" en="megapascal cubic metre per second"/>
    <zv:c l="rec20" k="F99" en="pascal litre per second"/>
    <zv:c l="rec20" k="FAH" en="degree Fahrenheit"/>
    <zv:c l="rec20" k="FAR" en="farad"/>
    <zv:c l="rec20" k="FBM" en="fibre metre"/>
    <zv:c l="rec20" k="FC" en="thousand cubic foot"/>
    <zv:c l="rec20" k="FF" en="hundred cubic metre"/>
    <zv:c l="rec20" k="FH" en="micromole"/>
    <zv:c l="rec20" k="FIT" en="failures in time"/>
    <zv:c l="rec20" k="FL" en="flake ton"/>
    <zv:c l="rec20" k="FNU" en="Formazin nephelometric unit"/>
    <zv:c l="rec20" k="FOT" en="foot"/>
    <zv:c l="rec20" k="FP" en="pound per square foot"/>
    <zv:c l="rec20" k="FR" en="foot per minute"/>
    <zv:c l="rec20" k="FS" en="foot per second"/>
    <zv:c l="rec20" k="FTK" en="square foot"/>
    <zv:c l="rec20" k="FTQ" en="cubic foot"/>
    <zv:c l="rec20" k="G01" en="pascal cubic metre per second"/>
    <zv:c l="rec20" k="G04" en="centimetre per bar"/>
    <zv:c l="rec20" k="G05" en="metre per bar"/>
    <zv:c l="rec20" k="G06" en="millimetre per bar"/>
    <zv:c l="rec20" k="G08" en="square inch per second"/>
    <zv:c l="rec20" k="G09" en="square metre per second kelvin"/>
    <zv:c l="rec20" k="G10" en="stokes per kelvin"/>
    <zv:c l="rec20" k="G11" en="gram per cubic centimetre bar"/>
    <zv:c l="rec20" k="G12" en="gram per cubic decimetre bar"/>
    <zv:c l="rec20" k="G13" en="gram per litre bar"/>
    <zv:c l="rec20" k="G14" en="gram per cubic metre bar"/>
    <zv:c l="rec20" k="G15" en="gram per millilitre bar"/>
    <zv:c l="rec20" k="G16" en="kilogram per cubic centimetre bar"/>
    <zv:c l="rec20" k="G17" en="kilogram per litre bar"/>
    <zv:c l="rec20" k="G18" en="kilogram per cubic metre bar"/>
    <zv:c l="rec20" k="G19" en="newton metre per kilogram"/>
    <zv:c l="rec20" k="G2" en="US gallon per minute"/>
    <zv:c l="rec20" k="G20" en="pound-force foot per pound"/>
    <zv:c l="rec20" k="G21" en="cup [unit of volume]"/>
    <zv:c l="rec20" k="G23" en="peck"/>
    <zv:c l="rec20" k="G24" en="tablespoon (US)"/>
    <zv:c l="rec20" k="G25" en="teaspoon (US)"/>
    <zv:c l="rec20" k="G26" en="stere"/>
    <zv:c l="rec20" k="G27" en="cubic centimetre per kelvin"/>
    <zv:c l="rec20" k="G28" en="litre per kelvin"/>
    <zv:c l="rec20" k="G29" en="cubic metre per kelvin"/>
    <zv:c l="rec20" k="G3" en="Imperial gallon per minute"/>
    <zv:c l="rec20" k="G30" en="millilitre per kelvin"/>
    <zv:c l="rec20" k="G31" en="kilogram per cubic centimetre"/>
    <zv:c l="rec20" k="G32" en="ounce (avoirdupois) per cubic yard"/>
    <zv:c l="rec20" k="G33" en="gram per cubic centimetre kelvin"/>
    <zv:c l="rec20" k="G34" en="gram per cubic decimetre kelvin"/>
    <zv:c l="rec20" k="G35" en="gram per litre kelvin"/>
    <zv:c l="rec20" k="G36" en="gram per cubic metre kelvin"/>
    <zv:c l="rec20" k="G37" en="gram per millilitre kelvin"/>
    <zv:c l="rec20" k="G38" en="kilogram per cubic centimetre kelvin"/>
    <zv:c l="rec20" k="G39" en="kilogram per litre kelvin"/>
    <zv:c l="rec20" k="G40" en="kilogram per cubic metre kelvin"/>
    <zv:c l="rec20" k="G41" en="square metre per second bar"/>
    <zv:c l="rec20" k="G42" en="microsiemens per centimetre"/>
    <zv:c l="rec20" k="G43" en="microsiemens per metre"/>
    <zv:c l="rec20" k="G44" en="nanosiemens per centimetre"/>
    <zv:c l="rec20" k="G45" en="nanosiemens per metre"/>
    <zv:c l="rec20" k="G46" en="stokes per bar"/>
    <zv:c l="rec20" k="G47" en="cubic centimetre per day"/>
    <zv:c l="rec20" k="G48" en="cubic centimetre per hour"/>
    <zv:c l="rec20" k="G49" en="cubic centimetre per minute"/>
    <zv:c l="rec20" k="G50" en="gallon (US) per hour"/>
    <zv:c l="rec20" k="G51" en="litre per second"/>
    <zv:c l="rec20" k="G52" en="cubic metre per day"/>
    <zv:c l="rec20" k="G53" en="cubic metre per minute"/>
    <zv:c l="rec20" k="G54" en="millilitre per day"/>
    <zv:c l="rec20" k="G55" en="millilitre per hour"/>
    <zv:c l="rec20" k="G56" en="cubic inch per hour"/>
    <zv:c l="rec20" k="G57" en="cubic inch per minute"/>
    <zv:c l="rec20" k="G58" en="cubic inch per second"/>
    <zv:c l="rec20" k="G59" en="milliampere per litre minute"/>
    <zv:c l="rec20" k="G60" en="volt per bar"/>
    <zv:c l="rec20" k="G61" en="cubic centimetre per day kelvin"/>
    <zv:c l="rec20" k="G62" en="cubic centimetre per hour kelvin"/>
    <zv:c l="rec20" k="G63" en="cubic centimetre per minute kelvin"/>
    <zv:c l="rec20" k="G64" en="cubic centimetre per second kelvin"/>
    <zv:c l="rec20" k="G65" en="litre per day kelvin"/>
    <zv:c l="rec20" k="G66" en="litre per hour kelvin"/>
    <zv:c l="rec20" k="G67" en="litre per minute kelvin"/>
    <zv:c l="rec20" k="G68" en="litre per second kelvin"/>
    <zv:c l="rec20" k="G69" en="cubic metre per day kelvin"/>
    <zv:c l="rec20" k="G70" en="cubic metre per hour kelvin"/>
    <zv:c l="rec20" k="G71" en="cubic metre per minute kelvin"/>
    <zv:c l="rec20" k="G72" en="cubic metre per second kelvin"/>
    <zv:c l="rec20" k="G73" en="millilitre per day kelvin"/>
    <zv:c l="rec20" k="G74" en="millilitre per hour kelvin"/>
    <zv:c l="rec20" k="G75" en="millilitre per minute kelvin"/>
    <zv:c l="rec20" k="G76" en="millilitre per second kelvin"/>
    <zv:c l="rec20" k="G77" en="millimetre to the fourth power"/>
    <zv:c l="rec20" k="G78" en="cubic centimetre per day bar"/>
    <zv:c l="rec20" k="G79" en="cubic centimetre per hour bar"/>
    <zv:c l="rec20" k="G80" en="cubic centimetre per minute bar"/>
    <zv:c l="rec20" k="G81" en="cubic centimetre per second bar"/>
    <zv:c l="rec20" k="G82" en="litre per day bar"/>
    <zv:c l="rec20" k="G83" en="litre per hour bar"/>
    <zv:c l="rec20" k="G84" en="litre per minute bar"/>
    <zv:c l="rec20" k="G85" en="litre per second bar"/>
    <zv:c l="rec20" k="G86" en="cubic metre per day bar"/>
    <zv:c l="rec20" k="G87" en="cubic metre per hour bar"/>
    <zv:c l="rec20" k="G88" en="cubic metre per minute bar"/>
    <zv:c l="rec20" k="G89" en="cubic metre per second bar"/>
    <zv:c l="rec20" k="G90" en="millilitre per day bar"/>
    <zv:c l="rec20" k="G91" en="millilitre per hour bar"/>
    <zv:c l="rec20" k="G92" en="millilitre per minute bar"/>
    <zv:c l="rec20" k="G93" en="millilitre per second bar"/>
    <zv:c l="rec20" k="G94" en="cubic centimetre per bar"/>
    <zv:c l="rec20" k="G95" en="litre per bar"/>
    <zv:c l="rec20" k="G96" en="cubic metre per bar"/>
    <zv:c l="rec20" k="G97" en="millilitre per bar"/>
    <zv:c l="rec20" k="G98" en="microhenry per kiloohm"/>
    <zv:c l="rec20" k="G99" en="microhenry per ohm"/>
    <zv:c l="rec20" k="GB" en="gallon (US) per day"/>
    <zv:c l="rec20" k="GBQ" en="gigabecquerel"/>
    <zv:c l="rec20" k="GDW" en="gram, dry weight"/>
    <zv:c l="rec20" k="GE" en="pound per gallon (US)"/>
    <zv:c l="rec20" k="GF" en="gram per metre (gram per 100 centimetres)"/>
    <zv:c l="rec20" k="GFI" en="gram of fissile isotope"/>
    <zv:c l="rec20" k="GGR" en="great gross"/>
    <zv:c l="rec20" k="GIA" en="gill (US)"/>
    <zv:c l="rec20" k="GIC" en="gram, including container"/>
    <zv:c l="rec20" k="GII" en="gill (UK)"/>
    <zv:c l="rec20" k="GIP" en="gram, including inner packaging"/>
    <zv:c l="rec20" k="GJ" en="gram per millilitre"/>
    <zv:c l="rec20" k="GL" en="gram per litre"/>
    <zv:c l="rec20" k="GLD" en="dry gallon (US)"/>
    <zv:c l="rec20" k="GLI" en="gallon (UK)"/>
    <zv:c l="rec20" k="GLL" en="gallon (US)"/>
    <zv:c l="rec20" k="GM" en="gram per square metre"/>
    <zv:c l="rec20" k="GO" en="milligram per square metre"/>
    <zv:c l="rec20" k="GP" en="milligram per cubic metre"/>
    <zv:c l="rec20" k="GQ" en="microgram per cubic metre"/>
    <zv:c l="rec20" k="GRM" de="g" en="g" fr="g"/>
    <zv:c l="rec20" k="GRN" en="grain"/>
    <zv:c l="rec20" k="GRO" en="gross"/>
    <zv:c l="rec20" k="GV" en="gigajoule"/>
    <zv:c l="rec20" k="GWH" en="gigawatt hour"/>
    <zv:c l="rec20" k="H03" en="henry per kiloohm"/>
    <zv:c l="rec20" k="H04" en="henry per ohm"/>
    <zv:c l="rec20" k="H05" en="millihenry per kiloohm"/>
    <zv:c l="rec20" k="H06" en="millihenry per ohm"/>
    <zv:c l="rec20" k="H07" en="pascal second per bar"/>
    <zv:c l="rec20" k="H08" en="microbecquerel"/>
    <zv:c l="rec20" k="H09" en="reciprocal year"/>
    <zv:c l="rec20" k="H10" en="reciprocal hour"/>
    <zv:c l="rec20" k="H11" en="reciprocal month"/>
    <zv:c l="rec20" k="H12" en="degree Celsius per hour"/>
    <zv:c l="rec20" k="H13" en="degree Celsius per minute"/>
    <zv:c l="rec20" k="H14" en="degree Celsius per second"/>
    <zv:c l="rec20" k="H15" en="square centimetre per gram"/>
    <zv:c l="rec20" k="H16" en="square decametre"/>
    <zv:c l="rec20" k="H18" en="square hectometre"/>
    <zv:c l="rec20" k="H19" en="cubic hectometre"/>
    <zv:c l="rec20" k="H20" en="cubic kilometre"/>
    <zv:c l="rec20" k="H21" en="blank"/>
    <zv:c l="rec20" k="H22" en="volt square inch per pound-force"/>
    <zv:c l="rec20" k="H23" en="volt per inch"/>
    <zv:c l="rec20" k="H24" en="volt per microsecond"/>
    <zv:c l="rec20" k="H25" en="percent per kelvin"/>
    <zv:c l="rec20" k="H26" en="ohm per metre"/>
    <zv:c l="rec20" k="H27" en="degree per metre"/>
    <zv:c l="rec20" k="H28" en="microfarad per kilometre"/>
    <zv:c l="rec20" k="H29" en="microgram per litre"/>
    <zv:c l="rec20" k="H30" en="square micrometre (square micron)"/>
    <zv:c l="rec20" k="H31" en="ampere per kilogram"/>
    <zv:c l="rec20" k="H32" en="ampere squared second"/>
    <zv:c l="rec20" k="H33" en="farad per kilometre"/>
    <zv:c l="rec20" k="H34" en="hertz metre"/>
    <zv:c l="rec20" k="H35" en="kelvin metre per watt"/>
    <zv:c l="rec20" k="H36" en="megaohm per kilometre"/>
    <zv:c l="rec20" k="H37" en="megaohm per metre"/>
    <zv:c l="rec20" k="H38" en="megaampere"/>
    <zv:c l="rec20" k="H39" en="megahertz kilometre"/>
    <zv:c l="rec20" k="H40" en="newton per ampere"/>
    <zv:c l="rec20" k="H41" en="newton metre watt to the power minus 0,5"/>
    <zv:c l="rec20" k="H42" en="pascal per metre"/>
    <zv:c l="rec20" k="H43" en="siemens per centimetre"/>
    <zv:c l="rec20" k="H44" en="teraohm"/>
    <zv:c l="rec20" k="H45" en="volt second per metre"/>
    <zv:c l="rec20" k="H46" en="volt per second"/>
    <zv:c l="rec20" k="H47" en="watt per cubic metre"/>
    <zv:c l="rec20" k="H48" en="attofarad"/>
    <zv:c l="rec20" k="H49" en="centimetre per hour"/>
    <zv:c l="rec20" k="H50" en="reciprocal cubic centimetre"/>
    <zv:c l="rec20" k="H51" en="decibel per kilometre"/>
    <zv:c l="rec20" k="H52" en="decibel per metre"/>
    <zv:c l="rec20" k="H53" en="kilogram per bar"/>
    <zv:c l="rec20" k="H54" en="kilogram per cubic decimetre kelvin"/>
    <zv:c l="rec20" k="H55" en="kilogram per cubic decimetre bar"/>
    <zv:c l="rec20" k="H56" en="kilogram per square metre second"/>
    <zv:c l="rec20" k="H57" en="inch per two pi radiant"/>
    <zv:c l="rec20" k="H58" en="metre per volt second"/>
    <zv:c l="rec20" k="H59" en="square metre per newton"/>
    <zv:c l="rec20" k="H60" en="cubic metre per cubic metre"/>
    <zv:c l="rec20" k="H61" en="millisiemens per centimetre"/>
    <zv:c l="rec20" k="H62" en="millivolt per minute"/>
    <zv:c l="rec20" k="H63" en="milligram per square centimetre"/>
    <zv:c l="rec20" k="H64" en="milligram per gram"/>
    <zv:c l="rec20" k="H65" en="millilitre per cubic metre"/>
    <zv:c l="rec20" k="H66" en="millimetre per year"/>
    <zv:c l="rec20" k="H67" en="millimetre per hour"/>
    <zv:c l="rec20" k="H68" en="millimole per gram"/>
    <zv:c l="rec20" k="H69" en="picopascal per kilometre"/>
    <zv:c l="rec20" k="H70" en="picosecond"/>
    <zv:c l="rec20" k="H71" en="percent per month"/>
    <zv:c l="rec20" k="H72" en="percent per hectobar"/>
    <zv:c l="rec20" k="H73" en="percent per decakelvin"/>
    <zv:c l="rec20" k="H74" en="watt per metre"/>
    <zv:c l="rec20" k="H75" en="decapascal"/>
    <zv:c l="rec20" k="H76" en="gram per millimetre"/>
    <zv:c l="rec20" k="H77" en="module width"/>
    <zv:c l="rec20" k="H79" en="French gauge"/>
    <zv:c l="rec20" k="H80" en="rack unit"/>
    <zv:c l="rec20" k="H81" en="millimetre per minute"/>
    <zv:c l="rec20" k="H82" en="big point"/>
    <zv:c l="rec20" k="H83" en="litre per kilogram"/>
    <zv:c l="rec20" k="H84" en="gram millimetre"/>
    <zv:c l="rec20" k="H85" en="reciprocal week"/>
    <zv:c l="rec20" k="H87" de="Stück" en="piece" fr="pièce"/>
    <zv:c l="rec20" k="H88" en="megaohm kilometre"/>
    <zv:c l="rec20" k="H89" en="percent per ohm"/>
    <zv:c l="rec20" k="H90" en="percent per degree"/>
    <zv:c l="rec20" k="H91" en="percent per ten thousand"/>
    <zv:c l="rec20" k="H92" en="percent per one hundred thousand"/>
    <zv:c l="rec20" k="H93" en="percent per hundred"/>
    <zv:c l="rec20" k="H94" en="percent per thousand"/>
    <zv:c l="rec20" k="H95" en="percent per volt"/>
    <zv:c l="rec20" k="H96" en="percent per bar"/>
    <zv:c l="rec20" k="H98" en="percent per inch"/>
    <zv:c l="rec20" k="H99" en="percent per metre"/>
    <zv:c l="rec20" k="HA" en="hank"/>
    <zv:c l="rec20" k="HAD" en="Piece Day"/>
    <zv:c l="rec20" k="HBA" en="hectobar"/>
    <zv:c l="rec20" k="HBX" en="hundred boxes"/>
    <zv:c l="rec20" k="HC" en="hundred count"/>
    <zv:c l="rec20" k="HDW" en="hundred kilogram, dry weight"/>
    <zv:c l="rec20" k="HEA" en="head"/>
    <zv:c l="rec20" k="HGM" en="hectogram"/>
    <zv:c l="rec20" k="HH" en="hundred cubic foot"/>
    <zv:c l="rec20" k="HIU" en="hundred international unit"/>
    <zv:c l="rec20" k="HKM" en="hundred kilogram, net mass"/>
    <zv:c l="rec20" k="HLT" en="hectolitre"/>
    <zv:c l="rec20" k="HM" en="mile per hour (statute mile)"/>
    <zv:c l="rec20" k="HMO" en="Piece Month"/>
    <zv:c l="rec20" k="HMQ" en="million cubic metre"/>
    <zv:c l="rec20" k="HMT" en="hectometre"/>
    <zv:c l="rec20" k="HPA" en="hectolitre of pure alcohol"/>
    <zv:c l="rec20" k="HTZ" en="hertz"/>
    <zv:c l="rec20" k="HUR" de="Stunde" en="hour" fr="heure"/>
    <zv:c l="rec20" k="HWE" en="Piece Week"/>
    <zv:c l="rec20" k="IA" en="inch pound (pound inch)"/>
    <zv:c l="rec20" k="IE" en="person"/>
    <zv:c l="rec20" k="INH" en="inch"/>
    <zv:c l="rec20" k="INK" en="square inch"/>
    <zv:c l="rec20" k="INQ" en="cubic inch"/>
    <zv:c l="rec20" k="ISD" en="international sugar degree"/>
    <zv:c l="rec20" k="IU" en="inch per second"/>
    <zv:c l="rec20" k="IUG" en="international unit per gram"/>
    <zv:c l="rec20" k="IV" en="inch per second squared"/>
    <zv:c l="rec20" k="J10" en="percent per millimetre"/>
    <zv:c l="rec20" k="J12" en="per mille per psi"/>
    <zv:c l="rec20" k="J13" en="degree API"/>
    <zv:c l="rec20" k="J14" en="degree Baume (origin scale)"/>
    <zv:c l="rec20" k="J15" en="degree Baume (US heavy)"/>
    <zv:c l="rec20" k="J16" en="degree Baume (US light)"/>
    <zv:c l="rec20" k="J17" en="degree Balling"/>
    <zv:c l="rec20" k="J18" en="degree Brix"/>
    <zv:c l="rec20" k="J19" en="degree Fahrenheit hour square foot per British thermal unit (thermochemical)"/>
    <zv:c l="rec20" k="J2" en="joule per kilogram"/>
    <zv:c l="rec20" k="J20" en="degree Fahrenheit per kelvin"/>
    <zv:c l="rec20" k="J21" en="degree Fahrenheit per bar"/>
    <zv:c l="rec20" k="J22" en="degree Fahrenheit hour square foot per British thermal unit (international table)"/>
    <zv:c l="rec20" k="J23" en="degree Fahrenheit per hour"/>
    <zv:c l="rec20" k="J24" en="degree Fahrenheit per minute"/>
    <zv:c l="rec20" k="J25" en="degree Fahrenheit per second"/>
    <zv:c l="rec20" k="J26" en="reciprocal degree Fahrenheit"/>
    <zv:c l="rec20" k="J27" en="degree Oechsle"/>
    <zv:c l="rec20" k="J28" en="degree Rankine per hour"/>
    <zv:c l="rec20" k="J29" en="degree Rankine per minute"/>
    <zv:c l="rec20" k="J30" en="degree Rankine per second"/>
    <zv:c l="rec20" k="J31" en="degree Twaddell"/>
    <zv:c l="rec20" k="J32" en="micropoise"/>
    <zv:c l="rec20" k="J33" en="microgram per kilogram"/>
    <zv:c l="rec20" k="J34" en="microgram per cubic metre kelvin"/>
    <zv:c l="rec20" k="J35" en="microgram per cubic metre bar"/>
    <zv:c l="rec20" k="J36" en="microlitre per litre"/>
    <zv:c l="rec20" k="J38" en="baud"/>
    <zv:c l="rec20" k="J39" en="British thermal unit (mean)"/>
    <zv:c l="rec20" k="J40" en="British thermal unit (international table) foot per hour square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="J41" en="British thermal unit (international table) inch per hour square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="J42" en="British thermal unit (international table) inch per second square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="J43" en="British thermal unit (international table) per pound degree Fahrenheit"/>
    <zv:c l="rec20" k="J44" en="British thermal unit (international table) per minute"/>
    <zv:c l="rec20" k="J45" en="British thermal unit (international table) per second"/>
    <zv:c l="rec20" k="J46" en="British thermal unit (thermochemical) foot per hour square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="J47" en="British thermal unit (thermochemical) per hour"/>
    <zv:c l="rec20" k="J48" en="British thermal unit (thermochemical) inch per hour square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="J49" en="British thermal unit (thermochemical) inch per second square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="J50" en="British thermal unit (thermochemical) per pound degree Fahrenheit"/>
    <zv:c l="rec20" k="J51" en="British thermal unit (thermochemical) per minute"/>
    <zv:c l="rec20" k="J52" en="British thermal unit (thermochemical) per second"/>
    <zv:c l="rec20" k="J53" en="coulomb square metre per kilogram"/>
    <zv:c l="rec20" k="J54" en="megabaud"/>
    <zv:c l="rec20" k="J55" en="watt second"/>
    <zv:c l="rec20" k="J56" en="bar per bar"/>
    <zv:c l="rec20" k="J57" en="barrel (UK petroleum)"/>
    <zv:c l="rec20" k="J58" en="barrel (UK petroleum) per minute"/>
    <zv:c l="rec20" k="J59" en="barrel (UK petroleum) per day"/>
    <zv:c l="rec20" k="J60" en="barrel (UK petroleum) per hour"/>
    <zv:c l="rec20" k="J61" en="barrel (UK petroleum) per second"/>
    <zv:c l="rec20" k="J62" en="barrel (US petroleum) per hour"/>
    <zv:c l="rec20" k="J63" en="barrel (US petroleum) per second"/>
    <zv:c l="rec20" k="J64" en="bushel (UK) per day"/>
    <zv:c l="rec20" k="J65" en="bushel (UK) per hour"/>
    <zv:c l="rec20" k="J66" en="bushel (UK) per minute"/>
    <zv:c l="rec20" k="J67" en="bushel (UK) per second"/>
    <zv:c l="rec20" k="J68" en="bushel (US dry) per day"/>
    <zv:c l="rec20" k="J69" en="bushel (US dry) per hour"/>
    <zv:c l="rec20" k="J70" en="bushel (US dry) per minute"/>
    <zv:c l="rec20" k="J71" en="bushel (US dry) per second"/>
    <zv:c l="rec20" k="J72" en="centinewton metre"/>
    <zv:c l="rec20" k="J73" en="centipoise per kelvin"/>
    <zv:c l="rec20" k="J74" en="centipoise per bar"/>
    <zv:c l="rec20" k="J75" en="calorie (mean)"/>
    <zv:c l="rec20" k="J76" en="calorie (international table) per gram degree Celsius"/>
    <zv:c l="rec20" k="J78" en="calorie (thermochemical) per centimetre second degree Celsius"/>
    <zv:c l="rec20" k="J79" en="calorie (thermochemical) per gram degree Celsius"/>
    <zv:c l="rec20" k="J81" en="calorie (thermochemical) per minute"/>
    <zv:c l="rec20" k="J82" en="calorie (thermochemical) per second"/>
    <zv:c l="rec20" k="J83" en="clo"/>
    <zv:c l="rec20" k="J84" en="centimetre per second kelvin"/>
    <zv:c l="rec20" k="J85" en="centimetre per second bar"/>
    <zv:c l="rec20" k="J87" en="cubic centimetre per cubic metre"/>
    <zv:c l="rec20" k="J90" en="cubic decimetre per day"/>
    <zv:c l="rec20" k="J91" en="cubic decimetre per cubic metre"/>
    <zv:c l="rec20" k="J92" en="cubic decimetre per minute"/>
    <zv:c l="rec20" k="J93" en="cubic decimetre per second"/>
    <zv:c l="rec20" k="J95" en="ounce (UK fluid) per day"/>
    <zv:c l="rec20" k="J96" en="ounce (UK fluid) per hour"/>
    <zv:c l="rec20" k="J97" en="ounce (UK fluid) per minute"/>
    <zv:c l="rec20" k="J98" en="ounce (UK fluid) per second"/>
    <zv:c l="rec20" k="J99" en="ounce (US fluid) per day"/>
    <zv:c l="rec20" k="JE" en="joule per kelvin"/>
    <zv:c l="rec20" k="JK" en="megajoule per kilogram"/>
    <zv:c l="rec20" k="JM" en="megajoule per cubic metre"/>
    <zv:c l="rec20" k="JNT" en="pipeline joint"/>
    <zv:c l="rec20" k="JOU" en="joule"/>
    <zv:c l="rec20" k="JPS" en="hundred metre"/>
    <zv:c l="rec20" k="JWL" en="number of jewels"/>
    <zv:c l="rec20" k="K1" en="kilowatt demand"/>
    <zv:c l="rec20" k="K10" en="ounce (US fluid) per hour"/>
    <zv:c l="rec20" k="K11" en="ounce (US fluid) per minute"/>
    <zv:c l="rec20" k="K12" en="ounce (US fluid) per second"/>
    <zv:c l="rec20" k="K13" en="foot per degree Fahrenheit"/>
    <zv:c l="rec20" k="K14" en="foot per hour"/>
    <zv:c l="rec20" k="K15" en="foot pound-force per hour"/>
    <zv:c l="rec20" k="K16" en="foot pound-force per minute"/>
    <zv:c l="rec20" k="K17" en="foot per psi"/>
    <zv:c l="rec20" k="K18" en="foot per second degree Fahrenheit"/>
    <zv:c l="rec20" k="K19" en="foot per second psi"/>
    <zv:c l="rec20" k="K2" en="kilovolt ampere reactive demand"/>
    <zv:c l="rec20" k="K20" en="reciprocal cubic foot"/>
    <zv:c l="rec20" k="K21" en="cubic foot per degree Fahrenheit"/>
    <zv:c l="rec20" k="K22" en="cubic foot per day"/>
    <zv:c l="rec20" k="K23" en="cubic foot per psi"/>
    <zv:c l="rec20" k="K26" en="gallon (UK) per day"/>
    <zv:c l="rec20" k="K27" en="gallon (UK) per hour"/>
    <zv:c l="rec20" k="K28" en="gallon (UK) per second"/>
    <zv:c l="rec20" k="K3" en="Kilovolt ampere reactive hour"/>
    <zv:c l="rec20" k="K30" en="gallon (US liquid) per second"/>
    <zv:c l="rec20" k="K31" en="gram-force per square centimetre"/>
    <zv:c l="rec20" k="K32" en="gill (UK) per day"/>
    <zv:c l="rec20" k="K33" en="gill (UK) per hour"/>
    <zv:c l="rec20" k="K34" en="gill (UK) per minute"/>
    <zv:c l="rec20" k="K35" en="gill (UK) per second"/>
    <zv:c l="rec20" k="K36" en="gill (US) per day"/>
    <zv:c l="rec20" k="K37" en="gill (US) per hour"/>
    <zv:c l="rec20" k="K38" en="gill (US) per minute"/>
    <zv:c l="rec20" k="K39" en="gill (US) per second"/>
    <zv:c l="rec20" k="K40" en="standard acceleration of free fall"/>
    <zv:c l="rec20" k="K41" en="grain per gallon (US)"/>
    <zv:c l="rec20" k="K42" en="horsepower (boiler)"/>
    <zv:c l="rec20" k="K43" en="horsepower (electric)"/>
    <zv:c l="rec20" k="K45" en="inch per degree Fahrenheit"/>
    <zv:c l="rec20" k="K46" en="inch per psi"/>
    <zv:c l="rec20" k="K47" en="inch per second degree Fahrenheit"/>
    <zv:c l="rec20" k="K48" en="inch per second psi"/>
    <zv:c l="rec20" k="K49" en="reciprocal cubic inch"/>
    <zv:c l="rec20" k="K50" en="kilobaud"/>
    <zv:c l="rec20" k="K51" en="kilocalorie (mean)"/>
    <zv:c l="rec20" k="K52" en="kilocalorie (international table) per hour metre degree Celsius"/>
    <zv:c l="rec20" k="K53" en="kilocalorie (thermochemical)"/>
    <zv:c l="rec20" k="K54" en="kilocalorie (thermochemical) per minute"/>
    <zv:c l="rec20" k="K55" en="kilocalorie (thermochemical) per second"/>
    <zv:c l="rec20" k="K58" en="kilomole per hour"/>
    <zv:c l="rec20" k="K59" en="kilomole per cubic metre kelvin"/>
    <zv:c l="rec20" k="K6" en="kilolitre"/>
    <zv:c l="rec20" k="K60" en="kilomole per cubic metre bar"/>
    <zv:c l="rec20" k="K61" en="kilomole per minute"/>
    <zv:c l="rec20" k="K62" en="litre per litre"/>
    <zv:c l="rec20" k="K63" en="reciprocal litre"/>
    <zv:c l="rec20" k="K64" en="pound (avoirdupois) per degree Fahrenheit"/>
    <zv:c l="rec20" k="K65" en="pound (avoirdupois) square foot"/>
    <zv:c l="rec20" k="K66" en="pound (avoirdupois) per day"/>
    <zv:c l="rec20" k="K67" en="pound per foot hour"/>
    <zv:c l="rec20" k="K68" en="pound per foot second"/>
    <zv:c l="rec20" k="K69" en="pound (avoirdupois) per cubic foot degree Fahrenheit"/>
    <zv:c l="rec20" k="K70" en="pound (avoirdupois) per cubic foot psi"/>
    <zv:c l="rec20" k="K71" en="pound (avoirdupois) per gallon (UK)"/>
    <zv:c l="rec20" k="K73" en="pound (avoirdupois) per hour degree Fahrenheit"/>
    <zv:c l="rec20" k="K74" en="pound (avoirdupois) per hour psi"/>
    <zv:c l="rec20" k="K75" en="pound (avoirdupois) per cubic inch degree Fahrenheit"/>
    <zv:c l="rec20" k="K76" en="pound (avoirdupois) per cubic inch psi"/>
    <zv:c l="rec20" k="K77" en="pound (avoirdupois) per psi"/>
    <zv:c l="rec20" k="K78" en="pound (avoirdupois) per minute"/>
    <zv:c l="rec20" k="K79" en="pound (avoirdupois) per minute degree Fahrenheit"/>
    <zv:c l="rec20" k="K80" en="pound (avoirdupois) per minute psi"/>
    <zv:c l="rec20" k="K81" en="pound (avoirdupois) per second"/>
    <zv:c l="rec20" k="K82" en="pound (avoirdupois) per second degree Fahrenheit"/>
    <zv:c l="rec20" k="K83" en="pound (avoirdupois) per second psi"/>
    <zv:c l="rec20" k="K84" en="pound per cubic yard"/>
    <zv:c l="rec20" k="K85" en="pound-force per square foot"/>
    <zv:c l="rec20" k="K86" en="pound-force per square inch degree Fahrenheit"/>
    <zv:c l="rec20" k="K87" en="psi cubic inch per second"/>
    <zv:c l="rec20" k="K88" en="psi litre per second"/>
    <zv:c l="rec20" k="K89" en="psi cubic metre per second"/>
    <zv:c l="rec20" k="K90" en="psi cubic yard per second"/>
    <zv:c l="rec20" k="K91" en="pound-force second per square foot"/>
    <zv:c l="rec20" k="K92" en="pound-force second per square inch"/>
    <zv:c l="rec20" k="K93" en="reciprocal psi"/>
    <zv:c l="rec20" k="K94" en="quart (UK liquid) per day"/>
    <zv:c l="rec20" k="K95" en="quart (UK liquid) per hour"/>
    <zv:c l="rec20" k="K96" en="quart (UK liquid) per minute"/>
    <zv:c l="rec20" k="K97" en="quart (UK liquid) per second"/>
    <zv:c l="rec20" k="K98" en="quart (US liquid) per day"/>
    <zv:c l="rec20" k="K99" en="quart (US liquid) per hour"/>
    <zv:c l="rec20" k="KA" en="cake"/>
    <zv:c l="rec20" k="KAT" en="katal"/>
    <zv:c l="rec20" k="KB" en="kilocharacter"/>
    <zv:c l="rec20" k="KBA" en="kilobar"/>
    <zv:c l="rec20" k="KCC" en="kilogram of choline chloride"/>
    <zv:c l="rec20" k="KDW" en="kilogram drained net weight"/>
    <zv:c l="rec20" k="KEL" en="kelvin"/>
    <zv:c l="rec20" k="KGM" de="kg" en="kg" fr="kg"/>
    <zv:c l="rec20" k="KGS" en="kilogram per second"/>
    <zv:c l="rec20" k="KHY" en="kilogram of hydrogen peroxide"/>
    <zv:c l="rec20" k="KHZ" en="kilohertz"/>
    <zv:c l="rec20" k="KI" en="kilogram per millimetre width"/>
    <zv:c l="rec20" k="KIC" en="kilogram, including container"/>
    <zv:c l="rec20" k="KIP" en="kilogram, including inner packaging"/>
    <zv:c l="rec20" k="KJ" en="kilosegment"/>
    <zv:c l="rec20" k="KJO" en="kilojoule"/>
    <zv:c l="rec20" k="KL" en="kilogram per metre"/>
    <zv:c l="rec20" k="KLK" en="lactic dry material percentage"/>
    <zv:c l="rec20" k="KLX" en="kilolux"/>
    <zv:c l="rec20" k="KMA" en="kilogram of methylamine"/>
    <zv:c l="rec20" k="KMH" en="kilometre per hour"/>
    <zv:c l="rec20" k="KMK" en="square kilometre"/>
    <zv:c l="rec20" k="KMQ" en="kilogram per cubic metre"/>
    <zv:c l="rec20" k="KMT" de="km" en="km" fr="km"/>
    <zv:c l="rec20" k="KNI" en="kilogram of nitrogen"/>
    <zv:c l="rec20" k="KNM" en="kilonewton per square metre"/>
    <zv:c l="rec20" k="KNS" en="kilogram named substance"/>
    <zv:c l="rec20" k="KNT" en="knot"/>
    <zv:c l="rec20" k="KO" en="milliequivalence caustic potash per gram of product"/>
    <zv:c l="rec20" k="KPA" en="kilopascal"/>
    <zv:c l="rec20" k="KPH" en="kilogram of potassium hydroxide (caustic potash)"/>
    <zv:c l="rec20" k="KPO" en="kilogram of potassium oxide"/>
    <zv:c l="rec20" k="KPP" en="kilogram of phosphorus pentoxide (phosphoric anhydride)"/>
    <zv:c l="rec20" k="KR" en="kiloroentgen"/>
    <zv:c l="rec20" k="KSD" en="kilogram of substance 90 % dry"/>
    <zv:c l="rec20" k="KSH" en="kilogram of sodium hydroxide (caustic soda)"/>
    <zv:c l="rec20" k="KT" en="kit"/>
    <zv:c l="rec20" k="KTN" en="kilotonne"/>
    <zv:c l="rec20" k="KUR" en="kilogram of uranium"/>
    <zv:c l="rec20" k="KVA" en="kilovolt - ampere"/>
    <zv:c l="rec20" k="KVR" en="kilovar"/>
    <zv:c l="rec20" k="KVT" en="kilovolt"/>
    <zv:c l="rec20" k="KW" en="kilogram per millimetre"/>
    <zv:c l="rec20" k="KWH" de="kWh" en="kWh" fr="kWh"/>
    <zv:c l="rec20" k="KWN" en="Kilowatt hour per normalized cubic metre"/>
    <zv:c l="rec20" k="KWO" en="kilogram of tungsten trioxide"/>
    <zv:c l="rec20" k="KWS" en="Kilowatt hour per standard cubic metre"/>
    <zv:c l="rec20" k="KWT" de="kW" en="kW" fr="kW"/>
    <zv:c l="rec20" k="KWY" en="kilowatt year"/>
    <zv:c l="rec20" k="KX" en="millilitre per kilogram"/>
    <zv:c l="rec20" k="L10" en="quart (US liquid) per minute"/>
    <zv:c l="rec20" k="L11" en="quart (US liquid) per second"/>
    <zv:c l="rec20" k="L12" en="metre per second kelvin"/>
    <zv:c l="rec20" k="L13" en="metre per second bar"/>
    <zv:c l="rec20" k="L14" en="square metre hour degree Celsius per kilocalorie (international table)"/>
    <zv:c l="rec20" k="L15" en="millipascal second per kelvin"/>
    <zv:c l="rec20" k="L16" en="millipascal second per bar"/>
    <zv:c l="rec20" k="L17" en="milligram per cubic metre kelvin"/>
    <zv:c l="rec20" k="L18" en="milligram per cubic metre bar"/>
    <zv:c l="rec20" k="L19" en="millilitre per litre"/>
    <zv:c l="rec20" k="L2" en="litre per minute"/>
    <zv:c l="rec20" k="L20" en="reciprocal cubic millimetre"/>
    <zv:c l="rec20" k="L21" en="cubic millimetre per cubic metre"/>
    <zv:c l="rec20" k="L23" en="mole per hour"/>
    <zv:c l="rec20" k="L24" en="mole per kilogram kelvin"/>
    <zv:c l="rec20" k="L25" en="mole per kilogram bar"/>
    <zv:c l="rec20" k="L26" en="mole per litre kelvin"/>
    <zv:c l="rec20" k="L27" en="mole per litre bar"/>
    <zv:c l="rec20" k="L28" en="mole per cubic metre kelvin"/>
    <zv:c l="rec20" k="L29" en="mole per cubic metre bar"/>
    <zv:c l="rec20" k="L30" en="mole per minute"/>
    <zv:c l="rec20" k="L31" en="milliroentgen aequivalent men"/>
    <zv:c l="rec20" k="L32" en="nanogram per kilogram"/>
    <zv:c l="rec20" k="L33" en="ounce (avoirdupois) per day"/>
    <zv:c l="rec20" k="L34" en="ounce (avoirdupois) per hour"/>
    <zv:c l="rec20" k="L35" en="ounce (avoirdupois) per minute"/>
    <zv:c l="rec20" k="L36" en="ounce (avoirdupois) per second"/>
    <zv:c l="rec20" k="L37" en="ounce (avoirdupois) per gallon (UK)"/>
    <zv:c l="rec20" k="L38" en="ounce (avoirdupois) per gallon (US)"/>
    <zv:c l="rec20" k="L39" en="ounce (avoirdupois) per cubic inch"/>
    <zv:c l="rec20" k="L40" en="ounce (avoirdupois)-force"/>
    <zv:c l="rec20" k="L41" en="ounce (avoirdupois)-force inch"/>
    <zv:c l="rec20" k="L42" en="picosiemens per metre"/>
    <zv:c l="rec20" k="L43" en="peck (UK)"/>
    <zv:c l="rec20" k="L44" en="peck (UK) per day"/>
    <zv:c l="rec20" k="L45" en="peck (UK) per hour"/>
    <zv:c l="rec20" k="L46" en="peck (UK) per minute"/>
    <zv:c l="rec20" k="L47" en="peck (UK) per second"/>
    <zv:c l="rec20" k="L48" en="peck (US dry) per day"/>
    <zv:c l="rec20" k="L49" en="peck (US dry) per hour"/>
    <zv:c l="rec20" k="L50" en="peck (US dry) per minute"/>
    <zv:c l="rec20" k="L51" en="peck (US dry) per second"/>
    <zv:c l="rec20" k="L52" en="psi per psi"/>
    <zv:c l="rec20" k="L53" en="pint (UK) per day"/>
    <zv:c l="rec20" k="L54" en="pint (UK) per hour"/>
    <zv:c l="rec20" k="L55" en="pint (UK) per minute"/>
    <zv:c l="rec20" k="L56" en="pint (UK) per second"/>
    <zv:c l="rec20" k="L57" en="pint (US liquid) per day"/>
    <zv:c l="rec20" k="L58" en="pint (US liquid) per hour"/>
    <zv:c l="rec20" k="L59" en="pint (US liquid) per minute"/>
    <zv:c l="rec20" k="L60" en="pint (US liquid) per second"/>
    <zv:c l="rec20" k="L63" en="slug per day"/>
    <zv:c l="rec20" k="L64" en="slug per foot second"/>
    <zv:c l="rec20" k="L65" en="slug per cubic foot"/>
    <zv:c l="rec20" k="L66" en="slug per hour"/>
    <zv:c l="rec20" k="L67" en="slug per minute"/>
    <zv:c l="rec20" k="L68" en="slug per second"/>
    <zv:c l="rec20" k="L69" en="tonne per kelvin"/>
    <zv:c l="rec20" k="L70" en="tonne per bar"/>
    <zv:c l="rec20" k="L71" en="tonne per day"/>
    <zv:c l="rec20" k="L72" en="tonne per day kelvin"/>
    <zv:c l="rec20" k="L73" en="tonne per day bar"/>
    <zv:c l="rec20" k="L74" en="tonne per hour kelvin"/>
    <zv:c l="rec20" k="L75" en="tonne per hour bar"/>
    <zv:c l="rec20" k="L76" en="tonne per cubic metre kelvin"/>
    <zv:c l="rec20" k="L77" en="tonne per cubic metre bar"/>
    <zv:c l="rec20" k="L78" en="tonne per minute"/>
    <zv:c l="rec20" k="L79" en="tonne per minute kelvin"/>
    <zv:c l="rec20" k="L80" en="tonne per minute bar"/>
    <zv:c l="rec20" k="L81" en="tonne per second"/>
    <zv:c l="rec20" k="L82" en="tonne per second kelvin"/>
    <zv:c l="rec20" k="L83" en="tonne per second bar"/>
    <zv:c l="rec20" k="L84" en="ton (UK shipping)"/>
    <zv:c l="rec20" k="L85" en="ton long per day"/>
    <zv:c l="rec20" k="L86" en="ton (US shipping)"/>
    <zv:c l="rec20" k="L87" en="ton short per degree Fahrenheit"/>
    <zv:c l="rec20" k="L88" en="ton short per day"/>
    <zv:c l="rec20" k="L89" en="ton short per hour degree Fahrenheit"/>
    <zv:c l="rec20" k="L90" en="ton short per hour psi"/>
    <zv:c l="rec20" k="L91" en="ton short per psi"/>
    <zv:c l="rec20" k="L92" en="ton (UK long) per cubic yard"/>
    <zv:c l="rec20" k="L93" en="ton (US short) per cubic yard"/>
    <zv:c l="rec20" k="L94" en="ton-force (US short)"/>
    <zv:c l="rec20" k="L95" en="common year"/>
    <zv:c l="rec20" k="L96" en="sidereal year"/>
    <zv:c l="rec20" k="L98" en="yard per degree Fahrenheit"/>
    <zv:c l="rec20" k="L99" en="yard per psi"/>
    <zv:c l="rec20" k="LA" en="pound per cubic inch"/>
    <zv:c l="rec20" k="LAC" en="lactose excess percentage"/>
    <zv:c l="rec20" k="LBR" en="pound"/>
    <zv:c l="rec20" k="LBT" en="troy pound (US)"/>
    <zv:c l="rec20" k="LD" en="litre per day"/>
    <zv:c l="rec20" k="LEF" en="leaf"/>
    <zv:c l="rec20" k="LF" en="linear foot"/>
    <zv:c l="rec20" k="LH" en="labour hour"/>
    <zv:c l="rec20" k="LK" en="link"/>
    <zv:c l="rec20" k="LM" en="linear metre"/>
    <zv:c l="rec20" k="LN" en="length"/>
    <zv:c l="rec20" k="LO" en="lot [unit of procurement]"/>
    <zv:c l="rec20" k="LP" en="liquid pound"/>
    <zv:c l="rec20" k="LPA" en="litre of pure alcohol"/>
    <zv:c l="rec20" k="LR" en="layer"/>
    <zv:c l="rec20" k="LS" de="pauschal" en="lump sum" fr="forfait"/>
    <zv:c l="rec20" k="LTN" en="ton (UK) or long ton (US)"/>
    <zv:c l="rec20" k="LTR" de="l" en="l" fr="l"/>
    <zv:c l="rec20" k="LUB" en="metric ton, lubricating oil"/>
    <zv:c l="rec20" k="LUM" en="lumen"/>
    <zv:c l="rec20" k="LUX" en="lux"/>
    <zv:c l="rec20" k="LY" en="linear yard"/>
    <zv:c l="rec20" k="M1" en="milligram per litre"/>
    <zv:c l="rec20" k="M10" en="reciprocal cubic yard"/>
    <zv:c l="rec20" k="M11" en="cubic yard per degree Fahrenheit"/>
    <zv:c l="rec20" k="M12" en="cubic yard per day"/>
    <zv:c l="rec20" k="M13" en="cubic yard per hour"/>
    <zv:c l="rec20" k="M14" en="cubic yard per psi"/>
    <zv:c l="rec20" k="M15" en="cubic yard per minute"/>
    <zv:c l="rec20" k="M16" en="cubic yard per second"/>
    <zv:c l="rec20" k="M17" en="kilohertz metre"/>
    <zv:c l="rec20" k="M18" en="gigahertz metre"/>
    <zv:c l="rec20" k="M19" en="Beaufort"/>
    <zv:c l="rec20" k="M20" en="reciprocal megakelvin or megakelvin to the power minus one"/>
    <zv:c l="rec20" k="M21" en="reciprocal kilovolt - ampere reciprocal hour"/>
    <zv:c l="rec20" k="M22" en="millilitre per square centimetre minute"/>
    <zv:c l="rec20" k="M23" en="newton per centimetre"/>
    <zv:c l="rec20" k="M24" en="ohm kilometre"/>
    <zv:c l="rec20" k="M25" en="percent per degree Celsius"/>
    <zv:c l="rec20" k="M26" en="gigaohm per metre"/>
    <zv:c l="rec20" k="M27" en="megahertz metre"/>
    <zv:c l="rec20" k="M29" en="kilogram per kilogram"/>
    <zv:c l="rec20" k="M30" en="reciprocal volt - ampere reciprocal second"/>
    <zv:c l="rec20" k="M31" en="kilogram per kilometre"/>
    <zv:c l="rec20" k="M32" en="pascal second per litre"/>
    <zv:c l="rec20" k="M33" en="millimole per litre"/>
    <zv:c l="rec20" k="M34" en="newton metre per square metre"/>
    <zv:c l="rec20" k="M35" en="millivolt - ampere"/>
    <zv:c l="rec20" k="M36" en="30-day month"/>
    <zv:c l="rec20" k="M37" en="actual/360"/>
    <zv:c l="rec20" k="M38" en="kilometre per second squared"/>
    <zv:c l="rec20" k="M39" en="centimetre per second squared"/>
    <zv:c l="rec20" k="M4" en="monetary value"/>
    <zv:c l="rec20" k="M40" en="yard per second squared"/>
    <zv:c l="rec20" k="M41" en="millimetre per second squared"/>
    <zv:c l="rec20" k="M42" en="mile (statute mile) per second squared"/>
    <zv:c l="rec20" k="M43" en="mil"/>
    <zv:c l="rec20" k="M44" en="revolution"/>
    <zv:c l="rec20" k="M45" en="degree [unit of angle] per second squared"/>
    <zv:c l="rec20" k="M46" en="revolution per minute"/>
    <zv:c l="rec20" k="M47" en="circular mil"/>
    <zv:c l="rec20" k="M48" en="square mile (based on U.S. survey foot)"/>
    <zv:c l="rec20" k="M49" en="chain (based on U.S. survey foot)"/>
    <zv:c l="rec20" k="M5" en="microcurie"/>
    <zv:c l="rec20" k="M50" en="furlong"/>
    <zv:c l="rec20" k="M51" en="foot (U.S. survey)"/>
    <zv:c l="rec20" k="M52" en="mile (based on U.S. survey foot)"/>
    <zv:c l="rec20" k="M53" en="metre per pascal"/>
    <zv:c l="rec20" k="M55" en="metre per radiant"/>
    <zv:c l="rec20" k="M56" en="shake"/>
    <zv:c l="rec20" k="M57" en="mile per minute"/>
    <zv:c l="rec20" k="M58" en="mile per second"/>
    <zv:c l="rec20" k="M59" en="metre per second pascal"/>
    <zv:c l="rec20" k="M60" en="metre per hour"/>
    <zv:c l="rec20" k="M61" en="inch per year"/>
    <zv:c l="rec20" k="M62" en="kilometre per second"/>
    <zv:c l="rec20" k="M63" en="inch per minute"/>
    <zv:c l="rec20" k="M64" en="yard per second"/>
    <zv:c l="rec20" k="M65" en="yard per minute"/>
    <zv:c l="rec20" k="M66" en="yard per hour"/>
    <zv:c l="rec20" k="M67" en="acre-foot (based on U.S. survey foot)"/>
    <zv:c l="rec20" k="M68" en="cord (128 ft3)"/>
    <zv:c l="rec20" k="M69" en="cubic mile (UK statute)"/>
    <zv:c l="rec20" k="M7" en="micro-inch"/>
    <zv:c l="rec20" k="M70" en="ton, register"/>
    <zv:c l="rec20" k="M71" en="cubic metre per pascal"/>
    <zv:c l="rec20" k="M72" en="bel"/>
    <zv:c l="rec20" k="M73" en="kilogram per cubic metre pascal"/>
    <zv:c l="rec20" k="M74" en="kilogram per pascal"/>
    <zv:c l="rec20" k="M75" en="kilopound-force"/>
    <zv:c l="rec20" k="M76" en="poundal"/>
    <zv:c l="rec20" k="M77" en="kilogram metre per second squared"/>
    <zv:c l="rec20" k="M78" en="pond"/>
    <zv:c l="rec20" k="M79" en="square foot per hour"/>
    <zv:c l="rec20" k="M80" en="stokes per pascal"/>
    <zv:c l="rec20" k="M81" en="square centimetre per second"/>
    <zv:c l="rec20" k="M82" en="square metre per second pascal"/>
    <zv:c l="rec20" k="M83" en="denier"/>
    <zv:c l="rec20" k="M84" en="pound per yard"/>
    <zv:c l="rec20" k="M85" en="ton, assay"/>
    <zv:c l="rec20" k="M86" en="pfund"/>
    <zv:c l="rec20" k="M87" en="kilogram per second pascal"/>
    <zv:c l="rec20" k="M88" en="tonne per month"/>
    <zv:c l="rec20" k="M89" en="tonne per year"/>
    <zv:c l="rec20" k="M9" en="million Btu per 1000 cubic foot"/>
    <zv:c l="rec20" k="M90" en="kilopound per hour"/>
    <zv:c l="rec20" k="M91" en="pound per pound"/>
    <zv:c l="rec20" k="M92" en="pound-force foot"/>
    <zv:c l="rec20" k="M93" en="newton metre per radian"/>
    <zv:c l="rec20" k="M94" en="kilogram metre"/>
    <zv:c l="rec20" k="M95" en="poundal foot"/>
    <zv:c l="rec20" k="M96" en="poundal inch"/>
    <zv:c l="rec20" k="M97" en="dyne metre"/>
    <zv:c l="rec20" k="M98" en="kilogram centimetre per second"/>
    <zv:c l="rec20" k="M99" en="gram centimetre per second"/>
    <zv:c l="rec20" k="MAH" en="megavolt ampere reactive hour"/>
    <zv:c l="rec20" k="MAL" en="megalitre"/>
    <zv:c l="rec20" k="MAM" en="megametre"/>
    <zv:c l="rec20" k="MAR" en="megavar"/>
    <zv:c l="rec20" k="MAW" en="megawatt"/>
    <zv:c l="rec20" k="MBE" en="thousand standard brick equivalent"/>
    <zv:c l="rec20" k="MBF" en="thousand board foot"/>
    <zv:c l="rec20" k="MBR" en="millibar"/>
    <zv:c l="rec20" k="MC" en="microgram"/>
    <zv:c l="rec20" k="MCU" en="millicurie"/>
    <zv:c l="rec20" k="MD" en="air dry metric ton"/>
    <zv:c l="rec20" k="MGM" de="mg" en="mg" fr="mg"/>
    <zv:c l="rec20" k="MHZ" en="megahertz"/>
    <zv:c l="rec20" k="MIK" en="square mile (statute mile)"/>
    <zv:c l="rec20" k="MIL" en="thousand"/>
    <zv:c l="rec20" k="MIN" de="Minute" en="minute" fr="minute"/>
    <zv:c l="rec20" k="MIO" en="million"/>
    <zv:c l="rec20" k="MIU" en="million international unit"/>
    <zv:c l="rec20" k="MKD" en="Square Metre Day"/>
    <zv:c l="rec20" k="MKM" en="Square Metre Month"/>
    <zv:c l="rec20" k="MKW" en="Square Metre Week"/>
    <zv:c l="rec20" k="MLD" en="milliard"/>
    <zv:c l="rec20" k="MLT" de="ml" en="ml" fr="ml"/>
    <zv:c l="rec20" k="MMK" en="square millimetre"/>
    <zv:c l="rec20" k="MMQ" en="cubic millimetre"/>
    <zv:c l="rec20" k="MMT" de="mm" en="mm" fr="mm"/>
    <zv:c l="rec20" k="MND" en="kilogram, dry weight"/>
    <zv:c l="rec20" k="MNJ" en="Mega Joule per Normalised cubic Metre"/>
    <zv:c l="rec20" k="MON" de="Monat" en="month" fr="mois"/>
    <zv:c l="rec20" k="MPA" en="megapascal"/>
    <zv:c l="rec20" k="MQD" en="Cubic Metre Day"/>
    <zv:c l="rec20" k="MQH" en="cubic metre per hour"/>
    <zv:c l="rec20" k="MQM" en="Cubic Metre Month"/>
    <zv:c l="rec20" k="MQS" en="cubic metre per second"/>
    <zv:c l="rec20" k="MQW" en="Cubic Metre Week"/>
    <zv:c l="rec20" k="MRD" en="Metre Day"/>
    <zv:c l="rec20" k="MRM" en="Metre Month"/>
    <zv:c l="rec20" k="MRW" en="Metre Week"/>
    <zv:c l="rec20" k="MSK" en="metre per second squared"/>
    <zv:c l="rec20" k="MTK" de="m²" en="m²" fr="m²"/>
    <zv:c l="rec20" k="MTQ" de="m³" en="m³" fr="m³"/>
    <zv:c l="rec20" k="MTR" de="m" en="m" fr="m"/>
    <zv:c l="rec20" k="MTS" en="metre per second"/>
    <zv:c l="rec20" k="MTZ" en="milihertz"/>
    <zv:c l="rec20" k="MVA" en="megavolt - ampere"/>
    <zv:c l="rec20" k="MWH" de="MWh" en="MWh" fr="MWh"/>
    <zv:c l="rec20" k="N1" en="pen calorie"/>
    <zv:c l="rec20" k="N10" en="pound foot per second"/>
    <zv:c l="rec20" k="N11" en="pound inch per second"/>
    <zv:c l="rec20" k="N12" en="Pferdestaerke"/>
    <zv:c l="rec20" k="N13" en="centimetre of mercury (0 ºC)"/>
    <zv:c l="rec20" k="N14" en="centimetre of water (4 ºC)"/>
    <zv:c l="rec20" k="N15" en="foot of water (39.2 ºF)"/>
    <zv:c l="rec20" k="N16" en="inch of mercury (32 ºF)"/>
    <zv:c l="rec20" k="N17" en="inch of mercury (60 ºF)"/>
    <zv:c l="rec20" k="N18" en="inch of water (39.2 ºF)"/>
    <zv:c l="rec20" k="N19" en="inch of water (60 ºF)"/>
    <zv:c l="rec20" k="N20" en="kip per square inch"/>
    <zv:c l="rec20" k="N21" en="poundal per square foot"/>
    <zv:c l="rec20" k="N22" en="ounce (avoirdupois) per square inch"/>
    <zv:c l="rec20" k="N23" en="conventional metre of water"/>
    <zv:c l="rec20" k="N24" en="gram per square millimetre"/>
    <zv:c l="rec20" k="N25" en="pound per square yard"/>
    <zv:c l="rec20" k="N26" en="poundal per square inch"/>
    <zv:c l="rec20" k="N27" en="foot to the fourth power"/>
    <zv:c l="rec20" k="N28" en="cubic decimetre per kilogram"/>
    <zv:c l="rec20" k="N29" en="cubic foot per pound"/>
    <zv:c l="rec20" k="N3" en="print point"/>
    <zv:c l="rec20" k="N30" en="cubic inch per pound"/>
    <zv:c l="rec20" k="N31" en="kilonewton per metre"/>
    <zv:c l="rec20" k="N32" en="poundal per inch"/>
    <zv:c l="rec20" k="N33" en="pound-force per yard"/>
    <zv:c l="rec20" k="N34" en="poundal second per square foot"/>
    <zv:c l="rec20" k="N35" en="poise per pascal"/>
    <zv:c l="rec20" k="N36" en="newton second per square metre"/>
    <zv:c l="rec20" k="N37" en="kilogram per metre second"/>
    <zv:c l="rec20" k="N38" en="kilogram per metre minute"/>
    <zv:c l="rec20" k="N39" en="kilogram per metre day"/>
    <zv:c l="rec20" k="N40" en="kilogram per metre hour"/>
    <zv:c l="rec20" k="N41" en="gram per centimetre second"/>
    <zv:c l="rec20" k="N42" en="poundal second per square inch"/>
    <zv:c l="rec20" k="N43" en="pound per foot minute"/>
    <zv:c l="rec20" k="N44" en="pound per foot day"/>
    <zv:c l="rec20" k="N45" en="cubic metre per second pascal"/>
    <zv:c l="rec20" k="N46" en="foot poundal"/>
    <zv:c l="rec20" k="N47" en="inch poundal"/>
    <zv:c l="rec20" k="N48" en="watt per square centimetre"/>
    <zv:c l="rec20" k="N49" en="watt per square inch"/>
    <zv:c l="rec20" k="N50" en="British thermal unit (international table) per square foot hour"/>
    <zv:c l="rec20" k="N51" en="British thermal unit (thermochemical) per square foot hour"/>
    <zv:c l="rec20" k="N52" en="British thermal unit (thermochemical) per square foot minute"/>
    <zv:c l="rec20" k="N53" en="British thermal unit (international table) per square foot second"/>
    <zv:c l="rec20" k="N54" en="British thermal unit (thermochemical) per square foot second"/>
    <zv:c l="rec20" k="N55" en="British thermal unit (international table) per square inch second"/>
    <zv:c l="rec20" k="N56" en="calorie (thermochemical) per square centimetre minute"/>
    <zv:c l="rec20" k="N57" en="calorie (thermochemical) per square centimetre second"/>
    <zv:c l="rec20" k="N58" en="British thermal unit (international table) per cubic foot"/>
    <zv:c l="rec20" k="N59" en="British thermal unit (thermochemical) per cubic foot"/>
    <zv:c l="rec20" k="N60" en="British thermal unit (international table) per degree Fahrenheit"/>
    <zv:c l="rec20" k="N61" en="British thermal unit (thermochemical) per degree Fahrenheit"/>
    <zv:c l="rec20" k="N62" en="British thermal unit (international table) per degree Rankine"/>
    <zv:c l="rec20" k="N63" en="British thermal unit (thermochemical) per degree Rankine"/>
    <zv:c l="rec20" k="N64" en="British thermal unit (thermochemical) per pound degree Rankine"/>
    <zv:c l="rec20" k="N65" en="kilocalorie (international table) per gram kelvin"/>
    <zv:c l="rec20" k="N66" en="British thermal unit (39 ºF)"/>
    <zv:c l="rec20" k="N67" en="British thermal unit (59 ºF)"/>
    <zv:c l="rec20" k="N68" en="British thermal unit (60 ºF)"/>
    <zv:c l="rec20" k="N69" en="calorie (20 ºC)"/>
    <zv:c l="rec20" k="N70" en="quad (1015 BtuIT)"/>
    <zv:c l="rec20" k="N71" en="therm (EC)"/>
    <zv:c l="rec20" k="N72" en="therm (U.S.)"/>
    <zv:c l="rec20" k="N73" en="British thermal unit (thermochemical) per pound"/>
    <zv:c l="rec20" k="N74" en="British thermal unit (international table) per hour square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="N75" en="British thermal unit (thermochemical) per hour square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="N76" en="British thermal unit (international table) per second square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="N77" en="British thermal unit (thermochemical) per second square foot degree Fahrenheit"/>
    <zv:c l="rec20" k="N78" en="kilowatt per square metre kelvin"/>
    <zv:c l="rec20" k="N79" en="kelvin per pascal"/>
    <zv:c l="rec20" k="N80" en="watt per metre degree Celsius"/>
    <zv:c l="rec20" k="N81" en="kilowatt per metre kelvin"/>
    <zv:c l="rec20" k="N82" en="kilowatt per metre degree Celsius"/>
    <zv:c l="rec20" k="N83" en="metre per degree Celcius metre"/>
    <zv:c l="rec20" k="N84" en="degree Fahrenheit hour per British thermal unit (international table)"/>
    <zv:c l="rec20" k="N85" en="degree Fahrenheit hour per British thermal unit (thermochemical)"/>
    <zv:c l="rec20" k="N86" en="degree Fahrenheit second per British thermal unit (international table)"/>
    <zv:c l="rec20" k="N87" en="degree Fahrenheit second per British thermal unit (thermochemical)"/>
    <zv:c l="rec20" k="N88" en="degree Fahrenheit hour square foot per British thermal unit (international table) inch"/>
    <zv:c l="rec20" k="N89" en="degree Fahrenheit hour square foot per British thermal unit (thermochemical) inch"/>
    <zv:c l="rec20" k="N90" en="kilofarad"/>
    <zv:c l="rec20" k="N91" en="reciprocal joule"/>
    <zv:c l="rec20" k="N92" en="picosiemens"/>
    <zv:c l="rec20" k="N93" en="ampere per pascal"/>
    <zv:c l="rec20" k="N94" en="franklin"/>
    <zv:c l="rec20" k="N95" en="ampere minute"/>
    <zv:c l="rec20" k="N96" en="biot"/>
    <zv:c l="rec20" k="N97" en="gilbert"/>
    <zv:c l="rec20" k="N98" en="volt per pascal"/>
    <zv:c l="rec20" k="N99" en="picovolt"/>
    <zv:c l="rec20" k="NA" en="milligram per kilogram"/>
    <zv:c l="rec20" k="NAR" de="Anzahl Artikel" en="number of articles" fr="nombre d'articles"/>
    <zv:c l="rec20" k="NCL" en="number of cells"/>
    <zv:c l="rec20" k="NEW" en="newton"/>
    <zv:c l="rec20" k="NF" en="message"/>
    <zv:c l="rec20" k="NIL" en="nil"/>
    <zv:c l="rec20" k="NIU" en="number of international units"/>
    <zv:c l="rec20" k="NL" en="load"/>
    <zv:c l="rec20" k="NM3" en="Normalised cubic metre"/>
    <zv:c l="rec20" k="NMI" en="nautical mile"/>
    <zv:c l="rec20" k="NMP" en="number of packs"/>
    <zv:c l="rec20" k="NPR" de="Anzahl Paare" en="number of pairs" fr="nombre de paires"/>
    <zv:c l="rec20" k="NPT" en="number of parts"/>
    <zv:c l="rec20" k="NT" en="net ton"/>
    <zv:c l="rec20" k="NTU" en="Nephelometric turbidity unit"/>
    <zv:c l="rec20" k="NU" en="newton metre"/>
    <zv:c l="rec20" k="NX" en="part per thousand"/>
    <zv:c l="rec20" k="OA" en="panel"/>
    <zv:c l="rec20" k="ODE" en="ozone depletion equivalent"/>
    <zv:c l="rec20" k="ODG" en="ODS Grams"/>
    <zv:c l="rec20" k="ODK" en="ODS Kilograms"/>
    <zv:c l="rec20" k="ODM" en="ODS Milligrams"/>
    <zv:c l="rec20" k="OHM" en="ohm"/>
    <zv:c l="rec20" k="ON" en="ounce per square yard"/>
    <zv:c l="rec20" k="ONZ" en="ounce (avoirdupois)"/>
    <zv:c l="rec20" k="OPM" en="oscillations per minute"/>
    <zv:c l="rec20" k="OT" en="overtime hour"/>
    <zv:c l="rec20" k="OZA" en="fluid ounce (US)"/>
    <zv:c l="rec20" k="OZI" en="fluid ounce (UK)"/>
    <zv:c l="rec20" k="P1" de="Prozent" en="percent" fr="pour cent"/>
    <zv:c l="rec20" k="P10" en="coulomb per metre"/>
    <zv:c l="rec20" k="P11" en="kiloweber"/>
    <zv:c l="rec20" k="P12" en="gamma"/>
    <zv:c l="rec20" k="P13" en="kilotesla"/>
    <zv:c l="rec20" k="P14" en="joule per second"/>
    <zv:c l="rec20" k="P15" en="joule per minute"/>
    <zv:c l="rec20" k="P16" en="joule per hour"/>
    <zv:c l="rec20" k="P17" en="joule per day"/>
    <zv:c l="rec20" k="P18" en="kilojoule per second"/>
    <zv:c l="rec20" k="P19" en="kilojoule per minute"/>
    <zv:c l="rec20" k="P2" en="pound per foot"/>
    <zv:c l="rec20" k="P20" en="kilojoule per hour"/>
    <zv:c l="rec20" k="P21" en="kilojoule per day"/>
    <zv:c l="rec20" k="P22" en="nanoohm"/>
    <zv:c l="rec20" k="P23" en="ohm circular-mil per foot"/>
    <zv:c l="rec20" k="P24" en="kilohenry"/>
    <zv:c l="rec20" k="P25" en="lumen per square foot"/>
    <zv:c l="rec20" k="P26" en="phot"/>
    <zv:c l="rec20" k="P27" en="footcandle"/>
    <zv:c l="rec20" k="P28" en="candela per square inch"/>
    <zv:c l="rec20" k="P29" en="footlambert"/>
    <zv:c l="rec20" k="P30" en="lambert"/>
    <zv:c l="rec20" k="P31" en="stilb"/>
    <zv:c l="rec20" k="P32" en="candela per square foot"/>
    <zv:c l="rec20" k="P33" en="kilocandela"/>
    <zv:c l="rec20" k="P34" en="millicandela"/>
    <zv:c l="rec20" k="P35" en="Hefner-Kerze"/>
    <zv:c l="rec20" k="P36" en="international candle"/>
    <zv:c l="rec20" k="P37" en="British thermal unit (international table) per square foot"/>
    <zv:c l="rec20" k="P38" en="British thermal unit (thermochemical) per square foot"/>
    <zv:c l="rec20" k="P39" en="calorie (thermochemical) per square centimetre"/>
    <zv:c l="rec20" k="P40" en="langley"/>
    <zv:c l="rec20" k="P41" en="decade (logarithmic)"/>
    <zv:c l="rec20" k="P42" en="pascal squared second"/>
    <zv:c l="rec20" k="P43" en="bel per metre"/>
    <zv:c l="rec20" k="P44" en="pound mole"/>
    <zv:c l="rec20" k="P45" en="pound mole per second"/>
    <zv:c l="rec20" k="P46" en="pound mole per minute"/>
    <zv:c l="rec20" k="P47" en="kilomole per kilogram"/>
    <zv:c l="rec20" k="P48" en="pound mole per pound"/>
    <zv:c l="rec20" k="P49" en="newton square metre per ampere"/>
    <zv:c l="rec20" k="P5" en="five pack"/>
    <zv:c l="rec20" k="P50" en="weber metre"/>
    <zv:c l="rec20" k="P51" en="mol per kilogram pascal"/>
    <zv:c l="rec20" k="P52" en="mol per cubic metre pascal"/>
    <zv:c l="rec20" k="P53" en="unit pole"/>
    <zv:c l="rec20" k="P54" en="milligray per second"/>
    <zv:c l="rec20" k="P55" en="microgray per second"/>
    <zv:c l="rec20" k="P56" en="nanogray per second"/>
    <zv:c l="rec20" k="P57" en="gray per minute"/>
    <zv:c l="rec20" k="P58" en="milligray per minute"/>
    <zv:c l="rec20" k="P59" en="microgray per minute"/>
    <zv:c l="rec20" k="P60" en="nanogray per minute"/>
    <zv:c l="rec20" k="P61" en="gray per hour"/>
    <zv:c l="rec20" k="P62" en="milligray per hour"/>
    <zv:c l="rec20" k="P63" en="microgray per hour"/>
    <zv:c l="rec20" k="P64" en="nanogray per hour"/>
    <zv:c l="rec20" k="P65" en="sievert per second"/>
    <zv:c l="rec20" k="P66" en="millisievert per second"/>
    <zv:c l="rec20" k="P67" en="microsievert per second"/>
    <zv:c l="rec20" k="P68" en="nanosievert per second"/>
    <zv:c l="rec20" k="P69" en="rem per second"/>
    <zv:c l="rec20" k="P70" en="sievert per hour"/>
    <zv:c l="rec20" k="P71" en="millisievert per hour"/>
    <zv:c l="rec20" k="P72" en="microsievert per hour"/>
    <zv:c l="rec20" k="P73" en="nanosievert per hour"/>
    <zv:c l="rec20" k="P74" en="sievert per minute"/>
    <zv:c l="rec20" k="P75" en="millisievert per minute"/>
    <zv:c l="rec20" k="P76" en="microsievert per minute"/>
    <zv:c l="rec20" k="P77" en="nanosievert per minute"/>
    <zv:c l="rec20" k="P78" en="reciprocal square inch"/>
    <zv:c l="rec20" k="P79" en="pascal square metre per kilogram"/>
    <zv:c l="rec20" k="P80" en="millipascal per metre"/>
    <zv:c l="rec20" k="P81" en="kilopascal per metre"/>
    <zv:c l="rec20" k="P82" en="hectopascal per metre"/>
    <zv:c l="rec20" k="P83" en="standard atmosphere per metre"/>
    <zv:c l="rec20" k="P84" en="technical atmosphere per metre"/>
    <zv:c l="rec20" k="P85" en="torr per metre"/>
    <zv:c l="rec20" k="P86" en="psi per inch"/>
    <zv:c l="rec20" k="P87" en="cubic metre per second square metre"/>
    <zv:c l="rec20" k="P88" en="rhe"/>
    <zv:c l="rec20" k="P89" en="pound-force foot per inch"/>
    <zv:c l="rec20" k="P90" en="pound-force inch per inch"/>
    <zv:c l="rec20" k="P91" en="perm (0 ºC)"/>
    <zv:c l="rec20" k="P92" en="perm (23 ºC)"/>
    <zv:c l="rec20" k="P93" en="byte per second"/>
    <zv:c l="rec20" k="P94" en="kilobyte per second"/>
    <zv:c l="rec20" k="P95" en="megabyte per second"/>
    <zv:c l="rec20" k="P96" en="reciprocal volt"/>
    <zv:c l="rec20" k="P97" en="reciprocal radian"/>
    <zv:c l="rec20" k="P98" en="pascal to the power sum of stoichiometric numbers"/>
    <zv:c l="rec20" k="P99" en="mole per cubiv metre to the power sum of stoichiometric numbers"/>
    <zv:c l="rec20" k="PAL" en="pascal"/>
    <zv:c l="rec20" k="PD" en="pad"/>
    <zv:c l="rec20" k="PFL" en="proof litre"/>
    <zv:c l="rec20" k="PGL" en="proof gallon"/>
    <zv:c l="rec20" k="PI" en="pitch"/>
    <zv:c l="rec20" k="PLA" en="degree Plato"/>
    <zv:c l="rec20" k="PO" en="pound per inch of length"/>
    <zv:c l="rec20" k="PQ" en="page per inch"/>
    <zv:c l="rec20" k="PR" de="Paar" en="pair" fr="paire"/>
    <zv:c l="rec20" k="PS" en="pound-force per square inch"/>
    <zv:c l="rec20" k="PTD" en="dry pint (US)"/>
    <zv:c l="rec20" k="PTI" en="pint (UK)"/>
    <zv:c l="rec20" k="PTL" en="liquid pint (US)"/>
    <zv:c l="rec20" k="PTN" en="portion"/>
    <zv:c l="rec20" k="Q10" en="joule per tesla"/>
    <zv:c l="rec20" k="Q11" en="erlang"/>
    <zv:c l="rec20" k="Q12" en="octet"/>
    <zv:c l="rec20" k="Q13" en="octet per second"/>
    <zv:c l="rec20" k="Q14" en="shannon"/>
    <zv:c l="rec20" k="Q15" en="hartley"/>
    <zv:c l="rec20" k="Q16" en="natural unit of information"/>
    <zv:c l="rec20" k="Q17" en="shannon per second"/>
    <zv:c l="rec20" k="Q18" en="hartley per second"/>
    <zv:c l="rec20" k="Q19" en="natural unit of information per second"/>
    <zv:c l="rec20" k="Q20" en="second per kilogramm"/>
    <zv:c l="rec20" k="Q21" en="watt square metre"/>
    <zv:c l="rec20" k="Q22" en="second per radian cubic metre"/>
    <zv:c l="rec20" k="Q23" en="weber to the power minus one"/>
    <zv:c l="rec20" k="Q24" en="reciprocal inch"/>
    <zv:c l="rec20" k="Q25" en="dioptre"/>
    <zv:c l="rec20" k="Q26" en="one per one"/>
    <zv:c l="rec20" k="Q27" en="newton metre per metre"/>
    <zv:c l="rec20" k="Q28" en="kilogram per square metre pascal second"/>
    <zv:c l="rec20" k="Q29" en="microgram per hectogram"/>
    <zv:c l="rec20" k="Q3" en="meal"/>
    <zv:c l="rec20" k="Q30" en="pH (potential of Hydrogen)"/>
    <zv:c l="rec20" k="Q31" en="kilojoule per gram"/>
    <zv:c l="rec20" k="Q32" en="femtolitre"/>
    <zv:c l="rec20" k="Q33" en="picolitre"/>
    <zv:c l="rec20" k="Q34" en="nanolitre"/>
    <zv:c l="rec20" k="Q35" en="megawatts per minute"/>
    <zv:c l="rec20" k="Q36" en="square metre per cubic metre"/>
    <zv:c l="rec20" k="Q37" en="Standard cubic metre per day"/>
    <zv:c l="rec20" k="Q38" en="Standard cubic metre per hour"/>
    <zv:c l="rec20" k="Q39" en="Normalized cubic metre per day"/>
    <zv:c l="rec20" k="Q40" en="Normalized cubic metre per hour"/>
    <zv:c l="rec20" k="Q41" en="Joule per normalised cubic metre"/>
    <zv:c l="rec20" k="Q42" en="Joule per standard cubic metre"/>
    <zv:c l="rec20" k="QA" en="page - facsimile"/>
    <zv:c l="rec20" k="QAN" de="Quartal" en="quarter" fr="trimestre"/>
    <zv:c l="rec20" k="QB" en="page - hardcopy"/>
    <zv:c l="rec20" k="QR" en="quire"/>
    <zv:c l="rec20" k="QTD" en="dry quart (US)"/>
    <zv:c l="rec20" k="QTI" en="quart (UK)"/>
    <zv:c l="rec20" k="QTL" en="liquid quart (US)"/>
    <zv:c l="rec20" k="QTR" en="quarter (UK)"/>
    <zv:c l="rec20" k="R1" en="pica"/>
    <zv:c l="rec20" k="R9" en="thousand cubic metre"/>
    <zv:c l="rec20" k="RH" en="running or operating hour"/>
    <zv:c l="rec20" k="RM" en="ream"/>
    <zv:c l="rec20" k="ROM" en="room"/>
    <zv:c l="rec20" k="RP" en="pound per ream"/>
    <zv:c l="rec20" k="RPM" en="revolutions per minute"/>
    <zv:c l="rec20" k="RPS" en="revolutions per second"/>
    <zv:c l="rec20" k="RT" en="revenue ton mile"/>
    <zv:c l="rec20" k="S3" en="square foot per second"/>
    <zv:c l="rec20" k="S4" en="square metre per second"/>
    <zv:c l="rec20" k="SAN" en="Half year (6 months)"/>
    <zv:c l="rec20" k="SCO" en="score"/>
    <zv:c l="rec20" k="SCR" en="scruple"/>
    <zv:c l="rec20" k="SEC" de="Sekunde" en="second" fr="seconde"/>
    <zv:c l="rec20" k="SET" de="Satz" en="set" fr="ensemble"/>
    <zv:c l="rec20" k="SG" en="segment"/>
    <zv:c l="rec20" k="SIE" en="siemens"/>
    <zv:c l="rec20" k="SM3" en="Standard cubic metre"/>
    <zv:c l="rec20" k="SMI" en="mile (statute mile)"/>
    <zv:c l="rec20" k="SQ" en="square"/>
    <zv:c l="rec20" k="SQR" en="square, roofing"/>
    <zv:c l="rec20" k="SR" en="strip"/>
    <zv:c l="rec20" k="STC" en="stick"/>
    <zv:c l="rec20" k="STI" en="stone (UK)"/>
    <zv:c l="rec20" k="STK" en="stick, cigarette"/>
    <zv:c l="rec20" k="STL" en="standard litre"/>
    <zv:c l="rec20" k="STN" en="ton (US) or short ton (UK/US)"/>
    <zv:c l="rec20" k="STW" en="straw"/>
    <zv:c l="rec20" k="SW" en="skein"/>
    <zv:c l="rec20" k="SX" en="shipment"/>
    <zv:c l="rec20" k="SYR" en="syringe"/>
    <zv:c l="rec20" k="T0" en="telecommunication line in service"/>
    <zv:c l="rec20" k="T3" en="thousand piece"/>
    <zv:c l="rec20" k="TAH" en="kiloampere hour (thousand ampere hour)"/>
    <zv:c l="rec20" k="TAN" en="total acid number"/>
    <zv:c l="rec20" k="TI" en="thousand square inch"/>
    <zv:c l="rec20" k="TIC" en="metric ton, including container"/>
    <zv:c l="rec20" k="TIP" en="metric ton, including inner packaging"/>
    <zv:c l="rec20" k="TKM" en="tonne kilometre"/>
    <zv:c l="rec20" k="TMS" en="kilogram of imported meat, less offal"/>
    <zv:c l="rec20" k="TNE" de="t" en="t" fr="t"/>
    <zv:c l="rec20" k="TP" en="ten pack"/>
    <zv:c l="rec20" k="TPI" en="teeth per inch"/>
    <zv:c l="rec20" k="TPR" en="ten pair"/>
    <zv:c l="rec20" k="TQD" en="thousand cubic metre per day"/>
    <zv:c l="rec20" k="TRL" en="trillion (EUR)"/>
    <zv:c l="rec20" k="TST" en="ten set"/>
    <zv:c l="rec20" k="TTS" en="ten thousand sticks"/>
    <zv:c l="rec20" k="U1" en="treatment"/>
    <zv:c l="rec20" k="U2" en="tablet"/>
    <zv:c l="rec20" k="UB" en="telecommunication line in service average"/>
    <zv:c l="rec20" k="UC" en="telecommunication port"/>
    <zv:c l="rec20" k="VA" en="volt - ampere per kilogram"/>
    <zv:c l="rec20" k="VLT" en="volt"/>
    <zv:c l="rec20" k="VP" en="percent volume"/>
    <zv:c l="rec20" k="W2" en="wet kilo"/>
    <zv:c l="rec20" k="WA" en="watt per kilogram"/>
    <zv:c l="rec20" k="WB" en="wet pound"/>
    <zv:c l="rec20" k="WCD" en="cord"/>
    <zv:c l="rec20" k="WE" en="wet ton"/>
    <zv:c l="rec20" k="WEB" en="weber"/>
    <zv:c l="rec20" k="WEE" de="Woche" en="week" fr="semaine"/>
    <zv:c l="rec20" k="WG" en="wine gallon"/>
    <zv:c l="rec20" k="WHR" en="watt hour"/>
    <zv:c l="rec20" k="WM" en="working month"/>
    <zv:c l="rec20" k="WSD" en="standard"/>
    <zv:c l="rec20" k="WTT" en="watt"/>
    <zv:c l="rec20" k="X1" en="Gunter's chain"/>
    <zv:c l="rec20" k="X1A" en="Drum, steel"/>
    <zv:c l="rec20" k="X1B" en="Drum, aluminium"/>
    <zv:c l="rec20" k="X1D" en="Drum, plywood"/>
    <zv:c l="rec20" k="X1F" en="Container, flexible"/>
    <zv:c l="rec20" k="X1G" en="Drum, fibre"/>
    <zv:c l="rec20" k="X1W" en="Drum, wooden"/>
    <zv:c l="rec20" k="X2C" en="Barrel, wooden"/>
    <zv:c l="rec20" k="X3A" en="Jerrican, steel"/>
    <zv:c l="rec20" k="X3H" en="Jerrican, plastic"/>
    <zv:c l="rec20" k="X43" en="Bag, super bulk"/>
    <zv:c l="rec20" k="X44" en="Bag, polybag"/>
    <zv:c l="rec20" k="X4A" en="Box, steel"/>
    <zv:c l="rec20" k="X4B" en="Box, aluminium"/>
    <zv:c l="rec20" k="X4C" en="Box, natural wood"/>
    <zv:c l="rec20" k="X4D" en="Box, plywood"/>
    <zv:c l="rec20" k="X4F" en="Box, reconstituted wood"/>
    <zv:c l="rec20" k="X4G" en="Box, fibreboard"/>
    <zv:c l="rec20" k="X4H" en="Box, plastic"/>
    <zv:c l="rec20" k="X5H" en="Bag, woven plastic"/>
    <zv:c l="rec20" k="X5L" en="Bag, textile"/>
    <zv:c l="rec20" k="X5M" en="Bag, paper"/>
    <zv:c l="rec20" k="X6H" en="Composite packaging, plastic receptacle"/>
    <zv:c l="rec20" k="X6P" en="Composite packaging, glass receptacle"/>
    <zv:c l="rec20" k="X7A" en="Case, car"/>
    <zv:c l="rec20" k="X7B" en="Case, wooden"/>
    <zv:c l="rec20" k="X8A" en="Pallet, wooden"/>
    <zv:c l="rec20" k="X8B" en="Crate, wooden"/>
    <zv:c l="rec20" k="X8C" en="Bundle, wooden"/>
    <zv:c l="rec20" k="XAA" en="Intermediate bulk container, rigid plastic"/>
    <zv:c l="rec20" k="XAB" en="Receptacle, fibre"/>
    <zv:c l="rec20" k="XAC" en="Receptacle, paper"/>
    <zv:c l="rec20" k="XAD" en="Receptacle, wooden"/>
    <zv:c l="rec20" k="XAE" en="Aerosol"/>
    <zv:c l="rec20" k="XAF" en="Pallet, modular, collars 80cms * 60cms"/>
    <zv:c l="rec20" k="XAG" en="Pallet, shrinkwrapped"/>
    <zv:c l="rec20" k="XAH" en="Pallet, 100cms * 110cms"/>
    <zv:c l="rec20" k="XAI" en="Clamshell"/>
    <zv:c l="rec20" k="XAJ" en="Cone"/>
    <zv:c l="rec20" k="XAL" en="Ball"/>
    <zv:c l="rec20" k="XAM" en="Ampoule, non-protected"/>
    <zv:c l="rec20" k="XAP" en="Ampoule, protected"/>
    <zv:c l="rec20" k="XAT" en="Atomizer"/>
    <zv:c l="rec20" k="XAV" en="Capsule"/>
    <zv:c l="rec20" k="XB4" en="Belt"/>
    <zv:c l="rec20" k="XBA" en="Barrel"/>
    <zv:c l="rec20" k="XBB" en="Bobbin"/>
    <zv:c l="rec20" k="XBC" en="Bottlecrate / bottlerack"/>
    <zv:c l="rec20" k="XBD" en="Board"/>
    <zv:c l="rec20" k="XBE" de="Bündel" en="bundle" fr="botte"/>
    <zv:c l="rec20" k="XBF" en="Balloon, non-protected"/>
    <zv:c l="rec20" k="XBG" de="Beutel" en="bag" fr="sac"/>
    <zv:c l="rec20" k="XBH" en="Bunch"/>
    <zv:c l="rec20" k="XBI" en="Bin"/>
    <zv:c l="rec20" k="XBJ" en="Bucket"/>
    <zv:c l="rec20" k="XBK" en="Basket"/>
    <zv:c l="rec20" k="XBL" en="Bale, compressed"/>
    <zv:c l="rec20" k="XBM" en="Basin"/>
    <zv:c l="rec20" k="XBN" en="Bale, non-compressed"/>
    <zv:c l="rec20" k="XBO" de="Flasche" en="bottle" fr="bouteille"/>
    <zv:c l="rec20" k="XBP" en="Balloon, protected"/>
    <zv:c l="rec20" k="XBQ" en="Bottle, protected cylindrical"/>
    <zv:c l="rec20" k="XBR" en="Bar"/>
    <zv:c l="rec20" k="XBS" en="Bottle, non-protected, bulbous"/>
    <zv:c l="rec20" k="XBT" en="Bolt"/>
    <zv:c l="rec20" k="XBU" en="Butt"/>
    <zv:c l="rec20" k="XBV" en="Bottle, protected bulbous"/>
    <zv:c l="rec20" k="XBW" en="Box, for liquids"/>
    <zv:c l="rec20" k="XBX" de="Karton" en="box" fr="boîte"/>
    <zv:c l="rec20" k="XBY" en="Board, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XBZ" en="Bars, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XCA" de="Dose" en="can" fr="boîte métallique"/>
    <zv:c l="rec20" k="XCB" en="Crate, beer"/>
    <zv:c l="rec20" k="XCC" en="Churn"/>
    <zv:c l="rec20" k="XCD" en="Can, with handle and spout"/>
    <zv:c l="rec20" k="XCE" en="Creel"/>
    <zv:c l="rec20" k="XCF" en="Coffer"/>
    <zv:c l="rec20" k="XCG" en="Cage"/>
    <zv:c l="rec20" k="XCH" en="Chest"/>
    <zv:c l="rec20" k="XCI" en="Canister"/>
    <zv:c l="rec20" k="XCJ" en="Coffin"/>
    <zv:c l="rec20" k="XCK" en="Cask"/>
    <zv:c l="rec20" k="XCL" en="Coil"/>
    <zv:c l="rec20" k="XCM" en="Card"/>
    <zv:c l="rec20" k="XCN" en="Container, not otherwise specified as transport equipment"/>
    <zv:c l="rec20" k="XCO" en="Carboy, non-protected"/>
    <zv:c l="rec20" k="XCP" en="Carboy, protected"/>
    <zv:c l="rec20" k="XCQ" en="Cartridge"/>
    <zv:c l="rec20" k="XCR" de="Kiste" en="crate" fr="caisse"/>
    <zv:c l="rec20" k="XCS" en="Case"/>
    <zv:c l="rec20" k="XCT" de="Karton" en="carton" fr="carton"/>
    <zv:c l="rec20" k="XCU" en="Cup"/>
    <zv:c l="rec20" k="XCV" en="Cover"/>
    <zv:c l="rec20" k="XCW" en="Cage, roll"/>
    <zv:c l="rec20" k="XCX" en="Can, cylindrical"/>
    <zv:c l="rec20" k="XCY" en="Cylinder"/>
    <zv:c l="rec20" k="XCZ" en="Canvas"/>
    <zv:c l="rec20" k="XDA" en="Crate, multiple layer, plastic"/>
    <zv:c l="rec20" k="XDB" en="Crate, multiple layer, wooden"/>
    <zv:c l="rec20" k="XDC" en="Crate, multiple layer, cardboard"/>
    <zv:c l="rec20" k="XDG" en="Cage, Commonwealth Handling Equipment Pool (CHEP)"/>
    <zv:c l="rec20" k="XDH" en="Box, Commonwealth Handling Equipment Pool (CHEP), Eurobox"/>
    <zv:c l="rec20" k="XDI" en="Drum, iron"/>
    <zv:c l="rec20" k="XDJ" en="Demijohn, non-protected"/>
    <zv:c l="rec20" k="XDK" en="Crate, bulk, cardboard"/>
    <zv:c l="rec20" k="XDL" en="Crate, bulk, plastic"/>
    <zv:c l="rec20" k="XDM" en="Crate, bulk, wooden"/>
    <zv:c l="rec20" k="XDN" en="Dispenser"/>
    <zv:c l="rec20" k="XDP" en="Demijohn, protected"/>
    <zv:c l="rec20" k="XDR" en="Drum"/>
    <zv:c l="rec20" k="XDS" en="Tray, one layer no cover, plastic"/>
    <zv:c l="rec20" k="XDT" en="Tray, one layer no cover, wooden"/>
    <zv:c l="rec20" k="XDU" en="Tray, one layer no cover, polystyrene"/>
    <zv:c l="rec20" k="XDV" en="Tray, one layer no cover, cardboard"/>
    <zv:c l="rec20" k="XDW" en="Tray, two layers no cover, plastic tray"/>
    <zv:c l="rec20" k="XDX" en="Tray, two layers no cover, wooden"/>
    <zv:c l="rec20" k="XDY" en="Tray, two layers no cover, cardboard"/>
    <zv:c l="rec20" k="XEC" en="Bag, plastic"/>
    <zv:c l="rec20" k="XED" en="Case, with pallet base"/>
    <zv:c l="rec20" k="XEE" en="Case, with pallet base, wooden"/>
    <zv:c l="rec20" k="XEF" en="Case, with pallet base, cardboard"/>
    <zv:c l="rec20" k="XEG" en="Case, with pallet base, plastic"/>
    <zv:c l="rec20" k="XEH" en="Case, with pallet base, metal"/>
    <zv:c l="rec20" k="XEI" en="Case, isothermic"/>
    <zv:c l="rec20" k="XEN" en="Envelope"/>
    <zv:c l="rec20" k="XFB" en="Flexibag"/>
    <zv:c l="rec20" k="XFC" en="Crate, fruit"/>
    <zv:c l="rec20" k="XFD" en="Crate, framed"/>
    <zv:c l="rec20" k="XFE" en="Flexitank"/>
    <zv:c l="rec20" k="XFI" en="Firkin"/>
    <zv:c l="rec20" k="XFL" en="Flask"/>
    <zv:c l="rec20" k="XFO" en="Footlocker"/>
    <zv:c l="rec20" k="XFP" en="Filmpack"/>
    <zv:c l="rec20" k="XFR" en="Frame"/>
    <zv:c l="rec20" k="XFT" en="Foodtainer"/>
    <zv:c l="rec20" k="XFW" en="Cart, flatbed"/>
    <zv:c l="rec20" k="XFX" en="Bag, flexible container"/>
    <zv:c l="rec20" k="XGB" en="Bottle, gas"/>
    <zv:c l="rec20" k="XGI" en="Girder"/>
    <zv:c l="rec20" k="XGL" en="Container, gallon"/>
    <zv:c l="rec20" k="XGR" en="Receptacle, glass"/>
    <zv:c l="rec20" k="XGU" en="Tray, containing horizontally stacked flat items"/>
    <zv:c l="rec20" k="XGY" en="Bag, gunny"/>
    <zv:c l="rec20" k="XGZ" en="Girders, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XHA" en="Basket, with handle, plastic"/>
    <zv:c l="rec20" k="XHB" en="Basket, with handle, wooden"/>
    <zv:c l="rec20" k="XHC" en="Basket, with handle, cardboard"/>
    <zv:c l="rec20" k="XHG" en="Hogshead"/>
    <zv:c l="rec20" k="XHN" en="Hanger"/>
    <zv:c l="rec20" k="XHR" en="Hamper"/>
    <zv:c l="rec20" k="XIA" en="Package, display, wooden"/>
    <zv:c l="rec20" k="XIB" en="Package, display, cardboard"/>
    <zv:c l="rec20" k="XIC" en="Package, display, plastic"/>
    <zv:c l="rec20" k="XID" en="Package, display, metal"/>
    <zv:c l="rec20" k="XIE" en="Package, show"/>
    <zv:c l="rec20" k="XIF" en="Package, flow"/>
    <zv:c l="rec20" k="XIG" en="Package, paper wrapped"/>
    <zv:c l="rec20" k="XIH" en="Drum, plastic"/>
    <zv:c l="rec20" k="XIK" en="Package, cardboard, with bottle grip-holes"/>
    <zv:c l="rec20" k="XIL" en="Tray, rigid, lidded stackable (CEN TS 14482:2002)"/>
    <zv:c l="rec20" k="XIN" en="Ingot"/>
    <zv:c l="rec20" k="XIZ" en="Ingots, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XJB" en="Bag, jumbo"/>
    <zv:c l="rec20" k="XJC" en="Jerrican, rectangular"/>
    <zv:c l="rec20" k="XJG" en="Jug"/>
    <zv:c l="rec20" k="XJR" en="Jar"/>
    <zv:c l="rec20" k="XJT" en="Jutebag"/>
    <zv:c l="rec20" k="XJY" en="Jerrican, cylindrical"/>
    <zv:c l="rec20" k="XKG" en="Keg"/>
    <zv:c l="rec20" k="XKI" de="Bausatz" en="kit" fr="kit"/>
    <zv:c l="rec20" k="XLE" en="Luggage"/>
    <zv:c l="rec20" k="XLG" en="Log"/>
    <zv:c l="rec20" k="XLT" en="Lot"/>
    <zv:c l="rec20" k="XLU" en="Lug"/>
    <zv:c l="rec20" k="XLV" en="Liftvan"/>
    <zv:c l="rec20" k="XLZ" en="Logs, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XMA" en="Crate, metal"/>
    <zv:c l="rec20" k="XMB" en="Bag, multiply"/>
    <zv:c l="rec20" k="XMC" en="Crate, milk"/>
    <zv:c l="rec20" k="XME" en="Container, metal"/>
    <zv:c l="rec20" k="XMR" en="Receptacle, metal"/>
    <zv:c l="rec20" k="XMS" en="Sack, multi-wall"/>
    <zv:c l="rec20" k="XMT" en="Mat"/>
    <zv:c l="rec20" k="XMW" en="Receptacle, plastic wrapped"/>
    <zv:c l="rec20" k="XMX" en="Matchbox"/>
    <zv:c l="rec20" k="XNA" en="Not available"/>
    <zv:c l="rec20" k="XNE" en="Unpacked or unpackaged"/>
    <zv:c l="rec20" k="XNF" en="Unpacked or unpackaged, single unit"/>
    <zv:c l="rec20" k="XNG" en="Unpacked or unpackaged, multiple units"/>
    <zv:c l="rec20" k="XNS" en="Nest"/>
    <zv:c l="rec20" k="XNT" en="Net"/>
    <zv:c l="rec20" k="XNU" en="Net, tube, plastic"/>
    <zv:c l="rec20" k="XNV" en="Net, tube, textile"/>
    <zv:c l="rec20" k="XO1" en="Two sided cage on wheels with fixing strap"/>
    <zv:c l="rec20" k="XO2" en="Trolley"/>
    <zv:c l="rec20" k="XO3" en="Oneway pallet ISO 0 - 1/2 EURO Pallet"/>
    <zv:c l="rec20" k="XO4" en="Oneway pallet ISO 1 - 1/1 EURO Pallet"/>
    <zv:c l="rec20" k="XO5" en="Oneway pallet ISO 2 - 2/1 EURO Pallet"/>
    <zv:c l="rec20" k="XO6" en="Pallet with exceptional dimensions"/>
    <zv:c l="rec20" k="XO7" en="Wooden pallet 40 cm x 80 cm"/>
    <zv:c l="rec20" k="XO8" en="Plastic pallet SRS 60 cm x 80 cm"/>
    <zv:c l="rec20" k="XO9" en="Plastic pallet SRS 80 cm x 120 cm"/>
    <zv:c l="rec20" k="XOA" en="Pallet, CHEP 40 cm x 60 cm"/>
    <zv:c l="rec20" k="XOB" en="Pallet, CHEP 80 cm x 120 cm"/>
    <zv:c l="rec20" k="XOC" en="Pallet, CHEP 100 cm x 120 cm"/>
    <zv:c l="rec20" k="XOD" en="Pallet, AS 4068-1993"/>
    <zv:c l="rec20" k="XOE" en="Pallet, ISO T11"/>
    <zv:c l="rec20" k="XOF" en="Platform, unspecified weight or dimension"/>
    <zv:c l="rec20" k="XOG" en="Pallet ISO 0 - 1/2 EURO Pallet"/>
    <zv:c l="rec20" k="XOH" en="Pallet ISO 1 - 1/1 EURO Pallet"/>
    <zv:c l="rec20" k="XOI" en="Pallet ISO 2 – 2/1 EURO Pallet"/>
    <zv:c l="rec20" k="XOJ" en="1/4 EURO Pallet"/>
    <zv:c l="rec20" k="XOK" en="Block"/>
    <zv:c l="rec20" k="XOL" en="1/8 EURO Pallet"/>
    <zv:c l="rec20" k="XOM" en="Synthetic pallet ISO 1"/>
    <zv:c l="rec20" k="XON" en="Synthetic pallet ISO 2"/>
    <zv:c l="rec20" k="XOP" en="Wholesaler pallet"/>
    <zv:c l="rec20" k="XOQ" en="Pallet 80 X 100 cm"/>
    <zv:c l="rec20" k="XOR" en="Pallet 60 X 100 cm"/>
    <zv:c l="rec20" k="XOS" en="Oneway pallet"/>
    <zv:c l="rec20" k="XOT" en="Octabin"/>
    <zv:c l="rec20" k="XOU" en="Container, outer"/>
    <zv:c l="rec20" k="XOV" en="Returnable pallet"/>
    <zv:c l="rec20" k="XOW" en="Large bag, pallet sized"/>
    <zv:c l="rec20" k="XOX" en="A wheeled pallet with raised rim (81 x 67 x 135)"/>
    <zv:c l="rec20" k="XOY" en="A Wheeled pallet with raised rim (81 x 72 x 135)"/>
    <zv:c l="rec20" k="XOZ" en="Wheeled pallet with raised rim ( 81 x 60 x 16)"/>
    <zv:c l="rec20" k="XP1" en="CHEP pallet 60 cm x 80 cm"/>
    <zv:c l="rec20" k="XP2" en="Pan"/>
    <zv:c l="rec20" k="XP3" en="LPR pallet 60 cm x 80 cm"/>
    <zv:c l="rec20" k="XP4" en="LPR pallet 80 cm x 120 cm"/>
    <zv:c l="rec20" k="XPA" de="Päckchen" en="packet" fr="paquet"/>
    <zv:c l="rec20" k="XPB" en="Pallet, box Combined open-ended box and pallet"/>
    <zv:c l="rec20" k="XPC" en="Parcel"/>
    <zv:c l="rec20" k="XPD" en="Pallet, modular, collars 80cms * 100cms"/>
    <zv:c l="rec20" k="XPE" en="Pallet, modular, collars 80cms * 120cms"/>
    <zv:c l="rec20" k="XPF" en="Pen"/>
    <zv:c l="rec20" k="XPG" en="Plate"/>
    <zv:c l="rec20" k="XPH" en="Pitcher"/>
    <zv:c l="rec20" k="XPI" en="Pipe"/>
    <zv:c l="rec20" k="XPJ" en="Punnet"/>
    <zv:c l="rec20" k="XPK" de="Packung" en="package" fr="paquet"/>
    <zv:c l="rec20" k="XPL" en="Pail"/>
    <zv:c l="rec20" k="XPN" en="Plank"/>
    <zv:c l="rec20" k="XPO" en="Pouch"/>
    <zv:c l="rec20" k="XPP" de="Stück" en="piece" fr="pièce"/>
    <zv:c l="rec20" k="XPR" en="Receptacle, plastic"/>
    <zv:c l="rec20" k="XPT" en="Pot"/>
    <zv:c l="rec20" k="XPU" en="Tray"/>
    <zv:c l="rec20" k="XPV" en="Pipes, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XPX" de="Palette" en="pallet" fr="palette"/>
    <zv:c l="rec20" k="XPY" en="Plates, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XPZ" en="Planks, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XQA" en="Drum, steel, non-removable head"/>
    <zv:c l="rec20" k="XQB" en="Drum, steel, removable head"/>
    <zv:c l="rec20" k="XQC" en="Drum, aluminium, non-removable head"/>
    <zv:c l="rec20" k="XQD" en="Drum, aluminium, removable head"/>
    <zv:c l="rec20" k="XQF" en="Drum, plastic, non-removable head"/>
    <zv:c l="rec20" k="XQG" en="Drum, plastic, removable head"/>
    <zv:c l="rec20" k="XQH" en="Barrel, wooden, bung type"/>
    <zv:c l="rec20" k="XQJ" en="Barrel, wooden, removable head"/>
    <zv:c l="rec20" k="XQK" en="Jerrican, steel, non-removable head"/>
    <zv:c l="rec20" k="XQL" en="Jerrican, steel, removable head"/>
    <zv:c l="rec20" k="XQM" en="Jerrican, plastic, non-removable head"/>
    <zv:c l="rec20" k="XQN" en="Jerrican, plastic, removable head"/>
    <zv:c l="rec20" k="XQP" en="Box, wooden, natural wood, ordinary"/>
    <zv:c l="rec20" k="XQQ" en="Box, wooden, natural wood, with sift proof walls"/>
    <zv:c l="rec20" k="XQR" en="Box, plastic, expanded"/>
    <zv:c l="rec20" k="XQS" en="Box, plastic, solid"/>
    <zv:c l="rec20" k="XRD" en="Rod"/>
    <zv:c l="rec20" k="XRG" en="Ring"/>
    <zv:c l="rec20" k="XRJ" en="Rack, clothing hanger"/>
    <zv:c l="rec20" k="XRK" en="Rack"/>
    <zv:c l="rec20" k="XRL" en="Reel"/>
    <zv:c l="rec20" k="XRO" de="Rolle" en="roll" fr="rouleau"/>
    <zv:c l="rec20" k="XRT" en="Rednet"/>
    <zv:c l="rec20" k="XRZ" en="Rods, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XSA" de="Sack" en="sack" fr="sac"/>
    <zv:c l="rec20" k="XSB" en="Slab"/>
    <zv:c l="rec20" k="XSC" en="Crate, shallow"/>
    <zv:c l="rec20" k="XSD" en="Spindle"/>
    <zv:c l="rec20" k="XSE" en="Sea-chest"/>
    <zv:c l="rec20" k="XSH" en="Sachet"/>
    <zv:c l="rec20" k="XSI" en="Skid"/>
    <zv:c l="rec20" k="XSK" en="Case, skeleton"/>
    <zv:c l="rec20" k="XSL" en="Slipsheet"/>
    <zv:c l="rec20" k="XSM" en="Sheetmetal"/>
    <zv:c l="rec20" k="XSO" en="Spool"/>
    <zv:c l="rec20" k="XSP" en="Sheet, plastic wrapping"/>
    <zv:c l="rec20" k="XSS" en="Case, steel"/>
    <zv:c l="rec20" k="XST" de="Blatt" en="sheet" fr="feuille"/>
    <zv:c l="rec20" k="XSU" en="Suitcase"/>
    <zv:c l="rec20" k="XSV" en="Envelope, steel"/>
    <zv:c l="rec20" k="XSW" en="Shrinkwrapped"/>
    <zv:c l="rec20" k="XSX" de="Satz" en="set" fr="ensemble"/>
    <zv:c l="rec20" k="XSY" en="Sleeve"/>
    <zv:c l="rec20" k="XSZ" en="Sheets, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XT1" en="Tablet"/>
    <zv:c l="rec20" k="XTB" en="Tub"/>
    <zv:c l="rec20" k="XTC" en="Tea-chest"/>
    <zv:c l="rec20" k="XTD" en="Tube, collapsible"/>
    <zv:c l="rec20" k="XTE" en="Tyre"/>
    <zv:c l="rec20" k="XTG" en="Tank container, generic"/>
    <zv:c l="rec20" k="XTI" en="Tierce"/>
    <zv:c l="rec20" k="XTK" en="Tank, rectangular"/>
    <zv:c l="rec20" k="XTL" en="Tub, with lid"/>
    <zv:c l="rec20" k="XTN" en="Tin"/>
    <zv:c l="rec20" k="XTO" en="Tun"/>
    <zv:c l="rec20" k="XTR" en="Trunk"/>
    <zv:c l="rec20" k="XTS" en="Truss"/>
    <zv:c l="rec20" k="XTT" en="Bag, tote"/>
    <zv:c l="rec20" k="XTU" de="Tube" en="tube" fr="tube"/>
    <zv:c l="rec20" k="XTV" en="Tube, with nozzle"/>
    <zv:c l="rec20" k="XTW" en="Pallet, triwall"/>
    <zv:c l="rec20" k="XTY" en="Tank, cylindrical"/>
    <zv:c l="rec20" k="XTZ" en="Tubes, in bundle/bunch/truss"/>
    <zv:c l="rec20" k="XUC" en="Uncaged"/>
    <zv:c l="rec20" k="XUN" en="Unit"/>
    <zv:c l="rec20" k="XVA" en="Vat"/>
    <zv:c l="rec20" k="XVG" en="Bulk, gas (at 1031 mbar and 15°C)"/>
    <zv:c l="rec20" k="XVI" en="Vial"/>
    <zv:c l="rec20" k="XVK" en="Vanpack"/>
    <zv:c l="rec20" k="XVL" en="Bulk, liquid"/>
    <zv:c l="rec20" k="XVN" en="Vehicle"/>
    <zv:c l="rec20" k="XVO" en="Bulk, solid, large particles (“nodules”)"/>
    <zv:c l="rec20" k="XVP" en="Vacuum-packed"/>
    <zv:c l="rec20" k="XVQ" en="Bulk, liquefied gas (at abnormal temperature/pressure)"/>
    <zv:c l="rec20" k="XVR" en="Bulk, solid, granular particles (“grains”)"/>
    <zv:c l="rec20" k="XVS" en="Bulk, scrap metal"/>
    <zv:c l="rec20" k="XVY" en="Bulk, solid, fine particles (“powders”)"/>
    <zv:c l="rec20" k="XWA" en="Intermediate bulk container"/>
    <zv:c l="rec20" k="XWB" en="Wickerbottle"/>
    <zv:c l="rec20" k="XWC" en="Intermediate bulk container, steel"/>
    <zv:c l="rec20" k="XWD" en="Intermediate bulk container, aluminium"/>
    <zv:c l="rec20" k="XWF" en="Intermediate bulk container, metal"/>
    <zv:c l="rec20" k="XWG" en="Intermediate bulk container, steel, pressurised &gt; 10 kpa"/>
    <zv:c l="rec20" k="XWH" en="Intermediate bulk container, aluminium, pressurised &gt; 10 kpa"/>
    <zv:c l="rec20" k="XWJ" en="Intermediate bulk container, metal, pressure 10 kpa"/>
    <zv:c l="rec20" k="XWK" en="Intermediate bulk container, steel, liquid"/>
    <zv:c l="rec20" k="XWL" en="Intermediate bulk container, aluminium, liquid"/>
    <zv:c l="rec20" k="XWM" en="Intermediate bulk container, metal, liquid"/>
    <zv:c l="rec20" k="XWN" en="Intermediate bulk container, woven plastic, without coat/liner"/>
    <zv:c l="rec20" k="XWP" en="Intermediate bulk container, woven plastic, coated"/>
    <zv:c l="rec20" k="XWQ" en="Intermediate bulk container, woven plastic, with liner"/>
    <zv:c l="rec20" k="XWR" en="Intermediate bulk container, woven plastic, coated and liner"/>
    <zv:c l="rec20" k="XWS" en="Intermediate bulk container, plastic film"/>
    <zv:c l="rec20" k="XWT" en="Intermediate bulk container, textile with out coat/liner"/>
    <zv:c l="rec20" k="XWU" en="Intermediate bulk container, natural wood, with inner liner"/>
    <zv:c l="rec20" k="XWV" en="Intermediate bulk container, textile, coated"/>
    <zv:c l="rec20" k="XWW" en="Intermediate bulk container, textile, with liner"/>
    <zv:c l="rec20" k="XWX" en="Intermediate bulk container, textile, coated and liner"/>
    <zv:c l="rec20" k="XWY" en="Intermediate bulk container, plywood, with inner liner"/>
    <zv:c l="rec20" k="XWZ" en="Intermediate bulk container, reconstituted wood, with inner liner"/>
    <zv:c l="rec20" k="XXA" en="Bag, woven plastic, without inner coat/liner"/>
    <zv:c l="rec20" k="XXB" en="Bag, woven plastic, sift proof"/>
    <zv:c l="rec20" k="XXC" en="Bag, woven plastic, water resistant"/>
    <zv:c l="rec20" k="XXD" en="Bag, plastics film"/>
    <zv:c l="rec20" k="XXF" en="Bag, textile, without inner coat/liner"/>
    <zv:c l="rec20" k="XXG" en="Bag, textile, sift proof"/>
    <zv:c l="rec20" k="XXH" en="Bag, textile, water resistant"/>
    <zv:c l="rec20" k="XXJ" en="Bag, paper, multi-wall"/>
    <zv:c l="rec20" k="XXK" en="Bag, paper, multi-wall, water resistant"/>
    <zv:c l="rec20" k="XYA" en="Composite packaging, plastic receptacle in steel drum"/>
    <zv:c l="rec20" k="XYB" en="Composite packaging, plastic receptacle in steel crate box"/>
    <zv:c l="rec20" k="XYC" en="Composite packaging, plastic receptacle in aluminium drum"/>
    <zv:c l="rec20" k="XYD" en="Composite packaging, plastic receptacle in aluminium crate"/>
    <zv:c l="rec20" k="XYF" en="Composite packaging, plastic receptacle in wooden box"/>
    <zv:c l="rec20" k="XYG" en="Composite packaging, plastic receptacle in plywood drum"/>
    <zv:c l="rec20" k="XYH" en="Composite packaging, plastic receptacle in plywood box"/>
    <zv:c l="rec20" k="XYJ" en="Composite packaging, plastic receptacle in fibre drum"/>
    <zv:c l="rec20" k="XYK" en="Composite packaging, plastic receptacle in fibreboard box"/>
    <zv:c l="rec20" k="XYL" en="Composite packaging, plastic receptacle in plastic drum"/>
    <zv:c l="rec20" k="XYM" en="Composite packaging, plastic receptacle in solid plastic box"/>
    <zv:c l="rec20" k="XYN" en="Composite packaging, glass receptacle in steel drum"/>
    <zv:c l="rec20" k="XYP" en="Composite packaging, glass receptacle in steel crate box"/>
    <zv:c l="rec20" k="XYQ" en="Composite packaging, glass receptacle in aluminium drum"/>
    <zv:c l="rec20" k="XYR" en="Composite packaging, glass receptacle in aluminium crate"/>
    <zv:c l="rec20" k="XYS" en="Composite packaging, glass receptacle in wooden box"/>
    <zv:c l="rec20" k="XYT" en="Composite packaging, glass receptacle in plywood drum"/>
    <zv:c l="rec20" k="XYV" en="Composite packaging, glass receptacle in wickerwork hamper"/>
    <zv:c l="rec20" k="XYW" en="Composite packaging, glass receptacle in fibre drum"/>
    <zv:c l="rec20" k="XYX" en="Composite packaging, glass receptacle in fibreboard box"/>
    <zv:c l="rec20" k="XYY" en="Composite packaging, glass receptacle in expandable plastic pack"/>
    <zv:c l="rec20" k="XYZ" en="Composite packaging, glass receptacle in solid plastic pack"/>
    <zv:c l="rec20" k="XZA" en="Intermediate bulk container, paper, multi-wall"/>
    <zv:c l="rec20" k="XZB" en="Bag, large"/>
    <zv:c l="rec20" k="XZC" en="Intermediate bulk container, paper, multi-wall, water resistant"/>
    <zv:c l="rec20" k="XZD" en="Intermediate bulk container, rigid plastic, with structural equipment, solids"/>
    <zv:c l="rec20" k="XZF" en="Intermediate bulk container, rigid plastic, freestanding, solids"/>
    <zv:c l="rec20" k="XZG" en="Intermediate bulk container, rigid plastic, with structural equipment, pressurised"/>
    <zv:c l="rec20" k="XZH" en="Intermediate bulk container, rigid plastic, freestanding, pressurised"/>
    <zv:c l="rec20" k="XZJ" en="Intermediate bulk container, rigid plastic, with structural equipment, liquids"/>
    <zv:c l="rec20" k="XZK" en="Intermediate bulk container, rigid plastic, freestanding, liquids"/>
    <zv:c l="rec20" k="XZL" en="Intermediate bulk container, composite, rigid plastic, solids"/>
    <zv:c l="rec20" k="XZM" en="Intermediate bulk container, composite, flexible plastic, solids"/>
    <zv:c l="rec20" k="XZN" en="Intermediate bulk container, composite, rigid plastic, pressurised"/>
    <zv:c l="rec20" k="XZP" en="Intermediate bulk container, composite, flexible plastic, pressurised"/>
    <zv:c l="rec20" k="XZQ" en="Intermediate bulk container, composite, rigid plastic, liquids"/>
    <zv:c l="rec20" k="XZR" en="Intermediate bulk container, composite, flexible plastic, liquids"/>
    <zv:c l="rec20" k="XZS" en="Intermediate bulk container, composite"/>
    <zv:c l="rec20" k="XZT" en="Intermediate bulk container, fibreboard"/>
    <zv:c l="rec20" k="XZU" en="Intermediate bulk container, flexible"/>
    <zv:c l="rec20" k="XZV" en="Intermediate bulk container, metal, other than steel"/>
    <zv:c l="rec20" k="XZW" en="Intermediate bulk container, natural wood"/>
    <zv:c l="rec20" k="XZX" en="Intermediate bulk container, plywood"/>
    <zv:c l="rec20" k="XZY" en="Intermediate bulk container, reconstituted wood"/>
    <zv:c l="rec20" k="XZZ" en="Mutually defined"/>
    <zv:c l="rec20" k="YDK" en="square yard"/>
    <zv:c l="rec20" k="YDQ" en="cubic yard"/>
    <zv:c l="rec20" k="YRD" en="yard"/>
    <zv:c l="rec20" k="Z11" en="hanging container"/>
    <zv:c l="rec20" k="Z9" en="nanomole"/>
    <zv:c l="rec20" k="ZP" en="page"/>
    <zv:c l="rec20" k="ZZ" en="mutually defined"/>
    <zv:c l="vatex" k='For each different value of VAT rate (BT-119) where the VAT category code (BT-118) is equal to “S” ("Standard rated"), Absolute Value of (VAT category tax amount (BT-117) - VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119)/100) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level allowance amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Standard rated " (S), and the VAT rate (BT-152, BT-96, BT-103, BT-X-274) equals the VAT category rate (BT-119), and only for lines where the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value "DETAIL" or is not specified. or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592).One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.' en="Exempt based on article 153 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132" en="Exempt based on article 132 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1A" en="Exempt based on article 132, section 1 (a) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1B" en="Exempt based on article 132, section 1 (b) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1C" en="Exempt based on article 132, section 1 (c) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1D" en="Exempt based on article 132, section 1 (d) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1E" en="Exempt based on article 132, section 1 (e) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1F" en="Exempt based on article 132, section 1 (f) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1G" en="Exempt based on article 132, section 1 (g) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1H" en="Exempt based on article 132, section 1 (h) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1I" en="Exempt based on article 132, section 1 (i) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1J" en="Exempt based on article 132, section 1 (j) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1K" en="Exempt based on article 132, section 1 (k) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1L" en="Exempt based on article 132, section 1 (l) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1M" en="Exempt based on article 132, section 1 (m) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1N" en="Exempt based on article 132, section 1 (n) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1O" en="Exempt based on article 132, section 1 (o) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1P" en="Exempt based on article 132, section 1 (p) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-132-1Q" en="Exempt based on article 132, section 1 (q) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-135-1" en="Exempt based on article 135, section 1 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143" en="Exempt based on article 143 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1A" en="Exempt based on article 143, section 1 (a) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1B" en="Exempt based on article 143, section 1 (b) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1C" en="Exempt based on article 143, section 1 (c) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1D" en="Exempt based on article 143, section 1 (d) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1E" en="Exempt based on article 143, section 1 (e) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1F" en="Exempt based on article 143, section 1 (f) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1FA" en="Exempt based on article 143, section 1 (fa) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1G" en="Exempt based on article 143, section 1 (g) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1H" en="Exempt based on article 143, section 1 (h) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1I" en="Exempt based on article 143, section 1 (i) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1J" en="Exempt based on article 143, section 1 (j) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1K" en="Exempt based on article 143, section 1 (k) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-143-1L" en="Exempt based on article 143, section 1 (l) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-144" en="Exempt based on article 144 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-146-1E" en="Exempt based on article 146 section 1 (e) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148" en="Exempt based on article 148 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-A" en="Exempt based on article 148, section (a) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-B" en="Exempt based on article 148, section (b) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-C" en="Exempt based on article 148, section (c) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-D" en="Exempt based on article 148, section (d) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-E" en="Exempt based on article 148, section (e) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-F" en="Exempt based on article 148, section (f) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-148-G" en="Exempt based on article 148, section (g) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151" en="Exempt based on article 151 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151-1A" en="Exempt based on article 151, section 1 (a) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151-1AA" en="Exempt based on article 151, section 1 (aa) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151-1B" en="Exempt based on article 151, section 1 (b) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151-1C" en="Exempt based on article 151, section 1 (c) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151-1D" en="Exempt based on article 151, section 1 (d) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-151-1E" en="Exempt based on article 151, section 1 (e) of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-159" en="Exempt based on article 159 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-309" en="Exempt based on article 309 of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-79-C" en="Exempt based on article 79, point c of Council Directive 2006/112/EC"/>
    <zv:c l="vatex" k="VATEX-EU-AE" en="Reverse charge"/>
    <zv:c l="vatex" k="VATEX-EU-D" en="Travel agents VAT scheme."/>
    <zv:c l="vatex" k="VATEX-EU-F" en="Second hand goods VAT scheme."/>
    <zv:c l="vatex" k="VATEX-EU-G" en="Export outside the EU"/>
    <zv:c l="vatex" k="VATEX-EU-I" en="Works of art VAT scheme."/>
    <zv:c l="vatex" k="VATEX-EU-IC" en="Intra-community supply"/>
    <zv:c l="vatex" k="VATEX-EU-J" en="Collectors items and antiques VAT scheme."/>
    <zv:c l="vatex" k="VATEX-EU-O" en="Not subject to VAT"/>
    <zv:c l="vatex" k="VATEX-FR-298SEXDECIESA" en="Exempt based on article 298 sexdecies A of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-AE" en="Exempt based on 2 of article 283 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-1" en="Exempt based on 1 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-2" en="Exempt based on 2 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-3" en="Exempt based on 3 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-4" en="Exempt based on 4 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-5" en="Exempt based on 5 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-7" en="Exempt based on 7 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261-8" en="Exempt based on 8 of article 261 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261A" en="Exempt based on article 261 A of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261B" en="Exempt based on article 261 B of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261C-1" en="Exempt based on 1° of article 261 C of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261C-2" en="Exempt based on 2° of article 261 C of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261C-3" en="Exempt based on 3° of article 261 C of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261D-1" en="Exempt based on 1° of article 261 D of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261D-1BIS" en="Exempt based on 1°bis of article 261 D of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261D-2" en="Exempt based on 2° of article 261 D of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261D-3" en="Exempt based on 3° of article 261 D of the Code Général des Impôts (CGI ; General tax code) Exonération de TVA - Article 261 D-3° du Code Général des Impôts"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261D-4" en="Exempt based on 4° of article 261 D of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261E-1" en="Exempt based on 1° of article 261 E of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI261E-2" en="Exempt based on 2° of article 261 E of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI275" en="Exempt based on article 275 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI277A" en="Exempt based on article 277 A of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CGI295" en="Exempt based on article 295 of the Code Général des Impôts (CGI ; General tax code)"/>
    <zv:c l="vatex" k="VATEX-FR-CNWVAT" en="France domestic Credit Notes without VAT, due to supplier forfeit of VAT for discount"/>
    <zv:c l="vatex" k="VATEX-FR-FRANCHISE" en="France domestic VAT franchise in base"/>
    <zv:b p="ExchangedDocument" id="BT-1-00"/>
    <zv:b p="ExchangedDocument/CopyIndicator" id="BT-X-3-00"/>
    <zv:b p="ExchangedDocument/CopyIndicator/Indicator" id="BT-X-3"/>
    <zv:b p="ExchangedDocument/EffectiveSpecifiedPeriod" id="BT-X-6-000"/>
    <zv:b p="ExchangedDocument/EffectiveSpecifiedPeriod/CompleteDateTime" id="BT-X-6-00"/>
    <zv:b p="ExchangedDocument/EffectiveSpecifiedPeriod/CompleteDateTime/DateTimeString" id="BT-X-6"/>
    <zv:b p="ExchangedDocument/ID" id="BT-1"/>
    <zv:b p="ExchangedDocument/IncludedNote" id="BG-1"/>
    <zv:b p="ExchangedDocument/IncludedNote/Content" id="BT-22"/>
    <zv:b p="ExchangedDocument/IncludedNote/ContentCode" id="BT-X-5"/>
    <zv:b p="ExchangedDocument/IncludedNote/SubjectCode" id="BT-21"/>
    <zv:b p="ExchangedDocument/IssueDateTime" id="BT-2-00"/>
    <zv:b p="ExchangedDocument/IssueDateTime/DateTimeString" id="BT-2"/>
    <zv:b p="ExchangedDocument/LanguageID" id="BT-X-4"/>
    <zv:b p="ExchangedDocument/Name" id="BT-X-2"/>
    <zv:b p="ExchangedDocument/TypeCode" id="BT-3"/>
    <zv:b p="ExchangedDocumentContext" id="BG-2"/>
    <zv:b p="ExchangedDocumentContext/BusinessProcessSpecifiedDocumentContextParameter" id="BT-23-00"/>
    <zv:b p="ExchangedDocumentContext/BusinessProcessSpecifiedDocumentContextParameter/ID" id="BT-23"/>
    <zv:b p="ExchangedDocumentContext/GuidelineSpecifiedDocumentContextParameter" id="BT-24-00"/>
    <zv:b p="ExchangedDocumentContext/GuidelineSpecifiedDocumentContextParameter/ID" id="BT-24"/>
    <zv:b p="ExchangedDocumentContext/TestIndicator" id="BT-X-1-00"/>
    <zv:b p="ExchangedDocumentContext/TestIndicator/Indicator" id="BT-X-1"/>
    <zv:b p="SupplyChainTradeTransaction" id="BG-25-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement" id="BT-10-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument" id="BG-24 / BT-17-00 / BT-18-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/AttachmentBinaryObject" id="BT-125"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/FormattedIssueDateTime" id="BT-X-149-00 / BT-X-556-00 / BT-X-557-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-149 / BT-X-556 / BT-X-557"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/IssuerAssignedID" id="BT-122 / BT-17 / BT-18"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/Name" id="BT-123"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/ReferenceTypeCode" id="BT-18-1"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/TypeCode" id="BT-122-0 / BT-17-0 / BT-18-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/AdditionalReferencedDocument/URIID" id="BT-124"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ApplicableTradeDeliveryTerms" id="BG-X-22"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ApplicableTradeDeliveryTerms/DeliveryTypeCode" id="BT-X-562 / BT-X-145"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ApplicableTradeDeliveryTerms/RelevantTradeLocation" id="BG-X-88"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ApplicableTradeDeliveryTerms/RelevantTradeLocation/CountryID" id="BT-X-563"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ApplicableTradeDeliveryTerms/RelevantTradeLocation/Name" id="BT-X-564"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty" id="BG-X-62"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact" id="BG-X-64"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-414"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-418-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-418"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-417-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-417"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/PersonName" id="BT-X-413"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-416-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-416"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/DefinedTradeContact/TypeCode" id="BT-X-415"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/GlobalID" id="BT-X-409"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/ID" id="BT-X-408"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/Name" id="BT-X-406"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress" id="BG-X-65"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/CityName" id="BT-X-423"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/CountryID" id="BT-X-424"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-425"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/LineOne" id="BT-X-420"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/LineThree" id="BT-X-422"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/LineTwo" id="BT-X-421"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-419"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/RoleCode" id="BT-X-549"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization" id="BG-X-63"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-410"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-66"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-430"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-431"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-432"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-427"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-429"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-428"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-426"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-407"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedTaxRegistration" id="BT-X-411-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-411"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/URIUniversalCommunication" id="BT-X-412-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerAgentTradeParty/URIUniversalCommunication/URIID" id="BT-X-412"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerOrderReferencedDocument" id="BT-13-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerOrderReferencedDocument/FormattedIssueDateTime" id="BT-X-147-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerOrderReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-147"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerOrderReferencedDocument/IssuerAssignedID" id="BT-13"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerReference" id="BT-10"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty" id="BG-X-54"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact" id="BG-X-55"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-370"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-374-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-374"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-373-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-373"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/PersonName" id="BT-X-369"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-372-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-372"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/DefinedTradeContact/TypeCode" id="BT-X-371"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/GlobalID" id="BT-X-365"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/ID" id="BT-X-364"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/Name" id="BT-X-362"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress" id="BG-X-56"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/CityName" id="BT-X-379"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/CountryID" id="BT-X-380"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-381"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/LineOne" id="BT-X-376"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/LineThree" id="BT-X-378"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/LineTwo" id="BT-X-377"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-375"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/RoleCode" id="BT-X-546"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization" id="BG-X-58"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-366"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-57"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-386"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-387"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-388"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-383"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-385"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-384"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-382"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-363"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedTaxRegistration" id="BT-X-367-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-367"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/URIUniversalCommunication" id="BT-X-368-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTaxRepresentativeTradeParty/URIUniversalCommunication/URIID" id="BT-X-368"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty" id="BG-7"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact" id="BG-9"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/DepartmentName" id="BT-56-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-58-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-58"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-115-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-115"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/PersonName" id="BT-56"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-57-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-57"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/DefinedTradeContact/TypeCode" id="BT-X-318"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/Description" id="BT-X-334"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/GlobalID" id="BT-46-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/ID" id="BT-46"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/Name" id="BT-44"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress" id="BG-8"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/CityName" id="BT-52"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/CountryID" id="BT-55"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-54"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/LineOne" id="BT-50"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/LineThree" id="BT-163"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/LineTwo" id="BT-51"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/PostalTradeAddress/PostcodeCode" id="BT-53"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/RoleCode" id="BT-X-544"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization" id="BT-47-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/ID" id="BT-47"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-15"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-112"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-113"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-114"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-109"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-111"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-110"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-108"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-45"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedTaxRegistration" id="BT-48-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/SpecifiedTaxRegistration/ID" id="BT-48"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/URIUniversalCommunication" id="BT-49-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/BuyerTradeParty/URIUniversalCommunication/URIID" id="BT-49"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ContractReferencedDocument" id="BT-12-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ContractReferencedDocument/FormattedIssueDateTime" id="BT-X-148-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ContractReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-148"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ContractReferencedDocument/IssuerAssignedID" id="BT-12"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ContractReferencedDocument/ReferenceTypeCode" id="BT-X-405"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/InvoiceeTradeParty/RoleCode" id="BT-X-554"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/InvoicerTradeParty/RoleCode" id="BT-X-553"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty" id="BG-X-18"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact" id="BG-X-20"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-132"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-135-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-135"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-134-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-134"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/PersonName" id="BT-X-131"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-133-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-133"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/DefinedTradeContact/TypeCode" id="BT-X-320"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/GlobalID" id="BT-X-127"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/ID" id="BT-X-126"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/Name" id="BT-X-128"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress" id="BG-X-21"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/CityName" id="BT-X-140"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/CountryID" id="BT-X-141"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-142"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/LineOne" id="BT-X-137"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/LineThree" id="BT-X-139"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/LineTwo" id="BT-X-138"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-136"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/RoleCode" id="BT-X-548"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization" id="BG-X-19"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-129"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-60"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-400"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-401"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-402"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-397"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-399"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-398"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-396"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-130"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedTaxRegistration" id="BT-X-144-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-144"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/URIUniversalCommunication" id="BT-X-143-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ProductEndUserTradeParty/URIUniversalCommunication/URIID" id="BT-X-143"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/QuotationReferencedDocument" id="BG-X-61"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/QuotationReferencedDocument/FormattedIssueDateTime" id="BT-X-404-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/QuotationReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-404"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/QuotationReferencedDocument/IssuerAssignedID" id="BT-X-403"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty" id="BG-X-49"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact" id="BG-X-51"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-343"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-346-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-346"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-345-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-345"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/PersonName" id="BT-X-342"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-344-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-344"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/DefinedTradeContact/TypeCode" id="BT-X-347"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/GlobalID" id="BT-X-338"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/ID" id="BT-X-337"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/Name" id="BT-X-335"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress" id="BG-X-52"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/CityName" id="BT-X-352"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/CountryID" id="BT-X-353"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-354"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/LineOne" id="BT-X-349"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/LineThree" id="BT-X-351"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/LineTwo" id="BT-X-350"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-348"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/RoleCode" id="BT-X-545"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization" id="BG-X-50"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-339"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-53"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-359"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-360"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-361"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-356"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-358"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-357"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-355"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-336"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedTaxRegistration" id="BT-X-340-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-340"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/URIUniversalCommunication" id="BT-X-341-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SalesAgentTradeParty/URIUniversalCommunication/URIID" id="BT-X-341"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerOrderReferencedDocument" id="BT-14-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerOrderReferencedDocument/FormattedIssueDateTime" id="BT-X-146-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerOrderReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-146"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerOrderReferencedDocument/IssuerAssignedID" id="BT-14"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty" id="BG-11"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact" id="BG-X-17"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-121"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-124-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-124"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-123-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-123"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/PersonName" id="BT-X-120"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-122-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-122"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/DefinedTradeContact/TypeCode" id="BT-X-319"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/GlobalID" id="BT-X-117"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/ID" id="BT-X-116"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/Name" id="BT-62"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress" id="BG-12"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/CityName" id="BT-66"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/CountryID" id="BT-69"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-68"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/LineOne" id="BT-64"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/LineThree" id="BT-164"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/LineTwo" id="BT-65"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/PostalTradeAddress/PostcodeCode" id="BT-67"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/RoleCode" id="BT-X-547"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization" id="BG-X-16"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-118"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-59"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-393"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-394"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-395"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-390"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-392"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-391"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-389"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-119"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedTaxRegistration" id="BT-63-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/SpecifiedTaxRegistration/ID" id="BT-63"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/URIUniversalCommunication" id="BT-X-125-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTaxRepresentativeTradeParty/URIUniversalCommunication/URIID" id="BT-X-125"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty" id="BG-4"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact" id="BG-6"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/DepartmentName" id="BT-41-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-43-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-43"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-107-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-107"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/PersonName" id="BT-41"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-42-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-42"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/DefinedTradeContact/TypeCode" id="BT-X-317"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/Description" id="BT-33"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/GlobalID" id="BT-29-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/ID" id="BT-29"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/Name" id="BT-27"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress" id="BG-5"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/CityName" id="BT-37"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/CountryID" id="BT-40"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-39"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/LineOne" id="BT-35"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/LineThree" id="BT-162"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/LineTwo" id="BT-36"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/PostalTradeAddress/PostcodeCode" id="BT-38"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/RoleCode" id="BT-X-543"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization" id="BT-30-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/ID" id="BT-30"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-14"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-104"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-105"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-106"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-101"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-103"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-102"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-100"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-28"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedTaxRegistration" id="BT-31-00 / BT-32-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/SpecifiedTaxRegistration/ID" id="BT-31 / BT-32"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/URIUniversalCommunication" id="BT-34-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SellerTradeParty/URIUniversalCommunication/URIID" id="BT-34"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ShipFromTradeParty/RoleCode" id="BT-X-552"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ShipToTradeParty/RoleCode" id="BT-X-550"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SpecifiedProcuringProject" id="BT-11-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SpecifiedProcuringProject/ID" id="BT-11"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/SpecifiedProcuringProject/Name" id="BT-11-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/UltimateCustomerOrderReferencedDocument" id="BG-X-23"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/UltimateCustomerOrderReferencedDocument/FormattedIssueDateTime" id="BT-X-151-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/UltimateCustomerOrderReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-151"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/UltimateCustomerOrderReferencedDocument/IssuerAssignedID" id="BT-X-150"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/UltimateShipToTradeParty/RoleCode" id="BT-X-551"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery" id="BG-13-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ActualDeliverySupplyChainEvent" id="BT-72-000"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ActualDeliverySupplyChainEvent/OccurrenceDateTime" id="BT-72-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ActualDeliverySupplyChainEvent/OccurrenceDateTime/DateTimeString" id="BT-72"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DeliveryNoteReferencedDocument" id="BT-X-202-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DeliveryNoteReferencedDocument/FormattedIssueDateTime" id="BT-X-203-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DeliveryNoteReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-203"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DeliveryNoteReferencedDocument/IssuerAssignedID" id="BT-X-202"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DespatchAdviceReferencedDocument" id="BT-16-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DespatchAdviceReferencedDocument/FormattedIssueDateTime" id="BT-X-200-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DespatchAdviceReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-200"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/DespatchAdviceReferencedDocument/IssuerAssignedID" id="BT-16"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ReceivingAdviceReferencedDocument" id="BT-15-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ReceivingAdviceReferencedDocument/FormattedIssueDateTime" id="BT-X-201-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ReceivingAdviceReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-201"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ReceivingAdviceReferencedDocument/IssuerAssignedID" id="BT-15"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/RelatedSupplyChainConsignment" id="BG-X-24"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/RelatedSupplyChainConsignment/SpecifiedLogisticsTransportMovement" id="BT-X-152-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/RelatedSupplyChainConsignment/SpecifiedLogisticsTransportMovement/ModeCode" id="BT-X-152"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty" id="BG-X-30"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact" id="BG-X-31"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-187"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-190-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-190"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-189-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-189"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/PersonName" id="BT-X-186"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-188-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-188"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/DefinedTradeContact/TypeCode" id="BT-X-323"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/GlobalID" id="BT-X-182"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/ID" id="BT-X-181"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/Name" id="BT-X-183"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress" id="BG-X-32"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/CityName" id="BT-X-195"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/CountryID" id="BT-X-196"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-197"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/LineOne" id="BT-X-192"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/LineThree" id="BT-X-194"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/LineTwo" id="BT-X-193"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-191"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization" id="BT-X-184-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-184"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-69"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-451"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-452"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-453"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-448"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-450"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-449"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-447"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-185"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedTaxRegistration" id="BT-X-199-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-199"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/URIUniversalCommunication" id="BT-X-198-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipFromTradeParty/URIUniversalCommunication/URIID" id="BT-X-198"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty" id="BG-13"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact" id="BG-X-26"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-156"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-159-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-159"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-158-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-158"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/PersonName" id="BT-X-155"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-157-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-157"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/DefinedTradeContact/TypeCode" id="BT-X-321"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/GlobalID" id="BT-71-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/ID" id="BT-71"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/Name" id="BT-70"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress" id="BG-15"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/CityName" id="BT-77"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/CountryID" id="BT-80"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-79"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/LineOne" id="BT-75"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/LineThree" id="BT-165"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/LineTwo" id="BT-76"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/PostalTradeAddress/PostcodeCode" id="BT-78"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization" id="BG-X-25"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-153"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-67"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-437"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-438"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-439"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-434"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-436"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-435"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-433"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-154"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedTaxRegistration" id="BT-X-161-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-161"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/URIUniversalCommunication" id="BT-X-160-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/ShipToTradeParty/URIUniversalCommunication/URIID" id="BT-X-160"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty" id="BG-X-27"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact" id="BG-X-28"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-168"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-171-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-171"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-170-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-170"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/PersonName" id="BT-X-167"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-169-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-169"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/TypeCode" id="BT-X-322"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/GlobalID" id="BT-X-163"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/ID" id="BT-X-162"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/Name" id="BT-X-164"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress" id="BG-X-29"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/CityName" id="BT-X-176"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/CountryID" id="BT-X-177"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-178"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/LineOne" id="BT-X-173"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/LineThree" id="BT-X-175"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/LineTwo" id="BT-X-174"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-172"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization" id="BT-X-165-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-165"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-68"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-444"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-445"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-446"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-441"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-443"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-442"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-440"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-166"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedTaxRegistration" id="BT-X-180-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-180"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/URIUniversalCommunication" id="BT-X-179-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeDelivery/UltimateShipToTradeParty/URIUniversalCommunication/URIID" id="BT-X-179"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement" id="BG-19"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax" id="BG-23"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/AllowanceChargeBasisAmount" id="BT-X-263"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/BasisAmount" id="BT-116"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/CalculatedAmount" id="BT-117"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/CategoryCode" id="BT-118"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/DueDateTypeCode" id="BT-8"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/ExemptionReason" id="BT-120"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/ExemptionReasonCode" id="BT-121"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/LineTotalBasisAmount" id="BT-X-262"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/RateApplicablePercent" id="BT-119"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/TaxPointDate" id="BT-7-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/TaxPointDate/DateString" id="BT-7"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ApplicableTradeTax/TypeCode" id="BT-118-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/BillingSpecifiedPeriod" id="BG-14"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/BillingSpecifiedPeriod/Description" id="BT-X-264"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/BillingSpecifiedPeriod/EndDateTime" id="BT-74-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/BillingSpecifiedPeriod/EndDateTime/DateTimeString" id="BT-74"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/BillingSpecifiedPeriod/StartDateTime" id="BT-73-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/BillingSpecifiedPeriod/StartDateTime/DateTimeString" id="BT-73"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/CreditorReferenceID" id="BT-90"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceCurrencyCode" id="BT-5"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceIssuerReference" id="BT-X-204"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceReferencedDocument" id="BG-3"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceReferencedDocument/FormattedIssueDateTime" id="BT-26-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-26"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceReferencedDocument/IssuerAssignedID" id="BT-25"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceReferencedDocument/TypeCode" id="BT-X-555"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty" id="BG-X-36"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact" id="BG-X-37"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-230"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-233-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-233"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-232-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-232"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/PersonName" id="BT-X-229"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-231-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-231"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/DefinedTradeContact/TypeCode" id="BT-X-325"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/GlobalID" id="BT-X-225"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/ID" id="BT-X-224"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/Name" id="BT-X-226"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress" id="BG-X-38"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/CityName" id="BT-X-238"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/CountryID" id="BT-X-239"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-240"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/LineOne" id="BT-X-235"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/LineThree" id="BT-X-237"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/LineTwo" id="BT-X-236"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-234"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization" id="BT-X-227-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-227"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-71"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-465"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-466"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-467"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-462"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-464"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-463"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-461"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-228"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedTaxRegistration" id="BT-X-242-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-242"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/URIUniversalCommunication" id="BT-X-241-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoiceeTradeParty/URIUniversalCommunication/URIID" id="BT-X-241"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty" id="BG-X-33"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact" id="BG-X-34"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-211"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-214-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-214"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-213-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-213"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/PersonName" id="BT-X-210"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-212-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-212"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/DefinedTradeContact/TypeCode" id="BT-X-324"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/GlobalID" id="BT-X-206"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/ID" id="BT-X-205"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/Name" id="BT-X-207"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress" id="BG-X-35"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/CityName" id="BT-X-219"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/CountryID" id="BT-X-220"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-221"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/LineOne" id="BT-X-216"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/LineThree" id="BT-X-218"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/LineTwo" id="BT-X-217"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-215"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization" id="BT-X-208-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-208"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-70"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-458"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-459"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-460"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-455"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-457"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-456"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-454"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-209"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedTaxRegistration" id="BT-X-223-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-223"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/URIUniversalCommunication" id="BT-X-222-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/InvoicerTradeParty/URIUniversalCommunication/URIID" id="BT-X-222"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty" id="BG-10"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact" id="BG-X-39"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-245"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-248-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-248"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-247-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-247"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/PersonName" id="BT-X-244"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-246-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-246"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/DefinedTradeContact/TypeCode" id="BT-X-326"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/GlobalID" id="BT-60-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/ID" id="BT-60"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/Name" id="BT-59"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress" id="BG-X-40"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/CityName" id="BT-X-253"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/CountryID" id="BT-X-254"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-255"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/LineOne" id="BT-X-250"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/LineThree" id="BT-X-252"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/LineTwo" id="BT-X-251"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-249"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/RoleCode" id="BT-X-468"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization" id="BT-61-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/ID" id="BT-61"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-72"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-473"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-474"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-475"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-470"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-472"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-471"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-469"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-243"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedTaxRegistration" id="BT-X-257-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-257"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/URIUniversalCommunication" id="BT-X-256-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayeeTradeParty/URIUniversalCommunication/URIID" id="BT-X-256"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty" id="BG-X-73"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact" id="BG-X-74"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-485"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-489-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-489"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-488-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-488"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/PersonName" id="BT-X-484"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-487-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-487"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/DefinedTradeContact/TypeCode" id="BT-X-486"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/GlobalID" id="BT-X-479"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/ID" id="BT-X-478"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/Name" id="BT-X-476"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress" id="BG-X-75"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/CityName" id="BT-X-494"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/CountryID" id="BT-X-495"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-496"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/LineOne" id="BT-X-491"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/LineThree" id="BT-X-493"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/LineTwo" id="BT-X-492"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-490"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/RoleCode" id="BT-X-483"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization" id="BT-X-480-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-480"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-76"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-501"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-502"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-503"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-498"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-500"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-499"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-497"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-477"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedTaxRegistration" id="BT-X-481-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-481"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/URIUniversalCommunication" id="BT-X-482-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PayerTradeParty/URIUniversalCommunication/URIID" id="BT-X-482"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/PaymentReference" id="BT-83"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ReceivableSpecifiedTradeAccountingAccount" id="BT-19-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ReceivableSpecifiedTradeAccountingAccount/ID" id="BT-19"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/ReceivableSpecifiedTradeAccountingAccount/TypeCode" id="BT-X-290"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment" id="BG-X-45"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/FormattedReceivedDateTime" id="BT-X-292-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/FormattedReceivedDateTime/DateTimeString" id="BT-X-292"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax" id="BG-X-46"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax/CalculatedAmount" id="BT-X-293"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax/CategoryCode" id="BT-X-296"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax/ExemptionReason" id="BT-X-295"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax/ExemptionReasonCode" id="BT-X-297"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax/RateApplicablePercent" id="BT-X-298"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/IncludedTradeTax/TypeCode" id="BT-X-294"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/InvoiceSpecifiedReferencedDocument" id="BG-X-85"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/InvoiceSpecifiedReferencedDocument/FormattedIssueDateTime" id="BT-X-560-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/InvoiceSpecifiedReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-560"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/InvoiceSpecifiedReferencedDocument/IssuerAssignedID" id="BT-X-558"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/InvoiceSpecifiedReferencedDocument/TypeCode" id="BT-X-559"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedAdvancePayment/PaidAmount" id="BT-X-291"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedFinancialAdjustment" id="BG-34"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedFinancialAdjustment/ActualAmount" id="BT-179"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedFinancialAdjustment/Reason" id="BT-180"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge" id="BG-X-42"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedAmount" id="BT-X-272"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedTradeTax" id="BT-X-273-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedTradeTax/CategoryCode" id="BT-X-273"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedTradeTax/ExemptionReason" id="BT-X-591"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedTradeTax/ExemptionReasonCode" id="BT-X-592"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedTradeTax/RateApplicablePercent" id="BT-X-274"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/AppliedTradeTax/TypeCode" id="BT-X-273-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedLogisticsServiceCharge/Description" id="BT-X-271"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge" id="BG-20 / BG-21"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/ActualAmount" id="BT-92 / BT-99"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/BasisAmount" id="BT-93 / BT-100"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/BasisQuantity" id="BT-X-266 / BT-X-269"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CalculationPercent" id="BT-94 / BT-101"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CategoryTradeTax" id="BT-95-00 / BT-102-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CategoryTradeTax/CategoryCode" id="BT-95 / BT-102"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CategoryTradeTax/ExemptionReason" id="BT-173 / BT-175"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CategoryTradeTax/ExemptionReasonCode" id="BT-174 / BT-176"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CategoryTradeTax/RateApplicablePercent" id="BT-96 / BT-103"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/CategoryTradeTax/TypeCode" id="BT-95-0 / BT-102-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/ChargeIndicator" id="BG-20-0 / BG-21-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/ChargeIndicator/Indicator" id="BG-20-1 / BG-21-1"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/Reason" id="BT-97 / BT-104"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/ReasonCode" id="BT-98 / BT-105 / BT-177"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeAllowanceCharge/SequenceNumeric" id="BT-X-265 / BT-X-268"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms" id="BT-20-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms" id="BG-X-44"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/ActualDiscountAmount" id="BT-X-287"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisAmount" id="BT-X-285"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisDateTime" id="BT-X-282-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisDateTime/DateTimeString" id="BT-X-282"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/BasisPeriodMeasure" id="BT-X-283"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentDiscountTerms/CalculationPercent" id="BT-X-286"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms" id="BG-X-43"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms/ActualPenaltyAmount" id="BT-X-281"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms/BasisAmount" id="BT-X-279"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms/BasisDateTime" id="BT-X-276-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms/BasisDateTime/DateTimeString" id="BT-X-276"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms/BasisPeriodMeasure" id="BT-X-277"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/ApplicableTradePaymentPenaltyTerms/CalculationPercent" id="BT-X-280"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/Description" id="BT-20"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/DirectDebitMandateID" id="BT-89"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/DueDateDateTime" id="BT-9-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/DueDateDateTime/DateTimeString" id="BT-9"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PartialPaymentAmount" id="BT-X-275"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty" id="BG-X-77"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact" id="BG-X-78"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-513"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-517-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-517"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-516-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-516"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/PersonName" id="BT-X-512"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-515-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-515"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/DefinedTradeContact/TypeCode" id="BT-X-514"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/GlobalID" id="BT-X-507"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/ID" id="BT-X-506"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/Name" id="BT-X-504"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress" id="BG-X-79"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/CityName" id="BT-X-522"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/CountryID" id="BT-X-523"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-524"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/LineOne" id="BT-X-519"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/LineThree" id="BT-X-521"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/LineTwo" id="BT-X-520"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-518"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/RoleCode" id="BT-X-511"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization" id="BT-X-508-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-508"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress" id="BG-X-80"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CityName" id="BT-X-529"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountryID" id="BT-X-530"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/CountrySubDivisionName" id="BT-X-531"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineOne" id="BT-X-526"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineThree" id="BT-X-528"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/LineTwo" id="BT-X-527"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/PostalTradeAddress/PostcodeCode" id="BT-X-525"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-505"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedTaxRegistration" id="BT-X-509-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-509"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/URIUniversalCommunication" id="BT-X-510-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradePaymentTerms/PayeeTradeParty/URIUniversalCommunication/URIID" id="BT-X-510"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation" id="BG-22"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/AllowanceTotalAmount" id="BT-107"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/ChargeTotalAmount" id="BT-108"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/DuePayableAmount" id="BT-115"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/GrandTotalAmount" id="BT-112"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/LineTotalAmount" id="BT-106"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/RoundingAmount" id="BT-114"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/TaxBasisTotalAmount" id="BT-109"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/TaxTotalAmount" id="BT-110 / BT-111"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementHeaderMonetarySummation/TotalPrepaidAmount" id="BT-113"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans" id="BG-16"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/ApplicableTradeSettlementFinancialCard" id="BG-18"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/ApplicableTradeSettlementFinancialCard/CardholderName" id="BT-88"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/ApplicableTradeSettlementFinancialCard/ID" id="BT-87"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/Information" id="BT-82"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayeePartyCreditorFinancialAccount" id="BG-17"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayeePartyCreditorFinancialAccount/AccountName" id="BT-85"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayeePartyCreditorFinancialAccount/IBANID" id="BT-84"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayeePartyCreditorFinancialAccount/ProprietaryID" id="BT-84-0"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayeeSpecifiedCreditorFinancialInstitution" id="BT-86-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayeeSpecifiedCreditorFinancialInstitution/BICID" id="BT-86"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayerPartyDebtorFinancialAccount" id="BT-91-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayerPartyDebtorFinancialAccount/AccountName" id="BT-216"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayerPartyDebtorFinancialAccount/IBANID" id="BT-91"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayerSpecifiedDebtorFinancialInstitution" id="BT-215-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/PayerSpecifiedDebtorFinancialInstitution/BICID" id="BT-215"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/SpecifiedTradeSettlementPaymentMeans/TypeCode" id="BT-81"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxApplicableTradeCurrencyExchange" id="BG-X-41"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxApplicableTradeCurrencyExchange/ConversionRate" id="BT-X-260"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxApplicableTradeCurrencyExchange/ConversionRateDateTime" id="BT-X-261-00"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxApplicableTradeCurrencyExchange/ConversionRateDateTime/DateTimeString" id="BT-X-261"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxApplicableTradeCurrencyExchange/SourceCurrencyCode" id="BT-X-258"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxApplicableTradeCurrencyExchange/TargetCurrencyCode" id="BT-X-259"/>
    <zv:b p="SupplyChainTradeTransaction/ApplicableHeaderTradeSettlement/TaxCurrencyCode" id="BT-6"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem" id="BG-25"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument" id="BT-126-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/IncludedNote" id="BT-127-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/IncludedNote/Content" id="BT-127"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/IncludedNote/ContentCode" id="BT-X-9"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/IncludedNote/SubjectCode" id="BT-X-10"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/LineID" id="BT-126"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/LineStatusCode" id="BT-X-7"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/LineStatusReasonCode" id="BT-X-8"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/AssociatedDocumentLineDocument/ParentLineID" id="BT-X-304"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement" id="BG-29"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument" id="BG-X-3"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/AttachmentBinaryObject" id="BT-X-31"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/FormattedIssueDateTime" id="BT-X-33-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-33"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/IssuerAssignedID" id="BT-X-27"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/LineID" id="BT-X-29"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/Name" id="BT-X-299"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/ReferenceTypeCode" id="BT-X-32"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/TypeCode" id="BT-X-30"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/AdditionalReferencedDocument/URIID" id="BT-X-28"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ApplicableTradeDeliveryTerms" id="BG-X-87"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ApplicableTradeDeliveryTerms/RelevantTradeLocation" id="BG-X-89"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ApplicableTradeDeliveryTerms/RelevantTradeLocation/CountryID" id="BT-X-565"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ApplicableTradeDeliveryTerms/RelevantTradeLocation/Name" id="BT-X-566"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/BuyerOrderReferencedDocument" id="BT-132-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/BuyerOrderReferencedDocument/FormattedIssueDateTime" id="BT-X-22-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/BuyerOrderReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-22"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/BuyerOrderReferencedDocument/IssuerAssignedID" id="BT-X-21"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/BuyerOrderReferencedDocument/LineID" id="BT-132"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ContractReferencedDocument" id="BG-X-2"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ContractReferencedDocument/FormattedIssueDateTime" id="BT-X-26-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ContractReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-26"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ContractReferencedDocument/IssuerAssignedID" id="BT-X-24"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ContractReferencedDocument/LineID" id="BT-X-25"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice" id="BT-148-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge" id="BT-147-00 / BT-X-302-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/ActualAmount" id="BT-147 / BT-X-302"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/BasisAmount" id="BT-X-35 / BT-X-301"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/CalculationPercent" id="BT-X-34 / BT-X-300"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/ChargeIndicator" id="BT-147-01 / BT-X-302-01"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/ChargeIndicator/Indicator" id="BT-147-02 / BT-X-302-02"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/Reason" id="BT-X-36 / BT-X-303"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/AppliedTradeAllowanceCharge/ReasonCode" id="BT-X-313 / BT-X-616 / BT-X-314"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/BasisQuantity" id="BT-149-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/GrossPriceProductTradePrice/ChargeAmount" id="BT-148"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty" id="BG-X-90"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact" id="BG-X-91"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-574-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-578-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-578"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-577-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-577"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/PersonName" id="BT-X-574"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-576-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-576"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/DefinedTradeContact/TypeCode" id="BT-X-575"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/Description" id="BT-X-571"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/GlobalID" id="BT-X-568"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/ID" id="BT-X-567"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/Name" id="BT-X-569"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress" id="BG-X-92"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/CityName" id="BT-X-583"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/CountryID" id="BT-X-584"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-585"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/LineOne" id="BT-X-580"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/LineThree" id="BT-X-582"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/LineTwo" id="BT-X-581"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-579"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/RoleCode" id="BT-X-570"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/SpecifiedLegalOrganization" id="BT-X-572-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-572"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-573"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/SpecifiedTaxRegistration" id="BT-X-587-00 / BT-X-588-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-587 / BT-X-588"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/URIUniversalCommunication" id="BT-X-586-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/ItemSellerTradeParty/URIUniversalCommunication/URIID" id="BT-X-586"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice" id="BT-146-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/BasisQuantity" id="BT-149"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/ChargeAmount" id="BT-146"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax" id="BG-X-4"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax/CalculatedAmount" id="BT-X-37"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax/CategoryCode" id="BT-X-40"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax/ExemptionReason" id="BT-X-39"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax/ExemptionReasonCode" id="BT-X-41"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax/RateApplicablePercent" id="BT-X-42"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/NetPriceProductTradePrice/IncludedTradeTax/TypeCode" id="BT-X-38"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/QuotationReferencedDocument" id="BG-X-47"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/QuotationReferencedDocument/FormattedIssueDateTime" id="BT-X-312-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/QuotationReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-312"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/QuotationReferencedDocument/IssuerAssignedID" id="BT-X-310"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/QuotationReferencedDocument/LineID" id="BT-X-311"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/SellerOrderReferencedDocument" id="BG-X-81"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/SellerOrderReferencedDocument/FormattedIssueDateTime" id="BT-X-539-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/SellerOrderReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-539"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/SellerOrderReferencedDocument/IssuerAssignedID" id="BT-X-537"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/SellerOrderReferencedDocument/LineID" id="BT-X-538"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/UltimateCustomerOrderReferencedDocument" id="BG-X-5"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/UltimateCustomerOrderReferencedDocument/FormattedIssueDateTime" id="BT-X-45-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/UltimateCustomerOrderReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-45"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/UltimateCustomerOrderReferencedDocument/IssuerAssignedID" id="BT-X-43"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeAgreement/UltimateCustomerOrderReferencedDocument/LineID" id="BT-X-44"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery" id="BT-129-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ActualDeliverySupplyChainEvent" id="BT-X-85-000"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ActualDeliverySupplyChainEvent/OccurrenceDateTime" id="BT-X-85-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ActualDeliverySupplyChainEvent/OccurrenceDateTime/DateTimeString" id="BT-X-85"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/BilledQuantity" id="BT-129"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ChargeFreeQuantity" id="BT-X-46"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument" id="BG-X-83"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument/FormattedIssueDateTime" id="BT-X-94-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-94"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument/IssuerAssignedID" id="BT-X-92"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DeliveryNoteReferencedDocument/LineID" id="BT-X-93"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DespatchAdviceReferencedDocument" id="BG-X-13"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DespatchAdviceReferencedDocument/FormattedIssueDateTime" id="BT-X-88-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DespatchAdviceReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-88"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DespatchAdviceReferencedDocument/IssuerAssignedID" id="BT-X-86"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/DespatchAdviceReferencedDocument/LineID" id="BT-X-87"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/PackageQuantity" id="BT-X-47"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/PerPackageUnitQuantity" id="BT-X-561"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ReceivingAdviceReferencedDocument" id="BG-X-82"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ReceivingAdviceReferencedDocument/FormattedIssueDateTime" id="BT-X-91-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ReceivingAdviceReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-91"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ReceivingAdviceReferencedDocument/IssuerAssignedID" id="BT-X-89"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ReceivingAdviceReferencedDocument/LineID" id="BT-X-90"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty" id="BG-X-7"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact" id="BG-X-8"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-54-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-57-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-57"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-56-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-56"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/PersonName" id="BT-X-54"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-55-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-55"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/DefinedTradeContact/TypeCode" id="BT-X-315"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/GlobalID" id="BT-186"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/ID" id="BT-186-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/Name" id="BT-X-50"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress" id="BG-X-9"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/CityName" id="BT-X-62"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/CountryID" id="BT-X-63"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-64"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/LineOne" id="BT-X-59"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/LineThree" id="BT-X-61"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/LineTwo" id="BT-X-60"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-58"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/RoleCode" id="BT-X-541"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization" id="BT-X-51-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-51"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-52"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/SpecifiedTaxRegistration" id="BT-X-66-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-66"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/URIUniversalCommunication" id="BT-X-65-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/ShipToTradeParty/URIUniversalCommunication/URIID" id="BT-X-65"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty" id="BG-X-10"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact" id="BG-X-11"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-72-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-75-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-75"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-74-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-74"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/PersonName" id="BT-X-72"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-73-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-73"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/DefinedTradeContact/TypeCode" id="BT-X-316"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/GlobalID" id="BT-X-68"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/ID" id="BT-X-67"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/Name" id="BT-X-69"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress" id="BG-X-12"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/CityName" id="BT-X-80"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/CountryID" id="BT-X-81"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-82"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/LineOne" id="BT-X-77"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/LineThree" id="BT-X-79"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/LineTwo" id="BT-X-78"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-76"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/RoleCode" id="BT-X-542"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization" id="BT-X-70-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-70"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-71"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/SpecifiedTaxRegistration" id="BT-X-84-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-84"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/URIUniversalCommunication" id="BT-X-83-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeDelivery/UltimateShipToTradeParty/URIUniversalCommunication/URIID" id="BT-X-83"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement" id="BG-30-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/AdditionalReferencedDocument" id="BT-128-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/AdditionalReferencedDocument/IssuerAssignedID" id="BT-128"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/AdditionalReferencedDocument/ReferenceTypeCode" id="BT-128-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/AdditionalReferencedDocument/TypeCode" id="BT-128-0"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax" id="BG-30"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/CalculatedAmount" id="BT-X-95"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/CategoryCode" id="BT-151"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/DueDateTypeCode" id="BT-X-589"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/ExemptionReason" id="BT-X-96"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/ExemptionReasonCode" id="BT-X-97"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/RateApplicablePercent" id="BT-152"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ApplicableTradeTax/TypeCode" id="BT-151-0"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/BillingSpecifiedPeriod" id="BG-26"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime" id="BT-135-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/EndDateTime/DateTimeString" id="BT-135"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime" id="BT-134-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/BillingSpecifiedPeriod/StartDateTime/DateTimeString" id="BT-134"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/InvoiceReferencedDocument" id="BG-X-48"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/InvoiceReferencedDocument/FormattedIssueDateTime" id="BT-X-333-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/InvoiceReferencedDocument/FormattedIssueDateTime/DateTimeString" id="BT-X-333"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/InvoiceReferencedDocument/IssuerAssignedID" id="BT-X-331"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/InvoiceReferencedDocument/LineID" id="BT-X-540"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/InvoiceReferencedDocument/TypeCode" id="BT-X-332"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ReceivableSpecifiedTradeAccountingAccount" id="BT-133-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ReceivableSpecifiedTradeAccountingAccount/ID" id="BT-133"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/ReceivableSpecifiedTradeAccountingAccount/TypeCode" id="BT-X-99"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge" id="BG-27 / BG-28"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/ActualAmount" id="BT-136 / BT-141"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/BasisAmount" id="BT-137 / BT-142"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/CalculationPercent" id="BT-138 / BT-143"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/ChargeIndicator" id="BG-27-0 / BG-28-0"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/ChargeIndicator/Indicator" id="BG-27-1 / BG-28-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/Reason" id="BT-139 / BT-144"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeAllowanceCharge/ReasonCode" id="BT-140 / BT-145 / BT-193"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation" id="BT-131-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation/AllowanceTotalAmount" id="BT-X-328"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation/ChargeTotalAmount" id="BT-X-327"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation/GrandTotalAmount" id="BT-X-330"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation/LineTotalAmount" id="BT-131"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation/TaxTotalAmount" id="BT-X-329 / BT-X-590"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedLineTradeSettlement/SpecifiedTradeSettlementLineMonetarySummation/TotalAllowanceChargeAmount" id="BT-X-98"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct" id="BG-31"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ApplicableProductCharacteristic" id="BG-32"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ApplicableProductCharacteristic/Description" id="BT-160"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ApplicableProductCharacteristic/TypeCode" id="BT-X-11"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ApplicableProductCharacteristic/Value" id="BT-161"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ApplicableProductCharacteristic/ValueMeasure" id="BT-X-12"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/BatchID" id="BT-X-534"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/BrandName" id="BT-X-535"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/BuyerAssignedID" id="BT-156"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/Description" id="BT-154"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/DesignatedProductClassification" id="BT-158-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/DesignatedProductClassification/ClassCode" id="BT-158"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/DesignatedProductClassification/ClassName" id="BT-X-13"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/GlobalID" id="BT-157"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ID" id="BT-X-305"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct" id="BG-X-1"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/BuyerAssignedID" id="BT-X-17"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/Description" id="BT-X-19"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/GlobalID" id="BT-X-15"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/ID" id="BT-X-308"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/IndustryAssignedID" id="BT-X-309"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/Name" id="BT-X-18"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/SellerAssignedID" id="BT-X-16"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IncludedReferencedProduct/UnitQuantity" id="BT-X-20"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IndividualTradeProductInstance" id="BG-X-84"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IndividualTradeProductInstance/BatchID" id="BT-X-306"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IndividualTradeProductInstance/SupplierAssignedSerialID" id="BT-X-307"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/IndustryAssignedID" id="BT-X-532"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty" id="BG-X-93"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact" id="BG-X-94"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/DepartmentName" id="BT-X-601"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication" id="BT-X-605-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/EmailURIUniversalCommunication/URIID" id="BT-X-605"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/FaxUniversalCommunication" id="BT-X-604-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/FaxUniversalCommunication/CompleteNumber" id="BT-X-604"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/PersonName" id="BT-X-600"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication" id="BT-X-603-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/TelephoneUniversalCommunication/CompleteNumber" id="BT-X-603"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/DefinedTradeContact/TypeCode" id="BT-X-602"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/Description" id="BT-X-597"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/GlobalID" id="BT-X-594"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/ID" id="BT-X-593"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/Name" id="BT-X-595"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress" id="BG-X-95"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/CityName" id="BT-X-610"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/CountryID" id="BT-X-611"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/CountrySubDivisionName" id="BT-X-612"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/LineOne" id="BT-X-607"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/LineThree" id="BT-X-609"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/LineTwo" id="BT-X-608"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/PostalTradeAddress/PostcodeCode" id="BT-X-606"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/RoleCode" id="BT-X-596"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/SpecifiedLegalOrganization" id="BT-X-598-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/SpecifiedLegalOrganization/ID" id="BT-X-598"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/SpecifiedLegalOrganization/TradingBusinessName" id="BT-X-599"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/SpecifiedTaxRegistration" id="BT-X-614-00 / BT-X-615-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/SpecifiedTaxRegistration/ID" id="BT-X-614 / BT-X-615"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/URIUniversalCommunication" id="BT-X-613-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ManufacturerTradeParty/URIUniversalCommunication/URIID" id="BT-X-613"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ModelID" id="BT-X-533"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ModelName" id="BT-X-536"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/Name" id="BT-153"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/OriginTradeCountry" id="BT-159-00"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/OriginTradeCountry/ID" id="BT-159"/>
    <zv:b p="SupplyChainTradeTransaction/IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/SellerAssignedID" id="BT-155"/>
  </zv:data>

</xsl:stylesheet>
