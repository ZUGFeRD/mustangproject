<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.Currency-Codes">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='AED'"><xsl:value-of select="$myparam"/> (UAE Dirham)</xsl:when>
      		<xsl:when test="$myparam.upper='AFN'"><xsl:value-of select="$myparam"/> (Afghani)</xsl:when>
      		<xsl:when test="$myparam.upper='ALL'"><xsl:value-of select="$myparam"/> (Lek)</xsl:when>
      		<xsl:when test="$myparam.upper='AMD'"><xsl:value-of select="$myparam"/> (Armenian Dram)</xsl:when>
      		<xsl:when test="$myparam.upper='ANG'"><xsl:value-of select="$myparam"/> (Netherlands Antillean Guilder)</xsl:when>
      		<xsl:when test="$myparam.upper='AOA'"><xsl:value-of select="$myparam"/> (Kwanza)</xsl:when>
      		<xsl:when test="$myparam.upper='ARS'"><xsl:value-of select="$myparam"/> (Argentine Peso)</xsl:when>
      		<xsl:when test="$myparam.upper='AUD'"><xsl:value-of select="$myparam"/> (Australian Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='AWG'"><xsl:value-of select="$myparam"/> (Aruban Florin)</xsl:when>
      		<xsl:when test="$myparam.upper='AZN'"><xsl:value-of select="$myparam"/> (Azerbaijan Manat)</xsl:when>
      		<xsl:when test="$myparam.upper='BAM'"><xsl:value-of select="$myparam"/> (Convertible Mark)</xsl:when>
      		<xsl:when test="$myparam.upper='BBD'"><xsl:value-of select="$myparam"/> (Barbados Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='BDT'"><xsl:value-of select="$myparam"/> (Taka)</xsl:when>
      		<xsl:when test="$myparam.upper='BGN'"><xsl:value-of select="$myparam"/> (Bulgarian Lev)</xsl:when>
      		<xsl:when test="$myparam.upper='BHD'"><xsl:value-of select="$myparam"/> (Bahraini Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='BIF'"><xsl:value-of select="$myparam"/> (Burundi Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='BMD'"><xsl:value-of select="$myparam"/> (Bermudian Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='BND'"><xsl:value-of select="$myparam"/> (Brunei Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='BOB'"><xsl:value-of select="$myparam"/> (Boliviano)</xsl:when>
      		<xsl:when test="$myparam.upper='BOV'"><xsl:value-of select="$myparam"/> (Mvdol)</xsl:when>
      		<xsl:when test="$myparam.upper='BRL'"><xsl:value-of select="$myparam"/> (Brazilian Real)</xsl:when>
      		<xsl:when test="$myparam.upper='BSD'"><xsl:value-of select="$myparam"/> (Bahamian Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='BTN'"><xsl:value-of select="$myparam"/> (Ngultrum)</xsl:when>
      		<xsl:when test="$myparam.upper='BWP'"><xsl:value-of select="$myparam"/> (Pula)</xsl:when>
      		<xsl:when test="$myparam.upper='BYN'"><xsl:value-of select="$myparam"/> (Belarusian Ruble)</xsl:when>
      		<xsl:when test="$myparam.upper='BZD'"><xsl:value-of select="$myparam"/> (Belize Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='CAD'"><xsl:value-of select="$myparam"/> (Canadian Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='CDF'"><xsl:value-of select="$myparam"/> (Congolese Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='CHE'"><xsl:value-of select="$myparam"/> (WIR Euro)</xsl:when>
      		<xsl:when test="$myparam.upper='CHF'"><xsl:value-of select="$myparam"/> (Swiss Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='CHW'"><xsl:value-of select="$myparam"/> (WIR Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='CLF'"><xsl:value-of select="$myparam"/> (Unidad de Fomento)</xsl:when>
      		<xsl:when test="$myparam.upper='CLP'"><xsl:value-of select="$myparam"/> (Chilean Peso)</xsl:when>
      		<xsl:when test="$myparam.upper='CNY'"><xsl:value-of select="$myparam"/> (Yuan Renminbi)</xsl:when>
      		<xsl:when test="$myparam.upper='COP'"><xsl:value-of select="$myparam"/> (Colombian Peso)</xsl:when>
      		<xsl:when test="$myparam.upper='COU'"><xsl:value-of select="$myparam"/> (Unidad de Valor Real)</xsl:when>
      		<xsl:when test="$myparam.upper='CRC'"><xsl:value-of select="$myparam"/> (Costa Rican Colon)</xsl:when>
      		<xsl:when test="$myparam.upper='CUC'"><xsl:value-of select="$myparam"/> (Peso Convertible)</xsl:when>
      		<xsl:when test="$myparam.upper='CUP'"><xsl:value-of select="$myparam"/> (Cuban Peso)</xsl:when>
      		<xsl:when test="$myparam.upper='CVE'"><xsl:value-of select="$myparam"/> (Cabo Verde Escudo)</xsl:when>
      		<xsl:when test="$myparam.upper='CZK'"><xsl:value-of select="$myparam"/> (Czech Koruna)</xsl:when>
      		<xsl:when test="$myparam.upper='DJF'"><xsl:value-of select="$myparam"/> (Djibouti Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='DKK'"><xsl:value-of select="$myparam"/> (Danish Krone)</xsl:when>
      		<xsl:when test="$myparam.upper='DOP'"><xsl:value-of select="$myparam"/> (Dominican Peso)</xsl:when>
      		<xsl:when test="$myparam.upper='DZD'"><xsl:value-of select="$myparam"/> (Algerian Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='EGP'"><xsl:value-of select="$myparam"/> (Egyptian Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='ERN'"><xsl:value-of select="$myparam"/> (Nakfa)</xsl:when>
      		<xsl:when test="$myparam.upper='ETB'"><xsl:value-of select="$myparam"/> (Ethiopian Birr)</xsl:when>
      		<xsl:when test="$myparam.upper='EUR'"><xsl:value-of select="$myparam"/> (Euro)</xsl:when>
      		<xsl:when test="$myparam.upper='FJD'"><xsl:value-of select="$myparam"/> (Fiji Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='FKP'"><xsl:value-of select="$myparam"/> (Falkland Islands Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='GBP'"><xsl:value-of select="$myparam"/> (Pound Sterling)</xsl:when>
      		<xsl:when test="$myparam.upper='GEL'"><xsl:value-of select="$myparam"/> (Lari)</xsl:when>
      		<xsl:when test="$myparam.upper='GHS'"><xsl:value-of select="$myparam"/> (Ghana Cedi)</xsl:when>
      		<xsl:when test="$myparam.upper='GIP'"><xsl:value-of select="$myparam"/> (Gibraltar Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='GMD'"><xsl:value-of select="$myparam"/> (Dalasi)</xsl:when>
      		<xsl:when test="$myparam.upper='GNF'"><xsl:value-of select="$myparam"/> (Guinean Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='GTQ'"><xsl:value-of select="$myparam"/> (Quetzal)</xsl:when>
      		<xsl:when test="$myparam.upper='GYD'"><xsl:value-of select="$myparam"/> (Guyana Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='HKD'"><xsl:value-of select="$myparam"/> (Hong Kong Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='HNL'"><xsl:value-of select="$myparam"/> (Lempira)</xsl:when>
      		<xsl:when test="$myparam.upper='HRK'"><xsl:value-of select="$myparam"/> (Kuna)</xsl:when>
      		<xsl:when test="$myparam.upper='HTG'"><xsl:value-of select="$myparam"/> (Gourde)</xsl:when>
      		<xsl:when test="$myparam.upper='HUF'"><xsl:value-of select="$myparam"/> (Forint)</xsl:when>
      		<xsl:when test="$myparam.upper='IDR'"><xsl:value-of select="$myparam"/> (Rupiah)</xsl:when>
      		<xsl:when test="$myparam.upper='ILS'"><xsl:value-of select="$myparam"/> (New Israeli Sheqel)</xsl:when>
      		<xsl:when test="$myparam.upper='INR'"><xsl:value-of select="$myparam"/> (Indian Rupee)</xsl:when>
      		<xsl:when test="$myparam.upper='IQD'"><xsl:value-of select="$myparam"/> (Iraqi Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='IRR'"><xsl:value-of select="$myparam"/> (Iranian Rial)</xsl:when>
      		<xsl:when test="$myparam.upper='ISK'"><xsl:value-of select="$myparam"/> (Iceland Krona)</xsl:when>
      		<xsl:when test="$myparam.upper='JMD'"><xsl:value-of select="$myparam"/> (Jamaican Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='JOD'"><xsl:value-of select="$myparam"/> (Jordanian Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='JPY'"><xsl:value-of select="$myparam"/> (Yen)</xsl:when>
      		<xsl:when test="$myparam.upper='KES'"><xsl:value-of select="$myparam"/> (Kenyan Shilling)</xsl:when>
      		<xsl:when test="$myparam.upper='KGS'"><xsl:value-of select="$myparam"/> (Som)</xsl:when>
      		<xsl:when test="$myparam.upper='KHR'"><xsl:value-of select="$myparam"/> (Riel)</xsl:when>
      		<xsl:when test="$myparam.upper='KMF'"><xsl:value-of select="$myparam"/> (Comorian Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='KPW'"><xsl:value-of select="$myparam"/> (North Korean Won)</xsl:when>
      		<xsl:when test="$myparam.upper='KRW'"><xsl:value-of select="$myparam"/> (Won)</xsl:when>
      		<xsl:when test="$myparam.upper='KWD'"><xsl:value-of select="$myparam"/> (Kuwaiti Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='KYD'"><xsl:value-of select="$myparam"/> (Cayman Islands Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='KZT'"><xsl:value-of select="$myparam"/> (Tenge)</xsl:when>
      		<xsl:when test="$myparam.upper='LAK'"><xsl:value-of select="$myparam"/> (Lao Kip)</xsl:when>
      		<xsl:when test="$myparam.upper='LBP'"><xsl:value-of select="$myparam"/> (Lebanese Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='LKR'"><xsl:value-of select="$myparam"/> (Sri Lanka Rupee)</xsl:when>
      		<xsl:when test="$myparam.upper='LRD'"><xsl:value-of select="$myparam"/> (Liberian Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='LSL'"><xsl:value-of select="$myparam"/> (Loti)</xsl:when>
      		<xsl:when test="$myparam.upper='LYD'"><xsl:value-of select="$myparam"/> (Libyan Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='MAD'"><xsl:value-of select="$myparam"/> (Moroccan Dirham)</xsl:when>
      		<xsl:when test="$myparam.upper='MDL'"><xsl:value-of select="$myparam"/> (Moldovan Leu)</xsl:when>
      		<xsl:when test="$myparam.upper='MGA'"><xsl:value-of select="$myparam"/> (Malagasy Ariary)</xsl:when>
      		<xsl:when test="$myparam.upper='MKD'"><xsl:value-of select="$myparam"/> (Denar)</xsl:when>
      		<xsl:when test="$myparam.upper='MMK'"><xsl:value-of select="$myparam"/> (Kyat)</xsl:when>
      		<xsl:when test="$myparam.upper='MNT'"><xsl:value-of select="$myparam"/> (Tugrik)</xsl:when>
      		<xsl:when test="$myparam.upper='MOP'"><xsl:value-of select="$myparam"/> (Pataca)</xsl:when>
      		<xsl:when test="$myparam.upper='MRO'"><xsl:value-of select="$myparam"/> (Ouguiya)</xsl:when>
      		<xsl:when test="$myparam.upper='MUR'"><xsl:value-of select="$myparam"/> (Mauritius Rupee)</xsl:when>
      		<xsl:when test="$myparam.upper='MVR'"><xsl:value-of select="$myparam"/> (Rufiyaa)</xsl:when>
      		<xsl:when test="$myparam.upper='MWK'"><xsl:value-of select="$myparam"/> (Malawi Kwacha)</xsl:when>
      		<xsl:when test="$myparam.upper='MXN'"><xsl:value-of select="$myparam"/> (Mexican Peso)</xsl:when>
      		<xsl:when test="$myparam.upper='MXV'"><xsl:value-of select="$myparam"/> (Mexican Unidad de Inversion (UDI))</xsl:when>
      		<xsl:when test="$myparam.upper='MYR'"><xsl:value-of select="$myparam"/> (Malaysian Ringgit)</xsl:when>
      		<xsl:when test="$myparam.upper='MZN'"><xsl:value-of select="$myparam"/> (Mozambique Metical)</xsl:when>
      		<xsl:when test="$myparam.upper='NAD'"><xsl:value-of select="$myparam"/> (Namibia Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='NGN'"><xsl:value-of select="$myparam"/> (Naira)</xsl:when>
      		<xsl:when test="$myparam.upper='NIO'"><xsl:value-of select="$myparam"/> (Cordoba Oro)</xsl:when>
      		<xsl:when test="$myparam.upper='NOK'"><xsl:value-of select="$myparam"/> (Norwegian Krone)</xsl:when>
      		<xsl:when test="$myparam.upper='NPR'"><xsl:value-of select="$myparam"/> (Nepalese Rupee)</xsl:when>
      		<xsl:when test="$myparam.upper='NZD'"><xsl:value-of select="$myparam"/> (New Zealand Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='OMR'"><xsl:value-of select="$myparam"/> (Rial Omani)</xsl:when>
      		<xsl:when test="$myparam.upper='PAB'"><xsl:value-of select="$myparam"/> (Balboa)</xsl:when>
      		<xsl:when test="$myparam.upper='PEN'"><xsl:value-of select="$myparam"/> (Sol)</xsl:when>
      		<xsl:when test="$myparam.upper='PGK'"><xsl:value-of select="$myparam"/> (Kina)</xsl:when>
      		<xsl:when test="$myparam.upper='PHP'"><xsl:value-of select="$myparam"/> (Philippine Piso)</xsl:when>
      		<xsl:when test="$myparam.upper='PKR'"><xsl:value-of select="$myparam"/> (Pakistan Rupee)</xsl:when>
      		<xsl:when test="$myparam.upper='PLN'"><xsl:value-of select="$myparam"/> (Zloty)</xsl:when>
      		<xsl:when test="$myparam.upper='PYG'"><xsl:value-of select="$myparam"/> (Guarani)</xsl:when>
      		<xsl:when test="$myparam.upper='QAR'"><xsl:value-of select="$myparam"/> (Qatari Rial)</xsl:when>
      		<xsl:when test="$myparam.upper='RON'"><xsl:value-of select="$myparam"/> (Romanian Leu)</xsl:when>
      		<xsl:when test="$myparam.upper='RSD'"><xsl:value-of select="$myparam"/> (Serbian Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='RUB'"><xsl:value-of select="$myparam"/> (Russian Ruble)</xsl:when>
      		<xsl:when test="$myparam.upper='RWF'"><xsl:value-of select="$myparam"/> (Rwanda Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='SAR'"><xsl:value-of select="$myparam"/> (Saudi Riyal)</xsl:when>
      		<xsl:when test="$myparam.upper='SBD'"><xsl:value-of select="$myparam"/> (Solomon Islands Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='SCR'"><xsl:value-of select="$myparam"/> (Seychelles Rupee)</xsl:when>
      		<xsl:when test="$myparam.upper='SDG'"><xsl:value-of select="$myparam"/> (Sudanese Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='SEK'"><xsl:value-of select="$myparam"/> (Swedish Krona)</xsl:when>
      		<xsl:when test="$myparam.upper='SGD'"><xsl:value-of select="$myparam"/> (Singapore Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='SHP'"><xsl:value-of select="$myparam"/> (Saint Helena Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='SLL'"><xsl:value-of select="$myparam"/> (Leone)</xsl:when>
      		<xsl:when test="$myparam.upper='SOS'"><xsl:value-of select="$myparam"/> (Somali Shilling)</xsl:when>
      		<xsl:when test="$myparam.upper='SRD'"><xsl:value-of select="$myparam"/> (Surinam Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='SSP'"><xsl:value-of select="$myparam"/> (South Sudanese Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='STD'"><xsl:value-of select="$myparam"/> (Dobra)</xsl:when>
      		<xsl:when test="$myparam.upper='SVC'"><xsl:value-of select="$myparam"/> (El Salvador Colon)</xsl:when>
      		<xsl:when test="$myparam.upper='SYP'"><xsl:value-of select="$myparam"/> (Syrian Pound)</xsl:when>
      		<xsl:when test="$myparam.upper='SZL'"><xsl:value-of select="$myparam"/> (Lilangeni)</xsl:when>
      		<xsl:when test="$myparam.upper='THB'"><xsl:value-of select="$myparam"/> (Baht)</xsl:when>
      		<xsl:when test="$myparam.upper='TJS'"><xsl:value-of select="$myparam"/> (Somoni)</xsl:when>
      		<xsl:when test="$myparam.upper='TMT'"><xsl:value-of select="$myparam"/> (Turkmenistan New Manat)</xsl:when>
      		<xsl:when test="$myparam.upper='TND'"><xsl:value-of select="$myparam"/> (Tunisian Dinar)</xsl:when>
      		<xsl:when test="$myparam.upper='TOP'"><xsl:value-of select="$myparam"/> (Pa’anga)</xsl:when>
      		<xsl:when test="$myparam.upper='TRY'"><xsl:value-of select="$myparam"/> (Turkish Lira)</xsl:when>
      		<xsl:when test="$myparam.upper='TTD'"><xsl:value-of select="$myparam"/> (Trinidad and Tobago Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='TWD'"><xsl:value-of select="$myparam"/> (New Taiwan Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='TZS'"><xsl:value-of select="$myparam"/> (Tanzanian Shilling)</xsl:when>
      		<xsl:when test="$myparam.upper='UAH'"><xsl:value-of select="$myparam"/> (Hryvnia)</xsl:when>
      		<xsl:when test="$myparam.upper='UGX'"><xsl:value-of select="$myparam"/> (Uganda Shilling)</xsl:when>
      		<xsl:when test="$myparam.upper='USD'"><xsl:value-of select="$myparam"/> (US Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='USN'"><xsl:value-of select="$myparam"/> (US Dollar (Next day))</xsl:when>
      		<xsl:when test="$myparam.upper='UYI'"><xsl:value-of select="$myparam"/> (Uruguay Peso en Unidades Indexadas (URUIURUI))</xsl:when>
      		<xsl:when test="$myparam.upper='UYU'"><xsl:value-of select="$myparam"/> (Peso Uruguayo)</xsl:when>
      		<xsl:when test="$myparam.upper='UZS'"><xsl:value-of select="$myparam"/> (Uzbekistan Sum)</xsl:when>
      		<xsl:when test="$myparam.upper='VEF'"><xsl:value-of select="$myparam"/> (Bolívar)</xsl:when>
      		<xsl:when test="$myparam.upper='VND'"><xsl:value-of select="$myparam"/> (Dong)</xsl:when>
      		<xsl:when test="$myparam.upper='VUV'"><xsl:value-of select="$myparam"/> (Vatu)</xsl:when>
      		<xsl:when test="$myparam.upper='WST'"><xsl:value-of select="$myparam"/> (Tala)</xsl:when>
      		<xsl:when test="$myparam.upper='XAF'"><xsl:value-of select="$myparam"/> (CFA Franc BEAC)</xsl:when>
      		<xsl:when test="$myparam.upper='XAG'"><xsl:value-of select="$myparam"/> (Silver)</xsl:when>
      		<xsl:when test="$myparam.upper='XAU'"><xsl:value-of select="$myparam"/> (Gold)</xsl:when>
      		<xsl:when test="$myparam.upper='XBA'"><xsl:value-of select="$myparam"/> (Bond Markets Unit European Composite Unit (EURCO))</xsl:when>
      		<xsl:when test="$myparam.upper='XBB'"><xsl:value-of select="$myparam"/> (Bond Markets Unit European Monetary Unit (E.M.U.-6))</xsl:when>
      		<xsl:when test="$myparam.upper='XBC'"><xsl:value-of select="$myparam"/> (Bond Markets Unit European Unit of Account 9 (E.U.A.-9))</xsl:when>
      		<xsl:when test="$myparam.upper='XBD'"><xsl:value-of select="$myparam"/> (Bond Markets Unit European Unit of Account 17 (E.U.A.-17))</xsl:when>
      		<xsl:when test="$myparam.upper='XCD'"><xsl:value-of select="$myparam"/> (East Caribbean Dollar)</xsl:when>
      		<xsl:when test="$myparam.upper='XDR'"><xsl:value-of select="$myparam"/> (SDR (Special Drawing Right))</xsl:when>
      		<xsl:when test="$myparam.upper='XOF'"><xsl:value-of select="$myparam"/> (CFA Franc BCEAO)</xsl:when>
      		<xsl:when test="$myparam.upper='XPD'"><xsl:value-of select="$myparam"/> (Palladium)</xsl:when>
      		<xsl:when test="$myparam.upper='XPF'"><xsl:value-of select="$myparam"/> (CFP Franc)</xsl:when>
      		<xsl:when test="$myparam.upper='XPT'"><xsl:value-of select="$myparam"/> (Platinum)</xsl:when>
      		<xsl:when test="$myparam.upper='XSU'"><xsl:value-of select="$myparam"/> (Sucre)</xsl:when>
      		<xsl:when test="$myparam.upper='XTS'"><xsl:value-of select="$myparam"/> (Codes specifically reserved for testing purposes)</xsl:when>
      		<xsl:when test="$myparam.upper='XUA'"><xsl:value-of select="$myparam"/> (ADB Unit of Account)</xsl:when>
      		<xsl:when test="$myparam.upper='XXX'"><xsl:value-of select="$myparam"/> (The codes assigned for transactions where no currency is involved)</xsl:when>
      		<xsl:when test="$myparam.upper='YER'"><xsl:value-of select="$myparam"/> (Yemeni Rial)</xsl:when>
      		<xsl:when test="$myparam.upper='ZAR'"><xsl:value-of select="$myparam"/> (Rand)</xsl:when>
      		<xsl:when test="$myparam.upper='ZMW'"><xsl:value-of select="$myparam"/> (Zambian Kwacha)</xsl:when>
      		<xsl:when test="$myparam.upper='ZWL'"><xsl:value-of select="$myparam"/> (Zimbabwe Dollar)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>