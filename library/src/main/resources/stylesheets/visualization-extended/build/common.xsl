<?xml version="1.0" encoding="UTF-8"?>
<!--
  Gemeinsamer Teil der ZUGFeRD/Factur-X-Visualisierungen (HTML und XSL-FO):
  Parameter, Schlüssel, Wörterbuch-Zugriff, BT-Zuordnung, Wert- und
  Codeformatierung. build_xsl.py fügt alles zwischen den Markierungen
  COMMON-BEGIN und COMMON-END in template_html.xsl bzw. template_fo.xsl ein
  (an der Stelle der Markierung @@COMMON@@).

  Jedes Ausgabeformat stellt dafür bereit:
    Variable btEmit         true(), wenn BT-Kennungen ausgegeben werden
    Template w(c, x, title) Inhalt x mit Auszeichnung c (cd = dezent,
                            nw = ohne Umbruch, mono = Festbreite, '' = keine)
    Template lnk(href)      Verweis mit dem Text des Kontextknotens
    Template attachment     Darstellung von AttachmentBinaryObject
    Template btOut(id)      Ausgabe einer BT-/BG-Kennung
    Template txt            Ausgabe eines einfachen Textwerts (Kontextknoten)
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
  xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
  xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
  xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
  xmlns:zv="urn:mustangproject:zugferd:visualization"
  exclude-result-prefixes="rsm ram udt qdt zv">

  <!-- COMMON-BEGIN -->
  <xsl:param name="lang" select="'de'"/>
  <xsl:param name="showBT" select="''"/>

  <xsl:variable name="btNorm" select="translate(normalize-space($showBT),'FALSENOI','falsenoi')"/>
  <xsl:variable name="BTON" select="$btNorm!='' and $btNorm!='false' and $btNorm!='0' and $btNorm!='no' and $btNorm!='nein' and $btNorm!='off'"/>

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
  <xsl:key name="btv"  match="zv:v" use="concat(@p,'|',@k)"/>
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
  <!--  Gemeinsame Templates (common.xsl)                                  -->
  <!-- ================================================================== -->

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

  <xsl:template name="perBasis">
    <xsl:if test="ram:BasisQuantity and number(ram:BasisQuantity) != 1">
      <xsl:call-template name="w">
        <xsl:with-param name="c" select="'cd'"/>
        <xsl:with-param name="x">
          <xsl:text> / </xsl:text>
          <xsl:call-template name="num"><xsl:with-param name="v" select="ram:BasisQuantity"/><xsl:with-param name="p" select="$P_QTY"/></xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:call-template name="unitName"><xsl:with-param name="u" select="ram:BasisQuantity/@unitCode"/></xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Grund eines Zu-/Abschlags: Text und/oder Code -->
  <xsl:template name="acReason">
    <xsl:choose>
      <xsl:when test="ram:Reason">
        <xsl:value-of select="ram:Reason"/>
        <xsl:if test="ram:ReasonCode"><xsl:call-template name="w"><xsl:with-param name="c" select="'cd'"/><xsl:with-param name="x"> (<xsl:value-of select="ram:ReasonCode"/>)</xsl:with-param></xsl:call-template></xsl:if>
      </xsl:when>
      <xsl:when test="ram:ReasonCode"><xsl:apply-templates select="ram:ReasonCode" mode="v"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="period">
    <xsl:for-each select="ram:StartDateTime"><xsl:apply-templates select="." mode="v"/></xsl:for-each>
    <xsl:if test="ram:StartDateTime or ram:EndDateTime"><xsl:text> &#8211; </xsl:text></xsl:if>
    <xsl:for-each select="ram:EndDateTime"><xsl:apply-templates select="." mode="v"/></xsl:for-each>
    <xsl:for-each select="ram:CompleteDateTime"><xsl:apply-templates select="." mode="v"/></xsl:for-each>
    <xsl:if test="ram:Description"><xsl:call-template name="w"><xsl:with-param name="c" select="'cd'"/><xsl:with-param name="x"><xsl:text> </xsl:text><xsl:value-of select="ram:Description"/></xsl:with-param></xsl:call-template></xsl:if>
  </xsl:template>

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
        <xsl:call-template name="attachment"/>
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
        <xsl:call-template name="w"><xsl:with-param name="c" select="'mono'"/><xsl:with-param name="x"><xsl:call-template name="iban"><xsl:with-param name="s" select="normalize-space(.)"/></xsl:call-template></xsl:with-param></xsl:call-template>
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
            <xsl:call-template name="lnk"><xsl:with-param name="href" select="normalize-space(.)"/></xsl:call-template>
          </xsl:when>
          <xsl:when test="($pn = 'EmailURIUniversalCommunication' or @schemeID = 'EM') and contains(.,'@')">
            <xsl:call-template name="lnk"><xsl:with-param name="href" select="concat('mailto:',normalize-space(.))"/></xsl:call-template>
          </xsl:when>
          <xsl:otherwise><xsl:call-template name="txt"/></xsl:otherwise>
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
        <xsl:call-template name="w">
          <xsl:with-param name="c" select="'cd'"/>
          <xsl:with-param name="x">
          <xsl:text> (</xsl:text>
          <xsl:call-template name="codeOrRaw"><xsl:with-param name="list" select="'eas'"/><xsl:with-param name="v" select="@schemeID"/></xsl:call-template>
          <xsl:text>)</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@schemeID">
        <xsl:call-template name="w">
          <xsl:with-param name="c" select="'cd'"/>
          <xsl:with-param name="x">
          <xsl:text> (</xsl:text>
          <xsl:call-template name="codeOrRaw"><xsl:with-param name="list" select="'icd'"/><xsl:with-param name="v" select="@schemeID"/></xsl:call-template>
          <xsl:text>)</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@listID">
        <xsl:call-template name="w">
          <xsl:with-param name="c" select="'cd'"/>
          <xsl:with-param name="x">
          <xsl:text> (</xsl:text>
          <xsl:call-template name="codeOrRaw"><xsl:with-param name="list" select="'7143'"/><xsl:with-param name="v" select="@listID"/></xsl:call-template>
          <xsl:if test="@listVersionID"><xsl:text> </xsl:text><xsl:value-of select="@listVersionID"/></xsl:if>
          <xsl:text>)</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
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
      <xsl:call-template name="w">
        <xsl:with-param name="c" select="'nw'"/>
        <xsl:with-param name="x">
        <xsl:call-template name="num"><xsl:with-param name="v" select="$n"/></xsl:call-template>
        <xsl:if test="$cur">
          <xsl:text>&#160;</xsl:text>
          <xsl:choose>
            <xsl:when test="$n/@currencyID"><xsl:value-of select="$n/@currencyID"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$S/ram:InvoiceCurrencyCode"/></xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
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
      <xsl:call-template name="w">
        <xsl:with-param name="c" select="''"/>
        <xsl:with-param name="title" select="string($u)"/>
        <xsl:with-param name="x">
        <xsl:choose>
          <xsl:when test="string($n) != ''"><xsl:value-of select="$n"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$u"/></xsl:otherwise>
        </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

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
        <xsl:call-template name="w"><xsl:with-param name="c" select="'cd'"/><xsl:with-param name="x"><xsl:text> (</xsl:text><xsl:value-of select="normalize-space($v)"/><xsl:text>)</xsl:text></xsl:with-param></xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$v"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="bt">
    <xsl:param name="n" select="."/>
    <xsl:if test="$n and $btEmit">
      <xsl:variable name="x" select="$n[1]"/>
      <xsl:variable name="p">
        <xsl:for-each select="$x/ancestor-or-self::*[parent::*]">
          <xsl:if test="position() &gt; 1">/</xsl:if>
          <xsl:value-of select="local-name()"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="ac" select="$x/ancestor-or-self::*[ram:ChargeIndicator][1]"/>
      <xsl:variable name="tr" select="$x/ancestor-or-self::ram:SpecifiedTaxRegistration[1]"/>
      <xsl:variable name="rd" select="$x/ancestor-or-self::ram:AdditionalReferencedDocument[1]"/>
      <xsl:variable name="c">
        <xsl:choose>
          <xsl:when test="count($n) &gt; 1"/>
          <xsl:when test="$ac">
            <xsl:choose>
              <xsl:when test="normalize-space($ac/ram:ChargeIndicator/udt:Indicator)='true'">true</xsl:when>
              <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$tr"><xsl:value-of select="normalize-space($tr/ram:ID/@schemeID)"/></xsl:when>
          <xsl:when test="$rd"><xsl:value-of select="normalize-space($rd/ram:TypeCode)"/></xsl:when>
          <xsl:when test="$x/self::ram:TaxTotalAmount">
            <xsl:choose>
              <xsl:when test="not($x/@currencyID) or normalize-space($x/@currencyID)=normalize-space($S/ram:InvoiceCurrencyCode)">inv</xsl:when>
              <xsl:otherwise>acc</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="$dictDoc">
        <xsl:variable name="v" select="key('btv',concat($p,'/DateTimeString|',$c)) | key('btv',concat($p,'/DateString|',$c)) | key('btv',concat($p,'/Indicator|',$c))"/>
        <xsl:variable name="b" select="key('bt',concat($p,'/DateTimeString')) | key('bt',concat($p,'/DateString')) | key('bt',concat($p,'/Indicator'))"/>
        <xsl:choose>
          <xsl:when test="string($c)!='' and $v"><xsl:call-template name="btOut"><xsl:with-param name="id" select="string($v[1]/@id)"/></xsl:call-template></xsl:when>
          <xsl:when test="$b"><xsl:call-template name="btOut"><xsl:with-param name="id" select="string($b[1]/@id)"/></xsl:call-template></xsl:when>
          <xsl:when test="string($c)!='' and key('btv',concat($p,'|',$c))"><xsl:call-template name="btOut"><xsl:with-param name="id" select="string(key('btv',concat($p,'|',$c))[1]/@id)"/></xsl:call-template></xsl:when>
          <xsl:when test="key('bt',$p)"><xsl:call-template name="btOut"><xsl:with-param name="id" select="string(key('bt',$p)[1]/@id)"/></xsl:call-template></xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- COMMON-END -->

</xsl:stylesheet>
