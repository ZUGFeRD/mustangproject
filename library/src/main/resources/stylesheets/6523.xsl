<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.ICD">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='0002'"><xsl:value-of select="$myparam"/> (System Information et Repertoire des Entreprise et des Etablissements: SIRENE)</xsl:when>
      		<xsl:when test="$myparam.upper='0003'"><xsl:value-of select="$myparam"/> (Codification Numerique des Etablissments Financiers En Belgique)</xsl:when>
      		<xsl:when test="$myparam.upper='0004'"><xsl:value-of select="$myparam"/> (NBS/OSI NETWORK)</xsl:when>
      		<xsl:when test="$myparam.upper='0005'"><xsl:value-of select="$myparam"/> (USA FED GOV OSI NETWORK)</xsl:when>
      		<xsl:when test="$myparam.upper='0006'"><xsl:value-of select="$myparam"/> (USA DOD OSI NETWORK)</xsl:when>
      		<xsl:when test="$myparam.upper='0007'"><xsl:value-of select="$myparam"/> (Organisationsnummer)</xsl:when>
      		<xsl:when test="$myparam.upper='0008'"><xsl:value-of select="$myparam"/> (LE NUMERO NATIONAL)</xsl:when>
      		<xsl:when test="$myparam.upper='0009'"><xsl:value-of select="$myparam"/> (SIRET-CODE)</xsl:when>
      		<xsl:when test="$myparam.upper='0010'"><xsl:value-of select="$myparam"/> (Organizational Identifiers for Structured Names under ISO 9541 Part 2)</xsl:when>
      		<xsl:when test="$myparam.upper='0011'"><xsl:value-of select="$myparam"/> (International Code Designator for the Identification of OSI-based, Amateur Radio Organizations, Network Objects and Application Services.)</xsl:when>
      		<xsl:when test="$myparam.upper='0012'"><xsl:value-of select="$myparam"/> (European Computer Manufacturers Association: ECMA)</xsl:when>
      		<xsl:when test="$myparam.upper='0013'"><xsl:value-of select="$myparam"/> (VSA FTP CODE (FTP = File Transfer Protocol))</xsl:when>
      		<xsl:when test="$myparam.upper='0014'"><xsl:value-of select="$myparam"/> (NIST/OSI Implememts' Workshop)</xsl:when>
      		<xsl:when test="$myparam.upper='0015'"><xsl:value-of select="$myparam"/> (Electronic Data Interchange: EDI)</xsl:when>
      		<xsl:when test="$myparam.upper='0016'"><xsl:value-of select="$myparam"/> (EWOS Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0017'"><xsl:value-of select="$myparam"/> (COMMON LANGUAGE)</xsl:when>
      		<xsl:when test="$myparam.upper='0018'"><xsl:value-of select="$myparam"/> (SNA/OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0019'"><xsl:value-of select="$myparam"/> (Air Transport Industry Services Communications Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0020'"><xsl:value-of select="$myparam"/> (European Laboratory for Particle Physics: CERN)</xsl:when>
      		<xsl:when test="$myparam.upper='0021'"><xsl:value-of select="$myparam"/> (SOCIETY FOR WORLDWIDE INTERBANK FINANCIAL, TELECOMMUNICATION S.W.I.F.T.)</xsl:when>
      		<xsl:when test="$myparam.upper='0022'"><xsl:value-of select="$myparam"/> (OSF Distributed Computing Object Identification)</xsl:when>
      		<xsl:when test="$myparam.upper='0023'"><xsl:value-of select="$myparam"/> (Nordic University and Research Network: NORDUnet)</xsl:when>
      		<xsl:when test="$myparam.upper='0024'"><xsl:value-of select="$myparam"/> (Digital Equipment Corporation: DEC)</xsl:when>
      		<xsl:when test="$myparam.upper='0025'"><xsl:value-of select="$myparam"/> (OSI ASIA-OCEANIA WORKSHOP)</xsl:when>
      		<xsl:when test="$myparam.upper='0026'"><xsl:value-of select="$myparam"/> (NATO ISO 6523 ICDE coding scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0027'"><xsl:value-of select="$myparam"/> (Aeronautical Telecommunications Network (ATN))</xsl:when>
      		<xsl:when test="$myparam.upper='0028'"><xsl:value-of select="$myparam"/> (International Standard ISO 6523)</xsl:when>
      		<xsl:when test="$myparam.upper='0029'"><xsl:value-of select="$myparam"/> (The All-Union Classifier of Enterprises and Organisations)</xsl:when>
      		<xsl:when test="$myparam.upper='0030'"><xsl:value-of select="$myparam"/> (AT&amp;T/OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0031'"><xsl:value-of select="$myparam"/> (EDI Partner Identification Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0032'"><xsl:value-of select="$myparam"/> (Telecom Australia)</xsl:when>
      		<xsl:when test="$myparam.upper='0033'"><xsl:value-of select="$myparam"/> (S G W OSI Internetwork)</xsl:when>
      		<xsl:when test="$myparam.upper='0034'"><xsl:value-of select="$myparam"/> (Reuter Open Address Standard)</xsl:when>
      		<xsl:when test="$myparam.upper='0035'"><xsl:value-of select="$myparam"/> (ISO 6523 - ICD)</xsl:when>
      		<xsl:when test="$myparam.upper='0036'"><xsl:value-of select="$myparam"/> (TeleTrust Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0037'"><xsl:value-of select="$myparam"/> (LY-tunnus)</xsl:when>
      		<xsl:when test="$myparam.upper='0038'"><xsl:value-of select="$myparam"/> (The Australian GOSIP Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0039'"><xsl:value-of select="$myparam"/> (The OZ DOD OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0040'"><xsl:value-of select="$myparam"/> (Unilever Group Companies)</xsl:when>
      		<xsl:when test="$myparam.upper='0041'"><xsl:value-of select="$myparam"/> (Citicorp Global Information Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0042'"><xsl:value-of select="$myparam"/> (DBP Telekom Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0043'"><xsl:value-of select="$myparam"/> (HydroNETT)</xsl:when>
      		<xsl:when test="$myparam.upper='0044'"><xsl:value-of select="$myparam"/> (Thai Industrial Standards Institute (TISI))</xsl:when>
      		<xsl:when test="$myparam.upper='0045'"><xsl:value-of select="$myparam"/> (ICI Company Identification System)</xsl:when>
      		<xsl:when test="$myparam.upper='0046'"><xsl:value-of select="$myparam"/> (FUNLOC)</xsl:when>
      		<xsl:when test="$myparam.upper='0047'"><xsl:value-of select="$myparam"/> (BULL ODI/DSA/UNIX Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0048'"><xsl:value-of select="$myparam"/> (OSINZ)</xsl:when>
      		<xsl:when test="$myparam.upper='0049'"><xsl:value-of select="$myparam"/> (Auckland Area Health)</xsl:when>
      		<xsl:when test="$myparam.upper='0050'"><xsl:value-of select="$myparam"/> (Firmenich)</xsl:when>
      		<xsl:when test="$myparam.upper='0051'"><xsl:value-of select="$myparam"/> (AGFA-DIS)</xsl:when>
      		<xsl:when test="$myparam.upper='0052'"><xsl:value-of select="$myparam"/> (Society of Motion Picture and Television Engineers (SMPTE))</xsl:when>
      		<xsl:when test="$myparam.upper='0053'"><xsl:value-of select="$myparam"/> (Migros_Network M_NETOPZ)</xsl:when>
      		<xsl:when test="$myparam.upper='0054'"><xsl:value-of select="$myparam"/> (ISO6523 - ICDPCR)</xsl:when>
      		<xsl:when test="$myparam.upper='0055'"><xsl:value-of select="$myparam"/> (Energy Net)</xsl:when>
      		<xsl:when test="$myparam.upper='0056'"><xsl:value-of select="$myparam"/> (Nokia Object Identifiers (NOI))</xsl:when>
      		<xsl:when test="$myparam.upper='0057'"><xsl:value-of select="$myparam"/> (Saint Gobain)</xsl:when>
      		<xsl:when test="$myparam.upper='0058'"><xsl:value-of select="$myparam"/> (Siemens Corporate Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0059'"><xsl:value-of select="$myparam"/> (DANZNET)</xsl:when>
      		<xsl:when test="$myparam.upper='0060'"><xsl:value-of select="$myparam"/> (Data Universal Numbering System (D-U-N-S Number))</xsl:when>
      		<xsl:when test="$myparam.upper='0061'"><xsl:value-of select="$myparam"/> (SOFFEX OSI)</xsl:when>
      		<xsl:when test="$myparam.upper='0062'"><xsl:value-of select="$myparam"/> (KPN OVN)</xsl:when>
      		<xsl:when test="$myparam.upper='0063'"><xsl:value-of select="$myparam"/> (ascomOSINet)</xsl:when>
      		<xsl:when test="$myparam.upper='0064'"><xsl:value-of select="$myparam"/> (UTC: Uniforme Transport Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0065'"><xsl:value-of select="$myparam"/> (SOLVAY OSI CODING)</xsl:when>
      		<xsl:when test="$myparam.upper='0066'"><xsl:value-of select="$myparam"/> (Roche Corporate Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0067'"><xsl:value-of select="$myparam"/> (ZellwegerOSINet)</xsl:when>
      		<xsl:when test="$myparam.upper='0068'"><xsl:value-of select="$myparam"/> (Intel Corporation OSI)</xsl:when>
      		<xsl:when test="$myparam.upper='0069'"><xsl:value-of select="$myparam"/> (SITA Object Identifier Tree)</xsl:when>
      		<xsl:when test="$myparam.upper='0070'"><xsl:value-of select="$myparam"/> (DaimlerChrysler Corporate Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0071'"><xsl:value-of select="$myparam"/> (LEGO /OSI NETWORK)</xsl:when>
      		<xsl:when test="$myparam.upper='0072'"><xsl:value-of select="$myparam"/> (NAVISTAR/OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0073'"><xsl:value-of select="$myparam"/> (ICD Formatted ATM address)</xsl:when>
      		<xsl:when test="$myparam.upper='0074'"><xsl:value-of select="$myparam"/> (ARINC)</xsl:when>
      		<xsl:when test="$myparam.upper='0075'"><xsl:value-of select="$myparam"/> (Alcanet/Alcatel-Alsthom Corporate Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0076'"><xsl:value-of select="$myparam"/> (Sistema Italiano di Identificazione di ogetti gestito da UNINFO)</xsl:when>
      		<xsl:when test="$myparam.upper='0077'"><xsl:value-of select="$myparam"/> (Sistema Italiano di Indirizzamento di Reti OSI Gestito da UNINFO)</xsl:when>
      		<xsl:when test="$myparam.upper='0078'"><xsl:value-of select="$myparam"/> (Mitel terminal or switching equipment)</xsl:when>
      		<xsl:when test="$myparam.upper='0079'"><xsl:value-of select="$myparam"/> (ATM Forum)</xsl:when>
      		<xsl:when test="$myparam.upper='0080'"><xsl:value-of select="$myparam"/> (UK National Health Service Scheme, (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0081'"><xsl:value-of select="$myparam"/> (International NSAP)</xsl:when>
      		<xsl:when test="$myparam.upper='0082'"><xsl:value-of select="$myparam"/> (Norwegian Telecommunications Authority's, NTA'S, EDI, identifier scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0083'"><xsl:value-of select="$myparam"/> (Advanced Telecommunications Modules Limited, Corporate Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0084'"><xsl:value-of select="$myparam"/> (Athens Chamber of Commerce &amp; Industry Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0085'"><xsl:value-of select="$myparam"/> (Swiss Chambers of Commerce Scheme (EDIRA) compliant)</xsl:when>
      		<xsl:when test="$myparam.upper='0086'"><xsl:value-of select="$myparam"/> (United States Council for International Business (USCIB) Scheme, (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0087'"><xsl:value-of select="$myparam"/> (National Federation of Chambers of Commerce &amp; Industry of Belgium, Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0088'"><xsl:value-of select="$myparam"/> (EAN Location Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0089'"><xsl:value-of select="$myparam"/> (The Association of British Chambers of Commerce Ltd. Scheme, (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0090'"><xsl:value-of select="$myparam"/> (Internet IP addressing - ISO 6523 ICD encoding)</xsl:when>
      		<xsl:when test="$myparam.upper='0091'"><xsl:value-of select="$myparam"/> (Cisco Sysytems / OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0093'"><xsl:value-of select="$myparam"/> (Revenue Canada Business Number Registration (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0094'"><xsl:value-of select="$myparam"/> (DEUTSCHER INDUSTRIE- UND HANDELSTAG (DIHT) Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0095'"><xsl:value-of select="$myparam"/> (Hewlett - Packard Company Internal AM Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0096'"><xsl:value-of select="$myparam"/> (DANISH CHAMBER OF COMMERCE Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0097'"><xsl:value-of select="$myparam"/> (FTI - Ediforum Italia, (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0098'"><xsl:value-of select="$myparam"/> (CHAMBER OF COMMERCE TEL AVIV-JAFFA Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0099'"><xsl:value-of select="$myparam"/> (Siemens Supervisory Systems Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0100'"><xsl:value-of select="$myparam"/> (PNG_ICD Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0101'"><xsl:value-of select="$myparam"/> (South African Code Allocation)</xsl:when>
      		<xsl:when test="$myparam.upper='0102'"><xsl:value-of select="$myparam"/> (HEAG)</xsl:when>
      		<xsl:when test="$myparam.upper='0104'"><xsl:value-of select="$myparam"/> (BT - ICD Coding System)</xsl:when>
      		<xsl:when test="$myparam.upper='0105'"><xsl:value-of select="$myparam"/> (Portuguese Chamber of Commerce and Industry Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0106'"><xsl:value-of select="$myparam"/> (Vereniging van Kamers van Koophandel en Fabrieken in Nederland (Association of Chambers of Commerce and Industry in the Netherlands), Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0107'"><xsl:value-of select="$myparam"/> (Association of Swedish Chambers of Commerce and Industry Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0108'"><xsl:value-of select="$myparam"/> (Australian Chambers of Commerce and Industry Scheme (EDIRA compliant))</xsl:when>
      		<xsl:when test="$myparam.upper='0109'"><xsl:value-of select="$myparam"/> (BellSouth ICD AESA (ATM End System Address))</xsl:when>
      		<xsl:when test="$myparam.upper='0110'"><xsl:value-of select="$myparam"/> (Bell Atlantic)</xsl:when>
      		<xsl:when test="$myparam.upper='0111'"><xsl:value-of select="$myparam"/> (Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0112'"><xsl:value-of select="$myparam"/> (ISO register for Standards producing Organizations)</xsl:when>
      		<xsl:when test="$myparam.upper='0113'"><xsl:value-of select="$myparam"/> (OriginNet)</xsl:when>
      		<xsl:when test="$myparam.upper='0114'"><xsl:value-of select="$myparam"/> (Check Point Software Technologies)</xsl:when>
      		<xsl:when test="$myparam.upper='0115'"><xsl:value-of select="$myparam"/> (Pacific Bell Data Communications Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0116'"><xsl:value-of select="$myparam"/> (PSS Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0117'"><xsl:value-of select="$myparam"/> (STENTOR-ICD CODING SYSTEM)</xsl:when>
      		<xsl:when test="$myparam.upper='0118'"><xsl:value-of select="$myparam"/> (ATM-Network ZN'96)</xsl:when>
      		<xsl:when test="$myparam.upper='0119'"><xsl:value-of select="$myparam"/> (MCI / OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0120'"><xsl:value-of select="$myparam"/> (Advantis)</xsl:when>
      		<xsl:when test="$myparam.upper='0121'"><xsl:value-of select="$myparam"/> (Affable Software Data Interchange Codes)</xsl:when>
      		<xsl:when test="$myparam.upper='0122'"><xsl:value-of select="$myparam"/> (BB-DATA GmbH)</xsl:when>
      		<xsl:when test="$myparam.upper='0123'"><xsl:value-of select="$myparam"/> (BASF Company ATM-Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0124'"><xsl:value-of select="$myparam"/> (IOTA Identifiers for Organizations for Telecommunications Addressing using the ICD system format defined in ISO/IEC 8348)</xsl:when>
      		<xsl:when test="$myparam.upper='0125'"><xsl:value-of select="$myparam"/> (Henkel Corporate Network (H-Net))</xsl:when>
      		<xsl:when test="$myparam.upper='0126'"><xsl:value-of select="$myparam"/> (GTE/OSI Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0127'"><xsl:value-of select="$myparam"/> (Dresdner Bank Corporate Network)</xsl:when>
      		<xsl:when test="$myparam.upper='0128'"><xsl:value-of select="$myparam"/> (BCNR (Swiss Clearing Bank Number))</xsl:when>
      		<xsl:when test="$myparam.upper='0129'"><xsl:value-of select="$myparam"/> (BPI (Swiss Business Partner Identification) code)</xsl:when>
      		<xsl:when test="$myparam.upper='0130'"><xsl:value-of select="$myparam"/> (Directorates of the European Commission)</xsl:when>
      		<xsl:when test="$myparam.upper='0131'"><xsl:value-of select="$myparam"/> (Code for the Identification of National Organizations)</xsl:when>
      		<xsl:when test="$myparam.upper='0132'"><xsl:value-of select="$myparam"/> (Certicom Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0133'"><xsl:value-of select="$myparam"/> (TC68 OID)</xsl:when>
      		<xsl:when test="$myparam.upper='0134'"><xsl:value-of select="$myparam"/> (Infonet Services Corporation)</xsl:when>
      		<xsl:when test="$myparam.upper='0135'"><xsl:value-of select="$myparam"/> (SIA Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0136'"><xsl:value-of select="$myparam"/> (Cable &amp; Wireless Global ATM End-System Address Plan)</xsl:when>
      		<xsl:when test="$myparam.upper='0137'"><xsl:value-of select="$myparam"/> (Global AESA scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0138'"><xsl:value-of select="$myparam"/> (France Telecom ATM End System Address Plan)</xsl:when>
      		<xsl:when test="$myparam.upper='0139'"><xsl:value-of select="$myparam"/> (Savvis Communications AESA:.)</xsl:when>
      		<xsl:when test="$myparam.upper='0140'"><xsl:value-of select="$myparam"/> (Toshiba Organizations, Partners, And Suppliers' (TOPAS) Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0141'"><xsl:value-of select="$myparam"/> (NATO Commercial and Government Entity system)</xsl:when>
      		<xsl:when test="$myparam.upper='0142'"><xsl:value-of select="$myparam"/> (SECETI Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0143'"><xsl:value-of select="$myparam"/> (EINESTEINet AG)</xsl:when>
      		<xsl:when test="$myparam.upper='0144'"><xsl:value-of select="$myparam"/> (DoDAAC (Department of Defense Activity Address Code))</xsl:when>
      		<xsl:when test="$myparam.upper='0145'"><xsl:value-of select="$myparam"/> (DGCP (Direction Générale de la Comptabilité Publique)administrative accounting identification scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0146'"><xsl:value-of select="$myparam"/> (DGI (Direction Générale des Impots) code)</xsl:when>
      		<xsl:when test="$myparam.upper='0147'"><xsl:value-of select="$myparam"/> (Standard Company Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0148'"><xsl:value-of select="$myparam"/> (ITU (International Telecommunications Union)Data Network Identification Codes (DNIC))</xsl:when>
      		<xsl:when test="$myparam.upper='0149'"><xsl:value-of select="$myparam"/> (Global Business Identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0150'"><xsl:value-of select="$myparam"/> (Madge Networks Ltd- ICD ATM Addressing Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0151'"><xsl:value-of select="$myparam"/> (Australian Business Number (ABN) Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0152'"><xsl:value-of select="$myparam"/> (Edira Scheme Identifier Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0153'"><xsl:value-of select="$myparam"/> (Concert Global Network Services ICD AESA)</xsl:when>
      		<xsl:when test="$myparam.upper='0154'"><xsl:value-of select="$myparam"/> (Identification number of economic subjects: (ICO))</xsl:when>
      		<xsl:when test="$myparam.upper='0155'"><xsl:value-of select="$myparam"/> (Global Crossing AESA (ATM End System Address))</xsl:when>
      		<xsl:when test="$myparam.upper='0156'"><xsl:value-of select="$myparam"/> (AUNA)</xsl:when>
      		<xsl:when test="$myparam.upper='0157'"><xsl:value-of select="$myparam"/> (ATM interconnection with the Dutch KPN Telecom)</xsl:when>
      		<xsl:when test="$myparam.upper='0158'"><xsl:value-of select="$myparam"/> (Identification number of economic subject (ICO) Act on State Statistics of 29 November 2'001, § 27)</xsl:when>
      		<xsl:when test="$myparam.upper='0159'"><xsl:value-of select="$myparam"/> (ACTALIS Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0160'"><xsl:value-of select="$myparam"/> (GTIN - Global Trade Item Number)</xsl:when>
      		<xsl:when test="$myparam.upper='0161'"><xsl:value-of select="$myparam"/> (ECCMA Open Technical Directory)</xsl:when>
      		<xsl:when test="$myparam.upper='0162'"><xsl:value-of select="$myparam"/> (CEN/ISSS Object Identifier Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0163'"><xsl:value-of select="$myparam"/> (US-EPA Facility Identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0164'"><xsl:value-of select="$myparam"/> (TELUS Corporation)</xsl:when>
      		<xsl:when test="$myparam.upper='0165'"><xsl:value-of select="$myparam"/> (FIEIE Object identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0166'"><xsl:value-of select="$myparam"/> (Swissguide Identifier Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0167'"><xsl:value-of select="$myparam"/> (Priority Telecom ATM End System Address Plan)</xsl:when>
      		<xsl:when test="$myparam.upper='0168'"><xsl:value-of select="$myparam"/> (Vodafone Ireland OSI Addressing)</xsl:when>
      		<xsl:when test="$myparam.upper='0169'"><xsl:value-of select="$myparam"/> (Swiss Federal Business Identification Number. Central Business names Index (zefix) Identification Number)</xsl:when>
      		<xsl:when test="$myparam.upper='0170'"><xsl:value-of select="$myparam"/> (Teikoku Company Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0171'"><xsl:value-of select="$myparam"/> (Luxembourg CP &amp; CPS (Certification Policy and Certification Practice Statement) Index)</xsl:when>
      		<xsl:when test="$myparam.upper='0172'"><xsl:value-of select="$myparam"/> (Project Group "Lists of Properties" (PROLIST®))</xsl:when>
      		<xsl:when test="$myparam.upper='0173'"><xsl:value-of select="$myparam"/> (eCI@ss)</xsl:when>
      		<xsl:when test="$myparam.upper='0174'"><xsl:value-of select="$myparam"/> (StepNexus)</xsl:when>
      		<xsl:when test="$myparam.upper='0175'"><xsl:value-of select="$myparam"/> (Siemens AG)</xsl:when>
      		<xsl:when test="$myparam.upper='0176'"><xsl:value-of select="$myparam"/> (Paradine GmbH)</xsl:when>
      		<xsl:when test="$myparam.upper='0177'"><xsl:value-of select="$myparam"/> (Odette International Limited)</xsl:when>
      		<xsl:when test="$myparam.upper='0178'"><xsl:value-of select="$myparam"/> (Route1 MobiNET)</xsl:when>
      		<xsl:when test="$myparam.upper='0179'"><xsl:value-of select="$myparam"/> (Penango Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0180'"><xsl:value-of select="$myparam"/> (Lithuanian military PKI)</xsl:when>
      		<xsl:when test="$myparam.upper='0183'"><xsl:value-of select="$myparam"/> (Numéro d'identification suisse des enterprises (IDE), Swiss Unique Business Identification Number (UIDB))</xsl:when>
      		<xsl:when test="$myparam.upper='0184'"><xsl:value-of select="$myparam"/> (DIGSTORG)</xsl:when>
      		<xsl:when test="$myparam.upper='0185'"><xsl:value-of select="$myparam"/> (Perceval Object Code)</xsl:when>
      		<xsl:when test="$myparam.upper='0186'"><xsl:value-of select="$myparam"/> (TrustPoint Object Identifiers)</xsl:when>
      		<xsl:when test="$myparam.upper='0187'"><xsl:value-of select="$myparam"/> (Amazon Unique Identification Scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='0188'"><xsl:value-of select="$myparam"/> (Corporate Number of The Social Security and Tax Number System)</xsl:when>
      		<xsl:when test="$myparam.upper='0189'"><xsl:value-of select="$myparam"/> (European Business Identifier (EBID))</xsl:when>
      		<xsl:when test="$myparam.upper='0190'"><xsl:value-of select="$myparam"/> (Organisatie Indentificatie Nummer (OIN))</xsl:when>
      		<xsl:when test="$myparam.upper='0191'"><xsl:value-of select="$myparam"/> (Company Code (Estonia))</xsl:when>
      		<xsl:when test="$myparam.upper='0192'"><xsl:value-of select="$myparam"/> (Organisasjonsnummer)</xsl:when>
      		<xsl:when test="$myparam.upper='0193'"><xsl:value-of select="$myparam"/> (UBL.BE Party Identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0194'"><xsl:value-of select="$myparam"/> (KOIOS Open Technical Dictionary)</xsl:when>
      		<xsl:when test="$myparam.upper='0195'"><xsl:value-of select="$myparam"/> (Singapore Nationwide E-lnvoice Framework)</xsl:when>
      		<xsl:when test="$myparam.upper='0196'"><xsl:value-of select="$myparam"/> (Icelandic identifier - Íslensk kennitala)</xsl:when>
      		<xsl:when test="$myparam.upper='0197'"><xsl:value-of select="$myparam"/> (APPLiA Pl Standard)</xsl:when>
      		<xsl:when test="$myparam.upper='0198'"><xsl:value-of select="$myparam"/> (ERSTORG)</xsl:when>
      		<xsl:when test="$myparam.upper='0199'"><xsl:value-of select="$myparam"/> (Legal Entity Identifier (LEI))</xsl:when>
      		<xsl:when test="$myparam.upper='0200'"><xsl:value-of select="$myparam"/> (Legal entity code (Lithuania))</xsl:when>
      		<xsl:when test="$myparam.upper='0201'"><xsl:value-of select="$myparam"/> (Codice Univoco Unità Organizzativa iPA)</xsl:when>
      		<xsl:when test="$myparam.upper='0202'"><xsl:value-of select="$myparam"/> (Indirizzo di Posta Elettronica Certificata)</xsl:when>
      		<xsl:when test="$myparam.upper='0203'"><xsl:value-of select="$myparam"/> (eDelivery Network Participant identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='0204'"><xsl:value-of select="$myparam"/> (Leitweg-ID)</xsl:when>
      		<xsl:when test="$myparam.upper='0205'"><xsl:value-of select="$myparam"/> (CODDEST)</xsl:when>
      		<xsl:when test="$myparam.upper='0206'"><xsl:value-of select="$myparam"/> (Registre du Commerce et de l’Industrie : RCI)</xsl:when>
      		<xsl:when test="$myparam.upper='0207'"><xsl:value-of select="$myparam"/> (PiLog Ontology Codification Identifier (POCI))</xsl:when>
      		<xsl:when test="$myparam.upper='0208'"><xsl:value-of select="$myparam"/> (Numero d'entreprise / ondernemingsnummer / Unternehmensnummer)</xsl:when>
      		<xsl:when test="$myparam.upper='0209'"><xsl:value-of select="$myparam"/> (GS1 identification keys)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>