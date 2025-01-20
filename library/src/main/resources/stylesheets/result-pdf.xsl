<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">
    <!-- Imports -->
    <xsl:import href="common-xr.xsl"/>
    <xsl:import href="xr-pdf/lib/konstanten.xsl"/>
    <!--
        FO engine used can be specified.
        Specific extensions will be then enabled.
        Supported values are:
            axf - Antenna House XSL Formatter
            fop - Apache FOP
    -->
    <xsl:param name="foengine"/>
    <xsl:param name="axf.extensions"
               select="if ($foengine eq 'axf') then true() else false()"/>
    <xsl:param name="fop.extensions"
               select="if ($foengine eq 'fop') then true() else false()"/>
    <xsl:variable name="xml_result_color">
        <xsl:if test="/validation/xml/summary/@status = 'valid'">
            <xsl:text>green</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/xml/summary/@status = 'invalid'">
            <xsl:text>red</xsl:text>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="xml_result_text">
        <xsl:if test="/validation/xml/summary/@status = 'valid'">
            <xsl:text>Das XML ist valide.</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/xml/summary/@status = 'invalid'">
            <xsl:text>Das XML ist nicht valide.</xsl:text>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="pdf_result_color">
        <xsl:if test="/validation/pdf/summary/@status = 'valid'">
            <xsl:text>green</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/pdf/summary/@status = 'invalid'">
            <xsl:text>red</xsl:text>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="pdf_result_text">
        <xsl:if test="/validation/pdf/summary/@status = 'valid'">
            <xsl:text>Das ZUGFeRD-PDF ist valide.</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/pdf/summary/@status = 'invalid'">
            <xsl:text>Das ZUGFeRD-PDF ist nicht valide.</xsl:text>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="result_color">
        <xsl:if test="/validation/summary/@status = 'valid'">
            <xsl:text>green</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/summary/@status = 'invalid'">
            <xsl:text>red</xsl:text>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="result_text">
        <xsl:if test="/validation/summary/@status = 'valid'">
            <xsl:text>Es wird empfohlen, das Dokument anzunehmen und es weiterzuverarbeiten.</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/summary/@status = 'invalid'">
            <xsl:text>Es wird empfohlen, das Dokument zurückzuweisen.</xsl:text>
        </xsl:if>
    </xsl:variable>
    <xsl:template match="validation">
        <fo:root language="{$lang}"
                 font-family="{$fontSans}">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="DIN-A4"
                                       page-height="297mm"
                                       page-width="210mm">
                    <fo:region-body region-name="body"
                                    margin="20mm 10mm 20mm 20mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="DIN-A4">
                <fo:flow flow-name="body">
                    <fo:block font-size="24px"
                              font-weight="bold">
                        <xsl:text>Prüfbericht</xsl:text>
                    </fo:block>
                    <xsl:call-template name="SubHeader">
                        <xsl:with-param name="text"
                                        select="'Angaben zum geprüften Dokument'"/>
                        <xsl:with-param name="color"
                                        select="'black'"/>
                    </xsl:call-template>
                    <fo:table>
                        <fo:table-column border-style="none"/>
                        <fo:table-column column-width="70%"
                                         border-style="none"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block text-align="left">Referenz:</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block text-align="right">
                                        <xsl:value-of select="./@filename"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block text-align="left">Zeitpunkt der Prüfung:</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block text-align="right">
                                        <xsl:value-of select="./@datetime"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block text-align="left">Erkannter Dokumenttyp:</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block text-align="right">
                                        <xsl:call-template name="EnableLineBreaks">
                                            <xsl:with-param name="text"
                                                            select="./xml/info/profile"/>
                                            <xsl:with-param name="separator"
                                                            select="'#'"/>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                    <xsl:apply-templates select="./pdf"/>
                    <xsl:apply-templates select="./xml"/>
                    <!--
                    <xsl:call-template name="SubHeader">
                        <xsl:with-param name="text"
                                        select=="'Konformitätsprüfung:'"/>
                        <xsl:with-param name="color"
                                        select=="'black'"/>
                    </xsl:call-template>
                    -->
                    <xsl:call-template name="SubHeader">
                        <xsl:with-param name="text"
                                        select="concat('Bewertung: ', $result_text)"/>
                        <xsl:with-param name="color"
                                        select="$result_color"/>
                    </xsl:call-template>
                    <fo:block>Validierungsergebnisse im Detail:</fo:block>
                    <fo:table>
                        <fo:table-column border-style="solid"/>
                        <fo:table-column border-style="solid"/>
                        <fo:table-column border-style="solid"/>
                        <fo:table-column border-style="solid"
                                         column-width="68%"/>
                        <fo:table-header>
                            <fo:table-row background-color="#E0E0E0"
                                          font-weight="bold"
                                          border-style="solid">
                                <fo:table-cell>
                                    <fo:block margin="0mm"
                                              padding="1mm">Type</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block margin="0mm"
                                              padding="1mm">Code</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block margin="0mm"
                                              padding="1mm">Schwere</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block margin="0mm"
                                              padding="1mm">Text</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>
                        <fo:table-body page-break-after="auto"
                                       page-break-before="auto"
                                       page-break-inside="avoid">
                            <xsl:choose>
                                <xsl:when test="./pdf/messages|./xml/messages|./messages">
                                    <xsl:apply-templates select="./pdf/messages|./xml/messages|./messages"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <fo:table-row border-style="solid"
                                                  font-size="12px">
                                        <fo:table-cell number-columns-spanned="4">
                                            <fo:block margin="0mm"
                                                      padding="1mm"
                                                      text-align="center">Es gibt keine Hinweise, Warnungen oder Fehler.</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:table-body>
                    </fo:table>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template match="notice|warning|error|exception|fatal">
        <xsl:variable name="msg_color">
            <xsl:choose>
                <xsl:when test="name() = 'error' or name() = 'exception' or name() = 'fatal'">
                    <xsl:text>red</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'warning'">
                    <xsl:text>orange</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>black</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="msg_label">
            <xsl:choose>
                <xsl:when test="name() = 'error' or name() = 'exception' or name() = 'fatal'">
                    <xsl:text>Fehler</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'warning'">
                    <xsl:text>Warnung</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Hinweis</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="msg_text">
            <xsl:choose>
                <xsl:when test="contains(., ' [ID ')">
                    <xsl:value-of select="substring-before(., ' [ID')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="rows-spanned">
            <xsl:choose>
                <xsl:when test="./@location">
                    <xsl:value-of select="'2'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'1'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:table-row border-style="solid"
                      font-size="12px"
                      keep-with-previous="auto"
                      keep-with-next="always">
            <fo:table-cell number-rows-spanned="{$rows-spanned}">
                <fo:block margin="0mm"
                          padding="1mm">
                    <xsl:value-of select="./@type"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block margin="0mm"
                          padding="1mm">
                    <xsl:value-of select="substring-before(substring-after(., ' [ID '), ']')"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block color="{$msg_color}"
                          margin="0mm"
                          padding="1mm">
                    <xsl:value-of select="$msg_label"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block color="{$msg_color}"
                          margin="0mm"
                          padding="1mm">
                    <xsl:value-of select="$msg_text"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:if test="./@location">
            <fo:table-row border-style="solid"
                          font-size="8px"
                          keep-with-previous="always"
                          keep-with-next="auto">
                <fo:table-cell number-columns-spanned="3">
                    <fo:block color="{$msg_color}"
                              margin="0mm"
                              padding="1mm">
                        <fo:block font-size="12px">
                            <xsl:value-of select="'Pfad: '"/>
                        </fo:block>
                        <xsl:call-template name="EnableLineBreaks">
                            <xsl:with-param name="text"
                                            select="./@location"/>
                            <xsl:with-param name="separator"
                                            select="'/'"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>
    <xsl:template match="pdf">
        <xsl:call-template name="SubHeader">
            <xsl:with-param name="text"
                            select="concat('ZUGFeRD-PDF: ', $pdf_result_text)"/>
            <xsl:with-param name="color"
                            select="$pdf_result_color"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="xml">
        <xsl:call-template name="SubHeader">
            <xsl:with-param name="text"
                            select="concat('E-Rechnung XML: ', $xml_result_text)"/>
            <xsl:with-param name="color"
                            select="$xml_result_color"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="SubHeader">
        <xsl:param name="text"/>
        <xsl:param name="color"/>
        <fo:block color="{$color}"
                  background-color="#E0E0E0"
                  margin-bottom="10px"
                  padding="3px"
                  font-weight="bold"
                  margin-top="10px">
            <xsl:value-of select="$text"/>
        </fo:block>
    </xsl:template>
    <xsl:template name="EnableLineBreaks">
        <xsl:param name="text"/>
        <xsl:param name="separator"/>
        <xsl:for-each select="tokenize($text, $separator)">
            <xsl:choose>
                <xsl:when test="position() eq 1">
                    <fo:block>
                        <xsl:value-of select="."/>
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block>
                        <xsl:value-of select="concat($separator, .)"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
