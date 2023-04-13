<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.Country-Codes">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='AF'"><xsl:value-of select="$myparam"/> (Afghanistan)</xsl:when>
      		<xsl:when test="$myparam.upper='EG'"><xsl:value-of select="$myparam"/> (Ägypten)</xsl:when>
      		<xsl:when test="$myparam.upper='AX'"><xsl:value-of select="$myparam"/> (Ålandinseln)</xsl:when>
      		<xsl:when test="$myparam.upper='AL'"><xsl:value-of select="$myparam"/> (Albanien)</xsl:when>
      		<xsl:when test="$myparam.upper='DZ'"><xsl:value-of select="$myparam"/> (Algerien)</xsl:when>
      		<xsl:when test="$myparam.upper='VI'"><xsl:value-of select="$myparam"/> (Amerikanische Jungferninseln)</xsl:when>
      		<xsl:when test="$myparam.upper='UM'"><xsl:value-of select="$myparam"/> (Amerikanische Überseeinseln, Kleinere)</xsl:when>
      		<xsl:when test="$myparam.upper='AS'"><xsl:value-of select="$myparam"/> (Amerikanisch-Samoa)</xsl:when>
      		<xsl:when test="$myparam.upper='AD'"><xsl:value-of select="$myparam"/> (Andorra)</xsl:when>
      		<xsl:when test="$myparam.upper='AO'"><xsl:value-of select="$myparam"/> (Angola)</xsl:when>
      		<xsl:when test="$myparam.upper='AI'"><xsl:value-of select="$myparam"/> (Anguilla)</xsl:when>
      		<xsl:when test="$myparam.upper='AQ'"><xsl:value-of select="$myparam"/> (Antarktis)</xsl:when>
      		<xsl:when test="$myparam.upper='AG'"><xsl:value-of select="$myparam"/> (Antigua und Barbuda)</xsl:when>
      		<xsl:when test="$myparam.upper='GQ'"><xsl:value-of select="$myparam"/> (Äquatorialguinea)</xsl:when>
      		<xsl:when test="$myparam.upper='SY'"><xsl:value-of select="$myparam"/> (Arabische Republik Syrien)</xsl:when>
      		<xsl:when test="$myparam.upper='AR'"><xsl:value-of select="$myparam"/> (Argentinien)</xsl:when>
      		<xsl:when test="$myparam.upper='AM'"><xsl:value-of select="$myparam"/> (Armenien)</xsl:when>
      		<xsl:when test="$myparam.upper='AW'"><xsl:value-of select="$myparam"/> (Aruba)</xsl:when>
      		<xsl:when test="$myparam.upper='AZ'"><xsl:value-of select="$myparam"/> (Aserbaidschan)</xsl:when>
      		<xsl:when test="$myparam.upper='ET'"><xsl:value-of select="$myparam"/> (Äthiopien)</xsl:when>
      		<xsl:when test="$myparam.upper='AU'"><xsl:value-of select="$myparam"/> (Australien)</xsl:when>
      		<xsl:when test="$myparam.upper='BS'"><xsl:value-of select="$myparam"/> (Bahamas)</xsl:when>
      		<xsl:when test="$myparam.upper='BH'"><xsl:value-of select="$myparam"/> (Bahrain)</xsl:when>
      		<xsl:when test="$myparam.upper='BD'"><xsl:value-of select="$myparam"/> (Bangladesch)</xsl:when>
      		<xsl:when test="$myparam.upper='BB'"><xsl:value-of select="$myparam"/> (Barbados)</xsl:when>
      		<xsl:when test="$myparam.upper='BE'"><xsl:value-of select="$myparam"/> (Belgien)</xsl:when>
      		<xsl:when test="$myparam.upper='BZ'"><xsl:value-of select="$myparam"/> (Belize)</xsl:when>
      		<xsl:when test="$myparam.upper='BJ'"><xsl:value-of select="$myparam"/> (Benin)</xsl:when>
      		<xsl:when test="$myparam.upper='BM'"><xsl:value-of select="$myparam"/> (Bermuda)</xsl:when>
      		<xsl:when test="$myparam.upper='BT'"><xsl:value-of select="$myparam"/> (Bhutan)</xsl:when>
      		<xsl:when test="$myparam.upper='VE'"><xsl:value-of select="$myparam"/> (Bolivarische Republik Venezuela)</xsl:when>
      		<xsl:when test="$myparam.upper='BQ'"><xsl:value-of select="$myparam"/> (Bonaire, St. Eustatius und Saba)</xsl:when>
      		<xsl:when test="$myparam.upper='BA'"><xsl:value-of select="$myparam"/> (Bosnien und Herzegowina)</xsl:when>
      		<xsl:when test="$myparam.upper='BW'"><xsl:value-of select="$myparam"/> (Botsuana)</xsl:when>
      		<xsl:when test="$myparam.upper='BV'"><xsl:value-of select="$myparam"/> (Bouvetinsel)</xsl:when>
      		<xsl:when test="$myparam.upper='BR'"><xsl:value-of select="$myparam"/> (Brasilien)</xsl:when>
      		<xsl:when test="$myparam.upper='VG'"><xsl:value-of select="$myparam"/> (Britische Jungferninseln)</xsl:when>
      		<xsl:when test="$myparam.upper='IO'"><xsl:value-of select="$myparam"/> (Britisches Territorium im Indischen Ozean)</xsl:when>
      		<xsl:when test="$myparam.upper='BN'"><xsl:value-of select="$myparam"/> (Brunei Darussalam)</xsl:when>
      		<xsl:when test="$myparam.upper='BG'"><xsl:value-of select="$myparam"/> (Bulgarien)</xsl:when>
      		<xsl:when test="$myparam.upper='BF'"><xsl:value-of select="$myparam"/> (Burkina Faso)</xsl:when>
      		<xsl:when test="$myparam.upper='BI'"><xsl:value-of select="$myparam"/> (Burundi)</xsl:when>
      		<xsl:when test="$myparam.upper='CV'"><xsl:value-of select="$myparam"/> (Cabo Verde)</xsl:when>
      		<xsl:when test="$myparam.upper='CL'"><xsl:value-of select="$myparam"/> (Chile)</xsl:when>
      		<xsl:when test="$myparam.upper='CN'"><xsl:value-of select="$myparam"/> (China)</xsl:when>
      		<xsl:when test="$myparam.upper='CK'"><xsl:value-of select="$myparam"/> (Cookinseln)</xsl:when>
      		<xsl:when test="$myparam.upper='CR'"><xsl:value-of select="$myparam"/> (Costa Rica)</xsl:when>
      		<xsl:when test="$myparam.upper='CI'"><xsl:value-of select="$myparam"/> (Côte d’Ivoire)</xsl:when>
      		<xsl:when test="$myparam.upper='CW'"><xsl:value-of select="$myparam"/> (Curaçao)</xsl:when>
      		<xsl:when test="$myparam.upper='DK'"><xsl:value-of select="$myparam"/> (Dänemark)</xsl:when>
      		<xsl:when test="$myparam.upper='CD'"><xsl:value-of select="$myparam"/> (Demokratische Republik Kongo)</xsl:when>
      		<xsl:when test="$myparam.upper='KP'"><xsl:value-of select="$myparam"/> (Demokratische Volksrepublik Korea)</xsl:when>
      		<xsl:when test="$myparam.upper='LA'"><xsl:value-of select="$myparam"/> (Demokratische Volksrepublik Laos)</xsl:when>
      		<xsl:when test="$myparam.upper='DE'"><xsl:value-of select="$myparam"/> (Deutschland)</xsl:when>
      		<xsl:when test="$myparam.upper='DM'"><xsl:value-of select="$myparam"/> (Dominica)</xsl:when>
      		<xsl:when test="$myparam.upper='DO'"><xsl:value-of select="$myparam"/> (Dominikanische Republik)</xsl:when>
      		<xsl:when test="$myparam.upper='DJ'"><xsl:value-of select="$myparam"/> (Dschibuti)</xsl:when>
      		<xsl:when test="$myparam.upper='EC'"><xsl:value-of select="$myparam"/> (Ecuador)</xsl:when>
      		<xsl:when test="$myparam.upper='MK'"><xsl:value-of select="$myparam"/> (Nordmazedonien)</xsl:when>
      		<xsl:when test="$myparam.upper='SV'"><xsl:value-of select="$myparam"/> (El Salvador)</xsl:when>
      		<xsl:when test="$myparam.upper='ER'"><xsl:value-of select="$myparam"/> (Eritrea)</xsl:when>
      		<xsl:when test="$myparam.upper='EE'"><xsl:value-of select="$myparam"/> (Estland)</xsl:when>
      		<xsl:when test="$myparam.upper='FK'"><xsl:value-of select="$myparam"/> (Falklandinseln (Malwinen))</xsl:when>
      		<xsl:when test="$myparam.upper='FO'"><xsl:value-of select="$myparam"/> (Färöer)</xsl:when>
      		<xsl:when test="$myparam.upper='FJ'"><xsl:value-of select="$myparam"/> (Fidschi)</xsl:when>
      		<xsl:when test="$myparam.upper='FI'"><xsl:value-of select="$myparam"/> (Finnland)</xsl:when>
      		<xsl:when test="$myparam.upper='FM'"><xsl:value-of select="$myparam"/> (Föderierte Staaten von Mikronesien)</xsl:when>
      		<xsl:when test="$myparam.upper='FR'"><xsl:value-of select="$myparam"/> (Frankreich)</xsl:when>
      		<xsl:when test="$myparam.upper='TF'"><xsl:value-of select="$myparam"/> (Französische Süd- und Antarktisgebiete)</xsl:when>
      		<xsl:when test="$myparam.upper='GF'"><xsl:value-of select="$myparam"/> (Französisch-Guayana)</xsl:when>
      		<xsl:when test="$myparam.upper='PF'"><xsl:value-of select="$myparam"/> (Französisch-Polynesien)</xsl:when>
      		<xsl:when test="$myparam.upper='GA'"><xsl:value-of select="$myparam"/> (Gabun)</xsl:when>
      		<xsl:when test="$myparam.upper='GM'"><xsl:value-of select="$myparam"/> (Gambia)</xsl:when>
      		<xsl:when test="$myparam.upper='GE'"><xsl:value-of select="$myparam"/> (Georgien)</xsl:when>
      		<xsl:when test="$myparam.upper='GH'"><xsl:value-of select="$myparam"/> (Ghana)</xsl:when>
      		<xsl:when test="$myparam.upper='GI'"><xsl:value-of select="$myparam"/> (Gibraltar)</xsl:when>
      		<xsl:when test="$myparam.upper='GD'"><xsl:value-of select="$myparam"/> (Grenada)</xsl:when>
      		<xsl:when test="$myparam.upper='GR'"><xsl:value-of select="$myparam"/> (Griechenland)</xsl:when>
      		<xsl:when test="$myparam.upper='GL'"><xsl:value-of select="$myparam"/> (Grönland)</xsl:when>
      		<xsl:when test="$myparam.upper='GP'"><xsl:value-of select="$myparam"/> (Guadeloupe)</xsl:when>
      		<xsl:when test="$myparam.upper='GU'"><xsl:value-of select="$myparam"/> (Guam)</xsl:when>
      		<xsl:when test="$myparam.upper='GT'"><xsl:value-of select="$myparam"/> (Guatemala)</xsl:when>
      		<xsl:when test="$myparam.upper='GG'"><xsl:value-of select="$myparam"/> (Guernsey)</xsl:when>
      		<xsl:when test="$myparam.upper='GN'"><xsl:value-of select="$myparam"/> (Guinea)</xsl:when>
      		<xsl:when test="$myparam.upper='GW'"><xsl:value-of select="$myparam"/> (Guinea-Bissau)</xsl:when>
      		<xsl:when test="$myparam.upper='GY'"><xsl:value-of select="$myparam"/> (Guyana)</xsl:when>
      		<xsl:when test="$myparam.upper='HT'"><xsl:value-of select="$myparam"/> (Haiti)</xsl:when>
      		<xsl:when test="$myparam.upper='HM'"><xsl:value-of select="$myparam"/> (Heard und die McDonaldinseln)</xsl:when>
      		<xsl:when test="$myparam.upper='HN'"><xsl:value-of select="$myparam"/> (Honduras)</xsl:when>
      		<xsl:when test="$myparam.upper='HK'"><xsl:value-of select="$myparam"/> (Hongkong)</xsl:when>
      		<xsl:when test="$myparam.upper='IN'"><xsl:value-of select="$myparam"/> (Indien)</xsl:when>
      		<xsl:when test="$myparam.upper='ID'"><xsl:value-of select="$myparam"/> (Indonesien)</xsl:when>
      		<xsl:when test="$myparam.upper='IM'"><xsl:value-of select="$myparam"/> (Insel Man)</xsl:when>
      		<xsl:when test="$myparam.upper='IQ'"><xsl:value-of select="$myparam"/> (Irak)</xsl:when>
      		<xsl:when test="$myparam.upper='IE'"><xsl:value-of select="$myparam"/> (Irland)</xsl:when>
      		<xsl:when test="$myparam.upper='IR'"><xsl:value-of select="$myparam"/> (Islamische Republik Iran)</xsl:when>
      		<xsl:when test="$myparam.upper='IS'"><xsl:value-of select="$myparam"/> (Island)</xsl:when>
      		<xsl:when test="$myparam.upper='IL'"><xsl:value-of select="$myparam"/> (Israel)</xsl:when>
      		<xsl:when test="$myparam.upper='IT'"><xsl:value-of select="$myparam"/> (Italien)</xsl:when>
      		<xsl:when test="$myparam.upper='JM'"><xsl:value-of select="$myparam"/> (Jamaika)</xsl:when>
      		<xsl:when test="$myparam.upper='JP'"><xsl:value-of select="$myparam"/> (Japan)</xsl:when>
      		<xsl:when test="$myparam.upper='YE'"><xsl:value-of select="$myparam"/> (Jemen)</xsl:when>
      		<xsl:when test="$myparam.upper='JE'"><xsl:value-of select="$myparam"/> (Jersey)</xsl:when>
      		<xsl:when test="$myparam.upper='JO'"><xsl:value-of select="$myparam"/> (Jordanien)</xsl:when>
      		<xsl:when test="$myparam.upper='KY'"><xsl:value-of select="$myparam"/> (Kaimaninseln)</xsl:when>
      		<xsl:when test="$myparam.upper='KH'"><xsl:value-of select="$myparam"/> (Kambodscha)</xsl:when>
      		<xsl:when test="$myparam.upper='CM'"><xsl:value-of select="$myparam"/> (Kamerun)</xsl:when>
      		<xsl:when test="$myparam.upper='CA'"><xsl:value-of select="$myparam"/> (Kanada)</xsl:when>
      		<xsl:when test="$myparam.upper='KZ'"><xsl:value-of select="$myparam"/> (Kasachstan)</xsl:when>
      		<xsl:when test="$myparam.upper='QA'"><xsl:value-of select="$myparam"/> (Katar)</xsl:when>
      		<xsl:when test="$myparam.upper='KE'"><xsl:value-of select="$myparam"/> (Kenia)</xsl:when>
      		<xsl:when test="$myparam.upper='KG'"><xsl:value-of select="$myparam"/> (Kirgisistan)</xsl:when>
      		<xsl:when test="$myparam.upper='KI'"><xsl:value-of select="$myparam"/> (Kiribati)</xsl:when>
      		<xsl:when test="$myparam.upper='CC'"><xsl:value-of select="$myparam"/> (Kokosinseln (Keeling))</xsl:when>
      		<xsl:when test="$myparam.upper='CO'"><xsl:value-of select="$myparam"/> (Kolumbien)</xsl:when>
      		<xsl:when test="$myparam.upper='KM'"><xsl:value-of select="$myparam"/> (Komoren)</xsl:when>
      		<xsl:when test="$myparam.upper='CG'"><xsl:value-of select="$myparam"/> (Kongo)</xsl:when>
      		<xsl:when test="$myparam.upper='HR'"><xsl:value-of select="$myparam"/> (Kroatien)</xsl:when>
      		<xsl:when test="$myparam.upper='CU'"><xsl:value-of select="$myparam"/> (Kuba)</xsl:when>
      		<xsl:when test="$myparam.upper='KW'"><xsl:value-of select="$myparam"/> (Kuwait)</xsl:when>
      		<xsl:when test="$myparam.upper='LS'"><xsl:value-of select="$myparam"/> (Lesotho)</xsl:when>
      		<xsl:when test="$myparam.upper='LV'"><xsl:value-of select="$myparam"/> (Lettland)</xsl:when>
      		<xsl:when test="$myparam.upper='LB'"><xsl:value-of select="$myparam"/> (Libanon)</xsl:when>
      		<xsl:when test="$myparam.upper='LR'"><xsl:value-of select="$myparam"/> (Liberia)</xsl:when>
      		<xsl:when test="$myparam.upper='LY'"><xsl:value-of select="$myparam"/> (Libyen)</xsl:when>
      		<xsl:when test="$myparam.upper='LI'"><xsl:value-of select="$myparam"/> (Liechtenstein)</xsl:when>
      		<xsl:when test="$myparam.upper='LT'"><xsl:value-of select="$myparam"/> (Litauen)</xsl:when>
      		<xsl:when test="$myparam.upper='LU'"><xsl:value-of select="$myparam"/> (Luxemburg)</xsl:when>
      		<xsl:when test="$myparam.upper='MO'"><xsl:value-of select="$myparam"/> (Macau)</xsl:when>
      		<xsl:when test="$myparam.upper='MG'"><xsl:value-of select="$myparam"/> (Madagaskar)</xsl:when>
      		<xsl:when test="$myparam.upper='MW'"><xsl:value-of select="$myparam"/> (Malawi)</xsl:when>
      		<xsl:when test="$myparam.upper='MY'"><xsl:value-of select="$myparam"/> (Malaysia)</xsl:when>
      		<xsl:when test="$myparam.upper='MV'"><xsl:value-of select="$myparam"/> (Malediven)</xsl:when>
      		<xsl:when test="$myparam.upper='ML'"><xsl:value-of select="$myparam"/> (Mali)</xsl:when>
      		<xsl:when test="$myparam.upper='MT'"><xsl:value-of select="$myparam"/> (Malta)</xsl:when>
      		<xsl:when test="$myparam.upper='MP'"><xsl:value-of select="$myparam"/> (Marianen, Nördliche)</xsl:when>
      		<xsl:when test="$myparam.upper='MA'"><xsl:value-of select="$myparam"/> (Marokko)</xsl:when>
      		<xsl:when test="$myparam.upper='MH'"><xsl:value-of select="$myparam"/> (Marshallinseln)</xsl:when>
      		<xsl:when test="$myparam.upper='MQ'"><xsl:value-of select="$myparam"/> (Martinique)</xsl:when>
      		<xsl:when test="$myparam.upper='MR'"><xsl:value-of select="$myparam"/> (Mauretanien)</xsl:when>
      		<xsl:when test="$myparam.upper='MU'"><xsl:value-of select="$myparam"/> (Mauritius)</xsl:when>
      		<xsl:when test="$myparam.upper='YT'"><xsl:value-of select="$myparam"/> (Mayotte)</xsl:when>
      		<xsl:when test="$myparam.upper='MX'"><xsl:value-of select="$myparam"/> (Mexiko)</xsl:when>
      		<xsl:when test="$myparam.upper='MC'"><xsl:value-of select="$myparam"/> (Monaco)</xsl:when>
      		<xsl:when test="$myparam.upper='MN'"><xsl:value-of select="$myparam"/> (Mongolei)</xsl:when>
      		<xsl:when test="$myparam.upper='MS'"><xsl:value-of select="$myparam"/> (Monserrat)</xsl:when>
      		<xsl:when test="$myparam.upper='ME'"><xsl:value-of select="$myparam"/> (Montenegro)</xsl:when>
      		<xsl:when test="$myparam.upper='MZ'"><xsl:value-of select="$myparam"/> (Mosambik)</xsl:when>
      		<xsl:when test="$myparam.upper='MM'"><xsl:value-of select="$myparam"/> (Myanmar)</xsl:when>
      		<xsl:when test="$myparam.upper='NA'"><xsl:value-of select="$myparam"/> (Namibia)</xsl:when>
      		<xsl:when test="$myparam.upper='NR'"><xsl:value-of select="$myparam"/> (Nauru)</xsl:when>
      		<xsl:when test="$myparam.upper='NP'"><xsl:value-of select="$myparam"/> (Nepal)</xsl:when>
      		<xsl:when test="$myparam.upper='NC'"><xsl:value-of select="$myparam"/> (Neukaledonien)</xsl:when>
      		<xsl:when test="$myparam.upper='NZ'"><xsl:value-of select="$myparam"/> (Neuseeland)</xsl:when>
      		<xsl:when test="$myparam.upper='NI'"><xsl:value-of select="$myparam"/> (Nicaragua)</xsl:when>
      		<xsl:when test="$myparam.upper='NL'"><xsl:value-of select="$myparam"/> (Niederlande)</xsl:when>
      		<xsl:when test="$myparam.upper='NE'"><xsl:value-of select="$myparam"/> (Niger)</xsl:when>
      		<xsl:when test="$myparam.upper='NG'"><xsl:value-of select="$myparam"/> (Nigeria)</xsl:when>
      		<xsl:when test="$myparam.upper='NU'"><xsl:value-of select="$myparam"/> (Niue)</xsl:when>
      		<xsl:when test="$myparam.upper='NF'"><xsl:value-of select="$myparam"/> (Norfolkinsel)</xsl:when>
      		<xsl:when test="$myparam.upper='NO'"><xsl:value-of select="$myparam"/> (Norwegen)</xsl:when>
      		<xsl:when test="$myparam.upper='OM'"><xsl:value-of select="$myparam"/> (Oman)</xsl:when>
      		<xsl:when test="$myparam.upper='AT'"><xsl:value-of select="$myparam"/> (Österreich)</xsl:when>
      		<xsl:when test="$myparam.upper='PK'"><xsl:value-of select="$myparam"/> (Pakistan)</xsl:when>
      		<xsl:when test="$myparam.upper='PW'"><xsl:value-of select="$myparam"/> (Palau)</xsl:when>
      		<xsl:when test="$myparam.upper='PS'"><xsl:value-of select="$myparam"/> (Palestine, State of)</xsl:when>
      		<xsl:when test="$myparam.upper='PA'"><xsl:value-of select="$myparam"/> (Panama)</xsl:when>
      		<xsl:when test="$myparam.upper='PG'"><xsl:value-of select="$myparam"/> (Papua-Neuguinea)</xsl:when>
      		<xsl:when test="$myparam.upper='PY'"><xsl:value-of select="$myparam"/> (Paraguay)</xsl:when>
      		<xsl:when test="$myparam.upper='PE'"><xsl:value-of select="$myparam"/> (Peru)</xsl:when>
      		<xsl:when test="$myparam.upper='PH'"><xsl:value-of select="$myparam"/> (Philippinen)</xsl:when>
      		<xsl:when test="$myparam.upper='PN'"><xsl:value-of select="$myparam"/> (Pitcairninseln)</xsl:when>
      		<xsl:when test="$myparam.upper='BO'"><xsl:value-of select="$myparam"/> (Plurinationaler Staat Bolivien)</xsl:when>
      		<xsl:when test="$myparam.upper='PL'"><xsl:value-of select="$myparam"/> (Polen)</xsl:when>
      		<xsl:when test="$myparam.upper='PT'"><xsl:value-of select="$myparam"/> (Portugal)</xsl:when>
      		<xsl:when test="$myparam.upper='PR'"><xsl:value-of select="$myparam"/> (Puerto Rico)</xsl:when>
      		<xsl:when test="$myparam.upper='KR'"><xsl:value-of select="$myparam"/> (Republik Korea)</xsl:when>
      		<xsl:when test="$myparam.upper='MD'"><xsl:value-of select="$myparam"/> (Republik Moldau)</xsl:when>
      		<xsl:when test="$myparam.upper='RE'"><xsl:value-of select="$myparam"/> (Réunion)</xsl:when>
      		<xsl:when test="$myparam.upper='RW'"><xsl:value-of select="$myparam"/> (Ruanda)</xsl:when>
      		<xsl:when test="$myparam.upper='RO'"><xsl:value-of select="$myparam"/> (Rumänien)</xsl:when>
      		<xsl:when test="$myparam.upper='RU'"><xsl:value-of select="$myparam"/> (Russische Föderation)</xsl:when>
      		<xsl:when test="$myparam.upper='SB'"><xsl:value-of select="$myparam"/> (Salomonen)</xsl:when>
      		<xsl:when test="$myparam.upper='ZM'"><xsl:value-of select="$myparam"/> (Sambia)</xsl:when>
      		<xsl:when test="$myparam.upper='WS'"><xsl:value-of select="$myparam"/> (Samoa)</xsl:when>
      		<xsl:when test="$myparam.upper='SM'"><xsl:value-of select="$myparam"/> (San Marino)</xsl:when>
      		<xsl:when test="$myparam.upper='ST'"><xsl:value-of select="$myparam"/> (São Tomé und Príncipe)</xsl:when>
      		<xsl:when test="$myparam.upper='SA'"><xsl:value-of select="$myparam"/> (Saudi-Arabien)</xsl:when>
      		<xsl:when test="$myparam.upper='SE'"><xsl:value-of select="$myparam"/> (Schweden)</xsl:when>
      		<xsl:when test="$myparam.upper='CH'"><xsl:value-of select="$myparam"/> (Schweiz)</xsl:when>
      		<xsl:when test="$myparam.upper='SN'"><xsl:value-of select="$myparam"/> (Senegal)</xsl:when>
      		<xsl:when test="$myparam.upper='RS'"><xsl:value-of select="$myparam"/> (Serbien)</xsl:when>
      		<xsl:when test="$myparam.upper='SC'"><xsl:value-of select="$myparam"/> (Seychellen)</xsl:when>
      		<xsl:when test="$myparam.upper='SL'"><xsl:value-of select="$myparam"/> (Sierra Leone)</xsl:when>
      		<xsl:when test="$myparam.upper='ZW'"><xsl:value-of select="$myparam"/> (Simbabwe)</xsl:when>
      		<xsl:when test="$myparam.upper='SG'"><xsl:value-of select="$myparam"/> (Singapur)</xsl:when>
      		<xsl:when test="$myparam.upper='SK'"><xsl:value-of select="$myparam"/> (Slowakei)</xsl:when>
      		<xsl:when test="$myparam.upper='SI'"><xsl:value-of select="$myparam"/> (Slowenien)</xsl:when>
      		<xsl:when test="$myparam.upper='SO'"><xsl:value-of select="$myparam"/> (Somalia)</xsl:when>
      		<xsl:when test="$myparam.upper='ES'"><xsl:value-of select="$myparam"/> (Spanien)</xsl:when>
      		<xsl:when test="$myparam.upper='LK'"><xsl:value-of select="$myparam"/> (Sri Lanka)</xsl:when>
      		<xsl:when test="$myparam.upper='BL'"><xsl:value-of select="$myparam"/> (St. Barthélemy)</xsl:when>
      		<xsl:when test="$myparam.upper='SH'"><xsl:value-of select="$myparam"/> (St. Helena, Ascension und Tristan da Cunha)</xsl:when>
      		<xsl:when test="$myparam.upper='KN'"><xsl:value-of select="$myparam"/> (St. Kitts und Nevis)</xsl:when>
      		<xsl:when test="$myparam.upper='LC'"><xsl:value-of select="$myparam"/> (St. Lucia)</xsl:when>
      		<xsl:when test="$myparam.upper='MF'"><xsl:value-of select="$myparam"/> (St. Martin (französischer Teil))</xsl:when>
      		<xsl:when test="$myparam.upper='SX'"><xsl:value-of select="$myparam"/> (St. Martin (Niederländischer Teil))</xsl:when>
      		<xsl:when test="$myparam.upper='PM'"><xsl:value-of select="$myparam"/> (St. Pierre und Miquelon)</xsl:when>
      		<xsl:when test="$myparam.upper='VC'"><xsl:value-of select="$myparam"/> (St. Vincent und die Grenadinen)</xsl:when>
      		<xsl:when test="$myparam.upper='ZA'"><xsl:value-of select="$myparam"/> (Südafrika)</xsl:when>
      		<xsl:when test="$myparam.upper='SD'"><xsl:value-of select="$myparam"/> (Sudan)</xsl:when>
      		<xsl:when test="$myparam.upper='GS'"><xsl:value-of select="$myparam"/> (Südgeorgien und die Südlichen Sandwichinseln)</xsl:when>
      		<xsl:when test="$myparam.upper='SS'"><xsl:value-of select="$myparam"/> (Südsudan)</xsl:when>
      		<xsl:when test="$myparam.upper='SR'"><xsl:value-of select="$myparam"/> (Suriname)</xsl:when>
      		<xsl:when test="$myparam.upper='SJ'"><xsl:value-of select="$myparam"/> (Svalbard und Jan Mayen)</xsl:when>
      		<xsl:when test="$myparam.upper='SZ'"><xsl:value-of select="$myparam"/> (Eswatini)</xsl:when>
      		<xsl:when test="$myparam.upper='TJ'"><xsl:value-of select="$myparam"/> (Tadschikistan)</xsl:when>
      		<xsl:when test="$myparam.upper='TW'"><xsl:value-of select="$myparam"/> (Taiwan)</xsl:when>
      		<xsl:when test="$myparam.upper='TH'"><xsl:value-of select="$myparam"/> (Thailand)</xsl:when>
      		<xsl:when test="$myparam.upper='TL'"><xsl:value-of select="$myparam"/> (Timor-Leste)</xsl:when>
      		<xsl:when test="$myparam.upper='TG'"><xsl:value-of select="$myparam"/> (Togo)</xsl:when>
      		<xsl:when test="$myparam.upper='TK'"><xsl:value-of select="$myparam"/> (Tokelau)</xsl:when>
      		<xsl:when test="$myparam.upper='TO'"><xsl:value-of select="$myparam"/> (Tonga)</xsl:when>
      		<xsl:when test="$myparam.upper='TT'"><xsl:value-of select="$myparam"/> (Trinidad und Tobago)</xsl:when>
      		<xsl:when test="$myparam.upper='TD'"><xsl:value-of select="$myparam"/> (Tschad)</xsl:when>
      		<xsl:when test="$myparam.upper='CZ'"><xsl:value-of select="$myparam"/> (Tschechien)</xsl:when>
      		<xsl:when test="$myparam.upper='TN'"><xsl:value-of select="$myparam"/> (Tunesien)</xsl:when>
      		<xsl:when test="$myparam.upper='TR'"><xsl:value-of select="$myparam"/> (Türkei)</xsl:when>
      		<xsl:when test="$myparam.upper='TM'"><xsl:value-of select="$myparam"/> (Turkmenistan)</xsl:when>
      		<xsl:when test="$myparam.upper='TC'"><xsl:value-of select="$myparam"/> (Turks- und Caicosinseln)</xsl:when>
      		<xsl:when test="$myparam.upper='TV'"><xsl:value-of select="$myparam"/> (Tuvalu)</xsl:when>
      		<xsl:when test="$myparam.upper='UG'"><xsl:value-of select="$myparam"/> (Uganda)</xsl:when>
      		<xsl:when test="$myparam.upper='UA'"><xsl:value-of select="$myparam"/> (Ukraine)</xsl:when>
      		<xsl:when test="$myparam.upper='HU'"><xsl:value-of select="$myparam"/> (Ungarn)</xsl:when>
      		<xsl:when test="$myparam.upper='UY'"><xsl:value-of select="$myparam"/> (Uruguay)</xsl:when>
      		<xsl:when test="$myparam.upper='UZ'"><xsl:value-of select="$myparam"/> (Usbekistan)</xsl:when>
      		<xsl:when test="$myparam.upper='VU'"><xsl:value-of select="$myparam"/> (Vanuatu)</xsl:when>
      		<xsl:when test="$myparam.upper='VA'"><xsl:value-of select="$myparam"/> (Vatikanstadt)</xsl:when>
      		<xsl:when test="$myparam.upper='AE'"><xsl:value-of select="$myparam"/> (Vereinigte Arabische Emirate)</xsl:when>
      		<xsl:when test="$myparam.upper='TZ'"><xsl:value-of select="$myparam"/> (Vereinigte Republik Tansania)</xsl:when>
      		<xsl:when test="$myparam.upper='US'"><xsl:value-of select="$myparam"/> (Vereinigte Staaten)</xsl:when>
      		<xsl:when test="$myparam.upper='GB'"><xsl:value-of select="$myparam"/> (Vereinigtes Königreich)</xsl:when>
      		<xsl:when test="$myparam.upper='VN'"><xsl:value-of select="$myparam"/> (Vietnam)</xsl:when>
      		<xsl:when test="$myparam.upper='WF'"><xsl:value-of select="$myparam"/> (Wallis und Futuna)</xsl:when>
      		<xsl:when test="$myparam.upper='CX'"><xsl:value-of select="$myparam"/> (Weihnachtsinsel)</xsl:when>
      		<xsl:when test="$myparam.upper='BY'"><xsl:value-of select="$myparam"/> (Weißrussland)</xsl:when>
      		<xsl:when test="$myparam.upper='EH'"><xsl:value-of select="$myparam"/> (Westsahara)</xsl:when>
      		<xsl:when test="$myparam.upper='CF'"><xsl:value-of select="$myparam"/> (Zentralafrikanische Republik)</xsl:when>
      		<xsl:when test="$myparam.upper='CY'"><xsl:value-of select="$myparam"/> (Zypern)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>