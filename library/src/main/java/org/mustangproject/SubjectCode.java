package org.mustangproject;

/**
 * EN16931-ID: BT-21 - the qualification of the free text on the invoice from BT-22
 * @see <a href="https://unece.org/fileadmin/DAM/trade/untdid/d16b/tred/tred4451.htm">UN/EDIFACT D.16B - Data Element [4451]</a>
 */
public enum SubjectCode {
	AAA, //Goods item description
	AAB, //Payment term
	AAC, //Dangerous goods additional information
	AAD, //Dangerous goods technical name
	AAE, //Acknowledgement description
	AAF, //Rate additional information
	AAG, //Party instructions
	AAI, //General information
	AAJ, //Additional conditions of sale/purchase
	AAK, //Price conditions
	AAL, //Goods dimensions in characters
	AAM, //Equipment re-usage restrictions
	AAN, //Handling restriction
	AAO, //Error description (free text)
	AAP, //Response (free text)
	AAQ, //Package content’s description
	AAR, //Terms of delivery
	AAS, //Bill of lading remarks
	AAT, //Mode of settlement information
	AAU, //Consignment invoice information
	AAV, //Clearance invoice information
	AAW, //Letter of credit information
	AAX, //License information
	AAY, //Certification statements
	AAZ, //Additional export information
	ABA, //Tariff statements
	ABB, //Medical history
	ABC, //Conditions of sale or purchase
	ABD, //Contract document type
	ABE, //Additional terms and/or conditions (documentary credit)
	ABF, //Instructions or information about standby documentary
	ABG, //Instructions or information about partial shipment(s)
	ABH, //Instructions or information about transhipment(s)
	ABI, //Additional handling instructions documentary credit
	ABJ, //Domestic routing information
	ABK, //Chargeable category of equipment
	ABL, //Government information
	ABM, //Onward routing information
	ABN, //Accounting information
	ABO, //Discrepancy information
	ABP, //Confirmation instructions
	ABQ, //Method of issuance
	ABR, //Documents delivery instructions
	ABS, //Additional conditions
	ABT, //Information/instructions about additional amounts covered
	ABU, //Deferred payment termed additional
	ABV, //Acceptance terms additional
	ABW, //Negotiation terms additional
	ABX, //Document name and documentary requirements
	ABZ, //Instructions/information about revolving documentary credit
	ACA, //Documentary requirements
	ACB, //Additional information
	ACC, //Factor assignment clause
	ACD, //Reason
	ACE, //Dispute
	ACF, //Additional attribute information
	ACG, //Absence declaration
	ACH, //Aggregation statement
	ACI, //Compilation statement
	ACJ, //Definitional exception
	ACK, //Privacy statement
	ACL, //Quality statement
	ACM, //Statistical description
	ACN, //Statistical definition
	ACO, //Statistical name
	ACP, //Statistical title
	ACQ, //Off-dimension information
	ACR, //Unexpected stops information
	ACS, //Principles
	ACT, //Terms and definition
	ACU, //Segment name
	ACV, //Simple data element name
	ACW, //Scope
	ACX, //Message type name
	ACY, //Introduction
	ACZ, //Glossary
	ADA, //Functional definition
	ADB, //Examples
	ADC, //Cover page
	ADD, //Dependency (syntax) notes
	ADE, //Code value name
	ADF, //Code list name
	ADG, //Clarification of usage
	ADH, //Composite data element name
	ADI, //Field of application
	ADJ, //Type of assets and liabilities
	ADK, //Promotion information
	ADL, //Meter condition
	ADM, //Meter reading information
	ADN, //Type of transaction reason
	ADO, //Type of survey question
	ADP, //Carrier’s agent counter information
	ADQ, //Description of work item on equipment
	ADR, //Message definition
	ADS, //Booked item information
	ADT, //Source of document
	ADU, //Note
	ADV, //Fixed part of segment clarification text
	ADW, //Characteristics of goods
	ADX, //Additional discharge instructions
	ADY, //Container stripping instructions
	ADZ, //CSC (Container Safety Convention) plate information
	AEA, //Cargo remarks
	AEB, //Temperature control instructions
	AEC, //Text refers to expected data
	AED, //Text refers to received data
	AEE, //Section clarification text
	AEF, //Information to the beneficiary
	AEG, //Information to the applicant
	AEH, //Instructions to the beneficiary
	AEI, //Instructions to the applicant
	AEJ, //Controlled atmosphere
	AEK, //Take off annotation
	AEL, //Price variation narrative
	AEM, //Documentary credit amendment instructions
	AEN, //Standard method narrative
	AEO, //Project narrative
	AEP, //Radioactive goods, additional information
	AEQ, //Bank-to-bank information
	AER, //Reimbursement instructions
	AES, //Reason for amending a message
	AET, //Instructions to the paying and/or accepting and/or
	AEU, //Interest instructions
	AEV, //Agent commission
	AEW, //Remitting bank instructions
	AEX, //Instructions to the collecting bank
	AEY, //Collection amount instructions
	AEZ, //Internal auditing information
	AFA, //Constraint
	AFB, //Comment
	AFC, //Semantic note
	AFD, //Help text
	AFE, //Legend
	AFF, //Batch code structure
	AFG, //Product application
	AFH, //Customer complaint
	AFI, //Probable cause of fault
	AFJ, //Defect description
	AFK, //Repair description
	AFL, //Review comments
	AFM, //Title
	AFN, //Description of amount
	AFO, //Responsibilities
	AFP, //Supplier
	AFQ, //Purchase region
	AFR, //Affiliation
	AFS, //Borrower
	AFT, //Line of business
	AFU, //Financial institution
	AFV, //Business founder
	AFW, //Business history
	AFX, //Banking arrangements
	AFY, //Business origin
	AFZ, //Brand names’ description
	AGA, //Business financing details
	AGB, //Competition
	AGC, //Construction process details
	AGD, //Construction specialty
	AGE, //Contract information
	AGF, //Corporate filing
	AGG, //Customer information
	AGH, //Copyright notice
	AGI, //Contingent debt
	AGJ, //Conviction details
	AGK, //Equipment
	AGL, //Workforce description
	AGM, //Exemption
	AGN, //Future plans
	AGO, //Interviewee conversation information
	AGP, //Intangible asset
	AGQ, //Inventory
	AGR, //Investment
	AGS, //Intercompany relations information
	AGT, //Joint venture
	AGU, //Loan
	AGV, //Long term debt
	AGW, //Location
	AGX, //Current legal structure
	AGY, //Marital contract
	AGZ, //Marketing activities
	AHA, //Merger
	AHB, //Marketable securities
	AHC, //Business debt
	AHD, //Original legal structure
	AHE, //Employee sharing arrangements
	AHF, //Organization details
	AHG, //Public record details
	AHH, //Price range
	AHI, //Qualifications
	AHJ, //Registered activity
	AHK, //Criminal sentence
	AHL, //Sales method
	AHM, //Educational institution information
	AHN, //Status details
	AHO, //Sales
	AHP, //Spouse information
	AHQ, //Educational degree information
	AHR, //Shareholding information
	AHS, //Sales territory
	AHT, //Accountant’s comments
	AHU, //Exemption law location
	AHV, //Share classifications
	AHW, //Forecast
	AHX, //Event location
	AHY, //Facility occupancy
	AHZ, //Import and export details
	AIA, //Additional facility information
	AIB, //Inventory value
	AIC, //Education
	AID, //Event
	AIE, //Agent
	AIF, //Domestically agreed financial statement details
	AIG, //Other current asset description
	AIH, //Other current liability description
	AII, //Former business activity
	AIJ, //Trade name use
	AIK, //Signing authority
	AIL, //Guarantee
	AIM, //Holding company operation
	AIN, //Consignment routing
	AIO, //Letter of protest
	AIP, //Question
	AIQ, //Party information
	AIR, //Area boundaries description
	AIS, //Advertisement information
	AIT, //Financial statement details
	AIU, //Access instructions
	AIV, //Liquidity
	AIW, //Credit line
	AIX, //Warranty terms
	AIY, //Division description
	AIZ, //Reporting instruction
	AJA, //Examination result
	AJB, //Laboratory result
	ALC, //Allowance/charge information
	ALD, //X-ray result
	ALE, //Pathology result
	ALF, //Intervention description
	ALG, //Summary of admittance
	ALH, //Medical treatment course detail
	ALI, //Prognosis
	ALJ, //Instruction to patient
	ALK, //Instruction to physician
	ALL, //All documents
	ALM, //Medicine treatment
	ALN, //Medicine dosage and administration
	ALO, //Availability of patient
	ALP, //Reason for service request
	ALQ, //Purpose of service
	ARR, //Arrival conditions
	ARS, //Service requester’s comment
	AUT, //Authentication
	AUU, //Requested location description
	AUV, //Medicine administration condition
	AUW, //Patient information
	AUX, //Precautionary measure
	AUY, //Service characteristic
	AUZ, //Planned event comment
	AVA, //Expected delay comment
	AVB, //Transport requirements comment
	AVC, //Temporary approval condition
	AVD, //Customs Valuation Information
	AVE, //Value Added Tax (VAT) margin scheme
	AVF, //Maritime Declaration of Health
	BAG, //Passenger baggage information
	BAH, //Maritime Declaration of Health
	BAI, //Additional product information address
	BAJ, //Information to be printed on despatch advice
	BAK, //Missing goods remarks
	BAL, //Non-acceptance information
	BAM, //Returns information
	BAN, //Sub-line item information
	BAO, //Test information
	BAP, //External link
	BAQ, //VAT exemption reason
	BAR, //Processing Instructions
	BAS, //Relay Instructions
	BAT, //SIMA applicable
	BAU, //Appeals program code
	BAV, //SIMA subject
	BAW, //Surtax applicable
	BAX, //SIMA security bond
	BAY, //Surtax subject
	BAZ, //Safeguard applicable
	BBA, //Safeguard applicable
	BBB, //Safeguard subject
	BLC, //Transport contract document clause
	BLD, //Instruction to prepare the patient
	BLE, //Medicine treatment comment
	BLF, //Examination result comment
	BLG, //Service request comment
	BLH, //Prescription reason
	BLI, //Prescription comment
	BLJ, //Clinical investigation comment
	BLK, //Medicinal specification comment
	BLL, //Economic contribution comment
	BLM, //Status of a plan
	BLN, //Random sample test information
	BLO, //Period of time
	BLP, //Legislation
	BLQ, //Security measures requested
	BLR, //Transport contract document remark
	BLS, //Previous port of call security information
	BLT, //Security information
	BLU, //Waste information
	BLV, //B2C marketing information, short description
	BLW, //B2B marketing information, long description
	BLX, //B2C marketing information, long description
	BLY, //Product ingredients
	BLZ, //Location short name
	BMA, //Packaging material information
	BMB, //Filler material information
	BMC, //Ship-to-ship activity information
	BMD, //Package material description
	BME, //Consumer level package marking
	BMF, //SIMA measure in force
	BMG, //Pre-CARM
	BMH, //SIMA measure type
	CCI, //Customs clearance instructions
	CCJ, //Sub Type Code
	CCK, //SIMA information
	CCL, //Time limit end
	CCM, //Time limit start
	CCN, //Warehouse time limit
	CCO, //Value for duty information
	CEX, //Customs clearance instructions export
	CHG, //Change information
	CIP, //Customs clearance instruction import
	CLP, //Clearance place requested
	CLR, //Loading remarks
	COI, //Order information
	CUR, //Customer remarks
	CUS, //Customs declaration information
	DAR, //Damage remarks
	DCL, //Document issuer declaration
	DEL, //Delivery information
	DIN, //Delivery instructions
	DOC, //Documentation instructions
	DUT, //Duty declaration
	EUR, //Effective used routing
	FBC, //First block to be printed on the transport contract
	GBL, //Government bill of lading information
	GEN, //Entire transaction set
	GS7, //Further information concerning GGVS par. 7
	HAN, //Consignment handling instruction
	HAZ, //Hazard information
	ICN, //Consignment information for consignee
	IIN, //Insurance instructions
	IMI, //Invoice mailing instructions
	IND, //Commercial invoice item description
	INS, //Insurance information
	INV, //Invoice instruction
	IRP, //Information for railway purpose
	ITR, //Inland transport details
	ITS, //Testing instructions
	LAN, //Location Alias
	LIN, //Line item
	LOI, //Loading instruction
	MCO, //Miscellaneous charge order
	MDH, //Maritime Declaration of Health
	MKS, //Additional marks/numbers information
	ORI, //Order instruction
	OSI, //Other service information
	PAC, //Packing/marking information
	PAI, //Payment instructions information
	PAY, //Payables information
	PKG, //Packaging information
	PKT, //Packaging terms information
	PMD, //Payment detail/remittance information
	PMT, //Payment information
	PRD, //Product information
	PRF, //Price calculation formula
	PRI, //Priority information
	PUR, //Purchasing information
	QIN, //Quarantine instructions
	QQD, //Quality demands/requirements
	QUT, //Quotation instruction/information
	RAH, //Risk and handling information
	REG, //Regulatory information
	RET, //Return to origin information
	REV, //Receivables
	RQR, //Consignment route
	SAF, //Safety information
	SIC, //Consignment documentary instruction
	SIN, //Special instructions
	SLR, //Ship line requested
	SPA, //Special permission for transport, generally
	SPG, //Special permission concerning the goods to be transported
	SPH, //Special handling
	SPP, //Special permission concerning package
	SPT, //Special permission concerning transport means
	SRN, //Subsidiary risk number (IATA/DGR)
	SSR, //Special service request
	SUR, //Supplier remarks
	TCA, //Consignment tariff
	TDT, //Consignment transport
	TRA, //Transportation information
	TRR, //Requested tariff
	TXD, //Tax declaration
	WHI, //Warehouse instruction/information
	ZZZ //Mutually defined}
}
