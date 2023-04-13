<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.4461">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='1'"><xsl:value-of select="$myparam"/> (Instrument not defined)</xsl:when>
      		<xsl:when test="$myparam.upper='2'"><xsl:value-of select="$myparam"/> (Automated clearing house credit)</xsl:when>
      		<xsl:when test="$myparam.upper='3'"><xsl:value-of select="$myparam"/> (Automated clearing house debit)</xsl:when>
      		<xsl:when test="$myparam.upper='4'"><xsl:value-of select="$myparam"/> (ACH demand debit reversal)</xsl:when>
      		<xsl:when test="$myparam.upper='5'"><xsl:value-of select="$myparam"/> (ACH demand credit reversal)</xsl:when>
      		<xsl:when test="$myparam.upper='6'"><xsl:value-of select="$myparam"/> (ACH demand credit)</xsl:when>
      		<xsl:when test="$myparam.upper='7'"><xsl:value-of select="$myparam"/> (ACH demand debit)</xsl:when>
      		<xsl:when test="$myparam.upper='8'"><xsl:value-of select="$myparam"/> (Hold)</xsl:when>
      		<xsl:when test="$myparam.upper='9'"><xsl:value-of select="$myparam"/> (National or regional clearing)</xsl:when>
      		<xsl:when test="$myparam.upper='10'"><xsl:value-of select="$myparam"/> (In cash)</xsl:when>
      		<xsl:when test="$myparam.upper='11'"><xsl:value-of select="$myparam"/> (ACH savings credit reversal)</xsl:when>
      		<xsl:when test="$myparam.upper='12'"><xsl:value-of select="$myparam"/> (ACH savings debit reversal)</xsl:when>
      		<xsl:when test="$myparam.upper='13'"><xsl:value-of select="$myparam"/> (ACH savings credit)</xsl:when>
      		<xsl:when test="$myparam.upper='14'"><xsl:value-of select="$myparam"/> (ACH savings debit)</xsl:when>
      		<xsl:when test="$myparam.upper='15'"><xsl:value-of select="$myparam"/> (Bookentry credit)</xsl:when>
      		<xsl:when test="$myparam.upper='16'"><xsl:value-of select="$myparam"/> (Bookentry debit)</xsl:when>
      		<xsl:when test="$myparam.upper='17'"><xsl:value-of select="$myparam"/> (ACH demand cash concentration/disbursement (CCD) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='18'"><xsl:value-of select="$myparam"/> (ACH demand cash concentration/disbursement (CCD) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='19'"><xsl:value-of select="$myparam"/> (ACH demand corporate trade payment (CTP) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='20'"><xsl:value-of select="$myparam"/> (Cheque)</xsl:when>
      		<xsl:when test="$myparam.upper='21'"><xsl:value-of select="$myparam"/> (Banker's draft)</xsl:when>
      		<xsl:when test="$myparam.upper='22'"><xsl:value-of select="$myparam"/> (Certified banker's draft)</xsl:when>
      		<xsl:when test="$myparam.upper='23'"><xsl:value-of select="$myparam"/> (Bank cheque (issued by a banking or similar establishment))</xsl:when>
      		<xsl:when test="$myparam.upper='24'"><xsl:value-of select="$myparam"/> (Bill of exchange awaiting acceptance)</xsl:when>
      		<xsl:when test="$myparam.upper='25'"><xsl:value-of select="$myparam"/> (Certified cheque)</xsl:when>
      		<xsl:when test="$myparam.upper='26'"><xsl:value-of select="$myparam"/> (Local cheque)</xsl:when>
      		<xsl:when test="$myparam.upper='27'"><xsl:value-of select="$myparam"/> (ACH demand corporate trade payment (CTP) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='28'"><xsl:value-of select="$myparam"/> (ACH demand corporate trade exchange (CTX) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='29'"><xsl:value-of select="$myparam"/> (ACH demand corporate trade exchange (CTX) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='30'"><xsl:value-of select="$myparam"/> (Credit transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='31'"><xsl:value-of select="$myparam"/> (Debit transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='32'"><xsl:value-of select="$myparam"/> (ACH demand cash concentration/disbursement plus (CCD+) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='33'"><xsl:value-of select="$myparam"/> (ACH demand cash concentration/disbursement plus (CCD+) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='34'"><xsl:value-of select="$myparam"/> (ACH prearranged payment and deposit (PPD))</xsl:when>
      		<xsl:when test="$myparam.upper='35'"><xsl:value-of select="$myparam"/> (ACH savings cash concentration/disbursement (CCD) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='36'"><xsl:value-of select="$myparam"/> (ACH savings cash concentration/disbursement (CCD) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='37'"><xsl:value-of select="$myparam"/> (ACH savings corporate trade payment (CTP) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='38'"><xsl:value-of select="$myparam"/> (ACH savings corporate trade payment (CTP) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='39'"><xsl:value-of select="$myparam"/> (ACH savings corporate trade exchange (CTX) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='40'"><xsl:value-of select="$myparam"/> (ACH savings corporate trade exchange (CTX) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='41'"><xsl:value-of select="$myparam"/> (ACH savings cash concentration/disbursement plus (CCD+) credit)</xsl:when>
      		<xsl:when test="$myparam.upper='42'"><xsl:value-of select="$myparam"/> (Payment to bank account)</xsl:when>
      		<xsl:when test="$myparam.upper='43'"><xsl:value-of select="$myparam"/> (ACH savings cash concentration/disbursement plus (CCD+) debit)</xsl:when>
      		<xsl:when test="$myparam.upper='44'"><xsl:value-of select="$myparam"/> (Accepted bill of exchange)</xsl:when>
      		<xsl:when test="$myparam.upper='45'"><xsl:value-of select="$myparam"/> (Referenced home-banking credit transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='46'"><xsl:value-of select="$myparam"/> (Interbank debit transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='47'"><xsl:value-of select="$myparam"/> (Home-banking debit transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='48'"><xsl:value-of select="$myparam"/> (Bank card)</xsl:when>
      		<xsl:when test="$myparam.upper='49'"><xsl:value-of select="$myparam"/> (Direct debit)</xsl:when>
      		<xsl:when test="$myparam.upper='50'"><xsl:value-of select="$myparam"/> (Payment by postgiro)</xsl:when>
      		<xsl:when test="$myparam.upper='51'"><xsl:value-of select="$myparam"/> (FR, norme 6 97-Telereglement CFONB (French Organisation for Banking Standards) - Option A)</xsl:when>
      		<xsl:when test="$myparam.upper='52'"><xsl:value-of select="$myparam"/> (Urgent commercial payment)</xsl:when>
      		<xsl:when test="$myparam.upper='53'"><xsl:value-of select="$myparam"/> (Urgent Treasury Payment)</xsl:when>
      		<xsl:when test="$myparam.upper='54'"><xsl:value-of select="$myparam"/> (Credit card)</xsl:when>
      		<xsl:when test="$myparam.upper='55'"><xsl:value-of select="$myparam"/> (Debit card)</xsl:when>
      		<xsl:when test="$myparam.upper='56'"><xsl:value-of select="$myparam"/> (Bankgiro)</xsl:when>
      		<xsl:when test="$myparam.upper='57'"><xsl:value-of select="$myparam"/> (Standing agreement)</xsl:when>
      		<xsl:when test="$myparam.upper='58'"><xsl:value-of select="$myparam"/> (SEPA credit transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='59'"><xsl:value-of select="$myparam"/> (SEPA direct debit)</xsl:when>
      		<xsl:when test="$myparam.upper='60'"><xsl:value-of select="$myparam"/> (Promissory note)</xsl:when>
      		<xsl:when test="$myparam.upper='61'"><xsl:value-of select="$myparam"/> (Promissory note signed by the debtor)</xsl:when>
      		<xsl:when test="$myparam.upper='62'"><xsl:value-of select="$myparam"/> (Promissory note signed by the debtor and endorsed by a bank)</xsl:when>
      		<xsl:when test="$myparam.upper='63'"><xsl:value-of select="$myparam"/> (Promissory note signed by the debtor and endorsed by a third party)</xsl:when>
      		<xsl:when test="$myparam.upper='64'"><xsl:value-of select="$myparam"/> (Promissory note signed by a bank)</xsl:when>
      		<xsl:when test="$myparam.upper='65'"><xsl:value-of select="$myparam"/> (Promissory note signed by a bank and endorsed by another bank)</xsl:when>
      		<xsl:when test="$myparam.upper='66'"><xsl:value-of select="$myparam"/> (Promissory note signed by a third party)</xsl:when>
      		<xsl:when test="$myparam.upper='67'"><xsl:value-of select="$myparam"/> (Promissory note signed by a third party and endorsed by a bank)</xsl:when>
      		<xsl:when test="$myparam.upper='68'"><xsl:value-of select="$myparam"/> (Online payment service)</xsl:when>
      		<xsl:when test="$myparam.upper='69'"><xsl:value-of select="$myparam"/> (Transfer Advice)</xsl:when>
      		<xsl:when test="$myparam.upper='70'"><xsl:value-of select="$myparam"/> (Bill drawn by the creditor on the debtor)</xsl:when>
      		<xsl:when test="$myparam.upper='74'"><xsl:value-of select="$myparam"/> (Bill drawn by the creditor on a bank)</xsl:when>
      		<xsl:when test="$myparam.upper='75'"><xsl:value-of select="$myparam"/> (Bill drawn by the creditor, endorsed by another bank)</xsl:when>
      		<xsl:when test="$myparam.upper='76'"><xsl:value-of select="$myparam"/> (Bill drawn by the creditor on a bank and endorsed by a third party)</xsl:when>
      		<xsl:when test="$myparam.upper='77'"><xsl:value-of select="$myparam"/> (Bill drawn by the creditor on a third party)</xsl:when>
      		<xsl:when test="$myparam.upper='78'"><xsl:value-of select="$myparam"/> (Bill drawn by creditor on third party, accepted and endorsed by bank)</xsl:when>
      		<xsl:when test="$myparam.upper='91'"><xsl:value-of select="$myparam"/> (Not transferable banker's draft)</xsl:when>
      		<xsl:when test="$myparam.upper='92'"><xsl:value-of select="$myparam"/> (Not transferable local cheque)</xsl:when>
      		<xsl:when test="$myparam.upper='93'"><xsl:value-of select="$myparam"/> (Reference giro)</xsl:when>
      		<xsl:when test="$myparam.upper='94'"><xsl:value-of select="$myparam"/> (Urgent giro)</xsl:when>
      		<xsl:when test="$myparam.upper='95'"><xsl:value-of select="$myparam"/> (Free format giro)</xsl:when>
      		<xsl:when test="$myparam.upper='96'"><xsl:value-of select="$myparam"/> (Requested method for payment was not used)</xsl:when>
      		<xsl:when test="$myparam.upper='97'"><xsl:value-of select="$myparam"/> (Clearing between partners)</xsl:when>
      		<xsl:when test="$myparam.upper='ZZZ'"><xsl:value-of select="$myparam"/> (Mutually defined)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>