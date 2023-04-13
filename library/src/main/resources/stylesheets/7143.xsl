<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="code.UNTDID.7143">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='AA'"><xsl:value-of select="$myparam"/> (Product version number)</xsl:when>
      		<xsl:when test="$myparam.upper='AB'"><xsl:value-of select="$myparam"/> (Assembly)</xsl:when>
      		<xsl:when test="$myparam.upper='AC'"><xsl:value-of select="$myparam"/> (HIBC (Health Industry Bar Code))</xsl:when>
      		<xsl:when test="$myparam.upper='AD'"><xsl:value-of select="$myparam"/> (Cold roll number)</xsl:when>
      		<xsl:when test="$myparam.upper='AE'"><xsl:value-of select="$myparam"/> (Hot roll number)</xsl:when>
      		<xsl:when test="$myparam.upper='AF'"><xsl:value-of select="$myparam"/> (Slab number)</xsl:when>
      		<xsl:when test="$myparam.upper='AG'"><xsl:value-of select="$myparam"/> (Software revision number)</xsl:when>
      		<xsl:when test="$myparam.upper='AH'"><xsl:value-of select="$myparam"/> (UPC (Universal Product Code) Consumer package code (1-5-5))</xsl:when>
      		<xsl:when test="$myparam.upper='AI'"><xsl:value-of select="$myparam"/> (UPC (Universal Product Code) Consumer package code (1-5-5-1))</xsl:when>
      		<xsl:when test="$myparam.upper='AJ'"><xsl:value-of select="$myparam"/> (Sample number)</xsl:when>
      		<xsl:when test="$myparam.upper='AK'"><xsl:value-of select="$myparam"/> (Pack number)</xsl:when>
      		<xsl:when test="$myparam.upper='AL'"><xsl:value-of select="$myparam"/> (UPC (Universal Product Code) Shipping container code (1-2-5-5))</xsl:when>
      		<xsl:when test="$myparam.upper='AM'"><xsl:value-of select="$myparam"/> (UPC (Universal Product Code)/EAN (European article number) Shipping container code (1-2-5-5-1))</xsl:when>
      		<xsl:when test="$myparam.upper='AN'"><xsl:value-of select="$myparam"/> (UPC (Universal Product Code) suffix)</xsl:when>
      		<xsl:when test="$myparam.upper='AO'"><xsl:value-of select="$myparam"/> (State label code)</xsl:when>
      		<xsl:when test="$myparam.upper='AP'"><xsl:value-of select="$myparam"/> (Heat number)</xsl:when>
      		<xsl:when test="$myparam.upper='AQ'"><xsl:value-of select="$myparam"/> (Coupon number)</xsl:when>
      		<xsl:when test="$myparam.upper='AR'"><xsl:value-of select="$myparam"/> (Resource number)</xsl:when>
      		<xsl:when test="$myparam.upper='AS'"><xsl:value-of select="$myparam"/> (Work task number)</xsl:when>
      		<xsl:when test="$myparam.upper='AT'"><xsl:value-of select="$myparam"/> (Price look up number)</xsl:when>
      		<xsl:when test="$myparam.upper='AU'"><xsl:value-of select="$myparam"/> (NSN (North Atlantic Treaty Organization Stock Number))</xsl:when>
      		<xsl:when test="$myparam.upper='AV'"><xsl:value-of select="$myparam"/> (Refined product code)</xsl:when>
      		<xsl:when test="$myparam.upper='AW'"><xsl:value-of select="$myparam"/> (Exhibit)</xsl:when>
      		<xsl:when test="$myparam.upper='AX'"><xsl:value-of select="$myparam"/> (End item)</xsl:when>
      		<xsl:when test="$myparam.upper='AY'"><xsl:value-of select="$myparam"/> (Federal supply classification)</xsl:when>
      		<xsl:when test="$myparam.upper='AZ'"><xsl:value-of select="$myparam"/> (Engineering data list)</xsl:when>
      		<xsl:when test="$myparam.upper='BA'"><xsl:value-of select="$myparam"/> (Milestone event number)</xsl:when>
      		<xsl:when test="$myparam.upper='BB'"><xsl:value-of select="$myparam"/> (Lot number)</xsl:when>
      		<xsl:when test="$myparam.upper='BC'"><xsl:value-of select="$myparam"/> (National drug code 4-4-2 format)</xsl:when>
      		<xsl:when test="$myparam.upper='BD'"><xsl:value-of select="$myparam"/> (National drug code 5-3-2 format)</xsl:when>
      		<xsl:when test="$myparam.upper='BE'"><xsl:value-of select="$myparam"/> (National drug code 5-4-1 format)</xsl:when>
      		<xsl:when test="$myparam.upper='BF'"><xsl:value-of select="$myparam"/> (National drug code 5-4-2 format)</xsl:when>
      		<xsl:when test="$myparam.upper='BG'"><xsl:value-of select="$myparam"/> (National drug code)</xsl:when>
      		<xsl:when test="$myparam.upper='BH'"><xsl:value-of select="$myparam"/> (Part number)</xsl:when>
      		<xsl:when test="$myparam.upper='BI'"><xsl:value-of select="$myparam"/> (Local Stock Number (LSN))</xsl:when>
      		<xsl:when test="$myparam.upper='BJ'"><xsl:value-of select="$myparam"/> (Next higher assembly number)</xsl:when>
      		<xsl:when test="$myparam.upper='BK'"><xsl:value-of select="$myparam"/> (Data category)</xsl:when>
      		<xsl:when test="$myparam.upper='BL'"><xsl:value-of select="$myparam"/> (Control number)</xsl:when>
      		<xsl:when test="$myparam.upper='BM'"><xsl:value-of select="$myparam"/> (Special material identification code)</xsl:when>
      		<xsl:when test="$myparam.upper='BN'"><xsl:value-of select="$myparam"/> (Locally assigned control number)</xsl:when>
      		<xsl:when test="$myparam.upper='BO'"><xsl:value-of select="$myparam"/> (Buyer's colour)</xsl:when>
      		<xsl:when test="$myparam.upper='BP'"><xsl:value-of select="$myparam"/> (Buyer's part number)</xsl:when>
      		<xsl:when test="$myparam.upper='BQ'"><xsl:value-of select="$myparam"/> (Variable measure product code)</xsl:when>
      		<xsl:when test="$myparam.upper='BR'"><xsl:value-of select="$myparam"/> (Financial phase)</xsl:when>
      		<xsl:when test="$myparam.upper='BS'"><xsl:value-of select="$myparam"/> (Contract breakdown)</xsl:when>
      		<xsl:when test="$myparam.upper='BT'"><xsl:value-of select="$myparam"/> (Technical phase)</xsl:when>
      		<xsl:when test="$myparam.upper='BU'"><xsl:value-of select="$myparam"/> (Dye lot number)</xsl:when>
      		<xsl:when test="$myparam.upper='BV'"><xsl:value-of select="$myparam"/> (Daily statement of activities)</xsl:when>
      		<xsl:when test="$myparam.upper='BW'"><xsl:value-of select="$myparam"/> (Periodical statement of activities within a bilaterally agreed time period)</xsl:when>
      		<xsl:when test="$myparam.upper='BX'"><xsl:value-of select="$myparam"/> (Calendar week statement of activities)</xsl:when>
      		<xsl:when test="$myparam.upper='BY'"><xsl:value-of select="$myparam"/> (Calendar month statement of activities)</xsl:when>
      		<xsl:when test="$myparam.upper='BZ'"><xsl:value-of select="$myparam"/> (Original equipment number)</xsl:when>
      		<xsl:when test="$myparam.upper='CC'"><xsl:value-of select="$myparam"/> (Industry commodity code)</xsl:when>
      		<xsl:when test="$myparam.upper='CG'"><xsl:value-of select="$myparam"/> (Commodity grouping)</xsl:when>
      		<xsl:when test="$myparam.upper='CL'"><xsl:value-of select="$myparam"/> (Colour number)</xsl:when>
      		<xsl:when test="$myparam.upper='CR'"><xsl:value-of select="$myparam"/> (Contract number)</xsl:when>
      		<xsl:when test="$myparam.upper='CV'"><xsl:value-of select="$myparam"/> (Customs article number)</xsl:when>
      		<xsl:when test="$myparam.upper='DR'"><xsl:value-of select="$myparam"/> (Drawing revision number)</xsl:when>
      		<xsl:when test="$myparam.upper='DW'"><xsl:value-of select="$myparam"/> (Drawing)</xsl:when>
      		<xsl:when test="$myparam.upper='EC'"><xsl:value-of select="$myparam"/> (Engineering change level)</xsl:when>
      		<xsl:when test="$myparam.upper='EF'"><xsl:value-of select="$myparam"/> (Material code)</xsl:when>
      		<xsl:when test="$myparam.upper='EN'"><xsl:value-of select="$myparam"/> (International Article Numbering Association (EAN))</xsl:when>
      		<xsl:when test="$myparam.upper='FS'"><xsl:value-of select="$myparam"/> (Fish species)</xsl:when>
      		<xsl:when test="$myparam.upper='GB'"><xsl:value-of select="$myparam"/> (Buyer's internal product group code)</xsl:when>
      		<xsl:when test="$myparam.upper='GN'"><xsl:value-of select="$myparam"/> (National product group code)</xsl:when>
      		<xsl:when test="$myparam.upper='GS'"><xsl:value-of select="$myparam"/> (General specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='HS'"><xsl:value-of select="$myparam"/> (Harmonised system)</xsl:when>
      		<xsl:when test="$myparam.upper='IB'"><xsl:value-of select="$myparam"/> (ISBN (International Standard Book Number))</xsl:when>
      		<xsl:when test="$myparam.upper='IN'"><xsl:value-of select="$myparam"/> (Buyer's item number)</xsl:when>
      		<xsl:when test="$myparam.upper='IS'"><xsl:value-of select="$myparam"/> (ISSN (International Standard Serial Number))</xsl:when>
      		<xsl:when test="$myparam.upper='IT'"><xsl:value-of select="$myparam"/> (Buyer's style number)</xsl:when>
      		<xsl:when test="$myparam.upper='IZ'"><xsl:value-of select="$myparam"/> (Buyer's size code)</xsl:when>
      		<xsl:when test="$myparam.upper='MA'"><xsl:value-of select="$myparam"/> (Machine number)</xsl:when>
      		<xsl:when test="$myparam.upper='MF'"><xsl:value-of select="$myparam"/> (Manufacturer's (producer's) article number)</xsl:when>
      		<xsl:when test="$myparam.upper='MN'"><xsl:value-of select="$myparam"/> (Model number)</xsl:when>
      		<xsl:when test="$myparam.upper='MP'"><xsl:value-of select="$myparam"/> (Product/service identification number)</xsl:when>
      		<xsl:when test="$myparam.upper='NB'"><xsl:value-of select="$myparam"/> (Batch number)</xsl:when>
      		<xsl:when test="$myparam.upper='ON'"><xsl:value-of select="$myparam"/> (Customer order number)</xsl:when>
      		<xsl:when test="$myparam.upper='PD'"><xsl:value-of select="$myparam"/> (Part number description)</xsl:when>
      		<xsl:when test="$myparam.upper='PL'"><xsl:value-of select="$myparam"/> (Purchaser's order line number)</xsl:when>
      		<xsl:when test="$myparam.upper='PO'"><xsl:value-of select="$myparam"/> (Purchase order number)</xsl:when>
      		<xsl:when test="$myparam.upper='PV'"><xsl:value-of select="$myparam"/> (Promotional variant number)</xsl:when>
      		<xsl:when test="$myparam.upper='QS'"><xsl:value-of select="$myparam"/> (Buyer's qualifier for size)</xsl:when>
      		<xsl:when test="$myparam.upper='RC'"><xsl:value-of select="$myparam"/> (Returnable container number)</xsl:when>
      		<xsl:when test="$myparam.upper='RN'"><xsl:value-of select="$myparam"/> (Release number)</xsl:when>
      		<xsl:when test="$myparam.upper='RU'"><xsl:value-of select="$myparam"/> (Run number)</xsl:when>
      		<xsl:when test="$myparam.upper='RY'"><xsl:value-of select="$myparam"/> (Record keeping of model year)</xsl:when>
      		<xsl:when test="$myparam.upper='SA'"><xsl:value-of select="$myparam"/> (Supplier's article number)</xsl:when>
      		<xsl:when test="$myparam.upper='SG'"><xsl:value-of select="$myparam"/> (Standard group of products (mixed assortment))</xsl:when>
      		<xsl:when test="$myparam.upper='SK'"><xsl:value-of select="$myparam"/> (SKU (Stock keeping unit))</xsl:when>
      		<xsl:when test="$myparam.upper='SN'"><xsl:value-of select="$myparam"/> (Serial number)</xsl:when>
      		<xsl:when test="$myparam.upper='SRS'"><xsl:value-of select="$myparam"/> (RSK number)</xsl:when>
      		<xsl:when test="$myparam.upper='SRT'"><xsl:value-of select="$myparam"/> (IFLS (Institut Francais du Libre Service) 5 digit product classification code)</xsl:when>
      		<xsl:when test="$myparam.upper='SRU'"><xsl:value-of select="$myparam"/> (IFLS (Institut Francais du Libre Service) 9 digit product classification code)</xsl:when>
      		<xsl:when test="$myparam.upper='SRV'"><xsl:value-of select="$myparam"/> (GS1 Global Trade Item Number)</xsl:when>
      		<xsl:when test="$myparam.upper='SRW'"><xsl:value-of select="$myparam"/> (EDIS (Energy Data Identification System))</xsl:when>
      		<xsl:when test="$myparam.upper='SRX'"><xsl:value-of select="$myparam"/> (Slaughter number)</xsl:when>
      		<xsl:when test="$myparam.upper='SRY'"><xsl:value-of select="$myparam"/> (Official animal number)</xsl:when>
      		<xsl:when test="$myparam.upper='SRZ'"><xsl:value-of select="$myparam"/> (Harmonized tariff schedule)</xsl:when>
      		<xsl:when test="$myparam.upper='SS'"><xsl:value-of select="$myparam"/> (Supplier's supplier article number)</xsl:when>
      		<xsl:when test="$myparam.upper='SSA'"><xsl:value-of select="$myparam"/> (46 Level DOT Code)</xsl:when>
      		<xsl:when test="$myparam.upper='SSB'"><xsl:value-of select="$myparam"/> (Airline Tariff 6D)</xsl:when>
      		<xsl:when test="$myparam.upper='SSC'"><xsl:value-of select="$myparam"/> (Title 49 Code of Federal Regulations)</xsl:when>
      		<xsl:when test="$myparam.upper='SSD'"><xsl:value-of select="$myparam"/> (International Civil Aviation Administration code)</xsl:when>
      		<xsl:when test="$myparam.upper='SSE'"><xsl:value-of select="$myparam"/> (Hazardous Materials ID DOT)</xsl:when>
      		<xsl:when test="$myparam.upper='SSF'"><xsl:value-of select="$myparam"/> (Endorsement)</xsl:when>
      		<xsl:when test="$myparam.upper='SSG'"><xsl:value-of select="$myparam"/> (Air Force Regulation 71-4)</xsl:when>
      		<xsl:when test="$myparam.upper='SSH'"><xsl:value-of select="$myparam"/> (Breed)</xsl:when>
      		<xsl:when test="$myparam.upper='SSI'"><xsl:value-of select="$myparam"/> (Chemical Abstract Service (CAS) registry number)</xsl:when>
      		<xsl:when test="$myparam.upper='SSJ'"><xsl:value-of select="$myparam"/> (Engine model designation)</xsl:when>
      		<xsl:when test="$myparam.upper='SSK'"><xsl:value-of select="$myparam"/> (Institutional Meat Purchase Specifications (IMPS) Number)</xsl:when>
      		<xsl:when test="$myparam.upper='SSL'"><xsl:value-of select="$myparam"/> (Price Look-Up code (PLU))</xsl:when>
      		<xsl:when test="$myparam.upper='SSM'"><xsl:value-of select="$myparam"/> (International Maritime Organization (IMO) Code)</xsl:when>
      		<xsl:when test="$myparam.upper='SSN'"><xsl:value-of select="$myparam"/> (Bureau of Explosives 600-A (rail))</xsl:when>
      		<xsl:when test="$myparam.upper='SSO'"><xsl:value-of select="$myparam"/> (United Nations Dangerous Goods List)</xsl:when>
      		<xsl:when test="$myparam.upper='SSP'"><xsl:value-of select="$myparam"/> (International Code of Botanical Nomenclature (ICBN))</xsl:when>
      		<xsl:when test="$myparam.upper='SSQ'"><xsl:value-of select="$myparam"/> (International Code of Zoological Nomenclature (ICZN))</xsl:when>
      		<xsl:when test="$myparam.upper='SSR'"><xsl:value-of select="$myparam"/> (International Code of Nomenclature for Cultivated Plants (ICNCP))</xsl:when>
      		<xsl:when test="$myparam.upper='SSS'"><xsl:value-of select="$myparam"/> (Distributor’s article identifier)</xsl:when>
      		<xsl:when test="$myparam.upper='SST'"><xsl:value-of select="$myparam"/> (Norwegian Classification system ENVA)</xsl:when>
      		<xsl:when test="$myparam.upper='SSU'"><xsl:value-of select="$myparam"/> (Supplier assigned classification)</xsl:when>
      		<xsl:when test="$myparam.upper='SSV'"><xsl:value-of select="$myparam"/> (Mexican classification system AMECE)</xsl:when>
      		<xsl:when test="$myparam.upper='SSW'"><xsl:value-of select="$myparam"/> (German classification system CCG)</xsl:when>
      		<xsl:when test="$myparam.upper='SSX'"><xsl:value-of select="$myparam"/> (Finnish classification system EANFIN)</xsl:when>
      		<xsl:when test="$myparam.upper='SSY'"><xsl:value-of select="$myparam"/> (Canadian classification system ICC)</xsl:when>
      		<xsl:when test="$myparam.upper='SSZ'"><xsl:value-of select="$myparam"/> (French classification system IFLS5)</xsl:when>
      		<xsl:when test="$myparam.upper='ST'"><xsl:value-of select="$myparam"/> (Style number)</xsl:when>
      		<xsl:when test="$myparam.upper='STA'"><xsl:value-of select="$myparam"/> (Dutch classification system CBL)</xsl:when>
      		<xsl:when test="$myparam.upper='STB'"><xsl:value-of select="$myparam"/> (Japanese classification system JICFS)</xsl:when>
      		<xsl:when test="$myparam.upper='STC'"><xsl:value-of select="$myparam"/> (European Union dairy subsidy eligibility classification)</xsl:when>
      		<xsl:when test="$myparam.upper='STD'"><xsl:value-of select="$myparam"/> (GS1 Spain classification system)</xsl:when>
      		<xsl:when test="$myparam.upper='STE'"><xsl:value-of select="$myparam"/> (GS1 Poland classification system)</xsl:when>
      		<xsl:when test="$myparam.upper='STF'"><xsl:value-of select="$myparam"/> (Federal Agency on Technical Regulating and Metrology of the Russian Federation)</xsl:when>
      		<xsl:when test="$myparam.upper='STG'"><xsl:value-of select="$myparam"/> (Efficient Consumer Response (ECR) Austria classification system)</xsl:when>
      		<xsl:when test="$myparam.upper='STH'"><xsl:value-of select="$myparam"/> (GS1 Italy classification system)</xsl:when>
      		<xsl:when test="$myparam.upper='STI'"><xsl:value-of select="$myparam"/> (CPV (Common Procurement Vocabulary))</xsl:when>
      		<xsl:when test="$myparam.upper='STJ'"><xsl:value-of select="$myparam"/> (IFDA (International Foodservice Distributors Association))</xsl:when>
      		<xsl:when test="$myparam.upper='STK'"><xsl:value-of select="$myparam"/> (AHFS (American Hospital Formulary Service) pharmacologic - therapeutic classification)</xsl:when>
      		<xsl:when test="$myparam.upper='STL'"><xsl:value-of select="$myparam"/> (ATC (Anatomical Therapeutic Chemical) classification system)</xsl:when>
      		<xsl:when test="$myparam.upper='STM'"><xsl:value-of select="$myparam"/> (CLADIMED (Classification des Dispositifs Médicaux))</xsl:when>
      		<xsl:when test="$myparam.upper='STN'"><xsl:value-of select="$myparam"/> (CMDR (Canadian Medical Device Regulations) classification system)</xsl:when>
      		<xsl:when test="$myparam.upper='STO'"><xsl:value-of select="$myparam"/> (CNDM (Classificazione Nazionale dei Dispositivi Medici))</xsl:when>
      		<xsl:when test="$myparam.upper='STP'"><xsl:value-of select="$myparam"/> (UK DM&amp;D (Dictionary of Medicines &amp; Devices) standard coding scheme)</xsl:when>
      		<xsl:when test="$myparam.upper='STQ'"><xsl:value-of select="$myparam"/> (eCl@ss)</xsl:when>
      		<xsl:when test="$myparam.upper='STR'"><xsl:value-of select="$myparam"/> (EDMA (European Diagnostic Manufacturers Association) Products Classification)</xsl:when>
      		<xsl:when test="$myparam.upper='STS'"><xsl:value-of select="$myparam"/> (EGAR (European Generic Article Register))</xsl:when>
      		<xsl:when test="$myparam.upper='STT'"><xsl:value-of select="$myparam"/> (GMDN (Global Medical Devices Nomenclature))</xsl:when>
      		<xsl:when test="$myparam.upper='STU'"><xsl:value-of select="$myparam"/> (GPI (Generic Product Identifier))</xsl:when>
      		<xsl:when test="$myparam.upper='STV'"><xsl:value-of select="$myparam"/> (HCPCS (Healthcare Common Procedure Coding System))</xsl:when>
      		<xsl:when test="$myparam.upper='STW'"><xsl:value-of select="$myparam"/> (ICPS (International Classification for Patient Safety))</xsl:when>
      		<xsl:when test="$myparam.upper='STX'"><xsl:value-of select="$myparam"/> (MedDRA (Medical Dictionary for Regulatory Activities))</xsl:when>
      		<xsl:when test="$myparam.upper='STY'"><xsl:value-of select="$myparam"/> (Medical Columbus)</xsl:when>
      		<xsl:when test="$myparam.upper='STZ'"><xsl:value-of select="$myparam"/> (NAPCS (North American Product Classification System))</xsl:when>
      		<xsl:when test="$myparam.upper='SUA'"><xsl:value-of select="$myparam"/> (NHS (National Health Services) eClass)</xsl:when>
      		<xsl:when test="$myparam.upper='SUB'"><xsl:value-of select="$myparam"/> (US FDA (Food and Drug Administration) Product Code Classification Database)</xsl:when>
      		<xsl:when test="$myparam.upper='SUC'"><xsl:value-of select="$myparam"/> (SNOMED CT (Systematized Nomenclature of Medicine-Clinical Terms))</xsl:when>
      		<xsl:when test="$myparam.upper='SUD'"><xsl:value-of select="$myparam"/> (UMDNS (Universal Medical Device Nomenclature System))</xsl:when>
      		<xsl:when test="$myparam.upper='SUE'"><xsl:value-of select="$myparam"/> (GS1 Global Returnable Asset Identifier, non-serialised)</xsl:when>
      		<xsl:when test="$myparam.upper='SUF'"><xsl:value-of select="$myparam"/> (IMEI)</xsl:when>
      		<xsl:when test="$myparam.upper='SUG'"><xsl:value-of select="$myparam"/> (Waste Type (EMSA))</xsl:when>
      		<xsl:when test="$myparam.upper='SUH'"><xsl:value-of select="$myparam"/> (Ship's store classification type)</xsl:when>
      		<xsl:when test="$myparam.upper='SUI'"><xsl:value-of select="$myparam"/> (Emergency fire code)</xsl:when>
      		<xsl:when test="$myparam.upper='SUJ'"><xsl:value-of select="$myparam"/> (Emergency spillage code)</xsl:when>
      		<xsl:when test="$myparam.upper='SUK'"><xsl:value-of select="$myparam"/> (IMDG packing group)</xsl:when>
      		<xsl:when test="$myparam.upper='SUL'"><xsl:value-of select="$myparam"/> (MARPOL Code IBC)</xsl:when>
      		<xsl:when test="$myparam.upper='SUM'"><xsl:value-of select="$myparam"/> (IMDG subsidiary risk class)</xsl:when>
      		<xsl:when test="$myparam.upper='TG'"><xsl:value-of select="$myparam"/> (Transport group number)</xsl:when>
      		<xsl:when test="$myparam.upper='TSN'"><xsl:value-of select="$myparam"/> (Taxonomic Serial Number)</xsl:when>
      		<xsl:when test="$myparam.upper='TSO'"><xsl:value-of select="$myparam"/> (IMDG main hazard class)</xsl:when>
      		<xsl:when test="$myparam.upper='TSP'"><xsl:value-of select="$myparam"/> (EU Combined Nomenclature)</xsl:when>
      		<xsl:when test="$myparam.upper='TSQ'"><xsl:value-of select="$myparam"/> (Therapeutic classification number)</xsl:when>
      		<xsl:when test="$myparam.upper='TSR'"><xsl:value-of select="$myparam"/> (European Waste Catalogue)</xsl:when>
      		<xsl:when test="$myparam.upper='TSS'"><xsl:value-of select="$myparam"/> (Price grouping code)</xsl:when>
      		<xsl:when test="$myparam.upper='TST'"><xsl:value-of select="$myparam"/> (UNSPSC)</xsl:when>
      		<xsl:when test="$myparam.upper='UA'"><xsl:value-of select="$myparam"/> (Ultimate customer's article number)</xsl:when>
      		<xsl:when test="$myparam.upper='UP'"><xsl:value-of select="$myparam"/> (UPC (Universal product code))</xsl:when>
      		<xsl:when test="$myparam.upper='VN'"><xsl:value-of select="$myparam"/> (Vendor item number)</xsl:when>
      		<xsl:when test="$myparam.upper='VP'"><xsl:value-of select="$myparam"/> (Vendor's (seller's) part number)</xsl:when>
      		<xsl:when test="$myparam.upper='VS'"><xsl:value-of select="$myparam"/> (Vendor's supplemental item number)</xsl:when>
      		<xsl:when test="$myparam.upper='VX'"><xsl:value-of select="$myparam"/> (Vendor specification number)</xsl:when>
      		<xsl:when test="$myparam.upper='ZZZ'"><xsl:value-of select="$myparam"/> (Mutually defined)</xsl:when>
   			<xsl:otherwise><xsl:value-of select="$myparam"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>