<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.EAS">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='0002'"><xsl:value-of select="$myparam"/> (System Information et Repertoire des Entreprise et des Etablissements: SIRENE)</xsl:when>
      		<xsl:when test="$myparam.upper='0007'"><xsl:value-of select="$myparam"/> (Organisationsnumme)</xsl:when>
      		<xsl:when test="$myparam.upper='0009'"><xsl:value-of select="$myparam"/> (SIRET-CODE)</xsl:when>
      		<xsl:when test="$myparam.upper='0037'"><xsl:value-of select="$myparam"/> (LY-tunnus)</xsl:when>
      		<xsl:when test="$myparam.upper='0060'"><xsl:value-of select="$myparam"/> (Data Universal Numbering System (D-U-N-S Number))</xsl:when>
      		<xsl:when test="$myparam.upper='0088'"><xsl:value-of select="$myparam"/> (EAN Location Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0096'"><xsl:value-of select="$myparam"/> (DANISH CHAMBER OF COMMERCE Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0097'"><xsl:value-of select="$myparam"/> (FTI - Ediforum Italia, (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0106'"><xsl:value-of select="$myparam"/> (Vereniging van Kamers van Koophandel en Fabrieken in Nederland (Association of Chambers of Commerce and Industry in the Netherlands), Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0130'"><xsl:value-of select="$myparam"/> (Directorates of the European Commission)</xsl:when>
      		<xsl:when test="$myparam.upper='0135'"><xsl:value-of select="$myparam"/> (SIA Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0142'"><xsl:value-of select="$myparam"/> (SECETI Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0151'"><xsl:value-of select="$myparam"/> (Australian Business Number (ABN) Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0183'"><xsl:value-of select="$myparam"/> (Numéro d'identification suisse des enterprises (IDE), Swiss Unique Business Identification Number (UIDB))</xsl:when>
      		<xsl:when test="$myparam.upper='0184'"><xsl:value-of select="$myparam"/> (DIGSTORG)</xsl:when>
      		<xsl:when test="$myparam.upper='0190'"><xsl:value-of select="$myparam"/> (Dutch Originator's Identification Number)</xsl:when>
      		<xsl:when test="$myparam.upper='0191'"><xsl:value-of select="$myparam"/> (Centre of Registers and Information Systems of the Ministry of Justice)</xsl:when>
      		<xsl:when test="$myparam.upper='0192'"><xsl:value-of select="$myparam"/> (Enhetsregisteret ved Bronnoysundregisterne)</xsl:when>
      		<xsl:when test="$myparam.upper='0193'"><xsl:value-of select="$myparam"/> (UBL.BE party identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0195'"><xsl:value-of select="$myparam"/> (Singapore UEN identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0196'"><xsl:value-of select="$myparam"/> (Kennitala - Iceland legal id for individuals and legal entities)</xsl:when>
      		<xsl:when test="$myparam.upper='0198'"><xsl:value-of select="$myparam"/> (ERSTORG)</xsl:when>
      		<xsl:when test="$myparam.upper='0199'"><xsl:value-of select="$myparam"/> (Legal Entity Identifier (LEI))</xsl:when>
      		<xsl:when test="$myparam.upper='0200'"><xsl:value-of select="$myparam"/> (Legal entity code (Lithuania))</xsl:when>
      		<xsl:when test="$myparam.upper='0201'"><xsl:value-of select="$myparam"/> (Codice Univoco Unità Organizzativa iPA)</xsl:when>
      		<xsl:when test="$myparam.upper='0202'"><xsl:value-of select="$myparam"/> (Indirizzo di Posta Elettronica Certificata)</xsl:when>
      		<xsl:when test="$myparam.upper='0203'"><xsl:value-of select="$myparam"/> (eDelivery Network Participant identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0204'"><xsl:value-of select="$myparam"/> (Leitweg-ID)</xsl:when>
      		<xsl:when test="$myparam.upper='9901'"><xsl:value-of select="$myparam"/> (Danish Ministry of the Interior and Health)</xsl:when>
      		<xsl:when test="$myparam.upper='9902'"><xsl:value-of select="$myparam"/> (The Danish Commerce and Companies Agency)</xsl:when>
      		<xsl:when test="$myparam.upper='9904'"><xsl:value-of select="$myparam"/> (Danish Ministry of Taxation, Central Customs and Tax Administration)</xsl:when>
      		<xsl:when test="$myparam.upper='9905'"><xsl:value-of select="$myparam"/> (Danish VANS providers)</xsl:when>
      		<xsl:when test="$myparam.upper='9906'"><xsl:value-of select="$myparam"/> (Ufficio responsabile gestione partite IVA)</xsl:when>
      		<xsl:when test="$myparam.upper='9907'"><xsl:value-of select="$myparam"/> (TAX Authority)</xsl:when>
      		<xsl:when test="$myparam.upper='9910'"><xsl:value-of select="$myparam"/> (Hungary VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9913'"><xsl:value-of select="$myparam"/> (Business Registers Network)</xsl:when>
      		<xsl:when test="$myparam.upper='9914'"><xsl:value-of select="$myparam"/> (Österreichische Umsatzsteuer-Identifikationsnummer)</xsl:when>
      		<xsl:when test="$myparam.upper='9915'"><xsl:value-of select="$myparam"/> (Österreichisches Verwaltungs bzw. Organisationskennzeichen)</xsl:when>
      		<xsl:when test="$myparam.upper='9917'"><xsl:value-of select="$myparam"/> (Kennitala - Iceland legal id for organizations and individuals)</xsl:when>
      		<xsl:when test="$myparam.upper='9918'"><xsl:value-of select="$myparam"/> (SOCIETY FOR WORLDWIDE INTERBANK FINANCIAL, TELECOMMUNICATION S.W.I.F.T)</xsl:when>
      		<xsl:when test="$myparam.upper='9919'"><xsl:value-of select="$myparam"/> (Kennziffer des Unternehmensregisters)</xsl:when>
      		<xsl:when test="$myparam.upper='9920'"><xsl:value-of select="$myparam"/> (Agencia Española de Administración Tributaria)</xsl:when>
      		<xsl:when test="$myparam.upper='9921'"><xsl:value-of select="$myparam"/> (Indice delle Pubbliche Amministrazioni)</xsl:when>
      		<xsl:when test="$myparam.upper='9922'"><xsl:value-of select="$myparam"/> (Andorra VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9923'"><xsl:value-of select="$myparam"/> (Albania VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9924'"><xsl:value-of select="$myparam"/> (Bosnia and Herzegovina VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9925'"><xsl:value-of select="$myparam"/> (Belgium VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9926'"><xsl:value-of select="$myparam"/> (Bulgaria VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9927'"><xsl:value-of select="$myparam"/> (Switzerland VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9928'"><xsl:value-of select="$myparam"/> (Cyprus VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9929'"><xsl:value-of select="$myparam"/> (Czech Republic VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9930'"><xsl:value-of select="$myparam"/> (Germany VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9931'"><xsl:value-of select="$myparam"/> (Estonia VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9932'"><xsl:value-of select="$myparam"/> (United Kingdom VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9933'"><xsl:value-of select="$myparam"/> (Greece VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9934'"><xsl:value-of select="$myparam"/> (Croatia VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9935'"><xsl:value-of select="$myparam"/> (Ireland VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9936'"><xsl:value-of select="$myparam"/> (Liechtenstein VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9937'"><xsl:value-of select="$myparam"/> (Lithuania VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9938'"><xsl:value-of select="$myparam"/> (Luxemburg VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9939'"><xsl:value-of select="$myparam"/> (Latvia VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9940'"><xsl:value-of select="$myparam"/> (Monaco VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9941'"><xsl:value-of select="$myparam"/> (Montenegro VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9942'"><xsl:value-of select="$myparam"/> (Macedonia, the former Yugoslav Republic of VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9943'"><xsl:value-of select="$myparam"/> (Malta VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9944'"><xsl:value-of select="$myparam"/> (Netherlands VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9945'"><xsl:value-of select="$myparam"/> (Poland VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9946'"><xsl:value-of select="$myparam"/> (Portugal VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9947'"><xsl:value-of select="$myparam"/> (Romania VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9948'"><xsl:value-of select="$myparam"/> (Serbia VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9949'"><xsl:value-of select="$myparam"/> (Slovenia VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9950'"><xsl:value-of select="$myparam"/> (Slovakia VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9951'"><xsl:value-of select="$myparam"/> (San Marino VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9952'"><xsl:value-of select="$myparam"/> (Turkey VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9953'"><xsl:value-of select="$myparam"/> (Holy See (Vatican City State) VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9955'"><xsl:value-of select="$myparam"/> (Swedish VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9956'"><xsl:value-of select="$myparam"/> (Belgian Crossroad Bank of Enterprises)</xsl:when>
      		<xsl:when test="$myparam.upper='9957'"><xsl:value-of select="$myparam"/> (French VAT number)</xsl:when>
      		<xsl:when test="$myparam.upper='9958'"><xsl:value-of select="$myparam"/> (German Leitweg ID)</xsl:when>
      		<xsl:when test="$myparam.upper='AN'"><xsl:value-of select="$myparam"/> (O.F.T.P. (ODETTE File Transfer Protocol))</xsl:when>
      		<xsl:when test="$myparam.upper='AQ'"><xsl:value-of select="$myparam"/> (X.400 address for mail text)</xsl:when>
      		<xsl:when test="$myparam.upper='AS'"><xsl:value-of select="$myparam"/> (AS2 exchange)</xsl:when>
      		<xsl:when test="$myparam.upper='AU'"><xsl:value-of select="$myparam"/> (File Transfer Protocol)</xsl:when>
      		<xsl:when test="$myparam.upper='EM'"><xsl:value-of select="$myparam"/> (Electronic mail)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>