<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.4451">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='AAA'"><xsl:value-of select="$myparam"/> (Goods item description)</xsl:when>
      		<xsl:when test="$myparam.upper='AAB'"><xsl:value-of select="$myparam"/> (Payment term)</xsl:when>
      		<xsl:when test="$myparam.upper='AAC'"><xsl:value-of select="$myparam"/> (Dangerous goods additional information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAD'"><xsl:value-of select="$myparam"/> (Dangerous goods technical name)</xsl:when>
      		<xsl:when test="$myparam.upper='AAE'"><xsl:value-of select="$myparam"/> (Acknowledgement description)</xsl:when>
      		<xsl:when test="$myparam.upper='AAF'"><xsl:value-of select="$myparam"/> (Rate additional information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAG'"><xsl:value-of select="$myparam"/> (Party instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AAI'"><xsl:value-of select="$myparam"/> (General information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAJ'"><xsl:value-of select="$myparam"/> (Additional conditions of sale/purchase)</xsl:when>
      		<xsl:when test="$myparam.upper='AAK'"><xsl:value-of select="$myparam"/> (Price conditions)</xsl:when>
      		<xsl:when test="$myparam.upper='AAL'"><xsl:value-of select="$myparam"/> (Goods dimensions in characters)</xsl:when>
      		<xsl:when test="$myparam.upper='AAM'"><xsl:value-of select="$myparam"/> (Equipment re-usage restrictions)</xsl:when>
      		<xsl:when test="$myparam.upper='AAN'"><xsl:value-of select="$myparam"/> (Handling restriction)</xsl:when>
      		<xsl:when test="$myparam.upper='AAO'"><xsl:value-of select="$myparam"/> (Error description (free text))</xsl:when>
      		<xsl:when test="$myparam.upper='AAP'"><xsl:value-of select="$myparam"/> (Response (free text))</xsl:when>
      		<xsl:when test="$myparam.upper='AAQ'"><xsl:value-of select="$myparam"/> (Package content's description)</xsl:when>
      		<xsl:when test="$myparam.upper='AAR'"><xsl:value-of select="$myparam"/> (Terms of delivery)</xsl:when>
      		<xsl:when test="$myparam.upper='AAS'"><xsl:value-of select="$myparam"/> (Bill of lading remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='AAT'"><xsl:value-of select="$myparam"/> (Mode of settlement information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAU'"><xsl:value-of select="$myparam"/> (Consignment invoice information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAV'"><xsl:value-of select="$myparam"/> (Clearance invoice information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAW'"><xsl:value-of select="$myparam"/> (Letter of credit information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAX'"><xsl:value-of select="$myparam"/> (License information)</xsl:when>
      		<xsl:when test="$myparam.upper='AAY'"><xsl:value-of select="$myparam"/> (Certification statements)</xsl:when>
      		<xsl:when test="$myparam.upper='AAZ'"><xsl:value-of select="$myparam"/> (Additional export information)</xsl:when>
      		<xsl:when test="$myparam.upper='ABA'"><xsl:value-of select="$myparam"/> (Tariff statements)</xsl:when>
      		<xsl:when test="$myparam.upper='ABB'"><xsl:value-of select="$myparam"/> (Medical history)</xsl:when>
      		<xsl:when test="$myparam.upper='ABC'"><xsl:value-of select="$myparam"/> (Conditions of sale or purchase)</xsl:when>
      		<xsl:when test="$myparam.upper='ABD'"><xsl:value-of select="$myparam"/> (Contract document type)</xsl:when>
      		<xsl:when test="$myparam.upper='ABE'"><xsl:value-of select="$myparam"/> (Additional terms and/or conditions (documentary credit))</xsl:when>
      		<xsl:when test="$myparam.upper='ABF'"><xsl:value-of select="$myparam"/> (Instructions or information about standby documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='ABG'"><xsl:value-of select="$myparam"/> (Instructions or information about partial shipment(s))</xsl:when>
      		<xsl:when test="$myparam.upper='ABH'"><xsl:value-of select="$myparam"/> (Instructions or information about transhipment(s))</xsl:when>
      		<xsl:when test="$myparam.upper='ABI'"><xsl:value-of select="$myparam"/> (Additional handling instructions documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='ABJ'"><xsl:value-of select="$myparam"/> (Domestic routing information)</xsl:when>
      		<xsl:when test="$myparam.upper='ABK'"><xsl:value-of select="$myparam"/> (Chargeable category of equipment)</xsl:when>
      		<xsl:when test="$myparam.upper='ABL'"><xsl:value-of select="$myparam"/> (Government information)</xsl:when>
      		<xsl:when test="$myparam.upper='ABM'"><xsl:value-of select="$myparam"/> (Onward routing information)</xsl:when>
      		<xsl:when test="$myparam.upper='ABN'"><xsl:value-of select="$myparam"/> (Accounting information)</xsl:when>
      		<xsl:when test="$myparam.upper='ABO'"><xsl:value-of select="$myparam"/> (Discrepancy information)</xsl:when>
      		<xsl:when test="$myparam.upper='ABP'"><xsl:value-of select="$myparam"/> (Confirmation instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='ABQ'"><xsl:value-of select="$myparam"/> (Method of issuance)</xsl:when>
      		<xsl:when test="$myparam.upper='ABR'"><xsl:value-of select="$myparam"/> (Documents delivery instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='ABS'"><xsl:value-of select="$myparam"/> (Additional conditions)</xsl:when>
      		<xsl:when test="$myparam.upper='ABT'"><xsl:value-of select="$myparam"/> (Information/instructions about additional amounts covered)</xsl:when>
      		<xsl:when test="$myparam.upper='ABU'"><xsl:value-of select="$myparam"/> (Deferred payment termed additional)</xsl:when>
      		<xsl:when test="$myparam.upper='ABV'"><xsl:value-of select="$myparam"/> (Acceptance terms additional)</xsl:when>
      		<xsl:when test="$myparam.upper='ABW'"><xsl:value-of select="$myparam"/> (Negotiation terms additional)</xsl:when>
      		<xsl:when test="$myparam.upper='ABX'"><xsl:value-of select="$myparam"/> (Document name and documentary requirements)</xsl:when>
      		<xsl:when test="$myparam.upper='ABZ'"><xsl:value-of select="$myparam"/> (Instructions/information about revolving documentary credit)</xsl:when>
      		<xsl:when test="$myparam.upper='ACA'"><xsl:value-of select="$myparam"/> (Documentary requirements)</xsl:when>
      		<xsl:when test="$myparam.upper='ACB'"><xsl:value-of select="$myparam"/> (Additional information)</xsl:when>
      		<xsl:when test="$myparam.upper='ACC'"><xsl:value-of select="$myparam"/> (Factor assignment clause)</xsl:when>
      		<xsl:when test="$myparam.upper='ACD'"><xsl:value-of select="$myparam"/> (Reason)</xsl:when>
      		<xsl:when test="$myparam.upper='ACE'"><xsl:value-of select="$myparam"/> (Dispute)</xsl:when>
      		<xsl:when test="$myparam.upper='ACF'"><xsl:value-of select="$myparam"/> (Additional attribute information)</xsl:when>
      		<xsl:when test="$myparam.upper='ACG'"><xsl:value-of select="$myparam"/> (Absence declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='ACH'"><xsl:value-of select="$myparam"/> (Aggregation statement)</xsl:when>
      		<xsl:when test="$myparam.upper='ACI'"><xsl:value-of select="$myparam"/> (Compilation statement)</xsl:when>
      		<xsl:when test="$myparam.upper='ACJ'"><xsl:value-of select="$myparam"/> (Definitional exception)</xsl:when>
      		<xsl:when test="$myparam.upper='ACK'"><xsl:value-of select="$myparam"/> (Privacy statement)</xsl:when>
      		<xsl:when test="$myparam.upper='ACL'"><xsl:value-of select="$myparam"/> (Quality statement)</xsl:when>
      		<xsl:when test="$myparam.upper='ACM'"><xsl:value-of select="$myparam"/> (Statistical description)</xsl:when>
      		<xsl:when test="$myparam.upper='ACN'"><xsl:value-of select="$myparam"/> (Statistical definition)</xsl:when>
      		<xsl:when test="$myparam.upper='ACO'"><xsl:value-of select="$myparam"/> (Statistical name)</xsl:when>
      		<xsl:when test="$myparam.upper='ACP'"><xsl:value-of select="$myparam"/> (Statistical title)</xsl:when>
      		<xsl:when test="$myparam.upper='ACQ'"><xsl:value-of select="$myparam"/> (Off-dimension information)</xsl:when>
      		<xsl:when test="$myparam.upper='ACR'"><xsl:value-of select="$myparam"/> (Unexpected stops information)</xsl:when>
      		<xsl:when test="$myparam.upper='ACS'"><xsl:value-of select="$myparam"/> (Principles)</xsl:when>
      		<xsl:when test="$myparam.upper='ACT'"><xsl:value-of select="$myparam"/> (Terms and definition)</xsl:when>
      		<xsl:when test="$myparam.upper='ACU'"><xsl:value-of select="$myparam"/> (Segment name)</xsl:when>
      		<xsl:when test="$myparam.upper='ACV'"><xsl:value-of select="$myparam"/> (Simple data element name)</xsl:when>
      		<xsl:when test="$myparam.upper='ACW'"><xsl:value-of select="$myparam"/> (Scope)</xsl:when>
      		<xsl:when test="$myparam.upper='ACX'"><xsl:value-of select="$myparam"/> (Message type name)</xsl:when>
      		<xsl:when test="$myparam.upper='ACY'"><xsl:value-of select="$myparam"/> (Introduction)</xsl:when>
      		<xsl:when test="$myparam.upper='ACZ'"><xsl:value-of select="$myparam"/> (Glossary)</xsl:when>
      		<xsl:when test="$myparam.upper='ADA'"><xsl:value-of select="$myparam"/> (Functional definition)</xsl:when>
      		<xsl:when test="$myparam.upper='ADB'"><xsl:value-of select="$myparam"/> (Examples)</xsl:when>
      		<xsl:when test="$myparam.upper='ADC'"><xsl:value-of select="$myparam"/> (Cover page)</xsl:when>
      		<xsl:when test="$myparam.upper='ADD'"><xsl:value-of select="$myparam"/> (Dependency (syntax) notes)</xsl:when>
      		<xsl:when test="$myparam.upper='ADE'"><xsl:value-of select="$myparam"/> (Code value name)</xsl:when>
      		<xsl:when test="$myparam.upper='ADF'"><xsl:value-of select="$myparam"/> (Code list name)</xsl:when>
      		<xsl:when test="$myparam.upper='ADG'"><xsl:value-of select="$myparam"/> (Clarification of usage)</xsl:when>
      		<xsl:when test="$myparam.upper='ADH'"><xsl:value-of select="$myparam"/> (Composite data element name)</xsl:when>
      		<xsl:when test="$myparam.upper='ADI'"><xsl:value-of select="$myparam"/> (Field of application)</xsl:when>
      		<xsl:when test="$myparam.upper='ADJ'"><xsl:value-of select="$myparam"/> (Type of assets and liabilities)</xsl:when>
      		<xsl:when test="$myparam.upper='ADK'"><xsl:value-of select="$myparam"/> (Promotion information)</xsl:when>
      		<xsl:when test="$myparam.upper='ADL'"><xsl:value-of select="$myparam"/> (Meter condition)</xsl:when>
      		<xsl:when test="$myparam.upper='ADM'"><xsl:value-of select="$myparam"/> (Meter reading information)</xsl:when>
      		<xsl:when test="$myparam.upper='ADN'"><xsl:value-of select="$myparam"/> (Type of transaction reason)</xsl:when>
      		<xsl:when test="$myparam.upper='ADO'"><xsl:value-of select="$myparam"/> (Type of survey question)</xsl:when>
      		<xsl:when test="$myparam.upper='ADP'"><xsl:value-of select="$myparam"/> (Carrier's agent counter information)</xsl:when>
      		<xsl:when test="$myparam.upper='ADQ'"><xsl:value-of select="$myparam"/> (Description of work item on equipment)</xsl:when>
      		<xsl:when test="$myparam.upper='ADR'"><xsl:value-of select="$myparam"/> (Message definition)</xsl:when>
      		<xsl:when test="$myparam.upper='ADS'"><xsl:value-of select="$myparam"/> (Booked item information)</xsl:when>
      		<xsl:when test="$myparam.upper='ADT'"><xsl:value-of select="$myparam"/> (Source of document)</xsl:when>
      		<xsl:when test="$myparam.upper='ADU'"><xsl:value-of select="$myparam"/> (Note)</xsl:when>
      		<xsl:when test="$myparam.upper='ADV'"><xsl:value-of select="$myparam"/> (Fixed part of segment clarification text)</xsl:when>
      		<xsl:when test="$myparam.upper='ADW'"><xsl:value-of select="$myparam"/> (Characteristics of goods)</xsl:when>
      		<xsl:when test="$myparam.upper='ADX'"><xsl:value-of select="$myparam"/> (Additional discharge instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='ADY'"><xsl:value-of select="$myparam"/> (Container stripping instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='ADZ'"><xsl:value-of select="$myparam"/> (CSC (Container Safety Convention) plate information)</xsl:when>
      		<xsl:when test="$myparam.upper='AEA'"><xsl:value-of select="$myparam"/> (Cargo remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='AEB'"><xsl:value-of select="$myparam"/> (Temperature control instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AEC'"><xsl:value-of select="$myparam"/> (Text refers to expected data)</xsl:when>
      		<xsl:when test="$myparam.upper='AED'"><xsl:value-of select="$myparam"/> (Text refers to received data)</xsl:when>
      		<xsl:when test="$myparam.upper='AEE'"><xsl:value-of select="$myparam"/> (Section clarification text)</xsl:when>
      		<xsl:when test="$myparam.upper='AEF'"><xsl:value-of select="$myparam"/> (Information to the beneficiary)</xsl:when>
      		<xsl:when test="$myparam.upper='AEG'"><xsl:value-of select="$myparam"/> (Information to the applicant)</xsl:when>
      		<xsl:when test="$myparam.upper='AEH'"><xsl:value-of select="$myparam"/> (Instructions to the beneficiary)</xsl:when>
      		<xsl:when test="$myparam.upper='AEI'"><xsl:value-of select="$myparam"/> (Instructions to the applicant)</xsl:when>
      		<xsl:when test="$myparam.upper='AEJ'"><xsl:value-of select="$myparam"/> (Controlled atmosphere)</xsl:when>
      		<xsl:when test="$myparam.upper='AEK'"><xsl:value-of select="$myparam"/> (Take off annotation)</xsl:when>
      		<xsl:when test="$myparam.upper='AEL'"><xsl:value-of select="$myparam"/> (Price variation narrative)</xsl:when>
      		<xsl:when test="$myparam.upper='AEM'"><xsl:value-of select="$myparam"/> (Documentary credit amendment instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AEN'"><xsl:value-of select="$myparam"/> (Standard method narrative)</xsl:when>
      		<xsl:when test="$myparam.upper='AEO'"><xsl:value-of select="$myparam"/> (Project narrative)</xsl:when>
      		<xsl:when test="$myparam.upper='AEP'"><xsl:value-of select="$myparam"/> (Radioactive goods, additional information)</xsl:when>
      		<xsl:when test="$myparam.upper='AEQ'"><xsl:value-of select="$myparam"/> (Bank-to-bank information)</xsl:when>
      		<xsl:when test="$myparam.upper='AER'"><xsl:value-of select="$myparam"/> (Reimbursement instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AES'"><xsl:value-of select="$myparam"/> (Reason for amending a message)</xsl:when>
      		<xsl:when test="$myparam.upper='AET'"><xsl:value-of select="$myparam"/> (Instructions to the paying and/or accepting and/or negotiating bank)</xsl:when>
      		<xsl:when test="$myparam.upper='AEU'"><xsl:value-of select="$myparam"/> (Interest instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AEV'"><xsl:value-of select="$myparam"/> (Agent commission)</xsl:when>
      		<xsl:when test="$myparam.upper='AEW'"><xsl:value-of select="$myparam"/> (Remitting bank instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AEX'"><xsl:value-of select="$myparam"/> (Instructions to the collecting bank)</xsl:when>
      		<xsl:when test="$myparam.upper='AEY'"><xsl:value-of select="$myparam"/> (Collection amount instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AEZ'"><xsl:value-of select="$myparam"/> (Internal auditing information)</xsl:when>
      		<xsl:when test="$myparam.upper='AFA'"><xsl:value-of select="$myparam"/> (Constraint)</xsl:when>
      		<xsl:when test="$myparam.upper='AFB'"><xsl:value-of select="$myparam"/> (Comment)</xsl:when>
      		<xsl:when test="$myparam.upper='AFC'"><xsl:value-of select="$myparam"/> (Semantic note)</xsl:when>
      		<xsl:when test="$myparam.upper='AFD'"><xsl:value-of select="$myparam"/> (Help text)</xsl:when>
      		<xsl:when test="$myparam.upper='AFE'"><xsl:value-of select="$myparam"/> (Legend)</xsl:when>
      		<xsl:when test="$myparam.upper='AFF'"><xsl:value-of select="$myparam"/> (Batch code structure)</xsl:when>
      		<xsl:when test="$myparam.upper='AFG'"><xsl:value-of select="$myparam"/> (Product application)</xsl:when>
      		<xsl:when test="$myparam.upper='AFH'"><xsl:value-of select="$myparam"/> (Customer complaint)</xsl:when>
      		<xsl:when test="$myparam.upper='AFI'"><xsl:value-of select="$myparam"/> (Probable cause of fault)</xsl:when>
      		<xsl:when test="$myparam.upper='AFJ'"><xsl:value-of select="$myparam"/> (Defect description)</xsl:when>
      		<xsl:when test="$myparam.upper='AFK'"><xsl:value-of select="$myparam"/> (Repair description)</xsl:when>
      		<xsl:when test="$myparam.upper='AFL'"><xsl:value-of select="$myparam"/> (Review comments)</xsl:when>
      		<xsl:when test="$myparam.upper='AFM'"><xsl:value-of select="$myparam"/> (Title)</xsl:when>
      		<xsl:when test="$myparam.upper='AFN'"><xsl:value-of select="$myparam"/> (Description of amount)</xsl:when>
      		<xsl:when test="$myparam.upper='AFO'"><xsl:value-of select="$myparam"/> (Responsibilities)</xsl:when>
      		<xsl:when test="$myparam.upper='AFP'"><xsl:value-of select="$myparam"/> (Supplier)</xsl:when>
      		<xsl:when test="$myparam.upper='AFQ'"><xsl:value-of select="$myparam"/> (Purchase region)</xsl:when>
      		<xsl:when test="$myparam.upper='AFR'"><xsl:value-of select="$myparam"/> (Affiliation)</xsl:when>
      		<xsl:when test="$myparam.upper='AFS'"><xsl:value-of select="$myparam"/> (Borrower)</xsl:when>
      		<xsl:when test="$myparam.upper='AFT'"><xsl:value-of select="$myparam"/> (Line of business)</xsl:when>
      		<xsl:when test="$myparam.upper='AFU'"><xsl:value-of select="$myparam"/> (Financial institution)</xsl:when>
      		<xsl:when test="$myparam.upper='AFV'"><xsl:value-of select="$myparam"/> (Business founder)</xsl:when>
      		<xsl:when test="$myparam.upper='AFW'"><xsl:value-of select="$myparam"/> (Business history)</xsl:when>
      		<xsl:when test="$myparam.upper='AFX'"><xsl:value-of select="$myparam"/> (Banking arrangements)</xsl:when>
      		<xsl:when test="$myparam.upper='AFY'"><xsl:value-of select="$myparam"/> (Business origin)</xsl:when>
      		<xsl:when test="$myparam.upper='AFZ'"><xsl:value-of select="$myparam"/> (Brand names' description)</xsl:when>
      		<xsl:when test="$myparam.upper='AGA'"><xsl:value-of select="$myparam"/> (Business financing details)</xsl:when>
      		<xsl:when test="$myparam.upper='AGB'"><xsl:value-of select="$myparam"/> (Competition)</xsl:when>
      		<xsl:when test="$myparam.upper='AGC'"><xsl:value-of select="$myparam"/> (Construction process details)</xsl:when>
      		<xsl:when test="$myparam.upper='AGD'"><xsl:value-of select="$myparam"/> (Construction specialty)</xsl:when>
      		<xsl:when test="$myparam.upper='AGE'"><xsl:value-of select="$myparam"/> (Contract information)</xsl:when>
      		<xsl:when test="$myparam.upper='AGF'"><xsl:value-of select="$myparam"/> (Corporate filing)</xsl:when>
      		<xsl:when test="$myparam.upper='AGG'"><xsl:value-of select="$myparam"/> (Customer information)</xsl:when>
      		<xsl:when test="$myparam.upper='AGH'"><xsl:value-of select="$myparam"/> (Copyright notice)</xsl:when>
      		<xsl:when test="$myparam.upper='AGI'"><xsl:value-of select="$myparam"/> (Contingent debt)</xsl:when>
      		<xsl:when test="$myparam.upper='AGJ'"><xsl:value-of select="$myparam"/> (Conviction details)</xsl:when>
      		<xsl:when test="$myparam.upper='AGK'"><xsl:value-of select="$myparam"/> (Equipment)</xsl:when>
      		<xsl:when test="$myparam.upper='AGL'"><xsl:value-of select="$myparam"/> (Workforce description)</xsl:when>
      		<xsl:when test="$myparam.upper='AGM'"><xsl:value-of select="$myparam"/> (Exemption)</xsl:when>
      		<xsl:when test="$myparam.upper='AGN'"><xsl:value-of select="$myparam"/> (Future plans)</xsl:when>
      		<xsl:when test="$myparam.upper='AGO'"><xsl:value-of select="$myparam"/> (Interviewee conversation information)</xsl:when>
      		<xsl:when test="$myparam.upper='AGP'"><xsl:value-of select="$myparam"/> (Intangible asset)</xsl:when>
      		<xsl:when test="$myparam.upper='AGQ'"><xsl:value-of select="$myparam"/> (Inventory)</xsl:when>
      		<xsl:when test="$myparam.upper='AGR'"><xsl:value-of select="$myparam"/> (Investment)</xsl:when>
      		<xsl:when test="$myparam.upper='AGS'"><xsl:value-of select="$myparam"/> (Intercompany relations information)</xsl:when>
      		<xsl:when test="$myparam.upper='AGT'"><xsl:value-of select="$myparam"/> (Joint venture)</xsl:when>
      		<xsl:when test="$myparam.upper='AGU'"><xsl:value-of select="$myparam"/> (Loan)</xsl:when>
      		<xsl:when test="$myparam.upper='AGV'"><xsl:value-of select="$myparam"/> (Long term debt)</xsl:when>
      		<xsl:when test="$myparam.upper='AGW'"><xsl:value-of select="$myparam"/> (Location)</xsl:when>
      		<xsl:when test="$myparam.upper='AGX'"><xsl:value-of select="$myparam"/> (Current legal structure)</xsl:when>
      		<xsl:when test="$myparam.upper='AGY'"><xsl:value-of select="$myparam"/> (Marital contract)</xsl:when>
      		<xsl:when test="$myparam.upper='AGZ'"><xsl:value-of select="$myparam"/> (Marketing activities)</xsl:when>
      		<xsl:when test="$myparam.upper='AHA'"><xsl:value-of select="$myparam"/> (Merger)</xsl:when>
      		<xsl:when test="$myparam.upper='AHB'"><xsl:value-of select="$myparam"/> (Marketable securities)</xsl:when>
      		<xsl:when test="$myparam.upper='AHC'"><xsl:value-of select="$myparam"/> (Business debt)</xsl:when>
      		<xsl:when test="$myparam.upper='AHD'"><xsl:value-of select="$myparam"/> (Original legal structure)</xsl:when>
      		<xsl:when test="$myparam.upper='AHE'"><xsl:value-of select="$myparam"/> (Employee sharing arrangements)</xsl:when>
      		<xsl:when test="$myparam.upper='AHF'"><xsl:value-of select="$myparam"/> (Organization details)</xsl:when>
      		<xsl:when test="$myparam.upper='AHG'"><xsl:value-of select="$myparam"/> (Public record details)</xsl:when>
      		<xsl:when test="$myparam.upper='AHH'"><xsl:value-of select="$myparam"/> (Price range)</xsl:when>
      		<xsl:when test="$myparam.upper='AHI'"><xsl:value-of select="$myparam"/> (Qualifications)</xsl:when>
      		<xsl:when test="$myparam.upper='AHJ'"><xsl:value-of select="$myparam"/> (Registered activity)</xsl:when>
      		<xsl:when test="$myparam.upper='AHK'"><xsl:value-of select="$myparam"/> (Criminal sentence)</xsl:when>
      		<xsl:when test="$myparam.upper='AHL'"><xsl:value-of select="$myparam"/> (Sales method)</xsl:when>
      		<xsl:when test="$myparam.upper='AHM'"><xsl:value-of select="$myparam"/> (Educational institution information)</xsl:when>
      		<xsl:when test="$myparam.upper='AHN'"><xsl:value-of select="$myparam"/> (Status details)</xsl:when>
      		<xsl:when test="$myparam.upper='AHO'"><xsl:value-of select="$myparam"/> (Sales)</xsl:when>
      		<xsl:when test="$myparam.upper='AHP'"><xsl:value-of select="$myparam"/> (Spouse information)</xsl:when>
      		<xsl:when test="$myparam.upper='AHQ'"><xsl:value-of select="$myparam"/> (Educational degree information)</xsl:when>
      		<xsl:when test="$myparam.upper='AHR'"><xsl:value-of select="$myparam"/> (Shareholding information)</xsl:when>
      		<xsl:when test="$myparam.upper='AHS'"><xsl:value-of select="$myparam"/> (Sales territory)</xsl:when>
      		<xsl:when test="$myparam.upper='AHT'"><xsl:value-of select="$myparam"/> (Accountant's comments)</xsl:when>
      		<xsl:when test="$myparam.upper='AHU'"><xsl:value-of select="$myparam"/> (Exemption law location)</xsl:when>
      		<xsl:when test="$myparam.upper='AHV'"><xsl:value-of select="$myparam"/> (Share classifications)</xsl:when>
      		<xsl:when test="$myparam.upper='AHW'"><xsl:value-of select="$myparam"/> (Forecast)</xsl:when>
      		<xsl:when test="$myparam.upper='AHX'"><xsl:value-of select="$myparam"/> (Event location)</xsl:when>
      		<xsl:when test="$myparam.upper='AHY'"><xsl:value-of select="$myparam"/> (Facility occupancy)</xsl:when>
      		<xsl:when test="$myparam.upper='AHZ'"><xsl:value-of select="$myparam"/> (Import and export details)</xsl:when>
      		<xsl:when test="$myparam.upper='AIA'"><xsl:value-of select="$myparam"/> (Additional facility information)</xsl:when>
      		<xsl:when test="$myparam.upper='AIB'"><xsl:value-of select="$myparam"/> (Inventory value)</xsl:when>
      		<xsl:when test="$myparam.upper='AIC'"><xsl:value-of select="$myparam"/> (Education)</xsl:when>
      		<xsl:when test="$myparam.upper='AID'"><xsl:value-of select="$myparam"/> (Event)</xsl:when>
      		<xsl:when test="$myparam.upper='AIE'"><xsl:value-of select="$myparam"/> (Agent)</xsl:when>
      		<xsl:when test="$myparam.upper='AIF'"><xsl:value-of select="$myparam"/> (Domestically agreed financial statement details)</xsl:when>
      		<xsl:when test="$myparam.upper='AIG'"><xsl:value-of select="$myparam"/> (Other current asset description)</xsl:when>
      		<xsl:when test="$myparam.upper='AIH'"><xsl:value-of select="$myparam"/> (Other current liability description)</xsl:when>
      		<xsl:when test="$myparam.upper='AII'"><xsl:value-of select="$myparam"/> (Former business activity)</xsl:when>
      		<xsl:when test="$myparam.upper='AIJ'"><xsl:value-of select="$myparam"/> (Trade name use)</xsl:when>
      		<xsl:when test="$myparam.upper='AIK'"><xsl:value-of select="$myparam"/> (Signing authority)</xsl:when>
      		<xsl:when test="$myparam.upper='AIL'"><xsl:value-of select="$myparam"/> (Guarantee)</xsl:when>
      		<xsl:when test="$myparam.upper='AIM'"><xsl:value-of select="$myparam"/> (Holding company operation)</xsl:when>
      		<xsl:when test="$myparam.upper='AIN'"><xsl:value-of select="$myparam"/> (Consignment routing)</xsl:when>
      		<xsl:when test="$myparam.upper='AIO'"><xsl:value-of select="$myparam"/> (Letter of protest)</xsl:when>
      		<xsl:when test="$myparam.upper='AIP'"><xsl:value-of select="$myparam"/> (Question)</xsl:when>
      		<xsl:when test="$myparam.upper='AIQ'"><xsl:value-of select="$myparam"/> (Party information)</xsl:when>
      		<xsl:when test="$myparam.upper='AIR'"><xsl:value-of select="$myparam"/> (Area boundaries description)</xsl:when>
      		<xsl:when test="$myparam.upper='AIS'"><xsl:value-of select="$myparam"/> (Advertisement information)</xsl:when>
      		<xsl:when test="$myparam.upper='AIT'"><xsl:value-of select="$myparam"/> (Financial statement details)</xsl:when>
      		<xsl:when test="$myparam.upper='AIU'"><xsl:value-of select="$myparam"/> (Access instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='AIV'"><xsl:value-of select="$myparam"/> (Liquidity)</xsl:when>
      		<xsl:when test="$myparam.upper='AIW'"><xsl:value-of select="$myparam"/> (Credit line)</xsl:when>
      		<xsl:when test="$myparam.upper='AIX'"><xsl:value-of select="$myparam"/> (Warranty terms)</xsl:when>
      		<xsl:when test="$myparam.upper='AIY'"><xsl:value-of select="$myparam"/> (Division description)</xsl:when>
      		<xsl:when test="$myparam.upper='AIZ'"><xsl:value-of select="$myparam"/> (Reporting instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='AJA'"><xsl:value-of select="$myparam"/> (Examination result)</xsl:when>
      		<xsl:when test="$myparam.upper='AJB'"><xsl:value-of select="$myparam"/> (Laboratory result)</xsl:when>
      		<xsl:when test="$myparam.upper='ALC'"><xsl:value-of select="$myparam"/> (Allowance/charge information)</xsl:when>
      		<xsl:when test="$myparam.upper='ALD'"><xsl:value-of select="$myparam"/> (X-ray result)</xsl:when>
      		<xsl:when test="$myparam.upper='ALE'"><xsl:value-of select="$myparam"/> (Pathology result)</xsl:when>
      		<xsl:when test="$myparam.upper='ALF'"><xsl:value-of select="$myparam"/> (Intervention description)</xsl:when>
      		<xsl:when test="$myparam.upper='ALG'"><xsl:value-of select="$myparam"/> (Summary of admittance)</xsl:when>
      		<xsl:when test="$myparam.upper='ALH'"><xsl:value-of select="$myparam"/> (Medical treatment course detail)</xsl:when>
      		<xsl:when test="$myparam.upper='ALI'"><xsl:value-of select="$myparam"/> (Prognosis)</xsl:when>
      		<xsl:when test="$myparam.upper='ALJ'"><xsl:value-of select="$myparam"/> (Instruction to patient)</xsl:when>
      		<xsl:when test="$myparam.upper='ALK'"><xsl:value-of select="$myparam"/> (Instruction to physician)</xsl:when>
      		<xsl:when test="$myparam.upper='ALL'"><xsl:value-of select="$myparam"/> (All documents)</xsl:when>
      		<xsl:when test="$myparam.upper='ALM'"><xsl:value-of select="$myparam"/> (Medicine treatment)</xsl:when>
      		<xsl:when test="$myparam.upper='ALN'"><xsl:value-of select="$myparam"/> (Medicine dosage and administration)</xsl:when>
      		<xsl:when test="$myparam.upper='ALO'"><xsl:value-of select="$myparam"/> (Availability of patient)</xsl:when>
      		<xsl:when test="$myparam.upper='ALP'"><xsl:value-of select="$myparam"/> (Reason for service request)</xsl:when>
      		<xsl:when test="$myparam.upper='ALQ'"><xsl:value-of select="$myparam"/> (Purpose of service)</xsl:when>
      		<xsl:when test="$myparam.upper='ARR'"><xsl:value-of select="$myparam"/> (Arrival conditions)</xsl:when>
      		<xsl:when test="$myparam.upper='ARS'"><xsl:value-of select="$myparam"/> (Service requester's comment)</xsl:when>
      		<xsl:when test="$myparam.upper='AUT'"><xsl:value-of select="$myparam"/> (Authentication)</xsl:when>
      		<xsl:when test="$myparam.upper='AUU'"><xsl:value-of select="$myparam"/> (Requested location description)</xsl:when>
      		<xsl:when test="$myparam.upper='AUV'"><xsl:value-of select="$myparam"/> (Medicine administration condition)</xsl:when>
      		<xsl:when test="$myparam.upper='AUW'"><xsl:value-of select="$myparam"/> (Patient information)</xsl:when>
      		<xsl:when test="$myparam.upper='AUX'"><xsl:value-of select="$myparam"/> (Precautionary measure)</xsl:when>
      		<xsl:when test="$myparam.upper='AUY'"><xsl:value-of select="$myparam"/> (Service characteristic)</xsl:when>
      		<xsl:when test="$myparam.upper='AUZ'"><xsl:value-of select="$myparam"/> (Planned event comment)</xsl:when>
      		<xsl:when test="$myparam.upper='AVA'"><xsl:value-of select="$myparam"/> (Expected delay comment)</xsl:when>
      		<xsl:when test="$myparam.upper='AVB'"><xsl:value-of select="$myparam"/> (Transport requirements comment)</xsl:when>
      		<xsl:when test="$myparam.upper='AVC'"><xsl:value-of select="$myparam"/> (Temporary approval condition)</xsl:when>
      		<xsl:when test="$myparam.upper='AVD'"><xsl:value-of select="$myparam"/> (Customs Valuation Information)</xsl:when>
      		<xsl:when test="$myparam.upper='AVE'"><xsl:value-of select="$myparam"/> (Value Added Tax (VAT) margin scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='AVF'"><xsl:value-of select="$myparam"/> (Maritime Declaration of Health)</xsl:when>
      		<xsl:when test="$myparam.upper='BAG'"><xsl:value-of select="$myparam"/> (Passenger baggage information)</xsl:when>
      		<xsl:when test="$myparam.upper='BAH'"><xsl:value-of select="$myparam"/> (Maritime Declaration of Health)</xsl:when>
      		<xsl:when test="$myparam.upper='BAI'"><xsl:value-of select="$myparam"/> (Additional product information address)</xsl:when>
      		<xsl:when test="$myparam.upper='BAJ'"><xsl:value-of select="$myparam"/> (Information to be printed on despatch advice)</xsl:when>
      		<xsl:when test="$myparam.upper='BAK'"><xsl:value-of select="$myparam"/> (Missing goods remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='BAL'"><xsl:value-of select="$myparam"/> (Non-acceptance information)</xsl:when>
      		<xsl:when test="$myparam.upper='BAM'"><xsl:value-of select="$myparam"/> (Returns information)</xsl:when>
      		<xsl:when test="$myparam.upper='BAN'"><xsl:value-of select="$myparam"/> (Sub-line item information)</xsl:when>
      		<xsl:when test="$myparam.upper='BAO'"><xsl:value-of select="$myparam"/> (Test information)</xsl:when>
      		<xsl:when test="$myparam.upper='BAP'"><xsl:value-of select="$myparam"/> (External link)</xsl:when>
      		<xsl:when test="$myparam.upper='BAQ'"><xsl:value-of select="$myparam"/> (VAT exemption reason)</xsl:when>
      		<xsl:when test="$myparam.upper='BAR'"><xsl:value-of select="$myparam"/> (Processing Instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='BAS'"><xsl:value-of select="$myparam"/> (Relay Instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='BLC'"><xsl:value-of select="$myparam"/> (Transport contract document clause)</xsl:when>
      		<xsl:when test="$myparam.upper='BLD'"><xsl:value-of select="$myparam"/> (Instruction to prepare the patient)</xsl:when>
      		<xsl:when test="$myparam.upper='BLE'"><xsl:value-of select="$myparam"/> (Medicine treatment comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLF'"><xsl:value-of select="$myparam"/> (Examination result comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLG'"><xsl:value-of select="$myparam"/> (Service request comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLH'"><xsl:value-of select="$myparam"/> (Prescription reason)</xsl:when>
      		<xsl:when test="$myparam.upper='BLI'"><xsl:value-of select="$myparam"/> (Prescription comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLJ'"><xsl:value-of select="$myparam"/> (Clinical investigation comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLK'"><xsl:value-of select="$myparam"/> (Medicinal specification comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLL'"><xsl:value-of select="$myparam"/> (Economic contribution comment)</xsl:when>
      		<xsl:when test="$myparam.upper='BLM'"><xsl:value-of select="$myparam"/> (Status of a plan)</xsl:when>
      		<xsl:when test="$myparam.upper='BLN'"><xsl:value-of select="$myparam"/> (Random sample test information)</xsl:when>
      		<xsl:when test="$myparam.upper='BLO'"><xsl:value-of select="$myparam"/> (Period of time)</xsl:when>
      		<xsl:when test="$myparam.upper='BLP'"><xsl:value-of select="$myparam"/> (Legislation)</xsl:when>
      		<xsl:when test="$myparam.upper='BLQ'"><xsl:value-of select="$myparam"/> (Security measures requested)</xsl:when>
      		<xsl:when test="$myparam.upper='BLR'"><xsl:value-of select="$myparam"/> (Transport contract document remark)</xsl:when>
      		<xsl:when test="$myparam.upper='BLS'"><xsl:value-of select="$myparam"/> (Previous port of call security information)</xsl:when>
      		<xsl:when test="$myparam.upper='BLT'"><xsl:value-of select="$myparam"/> (Security information)</xsl:when>
      		<xsl:when test="$myparam.upper='BLU'"><xsl:value-of select="$myparam"/> (Waste information)</xsl:when>
      		<xsl:when test="$myparam.upper='BLV'"><xsl:value-of select="$myparam"/> (B2C marketing information, short description)</xsl:when>
      		<xsl:when test="$myparam.upper='BLW'"><xsl:value-of select="$myparam"/> (B2B marketing information, long description)</xsl:when>
      		<xsl:when test="$myparam.upper='BLX'"><xsl:value-of select="$myparam"/> (B2C marketing information, long description)</xsl:when>
      		<xsl:when test="$myparam.upper='BLY'"><xsl:value-of select="$myparam"/> (Product ingredients)</xsl:when>
      		<xsl:when test="$myparam.upper='BLZ'"><xsl:value-of select="$myparam"/> (Location short name)</xsl:when>
      		<xsl:when test="$myparam.upper='BMA'"><xsl:value-of select="$myparam"/> (Packaging material information)</xsl:when>
      		<xsl:when test="$myparam.upper='BMB'"><xsl:value-of select="$myparam"/> (Filler material information)</xsl:when>
      		<xsl:when test="$myparam.upper='BMC'"><xsl:value-of select="$myparam"/> (Ship-to-ship activity information)</xsl:when>
      		<xsl:when test="$myparam.upper='BMD'"><xsl:value-of select="$myparam"/> (Package material description)</xsl:when>
      		<xsl:when test="$myparam.upper='BME'"><xsl:value-of select="$myparam"/> (Consumer level package marking)</xsl:when>
      		<xsl:when test="$myparam.upper='CCI'"><xsl:value-of select="$myparam"/> (Customs clearance instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='CEX'"><xsl:value-of select="$myparam"/> (Customs clearance instructions export)</xsl:when>
      		<xsl:when test="$myparam.upper='CHG'"><xsl:value-of select="$myparam"/> (Change information)</xsl:when>
      		<xsl:when test="$myparam.upper='CIP'"><xsl:value-of select="$myparam"/> (Customs clearance instruction import)</xsl:when>
      		<xsl:when test="$myparam.upper='CLP'"><xsl:value-of select="$myparam"/> (Clearance place requested)</xsl:when>
      		<xsl:when test="$myparam.upper='CLR'"><xsl:value-of select="$myparam"/> (Loading remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='COI'"><xsl:value-of select="$myparam"/> (Order information)</xsl:when>
      		<xsl:when test="$myparam.upper='CUR'"><xsl:value-of select="$myparam"/> (Customer remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='CUS'"><xsl:value-of select="$myparam"/> (Customs declaration information)</xsl:when>
      		<xsl:when test="$myparam.upper='DAR'"><xsl:value-of select="$myparam"/> (Damage remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='DCL'"><xsl:value-of select="$myparam"/> (Document issuer declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='DEL'"><xsl:value-of select="$myparam"/> (Delivery information)</xsl:when>
      		<xsl:when test="$myparam.upper='DIN'"><xsl:value-of select="$myparam"/> (Delivery instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='DOC'"><xsl:value-of select="$myparam"/> (Documentation instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='DUT'"><xsl:value-of select="$myparam"/> (Duty declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='EUR'"><xsl:value-of select="$myparam"/> (Effective used routing)</xsl:when>
      		<xsl:when test="$myparam.upper='FBC'"><xsl:value-of select="$myparam"/> (First block to be printed on the transport contract)</xsl:when>
      		<xsl:when test="$myparam.upper='GBL'"><xsl:value-of select="$myparam"/> (Government bill of lading information)</xsl:when>
      		<xsl:when test="$myparam.upper='GEN'"><xsl:value-of select="$myparam"/> (Entire transaction set)</xsl:when>
      		<xsl:when test="$myparam.upper='GS7'"><xsl:value-of select="$myparam"/> (Further information concerning GGVS par. 7)</xsl:when>
      		<xsl:when test="$myparam.upper='HAN'"><xsl:value-of select="$myparam"/> (Consignment handling instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='HAZ'"><xsl:value-of select="$myparam"/> (Hazard information)</xsl:when>
      		<xsl:when test="$myparam.upper='ICN'"><xsl:value-of select="$myparam"/> (Consignment information for consignee)</xsl:when>
      		<xsl:when test="$myparam.upper='IIN'"><xsl:value-of select="$myparam"/> (Insurance instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='IMI'"><xsl:value-of select="$myparam"/> (Invoice mailing instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='IND'"><xsl:value-of select="$myparam"/> (Commercial invoice item description)</xsl:when>
      		<xsl:when test="$myparam.upper='INS'"><xsl:value-of select="$myparam"/> (Insurance information)</xsl:when>
      		<xsl:when test="$myparam.upper='INV'"><xsl:value-of select="$myparam"/> (Invoice instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='IRP'"><xsl:value-of select="$myparam"/> (Information for railway purpose)</xsl:when>
      		<xsl:when test="$myparam.upper='ITR'"><xsl:value-of select="$myparam"/> (Inland transport details)</xsl:when>
      		<xsl:when test="$myparam.upper='ITS'"><xsl:value-of select="$myparam"/> (Testing instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='LAN'"><xsl:value-of select="$myparam"/> (Location Alias)</xsl:when>
      		<xsl:when test="$myparam.upper='LIN'"><xsl:value-of select="$myparam"/> (Line item)</xsl:when>
      		<xsl:when test="$myparam.upper='LOI'"><xsl:value-of select="$myparam"/> (Loading instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='MCO'"><xsl:value-of select="$myparam"/> (Miscellaneous charge order)</xsl:when>
      		<xsl:when test="$myparam.upper='MDH'"><xsl:value-of select="$myparam"/> (Maritime Declaration of Health)</xsl:when>
      		<xsl:when test="$myparam.upper='MKS'"><xsl:value-of select="$myparam"/> (Additional marks/numbers information)</xsl:when>
      		<xsl:when test="$myparam.upper='ORI'"><xsl:value-of select="$myparam"/> (Order instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='OSI'"><xsl:value-of select="$myparam"/> (Other service information)</xsl:when>
      		<xsl:when test="$myparam.upper='PAC'"><xsl:value-of select="$myparam"/> (Packing/marking information)</xsl:when>
      		<xsl:when test="$myparam.upper='PAI'"><xsl:value-of select="$myparam"/> (Payment instructions information)</xsl:when>
      		<xsl:when test="$myparam.upper='PAY'"><xsl:value-of select="$myparam"/> (Payables information)</xsl:when>
      		<xsl:when test="$myparam.upper='PKG'"><xsl:value-of select="$myparam"/> (Packaging information)</xsl:when>
      		<xsl:when test="$myparam.upper='PKT'"><xsl:value-of select="$myparam"/> (Packaging terms information)</xsl:when>
      		<xsl:when test="$myparam.upper='PMD'"><xsl:value-of select="$myparam"/> (Payment detail/remittance information)</xsl:when>
      		<xsl:when test="$myparam.upper='PMT'"><xsl:value-of select="$myparam"/> (Payment information)</xsl:when>
      		<xsl:when test="$myparam.upper='PRD'"><xsl:value-of select="$myparam"/> (Product information)</xsl:when>
      		<xsl:when test="$myparam.upper='PRF'"><xsl:value-of select="$myparam"/> (Price calculation formula)</xsl:when>
      		<xsl:when test="$myparam.upper='PRI'"><xsl:value-of select="$myparam"/> (Priority information)</xsl:when>
      		<xsl:when test="$myparam.upper='PUR'"><xsl:value-of select="$myparam"/> (Purchasing information)</xsl:when>
      		<xsl:when test="$myparam.upper='QIN'"><xsl:value-of select="$myparam"/> (Quarantine instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='QQD'"><xsl:value-of select="$myparam"/> (Quality demands/requirements)</xsl:when>
      		<xsl:when test="$myparam.upper='QUT'"><xsl:value-of select="$myparam"/> (Quotation instruction/information)</xsl:when>
      		<xsl:when test="$myparam.upper='RAH'"><xsl:value-of select="$myparam"/> (Risk and handling information)</xsl:when>
      		<xsl:when test="$myparam.upper='REG'"><xsl:value-of select="$myparam"/> (Regulatory information)</xsl:when>
      		<xsl:when test="$myparam.upper='RET'"><xsl:value-of select="$myparam"/> (Return to origin information)</xsl:when>
      		<xsl:when test="$myparam.upper='REV'"><xsl:value-of select="$myparam"/> (Receivables)</xsl:when>
      		<xsl:when test="$myparam.upper='RQR'"><xsl:value-of select="$myparam"/> (Consignment route)</xsl:when>
      		<xsl:when test="$myparam.upper='SAF'"><xsl:value-of select="$myparam"/> (Safety information)</xsl:when>
      		<xsl:when test="$myparam.upper='SIC'"><xsl:value-of select="$myparam"/> (Consignment documentary instruction)</xsl:when>
      		<xsl:when test="$myparam.upper='SIN'"><xsl:value-of select="$myparam"/> (Special instructions)</xsl:when>
      		<xsl:when test="$myparam.upper='SLR'"><xsl:value-of select="$myparam"/> (Ship line requested)</xsl:when>
      		<xsl:when test="$myparam.upper='SPA'"><xsl:value-of select="$myparam"/> (Special permission for transport, generally)</xsl:when>
      		<xsl:when test="$myparam.upper='SPG'"><xsl:value-of select="$myparam"/> (Special permission concerning the goods to be transported)</xsl:when>
      		<xsl:when test="$myparam.upper='SPH'"><xsl:value-of select="$myparam"/> (Special handling)</xsl:when>
      		<xsl:when test="$myparam.upper='SPP'"><xsl:value-of select="$myparam"/> (Special permission concerning package)</xsl:when>
      		<xsl:when test="$myparam.upper='SPT'"><xsl:value-of select="$myparam"/> (Special permission concerning transport means)</xsl:when>
      		<xsl:when test="$myparam.upper='SRN'"><xsl:value-of select="$myparam"/> (Subsidiary risk number (IATA/DGR))</xsl:when>
      		<xsl:when test="$myparam.upper='SSR'"><xsl:value-of select="$myparam"/> (Special service request)</xsl:when>
      		<xsl:when test="$myparam.upper='SUR'"><xsl:value-of select="$myparam"/> (Supplier remarks)</xsl:when>
      		<xsl:when test="$myparam.upper='TCA'"><xsl:value-of select="$myparam"/> (Consignment tariff)</xsl:when>
      		<xsl:when test="$myparam.upper='TDT'"><xsl:value-of select="$myparam"/> (Consignment transport)</xsl:when>
      		<xsl:when test="$myparam.upper='TRA'"><xsl:value-of select="$myparam"/> (Transportation information)</xsl:when>
      		<xsl:when test="$myparam.upper='TRR'"><xsl:value-of select="$myparam"/> (Requested tariff)</xsl:when>
      		<xsl:when test="$myparam.upper='TXD'"><xsl:value-of select="$myparam"/> (Tax declaration)</xsl:when>
      		<xsl:when test="$myparam.upper='WHI'"><xsl:value-of select="$myparam"/> (Warehouse instruction/information)</xsl:when>
      		<xsl:when test="$myparam.upper='ZZZ'"><xsl:value-of select="$myparam"/> (Mutually defined)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>