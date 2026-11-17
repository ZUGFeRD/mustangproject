<?xml version="1.0" encoding="UTF-8"?>
<!--
  ZUGFeRD 2.5.2 / Factur-X 1.09.2 - Profil EXTENDED - HTML-Visualisierung
  =====================================================================
  Wandelt eine ZUGFeRD/Factur-X CII-Rechnung (rsm:CrossIndustryInvoice) in
  eine lesbare HTML-Darstellung um. Alle im Profil EXTENDED vorgesehenen
  Informationen werden dargestellt (strukturiert oder in den aufklappbaren
  Detailbereichen).

  Parameter
    lang     de | en | fr   Sprache der Beschriftungen (Standard: de)
    showBT   (leer) | true  Falls gesetzt (nicht leer und nicht false/0/no/nein),
                            werden die BT-/BG-/BT-X-Kennungen der EN 16931 bzw.
                            von Factur-X/ZUGFeRD neben den Feldnamen angezeigt.
                            Ohne Parameter sind sie ausgeblendet und lassen sich
                            über den Schalter oben rechts einblenden.

  Profile
    Verarbeitet alle Profile (MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED,
    XRECHNUNG); nicht vorhandene Angaben bzw. Abschnitte werden ausgelassen.

  Aufruf (Beispiele)
    java -jar saxon-he.jar -s:rechnung.xml -xsl:ZUGFeRD_EXTENDED_html.xsl -o:rechnung.html lang=en showBT=true
    xsltproc (mit stringparam lang fr und stringparam showBT true) ZUGFeRD_EXTENDED_html.xsl rechnung.xml

  XSLT 1.0, keine Erweiterungsfunktionen. Die Beschriftungen, Codelisten und
  BT-Zuordnungen sind in diesem Stylesheet eingebettet (zv:data) und werden
  per document('') gelesen - das Stylesheet muss daher mit einer System-ID
  (Datei-/URL-Pfad) geladen werden.

  Diese Datei wird von build/build_xsl.py erzeugt - Änderungen bitte in
  build/template_html.xsl, build/common.xsl bzw. build/build_xsl.py vornehmen.
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

<!--@@COMMON@@-->

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
        <input type="checkbox" id="zv-bt" class="bt-cb">
          <xsl:if test="$BTON"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
        </input>
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
    <xsl:if test="$T/ram:IncludedSupplyChainTradeLineItem">
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

  <!-- ================================================================== -->
  <!--  Wertformatierung                                                   -->
  <!-- ================================================================== -->

  <!-- ================================================================== -->
  <!--  Wörterbuch-Zugriff                                                 -->
  <!-- ================================================================== -->

  <!-- BT/BG-Kennung zum Element (Parameter showBT bzw. Schalter oben rechts).
       Mehrdeutige Pfade werden über den Kontext aufgelöst: Zu-/Abschlag
       (ChargeIndicator), Steuerregistrierung (schemeID VA/FC), weitere
       Referenzdokumente (TypeCode 916/50/130), Steuergesamtbetrag (currencyID). -->

  <!-- ================================================================== -->
  <!--  Ausgabe-Primitive für den gemeinsamen Teil (common.xsl)            -->
  <!-- ================================================================== -->

  <xsl:variable name="btEmit" select="true()"/>

  <xsl:template name="w">
    <xsl:param name="c" select="''"/>
    <xsl:param name="x"/>
    <xsl:param name="title" select="''"/>
    <span>
      <xsl:if test="$c != ''"><xsl:attribute name="class"><xsl:value-of select="$c"/></xsl:attribute></xsl:if>
      <xsl:if test="$title != ''"><xsl:attribute name="title"><xsl:value-of select="$title"/></xsl:attribute></xsl:if>
      <xsl:copy-of select="$x"/>
    </span>
  </xsl:template>

  <xsl:template name="lnk">
    <xsl:param name="href"/>
    <a href="{$href}"><xsl:value-of select="."/></a>
  </xsl:template>

  <xsl:template name="attachment">
        <a class="att" download="{@filename}" href="data:{@mimeCode};base64,{translate(.,' &#9;&#10;&#13;','')}">
          <xsl:call-template name="t"><xsl:with-param name="k" select="'ui.download'"/></xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:choose>
            <xsl:when test="normalize-space(@filename)!=''"><xsl:value-of select="@filename"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@mimeCode"/></xsl:otherwise>
          </xsl:choose>
        </a>
        <span class="cd"><xsl:text> (</xsl:text><xsl:value-of select="@mimeCode"/><xsl:text>)</xsl:text></span>
  </xsl:template>

  <xsl:template name="txt">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template name="btOut">
    <xsl:param name="id"/>
    <span class="bt"><xsl:value-of select="$id"/></span>
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
<!--@@DATA@@-->
  </zv:data>

</xsl:stylesheet>
