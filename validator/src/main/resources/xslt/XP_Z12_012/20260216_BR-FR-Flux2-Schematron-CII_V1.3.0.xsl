<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:custom="http://www.example.org/custom"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
                xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
                xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->

   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->

   <!--KEYS AND FUNCTIONS-->
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-id-format"
                 as="xs:boolean">
      <xsl:param name="id" as="xs:string?"/>
      <xsl:sequence select="       matches(normalize-space($id), '^[A-Za-z0-9+\-_/]+$') and       not(matches($id, ' ')) and       not(starts-with($id, ' ')) and       not(ends-with($id, ' '))       "/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-date-format"
                 as="xs:boolean">
      <xsl:param name="date" as="xs:string?"/>
      <!-- Tronque la date aux 8 premiers caractères -->
      <xsl:variable name="shortDate" select="substring($date, 1, 8)"/>
      <!-- Vérifie le format AAAAMMJJ -->
      <xsl:variable name="isFormatValid"
                    select="matches($shortDate, '^20\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$')"/>
      <!-- Extraction des composantes -->
      <xsl:variable name="year" select="number(substring($shortDate, 1, 4))"/>
      <xsl:variable name="month" select="number(substring($shortDate, 5, 2))"/>
      <xsl:variable name="day" select="number(substring($shortDate, 7, 2))"/>
      <!-- Calcul année bissextile -->
      <xsl:variable name="isLeapYear"
                    select="($year mod 4 = 0 and $year mod 100 != 0) or ($year mod 400 = 0)"/>
      <!-- Nombre de jours max selon le mois -->
      <xsl:variable name="maxDay"
                    select="       if ($month = (1, 3, 5, 7, 8, 10, 12)) then 31       else if ($month = (4, 6, 9, 11)) then 30       else if ($month = 2 and $isLeapYear) then 29       else if ($month = 2) then 28       else 0"/>
      <!-- Résultat final -->
      <xsl:sequence select="$isFormatValid and $day le $maxDay"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-document-type-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="custom:document-type-codes"
                    as="xs:string"
                    select="'380 389 393 501 386 500 384 471 472 473 261 262 381 396 502 503'"/>
      <xsl:sequence select="$code = tokenize($custom:document-type-codes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-billing-mode"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="custom:billing-modes"
                    as="xs:string"
                    select="'B1 S1 M1 B2 S2 M2 S3 B4 S4 M4 S5 S6 B7 S7 B8 S8 M8'"/>
      <xsl:sequence select="$code = tokenize($custom:billing-modes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:check-siret-siren-coherence"
                 as="xs:boolean">
      <xsl:param name="siret" as="xs:string?"/>
      <xsl:param name="siren" as="xs:string?"/>
      <xsl:sequence select="matches($siret, '^\d{14}$') and substring($siret, 1, 9) = $siren"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-bar-treatment"
                 as="xs:boolean">
      <xsl:param name="value" as="xs:string?"/>
      <xsl:sequence select="$value = ('B2B', 'B2BINT', 'B2C', 'OUTOFSCOPE', 'ARCHIVEONLY')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-eas-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="custom:eas-codes"
                    as="xs:string"
                    select="'AN AQ AS AU EM 0002 0007 0009 0037 0060 0088 0096 0097 0106        0130 0135 0142 0147 0151 0154 0158 0170 0177 0183 0184 0188 0190        0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204        0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0218 0221 0225        0230 0235 0240 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924        9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937        9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950        9951 9952 9953 9957 9959'"/>
      <xsl:sequence select="$code = tokenize($custom:eas-codes, '\s+')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-vat-category-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="validCodes" select="('S', 'E', 'AE', 'K', 'G', 'O', 'Z')"/>
      <xsl:sequence select="$code = $validCodes"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-vat-rate"
                 as="xs:boolean">
      <xsl:param name="rate" as="xs:string?"/>
      <xsl:variable name="validRates"
                    select="(       '0', '0.0', '0.00', '10', '10.0', '10.00', '13', '13.0', '13.00', '20', '20.0', '20.00',       '8.5', '8.50', '19.6', '19.60', '2.1', '2.10', '5.5', '5.50', '7', '7.0', '7.00',       '20.6', '20.60', '1.05', '0.9', '0.90', '1.75', '9.2', '9.20', '9.6', '9.60'       )"/>
      <xsl:sequence select="$rate = $validRates"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-attachment-code"
                 as="xs:boolean">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="validCodes"
                    select="(       'RIB', 'LISIBLE', 'FEUILLE_DE_STYLE', 'PJA', 'BORDEREAU_SUIVI',       'DOCUMENT_ANNEXE', 'BON_LIVRAISON', 'BON_COMMANDE',       'BORDEREAU_SUIVI_VALIDATION', 'ETAT_ACOMPTE', 'FACTURE_PAIEMENT_DIRECT'       )"/>
      <xsl:sequence select="$code = $validCodes"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-schemeid-format"
                 as="xs:boolean">
      <xsl:param name="value" as="xs:string?"/>
      <!-- Autorise lettres, chiffres, + - _ / sans espaces -->
      <xsl:sequence select="matches($value, '^[A-Za-z0-9+\-_/]+$')"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-decimal-19-2"
                 as="xs:boolean">
      <xsl:param name="amount" as="xs:string?"/>
      <xsl:sequence select="matches($amount, '^[-]?\d{1,19}(\.\d{1,2})?$') and string-length(replace($amount, '\.', '')) le 19"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-decimal-19-4"
                 as="xs:boolean">
      <xsl:param name="quantity" as="xs:string?"/>
      <xsl:sequence select="matches($quantity, '^[-]?\d{1,19}(\.\d{1,4})?$') and string-length(replace($quantity, '\.', '')) le 19"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-decimal-19-6-positive"
                 as="xs:boolean">
      <xsl:param name="amount" as="xs:string?"/>
      <xsl:sequence select="matches($amount, '^\d{1,19}(\.\d{1,6})?$') and string-length(replace($amount, '\.', '')) le 19"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:is-valid-percent-4-2-positive"
                 as="xs:boolean">
      <xsl:param name="percent" as="xs:string?"/>
      <xsl:sequence select="matches($percent, '^\d{1,4}(\.\d{1,2})?$') and string-length(replace($percent, '\.', '')) le 4"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="custom:isSpecialContract"
                 as="xs:boolean">
      <xsl:param name="context" as="element()?"/>
      <xsl:sequence select="       exists($context/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID)       and (       $context/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = 'S8'       or $context/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = 'B8'       or $context/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = 'M8'       )       "/>
   </xsl:function>
   <!--DEFAULT RULES-->

   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.example.org/custom" prefix="custom"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
                                             prefix="rsm"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
                                             prefix="ram"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
                                             prefix="qdt"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
                                             prefix="udt"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-01_BR-FR-02</xsl:attribute>
            <xsl:attribute name="name">BR-FR-01 — Validation de la longueur et du format des identifiants de facture</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-03</xsl:attribute>
            <xsl:attribute name="name">BR-FR-03 — Validation de l'année dans les dates (2000–2099)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-04</xsl:attribute>
            <xsl:attribute name="name">BR-FR-04 — Validation du code type de document</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-05</xsl:attribute>
            <xsl:attribute name="name">BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-1)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-06</xsl:attribute>
            <xsl:attribute name="name">BR-FR-06 — Unicité des codes sujets dans les notes (BG-1)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-08</xsl:attribute>
            <xsl:attribute name="name">BR-FR-08 — Validation du mode de facturation (BT-23)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-09</xsl:attribute>
            <xsl:attribute name="name">BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-10</xsl:attribute>
            <xsl:attribute name="name">BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-11</xsl:attribute>
            <xsl:attribute name="name">BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-12</xsl:attribute>
            <xsl:attribute name="name">BR-FR-12 — Vérification de la présence du BT-49</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-13</xsl:attribute>
            <xsl:attribute name="name">BR-FR-13 — Vérification de la présence du BT-34</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-15</xsl:attribute>
            <xsl:attribute name="name">BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-16</xsl:attribute>
            <xsl:attribute name="name">BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-17</xsl:attribute>
            <xsl:attribute name="name">BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-18</xsl:attribute>
            <xsl:attribute name="name">BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-20</xsl:attribute>
            <xsl:attribute name="name">BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-21</xsl:attribute>
            <xsl:attribute name="name">BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-22</xsl:attribute>
            <xsl:attribute name="name">BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-23</xsl:attribute>
            <xsl:attribute name="name">BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-24</xsl:attribute>
            <xsl:attribute name="name">BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-25</xsl:attribute>
            <xsl:attribute name="name">BR-FR-25 — Longueur maximale des adresses électroniques (CII)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-26</xsl:attribute>
            <xsl:attribute name="name">BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-27</xsl:attribute>
            <xsl:attribute name="name">BR-FR-27 — Validation du groupe Attribut d’article (BG-32)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-28</xsl:attribute>
            <xsl:attribute name="name">BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-29</xsl:attribute>
            <xsl:attribute name="name">BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-30</xsl:attribute>
            <xsl:attribute name="name">BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-31</xsl:attribute>
            <xsl:attribute name="name">BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-03</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-04</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-05</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-07</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-08</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-09</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-10</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-12</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-14</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-CO-15</xsl:attribute>
            <xsl:attribute name="name">BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-DEC-01</xsl:attribute>
            <xsl:attribute name="name">BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-DEC-02</xsl:attribute>
            <xsl:attribute name="name">BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-DEC-03</xsl:attribute>
            <xsl:attribute name="name">BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-DEC-04</xsl:attribute>
            <xsl:attribute name="name">BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-01</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-01 — Vérification du sous-type de ligne lorsque le cadre de facturation est S8, B8 ou M8</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-02</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-02 — Vérification de la présence d'une ligne GROUP sans parent lorsque le cadre de facturation est S8, B8 ou M8</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-03</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-03 — Vérification des données obligatoires pour les lignes GROUP sans parent lorsque le cadre de facturation est S8, B8 ou M8</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-05</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-05 — Vérification de la cohérence des totaux HT entre la ligne GROUP et ses lignes enfants</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-06</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-06 — Vérification de la cohérence de l'identifiant légal du vendeur entre une ligne et sa ligne parent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-07</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-07 — Vérification de la cohérence du numéro de facture codifié AFL entre une ligne et sa ligne parent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-08</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-08 — Vérification de la raison d'exemption TVA contenant le numéro de sous-facture en ligne entre #</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-09</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-09 — Vérification de la cohérence du montant total TVA pour une ligne GROUP avec la somme des ventilations TVA liées</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-10</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-10 — Vérification de la cohérence du montant total avec TVA pour une ligne GROUP</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-11</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-11 — Vérification de la cohérence entre l'identifiant de facture à la ligne (AFL) et le numéro de facture (BT-1) pour le Vendeur principal</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-12</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-12 — Vérification de l'unicité des numéros de facture AFL pour les lignes GROUP sans parent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-FR-MV-13</xsl:attribute>
            <xsl:attribute name="name">BR-FR-MV-13 — Vérification que le code type de facture (BT-3) n'est pas un type auto-facturé interdit</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->

   <!--PATTERN BR-FR-01_BR-FR-02BR-FR-01 — Validation de la longueur et du format des identifiants de facture-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-01 — Validation de la longueur et du format des identifiants de facture</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID"
                 priority="1002"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 35"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 35">
               <xsl:attribute name="id">BR-FR-01_BT-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-01/BT-1 : L'identifiant de facture (ram:ID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-id-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-id-format(.)">
               <xsl:attribute name="id">BR-FR-02_BT-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-02/BT-1 : L'identifiant de facture (ram:ID) contient des caractères non autorisés. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID"
                 priority="1001"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 35"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 35">
               <xsl:attribute name="id">BR-FR-01_BT-25</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-01/BT-25 : L'identifiant de facture référencée (ram:IssuerAssignedID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-id-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-id-format(.)">
               <xsl:attribute name="id">BR-FR-02_BT-25</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-02/BT-25 : L'identifiant de facture référencée (ram:IssuerAssignedID) contient des caractères non autorisés. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 35"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 35">
               <xsl:attribute name="id">BR-FR-01_EXT-FR-FE-136</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-01/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (ram:IssuerAssignedID) ne doit pas dépasser 35 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier que l'identifiant respecte cette limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-id-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-id-format(.)">
               <xsl:attribute name="id">BR-FR-02_EXT-FR-FE-136</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-02/EXT-FR-FE-136 : L'identifiant de facture référencée en ligne (ram:IssuerAssignedID) contient des caractères non autorisés. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles + - _ / sont autorisés, sans espaces.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <!--PATTERN BR-FR-03BR-FR-03 — Validation de l'année dans les dates (2000–2099)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-03 — Validation de l'année dans les dates (2000–2099)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"
                 priority="1010"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-2 : La date d’émission (udt:DateTimeString) doit contenir une année comprise entre 2000 et 2099, au format AAAAMMJJ. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier que l’année est correcte et que le format est conforme.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString"
                 priority="1009"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-7</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-7 : La date de fait générateur de la taxe (udt:DateString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"
                 priority="1008"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-9</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-9 : La date d’échéance (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1007"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-26</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-26 : La date d’émission de la facture référencée (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"
                 priority="1006"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-72</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-72 : La date de livraison effective (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1005"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-73</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-73 : La date de début de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1004"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_BT-74</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-74 : La date de fin de période de facturation (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1003"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-138</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/EXT-FR-FE-138 : La date d’émission de la facture référencée en ligne (qdt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"
                 priority="1002"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-158</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/EXT-FR-FE-158 : La date de livraison effective en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1001"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-134</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-134 : La date de début de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-date-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-date-format(.)">
               <xsl:attribute name="id">BR-FR-03_EXT-FR-FE-135</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-03/BT-135 : La date de fin de période de facturation en ligne (udt:DateTimeString) doit contenir une année entre 2000 et 2099. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier la validité de la date.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--PATTERN BR-FR-04BR-FR-04 — Validation du code type de document-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-04 — Validation du code type de document</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode"
                 priority="1002"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-document-type-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-document-type-code(.)">
               <xsl:attribute name="id">BR-FR-04_BT-3</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-04/BT-3 : Le code type de document (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez utiliser un code conforme à la liste autorisée. Les autres codes définis dans la norme UNTDID 1001 ne doivent pas être utilisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode"
                 priority="1001"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-document-type-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-document-type-code(.)">
               <xsl:attribute name="id">BR-FR-04_EXT-FR-FE-02</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-04/EXT-FR-FE-02 : Le code type de document référencé (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez utiliser un code conforme à la liste autorisée.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-document-type-code(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-document-type-code(.)">
               <xsl:attribute name="id">BR-FR-04_EXT-FR-FE-137</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-04/EXT-FR-FE-137 : Le code type de document référencé en ligne (ram:TypeCode) n’est pas autorisé. Valeurs acceptées :
        380, 389, 393, 501, 386, 500, 384, 471, 472, 473, 261, 262, 381, 396, 502, 503.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez utiliser un code conforme à la liste autorisée.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <!--PATTERN BR-FR-05BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-1)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-05 — Présence obligatoire des mentions légales dans les notes (BG-1)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument"/>
      <xsl:variable name="notes" select="ram:IncludedNote"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists($notes[ram:SubjectCode = 'PMT'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists($notes[ram:SubjectCode = 'PMT'])">
               <xsl:attribute name="id">BR-FR-05_BT-22_PMT</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-05/BT-22 : La mention relative aux frais de recouvrement (code PMT) est absente. Elle est obligatoire dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists($notes[ram:SubjectCode = 'PMD'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists($notes[ram:SubjectCode = 'PMD'])">
               <xsl:attribute name="id">BR-FR-05_BT-22_PMD</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-05/BT-22 : La mention relative aux pénalités de retard (code PMD) est absente. Elle est obligatoire dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists($notes[ram:SubjectCode = 'AAB'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists($notes[ram:SubjectCode = 'AAB'])">
               <xsl:attribute name="id">BR-FR-05_BT-22_AAB</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-05/BT-22 : La mention relative à l’escompte ou à son absence (code AAB) est absente. Elle est obligatoire dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <!--PATTERN BR-FR-06BR-FR-06 — Unicité des codes sujets dans les notes (BG-1)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-06 — Unicité des codes sujets dans les notes (BG-1)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument"/>
      <xsl:variable name="notes" select="ram:IncludedNote"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count($notes[ram:SubjectCode = 'PMT']) le 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($notes[ram:SubjectCode = 'PMT']) le 1">
               <xsl:attribute name="id">BR-FR-06_BT-21_PMT</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-06/BT-21 : Le code sujet PMT (indemnité forfaitaire pour frais de recouvrement) ne doit apparaître qu'une seule fois dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count($notes[ram:SubjectCode = 'PMD']) le 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($notes[ram:SubjectCode = 'PMD']) le 1">
               <xsl:attribute name="id">BR-FR-06_BT-21_PMD</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-06/BT-21 : Le code sujet PMD (pénalités de retard) ne doit apparaître qu'une seule fois dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count($notes[ram:SubjectCode = 'AAB']) le 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($notes[ram:SubjectCode = 'AAB']) le 1">
               <xsl:attribute name="id">BR-FR-06_BT-21_AAB</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-06/BT-21 : Le code sujet AAB (mention d’escompte ou d’absence d’escompte) ne doit apparaître qu'une seule fois dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count($notes[ram:SubjectCode = 'TXD']) le 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($notes[ram:SubjectCode = 'TXD']) le 1">
               <xsl:attribute name="id">BR-FR-06_BT-21_TXD</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-06/BT-21 : Le code sujet TXD (mention de taxe) ne doit apparaître qu'une seule fois dans les notes (BG-1).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <!--PATTERN BR-FR-08BR-FR-08 — Validation du mode de facturation (BT-23)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-08 — Validation du mode de facturation (BT-23)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-billing-mode(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-billing-mode(.)">
               <xsl:attribute name="id">BR-FR-08_BT-23</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-08/BT-23 : La valeur du mode de facturation (ram:ID) n’est pas autorisée. Valeurs acceptées : B1, S1, M1, B2, S2, M2, B4, S4, M4, S5, S6, B7, S7.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez utiliser une valeur conforme à la liste des modes de facturation autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <!--PATTERN BR-FR-09BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-09 — Cohérence entre SIRET (GlobalID) et SIREN (ID)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"
                 priority="1009"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_BT-29</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/BT-29 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"
                 priority="1008"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_BT-46</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/BT-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty"
                 priority="1007"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_BT-60</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/BT-60 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty"
                 priority="1006"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-06</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/EXT-FR-FE-06 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty"
                 priority="1005"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-46</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/EXT-FR-FE-46 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty"
                 priority="1004"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-69</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/EXT-FR-FE-69 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty"
                 priority="1003"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-92</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/EXT-FR-FE-92 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty"
                 priority="1002"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-115</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/EXT-FR-FE-115 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty"
                 priority="1001"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_BT-71</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/BT-71 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty"/>
      <xsl:variable name="siret" select="ram:GlobalID[@schemeID='0009']"/>
      <xsl:variable name="siren"
                    select="if (string(ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'])) then ram:SpecifiedLegalOrganization/ram:ID[@schemeID='0002'] else substring($siret, 1, 9)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($siret) or custom:check-siret-siren-coherence($siret[1], $siren)">
               <xsl:attribute name="id">BR-FR-09_EXT-FR-FE-146</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-09/EXT-FR-FE-146 : Le SIRET doit contenir 14 chiffres et commencer par le SIREN. SIRET : "<xsl:text/>
                  <xsl:value-of select="$siret"/>
                  <xsl:text/>", SIREN : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--PATTERN BR-FR-10BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-10 — SIREN du vendeur obligatoire et valide (BT-30)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="siren"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID = '0002']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$siren and matches(normalize-space($siren), '^\d{9}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$siren and matches(normalize-space($siren), '^\d{9}$')">
               <xsl:attribute name="id">BR-FR-10_BT-30</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-10/BT-30 : Le SIREN du vendeur (ram:ID) est obligatoire et doit être composé exactement de 9 chiffres. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
        Veuillez renseigner un identifiant SIREN valide.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <!--PATTERN BR-FR-11BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-11 — SIREN obligatoire et valide si traitement BAR/B2B (BT-47)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="barTreatment"
                    select="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content"/>
      <xsl:variable name="siren"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID = '0002']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($barTreatment = 'B2B') or matches($siren, '^\d{9}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($barTreatment = 'B2B') or matches($siren, '^\d{9}$')">
               <xsl:attribute name="id">BR-FR-11_BT-47</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-11/BT-47 : Si une note contient le code sujet BAR avec la valeur 'B2B', alors le SIREN de l’acheteur (BT-47, ram:ID) est obligatoire et doit être composé exactement de 9 chiffres. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
        Veuillez renseigner un identifiant SIREN valide.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--PATTERN BR-FR-12BR-FR-12 — Vérification de la présence du BT-49-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-12 — Vérification de la présence du BT-49</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="endpointID"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string($endpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string($endpointID)">
               <xsl:attribute name="id">BR-FR-12_BT-49</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-12/BT-49 : Le BT-49  est obligatoire.
        Valeur actuelle : BT-49="<xsl:text/>
                  <xsl:value-of select="$endpointID"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <!--PATTERN BR-FR-13BR-FR-13 — Vérification de la présence du BT-34-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-13 — Vérification de la présence du BT-34</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="endpointID"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string($endpointID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string($endpointID)">
               <xsl:attribute name="id">BR-FR-13_BT-34</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-13/BT-34 : Le BT-34  est obligatoire.
        Valeur actuelle : BT-34="<xsl:text/>
                  <xsl:value-of select="$endpointID"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <!--PATTERN BR-FR-15BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-15 — Vérification des codes de catégorie de TVA (BT-95, BT-102, BT-118, BT-151)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax"
                 priority="1002"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax"/>
      <xsl:variable name="categoryCode" select="ram:CategoryCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-vat-category-code($categoryCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-vat-category-code($categoryCode)">
               <xsl:attribute name="id">BR-FR-15_BT-95_BT-102</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-15/BT-95 ou BT-102 : Code de catégorie de TVA invalide. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$categoryCode"/>
                  <xsl:text/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($categoryCode = ('L', 'M'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($categoryCode = ('L', 'M'))">
               <xsl:attribute name="id">BR-FR-15_BT-95_BT-102_LM</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-15/BT-95 ou BT-102 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$categoryCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax"
                 priority="1001"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax"/>
      <xsl:variable name="categoryCode" select="ram:CategoryCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-vat-category-code($categoryCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-vat-category-code($categoryCode)">
               <xsl:attribute name="id">BR-FR-15_BT-95_BT-118</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-15/BT-118 : Code de catégorie de TVA invalide. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$categoryCode"/>
                  <xsl:text/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($categoryCode = ('L', 'M'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($categoryCode = ('L', 'M'))">
               <xsl:attribute name="id">BR-FR-15_BT-95_BT-118_LM</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-15/BT-118 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$categoryCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax"/>
      <xsl:variable name="categoryCode" select="ram:CategoryCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-vat-category-code($categoryCode)          or (not($categoryCode) and (../../ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' or ../../ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'INFORMATION'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-vat-category-code($categoryCode) or (not($categoryCode) and (../../ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' or ../../ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'INFORMATION'))">
               <xsl:attribute name="id">BR-FR-15_BT-95_BT-151</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-15/BT-151 : Code de catégorie de TVA invalide. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$categoryCode"/>
                  <xsl:text/>". Veuillez utiliser un code valide : S, E, AE, K, G, O, Z.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($categoryCode = ('L', 'M'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($categoryCode = ('L', 'M'))">
               <xsl:attribute name="id">BR-FR-15_BT-95_BT-151_LM</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-15/BT-151 : Les codes 'L' et 'M' ne sont pas pertinents en France. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="$categoryCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--PATTERN BR-FR-16BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-16 — Vérification des taux de TVA autorisés (BT-96, BT-103, BT-119, BT-152)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax"
                 priority="1002"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax"/>
      <xsl:variable name="rate" select="string(ram:RateApplicablePercent)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($rate) or custom:is-valid-vat-rate($rate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($rate) or custom:is-valid-vat-rate($rate)">
               <xsl:attribute name="id">BR-FR-16_BT-96_BT-103</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-16/BT-96 ou BT-103 : Le taux de TVA (BT-96) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<xsl:text/>
                  <xsl:value-of select="$rate"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax"
                 priority="1001"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax"/>
      <xsl:variable name="rate" select="string(ram:RateApplicablePercent)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($rate) or custom:is-valid-vat-rate($rate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($rate) or custom:is-valid-vat-rate($rate)">
               <xsl:attribute name="id">BR-FR-16_BT-119</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-16/BT-119 : Le taux de TVA (BT-119) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<xsl:text/>
                  <xsl:value-of select="$rate"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax"/>
      <xsl:variable name="rate" select="string(ram:RateApplicablePercent)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($rate) or custom:is-valid-vat-rate($rate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($rate) or custom:is-valid-vat-rate($rate)">
               <xsl:attribute name="id">BR-FR-16_BT-152</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-16/BT-152 : Le taux de TVA (BT-152) doit être exprimé en pourcentage sans symbole « % » et faire partie des valeurs autorisées. Taux fourni : "<xsl:text/>
                  <xsl:value-of select="$rate"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--PATTERN BR-FR-17BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-17 — Codes autorisés pour qualifier les pièces jointes (BT-123)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode = '916']"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode = '916']"/>
      <xsl:variable name="code" select="normalize-space(ram:Name)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($code) or custom:is-valid-attachment-code($code)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($code) or custom:is-valid-attachment-code($code)">
               <xsl:attribute name="id">BR-FR-17_BT-123</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-17/BT-123 : Le code de qualification de la pièce jointe "<xsl:text/>
                  <xsl:value-of select="$code"/>
                  <xsl:text/>" est invalide. Il doit appartenir à la liste des codes autorisés. Veuillez corriger la valeur de BT-123.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--PATTERN BR-FR-18BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-18 — Un seul document additionnel avec la description 'LISIBLE' (BT-123)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="lisibleCount"
                    select="count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:Name = 'LISIBLE'])"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$lisibleCount le 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$lisibleCount le 1">
               <xsl:attribute name="id">BR-FR-18_BT-123</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-18/BT-123 : Il ne peut y avoir **qu’un seul** document additionnel (BG-24) dont la description (BT-123) est "LISIBLE".
        Nombre de documents trouvés : <xsl:text/>
                  <xsl:value-of select="$lisibleCount"/>
                  <xsl:text/>.
        Veuillez supprimer les doublons ou corriger les descriptions.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--PATTERN BR-FR-20BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-20 — Vérification du traitement associé à une note avec code sujet 'BAR' (BT-21)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']"/>
      <xsl:variable name="barTreatment" select="ram:Content"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-bar-treatment($barTreatment)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-bar-treatment($barTreatment)">
               <xsl:attribute name="id">BR-FR-20_BT-21</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-20/BT-21 : Lorsqu’une note a pour code sujet « BAR » (BT-21), la valeur associée (BT-22, contenu de la note) doit être l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<xsl:text/>
                  <xsl:value-of select="$barTreatment"/>
                  <xsl:text/>". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--PATTERN BR-FR-21BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-21 — Vérification du BT-49 en cas de traitement BAR/B2B et hors cas autofacture</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="barTreatment"
                    select="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content"/>
      <xsl:variable name="docType" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <xsl:variable name="siren"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
      <xsl:variable name="endpointID"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <xsl:variable name="endpointSchemeID"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID"/>
      <xsl:variable name="isB2B" select="$barTreatment = 'B2B'"/>
      <xsl:variable name="isExcludedDocType"
                    select="$docType = ('389', '501', '500', '471', '473', '261', '502')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isB2B and not($isExcludedDocType)) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isB2B and not($isExcludedDocType)) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')">
               <xsl:attribute name="id">BR-FR-21_BT-49</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-21/BT-49 : Si le traitement est BAR/B2B et que le type de document (BT-3) n’est pas en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-49 (EndpointID) doit commencer par le SIREN (BT-47) et le BT-49-1 (schemeID) doit être égal à "0225".
        Valeurs actuelles : EndpointID="<xsl:text/>
                  <xsl:value-of select="$endpointID"/>
                  <xsl:text/>", schemeID="<xsl:text/>
                  <xsl:value-of select="$endpointSchemeID"/>
                  <xsl:text/>", SIREN="<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--PATTERN BR-FR-22BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-22 — Vérification du BT-34 en cas de traitement BAR/B2B et en autofacture</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="barTreatment"
                    select="rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'BAR']/ram:Content"/>
      <xsl:variable name="docType" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <xsl:variable name="siren"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
      <xsl:variable name="endpointID"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <xsl:variable name="endpointSchemeID"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID/@schemeID"/>
      <xsl:variable name="isB2B" select="$barTreatment = 'B2B'"/>
      <xsl:variable name="isExcludedDocType"
                    select="$docType = ('389', '501', '500', '471', '473', '261', '502')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isB2B and $isExcludedDocType) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isB2B and $isExcludedDocType) or (starts-with($endpointID, $siren) and $endpointSchemeID = '0225')">
               <xsl:attribute name="id">BR-FR-22_BT-34</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-22/BT-34 : Si le traitement est BAR/B2B et que le type de document (BT-3) est en autofacture (389, 501, 500, 471, 473, 261, 502), alors le BT-34 (EndpointID du vendeur) doit commencer par le SIREN (BT-30) et le BT-34-1 (schemeID) doit être égal à "0225".
        Valeurs actuelles : EndpointID="<xsl:text/>
                  <xsl:value-of select="$endpointID"/>
                  <xsl:text/>", schemeID="<xsl:text/>
                  <xsl:value-of select="$endpointSchemeID"/>
                  <xsl:text/>", SIREN="<xsl:text/>
                  <xsl:value-of select="$siren"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--PATTERN BR-FR-23BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-23 — Validation du format des adresses électroniques avec schemeID = 0225 (CII)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1007"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_BT-34</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/BT-34 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1006"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_BT-49</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/BT-49 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1005"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-12</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/EXT-FR-FE-12 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1004"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-29</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/EXT-FR-FE-29 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1003"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-52</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/EXT-FR-FE-52 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1002"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-75</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/EXT-FR-FE-75 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1001"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-98</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/EXT-FR-FE-98 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID[@schemeID='0225']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-23_EXT-FR-FE-121</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-23/EXT-FR-FE-121 : L'adresse électronique (ram:URIID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--PATTERN BR-FR-24BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-24 — Validation du format des identifiants privés avec schemeID = 0224 (CII)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']"
                 priority="1001"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-24_BT-29</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-24/BT-29 : L'identifiant privé (ram:GlobalID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-schemeid-format(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-schemeid-format(.)">
               <xsl:attribute name="id">BR-FR-24_BT-46</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-24/BT-46 : L'identifiant privé (ram:GlobalID) ne respecte pas le format autorisé. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Seuls les caractères alphanumériques et les symboles "-", "_", "." sont autorisés.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <!--PATTERN BR-FR-25BR-FR-25 — Longueur maximale des adresses électroniques (CII)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-25 — Longueur maximale des adresses électroniques (CII)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1007"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_BT-34</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/BT-34 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1006"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_BT-49</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/BT-49 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1005"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-12</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/EXT-FR-FE-12 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1004"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-29</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/EXT-FR-FE-29 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1003"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-52</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/EXT-FR-FE-52 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1002"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-75</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/EXT-FR-FE-75 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1001"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-98</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/EXT-FR-FE-98 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 125"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 125">
               <xsl:attribute name="id">BR-FR-25_EXT-FR-FE-121</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-25/EXT-FR-FE-121 : L'adresse électronique (ram:URIID) dépasse 125 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--PATTERN BR-FR-26BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-26 — Longueur maximale des identifiants privés avec schemeID = 0224</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']"
                 priority="1001"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID='0224']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 100"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 100">
               <xsl:attribute name="id">BR-FR-26_BT-29</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-26/BT-29 : L'identifiant privé (ram:GlobalID) dépasse 100 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID[@schemeID='0224']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.) le 100"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) le 100">
               <xsl:attribute name="id">BR-FR-26_BT-46</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-26/BT-46 : L'identifiant privé (ram:GlobalID) dépasse 100 caractères. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez raccourcir cette valeur pour respecter la limite.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--PATTERN BR-FR-27BR-FR-27 — Validation du groupe Attribut d’article (BG-32)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-27 — Validation du groupe Attribut d’article (BG-32)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic"
                 priority="1002"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ram:Description or ram:TypeCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ram:Description or ram:TypeCode">
               <xsl:attribute name="id">BR-FR-27_BG-32</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-27/BG-32 : Le groupe Attribut d’article (BG-32) doit contenir soit un nom d’attribut d’article (BT-160 : ram:Description), soit un code d’attribut d’article (EXT-FR-FE-159 : ram:TypeCode).
        Aucun des deux éléments n’a été trouvé dans le contexte ApplicableProductCharacteristic.
        Veuillez ajouter au moins l’un des deux éléments pour respecter la structure attendue.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Description"
                 priority="1001"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Description"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-27_BT-160</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-27/BT-160 : Le nom d’attribut d’article (ram:Description) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez fournir un nom d’attribut valide ou utiliser un code à la place.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-27_EXT-FR-FE-159</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-27/EXT-FR-FE-159 : Le code d’attribut d’article (ram:TypeCode) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez fournir un code d’attribut valide ou utiliser un nom à la place.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--PATTERN BR-FR-28BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-28 — Validation de la valeur d’attribut d’article (BG-32)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic"
                 priority="1003"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(ram:Value or (ram:ValueMeasure and ram:ValueMeasure/@unitCode)) and not(ram:Value and (ram:ValueMeasure and ram:ValueMeasure/@unitCode))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(ram:Value or (ram:ValueMeasure and ram:ValueMeasure/@unitCode)) and not(ram:Value and (ram:ValueMeasure and ram:ValueMeasure/@unitCode))">
               <xsl:attribute name="id">BR-FR-28_BT-161-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-28/BT-161 : Le groupe Attribut d’article (BG-32) doit contenir soit une valeur d’attribut (BT-161 : ram:Value), soit une valeur d’attribut avec unité de mesure (EXT-FR-FE-160 : ram:ValueMeasure) accompagnée de son unité (EXT-FR-FE-161 : @unitCode), et pas les deux.
        Veuillez fournir une valeur d’attribut ou une valeur mesurée avec son unité, et pas les deux.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Value"
                 priority="1002"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:Value"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-28_BT-161-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-28/BT-161 : La valeur d’attribut (ram:Value) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez fournir une valeur d’attribut valide ou utiliser une mesure avec unité.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure"
                 priority="1001"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-28_EXT-FR-FE-160</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-28/EXT-FR-FE-160 : La valeur mesurée (ram:ValueMeasure) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez fournir une valeur mesurée valide accompagnée de son unité.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure/@unitCode"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:ValueMeasure/@unitCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-28_EXT-FR-FE-161</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-28/EXT-FR-FE-161 : L’unité de mesure (@unitCode) ne doit pas être vide lorsqu’une valeur mesurée est fournie.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez spécifier une unité de mesure conforme.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--PATTERN BR-FR-29BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-29 — Vérification des identifiants d’objets facturés (BT-18)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement"
                 priority="1002"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1">
               <xsl:attribute name="id">BR-FR-29_BT-18</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-29/BT-18 : Parmi les identifiants d’objets facturés (BT-18), les schémas d’identification "AFL" et "AVV" ne doivent être présents qu’une seule fois chacun.
        Actuellement : AFL = <xsl:text/>
                  <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL'])"/>
                  <xsl:text/> occurrence(s), AVV = <xsl:text/>
                  <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV'])"/>
                  <xsl:text/> occurrence(s).
        Veuillez supprimer les doublons pour respecter la règle.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID"
                 priority="1001"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-29_AFL</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-29/AFL : L’identifiant associé au schéma "AFL" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-29_AVV</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-29/AVV : L’identifiant associé au schéma "AVV" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--PATTERN BR-FR-30BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-30 — Vérification des identifiants d’objets facturés à la ligne (BT-128)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"
                 priority="1002"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']) &lt;= 1 and count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']) &lt;= 1">
               <xsl:attribute name="id">BR-FR-30_BT-128</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-30/BT-128 : Parmi les identifiants d’objets facturés à la ligne (BT-128), les schémas d’identification "AFL" et "AVV" ne doivent être présents qu’une seule fois chacun.
        Actuellement : AFL = <xsl:text/>
                  <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL'])"/>
                  <xsl:text/> occurrence(s), AVV = <xsl:text/>
                  <xsl:value-of select="count(ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV'])"/>
                  <xsl:text/> occurrence(s).
        Veuillez supprimer les doublons pour respecter la règle.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID"
                 priority="1001"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AFL']/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-30_AFL</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-30/AFL : L’identifiant associé au schéma "AFL" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode='AVV']/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(.) != ''">
               <xsl:attribute name="id">BR-FR-30_AVV</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-30/AVV : L’identifiant associé au schéma "AVV" (ram:IssuerAssignedID) ne doit pas être vide.
        Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--PATTERN BR-FR-31BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste -->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-31 — Note avec code sujet BAR : une seule valeur possible dans la liste </svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument"/>
      <xsl:variable name="barNotes" select="ram:IncludedNote[ram:SubjectCode = 'BAR']"/>
      <xsl:variable name="barCount"
                    select="count($barNotes[normalize-space(ram:Content) = 'B2B' or normalize-space(ram:Content) = 'B2BINT' or normalize-space(ram:Content) = 'B2C' or normalize-space(ram:Content) = 'OUTOFSCOPE' or normalize-space(ram:Content) = 'ARCHIVEONLY'])"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$barCount &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$barCount &lt;= 1">
               <xsl:attribute name="id">BR-FR-30_BT-21</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-30/BT-21 : Lorsque plusieurs notes ont le code sujet « BAR » (BT-21), Il ne peut y avoir qu'une seule valeur associée (BT-22, contenu de la note) parmi l’une des suivantes : B2B, B2BINT, B2C, OUTOFSCOPE, ARCHIVEONLY.
        Valeur fournie : "<xsl:text/>
                  <xsl:value-of select="$barNotes"/>
                  <xsl:text/>" , Nombre de valeurs présentes (pas plus de 1) : <xsl:text/>
                  <xsl:value-of select="$barCount"/>
                  <xsl:text/>  "/&gt;". Veuillez corriger la valeur ou retirer le code sujet « BAR ».
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-03BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-03 — Présence obligatoire du contrat et de la période de facturation si type de facture = 262 (Avoir Remise Globale)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <xsl:variable name="contractReference"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID"/>
      <xsl:variable name="billingPeriodStart"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"/>
      <xsl:variable name="billingPeriodEnd"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($typeCode = '262') or (string($contractReference) and string($billingPeriodStart) and string($billingPeriodEnd))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($typeCode = '262') or (string($contractReference) and string($billingPeriodStart) and string($billingPeriodEnd))">
               <xsl:attribute name="id">BR-FR-CO-03_BT-3</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-03/BT-3 : Si le code type de la facture (BT-3) est égal à 262 (Avoir Remise Globale), alors :
        - Le numéro de contrat (BT-12) doit être présent
        - La période de facturation (BG-14) doit être renseignée (dates de début et de fin).
        Valeurs actuelles : BT-12="<xsl:text/>
                  <xsl:value-of select="$contractReference"/>
                  <xsl:text/>", période="<xsl:text/>
                  <xsl:value-of select="$billingPeriodStart"/>
                  <xsl:text/> à <xsl:text/>
                  <xsl:value-of select="$billingPeriodEnd"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-04BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-04 — Une seule référence à une facture antérieure obligatoire pour les factures rectificatives (BT-3)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <xsl:variable name="references"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument"/>
      <xsl:variable name="refCount" select="count($references)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($typeCode = ('384', '471', '472', '473')) or $refCount = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($typeCode = ('384', '471', '472', '473')) or $refCount = 1">
               <xsl:attribute name="id">BR-FR-CO-04_BT-4</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-04/BT-3 : Si le type de facture (BT-3) est une facture rectificative (384, 471, 472, 473), alors **une et une seule** référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente.
        Nombre de références valides trouvées : <xsl:text/>
                  <xsl:value-of select="$refCount"/>
                  <xsl:text/>.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-05BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-05 — Référence obligatoire à une facture antérieure pour les avoirs (BT-3)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <xsl:variable name="headerRefs"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument"/>
      <xsl:variable name="headerRefCount"
                    select="count($headerRefs[ram:IssuerAssignedID and ram:FormattedIssueDateTime/qdt:DateTimeString])"/>
      <xsl:variable name="lineRefsValid"
                    select="every $line in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies          exists($line/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument[ram:IssuerAssignedID and ram:FormattedIssueDateTime/qdt:DateTimeString])"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($typeCode = ('261', '381', '396', '502', '503')) or ($headerRefCount ge 1 or $lineRefsValid)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($typeCode = ('261', '381', '396', '502', '503')) or ($headerRefCount ge 1 or $lineRefsValid)">
               <xsl:attribute name="id">BR-FR-CO-05_BT-3</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-05/BT-3 : Si le type de facture (BT-3) est un avoir (261, 381, 396, 502, 503), alors :
        - soit au moins une référence à une facture antérieure (BT-25) avec sa date (BT-26) doit être présente au niveau entête,
        - soit chaque ligne (BG-25) doit contenir une référence à une facture antérieure (EXT-FR-FE-136) avec sa date (EXT-FR-FE-138).
        Références entête trouvées : <xsl:text/>
                  <xsl:value-of select="$headerRefCount"/>
                  <xsl:text/>.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-07BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-07 — La date d’échéance (BT-9) doit être postérieure ou égale à la date de facture (BT-2), sauf cas particuliers</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="dueDate"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"/>
      <xsl:variable name="issueDate"
                    select="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"/>
      <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <xsl:variable name="frameworkCode"
                    select="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(string($dueDate)) or          ($typeCode = ('386', '500', '503') or $frameworkCode = ('B2', 'S2', 'M2') or $dueDate ge $issueDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(string($dueDate)) or ($typeCode = ('386', '500', '503') or $frameworkCode = ('B2', 'S2', 'M2') or $dueDate ge $issueDate)">
               <xsl:attribute name="id">BR-FR-CO-07_BT-9</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-07/BT-9 : La date d’échéance (BT-9), si présente, doit être postérieure ou égale à la date de facture (BT-2),
        sauf si la facture est de type acompte (386, 500, 503) ou si le cadre de facturation (BT-23) est B2, S2 ou M2.
        Valeurs actuelles : Date facture = "<xsl:text/>
                  <xsl:value-of select="$issueDate"/>
                  <xsl:text/>", Date échéance = "<xsl:text/>
                  <xsl:value-of select="$dueDate"/>
                  <xsl:text/>", Type = "<xsl:text/>
                  <xsl:value-of select="$typeCode"/>
                  <xsl:text/>", Cadre = "<xsl:text/>
                  <xsl:value-of select="$frameworkCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-08BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-08 — Incompatibilité entre cadre de facturation (BT-23) et type de facture (BT-3)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="frameworkCode"
                    select="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <xsl:variable name="typeCode" select="rsm:ExchangedDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($frameworkCode = ('B4', 'S4', 'M4')) or not($typeCode = ('386', '500', '503'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($frameworkCode = ('B4', 'S4', 'M4')) or not($typeCode = ('386', '500', '503'))">
               <xsl:attribute name="id">BR-FR-CO-08_BT-23</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-08/BT-23 : Si le cadre de facturation (BT-23) est B4, S4 ou M4 (factures définitives après acompte), alors le type de facture (BT-3) ne peut pas être une facture ou un avoir d’acompte (386, 500, 503).
        Valeurs actuelles : BT-23="<xsl:text/>
                  <xsl:value-of select="$frameworkCode"/>
                  <xsl:text/>", BT-3="<xsl:text/>
                  <xsl:value-of select="$typeCode"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-09BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-09 — Contrôle des montants et de la date d’échéance pour les factures déjà payées (BT-23)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="frameworkCode"
                    select="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <xsl:variable name="isPaidMode" select="$frameworkCode = ('B2', 'S2', 'M2')"/>
      <xsl:variable name="paidAmount"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount"/>
      <xsl:variable name="totalAmount"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount"/>
      <xsl:variable name="dueAmount"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount"/>
      <xsl:variable name="dueDate"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isPaidMode) or (number($paidAmount) = number($totalAmount))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isPaidMode) or (number($paidAmount) = number($totalAmount))">
               <xsl:attribute name="id">BR-FR-CO-09_BT-23-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2 (facture déjà payée), alors le montant déjà payé (BT-113) doit être égal au montant total TTC (BT-112).
        Montant payé : <xsl:text/>
                  <xsl:value-of select="$paidAmount"/>
                  <xsl:text/>, Montant total : <xsl:text/>
                  <xsl:value-of select="$totalAmount"/>
                  <xsl:text/>.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isPaidMode) or (number($dueAmount) = 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isPaidMode) or (number($dueAmount) = 0)">
               <xsl:attribute name="id">BR-FR-CO-09_BT-23-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors le net à payer (BT-115) doit être égal à 0.
        Net à payer : <xsl:text/>
                  <xsl:value-of select="$dueAmount"/>
                  <xsl:text/>.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isPaidMode) or string($dueDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isPaidMode) or string($dueDate)">
               <xsl:attribute name="id">BR-FR-CO-09_BT-23-3</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-09/BT-23 : Si le cadre de facturation (BT-23) est B2, S2 ou M2, alors la date d’échéance (BT-9) doit être renseignée et correspondre à la date de paiement.
        Date d’échéance actuelle : <xsl:text/>
                  <xsl:value-of select="$dueDate"/>
                  <xsl:text/>.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-10BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-10 — Vérification de la présence du schéma d’identifiant global (BT-29 et équivalents) et unicité du schemeID</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"
                 priority="1009"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_BT-29-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-29 : Si l’identifiant global du vendeur (BT-29) est renseigné, alors son schéma (BT-29-1) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_BT-29-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-29 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé du vendeur (BT-29).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"
                 priority="1008"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_BT-46-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-46 : Si l’identifiant global de l'acheteur (BT-46) est renseigné, alors son schéma (BT-46-1) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_BT-46-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-46 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé de l'acheteur (BT-46).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty"
                 priority="1007"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_BT-60-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-60 : Si l’identifiant global du bénéficiaire (BT-60) est renseigné, alors son schéma (BT-60-1) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_BT-60-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-60 : Chaque schemeID ne peut apparaître qu’une seule fois dans l'identifiant privé du bénéficiaire (BT-60).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty"
                 priority="1006"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-06-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-06 : Si l’identifiant global de l'agent d'acheteur (EXT-FR-FE-06) est renseigné, alors son schéma (EXT-FR-FE-07) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-06-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-06 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé de l'agent d'acheteur (EXT-FR-FE-06).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty"
                 priority="1005"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-46-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-46 : Si l’identifiant global du payeur (EXT-FR-FE-46) est renseigné, alors son schéma (EXT-FR-FE-47) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-46-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-46 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du payeur (EXT-FR-FE-46).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty"
                 priority="1004"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-69-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
          BR-FR-CO-10/EXT-FR-FE-69 : Si l’identifiant global de l'agent du vendeur (EXT-FR-FE-69) est renseigné, alors son schéma (EXT-FR-FE-70) doit également être renseigné.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-69-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
          BR-FR-CO-10/EXT-FR-FE-69 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé de l'agent du vendeur (EXT-FR-FE-69).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty"
                 priority="1003"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-92-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-92 : Si l’identifiant global du facturé à (EXT-FR-FE-92) est renseigné, alors son schéma (EXT-FR-FE-92-1) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-92-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-92 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du facturé à (EXT-FR-FE-92).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty"
                 priority="1002"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-115-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-115 : Si l’identifiant global du facturant (EXT-FR-FE-115) est renseigné, alors son schéma (EXT-FR-FE-116) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-115-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-115 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du facturant (EXT-FR-FE-115).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty"
                 priority="1001"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_BT-71-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-71 : Si l’identifiant global du livré à (BT-71) est renseigné, alors son schéma (BT-71-1) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_BT-71-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/BT-71 : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du livré à (BT-71).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $id in ram:GlobalID satisfies $id/@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $id in ram:GlobalID satisfies $id/@schemeID">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-146-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-146 : Si l’identifiant global du livré à à la ligne (EXT-FR-FE-146 ) est renseigné, alors son schéma (EXT-FR-FE-147) doit également être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(ram:GlobalID/@schemeID)) = count(ram:GlobalID/@schemeID)">
               <xsl:attribute name="id">BR-FR-CO-10_EXT-FR-FE-146-2</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-10/EXT-FR-FE-146  : Chaque schemeID ne peut apparaître qu’une seule fois ans l'identifiant privé du livré à à la ligne (EXT-FR-FE-146 ).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-12BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-12 — Contrôle des devises et du montant de TVA en comptabilité si la facture n’est pas en EUR</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="invoiceCurrency"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
      <xsl:variable name="accountingCurrency"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode"/>
      <xsl:variable name="taxAmountEUR"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceCurrency != 'EUR') or          ($accountingCurrency = 'EUR' and string($taxAmountEUR))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceCurrency != 'EUR') or ($accountingCurrency = 'EUR' and string($taxAmountEUR))">
               <xsl:attribute name="id">BR-FR-CO-12_BT-5</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-12/BT-5 : Si la devise de facture (BT-5) est différente de EUR, alors :
        - la devise de comptabilité (BT-6) doit être présente et égale à EUR,
        - le montant de TVA en devise de comptabilité (BT-111) doit être renseigné,
        - et sa devise (BT-111-1) doit être égale à EUR.
        Valeurs actuelles : BT-5="<xsl:text/>
                  <xsl:value-of select="$invoiceCurrency"/>
                  <xsl:text/>", BT-6="<xsl:text/>
                  <xsl:value-of select="$accountingCurrency"/>
                  <xsl:text/>", BT-111="<xsl:text/>
                  <xsl:value-of select="$taxAmountEUR"/>
                  <xsl:text/>"/&gt;".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-14BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-14 — Vérification de la note TXD pour les vendeurs membres d’un assujetti unique</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="isAU"
                    select="exists(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID[@schemeID = '0231'])"/>
      <xsl:variable name="hasTXDNote"
                    select="exists(rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode = 'TXD' and ram:Content = 'MEMBRE_ASSUJETTI_UNIQUE'])"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isAU) or $hasTXDNote"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isAU) or $hasTXDNote">
               <xsl:attribute name="id">BR-FR-CO-14_BT-29-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-14/BT-29-1 : Si le schéma d’identification du vendeur (BT-29-1) est '0231', cela signifie qu’il est membre d’un assujetti unique.
        Dans ce cas, une note (BG-1) avec le code sujet 'TXD' (BT-21) et le texte 'MEMBRE_ASSUJETTI_UNIQUE' (BT-22) doit être présente.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <!--PATTERN BR-FR-CO-15BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-CO-15 — Présence du représentant fiscal si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice" priority="1000" mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice"/>
      <xsl:variable name="isAU"
                    select="some $id in ./rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID satisfies $id/@schemeID = '0231'"/>
      <xsl:variable name="fiscalRep"
                    select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty"/>
      <xsl:variable name="fiscalVAT"
                    select="$fiscalRep/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isAU) or (exists($fiscalRep) and string($fiscalVAT))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isAU) or (exists($fiscalRep) and string($fiscalVAT))">
               <xsl:attribute name="id">BR-FR-CO-15_BT-29-1</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-CO-15/BT-29-1 : Si le vendeur est membre d’un assujetti unique (BT-29-1 = 0231), alors le bloc représentant fiscal (BG-11) doit être présent et contenir le numéro de TVA de l’assujetti unique (BT-63).
        État actuel : représentant fiscal <xsl:text/>
                  <xsl:value-of select="if (exists($fiscalRep)) then 'présent' else 'absent'"/>
                  <xsl:text/>, numéro de TVA = "<xsl:text/>
                  <xsl:value-of select="$fiscalVAT"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <!--PATTERN BR-FR-DEC-01BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-DEC-01 — Format des montants numériques (max 19 caractères, 2 décimales, séparateur « . »)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount"
                 priority="1016"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-92_BT-99</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-92/BT-99 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount"
                 priority="1015"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-93_BT-100</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-93 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount"
                 priority="1014"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-106</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-106 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount"
                 priority="1013"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-107</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-107 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount"
                 priority="1012"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-108</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-108 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount"
                 priority="1011"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-109</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-109 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount"
                 priority="1010"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-110</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-110 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount"
                 priority="1009"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2(normalize-space(.))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2(normalize-space(.))">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-111</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-DEC-01/BT-111 : Le montant « &lt;value-of select="."/&gt; » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount"
                 priority="1008"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-112</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-112 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount"
                 priority="1007"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-113</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-113 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount"
                 priority="1006"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-114</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-114 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount"
                 priority="1005"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-115</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-115 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount"
                 priority="1004"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-116</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-116 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount"
                 priority="1003"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-117</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-117 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"
                 priority="1002"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-131</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-131 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount"
                 priority="1001"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ActualAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-136_BT-141</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-136 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:BasisAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-2($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-2($amount)">
               <xsl:attribute name="id">BR-FR-DEC-01_BT-137_BT-142</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-01/BT-137 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit comporter au plus 2 décimales, être exprimé avec un point comme séparateur, et ne pas dépasser 19 caractères (hors séparateur). Le signe « - » est autorisé. Veuillez corriger ce montant.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--PATTERN BR-FR-DEC-02BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-DEC-02 — Format des quantités numériques (max 19 caractères, 4 décimales, séparateur « . »)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity"
                 priority="1001"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity"/>
      <xsl:variable name="quantity" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-4($quantity)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-4($quantity)">
               <xsl:attribute name="id">BR-FR-DEC-02_BT-129</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-02/BT-129 : La quantité « <xsl:text/>
                  <xsl:value-of select="$quantity"/>
                  <xsl:text/> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity"
                 priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity"/>
      <xsl:variable name="quantity" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-4($quantity)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-4($quantity)">
               <xsl:attribute name="id">BR-FR-DEC-02_BT-149</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-02/BT-149 : La quantité « <xsl:text/>
                  <xsl:value-of select="$quantity"/>
                  <xsl:text/> » est invalide. Elle doit :
        - être un nombre avec au plus 4 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur),
        - et peut commencer par un signe « - ».
        Veuillez corriger cette quantité pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <!--PATTERN BR-FR-DEC-03BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-DEC-03 — Format des montants positifs (max 19 caractères, 6 décimales, séparateur « . »)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount"
                 priority="1002"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-6-positive($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-6-positive($amount)">
               <xsl:attribute name="id">BR-FR-DEC-03_BT-146</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-03/BT-146 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount"
                 priority="1001"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-6-positive($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-6-positive($amount)">
               <xsl:attribute name="id">BR-FR-DEC-03_BT-147</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-03/BT-147 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount"/>
      <xsl:variable name="amount" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-decimal-19-6-positive($amount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-decimal-19-6-positive($amount)">
               <xsl:attribute name="id">BR-FR-DEC-03_BT-148</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-03/BT-148 : Le montant « <xsl:text/>
                  <xsl:value-of select="$amount"/>
                  <xsl:text/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 6 décimales (séparateur « . »),
        - contenir au maximum 19 caractères (hors séparateur).
        Veuillez corriger ce montant pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <!--PATTERN BR-FR-DEC-04BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-DEC-04 — Format des taux de TVA (max 4 caractères, 2 décimales, séparateur « . »)</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent"
                 priority="1002"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:CategoryTradeTax/ram:RateApplicablePercent"/>
      <xsl:variable name="rate" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-percent-4-2-positive($rate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-percent-4-2-positive($rate)">
               <xsl:attribute name="id">BR-FR-DEC-04_BT-96_BT-103</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-04/BT-96 ou BT-103 : Le taux de TVA « <xsl:text/>
                  <xsl:value-of select="$rate"/>
                  <xsl:text/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent"
                 priority="1001"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent"/>
      <xsl:variable name="rate" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-percent-4-2-positive($rate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-percent-4-2-positive($rate)">
               <xsl:attribute name="id">BR-FR-DEC-04_BT-119</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-04/BT-119 : Le taux de TVA « <xsl:text/>
                  <xsl:value-of select="$rate"/>
                  <xsl:text/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent"
                 priority="1000"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent"/>
      <xsl:variable name="rate" select="normalize-space(.)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="custom:is-valid-percent-4-2-positive($rate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="custom:is-valid-percent-4-2-positive($rate)">
               <xsl:attribute name="id">BR-FR-DEC-04_BT-152</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-DEC-04/BT-152 : Le taux de TVA « <xsl:text/>
                  <xsl:value-of select="$rate"/>
                  <xsl:text/> » est invalide. Il doit :
        - être un nombre strictement positif (sans signe « - »),
        - comporter au plus 2 décimales (séparateur « . »),
        - contenir au maximum 4 caractères (hors séparateur).
        Veuillez corriger ce taux pour respecter le format requis.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-01BR-FR-MV-01 — Vérification du sous-type de ligne lorsque le cadre de facturation est S8, B8 ou M8-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-01 — Vérification du sous-type de ligne lorsque le cadre de facturation est S8, B8 ou M8</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode"
                 priority="1000"
                 mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or (normalize-space(.) != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(.) != '')">
               <xsl:attribute name="id">BR-FR-MV-01_EXT-FR-FE-163</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-01/EXT-FR-FE-163 : Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, chaque ligne (BG-25) doit contenir un sous-type de ligne (ram:LineStatusReasonCode). Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>".
        Veuillez vérifier que le sous-type est renseigné, Veuillez vérifier que le sous-type est renseigné pour toutes les lignes.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-02BR-FR-MV-02 — Vérification de la présence d'une ligne GROUP sans parent lorsque le cadre de facturation est S8, B8 ou M8-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-02 — Vérification de la présence d'une ligne GROUP sans parent lorsque le cadre de facturation est S8, B8 ou M8</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction"
                 priority="1000"
                 mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (count(ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]) &gt;= 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (count(ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]) &gt;= 1)">
               <xsl:attribute name="id">BR-FR-MV-02_EXT-FR-FE-163</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-02/EXT-FR-FE-163 : Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, la facture doit contenir au moins une ligne (BG-25) avec le sous-type de ligne (ram:LineStatusReasonCode) égal à "GROUP" et sans identifiant de ligne parent (ram:ParentLineID).
        Veuillez vérifier que cette ligne est présente.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-03BR-FR-MV-03 — Vérification des données obligatoires pour les lignes GROUP sans parent lorsque le cadre de facturation est S8, B8 ou M8-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-03 — Vérification des données obligatoires pour les lignes GROUP sans parent lorsque le cadre de facturation est S8, B8 ou M8</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"
                 priority="1002"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:Name) != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:Name) != '')">
               <xsl:attribute name="id">BR-FR-MV-03_EXT-FR-FE-164</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> BR-FR-MV-03/EXT-FR-FE-164 : 
        Ligne : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/> : Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:Name"/>
                  <xsl:text/>".
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8 et que la ligne est de type GROUP sans parent, le nom du vendeur (ram:Name) doit être renseigné. 
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID) != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID) != '')">
               <xsl:attribute name="id">BR-FR-MV-03_EXT-FR-FE-167</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> BR-FR-MV-03/EXT-FR-FE-167 : 
        Ligne : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/> : Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
                  <xsl:text/>".
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8 et que la ligne est de type GROUP sans parent, l'identifiant du vendeur (ram:ID) doit être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:CountryID) != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:CountryID) != '')">
               <xsl:attribute name="id">BR-FR-MV-03_EXT-FR-FE-177</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> BR-FR-MV-03/EXT-FR-FE-177 : 
        Ligne : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/> : Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:CountryID"/>
                  <xsl:text/>'.
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8 et que la ligne est de type GROUP sans parent, le code pays du vendeur (ram:CountryID) doit être renseigné.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="invcurrency"
                    select="../ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]) != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]) != '')">
               <xsl:attribute name="id">BR-FR-MV-03_EXT-FR-FE-181</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BR-FR-MV-03/EXT-FR-FE-181 : 
        Ligne : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]"/>
                  <xsl:text/>".
        Pour une ligne GROUP sans parent, le montant total avec TVA (ram:TaxTotalAmount) doit être renseigné en devise de facture.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="acccurrency"
                    select="../ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or not($acccurrency) or ($acccurrency != '' and normalize-space(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $acccurrency]) != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or not($acccurrency) or ($acccurrency != '' and normalize-space(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $acccurrency]) != '')">
               <xsl:attribute name="id">BR-FR-MV-03_EXT-FR-FE-182</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> BR-FR-MV-03/EXT-FR-FE-182 : 
        Ligne : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, Devise de comptabilité : "<xsl:text/>
                  <xsl:value-of select="$acccurrency"/>
                  <xsl:text/>", TVA en ligne : "<xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $acccurrency]"/>
                  <xsl:text/>".
        Pour une ligne GROUP sans parent, le montant total avec TVA (ram:TaxTotalAmount) doit être renseigné en devise de comptabilisation (BT-6) si elle est renseignée.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode = 'AFL']"
                 priority="1001"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode = 'AFL']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or ((./ram:TypeCode = '130') and (normalize-space(./ram:IssuerAssignedID) != ''))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or ((./ram:TypeCode = '130') and (normalize-space(./ram:IssuerAssignedID) != ''))">
               <xsl:attribute name="id">BR-FR-MV-03_BT-128_AFL</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-03/BT-128 : Pour une ligne GROUP sans parent, une valeur d'objet facturé (ram:IssuerAssignedID) avec identifiant de schéma (ram:ReferenceTypeCode) = AFL doit être présente. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="./ram:IssuerAssignedID"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'        and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode = 'AVV']"
                 priority="1000"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'        and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[ram:ReferenceTypeCode = 'AVV']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or ((./ram:TypeCode = '130') and (normalize-space(./ram:IssuerAssignedID) != '') and not(./ram:IssuerAssignedID = 'M8' or ./ram:IssuerAssignedID = 'S8' or ./ram:IssuerAssignedID = 'B8'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or ((./ram:TypeCode = '130') and (normalize-space(./ram:IssuerAssignedID) != '') and not(./ram:IssuerAssignedID = 'M8' or ./ram:IssuerAssignedID = 'S8' or ./ram:IssuerAssignedID = 'B8'))">
               <xsl:attribute name="id">BR-FR-MV-03_BT-128_AVV</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-03/BT-128 : Pour une ligne GROUP sans parent, une valeur d'objet facturé (BT-128 : ram:IssuerAssignedID) avec identifiant de schéma (BT-128-1 : ram:ReferenceTypeCode) = AVV doit être présente et différente de M8/S8/B8. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:IssuerAssignedID"/>
                  <xsl:text/>".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-05BR-FR-MV-05 — Vérification de la cohérence des totaux HT entre la ligne GROUP et ses lignes enfants-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-05 — Vérification de la cohérence des totaux HT entre la ligne GROUP et ses lignes enfants</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"
                 priority="1000"
                 mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"/>
      <xsl:variable name="grouplineID"
                    select="normalize-space(./ram:AssociatedDocumentLineDocument/ram:LineID)"/>
      <xsl:variable name="sumsubline"
                    select="sum(../ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID= $grouplineID and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode != 'INFORMATION']         /ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)"/>
      <xsl:variable name="numberline"
                    select="count(../ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID= $grouplineID  and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode != 'INFORMATION']         /ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or (abs(number(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) - $sumsubline) &lt;= 0.01 * $numberline)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (abs(number(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) - $sumsubline) &lt;= 0.01 * $numberline)">
               <xsl:attribute name="id">BR-FR-MV-05_EXT-FR-FE-BG-12</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-05/EXT-FR-FE-BG-12 : Ligne GROUP : <xsl:text/>
                  <xsl:value-of select="$grouplineID"/>
                  <xsl:text/>, Somme Sous lignes : <xsl:text/>
                  <xsl:value-of select="$sumsubline"/>
                  <xsl:text/>, Nbre sous-lignes: <xsl:text/>
                  <xsl:value-of select="$numberline"/>
                  <xsl:text/>. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"/>
                  <xsl:text/>". 
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, le total HT (BT-131 : ram:LineTotalAmount) de la ligne GROUP doit être égal (tolérance ±0,01 * nombre de sous-lignes) à la somme des totaux HT des lignes enfants dont le ParentLineID correspond à l'identifiant de la ligne GROUP (ram:LineID).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-06BR-FR-MV-06 — Vérification de la cohérence de l'identifiant légal du vendeur entre une ligne et sa ligne parent-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-06 — Vérification de la cohérence de l'identifiant légal du vendeur entre une ligne et sa ligne parent</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"
                 priority="1000"
                 mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"/>
      <xsl:variable name="parentlineID"
                    select="./ram:AssociatedDocumentLineDocument/ram:ParentLineID"/>
      <xsl:variable name="legalID"
                    select="normalize-space(./ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)"/>
      <xsl:variable name="legalIDParent"
                    select="normalize-space(../ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineID = $parentlineID]/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or ($legalID != '' and (not($parentlineID) or $legalID = $legalIDParent))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or ($legalID != '' and (not($parentlineID) or $legalID = $legalIDParent))">
               <xsl:attribute name="id">BR-FR-MV-06_EXT-FR-FE-167</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-06/EXT-FR-FE-167 : IDligne <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, ID parent ligne <xsl:text/>
                  <xsl:value-of select="$parentlineID"/>
                  <xsl:text/>, legalID : <xsl:text/>
                  <xsl:value-of select="$legalID"/>
                  <xsl:text/>, ParentlegalID : <xsl:text/>
                  <xsl:value-of select="$legalIDParent"/>
                  <xsl:text/>.
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, chaque ligne (BG-25) doit contenir un identifiant légal de vendeur (ram:ID). Si la ligne a un identifiant de ligne parent (ram:ParentLineID), cet identifiant doit être identique à celui de la ligne parent.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-07BR-FR-MV-07 — Vérification de la cohérence du numéro de facture codifié AFL entre une ligne et sa ligne parent-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-07 — Vérification de la cohérence du numéro de facture codifié AFL entre une ligne et sa ligne parent</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"
                 priority="1000"
                 mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"/>
      <xsl:variable name="parentlineID"
                    select="./ram:AssociatedDocumentLineDocument/ram:ParentLineID"/>
      <xsl:variable name="numfact"
                    select="normalize-space(./ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')]/ram:IssuerAssignedID)"/>
      <xsl:variable name="numfactparent"
                    select="normalize-space(../ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineID = $parentlineID]/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')]/ram:IssuerAssignedID)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or ($numfact != '' and (not($parentlineID) or $numfact = $numfactparent))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or ($numfact != '' and (not($parentlineID) or $numfact = $numfactparent))">
               <xsl:attribute name="id">BR-FR-MV-07_BT-128</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-07/BT-128 : IDligne <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, ID parent ligne <xsl:text/>
                  <xsl:value-of select="$parentlineID"/>
                  <xsl:text/>, numfact en ligne <xsl:text/>
                  <xsl:value-of select="$numfact"/>
                  <xsl:text/>, numfact ligne parent : <xsl:text/>
                  <xsl:value-of select="$numfactparent"/>
                  <xsl:text/>. 
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, chaque ligne (BG-25) doit contenir un numéro de facture codifié AFL (ram:IssuerAssignedID). Si la ligne a un identifiant de ligne parent (ram:ParentLineID), ce numéro doit être identique à celui de la ligne parent.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-08BR-FR-MV-08 — Vérification de la raison d'exemption TVA contenant le numéro de sous-facture en ligne entre #-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-08 — Vérification de la raison d'exemption TVA contenant le numéro de sous-facture en ligne entre #</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']"
                 priority="1000"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']"/>
      <xsl:variable name="numfact"
                    select="normalize-space(./ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')]/ram:IssuerAssignedID)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))         or (normalize-space(./ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) != '' and $numfact != '' and starts-with(./ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason, concat('#', $numfact, '#')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(./ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) != '' and $numfact != '' and starts-with(./ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason, concat('#', $numfact, '#')))">
               <xsl:attribute name="id">BR-FR-MV-08_BT-128</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-08/BT-128 : IDligne <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, Raison exemption : <xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason"/>
                  <xsl:text/> / Num fact ligne: <xsl:text/>
                  <xsl:value-of select="$numfact"/>
                  <xsl:text/>. Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, chaque ligne (BG-25) doit contenir une raison d'exemption TVA en texte commençant par le numéro de sous-facture en ligne entre #.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-09BR-FR-MV-09 — Vérification de la cohérence du montant total TVA pour une ligne GROUP avec la somme des ventilations TVA liées-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-09 — Vérification de la cohérence du montant total TVA pour une ligne GROUP avec la somme des ventilations TVA liées</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"
                 priority="1000"
                 mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[       ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"/>
      <xsl:variable name="numfact"
                    select="normalize-space(./ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')]/ram:IssuerAssignedID)"/>
      <xsl:variable name="sumvat"
                    select="sum(../ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[(ram:TypeCode = 'VAT') and starts-with(ram:ExemptionReason,concat('#',$numfact,'#'))]/ram:CalculatedAmount)"/>
      <xsl:variable name="invcurrency"
                    select="../ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or (abs(number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]) - $sumvat) &lt;= 0.01)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (abs(number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]) - $sumvat) &lt;= 0.01)">
               <xsl:attribute name="id">BR-FR-MV-09_EXT-FR-FE-181</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-09/EXT-FR-FE-181 : Id Line Group : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, Numfact: <xsl:text/>
                  <xsl:value-of select="$numfact"/>
                  <xsl:text/>, Total TVA : <xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]"/>
                  <xsl:text/>, Somme TVA : <xsl:text/>
                  <xsl:value-of select="$sumvat"/>
                  <xsl:text/>. 
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, le montant total TVA de la ligne GROUP (EXT-FR-FE-181) doit être égal  à la somme des montants de TVA des ventilations TVA (BT-117) dont la raison d'exemption (ram:ExemptionReason) commence par le numéro de facture en ligne (BT-128 avec ReferenceTypeCode = AFL) entre #.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-10BR-FR-MV-10 — Vérification de la cohérence du montant total avec TVA pour une ligne GROUP-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-10 — Vérification de la cohérence du montant total avec TVA pour une ligne GROUP</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"
                 priority="1000"
                 mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'       and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"/>
      <xsl:variable name="invcurrency"
                    select="../ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
      <xsl:variable name="parentlineID"
                    select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
      <xsl:variable name="nbligne"
                    select="count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID = $parentlineID and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL'])"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or not(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount)         or (normalize-space(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount) != ''          and abs(number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount)          - number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)          - number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency])) &lt;= 0.01 * $nbligne)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or not(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount) or (normalize-space(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount) != '' and abs(number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount) - number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) - number(./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency])) &lt;= 0.01 * $nbligne)">
               <xsl:attribute name="id">BR-FR-MV-10_EXT-FR-FE-184</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-10/EXT-FR-FE-184 : Id Line Group : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>, nb sous-ligne : <xsl:text/>
                  <xsl:value-of select="$nbligne"/>
                  <xsl:text/>, 
        TTC : <xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount"/>
                  <xsl:text/>,
        TVA : <xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID = $invcurrency]"/>
                  <xsl:text/>,
        HT : <xsl:text/>
                  <xsl:value-of select="./ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"/>
                  <xsl:text/>
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, si le montant total avec TVA (ram:GrandTotalAmount) est présent pour une ligne GROUP sans parent, alors la différence entre ce montant et la somme du montant HT (ram:LineTotalAmount) et du montant TVA (ram:TaxTotalAmount) doit être inférieure ou égale à 0,01 × le nombre de sous-lignes DETAIL. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-11BR-FR-MV-11 — Vérification de la cohérence entre l'identifiant de facture à la ligne (AFL) et le numéro de facture (BT-1) pour le Vendeur principal-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-11 — Vérification de la cohérence entre l'identifiant de facture à la ligne (AFL) et le numéro de facture (BT-1) pour le Vendeur principal</svrl:text>
   <xsl:variable name="sellerID"
                 select="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
   <xsl:variable name="invID"
                 select="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID"/>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID = $sellerID       and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"
                 priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID = $sellerID       and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]"/>
      <xsl:variable name="lineinvID"
                    select="./ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')]/ram:IssuerAssignedID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or $lineinvID = $invID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or $lineinvID = $invID">
               <xsl:attribute name="id">BR-FR-MV-11_BT-128</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-11/BT-128 : ID Seller : <xsl:text/>
                  <xsl:value-of select="$sellerID"/>
                  <xsl:text/>, NB ligne GROUP seller : <xsl:text/>
                  <xsl:value-of select="./ram:AssociatedDocumentLineDocument/ram:LineID"/>
                  <xsl:text/>
        Numero de facture (BT-1) : <xsl:text/>
                  <xsl:value-of select="$invID"/>
                  <xsl:text/>, num fact en ligne <xsl:text/>
                  <xsl:value-of select="$lineinvID"/>
                  <xsl:text/>. 
        Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8 et que le vendeur principal (BG-4) dispose d'un groupe de lignes, l'identifiant de facture à la ligne (ram:IssuerAssignedID avec ReferenceTypeCode = AFL) doit être identique au numéro de facture (ram:ID dans ExchangedDocument).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-12BR-FR-MV-12 — Vérification de l'unicité des numéros de facture AFL pour les lignes GROUP sans parent-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-12 — Vérification de l'unicité des numéros de facture AFL pour les lignes GROUP sans parent</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or not(ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)]         /ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')]         /ram:IssuerAssignedID[. = preceding::ram:IssuerAssignedID])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or not(ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and not(ram:AssociatedDocumentLineDocument/ram:ParentLineID)] /ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument[(ram:ReferenceTypeCode = 'AFL') and (ram:TypeCode = '130')] /ram:IssuerAssignedID[. = preceding::ram:IssuerAssignedID])">
               <xsl:attribute name="id">BR-FR-MV-12_BT-128</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-12/BT-128 : Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, les numéros de facture à la ligne (ram:IssuerAssignedID avec ReferenceTypeCode = AFL) pour les lignes GROUP sans parent doivent être uniques. Veuillez vérifier que chaque numéro est distinct.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <!--PATTERN BR-FR-MV-13BR-FR-MV-13 — Vérification que le code type de facture (BT-3) n'est pas un type auto-facturé interdit-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BR-FR-MV-13 — Vérification que le code type de facture (BT-3) n'est pas un type auto-facturé interdit</svrl:text>
   <!--RULE -->
   <xsl:template match="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode"
                 priority="1000"
                 mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice))          or (normalize-space(.) != ''          and not(. = '389' or . = '261' or . = '501' or . = '500' or . = '502' or . = '471' or . = '473'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(custom:isSpecialContract(/rsm:CrossIndustryInvoice)) or (normalize-space(.) != '' and not(. = '389' or . = '261' or . = '501' or . = '500' or . = '502' or . = '471' or . = '473'))">
               <xsl:attribute name="id">BR-FR-MV-13_BT-3</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BR-FR-MV-13/BT-3 : Lorsque le cadre de facturation (BT-23) est S8, B8 ou M8, le code type de facture (ram:TypeCode) ne doit pas être l'un des types auto-facturés suivants : 389, 261, 501, 500, 502, 471, 473. Valeur actuelle : "<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
</xsl:stylesheet>
