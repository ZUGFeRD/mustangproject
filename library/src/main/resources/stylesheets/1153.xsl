<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.1153">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='AAA'"><xsl:value-of select="$myparam"/> (Order acknowledgement document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAB'"><xsl:value-of select="$myparam"/> (Proforma invoice document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAC'"><xsl:value-of select="$myparam"/> (Documentary credit identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAD'"><xsl:value-of select="$myparam"/> (Contract document addendum identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAE'"><xsl:value-of select="$myparam"/> (Goods declaration number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAF'"><xsl:value-of select="$myparam"/> (Debit card number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAG'"><xsl:value-of select="$myparam"/> (Offer number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAH'"><xsl:value-of select="$myparam"/> (Bank's batch interbank transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAI'"><xsl:value-of select="$myparam"/> (Bank's individual interbank transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAJ'"><xsl:value-of select="$myparam"/> (Delivery order number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAK'"><xsl:value-of select="$myparam"/> (Despatch advice number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAL'"><xsl:value-of select="$myparam"/> (Drawing number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAM'"><xsl:value-of select="$myparam"/> (Waybill number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAN'"><xsl:value-of select="$myparam"/> (Delivery schedule number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAO'"><xsl:value-of select="$myparam"/> (Consignment identifier, consignee assigned)</xsl:when>
      		<xsl:when test="$myparam.upper='AAP'"><xsl:value-of select="$myparam"/> (Partial shipment identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAQ'"><xsl:value-of select="$myparam"/> (Transport equipment identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAR'"><xsl:value-of select="$myparam"/> (Municipality assigned business registry number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAS'"><xsl:value-of select="$myparam"/> (Transport contract document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAT'"><xsl:value-of select="$myparam"/> (Master label number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAU'"><xsl:value-of select="$myparam"/> (Despatch note document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AAV'"><xsl:value-of select="$myparam"/> (Enquiry number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAW'"><xsl:value-of select="$myparam"/> (Docket number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAX'"><xsl:value-of select="$myparam"/> (Civil action number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAY'"><xsl:value-of select="$myparam"/> (Carrier's agent reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AAZ'"><xsl:value-of select="$myparam"/> (Standard Carrier Alpha Code (SCAC) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABA'"><xsl:value-of select="$myparam"/> (Customs valuation decision number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABB'"><xsl:value-of select="$myparam"/> (End use authorization number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABC'"><xsl:value-of select="$myparam"/> (Anti-dumping case number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABD'"><xsl:value-of select="$myparam"/> (Customs tariff number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABE'"><xsl:value-of select="$myparam"/> (Declarant's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABF'"><xsl:value-of select="$myparam"/> (Repair estimate number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABG'"><xsl:value-of select="$myparam"/> (Customs decision request number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABH'"><xsl:value-of select="$myparam"/> (Sub-house bill of lading number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABI'"><xsl:value-of select="$myparam"/> (Tax payment identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='ABJ'"><xsl:value-of select="$myparam"/> (Quota number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABK'"><xsl:value-of select="$myparam"/> (Transit (onward carriage) guarantee (bond) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABL'"><xsl:value-of select="$myparam"/> (Customs guarantee number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABM'"><xsl:value-of select="$myparam"/> (Replacing part number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABN'"><xsl:value-of select="$myparam"/> (Seller's catalogue number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABO'"><xsl:value-of select="$myparam"/> (Originator's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ABP'"><xsl:value-of select="$myparam"/> (Declarant's Customs identity number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABQ'"><xsl:value-of select="$myparam"/> (Importer reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABR'"><xsl:value-of select="$myparam"/> (Export clearance instruction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABS'"><xsl:value-of select="$myparam"/> (Import clearance instruction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABT'"><xsl:value-of select="$myparam"/> (Goods declaration document identifier, Customs)</xsl:when>
      		<xsl:when test="$myparam.upper='ABU'"><xsl:value-of select="$myparam"/> (Article number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABV'"><xsl:value-of select="$myparam"/> (Intra-plant routing)</xsl:when>
      		<xsl:when test="$myparam.upper='ABW'"><xsl:value-of select="$myparam"/> (Stock keeping unit number)</xsl:when>
      		<xsl:when test="$myparam.upper='ABX'"><xsl:value-of select="$myparam"/> (Text Element Identifier deletion reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ABY'"><xsl:value-of select="$myparam"/> (Allotment identification (Air))</xsl:when>
      		<xsl:when test="$myparam.upper='ABZ'"><xsl:value-of select="$myparam"/> (Vehicle licence number)</xsl:when>
      		<xsl:when test="$myparam.upper='AC'"><xsl:value-of select="$myparam"/> (Air cargo transfer manifest)</xsl:when>
      		<xsl:when test="$myparam.upper='ACA'"><xsl:value-of select="$myparam"/> (Cargo acceptance order reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACB'"><xsl:value-of select="$myparam"/> (US government agency number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACC'"><xsl:value-of select="$myparam"/> (Shipping unit identification)</xsl:when>
      		<xsl:when test="$myparam.upper='ACD'"><xsl:value-of select="$myparam"/> (Additional reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACE'"><xsl:value-of select="$myparam"/> (Related document number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACF'"><xsl:value-of select="$myparam"/> (Addressee reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ACG'"><xsl:value-of select="$myparam"/> (ATA carnet number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACH'"><xsl:value-of select="$myparam"/> (Packaging unit identification)</xsl:when>
      		<xsl:when test="$myparam.upper='ACI'"><xsl:value-of select="$myparam"/> (Outerpackaging unit identification)</xsl:when>
      		<xsl:when test="$myparam.upper='ACJ'"><xsl:value-of select="$myparam"/> (Customer material specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACK'"><xsl:value-of select="$myparam"/> (Bank reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ACL'"><xsl:value-of select="$myparam"/> (Principal reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACN'"><xsl:value-of select="$myparam"/> (Collection advice document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='ACO'"><xsl:value-of select="$myparam"/> (Iron charge number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACP'"><xsl:value-of select="$myparam"/> (Hot roll number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACQ'"><xsl:value-of select="$myparam"/> (Cold roll number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACR'"><xsl:value-of select="$myparam"/> (Railway wagon number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACT'"><xsl:value-of select="$myparam"/> (Unique claims reference number of the sender)</xsl:when>
      		<xsl:when test="$myparam.upper='ACU'"><xsl:value-of select="$myparam"/> (Loss/event number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACV'"><xsl:value-of select="$myparam"/> (Estimate order reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACW'"><xsl:value-of select="$myparam"/> (Reference number to previous message)</xsl:when>
      		<xsl:when test="$myparam.upper='ACX'"><xsl:value-of select="$myparam"/> (Banker's acceptance)</xsl:when>
      		<xsl:when test="$myparam.upper='ACY'"><xsl:value-of select="$myparam"/> (Duty memo number)</xsl:when>
      		<xsl:when test="$myparam.upper='ACZ'"><xsl:value-of select="$myparam"/> (Equipment transport charge number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADA'"><xsl:value-of select="$myparam"/> (Buyer's item number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADB'"><xsl:value-of select="$myparam"/> (Matured certificate of deposit)</xsl:when>
      		<xsl:when test="$myparam.upper='ADC'"><xsl:value-of select="$myparam"/> (Loan)</xsl:when>
      		<xsl:when test="$myparam.upper='ADD'"><xsl:value-of select="$myparam"/> (Analysis number/test number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADE'"><xsl:value-of select="$myparam"/> (Account number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADF'"><xsl:value-of select="$myparam"/> (Treaty number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADG'"><xsl:value-of select="$myparam"/> (Catastrophe number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADI'"><xsl:value-of select="$myparam"/> (Bureau signing (statement reference))</xsl:when>
      		<xsl:when test="$myparam.upper='ADJ'"><xsl:value-of select="$myparam"/> (Company / syndicate reference 1)</xsl:when>
      		<xsl:when test="$myparam.upper='ADK'"><xsl:value-of select="$myparam"/> (Company / syndicate reference 2)</xsl:when>
      		<xsl:when test="$myparam.upper='ADL'"><xsl:value-of select="$myparam"/> (Ordering customer consignment reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADM'"><xsl:value-of select="$myparam"/> (Shipowner's authorization number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADN'"><xsl:value-of select="$myparam"/> (Inland transport order number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADO'"><xsl:value-of select="$myparam"/> (Container work order reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADP'"><xsl:value-of select="$myparam"/> (Statement number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADQ'"><xsl:value-of select="$myparam"/> (Unique market reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ADT'"><xsl:value-of select="$myparam"/> (Group accounting)</xsl:when>
      		<xsl:when test="$myparam.upper='ADU'"><xsl:value-of select="$myparam"/> (Broker reference 1)</xsl:when>
      		<xsl:when test="$myparam.upper='ADV'"><xsl:value-of select="$myparam"/> (Broker reference 2)</xsl:when>
      		<xsl:when test="$myparam.upper='ADW'"><xsl:value-of select="$myparam"/> (Lloyd's claims office reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ADX'"><xsl:value-of select="$myparam"/> (Secure delivery terms and conditions agreement reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ADY'"><xsl:value-of select="$myparam"/> (Report number)</xsl:when>
      		<xsl:when test="$myparam.upper='ADZ'"><xsl:value-of select="$myparam"/> (Trader account number)</xsl:when>
      		<xsl:when test="$myparam.upper='AE'"><xsl:value-of select="$myparam"/> (Authorization for expense (AFE) number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEA'"><xsl:value-of select="$myparam"/> (Government agency reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEB'"><xsl:value-of select="$myparam"/> (Assembly number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEC'"><xsl:value-of select="$myparam"/> (Symbol number)</xsl:when>
      		<xsl:when test="$myparam.upper='AED'"><xsl:value-of select="$myparam"/> (Commodity number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEE'"><xsl:value-of select="$myparam"/> (Eur 1 certificate number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEF'"><xsl:value-of select="$myparam"/> (Customer process specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEG'"><xsl:value-of select="$myparam"/> (Customer specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEH'"><xsl:value-of select="$myparam"/> (Applicable instructions or standards)</xsl:when>
      		<xsl:when test="$myparam.upper='AEI'"><xsl:value-of select="$myparam"/> (Registration number of previous Customs declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='AEJ'"><xsl:value-of select="$myparam"/> (Post-entry reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AEK'"><xsl:value-of select="$myparam"/> (Payment order number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEL'"><xsl:value-of select="$myparam"/> (Delivery number (transport))</xsl:when>
      		<xsl:when test="$myparam.upper='AEM'"><xsl:value-of select="$myparam"/> (Transport route)</xsl:when>
      		<xsl:when test="$myparam.upper='AEN'"><xsl:value-of select="$myparam"/> (Customer's unit inventory number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEO'"><xsl:value-of select="$myparam"/> (Product reservation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEP'"><xsl:value-of select="$myparam"/> (Project number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEQ'"><xsl:value-of select="$myparam"/> (Drawing list number)</xsl:when>
      		<xsl:when test="$myparam.upper='AER'"><xsl:value-of select="$myparam"/> (Project specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AES'"><xsl:value-of select="$myparam"/> (Primary reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AET'"><xsl:value-of select="$myparam"/> (Request for cancellation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEU'"><xsl:value-of select="$myparam"/> (Supplier's control number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEV'"><xsl:value-of select="$myparam"/> (Shipping note number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEW'"><xsl:value-of select="$myparam"/> (Empty container bill number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEX'"><xsl:value-of select="$myparam"/> (Non-negotiable maritime transport document number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEY'"><xsl:value-of select="$myparam"/> (Substitute air waybill number)</xsl:when>
      		<xsl:when test="$myparam.upper='AEZ'"><xsl:value-of select="$myparam"/> (Despatch note (post parcels) number)</xsl:when>
      		<xsl:when test="$myparam.upper='AF'"><xsl:value-of select="$myparam"/> (Airlines flight identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFA'"><xsl:value-of select="$myparam"/> (Through bill of lading number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFB'"><xsl:value-of select="$myparam"/> (Cargo manifest number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFC'"><xsl:value-of select="$myparam"/> (Bordereau number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFD'"><xsl:value-of select="$myparam"/> (Customs item number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFE'"><xsl:value-of select="$myparam"/> (Export Control Commodity number (ECCN))</xsl:when>
      		<xsl:when test="$myparam.upper='AFF'"><xsl:value-of select="$myparam"/> (Marking/label reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFG'"><xsl:value-of select="$myparam"/> (Tariff number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFH'"><xsl:value-of select="$myparam"/> (Replenishment purchase order number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFI'"><xsl:value-of select="$myparam"/> (Immediate transportation no. for in bond movement)</xsl:when>
      		<xsl:when test="$myparam.upper='AFJ'"><xsl:value-of select="$myparam"/> (Transportation exportation no. for in bond movement)</xsl:when>
      		<xsl:when test="$myparam.upper='AFK'"><xsl:value-of select="$myparam"/> (Immediate exportation no. for in bond movement)</xsl:when>
      		<xsl:when test="$myparam.upper='AFL'"><xsl:value-of select="$myparam"/> (Associated invoices)</xsl:when>
      		<xsl:when test="$myparam.upper='AFM'"><xsl:value-of select="$myparam"/> (Secondary Customs reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFN'"><xsl:value-of select="$myparam"/> (Account party's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFO'"><xsl:value-of select="$myparam"/> (Beneficiary's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFP'"><xsl:value-of select="$myparam"/> (Second beneficiary's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFQ'"><xsl:value-of select="$myparam"/> (Applicant's bank reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFR'"><xsl:value-of select="$myparam"/> (Issuing bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFS'"><xsl:value-of select="$myparam"/> (Beneficiary's bank reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AFT'"><xsl:value-of select="$myparam"/> (Direct payment valuation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFU'"><xsl:value-of select="$myparam"/> (Direct payment valuation request number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFV'"><xsl:value-of select="$myparam"/> (Quantity valuation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFW'"><xsl:value-of select="$myparam"/> (Quantity valuation request number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFX'"><xsl:value-of select="$myparam"/> (Bill of quantities number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFY'"><xsl:value-of select="$myparam"/> (Payment valuation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AFZ'"><xsl:value-of select="$myparam"/> (Situation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGA'"><xsl:value-of select="$myparam"/> (Agreement to pay number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGB'"><xsl:value-of select="$myparam"/> (Contract party reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGC'"><xsl:value-of select="$myparam"/> (Account party's bank reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AGD'"><xsl:value-of select="$myparam"/> (Agent's bank reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AGE'"><xsl:value-of select="$myparam"/> (Agent's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AGF'"><xsl:value-of select="$myparam"/> (Applicant's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AGG'"><xsl:value-of select="$myparam"/> (Dispute number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGH'"><xsl:value-of select="$myparam"/> (Credit rating agency's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGI'"><xsl:value-of select="$myparam"/> (Request number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGJ'"><xsl:value-of select="$myparam"/> (Single transaction sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGK'"><xsl:value-of select="$myparam"/> (Application reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGL'"><xsl:value-of select="$myparam"/> (Delivery verification certificate)</xsl:when>
      		<xsl:when test="$myparam.upper='AGM'"><xsl:value-of select="$myparam"/> (Number of temporary importation document)</xsl:when>
      		<xsl:when test="$myparam.upper='AGN'"><xsl:value-of select="$myparam"/> (Reference number quoted on statement)</xsl:when>
      		<xsl:when test="$myparam.upper='AGO'"><xsl:value-of select="$myparam"/> (Sender's reference to the original message)</xsl:when>
      		<xsl:when test="$myparam.upper='AGP'"><xsl:value-of select="$myparam"/> (Company issued equipment ID)</xsl:when>
      		<xsl:when test="$myparam.upper='AGQ'"><xsl:value-of select="$myparam"/> (Domestic flight number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGR'"><xsl:value-of select="$myparam"/> (International flight number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGS'"><xsl:value-of select="$myparam"/> (Employer identification number of service bureau)</xsl:when>
      		<xsl:when test="$myparam.upper='AGT'"><xsl:value-of select="$myparam"/> (Service group identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGU'"><xsl:value-of select="$myparam"/> (Member number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGV'"><xsl:value-of select="$myparam"/> (Previous member number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGW'"><xsl:value-of select="$myparam"/> (Scheme/plan number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGX'"><xsl:value-of select="$myparam"/> (Previous scheme/plan number)</xsl:when>
      		<xsl:when test="$myparam.upper='AGY'"><xsl:value-of select="$myparam"/> (Receiving party's member identification)</xsl:when>
      		<xsl:when test="$myparam.upper='AGZ'"><xsl:value-of select="$myparam"/> (Payroll number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHA'"><xsl:value-of select="$myparam"/> (Packaging specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHB'"><xsl:value-of select="$myparam"/> (Authority issued equipment identification)</xsl:when>
      		<xsl:when test="$myparam.upper='AHC'"><xsl:value-of select="$myparam"/> (Training flight number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHD'"><xsl:value-of select="$myparam"/> (Fund code number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHE'"><xsl:value-of select="$myparam"/> (Signal code number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHF'"><xsl:value-of select="$myparam"/> (Major force program number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHG'"><xsl:value-of select="$myparam"/> (Nomination number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHH'"><xsl:value-of select="$myparam"/> (Laboratory registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHI'"><xsl:value-of select="$myparam"/> (Transport contract reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHJ'"><xsl:value-of select="$myparam"/> (Payee's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHK'"><xsl:value-of select="$myparam"/> (Payer's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHL'"><xsl:value-of select="$myparam"/> (Creditor's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHM'"><xsl:value-of select="$myparam"/> (Debtor's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHN'"><xsl:value-of select="$myparam"/> (Joint venture reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHO'"><xsl:value-of select="$myparam"/> (Chamber of Commerce registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHP'"><xsl:value-of select="$myparam"/> (Tax registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHQ'"><xsl:value-of select="$myparam"/> (Wool identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHR'"><xsl:value-of select="$myparam"/> (Wool tax reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHS'"><xsl:value-of select="$myparam"/> (Meat processing establishment registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHT'"><xsl:value-of select="$myparam"/> (Quarantine/treatment status reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHU'"><xsl:value-of select="$myparam"/> (Request for quote number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHV'"><xsl:value-of select="$myparam"/> (Manual processing authority number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHX'"><xsl:value-of select="$myparam"/> (Rate note number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHY'"><xsl:value-of select="$myparam"/> (Freight Forwarder number)</xsl:when>
      		<xsl:when test="$myparam.upper='AHZ'"><xsl:value-of select="$myparam"/> (Customs release code)</xsl:when>
      		<xsl:when test="$myparam.upper='AIA'"><xsl:value-of select="$myparam"/> (Compliance code number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIB'"><xsl:value-of select="$myparam"/> (Department of transportation bond number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIC'"><xsl:value-of select="$myparam"/> (Export establishment number)</xsl:when>
      		<xsl:when test="$myparam.upper='AID'"><xsl:value-of select="$myparam"/> (Certificate of conformity)</xsl:when>
      		<xsl:when test="$myparam.upper='AIE'"><xsl:value-of select="$myparam"/> (Ministerial certificate of homologation)</xsl:when>
      		<xsl:when test="$myparam.upper='AIF'"><xsl:value-of select="$myparam"/> (Previous delivery instruction number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIG'"><xsl:value-of select="$myparam"/> (Passport number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIH'"><xsl:value-of select="$myparam"/> (Common transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AII'"><xsl:value-of select="$myparam"/> (Bank's common transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIJ'"><xsl:value-of select="$myparam"/> (Customer's individual transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIK'"><xsl:value-of select="$myparam"/> (Bank's individual transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIL'"><xsl:value-of select="$myparam"/> (Customer's common transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIM'"><xsl:value-of select="$myparam"/> (Individual transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIN'"><xsl:value-of select="$myparam"/> (Product sourcing agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIO'"><xsl:value-of select="$myparam"/> (Customs transhipment number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIP'"><xsl:value-of select="$myparam"/> (Customs preference inquiry number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIQ'"><xsl:value-of select="$myparam"/> (Packing plant number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIR'"><xsl:value-of select="$myparam"/> (Original certificate number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIS'"><xsl:value-of select="$myparam"/> (Processing plant number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIT'"><xsl:value-of select="$myparam"/> (Slaughter plant number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIU'"><xsl:value-of select="$myparam"/> (Charge card account number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIV'"><xsl:value-of select="$myparam"/> (Event reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIW'"><xsl:value-of select="$myparam"/> (Transport section reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AIX'"><xsl:value-of select="$myparam"/> (Referred product for mechanical analysis)</xsl:when>
      		<xsl:when test="$myparam.upper='AIY'"><xsl:value-of select="$myparam"/> (Referred product for chemical analysis)</xsl:when>
      		<xsl:when test="$myparam.upper='AIZ'"><xsl:value-of select="$myparam"/> (Consolidated invoice number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJA'"><xsl:value-of select="$myparam"/> (Part reference indicator in a drawing)</xsl:when>
      		<xsl:when test="$myparam.upper='AJB'"><xsl:value-of select="$myparam"/> (U.S. Code of Federal Regulations (CFR))</xsl:when>
      		<xsl:when test="$myparam.upper='AJC'"><xsl:value-of select="$myparam"/> (Purchasing activity clause number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJD'"><xsl:value-of select="$myparam"/> (U.S. Defense Federal Acquisition Regulation Supplement)</xsl:when>
      		<xsl:when test="$myparam.upper='AJE'"><xsl:value-of select="$myparam"/> (Agency clause number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJF'"><xsl:value-of select="$myparam"/> (Circular publication number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJG'"><xsl:value-of select="$myparam"/> (U.S. Federal Acquisition Regulation)</xsl:when>
      		<xsl:when test="$myparam.upper='AJH'"><xsl:value-of select="$myparam"/> (U.S. General Services Administration Regulation)</xsl:when>
      		<xsl:when test="$myparam.upper='AJI'"><xsl:value-of select="$myparam"/> (U.S. Federal Information Resources Management Regulation)</xsl:when>
      		<xsl:when test="$myparam.upper='AJJ'"><xsl:value-of select="$myparam"/> (Paragraph)</xsl:when>
      		<xsl:when test="$myparam.upper='AJK'"><xsl:value-of select="$myparam"/> (Special instructions number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJL'"><xsl:value-of select="$myparam"/> (Site specific procedures, terms, and conditions number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJM'"><xsl:value-of select="$myparam"/> (Master solicitation procedures, terms, and conditions number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJN'"><xsl:value-of select="$myparam"/> (U.S. Department of Veterans Affairs Acquisition Regulation)</xsl:when>
      		<xsl:when test="$myparam.upper='AJO'"><xsl:value-of select="$myparam"/> (Military Interdepartmental Purchase Request (MIPR) number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJP'"><xsl:value-of select="$myparam"/> (Foreign military sales number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJQ'"><xsl:value-of select="$myparam"/> (Defense priorities allocation system priority rating)</xsl:when>
      		<xsl:when test="$myparam.upper='AJR'"><xsl:value-of select="$myparam"/> (Wage determination number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJS'"><xsl:value-of select="$myparam"/> (Agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJT'"><xsl:value-of select="$myparam"/> (Standard Industry Classification (SIC) number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJU'"><xsl:value-of select="$myparam"/> (End item number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJV'"><xsl:value-of select="$myparam"/> (Federal supply schedule item number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJW'"><xsl:value-of select="$myparam"/> (Technical document number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJX'"><xsl:value-of select="$myparam"/> (Technical order number)</xsl:when>
      		<xsl:when test="$myparam.upper='AJY'"><xsl:value-of select="$myparam"/> (Suffix)</xsl:when>
      		<xsl:when test="$myparam.upper='AJZ'"><xsl:value-of select="$myparam"/> (Transportation account number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKA'"><xsl:value-of select="$myparam"/> (Container disposition order reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKB'"><xsl:value-of select="$myparam"/> (Container prefix)</xsl:when>
      		<xsl:when test="$myparam.upper='AKC'"><xsl:value-of select="$myparam"/> (Transport equipment return reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AKD'"><xsl:value-of select="$myparam"/> (Transport equipment survey reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AKE'"><xsl:value-of select="$myparam"/> (Transport equipment survey report number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKF'"><xsl:value-of select="$myparam"/> (Transport equipment stuffing order)</xsl:when>
      		<xsl:when test="$myparam.upper='AKG'"><xsl:value-of select="$myparam"/> (Vehicle Identification Number (VIN))</xsl:when>
      		<xsl:when test="$myparam.upper='AKH'"><xsl:value-of select="$myparam"/> (Government bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='AKI'"><xsl:value-of select="$myparam"/> (Ordering customer's second reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKJ'"><xsl:value-of select="$myparam"/> (Direct debit reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AKK'"><xsl:value-of select="$myparam"/> (Meter reading at the beginning of the delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='AKL'"><xsl:value-of select="$myparam"/> (Meter reading at the end of delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='AKM'"><xsl:value-of select="$myparam"/> (Replenishment purchase order range start number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKN'"><xsl:value-of select="$myparam"/> (Third bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AKO'"><xsl:value-of select="$myparam"/> (Action authorization number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKP'"><xsl:value-of select="$myparam"/> (Appropriation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKQ'"><xsl:value-of select="$myparam"/> (Product change authority number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKR'"><xsl:value-of select="$myparam"/> (General cargo consignment reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKS'"><xsl:value-of select="$myparam"/> (Catalogue sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKT'"><xsl:value-of select="$myparam"/> (Forwarding order number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKU'"><xsl:value-of select="$myparam"/> (Transport equipment survey reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKV'"><xsl:value-of select="$myparam"/> (Lease contract reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AKW'"><xsl:value-of select="$myparam"/> (Transport costs reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKX'"><xsl:value-of select="$myparam"/> (Transport equipment stripping order)</xsl:when>
      		<xsl:when test="$myparam.upper='AKY'"><xsl:value-of select="$myparam"/> (Prior policy number)</xsl:when>
      		<xsl:when test="$myparam.upper='AKZ'"><xsl:value-of select="$myparam"/> (Policy number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALA'"><xsl:value-of select="$myparam"/> (Procurement budget number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALB'"><xsl:value-of select="$myparam"/> (Domestic inventory management code)</xsl:when>
      		<xsl:when test="$myparam.upper='ALC'"><xsl:value-of select="$myparam"/> (Customer reference number assigned to previous balance of payment information)</xsl:when>
      		<xsl:when test="$myparam.upper='ALD'"><xsl:value-of select="$myparam"/> (Previous credit advice reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALE'"><xsl:value-of select="$myparam"/> (Reporting form number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALF'"><xsl:value-of select="$myparam"/> (Authorization number for exception to dangerous goods regulations)</xsl:when>
      		<xsl:when test="$myparam.upper='ALG'"><xsl:value-of select="$myparam"/> (Dangerous goods security number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALH'"><xsl:value-of select="$myparam"/> (Dangerous goods transport licence number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALI'"><xsl:value-of select="$myparam"/> (Previous rental agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALJ'"><xsl:value-of select="$myparam"/> (Next rental agreement reason number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALK'"><xsl:value-of select="$myparam"/> (Consignee's invoice number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALL'"><xsl:value-of select="$myparam"/> (Message batch number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALM'"><xsl:value-of select="$myparam"/> (Previous delivery schedule number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALN'"><xsl:value-of select="$myparam"/> (Physical inventory recount reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALO'"><xsl:value-of select="$myparam"/> (Receiving advice number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALP'"><xsl:value-of select="$myparam"/> (Returnable container reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALQ'"><xsl:value-of select="$myparam"/> (Returns notice number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALR'"><xsl:value-of select="$myparam"/> (Sales forecast number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALS'"><xsl:value-of select="$myparam"/> (Sales report number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALT'"><xsl:value-of select="$myparam"/> (Previous tax control number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALU'"><xsl:value-of select="$myparam"/> (AGERD (Aerospace Ground Equipment Requirement Data) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ALV'"><xsl:value-of select="$myparam"/> (Registered capital reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ALW'"><xsl:value-of select="$myparam"/> (Standard number of inspection document)</xsl:when>
      		<xsl:when test="$myparam.upper='ALX'"><xsl:value-of select="$myparam"/> (Model)</xsl:when>
      		<xsl:when test="$myparam.upper='ALY'"><xsl:value-of select="$myparam"/> (Financial management reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ALZ'"><xsl:value-of select="$myparam"/> (NOTIfication for COLlection number (NOTICOL))</xsl:when>
      		<xsl:when test="$myparam.upper='AMA'"><xsl:value-of select="$myparam"/> (Previous request for metered reading reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMB'"><xsl:value-of select="$myparam"/> (Next rental agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMC'"><xsl:value-of select="$myparam"/> (Reference number of a request for metered reading)</xsl:when>
      		<xsl:when test="$myparam.upper='AMD'"><xsl:value-of select="$myparam"/> (Hastening number)</xsl:when>
      		<xsl:when test="$myparam.upper='AME'"><xsl:value-of select="$myparam"/> (Repair data request number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMF'"><xsl:value-of select="$myparam"/> (Consumption data request number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMG'"><xsl:value-of select="$myparam"/> (Profile number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMH'"><xsl:value-of select="$myparam"/> (Case number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMI'"><xsl:value-of select="$myparam"/> (Government quality assurance and control level Number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMJ'"><xsl:value-of select="$myparam"/> (Payment plan reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AMK'"><xsl:value-of select="$myparam"/> (Replaced meter unit number)</xsl:when>
      		<xsl:when test="$myparam.upper='AML'"><xsl:value-of select="$myparam"/> (Replenishment purchase order range end number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMM'"><xsl:value-of select="$myparam"/> (Insurer assigned reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMN'"><xsl:value-of select="$myparam"/> (Canadian excise entry number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMO'"><xsl:value-of select="$myparam"/> (Premium rate table)</xsl:when>
      		<xsl:when test="$myparam.upper='AMP'"><xsl:value-of select="$myparam"/> (Advise through bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AMQ'"><xsl:value-of select="$myparam"/> (US, Department of Transportation bond surety code)</xsl:when>
      		<xsl:when test="$myparam.upper='AMR'"><xsl:value-of select="$myparam"/> (US, Food and Drug Administration establishment indicator)</xsl:when>
      		<xsl:when test="$myparam.upper='AMS'"><xsl:value-of select="$myparam"/> (US, Federal Communications Commission (FCC) import condition number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMT'"><xsl:value-of select="$myparam"/> (Goods and Services Tax identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMU'"><xsl:value-of select="$myparam"/> (Integrated logistic support cross reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMV'"><xsl:value-of select="$myparam"/> (Department number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMW'"><xsl:value-of select="$myparam"/> (Buyer's catalogue number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMX'"><xsl:value-of select="$myparam"/> (Financial settlement party's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMY'"><xsl:value-of select="$myparam"/> (Standard's version number)</xsl:when>
      		<xsl:when test="$myparam.upper='AMZ'"><xsl:value-of select="$myparam"/> (Pipeline number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANA'"><xsl:value-of select="$myparam"/> (Account servicing bank's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANB'"><xsl:value-of select="$myparam"/> (Completed units payment request reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANC'"><xsl:value-of select="$myparam"/> (Payment in advance request reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AND'"><xsl:value-of select="$myparam"/> (Parent file)</xsl:when>
      		<xsl:when test="$myparam.upper='ANE'"><xsl:value-of select="$myparam"/> (Sub file)</xsl:when>
      		<xsl:when test="$myparam.upper='ANF'"><xsl:value-of select="$myparam"/> (CAD file layer convention)</xsl:when>
      		<xsl:when test="$myparam.upper='ANG'"><xsl:value-of select="$myparam"/> (Technical regulation)</xsl:when>
      		<xsl:when test="$myparam.upper='ANH'"><xsl:value-of select="$myparam"/> (Plot file)</xsl:when>
      		<xsl:when test="$myparam.upper='ANI'"><xsl:value-of select="$myparam"/> (File conversion journal)</xsl:when>
      		<xsl:when test="$myparam.upper='ANJ'"><xsl:value-of select="$myparam"/> (Authorization number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANK'"><xsl:value-of select="$myparam"/> (Reference number assigned by third party)</xsl:when>
      		<xsl:when test="$myparam.upper='ANL'"><xsl:value-of select="$myparam"/> (Deposit reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANM'"><xsl:value-of select="$myparam"/> (Named bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANN'"><xsl:value-of select="$myparam"/> (Drawee's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANO'"><xsl:value-of select="$myparam"/> (Case of need party's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANP'"><xsl:value-of select="$myparam"/> (Collecting bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANQ'"><xsl:value-of select="$myparam"/> (Remitting bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANR'"><xsl:value-of select="$myparam"/> (Principal's bank reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANS'"><xsl:value-of select="$myparam"/> (Presenting bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANT'"><xsl:value-of select="$myparam"/> (Consignee's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANU'"><xsl:value-of select="$myparam"/> (Financial transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANV'"><xsl:value-of select="$myparam"/> (Credit reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANW'"><xsl:value-of select="$myparam"/> (Receiving bank's authorization number)</xsl:when>
      		<xsl:when test="$myparam.upper='ANX'"><xsl:value-of select="$myparam"/> (Clearing reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ANY'"><xsl:value-of select="$myparam"/> (Sending bank's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AOA'"><xsl:value-of select="$myparam"/> (Documentary payment reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AOD'"><xsl:value-of select="$myparam"/> (Accounting file reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AOE'"><xsl:value-of select="$myparam"/> (Sender's file reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AOF'"><xsl:value-of select="$myparam"/> (Receiver's file reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AOG'"><xsl:value-of select="$myparam"/> (Source document internal reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AOH'"><xsl:value-of select="$myparam"/> (Principal's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AOI'"><xsl:value-of select="$myparam"/> (Debit reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AOJ'"><xsl:value-of select="$myparam"/> (Calendar)</xsl:when>
      		<xsl:when test="$myparam.upper='AOK'"><xsl:value-of select="$myparam"/> (Work shift)</xsl:when>
      		<xsl:when test="$myparam.upper='AOL'"><xsl:value-of select="$myparam"/> (Work breakdown structure)</xsl:when>
      		<xsl:when test="$myparam.upper='AOM'"><xsl:value-of select="$myparam"/> (Organisation breakdown structure)</xsl:when>
      		<xsl:when test="$myparam.upper='AON'"><xsl:value-of select="$myparam"/> (Work task charge number)</xsl:when>
      		<xsl:when test="$myparam.upper='AOO'"><xsl:value-of select="$myparam"/> (Functional work group)</xsl:when>
      		<xsl:when test="$myparam.upper='AOP'"><xsl:value-of select="$myparam"/> (Work team)</xsl:when>
      		<xsl:when test="$myparam.upper='AOQ'"><xsl:value-of select="$myparam"/> (Department)</xsl:when>
      		<xsl:when test="$myparam.upper='AOR'"><xsl:value-of select="$myparam"/> (Statement of work)</xsl:when>
      		<xsl:when test="$myparam.upper='AOS'"><xsl:value-of select="$myparam"/> (Work package)</xsl:when>
      		<xsl:when test="$myparam.upper='AOT'"><xsl:value-of select="$myparam"/> (Planning package)</xsl:when>
      		<xsl:when test="$myparam.upper='AOU'"><xsl:value-of select="$myparam"/> (Cost account)</xsl:when>
      		<xsl:when test="$myparam.upper='AOV'"><xsl:value-of select="$myparam"/> (Work order)</xsl:when>
      		<xsl:when test="$myparam.upper='AOW'"><xsl:value-of select="$myparam"/> (Transportation Control Number (TCN))</xsl:when>
      		<xsl:when test="$myparam.upper='AOX'"><xsl:value-of select="$myparam"/> (Constraint notation)</xsl:when>
      		<xsl:when test="$myparam.upper='AOY'"><xsl:value-of select="$myparam"/> (ETERMS reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AOZ'"><xsl:value-of select="$myparam"/> (Implementation version number)</xsl:when>
      		<xsl:when test="$myparam.upper='AP'"><xsl:value-of select="$myparam"/> (Accounts receivable number)</xsl:when>
      		<xsl:when test="$myparam.upper='APA'"><xsl:value-of select="$myparam"/> (Incorporated legal reference)</xsl:when>
      		<xsl:when test="$myparam.upper='APB'"><xsl:value-of select="$myparam"/> (Payment instalment reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APC'"><xsl:value-of select="$myparam"/> (Equipment owner reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APD'"><xsl:value-of select="$myparam"/> (Cedent's claim number)</xsl:when>
      		<xsl:when test="$myparam.upper='APE'"><xsl:value-of select="$myparam"/> (Reinsurer's claim number)</xsl:when>
      		<xsl:when test="$myparam.upper='APF'"><xsl:value-of select="$myparam"/> (Price/sales catalogue response reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APG'"><xsl:value-of select="$myparam"/> (General purpose message reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APH'"><xsl:value-of select="$myparam"/> (Invoicing data sheet reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='API'"><xsl:value-of select="$myparam"/> (Inventory report reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APJ'"><xsl:value-of select="$myparam"/> (Ceiling formula reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APK'"><xsl:value-of select="$myparam"/> (Price variation formula reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APL'"><xsl:value-of select="$myparam"/> (Reference to account servicing bank's message)</xsl:when>
      		<xsl:when test="$myparam.upper='APM'"><xsl:value-of select="$myparam"/> (Party sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='APN'"><xsl:value-of select="$myparam"/> (Purchaser's request reference)</xsl:when>
      		<xsl:when test="$myparam.upper='APO'"><xsl:value-of select="$myparam"/> (Contractor request reference)</xsl:when>
      		<xsl:when test="$myparam.upper='APP'"><xsl:value-of select="$myparam"/> (Accident reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APQ'"><xsl:value-of select="$myparam"/> (Commercial account summary reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='APR'"><xsl:value-of select="$myparam"/> (Contract breakdown reference)</xsl:when>
      		<xsl:when test="$myparam.upper='APS'"><xsl:value-of select="$myparam"/> (Contractor registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='APT'"><xsl:value-of select="$myparam"/> (Applicable coefficient identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='APU'"><xsl:value-of select="$myparam"/> (Special budget account number)</xsl:when>
      		<xsl:when test="$myparam.upper='APV'"><xsl:value-of select="$myparam"/> (Authorisation for repair reference)</xsl:when>
      		<xsl:when test="$myparam.upper='APW'"><xsl:value-of select="$myparam"/> (Manufacturer defined repair rates reference)</xsl:when>
      		<xsl:when test="$myparam.upper='APX'"><xsl:value-of select="$myparam"/> (Original submitter log number)</xsl:when>
      		<xsl:when test="$myparam.upper='APY'"><xsl:value-of select="$myparam"/> (Original submitter, parent Data Maintenance Request (DMR) log number)</xsl:when>
      		<xsl:when test="$myparam.upper='APZ'"><xsl:value-of select="$myparam"/> (Original submitter, child Data Maintenance Request (DMR) log number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQA'"><xsl:value-of select="$myparam"/> (Entry point assessment log number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQB'"><xsl:value-of select="$myparam"/> (Entry point assessment log number, parent DMR)</xsl:when>
      		<xsl:when test="$myparam.upper='AQC'"><xsl:value-of select="$myparam"/> (Entry point assessment log number, child DMR)</xsl:when>
      		<xsl:when test="$myparam.upper='AQD'"><xsl:value-of select="$myparam"/> (Data structure tag)</xsl:when>
      		<xsl:when test="$myparam.upper='AQE'"><xsl:value-of select="$myparam"/> (Central secretariat log number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQF'"><xsl:value-of select="$myparam"/> (Central secretariat log number, parent Data Maintenance Request (DMR))</xsl:when>
      		<xsl:when test="$myparam.upper='AQG'"><xsl:value-of select="$myparam"/> (Central secretariat log number, child Data Maintenance Request (DMR))</xsl:when>
      		<xsl:when test="$myparam.upper='AQH'"><xsl:value-of select="$myparam"/> (International assessment log number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQI'"><xsl:value-of select="$myparam"/> (International assessment log number, parent Data Maintenance Request (DMR))</xsl:when>
      		<xsl:when test="$myparam.upper='AQJ'"><xsl:value-of select="$myparam"/> (International assessment log number, child Data Maintenance Request (DMR))</xsl:when>
      		<xsl:when test="$myparam.upper='AQK'"><xsl:value-of select="$myparam"/> (Status report number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQL'"><xsl:value-of select="$myparam"/> (Message design group number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQM'"><xsl:value-of select="$myparam"/> (US Customs Service (USCS) entry code)</xsl:when>
      		<xsl:when test="$myparam.upper='AQN'"><xsl:value-of select="$myparam"/> (Beginning job sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQO'"><xsl:value-of select="$myparam"/> (Sender's clause number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQP'"><xsl:value-of select="$myparam"/> (Dun and Bradstreet Canada's 8 digit Standard Industrial Classification (SIC) code)</xsl:when>
      		<xsl:when test="$myparam.upper='AQQ'"><xsl:value-of select="$myparam"/> (Activite Principale Exercee (APE) identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AQR'"><xsl:value-of select="$myparam"/> (Dun and Bradstreet US 8 digit Standard Industrial Classification (SIC) code)</xsl:when>
      		<xsl:when test="$myparam.upper='AQS'"><xsl:value-of select="$myparam"/> (Nomenclature Activity Classification Economy (NACE) identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AQT'"><xsl:value-of select="$myparam"/> (Norme Activite Francaise (NAF) identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AQU'"><xsl:value-of select="$myparam"/> (Registered contractor activity type)</xsl:when>
      		<xsl:when test="$myparam.upper='AQV'"><xsl:value-of select="$myparam"/> (Statistic Bundes Amt (SBA) identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AQW'"><xsl:value-of select="$myparam"/> (State or province assigned entity identification)</xsl:when>
      		<xsl:when test="$myparam.upper='AQX'"><xsl:value-of select="$myparam"/> (Institute of Security and Future Market Development (ISFMD) serial number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQY'"><xsl:value-of select="$myparam"/> (File identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQZ'"><xsl:value-of select="$myparam"/> (Bankruptcy procedure number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARA'"><xsl:value-of select="$myparam"/> (National government business identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARB'"><xsl:value-of select="$myparam"/> (Prior Data Universal Number System (DUNS) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARC'"><xsl:value-of select="$myparam"/> (Companies Registry Office (CRO) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARD'"><xsl:value-of select="$myparam"/> (Costa Rican judicial number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARE'"><xsl:value-of select="$myparam"/> (Numero de Identificacion Tributaria (NIT))</xsl:when>
      		<xsl:when test="$myparam.upper='ARF'"><xsl:value-of select="$myparam"/> (Patron number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARG'"><xsl:value-of select="$myparam"/> (Registro Informacion Fiscal (RIF) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARH'"><xsl:value-of select="$myparam"/> (Registro Unico de Contribuyente (RUC) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARI'"><xsl:value-of select="$myparam"/> (Tokyo SHOKO Research (TSR) business identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='ARJ'"><xsl:value-of select="$myparam"/> (Personal identity card number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARK'"><xsl:value-of select="$myparam"/> (Systeme Informatique pour le Repertoire des ENtreprises (SIREN) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARL'"><xsl:value-of select="$myparam"/> (Systeme Informatique pour le Repertoire des ETablissements (SIRET) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARM'"><xsl:value-of select="$myparam"/> (Publication issue number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARN'"><xsl:value-of select="$myparam"/> (Original filing number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARO'"><xsl:value-of select="$myparam"/> (Document page identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='ARP'"><xsl:value-of select="$myparam"/> (Public filing registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARQ'"><xsl:value-of select="$myparam"/> (Regiristo Federal de Contribuyentes)</xsl:when>
      		<xsl:when test="$myparam.upper='ARR'"><xsl:value-of select="$myparam"/> (Social security number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARS'"><xsl:value-of select="$myparam"/> (Document volume number)</xsl:when>
      		<xsl:when test="$myparam.upper='ART'"><xsl:value-of select="$myparam"/> (Book number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARU'"><xsl:value-of select="$myparam"/> (Stock exchange company identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='ARV'"><xsl:value-of select="$myparam"/> (Imputation account)</xsl:when>
      		<xsl:when test="$myparam.upper='ARW'"><xsl:value-of select="$myparam"/> (Financial phase reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ARX'"><xsl:value-of select="$myparam"/> (Technical phase reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ARY'"><xsl:value-of select="$myparam"/> (Prior contractor registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='ARZ'"><xsl:value-of select="$myparam"/> (Stock adjustment number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASA'"><xsl:value-of select="$myparam"/> (Dispensation reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ASB'"><xsl:value-of select="$myparam"/> (Investment reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASC'"><xsl:value-of select="$myparam"/> (Assuming company)</xsl:when>
      		<xsl:when test="$myparam.upper='ASD'"><xsl:value-of select="$myparam"/> (Budget chapter)</xsl:when>
      		<xsl:when test="$myparam.upper='ASE'"><xsl:value-of select="$myparam"/> (Duty free products security number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASF'"><xsl:value-of select="$myparam"/> (Duty free products receipt authorisation number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASG'"><xsl:value-of select="$myparam"/> (Party information message reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ASH'"><xsl:value-of select="$myparam"/> (Formal statement reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ASI'"><xsl:value-of select="$myparam"/> (Proof of delivery reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASJ'"><xsl:value-of select="$myparam"/> (Supplier's credit claim reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASK'"><xsl:value-of select="$myparam"/> (Picture of actual product)</xsl:when>
      		<xsl:when test="$myparam.upper='ASL'"><xsl:value-of select="$myparam"/> (Picture of a generic product)</xsl:when>
      		<xsl:when test="$myparam.upper='ASM'"><xsl:value-of select="$myparam"/> (Trading partner identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASN'"><xsl:value-of select="$myparam"/> (Prior trading partner identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASO'"><xsl:value-of select="$myparam"/> (Password)</xsl:when>
      		<xsl:when test="$myparam.upper='ASP'"><xsl:value-of select="$myparam"/> (Formal report number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASQ'"><xsl:value-of select="$myparam"/> (Fund account number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASR'"><xsl:value-of select="$myparam"/> (Safe custody number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASS'"><xsl:value-of select="$myparam"/> (Master account number)</xsl:when>
      		<xsl:when test="$myparam.upper='AST'"><xsl:value-of select="$myparam"/> (Group reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASU'"><xsl:value-of select="$myparam"/> (Accounting transmission number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASV'"><xsl:value-of select="$myparam"/> (Product data file number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASW'"><xsl:value-of select="$myparam"/> (Cadastro Geral do Contribuinte (CGC))</xsl:when>
      		<xsl:when test="$myparam.upper='ASX'"><xsl:value-of select="$myparam"/> (Foreign resident identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ASY'"><xsl:value-of select="$myparam"/> (CD-ROM)</xsl:when>
      		<xsl:when test="$myparam.upper='ASZ'"><xsl:value-of select="$myparam"/> (Physical medium)</xsl:when>
      		<xsl:when test="$myparam.upper='ATA'"><xsl:value-of select="$myparam"/> (Financial cancellation reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATB'"><xsl:value-of select="$myparam"/> (Purchase for export Customs agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATC'"><xsl:value-of select="$myparam"/> (Judgment number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATD'"><xsl:value-of select="$myparam"/> (Secretariat number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATE'"><xsl:value-of select="$myparam"/> (Previous banking status message reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATF'"><xsl:value-of select="$myparam"/> (Last received banking status message reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATG'"><xsl:value-of select="$myparam"/> (Bank's documentary procedure reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATH'"><xsl:value-of select="$myparam"/> (Customer's documentary procedure reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATI'"><xsl:value-of select="$myparam"/> (Safe deposit box number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATJ'"><xsl:value-of select="$myparam"/> (Receiving Bankgiro number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATK'"><xsl:value-of select="$myparam"/> (Sending Bankgiro number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATL'"><xsl:value-of select="$myparam"/> (Bankgiro reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATM'"><xsl:value-of select="$myparam"/> (Guarantee number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATN'"><xsl:value-of select="$myparam"/> (Collection instrument number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATO'"><xsl:value-of select="$myparam"/> (Converted Postgiro number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATP'"><xsl:value-of select="$myparam"/> (Cost centre alignment number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATQ'"><xsl:value-of select="$myparam"/> (Kamer Van Koophandel (KVK) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATR'"><xsl:value-of select="$myparam"/> (Institut Belgo-Luxembourgeois de Codification (IBLC) number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATS'"><xsl:value-of select="$myparam"/> (External object reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATT'"><xsl:value-of select="$myparam"/> (Exceptional transport authorisation number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATU'"><xsl:value-of select="$myparam"/> (Clave Unica de Identificacion Tributaria (CUIT))</xsl:when>
      		<xsl:when test="$myparam.upper='ATV'"><xsl:value-of select="$myparam"/> (Registro Unico Tributario (RUT))</xsl:when>
      		<xsl:when test="$myparam.upper='ATW'"><xsl:value-of select="$myparam"/> (Flat rack container bundle identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ATX'"><xsl:value-of select="$myparam"/> (Transport equipment acceptance order reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATY'"><xsl:value-of select="$myparam"/> (Transport equipment release order reference)</xsl:when>
      		<xsl:when test="$myparam.upper='ATZ'"><xsl:value-of select="$myparam"/> (Ship's stay reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AU'"><xsl:value-of select="$myparam"/> (Authorization to meet competition number)</xsl:when>
      		<xsl:when test="$myparam.upper='AUA'"><xsl:value-of select="$myparam"/> (Place of positioning reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUB'"><xsl:value-of select="$myparam"/> (Party reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUC'"><xsl:value-of select="$myparam"/> (Issued prescription identification)</xsl:when>
      		<xsl:when test="$myparam.upper='AUD'"><xsl:value-of select="$myparam"/> (Collection reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUE'"><xsl:value-of select="$myparam"/> (Travel service)</xsl:when>
      		<xsl:when test="$myparam.upper='AUF'"><xsl:value-of select="$myparam"/> (Consignment stock contract)</xsl:when>
      		<xsl:when test="$myparam.upper='AUG'"><xsl:value-of select="$myparam"/> (Importer's letter of credit reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUH'"><xsl:value-of select="$myparam"/> (Performed prescription identification)</xsl:when>
      		<xsl:when test="$myparam.upper='AUI'"><xsl:value-of select="$myparam"/> (Image reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUJ'"><xsl:value-of select="$myparam"/> (Proposed purchase order reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AUK'"><xsl:value-of select="$myparam"/> (Application for financial support reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AUL'"><xsl:value-of select="$myparam"/> (Manufacturing quality agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='AUM'"><xsl:value-of select="$myparam"/> (Software editor reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUN'"><xsl:value-of select="$myparam"/> (Software reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUO'"><xsl:value-of select="$myparam"/> (Software quality reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUP'"><xsl:value-of select="$myparam"/> (Consolidated orders' reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUQ'"><xsl:value-of select="$myparam"/> (Customs binding ruling number)</xsl:when>
      		<xsl:when test="$myparam.upper='AUR'"><xsl:value-of select="$myparam"/> (Customs non-binding ruling number)</xsl:when>
      		<xsl:when test="$myparam.upper='AUS'"><xsl:value-of select="$myparam"/> (Delivery route reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUT'"><xsl:value-of select="$myparam"/> (Net area supplier reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUU'"><xsl:value-of select="$myparam"/> (Time series reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AUV'"><xsl:value-of select="$myparam"/> (Connecting point to central grid)</xsl:when>
      		<xsl:when test="$myparam.upper='AUW'"><xsl:value-of select="$myparam"/> (Marketing plan identification number (MPIN))</xsl:when>
      		<xsl:when test="$myparam.upper='AUX'"><xsl:value-of select="$myparam"/> (Entity reference number, previous)</xsl:when>
      		<xsl:when test="$myparam.upper='AUY'"><xsl:value-of select="$myparam"/> (International Standard Industrial Classification (ISIC) code)</xsl:when>
      		<xsl:when test="$myparam.upper='AUZ'"><xsl:value-of select="$myparam"/> (Customs pre-approval ruling number)</xsl:when>
      		<xsl:when test="$myparam.upper='AV'"><xsl:value-of select="$myparam"/> (Account payable number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVA'"><xsl:value-of select="$myparam"/> (First financial institution's transaction reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AVB'"><xsl:value-of select="$myparam"/> (Product characteristics directory)</xsl:when>
      		<xsl:when test="$myparam.upper='AVC'"><xsl:value-of select="$myparam"/> (Supplier's customer reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVD'"><xsl:value-of select="$myparam"/> (Inventory report request number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVE'"><xsl:value-of select="$myparam"/> (Metering point)</xsl:when>
      		<xsl:when test="$myparam.upper='AVF'"><xsl:value-of select="$myparam"/> (Passenger reservation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVG'"><xsl:value-of select="$myparam"/> (Slaughterhouse approval number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVH'"><xsl:value-of select="$myparam"/> (Meat cutting plant approval number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVI'"><xsl:value-of select="$myparam"/> (Customer travel service identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AVJ'"><xsl:value-of select="$myparam"/> (Export control classification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVK'"><xsl:value-of select="$myparam"/> (Broker reference 3)</xsl:when>
      		<xsl:when test="$myparam.upper='AVL'"><xsl:value-of select="$myparam"/> (Consignment information)</xsl:when>
      		<xsl:when test="$myparam.upper='AVM'"><xsl:value-of select="$myparam"/> (Goods item information)</xsl:when>
      		<xsl:when test="$myparam.upper='AVN'"><xsl:value-of select="$myparam"/> (Dangerous Goods information)</xsl:when>
      		<xsl:when test="$myparam.upper='AVO'"><xsl:value-of select="$myparam"/> (Pilotage services exemption number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVP'"><xsl:value-of select="$myparam"/> (Person registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVQ'"><xsl:value-of select="$myparam"/> (Place of packing approval number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVR'"><xsl:value-of select="$myparam"/> (Original Mandate Reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AVS'"><xsl:value-of select="$myparam"/> (Mandate Reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AVT'"><xsl:value-of select="$myparam"/> (Reservation station indentifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AVU'"><xsl:value-of select="$myparam"/> (Unique goods shipment identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AVV'"><xsl:value-of select="$myparam"/> (Framework Agreement Number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVW'"><xsl:value-of select="$myparam"/> (Hash value)</xsl:when>
      		<xsl:when test="$myparam.upper='AVX'"><xsl:value-of select="$myparam"/> (Movement reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AVY'"><xsl:value-of select="$myparam"/> (Economic Operators Registration and Identification Number (EORI))</xsl:when>
      		<xsl:when test="$myparam.upper='AVZ'"><xsl:value-of select="$myparam"/> (Local Reference Number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWA'"><xsl:value-of select="$myparam"/> (Rate code number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWB'"><xsl:value-of select="$myparam"/> (Air waybill number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWC'"><xsl:value-of select="$myparam"/> (Documentary credit amendment number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWD'"><xsl:value-of select="$myparam"/> (Advising bank's reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AWE'"><xsl:value-of select="$myparam"/> (Cost centre)</xsl:when>
      		<xsl:when test="$myparam.upper='AWF'"><xsl:value-of select="$myparam"/> (Work item quantity determination)</xsl:when>
      		<xsl:when test="$myparam.upper='AWG'"><xsl:value-of select="$myparam"/> (Internal data process number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWH'"><xsl:value-of select="$myparam"/> (Category of work reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AWI'"><xsl:value-of select="$myparam"/> (Policy form number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWJ'"><xsl:value-of select="$myparam"/> (Net area)</xsl:when>
      		<xsl:when test="$myparam.upper='AWK'"><xsl:value-of select="$myparam"/> (Service provider)</xsl:when>
      		<xsl:when test="$myparam.upper='AWL'"><xsl:value-of select="$myparam"/> (Error position)</xsl:when>
      		<xsl:when test="$myparam.upper='AWM'"><xsl:value-of select="$myparam"/> (Service category reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AWN'"><xsl:value-of select="$myparam"/> (Connected location)</xsl:when>
      		<xsl:when test="$myparam.upper='AWO'"><xsl:value-of select="$myparam"/> (Related party)</xsl:when>
      		<xsl:when test="$myparam.upper='AWP'"><xsl:value-of select="$myparam"/> (Latest accounting entry record reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AWQ'"><xsl:value-of select="$myparam"/> (Accounting entry)</xsl:when>
      		<xsl:when test="$myparam.upper='AWR'"><xsl:value-of select="$myparam"/> (Document reference, original)</xsl:when>
      		<xsl:when test="$myparam.upper='AWS'"><xsl:value-of select="$myparam"/> (Hygienic Certificate number, national)</xsl:when>
      		<xsl:when test="$myparam.upper='AWT'"><xsl:value-of select="$myparam"/> (Administrative Reference Code)</xsl:when>
      		<xsl:when test="$myparam.upper='AWU'"><xsl:value-of select="$myparam"/> (Pick-up sheet number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWV'"><xsl:value-of select="$myparam"/> (Phone number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWW'"><xsl:value-of select="$myparam"/> (Buyer's fund number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWX'"><xsl:value-of select="$myparam"/> (Company trading account number)</xsl:when>
      		<xsl:when test="$myparam.upper='AWY'"><xsl:value-of select="$myparam"/> (Reserved goods identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='AWZ'"><xsl:value-of select="$myparam"/> (Handling and movement reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXA'"><xsl:value-of select="$myparam"/> (Instruction to despatch reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXB'"><xsl:value-of select="$myparam"/> (Instruction for returns number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXC'"><xsl:value-of select="$myparam"/> (Metered services consumption report number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXD'"><xsl:value-of select="$myparam"/> (Order status enquiry number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXE'"><xsl:value-of select="$myparam"/> (Firm booking reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXF'"><xsl:value-of select="$myparam"/> (Product inquiry number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXG'"><xsl:value-of select="$myparam"/> (Split delivery number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXH'"><xsl:value-of select="$myparam"/> (Service relation number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXI'"><xsl:value-of select="$myparam"/> (Serial shipping container code)</xsl:when>
      		<xsl:when test="$myparam.upper='AXJ'"><xsl:value-of select="$myparam"/> (Test specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXK'"><xsl:value-of select="$myparam"/> (Transport status report number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXL'"><xsl:value-of select="$myparam"/> (Tooling contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXM'"><xsl:value-of select="$myparam"/> (Formula reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXN'"><xsl:value-of select="$myparam"/> (Pre-agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXO'"><xsl:value-of select="$myparam"/> (Product certification number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXP'"><xsl:value-of select="$myparam"/> (Consignment contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXQ'"><xsl:value-of select="$myparam"/> (Product specification reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='AXR'"><xsl:value-of select="$myparam"/> (Payroll deduction advice reference)</xsl:when>
      		<xsl:when test="$myparam.upper='AXS'"><xsl:value-of select="$myparam"/> (TRACES party identification)</xsl:when>
      		<xsl:when test="$myparam.upper='BA'"><xsl:value-of select="$myparam"/> (Beginning meter reading actual)</xsl:when>
      		<xsl:when test="$myparam.upper='BC'"><xsl:value-of select="$myparam"/> (Buyer's contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='BD'"><xsl:value-of select="$myparam"/> (Bid number)</xsl:when>
      		<xsl:when test="$myparam.upper='BE'"><xsl:value-of select="$myparam"/> (Beginning meter reading estimated)</xsl:when>
      		<xsl:when test="$myparam.upper='BH'"><xsl:value-of select="$myparam"/> (House bill of lading number)</xsl:when>
      		<xsl:when test="$myparam.upper='BM'"><xsl:value-of select="$myparam"/> (Bill of lading number)</xsl:when>
      		<xsl:when test="$myparam.upper='BN'"><xsl:value-of select="$myparam"/> (Consignment identifier, carrier assigned)</xsl:when>
      		<xsl:when test="$myparam.upper='BO'"><xsl:value-of select="$myparam"/> (Blanket order number)</xsl:when>
      		<xsl:when test="$myparam.upper='BR'"><xsl:value-of select="$myparam"/> (Broker or sales office number)</xsl:when>
      		<xsl:when test="$myparam.upper='BT'"><xsl:value-of select="$myparam"/> (Batch number/lot number)</xsl:when>
      		<xsl:when test="$myparam.upper='BTP'"><xsl:value-of select="$myparam"/> (Battery and accumulator producer registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='BW'"><xsl:value-of select="$myparam"/> (Blended with number)</xsl:when>
      		<xsl:when test="$myparam.upper='CAS'"><xsl:value-of select="$myparam"/> (IATA Cargo Agent CASS Address number)</xsl:when>
      		<xsl:when test="$myparam.upper='CAT'"><xsl:value-of select="$myparam"/> (Matching of entries, balanced)</xsl:when>
      		<xsl:when test="$myparam.upper='CAU'"><xsl:value-of select="$myparam"/> (Entry flagging)</xsl:when>
      		<xsl:when test="$myparam.upper='CAV'"><xsl:value-of select="$myparam"/> (Matching of entries, unbalanced)</xsl:when>
      		<xsl:when test="$myparam.upper='CAW'"><xsl:value-of select="$myparam"/> (Document reference, internal)</xsl:when>
      		<xsl:when test="$myparam.upper='CAX'"><xsl:value-of select="$myparam"/> (European Value Added Tax identification)</xsl:when>
      		<xsl:when test="$myparam.upper='CAY'"><xsl:value-of select="$myparam"/> (Cost accounting document)</xsl:when>
      		<xsl:when test="$myparam.upper='CAZ'"><xsl:value-of select="$myparam"/> (Grid operator's customer reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='CBA'"><xsl:value-of select="$myparam"/> (Ticket control number)</xsl:when>
      		<xsl:when test="$myparam.upper='CBB'"><xsl:value-of select="$myparam"/> (Order shipment grouping reference)</xsl:when>
      		<xsl:when test="$myparam.upper='CD'"><xsl:value-of select="$myparam"/> (Credit note number)</xsl:when>
      		<xsl:when test="$myparam.upper='CEC'"><xsl:value-of select="$myparam"/> (Ceding company)</xsl:when>
      		<xsl:when test="$myparam.upper='CED'"><xsl:value-of select="$myparam"/> (Debit letter number)</xsl:when>
      		<xsl:when test="$myparam.upper='CFE'"><xsl:value-of select="$myparam"/> (Consignee's further order)</xsl:when>
      		<xsl:when test="$myparam.upper='CFF'"><xsl:value-of select="$myparam"/> (Animal farm licence number)</xsl:when>
      		<xsl:when test="$myparam.upper='CFO'"><xsl:value-of select="$myparam"/> (Consignor's further order)</xsl:when>
      		<xsl:when test="$myparam.upper='CG'"><xsl:value-of select="$myparam"/> (Consignee's order number)</xsl:when>
      		<xsl:when test="$myparam.upper='CH'"><xsl:value-of select="$myparam"/> (Customer catalogue number)</xsl:when>
      		<xsl:when test="$myparam.upper='CK'"><xsl:value-of select="$myparam"/> (Cheque number)</xsl:when>
      		<xsl:when test="$myparam.upper='CKN'"><xsl:value-of select="$myparam"/> (Checking number)</xsl:when>
      		<xsl:when test="$myparam.upper='CM'"><xsl:value-of select="$myparam"/> (Credit memo number)</xsl:when>
      		<xsl:when test="$myparam.upper='CMR'"><xsl:value-of select="$myparam"/> (Road consignment note number)</xsl:when>
      		<xsl:when test="$myparam.upper='CN'"><xsl:value-of select="$myparam"/> (Carrier's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='CNO'"><xsl:value-of select="$myparam"/> (Charges note document attachment indicator)</xsl:when>
      		<xsl:when test="$myparam.upper='COF'"><xsl:value-of select="$myparam"/> (Call off order number)</xsl:when>
      		<xsl:when test="$myparam.upper='CP'"><xsl:value-of select="$myparam"/> (Condition of purchase document number)</xsl:when>
      		<xsl:when test="$myparam.upper='CR'"><xsl:value-of select="$myparam"/> (Customer reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='CRN'"><xsl:value-of select="$myparam"/> (Transport means journey identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='CS'"><xsl:value-of select="$myparam"/> (Condition of sale document number)</xsl:when>
      		<xsl:when test="$myparam.upper='CST'"><xsl:value-of select="$myparam"/> (Team assignment number)</xsl:when>
      		<xsl:when test="$myparam.upper='CT'"><xsl:value-of select="$myparam"/> (Contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='CU'"><xsl:value-of select="$myparam"/> (Consignment identifier, consignor assigned)</xsl:when>
      		<xsl:when test="$myparam.upper='CV'"><xsl:value-of select="$myparam"/> (Container operators reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='CW'"><xsl:value-of select="$myparam"/> (Package number)</xsl:when>
      		<xsl:when test="$myparam.upper='CZ'"><xsl:value-of select="$myparam"/> (Cooperation contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='DA'"><xsl:value-of select="$myparam"/> (Deferment approval number)</xsl:when>
      		<xsl:when test="$myparam.upper='DAN'"><xsl:value-of select="$myparam"/> (Debit account number)</xsl:when>
      		<xsl:when test="$myparam.upper='DB'"><xsl:value-of select="$myparam"/> (Buyer's debtor number)</xsl:when>
      		<xsl:when test="$myparam.upper='DI'"><xsl:value-of select="$myparam"/> (Distributor invoice number)</xsl:when>
      		<xsl:when test="$myparam.upper='DL'"><xsl:value-of select="$myparam"/> (Debit note number)</xsl:when>
      		<xsl:when test="$myparam.upper='DM'"><xsl:value-of select="$myparam"/> (Document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='DQ'"><xsl:value-of select="$myparam"/> (Delivery note number)</xsl:when>
      		<xsl:when test="$myparam.upper='DR'"><xsl:value-of select="$myparam"/> (Dock receipt number)</xsl:when>
      		<xsl:when test="$myparam.upper='EA'"><xsl:value-of select="$myparam"/> (Ending meter reading actual)</xsl:when>
      		<xsl:when test="$myparam.upper='EB'"><xsl:value-of select="$myparam"/> (Embargo permit number)</xsl:when>
      		<xsl:when test="$myparam.upper='ED'"><xsl:value-of select="$myparam"/> (Export declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='EE'"><xsl:value-of select="$myparam"/> (Ending meter reading estimated)</xsl:when>
      		<xsl:when test="$myparam.upper='EEP'"><xsl:value-of select="$myparam"/> (Electrical and electronic equipment producer registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='EI'"><xsl:value-of select="$myparam"/> (Employer's identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='EN'"><xsl:value-of select="$myparam"/> (Embargo number)</xsl:when>
      		<xsl:when test="$myparam.upper='EQ'"><xsl:value-of select="$myparam"/> (Equipment number)</xsl:when>
      		<xsl:when test="$myparam.upper='ER'"><xsl:value-of select="$myparam"/> (Container/equipment receipt number)</xsl:when>
      		<xsl:when test="$myparam.upper='ERN'"><xsl:value-of select="$myparam"/> (Exporter's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ET'"><xsl:value-of select="$myparam"/> (Excess transportation number)</xsl:when>
      		<xsl:when test="$myparam.upper='EX'"><xsl:value-of select="$myparam"/> (Export permit identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='FC'"><xsl:value-of select="$myparam"/> (Fiscal number)</xsl:when>
      		<xsl:when test="$myparam.upper='FF'"><xsl:value-of select="$myparam"/> (Consignment identifier, freight forwarder assigned)</xsl:when>
      		<xsl:when test="$myparam.upper='FI'"><xsl:value-of select="$myparam"/> (File line identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='FLW'"><xsl:value-of select="$myparam"/> (Flow reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='FN'"><xsl:value-of select="$myparam"/> (Freight bill number)</xsl:when>
      		<xsl:when test="$myparam.upper='FO'"><xsl:value-of select="$myparam"/> (Foreign exchange)</xsl:when>
      		<xsl:when test="$myparam.upper='FS'"><xsl:value-of select="$myparam"/> (Final sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='FT'"><xsl:value-of select="$myparam"/> (Free zone identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='FV'"><xsl:value-of select="$myparam"/> (File version number)</xsl:when>
      		<xsl:when test="$myparam.upper='FX'"><xsl:value-of select="$myparam"/> (Foreign exchange contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='GA'"><xsl:value-of select="$myparam"/> (Standard's number)</xsl:when>
      		<xsl:when test="$myparam.upper='GC'"><xsl:value-of select="$myparam"/> (Government contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='GD'"><xsl:value-of select="$myparam"/> (Standard's code number)</xsl:when>
      		<xsl:when test="$myparam.upper='GDN'"><xsl:value-of select="$myparam"/> (General declaration number)</xsl:when>
      		<xsl:when test="$myparam.upper='GN'"><xsl:value-of select="$myparam"/> (Government reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='HS'"><xsl:value-of select="$myparam"/> (Harmonised system number)</xsl:when>
      		<xsl:when test="$myparam.upper='HWB'"><xsl:value-of select="$myparam"/> (House waybill number)</xsl:when>
      		<xsl:when test="$myparam.upper='IA'"><xsl:value-of select="$myparam"/> (Internal vendor number)</xsl:when>
      		<xsl:when test="$myparam.upper='IB'"><xsl:value-of select="$myparam"/> (In bond number)</xsl:when>
      		<xsl:when test="$myparam.upper='ICA'"><xsl:value-of select="$myparam"/> (IATA cargo agent code number)</xsl:when>
      		<xsl:when test="$myparam.upper='ICE'"><xsl:value-of select="$myparam"/> (Insurance certificate reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='ICO'"><xsl:value-of select="$myparam"/> (Insurance contract reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='II'"><xsl:value-of select="$myparam"/> (Initial sample inspection report number)</xsl:when>
      		<xsl:when test="$myparam.upper='IL'"><xsl:value-of select="$myparam"/> (Internal order number)</xsl:when>
      		<xsl:when test="$myparam.upper='INB'"><xsl:value-of select="$myparam"/> (Intermediary broker)</xsl:when>
      		<xsl:when test="$myparam.upper='INN'"><xsl:value-of select="$myparam"/> (Interchange number new)</xsl:when>
      		<xsl:when test="$myparam.upper='INO'"><xsl:value-of select="$myparam"/> (Interchange number old)</xsl:when>
      		<xsl:when test="$myparam.upper='IP'"><xsl:value-of select="$myparam"/> (Import permit identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='IS'"><xsl:value-of select="$myparam"/> (Invoice number suffix)</xsl:when>
      		<xsl:when test="$myparam.upper='IT'"><xsl:value-of select="$myparam"/> (Internal customer number)</xsl:when>
      		<xsl:when test="$myparam.upper='IV'"><xsl:value-of select="$myparam"/> (Invoice document identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='JB'"><xsl:value-of select="$myparam"/> (Job number)</xsl:when>
      		<xsl:when test="$myparam.upper='JE'"><xsl:value-of select="$myparam"/> (Ending job sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='LA'"><xsl:value-of select="$myparam"/> (Shipping label serial number)</xsl:when>
      		<xsl:when test="$myparam.upper='LAN'"><xsl:value-of select="$myparam"/> (Loading authorisation identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='LAR'"><xsl:value-of select="$myparam"/> (Lower number in range)</xsl:when>
      		<xsl:when test="$myparam.upper='LB'"><xsl:value-of select="$myparam"/> (Lockbox)</xsl:when>
      		<xsl:when test="$myparam.upper='LC'"><xsl:value-of select="$myparam"/> (Letter of credit number)</xsl:when>
      		<xsl:when test="$myparam.upper='LI'"><xsl:value-of select="$myparam"/> (Document line identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='LO'"><xsl:value-of select="$myparam"/> (Load planning number)</xsl:when>
      		<xsl:when test="$myparam.upper='LRC'"><xsl:value-of select="$myparam"/> (Reservation office identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='LS'"><xsl:value-of select="$myparam"/> (Bar coded label serial number)</xsl:when>
      		<xsl:when test="$myparam.upper='MA'"><xsl:value-of select="$myparam"/> (Ship notice/manifest number)</xsl:when>
      		<xsl:when test="$myparam.upper='MB'"><xsl:value-of select="$myparam"/> (Master bill of lading number)</xsl:when>
      		<xsl:when test="$myparam.upper='MF'"><xsl:value-of select="$myparam"/> (Manufacturer's part number)</xsl:when>
      		<xsl:when test="$myparam.upper='MG'"><xsl:value-of select="$myparam"/> (Meter unit number)</xsl:when>
      		<xsl:when test="$myparam.upper='MH'"><xsl:value-of select="$myparam"/> (Manufacturing order number)</xsl:when>
      		<xsl:when test="$myparam.upper='MR'"><xsl:value-of select="$myparam"/> (Message recipient)</xsl:when>
      		<xsl:when test="$myparam.upper='MRN'"><xsl:value-of select="$myparam"/> (Mailing reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='MS'"><xsl:value-of select="$myparam"/> (Message sender)</xsl:when>
      		<xsl:when test="$myparam.upper='MSS'"><xsl:value-of select="$myparam"/> (Manufacturer's material safety data sheet number)</xsl:when>
      		<xsl:when test="$myparam.upper='MWB'"><xsl:value-of select="$myparam"/> (Master air waybill number)</xsl:when>
      		<xsl:when test="$myparam.upper='NA'"><xsl:value-of select="$myparam"/> (North American hazardous goods classification number)</xsl:when>
      		<xsl:when test="$myparam.upper='NF'"><xsl:value-of select="$myparam"/> (Nota Fiscal)</xsl:when>
      		<xsl:when test="$myparam.upper='OH'"><xsl:value-of select="$myparam"/> (Current invoice number)</xsl:when>
      		<xsl:when test="$myparam.upper='OI'"><xsl:value-of select="$myparam"/> (Previous invoice number)</xsl:when>
      		<xsl:when test="$myparam.upper='ON'"><xsl:value-of select="$myparam"/> (Order document identifier, buyer assigned)</xsl:when>
      		<xsl:when test="$myparam.upper='OP'"><xsl:value-of select="$myparam"/> (Original purchase order)</xsl:when>
      		<xsl:when test="$myparam.upper='OR'"><xsl:value-of select="$myparam"/> (General order number)</xsl:when>
      		<xsl:when test="$myparam.upper='PB'"><xsl:value-of select="$myparam"/> (Payer's financial institution account number)</xsl:when>
      		<xsl:when test="$myparam.upper='PC'"><xsl:value-of select="$myparam"/> (Production code)</xsl:when>
      		<xsl:when test="$myparam.upper='PD'"><xsl:value-of select="$myparam"/> (Promotion deal number)</xsl:when>
      		<xsl:when test="$myparam.upper='PE'"><xsl:value-of select="$myparam"/> (Plant number)</xsl:when>
      		<xsl:when test="$myparam.upper='PF'"><xsl:value-of select="$myparam"/> (Prime contractor contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='PI'"><xsl:value-of select="$myparam"/> (Price list version number)</xsl:when>
      		<xsl:when test="$myparam.upper='PK'"><xsl:value-of select="$myparam"/> (Packing list number)</xsl:when>
      		<xsl:when test="$myparam.upper='PL'"><xsl:value-of select="$myparam"/> (Price list number)</xsl:when>
      		<xsl:when test="$myparam.upper='POR'"><xsl:value-of select="$myparam"/> (Purchase order response number)</xsl:when>
      		<xsl:when test="$myparam.upper='PP'"><xsl:value-of select="$myparam"/> (Purchase order change number)</xsl:when>
      		<xsl:when test="$myparam.upper='PQ'"><xsl:value-of select="$myparam"/> (Payment reference)</xsl:when>
      		<xsl:when test="$myparam.upper='PR'"><xsl:value-of select="$myparam"/> (Price quote number)</xsl:when>
      		<xsl:when test="$myparam.upper='PS'"><xsl:value-of select="$myparam"/> (Purchase order number suffix)</xsl:when>
      		<xsl:when test="$myparam.upper='PW'"><xsl:value-of select="$myparam"/> (Prior purchase order number)</xsl:when>
      		<xsl:when test="$myparam.upper='PY'"><xsl:value-of select="$myparam"/> (Payee's financial institution account number)</xsl:when>
      		<xsl:when test="$myparam.upper='RA'"><xsl:value-of select="$myparam"/> (Remittance advice number)</xsl:when>
      		<xsl:when test="$myparam.upper='RC'"><xsl:value-of select="$myparam"/> (Rail/road routing code)</xsl:when>
      		<xsl:when test="$myparam.upper='RCN'"><xsl:value-of select="$myparam"/> (Railway consignment note number)</xsl:when>
      		<xsl:when test="$myparam.upper='RE'"><xsl:value-of select="$myparam"/> (Release number)</xsl:when>
      		<xsl:when test="$myparam.upper='REN'"><xsl:value-of select="$myparam"/> (Consignment receipt identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='RF'"><xsl:value-of select="$myparam"/> (Export reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='RR'"><xsl:value-of select="$myparam"/> (Payer's financial institution transit routing No.(ACH transfers))</xsl:when>
      		<xsl:when test="$myparam.upper='RT'"><xsl:value-of select="$myparam"/> (Payee's financial institution transit routing No.)</xsl:when>
      		<xsl:when test="$myparam.upper='SA'"><xsl:value-of select="$myparam"/> (Sales person number)</xsl:when>
      		<xsl:when test="$myparam.upper='SB'"><xsl:value-of select="$myparam"/> (Sales region number)</xsl:when>
      		<xsl:when test="$myparam.upper='SD'"><xsl:value-of select="$myparam"/> (Sales department number)</xsl:when>
      		<xsl:when test="$myparam.upper='SE'"><xsl:value-of select="$myparam"/> (Serial number)</xsl:when>
      		<xsl:when test="$myparam.upper='SEA'"><xsl:value-of select="$myparam"/> (Allocated seat)</xsl:when>
      		<xsl:when test="$myparam.upper='SF'"><xsl:value-of select="$myparam"/> (Ship from)</xsl:when>
      		<xsl:when test="$myparam.upper='SH'"><xsl:value-of select="$myparam"/> (Previous highest schedule number)</xsl:when>
      		<xsl:when test="$myparam.upper='SI'"><xsl:value-of select="$myparam"/> (SID (Shipper's identifying number for shipment))</xsl:when>
      		<xsl:when test="$myparam.upper='SM'"><xsl:value-of select="$myparam"/> (Sales office number)</xsl:when>
      		<xsl:when test="$myparam.upper='SN'"><xsl:value-of select="$myparam"/> (Transport equipment seal identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='SP'"><xsl:value-of select="$myparam"/> (Scan line)</xsl:when>
      		<xsl:when test="$myparam.upper='SQ'"><xsl:value-of select="$myparam"/> (Equipment sequence number)</xsl:when>
      		<xsl:when test="$myparam.upper='SRN'"><xsl:value-of select="$myparam"/> (Shipment reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='SS'"><xsl:value-of select="$myparam"/> (Sellers reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='STA'"><xsl:value-of select="$myparam"/> (Station reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='SW'"><xsl:value-of select="$myparam"/> (Swap order number)</xsl:when>
      		<xsl:when test="$myparam.upper='SZ'"><xsl:value-of select="$myparam"/> (Specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='TB'"><xsl:value-of select="$myparam"/> (Trucker's bill of lading)</xsl:when>
      		<xsl:when test="$myparam.upper='TCR'"><xsl:value-of select="$myparam"/> (Terminal operator's consignment reference)</xsl:when>
      		<xsl:when test="$myparam.upper='TE'"><xsl:value-of select="$myparam"/> (Telex message number)</xsl:when>
      		<xsl:when test="$myparam.upper='TF'"><xsl:value-of select="$myparam"/> (Transfer number)</xsl:when>
      		<xsl:when test="$myparam.upper='TI'"><xsl:value-of select="$myparam"/> (TIR carnet number)</xsl:when>
      		<xsl:when test="$myparam.upper='TIN'"><xsl:value-of select="$myparam"/> (Transport instruction number)</xsl:when>
      		<xsl:when test="$myparam.upper='TL'"><xsl:value-of select="$myparam"/> (Tax exemption licence number)</xsl:when>
      		<xsl:when test="$myparam.upper='TN'"><xsl:value-of select="$myparam"/> (Transaction reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='TP'"><xsl:value-of select="$myparam"/> (Test report number)</xsl:when>
      		<xsl:when test="$myparam.upper='UAR'"><xsl:value-of select="$myparam"/> (Upper number of range)</xsl:when>
      		<xsl:when test="$myparam.upper='UC'"><xsl:value-of select="$myparam"/> (Ultimate customer's reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='UCN'"><xsl:value-of select="$myparam"/> (Unique consignment reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='UN'"><xsl:value-of select="$myparam"/> (United Nations Dangerous Goods identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='UO'"><xsl:value-of select="$myparam"/> (Ultimate customer's order number)</xsl:when>
      		<xsl:when test="$myparam.upper='URI'"><xsl:value-of select="$myparam"/> (Uniform Resource Identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='VA'"><xsl:value-of select="$myparam"/> (VAT registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='VC'"><xsl:value-of select="$myparam"/> (Vendor contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='VGR'"><xsl:value-of select="$myparam"/> (Transport equipment gross mass verification reference number)</xsl:when>
      		<xsl:when test="$myparam.upper='VM'"><xsl:value-of select="$myparam"/> (Vessel identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='VN'"><xsl:value-of select="$myparam"/> (Order number (vendor))</xsl:when>
      		<xsl:when test="$myparam.upper='VON'"><xsl:value-of select="$myparam"/> (Voyage number)</xsl:when>
      		<xsl:when test="$myparam.upper='VOR'"><xsl:value-of select="$myparam"/> (Transport equipment gross mass verification order reference)</xsl:when>
      		<xsl:when test="$myparam.upper='VP'"><xsl:value-of select="$myparam"/> (Vendor product number)</xsl:when>
      		<xsl:when test="$myparam.upper='VR'"><xsl:value-of select="$myparam"/> (Vendor ID number)</xsl:when>
      		<xsl:when test="$myparam.upper='VS'"><xsl:value-of select="$myparam"/> (Vendor order number suffix)</xsl:when>
      		<xsl:when test="$myparam.upper='VT'"><xsl:value-of select="$myparam"/> (Motor vehicle identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='VV'"><xsl:value-of select="$myparam"/> (Voucher number)</xsl:when>
      		<xsl:when test="$myparam.upper='WE'"><xsl:value-of select="$myparam"/> (Warehouse entry number)</xsl:when>
      		<xsl:when test="$myparam.upper='WM'"><xsl:value-of select="$myparam"/> (Weight agreement number)</xsl:when>
      		<xsl:when test="$myparam.upper='WN'"><xsl:value-of select="$myparam"/> (Well number)</xsl:when>
      		<xsl:when test="$myparam.upper='WR'"><xsl:value-of select="$myparam"/> (Warehouse receipt number)</xsl:when>
      		<xsl:when test="$myparam.upper='WS'"><xsl:value-of select="$myparam"/> (Warehouse storage location number)</xsl:when>
      		<xsl:when test="$myparam.upper='WY'"><xsl:value-of select="$myparam"/> (Rail waybill number)</xsl:when>
      		<xsl:when test="$myparam.upper='XA'"><xsl:value-of select="$myparam"/> (Company/place registration number)</xsl:when>
      		<xsl:when test="$myparam.upper='XC'"><xsl:value-of select="$myparam"/> (Cargo control number)</xsl:when>
      		<xsl:when test="$myparam.upper='XP'"><xsl:value-of select="$myparam"/> (Previous cargo control number)</xsl:when>
      		<xsl:when test="$myparam.upper='ZZZ'"><xsl:value-of select="$myparam"/> (Mutually defined reference number)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>