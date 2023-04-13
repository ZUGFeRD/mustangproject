<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.untdid.1001">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='1'"><xsl:value-of select="$myparam"/> (Certificate of analysis)</xsl:when>
      		<xsl:when test="$myparam.upper='2'"><xsl:value-of select="$myparam"/> (Certificate of conformity)</xsl:when>
      		<xsl:when test="$myparam.upper='3'"><xsl:value-of select="$myparam"/> (Certificate of quality)</xsl:when>
      		<xsl:when test="$myparam.upper='4'"><xsl:value-of select="$myparam"/> (Test report)</xsl:when>
      		<xsl:when test="$myparam.upper='5'"><xsl:value-of select="$myparam"/> (Product performance report)</xsl:when>
      		<xsl:when test="$myparam.upper='6'"><xsl:value-of select="$myparam"/> (Product specification report)</xsl:when>
      		<xsl:when test="$myparam.upper='7'"><xsl:value-of select="$myparam"/> (Process data report)</xsl:when>
      		<xsl:when test="$myparam.upper='8'"><xsl:value-of select="$myparam"/> (First sample test report)</xsl:when>
      		<xsl:when test="$myparam.upper='9'"><xsl:value-of select="$myparam"/> (Price/sales catalogue)</xsl:when>
      		<xsl:when test="$myparam.upper='10'"><xsl:value-of select="$myparam"/> (Party information)</xsl:when>
      		<xsl:when test="$myparam.upper='11'"><xsl:value-of select="$myparam"/> (Federal label approval)</xsl:when>
      		<xsl:when test="$myparam.upper='12'"><xsl:value-of select="$myparam"/> (Mill certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='13'"><xsl:value-of select="$myparam"/> (Post receipt)</xsl:when>
      		<xsl:when test="$myparam.upper='14'"><xsl:value-of select="$myparam"/> (Weight certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='15'"><xsl:value-of select="$myparam"/> (Weight list)</xsl:when>
      		<xsl:when test="$myparam.upper='16'"><xsl:value-of select="$myparam"/> (Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='17'"><xsl:value-of select="$myparam"/> (Combined certificate of value and origin)</xsl:when>
      		<xsl:when test="$myparam.upper='18'"><xsl:value-of select="$myparam"/> (Movement certificate A.TR.1)</xsl:when>
      		<xsl:when test="$myparam.upper='19'"><xsl:value-of select="$myparam"/> (Certificate of quantity)</xsl:when>
      		<xsl:when test="$myparam.upper='20'"><xsl:value-of select="$myparam"/> (Quality data message)</xsl:when>
      		<xsl:when test="$myparam.upper='21'"><xsl:value-of select="$myparam"/> (Query)</xsl:when>
      		<xsl:when test="$myparam.upper='22'"><xsl:value-of select="$myparam"/> (Response to query)</xsl:when>
      		<xsl:when test="$myparam.upper='23'"><xsl:value-of select="$myparam"/> (Status information)</xsl:when>
      		<xsl:when test="$myparam.upper='24'"><xsl:value-of select="$myparam"/> (Restow)</xsl:when>
      		<xsl:when test="$myparam.upper='25'"><xsl:value-of select="$myparam"/> (Container discharge list)</xsl:when>
      		<xsl:when test="$myparam.upper='26'"><xsl:value-of select="$myparam"/> (Corporate superannuation contributions advice)</xsl:when>
      		<xsl:when test="$myparam.upper='27'"><xsl:value-of select="$myparam"/> (Industry superannuation contributions advice)</xsl:when>
      		<xsl:when test="$myparam.upper='28'"><xsl:value-of select="$myparam"/> (Corporate superannuation member maintenance message)</xsl:when>
      		<xsl:when test="$myparam.upper='29'"><xsl:value-of select="$myparam"/> (Industry superannuation member maintenance message)</xsl:when>
      		<xsl:when test="$myparam.upper='30'"><xsl:value-of select="$myparam"/> (Life insurance payroll deductions advice)</xsl:when>
      		<xsl:when test="$myparam.upper='31'"><xsl:value-of select="$myparam"/> (Underbond request)</xsl:when>
      		<xsl:when test="$myparam.upper='32'"><xsl:value-of select="$myparam"/> (Underbond approval)</xsl:when>
      		<xsl:when test="$myparam.upper='33'"><xsl:value-of select="$myparam"/> (Certificate of sealing of export meat lockers)</xsl:when>
      		<xsl:when test="$myparam.upper='34'"><xsl:value-of select="$myparam"/> (Cargo status)</xsl:when>
      		<xsl:when test="$myparam.upper='35'"><xsl:value-of select="$myparam"/> (Inventory report)</xsl:when>
      		<xsl:when test="$myparam.upper='36'"><xsl:value-of select="$myparam"/> (Identity card)</xsl:when>
      		<xsl:when test="$myparam.upper='37'"><xsl:value-of select="$myparam"/> (Response to a trade statistics message)</xsl:when>
      		<xsl:when test="$myparam.upper='38'"><xsl:value-of select="$myparam"/> (Vaccination certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='39'"><xsl:value-of select="$myparam"/> (Passport)</xsl:when>
      		<xsl:when test="$myparam.upper='40'"><xsl:value-of select="$myparam"/> (Driving licence (national))</xsl:when>
      		<xsl:when test="$myparam.upper='41'"><xsl:value-of select="$myparam"/> (Driving licence (international))</xsl:when>
      		<xsl:when test="$myparam.upper='42'"><xsl:value-of select="$myparam"/> (Free pass)</xsl:when>
      		<xsl:when test="$myparam.upper='43'"><xsl:value-of select="$myparam"/> (Season ticket)</xsl:when>
      		<xsl:when test="$myparam.upper='44'"><xsl:value-of select="$myparam"/> (Transport status report)</xsl:when>
      		<xsl:when test="$myparam.upper='45'"><xsl:value-of select="$myparam"/> (Transport status request)</xsl:when>
      		<xsl:when test="$myparam.upper='46'"><xsl:value-of select="$myparam"/> (Banking status)</xsl:when>
      		<xsl:when test="$myparam.upper='47'"><xsl:value-of select="$myparam"/> (Extra-Community trade statistical declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='48'"><xsl:value-of select="$myparam"/> (Written instructions in conformance with ADR article number 10385)</xsl:when>
      		<xsl:when test="$myparam.upper='49'"><xsl:value-of select="$myparam"/> (Damage certification)</xsl:when>
      		<xsl:when test="$myparam.upper='50'"><xsl:value-of select="$myparam"/> (Validated priced tender)</xsl:when>
      		<xsl:when test="$myparam.upper='51'"><xsl:value-of select="$myparam"/> (Price/sales catalogue response)</xsl:when>
      		<xsl:when test="$myparam.upper='52'"><xsl:value-of select="$myparam"/> (Price negotiation result)</xsl:when>
      		<xsl:when test="$myparam.upper='53'"><xsl:value-of select="$myparam"/> (Safety and hazard data sheet)</xsl:when>
      		<xsl:when test="$myparam.upper='54'"><xsl:value-of select="$myparam"/> (Legal statement of an account)</xsl:when>
      		<xsl:when test="$myparam.upper='55'"><xsl:value-of select="$myparam"/> (Listing statement of an account)</xsl:when>
      		<xsl:when test="$myparam.upper='56'"><xsl:value-of select="$myparam"/> (Closing statement of an account)</xsl:when>
      		<xsl:when test="$myparam.upper='57'"><xsl:value-of select="$myparam"/> (Transport equipment on-hire report)</xsl:when>
      		<xsl:when test="$myparam.upper='58'"><xsl:value-of select="$myparam"/> (Transport equipment off-hire report)</xsl:when>
      		<xsl:when test="$myparam.upper='59'"><xsl:value-of select="$myparam"/> (Treatment - nil outturn)</xsl:when>
      		<xsl:when test="$myparam.upper='60'"><xsl:value-of select="$myparam"/> (Treatment - time-up underbond)</xsl:when>
      		<xsl:when test="$myparam.upper='61'"><xsl:value-of select="$myparam"/> (Treatment - underbond by sea)</xsl:when>
      		<xsl:when test="$myparam.upper='62'"><xsl:value-of select="$myparam"/> (Treatment - personal effect)</xsl:when>
      		<xsl:when test="$myparam.upper='63'"><xsl:value-of select="$myparam"/> (Treatment - timber)</xsl:when>
      		<xsl:when test="$myparam.upper='64'"><xsl:value-of select="$myparam"/> (Preliminary credit assessment)</xsl:when>
      		<xsl:when test="$myparam.upper='65'"><xsl:value-of select="$myparam"/> (Credit cover)</xsl:when>
      		<xsl:when test="$myparam.upper='66'"><xsl:value-of select="$myparam"/> (Current account)</xsl:when>
      		<xsl:when test="$myparam.upper='67'"><xsl:value-of select="$myparam"/> (Commercial dispute)</xsl:when>
      		<xsl:when test="$myparam.upper='68'"><xsl:value-of select="$myparam"/> (Chargeback)</xsl:when>
      		<xsl:when test="$myparam.upper='69'"><xsl:value-of select="$myparam"/> (Reassignment)</xsl:when>
      		<xsl:when test="$myparam.upper='70'"><xsl:value-of select="$myparam"/> (Collateral account)</xsl:when>
      		<xsl:when test="$myparam.upper='71'"><xsl:value-of select="$myparam"/> (Request for payment)</xsl:when>
      		<xsl:when test="$myparam.upper='72'"><xsl:value-of select="$myparam"/> (Unship permit)</xsl:when>
      		<xsl:when test="$myparam.upper='73'"><xsl:value-of select="$myparam"/> (Statistical definitions)</xsl:when>
      		<xsl:when test="$myparam.upper='74'"><xsl:value-of select="$myparam"/> (Statistical data)</xsl:when>
      		<xsl:when test="$myparam.upper='75'"><xsl:value-of select="$myparam"/> (Request for statistical data)</xsl:when>
      		<xsl:when test="$myparam.upper='76'"><xsl:value-of select="$myparam"/> (Call-off delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='77'"><xsl:value-of select="$myparam"/> (Consignment status report)</xsl:when>
      		<xsl:when test="$myparam.upper='78'"><xsl:value-of select="$myparam"/> (Inventory movement advice)</xsl:when>
      		<xsl:when test="$myparam.upper='79'"><xsl:value-of select="$myparam"/> (Inventory status advice)</xsl:when>
      		<xsl:when test="$myparam.upper='80'"><xsl:value-of select="$myparam"/> (Debit note related to goods or services)</xsl:when>
      		<xsl:when test="$myparam.upper='81'"><xsl:value-of select="$myparam"/> (Credit note related to goods or services)</xsl:when>
      		<xsl:when test="$myparam.upper='82'"><xsl:value-of select="$myparam"/> (Metered services invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='83'"><xsl:value-of select="$myparam"/> (Credit note related to financial adjustments)</xsl:when>
      		<xsl:when test="$myparam.upper='84'"><xsl:value-of select="$myparam"/> (Debit note related to financial adjustments)</xsl:when>
      		<xsl:when test="$myparam.upper='85'"><xsl:value-of select="$myparam"/> (Customs manifest)</xsl:when>
      		<xsl:when test="$myparam.upper='86'"><xsl:value-of select="$myparam"/> (Vessel unpack report)</xsl:when>
      		<xsl:when test="$myparam.upper='87'"><xsl:value-of select="$myparam"/> (General cargo summary manifest report)</xsl:when>
      		<xsl:when test="$myparam.upper='88'"><xsl:value-of select="$myparam"/> (Consignment unpack report)</xsl:when>
      		<xsl:when test="$myparam.upper='89'"><xsl:value-of select="$myparam"/> (Meat and meat by-products sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='90'"><xsl:value-of select="$myparam"/> (Meat food products sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='91'"><xsl:value-of select="$myparam"/> (Poultry sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='92'"><xsl:value-of select="$myparam"/> (Horsemeat sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='93'"><xsl:value-of select="$myparam"/> (Casing sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='94'"><xsl:value-of select="$myparam"/> (Pharmaceutical sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='95'"><xsl:value-of select="$myparam"/> (Inedible sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='96'"><xsl:value-of select="$myparam"/> (Impending arrival)</xsl:when>
      		<xsl:when test="$myparam.upper='97'"><xsl:value-of select="$myparam"/> (Means of transport advice)</xsl:when>
      		<xsl:when test="$myparam.upper='98'"><xsl:value-of select="$myparam"/> (Arrival information)</xsl:when>
      		<xsl:when test="$myparam.upper='99'"><xsl:value-of select="$myparam"/> (Cargo release notification)</xsl:when>
      		<xsl:when test="$myparam.upper='100'"><xsl:value-of select="$myparam"/> (Excise certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='101'"><xsl:value-of select="$myparam"/> (Registration document)</xsl:when>
      		<xsl:when test="$myparam.upper='102'"><xsl:value-of select="$myparam"/> (Tax notification)</xsl:when>
      		<xsl:when test="$myparam.upper='103'"><xsl:value-of select="$myparam"/> (Transport equipment direct interchange report)</xsl:when>
      		<xsl:when test="$myparam.upper='104'"><xsl:value-of select="$myparam"/> (Transport equipment impending arrival advice)</xsl:when>
      		<xsl:when test="$myparam.upper='105'"><xsl:value-of select="$myparam"/> (Purchase order)</xsl:when>
      		<xsl:when test="$myparam.upper='106'"><xsl:value-of select="$myparam"/> (Transport equipment damage report)</xsl:when>
      		<xsl:when test="$myparam.upper='107'"><xsl:value-of select="$myparam"/> (Transport equipment maintenance and repair work estimate advice)</xsl:when>
      		<xsl:when test="$myparam.upper='108'"><xsl:value-of select="$myparam"/> (Transport equipment empty release instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='109'"><xsl:value-of select="$myparam"/> (Transport movement gate in report)</xsl:when>
      		<xsl:when test="$myparam.upper='110'"><xsl:value-of select="$myparam"/> (Manufacturing instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='111'"><xsl:value-of select="$myparam"/> (Transport movement gate out report)</xsl:when>
      		<xsl:when test="$myparam.upper='112'"><xsl:value-of select="$myparam"/> (Transport equipment unpacking instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='113'"><xsl:value-of select="$myparam"/> (Transport equipment unpacking report)</xsl:when>
      		<xsl:when test="$myparam.upper='114'"><xsl:value-of select="$myparam"/> (Transport equipment pick-up availability request)</xsl:when>
      		<xsl:when test="$myparam.upper='115'"><xsl:value-of select="$myparam"/> (Transport equipment pick-up availability confirmation)</xsl:when>
      		<xsl:when test="$myparam.upper='116'"><xsl:value-of select="$myparam"/> (Transport equipment pick-up report)</xsl:when>
      		<xsl:when test="$myparam.upper='117'"><xsl:value-of select="$myparam"/> (Transport equipment shift report)</xsl:when>
      		<xsl:when test="$myparam.upper='118'"><xsl:value-of select="$myparam"/> (Transport discharge instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='119'"><xsl:value-of select="$myparam"/> (Transport discharge report)</xsl:when>
      		<xsl:when test="$myparam.upper='120'"><xsl:value-of select="$myparam"/> (Stores requisition)</xsl:when>
      		<xsl:when test="$myparam.upper='121'"><xsl:value-of select="$myparam"/> (Transport loading instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='122'"><xsl:value-of select="$myparam"/> (Transport loading report)</xsl:when>
      		<xsl:when test="$myparam.upper='123'"><xsl:value-of select="$myparam"/> (Transport equipment maintenance and repair work authorisation)</xsl:when>
      		<xsl:when test="$myparam.upper='124'"><xsl:value-of select="$myparam"/> (Transport departure report)</xsl:when>
      		<xsl:when test="$myparam.upper='125'"><xsl:value-of select="$myparam"/> (Transport empty equipment advice)</xsl:when>
      		<xsl:when test="$myparam.upper='126'"><xsl:value-of select="$myparam"/> (Transport equipment acceptance order)</xsl:when>
      		<xsl:when test="$myparam.upper='127'"><xsl:value-of select="$myparam"/> (Transport equipment special service instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='128'"><xsl:value-of select="$myparam"/> (Transport equipment stock report)</xsl:when>
      		<xsl:when test="$myparam.upper='129'"><xsl:value-of select="$myparam"/> (Transport cargo release order)</xsl:when>
      		<xsl:when test="$myparam.upper='130'"><xsl:value-of select="$myparam"/> (Invoicing data sheet)</xsl:when>
      		<xsl:when test="$myparam.upper='131'"><xsl:value-of select="$myparam"/> (Transport equipment packing instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='132'"><xsl:value-of select="$myparam"/> (Customs clearance notice)</xsl:when>
      		<xsl:when test="$myparam.upper='133'"><xsl:value-of select="$myparam"/> (Customs documents expiration notice)</xsl:when>
      		<xsl:when test="$myparam.upper='134'"><xsl:value-of select="$myparam"/> (Transport equipment on-hire request)</xsl:when>
      		<xsl:when test="$myparam.upper='135'"><xsl:value-of select="$myparam"/> (Transport equipment on-hire order)</xsl:when>
      		<xsl:when test="$myparam.upper='136'"><xsl:value-of select="$myparam"/> (Transport equipment off-hire request)</xsl:when>
      		<xsl:when test="$myparam.upper='137'"><xsl:value-of select="$myparam"/> (Transport equipment survey order)</xsl:when>
      		<xsl:when test="$myparam.upper='138'"><xsl:value-of select="$myparam"/> (Transport equipment survey order response)</xsl:when>
      		<xsl:when test="$myparam.upper='139'"><xsl:value-of select="$myparam"/> (Transport equipment survey report)</xsl:when>
      		<xsl:when test="$myparam.upper='140'"><xsl:value-of select="$myparam"/> (Packing instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='141'"><xsl:value-of select="$myparam"/> (Advising items to be booked to a financial account)</xsl:when>
      		<xsl:when test="$myparam.upper='142'"><xsl:value-of select="$myparam"/> (Transport equipment maintenance and repair work estimate order)</xsl:when>
      		<xsl:when test="$myparam.upper='143'"><xsl:value-of select="$myparam"/> (Transport equipment maintenance and repair notice)</xsl:when>
      		<xsl:when test="$myparam.upper='144'"><xsl:value-of select="$myparam"/> (Empty container disposition order)</xsl:when>
      		<xsl:when test="$myparam.upper='145'"><xsl:value-of select="$myparam"/> (Cargo vessel discharge order)</xsl:when>
      		<xsl:when test="$myparam.upper='146'"><xsl:value-of select="$myparam"/> (Cargo vessel loading order)</xsl:when>
      		<xsl:when test="$myparam.upper='147'"><xsl:value-of select="$myparam"/> (Multidrop order)</xsl:when>
      		<xsl:when test="$myparam.upper='148'"><xsl:value-of select="$myparam"/> (Bailment contract)</xsl:when>
      		<xsl:when test="$myparam.upper='149'"><xsl:value-of select="$myparam"/> (Basic agreement)</xsl:when>
      		<xsl:when test="$myparam.upper='150'"><xsl:value-of select="$myparam"/> (Internal transport order)</xsl:when>
      		<xsl:when test="$myparam.upper='151'"><xsl:value-of select="$myparam"/> (Grant)</xsl:when>
      		<xsl:when test="$myparam.upper='152'"><xsl:value-of select="$myparam"/> (Indefinite delivery indefinite quantity contract)</xsl:when>
      		<xsl:when test="$myparam.upper='153'"><xsl:value-of select="$myparam"/> (Indefinite delivery definite quantity contract)</xsl:when>
      		<xsl:when test="$myparam.upper='154'"><xsl:value-of select="$myparam"/> (Requirements contract)</xsl:when>
      		<xsl:when test="$myparam.upper='155'"><xsl:value-of select="$myparam"/> (Task order)</xsl:when>
      		<xsl:when test="$myparam.upper='156'"><xsl:value-of select="$myparam"/> (Make or buy plan)</xsl:when>
      		<xsl:when test="$myparam.upper='157'"><xsl:value-of select="$myparam"/> (Subcontractor plan)</xsl:when>
      		<xsl:when test="$myparam.upper='158'"><xsl:value-of select="$myparam"/> (Cost data summary)</xsl:when>
      		<xsl:when test="$myparam.upper='159'"><xsl:value-of select="$myparam"/> (Certified cost and price data)</xsl:when>
      		<xsl:when test="$myparam.upper='160'"><xsl:value-of select="$myparam"/> (Wage determination)</xsl:when>
      		<xsl:when test="$myparam.upper='161'"><xsl:value-of select="$myparam"/> (Contract Funds Status Report (CFSR))</xsl:when>
      		<xsl:when test="$myparam.upper='162'"><xsl:value-of select="$myparam"/> (Certified inspection and test results)</xsl:when>
      		<xsl:when test="$myparam.upper='163'"><xsl:value-of select="$myparam"/> (Material inspection and receiving report)</xsl:when>
      		<xsl:when test="$myparam.upper='164'"><xsl:value-of select="$myparam"/> (Purchasing specification)</xsl:when>
      		<xsl:when test="$myparam.upper='165'"><xsl:value-of select="$myparam"/> (Payment or performance bond)</xsl:when>
      		<xsl:when test="$myparam.upper='166'"><xsl:value-of select="$myparam"/> (Contract security classification specification)</xsl:when>
      		<xsl:when test="$myparam.upper='167'"><xsl:value-of select="$myparam"/> (Manufacturing specification)</xsl:when>
      		<xsl:when test="$myparam.upper='168'"><xsl:value-of select="$myparam"/> (Buy America certificate of compliance)</xsl:when>
      		<xsl:when test="$myparam.upper='169'"><xsl:value-of select="$myparam"/> (Container off-hire notice)</xsl:when>
      		<xsl:when test="$myparam.upper='170'"><xsl:value-of select="$myparam"/> (Cargo acceptance order)</xsl:when>
      		<xsl:when test="$myparam.upper='171'"><xsl:value-of select="$myparam"/> (Pick-up notice)</xsl:when>
      		<xsl:when test="$myparam.upper='172'"><xsl:value-of select="$myparam"/> (Authorisation to plan and suggest orders)</xsl:when>
      		<xsl:when test="$myparam.upper='173'"><xsl:value-of select="$myparam"/> (Authorisation to plan and ship orders)</xsl:when>
      		<xsl:when test="$myparam.upper='174'"><xsl:value-of select="$myparam"/> (Drawing)</xsl:when>
      		<xsl:when test="$myparam.upper='175'"><xsl:value-of select="$myparam"/> (Cost Performance Report (CPR) format 2)</xsl:when>
      		<xsl:when test="$myparam.upper='176'"><xsl:value-of select="$myparam"/> (Cost Schedule Status Report (CSSR))</xsl:when>
      		<xsl:when test="$myparam.upper='177'"><xsl:value-of select="$myparam"/> (Cost Performance Report (CPR) format 1)</xsl:when>
      		<xsl:when test="$myparam.upper='178'"><xsl:value-of select="$myparam"/> (Cost Performance Report (CPR) format 3)</xsl:when>
      		<xsl:when test="$myparam.upper='179'"><xsl:value-of select="$myparam"/> (Cost Performance Report (CPR) format 4)</xsl:when>
      		<xsl:when test="$myparam.upper='180'"><xsl:value-of select="$myparam"/> (Cost Performance Report (CPR) format 5)</xsl:when>
      		<xsl:when test="$myparam.upper='181'"><xsl:value-of select="$myparam"/> (Progressive discharge report)</xsl:when>
      		<xsl:when test="$myparam.upper='182'"><xsl:value-of select="$myparam"/> (Balance confirmation)</xsl:when>
      		<xsl:when test="$myparam.upper='183'"><xsl:value-of select="$myparam"/> (Container stripping order)</xsl:when>
      		<xsl:when test="$myparam.upper='184'"><xsl:value-of select="$myparam"/> (Container stuffing order)</xsl:when>
      		<xsl:when test="$myparam.upper='185'"><xsl:value-of select="$myparam"/> (Conveyance declaration (arrival))</xsl:when>
      		<xsl:when test="$myparam.upper='186'"><xsl:value-of select="$myparam"/> (Conveyance declaration (departure))</xsl:when>
      		<xsl:when test="$myparam.upper='187'"><xsl:value-of select="$myparam"/> (Conveyance declaration (combined))</xsl:when>
      		<xsl:when test="$myparam.upper='188'"><xsl:value-of select="$myparam"/> (Project recovery plan)</xsl:when>
      		<xsl:when test="$myparam.upper='189'"><xsl:value-of select="$myparam"/> (Project production plan)</xsl:when>
      		<xsl:when test="$myparam.upper='190'"><xsl:value-of select="$myparam"/> (Statistical and other administrative internal documents)</xsl:when>
      		<xsl:when test="$myparam.upper='191'"><xsl:value-of select="$myparam"/> (Project master schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='192'"><xsl:value-of select="$myparam"/> (Priced alternate tender bill of quantity)</xsl:when>
      		<xsl:when test="$myparam.upper='193'"><xsl:value-of select="$myparam"/> (Estimated priced bill of quantity)</xsl:when>
      		<xsl:when test="$myparam.upper='194'"><xsl:value-of select="$myparam"/> (Draft bill of quantity)</xsl:when>
      		<xsl:when test="$myparam.upper='195'"><xsl:value-of select="$myparam"/> (Documentary credit collection instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='196'"><xsl:value-of select="$myparam"/> (Request for an amendment of a documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='197'"><xsl:value-of select="$myparam"/> (Documentary credit amendment information)</xsl:when>
      		<xsl:when test="$myparam.upper='198'"><xsl:value-of select="$myparam"/> (Advice of an amendment of a documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='199'"><xsl:value-of select="$myparam"/> (Response to an amendment of a documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='200'"><xsl:value-of select="$myparam"/> (Documentary credit issuance information)</xsl:when>
      		<xsl:when test="$myparam.upper='201'"><xsl:value-of select="$myparam"/> (Direct payment valuation request)</xsl:when>
      		<xsl:when test="$myparam.upper='202'"><xsl:value-of select="$myparam"/> (Direct payment valuation)</xsl:when>
      		<xsl:when test="$myparam.upper='203'"><xsl:value-of select="$myparam"/> (Provisional payment valuation)</xsl:when>
      		<xsl:when test="$myparam.upper='204'"><xsl:value-of select="$myparam"/> (Payment valuation)</xsl:when>
      		<xsl:when test="$myparam.upper='205'"><xsl:value-of select="$myparam"/> (Quantity valuation)</xsl:when>
      		<xsl:when test="$myparam.upper='206'"><xsl:value-of select="$myparam"/> (Quantity valuation request)</xsl:when>
      		<xsl:when test="$myparam.upper='207'"><xsl:value-of select="$myparam"/> (Contract bill of quantities - BOQ)</xsl:when>
      		<xsl:when test="$myparam.upper='208'"><xsl:value-of select="$myparam"/> (Unpriced bill of quantity)</xsl:when>
      		<xsl:when test="$myparam.upper='209'"><xsl:value-of select="$myparam"/> (Priced tender BOQ)</xsl:when>
      		<xsl:when test="$myparam.upper='210'"><xsl:value-of select="$myparam"/> (Enquiry)</xsl:when>
      		<xsl:when test="$myparam.upper='211'"><xsl:value-of select="$myparam"/> (Interim application for payment)</xsl:when>
      		<xsl:when test="$myparam.upper='212'"><xsl:value-of select="$myparam"/> (Agreement to pay)</xsl:when>
      		<xsl:when test="$myparam.upper='213'"><xsl:value-of select="$myparam"/> (Request for financial cancellation)</xsl:when>
      		<xsl:when test="$myparam.upper='214'"><xsl:value-of select="$myparam"/> (Pre-authorised direct debit(s))</xsl:when>
      		<xsl:when test="$myparam.upper='215'"><xsl:value-of select="$myparam"/> (Letter of intent)</xsl:when>
      		<xsl:when test="$myparam.upper='216'"><xsl:value-of select="$myparam"/> (Approved unpriced bill of quantity)</xsl:when>
      		<xsl:when test="$myparam.upper='217'"><xsl:value-of select="$myparam"/> (Payment valuation for unscheduled items)</xsl:when>
      		<xsl:when test="$myparam.upper='218'"><xsl:value-of select="$myparam"/> (Final payment request based on completion of work)</xsl:when>
      		<xsl:when test="$myparam.upper='219'"><xsl:value-of select="$myparam"/> (Payment request for completed units)</xsl:when>
      		<xsl:when test="$myparam.upper='220'"><xsl:value-of select="$myparam"/> (Order)</xsl:when>
      		<xsl:when test="$myparam.upper='221'"><xsl:value-of select="$myparam"/> (Blanket order)</xsl:when>
      		<xsl:when test="$myparam.upper='222'"><xsl:value-of select="$myparam"/> (Spot order)</xsl:when>
      		<xsl:when test="$myparam.upper='223'"><xsl:value-of select="$myparam"/> (Lease order)</xsl:when>
      		<xsl:when test="$myparam.upper='224'"><xsl:value-of select="$myparam"/> (Rush order)</xsl:when>
      		<xsl:when test="$myparam.upper='225'"><xsl:value-of select="$myparam"/> (Repair order)</xsl:when>
      		<xsl:when test="$myparam.upper='226'"><xsl:value-of select="$myparam"/> (Call off order)</xsl:when>
      		<xsl:when test="$myparam.upper='227'"><xsl:value-of select="$myparam"/> (Consignment order)</xsl:when>
      		<xsl:when test="$myparam.upper='228'"><xsl:value-of select="$myparam"/> (Sample order)</xsl:when>
      		<xsl:when test="$myparam.upper='229'"><xsl:value-of select="$myparam"/> (Swap order)</xsl:when>
      		<xsl:when test="$myparam.upper='230'"><xsl:value-of select="$myparam"/> (Purchase order change request)</xsl:when>
      		<xsl:when test="$myparam.upper='231'"><xsl:value-of select="$myparam"/> (Purchase order response)</xsl:when>
      		<xsl:when test="$myparam.upper='232'"><xsl:value-of select="$myparam"/> (Hire order)</xsl:when>
      		<xsl:when test="$myparam.upper='233'"><xsl:value-of select="$myparam"/> (Spare parts order)</xsl:when>
      		<xsl:when test="$myparam.upper='234'"><xsl:value-of select="$myparam"/> (Campaign price/sales catalogue)</xsl:when>
      		<xsl:when test="$myparam.upper='235'"><xsl:value-of select="$myparam"/> (Container list)</xsl:when>
      		<xsl:when test="$myparam.upper='236'"><xsl:value-of select="$myparam"/> (Delivery forecast)</xsl:when>
      		<xsl:when test="$myparam.upper='237'"><xsl:value-of select="$myparam"/> (Cross docking services order)</xsl:when>
      		<xsl:when test="$myparam.upper='238'"><xsl:value-of select="$myparam"/> (Non-pre-authorised direct debit(s))</xsl:when>
      		<xsl:when test="$myparam.upper='239'"><xsl:value-of select="$myparam"/> (Rejected direct debit(s))</xsl:when>
      		<xsl:when test="$myparam.upper='240'"><xsl:value-of select="$myparam"/> (Delivery instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='241'"><xsl:value-of select="$myparam"/> (Delivery schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='242'"><xsl:value-of select="$myparam"/> (Delivery just-in-time)</xsl:when>
      		<xsl:when test="$myparam.upper='243'"><xsl:value-of select="$myparam"/> (Pre-authorised direct debit request(s))</xsl:when>
      		<xsl:when test="$myparam.upper='244'"><xsl:value-of select="$myparam"/> (Non-pre-authorised direct debit request(s))</xsl:when>
      		<xsl:when test="$myparam.upper='245'"><xsl:value-of select="$myparam"/> (Delivery release)</xsl:when>
      		<xsl:when test="$myparam.upper='246'"><xsl:value-of select="$myparam"/> (Settlement of a letter of credit)</xsl:when>
      		<xsl:when test="$myparam.upper='247'"><xsl:value-of select="$myparam"/> (Bank to bank funds transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='248'"><xsl:value-of select="$myparam"/> (Customer payment order(s))</xsl:when>
      		<xsl:when test="$myparam.upper='249'"><xsl:value-of select="$myparam"/> (Low value payment order(s))</xsl:when>
      		<xsl:when test="$myparam.upper='250'"><xsl:value-of select="$myparam"/> (Crew list declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='251'"><xsl:value-of select="$myparam"/> (Inquiry)</xsl:when>
      		<xsl:when test="$myparam.upper='252'"><xsl:value-of select="$myparam"/> (Response to previous banking status message)</xsl:when>
      		<xsl:when test="$myparam.upper='253'"><xsl:value-of select="$myparam"/> (Project master plan)</xsl:when>
      		<xsl:when test="$myparam.upper='254'"><xsl:value-of select="$myparam"/> (Project plan)</xsl:when>
      		<xsl:when test="$myparam.upper='255'"><xsl:value-of select="$myparam"/> (Project schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='256'"><xsl:value-of select="$myparam"/> (Project planning available resources)</xsl:when>
      		<xsl:when test="$myparam.upper='257'"><xsl:value-of select="$myparam"/> (Project planning calendar)</xsl:when>
      		<xsl:when test="$myparam.upper='258'"><xsl:value-of select="$myparam"/> (Standing order)</xsl:when>
      		<xsl:when test="$myparam.upper='259'"><xsl:value-of select="$myparam"/> (Cargo movement event log)</xsl:when>
      		<xsl:when test="$myparam.upper='260'"><xsl:value-of select="$myparam"/> (Cargo analysis voyage report)</xsl:when>
      		<xsl:when test="$myparam.upper='261'"><xsl:value-of select="$myparam"/> (Self billed credit note)</xsl:when>
      		<xsl:when test="$myparam.upper='262'"><xsl:value-of select="$myparam"/> (Consolidated credit note - goods and services)</xsl:when>
      		<xsl:when test="$myparam.upper='263'"><xsl:value-of select="$myparam"/> (Inventory adjustment status report)</xsl:when>
      		<xsl:when test="$myparam.upper='264'"><xsl:value-of select="$myparam"/> (Transport equipment movement instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='265'"><xsl:value-of select="$myparam"/> (Transport equipment movement report)</xsl:when>
      		<xsl:when test="$myparam.upper='266'"><xsl:value-of select="$myparam"/> (Transport equipment status change report)</xsl:when>
      		<xsl:when test="$myparam.upper='267'"><xsl:value-of select="$myparam"/> (Fumigation certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='268'"><xsl:value-of select="$myparam"/> (Wine certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='269'"><xsl:value-of select="$myparam"/> (Wool health certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='270'"><xsl:value-of select="$myparam"/> (Delivery note)</xsl:when>
      		<xsl:when test="$myparam.upper='271'"><xsl:value-of select="$myparam"/> (Packing list)</xsl:when>
      		<xsl:when test="$myparam.upper='272'"><xsl:value-of select="$myparam"/> (New code request)</xsl:when>
      		<xsl:when test="$myparam.upper='273'"><xsl:value-of select="$myparam"/> (Code change request)</xsl:when>
      		<xsl:when test="$myparam.upper='274'"><xsl:value-of select="$myparam"/> (Simple data element request)</xsl:when>
      		<xsl:when test="$myparam.upper='275'"><xsl:value-of select="$myparam"/> (Simple data element change request)</xsl:when>
      		<xsl:when test="$myparam.upper='276'"><xsl:value-of select="$myparam"/> (Composite data element request)</xsl:when>
      		<xsl:when test="$myparam.upper='277'"><xsl:value-of select="$myparam"/> (Composite data element change request)</xsl:when>
      		<xsl:when test="$myparam.upper='278'"><xsl:value-of select="$myparam"/> (Segment request)</xsl:when>
      		<xsl:when test="$myparam.upper='279'"><xsl:value-of select="$myparam"/> (Segment change request)</xsl:when>
      		<xsl:when test="$myparam.upper='280'"><xsl:value-of select="$myparam"/> (New message request)</xsl:when>
      		<xsl:when test="$myparam.upper='281'"><xsl:value-of select="$myparam"/> (Message in development request)</xsl:when>
      		<xsl:when test="$myparam.upper='282'"><xsl:value-of select="$myparam"/> (Modification of existing message)</xsl:when>
      		<xsl:when test="$myparam.upper='283'"><xsl:value-of select="$myparam"/> (Tracking number assignment report)</xsl:when>
      		<xsl:when test="$myparam.upper='284'"><xsl:value-of select="$myparam"/> (User directory definition)</xsl:when>
      		<xsl:when test="$myparam.upper='285'"><xsl:value-of select="$myparam"/> (United Nations standard message request)</xsl:when>
      		<xsl:when test="$myparam.upper='286'"><xsl:value-of select="$myparam"/> (Service directory definition)</xsl:when>
      		<xsl:when test="$myparam.upper='287'"><xsl:value-of select="$myparam"/> (Status report)</xsl:when>
      		<xsl:when test="$myparam.upper='288'"><xsl:value-of select="$myparam"/> (Kanban schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='289'"><xsl:value-of select="$myparam"/> (Product data message)</xsl:when>
      		<xsl:when test="$myparam.upper='290'"><xsl:value-of select="$myparam"/> (A claim for parts and/or labour charges)</xsl:when>
      		<xsl:when test="$myparam.upper='291'"><xsl:value-of select="$myparam"/> (Delivery schedule response)</xsl:when>
      		<xsl:when test="$myparam.upper='292'"><xsl:value-of select="$myparam"/> (Inspection request)</xsl:when>
      		<xsl:when test="$myparam.upper='293'"><xsl:value-of select="$myparam"/> (Inspection report)</xsl:when>
      		<xsl:when test="$myparam.upper='294'"><xsl:value-of select="$myparam"/> (Application acknowledgement and error report)</xsl:when>
      		<xsl:when test="$myparam.upper='295'"><xsl:value-of select="$myparam"/> (Price variation invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='296'"><xsl:value-of select="$myparam"/> (Credit note for price variation)</xsl:when>
      		<xsl:when test="$myparam.upper='297'"><xsl:value-of select="$myparam"/> (Instruction to collect)</xsl:when>
      		<xsl:when test="$myparam.upper='298'"><xsl:value-of select="$myparam"/> (Dangerous goods list)</xsl:when>
      		<xsl:when test="$myparam.upper='299'"><xsl:value-of select="$myparam"/> (Registration renewal)</xsl:when>
      		<xsl:when test="$myparam.upper='300'"><xsl:value-of select="$myparam"/> (Registration change)</xsl:when>
      		<xsl:when test="$myparam.upper='301'"><xsl:value-of select="$myparam"/> (Response to registration)</xsl:when>
      		<xsl:when test="$myparam.upper='302'"><xsl:value-of select="$myparam"/> (Implementation guideline)</xsl:when>
      		<xsl:when test="$myparam.upper='303'"><xsl:value-of select="$myparam"/> (Request for transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='304'"><xsl:value-of select="$myparam"/> (Cost performance report)</xsl:when>
      		<xsl:when test="$myparam.upper='305'"><xsl:value-of select="$myparam"/> (Application error and acknowledgement)</xsl:when>
      		<xsl:when test="$myparam.upper='306'"><xsl:value-of select="$myparam"/> (Cash pool financial statement)</xsl:when>
      		<xsl:when test="$myparam.upper='307'"><xsl:value-of select="$myparam"/> (Sequenced delivery schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='308'"><xsl:value-of select="$myparam"/> (Delcredere credit note)</xsl:when>
      		<xsl:when test="$myparam.upper='309'"><xsl:value-of select="$myparam"/> (Healthcare discharge report, final)</xsl:when>
      		<xsl:when test="$myparam.upper='310'"><xsl:value-of select="$myparam"/> (Offer / quotation)</xsl:when>
      		<xsl:when test="$myparam.upper='311'"><xsl:value-of select="$myparam"/> (Request for quote)</xsl:when>
      		<xsl:when test="$myparam.upper='312'"><xsl:value-of select="$myparam"/> (Acknowledgement message)</xsl:when>
      		<xsl:when test="$myparam.upper='313'"><xsl:value-of select="$myparam"/> (Application error message)</xsl:when>
      		<xsl:when test="$myparam.upper='314'"><xsl:value-of select="$myparam"/> (Cargo movement voyage summary)</xsl:when>
      		<xsl:when test="$myparam.upper='315'"><xsl:value-of select="$myparam"/> (Contract)</xsl:when>
      		<xsl:when test="$myparam.upper='316'"><xsl:value-of select="$myparam"/> (Application for usage of berth or mooring facilities)</xsl:when>
      		<xsl:when test="$myparam.upper='317'"><xsl:value-of select="$myparam"/> (Application for designation of berthing places)</xsl:when>
      		<xsl:when test="$myparam.upper='318'"><xsl:value-of select="$myparam"/> (Application for shifting from the designated place in port)</xsl:when>
      		<xsl:when test="$myparam.upper='319'"><xsl:value-of select="$myparam"/> (Supplementary document for application for cargo operation of dangerous goods)</xsl:when>
      		<xsl:when test="$myparam.upper='320'"><xsl:value-of select="$myparam"/> (Acknowledgement of order)</xsl:when>
      		<xsl:when test="$myparam.upper='321'"><xsl:value-of select="$myparam"/> (Supplementary document for application for transport of dangerous goods)</xsl:when>
      		<xsl:when test="$myparam.upper='322'"><xsl:value-of select="$myparam"/> (Optical Character Reading (OCR) payment)</xsl:when>
      		<xsl:when test="$myparam.upper='323'"><xsl:value-of select="$myparam"/> (Preliminary sales report)</xsl:when>
      		<xsl:when test="$myparam.upper='324'"><xsl:value-of select="$myparam"/> (Transport emergency card)</xsl:when>
      		<xsl:when test="$myparam.upper='325'"><xsl:value-of select="$myparam"/> (Proforma invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='326'"><xsl:value-of select="$myparam"/> (Partial invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='327'"><xsl:value-of select="$myparam"/> (Operating instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='328'"><xsl:value-of select="$myparam"/> (Name/product plate)</xsl:when>
      		<xsl:when test="$myparam.upper='329'"><xsl:value-of select="$myparam"/> (Co-insurance ceding bordereau)</xsl:when>
      		<xsl:when test="$myparam.upper='330'"><xsl:value-of select="$myparam"/> (Request for delivery instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='331'"><xsl:value-of select="$myparam"/> (Commercial invoice which includes a packing list)</xsl:when>
      		<xsl:when test="$myparam.upper='332'"><xsl:value-of select="$myparam"/> (Trade data)</xsl:when>
      		<xsl:when test="$myparam.upper='333'"><xsl:value-of select="$myparam"/> (Customs declaration for cargo examination)</xsl:when>
      		<xsl:when test="$myparam.upper='334'"><xsl:value-of select="$myparam"/> (Customs declaration for cargo examination, alternate)</xsl:when>
      		<xsl:when test="$myparam.upper='335'"><xsl:value-of select="$myparam"/> (Booking request)</xsl:when>
      		<xsl:when test="$myparam.upper='336'"><xsl:value-of select="$myparam"/> (Customs crew and conveyance)</xsl:when>
      		<xsl:when test="$myparam.upper='337'"><xsl:value-of select="$myparam"/> (Customs summary declaration with commercial detail, alternate)</xsl:when>
      		<xsl:when test="$myparam.upper='338'"><xsl:value-of select="$myparam"/> (Items booked to a financial account report)</xsl:when>
      		<xsl:when test="$myparam.upper='339'"><xsl:value-of select="$myparam"/> (Report of transactions which need further information from the receiver)</xsl:when>
      		<xsl:when test="$myparam.upper='340'"><xsl:value-of select="$myparam"/> (Shipping instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='341'"><xsl:value-of select="$myparam"/> (Shipper's letter of instructions (air))</xsl:when>
      		<xsl:when test="$myparam.upper='342'"><xsl:value-of select="$myparam"/> (Report of transactions for information only)</xsl:when>
      		<xsl:when test="$myparam.upper='343'"><xsl:value-of select="$myparam"/> (Cartage order (local transport))</xsl:when>
      		<xsl:when test="$myparam.upper='344'"><xsl:value-of select="$myparam"/> (EDI associated object administration message)</xsl:when>
      		<xsl:when test="$myparam.upper='345'"><xsl:value-of select="$myparam"/> (Ready for despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='346'"><xsl:value-of select="$myparam"/> (Summary sales report)</xsl:when>
      		<xsl:when test="$myparam.upper='347'"><xsl:value-of select="$myparam"/> (Order status enquiry)</xsl:when>
      		<xsl:when test="$myparam.upper='348'"><xsl:value-of select="$myparam"/> (Order status report)</xsl:when>
      		<xsl:when test="$myparam.upper='349'"><xsl:value-of select="$myparam"/> (Declaration regarding the inward and outward movement of vessel)</xsl:when>
      		<xsl:when test="$myparam.upper='350'"><xsl:value-of select="$myparam"/> (Despatch order)</xsl:when>
      		<xsl:when test="$myparam.upper='351'"><xsl:value-of select="$myparam"/> (Despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='352'"><xsl:value-of select="$myparam"/> (Notification of usage of berth or mooring facilities)</xsl:when>
      		<xsl:when test="$myparam.upper='353'"><xsl:value-of select="$myparam"/> (Application for vessel's entering into port area in night-time)</xsl:when>
      		<xsl:when test="$myparam.upper='354'"><xsl:value-of select="$myparam"/> (Notification of emergency shifting from the designated place in port)</xsl:when>
      		<xsl:when test="$myparam.upper='355'"><xsl:value-of select="$myparam"/> (Customs summary declaration without commercial detail, alternate)</xsl:when>
      		<xsl:when test="$myparam.upper='356'"><xsl:value-of select="$myparam"/> (Performance bond)</xsl:when>
      		<xsl:when test="$myparam.upper='357'"><xsl:value-of select="$myparam"/> (Payment bond)</xsl:when>
      		<xsl:when test="$myparam.upper='358'"><xsl:value-of select="$myparam"/> (Healthcare discharge report, preliminary)</xsl:when>
      		<xsl:when test="$myparam.upper='359'"><xsl:value-of select="$myparam"/> (Request for provision of a health service)</xsl:when>
      		<xsl:when test="$myparam.upper='360'"><xsl:value-of select="$myparam"/> (Request for price quote)</xsl:when>
      		<xsl:when test="$myparam.upper='361'"><xsl:value-of select="$myparam"/> (Price quote)</xsl:when>
      		<xsl:when test="$myparam.upper='362'"><xsl:value-of select="$myparam"/> (Delivery quote)</xsl:when>
      		<xsl:when test="$myparam.upper='363'"><xsl:value-of select="$myparam"/> (Price and delivery quote)</xsl:when>
      		<xsl:when test="$myparam.upper='364'"><xsl:value-of select="$myparam"/> (Contract price quote)</xsl:when>
      		<xsl:when test="$myparam.upper='365'"><xsl:value-of select="$myparam"/> (Contract price and delivery quote)</xsl:when>
      		<xsl:when test="$myparam.upper='366'"><xsl:value-of select="$myparam"/> (Price quote, specified end-customer)</xsl:when>
      		<xsl:when test="$myparam.upper='367'"><xsl:value-of select="$myparam"/> (Price and delivery quote, specified end-customer)</xsl:when>
      		<xsl:when test="$myparam.upper='368'"><xsl:value-of select="$myparam"/> (Price quote, ship and debit)</xsl:when>
      		<xsl:when test="$myparam.upper='369'"><xsl:value-of select="$myparam"/> (Price and delivery quote, ship and debit)</xsl:when>
      		<xsl:when test="$myparam.upper='370'"><xsl:value-of select="$myparam"/> (Advice of distribution of documents)</xsl:when>
      		<xsl:when test="$myparam.upper='371'"><xsl:value-of select="$myparam"/> (Plan for provision of health service)</xsl:when>
      		<xsl:when test="$myparam.upper='372'"><xsl:value-of select="$myparam"/> (Prescription)</xsl:when>
      		<xsl:when test="$myparam.upper='373'"><xsl:value-of select="$myparam"/> (Prescription request)</xsl:when>
      		<xsl:when test="$myparam.upper='374'"><xsl:value-of select="$myparam"/> (Prescription dispensing report)</xsl:when>
      		<xsl:when test="$myparam.upper='375'"><xsl:value-of select="$myparam"/> (Certificate of shipment)</xsl:when>
      		<xsl:when test="$myparam.upper='376'"><xsl:value-of select="$myparam"/> (Standing inquiry on product information)</xsl:when>
      		<xsl:when test="$myparam.upper='377'"><xsl:value-of select="$myparam"/> (Party credit information)</xsl:when>
      		<xsl:when test="$myparam.upper='378'"><xsl:value-of select="$myparam"/> (Party payment behaviour information)</xsl:when>
      		<xsl:when test="$myparam.upper='379'"><xsl:value-of select="$myparam"/> (Request for metering point information)</xsl:when>
      		<xsl:when test="$myparam.upper='380'"><xsl:value-of select="$myparam"/> (Commercial invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='381'"><xsl:value-of select="$myparam"/> (Credit note)</xsl:when>
      		<xsl:when test="$myparam.upper='382'"><xsl:value-of select="$myparam"/> (Commission note)</xsl:when>
      		<xsl:when test="$myparam.upper='383'"><xsl:value-of select="$myparam"/> (Debit note)</xsl:when>
      		<xsl:when test="$myparam.upper='384'"><xsl:value-of select="$myparam"/> (Corrected invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='385'"><xsl:value-of select="$myparam"/> (Consolidated invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='386'"><xsl:value-of select="$myparam"/> (Prepayment invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='387'"><xsl:value-of select="$myparam"/> (Hire invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='388'"><xsl:value-of select="$myparam"/> (Tax invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='389'"><xsl:value-of select="$myparam"/> (Self-billed invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='390'"><xsl:value-of select="$myparam"/> (Delcredere invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='391'"><xsl:value-of select="$myparam"/> (Metering point information response)</xsl:when>
      		<xsl:when test="$myparam.upper='392'"><xsl:value-of select="$myparam"/> (Notification of change of supplier)</xsl:when>
      		<xsl:when test="$myparam.upper='393'"><xsl:value-of select="$myparam"/> (Factored invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='394'"><xsl:value-of select="$myparam"/> (Lease invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='395'"><xsl:value-of select="$myparam"/> (Consignment invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='396'"><xsl:value-of select="$myparam"/> (Factored credit note)</xsl:when>
      		<xsl:when test="$myparam.upper='397'"><xsl:value-of select="$myparam"/> (Commercial account summary response)</xsl:when>
      		<xsl:when test="$myparam.upper='398'"><xsl:value-of select="$myparam"/> (Cross docking despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='399'"><xsl:value-of select="$myparam"/> (Transshipment despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='400'"><xsl:value-of select="$myparam"/> (Exceptional order)</xsl:when>
      		<xsl:when test="$myparam.upper='401'"><xsl:value-of select="$myparam"/> (Pre-packed cross docking order)</xsl:when>
      		<xsl:when test="$myparam.upper='402'"><xsl:value-of select="$myparam"/> (Intermediate handling cross docking order)</xsl:when>
      		<xsl:when test="$myparam.upper='403'"><xsl:value-of select="$myparam"/> (Means of transportation availability information)</xsl:when>
      		<xsl:when test="$myparam.upper='404'"><xsl:value-of select="$myparam"/> (Means of transportation schedule information)</xsl:when>
      		<xsl:when test="$myparam.upper='405'"><xsl:value-of select="$myparam"/> (Transport equipment delivery notice)</xsl:when>
      		<xsl:when test="$myparam.upper='406'"><xsl:value-of select="$myparam"/> (Notification to supplier of contract termination)</xsl:when>
      		<xsl:when test="$myparam.upper='407'"><xsl:value-of select="$myparam"/> (Notification to supplier of metering point changes)</xsl:when>
      		<xsl:when test="$myparam.upper='408'"><xsl:value-of select="$myparam"/> (Notification of meter change)</xsl:when>
      		<xsl:when test="$myparam.upper='409'"><xsl:value-of select="$myparam"/> (Instructions for bank transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='410'"><xsl:value-of select="$myparam"/> (Notification of metering point identification change)</xsl:when>
      		<xsl:when test="$myparam.upper='411'"><xsl:value-of select="$myparam"/> (Utilities time series message)</xsl:when>
      		<xsl:when test="$myparam.upper='412'"><xsl:value-of select="$myparam"/> (Application for banker's draft)</xsl:when>
      		<xsl:when test="$myparam.upper='413'"><xsl:value-of select="$myparam"/> (Infrastructure condition)</xsl:when>
      		<xsl:when test="$myparam.upper='414'"><xsl:value-of select="$myparam"/> (Acknowledgement of change of supplier)</xsl:when>
      		<xsl:when test="$myparam.upper='415'"><xsl:value-of select="$myparam"/> (Data Plot Sheet)</xsl:when>
      		<xsl:when test="$myparam.upper='416'"><xsl:value-of select="$myparam"/> (Soil analysis)</xsl:when>
      		<xsl:when test="$myparam.upper='417'"><xsl:value-of select="$myparam"/> (Farmyard manure analysis)</xsl:when>
      		<xsl:when test="$myparam.upper='418'"><xsl:value-of select="$myparam"/> (WCO Cargo Report Export, Rail or Road)</xsl:when>
      		<xsl:when test="$myparam.upper='419'"><xsl:value-of select="$myparam"/> (WCO Cargo Report Export, Air or Maritime)</xsl:when>
      		<xsl:when test="$myparam.upper='420'"><xsl:value-of select="$myparam"/> (Optical Character Reading (OCR) payment credit note)</xsl:when>
      		<xsl:when test="$myparam.upper='421'"><xsl:value-of select="$myparam"/> (WCO Cargo Report Import, Rail or Road)</xsl:when>
      		<xsl:when test="$myparam.upper='422'"><xsl:value-of select="$myparam"/> (WCO Cargo Report Import, Air or Maritime)</xsl:when>
      		<xsl:when test="$myparam.upper='423'"><xsl:value-of select="$myparam"/> (WCO one-step export declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='424'"><xsl:value-of select="$myparam"/> (WCO first step of two-step export declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='425'"><xsl:value-of select="$myparam"/> (Collection payment advice)</xsl:when>
      		<xsl:when test="$myparam.upper='426'"><xsl:value-of select="$myparam"/> (Documentary credit payment advice)</xsl:when>
      		<xsl:when test="$myparam.upper='427'"><xsl:value-of select="$myparam"/> (Documentary credit acceptance advice)</xsl:when>
      		<xsl:when test="$myparam.upper='428'"><xsl:value-of select="$myparam"/> (Documentary credit negotiation advice)</xsl:when>
      		<xsl:when test="$myparam.upper='429'"><xsl:value-of select="$myparam"/> (Application for banker's guarantee)</xsl:when>
      		<xsl:when test="$myparam.upper='430'"><xsl:value-of select="$myparam"/> (Banker's guarantee)</xsl:when>
      		<xsl:when test="$myparam.upper='431'"><xsl:value-of select="$myparam"/> (Documentary credit letter of indemnity)</xsl:when>
      		<xsl:when test="$myparam.upper='432'"><xsl:value-of select="$myparam"/> (Notification to grid operator of contract termination)</xsl:when>
      		<xsl:when test="$myparam.upper='433'"><xsl:value-of select="$myparam"/> (Notification to grid operator of metering point changes)</xsl:when>
      		<xsl:when test="$myparam.upper='434'"><xsl:value-of select="$myparam"/> (Notification of balance responsible entity change)</xsl:when>
      		<xsl:when test="$myparam.upper='435'"><xsl:value-of select="$myparam"/> (Preadvice of a credit)</xsl:when>
      		<xsl:when test="$myparam.upper='436'"><xsl:value-of select="$myparam"/> (Transport equipment profile report)</xsl:when>
      		<xsl:when test="$myparam.upper='437'"><xsl:value-of select="$myparam"/> (Request for price and delivery quote, specified end-user)</xsl:when>
      		<xsl:when test="$myparam.upper='438'"><xsl:value-of select="$myparam"/> (Request for price quote, ship and debit)</xsl:when>
      		<xsl:when test="$myparam.upper='439'"><xsl:value-of select="$myparam"/> (Request for price and delivery quote, ship and debit)</xsl:when>
      		<xsl:when test="$myparam.upper='440'"><xsl:value-of select="$myparam"/> (Delivery point list.)</xsl:when>
      		<xsl:when test="$myparam.upper='441'"><xsl:value-of select="$myparam"/> (Transport routing information)</xsl:when>
      		<xsl:when test="$myparam.upper='442'"><xsl:value-of select="$myparam"/> (Request for delivery quote)</xsl:when>
      		<xsl:when test="$myparam.upper='443'"><xsl:value-of select="$myparam"/> (Request for price and delivery quote)</xsl:when>
      		<xsl:when test="$myparam.upper='444'"><xsl:value-of select="$myparam"/> (Request for contract price quote)</xsl:when>
      		<xsl:when test="$myparam.upper='445'"><xsl:value-of select="$myparam"/> (Request for contract price and delivery quote)</xsl:when>
      		<xsl:when test="$myparam.upper='446'"><xsl:value-of select="$myparam"/> (Request for price quote, specified end-customer)</xsl:when>
      		<xsl:when test="$myparam.upper='447'"><xsl:value-of select="$myparam"/> (Collection order)</xsl:when>
      		<xsl:when test="$myparam.upper='448'"><xsl:value-of select="$myparam"/> (Documents presentation form)</xsl:when>
      		<xsl:when test="$myparam.upper='449'"><xsl:value-of select="$myparam"/> (Identification match)</xsl:when>
      		<xsl:when test="$myparam.upper='450'"><xsl:value-of select="$myparam"/> (Payment order)</xsl:when>
      		<xsl:when test="$myparam.upper='451'"><xsl:value-of select="$myparam"/> (Extended payment order)</xsl:when>
      		<xsl:when test="$myparam.upper='452'"><xsl:value-of select="$myparam"/> (Multiple payment order)</xsl:when>
      		<xsl:when test="$myparam.upper='453'"><xsl:value-of select="$myparam"/> (Notice that circumstances prevent payment of delivered goods)</xsl:when>
      		<xsl:when test="$myparam.upper='454'"><xsl:value-of select="$myparam"/> (Credit advice)</xsl:when>
      		<xsl:when test="$myparam.upper='455'"><xsl:value-of select="$myparam"/> (Extended credit advice)</xsl:when>
      		<xsl:when test="$myparam.upper='456'"><xsl:value-of select="$myparam"/> (Debit advice)</xsl:when>
      		<xsl:when test="$myparam.upper='457'"><xsl:value-of select="$myparam"/> (Reversal of debit)</xsl:when>
      		<xsl:when test="$myparam.upper='458'"><xsl:value-of select="$myparam"/> (Reversal of credit)</xsl:when>
      		<xsl:when test="$myparam.upper='459'"><xsl:value-of select="$myparam"/> (Travel ticket)</xsl:when>
      		<xsl:when test="$myparam.upper='460'"><xsl:value-of select="$myparam"/> (Documentary credit application)</xsl:when>
      		<xsl:when test="$myparam.upper='461'"><xsl:value-of select="$myparam"/> (Payment card)</xsl:when>
      		<xsl:when test="$myparam.upper='462'"><xsl:value-of select="$myparam"/> (Ready for transshipment despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='463'"><xsl:value-of select="$myparam"/> (Pre-packed cross docking despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='464'"><xsl:value-of select="$myparam"/> (Intermediate handling cross docking despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='465'"><xsl:value-of select="$myparam"/> (Documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='466'"><xsl:value-of select="$myparam"/> (Documentary credit notification)</xsl:when>
      		<xsl:when test="$myparam.upper='467'"><xsl:value-of select="$myparam"/> (Documentary credit transfer advice)</xsl:when>
      		<xsl:when test="$myparam.upper='468'"><xsl:value-of select="$myparam"/> (Documentary credit amendment notification)</xsl:when>
      		<xsl:when test="$myparam.upper='469'"><xsl:value-of select="$myparam"/> (Documentary credit amendment)</xsl:when>
      		<xsl:when test="$myparam.upper='470'"><xsl:value-of select="$myparam"/> (Waste disposal report)</xsl:when>
      		<xsl:when test="$myparam.upper='481'"><xsl:value-of select="$myparam"/> (Remittance advice)</xsl:when>
      		<xsl:when test="$myparam.upper='482'"><xsl:value-of select="$myparam"/> (Port authority waste disposal report)</xsl:when>
      		<xsl:when test="$myparam.upper='483'"><xsl:value-of select="$myparam"/> (Visa)</xsl:when>
      		<xsl:when test="$myparam.upper='484'"><xsl:value-of select="$myparam"/> (Multiple direct debit request)</xsl:when>
      		<xsl:when test="$myparam.upper='485'"><xsl:value-of select="$myparam"/> (Banker's draft)</xsl:when>
      		<xsl:when test="$myparam.upper='486'"><xsl:value-of select="$myparam"/> (Multiple direct debit)</xsl:when>
      		<xsl:when test="$myparam.upper='487'"><xsl:value-of select="$myparam"/> (Certificate of disembarkation permission)</xsl:when>
      		<xsl:when test="$myparam.upper='488'"><xsl:value-of select="$myparam"/> (Deratting exemption certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='489'"><xsl:value-of select="$myparam"/> (Reefer connection order)</xsl:when>
      		<xsl:when test="$myparam.upper='490'"><xsl:value-of select="$myparam"/> (Bill of exchange)</xsl:when>
      		<xsl:when test="$myparam.upper='491'"><xsl:value-of select="$myparam"/> (Promissory note)</xsl:when>
      		<xsl:when test="$myparam.upper='493'"><xsl:value-of select="$myparam"/> (Statement of account message)</xsl:when>
      		<xsl:when test="$myparam.upper='494'"><xsl:value-of select="$myparam"/> (Direct delivery (transport))</xsl:when>
      		<xsl:when test="$myparam.upper='495'"><xsl:value-of select="$myparam"/> (WCO second step of two-step export declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='496'"><xsl:value-of select="$myparam"/> (WCO one-step import declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='497'"><xsl:value-of select="$myparam"/> (WCO first step of two-step import declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='498'"><xsl:value-of select="$myparam"/> (WCO second step of two-step import declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='499'"><xsl:value-of select="$myparam"/> (Previous transport document)</xsl:when>
      		<xsl:when test="$myparam.upper='520'"><xsl:value-of select="$myparam"/> (Insurance certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='521'"><xsl:value-of select="$myparam"/> (Special requirements permit related to the transport of cargo)</xsl:when>
      		<xsl:when test="$myparam.upper='522'"><xsl:value-of select="$myparam"/> (Dangerous Goods Notification for Tanker vessel)</xsl:when>
      		<xsl:when test="$myparam.upper='523'"><xsl:value-of select="$myparam"/> (Dangerous Goods Notification for non-tanker vessel)</xsl:when>
      		<xsl:when test="$myparam.upper='524'"><xsl:value-of select="$myparam"/> (WCO Conveyance Arrival Report)</xsl:when>
      		<xsl:when test="$myparam.upper='525'"><xsl:value-of select="$myparam"/> (WCO Conveyance Departure Report)</xsl:when>
      		<xsl:when test="$myparam.upper='526'"><xsl:value-of select="$myparam"/> (Accounting voucher)</xsl:when>
      		<xsl:when test="$myparam.upper='527'"><xsl:value-of select="$myparam"/> (Self billed debit note)</xsl:when>
      		<xsl:when test="$myparam.upper='528'"><xsl:value-of select="$myparam"/> (Military Identification Card)</xsl:when>
      		<xsl:when test="$myparam.upper='529'"><xsl:value-of select="$myparam"/> (Re-Entry Permit)</xsl:when>
      		<xsl:when test="$myparam.upper='530'"><xsl:value-of select="$myparam"/> (Insurance policy)</xsl:when>
      		<xsl:when test="$myparam.upper='531'"><xsl:value-of select="$myparam"/> (Refugee Permit)</xsl:when>
      		<xsl:when test="$myparam.upper='532'"><xsl:value-of select="$myparam"/> (Forwarder’s credit note)</xsl:when>
      		<xsl:when test="$myparam.upper='533'"><xsl:value-of select="$myparam"/> (Original accounting voucher)</xsl:when>
      		<xsl:when test="$myparam.upper='534'"><xsl:value-of select="$myparam"/> (Copy accounting voucher)</xsl:when>
      		<xsl:when test="$myparam.upper='535'"><xsl:value-of select="$myparam"/> (Pro-forma accounting voucher)</xsl:when>
      		<xsl:when test="$myparam.upper='536'"><xsl:value-of select="$myparam"/> (International Ship Security Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='537'"><xsl:value-of select="$myparam"/> (Interim International Ship Security Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='538'"><xsl:value-of select="$myparam"/> (Good Manufacturing Practice (GMP) Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='539'"><xsl:value-of select="$myparam"/> (Framework Agreement)</xsl:when>
      		<xsl:when test="$myparam.upper='550'"><xsl:value-of select="$myparam"/> (Insurance declaration sheet (bordereau))</xsl:when>
      		<xsl:when test="$myparam.upper='551'"><xsl:value-of select="$myparam"/> (Transport capacity offer)</xsl:when>
      		<xsl:when test="$myparam.upper='552'"><xsl:value-of select="$myparam"/> (Ship Security Plan)</xsl:when>
      		<xsl:when test="$myparam.upper='553'"><xsl:value-of select="$myparam"/> (Forwarder’s invoice discrepancy report)</xsl:when>
      		<xsl:when test="$myparam.upper='554'"><xsl:value-of select="$myparam"/> (Storage capacity offer)</xsl:when>
      		<xsl:when test="$myparam.upper='575'"><xsl:value-of select="$myparam"/> (Insurer's invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='576'"><xsl:value-of select="$myparam"/> (Storage capacity request)</xsl:when>
      		<xsl:when test="$myparam.upper='577'"><xsl:value-of select="$myparam"/> (Transport capacity request)</xsl:when>
      		<xsl:when test="$myparam.upper='578'"><xsl:value-of select="$myparam"/> (EU Customs declaration for External Community Transit (T1))</xsl:when>
      		<xsl:when test="$myparam.upper='579'"><xsl:value-of select="$myparam"/> (EU Customs declaration for internal Community Transit (T2))</xsl:when>
      		<xsl:when test="$myparam.upper='580'"><xsl:value-of select="$myparam"/> (Cover note)</xsl:when>
      		<xsl:when test="$myparam.upper='581'"><xsl:value-of select="$myparam"/> (EU Customs declaration for non-fiscal area internal Community Transit (T2F))</xsl:when>
      		<xsl:when test="$myparam.upper='582'"><xsl:value-of select="$myparam"/> (EU Customs declaration for internal transit to San Marino (T2SM))</xsl:when>
      		<xsl:when test="$myparam.upper='583'"><xsl:value-of select="$myparam"/> (EU Customs declaration for mixed consignments (T))</xsl:when>
      		<xsl:when test="$myparam.upper='584'"><xsl:value-of select="$myparam"/> (EU Document for establishing the Community status of goods (T2L))</xsl:when>
      		<xsl:when test="$myparam.upper='585'"><xsl:value-of select="$myparam"/> (EU Document for establishing the Community status of goods for certain fiscal purposes (T2LF))</xsl:when>
      		<xsl:when test="$myparam.upper='586'"><xsl:value-of select="$myparam"/> (Document for establishing the Customs Status of goods for San Marino (T2LSM))</xsl:when>
      		<xsl:when test="$myparam.upper='587'"><xsl:value-of select="$myparam"/> (Customs declaration for TIR Carnet goods)</xsl:when>
      		<xsl:when test="$myparam.upper='588'"><xsl:value-of select="$myparam"/> (Transport Means Security Report)</xsl:when>
      		<xsl:when test="$myparam.upper='589'"><xsl:value-of select="$myparam"/> (Halal Slaughtering Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='610'"><xsl:value-of select="$myparam"/> (Forwarding instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='621'"><xsl:value-of select="$myparam"/> (Forwarder's advice to import agent)</xsl:when>
      		<xsl:when test="$myparam.upper='622'"><xsl:value-of select="$myparam"/> (Forwarder's advice to exporter)</xsl:when>
      		<xsl:when test="$myparam.upper='623'"><xsl:value-of select="$myparam"/> (Forwarder's invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='624'"><xsl:value-of select="$myparam"/> (Forwarder's certificate of receipt)</xsl:when>
      		<xsl:when test="$myparam.upper='625'"><xsl:value-of select="$myparam"/> (Heat Treatment Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='626'"><xsl:value-of select="$myparam"/> (Convention on International Trade in Endangered Species of Wild Fauna and Flora (CITES) Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='627'"><xsl:value-of select="$myparam"/> (Free Sale Certificate in the Country of Origin)</xsl:when>
      		<xsl:when test="$myparam.upper='628'"><xsl:value-of select="$myparam"/> (Transit license)</xsl:when>
      		<xsl:when test="$myparam.upper='629'"><xsl:value-of select="$myparam"/> (Veterinary quarantine certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='630'"><xsl:value-of select="$myparam"/> (Shipping note)</xsl:when>
      		<xsl:when test="$myparam.upper='631'"><xsl:value-of select="$myparam"/> (Forwarder's warehouse receipt)</xsl:when>
      		<xsl:when test="$myparam.upper='632'"><xsl:value-of select="$myparam"/> (Goods receipt)</xsl:when>
      		<xsl:when test="$myparam.upper='633'"><xsl:value-of select="$myparam"/> (Port charges documents)</xsl:when>
      		<xsl:when test="$myparam.upper='634'"><xsl:value-of select="$myparam"/> (Certified list of ingredients)</xsl:when>
      		<xsl:when test="$myparam.upper='635'"><xsl:value-of select="$myparam"/> (Warehouse warrant)</xsl:when>
      		<xsl:when test="$myparam.upper='636'"><xsl:value-of select="$myparam"/> (Health certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='637'"><xsl:value-of select="$myparam"/> (Food grade certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='638'"><xsl:value-of select="$myparam"/> (Certificate of suitability for transport of grains and legumes)</xsl:when>
      		<xsl:when test="$myparam.upper='639'"><xsl:value-of select="$myparam"/> (Certificate of refrigerated transport equipment inspection)</xsl:when>
      		<xsl:when test="$myparam.upper='640'"><xsl:value-of select="$myparam"/> (Delivery order)</xsl:when>
      		<xsl:when test="$myparam.upper='641'"><xsl:value-of select="$myparam"/> (Thermographic reading report)</xsl:when>
      		<xsl:when test="$myparam.upper='642'"><xsl:value-of select="$myparam"/> (Certificate of food item transport readiness)</xsl:when>
      		<xsl:when test="$myparam.upper='643'"><xsl:value-of select="$myparam"/> (Food packaging contact certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='644'"><xsl:value-of select="$myparam"/> (Packaging material composition report)</xsl:when>
      		<xsl:when test="$myparam.upper='645'"><xsl:value-of select="$myparam"/> (Export price certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='646'"><xsl:value-of select="$myparam"/> (Public price certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='647'"><xsl:value-of select="$myparam"/> (Drug shelf life study report)</xsl:when>
      		<xsl:when test="$myparam.upper='648'"><xsl:value-of select="$myparam"/> (Certificate of compliance with standards of the World Organization for Animal Health (OIE))</xsl:when>
      		<xsl:when test="$myparam.upper='649'"><xsl:value-of select="$myparam"/> (Production facility license)</xsl:when>
      		<xsl:when test="$myparam.upper='650'"><xsl:value-of select="$myparam"/> (Handling order)</xsl:when>
      		<xsl:when test="$myparam.upper='651'"><xsl:value-of select="$myparam"/> (Manufacturing license)</xsl:when>
      		<xsl:when test="$myparam.upper='652'"><xsl:value-of select="$myparam"/> (Low risk country formal letter)</xsl:when>
      		<xsl:when test="$myparam.upper='653'"><xsl:value-of select="$myparam"/> (Previous correspondence)</xsl:when>
      		<xsl:when test="$myparam.upper='654'"><xsl:value-of select="$myparam"/> (Declaration for radioactive material)</xsl:when>
      		<xsl:when test="$myparam.upper='655'"><xsl:value-of select="$myparam"/> (Gate pass)</xsl:when>
      		<xsl:when test="$myparam.upper='656'"><xsl:value-of select="$myparam"/> (Resale information)</xsl:when>
      		<xsl:when test="$myparam.upper='657'"><xsl:value-of select="$myparam"/> (Phytosanitary Re-export Certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='658'"><xsl:value-of select="$myparam"/> (Bayplan/stowage plan, full)</xsl:when>
      		<xsl:when test="$myparam.upper='659'"><xsl:value-of select="$myparam"/> (Bayplan/stowage plan, partial)</xsl:when>
      		<xsl:when test="$myparam.upper='700'"><xsl:value-of select="$myparam"/> (Waybill)</xsl:when>
      		<xsl:when test="$myparam.upper='701'"><xsl:value-of select="$myparam"/> (Universal (multipurpose) transport document)</xsl:when>
      		<xsl:when test="$myparam.upper='702'"><xsl:value-of select="$myparam"/> (Goods receipt, carriage)</xsl:when>
      		<xsl:when test="$myparam.upper='703'"><xsl:value-of select="$myparam"/> (House waybill)</xsl:when>
      		<xsl:when test="$myparam.upper='704'"><xsl:value-of select="$myparam"/> (Master bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='705'"><xsl:value-of select="$myparam"/> (Bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='706'"><xsl:value-of select="$myparam"/> (Bill of lading original)</xsl:when>
      		<xsl:when test="$myparam.upper='707'"><xsl:value-of select="$myparam"/> (Bill of lading copy)</xsl:when>
      		<xsl:when test="$myparam.upper='708'"><xsl:value-of select="$myparam"/> (Empty container bill)</xsl:when>
      		<xsl:when test="$myparam.upper='709'"><xsl:value-of select="$myparam"/> (Tanker bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='710'"><xsl:value-of select="$myparam"/> (Sea waybill)</xsl:when>
      		<xsl:when test="$myparam.upper='711'"><xsl:value-of select="$myparam"/> (Inland waterway bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='712'"><xsl:value-of select="$myparam"/> (Non-negotiable maritime transport document (generic))</xsl:when>
      		<xsl:when test="$myparam.upper='713'"><xsl:value-of select="$myparam"/> (Mate's receipt)</xsl:when>
      		<xsl:when test="$myparam.upper='714'"><xsl:value-of select="$myparam"/> (House bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='715'"><xsl:value-of select="$myparam"/> (Letter of indemnity for non-surrender of bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='716'"><xsl:value-of select="$myparam"/> (Forwarder's bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='717'"><xsl:value-of select="$myparam"/> (Residence permit)</xsl:when>
      		<xsl:when test="$myparam.upper='718'"><xsl:value-of select="$myparam"/> (Seaman’s book)</xsl:when>
      		<xsl:when test="$myparam.upper='719'"><xsl:value-of select="$myparam"/> (General message)</xsl:when>
      		<xsl:when test="$myparam.upper='720'"><xsl:value-of select="$myparam"/> (Rail consignment note (generic term))</xsl:when>
      		<xsl:when test="$myparam.upper='721'"><xsl:value-of select="$myparam"/> (Product data response)</xsl:when>
      		<xsl:when test="$myparam.upper='722'"><xsl:value-of select="$myparam"/> (Road list-SMGS)</xsl:when>
      		<xsl:when test="$myparam.upper='723'"><xsl:value-of select="$myparam"/> (Escort official recognition)</xsl:when>
      		<xsl:when test="$myparam.upper='724'"><xsl:value-of select="$myparam"/> (Recharging document)</xsl:when>
      		<xsl:when test="$myparam.upper='725'"><xsl:value-of select="$myparam"/> (Manufacturer raised order)</xsl:when>
      		<xsl:when test="$myparam.upper='726'"><xsl:value-of select="$myparam"/> (Manufacturer raised consignment order)</xsl:when>
      		<xsl:when test="$myparam.upper='727'"><xsl:value-of select="$myparam"/> (Price/sales catalogue not containing commercial information)</xsl:when>
      		<xsl:when test="$myparam.upper='728'"><xsl:value-of select="$myparam"/> (Price/sales catalogue containing commercial information)</xsl:when>
      		<xsl:when test="$myparam.upper='729'"><xsl:value-of select="$myparam"/> (Returns advice)</xsl:when>
      		<xsl:when test="$myparam.upper='730'"><xsl:value-of select="$myparam"/> (Road consignment note)</xsl:when>
      		<xsl:when test="$myparam.upper='731'"><xsl:value-of select="$myparam"/> (Commercial account summary)</xsl:when>
      		<xsl:when test="$myparam.upper='732'"><xsl:value-of select="$myparam"/> (Announcement for returns)</xsl:when>
      		<xsl:when test="$myparam.upper='733'"><xsl:value-of select="$myparam"/> (Instruction for returns)</xsl:when>
      		<xsl:when test="$myparam.upper='734'"><xsl:value-of select="$myparam"/> (Sales forecast report)</xsl:when>
      		<xsl:when test="$myparam.upper='735'"><xsl:value-of select="$myparam"/> (Sales data report)</xsl:when>
      		<xsl:when test="$myparam.upper='736'"><xsl:value-of select="$myparam"/> (Standing inquiry on complete product information)</xsl:when>
      		<xsl:when test="$myparam.upper='737'"><xsl:value-of select="$myparam"/> (Proof of delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='738'"><xsl:value-of select="$myparam"/> (Cargo/goods handling and movement message)</xsl:when>
      		<xsl:when test="$myparam.upper='739'"><xsl:value-of select="$myparam"/> (Metered services consumption report supporting an invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='740'"><xsl:value-of select="$myparam"/> (Air waybill)</xsl:when>
      		<xsl:when test="$myparam.upper='741'"><xsl:value-of select="$myparam"/> (Master air waybill)</xsl:when>
      		<xsl:when test="$myparam.upper='742'"><xsl:value-of select="$myparam"/> (Metered services consumption report)</xsl:when>
      		<xsl:when test="$myparam.upper='743'"><xsl:value-of select="$myparam"/> (Substitute air waybill)</xsl:when>
      		<xsl:when test="$myparam.upper='744'"><xsl:value-of select="$myparam"/> (Crew's effects declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='745'"><xsl:value-of select="$myparam"/> (Passenger list)</xsl:when>
      		<xsl:when test="$myparam.upper='746'"><xsl:value-of select="$myparam"/> (Delivery notice (rail transport))</xsl:when>
      		<xsl:when test="$myparam.upper='747'"><xsl:value-of select="$myparam"/> (Payroll deductions advice)</xsl:when>
      		<xsl:when test="$myparam.upper='748'"><xsl:value-of select="$myparam"/> (Consignment despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='749'"><xsl:value-of select="$myparam"/> (Transport equipment gross mass verification message)</xsl:when>
      		<xsl:when test="$myparam.upper='750'"><xsl:value-of select="$myparam"/> (Despatch note (post parcels))</xsl:when>
      		<xsl:when test="$myparam.upper='751'"><xsl:value-of select="$myparam"/> (Invoice information for accounting purposes)</xsl:when>
      		<xsl:when test="$myparam.upper='752'"><xsl:value-of select="$myparam"/> (Plant Passport)</xsl:when>
      		<xsl:when test="$myparam.upper='753'"><xsl:value-of select="$myparam"/> (Certificate of sustainability)</xsl:when>
      		<xsl:when test="$myparam.upper='754'"><xsl:value-of select="$myparam"/> (Call for tender)</xsl:when>
      		<xsl:when test="$myparam.upper='755'"><xsl:value-of select="$myparam"/> (Invitation to tender)</xsl:when>
      		<xsl:when test="$myparam.upper='756'"><xsl:value-of select="$myparam"/> (European Single Procurement Document request)</xsl:when>
      		<xsl:when test="$myparam.upper='757'"><xsl:value-of select="$myparam"/> (Tendering price/sales catalogue request)</xsl:when>
      		<xsl:when test="$myparam.upper='758'"><xsl:value-of select="$myparam"/> (Tender)</xsl:when>
      		<xsl:when test="$myparam.upper='759'"><xsl:value-of select="$myparam"/> (European Single Procurement Document)</xsl:when>
      		<xsl:when test="$myparam.upper='760'"><xsl:value-of select="$myparam"/> (Multimodal/combined transport document (generic))</xsl:when>
      		<xsl:when test="$myparam.upper='761'"><xsl:value-of select="$myparam"/> (Through bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='762'"><xsl:value-of select="$myparam"/> (Tendering price/sales catalogue)</xsl:when>
      		<xsl:when test="$myparam.upper='763'"><xsl:value-of select="$myparam"/> (Forwarder's certificate of transport)</xsl:when>
      		<xsl:when test="$myparam.upper='764'"><xsl:value-of select="$myparam"/> (Combined transport document (generic))</xsl:when>
      		<xsl:when test="$myparam.upper='765'"><xsl:value-of select="$myparam"/> (Multimodal transport document (generic))</xsl:when>
      		<xsl:when test="$myparam.upper='766'"><xsl:value-of select="$myparam"/> (Combined transport bill of lading/multimodal bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='767'"><xsl:value-of select="$myparam"/> (Acknowledgment of receipt)</xsl:when>
      		<xsl:when test="$myparam.upper='768'"><xsl:value-of select="$myparam"/> (Civil status document)</xsl:when>
      		<xsl:when test="$myparam.upper='769'"><xsl:value-of select="$myparam"/> (Advice report)</xsl:when>
      		<xsl:when test="$myparam.upper='770'"><xsl:value-of select="$myparam"/> (Booking confirmation)</xsl:when>
      		<xsl:when test="$myparam.upper='771'"><xsl:value-of select="$myparam"/> (Binding offer)</xsl:when>
      		<xsl:when test="$myparam.upper='772'"><xsl:value-of select="$myparam"/> (Binding customer agreement for contract)</xsl:when>
      		<xsl:when test="$myparam.upper='773'"><xsl:value-of select="$myparam"/> (Coverage confirmation note)</xsl:when>
      		<xsl:when test="$myparam.upper='774'"><xsl:value-of select="$myparam"/> (General terms and conditions)</xsl:when>
      		<xsl:when test="$myparam.upper='775'"><xsl:value-of select="$myparam"/> (Calling forward notice)</xsl:when>
      		<xsl:when test="$myparam.upper='776'"><xsl:value-of select="$myparam"/> (Contract clauses)</xsl:when>
      		<xsl:when test="$myparam.upper='777'"><xsl:value-of select="$myparam"/> (Specific contract conditions)</xsl:when>
      		<xsl:when test="$myparam.upper='778'"><xsl:value-of select="$myparam"/> (Group insurance rules)</xsl:when>
      		<xsl:when test="$myparam.upper='779'"><xsl:value-of select="$myparam"/> (Questionnaire)</xsl:when>
      		<xsl:when test="$myparam.upper='780'"><xsl:value-of select="$myparam"/> (Freight invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='781'"><xsl:value-of select="$myparam"/> (Arrival notice (goods))</xsl:when>
      		<xsl:when test="$myparam.upper='782'"><xsl:value-of select="$myparam"/> (Notice of circumstances preventing delivery (goods))</xsl:when>
      		<xsl:when test="$myparam.upper='783'"><xsl:value-of select="$myparam"/> (Notice of circumstances preventing transport (goods))</xsl:when>
      		<xsl:when test="$myparam.upper='784'"><xsl:value-of select="$myparam"/> (Delivery notice (goods))</xsl:when>
      		<xsl:when test="$myparam.upper='785'"><xsl:value-of select="$myparam"/> (Cargo manifest)</xsl:when>
      		<xsl:when test="$myparam.upper='786'"><xsl:value-of select="$myparam"/> (Freight manifest)</xsl:when>
      		<xsl:when test="$myparam.upper='787'"><xsl:value-of select="$myparam"/> (Bordereau)</xsl:when>
      		<xsl:when test="$myparam.upper='788'"><xsl:value-of select="$myparam"/> (Container manifest (unit packing list))</xsl:when>
      		<xsl:when test="$myparam.upper='789'"><xsl:value-of select="$myparam"/> (Charges note)</xsl:when>
      		<xsl:when test="$myparam.upper='790'"><xsl:value-of select="$myparam"/> (Advice of collection)</xsl:when>
      		<xsl:when test="$myparam.upper='791'"><xsl:value-of select="$myparam"/> (Safety of ship certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='792'"><xsl:value-of select="$myparam"/> (Safety of radio certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='793'"><xsl:value-of select="$myparam"/> (Safety of equipment certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='794'"><xsl:value-of select="$myparam"/> (Civil liability for oil certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='795'"><xsl:value-of select="$myparam"/> (Loadline document)</xsl:when>
      		<xsl:when test="$myparam.upper='796'"><xsl:value-of select="$myparam"/> (Derat document)</xsl:when>
      		<xsl:when test="$myparam.upper='797'"><xsl:value-of select="$myparam"/> (Maritime declaration of health)</xsl:when>
      		<xsl:when test="$myparam.upper='798'"><xsl:value-of select="$myparam"/> (Certificate of registry)</xsl:when>
      		<xsl:when test="$myparam.upper='799'"><xsl:value-of select="$myparam"/> (Ship's stores declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='810'"><xsl:value-of select="$myparam"/> (Export licence, application for)</xsl:when>
      		<xsl:when test="$myparam.upper='811'"><xsl:value-of select="$myparam"/> (Export licence)</xsl:when>
      		<xsl:when test="$myparam.upper='812'"><xsl:value-of select="$myparam"/> (Exchange control declaration, export)</xsl:when>
      		<xsl:when test="$myparam.upper='813'"><xsl:value-of select="$myparam"/> (Declaration of final beneficiary)</xsl:when>
      		<xsl:when test="$myparam.upper='814'"><xsl:value-of select="$myparam"/> (US, FATCA statement)</xsl:when>
      		<xsl:when test="$myparam.upper='815'"><xsl:value-of select="$myparam"/> (Insured status report)</xsl:when>
      		<xsl:when test="$myparam.upper='816'"><xsl:value-of select="$myparam"/> (Group pension commitment information)</xsl:when>
      		<xsl:when test="$myparam.upper='817'"><xsl:value-of select="$myparam"/> (Claim notification)</xsl:when>
      		<xsl:when test="$myparam.upper='818'"><xsl:value-of select="$myparam"/> (Assessment report)</xsl:when>
      		<xsl:when test="$myparam.upper='819'"><xsl:value-of select="$myparam"/> (Loss statement)</xsl:when>
      		<xsl:when test="$myparam.upper='820'"><xsl:value-of select="$myparam"/> (Despatch note model T)</xsl:when>
      		<xsl:when test="$myparam.upper='821'"><xsl:value-of select="$myparam"/> (Despatch note model T1)</xsl:when>
      		<xsl:when test="$myparam.upper='822'"><xsl:value-of select="$myparam"/> (Despatch note model T2)</xsl:when>
      		<xsl:when test="$myparam.upper='823'"><xsl:value-of select="$myparam"/> (Control document T5)</xsl:when>
      		<xsl:when test="$myparam.upper='824'"><xsl:value-of select="$myparam"/> (Re-sending consignment note)</xsl:when>
      		<xsl:when test="$myparam.upper='825'"><xsl:value-of select="$myparam"/> (Despatch note model T2L)</xsl:when>
      		<xsl:when test="$myparam.upper='826'"><xsl:value-of select="$myparam"/> (Guarantee of cost acceptance)</xsl:when>
      		<xsl:when test="$myparam.upper='827'"><xsl:value-of select="$myparam"/> (Close of claim)</xsl:when>
      		<xsl:when test="$myparam.upper='828'"><xsl:value-of select="$myparam"/> (Refusal of claim)</xsl:when>
      		<xsl:when test="$myparam.upper='829'"><xsl:value-of select="$myparam"/> (Valuation report)</xsl:when>
      		<xsl:when test="$myparam.upper='830'"><xsl:value-of select="$myparam"/> (Goods declaration for exportation)</xsl:when>
      		<xsl:when test="$myparam.upper='831'"><xsl:value-of select="$myparam"/> (Claim history certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='832'"><xsl:value-of select="$myparam"/> (Accounting statement)</xsl:when>
      		<xsl:when test="$myparam.upper='833'"><xsl:value-of select="$myparam"/> (Cargo declaration (departure))</xsl:when>
      		<xsl:when test="$myparam.upper='834'"><xsl:value-of select="$myparam"/> (Payment receipt confirmation)</xsl:when>
      		<xsl:when test="$myparam.upper='835'"><xsl:value-of select="$myparam"/> (Certificate of paid insurance premium)</xsl:when>
      		<xsl:when test="$myparam.upper='836'"><xsl:value-of select="$myparam"/> (Insured party payment report)</xsl:when>
      		<xsl:when test="$myparam.upper='837'"><xsl:value-of select="$myparam"/> (Third party payment report)</xsl:when>
      		<xsl:when test="$myparam.upper='838'"><xsl:value-of select="$myparam"/> (Direct debit authorisation)</xsl:when>
      		<xsl:when test="$myparam.upper='839'"><xsl:value-of select="$myparam"/> (Physician report)</xsl:when>
      		<xsl:when test="$myparam.upper='840'"><xsl:value-of select="$myparam"/> (Application for goods control certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='841'"><xsl:value-of select="$myparam"/> (Goods control certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='842'"><xsl:value-of select="$myparam"/> (Medical certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='843'"><xsl:value-of select="$myparam"/> (Witness report)</xsl:when>
      		<xsl:when test="$myparam.upper='844'"><xsl:value-of select="$myparam"/> (Calculation note)</xsl:when>
      		<xsl:when test="$myparam.upper='845'"><xsl:value-of select="$myparam"/> (Communication from opposite party)</xsl:when>
      		<xsl:when test="$myparam.upper='846'"><xsl:value-of select="$myparam"/> (Amicable agreement)</xsl:when>
      		<xsl:when test="$myparam.upper='847'"><xsl:value-of select="$myparam"/> (Out of court settlement)</xsl:when>
      		<xsl:when test="$myparam.upper='848'"><xsl:value-of select="$myparam"/> (Legal action)</xsl:when>
      		<xsl:when test="$myparam.upper='849'"><xsl:value-of select="$myparam"/> (Summons)</xsl:when>
      		<xsl:when test="$myparam.upper='850'"><xsl:value-of select="$myparam"/> (Application for phytosanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='851'"><xsl:value-of select="$myparam"/> (Phytosanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='852'"><xsl:value-of select="$myparam"/> (Sanitary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='853'"><xsl:value-of select="$myparam"/> (Veterinary certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='854'"><xsl:value-of select="$myparam"/> (Court judgment)</xsl:when>
      		<xsl:when test="$myparam.upper='855'"><xsl:value-of select="$myparam"/> (Application for inspection certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='856'"><xsl:value-of select="$myparam"/> (Inspection certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='857'"><xsl:value-of select="$myparam"/> (Vehicle aboard document)</xsl:when>
      		<xsl:when test="$myparam.upper='858'"><xsl:value-of select="$myparam"/> (Image)</xsl:when>
      		<xsl:when test="$myparam.upper='859'"><xsl:value-of select="$myparam"/> (Audio)</xsl:when>
      		<xsl:when test="$myparam.upper='860'"><xsl:value-of select="$myparam"/> (Certificate of origin, application for)</xsl:when>
      		<xsl:when test="$myparam.upper='861'"><xsl:value-of select="$myparam"/> (Certificate of origin)</xsl:when>
      		<xsl:when test="$myparam.upper='862'"><xsl:value-of select="$myparam"/> (Declaration of origin)</xsl:when>
      		<xsl:when test="$myparam.upper='863'"><xsl:value-of select="$myparam"/> (Regional appellation certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='864'"><xsl:value-of select="$myparam"/> (Preference certificate of origin)</xsl:when>
      		<xsl:when test="$myparam.upper='865'"><xsl:value-of select="$myparam"/> (Certificate of origin form GSP)</xsl:when>
      		<xsl:when test="$myparam.upper='866'"><xsl:value-of select="$myparam"/> (Video)</xsl:when>
      		<xsl:when test="$myparam.upper='867'"><xsl:value-of select="$myparam"/> (Introductory letter)</xsl:when>
      		<xsl:when test="$myparam.upper='868'"><xsl:value-of select="$myparam"/> (Data protection regulations statement)</xsl:when>
      		<xsl:when test="$myparam.upper='869'"><xsl:value-of select="$myparam"/> (Exclusive brokerage mandate)</xsl:when>
      		<xsl:when test="$myparam.upper='870'"><xsl:value-of select="$myparam"/> (Consular invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='871'"><xsl:value-of select="$myparam"/> (Inquiry mandate)</xsl:when>
      		<xsl:when test="$myparam.upper='872'"><xsl:value-of select="$myparam"/> (Risk analysis)</xsl:when>
      		<xsl:when test="$myparam.upper='873'"><xsl:value-of select="$myparam"/> (Transport equipment movement report, partial)</xsl:when>
      		<xsl:when test="$myparam.upper='874'"><xsl:value-of select="$myparam"/> (Conveyance declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='875'"><xsl:value-of select="$myparam"/> (Partial construction invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='876'"><xsl:value-of select="$myparam"/> (Partial final construction invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='877'"><xsl:value-of select="$myparam"/> (Final construction invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='878'"><xsl:value-of select="$myparam"/> (AEO Certificate of Security and/or Safety)</xsl:when>
      		<xsl:when test="$myparam.upper='879'"><xsl:value-of select="$myparam"/> (AEO Certificate of Conformity or Compliance)</xsl:when>
      		<xsl:when test="$myparam.upper='890'"><xsl:value-of select="$myparam"/> (Dangerous goods declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='891'"><xsl:value-of select="$myparam"/> (AEO Certificate Full)</xsl:when>
      		<xsl:when test="$myparam.upper='892'"><xsl:value-of select="$myparam"/> (Purchase Order Financing Request)</xsl:when>
      		<xsl:when test="$myparam.upper='893'"><xsl:value-of select="$myparam"/> (Purchase Order Financing Request Status)</xsl:when>
      		<xsl:when test="$myparam.upper='894'"><xsl:value-of select="$myparam"/> (Purchase Order Financing Request Cancellation)</xsl:when>
      		<xsl:when test="$myparam.upper='895'"><xsl:value-of select="$myparam"/> (Statistical document, export)</xsl:when>
      		<xsl:when test="$myparam.upper='896'"><xsl:value-of select="$myparam"/> (INTRASTAT declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='901'"><xsl:value-of select="$myparam"/> (Delivery verification certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='910'"><xsl:value-of select="$myparam"/> (Import licence, application for)</xsl:when>
      		<xsl:when test="$myparam.upper='911'"><xsl:value-of select="$myparam"/> (Import licence)</xsl:when>
      		<xsl:when test="$myparam.upper='913'"><xsl:value-of select="$myparam"/> (Customs declaration without commercial detail)</xsl:when>
      		<xsl:when test="$myparam.upper='914'"><xsl:value-of select="$myparam"/> (Customs declaration with commercial and item detail)</xsl:when>
      		<xsl:when test="$myparam.upper='915'"><xsl:value-of select="$myparam"/> (Customs declaration without item detail)</xsl:when>
      		<xsl:when test="$myparam.upper='916'"><xsl:value-of select="$myparam"/> (Related document)</xsl:when>
      		<xsl:when test="$myparam.upper='917'"><xsl:value-of select="$myparam"/> (Receipt (Customs))</xsl:when>
      		<xsl:when test="$myparam.upper='925'"><xsl:value-of select="$myparam"/> (Application for exchange allocation)</xsl:when>
      		<xsl:when test="$myparam.upper='926'"><xsl:value-of select="$myparam"/> (Foreign exchange permit)</xsl:when>
      		<xsl:when test="$myparam.upper='927'"><xsl:value-of select="$myparam"/> (Exchange control declaration (import))</xsl:when>
      		<xsl:when test="$myparam.upper='929'"><xsl:value-of select="$myparam"/> (Goods declaration for importation)</xsl:when>
      		<xsl:when test="$myparam.upper='930'"><xsl:value-of select="$myparam"/> (Goods declaration for home use)</xsl:when>
      		<xsl:when test="$myparam.upper='931'"><xsl:value-of select="$myparam"/> (Customs immediate release declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='932'"><xsl:value-of select="$myparam"/> (Customs delivery note)</xsl:when>
      		<xsl:when test="$myparam.upper='933'"><xsl:value-of select="$myparam"/> (Cargo declaration (arrival))</xsl:when>
      		<xsl:when test="$myparam.upper='934'"><xsl:value-of select="$myparam"/> (Value declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='935'"><xsl:value-of select="$myparam"/> (Customs invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='936'"><xsl:value-of select="$myparam"/> (Customs declaration (post parcels))</xsl:when>
      		<xsl:when test="$myparam.upper='937'"><xsl:value-of select="$myparam"/> (Tax declaration (value added tax))</xsl:when>
      		<xsl:when test="$myparam.upper='938'"><xsl:value-of select="$myparam"/> (Tax declaration (general))</xsl:when>
      		<xsl:when test="$myparam.upper='940'"><xsl:value-of select="$myparam"/> (Tax demand)</xsl:when>
      		<xsl:when test="$myparam.upper='941'"><xsl:value-of select="$myparam"/> (Embargo permit)</xsl:when>
      		<xsl:when test="$myparam.upper='950'"><xsl:value-of select="$myparam"/> (Goods declaration for Customs transit)</xsl:when>
      		<xsl:when test="$myparam.upper='951'"><xsl:value-of select="$myparam"/> (TIF form)</xsl:when>
      		<xsl:when test="$myparam.upper='952'"><xsl:value-of select="$myparam"/> (TIR carnet)</xsl:when>
      		<xsl:when test="$myparam.upper='953'"><xsl:value-of select="$myparam"/> (EC carnet)</xsl:when>
      		<xsl:when test="$myparam.upper='954'"><xsl:value-of select="$myparam"/> (EUR 1 certificate of origin)</xsl:when>
      		<xsl:when test="$myparam.upper='955'"><xsl:value-of select="$myparam"/> (ATA carnet)</xsl:when>
      		<xsl:when test="$myparam.upper='960'"><xsl:value-of select="$myparam"/> (Single administrative document)</xsl:when>
      		<xsl:when test="$myparam.upper='961'"><xsl:value-of select="$myparam"/> (General response (Customs))</xsl:when>
      		<xsl:when test="$myparam.upper='962'"><xsl:value-of select="$myparam"/> (Document response (Customs))</xsl:when>
      		<xsl:when test="$myparam.upper='963'"><xsl:value-of select="$myparam"/> (Error response (Customs))</xsl:when>
      		<xsl:when test="$myparam.upper='964'"><xsl:value-of select="$myparam"/> (Package response (Customs))</xsl:when>
      		<xsl:when test="$myparam.upper='965'"><xsl:value-of select="$myparam"/> (Tax calculation/confirmation response (Customs))</xsl:when>
      		<xsl:when test="$myparam.upper='966'"><xsl:value-of select="$myparam"/> (Quota prior allocation certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='970'"><xsl:value-of select="$myparam"/> (Wagon report)</xsl:when>
      		<xsl:when test="$myparam.upper='971'"><xsl:value-of select="$myparam"/> (Transit Conveyor Document)</xsl:when>
      		<xsl:when test="$myparam.upper='972'"><xsl:value-of select="$myparam"/> (Rail consignment note forwarder copy)</xsl:when>
      		<xsl:when test="$myparam.upper='974'"><xsl:value-of select="$myparam"/> (Duty suspended goods)</xsl:when>
      		<xsl:when test="$myparam.upper='975'"><xsl:value-of select="$myparam"/> (Proof of transit declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='976'"><xsl:value-of select="$myparam"/> (Container transfer note)</xsl:when>
      		<xsl:when test="$myparam.upper='977'"><xsl:value-of select="$myparam"/> (NATO transit document)</xsl:when>
      		<xsl:when test="$myparam.upper='978'"><xsl:value-of select="$myparam"/> (Transfrontier waste shipment authorization)</xsl:when>
      		<xsl:when test="$myparam.upper='979'"><xsl:value-of select="$myparam"/> (Transfrontier waste shipment movement document)</xsl:when>
      		<xsl:when test="$myparam.upper='990'"><xsl:value-of select="$myparam"/> (End use authorization)</xsl:when>
      		<xsl:when test="$myparam.upper='991'"><xsl:value-of select="$myparam"/> (Government contract)</xsl:when>
      		<xsl:when test="$myparam.upper='995'"><xsl:value-of select="$myparam"/> (Statistical document, import)</xsl:when>
      		<xsl:when test="$myparam.upper='996'"><xsl:value-of select="$myparam"/> (Application for documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='998'"><xsl:value-of select="$myparam"/> (Previous Customs document/message)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>