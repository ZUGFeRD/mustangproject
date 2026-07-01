package org.mustangproject;

/**
 * EN16931-ID: BT-21 - the qualification of the free text on the invoice from BT-22
 * @see <a href="https://service.unece.org/trade/untdid/d96a/uncl/uncl4451.htm">UNTDID - D.96A - Element 4451</a> for a complete list of codes
 *
 *
 * Complete UNTDID 4451 code list. Previously only a subset was implemented;
 * all standard codes are now available.
 *
 * 
 * Recommended codes for invoice notes:
 * AAI : General information / Allgemeine Informationen
 * SUR : Supplier remarks / Anmerkungen des Verkäufers
 * REG : Regulatory information / Regulatorische Informationen
 * ABL : Government information / Rechtliche Informationen
 * TXD : Tax declaration / Informationen zur Steuer
 * CUS : Customs declaration information / Zollinformationen
 *
 * plus
 * ACY : Introduction
 * AAK : Price conditions
 * ABZ : Instructions/information about revolving documentary credit
 * PMT : Payment information
 * PMD : Payment detail/remittance information
 * AAB : Terms of payments
 * ACB : Additional information
 * INV : Invoice instruction
 */
public enum SubjectCode {
  /**
	 * Goods item description
	 */
	AAA,
	/**
	 * Payment term
	 */
	AAB,
	/**
	 * Dangerous goods additional information
	 */
	AAC,
	/**
	 * Dangerous goods technical name
	 */
	AAD,
	/**
	 * Acknowledgement description
	 */
	AAE,
	/**
	 * Rate additional information
	 */
	AAF,
	/**
	 * Party instructions
	 */
	AAG,
	/**
	 * general information
	 */
	AAI,
	/**
	 * Additional conditions of sale/purchase
	 */
	AAJ,
	/**
	 * Discount and bonus agreements
	 */
	AAK,
	/**
	 * Goods dimensions in characters
	 */
	AAL,
	/**
	 * Equipment re-usage restrictions
	 */
	AAM,
	/**
	 * Handling restriction
	 */
	AAN,
	/**
	 * Error description (free text)
	 */
	AAO,
	/**
	 * Response (free text)
	 */
	AAP,
	/**
	 * Package content's description
	 */
	AAQ,
	/**
	 * Terms of delivery
	 */
	AAR,
	/**
	 * Bill of lading remarks
	 */
	AAS,
	/**
	 * Mode of settlement information
	 */
	AAT,
	/**
	 * Consignment invoice information
	 */
	AAU,
	/**
	 * Clearance invoice information
	 */
	AAV,
	/**
	 * Letter of credit information
	 */
	AAW,
	/**
	 * License information
	 */
	AAX,
	/**
	 * Certification statements
	 */
	AAY,
	/**
	 * Additional export information
	 */
	AAZ,
	/**
	 * Tariff statements
	 */
	ABA,
	/**
	 * Medical history
	 */
	ABB,
	/**
	 * Conditions of sale or purchase
	 */
	ABC,
	/**
	 * Contract document type
	 */
	ABD,
	/**
	 * Additional terms and/or conditions (documentary credit)
	 */
	ABE,
	/**
	 * Instructions or information about standby documentary
	 */
	ABF,
	/**
	 * Instructions or information about partial shipment(s)
	 */
	ABG,
	/**
	 * Instructions or information about transhipment(s)
	 */
	ABH,
	/**
	 * Additional handling instructions documentary credit
	 */
	ABI,
	/**
	 * Domestic routing information
	 */
	ABJ,
	/**
	 * Chargeable category of equipment
	 */
	ABK,
	/**
	 * legal information
	 */
	ABL,
	/**
	 * Onward routing information
	 */
	ABM,
	/**
	 * Accounting information
	 */
	ABN,
	/**
	 * Discrepancy information
	 */
	ABO,
	/**
	 * Confirmation instructions
	 */
	ABP,
	/**
	 * Method of issuance
	 */
	ABQ,
	/**
	 * Documents delivery instructions
	 */
	ABR,
	/**
	 * Additional conditions
	 */
	ABS,
	/**
	 * Information/instructions about additional amounts covered
	 */
	ABT,
	/**
	 * Deferred payment termed additional
	 */
	ABU,
	/**
	 * Acceptance terms additional
	 */
	ABV,
	/**
	 * Negotiation terms additional
	 */
	ABW,
	/**
	 * Document name and documentary requirements
	 */
	ABX,
	/**
	 * Instructions/information about revolving documentary credit
	 */
	ABZ,
	/**
	 * Documentary requirements
	 */
	ACA,
	/**
	 * Additional information
	 */
	ACB,
	/**
	 * Factor assignment clause
	 */
	ACC,
	/**
	 * Reason
	 */
	ACD,
	/**
	 * Dispute
	 */
	ACE,
	/**
	 * Additional attribute information
	 */
	ACF,
	/**
	 * Absence declaration
	 */
	ACG,
	/**
	 * Aggregation statement
	 */
	ACH,
	/**
	 * Compilation statement
	 */
	ACI,
	/**
	 * Definitional exception
	 */
	ACJ,
	/**
	 * Privacy statement
	 */
	ACK,
	/**
	 * Quality statement
	 */
	ACL,
	/**
	 * Statistical description
	 */
	ACM,
	/**
	 * Statistical definition
	 */
	ACN,
	/**
	 * Statistical name
	 */
	ACO,
	/**
	 * Statistical title
	 */
	ACP,
	/**
	 * Off-dimension information
	 */
	ACQ,
	/**
	 * Unexpected stops information
	 */
	ACR,
	/**
	 * Principles
	 */
	ACS,
	/**
	 * Terms and definition
	 */
	ACT,
	/**
	 * Segment name
	 */
	ACU,
	/**
	 * Simple data element name
	 */
	ACV,
	/**
	 * Scope
	 */
	ACW,
	/**
	 * Message type name
	 */
	ACX,
	/**
	 * introduction
	 */
	ACY,
	/**
	 * Glossary
	 */
	ACZ,
	/**
	 * Functional definition
	 */
	ADA,
	/**
	 * Examples
	 */
	ADB,
	/**
	 * Cover page
	 */
	ADC,
	/**
	 * Dependency (syntax) notes
	 */
	ADD,
	/**
	 * Code value name
	 */
	ADE,
	/**
	 * Code list name
	 */
	ADF,
	/**
	 * Clarification of usage
	 */
	ADG,
	/**
	 * Composite data element name
	 */
	ADH,
	/**
	 * Field of application
	 */
	ADI,
	/**
	 * Type of assets and liabilities
	 */
	ADJ,
	/**
	 * Promotion information
	 */
	ADK,
	/**
	 * Meter condition
	 */
	ADL,
	/**
	 * Meter reading information
	 */
	ADM,
	/**
	 * Type of transaction reason
	 */
	ADN,
	/**
	 * Type of survey question
	 */
	ADO,
	/**
	 * Carrier's agent counter information
	 */
	ADP,
	/**
	 * Description of work item on equipment
	 */
	ADQ,
	/**
	 * Message definition
	 */
	ADR,
	/**
	 * Booked item information
	 */
	ADS,
	/**
	 * Source of document
	 */
	ADT,
	/**
	 * Note
	 */
	ADU,
	/**
	 * Fixed part of segment clarification text
	 */
	ADV,
	/**
	 * Characteristics of goods
	 */
	ADW,
	/**
	 * Additional discharge instructions
	 */
	ADX,
	/**
	 * Container stripping instructions
	 */
	ADY,
	/**
	 * CSC (Container Safety Convention) plate information
	 */
	ADZ,
	/**
	 * Cargo remarks
	 */
	AEA,
	/**
	 * Temperature control instructions
	 */
	AEB,
	/**
	 * Text refers to expected data
	 */
	AEC,
	/**
	 * Text refers to received data
	 */
	AED,
	/**
	 * Section clarification text
	 */
	AEE,
	/**
	 * Information to the beneficiary
	 */
	AEF,
	/**
	 * Information to the applicant
	 */
	AEG,
	/**
	 * Instructions to the beneficiary
	 */
	AEH,
	/**
	 * Instructions to the applicant
	 */
	AEI,
	/**
	 * Controlled atmosphere
	 */
	AEJ,
	/**
	 * Take off annotation
	 */
	AEK,
	/**
	 * Price variation narrative
	 */
	AEL,
	/**
	 * Documentary credit amendment instructions
	 */
	AEM,
	/**
	 * Standard method narrative
	 */
	AEN,
	/**
	 * Project narrative
	 */
	AEO,
	/**
	 * Radioactive goods, additional information
	 */
	AEP,
	/**
	 * Bank-to-bank information
	 */
	AEQ,
	/**
	 * Reimbursement instructions
	 */
	AER,
	/**
	 * Reason for amending a message
	 */
	AES,
	/**
	 * Instructions to the paying and/or accepting and/or negotiating bank
	 */
	AET,
	/**
	 * Interest instructions
	 */
	AEU,
	/**
	 * Agent commission
	 */
	AEV,
	/**
	 * Remitting bank instructions
	 */
	AEW,
	/**
	 * Instructions to the collecting bank
	 */
	AEX,
	/**
	 * Collection amount instructions
	 */
	AEY,
	/**
	 * Internal auditing information
	 */
	AEZ,
	/**
	 * Constraint
	 */
	AFA,
	/**
	 * Comment
	 */
	AFB,
	/**
	 * Semantic note
	 */
	AFC,
	/**
	 * Help text
	 */
	AFD,
	/**
	 * Legend
	 */
	AFE,
	/**
	 * Batch code structure
	 */
	AFF,
	/**
	 * Product application
	 */
	AFG,
	/**
	 * Customer complaint
	 */
	AFH,
	/**
	 * Probable cause of fault
	 */
	AFI,
	/**
	 * Defect description
	 */
	AFJ,
	/**
	 * Repair description
	 */
	AFK,
	/**
	 * Review comments
	 */
	AFL,
	/**
	 * Title
	 */
	AFM,
	/**
	 * Description of amount
	 */
	AFN,
	/**
	 * Responsibilities
	 */
	AFO,
	/**
	 * Supplier
	 */
	AFP,
	/**
	 * Purchase region
	 */
	AFQ,
	/**
	 * Affiliation
	 */
	AFR,
	/**
	 * Borrower
	 */
	AFS,
	/**
	 * Line of business
	 */
	AFT,
	/**
	 * Financial institution
	 */
	AFU,
	/**
	 * Business founder
	 */
	AFV,
	/**
	 * Business history
	 */
	AFW,
	/**
	 * Banking arrangements
	 */
	AFX,
	/**
	 * Business origin
	 */
	AFY,
	/**
	 * Brand names' description
	 */
	AFZ,
	/**
	 * Business financing details
	 */
	AGA,
	/**
	 * Competition
	 */
	AGB,
	/**
	 * Construction process details
	 */
	AGC,
	/**
	 * Construction specialty
	 */
	AGD,
	/**
	 * Contract information
	 */
	AGE,
	/**
	 * Corporate filing
	 */
	AGF,
	/**
	 * Customer information
	 */
	AGG,
	/**
	 * Copyright notice
	 */
	AGH,
	/**
	 * Contingent debt
	 */
	AGI,
	/**
	 * Conviction details
	 */
	AGJ,
	/**
	 * Equipment
	 */
	AGK,
	/**
	 * Workforce description
	 */
	AGL,
	/**
	 * Exemption
	 */
	AGM,
	/**
	 * Future plans
	 */
	AGN,
	/**
	 * Interviewee conversation information
	 */
	AGO,
	/**
	 * Intangible asset
	 */
	AGP,
	/**
	 * Inventory
	 */
	AGQ,
	/**
	 * Investment
	 */
	AGR,
	/**
	 * Intercompany relations information
	 */
	AGS,
	/**
	 * Joint venture
	 */
	AGT,
	/**
	 * Loan
	 */
	AGU,
	/**
	 * Long term debt
	 */
	AGV,
	/**
	 * Location
	 */
	AGW,
	/**
	 * Current legal structure
	 */
	AGX,
	/**
	 * Marital contract
	 */
	AGY,
	/**
	 * Marketing activities
	 */
	AGZ,
	/**
	 * Merger
	 */
	AHA,
	/**
	 * Marketable securities
	 */
	AHB,
	/**
	 * Business debt
	 */
	AHC,
	/**
	 * Original legal structure
	 */
	AHD,
	/**
	 * Employee sharing arrangements
	 */
	AHE,
	/**
	 * Organization details
	 */
	AHF,
	/**
	 * Public record details
	 */
	AHG,
	/**
	 * Price range
	 */
	AHH,
	/**
	 * Qualifications
	 */
	AHI,
	/**
	 * Registered activity
	 */
	AHJ,
	/**
	 * Criminal sentence
	 */
	AHK,
	/**
	 * Sales method
	 */
	AHL,
	/**
	 * Educational institution information
	 */
	AHM,
	/**
	 * Status details
	 */
	AHN,
	/**
	 * Sales
	 */
	AHO,
	/**
	 * Spouse information
	 */
	AHP,
	/**
	 * Educational degree information
	 */
	AHQ,
	/**
	 * Shareholding information
	 */
	AHR,
	/**
	 * Sales territory
	 */
	AHS,
	/**
	 * Accountant's comments
	 */
	AHT,
	/**
	 * Exemption law location
	 */
	AHU,
	/**
	 * Share classifications
	 */
	AHV,
	/**
	 * Forecast
	 */
	AHW,
	/**
	 * Event location
	 */
	AHX,
	/**
	 * Facility occupancy
	 */
	AHY,
	/**
	 * Import and export details
	 */
	AHZ,
	/**
	 * Additional facility information
	 */
	AIA,
	/**
	 * Inventory value
	 */
	AIB,
	/**
	 * Education
	 */
	AIC,
	/**
	 * Event
	 */
	AID,
	/**
	 * Agent
	 */
	AIE,
	/**
	 * Domestically agreed financial statement details
	 */
	AIF,
	/**
	 * Other current asset description
	 */
	AIG,
	/**
	 * Other current liability description
	 */
	AIH,
	/**
	 * Former business activity
	 */
	AII,
	/**
	 * Trade name use
	 */
	AIJ,
	/**
	 * Signing authority
	 */
	AIK,
	/**
	 * Guarantee
	 */
	AIL,
	/**
	 * Holding company operation
	 */
	AIM,
	/**
	 * Consignment routing
	 */
	AIN,
	/**
	 * Letter of protest
	 */
	AIO,
	/**
	 * Question
	 */
	AIP,
	/**
	 * Party information
	 */
	AIQ,
	/**
	 * Area boundaries description
	 */
	AIR,
	/**
	 * Advertisement information
	 */
	AIS,
	/**
	 * Financial statement details
	 */
	AIT,
	/**
	 * Access instructions
	 */
	AIU,
	/**
	 * Liquidity
	 */
	AIV,
	/**
	 * Credit line
	 */
	AIW,
	/**
	 * Warranty terms
	 */
	AIX,
	/**
	 * Division description
	 */
	AIY,
	/**
	 * Reporting instruction
	 */
	AIZ,
	/**
	 * Examination result
	 */
	AJA,
	/**
	 * Laboratory result
	 */
	AJB,
	/**
	 * Allowance/charge information
	 */
	ALC,
	/**
	 * X-ray result
	 */
	ALD,
	/**
	 * Pathology result
	 */
	ALE,
	/**
	 * Intervention description
	 */
	ALF,
	/**
	 * Summary of admittance
	 */
	ALG,
	/**
	 * Medical treatment course detail
	 */
	ALH,
	/**
	 * Prognosis
	 */
	ALI,
	/**
	 * Instruction to patient
	 */
	ALJ,
	/**
	 * Instruction to physician
	 */
	ALK,
	/**
	 * All documents
	 */
	ALL,
	/**
	 * Medicine treatment
	 */
	ALM,
	/**
	 * Medicine dosage and administration
	 */
	ALN,
	/**
	 * Availability of patient
	 */
	ALO,
	/**
	 * Reason for service request
	 */
	ALP,
	/**
	 * Purpose of service
	 */
	ALQ,
	/**
	 * Arrival conditions
	 */
	ARR,
	/**
	 * Service requester's comment
	 */
	ARS,
	/**
	 * Authentication
	 */
	AUT,
	/**
	 * Requested location description
	 */
	AUU,
	/**
	 * Medicine administration condition
	 */
	AUV,
	/**
	 * Patient information
	 */
	AUW,
	/**
	 * Precautionary measure
	 */
	AUX,
	/**
	 * Service characteristic
	 */
	AUY,
	/**
	 * Planned event comment
	 */
	AUZ,
	/**
	 * Expected delay comment
	 */
	AVA,
	/**
	 * Transport requirements comment
	 */
	AVB,
	/**
	 * Temporary approval condition
	 */
	AVC,
	/**
	 * Customs Valuation Information
	 */
	AVD,
	/**
	 * Value Added Tax (VAT) margin scheme
	 */
	AVE,
	/**
	 * Maritime Declaration of Health
	 */
	AVF,
	/**
	 * Passenger baggage information
	 */
	BAG,
	/**
	 * Maritime Declaration of Health
	 */
	BAH,
	/**
	 * Additional product information address
	 */
	BAI,
	/**
	 * Information to be printed on despatch advice
	 */
	BAJ,
	/**
	 * Missing goods remarks
	 */
	BAK,
	/**
	 * Non-acceptance information
	 */
	BAL,
	/**
	 * Returns information
	 */
	BAM,
	/**
	 * Sub-line item information
	 */
	BAN,
	/**
	 * Test information
	 */
	BAO,
	/**
	 * External link
	 */
	BAP,
	/**
	 * VAT exemption reason
	 */
	BAQ,
	/**
	 * Processing Instructions
	 */
	BAR,
	/**
	 * Relay Instructions
	 */
	BAS,
	/**
	 * SIMA applicable
	 */
	BAT,
	/**
	 * Appeals program code
	 */
	BAU,
	/**
	 * SIMA subject
	 */
	BAV,
	/**
	 * Surtax applicable
	 */
	BAW,
	/**
	 * SIMA security bond
	 */
	BAX,
	/**
	 * Surtax subject
	 */
	BAY,
	/**
	 * Safeguard applicable
	 */
	BAZ,
	/**
	 * Safeguard applicable
	 */
	BBA,
	/**
	 * Safeguard subject
	 */
	BBB,
	/**
	 * Transport contract document clause
	 */
	BLC,
	/**
	 * Instruction to prepare the patient
	 */
	BLD,
	/**
	 * Medicine treatment comment
	 */
	BLE,
	/**
	 * Examination result comment
	 */
	BLF,
	/**
	 * Service request comment
	 */
	BLG,
	/**
	 * Prescription reason
	 */
	BLH,
	/**
	 * Prescription comment
	 */
	BLI,
	/**
	 * Clinical investigation comment
	 */
	BLJ,
	/**
	 * Medicinal specification comment
	 */
	BLK,
	/**
	 * Economic contribution comment
	 */
	BLL,
	/**
	 * Status of a plan
	 */
	BLM,
	/**
	 * Random sample test information
	 */
	BLN,
	/**
	 * Period of time
	 */
	BLO,
	/**
	 * Legislation
	 */
	BLP,
	/**
	 * Security measures requested
	 */
	BLQ,
	/**
	 * Transport contract document remark
	 */
	BLR,
	/**
	 * Previous port of call security information
	 */
	BLS,
	/**
	 * Security information
	 */
	BLT,
	/**
	 * Waste information
	 */
	BLU,
	/**
	 * B2C marketing information, short description
	 */
	BLV,
	/**
	 * B2B marketing information, long description
	 */
	BLW,
	/**
	 * B2C marketing information, long description
	 */
	BLX,
	/**
	 * Product ingredients
	 */
	BLY,
	/**
	 * Location short name
	 */
	BLZ,
	/**
	 * Packaging material information
	 */
	BMA,
	/**
	 * Filler material information
	 */
	BMB,
	/**
	 * Ship-to-ship activity information
	 */
	BMC,
	/**
	 * Package material description
	 */
	BMD,
	/**
	 * Consumer level package marking
	 */
	BME,
	/**
	 * SIMA measure in force
	 */
	BMF,
	/**
	 * Pre-CARM
	 */
	BMG,
	/**
	 * SIMA measure type
	 */
	BMH,
	/**
	 * Customs clearance instructions
	 */
	CCI,
	/**
	 * Sub Type Code
	 */
	CCJ,
	/**
	 * SIMA information
	 */
	CCK,
	/**
	 * Time limit end
	 */
	CCL,
	/**
	 * Time limit start
	 */
	CCM,
	/**
	 * Warehouse time limit
	 */
	CCN,
	/**
	 * Value for duty information
	 */
	CCO,
	/**
	 * Customs clearance instructions export
	 */
	CEX,
	/**
	 * Change information
	 */
	CHG,
	/**
	 * Customs clearance instruction import
	 */
	CIP,
	/**
	 * Clearance place requested
	 */
	CLP,
	/**
	 * Loading remarks
	 */
	CLR,
	/**
	 * Order information
	 */
	COI,
	/**
	 * Customer remarks
	 */
	CUR,
	/**
	 * Customs information
	 */
	CUS,
	/**
	 * Damage remarks
	 */
	DAR,
	/**
	 * Document issuer declaration
	 */
	DCL,
	/**
	 * Delivery information
	 */
	DEL,
	/**
	 * Delivery instructions
	 */
	DIN,
	/**
	 * Documentation instructions
	 */
	DOC,
	/**
	 * Duty declaration
	 */
	DUT,
	/**
	 * Effective used routing
	 */
	EUR,
	/**
	 * First block to be printed on the transport contract
	 */
	FBC,
	/**
	 * Government bill of lading information
	 */
	GBL,
	/**
	 * Entire transaction set
	 */
	GEN,
	/**
	 * Further information concerning GGVS par. 7
	 */
	GS7,
	/**
	 * Consignment handling instruction
	 */
	HAN,
	/**
	 * Hazard information
	 */
	HAZ,
	/**
	 * Consignment information for consignee
	 */
	ICN,
	/**
	 * Insurance instructions
	 */
	IIN,
	/**
	 * Invoice mailing instructions
	 */
	IMI,
	/**
	 * Commercial invoice item description
	 */
	IND,
	/**
	 * Insurance information
	 */
	INS,
	/**
	 * Invoice instruction
	 */
	INV,
	/**
	 * Information for railway purpose
	 */
	IRP,
	/**
	 * Inland transport details
	 */
	ITR,
	/**
	 * Testing instructions
	 */
	ITS,
	/**
	 * Location Alias
	 */
	LAN,
	/**
	 * Line item
	 */
	LIN,
	/**
	 * Loading instruction
	 */
	LOI,
	/**
	 * Miscellaneous charge order
	 */
	MCO,
	/**
	 * Maritime Declaration of Health
	 */
	MDH,
	/**
	 * Additional marks/numbers information
	 */
	MKS,
	/**
	 * Order instruction
	 */
	ORI,
	/**
	 * Other service information
	 */
	OSI,
	/**
	 * Packing/marking information
	 */
	PAC,
	/**
	 * Payment instructions information
	 */
	PAI,
	/**
	 * Payables information
	 */
	PAY,
	/**
	 * Packaging information
	 */
	PKG,
	/**
	 * Packaging terms information
	 */
	PKT,
	/**
	 * Payment detail/remittance information
	 */
	PMD,
	/**
	 * Payment information
	 */
	PMT,
	/**
	 * Product information
	 */
	PRD,
	/**
	 * Price calculation formula
	 */
	PRF,
	/**
	 * Priority information
	 */
	PRI,
	/**
	 * Purchasing information
	 */
	PUR,
	/**
	 * Quarantine instructions
	 */
	QIN,
	/**
	 * Quality demands/requirements
	 */
	QQD,
	/**
	 * Quotation instruction/information
	 */
	QUT,
	/**
	 * Risk and handling information
	 */
	RAH,
	/**
	 * regulatory information
	 */
	REG,
	/**
	 * Return to origin information
	 */
	RET,
	/**
	 * Receivables
	 */
	REV,
	/**
	 * Consignment route
	 */
	RQR,
	/**
	 * Safety information
	 */
	SAF,
	/**
	 * Consignment documentary instruction
	 */
	SIC,
	/**
	 * Special instructions
	 */
	SIN,
	/**
	 * Ship line requested
	 */
	SLR,
	/**
	 * Special permission for transport, generally
	 */
	SPA,
	/**
	 * Special permission concerning the goods to be transported
	 */
	SPG,
	/**
	 * Special handling
	 */
	SPH,
	/**
	 * Special permission concerning package
	 */
	SPP,
	/**
	 * Special permission concerning transport means
	 */
	SPT,
	/**
	 * Subsidiary risk number (IATA/DGR)
	 */
	SRN,
	/**
	 * Special service request
	 */
	SSR,
	/**
	 * seller notes
	 */
	SUR,
	/**
	 * Consignment tariff
	 */
	TCA,
	/**
	 * Consignment transport
	 */
	TDT,
	/**
	 * Transportation information
	 */
	TRA,
	/**
	 * Requested tariff
	 */
	TRR,
	/**
	 * tax information
	 */
	TXD,
	/**
	 * Warehouse instruction/information
	 */
	WHI,
	/**
	 * Mutually defined
	 */
	ZZZ

}
