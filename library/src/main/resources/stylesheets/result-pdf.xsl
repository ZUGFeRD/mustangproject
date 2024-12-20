<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	        xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
	        xmlns:xs="http://www.w3.org/2001/XMLSchema"        
	        version="2.0">
    <!-- ==========================================================================
       == Imports
       =========================================================================== -->
    <xsl:import href="common-xr.xsl"/>

    <xsl:import href="xr-pdf/lib/konstanten.xsl"/>

    <!-- FO engine used can be specified. Specific extensions will be then enabled.
       Supported values are:
            axf - Antenna House XSL Formatter
            fop - Apache FOP
       -->
    <xsl:param name="foengine"/>

    <xsl:param name="axf.extensions" select="if ($foengine eq 'axf') then true() else false()"/>
    <xsl:param name="fop.extensions" select="if ($foengine eq 'fop') then true() else false()"/>


    <xsl:variable name="xml_result_color">
        <xsl:if test="/validation/xml/summary/@status = 'valid' ">
            <xsl:text>green</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/xml/summary/@status = 'invalid' ">
            <xsl:text>red</xsl:text>
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="pdf_result_color">
        <xsl:if test="/validation/pdf/summary/@status = 'valid' ">
            <xsl:text>green</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/pdf/summary/@status = 'invalid' ">
            <xsl:text>red</xsl:text>
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="pdf_result_text">
        <xsl:if test="/validation/xml/summary/@status = 'valid' ">
            <xsl:text>Das ZUGFeRD-PDF ist valide.</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/xml/summary/@status = 'invalid' ">
            <xsl:text>Das ZUGFeRD-PDF ist nicht valide.</xsl:text>
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="result_text">
        <xsl:if test="/validation/xml/summary/@status = 'valid' ">
            <xsl:text>Es wird empfohlen das Dokument anzunehmen und weiter zu verarbeiten.</xsl:text>
        </xsl:if>
        <xsl:if test="/validation/xml/summary/@status = 'invalid' ">
            <xsl:text>Es wird empfohlen das Dokument zurückzuweisen.</xsl:text>
        </xsl:if>
    </xsl:variable>

    <xsl:template match="validation">
        <fo:root xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
                 language="{$lang}" font-family="{$fontSans}">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="DIN-A4" page-height="297mm" page-width="210mm">
                    <fo:region-body region-name="body" margin="20mm 10mm 20mm 20mm" />
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="DIN-A4">
                <fo:flow flow-name="body">
                    <fo:block font-size="24px" font-weight="bold">
                        Prüfbericht
                    </fo:block>

                    <xsl:call-template name="SubHeader">
                        <xsl:with-param name="text" select='"Angaben zum geprüften Dokument"' />
                        <xsl:with-param name="color" select='"black"' />
                    </xsl:call-template>

                    <fo:block>
                        <fo:block text-align="justify">
                            <fo:float float="right">
                                <fo:block >
                                    <xsl:value-of select="/validation/@filename" />
                                </fo:block>
                            </fo:float>
                            Referenz:
                        </fo:block>
                    </fo:block>
                    <fo:block>
                        <fo:block text-align="justify">
                            <fo:float float="right">
                                <fo:block >
                                    <xsl:value-of select="/validation/@datetime" />
                                </fo:block>
                            </fo:float>
                            Zeitpunkt der Prüfung:
                        </fo:block>
                    </fo:block>
                    <fo:block>
                        <fo:block text-align="justify">
                            <fo:float float="right">
                                <fo:block >
                                    <xsl:value-of select="/validation/xml/info/profile" />
                                </fo:block>
                            </fo:float>
                            Erkannter Dokumenttyp:
                        </fo:block>
                    </fo:block>

                    <xsl:apply-templates select="/validation/pdf" />

                    <!--<xsl:call-template name="SubHeader" >
                        <xsl:with-param name="text" select='"Konformitätsprüfung:"' />
                        <xsl:with-param name="color" select='"black"' />
                    </xsl:call-template>-->

                    <xsl:call-template name="SubHeader" >
                        <xsl:with-param name="text" select="concat('Bewertung: ', $result_text)" />
                        <xsl:with-param name="color" select="$xml_result_color" />
                    </xsl:call-template>

                    <fo:block>Validierungsergebnisse im Detail:</fo:block>

                    <fo:table>
                        <fo:table-column border-style="solid" />
                        <fo:table-column border-style="solid" />
                        <fo:table-column border-style="solid" />
                        <fo:table-column column-width="70%" border-style="solid" />
                        <fo:table-header>
                            <fo:table-row background-color="#E0E0E0" font-weight="bold">
                                <fo:table-cell>
                                    <fo:block>Type</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Code</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Schwere</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Text</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>
                        <fo:table-body>
                            <xsl:apply-templates select="/validation/xml/messages" />
                        </fo:table-body>
                    </fo:table>

                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="notice|error">
        <fo:table-row font-size="12px" border-style="solid">
            <fo:table-cell number-rows-spanned="2">
                <fo:block>
                    <xsl:value-of select="@type" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell number-rows-spanned="2">
                <fo:block>
                    <xsl:call-template name="SUBID" >
                        <xsl:with-param name="myparam" select="substring-after(.,' [ID ')" />
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell number-rows-spanned="2">
                <fo:block >
                    <xsl:choose>
                        <xsl:when test="name() = 'error'">
                            <xsl:attribute name="color">red</xsl:attribute>
                            Fehler
                        </xsl:when>
                        <xsl:otherwise>
                            Hinweis
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:if test="name() = 'error'">
                        <xsl:attribute name="color">red</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="substring-before(.,' [ID')" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <fo:table-row font-size="12px" border-style="solid">
            <fo:table-cell>
                <fo:block>
                    <xsl:if test="name() = 'error'">
                        <xsl:attribute name="color">red</xsl:attribute>
                    </xsl:if>
                    Pfad:
                    <xsl:value-of select="@location" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="pdf">
        <xsl:call-template name="SubHeader" >
            <xsl:with-param name="text" select="concat('ZUGFeRD-PDF: ', $pdf_result_text)" />
            <xsl:with-param name="color" select='"black"' />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="SubHeader">
        <xsl:param name="text" />
        <xsl:param name="color" />
        <fo:block color="{$color}" background-color="#E0E0E0" margin-bottom="10px" padding="3px" font-weight="bold" margin-top="10px">
            <xsl:value-of select="$text" />
        </fo:block>
    </xsl:template>

    <xsl:template name="SUBID">
        <xsl:param name="myparam" />
        <xsl:variable name="myparam.end" select="substring-before($myparam, ']')"/>
        <xsl:value-of select="$myparam.end"/>
    </xsl:template>

</xsl:stylesheet>
