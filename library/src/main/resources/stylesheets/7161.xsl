<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.7161">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='AA'"><xsl:value-of select="$myparam"/> (Advertising)</xsl:when>
      		<xsl:when test="$myparam.upper='AAA'"><xsl:value-of select="$myparam"/> (Telecommunication)</xsl:when>
      		<xsl:when test="$myparam.upper='AAC'"><xsl:value-of select="$myparam"/> (Technical modification)</xsl:when>
      		<xsl:when test="$myparam.upper='AAD'"><xsl:value-of select="$myparam"/> (Job-order production)</xsl:when>
      		<xsl:when test="$myparam.upper='AAE'"><xsl:value-of select="$myparam"/> (Outlays)</xsl:when>
      		<xsl:when test="$myparam.upper='AAF'"><xsl:value-of select="$myparam"/> (Off-premises)</xsl:when>
      		<xsl:when test="$myparam.upper='AAH'"><xsl:value-of select="$myparam"/> (Additional processing)</xsl:when>
      		<xsl:when test="$myparam.upper='AAI'"><xsl:value-of select="$myparam"/> (Attesting)</xsl:when>
      		<xsl:when test="$myparam.upper='AAS'"><xsl:value-of select="$myparam"/> (Acceptance)</xsl:when>
      		<xsl:when test="$myparam.upper='AAT'"><xsl:value-of select="$myparam"/> (Rush delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='AAV'"><xsl:value-of select="$myparam"/> (Special construction)</xsl:when>
      		<xsl:when test="$myparam.upper='AAY'"><xsl:value-of select="$myparam"/> (Airport facilities)</xsl:when>
      		<xsl:when test="$myparam.upper='AAZ'"><xsl:value-of select="$myparam"/> (Concession)</xsl:when>
      		<xsl:when test="$myparam.upper='ABA'"><xsl:value-of select="$myparam"/> (Compulsory storage)</xsl:when>
      		<xsl:when test="$myparam.upper='ABB'"><xsl:value-of select="$myparam"/> (Fuel removal)</xsl:when>
      		<xsl:when test="$myparam.upper='ABC'"><xsl:value-of select="$myparam"/> (Into plane)</xsl:when>
      		<xsl:when test="$myparam.upper='ABD'"><xsl:value-of select="$myparam"/> (Overtime)</xsl:when>
      		<xsl:when test="$myparam.upper='ABF'"><xsl:value-of select="$myparam"/> (Tooling)</xsl:when>
      		<xsl:when test="$myparam.upper='ABK'"><xsl:value-of select="$myparam"/> (Miscellaneous)</xsl:when>
      		<xsl:when test="$myparam.upper='ABL'"><xsl:value-of select="$myparam"/> (Additional packaging)</xsl:when>
      		<xsl:when test="$myparam.upper='ABN'"><xsl:value-of select="$myparam"/> (Dunnage)</xsl:when>
      		<xsl:when test="$myparam.upper='ABR'"><xsl:value-of select="$myparam"/> (Containerisation)</xsl:when>
      		<xsl:when test="$myparam.upper='ABS'"><xsl:value-of select="$myparam"/> (Carton packing)</xsl:when>
      		<xsl:when test="$myparam.upper='ABT'"><xsl:value-of select="$myparam"/> (Hessian wrapped)</xsl:when>
      		<xsl:when test="$myparam.upper='ABU'"><xsl:value-of select="$myparam"/> (Polyethylene wrap packing)</xsl:when>
      		<xsl:when test="$myparam.upper='ACF'"><xsl:value-of select="$myparam"/> (Miscellaneous treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='ACG'"><xsl:value-of select="$myparam"/> (Enamelling treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='ACH'"><xsl:value-of select="$myparam"/> (Heat treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='ACI'"><xsl:value-of select="$myparam"/> (Plating treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='ACJ'"><xsl:value-of select="$myparam"/> (Painting)</xsl:when>
      		<xsl:when test="$myparam.upper='ACK'"><xsl:value-of select="$myparam"/> (Polishing)</xsl:when>
      		<xsl:when test="$myparam.upper='ACL'"><xsl:value-of select="$myparam"/> (Priming)</xsl:when>
      		<xsl:when test="$myparam.upper='ACM'"><xsl:value-of select="$myparam"/> (Preservation treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='ACS'"><xsl:value-of select="$myparam"/> (Fitting)</xsl:when>
      		<xsl:when test="$myparam.upper='ADC'"><xsl:value-of select="$myparam"/> (Consolidation)</xsl:when>
      		<xsl:when test="$myparam.upper='ADE'"><xsl:value-of select="$myparam"/> (Bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='ADJ'"><xsl:value-of select="$myparam"/> (Airbag)</xsl:when>
      		<xsl:when test="$myparam.upper='ADK'"><xsl:value-of select="$myparam"/> (Transfer)</xsl:when>
      		<xsl:when test="$myparam.upper='ADL'"><xsl:value-of select="$myparam"/> (Slipsheet)</xsl:when>
      		<xsl:when test="$myparam.upper='ADM'"><xsl:value-of select="$myparam"/> (Binding)</xsl:when>
      		<xsl:when test="$myparam.upper='ADN'"><xsl:value-of select="$myparam"/> (Repair or replacement of broken returnable package)</xsl:when>
      		<xsl:when test="$myparam.upper='ADO'"><xsl:value-of select="$myparam"/> (Efficient logistics)</xsl:when>
      		<xsl:when test="$myparam.upper='ADP'"><xsl:value-of select="$myparam"/> (Merchandising)</xsl:when>
      		<xsl:when test="$myparam.upper='ADQ'"><xsl:value-of select="$myparam"/> (Product mix)</xsl:when>
      		<xsl:when test="$myparam.upper='ADR'"><xsl:value-of select="$myparam"/> (Other services)</xsl:when>
      		<xsl:when test="$myparam.upper='ADT'"><xsl:value-of select="$myparam"/> (Pick-up)</xsl:when>
      		<xsl:when test="$myparam.upper='ADW'"><xsl:value-of select="$myparam"/> (Chronic illness)</xsl:when>
      		<xsl:when test="$myparam.upper='ADY'"><xsl:value-of select="$myparam"/> (New product introduction)</xsl:when>
      		<xsl:when test="$myparam.upper='ADZ'"><xsl:value-of select="$myparam"/> (Direct delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='AEA'"><xsl:value-of select="$myparam"/> (Diversion)</xsl:when>
      		<xsl:when test="$myparam.upper='AEB'"><xsl:value-of select="$myparam"/> (Disconnect)</xsl:when>
      		<xsl:when test="$myparam.upper='AEC'"><xsl:value-of select="$myparam"/> (Distribution)</xsl:when>
      		<xsl:when test="$myparam.upper='AED'"><xsl:value-of select="$myparam"/> (Handling of hazardous cargo)</xsl:when>
      		<xsl:when test="$myparam.upper='AEF'"><xsl:value-of select="$myparam"/> (Rents and leases)</xsl:when>
      		<xsl:when test="$myparam.upper='AEH'"><xsl:value-of select="$myparam"/> (Location differential)</xsl:when>
      		<xsl:when test="$myparam.upper='AEI'"><xsl:value-of select="$myparam"/> (Aircraft refueling)</xsl:when>
      		<xsl:when test="$myparam.upper='AEJ'"><xsl:value-of select="$myparam"/> (Fuel shipped into storage)</xsl:when>
      		<xsl:when test="$myparam.upper='AEK'"><xsl:value-of select="$myparam"/> (Cash on delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='AEL'"><xsl:value-of select="$myparam"/> (Small order processing service)</xsl:when>
      		<xsl:when test="$myparam.upper='AEM'"><xsl:value-of select="$myparam"/> (Clerical or administrative services)</xsl:when>
      		<xsl:when test="$myparam.upper='AEN'"><xsl:value-of select="$myparam"/> (Guarantee)</xsl:when>
      		<xsl:when test="$myparam.upper='AEO'"><xsl:value-of select="$myparam"/> (Collection and recycling)</xsl:when>
      		<xsl:when test="$myparam.upper='AEP'"><xsl:value-of select="$myparam"/> (Copyright fee collection)</xsl:when>
      		<xsl:when test="$myparam.upper='AES'"><xsl:value-of select="$myparam"/> (Veterinary inspection service)</xsl:when>
      		<xsl:when test="$myparam.upper='AET'"><xsl:value-of select="$myparam"/> (Pensioner service)</xsl:when>
      		<xsl:when test="$myparam.upper='AEU'"><xsl:value-of select="$myparam"/> (Medicine free pass holder)</xsl:when>
      		<xsl:when test="$myparam.upper='AEV'"><xsl:value-of select="$myparam"/> (Environmental protection service)</xsl:when>
      		<xsl:when test="$myparam.upper='AEW'"><xsl:value-of select="$myparam"/> (Environmental clean-up service)</xsl:when>
      		<xsl:when test="$myparam.upper='AEX'"><xsl:value-of select="$myparam"/> (National cheque processing service outside account area)</xsl:when>
      		<xsl:when test="$myparam.upper='AEY'"><xsl:value-of select="$myparam"/> (National payment service outside account area)</xsl:when>
      		<xsl:when test="$myparam.upper='AEZ'"><xsl:value-of select="$myparam"/> (National payment service within account area)</xsl:when>
      		<xsl:when test="$myparam.upper='AJ'"><xsl:value-of select="$myparam"/> (Adjustments)</xsl:when>
      		<xsl:when test="$myparam.upper='AU'"><xsl:value-of select="$myparam"/> (Authentication)</xsl:when>
      		<xsl:when test="$myparam.upper='CA'"><xsl:value-of select="$myparam"/> (Cataloguing)</xsl:when>
      		<xsl:when test="$myparam.upper='CAB'"><xsl:value-of select="$myparam"/> (Cartage)</xsl:when>
      		<xsl:when test="$myparam.upper='CAD'"><xsl:value-of select="$myparam"/> (Certification)</xsl:when>
      		<xsl:when test="$myparam.upper='CAE'"><xsl:value-of select="$myparam"/> (Certificate of conformance)</xsl:when>
      		<xsl:when test="$myparam.upper='CAF'"><xsl:value-of select="$myparam"/> (Certificate of origin)</xsl:when>
      		<xsl:when test="$myparam.upper='CAI'"><xsl:value-of select="$myparam"/> (Cutting)</xsl:when>
      		<xsl:when test="$myparam.upper='CAJ'"><xsl:value-of select="$myparam"/> (Consular service)</xsl:when>
      		<xsl:when test="$myparam.upper='CAK'"><xsl:value-of select="$myparam"/> (Customer collection)</xsl:when>
      		<xsl:when test="$myparam.upper='CAL'"><xsl:value-of select="$myparam"/> (Payroll payment service)</xsl:when>
      		<xsl:when test="$myparam.upper='CAM'"><xsl:value-of select="$myparam"/> (Cash transportation)</xsl:when>
      		<xsl:when test="$myparam.upper='CAN'"><xsl:value-of select="$myparam"/> (Home banking service)</xsl:when>
      		<xsl:when test="$myparam.upper='CAO'"><xsl:value-of select="$myparam"/> (Bilateral agreement service)</xsl:when>
      		<xsl:when test="$myparam.upper='CAP'"><xsl:value-of select="$myparam"/> (Insurance brokerage service)</xsl:when>
      		<xsl:when test="$myparam.upper='CAQ'"><xsl:value-of select="$myparam"/> (Cheque generation)</xsl:when>
      		<xsl:when test="$myparam.upper='CAR'"><xsl:value-of select="$myparam"/> (Preferential merchandising location)</xsl:when>
      		<xsl:when test="$myparam.upper='CAS'"><xsl:value-of select="$myparam"/> (Crane)</xsl:when>
      		<xsl:when test="$myparam.upper='CAT'"><xsl:value-of select="$myparam"/> (Special colour service)</xsl:when>
      		<xsl:when test="$myparam.upper='CAU'"><xsl:value-of select="$myparam"/> (Sorting)</xsl:when>
      		<xsl:when test="$myparam.upper='CAV'"><xsl:value-of select="$myparam"/> (Battery collection and recycling)</xsl:when>
      		<xsl:when test="$myparam.upper='CAW'"><xsl:value-of select="$myparam"/> (Product take back fee)</xsl:when>
      		<xsl:when test="$myparam.upper='CAX'"><xsl:value-of select="$myparam"/> (Quality control released)</xsl:when>
      		<xsl:when test="$myparam.upper='CAY'"><xsl:value-of select="$myparam"/> (Quality control held)</xsl:when>
      		<xsl:when test="$myparam.upper='CAZ'"><xsl:value-of select="$myparam"/> (Quality control embargo)</xsl:when>
      		<xsl:when test="$myparam.upper='CD'"><xsl:value-of select="$myparam"/> (Car loading)</xsl:when>
      		<xsl:when test="$myparam.upper='CG'"><xsl:value-of select="$myparam"/> (Cleaning)</xsl:when>
      		<xsl:when test="$myparam.upper='CS'"><xsl:value-of select="$myparam"/> (Cigarette stamping)</xsl:when>
      		<xsl:when test="$myparam.upper='CT'"><xsl:value-of select="$myparam"/> (Count and recount)</xsl:when>
      		<xsl:when test="$myparam.upper='DAB'"><xsl:value-of select="$myparam"/> (Layout/design)</xsl:when>
      		<xsl:when test="$myparam.upper='DAC'"><xsl:value-of select="$myparam"/> (Assortment allowance)</xsl:when>
      		<xsl:when test="$myparam.upper='DAD'"><xsl:value-of select="$myparam"/> (Driver assigned unloading)</xsl:when>
      		<xsl:when test="$myparam.upper='DAF'"><xsl:value-of select="$myparam"/> (Debtor bound)</xsl:when>
      		<xsl:when test="$myparam.upper='DAG'"><xsl:value-of select="$myparam"/> (Dealer allowance)</xsl:when>
      		<xsl:when test="$myparam.upper='DAH'"><xsl:value-of select="$myparam"/> (Allowance transferable to the consumer)</xsl:when>
      		<xsl:when test="$myparam.upper='DAI'"><xsl:value-of select="$myparam"/> (Growth of business)</xsl:when>
      		<xsl:when test="$myparam.upper='DAJ'"><xsl:value-of select="$myparam"/> (Introduction allowance)</xsl:when>
      		<xsl:when test="$myparam.upper='DAK'"><xsl:value-of select="$myparam"/> (Multi-buy promotion)</xsl:when>
      		<xsl:when test="$myparam.upper='DAL'"><xsl:value-of select="$myparam"/> (Partnership)</xsl:when>
      		<xsl:when test="$myparam.upper='DAM'"><xsl:value-of select="$myparam"/> (Return handling)</xsl:when>
      		<xsl:when test="$myparam.upper='DAN'"><xsl:value-of select="$myparam"/> (Minimum order not fulfilled charge)</xsl:when>
      		<xsl:when test="$myparam.upper='DAO'"><xsl:value-of select="$myparam"/> (Point of sales threshold allowance)</xsl:when>
      		<xsl:when test="$myparam.upper='DAP'"><xsl:value-of select="$myparam"/> (Wholesaling discount)</xsl:when>
      		<xsl:when test="$myparam.upper='DAQ'"><xsl:value-of select="$myparam"/> (Documentary credits transfer commission)</xsl:when>
      		<xsl:when test="$myparam.upper='DL'"><xsl:value-of select="$myparam"/> (Delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='EG'"><xsl:value-of select="$myparam"/> (Engraving)</xsl:when>
      		<xsl:when test="$myparam.upper='EP'"><xsl:value-of select="$myparam"/> (Expediting)</xsl:when>
      		<xsl:when test="$myparam.upper='ER'"><xsl:value-of select="$myparam"/> (Exchange rate guarantee)</xsl:when>
      		<xsl:when test="$myparam.upper='FAA'"><xsl:value-of select="$myparam"/> (Fabrication)</xsl:when>
      		<xsl:when test="$myparam.upper='FAB'"><xsl:value-of select="$myparam"/> (Freight equalization)</xsl:when>
      		<xsl:when test="$myparam.upper='FAC'"><xsl:value-of select="$myparam"/> (Freight extraordinary handling)</xsl:when>
      		<xsl:when test="$myparam.upper='FC'"><xsl:value-of select="$myparam"/> (Freight service)</xsl:when>
      		<xsl:when test="$myparam.upper='FH'"><xsl:value-of select="$myparam"/> (Filling/handling)</xsl:when>
      		<xsl:when test="$myparam.upper='FI'"><xsl:value-of select="$myparam"/> (Financing)</xsl:when>
      		<xsl:when test="$myparam.upper='GAA'"><xsl:value-of select="$myparam"/> (Grinding)</xsl:when>
      		<xsl:when test="$myparam.upper='HAA'"><xsl:value-of select="$myparam"/> (Hose)</xsl:when>
      		<xsl:when test="$myparam.upper='HD'"><xsl:value-of select="$myparam"/> (Handling)</xsl:when>
      		<xsl:when test="$myparam.upper='HH'"><xsl:value-of select="$myparam"/> (Hoisting and hauling)</xsl:when>
      		<xsl:when test="$myparam.upper='IAA'"><xsl:value-of select="$myparam"/> (Installation)</xsl:when>
      		<xsl:when test="$myparam.upper='IAB'"><xsl:value-of select="$myparam"/> (Installation and warranty)</xsl:when>
      		<xsl:when test="$myparam.upper='ID'"><xsl:value-of select="$myparam"/> (Inside delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='IF'"><xsl:value-of select="$myparam"/> (Inspection)</xsl:when>
      		<xsl:when test="$myparam.upper='IR'"><xsl:value-of select="$myparam"/> (Installation and training)</xsl:when>
      		<xsl:when test="$myparam.upper='IS'"><xsl:value-of select="$myparam"/> (Invoicing)</xsl:when>
      		<xsl:when test="$myparam.upper='KO'"><xsl:value-of select="$myparam"/> (Koshering)</xsl:when>
      		<xsl:when test="$myparam.upper='L1'"><xsl:value-of select="$myparam"/> (Carrier count)</xsl:when>
      		<xsl:when test="$myparam.upper='LA'"><xsl:value-of select="$myparam"/> (Labelling)</xsl:when>
      		<xsl:when test="$myparam.upper='LAA'"><xsl:value-of select="$myparam"/> (Labour)</xsl:when>
      		<xsl:when test="$myparam.upper='LAB'"><xsl:value-of select="$myparam"/> (Repair and return)</xsl:when>
      		<xsl:when test="$myparam.upper='LF'"><xsl:value-of select="$myparam"/> (Legalisation)</xsl:when>
      		<xsl:when test="$myparam.upper='MAE'"><xsl:value-of select="$myparam"/> (Mounting)</xsl:when>
      		<xsl:when test="$myparam.upper='MI'"><xsl:value-of select="$myparam"/> (Mail invoice)</xsl:when>
      		<xsl:when test="$myparam.upper='ML'"><xsl:value-of select="$myparam"/> (Mail invoice to each location)</xsl:when>
      		<xsl:when test="$myparam.upper='NAA'"><xsl:value-of select="$myparam"/> (Non-returnable containers)</xsl:when>
      		<xsl:when test="$myparam.upper='OA'"><xsl:value-of select="$myparam"/> (Outside cable connectors)</xsl:when>
      		<xsl:when test="$myparam.upper='PA'"><xsl:value-of select="$myparam"/> (Invoice with shipment)</xsl:when>
      		<xsl:when test="$myparam.upper='PAA'"><xsl:value-of select="$myparam"/> (Phosphatizing (steel treatment))</xsl:when>
      		<xsl:when test="$myparam.upper='PC'"><xsl:value-of select="$myparam"/> (Packing)</xsl:when>
      		<xsl:when test="$myparam.upper='PL'"><xsl:value-of select="$myparam"/> (Palletizing)</xsl:when>
      		<xsl:when test="$myparam.upper='RAB'"><xsl:value-of select="$myparam"/> (Repacking)</xsl:when>
      		<xsl:when test="$myparam.upper='RAC'"><xsl:value-of select="$myparam"/> (Repair)</xsl:when>
      		<xsl:when test="$myparam.upper='RAD'"><xsl:value-of select="$myparam"/> (Returnable container)</xsl:when>
      		<xsl:when test="$myparam.upper='RAF'"><xsl:value-of select="$myparam"/> (Restocking)</xsl:when>
      		<xsl:when test="$myparam.upper='RE'"><xsl:value-of select="$myparam"/> (Re-delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='RF'"><xsl:value-of select="$myparam"/> (Refurbishing)</xsl:when>
      		<xsl:when test="$myparam.upper='RH'"><xsl:value-of select="$myparam"/> (Rail wagon hire)</xsl:when>
      		<xsl:when test="$myparam.upper='RV'"><xsl:value-of select="$myparam"/> (Loading)</xsl:when>
      		<xsl:when test="$myparam.upper='SA'"><xsl:value-of select="$myparam"/> (Salvaging)</xsl:when>
      		<xsl:when test="$myparam.upper='SAA'"><xsl:value-of select="$myparam"/> (Shipping and handling)</xsl:when>
      		<xsl:when test="$myparam.upper='SAD'"><xsl:value-of select="$myparam"/> (Special packaging)</xsl:when>
      		<xsl:when test="$myparam.upper='SAE'"><xsl:value-of select="$myparam"/> (Stamping)</xsl:when>
      		<xsl:when test="$myparam.upper='SAI'"><xsl:value-of select="$myparam"/> (Consignee unload)</xsl:when>
      		<xsl:when test="$myparam.upper='SG'"><xsl:value-of select="$myparam"/> (Shrink-wrap)</xsl:when>
      		<xsl:when test="$myparam.upper='SH'"><xsl:value-of select="$myparam"/> (Special handling)</xsl:when>
      		<xsl:when test="$myparam.upper='SM'"><xsl:value-of select="$myparam"/> (Special finish)</xsl:when>
      		<xsl:when test="$myparam.upper='SU'"><xsl:value-of select="$myparam"/> (Set-up)</xsl:when>
      		<xsl:when test="$myparam.upper='TAB'"><xsl:value-of select="$myparam"/> (Tank renting)</xsl:when>
      		<xsl:when test="$myparam.upper='TAC'"><xsl:value-of select="$myparam"/> (Testing)</xsl:when>
      		<xsl:when test="$myparam.upper='TT'"><xsl:value-of select="$myparam"/> (Transportation - third party billing)</xsl:when>
      		<xsl:when test="$myparam.upper='TV'"><xsl:value-of select="$myparam"/> (Transportation by vendor)</xsl:when>
      		<xsl:when test="$myparam.upper='V1'"><xsl:value-of select="$myparam"/> (Drop yard)</xsl:when>
      		<xsl:when test="$myparam.upper='V2'"><xsl:value-of select="$myparam"/> (Drop dock)</xsl:when>
      		<xsl:when test="$myparam.upper='WH'"><xsl:value-of select="$myparam"/> (Warehousing)</xsl:when>
      		<xsl:when test="$myparam.upper='XAA'"><xsl:value-of select="$myparam"/> (Combine all same day shipment)</xsl:when>
      		<xsl:when test="$myparam.upper='YY'"><xsl:value-of select="$myparam"/> (Split pick-up)</xsl:when>
      		<xsl:when test="$myparam.upper='ZZZ'"><xsl:value-of select="$myparam"/> (Mutually defined)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>