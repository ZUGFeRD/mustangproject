<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.rec20">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='10'"><xsl:value-of select="$myparam"/> (group)</xsl:when>
      		<xsl:when test="$myparam.upper='11'"><xsl:value-of select="$myparam"/> (outfit)</xsl:when>
      		<xsl:when test="$myparam.upper='13'"><xsl:value-of select="$myparam"/> (ration)</xsl:when>
      		<xsl:when test="$myparam.upper='14'"><xsl:value-of select="$myparam"/> (shot)</xsl:when>
      		<xsl:when test="$myparam.upper='15'"><xsl:value-of select="$myparam"/> (stick, military)</xsl:when>
      		<xsl:when test="$myparam.upper='20'"><xsl:value-of select="$myparam"/> (twenty foot container)</xsl:when>
      		<xsl:when test="$myparam.upper='21'"><xsl:value-of select="$myparam"/> (forty foot container)</xsl:when>
      		<xsl:when test="$myparam.upper='22'"><xsl:value-of select="$myparam"/> (decilitre per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='23'"><xsl:value-of select="$myparam"/> (gram per cubic centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='24'"><xsl:value-of select="$myparam"/> (theoretical pound)</xsl:when>
      		<xsl:when test="$myparam.upper='25'"><xsl:value-of select="$myparam"/> (gram per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='27'"><xsl:value-of select="$myparam"/> (theoretical ton)</xsl:when>
      		<xsl:when test="$myparam.upper='28'"><xsl:value-of select="$myparam"/> (kilogram per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='33'"><xsl:value-of select="$myparam"/> (kilopascal square metre per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='34'"><xsl:value-of select="$myparam"/> (kilopascal per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='35'"><xsl:value-of select="$myparam"/> (millilitre per square centimetre second)</xsl:when>
      		<xsl:when test="$myparam.upper='37'"><xsl:value-of select="$myparam"/> (ounce per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='38'"><xsl:value-of select="$myparam"/> (ounce per square foot per 0,01inch)</xsl:when>
      		<xsl:when test="$myparam.upper='40'"><xsl:value-of select="$myparam"/> (millilitre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='41'"><xsl:value-of select="$myparam"/> (millilitre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='56'"><xsl:value-of select="$myparam"/> (sitas)</xsl:when>
      		<xsl:when test="$myparam.upper='57'"><xsl:value-of select="$myparam"/> (mesh)</xsl:when>
      		<xsl:when test="$myparam.upper='58'"><xsl:value-of select="$myparam"/> (net kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='59'"><xsl:value-of select="$myparam"/> (part per million)</xsl:when>
      		<xsl:when test="$myparam.upper='60'"><xsl:value-of select="$myparam"/> (percent weight)</xsl:when>
      		<xsl:when test="$myparam.upper='61'"><xsl:value-of select="$myparam"/> (part per billion (US))</xsl:when>
      		<xsl:when test="$myparam.upper='74'"><xsl:value-of select="$myparam"/> (millipascal)</xsl:when>
      		<xsl:when test="$myparam.upper='77'"><xsl:value-of select="$myparam"/> (milli-inch)</xsl:when>
      		<xsl:when test="$myparam.upper='80'"><xsl:value-of select="$myparam"/> (pound per square inch absolute)</xsl:when>
      		<xsl:when test="$myparam.upper='81'"><xsl:value-of select="$myparam"/> (henry)</xsl:when>
      		<xsl:when test="$myparam.upper='85'"><xsl:value-of select="$myparam"/> (foot pound-force)</xsl:when>
      		<xsl:when test="$myparam.upper='87'"><xsl:value-of select="$myparam"/> (pound per cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='89'"><xsl:value-of select="$myparam"/> (poise)</xsl:when>
      		<xsl:when test="$myparam.upper='91'"><xsl:value-of select="$myparam"/> (stokes)</xsl:when>
      		<xsl:when test="$myparam.upper='1I'"><xsl:value-of select="$myparam"/> (fixed rate)</xsl:when>
      		<xsl:when test="$myparam.upper='2A'"><xsl:value-of select="$myparam"/> (radian per second)</xsl:when>
      		<xsl:when test="$myparam.upper='2B'"><xsl:value-of select="$myparam"/> (radian per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='2C'"><xsl:value-of select="$myparam"/> (roentgen)</xsl:when>
      		<xsl:when test="$myparam.upper='2G'"><xsl:value-of select="$myparam"/> (volt AC)</xsl:when>
      		<xsl:when test="$myparam.upper='2H'"><xsl:value-of select="$myparam"/> (volt DC)</xsl:when>
      		<xsl:when test="$myparam.upper='2I'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='2J'"><xsl:value-of select="$myparam"/> (cubic centimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='2K'"><xsl:value-of select="$myparam"/> (cubic foot per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='2L'"><xsl:value-of select="$myparam"/> (cubic foot per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='2M'"><xsl:value-of select="$myparam"/> (centimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='2N'"><xsl:value-of select="$myparam"/> (decibel)</xsl:when>
      		<xsl:when test="$myparam.upper='2P'"><xsl:value-of select="$myparam"/> (kilobyte)</xsl:when>
      		<xsl:when test="$myparam.upper='2Q'"><xsl:value-of select="$myparam"/> (kilobecquerel)</xsl:when>
      		<xsl:when test="$myparam.upper='2R'"><xsl:value-of select="$myparam"/> (kilocurie)</xsl:when>
      		<xsl:when test="$myparam.upper='2U'"><xsl:value-of select="$myparam"/> (megagram)</xsl:when>
      		<xsl:when test="$myparam.upper='2X'"><xsl:value-of select="$myparam"/> (metre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='2Y'"><xsl:value-of select="$myparam"/> (milliroentgen)</xsl:when>
      		<xsl:when test="$myparam.upper='2Z'"><xsl:value-of select="$myparam"/> (millivolt)</xsl:when>
      		<xsl:when test="$myparam.upper='3B'"><xsl:value-of select="$myparam"/> (megajoule)</xsl:when>
      		<xsl:when test="$myparam.upper='3C'"><xsl:value-of select="$myparam"/> (manmonth)</xsl:when>
      		<xsl:when test="$myparam.upper='4C'"><xsl:value-of select="$myparam"/> (centistokes)</xsl:when>
      		<xsl:when test="$myparam.upper='4G'"><xsl:value-of select="$myparam"/> (microlitre)</xsl:when>
      		<xsl:when test="$myparam.upper='4H'"><xsl:value-of select="$myparam"/> (micrometre (micron))</xsl:when>
      		<xsl:when test="$myparam.upper='4K'"><xsl:value-of select="$myparam"/> (milliampere)</xsl:when>
      		<xsl:when test="$myparam.upper='4L'"><xsl:value-of select="$myparam"/> (megabyte)</xsl:when>
      		<xsl:when test="$myparam.upper='4M'"><xsl:value-of select="$myparam"/> (milligram per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='4N'"><xsl:value-of select="$myparam"/> (megabecquerel)</xsl:when>
      		<xsl:when test="$myparam.upper='4O'"><xsl:value-of select="$myparam"/> (microfarad)</xsl:when>
      		<xsl:when test="$myparam.upper='4P'"><xsl:value-of select="$myparam"/> (newton per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='4Q'"><xsl:value-of select="$myparam"/> (ounce inch)</xsl:when>
      		<xsl:when test="$myparam.upper='4R'"><xsl:value-of select="$myparam"/> (ounce foot)</xsl:when>
      		<xsl:when test="$myparam.upper='4T'"><xsl:value-of select="$myparam"/> (picofarad)</xsl:when>
      		<xsl:when test="$myparam.upper='4U'"><xsl:value-of select="$myparam"/> (pound per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='4W'"><xsl:value-of select="$myparam"/> (ton (US) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='4X'"><xsl:value-of select="$myparam"/> (kilolitre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='5A'"><xsl:value-of select="$myparam"/> (barrel (US) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='5B'"><xsl:value-of select="$myparam"/> (batch)</xsl:when>
      		<xsl:when test="$myparam.upper='5E'"><xsl:value-of select="$myparam"/> (MMSCF/day)</xsl:when>
      		<xsl:when test="$myparam.upper='5J'"><xsl:value-of select="$myparam"/> (hydraulic horse power)</xsl:when>
      		<xsl:when test="$myparam.upper='A10'"><xsl:value-of select="$myparam"/> (ampere square metre per joule second)</xsl:when>
      		<xsl:when test="$myparam.upper='A11'"><xsl:value-of select="$myparam"/> (angstrom)</xsl:when>
      		<xsl:when test="$myparam.upper='A12'"><xsl:value-of select="$myparam"/> (astronomical unit)</xsl:when>
      		<xsl:when test="$myparam.upper='A13'"><xsl:value-of select="$myparam"/> (attojoule)</xsl:when>
      		<xsl:when test="$myparam.upper='A14'"><xsl:value-of select="$myparam"/> (barn)</xsl:when>
      		<xsl:when test="$myparam.upper='A15'"><xsl:value-of select="$myparam"/> (barn per electronvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='A16'"><xsl:value-of select="$myparam"/> (barn per steradian electronvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='A17'"><xsl:value-of select="$myparam"/> (barn per steradian)</xsl:when>
      		<xsl:when test="$myparam.upper='A18'"><xsl:value-of select="$myparam"/> (becquerel per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='A19'"><xsl:value-of select="$myparam"/> (becquerel per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A2'"><xsl:value-of select="$myparam"/> (ampere per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A20'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per second square foot degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='A21'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per pound degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='A22'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per second foot degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='A23'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per hour square foot degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='A24'"><xsl:value-of select="$myparam"/> (candela per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A26'"><xsl:value-of select="$myparam"/> (coulomb metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A27'"><xsl:value-of select="$myparam"/> (coulomb metre squared per volt)</xsl:when>
      		<xsl:when test="$myparam.upper='A28'"><xsl:value-of select="$myparam"/> (coulomb per cubic centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A29'"><xsl:value-of select="$myparam"/> (coulomb per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A3'"><xsl:value-of select="$myparam"/> (ampere per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A30'"><xsl:value-of select="$myparam"/> (coulomb per cubic millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A31'"><xsl:value-of select="$myparam"/> (coulomb per kilogram second)</xsl:when>
      		<xsl:when test="$myparam.upper='A32'"><xsl:value-of select="$myparam"/> (coulomb per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='A33'"><xsl:value-of select="$myparam"/> (coulomb per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A34'"><xsl:value-of select="$myparam"/> (coulomb per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A35'"><xsl:value-of select="$myparam"/> (coulomb per square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A36'"><xsl:value-of select="$myparam"/> (cubic centimetre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='A37'"><xsl:value-of select="$myparam"/> (cubic decimetre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='A38'"><xsl:value-of select="$myparam"/> (cubic metre per coulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='A39'"><xsl:value-of select="$myparam"/> (cubic metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='A4'"><xsl:value-of select="$myparam"/> (ampere per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A40'"><xsl:value-of select="$myparam"/> (cubic metre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='A41'"><xsl:value-of select="$myparam"/> (ampere per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A42'"><xsl:value-of select="$myparam"/> (curie per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='A43'"><xsl:value-of select="$myparam"/> (deadweight tonnage)</xsl:when>
      		<xsl:when test="$myparam.upper='A44'"><xsl:value-of select="$myparam"/> (decalitre)</xsl:when>
      		<xsl:when test="$myparam.upper='A45'"><xsl:value-of select="$myparam"/> (decametre)</xsl:when>
      		<xsl:when test="$myparam.upper='A47'"><xsl:value-of select="$myparam"/> (decitex)</xsl:when>
      		<xsl:when test="$myparam.upper='A48'"><xsl:value-of select="$myparam"/> (degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='A49'"><xsl:value-of select="$myparam"/> (denier)</xsl:when>
      		<xsl:when test="$myparam.upper='A5'"><xsl:value-of select="$myparam"/> (ampere square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A53'"><xsl:value-of select="$myparam"/> (electronvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='A54'"><xsl:value-of select="$myparam"/> (electronvolt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A55'"><xsl:value-of select="$myparam"/> (electronvolt square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A56'"><xsl:value-of select="$myparam"/> (electronvolt square metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='A59'"><xsl:value-of select="$myparam"/> (8-part cloud cover)</xsl:when>
      		<xsl:when test="$myparam.upper='A6'"><xsl:value-of select="$myparam"/> (ampere per square metre kelvin squared)</xsl:when>
      		<xsl:when test="$myparam.upper='A68'"><xsl:value-of select="$myparam"/> (exajoule)</xsl:when>
      		<xsl:when test="$myparam.upper='A69'"><xsl:value-of select="$myparam"/> (farad per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A7'"><xsl:value-of select="$myparam"/> (ampere per square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='A70'"><xsl:value-of select="$myparam"/> (femtojoule)</xsl:when>
      		<xsl:when test="$myparam.upper='A71'"><xsl:value-of select="$myparam"/> (femtometre)</xsl:when>
      		<xsl:when test="$myparam.upper='A73'"><xsl:value-of select="$myparam"/> (foot per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='A74'"><xsl:value-of select="$myparam"/> (foot pound-force per second)</xsl:when>
      		<xsl:when test="$myparam.upper='A75'"><xsl:value-of select="$myparam"/> (freight ton)</xsl:when>
      		<xsl:when test="$myparam.upper='A76'"><xsl:value-of select="$myparam"/> (gal)</xsl:when>
      		<xsl:when test="$myparam.upper='A8'"><xsl:value-of select="$myparam"/> (ampere second)</xsl:when>
      		<xsl:when test="$myparam.upper='A84'"><xsl:value-of select="$myparam"/> (gigacoulomb per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A85'"><xsl:value-of select="$myparam"/> (gigaelectronvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='A86'"><xsl:value-of select="$myparam"/> (gigahertz)</xsl:when>
      		<xsl:when test="$myparam.upper='A87'"><xsl:value-of select="$myparam"/> (gigaohm)</xsl:when>
      		<xsl:when test="$myparam.upper='A88'"><xsl:value-of select="$myparam"/> (gigaohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A89'"><xsl:value-of select="$myparam"/> (gigapascal)</xsl:when>
      		<xsl:when test="$myparam.upper='A9'"><xsl:value-of select="$myparam"/> (rate)</xsl:when>
      		<xsl:when test="$myparam.upper='A90'"><xsl:value-of select="$myparam"/> (gigawatt)</xsl:when>
      		<xsl:when test="$myparam.upper='A91'"><xsl:value-of select="$myparam"/> (gon)</xsl:when>
      		<xsl:when test="$myparam.upper='A93'"><xsl:value-of select="$myparam"/> (gram per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A94'"><xsl:value-of select="$myparam"/> (gram per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='A95'"><xsl:value-of select="$myparam"/> (gray)</xsl:when>
      		<xsl:when test="$myparam.upper='A96'"><xsl:value-of select="$myparam"/> (gray per second)</xsl:when>
      		<xsl:when test="$myparam.upper='A97'"><xsl:value-of select="$myparam"/> (hectopascal)</xsl:when>
      		<xsl:when test="$myparam.upper='A98'"><xsl:value-of select="$myparam"/> (henry per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='A99'"><xsl:value-of select="$myparam"/> (bit)</xsl:when>
      		<xsl:when test="$myparam.upper='AA'"><xsl:value-of select="$myparam"/> (ball)</xsl:when>
      		<xsl:when test="$myparam.upper='AB'"><xsl:value-of select="$myparam"/> (bulk pack)</xsl:when>
      		<xsl:when test="$myparam.upper='ACR'"><xsl:value-of select="$myparam"/> (acre)</xsl:when>
      		<xsl:when test="$myparam.upper='ACT'"><xsl:value-of select="$myparam"/> (activity)</xsl:when>
      		<xsl:when test="$myparam.upper='AD'"><xsl:value-of select="$myparam"/> (byte)</xsl:when>
      		<xsl:when test="$myparam.upper='AE'"><xsl:value-of select="$myparam"/> (ampere per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='AH'"><xsl:value-of select="$myparam"/> (additional minute)</xsl:when>
      		<xsl:when test="$myparam.upper='AI'"><xsl:value-of select="$myparam"/> (average minute per call)</xsl:when>
      		<xsl:when test="$myparam.upper='AK'"><xsl:value-of select="$myparam"/> (fathom)</xsl:when>
      		<xsl:when test="$myparam.upper='AL'"><xsl:value-of select="$myparam"/> (access line)</xsl:when>
      		<xsl:when test="$myparam.upper='AMH'"><xsl:value-of select="$myparam"/> (ampere hour)</xsl:when>
      		<xsl:when test="$myparam.upper='AMP'"><xsl:value-of select="$myparam"/> (ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='ANN'"><xsl:value-of select="$myparam"/> (year)</xsl:when>
      		<xsl:when test="$myparam.upper='APZ'"><xsl:value-of select="$myparam"/> (troy ounce or apothecary ounce)</xsl:when>
      		<xsl:when test="$myparam.upper='AQ'"><xsl:value-of select="$myparam"/> (anti-hemophilic factor (AHF) unit)</xsl:when>
      		<xsl:when test="$myparam.upper='AS'"><xsl:value-of select="$myparam"/> (assortment)</xsl:when>
      		<xsl:when test="$myparam.upper='ASM'"><xsl:value-of select="$myparam"/> (alcoholic strength by mass)</xsl:when>
      		<xsl:when test="$myparam.upper='ASU'"><xsl:value-of select="$myparam"/> (alcoholic strength by volume)</xsl:when>
      		<xsl:when test="$myparam.upper='ATM'"><xsl:value-of select="$myparam"/> (standard atmosphere)</xsl:when>
      		<xsl:when test="$myparam.upper='AWG'"><xsl:value-of select="$myparam"/> (american wire gauge)</xsl:when>
      		<xsl:when test="$myparam.upper='AY'"><xsl:value-of select="$myparam"/> (assembly)</xsl:when>
      		<xsl:when test="$myparam.upper='AZ'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='B1'"><xsl:value-of select="$myparam"/> (barrel (US) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='B10'"><xsl:value-of select="$myparam"/> (bit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='B11'"><xsl:value-of select="$myparam"/> (joule per kilogram kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='B12'"><xsl:value-of select="$myparam"/> (joule per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B13'"><xsl:value-of select="$myparam"/> (joule per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B14'"><xsl:value-of select="$myparam"/> (joule per metre to the fourth power)</xsl:when>
      		<xsl:when test="$myparam.upper='B15'"><xsl:value-of select="$myparam"/> (joule per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='B16'"><xsl:value-of select="$myparam"/> (joule per mole kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='B17'"><xsl:value-of select="$myparam"/> (credit)</xsl:when>
      		<xsl:when test="$myparam.upper='B18'"><xsl:value-of select="$myparam"/> (joule second)</xsl:when>
      		<xsl:when test="$myparam.upper='B19'"><xsl:value-of select="$myparam"/> (digit)</xsl:when>
      		<xsl:when test="$myparam.upper='B20'"><xsl:value-of select="$myparam"/> (joule square metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='B21'"><xsl:value-of select="$myparam"/> (kelvin per watt)</xsl:when>
      		<xsl:when test="$myparam.upper='B22'"><xsl:value-of select="$myparam"/> (kiloampere)</xsl:when>
      		<xsl:when test="$myparam.upper='B23'"><xsl:value-of select="$myparam"/> (kiloampere per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B24'"><xsl:value-of select="$myparam"/> (kiloampere per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B25'"><xsl:value-of select="$myparam"/> (kilobecquerel per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='B26'"><xsl:value-of select="$myparam"/> (kilocoulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='B27'"><xsl:value-of select="$myparam"/> (kilocoulomb per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B28'"><xsl:value-of select="$myparam"/> (kilocoulomb per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B29'"><xsl:value-of select="$myparam"/> (kiloelectronvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='B3'"><xsl:value-of select="$myparam"/> (batting pound)</xsl:when>
      		<xsl:when test="$myparam.upper='B30'"><xsl:value-of select="$myparam"/> (gibibit)</xsl:when>
      		<xsl:when test="$myparam.upper='B31'"><xsl:value-of select="$myparam"/> (kilogram metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='B32'"><xsl:value-of select="$myparam"/> (kilogram metre squared)</xsl:when>
      		<xsl:when test="$myparam.upper='B33'"><xsl:value-of select="$myparam"/> (kilogram metre squared per second)</xsl:when>
      		<xsl:when test="$myparam.upper='B34'"><xsl:value-of select="$myparam"/> (kilogram per cubic decimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='B35'"><xsl:value-of select="$myparam"/> (kilogram per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='B4'"><xsl:value-of select="$myparam"/> (barrel, imperial)</xsl:when>
      		<xsl:when test="$myparam.upper='B41'"><xsl:value-of select="$myparam"/> (kilojoule per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='B42'"><xsl:value-of select="$myparam"/> (kilojoule per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='B43'"><xsl:value-of select="$myparam"/> (kilojoule per kilogram kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='B44'"><xsl:value-of select="$myparam"/> (kilojoule per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='B45'"><xsl:value-of select="$myparam"/> (kilomole)</xsl:when>
      		<xsl:when test="$myparam.upper='B46'"><xsl:value-of select="$myparam"/> (kilomole per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B47'"><xsl:value-of select="$myparam"/> (kilonewton)</xsl:when>
      		<xsl:when test="$myparam.upper='B48'"><xsl:value-of select="$myparam"/> (kilonewton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B49'"><xsl:value-of select="$myparam"/> (kiloohm)</xsl:when>
      		<xsl:when test="$myparam.upper='B50'"><xsl:value-of select="$myparam"/> (kiloohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B52'"><xsl:value-of select="$myparam"/> (kilosecond)</xsl:when>
      		<xsl:when test="$myparam.upper='B53'"><xsl:value-of select="$myparam"/> (kilosiemens)</xsl:when>
      		<xsl:when test="$myparam.upper='B54'"><xsl:value-of select="$myparam"/> (kilosiemens per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B55'"><xsl:value-of select="$myparam"/> (kilovolt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B56'"><xsl:value-of select="$myparam"/> (kiloweber per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B57'"><xsl:value-of select="$myparam"/> (light year)</xsl:when>
      		<xsl:when test="$myparam.upper='B58'"><xsl:value-of select="$myparam"/> (litre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='B59'"><xsl:value-of select="$myparam"/> (lumen hour)</xsl:when>
      		<xsl:when test="$myparam.upper='B60'"><xsl:value-of select="$myparam"/> (lumen per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B61'"><xsl:value-of select="$myparam"/> (lumen per watt)</xsl:when>
      		<xsl:when test="$myparam.upper='B62'"><xsl:value-of select="$myparam"/> (lumen second)</xsl:when>
      		<xsl:when test="$myparam.upper='B63'"><xsl:value-of select="$myparam"/> (lux hour)</xsl:when>
      		<xsl:when test="$myparam.upper='B64'"><xsl:value-of select="$myparam"/> (lux second)</xsl:when>
      		<xsl:when test="$myparam.upper='B66'"><xsl:value-of select="$myparam"/> (megaampere per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B67'"><xsl:value-of select="$myparam"/> (megabecquerel per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='B68'"><xsl:value-of select="$myparam"/> (gigabit)</xsl:when>
      		<xsl:when test="$myparam.upper='B69'"><xsl:value-of select="$myparam"/> (megacoulomb per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B7'"><xsl:value-of select="$myparam"/> (cycle)</xsl:when>
      		<xsl:when test="$myparam.upper='B70'"><xsl:value-of select="$myparam"/> (megacoulomb per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B71'"><xsl:value-of select="$myparam"/> (megaelectronvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='B72'"><xsl:value-of select="$myparam"/> (megagram per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B73'"><xsl:value-of select="$myparam"/> (meganewton)</xsl:when>
      		<xsl:when test="$myparam.upper='B74'"><xsl:value-of select="$myparam"/> (meganewton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B75'"><xsl:value-of select="$myparam"/> (megaohm)</xsl:when>
      		<xsl:when test="$myparam.upper='B76'"><xsl:value-of select="$myparam"/> (megaohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B77'"><xsl:value-of select="$myparam"/> (megasiemens per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B78'"><xsl:value-of select="$myparam"/> (megavolt)</xsl:when>
      		<xsl:when test="$myparam.upper='B79'"><xsl:value-of select="$myparam"/> (megavolt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B8'"><xsl:value-of select="$myparam"/> (joule per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B80'"><xsl:value-of select="$myparam"/> (gigabit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='B81'"><xsl:value-of select="$myparam"/> (reciprocal metre squared reciprocal second)</xsl:when>
      		<xsl:when test="$myparam.upper='B82'"><xsl:value-of select="$myparam"/> (inch per linear foot)</xsl:when>
      		<xsl:when test="$myparam.upper='B83'"><xsl:value-of select="$myparam"/> (metre to the fourth power)</xsl:when>
      		<xsl:when test="$myparam.upper='B84'"><xsl:value-of select="$myparam"/> (microampere)</xsl:when>
      		<xsl:when test="$myparam.upper='B85'"><xsl:value-of select="$myparam"/> (microbar)</xsl:when>
      		<xsl:when test="$myparam.upper='B86'"><xsl:value-of select="$myparam"/> (microcoulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='B87'"><xsl:value-of select="$myparam"/> (microcoulomb per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B88'"><xsl:value-of select="$myparam"/> (microcoulomb per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B89'"><xsl:value-of select="$myparam"/> (microfarad per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B90'"><xsl:value-of select="$myparam"/> (microhenry)</xsl:when>
      		<xsl:when test="$myparam.upper='B91'"><xsl:value-of select="$myparam"/> (microhenry per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B92'"><xsl:value-of select="$myparam"/> (micronewton)</xsl:when>
      		<xsl:when test="$myparam.upper='B93'"><xsl:value-of select="$myparam"/> (micronewton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B94'"><xsl:value-of select="$myparam"/> (microohm)</xsl:when>
      		<xsl:when test="$myparam.upper='B95'"><xsl:value-of select="$myparam"/> (microohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='B96'"><xsl:value-of select="$myparam"/> (micropascal)</xsl:when>
      		<xsl:when test="$myparam.upper='B97'"><xsl:value-of select="$myparam"/> (microradian)</xsl:when>
      		<xsl:when test="$myparam.upper='B98'"><xsl:value-of select="$myparam"/> (microsecond)</xsl:when>
      		<xsl:when test="$myparam.upper='B99'"><xsl:value-of select="$myparam"/> (microsiemens)</xsl:when>
      		<xsl:when test="$myparam.upper='BAR'"><xsl:value-of select="$myparam"/> (bar [unit of pressure])</xsl:when>
      		<xsl:when test="$myparam.upper='BB'"><xsl:value-of select="$myparam"/> (base box)</xsl:when>
      		<xsl:when test="$myparam.upper='BFT'"><xsl:value-of select="$myparam"/> (board foot)</xsl:when>
      		<xsl:when test="$myparam.upper='BHP'"><xsl:value-of select="$myparam"/> (brake horse power)</xsl:when>
      		<xsl:when test="$myparam.upper='BIL'"><xsl:value-of select="$myparam"/> (billion (EUR))</xsl:when>
      		<xsl:when test="$myparam.upper='BLD'"><xsl:value-of select="$myparam"/> (dry barrel (US))</xsl:when>
      		<xsl:when test="$myparam.upper='BLL'"><xsl:value-of select="$myparam"/> (barrel (US))</xsl:when>
      		<xsl:when test="$myparam.upper='BP'"><xsl:value-of select="$myparam"/> (hundred board foot)</xsl:when>
      		<xsl:when test="$myparam.upper='BPM'"><xsl:value-of select="$myparam"/> (beats per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='BQL'"><xsl:value-of select="$myparam"/> (becquerel)</xsl:when>
      		<xsl:when test="$myparam.upper='BTU'"><xsl:value-of select="$myparam"/> (British thermal unit (international table))</xsl:when>
      		<xsl:when test="$myparam.upper='BUA'"><xsl:value-of select="$myparam"/> (bushel (US))</xsl:when>
      		<xsl:when test="$myparam.upper='BUI'"><xsl:value-of select="$myparam"/> (bushel (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='C0'"><xsl:value-of select="$myparam"/> (call)</xsl:when>
      		<xsl:when test="$myparam.upper='C10'"><xsl:value-of select="$myparam"/> (millifarad)</xsl:when>
      		<xsl:when test="$myparam.upper='C11'"><xsl:value-of select="$myparam"/> (milligal)</xsl:when>
      		<xsl:when test="$myparam.upper='C12'"><xsl:value-of select="$myparam"/> (milligram per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C13'"><xsl:value-of select="$myparam"/> (milligray)</xsl:when>
      		<xsl:when test="$myparam.upper='C14'"><xsl:value-of select="$myparam"/> (millihenry)</xsl:when>
      		<xsl:when test="$myparam.upper='C15'"><xsl:value-of select="$myparam"/> (millijoule)</xsl:when>
      		<xsl:when test="$myparam.upper='C16'"><xsl:value-of select="$myparam"/> (millimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='C17'"><xsl:value-of select="$myparam"/> (millimetre squared per second)</xsl:when>
      		<xsl:when test="$myparam.upper='C18'"><xsl:value-of select="$myparam"/> (millimole)</xsl:when>
      		<xsl:when test="$myparam.upper='C19'"><xsl:value-of select="$myparam"/> (mole per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='C20'"><xsl:value-of select="$myparam"/> (millinewton)</xsl:when>
      		<xsl:when test="$myparam.upper='C21'"><xsl:value-of select="$myparam"/> (kibibit)</xsl:when>
      		<xsl:when test="$myparam.upper='C22'"><xsl:value-of select="$myparam"/> (millinewton per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C23'"><xsl:value-of select="$myparam"/> (milliohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C24'"><xsl:value-of select="$myparam"/> (millipascal second)</xsl:when>
      		<xsl:when test="$myparam.upper='C25'"><xsl:value-of select="$myparam"/> (milliradian)</xsl:when>
      		<xsl:when test="$myparam.upper='C26'"><xsl:value-of select="$myparam"/> (millisecond)</xsl:when>
      		<xsl:when test="$myparam.upper='C27'"><xsl:value-of select="$myparam"/> (millisiemens)</xsl:when>
      		<xsl:when test="$myparam.upper='C28'"><xsl:value-of select="$myparam"/> (millisievert)</xsl:when>
      		<xsl:when test="$myparam.upper='C29'"><xsl:value-of select="$myparam"/> (millitesla)</xsl:when>
      		<xsl:when test="$myparam.upper='C3'"><xsl:value-of select="$myparam"/> (microvolt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C30'"><xsl:value-of select="$myparam"/> (millivolt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C31'"><xsl:value-of select="$myparam"/> (milliwatt)</xsl:when>
      		<xsl:when test="$myparam.upper='C32'"><xsl:value-of select="$myparam"/> (milliwatt per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C33'"><xsl:value-of select="$myparam"/> (milliweber)</xsl:when>
      		<xsl:when test="$myparam.upper='C34'"><xsl:value-of select="$myparam"/> (mole)</xsl:when>
      		<xsl:when test="$myparam.upper='C35'"><xsl:value-of select="$myparam"/> (mole per cubic decimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='C36'"><xsl:value-of select="$myparam"/> (mole per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C37'"><xsl:value-of select="$myparam"/> (kilobit)</xsl:when>
      		<xsl:when test="$myparam.upper='C38'"><xsl:value-of select="$myparam"/> (mole per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='C39'"><xsl:value-of select="$myparam"/> (nanoampere)</xsl:when>
      		<xsl:when test="$myparam.upper='C40'"><xsl:value-of select="$myparam"/> (nanocoulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='C41'"><xsl:value-of select="$myparam"/> (nanofarad)</xsl:when>
      		<xsl:when test="$myparam.upper='C42'"><xsl:value-of select="$myparam"/> (nanofarad per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C43'"><xsl:value-of select="$myparam"/> (nanohenry)</xsl:when>
      		<xsl:when test="$myparam.upper='C44'"><xsl:value-of select="$myparam"/> (nanohenry per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C45'"><xsl:value-of select="$myparam"/> (nanometre)</xsl:when>
      		<xsl:when test="$myparam.upper='C46'"><xsl:value-of select="$myparam"/> (nanoohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C47'"><xsl:value-of select="$myparam"/> (nanosecond)</xsl:when>
      		<xsl:when test="$myparam.upper='C48'"><xsl:value-of select="$myparam"/> (nanotesla)</xsl:when>
      		<xsl:when test="$myparam.upper='C49'"><xsl:value-of select="$myparam"/> (nanowatt)</xsl:when>
      		<xsl:when test="$myparam.upper='C50'"><xsl:value-of select="$myparam"/> (neper)</xsl:when>
      		<xsl:when test="$myparam.upper='C51'"><xsl:value-of select="$myparam"/> (neper per second)</xsl:when>
      		<xsl:when test="$myparam.upper='C52'"><xsl:value-of select="$myparam"/> (picometre)</xsl:when>
      		<xsl:when test="$myparam.upper='C53'"><xsl:value-of select="$myparam"/> (newton metre second)</xsl:when>
      		<xsl:when test="$myparam.upper='C54'"><xsl:value-of select="$myparam"/> (newton metre squared per kilogram squared)</xsl:when>
      		<xsl:when test="$myparam.upper='C55'"><xsl:value-of select="$myparam"/> (newton per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C56'"><xsl:value-of select="$myparam"/> (newton per square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='C57'"><xsl:value-of select="$myparam"/> (newton second)</xsl:when>
      		<xsl:when test="$myparam.upper='C58'"><xsl:value-of select="$myparam"/> (newton second per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C59'"><xsl:value-of select="$myparam"/> (octave)</xsl:when>
      		<xsl:when test="$myparam.upper='C60'"><xsl:value-of select="$myparam"/> (ohm centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='C61'"><xsl:value-of select="$myparam"/> (ohm metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C62'"><xsl:value-of select="$myparam"/> (one)</xsl:when>
      		<xsl:when test="$myparam.upper='C63'"><xsl:value-of select="$myparam"/> (parsec)</xsl:when>
      		<xsl:when test="$myparam.upper='C64'"><xsl:value-of select="$myparam"/> (pascal per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='C65'"><xsl:value-of select="$myparam"/> (pascal second)</xsl:when>
      		<xsl:when test="$myparam.upper='C66'"><xsl:value-of select="$myparam"/> (pascal second per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C67'"><xsl:value-of select="$myparam"/> (pascal second per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C68'"><xsl:value-of select="$myparam"/> (petajoule)</xsl:when>
      		<xsl:when test="$myparam.upper='C69'"><xsl:value-of select="$myparam"/> (phon)</xsl:when>
      		<xsl:when test="$myparam.upper='C7'"><xsl:value-of select="$myparam"/> (centipoise)</xsl:when>
      		<xsl:when test="$myparam.upper='C70'"><xsl:value-of select="$myparam"/> (picoampere)</xsl:when>
      		<xsl:when test="$myparam.upper='C71'"><xsl:value-of select="$myparam"/> (picocoulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='C72'"><xsl:value-of select="$myparam"/> (picofarad per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C73'"><xsl:value-of select="$myparam"/> (picohenry)</xsl:when>
      		<xsl:when test="$myparam.upper='C74'"><xsl:value-of select="$myparam"/> (kilobit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='C75'"><xsl:value-of select="$myparam"/> (picowatt)</xsl:when>
      		<xsl:when test="$myparam.upper='C76'"><xsl:value-of select="$myparam"/> (picowatt per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C78'"><xsl:value-of select="$myparam"/> (pound-force)</xsl:when>
      		<xsl:when test="$myparam.upper='C79'"><xsl:value-of select="$myparam"/> (kilovolt ampere hour)</xsl:when>
      		<xsl:when test="$myparam.upper='C8'"><xsl:value-of select="$myparam"/> (millicoulomb per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='C80'"><xsl:value-of select="$myparam"/> (rad)</xsl:when>
      		<xsl:when test="$myparam.upper='C81'"><xsl:value-of select="$myparam"/> (radian)</xsl:when>
      		<xsl:when test="$myparam.upper='C82'"><xsl:value-of select="$myparam"/> (radian square metre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='C83'"><xsl:value-of select="$myparam"/> (radian square metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='C84'"><xsl:value-of select="$myparam"/> (radian per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C85'"><xsl:value-of select="$myparam"/> (reciprocal angstrom)</xsl:when>
      		<xsl:when test="$myparam.upper='C86'"><xsl:value-of select="$myparam"/> (reciprocal cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C87'"><xsl:value-of select="$myparam"/> (reciprocal cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='C88'"><xsl:value-of select="$myparam"/> (reciprocal electron volt per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C89'"><xsl:value-of select="$myparam"/> (reciprocal henry)</xsl:when>
      		<xsl:when test="$myparam.upper='C9'"><xsl:value-of select="$myparam"/> (coil group)</xsl:when>
      		<xsl:when test="$myparam.upper='C90'"><xsl:value-of select="$myparam"/> (reciprocal joule per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C91'"><xsl:value-of select="$myparam"/> (reciprocal kelvin or kelvin to the power minus one)</xsl:when>
      		<xsl:when test="$myparam.upper='C92'"><xsl:value-of select="$myparam"/> (reciprocal metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C93'"><xsl:value-of select="$myparam"/> (reciprocal square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='C94'"><xsl:value-of select="$myparam"/> (reciprocal minute)</xsl:when>
      		<xsl:when test="$myparam.upper='C95'"><xsl:value-of select="$myparam"/> (reciprocal mole)</xsl:when>
      		<xsl:when test="$myparam.upper='C96'"><xsl:value-of select="$myparam"/> (reciprocal pascal or pascal to the power minus one)</xsl:when>
      		<xsl:when test="$myparam.upper='C97'"><xsl:value-of select="$myparam"/> (reciprocal second)</xsl:when>
      		<xsl:when test="$myparam.upper='C99'"><xsl:value-of select="$myparam"/> (reciprocal second per metre squared)</xsl:when>
      		<xsl:when test="$myparam.upper='CCT'"><xsl:value-of select="$myparam"/> (carrying capacity in metric ton)</xsl:when>
      		<xsl:when test="$myparam.upper='CDL'"><xsl:value-of select="$myparam"/> (candela)</xsl:when>
      		<xsl:when test="$myparam.upper='CEL'"><xsl:value-of select="$myparam"/> (degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='CEN'"><xsl:value-of select="$myparam"/> (hundred)</xsl:when>
      		<xsl:when test="$myparam.upper='CG'"><xsl:value-of select="$myparam"/> (card)</xsl:when>
      		<xsl:when test="$myparam.upper='CGM'"><xsl:value-of select="$myparam"/> (centigram)</xsl:when>
      		<xsl:when test="$myparam.upper='CKG'"><xsl:value-of select="$myparam"/> (coulomb per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='CLF'"><xsl:value-of select="$myparam"/> (hundred leave)</xsl:when>
      		<xsl:when test="$myparam.upper='CLT'"><xsl:value-of select="$myparam"/> (centilitre)</xsl:when>
      		<xsl:when test="$myparam.upper='CMK'"><xsl:value-of select="$myparam"/> (square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='CMQ'"><xsl:value-of select="$myparam"/> (cubic centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='CMT'"><xsl:value-of select="$myparam"/> (centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='CNP'"><xsl:value-of select="$myparam"/> (hundred pack)</xsl:when>
      		<xsl:when test="$myparam.upper='CNT'"><xsl:value-of select="$myparam"/> (cental (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='COU'"><xsl:value-of select="$myparam"/> (coulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='CTG'"><xsl:value-of select="$myparam"/> (content gram)</xsl:when>
      		<xsl:when test="$myparam.upper='CTM'"><xsl:value-of select="$myparam"/> (metric carat)</xsl:when>
      		<xsl:when test="$myparam.upper='CTN'"><xsl:value-of select="$myparam"/> (content ton (metric))</xsl:when>
      		<xsl:when test="$myparam.upper='CUR'"><xsl:value-of select="$myparam"/> (curie)</xsl:when>
      		<xsl:when test="$myparam.upper='CWA'"><xsl:value-of select="$myparam"/> (hundred pound (cwt) / hundred weight (US))</xsl:when>
      		<xsl:when test="$myparam.upper='CWI'"><xsl:value-of select="$myparam"/> (hundred weight (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='D03'"><xsl:value-of select="$myparam"/> (kilowatt hour per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='D04'"><xsl:value-of select="$myparam"/> (lot [unit of weight])</xsl:when>
      		<xsl:when test="$myparam.upper='D1'"><xsl:value-of select="$myparam"/> (reciprocal second per steradian)</xsl:when>
      		<xsl:when test="$myparam.upper='D10'"><xsl:value-of select="$myparam"/> (siemens per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D11'"><xsl:value-of select="$myparam"/> (mebibit)</xsl:when>
      		<xsl:when test="$myparam.upper='D12'"><xsl:value-of select="$myparam"/> (siemens square metre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='D13'"><xsl:value-of select="$myparam"/> (sievert)</xsl:when>
      		<xsl:when test="$myparam.upper='D15'"><xsl:value-of select="$myparam"/> (sone)</xsl:when>
      		<xsl:when test="$myparam.upper='D16'"><xsl:value-of select="$myparam"/> (square centimetre per erg)</xsl:when>
      		<xsl:when test="$myparam.upper='D17'"><xsl:value-of select="$myparam"/> (square centimetre per steradian erg)</xsl:when>
      		<xsl:when test="$myparam.upper='D18'"><xsl:value-of select="$myparam"/> (metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='D19'"><xsl:value-of select="$myparam"/> (square metre kelvin per watt)</xsl:when>
      		<xsl:when test="$myparam.upper='D2'"><xsl:value-of select="$myparam"/> (reciprocal second per steradian metre squared)</xsl:when>
      		<xsl:when test="$myparam.upper='D20'"><xsl:value-of select="$myparam"/> (square metre per joule)</xsl:when>
      		<xsl:when test="$myparam.upper='D21'"><xsl:value-of select="$myparam"/> (square metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='D22'"><xsl:value-of select="$myparam"/> (square metre per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='D23'"><xsl:value-of select="$myparam"/> (pen gram (protein))</xsl:when>
      		<xsl:when test="$myparam.upper='D24'"><xsl:value-of select="$myparam"/> (square metre per steradian)</xsl:when>
      		<xsl:when test="$myparam.upper='D25'"><xsl:value-of select="$myparam"/> (square metre per steradian joule)</xsl:when>
      		<xsl:when test="$myparam.upper='D26'"><xsl:value-of select="$myparam"/> (square metre per volt second)</xsl:when>
      		<xsl:when test="$myparam.upper='D27'"><xsl:value-of select="$myparam"/> (steradian)</xsl:when>
      		<xsl:when test="$myparam.upper='D29'"><xsl:value-of select="$myparam"/> (terahertz)</xsl:when>
      		<xsl:when test="$myparam.upper='D30'"><xsl:value-of select="$myparam"/> (terajoule)</xsl:when>
      		<xsl:when test="$myparam.upper='D31'"><xsl:value-of select="$myparam"/> (terawatt)</xsl:when>
      		<xsl:when test="$myparam.upper='D32'"><xsl:value-of select="$myparam"/> (terawatt hour)</xsl:when>
      		<xsl:when test="$myparam.upper='D33'"><xsl:value-of select="$myparam"/> (tesla)</xsl:when>
      		<xsl:when test="$myparam.upper='D34'"><xsl:value-of select="$myparam"/> (tex)</xsl:when>
      		<xsl:when test="$myparam.upper='D36'"><xsl:value-of select="$myparam"/> (megabit)</xsl:when>
      		<xsl:when test="$myparam.upper='D41'"><xsl:value-of select="$myparam"/> (tonne per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D42'"><xsl:value-of select="$myparam"/> (tropical year)</xsl:when>
      		<xsl:when test="$myparam.upper='D43'"><xsl:value-of select="$myparam"/> (unified atomic mass unit)</xsl:when>
      		<xsl:when test="$myparam.upper='D44'"><xsl:value-of select="$myparam"/> (var)</xsl:when>
      		<xsl:when test="$myparam.upper='D45'"><xsl:value-of select="$myparam"/> (volt squared per kelvin squared)</xsl:when>
      		<xsl:when test="$myparam.upper='D46'"><xsl:value-of select="$myparam"/> (volt - ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='D47'"><xsl:value-of select="$myparam"/> (volt per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='D48'"><xsl:value-of select="$myparam"/> (volt per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='D49'"><xsl:value-of select="$myparam"/> (millivolt per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='D5'"><xsl:value-of select="$myparam"/> (kilogram per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='D50'"><xsl:value-of select="$myparam"/> (volt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D51'"><xsl:value-of select="$myparam"/> (volt per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='D52'"><xsl:value-of select="$myparam"/> (watt per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='D53'"><xsl:value-of select="$myparam"/> (watt per metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='D54'"><xsl:value-of select="$myparam"/> (watt per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D55'"><xsl:value-of select="$myparam"/> (watt per square metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='D56'"><xsl:value-of select="$myparam"/> (watt per square metre kelvin to the fourth power)</xsl:when>
      		<xsl:when test="$myparam.upper='D57'"><xsl:value-of select="$myparam"/> (watt per steradian)</xsl:when>
      		<xsl:when test="$myparam.upper='D58'"><xsl:value-of select="$myparam"/> (watt per steradian square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D59'"><xsl:value-of select="$myparam"/> (weber per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D6'"><xsl:value-of select="$myparam"/> (roentgen per second)</xsl:when>
      		<xsl:when test="$myparam.upper='D60'"><xsl:value-of select="$myparam"/> (weber per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='D61'"><xsl:value-of select="$myparam"/> (minute [unit of angle])</xsl:when>
      		<xsl:when test="$myparam.upper='D62'"><xsl:value-of select="$myparam"/> (second [unit of angle])</xsl:when>
      		<xsl:when test="$myparam.upper='D63'"><xsl:value-of select="$myparam"/> (book)</xsl:when>
      		<xsl:when test="$myparam.upper='D65'"><xsl:value-of select="$myparam"/> (round)</xsl:when>
      		<xsl:when test="$myparam.upper='D68'"><xsl:value-of select="$myparam"/> (number of words)</xsl:when>
      		<xsl:when test="$myparam.upper='D69'"><xsl:value-of select="$myparam"/> (inch to the fourth power)</xsl:when>
      		<xsl:when test="$myparam.upper='D73'"><xsl:value-of select="$myparam"/> (joule square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D74'"><xsl:value-of select="$myparam"/> (kilogram per mole)</xsl:when>
      		<xsl:when test="$myparam.upper='D77'"><xsl:value-of select="$myparam"/> (megacoulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='D78'"><xsl:value-of select="$myparam"/> (megajoule per second)</xsl:when>
      		<xsl:when test="$myparam.upper='D80'"><xsl:value-of select="$myparam"/> (microwatt)</xsl:when>
      		<xsl:when test="$myparam.upper='D81'"><xsl:value-of select="$myparam"/> (microtesla)</xsl:when>
      		<xsl:when test="$myparam.upper='D82'"><xsl:value-of select="$myparam"/> (microvolt)</xsl:when>
      		<xsl:when test="$myparam.upper='D83'"><xsl:value-of select="$myparam"/> (millinewton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D85'"><xsl:value-of select="$myparam"/> (microwatt per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D86'"><xsl:value-of select="$myparam"/> (millicoulomb)</xsl:when>
      		<xsl:when test="$myparam.upper='D87'"><xsl:value-of select="$myparam"/> (millimole per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='D88'"><xsl:value-of select="$myparam"/> (millicoulomb per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D89'"><xsl:value-of select="$myparam"/> (millicoulomb per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D91'"><xsl:value-of select="$myparam"/> (rem)</xsl:when>
      		<xsl:when test="$myparam.upper='D93'"><xsl:value-of select="$myparam"/> (second per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='D94'"><xsl:value-of select="$myparam"/> (second per cubic metre radian)</xsl:when>
      		<xsl:when test="$myparam.upper='D95'"><xsl:value-of select="$myparam"/> (joule per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='DAA'"><xsl:value-of select="$myparam"/> (decare)</xsl:when>
      		<xsl:when test="$myparam.upper='DAD'"><xsl:value-of select="$myparam"/> (ten day)</xsl:when>
      		<xsl:when test="$myparam.upper='DAY'"><xsl:value-of select="$myparam"/> (day)</xsl:when>
      		<xsl:when test="$myparam.upper='DB'"><xsl:value-of select="$myparam"/> (dry pound)</xsl:when>
      		<xsl:when test="$myparam.upper='DD'"><xsl:value-of select="$myparam"/> (degree [unit of angle])</xsl:when>
      		<xsl:when test="$myparam.upper='DEC'"><xsl:value-of select="$myparam"/> (decade)</xsl:when>
      		<xsl:when test="$myparam.upper='DG'"><xsl:value-of select="$myparam"/> (decigram)</xsl:when>
      		<xsl:when test="$myparam.upper='DJ'"><xsl:value-of select="$myparam"/> (decagram)</xsl:when>
      		<xsl:when test="$myparam.upper='DLT'"><xsl:value-of select="$myparam"/> (decilitre)</xsl:when>
      		<xsl:when test="$myparam.upper='DMA'"><xsl:value-of select="$myparam"/> (cubic decametre)</xsl:when>
      		<xsl:when test="$myparam.upper='DMK'"><xsl:value-of select="$myparam"/> (square decimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='DMO'"><xsl:value-of select="$myparam"/> (standard kilolitre)</xsl:when>
      		<xsl:when test="$myparam.upper='DMQ'"><xsl:value-of select="$myparam"/> (cubic decimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='DMT'"><xsl:value-of select="$myparam"/> (decimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='DN'"><xsl:value-of select="$myparam"/> (decinewton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='DPC'"><xsl:value-of select="$myparam"/> (dozen piece)</xsl:when>
      		<xsl:when test="$myparam.upper='DPR'"><xsl:value-of select="$myparam"/> (dozen pair)</xsl:when>
      		<xsl:when test="$myparam.upper='DPT'"><xsl:value-of select="$myparam"/> (displacement tonnage)</xsl:when>
      		<xsl:when test="$myparam.upper='DRA'"><xsl:value-of select="$myparam"/> (dram (US))</xsl:when>
      		<xsl:when test="$myparam.upper='DRI'"><xsl:value-of select="$myparam"/> (dram (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='DRL'"><xsl:value-of select="$myparam"/> (dozen roll)</xsl:when>
      		<xsl:when test="$myparam.upper='DT'"><xsl:value-of select="$myparam"/> (dry ton)</xsl:when>
      		<xsl:when test="$myparam.upper='DTN'"><xsl:value-of select="$myparam"/> (decitonne)</xsl:when>
      		<xsl:when test="$myparam.upper='DWT'"><xsl:value-of select="$myparam"/> (pennyweight)</xsl:when>
      		<xsl:when test="$myparam.upper='DZN'"><xsl:value-of select="$myparam"/> (dozen)</xsl:when>
      		<xsl:when test="$myparam.upper='DZP'"><xsl:value-of select="$myparam"/> (dozen pack)</xsl:when>
      		<xsl:when test="$myparam.upper='E01'"><xsl:value-of select="$myparam"/> (newton per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='E07'"><xsl:value-of select="$myparam"/> (megawatt hour per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E08'"><xsl:value-of select="$myparam"/> (megawatt per hertz)</xsl:when>
      		<xsl:when test="$myparam.upper='E09'"><xsl:value-of select="$myparam"/> (milliampere hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E10'"><xsl:value-of select="$myparam"/> (degree day)</xsl:when>
      		<xsl:when test="$myparam.upper='E12'"><xsl:value-of select="$myparam"/> (mille)</xsl:when>
      		<xsl:when test="$myparam.upper='E14'"><xsl:value-of select="$myparam"/> (kilocalorie (international table))</xsl:when>
      		<xsl:when test="$myparam.upper='E15'"><xsl:value-of select="$myparam"/> (kilocalorie (thermochemical) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E16'"><xsl:value-of select="$myparam"/> (million Btu(IT) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E17'"><xsl:value-of select="$myparam"/> (cubic foot per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E18'"><xsl:value-of select="$myparam"/> (tonne per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E19'"><xsl:value-of select="$myparam"/> (ping)</xsl:when>
      		<xsl:when test="$myparam.upper='E20'"><xsl:value-of select="$myparam"/> (megabit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E21'"><xsl:value-of select="$myparam"/> (shares)</xsl:when>
      		<xsl:when test="$myparam.upper='E22'"><xsl:value-of select="$myparam"/> (TEU)</xsl:when>
      		<xsl:when test="$myparam.upper='E23'"><xsl:value-of select="$myparam"/> (tyre)</xsl:when>
      		<xsl:when test="$myparam.upper='E25'"><xsl:value-of select="$myparam"/> (active unit)</xsl:when>
      		<xsl:when test="$myparam.upper='E27'"><xsl:value-of select="$myparam"/> (dose)</xsl:when>
      		<xsl:when test="$myparam.upper='E28'"><xsl:value-of select="$myparam"/> (air dry ton)</xsl:when>
      		<xsl:when test="$myparam.upper='E30'"><xsl:value-of select="$myparam"/> (strand)</xsl:when>
      		<xsl:when test="$myparam.upper='E31'"><xsl:value-of select="$myparam"/> (square metre per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='E32'"><xsl:value-of select="$myparam"/> (litre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E33'"><xsl:value-of select="$myparam"/> (foot per thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='E34'"><xsl:value-of select="$myparam"/> (gigabyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E35'"><xsl:value-of select="$myparam"/> (terabyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E36'"><xsl:value-of select="$myparam"/> (petabyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E37'"><xsl:value-of select="$myparam"/> (pixel)</xsl:when>
      		<xsl:when test="$myparam.upper='E38'"><xsl:value-of select="$myparam"/> (megapixel)</xsl:when>
      		<xsl:when test="$myparam.upper='E39'"><xsl:value-of select="$myparam"/> (dots per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='E4'"><xsl:value-of select="$myparam"/> (gross kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='E40'"><xsl:value-of select="$myparam"/> (part per hundred thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='E41'"><xsl:value-of select="$myparam"/> (kilogram-force per square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='E42'"><xsl:value-of select="$myparam"/> (kilogram-force per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='E43'"><xsl:value-of select="$myparam"/> (joule per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='E44'"><xsl:value-of select="$myparam"/> (kilogram-force metre per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='E45'"><xsl:value-of select="$myparam"/> (milliohm)</xsl:when>
      		<xsl:when test="$myparam.upper='E46'"><xsl:value-of select="$myparam"/> (kilowatt hour per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E47'"><xsl:value-of select="$myparam"/> (kilowatt hour per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='E48'"><xsl:value-of select="$myparam"/> (service unit)</xsl:when>
      		<xsl:when test="$myparam.upper='E49'"><xsl:value-of select="$myparam"/> (working day)</xsl:when>
      		<xsl:when test="$myparam.upper='E50'"><xsl:value-of select="$myparam"/> (accounting unit)</xsl:when>
      		<xsl:when test="$myparam.upper='E51'"><xsl:value-of select="$myparam"/> (job)</xsl:when>
      		<xsl:when test="$myparam.upper='E52'"><xsl:value-of select="$myparam"/> (run foot)</xsl:when>
      		<xsl:when test="$myparam.upper='E53'"><xsl:value-of select="$myparam"/> (test)</xsl:when>
      		<xsl:when test="$myparam.upper='E54'"><xsl:value-of select="$myparam"/> (trip)</xsl:when>
      		<xsl:when test="$myparam.upper='E55'"><xsl:value-of select="$myparam"/> (use)</xsl:when>
      		<xsl:when test="$myparam.upper='E56'"><xsl:value-of select="$myparam"/> (well)</xsl:when>
      		<xsl:when test="$myparam.upper='E57'"><xsl:value-of select="$myparam"/> (zone)</xsl:when>
      		<xsl:when test="$myparam.upper='E58'"><xsl:value-of select="$myparam"/> (exabit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E59'"><xsl:value-of select="$myparam"/> (exbibyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E60'"><xsl:value-of select="$myparam"/> (pebibyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E61'"><xsl:value-of select="$myparam"/> (tebibyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E62'"><xsl:value-of select="$myparam"/> (gibibyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E63'"><xsl:value-of select="$myparam"/> (mebibyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E64'"><xsl:value-of select="$myparam"/> (kibibyte)</xsl:when>
      		<xsl:when test="$myparam.upper='E65'"><xsl:value-of select="$myparam"/> (exbibit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E66'"><xsl:value-of select="$myparam"/> (exbibit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E67'"><xsl:value-of select="$myparam"/> (exbibit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E68'"><xsl:value-of select="$myparam"/> (gigabyte per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E69'"><xsl:value-of select="$myparam"/> (gibibit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E70'"><xsl:value-of select="$myparam"/> (gibibit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E71'"><xsl:value-of select="$myparam"/> (gibibit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E72'"><xsl:value-of select="$myparam"/> (kibibit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E73'"><xsl:value-of select="$myparam"/> (kibibit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E74'"><xsl:value-of select="$myparam"/> (kibibit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E75'"><xsl:value-of select="$myparam"/> (mebibit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E76'"><xsl:value-of select="$myparam"/> (mebibit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E77'"><xsl:value-of select="$myparam"/> (mebibit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E78'"><xsl:value-of select="$myparam"/> (petabit)</xsl:when>
      		<xsl:when test="$myparam.upper='E79'"><xsl:value-of select="$myparam"/> (petabit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E80'"><xsl:value-of select="$myparam"/> (pebibit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E81'"><xsl:value-of select="$myparam"/> (pebibit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E82'"><xsl:value-of select="$myparam"/> (pebibit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E83'"><xsl:value-of select="$myparam"/> (terabit)</xsl:when>
      		<xsl:when test="$myparam.upper='E84'"><xsl:value-of select="$myparam"/> (terabit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E85'"><xsl:value-of select="$myparam"/> (tebibit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E86'"><xsl:value-of select="$myparam"/> (tebibit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E87'"><xsl:value-of select="$myparam"/> (tebibit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E88'"><xsl:value-of select="$myparam"/> (bit per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E89'"><xsl:value-of select="$myparam"/> (bit per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E90'"><xsl:value-of select="$myparam"/> (reciprocal centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='E91'"><xsl:value-of select="$myparam"/> (reciprocal day)</xsl:when>
      		<xsl:when test="$myparam.upper='E92'"><xsl:value-of select="$myparam"/> (cubic decimetre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E93'"><xsl:value-of select="$myparam"/> (kilogram per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='E94'"><xsl:value-of select="$myparam"/> (kilomole per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E95'"><xsl:value-of select="$myparam"/> (mole per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E96'"><xsl:value-of select="$myparam"/> (degree per second)</xsl:when>
      		<xsl:when test="$myparam.upper='E97'"><xsl:value-of select="$myparam"/> (millimetre per degree Celcius metre)</xsl:when>
      		<xsl:when test="$myparam.upper='E98'"><xsl:value-of select="$myparam"/> (degree Celsius per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='E99'"><xsl:value-of select="$myparam"/> (hectopascal per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='EA'"><xsl:value-of select="$myparam"/> (each)</xsl:when>
      		<xsl:when test="$myparam.upper='EB'"><xsl:value-of select="$myparam"/> (electronic mail box)</xsl:when>
      		<xsl:when test="$myparam.upper='EQ'"><xsl:value-of select="$myparam"/> (equivalent gallon)</xsl:when>
      		<xsl:when test="$myparam.upper='F01'"><xsl:value-of select="$myparam"/> (bit per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='F02'"><xsl:value-of select="$myparam"/> (kelvin per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F03'"><xsl:value-of select="$myparam"/> (kilopascal per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F04'"><xsl:value-of select="$myparam"/> (millibar per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F05'"><xsl:value-of select="$myparam"/> (megapascal per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F06'"><xsl:value-of select="$myparam"/> (poise per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F07'"><xsl:value-of select="$myparam"/> (pascal per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F08'"><xsl:value-of select="$myparam"/> (milliampere per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='F10'"><xsl:value-of select="$myparam"/> (kelvin per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='F11'"><xsl:value-of select="$myparam"/> (kelvin per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='F12'"><xsl:value-of select="$myparam"/> (kelvin per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F13'"><xsl:value-of select="$myparam"/> (slug)</xsl:when>
      		<xsl:when test="$myparam.upper='F14'"><xsl:value-of select="$myparam"/> (gram per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F15'"><xsl:value-of select="$myparam"/> (kilogram per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F16'"><xsl:value-of select="$myparam"/> (milligram per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F17'"><xsl:value-of select="$myparam"/> (pound-force per foot)</xsl:when>
      		<xsl:when test="$myparam.upper='F18'"><xsl:value-of select="$myparam"/> (kilogram square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='F19'"><xsl:value-of select="$myparam"/> (kilogram square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='F20'"><xsl:value-of select="$myparam"/> (pound inch squared)</xsl:when>
      		<xsl:when test="$myparam.upper='F21'"><xsl:value-of select="$myparam"/> (pound-force inch)</xsl:when>
      		<xsl:when test="$myparam.upper='F22'"><xsl:value-of select="$myparam"/> (pound-force foot per ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='F23'"><xsl:value-of select="$myparam"/> (gram per cubic decimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='F24'"><xsl:value-of select="$myparam"/> (kilogram per kilomol)</xsl:when>
      		<xsl:when test="$myparam.upper='F25'"><xsl:value-of select="$myparam"/> (gram per hertz)</xsl:when>
      		<xsl:when test="$myparam.upper='F26'"><xsl:value-of select="$myparam"/> (gram per day)</xsl:when>
      		<xsl:when test="$myparam.upper='F27'"><xsl:value-of select="$myparam"/> (gram per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='F28'"><xsl:value-of select="$myparam"/> (gram per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='F29'"><xsl:value-of select="$myparam"/> (gram per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F30'"><xsl:value-of select="$myparam"/> (kilogram per day)</xsl:when>
      		<xsl:when test="$myparam.upper='F31'"><xsl:value-of select="$myparam"/> (kilogram per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='F32'"><xsl:value-of select="$myparam"/> (milligram per day)</xsl:when>
      		<xsl:when test="$myparam.upper='F33'"><xsl:value-of select="$myparam"/> (milligram per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='F34'"><xsl:value-of select="$myparam"/> (milligram per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F35'"><xsl:value-of select="$myparam"/> (gram per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F36'"><xsl:value-of select="$myparam"/> (gram per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F37'"><xsl:value-of select="$myparam"/> (gram per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F38'"><xsl:value-of select="$myparam"/> (gram per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F39'"><xsl:value-of select="$myparam"/> (kilogram per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F40'"><xsl:value-of select="$myparam"/> (kilogram per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F41'"><xsl:value-of select="$myparam"/> (kilogram per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F42'"><xsl:value-of select="$myparam"/> (kilogram per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F43'"><xsl:value-of select="$myparam"/> (milligram per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F44'"><xsl:value-of select="$myparam"/> (milligram per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F45'"><xsl:value-of select="$myparam"/> (milligram per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F46'"><xsl:value-of select="$myparam"/> (milligram per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F47'"><xsl:value-of select="$myparam"/> (newton per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='F48'"><xsl:value-of select="$myparam"/> (pound-force per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='F49'"><xsl:value-of select="$myparam"/> (rod [unit of distance])</xsl:when>
      		<xsl:when test="$myparam.upper='F50'"><xsl:value-of select="$myparam"/> (micrometre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F51'"><xsl:value-of select="$myparam"/> (centimetre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F52'"><xsl:value-of select="$myparam"/> (metre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F53'"><xsl:value-of select="$myparam"/> (millimetre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F54'"><xsl:value-of select="$myparam"/> (milliohm per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='F55'"><xsl:value-of select="$myparam"/> (ohm per mile (statute mile))</xsl:when>
      		<xsl:when test="$myparam.upper='F56'"><xsl:value-of select="$myparam"/> (ohm per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='F57'"><xsl:value-of select="$myparam"/> (milliampere per pound-force per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='F58'"><xsl:value-of select="$myparam"/> (reciprocal bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F59'"><xsl:value-of select="$myparam"/> (milliampere per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F60'"><xsl:value-of select="$myparam"/> (degree Celsius per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F61'"><xsl:value-of select="$myparam"/> (kelvin per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F62'"><xsl:value-of select="$myparam"/> (gram per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F63'"><xsl:value-of select="$myparam"/> (gram per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F64'"><xsl:value-of select="$myparam"/> (gram per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F65'"><xsl:value-of select="$myparam"/> (gram per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F66'"><xsl:value-of select="$myparam"/> (kilogram per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F67'"><xsl:value-of select="$myparam"/> (kilogram per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F68'"><xsl:value-of select="$myparam"/> (kilogram per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F69'"><xsl:value-of select="$myparam"/> (kilogram per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F70'"><xsl:value-of select="$myparam"/> (milligram per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F71'"><xsl:value-of select="$myparam"/> (milligram per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F72'"><xsl:value-of select="$myparam"/> (milligram per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F73'"><xsl:value-of select="$myparam"/> (milligram per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F74'"><xsl:value-of select="$myparam"/> (gram per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F75'"><xsl:value-of select="$myparam"/> (milligram per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='F76'"><xsl:value-of select="$myparam"/> (milliampere per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='F77'"><xsl:value-of select="$myparam"/> (pascal second per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F78'"><xsl:value-of select="$myparam"/> (inch of water)</xsl:when>
      		<xsl:when test="$myparam.upper='F79'"><xsl:value-of select="$myparam"/> (inch of mercury)</xsl:when>
      		<xsl:when test="$myparam.upper='F80'"><xsl:value-of select="$myparam"/> (water horse power)</xsl:when>
      		<xsl:when test="$myparam.upper='F81'"><xsl:value-of select="$myparam"/> (bar per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F82'"><xsl:value-of select="$myparam"/> (hectopascal per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F83'"><xsl:value-of select="$myparam"/> (kilopascal per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F84'"><xsl:value-of select="$myparam"/> (millibar per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F85'"><xsl:value-of select="$myparam"/> (megapascal per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F86'"><xsl:value-of select="$myparam"/> (poise per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='F87'"><xsl:value-of select="$myparam"/> (volt per litre minute)</xsl:when>
      		<xsl:when test="$myparam.upper='F88'"><xsl:value-of select="$myparam"/> (newton centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='F89'"><xsl:value-of select="$myparam"/> (newton metre per degree)</xsl:when>
      		<xsl:when test="$myparam.upper='F90'"><xsl:value-of select="$myparam"/> (newton metre per ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='F91'"><xsl:value-of select="$myparam"/> (bar litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F92'"><xsl:value-of select="$myparam"/> (bar cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F93'"><xsl:value-of select="$myparam"/> (hectopascal litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F94'"><xsl:value-of select="$myparam"/> (hectopascal cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F95'"><xsl:value-of select="$myparam"/> (millibar litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F96'"><xsl:value-of select="$myparam"/> (millibar cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F97'"><xsl:value-of select="$myparam"/> (megapascal litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F98'"><xsl:value-of select="$myparam"/> (megapascal cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='F99'"><xsl:value-of select="$myparam"/> (pascal litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='FAH'"><xsl:value-of select="$myparam"/> (degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='FAR'"><xsl:value-of select="$myparam"/> (farad)</xsl:when>
      		<xsl:when test="$myparam.upper='FBM'"><xsl:value-of select="$myparam"/> (fibre metre)</xsl:when>
      		<xsl:when test="$myparam.upper='FC'"><xsl:value-of select="$myparam"/> (thousand cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='FF'"><xsl:value-of select="$myparam"/> (hundred cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='FH'"><xsl:value-of select="$myparam"/> (micromole)</xsl:when>
      		<xsl:when test="$myparam.upper='FIT'"><xsl:value-of select="$myparam"/> (failures in time)</xsl:when>
      		<xsl:when test="$myparam.upper='FL'"><xsl:value-of select="$myparam"/> (flake ton)</xsl:when>
      		<xsl:when test="$myparam.upper='FOT'"><xsl:value-of select="$myparam"/> (foot)</xsl:when>
      		<xsl:when test="$myparam.upper='FP'"><xsl:value-of select="$myparam"/> (pound per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='FR'"><xsl:value-of select="$myparam"/> (foot per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='FS'"><xsl:value-of select="$myparam"/> (foot per second)</xsl:when>
      		<xsl:when test="$myparam.upper='FTK'"><xsl:value-of select="$myparam"/> (square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='FTQ'"><xsl:value-of select="$myparam"/> (cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='G01'"><xsl:value-of select="$myparam"/> (pascal cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='G04'"><xsl:value-of select="$myparam"/> (centimetre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G05'"><xsl:value-of select="$myparam"/> (metre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G06'"><xsl:value-of select="$myparam"/> (millimetre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G08'"><xsl:value-of select="$myparam"/> (square inch per second)</xsl:when>
      		<xsl:when test="$myparam.upper='G09'"><xsl:value-of select="$myparam"/> (square metre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G10'"><xsl:value-of select="$myparam"/> (stokes per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G11'"><xsl:value-of select="$myparam"/> (gram per cubic centimetre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G12'"><xsl:value-of select="$myparam"/> (gram per cubic decimetre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G13'"><xsl:value-of select="$myparam"/> (gram per litre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G14'"><xsl:value-of select="$myparam"/> (gram per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G15'"><xsl:value-of select="$myparam"/> (gram per millilitre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G16'"><xsl:value-of select="$myparam"/> (kilogram per cubic centimetre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G17'"><xsl:value-of select="$myparam"/> (kilogram per litre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G18'"><xsl:value-of select="$myparam"/> (kilogram per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G19'"><xsl:value-of select="$myparam"/> (newton metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='G2'"><xsl:value-of select="$myparam"/> (US gallon per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='G20'"><xsl:value-of select="$myparam"/> (pound-force foot per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='G21'"><xsl:value-of select="$myparam"/> (cup [unit of volume])</xsl:when>
      		<xsl:when test="$myparam.upper='G23'"><xsl:value-of select="$myparam"/> (peck)</xsl:when>
      		<xsl:when test="$myparam.upper='G24'"><xsl:value-of select="$myparam"/> (tablespoon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='G25'"><xsl:value-of select="$myparam"/> (teaspoon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='G26'"><xsl:value-of select="$myparam"/> (stere)</xsl:when>
      		<xsl:when test="$myparam.upper='G27'"><xsl:value-of select="$myparam"/> (cubic centimetre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G28'"><xsl:value-of select="$myparam"/> (litre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G29'"><xsl:value-of select="$myparam"/> (cubic metre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G3'"><xsl:value-of select="$myparam"/> (Imperial gallon per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='G30'"><xsl:value-of select="$myparam"/> (millilitre per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G31'"><xsl:value-of select="$myparam"/> (kilogram per cubic centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='G32'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per cubic yard)</xsl:when>
      		<xsl:when test="$myparam.upper='G33'"><xsl:value-of select="$myparam"/> (gram per cubic centimetre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G34'"><xsl:value-of select="$myparam"/> (gram per cubic decimetre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G35'"><xsl:value-of select="$myparam"/> (gram per litre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G36'"><xsl:value-of select="$myparam"/> (gram per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G37'"><xsl:value-of select="$myparam"/> (gram per millilitre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G38'"><xsl:value-of select="$myparam"/> (kilogram per cubic centimetre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G39'"><xsl:value-of select="$myparam"/> (kilogram per litre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G40'"><xsl:value-of select="$myparam"/> (kilogram per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G41'"><xsl:value-of select="$myparam"/> (square metre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G42'"><xsl:value-of select="$myparam"/> (microsiemens per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='G43'"><xsl:value-of select="$myparam"/> (microsiemens per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='G44'"><xsl:value-of select="$myparam"/> (nanosiemens per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='G45'"><xsl:value-of select="$myparam"/> (nanosiemens per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='G46'"><xsl:value-of select="$myparam"/> (stokes per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G47'"><xsl:value-of select="$myparam"/> (cubic centimetre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='G48'"><xsl:value-of select="$myparam"/> (cubic centimetre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='G49'"><xsl:value-of select="$myparam"/> (cubic centimetre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='G50'"><xsl:value-of select="$myparam"/> (gallon (US) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='G51'"><xsl:value-of select="$myparam"/> (litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='G52'"><xsl:value-of select="$myparam"/> (cubic metre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='G53'"><xsl:value-of select="$myparam"/> (cubic metre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='G54'"><xsl:value-of select="$myparam"/> (millilitre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='G55'"><xsl:value-of select="$myparam"/> (millilitre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='G56'"><xsl:value-of select="$myparam"/> (cubic inch per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='G57'"><xsl:value-of select="$myparam"/> (cubic inch per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='G58'"><xsl:value-of select="$myparam"/> (cubic inch per second)</xsl:when>
      		<xsl:when test="$myparam.upper='G59'"><xsl:value-of select="$myparam"/> (milliampere per litre minute)</xsl:when>
      		<xsl:when test="$myparam.upper='G60'"><xsl:value-of select="$myparam"/> (volt per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G61'"><xsl:value-of select="$myparam"/> (cubic centimetre per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G62'"><xsl:value-of select="$myparam"/> (cubic centimetre per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G63'"><xsl:value-of select="$myparam"/> (cubic centimetre per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G64'"><xsl:value-of select="$myparam"/> (cubic centimetre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G65'"><xsl:value-of select="$myparam"/> (litre per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G66'"><xsl:value-of select="$myparam"/> (litre per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G67'"><xsl:value-of select="$myparam"/> (litre per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G68'"><xsl:value-of select="$myparam"/> (litre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G69'"><xsl:value-of select="$myparam"/> (cubic metre per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G70'"><xsl:value-of select="$myparam"/> (cubic metre per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G71'"><xsl:value-of select="$myparam"/> (cubic metre per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G72'"><xsl:value-of select="$myparam"/> (cubic metre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G73'"><xsl:value-of select="$myparam"/> (millilitre per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G74'"><xsl:value-of select="$myparam"/> (millilitre per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G75'"><xsl:value-of select="$myparam"/> (millilitre per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G76'"><xsl:value-of select="$myparam"/> (millilitre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='G77'"><xsl:value-of select="$myparam"/> (millimetre to the fourth power)</xsl:when>
      		<xsl:when test="$myparam.upper='G78'"><xsl:value-of select="$myparam"/> (cubic centimetre per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G79'"><xsl:value-of select="$myparam"/> (cubic centimetre per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G80'"><xsl:value-of select="$myparam"/> (cubic centimetre per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G81'"><xsl:value-of select="$myparam"/> (cubic centimetre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G82'"><xsl:value-of select="$myparam"/> (litre per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G83'"><xsl:value-of select="$myparam"/> (litre per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G84'"><xsl:value-of select="$myparam"/> (litre per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G85'"><xsl:value-of select="$myparam"/> (litre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G86'"><xsl:value-of select="$myparam"/> (cubic metre per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G87'"><xsl:value-of select="$myparam"/> (cubic metre per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G88'"><xsl:value-of select="$myparam"/> (cubic metre per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G89'"><xsl:value-of select="$myparam"/> (cubic metre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G90'"><xsl:value-of select="$myparam"/> (millilitre per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G91'"><xsl:value-of select="$myparam"/> (millilitre per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G92'"><xsl:value-of select="$myparam"/> (millilitre per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G93'"><xsl:value-of select="$myparam"/> (millilitre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G94'"><xsl:value-of select="$myparam"/> (cubic centimetre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G95'"><xsl:value-of select="$myparam"/> (litre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G96'"><xsl:value-of select="$myparam"/> (cubic metre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G97'"><xsl:value-of select="$myparam"/> (millilitre per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='G98'"><xsl:value-of select="$myparam"/> (microhenry per kiloohm)</xsl:when>
      		<xsl:when test="$myparam.upper='G99'"><xsl:value-of select="$myparam"/> (microhenry per ohm)</xsl:when>
      		<xsl:when test="$myparam.upper='GB'"><xsl:value-of select="$myparam"/> (gallon (US) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='GBQ'"><xsl:value-of select="$myparam"/> (gigabecquerel)</xsl:when>
      		<xsl:when test="$myparam.upper='GDW'"><xsl:value-of select="$myparam"/> (gram, dry weight)</xsl:when>
      		<xsl:when test="$myparam.upper='GE'"><xsl:value-of select="$myparam"/> (pound per gallon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='GF'"><xsl:value-of select="$myparam"/> (gram per metre (gram per 100 centimetres))</xsl:when>
      		<xsl:when test="$myparam.upper='GFI'"><xsl:value-of select="$myparam"/> (gram of fissile isotope)</xsl:when>
      		<xsl:when test="$myparam.upper='GGR'"><xsl:value-of select="$myparam"/> (great gross)</xsl:when>
      		<xsl:when test="$myparam.upper='GIA'"><xsl:value-of select="$myparam"/> (gill (US))</xsl:when>
      		<xsl:when test="$myparam.upper='GIC'"><xsl:value-of select="$myparam"/> (gram, including container)</xsl:when>
      		<xsl:when test="$myparam.upper='GII'"><xsl:value-of select="$myparam"/> (gill (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='GIP'"><xsl:value-of select="$myparam"/> (gram, including inner packaging)</xsl:when>
      		<xsl:when test="$myparam.upper='GJ'"><xsl:value-of select="$myparam"/> (gram per millilitre)</xsl:when>
      		<xsl:when test="$myparam.upper='GL'"><xsl:value-of select="$myparam"/> (gram per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='GLD'"><xsl:value-of select="$myparam"/> (dry gallon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='GLI'"><xsl:value-of select="$myparam"/> (gallon (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='GLL'"><xsl:value-of select="$myparam"/> (gallon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='GM'"><xsl:value-of select="$myparam"/> (gram per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='GO'"><xsl:value-of select="$myparam"/> (milligram per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='GP'"><xsl:value-of select="$myparam"/> (milligram per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='GQ'"><xsl:value-of select="$myparam"/> (microgram per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='GRM'"><xsl:value-of select="$myparam"/> (gram)</xsl:when>
      		<xsl:when test="$myparam.upper='GRN'"><xsl:value-of select="$myparam"/> (grain)</xsl:when>
      		<xsl:when test="$myparam.upper='GRO'"><xsl:value-of select="$myparam"/> (gross)</xsl:when>
      		<xsl:when test="$myparam.upper='GV'"><xsl:value-of select="$myparam"/> (gigajoule)</xsl:when>
      		<xsl:when test="$myparam.upper='GWH'"><xsl:value-of select="$myparam"/> (gigawatt hour)</xsl:when>
      		<xsl:when test="$myparam.upper='H03'"><xsl:value-of select="$myparam"/> (henry per kiloohm)</xsl:when>
      		<xsl:when test="$myparam.upper='H04'"><xsl:value-of select="$myparam"/> (henry per ohm)</xsl:when>
      		<xsl:when test="$myparam.upper='H05'"><xsl:value-of select="$myparam"/> (millihenry per kiloohm)</xsl:when>
      		<xsl:when test="$myparam.upper='H06'"><xsl:value-of select="$myparam"/> (millihenry per ohm)</xsl:when>
      		<xsl:when test="$myparam.upper='H07'"><xsl:value-of select="$myparam"/> (pascal second per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='H08'"><xsl:value-of select="$myparam"/> (microbecquerel)</xsl:when>
      		<xsl:when test="$myparam.upper='H09'"><xsl:value-of select="$myparam"/> (reciprocal year)</xsl:when>
      		<xsl:when test="$myparam.upper='H10'"><xsl:value-of select="$myparam"/> (reciprocal hour)</xsl:when>
      		<xsl:when test="$myparam.upper='H11'"><xsl:value-of select="$myparam"/> (reciprocal month)</xsl:when>
      		<xsl:when test="$myparam.upper='H12'"><xsl:value-of select="$myparam"/> (degree Celsius per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='H13'"><xsl:value-of select="$myparam"/> (degree Celsius per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='H14'"><xsl:value-of select="$myparam"/> (degree Celsius per second)</xsl:when>
      		<xsl:when test="$myparam.upper='H15'"><xsl:value-of select="$myparam"/> (square centimetre per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='H16'"><xsl:value-of select="$myparam"/> (square decametre)</xsl:when>
      		<xsl:when test="$myparam.upper='H18'"><xsl:value-of select="$myparam"/> (square hectometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H19'"><xsl:value-of select="$myparam"/> (cubic hectometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H20'"><xsl:value-of select="$myparam"/> (cubic kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H21'"><xsl:value-of select="$myparam"/> (blank)</xsl:when>
      		<xsl:when test="$myparam.upper='H22'"><xsl:value-of select="$myparam"/> (volt square inch per pound-force)</xsl:when>
      		<xsl:when test="$myparam.upper='H23'"><xsl:value-of select="$myparam"/> (volt per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='H24'"><xsl:value-of select="$myparam"/> (volt per microsecond)</xsl:when>
      		<xsl:when test="$myparam.upper='H25'"><xsl:value-of select="$myparam"/> (percent per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='H26'"><xsl:value-of select="$myparam"/> (ohm per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H27'"><xsl:value-of select="$myparam"/> (degree per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H28'"><xsl:value-of select="$myparam"/> (microfarad per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H29'"><xsl:value-of select="$myparam"/> (microgram per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='H30'"><xsl:value-of select="$myparam"/> (square micrometre (square micron))</xsl:when>
      		<xsl:when test="$myparam.upper='H31'"><xsl:value-of select="$myparam"/> (ampere per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='H32'"><xsl:value-of select="$myparam"/> (ampere squared second)</xsl:when>
      		<xsl:when test="$myparam.upper='H33'"><xsl:value-of select="$myparam"/> (farad per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H34'"><xsl:value-of select="$myparam"/> (hertz metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H35'"><xsl:value-of select="$myparam"/> (kelvin metre per watt)</xsl:when>
      		<xsl:when test="$myparam.upper='H36'"><xsl:value-of select="$myparam"/> (megaohm per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H37'"><xsl:value-of select="$myparam"/> (megaohm per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H38'"><xsl:value-of select="$myparam"/> (megaampere)</xsl:when>
      		<xsl:when test="$myparam.upper='H39'"><xsl:value-of select="$myparam"/> (megahertz kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H40'"><xsl:value-of select="$myparam"/> (newton per ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='H41'"><xsl:value-of select="$myparam"/> (newton metre watt to the power minus 0,5)</xsl:when>
      		<xsl:when test="$myparam.upper='H42'"><xsl:value-of select="$myparam"/> (pascal per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H43'"><xsl:value-of select="$myparam"/> (siemens per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='H44'"><xsl:value-of select="$myparam"/> (teraohm)</xsl:when>
      		<xsl:when test="$myparam.upper='H45'"><xsl:value-of select="$myparam"/> (volt second per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H46'"><xsl:value-of select="$myparam"/> (volt per second)</xsl:when>
      		<xsl:when test="$myparam.upper='H47'"><xsl:value-of select="$myparam"/> (watt per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H48'"><xsl:value-of select="$myparam"/> (attofarad)</xsl:when>
      		<xsl:when test="$myparam.upper='H49'"><xsl:value-of select="$myparam"/> (centimetre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='H50'"><xsl:value-of select="$myparam"/> (reciprocal cubic centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='H51'"><xsl:value-of select="$myparam"/> (decibel per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H52'"><xsl:value-of select="$myparam"/> (decibel per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H53'"><xsl:value-of select="$myparam"/> (kilogram per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='H54'"><xsl:value-of select="$myparam"/> (kilogram per cubic decimetre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='H55'"><xsl:value-of select="$myparam"/> (kilogram per cubic decimetre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='H56'"><xsl:value-of select="$myparam"/> (kilogram per square metre second)</xsl:when>
      		<xsl:when test="$myparam.upper='H57'"><xsl:value-of select="$myparam"/> (inch per two pi radiant)</xsl:when>
      		<xsl:when test="$myparam.upper='H58'"><xsl:value-of select="$myparam"/> (metre per volt second)</xsl:when>
      		<xsl:when test="$myparam.upper='H59'"><xsl:value-of select="$myparam"/> (square metre per newton)</xsl:when>
      		<xsl:when test="$myparam.upper='H60'"><xsl:value-of select="$myparam"/> (cubic metre per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H61'"><xsl:value-of select="$myparam"/> (millisiemens per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='H62'"><xsl:value-of select="$myparam"/> (millivolt per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='H63'"><xsl:value-of select="$myparam"/> (milligram per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='H64'"><xsl:value-of select="$myparam"/> (milligram per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='H65'"><xsl:value-of select="$myparam"/> (millilitre per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H66'"><xsl:value-of select="$myparam"/> (millimetre per year)</xsl:when>
      		<xsl:when test="$myparam.upper='H67'"><xsl:value-of select="$myparam"/> (millimetre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='H68'"><xsl:value-of select="$myparam"/> (millimole per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='H69'"><xsl:value-of select="$myparam"/> (picopascal per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H70'"><xsl:value-of select="$myparam"/> (picosecond)</xsl:when>
      		<xsl:when test="$myparam.upper='H71'"><xsl:value-of select="$myparam"/> (percent per month)</xsl:when>
      		<xsl:when test="$myparam.upper='H72'"><xsl:value-of select="$myparam"/> (percent per hectobar)</xsl:when>
      		<xsl:when test="$myparam.upper='H73'"><xsl:value-of select="$myparam"/> (percent per decakelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='H74'"><xsl:value-of select="$myparam"/> (watt per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='H75'"><xsl:value-of select="$myparam"/> (decapascal)</xsl:when>
      		<xsl:when test="$myparam.upper='H76'"><xsl:value-of select="$myparam"/> (gram per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='H77'"><xsl:value-of select="$myparam"/> (module width)</xsl:when>
      		<xsl:when test="$myparam.upper='H79'"><xsl:value-of select="$myparam"/> (French gauge)</xsl:when>
      		<xsl:when test="$myparam.upper='H80'"><xsl:value-of select="$myparam"/> (rack unit)</xsl:when>
      		<xsl:when test="$myparam.upper='H81'"><xsl:value-of select="$myparam"/> (millimetre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='H82'"><xsl:value-of select="$myparam"/> (big point)</xsl:when>
      		<xsl:when test="$myparam.upper='H83'"><xsl:value-of select="$myparam"/> (litre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='H84'"><xsl:value-of select="$myparam"/> (gram millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='H85'"><xsl:value-of select="$myparam"/> (reciprocal week)</xsl:when>
      		<xsl:when test="$myparam.upper='H87'"><xsl:value-of select="$myparam"/> (piece)</xsl:when>
      		<xsl:when test="$myparam.upper='H88'"><xsl:value-of select="$myparam"/> (megaohm kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='H89'"><xsl:value-of select="$myparam"/> (percent per ohm)</xsl:when>
      		<xsl:when test="$myparam.upper='H90'"><xsl:value-of select="$myparam"/> (percent per degree)</xsl:when>
      		<xsl:when test="$myparam.upper='H91'"><xsl:value-of select="$myparam"/> (percent per ten thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='H92'"><xsl:value-of select="$myparam"/> (percent per one hundred thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='H93'"><xsl:value-of select="$myparam"/> (percent per hundred)</xsl:when>
      		<xsl:when test="$myparam.upper='H94'"><xsl:value-of select="$myparam"/> (percent per thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='H95'"><xsl:value-of select="$myparam"/> (percent per volt)</xsl:when>
      		<xsl:when test="$myparam.upper='H96'"><xsl:value-of select="$myparam"/> (percent per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='H98'"><xsl:value-of select="$myparam"/> (percent per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='H99'"><xsl:value-of select="$myparam"/> (percent per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='HA'"><xsl:value-of select="$myparam"/> (hank)</xsl:when>
      		<xsl:when test="$myparam.upper='HBA'"><xsl:value-of select="$myparam"/> (hectobar)</xsl:when>
      		<xsl:when test="$myparam.upper='HBX'"><xsl:value-of select="$myparam"/> (hundred boxes)</xsl:when>
      		<xsl:when test="$myparam.upper='HC'"><xsl:value-of select="$myparam"/> (hundred count)</xsl:when>
      		<xsl:when test="$myparam.upper='HDW'"><xsl:value-of select="$myparam"/> (hundred kilogram, dry weight)</xsl:when>
      		<xsl:when test="$myparam.upper='HEA'"><xsl:value-of select="$myparam"/> (head)</xsl:when>
      		<xsl:when test="$myparam.upper='HGM'"><xsl:value-of select="$myparam"/> (hectogram)</xsl:when>
      		<xsl:when test="$myparam.upper='HH'"><xsl:value-of select="$myparam"/> (hundred cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='HIU'"><xsl:value-of select="$myparam"/> (hundred international unit)</xsl:when>
      		<xsl:when test="$myparam.upper='HKM'"><xsl:value-of select="$myparam"/> (hundred kilogram, net mass)</xsl:when>
      		<xsl:when test="$myparam.upper='HLT'"><xsl:value-of select="$myparam"/> (hectolitre)</xsl:when>
      		<xsl:when test="$myparam.upper='HM'"><xsl:value-of select="$myparam"/> (mile per hour (statute mile))</xsl:when>
      		<xsl:when test="$myparam.upper='HMQ'"><xsl:value-of select="$myparam"/> (million cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='HMT'"><xsl:value-of select="$myparam"/> (hectometre)</xsl:when>
      		<xsl:when test="$myparam.upper='HPA'"><xsl:value-of select="$myparam"/> (hectolitre of pure alcohol)</xsl:when>
      		<xsl:when test="$myparam.upper='HTZ'"><xsl:value-of select="$myparam"/> (hertz)</xsl:when>
      		<xsl:when test="$myparam.upper='HUR'"><xsl:value-of select="$myparam"/> (hour)</xsl:when>
      		<xsl:when test="$myparam.upper='IA'"><xsl:value-of select="$myparam"/> (inch pound (pound inch))</xsl:when>
      		<xsl:when test="$myparam.upper='IE'"><xsl:value-of select="$myparam"/> (person)</xsl:when>
      		<xsl:when test="$myparam.upper='INH'"><xsl:value-of select="$myparam"/> (inch)</xsl:when>
      		<xsl:when test="$myparam.upper='INK'"><xsl:value-of select="$myparam"/> (square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='INQ'"><xsl:value-of select="$myparam"/> (cubic inch)</xsl:when>
      		<xsl:when test="$myparam.upper='ISD'"><xsl:value-of select="$myparam"/> (international sugar degree)</xsl:when>
      		<xsl:when test="$myparam.upper='IU'"><xsl:value-of select="$myparam"/> (inch per second)</xsl:when>
      		<xsl:when test="$myparam.upper='IUG'"><xsl:value-of select="$myparam"/> (international unit per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='IV'"><xsl:value-of select="$myparam"/> (inch per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='J10'"><xsl:value-of select="$myparam"/> (percent per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='J12'"><xsl:value-of select="$myparam"/> (per mille per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='J13'"><xsl:value-of select="$myparam"/> (degree API)</xsl:when>
      		<xsl:when test="$myparam.upper='J14'"><xsl:value-of select="$myparam"/> (degree Baume (origin scale))</xsl:when>
      		<xsl:when test="$myparam.upper='J15'"><xsl:value-of select="$myparam"/> (degree Baume (US heavy))</xsl:when>
      		<xsl:when test="$myparam.upper='J16'"><xsl:value-of select="$myparam"/> (degree Baume (US light))</xsl:when>
      		<xsl:when test="$myparam.upper='J17'"><xsl:value-of select="$myparam"/> (degree Balling)</xsl:when>
      		<xsl:when test="$myparam.upper='J18'"><xsl:value-of select="$myparam"/> (degree Brix)</xsl:when>
      		<xsl:when test="$myparam.upper='J19'"><xsl:value-of select="$myparam"/> (degree Fahrenheit hour square foot per British thermal unit (thermochemical))</xsl:when>
      		<xsl:when test="$myparam.upper='J2'"><xsl:value-of select="$myparam"/> (joule per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='J20'"><xsl:value-of select="$myparam"/> (degree Fahrenheit per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='J21'"><xsl:value-of select="$myparam"/> (degree Fahrenheit per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='J22'"><xsl:value-of select="$myparam"/> (degree Fahrenheit hour square foot per British thermal unit (international table))</xsl:when>
      		<xsl:when test="$myparam.upper='J23'"><xsl:value-of select="$myparam"/> (degree Fahrenheit per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J24'"><xsl:value-of select="$myparam"/> (degree Fahrenheit per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J25'"><xsl:value-of select="$myparam"/> (degree Fahrenheit per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J26'"><xsl:value-of select="$myparam"/> (reciprocal degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J27'"><xsl:value-of select="$myparam"/> (degree Oechsle)</xsl:when>
      		<xsl:when test="$myparam.upper='J28'"><xsl:value-of select="$myparam"/> (degree Rankine per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J29'"><xsl:value-of select="$myparam"/> (degree Rankine per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J30'"><xsl:value-of select="$myparam"/> (degree Rankine per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J31'"><xsl:value-of select="$myparam"/> (degree Twaddell)</xsl:when>
      		<xsl:when test="$myparam.upper='J32'"><xsl:value-of select="$myparam"/> (micropoise)</xsl:when>
      		<xsl:when test="$myparam.upper='J33'"><xsl:value-of select="$myparam"/> (microgram per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='J34'"><xsl:value-of select="$myparam"/> (microgram per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='J35'"><xsl:value-of select="$myparam"/> (microgram per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='J36'"><xsl:value-of select="$myparam"/> (microlitre per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='J38'"><xsl:value-of select="$myparam"/> (baud)</xsl:when>
      		<xsl:when test="$myparam.upper='J39'"><xsl:value-of select="$myparam"/> (British thermal unit (mean))</xsl:when>
      		<xsl:when test="$myparam.upper='J40'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) foot per hour square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J41'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) inch per hour square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J42'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) inch per second square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J43'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per pound degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J44'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J45'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J46'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) foot per hour square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J47'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J48'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) inch per hour square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J49'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) inch per second square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J50'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per pound degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='J51'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J52'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J53'"><xsl:value-of select="$myparam"/> (coulomb square metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='J54'"><xsl:value-of select="$myparam"/> (megabaud)</xsl:when>
      		<xsl:when test="$myparam.upper='J55'"><xsl:value-of select="$myparam"/> (watt second)</xsl:when>
      		<xsl:when test="$myparam.upper='J56'"><xsl:value-of select="$myparam"/> (bar per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='J57'"><xsl:value-of select="$myparam"/> (barrel (UK petroleum))</xsl:when>
      		<xsl:when test="$myparam.upper='J58'"><xsl:value-of select="$myparam"/> (barrel (UK petroleum) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J59'"><xsl:value-of select="$myparam"/> (barrel (UK petroleum) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='J60'"><xsl:value-of select="$myparam"/> (barrel (UK petroleum) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J61'"><xsl:value-of select="$myparam"/> (barrel (UK petroleum) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J62'"><xsl:value-of select="$myparam"/> (barrel (US petroleum) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J63'"><xsl:value-of select="$myparam"/> (barrel (US petroleum) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J64'"><xsl:value-of select="$myparam"/> (bushel (UK) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='J65'"><xsl:value-of select="$myparam"/> (bushel (UK) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J66'"><xsl:value-of select="$myparam"/> (bushel (UK) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J67'"><xsl:value-of select="$myparam"/> (bushel (UK) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J68'"><xsl:value-of select="$myparam"/> (bushel (US dry) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='J69'"><xsl:value-of select="$myparam"/> (bushel (US dry) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J70'"><xsl:value-of select="$myparam"/> (bushel (US dry) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J71'"><xsl:value-of select="$myparam"/> (bushel (US dry) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J72'"><xsl:value-of select="$myparam"/> (centinewton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='J73'"><xsl:value-of select="$myparam"/> (centipoise per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='J74'"><xsl:value-of select="$myparam"/> (centipoise per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='J75'"><xsl:value-of select="$myparam"/> (calorie (mean))</xsl:when>
      		<xsl:when test="$myparam.upper='J76'"><xsl:value-of select="$myparam"/> (calorie (international table) per gram degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='J78'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per centimetre second degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='J79'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per gram degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='J81'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J82'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J83'"><xsl:value-of select="$myparam"/> (clo)</xsl:when>
      		<xsl:when test="$myparam.upper='J84'"><xsl:value-of select="$myparam"/> (centimetre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='J85'"><xsl:value-of select="$myparam"/> (centimetre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='J87'"><xsl:value-of select="$myparam"/> (cubic centimetre per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='J90'"><xsl:value-of select="$myparam"/> (cubic decimetre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='J91'"><xsl:value-of select="$myparam"/> (cubic decimetre per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='J92'"><xsl:value-of select="$myparam"/> (cubic decimetre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J93'"><xsl:value-of select="$myparam"/> (cubic decimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J95'"><xsl:value-of select="$myparam"/> (ounce (UK fluid) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='J96'"><xsl:value-of select="$myparam"/> (ounce (UK fluid) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='J97'"><xsl:value-of select="$myparam"/> (ounce (UK fluid) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='J98'"><xsl:value-of select="$myparam"/> (ounce (UK fluid) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='J99'"><xsl:value-of select="$myparam"/> (ounce (US fluid) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='JE'"><xsl:value-of select="$myparam"/> (joule per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='JK'"><xsl:value-of select="$myparam"/> (megajoule per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='JM'"><xsl:value-of select="$myparam"/> (megajoule per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='JNT'"><xsl:value-of select="$myparam"/> (pipeline joint)</xsl:when>
      		<xsl:when test="$myparam.upper='JOU'"><xsl:value-of select="$myparam"/> (joule)</xsl:when>
      		<xsl:when test="$myparam.upper='JPS'"><xsl:value-of select="$myparam"/> (hundred metre)</xsl:when>
      		<xsl:when test="$myparam.upper='JWL'"><xsl:value-of select="$myparam"/> (number of jewels)</xsl:when>
      		<xsl:when test="$myparam.upper='K1'"><xsl:value-of select="$myparam"/> (kilowatt demand)</xsl:when>
      		<xsl:when test="$myparam.upper='K10'"><xsl:value-of select="$myparam"/> (ounce (US fluid) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K11'"><xsl:value-of select="$myparam"/> (ounce (US fluid) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K12'"><xsl:value-of select="$myparam"/> (ounce (US fluid) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K13'"><xsl:value-of select="$myparam"/> (foot per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K14'"><xsl:value-of select="$myparam"/> (foot per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K15'"><xsl:value-of select="$myparam"/> (foot pound-force per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K16'"><xsl:value-of select="$myparam"/> (foot pound-force per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K17'"><xsl:value-of select="$myparam"/> (foot per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K18'"><xsl:value-of select="$myparam"/> (foot per second degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K19'"><xsl:value-of select="$myparam"/> (foot per second psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K2'"><xsl:value-of select="$myparam"/> (kilovolt ampere reactive demand)</xsl:when>
      		<xsl:when test="$myparam.upper='K20'"><xsl:value-of select="$myparam"/> (reciprocal cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='K21'"><xsl:value-of select="$myparam"/> (cubic foot per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K22'"><xsl:value-of select="$myparam"/> (cubic foot per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K23'"><xsl:value-of select="$myparam"/> (cubic foot per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K26'"><xsl:value-of select="$myparam"/> (gallon (UK) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K27'"><xsl:value-of select="$myparam"/> (gallon (UK) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K28'"><xsl:value-of select="$myparam"/> (gallon (UK) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K3'"><xsl:value-of select="$myparam"/> (kilovolt ampere reactive hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K30'"><xsl:value-of select="$myparam"/> (gallon (US liquid) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K31'"><xsl:value-of select="$myparam"/> (gram-force per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='K32'"><xsl:value-of select="$myparam"/> (gill (UK) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K33'"><xsl:value-of select="$myparam"/> (gill (UK) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K34'"><xsl:value-of select="$myparam"/> (gill (UK) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K35'"><xsl:value-of select="$myparam"/> (gill (UK) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K36'"><xsl:value-of select="$myparam"/> (gill (US) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K37'"><xsl:value-of select="$myparam"/> (gill (US) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K38'"><xsl:value-of select="$myparam"/> (gill (US) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K39'"><xsl:value-of select="$myparam"/> (gill (US) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K40'"><xsl:value-of select="$myparam"/> (standard acceleration of free fall)</xsl:when>
      		<xsl:when test="$myparam.upper='K41'"><xsl:value-of select="$myparam"/> (grain per gallon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='K42'"><xsl:value-of select="$myparam"/> (horsepower (boiler))</xsl:when>
      		<xsl:when test="$myparam.upper='K43'"><xsl:value-of select="$myparam"/> (horsepower (electric))</xsl:when>
      		<xsl:when test="$myparam.upper='K45'"><xsl:value-of select="$myparam"/> (inch per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K46'"><xsl:value-of select="$myparam"/> (inch per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K47'"><xsl:value-of select="$myparam"/> (inch per second degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K48'"><xsl:value-of select="$myparam"/> (inch per second psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K49'"><xsl:value-of select="$myparam"/> (reciprocal cubic inch)</xsl:when>
      		<xsl:when test="$myparam.upper='K50'"><xsl:value-of select="$myparam"/> (kilobaud)</xsl:when>
      		<xsl:when test="$myparam.upper='K51'"><xsl:value-of select="$myparam"/> (kilocalorie (mean))</xsl:when>
      		<xsl:when test="$myparam.upper='K52'"><xsl:value-of select="$myparam"/> (kilocalorie (international table) per hour metre degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='K53'"><xsl:value-of select="$myparam"/> (kilocalorie (thermochemical))</xsl:when>
      		<xsl:when test="$myparam.upper='K54'"><xsl:value-of select="$myparam"/> (kilocalorie (thermochemical) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K55'"><xsl:value-of select="$myparam"/> (kilocalorie (thermochemical) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K58'"><xsl:value-of select="$myparam"/> (kilomole per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K59'"><xsl:value-of select="$myparam"/> (kilomole per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='K6'"><xsl:value-of select="$myparam"/> (kilolitre)</xsl:when>
      		<xsl:when test="$myparam.upper='K60'"><xsl:value-of select="$myparam"/> (kilomole per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='K61'"><xsl:value-of select="$myparam"/> (kilomole per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K62'"><xsl:value-of select="$myparam"/> (litre per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='K63'"><xsl:value-of select="$myparam"/> (reciprocal litre)</xsl:when>
      		<xsl:when test="$myparam.upper='K64'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K65'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='K66'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K67'"><xsl:value-of select="$myparam"/> (pound per foot hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K68'"><xsl:value-of select="$myparam"/> (pound per foot second)</xsl:when>
      		<xsl:when test="$myparam.upper='K69'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per cubic foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K70'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per cubic foot psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K71'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per gallon (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='K73'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per hour degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K74'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per hour psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K75'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per cubic inch degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K76'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per cubic inch psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K77'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K78'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K79'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per minute degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K80'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per minute psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K81'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K82'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per second degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K83'"><xsl:value-of select="$myparam"/> (pound (avoirdupois) per second psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K84'"><xsl:value-of select="$myparam"/> (pound per cubic yard)</xsl:when>
      		<xsl:when test="$myparam.upper='K85'"><xsl:value-of select="$myparam"/> (pound-force per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='K86'"><xsl:value-of select="$myparam"/> (pound-force per square inch degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='K87'"><xsl:value-of select="$myparam"/> (psi cubic inch per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K88'"><xsl:value-of select="$myparam"/> (psi litre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K89'"><xsl:value-of select="$myparam"/> (psi cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K90'"><xsl:value-of select="$myparam"/> (psi cubic yard per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K91'"><xsl:value-of select="$myparam"/> (pound-force second per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='K92'"><xsl:value-of select="$myparam"/> (pound-force second per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='K93'"><xsl:value-of select="$myparam"/> (reciprocal psi)</xsl:when>
      		<xsl:when test="$myparam.upper='K94'"><xsl:value-of select="$myparam"/> (quart (UK liquid) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K95'"><xsl:value-of select="$myparam"/> (quart (UK liquid) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='K96'"><xsl:value-of select="$myparam"/> (quart (UK liquid) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='K97'"><xsl:value-of select="$myparam"/> (quart (UK liquid) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='K98'"><xsl:value-of select="$myparam"/> (quart (US liquid) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='K99'"><xsl:value-of select="$myparam"/> (quart (US liquid) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='KA'"><xsl:value-of select="$myparam"/> (cake)</xsl:when>
      		<xsl:when test="$myparam.upper='KAT'"><xsl:value-of select="$myparam"/> (katal)</xsl:when>
      		<xsl:when test="$myparam.upper='KB'"><xsl:value-of select="$myparam"/> (kilocharacter)</xsl:when>
      		<xsl:when test="$myparam.upper='KBA'"><xsl:value-of select="$myparam"/> (kilobar)</xsl:when>
      		<xsl:when test="$myparam.upper='KCC'"><xsl:value-of select="$myparam"/> (kilogram of choline chloride)</xsl:when>
      		<xsl:when test="$myparam.upper='KDW'"><xsl:value-of select="$myparam"/> (kilogram drained net weight)</xsl:when>
      		<xsl:when test="$myparam.upper='KEL'"><xsl:value-of select="$myparam"/> (kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='KGM'"><xsl:value-of select="$myparam"/> (kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='KGS'"><xsl:value-of select="$myparam"/> (kilogram per second)</xsl:when>
      		<xsl:when test="$myparam.upper='KHY'"><xsl:value-of select="$myparam"/> (kilogram of hydrogen peroxide)</xsl:when>
      		<xsl:when test="$myparam.upper='KHZ'"><xsl:value-of select="$myparam"/> (kilohertz)</xsl:when>
      		<xsl:when test="$myparam.upper='KI'"><xsl:value-of select="$myparam"/> (kilogram per millimetre width)</xsl:when>
      		<xsl:when test="$myparam.upper='KIC'"><xsl:value-of select="$myparam"/> (kilogram, including container)</xsl:when>
      		<xsl:when test="$myparam.upper='KIP'"><xsl:value-of select="$myparam"/> (kilogram, including inner packaging)</xsl:when>
      		<xsl:when test="$myparam.upper='KJ'"><xsl:value-of select="$myparam"/> (kilosegment)</xsl:when>
      		<xsl:when test="$myparam.upper='KJO'"><xsl:value-of select="$myparam"/> (kilojoule)</xsl:when>
      		<xsl:when test="$myparam.upper='KL'"><xsl:value-of select="$myparam"/> (kilogram per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='KLK'"><xsl:value-of select="$myparam"/> (lactic dry material percentage)</xsl:when>
      		<xsl:when test="$myparam.upper='KLX'"><xsl:value-of select="$myparam"/> (kilolux)</xsl:when>
      		<xsl:when test="$myparam.upper='KMA'"><xsl:value-of select="$myparam"/> (kilogram of methylamine)</xsl:when>
      		<xsl:when test="$myparam.upper='KMH'"><xsl:value-of select="$myparam"/> (kilometre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='KMK'"><xsl:value-of select="$myparam"/> (square kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='KMQ'"><xsl:value-of select="$myparam"/> (kilogram per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='KMT'"><xsl:value-of select="$myparam"/> (kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='KNI'"><xsl:value-of select="$myparam"/> (kilogram of nitrogen)</xsl:when>
      		<xsl:when test="$myparam.upper='KNM'"><xsl:value-of select="$myparam"/> (kilonewton per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='KNS'"><xsl:value-of select="$myparam"/> (kilogram named substance)</xsl:when>
      		<xsl:when test="$myparam.upper='KNT'"><xsl:value-of select="$myparam"/> (knot)</xsl:when>
      		<xsl:when test="$myparam.upper='KO'"><xsl:value-of select="$myparam"/> (milliequivalence caustic potash per gram of product)</xsl:when>
      		<xsl:when test="$myparam.upper='KPA'"><xsl:value-of select="$myparam"/> (kilopascal)</xsl:when>
      		<xsl:when test="$myparam.upper='KPH'"><xsl:value-of select="$myparam"/> (kilogram of potassium hydroxide (caustic potash))</xsl:when>
      		<xsl:when test="$myparam.upper='KPO'"><xsl:value-of select="$myparam"/> (kilogram of potassium oxide)</xsl:when>
      		<xsl:when test="$myparam.upper='KPP'"><xsl:value-of select="$myparam"/> (kilogram of phosphorus pentoxide (phosphoric anhydride))</xsl:when>
      		<xsl:when test="$myparam.upper='KR'"><xsl:value-of select="$myparam"/> (kiloroentgen)</xsl:when>
      		<xsl:when test="$myparam.upper='KSD'"><xsl:value-of select="$myparam"/> (kilogram of substance 90 % dry)</xsl:when>
      		<xsl:when test="$myparam.upper='KSH'"><xsl:value-of select="$myparam"/> (kilogram of sodium hydroxide (caustic soda))</xsl:when>
      		<xsl:when test="$myparam.upper='KT'"><xsl:value-of select="$myparam"/> (kit)</xsl:when>
      		<xsl:when test="$myparam.upper='KTN'"><xsl:value-of select="$myparam"/> (kilotonne)</xsl:when>
      		<xsl:when test="$myparam.upper='KUR'"><xsl:value-of select="$myparam"/> (kilogram of uranium)</xsl:when>
      		<xsl:when test="$myparam.upper='KVA'"><xsl:value-of select="$myparam"/> (kilovolt - ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='KVR'"><xsl:value-of select="$myparam"/> (kilovar)</xsl:when>
      		<xsl:when test="$myparam.upper='KVT'"><xsl:value-of select="$myparam"/> (kilovolt)</xsl:when>
      		<xsl:when test="$myparam.upper='KW'"><xsl:value-of select="$myparam"/> (kilogram per millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='KWH'"><xsl:value-of select="$myparam"/> (kilowatt hour)</xsl:when>
      		<xsl:when test="$myparam.upper='KWN'"><xsl:value-of select="$myparam"/> (Kilowatt hour per normalized cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='KWO'"><xsl:value-of select="$myparam"/> (kilogram of tungsten trioxide)</xsl:when>
      		<xsl:when test="$myparam.upper='KWS'"><xsl:value-of select="$myparam"/> (Kilowatt hour per standard cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='KWT'"><xsl:value-of select="$myparam"/> (kilowatt)</xsl:when>
      		<xsl:when test="$myparam.upper='KX'"><xsl:value-of select="$myparam"/> (millilitre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='L10'"><xsl:value-of select="$myparam"/> (quart (US liquid) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L11'"><xsl:value-of select="$myparam"/> (quart (US liquid) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L12'"><xsl:value-of select="$myparam"/> (metre per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L13'"><xsl:value-of select="$myparam"/> (metre per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L14'"><xsl:value-of select="$myparam"/> (square metre hour degree Celsius per kilocalorie (international table))</xsl:when>
      		<xsl:when test="$myparam.upper='L15'"><xsl:value-of select="$myparam"/> (millipascal second per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L16'"><xsl:value-of select="$myparam"/> (millipascal second per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L17'"><xsl:value-of select="$myparam"/> (milligram per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L18'"><xsl:value-of select="$myparam"/> (milligram per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L19'"><xsl:value-of select="$myparam"/> (millilitre per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='L2'"><xsl:value-of select="$myparam"/> (litre per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L20'"><xsl:value-of select="$myparam"/> (reciprocal cubic millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='L21'"><xsl:value-of select="$myparam"/> (cubic millimetre per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='L23'"><xsl:value-of select="$myparam"/> (mole per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L24'"><xsl:value-of select="$myparam"/> (mole per kilogram kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L25'"><xsl:value-of select="$myparam"/> (mole per kilogram bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L26'"><xsl:value-of select="$myparam"/> (mole per litre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L27'"><xsl:value-of select="$myparam"/> (mole per litre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L28'"><xsl:value-of select="$myparam"/> (mole per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L29'"><xsl:value-of select="$myparam"/> (mole per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L30'"><xsl:value-of select="$myparam"/> (mole per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L31'"><xsl:value-of select="$myparam"/> (milliroentgen aequivalent men)</xsl:when>
      		<xsl:when test="$myparam.upper='L32'"><xsl:value-of select="$myparam"/> (nanogram per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='L33'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L34'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L35'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L36'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L37'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per gallon (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='L38'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per gallon (US))</xsl:when>
      		<xsl:when test="$myparam.upper='L39'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per cubic inch)</xsl:when>
      		<xsl:when test="$myparam.upper='L40'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois)-force)</xsl:when>
      		<xsl:when test="$myparam.upper='L41'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois)-force inch)</xsl:when>
      		<xsl:when test="$myparam.upper='L42'"><xsl:value-of select="$myparam"/> (picosiemens per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='L43'"><xsl:value-of select="$myparam"/> (peck (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='L44'"><xsl:value-of select="$myparam"/> (peck (UK) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L45'"><xsl:value-of select="$myparam"/> (peck (UK) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L46'"><xsl:value-of select="$myparam"/> (peck (UK) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L47'"><xsl:value-of select="$myparam"/> (peck (UK) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L48'"><xsl:value-of select="$myparam"/> (peck (US dry) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L49'"><xsl:value-of select="$myparam"/> (peck (US dry) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L50'"><xsl:value-of select="$myparam"/> (peck (US dry) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L51'"><xsl:value-of select="$myparam"/> (peck (US dry) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L52'"><xsl:value-of select="$myparam"/> (psi per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='L53'"><xsl:value-of select="$myparam"/> (pint (UK) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L54'"><xsl:value-of select="$myparam"/> (pint (UK) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L55'"><xsl:value-of select="$myparam"/> (pint (UK) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L56'"><xsl:value-of select="$myparam"/> (pint (UK) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L57'"><xsl:value-of select="$myparam"/> (pint (US liquid) per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L58'"><xsl:value-of select="$myparam"/> (pint (US liquid) per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L59'"><xsl:value-of select="$myparam"/> (pint (US liquid) per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L60'"><xsl:value-of select="$myparam"/> (pint (US liquid) per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L63'"><xsl:value-of select="$myparam"/> (slug per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L64'"><xsl:value-of select="$myparam"/> (slug per foot second)</xsl:when>
      		<xsl:when test="$myparam.upper='L65'"><xsl:value-of select="$myparam"/> (slug per cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='L66'"><xsl:value-of select="$myparam"/> (slug per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='L67'"><xsl:value-of select="$myparam"/> (slug per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L68'"><xsl:value-of select="$myparam"/> (slug per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L69'"><xsl:value-of select="$myparam"/> (tonne per kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L70'"><xsl:value-of select="$myparam"/> (tonne per bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L71'"><xsl:value-of select="$myparam"/> (tonne per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L72'"><xsl:value-of select="$myparam"/> (tonne per day kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L73'"><xsl:value-of select="$myparam"/> (tonne per day bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L74'"><xsl:value-of select="$myparam"/> (tonne per hour kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L75'"><xsl:value-of select="$myparam"/> (tonne per hour bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L76'"><xsl:value-of select="$myparam"/> (tonne per cubic metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L77'"><xsl:value-of select="$myparam"/> (tonne per cubic metre bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L78'"><xsl:value-of select="$myparam"/> (tonne per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='L79'"><xsl:value-of select="$myparam"/> (tonne per minute kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L80'"><xsl:value-of select="$myparam"/> (tonne per minute bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L81'"><xsl:value-of select="$myparam"/> (tonne per second)</xsl:when>
      		<xsl:when test="$myparam.upper='L82'"><xsl:value-of select="$myparam"/> (tonne per second kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='L83'"><xsl:value-of select="$myparam"/> (tonne per second bar)</xsl:when>
      		<xsl:when test="$myparam.upper='L84'"><xsl:value-of select="$myparam"/> (ton (UK shipping))</xsl:when>
      		<xsl:when test="$myparam.upper='L85'"><xsl:value-of select="$myparam"/> (ton long per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L86'"><xsl:value-of select="$myparam"/> (ton (US shipping))</xsl:when>
      		<xsl:when test="$myparam.upper='L87'"><xsl:value-of select="$myparam"/> (ton short per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='L88'"><xsl:value-of select="$myparam"/> (ton short per day)</xsl:when>
      		<xsl:when test="$myparam.upper='L89'"><xsl:value-of select="$myparam"/> (ton short per hour degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='L90'"><xsl:value-of select="$myparam"/> (ton short per hour psi)</xsl:when>
      		<xsl:when test="$myparam.upper='L91'"><xsl:value-of select="$myparam"/> (ton short per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='L92'"><xsl:value-of select="$myparam"/> (ton (UK long) per cubic yard)</xsl:when>
      		<xsl:when test="$myparam.upper='L93'"><xsl:value-of select="$myparam"/> (ton (US short) per cubic yard)</xsl:when>
      		<xsl:when test="$myparam.upper='L94'"><xsl:value-of select="$myparam"/> (ton-force (US short))</xsl:when>
      		<xsl:when test="$myparam.upper='L95'"><xsl:value-of select="$myparam"/> (common year)</xsl:when>
      		<xsl:when test="$myparam.upper='L96'"><xsl:value-of select="$myparam"/> (sidereal year)</xsl:when>
      		<xsl:when test="$myparam.upper='L98'"><xsl:value-of select="$myparam"/> (yard per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='L99'"><xsl:value-of select="$myparam"/> (yard per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='LA'"><xsl:value-of select="$myparam"/> (pound per cubic inch)</xsl:when>
      		<xsl:when test="$myparam.upper='LAC'"><xsl:value-of select="$myparam"/> (lactose excess percentage)</xsl:when>
      		<xsl:when test="$myparam.upper='LBR'"><xsl:value-of select="$myparam"/> (pound)</xsl:when>
      		<xsl:when test="$myparam.upper='LBT'"><xsl:value-of select="$myparam"/> (troy pound (US))</xsl:when>
      		<xsl:when test="$myparam.upper='LD'"><xsl:value-of select="$myparam"/> (litre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='LEF'"><xsl:value-of select="$myparam"/> (leaf)</xsl:when>
      		<xsl:when test="$myparam.upper='LF'"><xsl:value-of select="$myparam"/> (linear foot)</xsl:when>
      		<xsl:when test="$myparam.upper='LH'"><xsl:value-of select="$myparam"/> (labour hour)</xsl:when>
      		<xsl:when test="$myparam.upper='LK'"><xsl:value-of select="$myparam"/> (link)</xsl:when>
      		<xsl:when test="$myparam.upper='LM'"><xsl:value-of select="$myparam"/> (linear metre)</xsl:when>
      		<xsl:when test="$myparam.upper='LN'"><xsl:value-of select="$myparam"/> (length)</xsl:when>
      		<xsl:when test="$myparam.upper='LO'"><xsl:value-of select="$myparam"/> (lot [unit of procurement])</xsl:when>
      		<xsl:when test="$myparam.upper='LP'"><xsl:value-of select="$myparam"/> (liquid pound)</xsl:when>
      		<xsl:when test="$myparam.upper='LPA'"><xsl:value-of select="$myparam"/> (litre of pure alcohol)</xsl:when>
      		<xsl:when test="$myparam.upper='LR'"><xsl:value-of select="$myparam"/> (layer)</xsl:when>
      		<xsl:when test="$myparam.upper='LS'"><xsl:value-of select="$myparam"/> (lump sum)</xsl:when>
      		<xsl:when test="$myparam.upper='LTN'"><xsl:value-of select="$myparam"/> (ton (UK) or long ton (US))</xsl:when>
      		<xsl:when test="$myparam.upper='LTR'"><xsl:value-of select="$myparam"/> (litre)</xsl:when>
      		<xsl:when test="$myparam.upper='LUB'"><xsl:value-of select="$myparam"/> (metric ton, lubricating oil)</xsl:when>
      		<xsl:when test="$myparam.upper='LUM'"><xsl:value-of select="$myparam"/> (lumen)</xsl:when>
      		<xsl:when test="$myparam.upper='LUX'"><xsl:value-of select="$myparam"/> (lux)</xsl:when>
      		<xsl:when test="$myparam.upper='LY'"><xsl:value-of select="$myparam"/> (linear yard)</xsl:when>
      		<xsl:when test="$myparam.upper='M1'"><xsl:value-of select="$myparam"/> (milligram per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='M10'"><xsl:value-of select="$myparam"/> (reciprocal cubic yard)</xsl:when>
      		<xsl:when test="$myparam.upper='M11'"><xsl:value-of select="$myparam"/> (cubic yard per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='M12'"><xsl:value-of select="$myparam"/> (cubic yard per day)</xsl:when>
      		<xsl:when test="$myparam.upper='M13'"><xsl:value-of select="$myparam"/> (cubic yard per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='M14'"><xsl:value-of select="$myparam"/> (cubic yard per psi)</xsl:when>
      		<xsl:when test="$myparam.upper='M15'"><xsl:value-of select="$myparam"/> (cubic yard per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='M16'"><xsl:value-of select="$myparam"/> (cubic yard per second)</xsl:when>
      		<xsl:when test="$myparam.upper='M17'"><xsl:value-of select="$myparam"/> (kilohertz metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M18'"><xsl:value-of select="$myparam"/> (gigahertz metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M19'"><xsl:value-of select="$myparam"/> (Beaufort)</xsl:when>
      		<xsl:when test="$myparam.upper='M20'"><xsl:value-of select="$myparam"/> (reciprocal megakelvin or megakelvin to the power minus one)</xsl:when>
      		<xsl:when test="$myparam.upper='M21'"><xsl:value-of select="$myparam"/> (reciprocal kilovolt - ampere reciprocal hour)</xsl:when>
      		<xsl:when test="$myparam.upper='M22'"><xsl:value-of select="$myparam"/> (millilitre per square centimetre minute)</xsl:when>
      		<xsl:when test="$myparam.upper='M23'"><xsl:value-of select="$myparam"/> (newton per centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='M24'"><xsl:value-of select="$myparam"/> (ohm kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='M25'"><xsl:value-of select="$myparam"/> (percent per degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='M26'"><xsl:value-of select="$myparam"/> (gigaohm per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M27'"><xsl:value-of select="$myparam"/> (megahertz metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M29'"><xsl:value-of select="$myparam"/> (kilogram per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='M30'"><xsl:value-of select="$myparam"/> (reciprocal volt - ampere reciprocal second)</xsl:when>
      		<xsl:when test="$myparam.upper='M31'"><xsl:value-of select="$myparam"/> (kilogram per kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='M32'"><xsl:value-of select="$myparam"/> (pascal second per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='M33'"><xsl:value-of select="$myparam"/> (millimole per litre)</xsl:when>
      		<xsl:when test="$myparam.upper='M34'"><xsl:value-of select="$myparam"/> (newton metre per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M35'"><xsl:value-of select="$myparam"/> (millivolt - ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='M36'"><xsl:value-of select="$myparam"/> (30-day month)</xsl:when>
      		<xsl:when test="$myparam.upper='M37'"><xsl:value-of select="$myparam"/> (actual/360)</xsl:when>
      		<xsl:when test="$myparam.upper='M38'"><xsl:value-of select="$myparam"/> (kilometre per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M39'"><xsl:value-of select="$myparam"/> (centimetre per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M4'"><xsl:value-of select="$myparam"/> (monetary value)</xsl:when>
      		<xsl:when test="$myparam.upper='M40'"><xsl:value-of select="$myparam"/> (yard per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M41'"><xsl:value-of select="$myparam"/> (millimetre per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M42'"><xsl:value-of select="$myparam"/> (mile (statute mile) per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M43'"><xsl:value-of select="$myparam"/> (mil)</xsl:when>
      		<xsl:when test="$myparam.upper='M44'"><xsl:value-of select="$myparam"/> (revolution)</xsl:when>
      		<xsl:when test="$myparam.upper='M45'"><xsl:value-of select="$myparam"/> (degree [unit of angle] per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M46'"><xsl:value-of select="$myparam"/> (revolution per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='M47'"><xsl:value-of select="$myparam"/> (circular mil)</xsl:when>
      		<xsl:when test="$myparam.upper='M48'"><xsl:value-of select="$myparam"/> (square mile (based on U.S. survey foot))</xsl:when>
      		<xsl:when test="$myparam.upper='M49'"><xsl:value-of select="$myparam"/> (chain (based on U.S. survey foot))</xsl:when>
      		<xsl:when test="$myparam.upper='M5'"><xsl:value-of select="$myparam"/> (microcurie)</xsl:when>
      		<xsl:when test="$myparam.upper='M50'"><xsl:value-of select="$myparam"/> (furlong)</xsl:when>
      		<xsl:when test="$myparam.upper='M51'"><xsl:value-of select="$myparam"/> (foot (U.S. survey))</xsl:when>
      		<xsl:when test="$myparam.upper='M52'"><xsl:value-of select="$myparam"/> (mile (based on U.S. survey foot))</xsl:when>
      		<xsl:when test="$myparam.upper='M53'"><xsl:value-of select="$myparam"/> (metre per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M55'"><xsl:value-of select="$myparam"/> (metre per radiant)</xsl:when>
      		<xsl:when test="$myparam.upper='M56'"><xsl:value-of select="$myparam"/> (shake)</xsl:when>
      		<xsl:when test="$myparam.upper='M57'"><xsl:value-of select="$myparam"/> (mile per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='M58'"><xsl:value-of select="$myparam"/> (mile per second)</xsl:when>
      		<xsl:when test="$myparam.upper='M59'"><xsl:value-of select="$myparam"/> (metre per second pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M60'"><xsl:value-of select="$myparam"/> (metre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='M61'"><xsl:value-of select="$myparam"/> (inch per year)</xsl:when>
      		<xsl:when test="$myparam.upper='M62'"><xsl:value-of select="$myparam"/> (kilometre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='M63'"><xsl:value-of select="$myparam"/> (inch per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='M64'"><xsl:value-of select="$myparam"/> (yard per second)</xsl:when>
      		<xsl:when test="$myparam.upper='M65'"><xsl:value-of select="$myparam"/> (yard per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='M66'"><xsl:value-of select="$myparam"/> (yard per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='M67'"><xsl:value-of select="$myparam"/> (acre-foot (based on U.S. survey foot))</xsl:when>
      		<xsl:when test="$myparam.upper='M68'"><xsl:value-of select="$myparam"/> (cord (128 ft3))</xsl:when>
      		<xsl:when test="$myparam.upper='M69'"><xsl:value-of select="$myparam"/> (cubic mile (UK statute))</xsl:when>
      		<xsl:when test="$myparam.upper='M7'"><xsl:value-of select="$myparam"/> (micro-inch)</xsl:when>
      		<xsl:when test="$myparam.upper='M70'"><xsl:value-of select="$myparam"/> (ton, register)</xsl:when>
      		<xsl:when test="$myparam.upper='M71'"><xsl:value-of select="$myparam"/> (cubic metre per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M72'"><xsl:value-of select="$myparam"/> (bel)</xsl:when>
      		<xsl:when test="$myparam.upper='M73'"><xsl:value-of select="$myparam"/> (kilogram per cubic metre pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M74'"><xsl:value-of select="$myparam"/> (kilogram per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M75'"><xsl:value-of select="$myparam"/> (kilopound-force)</xsl:when>
      		<xsl:when test="$myparam.upper='M76'"><xsl:value-of select="$myparam"/> (poundal)</xsl:when>
      		<xsl:when test="$myparam.upper='M77'"><xsl:value-of select="$myparam"/> (kilogram metre per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='M78'"><xsl:value-of select="$myparam"/> (pond)</xsl:when>
      		<xsl:when test="$myparam.upper='M79'"><xsl:value-of select="$myparam"/> (square foot per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='M80'"><xsl:value-of select="$myparam"/> (stokes per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M81'"><xsl:value-of select="$myparam"/> (square centimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='M82'"><xsl:value-of select="$myparam"/> (square metre per second pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M83'"><xsl:value-of select="$myparam"/> (denier)</xsl:when>
      		<xsl:when test="$myparam.upper='M84'"><xsl:value-of select="$myparam"/> (pound per yard)</xsl:when>
      		<xsl:when test="$myparam.upper='M85'"><xsl:value-of select="$myparam"/> (ton, assay)</xsl:when>
      		<xsl:when test="$myparam.upper='M86'"><xsl:value-of select="$myparam"/> (pfund)</xsl:when>
      		<xsl:when test="$myparam.upper='M87'"><xsl:value-of select="$myparam"/> (kilogram per second pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='M88'"><xsl:value-of select="$myparam"/> (tonne per month)</xsl:when>
      		<xsl:when test="$myparam.upper='M89'"><xsl:value-of select="$myparam"/> (tonne per year)</xsl:when>
      		<xsl:when test="$myparam.upper='M9'"><xsl:value-of select="$myparam"/> (million Btu per 1000 cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='M90'"><xsl:value-of select="$myparam"/> (kilopound per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='M91'"><xsl:value-of select="$myparam"/> (pound per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='M92'"><xsl:value-of select="$myparam"/> (pound-force foot)</xsl:when>
      		<xsl:when test="$myparam.upper='M93'"><xsl:value-of select="$myparam"/> (newton metre per radian)</xsl:when>
      		<xsl:when test="$myparam.upper='M94'"><xsl:value-of select="$myparam"/> (kilogram metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M95'"><xsl:value-of select="$myparam"/> (poundal foot)</xsl:when>
      		<xsl:when test="$myparam.upper='M96'"><xsl:value-of select="$myparam"/> (poundal inch)</xsl:when>
      		<xsl:when test="$myparam.upper='M97'"><xsl:value-of select="$myparam"/> (dyne metre)</xsl:when>
      		<xsl:when test="$myparam.upper='M98'"><xsl:value-of select="$myparam"/> (kilogram centimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='M99'"><xsl:value-of select="$myparam"/> (gram centimetre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='MAH'"><xsl:value-of select="$myparam"/> (megavolt ampere reactive hour)</xsl:when>
      		<xsl:when test="$myparam.upper='MAL'"><xsl:value-of select="$myparam"/> (megalitre)</xsl:when>
      		<xsl:when test="$myparam.upper='MAM'"><xsl:value-of select="$myparam"/> (megametre)</xsl:when>
      		<xsl:when test="$myparam.upper='MAR'"><xsl:value-of select="$myparam"/> (megavar)</xsl:when>
      		<xsl:when test="$myparam.upper='MAW'"><xsl:value-of select="$myparam"/> (megawatt)</xsl:when>
      		<xsl:when test="$myparam.upper='MBE'"><xsl:value-of select="$myparam"/> (thousand standard brick equivalent)</xsl:when>
      		<xsl:when test="$myparam.upper='MBF'"><xsl:value-of select="$myparam"/> (thousand board foot)</xsl:when>
      		<xsl:when test="$myparam.upper='MBR'"><xsl:value-of select="$myparam"/> (millibar)</xsl:when>
      		<xsl:when test="$myparam.upper='MC'"><xsl:value-of select="$myparam"/> (microgram)</xsl:when>
      		<xsl:when test="$myparam.upper='MCU'"><xsl:value-of select="$myparam"/> (millicurie)</xsl:when>
      		<xsl:when test="$myparam.upper='MD'"><xsl:value-of select="$myparam"/> (air dry metric ton)</xsl:when>
      		<xsl:when test="$myparam.upper='MGM'"><xsl:value-of select="$myparam"/> (milligram)</xsl:when>
      		<xsl:when test="$myparam.upper='MHZ'"><xsl:value-of select="$myparam"/> (megahertz)</xsl:when>
      		<xsl:when test="$myparam.upper='MIK'"><xsl:value-of select="$myparam"/> (square mile (statute mile))</xsl:when>
      		<xsl:when test="$myparam.upper='MIL'"><xsl:value-of select="$myparam"/> (thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='MIN'"><xsl:value-of select="$myparam"/> (minute [unit of time])</xsl:when>
      		<xsl:when test="$myparam.upper='MIO'"><xsl:value-of select="$myparam"/> (million)</xsl:when>
      		<xsl:when test="$myparam.upper='MIU'"><xsl:value-of select="$myparam"/> (million international unit)</xsl:when>
      		<xsl:when test="$myparam.upper='MLD'"><xsl:value-of select="$myparam"/> (milliard)</xsl:when>
      		<xsl:when test="$myparam.upper='MLT'"><xsl:value-of select="$myparam"/> (millilitre)</xsl:when>
      		<xsl:when test="$myparam.upper='MMK'"><xsl:value-of select="$myparam"/> (square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='MMQ'"><xsl:value-of select="$myparam"/> (cubic millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='MMT'"><xsl:value-of select="$myparam"/> (millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='MND'"><xsl:value-of select="$myparam"/> (kilogram, dry weight)</xsl:when>
      		<xsl:when test="$myparam.upper='MON'"><xsl:value-of select="$myparam"/> (month)</xsl:when>
      		<xsl:when test="$myparam.upper='MPA'"><xsl:value-of select="$myparam"/> (megapascal)</xsl:when>
      		<xsl:when test="$myparam.upper='MQH'"><xsl:value-of select="$myparam"/> (cubic metre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='MQS'"><xsl:value-of select="$myparam"/> (cubic metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='MSK'"><xsl:value-of select="$myparam"/> (metre per second squared)</xsl:when>
      		<xsl:when test="$myparam.upper='MTK'"><xsl:value-of select="$myparam"/> (square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='MTQ'"><xsl:value-of select="$myparam"/> (cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='MTR'"><xsl:value-of select="$myparam"/> (metre)</xsl:when>
      		<xsl:when test="$myparam.upper='MTS'"><xsl:value-of select="$myparam"/> (metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='MVA'"><xsl:value-of select="$myparam"/> (megavolt - ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='MWH'"><xsl:value-of select="$myparam"/> (megawatt hour (1000 kW.h))</xsl:when>
      		<xsl:when test="$myparam.upper='N1'"><xsl:value-of select="$myparam"/> (pen calorie)</xsl:when>
      		<xsl:when test="$myparam.upper='N10'"><xsl:value-of select="$myparam"/> (pound foot per second)</xsl:when>
      		<xsl:when test="$myparam.upper='N11'"><xsl:value-of select="$myparam"/> (pound inch per second)</xsl:when>
      		<xsl:when test="$myparam.upper='N12'"><xsl:value-of select="$myparam"/> (Pferdestaerke)</xsl:when>
      		<xsl:when test="$myparam.upper='N13'"><xsl:value-of select="$myparam"/> (centimetre of mercury (0 ºC))</xsl:when>
      		<xsl:when test="$myparam.upper='N14'"><xsl:value-of select="$myparam"/> (centimetre of water (4 ºC))</xsl:when>
      		<xsl:when test="$myparam.upper='N15'"><xsl:value-of select="$myparam"/> (foot of water (39.2 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N16'"><xsl:value-of select="$myparam"/> (inch of mercury (32 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N17'"><xsl:value-of select="$myparam"/> (inch of mercury (60 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N18'"><xsl:value-of select="$myparam"/> (inch of water (39.2 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N19'"><xsl:value-of select="$myparam"/> (inch of water (60 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N20'"><xsl:value-of select="$myparam"/> (kip per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N21'"><xsl:value-of select="$myparam"/> (poundal per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='N22'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois) per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N23'"><xsl:value-of select="$myparam"/> (conventional metre of water)</xsl:when>
      		<xsl:when test="$myparam.upper='N24'"><xsl:value-of select="$myparam"/> (gram per square millimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='N25'"><xsl:value-of select="$myparam"/> (pound per square yard)</xsl:when>
      		<xsl:when test="$myparam.upper='N26'"><xsl:value-of select="$myparam"/> (poundal per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N27'"><xsl:value-of select="$myparam"/> (foot to the fourth power)</xsl:when>
      		<xsl:when test="$myparam.upper='N28'"><xsl:value-of select="$myparam"/> (cubic decimetre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='N29'"><xsl:value-of select="$myparam"/> (cubic foot per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='N3'"><xsl:value-of select="$myparam"/> (print point)</xsl:when>
      		<xsl:when test="$myparam.upper='N30'"><xsl:value-of select="$myparam"/> (cubic inch per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='N31'"><xsl:value-of select="$myparam"/> (kilonewton per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='N32'"><xsl:value-of select="$myparam"/> (poundal per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N33'"><xsl:value-of select="$myparam"/> (pound-force per yard)</xsl:when>
      		<xsl:when test="$myparam.upper='N34'"><xsl:value-of select="$myparam"/> (poundal second per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='N35'"><xsl:value-of select="$myparam"/> (poise per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='N36'"><xsl:value-of select="$myparam"/> (newton second per square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='N37'"><xsl:value-of select="$myparam"/> (kilogram per metre second)</xsl:when>
      		<xsl:when test="$myparam.upper='N38'"><xsl:value-of select="$myparam"/> (kilogram per metre minute)</xsl:when>
      		<xsl:when test="$myparam.upper='N39'"><xsl:value-of select="$myparam"/> (kilogram per metre day)</xsl:when>
      		<xsl:when test="$myparam.upper='N40'"><xsl:value-of select="$myparam"/> (kilogram per metre hour)</xsl:when>
      		<xsl:when test="$myparam.upper='N41'"><xsl:value-of select="$myparam"/> (gram per centimetre second)</xsl:when>
      		<xsl:when test="$myparam.upper='N42'"><xsl:value-of select="$myparam"/> (poundal second per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N43'"><xsl:value-of select="$myparam"/> (pound per foot minute)</xsl:when>
      		<xsl:when test="$myparam.upper='N44'"><xsl:value-of select="$myparam"/> (pound per foot day)</xsl:when>
      		<xsl:when test="$myparam.upper='N45'"><xsl:value-of select="$myparam"/> (cubic metre per second pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='N46'"><xsl:value-of select="$myparam"/> (foot poundal)</xsl:when>
      		<xsl:when test="$myparam.upper='N47'"><xsl:value-of select="$myparam"/> (inch poundal)</xsl:when>
      		<xsl:when test="$myparam.upper='N48'"><xsl:value-of select="$myparam"/> (watt per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='N49'"><xsl:value-of select="$myparam"/> (watt per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N50'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per square foot hour)</xsl:when>
      		<xsl:when test="$myparam.upper='N51'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per square foot hour)</xsl:when>
      		<xsl:when test="$myparam.upper='N52'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per square foot minute)</xsl:when>
      		<xsl:when test="$myparam.upper='N53'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per square foot second)</xsl:when>
      		<xsl:when test="$myparam.upper='N54'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per square foot second)</xsl:when>
      		<xsl:when test="$myparam.upper='N55'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per square inch second)</xsl:when>
      		<xsl:when test="$myparam.upper='N56'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per square centimetre minute)</xsl:when>
      		<xsl:when test="$myparam.upper='N57'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per square centimetre second)</xsl:when>
      		<xsl:when test="$myparam.upper='N58'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='N59'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per cubic foot)</xsl:when>
      		<xsl:when test="$myparam.upper='N60'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='N61'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='N62'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='N63'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='N64'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per pound degree Rankine)</xsl:when>
      		<xsl:when test="$myparam.upper='N65'"><xsl:value-of select="$myparam"/> (kilocalorie (international table) per gram kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='N66'"><xsl:value-of select="$myparam"/> (British thermal unit (39 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N67'"><xsl:value-of select="$myparam"/> (British thermal unit (59 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N68'"><xsl:value-of select="$myparam"/> (British thermal unit (60 ºF))</xsl:when>
      		<xsl:when test="$myparam.upper='N69'"><xsl:value-of select="$myparam"/> (calorie (20 ºC))</xsl:when>
      		<xsl:when test="$myparam.upper='N70'"><xsl:value-of select="$myparam"/> (quad (1015 BtuIT))</xsl:when>
      		<xsl:when test="$myparam.upper='N71'"><xsl:value-of select="$myparam"/> (therm (EC))</xsl:when>
      		<xsl:when test="$myparam.upper='N72'"><xsl:value-of select="$myparam"/> (therm (U.S.))</xsl:when>
      		<xsl:when test="$myparam.upper='N73'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='N74'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per hour square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='N75'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per hour square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='N76'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per second square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='N77'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per second square foot degree Fahrenheit)</xsl:when>
      		<xsl:when test="$myparam.upper='N78'"><xsl:value-of select="$myparam"/> (kilowatt per square metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='N79'"><xsl:value-of select="$myparam"/> (kelvin per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='N80'"><xsl:value-of select="$myparam"/> (watt per metre degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='N81'"><xsl:value-of select="$myparam"/> (kilowatt per metre kelvin)</xsl:when>
      		<xsl:when test="$myparam.upper='N82'"><xsl:value-of select="$myparam"/> (kilowatt per metre degree Celsius)</xsl:when>
      		<xsl:when test="$myparam.upper='N83'"><xsl:value-of select="$myparam"/> (metre per degree Celcius metre)</xsl:when>
      		<xsl:when test="$myparam.upper='N84'"><xsl:value-of select="$myparam"/> (degree Fahrenheit hour per British thermal unit (international table))</xsl:when>
      		<xsl:when test="$myparam.upper='N85'"><xsl:value-of select="$myparam"/> (degree Fahrenheit hour per British thermal unit (thermochemical))</xsl:when>
      		<xsl:when test="$myparam.upper='N86'"><xsl:value-of select="$myparam"/> (degree Fahrenheit second per British thermal unit (international table))</xsl:when>
      		<xsl:when test="$myparam.upper='N87'"><xsl:value-of select="$myparam"/> (degree Fahrenheit second per British thermal unit (thermochemical))</xsl:when>
      		<xsl:when test="$myparam.upper='N88'"><xsl:value-of select="$myparam"/> (degree Fahrenheit hour square foot per British thermal unit (international table) inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N89'"><xsl:value-of select="$myparam"/> (degree Fahrenheit hour square foot per British thermal unit (thermochemical) inch)</xsl:when>
      		<xsl:when test="$myparam.upper='N90'"><xsl:value-of select="$myparam"/> (kilofarad)</xsl:when>
      		<xsl:when test="$myparam.upper='N91'"><xsl:value-of select="$myparam"/> (reciprocal joule)</xsl:when>
      		<xsl:when test="$myparam.upper='N92'"><xsl:value-of select="$myparam"/> (picosiemens)</xsl:when>
      		<xsl:when test="$myparam.upper='N93'"><xsl:value-of select="$myparam"/> (ampere per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='N94'"><xsl:value-of select="$myparam"/> (franklin)</xsl:when>
      		<xsl:when test="$myparam.upper='N95'"><xsl:value-of select="$myparam"/> (ampere minute)</xsl:when>
      		<xsl:when test="$myparam.upper='N96'"><xsl:value-of select="$myparam"/> (biot)</xsl:when>
      		<xsl:when test="$myparam.upper='N97'"><xsl:value-of select="$myparam"/> (gilbert)</xsl:when>
      		<xsl:when test="$myparam.upper='N98'"><xsl:value-of select="$myparam"/> (volt per pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='N99'"><xsl:value-of select="$myparam"/> (picovolt)</xsl:when>
      		<xsl:when test="$myparam.upper='NA'"><xsl:value-of select="$myparam"/> (milligram per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='NAR'"><xsl:value-of select="$myparam"/> (number of articles)</xsl:when>
      		<xsl:when test="$myparam.upper='NCL'"><xsl:value-of select="$myparam"/> (number of cells)</xsl:when>
      		<xsl:when test="$myparam.upper='NEW'"><xsl:value-of select="$myparam"/> (newton)</xsl:when>
      		<xsl:when test="$myparam.upper='NF'"><xsl:value-of select="$myparam"/> (message)</xsl:when>
      		<xsl:when test="$myparam.upper='NIL'"><xsl:value-of select="$myparam"/> (nil)</xsl:when>
      		<xsl:when test="$myparam.upper='NIU'"><xsl:value-of select="$myparam"/> (number of international units)</xsl:when>
      		<xsl:when test="$myparam.upper='NL'"><xsl:value-of select="$myparam"/> (load)</xsl:when>
      		<xsl:when test="$myparam.upper='NM3'"><xsl:value-of select="$myparam"/> (Normalised cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='NMI'"><xsl:value-of select="$myparam"/> (nautical mile)</xsl:when>
      		<xsl:when test="$myparam.upper='NMP'"><xsl:value-of select="$myparam"/> (number of packs)</xsl:when>
      		<xsl:when test="$myparam.upper='NPT'"><xsl:value-of select="$myparam"/> (number of parts)</xsl:when>
      		<xsl:when test="$myparam.upper='NT'"><xsl:value-of select="$myparam"/> (net ton)</xsl:when>
      		<xsl:when test="$myparam.upper='NU'"><xsl:value-of select="$myparam"/> (newton metre)</xsl:when>
      		<xsl:when test="$myparam.upper='NX'"><xsl:value-of select="$myparam"/> (part per thousand)</xsl:when>
      		<xsl:when test="$myparam.upper='OA'"><xsl:value-of select="$myparam"/> (panel)</xsl:when>
      		<xsl:when test="$myparam.upper='ODE'"><xsl:value-of select="$myparam"/> (ozone depletion equivalent)</xsl:when>
      		<xsl:when test="$myparam.upper='ODG'"><xsl:value-of select="$myparam"/> (ODS Grams)</xsl:when>
      		<xsl:when test="$myparam.upper='ODK'"><xsl:value-of select="$myparam"/> (ODS Kilograms)</xsl:when>
      		<xsl:when test="$myparam.upper='ODM'"><xsl:value-of select="$myparam"/> (ODS Milligrams)</xsl:when>
      		<xsl:when test="$myparam.upper='OHM'"><xsl:value-of select="$myparam"/> (ohm)</xsl:when>
      		<xsl:when test="$myparam.upper='ON'"><xsl:value-of select="$myparam"/> (ounce per square yard)</xsl:when>
      		<xsl:when test="$myparam.upper='ONZ'"><xsl:value-of select="$myparam"/> (ounce (avoirdupois))</xsl:when>
      		<xsl:when test="$myparam.upper='OPM'"><xsl:value-of select="$myparam"/> (oscillations per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='OT'"><xsl:value-of select="$myparam"/> (overtime hour)</xsl:when>
      		<xsl:when test="$myparam.upper='OZA'"><xsl:value-of select="$myparam"/> (fluid ounce (US))</xsl:when>
      		<xsl:when test="$myparam.upper='OZI'"><xsl:value-of select="$myparam"/> (fluid ounce (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='P1'"><xsl:value-of select="$myparam"/> (percent)</xsl:when>
      		<xsl:when test="$myparam.upper='P10'"><xsl:value-of select="$myparam"/> (coulomb per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P11'"><xsl:value-of select="$myparam"/> (kiloweber)</xsl:when>
      		<xsl:when test="$myparam.upper='P12'"><xsl:value-of select="$myparam"/> (gamma)</xsl:when>
      		<xsl:when test="$myparam.upper='P13'"><xsl:value-of select="$myparam"/> (kilotesla)</xsl:when>
      		<xsl:when test="$myparam.upper='P14'"><xsl:value-of select="$myparam"/> (joule per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P15'"><xsl:value-of select="$myparam"/> (joule per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P16'"><xsl:value-of select="$myparam"/> (joule per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P17'"><xsl:value-of select="$myparam"/> (joule per day)</xsl:when>
      		<xsl:when test="$myparam.upper='P18'"><xsl:value-of select="$myparam"/> (kilojoule per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P19'"><xsl:value-of select="$myparam"/> (kilojoule per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P2'"><xsl:value-of select="$myparam"/> (pound per foot)</xsl:when>
      		<xsl:when test="$myparam.upper='P20'"><xsl:value-of select="$myparam"/> (kilojoule per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P21'"><xsl:value-of select="$myparam"/> (kilojoule per day)</xsl:when>
      		<xsl:when test="$myparam.upper='P22'"><xsl:value-of select="$myparam"/> (nanoohm)</xsl:when>
      		<xsl:when test="$myparam.upper='P23'"><xsl:value-of select="$myparam"/> (ohm circular-mil per foot)</xsl:when>
      		<xsl:when test="$myparam.upper='P24'"><xsl:value-of select="$myparam"/> (kilohenry)</xsl:when>
      		<xsl:when test="$myparam.upper='P25'"><xsl:value-of select="$myparam"/> (lumen per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='P26'"><xsl:value-of select="$myparam"/> (phot)</xsl:when>
      		<xsl:when test="$myparam.upper='P27'"><xsl:value-of select="$myparam"/> (footcandle)</xsl:when>
      		<xsl:when test="$myparam.upper='P28'"><xsl:value-of select="$myparam"/> (candela per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='P29'"><xsl:value-of select="$myparam"/> (footlambert)</xsl:when>
      		<xsl:when test="$myparam.upper='P30'"><xsl:value-of select="$myparam"/> (lambert)</xsl:when>
      		<xsl:when test="$myparam.upper='P31'"><xsl:value-of select="$myparam"/> (stilb)</xsl:when>
      		<xsl:when test="$myparam.upper='P32'"><xsl:value-of select="$myparam"/> (candela per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='P33'"><xsl:value-of select="$myparam"/> (kilocandela)</xsl:when>
      		<xsl:when test="$myparam.upper='P34'"><xsl:value-of select="$myparam"/> (millicandela)</xsl:when>
      		<xsl:when test="$myparam.upper='P35'"><xsl:value-of select="$myparam"/> (Hefner-Kerze)</xsl:when>
      		<xsl:when test="$myparam.upper='P36'"><xsl:value-of select="$myparam"/> (international candle)</xsl:when>
      		<xsl:when test="$myparam.upper='P37'"><xsl:value-of select="$myparam"/> (British thermal unit (international table) per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='P38'"><xsl:value-of select="$myparam"/> (British thermal unit (thermochemical) per square foot)</xsl:when>
      		<xsl:when test="$myparam.upper='P39'"><xsl:value-of select="$myparam"/> (calorie (thermochemical) per square centimetre)</xsl:when>
      		<xsl:when test="$myparam.upper='P40'"><xsl:value-of select="$myparam"/> (langley)</xsl:when>
      		<xsl:when test="$myparam.upper='P41'"><xsl:value-of select="$myparam"/> (decade (logarithmic))</xsl:when>
      		<xsl:when test="$myparam.upper='P42'"><xsl:value-of select="$myparam"/> (pascal squared second)</xsl:when>
      		<xsl:when test="$myparam.upper='P43'"><xsl:value-of select="$myparam"/> (bel per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P44'"><xsl:value-of select="$myparam"/> (pound mole)</xsl:when>
      		<xsl:when test="$myparam.upper='P45'"><xsl:value-of select="$myparam"/> (pound mole per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P46'"><xsl:value-of select="$myparam"/> (pound mole per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P47'"><xsl:value-of select="$myparam"/> (kilomole per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='P48'"><xsl:value-of select="$myparam"/> (pound mole per pound)</xsl:when>
      		<xsl:when test="$myparam.upper='P49'"><xsl:value-of select="$myparam"/> (newton square metre per ampere)</xsl:when>
      		<xsl:when test="$myparam.upper='P5'"><xsl:value-of select="$myparam"/> (five pack)</xsl:when>
      		<xsl:when test="$myparam.upper='P50'"><xsl:value-of select="$myparam"/> (weber metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P51'"><xsl:value-of select="$myparam"/> (mol per kilogram pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='P52'"><xsl:value-of select="$myparam"/> (mol per cubic metre pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='P53'"><xsl:value-of select="$myparam"/> (unit pole)</xsl:when>
      		<xsl:when test="$myparam.upper='P54'"><xsl:value-of select="$myparam"/> (milligray per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P55'"><xsl:value-of select="$myparam"/> (microgray per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P56'"><xsl:value-of select="$myparam"/> (nanogray per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P57'"><xsl:value-of select="$myparam"/> (gray per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P58'"><xsl:value-of select="$myparam"/> (milligray per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P59'"><xsl:value-of select="$myparam"/> (microgray per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P60'"><xsl:value-of select="$myparam"/> (nanogray per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P61'"><xsl:value-of select="$myparam"/> (gray per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P62'"><xsl:value-of select="$myparam"/> (milligray per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P63'"><xsl:value-of select="$myparam"/> (microgray per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P64'"><xsl:value-of select="$myparam"/> (nanogray per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P65'"><xsl:value-of select="$myparam"/> (sievert per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P66'"><xsl:value-of select="$myparam"/> (millisievert per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P67'"><xsl:value-of select="$myparam"/> (microsievert per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P68'"><xsl:value-of select="$myparam"/> (nanosievert per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P69'"><xsl:value-of select="$myparam"/> (rem per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P70'"><xsl:value-of select="$myparam"/> (sievert per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P71'"><xsl:value-of select="$myparam"/> (millisievert per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P72'"><xsl:value-of select="$myparam"/> (microsievert per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P73'"><xsl:value-of select="$myparam"/> (nanosievert per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='P74'"><xsl:value-of select="$myparam"/> (sievert per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P75'"><xsl:value-of select="$myparam"/> (millisievert per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P76'"><xsl:value-of select="$myparam"/> (microsievert per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P77'"><xsl:value-of select="$myparam"/> (nanosievert per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='P78'"><xsl:value-of select="$myparam"/> (reciprocal square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='P79'"><xsl:value-of select="$myparam"/> (pascal square metre per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='P80'"><xsl:value-of select="$myparam"/> (millipascal per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P81'"><xsl:value-of select="$myparam"/> (kilopascal per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P82'"><xsl:value-of select="$myparam"/> (hectopascal per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P83'"><xsl:value-of select="$myparam"/> (standard atmosphere per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P84'"><xsl:value-of select="$myparam"/> (technical atmosphere per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P85'"><xsl:value-of select="$myparam"/> (torr per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P86'"><xsl:value-of select="$myparam"/> (psi per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='P87'"><xsl:value-of select="$myparam"/> (cubic metre per second square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='P88'"><xsl:value-of select="$myparam"/> (rhe)</xsl:when>
      		<xsl:when test="$myparam.upper='P89'"><xsl:value-of select="$myparam"/> (pound-force foot per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='P90'"><xsl:value-of select="$myparam"/> (pound-force inch per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='P91'"><xsl:value-of select="$myparam"/> (perm (0 ºC))</xsl:when>
      		<xsl:when test="$myparam.upper='P92'"><xsl:value-of select="$myparam"/> (perm (23 ºC))</xsl:when>
      		<xsl:when test="$myparam.upper='P93'"><xsl:value-of select="$myparam"/> (byte per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P94'"><xsl:value-of select="$myparam"/> (kilobyte per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P95'"><xsl:value-of select="$myparam"/> (megabyte per second)</xsl:when>
      		<xsl:when test="$myparam.upper='P96'"><xsl:value-of select="$myparam"/> (reciprocal volt)</xsl:when>
      		<xsl:when test="$myparam.upper='P97'"><xsl:value-of select="$myparam"/> (reciprocal radian)</xsl:when>
      		<xsl:when test="$myparam.upper='P98'"><xsl:value-of select="$myparam"/> (pascal to the power sum of stoichiometric numbers)</xsl:when>
      		<xsl:when test="$myparam.upper='P99'"><xsl:value-of select="$myparam"/> (mole per cubiv metre to the power sum of stoichiometric numbers)</xsl:when>
      		<xsl:when test="$myparam.upper='PAL'"><xsl:value-of select="$myparam"/> (pascal)</xsl:when>
      		<xsl:when test="$myparam.upper='PD'"><xsl:value-of select="$myparam"/> (pad)</xsl:when>
      		<xsl:when test="$myparam.upper='PFL'"><xsl:value-of select="$myparam"/> (proof litre)</xsl:when>
      		<xsl:when test="$myparam.upper='PGL'"><xsl:value-of select="$myparam"/> (proof gallon)</xsl:when>
      		<xsl:when test="$myparam.upper='PI'"><xsl:value-of select="$myparam"/> (pitch)</xsl:when>
      		<xsl:when test="$myparam.upper='PLA'"><xsl:value-of select="$myparam"/> (degree Plato)</xsl:when>
      		<xsl:when test="$myparam.upper='PO'"><xsl:value-of select="$myparam"/> (pound per inch of length)</xsl:when>
      		<xsl:when test="$myparam.upper='PQ'"><xsl:value-of select="$myparam"/> (page per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='PR'"><xsl:value-of select="$myparam"/> (pair)</xsl:when>
      		<xsl:when test="$myparam.upper='PS'"><xsl:value-of select="$myparam"/> (pound-force per square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='PTD'"><xsl:value-of select="$myparam"/> (dry pint (US))</xsl:when>
      		<xsl:when test="$myparam.upper='PTI'"><xsl:value-of select="$myparam"/> (pint (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='PTL'"><xsl:value-of select="$myparam"/> (liquid pint (US))</xsl:when>
      		<xsl:when test="$myparam.upper='PTN'"><xsl:value-of select="$myparam"/> (portion)</xsl:when>
      		<xsl:when test="$myparam.upper='Q10'"><xsl:value-of select="$myparam"/> (joule per tesla)</xsl:when>
      		<xsl:when test="$myparam.upper='Q11'"><xsl:value-of select="$myparam"/> (erlang)</xsl:when>
      		<xsl:when test="$myparam.upper='Q12'"><xsl:value-of select="$myparam"/> (octet)</xsl:when>
      		<xsl:when test="$myparam.upper='Q13'"><xsl:value-of select="$myparam"/> (octet per second)</xsl:when>
      		<xsl:when test="$myparam.upper='Q14'"><xsl:value-of select="$myparam"/> (shannon)</xsl:when>
      		<xsl:when test="$myparam.upper='Q15'"><xsl:value-of select="$myparam"/> (hartley)</xsl:when>
      		<xsl:when test="$myparam.upper='Q16'"><xsl:value-of select="$myparam"/> (natural unit of information)</xsl:when>
      		<xsl:when test="$myparam.upper='Q17'"><xsl:value-of select="$myparam"/> (shannon per second)</xsl:when>
      		<xsl:when test="$myparam.upper='Q18'"><xsl:value-of select="$myparam"/> (hartley per second)</xsl:when>
      		<xsl:when test="$myparam.upper='Q19'"><xsl:value-of select="$myparam"/> (natural unit of information per second)</xsl:when>
      		<xsl:when test="$myparam.upper='Q20'"><xsl:value-of select="$myparam"/> (second per kilogramm)</xsl:when>
      		<xsl:when test="$myparam.upper='Q21'"><xsl:value-of select="$myparam"/> (watt square metre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q22'"><xsl:value-of select="$myparam"/> (second per radian cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q23'"><xsl:value-of select="$myparam"/> (weber to the power minus one)</xsl:when>
      		<xsl:when test="$myparam.upper='Q24'"><xsl:value-of select="$myparam"/> (reciprocal inch)</xsl:when>
      		<xsl:when test="$myparam.upper='Q25'"><xsl:value-of select="$myparam"/> (dioptre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q26'"><xsl:value-of select="$myparam"/> (one per one)</xsl:when>
      		<xsl:when test="$myparam.upper='Q27'"><xsl:value-of select="$myparam"/> (newton metre per metre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q28'"><xsl:value-of select="$myparam"/> (kilogram per square metre pascal second)</xsl:when>
      		<xsl:when test="$myparam.upper='Q29'"><xsl:value-of select="$myparam"/> (microgram per hectogram)</xsl:when>
      		<xsl:when test="$myparam.upper='Q30'"><xsl:value-of select="$myparam"/> (pH (potential of Hydrogen))</xsl:when>
      		<xsl:when test="$myparam.upper='Q31'"><xsl:value-of select="$myparam"/> (kilojoule per gram)</xsl:when>
      		<xsl:when test="$myparam.upper='Q32'"><xsl:value-of select="$myparam"/> (femtolitre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q33'"><xsl:value-of select="$myparam"/> (picolitre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q34'"><xsl:value-of select="$myparam"/> (nanolitre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q35'"><xsl:value-of select="$myparam"/> (megawatts per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='Q36'"><xsl:value-of select="$myparam"/> (square metre per cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q37'"><xsl:value-of select="$myparam"/> (Standard cubic metre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='Q38'"><xsl:value-of select="$myparam"/> (Standard cubic metre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='Q39'"><xsl:value-of select="$myparam"/> (Normalized cubic metre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='Q40'"><xsl:value-of select="$myparam"/> (Normalized cubic metre per hour)</xsl:when>
      		<xsl:when test="$myparam.upper='Q41'"><xsl:value-of select="$myparam"/> (Joule per normalised cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q42'"><xsl:value-of select="$myparam"/> (Joule per standard cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='Q3'"><xsl:value-of select="$myparam"/> (meal)</xsl:when>
      		<xsl:when test="$myparam.upper='QA'"><xsl:value-of select="$myparam"/> (page - facsimile)</xsl:when>
      		<xsl:when test="$myparam.upper='QAN'"><xsl:value-of select="$myparam"/> (quarter (of a year))</xsl:when>
      		<xsl:when test="$myparam.upper='QB'"><xsl:value-of select="$myparam"/> (page - hardcopy)</xsl:when>
      		<xsl:when test="$myparam.upper='QR'"><xsl:value-of select="$myparam"/> (quire)</xsl:when>
      		<xsl:when test="$myparam.upper='QTD'"><xsl:value-of select="$myparam"/> (dry quart (US))</xsl:when>
      		<xsl:when test="$myparam.upper='QTI'"><xsl:value-of select="$myparam"/> (quart (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='QTL'"><xsl:value-of select="$myparam"/> (liquid quart (US))</xsl:when>
      		<xsl:when test="$myparam.upper='QTR'"><xsl:value-of select="$myparam"/> (quarter (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='R1'"><xsl:value-of select="$myparam"/> (pica)</xsl:when>
      		<xsl:when test="$myparam.upper='R9'"><xsl:value-of select="$myparam"/> (thousand cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='RH'"><xsl:value-of select="$myparam"/> (running or operating hour)</xsl:when>
      		<xsl:when test="$myparam.upper='RM'"><xsl:value-of select="$myparam"/> (ream)</xsl:when>
      		<xsl:when test="$myparam.upper='ROM'"><xsl:value-of select="$myparam"/> (room)</xsl:when>
      		<xsl:when test="$myparam.upper='RP'"><xsl:value-of select="$myparam"/> (pound per ream)</xsl:when>
      		<xsl:when test="$myparam.upper='RPM'"><xsl:value-of select="$myparam"/> (revolutions per minute)</xsl:when>
      		<xsl:when test="$myparam.upper='RPS'"><xsl:value-of select="$myparam"/> (revolutions per second)</xsl:when>
      		<xsl:when test="$myparam.upper='RT'"><xsl:value-of select="$myparam"/> (revenue ton mile)</xsl:when>
      		<xsl:when test="$myparam.upper='S3'"><xsl:value-of select="$myparam"/> (square foot per second)</xsl:when>
      		<xsl:when test="$myparam.upper='S4'"><xsl:value-of select="$myparam"/> (square metre per second)</xsl:when>
      		<xsl:when test="$myparam.upper='SAN'"><xsl:value-of select="$myparam"/> (half year (6 months))</xsl:when>
      		<xsl:when test="$myparam.upper='SCO'"><xsl:value-of select="$myparam"/> (score)</xsl:when>
      		<xsl:when test="$myparam.upper='SCR'"><xsl:value-of select="$myparam"/> (scruple)</xsl:when>
      		<xsl:when test="$myparam.upper='SEC'"><xsl:value-of select="$myparam"/> (second [unit of time])</xsl:when>
      		<xsl:when test="$myparam.upper='SET'"><xsl:value-of select="$myparam"/> (set)</xsl:when>
      		<xsl:when test="$myparam.upper='SG'"><xsl:value-of select="$myparam"/> (segment)</xsl:when>
      		<xsl:when test="$myparam.upper='SIE'"><xsl:value-of select="$myparam"/> (siemens)</xsl:when>
      		<xsl:when test="$myparam.upper='SM3'"><xsl:value-of select="$myparam"/> (Standard cubic metre)</xsl:when>
      		<xsl:when test="$myparam.upper='SMI'"><xsl:value-of select="$myparam"/> (mile (statute mile))</xsl:when>
      		<xsl:when test="$myparam.upper='SQ'"><xsl:value-of select="$myparam"/> (square)</xsl:when>
      		<xsl:when test="$myparam.upper='SQR'"><xsl:value-of select="$myparam"/> (square, roofing)</xsl:when>
      		<xsl:when test="$myparam.upper='SR'"><xsl:value-of select="$myparam"/> (strip)</xsl:when>
      		<xsl:when test="$myparam.upper='STC'"><xsl:value-of select="$myparam"/> (stick)</xsl:when>
      		<xsl:when test="$myparam.upper='STI'"><xsl:value-of select="$myparam"/> (stone (UK))</xsl:when>
      		<xsl:when test="$myparam.upper='STK'"><xsl:value-of select="$myparam"/> (stick, cigarette)</xsl:when>
      		<xsl:when test="$myparam.upper='STL'"><xsl:value-of select="$myparam"/> (standard litre)</xsl:when>
      		<xsl:when test="$myparam.upper='STN'"><xsl:value-of select="$myparam"/> (ton (US) or short ton (UK/US))</xsl:when>
      		<xsl:when test="$myparam.upper='STW'"><xsl:value-of select="$myparam"/> (straw)</xsl:when>
      		<xsl:when test="$myparam.upper='SW'"><xsl:value-of select="$myparam"/> (skein)</xsl:when>
      		<xsl:when test="$myparam.upper='SX'"><xsl:value-of select="$myparam"/> (shipment)</xsl:when>
      		<xsl:when test="$myparam.upper='SYR'"><xsl:value-of select="$myparam"/> (syringe)</xsl:when>
      		<xsl:when test="$myparam.upper='T0'"><xsl:value-of select="$myparam"/> (telecommunication line in service)</xsl:when>
      		<xsl:when test="$myparam.upper='T3'"><xsl:value-of select="$myparam"/> (thousand piece)</xsl:when>
      		<xsl:when test="$myparam.upper='TAH'"><xsl:value-of select="$myparam"/> (kiloampere hour (thousand ampere hour))</xsl:when>
      		<xsl:when test="$myparam.upper='TAN'"><xsl:value-of select="$myparam"/> (total acid number)</xsl:when>
      		<xsl:when test="$myparam.upper='TI'"><xsl:value-of select="$myparam"/> (thousand square inch)</xsl:when>
      		<xsl:when test="$myparam.upper='TIC'"><xsl:value-of select="$myparam"/> (metric ton, including container)</xsl:when>
      		<xsl:when test="$myparam.upper='TIP'"><xsl:value-of select="$myparam"/> (metric ton, including inner packaging)</xsl:when>
      		<xsl:when test="$myparam.upper='TKM'"><xsl:value-of select="$myparam"/> (tonne kilometre)</xsl:when>
      		<xsl:when test="$myparam.upper='TMS'"><xsl:value-of select="$myparam"/> (kilogram of imported meat, less offal)</xsl:when>
      		<xsl:when test="$myparam.upper='TNE'"><xsl:value-of select="$myparam"/> (tonne (metric ton))</xsl:when>
      		<xsl:when test="$myparam.upper='TP'"><xsl:value-of select="$myparam"/> (ten pack)</xsl:when>
      		<xsl:when test="$myparam.upper='TPI'"><xsl:value-of select="$myparam"/> (teeth per inch)</xsl:when>
      		<xsl:when test="$myparam.upper='TPR'"><xsl:value-of select="$myparam"/> (ten pair)</xsl:when>
      		<xsl:when test="$myparam.upper='TQD'"><xsl:value-of select="$myparam"/> (thousand cubic metre per day)</xsl:when>
      		<xsl:when test="$myparam.upper='TRL'"><xsl:value-of select="$myparam"/> (trillion (EUR))</xsl:when>
      		<xsl:when test="$myparam.upper='TST'"><xsl:value-of select="$myparam"/> (ten set)</xsl:when>
      		<xsl:when test="$myparam.upper='TTS'"><xsl:value-of select="$myparam"/> (ten thousand sticks)</xsl:when>
      		<xsl:when test="$myparam.upper='U1'"><xsl:value-of select="$myparam"/> (treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='U2'"><xsl:value-of select="$myparam"/> (tablet)</xsl:when>
      		<xsl:when test="$myparam.upper='UB'"><xsl:value-of select="$myparam"/> (telecommunication line in service average)</xsl:when>
      		<xsl:when test="$myparam.upper='UC'"><xsl:value-of select="$myparam"/> (telecommunication port)</xsl:when>
      		<xsl:when test="$myparam.upper='VA'"><xsl:value-of select="$myparam"/> (volt - ampere per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='VLT'"><xsl:value-of select="$myparam"/> (volt)</xsl:when>
      		<xsl:when test="$myparam.upper='VP'"><xsl:value-of select="$myparam"/> (percent volume)</xsl:when>
      		<xsl:when test="$myparam.upper='W2'"><xsl:value-of select="$myparam"/> (wet kilo)</xsl:when>
      		<xsl:when test="$myparam.upper='WA'"><xsl:value-of select="$myparam"/> (watt per kilogram)</xsl:when>
      		<xsl:when test="$myparam.upper='WB'"><xsl:value-of select="$myparam"/> (wet pound)</xsl:when>
      		<xsl:when test="$myparam.upper='WCD'"><xsl:value-of select="$myparam"/> (cord)</xsl:when>
      		<xsl:when test="$myparam.upper='WE'"><xsl:value-of select="$myparam"/> (wet ton)</xsl:when>
      		<xsl:when test="$myparam.upper='WEB'"><xsl:value-of select="$myparam"/> (weber)</xsl:when>
      		<xsl:when test="$myparam.upper='WEE'"><xsl:value-of select="$myparam"/> (week)</xsl:when>
      		<xsl:when test="$myparam.upper='WG'"><xsl:value-of select="$myparam"/> (wine gallon)</xsl:when>
      		<xsl:when test="$myparam.upper='WHR'"><xsl:value-of select="$myparam"/> (watt hour)</xsl:when>
      		<xsl:when test="$myparam.upper='WM'"><xsl:value-of select="$myparam"/> (working month)</xsl:when>
      		<xsl:when test="$myparam.upper='WSD'"><xsl:value-of select="$myparam"/> (standard)</xsl:when>
      		<xsl:when test="$myparam.upper='WTT'"><xsl:value-of select="$myparam"/> (watt)</xsl:when>
      		<xsl:when test="$myparam.upper='X1'"><xsl:value-of select="$myparam"/> (Gunter's chain)</xsl:when>
      		<xsl:when test="$myparam.upper='YDK'"><xsl:value-of select="$myparam"/> (square yard)</xsl:when>
      		<xsl:when test="$myparam.upper='YDQ'"><xsl:value-of select="$myparam"/> (cubic yard)</xsl:when>
      		<xsl:when test="$myparam.upper='YRD'"><xsl:value-of select="$myparam"/> (yard)</xsl:when>
      		<xsl:when test="$myparam.upper='Z11'"><xsl:value-of select="$myparam"/> (hanging container)</xsl:when>
      		<xsl:when test="$myparam.upper='ZP'"><xsl:value-of select="$myparam"/> (page)</xsl:when>
      		<xsl:when test="$myparam.upper='ZZ'"><xsl:value-of select="$myparam"/> (mutually defined)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>