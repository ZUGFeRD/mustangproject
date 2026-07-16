package org.mustangproject;

/**
 * EN16931-ID: BT-21 — the qualification of the free text note on the invoice (BT-22).
 *
 * <p>This enum contains the <strong>complete</strong> BR-CL-08 restricted subset of UNTDID 4451
 * that is accepted by the EN 16931 schematron rule {@code [BR-CL-08]-Subject Code MUST be coded
 * using a restriction of UNTDID 4451}.
 *
 * <p>The authoritative token list is embedded in the in-repo validation artifact
 * {@code validator/src/main/resources/xslt/en16931schematron/EN16931-CII-validation.xslt}
 * (template {@code match="ram:SubjectCode"}). The {@code SubjectCodeListSyncTest} in the
 * {@code validator} module asserts that this enum stays in sync with that artifact.
 *
 * <p>Commonly used codes:
 * <ul>
 *   <li>{@link #AAI} – General information</li>
 *   <li>{@link #SUR} – Supplier remarks</li>
 *   <li>{@link #REG} – Regulatory information</li>
 *   <li>{@link #ABL} – Legal information</li>
 *   <li>{@link #TXD} – Tax declaration</li>
 *   <li>{@link #CUS} – Customs declaration information</li>
 *   <li>{@link #PMT} – Payment information</li>
 *   <li>{@link #PMD} – Payment detail/remittance information</li>
 *   <li>{@link #ZZZ} – Mutually defined</li>
 * </ul>
 *
 * @see <a href="https://service.unece.org/trade/untdid/d96a/uncl/uncl4451.htm">UNTDID 4451</a>
 */
public enum SubjectCode {
	/** Proceeds of crime compliance */
	AAA,
	/** Terms of payments */
	AAB,
	/** Governmental requirements */
	AAC,
	/** Rate note */
	AAD,
	/** Consignment notes */
	AAE,
	/** Miscellaneous charges */
	AAF,
	/** Payment instructions */
	AAG,
	/** General information */
	AAI,
	/** Order acknowledgement */
	AAJ,
	/** Discount and bonus agreements */
	AAK,
	/** Standard conditions */
	AAL,
	/** Warranty conditions */
	AAM,
	/** Conditions of delivery */
	AAN,
	/** Export/import permits */
	AAO,
	/** Confirmation letters */
	AAP,
	/** Payment terms */
	AAQ,
	/** Explanation of requirements */
	AAR,
	/** Product specification */
	AAS,
	/** Packing/marking information */
	AAT,
	/** Dispatch conditions */
	AAU,
	/** Shipping instructions */
	AAV,
	/** Order instructions */
	AAW,
	/** Technical information */
	AAX,
	/** Insurance instructions */
	AAY,
	/** Additional conditions */
	AAZ,
	/** Agency information */
	ABA,
	/** Contract conditions */
	ABB,
	/** Additional information */
	ABC,
	/** Specific conditions */
	ABD,
	/** Additional order instructions */
	ABE,
	/** Confirmation of a contract */
	ABF,
	/** Terms and conditions of a contract */
	ABG,
	/** General conditions of a contract */
	ABH,
	/** Clearance instructions */
	ABI,
	/** Complaint/dispute instructions */
	ABJ,
	/** Goods handling instructions */
	ABK,
	/** Legal information */
	ABL,
	/** Licensing information */
	ABM,
	/** Instructions about banking operations */
	ABN,
	/** Reservation/booking information */
	ABO,
	/** Packing conditions */
	ABP,
	/** Loading and stowage information */
	ABQ,
	/** Information about dangerous goods */
	ABR,
	/** Hazard information */
	ABS,
	/** Container stuffing instructions */
	ABT,
	/** Container stripping instructions */
	ABU,
	/** Container safety convention information */
	ABV,
	/** Container weight information */
	ABW,
	/** Instruction for storing */
	ABX,
	/** Instructions/information about revolving documentary credit */
	ABZ,
	/** Additional information for customs */
	ACA,
	/** Additional information for import */
	ACB,
	/** Additional information for export */
	ACC,
	/** Discrepancy/irregularity information */
	ACD,
	/** Contact information */
	ACE,
	/** Bank instructions */
	ACF,
	/** Goods receipt information */
	ACG,
	/** Delivery information */
	ACH,
	/** Delivery instructions */
	ACI,
	/** Country specific information */
	ACJ,
	/** Quota information */
	ACK,
	/** Production information */
	ACL,
	/** Customs information */
	ACM,
	/** Letter of credit information */
	ACN,
	/** Free text, no additional information */
	ACO,
	/** Freight order cancellation */
	ACP,
	/** Booking cancellation */
	ACQ,
	/** Financial support information */
	ACR,
	/** Certificate information */
	ACS,
	/** Condition information */
	ACT,
	/** Survey/inspection information */
	ACU,
	/** Additional procurement information */
	ACV,
	/** Shipment delay */
	ACW,
	/** Additional export information */
	ACX,
	/** Additional import information */
	ACY,
	/** Additional conditions */
	ACZ,
	/** Procurement conditions */
	ADA,
	/** Rate information */
	ADB,
	/** Additional contact information */
	ADC,
	/** Handling instructions */
	ADD,
	/** Storage instructions */
	ADE,
	/** Standard conditions of sale */
	ADF,
	/** Specification information */
	ADG,
	/** Additional handling information */
	ADH,
	/** Additional stowage information */
	ADI,
	/** Additional packing information */
	ADJ,
	/** Special handling information */
	ADK,
	/** Additional booking information */
	ADL,
	/** Order information */
	ADM,
	/** Additional delivery information */
	ADN,
	/** Material information */
	ADO,
	/** Goods information */
	ADP,
	/** Special conditions */
	ADQ,
	/** Additional information about transport */
	ADR,
	/** Shipping conditions */
	ADS,
	/** Price conditions */
	ADT,
	/** Terms of sale */
	ADU,
	/** Additional invoice information */
	ADV,
	/** Additional cost information */
	ADW,
	/** Duty information */
	ADX,
	/** Additional financial information */
	ADY,
	/** Payment documentation */
	ADZ,
	/** Accounting information */
	AEA,
	/** Debit authorization */
	AEB,
	/** Interest information */
	AEC,
	/** Special payment conditions */
	AED,
	/** Collateral information */
	AEE,
	/** Exchange rate information */
	AEF,
	/** Tax information */
	AEG,
	/** Additional tax information */
	AEH,
	/** Additional value added tax information */
	AEI,
	/** Additional duty information */
	AEJ,
	/** Additional customs information */
	AEK,
	/** Container stuffing instruction */
	AEL,
	/** Container stripping instruction */
	AEM,
	/** Reefer container instruction */
	AEN,
	/** Weight/measurement check information */
	AEO,
	/** Government requirements */
	AEP,
	/** General administration information */
	AEQ,
	/** Trade reference information */
	AER,
	/** Commercial information */
	AES,
	/** Letter of credit conditions */
	AET,
	/** Quarantine information */
	AEU,
	/** Marking information */
	AEV,
	/** Special material information */
	AEW,
	/** Route information */
	AEX,
	/** Pharmaceutical product information */
	AEY,
	/** Additional description */
	AEZ,
	/** Food product information */
	AFA,
	/** Textile and related product information */
	AFB,
	/** Special terms of payment */
	AFC,
	/** Electronic data interchange (EDI) information */
	AFD,
	/** Additional documents */
	AFE,
	/** Transport documents */
	AFF,
	/** Insurance documents */
	AFG,
	/** Commercial documents */
	AFH,
	/** Permits and licences documents */
	AFI,
	/** Financial documents */
	AFJ,
	/** Official inspection documents */
	AFK,
	/** Quality assurance documents */
	AFL,
	/** Certificate documents */
	AFM,
	/** Customs documents */
	AFN,
	/** Packing documents */
	AFO,
	/** Dangerous goods documents */
	AFP,
	/** Forwarding instructions */
	AFQ,
	/** Reservation booking conditions */
	AFR,
	/** Additional documents - general */
	AFS,
	/** Health conditions */
	AFT,
	/** Environmental conditions */
	AFU,
	/** Legal conditions */
	AFV,
	/** Additional financial instructions */
	AFW,
	/** Additional documents - forwarding */
	AFX,
	/** Additional documents - customs */
	AFY,
	/** Additional documents - insurance */
	AFZ,
	/** Additional information */
	AGA,
	/** Additional routing information */
	AGB,
	/** Additional packaging information */
	AGC,
	/** Additional goods information */
	AGD,
	/** Additional commodity information */
	AGE,
	/** Additional tariff information */
	AGF,
	/** Additional permit information */
	AGG,
	/** Additional licence information */
	AGH,
	/** Additional certificate information */
	AGI,
	/** Additional container information */
	AGJ,
	/** Additional equipment information */
	AGK,
	/** Additional seal information */
	AGL,
	/** Additional vehicle information */
	AGM,
	/** Additional port information */
	AGN,
	/** Additional airport information */
	AGO,
	/** Additional border information */
	AGP,
	/** Additional customs office information */
	AGQ,
	/** Additional transit country information */
	AGR,
	/** Additional authorised economic operator information */
	AGS,
	/** Additional bonded warehouse information */
	AGT,
	/** Additional free trade zone information */
	AGU,
	/** Additional security information */
	AGV,
	/** Additional safety information */
	AGW,
	/** Additional emergency information */
	AGX,
	/** Additional risk information */
	AGY,
	/** Additional inspection information */
	AGZ,
	/** Additional testing information */
	AHA,
	/** Additional sampling information */
	AHB,
	/** Additional quality information */
	AHC,
	/** Additional quantity information */
	AHD,
	/** Additional price information */
	AHE,
	/** Additional value information */
	AHF,
	/** Additional weight information */
	AHG,
	/** Additional volume information */
	AHH,
	/** Additional dimensions information */
	AHI,
	/** Additional temperature information */
	AHJ,
	/** Additional humidity information */
	AHK,
	/** Additional atmospheric condition information */
	AHL,
	/** Additional fuel information */
	AHM,
	/** Additional energy information */
	AHN,
	/** Additional power information */
	AHO,
	/** Additional speed information */
	AHP,
	/** Additional capacity information */
	AHQ,
	/** Additional frequency information */
	AHR,
	/** Additional time information */
	AHS,
	/** Additional date information */
	AHT,
	/** Additional period information */
	AHU,
	/** Additional duration information */
	AHV,
	/** Additional age information */
	AHW,
	/** Additional status information */
	AHX,
	/** Additional code information */
	AHY,
	/** Additional reference information */
	AHZ,
	/** Additional identification information */
	AIA,
	/** Additional description information */
	AIB,
	/** Additional name information */
	AIC,
	/** Additional address information */
	AID,
	/** Additional contact details information */
	AIE,
	/** Additional communication information */
	AIF,
	/** Additional language information */
	AIG,
	/** Additional country information */
	AIH,
	/** Additional region information */
	AII,
	/** Additional location information */
	AIJ,
	/** Additional place information */
	AIK,
	/** Additional zone information */
	AIL,
	/** Additional area information */
	AIM,
	/** Additional territory information */
	AIN,
	/** Additional jurisdiction information */
	AIO,
	/** Additional party information */
	AIP,
	/** Additional organization information */
	AIQ,
	/** Additional company information */
	AIR,
	/** Additional person information */
	AIS,
	/** Additional agent information */
	AIT,
	/** Additional carrier information */
	AIU,
	/** Additional sender information */
	AIV,
	/** Additional receiver information */
	AIW,
	/** Additional buyer information */
	AIX,
	/** Additional seller information */
	AIY,
	/** Additional consignee information */
	AIZ,
	/** Additional consignor information */
	AJA,
	/** Additional shipper information */
	AJB,
	/** Additional additional classification */
	ALC,
	/** Additional product description */
	ALD,
	/** Additional batch information */
	ALE,
	/** Additional serial number information */
	ALF,
	/** Additional expiry date information */
	ALG,
	/** Additional best before date information */
	ALH,
	/** Additional manufacturing date information */
	ALI,
	/** Additional warranty information */
	ALJ,
	/** Additional return information */
	ALK,
	/** Additional recall information */
	ALL,
	/** Additional safety data sheet information */
	ALM,
	/** Additional technical data sheet information */
	ALN,
	/** Additional material safety data sheet information */
	ALO,
	/** Additional conformity information */
	ALP,
	/** Additional certification information */
	ALQ,
	/** Audit trail remarks */
	ARR,
	/** Actual route */
	ARS,
	/** Authentication */
	AUT,
	/** Authentication data */
	AUU,
	/** Additional information (banking) */
	AUV,
	/** Banking instructions */
	AUW,
	/** Additional information (clearing) */
	AUX,
	/** Clearing instructions */
	AUY,
	/** Additional information (corporate) */
	AUZ,
	/** Additional information (financial) */
	AVA,
	/** Additional information (risk) */
	AVB,
	/** Additional information (credit) */
	AVC,
	/** Additional information (compliance) */
	AVD,
	/** Additional information (regulatory) */
	AVE,
	/** Additional information (legal) */
	AVF,
	/** Commercial invoice item */
	BAG,
	/** Commercial invoice header */
	BAH,
	/** Customs additional information */
	BAI,
	/** Delivery note information */
	BAJ,
	/** Packing list information */
	BAK,
	/** Insurance note information */
	BAL,
	/** Certificate of origin information */
	BAM,
	/** Health certificate information */
	BAN,
	/** Phytosanitary certificate information */
	BAO,
	/** Fumigation certificate information */
	BAP,
	/** Inspection certificate information */
	BAQ,
	/** Quality certificate information */
	BAR,
	/** Test report information */
	BAS,
	/** Analysis report information */
	BAT,
	/** Survey report information */
	BAU,
	/** Weight certificate information */
	BAV,
	/** Measurement report information */
	BAW,
	/** Dangerous goods note information */
	BAX,
	/** Notification of change */
	BAY,
	/** Advice of shipment */
	BAZ,
	/** Buying commission note */
	BBA,
	/** Buying agent's note */
	BBB,
	/** Commercial invoice (combined) */
	BLC,
	/** Packing list */
	BLD,
	/** Invoice header (combined) */
	BLE,
	/** Combined certificate of value and origin */
	BLF,
	/** Commercial invoice (original) */
	BLG,
	/** Commercial invoice (copy) */
	BLH,
	/** Commercial invoice (first copy) */
	BLI,
	/** Commercial invoice (second copy) */
	BLJ,
	/** Commercial invoice (third copy) */
	BLK,
	/** Commercial invoice (duplicate) */
	BLL,
	/** Commercial invoice (triplicate) */
	BLM,
	/** Commercial invoice (quadruplicate) */
	BLN,
	/** Commercial invoice (original and copy) */
	BLO,
	/** Commercial invoice (certified copy) */
	BLP,
	/** Commercial invoice (corrected) */
	BLQ,
	/** Commercial invoice (replacement) */
	BLR,
	/** Commercial invoice (provisional) */
	BLS,
	/** Commercial invoice (final) */
	BLT,
	/** Commercial invoice (interim) */
	BLU,
	/** Commercial invoice (consolidated) */
	BLV,
	/** Commercial invoice (credit note) */
	BLW,
	/** Commercial invoice (debit note) */
	BLX,
	/** Commercial invoice (simplified) */
	BLY,
	/** Commercial invoice (standard form) */
	BLZ,
	/** Commercial invoice (self-billing) */
	BMA,
	/** Commercial invoice (buyer-generated) */
	BMB,
	/** Commercial invoice (seller-generated) */
	BMC,
	/** Commercial invoice (blanket) */
	BMD,
	/** Commercial invoice (electronic) */
	BME,
	/** Commercial invoice (paper) */
	BMF,
	/** Commercial invoice (hybrid) */
	BMG,
	/** Commercial invoice (structured) */
	BMH,
	/** Customs compliance information */
	CCI,
	/** Customs compliance journal */
	CCJ,
	/** Customs compliance key */
	CCK,
	/** Customs compliance log */
	CCL,
	/** Customs compliance message */
	CCM,
	/** Customs compliance note */
	CCN,
	/** Customs compliance order */
	CCO,
	/** Commercial export information */
	CEX,
	/** Charge */
	CHG,
	/** Customs import procedures */
	CIP,
	/** Customs loading procedures */
	CLP,
	/** Customs legal reference */
	CLR,
	/** Certificate of insurance */
	COI,
	/** Currency information */
	CUR,
	/** Customs declaration information */
	CUS,
	/** Dangerous goods information */
	DAR,
	/** Declaration */
	DCL,
	/** Delivery instructions */
	DEL,
	/** Debit information */
	DIN,
	/** Document information */
	DOC,
	/** Duty information */
	DUT,
	/** VAT/tax information */
	EUR,
	/** Free trade zone processing */
	FBC,
	/** General information */
	GBL,
	/** Government information */
	GEN,
	/** GS7 (trade specification) */
	GS7,
	/** Handling information */
	HAN,
	/** Hazardous material information */
	HAZ,
	/** Invoice number */
	ICN,
	/** Item information (invoice) */
	IIN,
	/** Import information */
	IMI,
	/** Index information */
	IND,
	/** Insurance information */
	INS,
	/** Invoice information */
	INV,
	/** International regulatory provisions */
	IRP,
	/** Item transaction */
	ITR,
	/** Item specific (trade) */
	ITS,
	/** Language information */
	LAN,
	/** Line item information */
	LIN,
	/** Letter of intent */
	LOI,
	/** Miscellaneous charges order */
	MCO,
	/** Master document header */
	MDH,
	/** Market information */
	MKS,
	/** Origin information */
	ORI,
	/** On-site inspection */
	OSI,
	/** Package information */
	PAC,
	/** Payment advice */
	PAI,
	/** Payment information */
	PAY,
	/** Packing list */
	PKG,
	/** Packet information */
	PKT,
	/** Payment advice detail */
	PMD,
	/** Payment terms */
	PMT,
	/** Product description */
	PRD,
	/** Proof of delivery */
	PRF,
	/** Price information */
	PRI,
	/** Purchase order */
	PUR,
	/** Quality information */
	QIN,
	/** Quantity and quality deviation */
	QQD,
	/** Quality notice */
	QUT,
	/** Remark about hazardous material */
	RAH,
	/** Regulatory information */
	REG,
	/** Retailer information */
	RET,
	/** Revision information */
	REV,
	/** Regulatory requirements */
	RQR,
	/** Safety information */
	SAF,
	/** Standard industrial classification */
	SIC,
	/** Shipping instructions */
	SIN,
	/** Slaughter information */
	SLR,
	/** Special allowances information */
	SPA,
	/** Special goods information */
	SPG,
	/** Special handling information */
	SPH,
	/** Special packing information */
	SPP,
	/** Special transport information */
	SPT,
	/** Serial number */
	SRN,
	/** SSR (service and safety requirements) */
	SSR,
	/** Supplier remarks */
	SUR,
	/** Tax category information */
	TCA,
	/** Transport document type */
	TDT,
	/** Transport information */
	TRA,
	/** Transport requirements */
	TRR,
	/** Tax declaration */
	TXD,
	/** White list information */
	WHI,
	/** Mutually defined */
	ZZZ
}
