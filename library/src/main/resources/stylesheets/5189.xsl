<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.5189">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='1'"><xsl:value-of select="$myparam"/> (Handling commission)</xsl:when>
      		<xsl:when test="$myparam.upper='2'"><xsl:value-of select="$myparam"/> (Amendment commission)</xsl:when>
      		<xsl:when test="$myparam.upper='3'"><xsl:value-of select="$myparam"/> (Acceptance commission)</xsl:when>
      		<xsl:when test="$myparam.upper='4'"><xsl:value-of select="$myparam"/> (Commission for obtaining acceptance)</xsl:when>
      		<xsl:when test="$myparam.upper='5'"><xsl:value-of select="$myparam"/> (Commission on delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='6'"><xsl:value-of select="$myparam"/> (Advising commission)</xsl:when>
      		<xsl:when test="$myparam.upper='7'"><xsl:value-of select="$myparam"/> (Confirmation commission)</xsl:when>
      		<xsl:when test="$myparam.upper='8'"><xsl:value-of select="$myparam"/> (Deferred payment commission)</xsl:when>
      		<xsl:when test="$myparam.upper='9'"><xsl:value-of select="$myparam"/> (Commission for taking up documents)</xsl:when>
      		<xsl:when test="$myparam.upper='10'"><xsl:value-of select="$myparam"/> (Opening commission)</xsl:when>
      		<xsl:when test="$myparam.upper='11'"><xsl:value-of select="$myparam"/> (Fee for payment under reserve)</xsl:when>
      		<xsl:when test="$myparam.upper='12'"><xsl:value-of select="$myparam"/> (Discrepancy fee)</xsl:when>
      		<xsl:when test="$myparam.upper='13'"><xsl:value-of select="$myparam"/> (Domicilation commission)</xsl:when>
      		<xsl:when test="$myparam.upper='14'"><xsl:value-of select="$myparam"/> (Commission for release of goods)</xsl:when>
      		<xsl:when test="$myparam.upper='15'"><xsl:value-of select="$myparam"/> (Collection commission)</xsl:when>
      		<xsl:when test="$myparam.upper='16'"><xsl:value-of select="$myparam"/> (Negotiation commission)</xsl:when>
      		<xsl:when test="$myparam.upper='17'"><xsl:value-of select="$myparam"/> (Return commission)</xsl:when>
      		<xsl:when test="$myparam.upper='18'"><xsl:value-of select="$myparam"/> (B/L splitting charges)</xsl:when>
      		<xsl:when test="$myparam.upper='19'"><xsl:value-of select="$myparam"/> (Trust commission)</xsl:when>
      		<xsl:when test="$myparam.upper='20'"><xsl:value-of select="$myparam"/> (Transfer commission)</xsl:when>
      		<xsl:when test="$myparam.upper='21'"><xsl:value-of select="$myparam"/> (Commission for opening irrevocable documentary credits)</xsl:when>
      		<xsl:when test="$myparam.upper='22'"><xsl:value-of select="$myparam"/> (Pre-advice commission)</xsl:when>
      		<xsl:when test="$myparam.upper='23'"><xsl:value-of select="$myparam"/> (Supervisory commission)</xsl:when>
      		<xsl:when test="$myparam.upper='24'"><xsl:value-of select="$myparam"/> (Model charges)</xsl:when>
      		<xsl:when test="$myparam.upper='25'"><xsl:value-of select="$myparam"/> (Risk commission)</xsl:when>
      		<xsl:when test="$myparam.upper='26'"><xsl:value-of select="$myparam"/> (Guarantee commission)</xsl:when>
      		<xsl:when test="$myparam.upper='27'"><xsl:value-of select="$myparam"/> (Reimbursement commission)</xsl:when>
      		<xsl:when test="$myparam.upper='28'"><xsl:value-of select="$myparam"/> (Stamp duty)</xsl:when>
      		<xsl:when test="$myparam.upper='29'"><xsl:value-of select="$myparam"/> (Brokerage)</xsl:when>
      		<xsl:when test="$myparam.upper='30'"><xsl:value-of select="$myparam"/> (Bank charges)</xsl:when>
      		<xsl:when test="$myparam.upper='31'"><xsl:value-of select="$myparam"/> (Bank charges information)</xsl:when>
      		<xsl:when test="$myparam.upper='32'"><xsl:value-of select="$myparam"/> (Courier fee)</xsl:when>
      		<xsl:when test="$myparam.upper='33'"><xsl:value-of select="$myparam"/> (Phone fee)</xsl:when>
      		<xsl:when test="$myparam.upper='34'"><xsl:value-of select="$myparam"/> (Postage fee)</xsl:when>
      		<xsl:when test="$myparam.upper='35'"><xsl:value-of select="$myparam"/> (S.W.I.F.T. fee)</xsl:when>
      		<xsl:when test="$myparam.upper='36'"><xsl:value-of select="$myparam"/> (Telex fee)</xsl:when>
      		<xsl:when test="$myparam.upper='37'"><xsl:value-of select="$myparam"/> (Penalty for late delivery of documents)</xsl:when>
      		<xsl:when test="$myparam.upper='38'"><xsl:value-of select="$myparam"/> (Penalty for late delivery of valuation of works)</xsl:when>
      		<xsl:when test="$myparam.upper='39'"><xsl:value-of select="$myparam"/> (Penalty for execution of works behind schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='40'"><xsl:value-of select="$myparam"/> (Other penalties)</xsl:when>
      		<xsl:when test="$myparam.upper='41'"><xsl:value-of select="$myparam"/> (Bonus for works ahead of schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='42'"><xsl:value-of select="$myparam"/> (Other bonus)</xsl:when>
      		<xsl:when test="$myparam.upper='44'"><xsl:value-of select="$myparam"/> (Project management cost)</xsl:when>
      		<xsl:when test="$myparam.upper='45'"><xsl:value-of select="$myparam"/> (Pro rata retention)</xsl:when>
      		<xsl:when test="$myparam.upper='46'"><xsl:value-of select="$myparam"/> (Contractual retention)</xsl:when>
      		<xsl:when test="$myparam.upper='47'"><xsl:value-of select="$myparam"/> (Other retentions)</xsl:when>
      		<xsl:when test="$myparam.upper='48'"><xsl:value-of select="$myparam"/> (Interest on arrears)</xsl:when>
      		<xsl:when test="$myparam.upper='49'"><xsl:value-of select="$myparam"/> (Interest)</xsl:when>
      		<xsl:when test="$myparam.upper='50'"><xsl:value-of select="$myparam"/> (Charge per credit cover)</xsl:when>
      		<xsl:when test="$myparam.upper='51'"><xsl:value-of select="$myparam"/> (Charge per unused credit cover)</xsl:when>
      		<xsl:when test="$myparam.upper='52'"><xsl:value-of select="$myparam"/> (Minimum commission)</xsl:when>
      		<xsl:when test="$myparam.upper='53'"><xsl:value-of select="$myparam"/> (Factoring commission)</xsl:when>
      		<xsl:when test="$myparam.upper='54'"><xsl:value-of select="$myparam"/> (Chamber of commerce charge)</xsl:when>
      		<xsl:when test="$myparam.upper='55'"><xsl:value-of select="$myparam"/> (Transfer charges)</xsl:when>
      		<xsl:when test="$myparam.upper='56'"><xsl:value-of select="$myparam"/> (Repatriation charges)</xsl:when>
      		<xsl:when test="$myparam.upper='57'"><xsl:value-of select="$myparam"/> (Miscellaneous charges)</xsl:when>
      		<xsl:when test="$myparam.upper='58'"><xsl:value-of select="$myparam"/> (Foreign exchange charges)</xsl:when>
      		<xsl:when test="$myparam.upper='59'"><xsl:value-of select="$myparam"/> (Agreed debit interest charge)</xsl:when>
      		<xsl:when test="$myparam.upper='60'"><xsl:value-of select="$myparam"/> (Manufacturer's consumer discount)</xsl:when>
      		<xsl:when test="$myparam.upper='61'"><xsl:value-of select="$myparam"/> (Fax advice charge)</xsl:when>
      		<xsl:when test="$myparam.upper='62'"><xsl:value-of select="$myparam"/> (Due to military status)</xsl:when>
      		<xsl:when test="$myparam.upper='63'"><xsl:value-of select="$myparam"/> (Due to work accident)</xsl:when>
      		<xsl:when test="$myparam.upper='64'"><xsl:value-of select="$myparam"/> (Special agreement)</xsl:when>
      		<xsl:when test="$myparam.upper='65'"><xsl:value-of select="$myparam"/> (Production error discount)</xsl:when>
      		<xsl:when test="$myparam.upper='66'"><xsl:value-of select="$myparam"/> (New outlet discount)</xsl:when>
      		<xsl:when test="$myparam.upper='67'"><xsl:value-of select="$myparam"/> (Sample discount)</xsl:when>
      		<xsl:when test="$myparam.upper='68'"><xsl:value-of select="$myparam"/> (End-of-range discount)</xsl:when>
      		<xsl:when test="$myparam.upper='69'"><xsl:value-of select="$myparam"/> (Charge for a customer specific finish)</xsl:when>
      		<xsl:when test="$myparam.upper='70'"><xsl:value-of select="$myparam"/> (Incoterm discount)</xsl:when>
      		<xsl:when test="$myparam.upper='71'"><xsl:value-of select="$myparam"/> (Point of sales threshold allowance)</xsl:when>
      		<xsl:when test="$myparam.upper='72'"><xsl:value-of select="$myparam"/> (Technical modification costs)</xsl:when>
      		<xsl:when test="$myparam.upper='73'"><xsl:value-of select="$myparam"/> (Job-order production costs)</xsl:when>
      		<xsl:when test="$myparam.upper='74'"><xsl:value-of select="$myparam"/> (Off-premises costs)</xsl:when>
      		<xsl:when test="$myparam.upper='75'"><xsl:value-of select="$myparam"/> (Additional processing costs)</xsl:when>
      		<xsl:when test="$myparam.upper='76'"><xsl:value-of select="$myparam"/> (Attesting charge)</xsl:when>
      		<xsl:when test="$myparam.upper='77'"><xsl:value-of select="$myparam"/> (Rush delivery surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='78'"><xsl:value-of select="$myparam"/> (Special construction costs)</xsl:when>
      		<xsl:when test="$myparam.upper='79'"><xsl:value-of select="$myparam"/> (Freight charges)</xsl:when>
      		<xsl:when test="$myparam.upper='80'"><xsl:value-of select="$myparam"/> (Packing charge)</xsl:when>
      		<xsl:when test="$myparam.upper='81'"><xsl:value-of select="$myparam"/> (Repair charge)</xsl:when>
      		<xsl:when test="$myparam.upper='82'"><xsl:value-of select="$myparam"/> (Loading charge)</xsl:when>
      		<xsl:when test="$myparam.upper='83'"><xsl:value-of select="$myparam"/> (Setup charge)</xsl:when>
      		<xsl:when test="$myparam.upper='84'"><xsl:value-of select="$myparam"/> (Testing charge)</xsl:when>
      		<xsl:when test="$myparam.upper='85'"><xsl:value-of select="$myparam"/> (Warehousing charge)</xsl:when>
      		<xsl:when test="$myparam.upper='86'"><xsl:value-of select="$myparam"/> (Gold surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='87'"><xsl:value-of select="$myparam"/> (Copper surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='88'"><xsl:value-of select="$myparam"/> (Material surcharge/deduction)</xsl:when>
      		<xsl:when test="$myparam.upper='89'"><xsl:value-of select="$myparam"/> (Lead surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='90'"><xsl:value-of select="$myparam"/> (Price index surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='91'"><xsl:value-of select="$myparam"/> (Platinum surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='92'"><xsl:value-of select="$myparam"/> (Silver surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='93'"><xsl:value-of select="$myparam"/> (Wolfram surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='94'"><xsl:value-of select="$myparam"/> (Aluminum surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='95'"><xsl:value-of select="$myparam"/> (Discount)</xsl:when>
      		<xsl:when test="$myparam.upper='96'"><xsl:value-of select="$myparam"/> (Insurance)</xsl:when>
      		<xsl:when test="$myparam.upper='97'"><xsl:value-of select="$myparam"/> (Minimum order / minimum billing charge)</xsl:when>
      		<xsl:when test="$myparam.upper='98'"><xsl:value-of select="$myparam"/> (Material surcharge (special materials))</xsl:when>
      		<xsl:when test="$myparam.upper='99'"><xsl:value-of select="$myparam"/> (Surcharge)</xsl:when>
      		<xsl:when test="$myparam.upper='100'"><xsl:value-of select="$myparam"/> (Special rebate)</xsl:when>
      		<xsl:when test="$myparam.upper='101'"><xsl:value-of select="$myparam"/> (Carbon footprint charge)</xsl:when>
      		<xsl:when test="$myparam.upper='102'"><xsl:value-of select="$myparam"/> (Fixed long term)</xsl:when>
      		<xsl:when test="$myparam.upper='103'"><xsl:value-of select="$myparam"/> (Temporary)</xsl:when>
      		<xsl:when test="$myparam.upper='104'"><xsl:value-of select="$myparam"/> (Standard)</xsl:when>
      		<xsl:when test="$myparam.upper='105'"><xsl:value-of select="$myparam"/> (Yearly turnover)</xsl:when>
      		<xsl:when test="$myparam.upper='106'"><xsl:value-of select="$myparam"/> (Withheld taxes and social security contributions)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>